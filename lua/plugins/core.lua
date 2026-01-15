return {
  { "folke/lazy.nvim", version = false },
  { "LazyVim/LazyVim", version = false },

  -- lazygit 关闭后重新加载 buffer 并刷新诊断
  {
    "folke/snacks.nvim",
    opts = {
      lazygit = {
        win = {
          on_close = function()
            vim.defer_fn(function()
              -- 只重新加载被外部修改的 buffer
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
                  local name = vim.api.nvim_buf_get_name(buf)
                  if name ~= "" and vim.fn.filereadable(name) == 1 then
                    local file_mtime = vim.fn.getftime(name)
                    local buf_mtime = vim.b[buf].last_mtime or 0
                    -- 文件被外部修改 或 buffer 有未保存修改（可能被 discard）
                    if file_mtime > buf_mtime or vim.bo[buf].modified then
                      vim.api.nvim_buf_call(buf, function()
                        vim.cmd("e!")
                      end)
                      vim.b[buf].last_mtime = file_mtime
                    end
                  end
                end
              end
            end, 100)
          end,
        },
      },
    },
  },
}
