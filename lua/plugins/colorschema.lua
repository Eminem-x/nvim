-- https://vimcolorschemes.com/ 可参考的 nvim 背景
return {
    -- add gruvbox
    { "ellisonleao/gruvbox.nvim" },
    -- add catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },
    -- add onedark
    -- { "joshdick/onedark.vim" },
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = { style = "storm" },
    },
    {
        "navarasu/onedark.nvim",
    },

    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            -- colorscheme = "catppuccin",
            colorscheme = "onedark",
        },
    },
}
