" Vim compiler file
" Compiler:     Zig Compiler
" Language:     Zig
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Filenames:    *.zig
" Last Change:  2023 Jul 26
" NOTE:         Based on the official zig.vim compiler file.

" Quit when a (custom) compiler file was already loaded
if exists('b:current_compiler')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" a subcommand must be provided for the this compiler (test, build-exe, etc)
if has('patch-7.4.191')
  CompilerSet makeprg=zig\ \$*\ \%:S
else
  CompilerSet makeprg=zig\ \$*\ \"%\"
endif

"CompilerSet errorformat=
"    \%-G#\ %.%#,
"    \%A%f:%l:%c:\ %m,
"    \%A%f:%l:\ %m,
"    \%C%*\\s%m,
"    \%-G%.%#

let b:current_compiler = 'zig'

let &cpo = s:save_cpo
unlet s:save_cpo
