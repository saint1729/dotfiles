" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Document {{{
"==================================================
" Name: <% eval: expand('%:t:r') %>
" Version: 0.0.0
" Author:  tyru <tyru.exe@gmail.com>
" Last Change: 2009-09-29.
"
" Description:
"   NO DESCRIPTION YET
"
" Change Log: {{{
" }}}
" Usage: {{{
"   Commands: {{{
"   }}}
"   Mappings: {{{
"   }}}
"   Global Variables: {{{
"   }}}
" }}}
"==================================================
" }}}

" Load Once {{{
if exists('g:loaded_<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>') && g:loaded_<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%> != 0
    finish
endif
let g:loaded_<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%> = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Scope Variables {{{
" }}}
" Global Variables {{{
" }}}

" Functions {{{

" Debug {{{
if g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug
    let s:debug_errmsg = []

    func! s:debug(cmd, ...)
        if a:cmd ==# 'on'
            let g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug = 1
        elseif a:cmd ==# 'off'
            let g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug = 0
        elseif a:cmd ==# 'msg'
            for i in s:debug_errmsg
                echo i
            endfor
        elseif a:cmd ==# 'eval'
            redraw
            execute join(a:000, ' ')
        endif
    endfunc

    com! -nargs=+ SDDebug
        \ call s:debug(<f-args>)
endif

" s:debugmsg {{{
func! s:debugmsg(...)
    if g:<%eval:substitute(expand("%:t:r"), "\\m\\W", "_", "g")%>_debug
        call s:apply('s:warn', a:000)
    endif
endfunc
" }}}

" }}}

" s:warn {{{
func! s:warn(...)
    if a:0 == 0
        return
    elseif a:0 == 1
        let msg = a:1
    else
        let msg = s:apply('printf', a:000)
    endif

    echohl WarningMsg
    echo msg
    sleep 1
    redraw
    echohl None

    call add(s:debug_errmsg, msg)
endfunc
" }}}

" s:apply {{{
func! s:apply(funcname, args)
    let args_str = ''
    let i = 0
    let arg_len = len(a:args)
    while i < arg_len
        if i ==# 0
            let args_str = printf('a:args[%d]', i)
        else
            let args_str .= ', '.printf('a:args[%d]', i)
        endif
        let i += 1
    endwhile

    return eval(printf('%s(%s)', a:funcname, args_str))
endfunc
" }}}

" s:uneval {{{
func! s:uneval(expr)
    let expr = a:expr

    if type(expr) == type(0)
        return expr + 0

    elseif type(expr) == type("")
        " how ugly
        let table = [
            \ 'n',
            \ 't'
        \ ]
        let expr = substitute(expr, '\', escape('\\', '\'), 'g')
        let expr = substitute(expr, '"', escape('\"', '\'), 'g')
        for i in table
            let pat = eval(printf('"\%s"', i))
            let sub = eval(printf('"\\%s"', i))
            " "\n" -> '\n'
            let expr = substitute(expr, pat, escape(sub, '\'), 'g')
        endfor
        let expr = '"'.expr.'"'
        return expr
        " return printf('"%s"', escape(expr, "\n\t\"\\"))

    elseif type(expr) == type(function('tr'))
        return printf("function('%s')", string(expr))

    elseif type(expr) == type([])
        let lis = map(copy(expr), 's:uneval(v:val)')
        return '['.join(lis, ',').']'

    elseif type(expr) == type({})
        let keys = keys(expr)
        let pairs = map(keys, 's:uneval(copy(v:val)).":".s:uneval(copy(expr[v:val]))')
        return '{'.join(pairs, ',').'}'

    else
        let v:errmsg = printf('undefined type number '.type(expr))
    endif
endfunc
" }}}

" }}}

" Commands {{{
" }}}
" Mappings {{{
" }}}
" Autocmd {{{
" }}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
