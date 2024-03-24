set number
set mouse=a
set numberwidth=1
"set clipboard=unnamed  " deprecated
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


"TODO: clipboard configuration needs improvemnt
"set clipboard=unnamed
set clipboard+=unnamedplus


" new
set t_Co=256

filetype plugin on

" theme

" colorscheme onedark

"colorscheme monokai

" Important!!
if has('termguicolors')
  set termguicolors
endif


let g:loaded_perl_provider = 0

" NOTE: theme migrated to lua config fle lua/plugins/theme.lua
" The configuration options should be placed before `colorscheme edge`.
" let g:edge_style = 'neon' " aura | neon | aura dim | light | none
" let g:edge_better_performance = 1
" colorscheme edge
"

" toggle relative numbers
"autocmd InsertEnter * : bufdo norelativenumber
"autocmd InsertLeave * : bufdo relativenumber
autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
