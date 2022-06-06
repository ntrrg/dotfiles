" Vim syntax file
" Language:     Go template
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Filenames:    *.gotmpl,*.gotxt,*.tmpl
" Last Change:  2022 Jun 05
" NOTE:         Based on the official gotexttmpl.vim file.

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

syn case match

" -----------------------------------------------------------------------------
" Comments

syn region goTmplComment start="{{\(- \)\?/\*" end="\*/\( -\)\?}}"

hi def link goTmplComment Comment

" -----------------------------------------------------------------------------
" Operators

" {{ {{- }} -}} ( )
syn match goTmplOperator display contained /{{-\?\|-\?}}\|(\|)/

" = := .
syn match goTmplOperator display contained /:\?=\|\./

hi def link goTmplOperator Operator

syn cluster goTmplSyntax contains=goTmplOperator

" -----------------------------------------------------------------------------
" Keywords

syn keyword goTmplDefine contained define template block

hi def link goTmplDefine Define

syn cluster goTmplSyntax add=goTmplDefine

" Identifiers

syn keyword goTmplPredefinedIdentifiers contained nil

hi def link goTmplPredefinedIdentifiers Boolean

syn cluster goTmplSyntax add=goTmplPredefinedIdentifiers

syn keyword goTmplBuiltins contained
  \ and call eq ge gt html index js le len lt ne not or print printf println
  \ slice urlquery

hi def link goTmplBuiltins Function

syn cluster goTmplSyntax add=goTmplBuiltins

syn keyword goTmplConditional contained else if with
syn keyword goTmplRepeat      contained range
syn keyword goTmplStatement   contained end

hi def link goTmplConditional Conditional
hi def link goTmplRepeat      Repeat
hi def link goTmplStatement   Statement

syn cluster goTmplSyntax add=goTmplConditional,goTmplRepeat,goTmplStatement

" -----------------------------------------------------------------------------
" Literals

syn include @goLiterals syntax/go-literals.vim

syn cluster goTmplSyntax add=@goLiterals

" -----------------------------------------------------------------------------
" Regions

syn region goTmplAction start="{{" end="}}" keepend contains=@goTmplSyntax

" -----------------------------------------------------------------------------

let b:current_syntax = 'gotmpl'
