" Vim syntax file
" Language:     Go
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Filenames:    go.sum
" Last Change:  2022 May 30
" NOTE:         Go modules summary. Based on gosum.vim from https://github.com/fatih/vim-go.

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

syn case match

" -----------------------------------------------------------------------------
" Module name

syn include @goModName syntax/gomod-name.vim

syn region gosumEntryName start="^" end="\s"me=e-1 transparent display keepend
  \ contains=@goModName

" -----------------------------------------------------------------------------
" Module version

syn include @goModVersion syntax/gomod-semver.vim

syn region gosumEntryVersion start="\s" end="\s"me=e-1 transparent display
  \ keepend contains=@goModVersion

" -----------------------------------------------------------------------------
" Module hash

syn match gosumHashAlgo display contained /\s\(h1\)/
syn match gosumHash     display contained ":[A-Za-z0-9+/=]\+$"hs=s+1

hi def link gosumHashAlgo Define
hi def link gosumHash     Number

syn region gosumEntryHash start="\s\(h1\)" end="$" transparent display keepend
  \ contains=gosumHashAlgo,gosumHash

" -----------------------------------------------------------------------------

let b:current_syntax = 'gosum'
