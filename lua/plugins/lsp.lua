return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              -- 关闭高版本 Go 插件
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
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                -- 禁用一些 python 的 linter
                pycodestyle = {
                  enabled = false,
                  ignore = { "W391", "W504", "W291" },
                  maxLineLength = 200,
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = {
          -- 忽略部分文件
          "kitex_gen",
          "go.mod",
          "go.sum",
          -- "biz/model",
          -- "idl",
        },
      },
    },
  },
}
