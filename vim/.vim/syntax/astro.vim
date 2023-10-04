" Vim syntax file
" Language:     Astro
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Filenames:    *.astro
" Last Change:  2023 Oct 04

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

runtime! syntax/html.vim
unlet! b:current_syntax

syn include @tsx syntax/typescript.vim
unlet! b:current_syntax
syn region astroTypeScriptTop start="\%^---$" end="^\%(---\|\.\.\.\)\s*$" keepend contains=@tsx

let b:current_syntax = 'astro'
