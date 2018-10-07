" ==============================================================================
" File: autoload/fastfinger.vim
" Description: Defines several built-in submodes for fast repeating common
" Author: Saul Axel <saulaxel.50@gmail.com>
" ==============================================================================
if exists('g:fastfinger_loaded')
    finish
endif
let g:fastfinger_loaded = 1

" Configuration variables {{{1
let g:fastfinger_enabled          = get(g:, 'fastfinger_enabled', 1)
let g:fastfinger_seconds_to_leave = get(g:, 'fastfinger_seconds_to_leave', 5)
let g:fastfinger_message_format   = get(g:, 'fastfinger_message_format',
                                          \ '-- <mode> mode (<keys>)')

" Auxiliary {{{1
function! s:Enabled(submode) abort
    if type(g:fastfinger_enabled) == type({})
        return g:fastfinger_enabled[a:submode]
    endif
    return g:fastfinger_enabled
endfunction

" Defining submodes {{{1
if s:Enabled('tab')
    let s:enter_maps = { '<leader>tm': ':' }
    let s:mode_maps = {
    \   'k': ":tabnext \<CR>" , '<Up>'   : ":tabnext \<CR>" , 't': 'gt',
    \   'j': ":tabprev \<CR>" , '<Down>' : ":tabprev \<CR>" , 'T': 'gT',
    \   'h': ":tabfirst \<CR>", '<Left>' : ":tabfirst \<CR>",
    \   'l': ":tablast \<CR>" , '<Right>': ":tablast \<CR>" ,
    \   '-': ":tabmove -\<CR>", '<C-Up>'   : ":tabmove -\<CR>",
    \   '+': ":tabmove +\<CR>", '<C-Down>' : ":tabmove +\<CR>",
    \   '0': ":tabmove 0\<CR>", '<C-Left>' : ":tabmove 0\<CR>",
    \   '$': ":tabmove $\<CR>", '<C-Right>': ":tabmove $\<CR>",
    \}

    call fastfinger#CreateMode('Tab', s:enter_maps, s:mode_maps)
endif

if s:Enabled('buf')
    let s:enter_maps = {
    \   '<leader>bm': ':'
    \}
    let s:mode_maps = {
    \   'k': ":bnext \<CR>", '<Up>'   : ":bnext \<CR>" ,
    \   'j': ":bprev \<CR>", '<Down>' : ":bprev \<CR>" ,
    \   'h': ":bfirst\<CR>", '<Left>' : ":bfirst\<CR>",
    \   'l': ":blast \<CR>", '<Right>': ":blast \<CR>" ,
    \}

    call fastfinger#CreateMode('Buffer', s:enter_maps, s:mode_maps)
endif

if s:Enabled('win_traverse')
    let s:enter_maps = {
    \   '<C-w>k': ":wincmd k\<CR>", '<C-w><C-k>': ":wincmd k\<CR>", '<C-w><Up>'   : ":wincmd k\<CR>",
    \   '<C-w>j': ":wincmd j\<CR>", '<C-w><C-j>': ":wincmd j\<CR>", '<C-w><Down>' : ":wincmd j\<CR>",
    \   '<C-w>h': ":wincmd h\<CR>", '<C-w><C-h>': ":wincmd h\<CR>", '<C-w><Left>' : ":wincmd h\<CR>",
    \   '<C-w>l': ":wincmd l\<CR>", '<C-w><C-l>': ":wincmd l\<CR>", '<C-w><Right>': ":wincmd l\<CR>",
    \   '<C-w>w': ":wincmd w\<CR>", '<C-w><C-w>': ":wincmd w\<CR>",
    \   '<C-w>W': ":wincmd W\<CR>",
    \   '<C-w>t': ":wincmd t\<CR>", '<C-w><C-t>': ":wincmd t\<CR>",
    \   '<C-w>b': ":wincmd b\<CR>", '<C-w><C-b>': ":wincmd b\<CR>",
    \   '<C-w>p': ":wincmd p\<CR>", '<C-w><C-p>': ":wincmd p\<CR>",
    \   '<C-w>P': ":wincmd P\<CR>",
    \}
    let s:mode_maps = {
    \   '<C-k>': ":wincmd k\<CR>", '<Up>'   : ":wincmd k\<CR>",
    \   '<C-j>': ":wincmd j\<CR>", '<Down>' : ":wincmd j\<CR>",
    \   '<C-h>': ":wincmd h\<CR>", '<Left>' : ":wincmd h\<CR>",
    \   '<C-l>': ":wincmd l\<CR>", '<Right>': ":wincmd l\<CR>",
    \   'w': ":wincmd w\<CR>", '<C-w>': ":wincmd w\<CR>",
    \   'W': ":wincmd W\<CR>",
    \   't': ":wincmd t\<CR>", '<C-t>': ":wincmd t\<CR>",
    \   'b': ":wincmd b\<CR>", '<C-b>': ":wincmd b\<CR>",
    \   'p': ":wincmd p\<CR>", '<C-p>': ":wincmd p\<CR>",
    \   'P': ":wincmd P\<CR>",
    \}

    call fastfinger#CreateMode('Window traverse', s:enter_maps, s:mode_maps)
endif

if s:Enabled('win_move')
    let s:enter_maps = {
    \   '<C-w>r': ":wincmd r\<CR>", '<C-w><C-r>': ":wincmd r\<CR>",
    \   '<C-w>R': ":wincmd R\<CR>",
    \   '<C-w>x': ":wincmd x\<CR>", '<C-w><C-x>': ":wincmd x\<CR>",
    \   '<C-w>K': ":wincmd K\<CR>",
    \   '<C-w>J': ":wincmd J\<CR>",
    \   '<C-w>H': ":wincmd H\<CR>",
    \   '<C-w>L': ":wincmd L\<CR>",
    \}
    let s:mode_maps = {
    \   'r': ":wincmd r\<CR>", '<C-r>': ":wincmd r\<CR>",
    \   'R': ":wincmd R\<CR>",
    \   'x': ":wincmd x\<CR>", '<C-x>': ":wincmd x\<CR>",
    \   'K': ":wincmd K\<CR>", '<Up>'   : ":wincmd K\<CR>",
    \   'J': ":wincmd J\<CR>", '<Down>' : ":wincmd J\<CR>",
    \   'H': ":wincmd H\<CR>", '<Left>' : ":wincmd H\<CR>",
    \   'L': ":wincmd L\<CR>", '<Right>': ":wincmd L\<CR>",
    \}

    call fastfinger#CreateMode('Window move', s:enter_maps, s:mode_maps)
endif

if s:Enabled('win_res')
    let s:enter_maps = {
    \   '<C-w>-': ":wincmd -\<CR>",
    \   '<C-w>+': ":wincmd +\<CR>",
    \   '<C-w><': ":wincmd <\<CR>",
    \   '<C-w>>': ":wincmd >\<CR>",
    \   '<C-w>=': ":wincmd =\<CR>",
    \   '<C-w>_': ":wincmd _\<CR>",
    \   '<C-w>|': ":wincmd |\<CR>",
    \}
    let s:mode_maps = {
    \   '-': ":wincmd -\<CR>",
    \   '+': ":wincmd +\<CR>",
    \   '<': ":wincmd <\<CR>",
    \   '>': ":wincmd >\<CR>",
    \   '=': ":wincmd =\<CR>",
    \   '_': ":wincmd _\<CR>",
    \   '|': ":wincmd |\<CR>",
    \}

    call fastfinger#CreateMode('Window resize', s:enter_maps, s:mode_maps)
endif
unlet s:enter_maps
unlet s:mode_maps

" End {{{1
" vim:tw=80:et:ts=4:sts=4:sw=4:fdm=marker:spell:spl=en
