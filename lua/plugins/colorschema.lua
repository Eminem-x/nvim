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
    opts = {
      -- moon, storm, night, day
      style = "storm",
    },
  },

  { "navarasu/onedark.nvim", opts = { style = "deep" } },

  { "Mofiqul/vscode.nvim" },

  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
    },
  },

  { "EdenEast/nightfox.nvim" },

  {
    "rose-pine/neovim",
    name = "rose-pine-moon",
  },

  {
    "olimorris/onedarkpro.nvim",
    name = "onedarkpro",
    lazy = true,
  },

  -- set the theme of lazyvim
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },
}
