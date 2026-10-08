# gopls 在字节大仓吃满 48G 内存的排查全记录

**Date**: 2026-09-22
**Tags**: #gopls #golang #memory #lazyvim #lsp #bytedance #trae-gopls #rgo

## 🎯 One-Line Summary

`cashier_core`（overpass/kitex 生成代码大仓）上 gopls + golangci-lint 合计吃满 48G 物理内存，
最终靠**换内场定制版 trae-gopls + 关掉 golangci-lint + 修正 GOGC 配置**降到 16G，
而中途花了大半程折腾的 gopls 调参和 RGO 方案，全是弯路。

---

## 最终改动

`lua/plugins/lsp.lua` 相对原状只有两处：

```lua
local trae_gopls = vim.fn.exepath("trae-gopls")

-- 1. gopls 换成内场定制版
gopls = {
  cmd = trae_gopls ~= "" and { trae_gopls } or nil,
  cmd_env = trae_gopls ~= "" and { GOMEMLIMIT = "20GiB" } or nil,
  -- settings 保持原样，什么都不用调
},

-- 2. 关掉 go 的 golangci-lint
{
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.go = {}
    return opts
  end,
},
```

装 trae-gopls：

```bash
curl -fsSL https://tosv-myabc.byted.org/obj/trae-common-2-asiasebd/trae-gopls/install_all_platforms.sh | bash
# macOS 实际走 homebrew，升级同命令，或 brew reinstall flow/trae-gopls/trae-gopls
```

---

## 1. 真凶不止一个：先看进程列表

### 🔴 The Problem

只盯着 gopls 调了半天参数，内存还是爆。直到打开活动监视器截图：

```
gopls            28.61 GB
golangci-lint    19.48 GB     ← 这货哪来的？
                 -------
                 48.09 GB  ≈ 物理内存
```

### 💡 The Insight

`golangci-lint` 是 **LazyVim `lang.go` extra 自带的**，一直都在：

```lua
-- lazyvim/plugins/extras/lang/go.lua
{ "mfussenegger/nvim-lint", opts = { linters_by_ft = { go = { "golangcilint" } } } }
```

触发点是 `BufWritePost` / `BufReadPost` / `InsertLeave`——**打开文件就跑一次**。
项目没有 `.golangci.yml` 时走默认 linter 集，其中 `unused` 是**全程序分析**，
等于在第二个进程里把 gopls 刚做完的加载 + 类型检查原样重做一遍。

更阴的是它为什么"突然出现"：之前 gopls 不设限地冲到 48G 把内存吃干净，
golangci-lint 一起来就分配不到内存被系统干掉，**根本活不到能被看见**。
加了 `GOMEMLIMIT` 把 gopls 摁在 28.6G 之后，正好腾出 19G，它才第一次活下来。

> **经验**：内存爆了先看**完整进程列表**，别预设只有一个嫌疑人。
> 给嫌疑人加限制可能只是把资源让给了另一个你还不知道的进程。

---

## 2. `GOGC=off` + `GOMEMLIMIT` = 上限即稳态

### 🔴 The Problem

配了这两行之后，gopls 稳定吃满 30GB，一点不降：

```lua
GOMEMLIMIT = "30GiB",
GOGC = "off",        -- 本意：空闲时 CPU 归零
```

### 💡 The Insight

`GOGC=off` 关掉了按比例触发 GC 的机制，此时 **`GOMEMLIMIT` 成了唯一的 GC 触发条件**。
推论是：堆会一路长到逼近 30GiB 才第一次回收，**跟实际活跃数据有多少完全无关**。

看到的 30GB 不是 gopls 需要 30GB，是配置逼它长到 30GB 才 GC。

这个错误还有更坏的副作用：**它让之前所有的内存测量全部失真**。
中途做的"RGO 开/关"A/B 对比，两边都会顶到 30GB，测了等于没测。

### 🛠️ 正确的心智模型

`GOGC` 和 `GOMEMLIMIT` 是**两个独立的 GC 触发条件，谁先到算谁**：

| 旋钮 | 管什么 | 什么时候调 |
|---|---|---|
| `GOGC`（默认 100） | 堆长到活跃集的 2 倍就 GC | **想压内存调这个** |
| `GOMEMLIMIT` | 逼近上限就 GC | 纯安全阀，防跑飞 |

判断哪个在绑定，**看 CPU 不看内存**：

- 索引跑完 CPU 回落到接近 0 → GOGC 在管事，limit 没绑定，调高 limit 毫无意义
- 索引跑完 CPU 持续几十上百 % 不降 → limit 在绑定，GC 被逼着反复跑，该调高 limit

要实锤就挂 `GODEBUG=gctrace=1`，日志进 `:LspLog`，看每行末尾的 `goal`。

> **经验**：`GOGC=off` 不是"省 CPU"，是"把上限变成稳态"。
> 只有在活跃集本来就逼近上限、调低 GOGC 会导致 GC 死循环时，才是不得已的选择。

---

## 3. 根治：trae-gopls

### 🔴 The Problem

`cashier_core` 的体量：

```
代码里 import 的 overpass 模块           61 个
这 61 个模块的 Go 源码                   2.41 GB
modcache 里 overpass 总量（含多版本）     9.1 GB
kitex_gen/models/v1/payment/ttypes.go   201,860 行 / 5.9 MB（单文件）
```

官方 gopls 的设计文档把 `Low memory environments` 明确列为 **Non-Goal**，
它会 parse 全量代码、type check 后常驻内存。在这种生成代码占大头的仓库上必然爆。

### 💡 The Insight

内场有个定制版 `trae-gopls`（基于 upstream v0.21.1），四个优化正好对着痛点：

| 它做的 | 对应的土办法 | 差距 |
|---|---|---|
| 生成代码**跳过 func body**，剔除 `ReadFieldN`/`WriteFieldN`/未导出方法符号 | `semanticTokens = false` | 土办法只是不渲染，它是根本不 parse |
| 静态分析默认只覆盖 **workspace + 标准库** | 手工把 12 个 `analyses` 设 false | 土办法关的是 analyzer 开关，inspector 照样 walk 全量 AST |
| 文件内容初始化后**可被 GC** | 无 | 某 monorepo 实测 7G → 200M |
| Tango beast 模式编译 | 无 | 再省 500M-1.5G |

实测：**30GB → 16GB**，主观"丝滑很多"。换上之后，之前手工调的
`analyses` / `hints` / `codelenses` / `completeUnimported` / `semanticTokens`
**全部回退，一个都不需要**——`completeUnimported` 和 inlay hints 还顺带拿回来了。

### ⚠️ 代价

- **生成代码的 func body 内部 `gd` 跳不了**（body 没被解析），`gr`（references）不受影响
- 但 **type 声明全部保留**。以 `ttypes.go` 为例：

```
type 声明               514      ← 保留，日常 gd 的目标就是这些
func/method           16,878
  ├ ReadFieldN/WriteFieldN   3,999   ← 符号被剔除
  ├ 未导出方法                4,112   ← 符号被剔除
  └ 其余导出方法              8,767   ← 签名保留，body 置空
```

所以 `gd` 到 `payment.QueryElementResp` 这种 struct 是正常的，
断的只是"光标停在生成代码 func body 里面"的场景。文件内容本身没变，
nvim 显示的还是磁盘真实文本，treesitter 高亮照常。

---

## 🚧 走过的弯路

记下来是为了以后别再走一遍。

### 弯路一：手工调 gopls settings

关掉 `staticcheck` + 12 个 `analyses` + 8 个 `codelenses` + 7 个 `hints`、
`completeUnimported = false`、`symbolScope = "workspace"`、`diagnosticsDelay = "2s"`……

**结果**：内存没下来，日常体验（自动导入补全、inlay hints）全丢了。
这些开关关的是"要不要跑分析"，但 AST 该 parse 还是 parse，该常驻还是常驻。
**治标不治本，而且代价是天天都在付。**

### 弯路二：RGO 本地注入

RGO 是内场的编译期/编辑期代码注入方案，用 **go.work + 部分 go mod replace**
把 overpass 依赖换成本地生成的精简代码（frugal + thrift 桥接，代码量降到 20%，
开 `auto_trimmer` 能到 5-10%）。

**实测确实有效**：

```
rgo generate                              8.9s
同样 10 个模块的 Go 源码   796 MB → 154 MB   (-81%)
```

**但不够，而且有副作用**：

1. `go.work` 的 `use` 会把这些模块提升成 **workspace 模块**，gopls 对 workspace 模块是
   **全量加载所有包**的（实测 +633 个包），而 modcache 模式下只加载真正被 import 的那部分。
   源码字节数 -642MB，全量加载的包数 +633，**净效果方向相反**。
2. RGO 默认拉 IDL 仓库 **master 最新 commit**，而 go.mod 是钉死的。
   只在本地扩配置不提交，就会变成"本地看 master 最新 IDL、CI 看两个月前的 pin"，
   写出来的代码本地过 CI 挂，报错还在依赖里。
3. `cashier_core` 的 `rgo_config.yaml` 只配了 10 个 PSM（代码里 import 了 61 个），
   `rgo` 只在 `build.sh` 的 SCM 流程里跑，本地压根没装——**"配了但没生效"**。

trae 团队自己在文档里说了：RGO 是他们**之前**给出的缓解方案，
"部分仓库即便使用 rgo 仍然无法将内存降到可用程度"。

**最终 `rgo generate_clean -rm` 清干净了。**

> **经验**：缓解方案和根治方案要分清。RGO 砍的是"生成代码的体积"，
> trae-gopls 砍的是"要不要解析生成代码"——后者更靠近问题本身。

### 弯路三：在失真的测量上做 A/B

带着 `GOGC=off` 做 "go.work 开/关" 对比，两边都顶在 30GB。
花了时间，得到零信息。

> **经验**：做 A/B 之前先确认**测量本身是可信的**。
> RSS 不等于 live heap——RSS 包含 GC 后还没还给 OS 的部分。
> 要真实活跃集用 pprof 并强制 GC：
> ```bash
> # cmd = { "gopls", "-debug=localhost:6060" }
> go tool pprof -top "http://localhost:6060/debug/pprof/heap?gc=1"
> ```

---

## 🧰 踩到的小坑

### `go install` 内场模块报 404

```
verifying module: ... sumdb/sum.golang.org/lookup/code.byted.org/...: 404 Not Found
server response: ... dial tcp: lookup code.byted.org on 8.8.8.8:53: no such host
```

`GOPROXY` 配了内网 proxy，但 `GOSUMDB` 还是默认的 `sum.golang.org`，
于是去公网查校验和 → 404 → 退回 direct 拉取 → DNS 解析不了。

```bash
go env -w GONOSUMDB=code.byted.org
```

⚠️ **别用常见的 `GOPRIVATE=code.byted.org`**——它会连带置上 `GONOPROXY`，
让 go 绕过内网 proxy 直连 `code.byted.org`，正好撞上 DNS 解析不了的问题。

另外 `GONOSUMCHECK` 是老版本遗留，go 会直接报 `unknown go command variable`。

### `go env -w` vs zshrc

`go env -w` 写进 `~/Library/Application Support/go/env`，**对所有进程生效**，
包括 GUI 启动的 Neovim 拉起的 gopls。zshrc 的 `export` 只对交互式 shell 及其子进程生效——
从 Neovide / Raycast / `.app` 启动 nvim 就没了。

Go 工具链相关的环境变量建议放 go env 文件，别放 zshrc。

### LazyVim 的 `tbl_deep_extend` 盖不掉列表

想关掉某个 filetype 的 linter，**写空表没用**：

```lua
-- ❌ 无效：LazyVim 走 vim.tbl_deep_extend("force")，
--    空表没有任何键，合并后上游的 { "golangcilint" } 原封不动
opts = { linters_by_ft = { go = {} } }

-- ✅ 用函数形式显式赋值
opts = function(_, opts)
  opts.linters_by_ft.go = {}
  return opts
end,
```

同类问题在所有"用 opts 表覆盖上游列表"的场景都存在。

### 上游默认配置要去读源码

`golangci-lint` 从哪来的、`staticcheck` 默认开不开、`semanticTokens` 默认值是什么——
这些都在 `~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/lang/go.lua` 里写着。
**猜不如读**。

---

## 📊 数据速查

| 指标 | 数值 |
|---|---|
| 物理内存 | 48 GB |
| 爆内存时：gopls / golangci-lint | 28.61 GB / 19.48 GB |
| 换 trae-gopls 后 | 16 GB（`GOMEMLIMIT=20GiB`，GOGC 默认，未绑定） |
| import 的 overpass 模块数 / 源码量 | 61 个 / 2.41 GB |
| modcache 里 overpass 总量 | 9.1 GB |
| 最大单文件 | `kitex_gen/models/v1/payment/ttypes.go` 201,860 行 / 5.9 MB |
| RGO 生成代码压缩比（同 10 个模块） | 796 MB → 154 MB |
| `rgo generate` 耗时（10 个 PSM，冷启动） | 8.9 s |
| go.work 引入的 workspace 包数 | +633 |

---

## 🔗 参考

- [TRAE gopls 优化版说明](https://bytedance.larkoffice.com/wiki/RvEAwHc22i7L94kSCEZcn6dhnyd) — 装法、配置、FAQ、已知问题
- [技术分享｜TRAE-Gopls 优化思路 & 原理](https://bytedance.larkoffice.com/wiki/L2lUwTnsVinq7EkflhDcwaGInff) — 为什么 gopls 会吃这么多内存
- [RGO 用户文档](https://bytedance.larkoffice.com/wiki/D8DswxnHwigibTkui8icgqplnKi) — 编译期/编辑期注入生成代码
- [Gopls: Design](https://tip.golang.org/gopls/design/design) — `Low memory environments` 被明确列为 Non-Goal
- [A Guide to the Go Garbage Collector](https://tip.golang.org/doc/gc-guide) — GOGC 与 GOMEMLIMIT 的交互

---

## ✅ 结论

按杠杆大小排序，真正有用的只有三条：

1. **换 trae-gopls**（-14 GB）— 根治，且能把之前所有降级的体验还回来
2. **关掉 golangci-lint**（-19.5 GB）— 独立进程，跟换不换 gopls 正交，CI 里本来就有
3. **去掉 `GOGC=off`** — 不去掉的话，堆必然涨到 `GOMEMLIMIT`，且所有测量都不可信

其余（gopls settings 调参、RGO 本地注入）投入产出比都很差，
甚至是负的——**代价天天在付，收益一次都没兑现**。
