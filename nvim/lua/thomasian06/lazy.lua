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

    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },

    {
        'rose-pine/neovim',
        name = 'rose-pine',
        config = function(plugin)
            vim.cmd('colorscheme rose-pine')
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },
    'nvim-treesitter/playground',
    'theprimeagen/harpoon',
    'mbbill/undotree',
    'tpope/vim-fugitive',
    'lewis6991/gitsigns.nvim',

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true }
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
    -- Debuggers
    ---------------------------------------------------------------------------
    {
        "mfussenegger/nvim-dap",
        keys = {
            { "<leader>db", "<cmd> DapToggleBreakpoint <CR>", desc = "Toggle Breakpoint" },
            { "<leader>di", "<cmd> DapStepInto <CR>", desc = "Toggle Breakpoint" },
            { "<leader>do", "<cmd> DapStepOver <CR>", desc = "Toggle Breakpoint" },
            { "<leader>du", "<cmd> DapStepOut <CR>", desc = "Toggle Breakpoint" },
            { "<leader>dc", "<cmd> DapContinue <CR>", desc = "Toggle Breakpoint" },
            { "<leader>dt", "<cmd> DapTerminate <CR>", desc = "Toggle Breakpoint" },
            { "<leader>de", "<cmd> DapToggleRepl <CR>", desc = "Toggle Breakpoint" },
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
    }
})
