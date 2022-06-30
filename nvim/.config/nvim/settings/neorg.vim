lua << EOF
require('neorg').setup {
    load = {
        ["core.defaults"] = {}
    }
}

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*.norg" },
    command = "normal Neorg sync-parsers ",
})
EOF
