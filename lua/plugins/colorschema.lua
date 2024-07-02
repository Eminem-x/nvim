-- https://vimcolorschemes.com/ 可参考的 nvim 背景
return {
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
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight" },
  },
}
