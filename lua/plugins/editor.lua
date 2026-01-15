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
}
