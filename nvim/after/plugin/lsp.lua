-------------------------------------------------------------------------------
-- LSP Configuration
-------------------------------------------------------------------------------

local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.setup()

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
-- local cmp_mappings = lsp.defaults.cmp_mappings({
-- 	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
-- 	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
-- 	['<C-y>'] = cmp.mapping.confirm({ select = true}),
-- 	['<C-Space>'] = cmp.mapping.complete(),
-- })

lsp.set_preferences({
    sign_icons = {}
})


local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    })
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }


    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "C-h", function() vim.lsp.buf.signature_help() end, opts)
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = { 'jedi_language_server', 'ruff_lsp', 'lua_ls', 'tsserver', 'eslint', 'html', 'htmx', 'cssls', 'emmet_language_server' },
    handlers = {
        lsp.default_setup,
    },
})

local null_ls = require("null-ls")
local null_ls_sources = {}


-------------------------------------------------------------------------------
-- Python Configuration
-------------------------------------------------------------------------------

-- Jedi Config
require("lspconfig").jedi_language_server.setup {
    on_attach = lsp.on_attach,
}

-- Ruff Config
local ruff_lsp_on_attach = function(client, bufnr)
    client.server_capabilities.hoverProvider = false
    lsp.on_attach(client, bufnr)
end

require("lspconfig").ruff_lsp.setup {
    on_attach = ruff_lsp_on_attach,
    init_options = {
        settings = {
            args = {},
        }
    }
}

-- table.insert(null_ls_sources, null_ls.builtins.diagnostics.ruff.with({
--     prefer_local = ".venv/bin",
-- }))

-- Mypy Config
table.insert(null_ls_sources, null_ls.builtins.diagnostics.mypy.with({
    prefer_local = ".venv/bin",
}))

-------------------------------------------------------------------------------
-- Web Dev Configuration
-------------------------------------------------------------------------------

-- Tsserver Config
require("lspconfig").tsserver.setup {
    on_attach = lsp.on_attach,
}

-- Eslint Config
require("lspconfig").eslint.setup {
    on_attach = lsp.on_attach,
}

-- Emmet Config
require("lspconfig").emmet_language_server.setup {
    on_attach = lsp.on_attach,
}

-- HTML Config
require("lspconfig").html.setup {
    on_attach = lsp.on_attach,
}

-- -- HTMX Config
-- require("lspconfig").htmx.setup {
--     on_attach = lsp.on_attach,
-- }

-- CSS Config
require("lspconfig").cssls.setup {
    on_attach = lsp.on_attach,
}


-------------------------------------------------------------------------------
-- Mojo Configuration
-------------------------------------------------------------------------------
require("lspconfig").mojo.setup {}

-------------------------------------------------------------------------------
-- Null-ls (None-ls) Config
-------------------------------------------------------------------------------

null_ls.setup({
    sources = null_ls_sources,
})

lsp.setup()
