return {
    {
        "nvimtools/none-ls.nvim",
        opts = function(_, opts)
            local nls = require("null-ls")
            opts.sources = vim.list_extend(opts.sources or {}, {
                nls.builtins.code_actions.gomodifytags,
                nls.builtins.code_actions.impl,
                -- 关闭保存时的优化 fortmat, 减少代码增量改动
                -- nls.builtins.formatting.goimports,
                -- nls.builtins.formatting.gofumpt,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                gopls = {
                    settings = {
                        gopls = {
                            -- 关闭高版本 Go 插件
                            gofumpt = false,
                            staticcheck = false,
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
                },
            },
        },
    },
}
