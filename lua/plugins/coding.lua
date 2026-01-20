return {
  -- Claude Code: diff 打开后焦点保持在 terminal
  {
    "coder/claudecode.nvim",
    opts = {
      diff_opts = {
        keep_terminal_focus = true,
      },
    },
  },

  -- 文件被外部修改后自动刷新 buffer（适配 Claude Code 等 AI 工具）
  {
    "diogo464/hotreload.nvim",
    event = "VeryLazy",
    opts = {
      interval = 500,
    },
  },

  -- Tab 补全：优先接受 AI 补全，然后选择下一项
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = {
          "snippet_forward",
          "select_next",
          LazyVim.cmp.map({ "ai_accept" }),
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      },
    },
  },

  -- add gitsigns extra command
  {
    "lewis6991/gitsigns.nvim",

    opts = {
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

      -- stylua: ignore start
      map("n", "]h", gs.next_hunk, "Next Hunk")
      map("n", "[h", gs.prev_hunk, "Prev Hunk")
      map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
      map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
      map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
      map("n", "<leader>ght", gs.toggle_current_line_blame, "Blame Line") -- 相比于上面的 blame 更加方便
      map("n", "<leader>ghd", gs.diffthis, "Diff This")
      map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
}
