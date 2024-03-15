------------------------------------------------------------------------------
-- LSP Configuration for non-preconfigured LSPs
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Mojo
------------------------------------------------------------------------------

return {
    {
        "czheo/mojo.vim",
        ft = { "mojo" },
        init = function()
            vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
                pattern = { "*.🔥" },
                callback = function()
                    if vim.bo.filetype ~= "mojo" then
                        vim.bo.filetype = "mojo"
                    end
                end,
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "mojo",
                callback = function()
                    local modular = vim.env.MODULAR_HOME
                    local lsp_cmd = modular .. "/pkg/packages.modular.com_mojo/bin/mojo-lsp-server"

                    vim.bo.expandtab = true
                    vim.bo.shiftwidth = 4
                    vim.bo.softtabstop = 4

                    vim.lsp.start({
                        name = "mojo",
                        cmd = { lsp_cmd },
                    })
                end,
            })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        optional = true,
        opts = function(_, opts)
            local nls = require("null-ls")
            opts.sources = vim.list_extend(opts.sources or {}, {
                nls.builtins.diagnostics.mypy.with({ prefer_local = ".venv/bin" }),
            })
        end,
    },
}
