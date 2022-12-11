-- git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
-- cargo install tree-sitter-cli / or with npm
-- Dame espacio
vim.opt.signcolumn = 'yes'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('packer').startup(function(use)
	-- Packer puede actualizarse solo
    use 'wbthomason/packer.nvim'

	use "lewis6991/impatient.nvim"

	-- Tema
    -- tree siiter compatible
    -- 
    use 'sainnhe/edge'
    -- untested tree sitter
	use 'joshdick/onedark.vim'
    use 'morhetz/gruvbox'
    -- use 'sonph/onehalf', { 'rtp': 'vim' }
    use 'NLKNguyen/papercolor-theme'
    use 'sickill/vim-monokai'
    use 'safv12/andromeda.vim'
    use 'ayu-theme/ayu-vim'
    use 'rakr/vim-one'

	-- LSP
	use {
	    'VonHeikemen/lsp-zero.nvim',
	    requires = {
            -- Soporte LSP
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
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

            -- tabnine
            -- use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}
		}
	}

	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		requires = {
			"nvim-treesitter/playground",
			"nvim-treesitter/nvim-treesitter-refactor",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
	})

	use({
	    "nvim-telescope/telescope.nvim",
	    requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-lua/popup.nvim" },
            { "nvim-telescope/telescope-fzy-native.nvim" },
            { "kyazdani42/nvim-web-devicons" },
            { "nvim-telescope/telescope-file-browser.nvim" },
            { "nvim-telescope/telescope-dap.nvim" },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
		},
	})

    use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    use 'christoomey/vim-tmux-navigator'
    use 'tiagofumo/vim-nerdtree-syntax-highlight'
    use 'preservim/nerdcommenter'
    use 'alvan/vim-closetag'
    use 'tpope/vim-surround'
    use 'yggdroot/indentline'

    -- Vim-Session
    use 'xolox/vim-misc'
    use 'xolox/vim-session'

    -- =====================  languages  ======================================

    --" go
    --"" Go Lang Bundle
    --Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}

    --" javascript
    --"" Javascript Bundle
    --Plug 'jelera/vim-javascript-syntax'

    --" php
    --"" PHP Bundle
    --"Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install --no-dev -o'}
    --Plug 'stephpy/vim-php-cs-fixer'

    --" optional laravel deps
    --Plug 'tpope/vim-dispatch'
    --Plug 'tpope/vim-projectionist'
    --Plug 'noahfrederick/vim-composer'
    --Plug 'noahfrederick/vim-laravel'


    --" python
    --"" Python Bundle
    use 'davidhalter/jedi-vim'
    -- use 'raimon49/requirements.txt.vim', {'for': 'requirements'}

    --" typescript
    --Plug 'leafgarland/typescript-vim'
    --Plug 'HerringtonDarkholme/yats.vim'

    -- BufOnly script -> close all non current buffers
    use 'vim-scripts/BufOnly.vim'
end)

-- Declaramos el tema
vim.opt.termguicolors = true
-- pcall(vim.cmd, 'colorscheme onedark')

local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.setup()


-- inline error strings
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = false,
  float = true,
})

-- TODO: this implementation doesnt work on raspbian (normal aarch64) -> should work on M1 according official documentation
-- tabnine
--require('cmp').setup {
    --sources = {
        --{ name = 'cmp_tabnine' },
    --},
--}


-- nvim tree
require("nvim-tree").setup({
    auto_reload_on_write = true,
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        width = 30,
        -- height = 30,
        side = "right",
        mappings = {
            list = {
                { key = "u", action = "dir_up", mode = "n" },
                { key = "t", action = "tabnew", mode = "n" }
            },
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
})


require('lualine').setup {
	options = {
        icons_enabled = true,
        theme = 'codedark',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = false,
	},
	sections = {
        lualine_a = {
            {
                'mode',
                icons_enabled = true
            },
        },
		lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
            {
                'filename',
                file_status=true,
                path=1,
            }
        },
        lualine_x = {'hostname','encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
	},
	inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
	},
	tabline = {},
	extensions = {}
}


require('telescope').setup{
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		prompt_prefix = "   ",
		selection_caret = "  ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
				preview_width = 0.55,
				results_width = 0.8,
			},
			vertical = {
				mirror = false,
			},
			width = 0.87,
			height = 0.80,
			preview_cutoff = 120,
		},
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_ignore_patterns = { "node_modules" },
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		path_display = { "truncate" },
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		-- Developer configurations: Not meant for general override
		buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		mappings = {
			n = { ["q"] = require("telescope.actions").close },
		},
	},
	pickers = {
	-- Default configuration for builtin pickers goes here:
	-- picker_name = {
	--   picker_config_key = value,
	--   ...
	-- }
	-- Now the picker_config_key will be applied every time you call this
	-- builtin picker
	},
	extensions = {
	-- Your extension configuration goes here:
	-- extension_name = {
	--   extension_config_key = value,
	-- }
	-- please take a look at the readme of the extension you want to configure
	},

	extensions_list = { "themes", "terms" }
}
