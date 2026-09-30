-- herdr-nvim: <leader>aa tree, <leader>ap picker (plugin defaults).
-- Uses the local checkout when present, otherwise installs from GitHub.
local dev = vim.fn.expand("~/projects/herdr-nvim")

return {
  {
    "thomasian06/herdr-nvim",
    dir = vim.uv.fs_stat(dev) and dev or nil,
    event = "VeryLazy",
    opts = {
      remote = "work.dev",
      session = "main",
    },
  },
}
