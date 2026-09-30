-- herdr-nvim: <leader>aa tree, <leader>ap picker, <leader>ac connect (plugin defaults).
-- Uses the local checkout when present, otherwise installs from GitHub.
-- Nothing connects automatically, except a trusted .herdr-nvim.json in the
-- working directory (or a parent), e.g. { "profile": "work" }.
local dev = vim.fn.expand("~/projects/herdr-nvim")

return {
  {
    "thomasian06/herdr-nvim",
    dir = vim.uv.fs_stat(dev) and dev or nil,
    event = "VeryLazy",
    opts = {
      profiles = {
        { name = "work", remote = "work.dev", session = "main", projects_dir = "~/projects" },
      },
    },
  },
  -- Keep buffer tabs to the right of the herdr tree, like the file explorer.
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.offsets = opts.options.offsets or {}
      table.insert(opts.options.offsets, {
        filetype = "herdr",
        text = "Herdr",
        highlight = "Directory",
        text_align = "left",
      })
    end,
  },
}
