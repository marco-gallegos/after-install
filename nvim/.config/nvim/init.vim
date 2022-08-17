" this is my latest version
" TODO: check older config '.config/init....
" NOTES
" ctrl + alt = win (cmd in mac) dot use in kitty because kitty use this hotkey
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
"       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

" pip install pynvim
" npm install tree-sitter-cli
" npm i -g yarn

set number
set mouse=a
set numberwidth=1
set clipboard=unnamed
syntax enable
set showcmd
set encoding=utf-8
set showmatch
set relativenumber
set hidden

" identation
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set pastetoggle=<F3>
set showmode
set autoread

" new
set t_Co=256
" enable this by default 
"set paste

" autocmd BufEnter * lcd %:p:h

call plug#begin('~/.config/nvim/plugged')
" Temas
Plug 'morhetz/gruvbox'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'NLKNguyen/papercolor-theme'
Plug 'sickill/vim-monokai'
Plug 'safv12/andromeda.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'rakr/vim-one'

" Plug ''

" IDE
" easymotion -> better file navigation
Plug 'easymotion/vim-easymotion'

" nerdtree
Plug 'scrooloose/nerdtree'
Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
Plug 'kyazdani42/nvim-tree.lua'

"vim tmux navigation
Plug 'christoomey/vim-tmux-navigator'

" better navbar
" Plug 'itchyny/lightline.vim'
Plug 'nvim-lualine/lualine.nvim'


" search plugins to get a better experience
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"indentation line
Plug 'yggdroot/indentline'


" COC a code sniffer
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}


" misc plugins
Plug 'mattn/emmet-vim'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
" comment easy line or all selection
Plug 'scrooloose/nerdcommenter'
" check this
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'neovim/nvim-lspconfig'
" ts npm install -g typescript typescript-language-server

"" Vim-Session
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

"" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" languages ================================================================

" go
"" Go Lang Bundle
Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}

" javascript
"" Javascript Bundle
Plug 'jelera/vim-javascript-syntax'

" php
"" PHP Bundle
Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install --no-dev -o'}
Plug 'stephpy/vim-php-cs-fixer'

" optional laravel deps
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist'
Plug 'noahfrederick/vim-composer'
Plug 'noahfrederick/vim-laravel'


" python
"" Python Bundle
Plug 'davidhalter/jedi-vim'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

" typescript
Plug 'leafgarland/typescript-vim'
Plug 'HerringtonDarkholme/yats.vim'

" BufOnly script
Plug 'vim-scripts/BufOnly.vim'

call plug#end()
" ======================================================

" to use in easy motion as trigger key: 'space'
let mapleader = " "

" easymotion plugin hotkey 'space' + 's' -> search <n> chars in all file
nmap <Leader>s <Plug>(easymotion-s2)


" <CR> is a enter
" nerdtree is a file browser
" 'space' + nt -> open nerd tree in current path
" nmap <Leader>r :NERDTreeFind<CR>
nmap <C-;>  :NvimTreeFindFileToggle<CR>
nmap <M-;>  :NvimTreeFindFileToggle<CR>

" 'space' + ntc -> close or open nerdtree (is here to close)
" nmap <Leader>nt :NERDTreeToggle<CR>
nmap <Leader>nt  :NvimTreeToggle<CR>
"nmap <leader>r :NERDTreeFind<cr>
"autocmd BufWrite * :NERDTreeFind<cr>
"autocmd BufRead * :NERDTreeFind<cr>
"autocmd BufEnter * :NERDTreeFind<cr>
" map on visualmode
vmap <C-/> <plug>NERDCommenterToggle
vmap <M-/> <plug>NERDCommenterToggle
" map on normal
nmap <C-/> <plug>NERDCommenterToggle
nmap <M-/> <plug>NERDCommenterToggle


" ctrl + P | F
nmap <C-P> :Telescope git_files hidden=true <CR>
nmap <C-F> :Telescope live_grep <CR>


" buffers next and before
nmap <C-N> :bnext<CR>
nmap <C-B> :bprev<CR>
nmap <Leader>bl :buffers<CR>
" delete current buffer
nmap <Leader>bd :bd!<CR> 
" unload buffer
nmap <Leader>bu :bw 
" go to beffer
nmap <Leader>b :buffer 
" sessions -> this uses the xolox/session
nmap <Leader>ss :SaveSession!<CR>
nmap <Leader>sns :SaveSession 
nmap <Leader>so :OpenSession!<CR>

" tab shortcuts
nmap <Leader>tc :tabnew<CR>
nmap <Leader>tn :tabnext<CR>
nmap <Leader>tb :tabprevious<CR>
nmap <Leader>tq :tabclose<CR>
" current buffer in tab
nmap <Leader>t :tabe %<CR>


" ================================================================== COC
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
"if has('nvim-0.4.0') || has('patch-8.2.0750')
  "nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  "nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  "inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  "inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  "vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  "vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
"nmap <silent> <C-s> <Plug>(coc-range-select)
"xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
"nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions.
"nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
"" Show commands.
"nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document.
"nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols.
"nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list.
"nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" ====================================================================== COC END

" ====================================================================== tags
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" ======================================================================= tags end


" general shortcut
nmap <Leader>wq :wq!<CR>
nmap <C-s> :w<CR>
nmap <C-Q> :q!<CR>
" quit all without saving
nmap <Leader>qq :qa!<CR>

nnoremap <leader>vm :vertical resize +10<CR>

" copy current file path
nnoremap <Leader>cp :let @*=expand("%")<CR>

" functions to make line change work with vim
function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction

function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif
    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction

function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif
    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction
" line exchange using ctrl + shift + up or down
noremap <silent> <s-up> :call <SID>swap_up()<CR>
noremap <silent> <s-down> :call <SID>swap_down()<CR>


" ========================================================
" plugins  configuration

let NERDTreeShowHidden=1
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeIgnore = ['^node_modules$', '\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']

" testing config
let g:NERDTreeChDirMode=2
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 40
let g:NERDTreeWinPos = "right"

" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()        
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
" autocmd BufEnter * call SyncTree()


" coc config
    let g:coc_global_extensions = [
        \ 'coc-snippets',
        \ 'coc-pairs',
        \ 'coc-tsserver',
        \ 'coc-eslint', 
        \ 'coc-prettier', 
        \ 'coc-json', 
        "\ 'coc-python',
        \ 'coc-pyright',
        \ 'coc-tabnine',
    \ ]

" let g:gruvbox_(option) = '(value)'
" colorscheme gruvbox

" let g:airline_theme='onehalfdark'
" colorscheme onehalflight
" colorscheme onehalfdark
" true colors on any theme
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set background=dark
colorscheme PaperColor

" colorscheme monokai

" set background=dark
" colorscheme andromeda

" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
" colorscheme ayu

" colorscheme one
" set background=dark " for the dark version
" set background=light " for the light version

lua << END
require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {},
		always_divide_middle = true,
		globalstatus = false,
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {'filename'},
		lualine_x = {'hostname','encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
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

-- OR setup with some options
require("nvim-tree").setup({
    auto_reload_on_write = true,
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        width = 30,
        height = 30,
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
        dotfiles = true,
    },
})

END
