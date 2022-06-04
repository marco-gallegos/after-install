" this is my latest version
" TODO: check older confid '.config/init....'
" NOTES
" pip install pynvim

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
set autoindent
set smartindent


call plug#begin('~/.vim/plugged')
" Temas
Plug 'morhetz/gruvbox'

" IDE
" easymotion -> better file navigation
Plug 'easymotion/vim-easymotion'

" nerdtree
Plug 'scrooloose/nerdtree'

"vim tmux navigation
Plug 'christoomey/vim-tmux-navigator'


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


call plug#end()
" ======================================================

" to use in easy motion as trigger key: 'space'
let mapleader = " "

" easymotion plugin hotkey 'space' + 's' -> search 2 chars in all file
nmap <Leader>s <Plug>(easymotion-s2)


" <CR> is a enter
" nerdtree is a file browser
" 'space' + nt -> open nerd tree in current path
nmap <Leader>r :NERDTreeFind<CR>

" 'space' + ntc -> close or open nerdtree (is here to close)
nmap <Leader>nt :NERDTreeToggle<CR>
"nmap <leader>r :NERDTreeFind<cr>
"autocmd BufWrite * :NERDTreeFind<cr>
"autocmd BufRead * :NERDTreeFind<cr>
"autocmd BufEnter * :NERDTreeFind<cr>


" ctrl + P | F
nmap <C-P> :Telescope git_files hidden=true <CR>
nmap <C-F> :Telescope live_grep <CR>


" buffers next and before
nnoremap <C-N> :bnext<CR>
nnoremap <C-B> :bprev<CR>

" COC code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <F2> <Plug>(coc-rename)

" general shortcut
nmap <Leader>wq :wq!<CR>
nmap <Leader>w :w<CR>
nmap <Leader>q :q!<CR>

nnoremap <Leader>cp :let @*=expand("%")<CR>

" ========================================================
" plugins  configuration

let NERDTreeShowHidden=1
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeIgnore = ['^node_modules$']
"colorscheme codedark


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
  \ 'coc-python',
  \ ]

"let g:gruvbox_(option) = '(value)'
colorscheme gruvbox
