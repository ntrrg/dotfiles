" Copyright 2020 Miguel Angel Rivera Notararigo. All rights reserved.
" This source code was released under the MIT license.
"
" gocover.vim: Vim syntax file for Go tests coverage.

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn case match

hi def link Normal      Comment
hi def link goCovered   DiffAdd
hi def link goUncovered DiffDelete

let b:current_syntax = "gocover"
