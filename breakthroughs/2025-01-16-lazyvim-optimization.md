# LazyVim 配置优化全记录

**Date**: 2025-01-16
**Tags**: #lazyvim #neovim #terminal #ai #git #snacks

## 🎯 One-Line Summary

解决 LazyVim 多终端管理、AI 补全 ghost text、Lazygit buffer 刷新、侧边栏布局等核心体验问题。

---

## 1. Snacks 多终端管理

### 🔴 The Problem

Snacks.terminal 默认只能 toggle 同一个终端，无法像 VSCode 那样创建和切换多个终端。

### 💡 The Insight

Snacks 终端 ID 基于 `cmd`, `cwd`, `env`, `vim.v.count1` 生成。通过不同的 `env` 参数可以创建独立终端实例。

### 🛠️ Implementation

```lua
-- 多终端管理
local term_id = 0

-- 新建浮动终端
vim.keymap.set("n", "<leader>fn", function()
  term_id = term_id + 1
  Snacks.terminal.open(nil, { win = { position = "float" }, env = { SNACKS_TERM = tostring(term_id) } })
end, { desc = "New Float Terminal" })

-- 终端列表选择器
vim.keymap.set("n", "<leader>fl", function()
  local terminals = Snacks.terminal.list()
  if #terminals == 0 then
    vim.notify("No terminals open", vim.log.levels.INFO)
    return
  end
  local names = {}
  for i, _ in ipairs(terminals) do
    table.insert(names, "Terminal " .. i)
  end
  vim.ui.select(names, { prompt = "Select Terminal:" }, function(_, idx)
    if idx then
      terminals[idx]:show()
      terminals[idx]:focus()
    end
  end)
end, { desc = "List Terminals" })
```

### 🔄 Reusable Pattern

**避免 userdata deepcopy 错误**：Snacks.picker 无法 deepcopy userdata（如终端对象），改用 `vim.ui.select` 配合索引间接引用。

---

## 2. AI 补全 Ghost Text 配置

### 🔴 The Problem

安装 Supermaven 后看不到行内灰色 ghost text 预览，只能在补全菜单里选择。

### 💡 The Insight

LazyVim 默认 `vim.g.ai_cmp = true`，会将 AI 建议放入补全菜单而非 inline ghost text。

### 🛠️ Implementation

```lua
-- lua/config/options.lua
-- 启用 AI inline ghost text（类似 Cursor）
vim.g.ai_cmp = false
```

### 📊 Impact

- Before: AI 建议只在补全菜单显示
- After: 打字时直接看到灰色预览，Tab 一键接受

### 🔄 Reusable Pattern

| 设置 | 效果 |
|------|------|
| `vim.g.ai_cmp = true` | AI 建议在补全菜单 |
| `vim.g.ai_cmp = false` | AI 建议为 inline ghost text |

---

## 3. Lazygit Buffer 刷新

### 🔴 The Problem

在 lazygit 里 discard 改动后，nvim 的 buffer 和 neo-tree 诊断不刷新，需要退出重进。

### 💡 The Insight

snacks.nvim 的 lazygit 支持 `win.on_close` 回调，可以在关闭时检测文件 mtime 变化并重新加载。

### 🛠️ Implementation

```lua
-- lua/plugins/core.lua
{
  "folke/snacks.nvim",
  opts = {
    lazygit = {
      win = {
        on_close = function()
          vim.defer_fn(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
                local name = vim.api.nvim_buf_get_name(buf)
                if name ~= "" and vim.fn.filereadable(name) == 1 then
                  local file_mtime = vim.fn.getftime(name)
                  local buf_mtime = vim.b[buf].last_mtime or 0
                  if file_mtime > buf_mtime or vim.bo[buf].modified then
                    vim.api.nvim_buf_call(buf, function()
                      vim.cmd("e!")
                    end)
                    vim.b[buf].last_mtime = file_mtime
                  end
                end
              end
            end
          end, 100)
        end,
      },
    },
  },
},
```

### 🔄 Reusable Pattern

**外部工具修改文件后刷新 buffer**：
1. 用 `vim.fn.getftime()` 获取文件修改时间
2. 对比 buffer 缓存的 mtime
3. 只刷新真正变更的文件，避免全量刷新

---

## 4. Edgy 侧边栏布局

### 🔴 The Problem

右侧边栏 Database 在上面、Outline 在下面，且 Database 无法折叠。

### 💡 The Insight

edgy.nvim 的 `right` 配置数组顺序决定面板位置，`open = false` 设置默认折叠。

### 🛠️ Implementation

```lua
-- lua/plugins/editor.lua
{
  "folke/edgy.nvim",
  opts = {
    right = {
      { title = "Outline", ft = "Outline", size = { height = 0.6 } },
      { title = "Database", ft = "dbui", size = { height = 0.4 }, open = false },
    },
  },
}
```

### 🔄 Reusable Pattern

**edgy.nvim 面板配置**：
- 数组顺序 = 面板从上到下的位置
- `size = { height = 0.6 }` = 占 60% 高度
- `open = false` = 默认折叠

---

## 5. 禁用 windows.nvim

### 🔴 The Problem

windows.nvim 导致切换窗口时大小不断跳动，影响专注。

### 💡 The Insight

windows.nvim 的自动缩放和 edgy.nvim 冲突，且视觉干扰大于收益。

### 🛠️ Implementation

```lua
-- lua/plugins/disabled.lua
{ "anuvyklack/windows.nvim", enabled = false },
```

### 🔄 Reusable Pattern

**替代方案**：
- `<C-w>|` 最大化当前窗口宽度
- `<C-w>=` 恢复均分
- `NeoZoom` 的 `<CR>` 全屏当前 buffer

---

## 🔗 Related Resources

- [LazyVim Extras](https://www.lazyvim.org/extras)
- [snacks.nvim Terminal](https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md)
- [edgy.nvim](https://github.com/folke/edgy.nvim)
