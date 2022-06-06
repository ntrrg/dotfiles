" Vim syntax file
" Language:     Go
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Filenames:    go.mod
" Last Change:  2022 May 30
" NOTE:         Go modules. Based on gomod.vim from https://github.com/fatih/vim-go.

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

syn case match

syn include @goModName syntax/gomod-name.vim
syn include @goModVersion syntax/gomod-semver.vim

" -----------------------------------------------------------------------------
" Comments

syn region gomodComment start="//" end="$" display contains=@Spell

hi def link gomodComment Comment

" -----------------------------------------------------------------------------
" Module

syn keyword gomodModule  contained         module
syn match   gomodModuleN display contained /\s.\+$/hs=s+1

hi def link gomodModule  Keyword
hi def link gomodModuleN Identifier

syn region gomodModuleInline start="^module\s" end="$" transparent display
  \ keepend contains=gomodComment,gomodModule,gomodModuleN

" -----------------------------------------------------------------------------
" Go version

syn keyword gomodGoVersion  contained         go
syn match   gomodGoVersionN display contained /\s\d\+\(\.\d\+\)*/hs=s+1

hi def link gomodGoVersion  Keyword
hi def link gomodGoVersionN Float

syn region gomodGoInline start="^go\s" end="$" transparent display
  \ contains=gomodComment,gomodGoVersion,gomodGoVersionN

" -----------------------------------------------------------------------------
" Directives

" Require

syn keyword gomodRequire contained require

hi def link gomodRequire Keyword

" ( )
syn match gomodRequireOperator display contained /(\|)/

hi def link gomodRequireOperator Operator

syn region gomodRequireInline start="^require\s\+[^(]" end="$" transparent
  \ display keepend contains=gomodComment,gomodRequire,@goModName,@goModVersion

syn region gomodRequireBlock start="^require\s*(" end=")" transparent fold
  \ keepend contains=gomodComment,gomodRequire,gomodRequireOperator,@goModName,@goModVersion

" Exclude

syn keyword gomodExclude contained exclude

hi def link gomodExclude Keyword

" ( )
syn match gomodExcludeOperator display contained /(\|)/

hi def link gomodExcludeOperator Operator

syn region gomodExcludeInline start="^exclude\s\+[^(]" end="$" transparent
  \ display keepend contains=gomodComment,gomodExclude,@goModName,@goModVersion

syn region gomodExcludeBlock start="^exclude\s*(" end=")" transparent fold
  \ keepend contains=gomodComment,gomodExclude,gomodExcludeOperator,@goModName,@goModVersion

" Replace

syn keyword gomodReplace contained replace

hi def link gomodReplace Keyword

" ( ) =>
syn match gomodReplaceOperator display contained /(\|)\|=>/

hi def link gomodReplaceOperator Operator

syn region gomodReplaceInline start="^replace\s\+[^(]" end="$" transparent
  \ display keepend contains=gomodComment,gomodReplace,gomodReplaceOperator,@goModName,@goModVersion

syn region gomodReplaceBlock start="^replace\s*(" end=")" transparent fold
  \ keepend contains=gomodComment,gomodReplace,gomodReplaceOperator,@goModName,@goModVersion

" Reract

syn keyword gomodReract contained retract

hi def link gomodReract Keyword

" ( ) [ ] ,
syn match gomodRetractOperator display contained /(\|)\|\[\|\]\|,/

hi def link gomodRetractOperator Operator

syn region gomodRetractInline start="^retract\s\+[^(]" end="$" transparent
  \ display keepend contains=gomodComment,gomodReract,gomodRetractOperator,@goModVersion

syn region gomodRetractBlock start="^retract\s*(" end=")" transparent fold
  \ keepend contains=gomodComment,gomodReract,gomodRetractOperator,@goModVersion

" -----------------------------------------------------------------------------

let b:current_syntax = 'gomod'
