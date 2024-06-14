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
    "rebelot/kanagawa.nvim",
  },
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
      colorscheme = "kanagawa",
    },
  },

  -- dashboard
  {
    "goolord/alpha-nvim",
    opts = function()
      local logo = [[
██╗   ██╗██╗   ██╗ █████╗ ███╗   ██╗██╗  ██╗ █████╗  ██████╗ 
╚██╗ ██╔╝██║   ██║██╔══██╗████╗  ██║██║  ██║██╔══██╗██╔═══██╗
 ╚████╔╝ ██║   ██║███████║██╔██╗ ██║███████║███████║██║   ██║
  ╚██╔╝  ██║   ██║██╔══██║██║╚██╗██║██╔══██║██╔══██║██║   ██║
   ██║   ╚██████╔╝██║  ██║██║ ╚████║██║  ██║██║  ██║╚██████╔╝
   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ 
            ]]
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = vim.split(logo, "\n")
    end,
  },
}
