-- 内场定制版 gopls：生成代码跳过 func body、静态分析默认只覆盖 workspace + 标准库、
-- 文件内容在初始化后可被 GC。cashier_core 上官方 gopls 稳定吃满 30G，换它之后 16G。
-- 装法（macOS 走 homebrew，升级同命令）：
--   curl -fsSL https://tosv-myabc.byted.org/obj/trae-common-2-asiasebd/trae-gopls/install_all_platforms.sh | bash
-- 代价：生成代码的 func body 内部 gd 跳不了（body 没被解析），gr 不受影响。
local trae_gopls = vim.fn.exepath("trae-gopls")

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          -- 没装就留空，回落到 LazyVim 默认的 Mason gopls
          cmd = trae_gopls ~= "" and { trae_gopls } or nil,
          -- gopls 的 implementation 要扫全依赖图的方法集，cashier_core 上每次都卡；
          -- gI 改成 rg 搜 `func (recv) 光标词(`，秒出（默认排除测试/生成代码，<a-t>/<a-g> 切换），
          -- 要按类型精确匹配（含接口名本身）时用 <leader>cI 走 LSP
          keys = {
            {
              "gI",
              function()
                local word = vim.fn.expand("<cword>")
                Snacks.picker.grep({
                  title = "Implementations: " .. word,
                  search = "^func \\([^)]*\\) " .. word .. "\\(",
                  regex = true,
                  live = false,
                  cwd = LazyVim.root(),
                })
              end,
              desc = "Goto Implementation (grep)",
            },
            {
              "<leader>cI",
              function()
                Snacks.picker.lsp_implementations()
              end,
              desc = "Goto Implementation (LSP)",
            },
          },
          -- 安全阀，不是目标值；GOGC 保持默认 100，让堆贴着活跃集走
          cmd_env = trae_gopls ~= "" and { GOMEMLIMIT = "20GiB" } or nil,
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = false,
              analyses = {
                fieldalignment = false,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
            },
          },
        },
      },
    },
  },
  {
    -- LazyVim 的 lang.go extra 给 go 挂了 golangcilint(nvim-lint)，在
    -- BufWritePost/BufReadPost/InsertLeave 上触发。项目没有 .golangci.yml 时走默认
    -- linter 集，其中 unused 是全程序分析，会在独立进程里把整张依赖图重新类型检查
    -- 一遍 —— cashier_core 上实测 19.5GB。这跟换不换 gopls 无关，CI 里也有 lint。
    "mfussenegger/nvim-lint",
    -- 必须用函数形式：LazyVim 走 tbl_deep_extend("force")，空表盖不掉上游的值
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.go = {}
      return opts
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = {
          "kitex_gen",
          "go.mod",
          "go.sum",
        },
      },
    },
  },
}
