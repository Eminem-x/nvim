return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        keys = {
            {
                "<leader>be",
                function()
                    require("neo-tree.command").execute({ toggle = true, source = "buffers" })
                end,
                desc = "buffer explore",
            },
            {
                "<leader>ge",
                function()
                    require("neo-tree.command").execute({ toggle = true, source = "git_status" })
                end,
                desc = "git explore",
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "SmiteshP/nvim-navbuddy",
                dependencies = {
                    "SmiteshP/nvim-navic",
                    "MunifTanjim/nui.nvim"
                },
                opts = { lsp = { auto_attach = true } }
            }
        },
        -- your lsp config or other stuff
    },
    {
        "SmiteshP/nvim-navbuddy",
        opts = {
            window = {
                border = "single", -- "rounded", "double", "solid", "none", "single"
                -- or an array with eight chars building up the border in a clockwise fashion
                -- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
                -- size = "80%", -- Or table format example: { height = "40%", width = "100%"}
                size = {
                    height = "60%",
                    width = "70%",
                },
                position = "50%", -- Or table format example: { row = "100%", col = "0%"}
                scrolloff = nil,  -- scrolloff value within navbuddy window
                sections = {
                    left = {
                        size = "20%",
                        border = "single", -- You can set border style for each section individually as well.
                    },
                    mid = {
                        size = "30%",
                        border = "single",
                    },
                    right = {
                        -- No size option for right most section. It fills to
                        -- remaining area.
                        border = "single",
                        preview = "leaf", -- Right section can show previews too.
                        -- Options: "leaf", "always" or "never"
                    }
                },
            },
        }
    },
    {
        "chrisgrieser/nvim-spider",
        lazy = true,
        opts = {
            skipInsignificantPunctuation = false,
        }
    },
    { "anuvyklack/pretty-fold.nvim" }
}
