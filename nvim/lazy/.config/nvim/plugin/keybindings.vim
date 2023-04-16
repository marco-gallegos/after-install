let mapleader = " "
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

" <CR> is a enter
" nerdtree is a file browser
" 'space' + nt -> open nerd tree in current path
" nmap <Leader>r :NERDTreeFind<CR>
nmap <C-;>  :NvimTreeFindFileToggle<CR>
nmap <M-;>  :NvimTreeFindFileToggle<CR>

" 'space' + ntc -> close or open nerdtree (is here to close)
" nmap <Leader>nt :NERDTreeToggle<CR>
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
