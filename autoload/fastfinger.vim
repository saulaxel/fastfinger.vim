" ==============================================================================
" File: autoload/fastfinger.vim
" Description: Defines the interface for creating fastfinger sub-modes
" Author: Saul Axel <saulaxel.50@gmail.com>
" ==============================================================================
scriptencoding utf-8

" Utility {{{1
function! s:ErrorMsg(message) abort   " {{{2
    echohl ErrorMsg
    echo '[Fastfinger]' a:message
    echohl Normal
endfunction

function! s:CompareKeys(a, b) abort
    if strlen(a:a) != strlen(a:b)
        return strlen(a:a) - strlen(a:b)
    endif
    return (a:a < a:b ? -1 : a:a > a:b ? 1 : 0)
endfunction

function! s:KeysAsString(mode_maps) abort   " {{{2
    let rv = ''
    let lhs_keys = keys(a:mode_maps)
    for i in range(len(lhs_keys))
        if &encoding =~# '^u'
            let lhs_keys[i] = substitute(lhs_keys[i], '\c\(Left\|<Left>\)', '←', '')
            let lhs_keys[i] = substitute(lhs_keys[i], '\c\(Right\|<Right>\)', '→', '')
            let lhs_keys[i] = substitute(lhs_keys[i], '\c\(Up\|<Up>\)', '↑', '')
            let lhs_keys[i] = substitute(lhs_keys[i], '\c\(Down\|<Down>\)', '↓', '')
        endif

        if lhs_keys[i] =~? '<C-.*>' && strchars(lhs_keys[i][3:-2]) == 1
            let lhs_keys[i] = substitute(lhs_keys[i], '\c<C-\(.*\)>', '^\1', '')
        endif
    endfor

    let ordered_lhs = sort(lhs_keys, function('s:CompareKeys'))
    let length = len(ordered_lhs)
    for i in range(length)
        let rv .= ordered_lhs[i]
        if i != length - 1
            let rv .= ' '
        endif
    endfor
    return rv
endfunction

function! s:ValidMappings(mode_maps) abort   " {{{2
    for lhs in keys(a:mode_maps)
        if lhs =~# '^<.*>$' && matchstr(lhs, '^<.\{-}\(<\|>\)\=>') ==# lhs
            if lhs =~? '<\%(A\|M\)-.*>'
                call s:ErrorMsg('Meta keys not supported')
                return 0
            endif
        elseif strchars(lhs) != 1
            call s:ErrorMsg('Lhs "' . lhs . '"must be single a single keystroke')
            return 0
        endif
    endfor
    return 1
endfunction

function! s:NormalizeMappings(mode_maps) abort   " {{{2
    let normalized = {}

    for lhs in keys(a:mode_maps)
        if lhs =~? '^<.*>$'
            let normalized[eval('"\' . lhs . '"')] = a:mode_maps[lhs]
        else
            let normalized[lhs] = a:mode_maps[lhs]
        endif
    endfor
    return normalized
endfunction

" Functionality {{{1
let s:modes = {}

function! s:EnterFastfingerMode(name, key) abort   " {{{2
    silent execute 'normal!' s:modes[a:name].enter_maps[a:key]

    call s:ModeLoop(a:name)
endfunction
let s:start_function_name = matchstr(string(function('s:EnterFastfingerMode')),
                                   \ '<SNR>\w\+')

function! s:ModeLoop(name) abort   " {{{2
    let maps = s:modes[a:name].mode_maps
    let times  = 0

    let message   = substitute(
                  \ substitute(g:fastfinger_message_format,
                  \            '<mode>', a:name, 'g'),
                  \            '<keys>', s:modes[a:name].keys, 'g')

    redraw | echo message

    let no_keypress_count = 0
    while no_keypress_count < 100 * g:fastfinger_seconds_to_leave
        let key = getchar(0)

        if key
            let char = (type(key) == type(0)) ? nr2char(key) : key

            if has_key(maps, char)
                let [i, n] = [0, times ? times : 1]
                while i < n
                    silent execute 'normal!' maps[char]
                    let i += 1
                endwhile

                redraw | echo message
                let no_keypress_count = 0
                let times = 0
            elseif char =~# '\d'
                let times = times * 10 + char
            else
                let command = (type(key) == type(0)) ? nr2char(key) : key
                call feedkeys((times ? times : 1) . command)
                break
            endif
        endif

        sleep 10m
        let no_keypress_count += 1
    endwhile

    echo '' | redraw
endfunction

" Interface {{{1
function! fastfinger#CreateMode(mode_name, enter_maps, mode_maps) abort   " {{{ 2
    let s:modes[a:mode_name] = {}

    if s:ValidMappings(a:mode_maps)
        let s:modes[a:mode_name] = {}
        let s:modes[a:mode_name].keys = s:KeysAsString(a:mode_maps)
    else
        return
    endif

    let s:modes[a:mode_name].enter_maps = a:enter_maps

    for lhs in keys(a:enter_maps)
        let lhs = substitute(lhs, '|', '<bar>', 'g')
        let rhs = substitute(lhs, '<', '<lt>', 'g')

        execute 'nnoremap <silent>' lhs ':call' . s:start_function_name
            \ . ("('" . a:mode_name . "', '" . rhs . "')<CR>")
    endfor

    let s:modes[a:mode_name].mode_maps = s:NormalizeMappings(a:mode_maps)
endfunction

" End {{{1
" vim:tw=80:et:ts=4:sts=4:sw=4:fdm=marker:spell:spl=en
