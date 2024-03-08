return {
    -- Harpoon plugin configuration
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        lazy = false,
        requires = { "nvim-lua/plenary.nvim" }, -- if harpoon requires this
        config = function()
            require("harpoon").setup({})

            local function toggle_telescope_with_harpoon(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers")
                    .new({}, {
                        prompt_title = "Harpoon",
                        finder = require("telescope.finders").new_table({
                            results = file_paths,
                        }),
                        previewer = require("telescope.config").values.file_previewer({}),
                        sorter = require("telescope.config").values.generic_sorter({}),
                    })
                    :find()
            end
            vim.keymap.set("n", "<leader>H", function()
                local harpoon = require("harpoon")
                toggle_telescope_with_harpoon(harpoon:list())
            end, { desc = "Open harpoon window" })
        end,
        keys = {
            {
                "<leader>a",
                function()
                    require("harpoon"):list():append()
                end,
                desc = "harpoon file",
            },
            {
                "<leader>h",
                function()
                    local harpoon = require("harpoon")
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "Harpoon quick menu",
            },
            {
                "<leader>1",
                function()
                    require("harpoon"):list():select(1)
                end,
                desc = "Harpoon to file 1",
            },
            {
                "<leader>2",
                function()
                    require("harpoon"):list():select(2)
                end,
                desc = "Harpoon to file 2",
            },
            {
                "<leader>3",
                function()
                    require("harpoon"):list():select(3)
                end,
                desc = "Harpoon to file 3",
            },
            {
                "<leader>4",
                function()
                    require("harpoon"):list():select(4)
                end,
                desc = "Harpoon to file 4",
            },
            {
                "<leader>5",
                function()
                    require("harpoon"):list():select(5)
                end,
                desc = "Harpoon to file 5",
            },
        },
    },
}
