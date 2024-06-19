return {
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
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    opts = {
      skipInsignificantPunctuation = false,
    },
  },
  { vim.api.nvim_exec("language en_US", true) }, -- 设置默认语言为英语
  {
    "tris203/precognition.nvim",
    --event = "VeryLazy",
    opts = {
      -- startVisible = true,
      -- showBlankVirtLine = true,
      -- highlightColor = { link = "Comment" },
      -- hints = {
      --      Caret = { text = "^", prio = 2 },
      --      Dollar = { text = "$", prio = 1 },
      --      MatchingPair = { text = "%", prio = 5 },
      --      Zero = { text = "0", prio = 1 },
      --      w = { text = "w", prio = 10 },
      --      b = { text = "b", prio = 9 },
      --      e = { text = "e", prio = 8 },
      --      W = { text = "W", prio = 7 },
      --      B = { text = "B", prio = 6 },
      --      E = { text = "E", prio = 5 },
      -- },
      -- gutterHints = {
      --     G = { text = "G", prio = 10 },
      --     gg = { text = "gg", prio = 9 },
      --     PrevParagraph = { text = "{", prio = 8 },
      --     NextParagraph = { text = "}", prio = 8 },
      -- },
    },
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
