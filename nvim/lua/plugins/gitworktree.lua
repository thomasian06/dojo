return {
    {
        "theprimeagen/git-worktree.nvim",
        keys = {
            {
                "<leader>gw",
                function()
                    require("telescope").extensions.git_worktree.git_worktrees()
                end,
                desc = "Toggle git worktrees.",
            },
            {
                "<leader>gW",
                function()
                    require("telescope").extensions.git_worktree.create_git_worktree()
                end,
                desc = "Create git worktree.",
            },
        },
    },
}
