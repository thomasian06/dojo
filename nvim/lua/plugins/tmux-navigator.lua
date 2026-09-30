-- Neovim half of the vim-tmux-navigator setup in ~/.tmux.conf: C-h/j/k/l move
-- between Neovim windows and continue into tmux panes at the edges.
return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    init = function()
      -- Keys are set below (so LazyVim's window maps are overridden).
      vim.g.tmux_navigator_no_mappings = 1
    end,
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window/tmux left" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window/tmux down" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window/tmux up" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window/tmux right" },
      { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Window/tmux previous" },
    },
  },
}
