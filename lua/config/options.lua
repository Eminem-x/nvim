-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.relativenumber = false

opt.tabstop = 4 -- A TAB character looks like 4 spaces
opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
opt.shiftwidth = 4 -- Number of spaces inserted when indenting

opt.wrap = true -- 当文本长度超过窗口宽度时，自动换行文本

opt.spelllang = "en,cjk" -- 同时启用英语和中日韩语言的拼写检查
opt.spelloptions = "camel" -- 拼写检查会忽略包含大写字母的单词

opt.indentexpr = ""
opt.foldmethod = "indent" -- 设置折叠方法为 indent（基于缩进）
opt.foldlevel = 99 -- 设置默认折叠级别为 99, 表示所有代码都会被折叠起来，除非手动展开
opt.foldenable = true -- 启用折叠功能
opt.foldlevelstart = 99 -- 设置起始折叠级别为 99

opt.foldmethod = "indent" -- 根据 indent 折叠
