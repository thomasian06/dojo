return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        -- Let LazyVim run catppuccin's setup and apply the colorscheme once.
        -- (Applying it again from a custom `config` reloaded it mid-startup and
        -- could wipe lualine's mode colors.)
        opts = { flavour = "mocha" },
    },

    -- Configure LazyVim to use theme
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin-mocha",
        },
    },
}
