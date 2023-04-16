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

filetype plugin on

" theme

" colorscheme onedark

"colorscheme monokai

" Important!!
if has('termguicolors')
  set termguicolors
endif

" NOTE: theme migrated to lua config fle lua/plugins/theme.lua
" The configuration options should be placed before `colorscheme edge`.
" let g:edge_style = 'neon' " aura | neon | aura dim | light | none
" let g:edge_better_performance = 1
" colorscheme edge
