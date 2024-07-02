-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.relativenumber = false

opt.tabstop = 4 -- A TAB character looks like 4 spaces
opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
opt.shiftwidth = 4 -- Number of spaces inserted when indenting

opt.wrap = true -- 当文本长度超过窗口宽度时，自动换行文本

vim.api.nvim_exec("language en_US", true)
opt.spelllang = "en,cjk" -- 同时启用英语和中日韩语言的拼写检查
opt.spelloptions = "camel" -- 拼写检查会忽略包含大写字母的单词

-- https://www.jmaguire.tech/posts/treesitter_folding/
-- opt.foldmethod = "expr"
-- opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99 -- 设置默认折叠级别为 99, 表示所有代码都会被折叠起来，除非手动展开

opt.mouse = "" -- 禁用鼠标
opt.mousescroll = "ver:0,hor:0" -- 禁用鼠标滚动

-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyjight instead of pyright.
-- vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_lsp = "pylsp"
vim.g.lazyvim_python_ruff = "ruff_lsp"
vim.g.codeium_enabled = true

vim.o.guifont = "SauceCodePro Nerd Font Mono:h13"

-- 将 Cmd+V 映射为从系统剪贴板粘贴
vim.api.nvim_set_keymap("n", "<D-v>", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<D-v>", "<C-r>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap("c", "<D-v>", "<C-r>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-r>+", { noremap = true, silent = true })
