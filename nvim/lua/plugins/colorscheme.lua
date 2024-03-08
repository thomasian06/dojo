return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function(plugin)
            vim.cmd("colorscheme catppuccin-mocha")
        end,
    },

    -- Configure LazyVim to use theme
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin",
        },
    },
}
