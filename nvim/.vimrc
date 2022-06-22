" this is my latest version
" TODO: check older config '.config/init....
" NOTES
" ctrl + alt = win (cmd in mac) dot use in kitty because kitty use this hotkey
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
"       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" pip install pynvim
" 

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

" new
set t_Co=256


" autocmd BufEnter * lcd %:p:h

call plug#begin('~/.vim/plugged')
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

"vim tmux navigation
Plug 'christoomey/vim-tmux-navigator'

" better navbar
Plug 'itchyny/lightline.vim'


"indentation line
Plug 'yggdroot/indentline'


" COC a code sniffer
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}


" misc plugins
Plug 'mattn/emmet-vim'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

"" Vim-Session
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

"" Snippets
" Plug 'SirVer/ultisnips'
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
Plug 'symfony/symfony'

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

" easymotion plugin hotkey 'space' + 's' -> search 2 chars in all file
nmap <Leader>s <Plug>(easymotion-s7)


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
nmap <Leader>ss :SaveSession<CR>
nmap <Leader>sns :SaveSession 
nmap <Leader>so :OpenSession<CR>

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
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" COC code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <F2> <Plug>(coc-rename)

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor. TODO:check is not working
autocmd CursorHold * silent call CocActionAsync('highlight')

" ====================================================================== COC END

" general shortcut
nmap <Leader>wq :wq!<CR>
nmap <Leader>w :w<CR>
nmap <Leader>q :q!<CR>
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
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '\.swp$', '\.bak$', '\~$']
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
        \ 'coc-pairs',
        \ 'coc-tsserver',
        \ 'coc-eslint', 
        \ 'coc-prettier', 
        \ 'coc-json', 
        \ 'coc-python',
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

" set background=dark
" colorscheme PaperColor

colorscheme monokai

" set background=dark
" colorscheme andromeda

" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
" colorscheme ayu

" colorscheme one
" set background=dark " for the dark version
" set background=light " for the light version
