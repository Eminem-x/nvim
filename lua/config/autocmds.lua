-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable autoformat for lua files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "python", "py" },
  callback = function()
    vim.b.autoformat = false
  end,
})

if vim.fn.getenv("SSH_CONNECTION") ~= nil then
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      if vim.v.event.operator == "y" and vim.v.event.regname == "" then
        require("osc52").copy_register("+")
      end
    end,
  })

  local function copy(lines, _)
    require("osc52").copy(table.concat(lines, "\n"))
  end

  local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end

  vim.g.clipboard = {
    name = "osc52",
    copy = { ["+"] = copy, ["*"] = copy },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
