return {
  -- add buffer and git neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ toggle = true, source = "buffers" })
        end,
        desc = "buffer explore",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ toggle = true, source = "git_status" })
        end,
        desc = "git explore",
      },
    },
  },

  -- snacks explorer: 禁用 esc 关闭，让 flash 可以正常退出，用 q 关闭
  -- snacks grep: <a-t> 排除测试文件、<a-g> 排除生成代码、<a-c> 区分大小写、<a-w> 全词匹配，
  -- 开启时标题栏显示 T / G / Aa / W
  -- （snacks 自带的 <a-h>/<a-i>/<a-f>/<a-p> 被 zellij 占了，所以选 t/g）
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      local excludes = {
        no_tests = { "*_test.go", "**/mocks/**", "**/mock/**" },
        no_gen = { "**/kitex_gen/**", "**/thrift_gen/**", "**/mocks_autogen/**", "*.pb.go" },
      }
      -- 默认 --smart-case；rg 里后出现的大小写 flag 覆盖前面的
      local flags = {
        case_sensitive = "--case-sensitive",
        whole_word = "--word-regexp",
      }
      local grep_opts = {
        toggles = { no_tests = "T", no_gen = "G", case_sensitive = "Aa", whole_word = "W" },
        -- 默认排除测试和生成代码，需要时 <a-t>/<a-g> 关掉
        no_tests = true,
        no_gen = true,
        finder = function(o, ctx)
          local exclude = vim.list_extend({}, o.exclude or {})
          for name, globs in pairs(excludes) do
            if o[name] then
              vim.list_extend(exclude, globs)
            end
          end
          local args = vim.list_extend({}, o.args or {})
          for name, flag in pairs(flags) do
            if o[name] then
              args[#args + 1] = flag
            end
          end
          return require("snacks.picker.source.grep").grep(
            setmetatable({ exclude = exclude, args = args }, { __index = o }),
            ctx
          )
        end,
        win = {
          input = {
            keys = {
              ["<a-t>"] = { "toggle_no_tests", mode = { "i", "n" } },
              ["<a-g>"] = { "toggle_no_gen", mode = { "i", "n" } },
              -- 同 VSCode：Alt-c 大小写、Alt-w 全词、Alt-r 正则（snacks 自带）
              ["<a-c>"] = { "toggle_case_sensitive", mode = { "i", "n" } },
              ["<a-w>"] = { "toggle_whole_word", mode = { "i", "n" } },
            },
          },
        },
      }
      return vim.tbl_deep_extend("force", opts, {
        picker = {
          sources = {
            explorer = {
              win = {
                list = {
                  keys = {
                    ["<esc>"] = { "", mode = "n" },
                  },
                },
              },
            },
            grep = grep_opts,
            grep_word = grep_opts,
          },
        },
      })
    end,
  },

  -- add navbuddy
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
      },
    },
    -- your lsp config or other stuff
  },
  {
    "SmiteshP/nvim-navbuddy",
    opts = {
      window = {
        border = "single", -- "rounded", "double", "solid", "none", "single"
        -- or an array with eight chars building up the border in a clockwise fashion
        -- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
        -- size = "80%", -- Or table format example: { height = "40%", width = "100%"}
        size = {
          height = "60%",
          width = "70%",
        },
        position = "50%", -- Or table format example: { row = "100%", col = "0%"}
        scrolloff = nil, -- scrolloff value within navbuddy window
        sections = {
          left = {
            size = "20%",
            border = "single", -- You can set border style for each section individually as well.
          },
          mid = {
            size = "30%",
            border = "single",
          },
          right = {
            -- No size option for right most section. It fills to
            -- remaining area.
            border = "single",
            preview = "leaf", -- Right section can show previews too.
            -- Options: "leaf", "always" or "never"
          },
        },
      },
    },
  },

  -- add nvim-spider which enhance ewbn
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    opts = {
      skipInsignificantPunctuation = false,
    },
  },

  -- which disable your bad vim operator
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- optimize your nvim cursor move
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({})
    end,
  },

  --optimize your windows split
  {
    "anuvyklack/windows.nvim",
    dependencies = { "anuvyklack/middleclass" },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require("windows").setup()
    end,
  },

  -- fullscreen your current buffer
  {
    "nyngwang/NeoZoom.lua",
    config = function()
      require("neo-zoom").setup({
        popup = { enabled = true }, -- this is the default.
        -- NOTE: Add popup-effect (replace the window on-zoom with a `[No Name]`).
        -- EXPLAIN: This improves the performance, and you won't see two
        --          identical buffers got updated at the same time.
        -- popup = {
        --   enabled = true,
        --   exclude_filetypes = {},
        --   exclude_buftypes = {},
        -- },
        exclude_buftypes = { "terminal" },
        -- exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf' },
        winopts = {
          offset = {
            -- NOTE: omit `top`/`left` to center the floating window vertically/horizontally.
            -- top = 0,
            -- left = 0.17,
            width = 180,
            height = 0.9,
          },
          -- NOTE: check :help nvim_open_win() for possible border values.
          border = "thicc", -- this is a preset, try it :)
        },
        presets = {
          {
            -- NOTE: regex pattern can be used here!
            filetypes = { "dapui_.*", "dap-repl" },
            winopts = {
              offset = { top = 0.02, left = 0.26, width = 0.74, height = 0.25 },
            },
          },
          {
            filetypes = { "markdown" },
            callbacks = {
              function()
                vim.wo.wrap = true
              end,
            },
          },
        },
      })
      vim.keymap.set("n", "<CR>", function()
        vim.cmd("NeoZoomToggle")
        -- NeoZoom 硬编码 zindex=5，手动提升避免被 neo-tree 遮挡
        local win = vim.api.nvim_get_current_win()
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" then
          config.zindex = 50
          vim.api.nvim_win_set_config(win, config)
        end
      end, { silent = true, nowait = true })
    end,
  },

  -- enhance your terminal
  { "akinsho/toggleterm.nvim", version = "*", config = true },

  -- expand your edgy window
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
      bottom = {
        {
          ft = "lazyterm",
          size = { height = 0.3 },
          filter = function(buf)
            return not vim.b[buf].lazyterm_cmd
          end,
        },
        { ft = "dbout", size = { height = 0.5 } },
      },
      right = {
        { title = "Outline", ft = "Outline", size = { height = 0.6 } },
        { title = "Database", ft = "dbui", size = { height = 0.4 }, open = false },
      },
      options = {
        left = { size = 40 },
        right = { size = 50 },
      },
    },
  },
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },

  -- Reveal whitespace characters in visual mode, similar to VSCode.
  -- {
  --   "mcauley-penney/visual-whitespace.nvim",
  --   -- config = true,
  -- },

  -- osc52 for ssh connection
  {
    "ojroques/nvim-osc52",
    lazy = false,
    enabled = function()
      return vim.fn.getenv("SSH_CONNECTION") ~= nil
    end,
  },

  -- highlight undo
  {
    "tzachar/highlight-undo.nvim",
    keys = { { "u" }, { "<C-r>" } },
  },

  -- yazi file manager
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>-", "<cmd>Yazi<cr>", desc = "Open yazi at current file" },
      { "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open yazi in cwd" },
      { "<c-up>", "<cmd>Yazi toggle<cr>", desc = "Resume last yazi session" },
    },
    opts = {
      open_for_directories = true,
    },
  },
}
