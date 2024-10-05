lua << EOF
local cmp = require('cmp')
local cmp_format = require('lsp-zero').cmp_format()
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
sources = {
	{name = 'nvim_lsp'},
	{name = 'luasnip'},
	-- {name = 'copilot'},
	{name = 'buffer'},
},
mapping = {

	['<CR>'] = cmp.mapping.confirm({
	-- documentation says this is important.
	-- I don't know why.
	behavior = cmp.ConfirmBehavior.Replace,
	select = false,
	}),
	['<C-f>'] = cmp_action.luasnip_jump_forward(),
	['<C-b>'] = cmp_action.luasnip_jump_backward(),


	['<C-y>'] = cmp.mapping.confirm({select = false}),
	['<C-e>'] = cmp.mapping.abort(),
	['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
	['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
	['<Tab>'] = cmp_action.luasnip_supertab(),
	['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
	['<C-p>'] = cmp.mapping(function()
	if cmp.visible() then
		cmp.select_prev_item({behavior = 'insert'})
	else
		cmp.complete()
		end
		end),
		['<C-n>'] = cmp.mapping(function()
		if cmp.visible() then
			cmp.select_next_item({behavior = 'insert'})
		else
			cmp.complete()
			end
			end),
},
snippet = {
	expand = function(args)
	require('luasnip').lsp_expand(args.body)
	end,
},
window = {
	completion = cmp.config.window.bordered(),
	documentation = cmp.config.window.bordered(),
},
formatting = cmp_format,
})

EOF
