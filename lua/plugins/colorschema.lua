-- https://vimcolorschemes.com/ 可参考的 nvim 背景
return {
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

  { "ellisonleao/gruvbox.nvim" },

  { "rebelot/kanagawa.nvim" },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    -- moon, storm, night, day
    opts = { style = "storm" },
  },

  { "navarasu/onedark.nvim" },

  { "Mofiqul/vscode.nvim" },

  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
    },
  },

  -- set the theme of lazyvim
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },
}
