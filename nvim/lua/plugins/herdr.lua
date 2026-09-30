return {
  {
    dir = "~/projects/herdr.nvim",
    name = "herdr.nvim",
    cmd = "Herdr",
    keys = {
      { "<leader>aa", "<cmd>Herdr toggle<cr>", desc = "Herdr tree" },
      { "<leader>ap", "<cmd>Herdr pick<cr>", desc = "Herdr pick pane" },
    },
    opts = {
      remote = "work.dev",
      session = "main",
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = { spec = { { "<leader>a", group = "agents (herdr)" } } },
  },
}
