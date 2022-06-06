" Vim syntax file
" Language:     Go HTML template
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Filenames:    *.gohtml
" Last Change:  2022 Jun 05

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

runtime! syntax/gotmpl.vim
unlet! b:current_syntax

runtime! syntax/html.vim
unlet! b:current_syntax

syn cluster htmlPreproc add=goTmplAction,goTmplComment

let b:current_syntax = 'gohtml'
