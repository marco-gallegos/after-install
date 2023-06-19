return {
	'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
	dependencies = {
		{'neovim/nvim-lspconfig'},
        {                                      -- Optional
          'williamboman/mason.nvim',
          build = function()
            pcall(vim.cmd, 'MasonUpdate')
          end,
        },
        {'williamboman/mason-lspconfig.nvim'},

        	-- Autocompletado
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'saadparwaiz1/cmp_luasnip'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-nvim-lua'},

        -- Snippets
        {'L3MON4D3/LuaSnip'},
        {'rafamadriz/friendly-snippets'},
	},
	config = function()
        local lsp_zero = require('lsp-zero').preset({})
        local luasnip = require('luasnip')
        local lspconfig = require('lspconfig')

        -- snipet loading
        local luasnip_loader_vsc = require('luasnip.loaders.from_vscode')

        lsp_zero.on_attach(function(client, bufnr)
            lsp_zero.default_keymaps({
                buffer = bufnr,
                preserve_mappings = false,
            })
        end)

        -- (Optional) Configure lua language server for neovim
        lspconfig.lua_ls.setup(lsp_zero.nvim_lua_ls())

        lsp_zero.setup()

        -- Make sure you setup `cmp` after lsp-zero

        local cmp = require('cmp')
        local cmp_action = lsp_zero.cmp_action()

        luasnip_loader_vsc.lazy_load()

        cmp.setup({
            mapping = {
                -- `Enter` key to confirm completion
                ['<CR>'] = cmp.mapping.confirm({select = false}),

                -- Ctrl+Space to trigger completion menu
                --['<C-Space>'] = cmp.mapping.complete(),

                -- Ngate between snippet placeholder
                --['<C-1>'] = cmp_action.luasnip_jump_forward(),
                --['<C-b>'] = cmp_action.luasnip_jump_backward(),
            },

            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },

            sources = {
                { name = 'luasnip' },
                { name = 'nvim_lsp'},
                { name = 'buffer'},
                { name = 'path'},
            },
        })
	end,
}
