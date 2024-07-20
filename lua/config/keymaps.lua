-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Resize window using <ctrl> arrow keys
-- vim.keymap.set("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
-- vim.keymap.set("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
-- vim.keymap.set("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- vim.keymap.set("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- spider
vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })

-- disablse scrolling on touchpad
vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
-- vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
-- vim.keymap.set("i", "<down>", "<nop>", { noremap = true })

-- floating terminal
local lazyterm = function()
  LazyVim.terminal(nil, { cwd = LazyVim.root() })
end
vim.keymap.set("n", "<leader>ft", lazyterm, { desc = "Terminal (Root Dir)" })
-- map("n", "<leader>ft", function()
--   lazyvim.terminal()
-- end, { desc = "terminal (cwd)" })
vim.keymap.set("n", "<leader>fT", "<cmd>ToggleTerm size=40 direction=float<CR>", { desc = "terminal (cwd)" })
vim.keymap.set("n", "<c-q>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], { desc = "terminal (cwd)" })
vim.keymap.set("n", "<c-/>", lazyterm, { desc = "Terminal (Root Dir)" })
vim.keymap.set("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })
