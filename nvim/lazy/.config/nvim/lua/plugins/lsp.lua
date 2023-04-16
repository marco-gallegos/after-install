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
        --TODO:Llklklk
        -- require "alpha.lsp"
		--local lsp = require('lsp-zero')

		--lsp.preset('recommended')
		--lsp.setup()
        --
        local lsp = require('lsp-zero').preset({})

        lsp.on_attach(function(client, bufnr)
          lsp.default_keymaps({buffer = bufnr})
        end)

        -- (Optional) Configure lua language server for neovim
        require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

        lsp.setup()

        -- Make sure you setup `cmp` after lsp-zero

        local cmp = require('cmp')
        local cmp_action = require('lsp-zero').cmp_action()

        cmp.setup({
          mapping = {
            -- `Enter` key to confirm completion
            ['<CR>'] = cmp.mapping.confirm({select = false}),

            -- Ctrl+Space to trigger completion menu
            --['<C-Space>'] = cmp.mapping.complete(),

            -- Navigate between snippet placeholder
            --['<C-f>'] = cmp_action.luasnip_jump_forward(),
            --['<C-b>'] = cmp_action.luasnip_jump_backward(),
          }
        })
	end,
}
