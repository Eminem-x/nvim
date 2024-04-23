-- https://vimcolorschemes.com/ 可参考的 nvim 背景
return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  -- add catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      no_italic = true,
    },
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
  {
    "Mofiqul/vscode.nvim",
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin",
      colorscheme = "catppuccin",
    },
  },
}
