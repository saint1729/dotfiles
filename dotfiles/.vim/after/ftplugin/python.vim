" vim:foldmethod=marker:fen:
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


let s:opt = tyru#util#undo_ftplugin_helper#new()

" TODO: Do not re-indent when comment inserted.
call s:opt.append('comments', 'b:#')

" http://vim.wikia.com/wiki/Omnicomplete_-_Remove_Python_Pydoc_Preview_Window
call s:opt.remove('completeopt', 'preview')

let b:undo_ftplugin = s:opt.make_undo_ftplugin()


let &cpo = s:save_cpo
