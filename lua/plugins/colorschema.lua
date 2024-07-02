-- https://vimcolorschemes.com/ 可参考的 nvim 背景
return {
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },
  { "ellisonleao/gruvbox.nvim" },
  { "rebelot/kanagawa.nvim" },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    -- moon, storm, night, day
    opts = { style = "moon" },
  },
  { "navarasu/onedark.nvim" },
  { "Mofiqul/vscode.nvim" },
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
