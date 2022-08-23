" Vim syntax file
" Language:     Go
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Filenames:    *.go
" Last Change:  2022 May 25
" NOTE:         Based on go.vim from https://github.com/fatih/vim-go and the
"               official go.vim file.

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

syn case match

" -----------------------------------------------------------------------------
" Comments

syn match goNote display "//\s[A-Z]\{3,\}:\s"hs=s+3,he=e-2

syn match goSpecialComment display contained "//go:\w\+"hs=s+2

syn region goComment start="//" end="$" display
  \ contains=goNote,goSpecialComment,@Spell

syn region goComment start="/\*" end="\*/" contains=goNote,@Spell

hi def link goComment        Comment
hi def link goSpecialComment Keyword
hi def link goNote           Todo

" Build Constraints

syn match goBuildKeyword display contained "go:build"

syn keyword goBuildDirectives contained
  \ aix android darwin dragonfly freebsd illumos linux nacl netbsd openbsd
  \ plan9 solaris unix windows 
  \
  \ 386 amd64 amd64p32 arm arm64 arm64be armbe mips mips64 mips64le mipsle
  \ mips64p32 mips64p32le ppc ppc64 ppc64le s390 s390x sparc sparc64
  \
  \ js wasm
  \
  \ gc gccgo cgo ignore race

syn match goBuildDirectives display contained /go[1-9]\+\.\d\+/

syn region goBuildComment start="//go:build\s" end="$" display
  \ contains=goBuildKeyword,goBuildDirectives

hi def link goBuildComment    SpecialComment
hi def link goBuildKeyword    Keyword
hi def link goBuildDirectives Identifier

" -----------------------------------------------------------------------------
" Operators

" = := ++ -- <-
syn match goOperator display /:\?=\|++\|--\|<-/

" +  -  *  % 
" += -= *= %=
syn match goOperator display /[+\-*%]=\?/

" / /=
syn match goOperator display "/\(=\|\ze[^/*]\)"

" &  |  ^
" &= |= ^=
syn match goOperator display /[&|^]=\?/

" <<  >>  &^
" <<= >>= &^=
syn match goOperator display /\%(<<\|>>\|&\^\)=\?/

" <  >  !  =
" <= >= != ==
syn match goOperator display "[<>!&|^=]=\?"

" && ||
syn match goOperator display /&&\|||/

" ( ) [ ] { } . : , ; ~
syn match goOperator display /[()\[\]{}.:,;~]/

"hi def link goOperator Operator

" -----------------------------------------------------------------------------
" Keywords

syn keyword goDefine      const import type var
syn keyword goStatement   break continue defer fallthrough go goto return
syn keyword goConditional else if select switch
syn keyword goLabel       case default
syn keyword goRepeat      for range

hi def link goDefine      Define
hi def link goStatement   Statement
hi def link goConditional Conditional
hi def link goLabel       Label
hi def link goRepeat      Repeat

" Package name

syn keyword goPackage     nextgroup=goPackageName package
syn match   goPackageName display contained       /\s.\+$/hs=s+1

hi def link goPackage     Define
hi def link goPackageName Identifier

" Identifiers

syn keyword goPredefinedIdentifiers _ nil iota
syn keyword goBoolConst             true false

hi def link goPredefinedIdentifiers Identifier
hi def link goBoolConst             Boolean

syn keyword goBuiltins 
  \ append cap close complex copy delete imag len make new panic print println
  \ real recover

hi def link goBuiltins Function

runtime! syntax/go-stdlib.vim

" Types

hi def link goType Type

syn keyword goTypeBool      bool
syn keyword goTypeInt       int int8 int16 int32 int64 rune
syn keyword goTypeUInt      byte uint uint8 uint16 uint32 uint64 uintptr
syn keyword goTypeFloat     float32 float64
syn keyword goTypeComplex   complex64 complex128
syn keyword goTypeString    string
syn keyword goTypeStruct    struct
syn keyword goTypeMap       map
syn keyword goTypeInterface interface
syn keyword goTypeError     error
syn keyword goTypeGeneric   any comparable

hi def link goTypeBool      goType
hi def link goTypeInt       goType
hi def link goTypeUInt      goType
hi def link goTypeFloat     goType
hi def link goTypeComplex   goType
hi def link goTypeString    goType
hi def link goTypeStruct    goType
hi def link goTypeMap       goType
hi def link goTypeInterface goType
hi def link goTypeError     goType
hi def link goTypeGeneric   goType

syn match goTypeChannel display /\(<-\)\?chan\(<-\)\?/
syn match goTypeFunc    display /\<func\>/
syn match goDefine      display /\(^\|;\s*\)func\>/

hi def link goTypeChannel goType
hi def link goTypeFunc    goType

" -----------------------------------------------------------------------------
" Literals

runtime! syntax/go-literals.vim

" -----------------------------------------------------------------------------
" Blocks

syn region goParen start="("  end=")"  transparent fold
syn region goSqrBr start="\[" end="\]" transparent fold
syn region goBlock start="{"  end="}"  transparent fold

" -----------------------------------------------------------------------------
" Errors

syn match goDeprecatedError display "^//+build\s.\+$"

hi def link goDeprecatedError Error

syn match goInvalidSyntaxError display /\.\{4,\}/

hi def link goInvalidSyntaxError Error

syn match goSpaceError display           / \+\t/me=e-1
syn match goSpaceError display excludenl /\s\+$/

hi def link goSpaceError Error

" -----------------------------------------------------------------------------

let b:current_syntax = 'go'
