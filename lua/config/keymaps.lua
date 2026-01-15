-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Resize window using <ctrl> arrow keys
-- vim.keymap.set("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
-- vim.keymap.set("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
-- vim.keymap.set("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- vim.keymap.set("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- spider
vim.keymap.set({ "n", "o", "x" }, "w", function() require("spider").motion("w") end, { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", function() require("spider").motion("e") end, { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", function() require("spider").motion("b") end, { desc = "Spider-b" })

-- disable scrolling on touchpad
vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })

-- vim.keymap.set("n", "<leader>vw", require("visual-whitespace").toggle, { desc = "Toggle Visual Whitespace" })

-- snacks terminal
vim.keymap.set("n", "<leader>ft", function()
  -- 传入 nil 作为命令，让它使用默认的 shell
  -- 通过 opts 参数设置窗口位置
  Snacks.terminal(nil, {
    win = { position = "float" },
  })
end, { desc = "Toggle Float Terminal" })
vim.keymap.set("n", "<leader>fT", function()
  Snacks.terminal()
end, { desc = "Toggle Bottom Terminal" })

-- Cmd+V 从系统剪贴板粘贴
vim.keymap.set("n", "<D-v>", '"+p', { noremap = true, silent = true })
vim.keymap.set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true })
vim.keymap.set("v", "<D-v>", '"+p', { noremap = true, silent = true })
vim.keymap.set("c", "<D-v>", "<C-r>+", { noremap = true, silent = true })
vim.keymap.set("t", "<D-v>", "<C-r>+", { noremap = true, silent = true })
