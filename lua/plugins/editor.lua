return {
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
}
