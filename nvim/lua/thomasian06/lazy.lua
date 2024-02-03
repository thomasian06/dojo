-------------------------------------------------------------------------------
-- Lazy Package Manager
-------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- [[Basic Keymaps]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: must happen before plugins are required
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

return require('lazy').setup({

    ---------------------------------------------------------------------------
    -- Theme
    ---------------------------------------------------------------------------
    {
        'rose-pine/neovim',
        name = 'rose-pine',
        config = function(plugin)
            vim.cmd('colorscheme rose-pine-moon')
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true }
    },
    {
        "folke/zen-mode.nvim",
    },
    {
        "folke/twilight.nvim",
    },

    ---------------------------------------------------------------------------
    -- Syntax Highlighting
    ---------------------------------------------------------------------------
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },
    'nvim-treesitter/playground',
    {
        "kiyoon/treesitter-indent-object.nvim",
        keys = {
            {
                "ai",
                function() require 'treesitter_indent_object.textobj'.select_indent_outer() end,
                mode = { "x", "o" },
                desc = "Select context-aware indent (outer)",
            },
            {
                "aI",
                function() require 'treesitter_indent_object.textobj'.select_indent_outer(true) end,
                mode = { "x", "o" },
                desc = "Select context-aware indent (outer, line-wise)",
            },
            {
                "ii",
                function() require 'treesitter_indent_object.textobj'.select_indent_inner() end,
                mode = { "x", "o" },
                desc = "Select context-aware indent (inner, partial range)",
            },
            {
                "iI",
                function() require 'treesitter_indent_object.textobj'.select_indent_inner(true, 'V') end,
                mode = { "x", "o" },
                desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
            },
        },
    },

    ---------------------------------------------------------------------------
    -- Navigation
    ---------------------------------------------------------------------------
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    'theprimeagen/harpoon',
    'mbbill/undotree',
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },

    ---------------------------------------------------------------------------
    -- Git
    ---------------------------------------------------------------------------
    'tpope/vim-fugitive',
    'lewis6991/gitsigns.nvim',
    {
        'theprimeagen/git-worktree.nvim',
        keys = {
            { "<leader>gw", function() require('telescope').extensions.git_worktree.git_worktrees() end,       desc = "Toggle git worktrees." },
            { "<leader>gW", function() require('telescope').extensions.git_worktree.create_git_worktree() end, desc = "Create git worktree." },
        },
    },



    ---------------------------------------------------------------------------
    -- Dependency Manager
    ---------------------------------------------------------------------------
    {
        'williamboman/mason.nvim',
        opts = {
            ensure_installed = {
                "debugpy",
            },
        },
    },

    ---------------------------------------------------------------------------
    -- LSP
    ---------------------------------------------------------------------------
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            --- Uncomment the two plugins below if you want to manage the language servers from neovim
            --- and read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            { 'williamboman/mason-lspconfig.nvim' },

            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    },

    {
        'nvimtools/none-ls.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' }
        }
    },

    ---------------------------------------------------------------------------
    -- Debuggers
    ---------------------------------------------------------------------------
    {
        "mfussenegger/nvim-dap",
        keys = {
            { "<leader>db", "<cmd> DapToggleBreakpoint <CR>", desc = "Toggle Breakpoint" },
            { "<leader>di", "<cmd> DapStepInto <CR>",         desc = "Toggle Breakpoint" },
            { "<leader>do", "<cmd> DapStepOver <CR>",         desc = "Toggle Breakpoint" },
            { "<leader>du", "<cmd> DapStepOut <CR>",          desc = "Toggle Breakpoint" },
            { "<leader>dc", "<cmd> DapContinue <CR>",         desc = "Toggle Breakpoint" },
            { "<leader>dt", "<cmd> DapTerminate <CR>",        desc = "Toggle Breakpoint" },
            { "<leader>de", "<cmd> DapToggleRepl <CR>",       desc = "Toggle Breakpoint" },
        },
    },

    -- Debug UI
    {
        "rcarriga/nvim-dap-ui",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },

    -- Python
    {
        "mfussenegger/nvim-dap-python",
        ft = { "python" },
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        keys = {
            { "<leader>dr", function() require("dap-python").test_method() end, desc = "Run and debug." }
        },
        config = function(_, opts)
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
        end,
    },

    ---------------------------------------------------------------------------
    -- Testing
    ---------------------------------------------------------------------------
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
        },
        config = function(_, opts)
            local neotest = require("neotest")
            neotest.setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        args = { "--log-level", "DEBUG" },
                        runner = "pytest",
                        python = ".venv/bin/python",
                        pytest_discover_instances = true,
                    })
                }
            })
        end,
        keys = {
            { "<leader>tr", function() require("neotest").run.run() end,                                         desc = "Run nearest test." },
            { "<leader>tR", function() require("neotest").run.run(vim.fn.expand("%")) end,                       desc = "Run all tests in file." },
            { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end,                     desc = "Run nearest test in debug mode." },
            { "<leader>tD", function() require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" }) end, desc = "Run all tests in file in debug mode." },
            { "<leader>ta", function() require("neotest").run.attach() end,                                      desc = "Attach to nearest test." },
        }
    }
})
