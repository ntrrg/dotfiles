" Copyright 2020 Miguel Angel Rivera Notararigo. All rights reserved.
" This source code was released under the MIT license.
"
" This systax file is based on fatih/vim-go and the official go.vim file.
"
" go.vim: Vim syntax file for Go.

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn case match

" -----------------------------------------------------------------------------
" Build Constraints

syn match goBuildKeyword display contained "+build"

syn keyword goBuildDirectives contained
  \ aix android darwin dragonfly freebsd illumos linux nacl netbsd openbsd
  \ plan9 solaris windows 
  \
  \ 386 amd64 amd64p32 arm arm64 mips mips64 mips64le mipsle ppc64 ppc64le
  \ s390x
  \
  \ js wasm
  \
  \ gc gccgo cgo ignore race

syn match goBuildDirectives contained /go[1-9]\+\.\d\+/

syn region goBuildComment matchgroup=goBuildCommentStart
  \ start="//\s*+build\s"rs=s+2 end="$"
  \ contains=goBuildKeyword,goBuildDirectives

hi def link goBuildCommentStart SpecialComment
hi def link goBuildDirectives   Type
hi def link goBuildKeyword      Keyword

" -----------------------------------------------------------------------------
" Go package

syn keyword goPackage     nextgroup=goPackageName package
syn match   goPackageName contained               / \w\+/hs=s+1

hi def link goPackage     Keyword
hi def link goPackageName Identifier

" -----------------------------------------------------------------------------
" Comments

syn match   goNote /[A-Z]\{3,\}\((\w\+)\)\?:/he=e-1

hi def link goNote Todo

syn cluster goCommentGroup contains=goNote

syn region  goComment start="/\*" end="\*/" contains=@goCommentGroup,@Spell
syn region  goComment start="//" end="$"    contains=@goCommentGroup,@Spell

hi def link goComment Comment

syn region goGenerate start="^\s*//go:generate" end="$"

hi def link goGenerate Error

" -----------------------------------------------------------------------------
" Keywords

syn keyword goImport  import
syn keyword goVar     var
syn keyword goConst   const
syn keyword goDefType type

hi def link goImport  Define
hi def link goVar     Define
hi def link goConst   Define
hi def link goDefType Define

  " Operators;
" match single-char operators:          - + % < > ! & | ^ * =
" and corresponding two-char operators: -= += %= <= >= != &= |= ^= *= ==
syn match goOperator /[-+%<>!&|^*=]=\?/
" match / and /=
syn match goOperator /\/\%(=\|\ze[^/*]\)/
" match two-char operators:               << >> &^
" and corresponding three-char operators: <<= >>= &^=
syn match goOperator /\%(<<\|>>\|&^\)=\?/
" match remaining two-char operators: := && || <- ++ --
syn match goOperator /:=\|||\|<-\|++\|--/
" match ...
syn match goVarArgs  /\.\.\./

hi def link goVarArgs  goOperator
hi def link goOperator Operator

  " Builtins
syn keyword goBuiltins              append cap close complex copy delete imag len
syn keyword goBuiltins              make new panic print println real recover
syn keyword goBlank                 _
syn keyword goBoolConst             true false
syn keyword goPredefinedIdentifiers nil iota

hi def link goBuiltins              Function
hi def link goBlank                 Identifier
hi def link goBoolConst             Boolean
hi def link goPredefinedIdentifiers Boolean

  " Within functions
syn keyword goStatement   break continue defer fallthrough go goto return
syn keyword goConditional else if select switch
syn keyword goLabel       case default
syn keyword goRepeat      for range

hi def link goStatement   Statement
hi def link goConditional Conditional
hi def link goLabel       Label
hi def link goRepeat      Repeat

  " Types
syn keyword goBool         bool
syn keyword goInt          int int8 int16 int32 int64 rune
syn keyword goUnsignedInt  byte uint uint8 uint16 uint32 uint64 uintptr
syn keyword goFloat        float32 float64
syn keyword goComplex      complex64 complex128
syn keyword goString       string
syn keyword goStruct       struct
syn keyword goFunction     func
syn keyword goInterface    interface
syn keyword goMap          map
syn match   goChannel      /\(<-\)\?chan\(<-\)\?/
syn keyword goErrorType    error

hi def link goBool         goType
hi def link goInt          goType
hi def link goUnsignedInt  goType
hi def link goFloat        goType
hi def link goComplex      goType
hi def link goString       goType
hi def link goStruct       goType
hi def link goFunction     goType
hi def link goInterface    goType
hi def link goMap          goType
hi def link goChannel      goType
hi def link goErrorType    goType

hi def link goType Type

" -----------------------------------------------------------------------------
" Literals
  " Numerics
    " Integers
syn match goLiteralDecimalInt     "\<\(0\|[1-9]\(_\?\d\+\)*\)\>"
syn match goLiteralHexadecimalInt "\<0[xX]\(_\?\x\+\)\+\>"
syn match goLiteralOctalInt       "\<0[oO]\?\(_\?\o\+\)\+\>"
syn match goLiteralBinaryInt      "\<0[bB]\(_\?[01]\+\)\+\>"

hi def link goLiteralDecimalInt     goLiteralInt
hi def link goLiteralHexadecimalInt goLiteralInt
hi def link goLiteralOctalInt       goLiteralInt
hi def link goLiteralBinaryInt      goLiteralInt
hi def link goLiteralInt            Number

    " Floats
syn match goLiteralDecimalFloat     "\<\d\(_\?\d\+\)*\."
syn match goLiteralDecimalFloat     "\.\d\(_\?\d\+\)*\>"
syn match goLiteralDecimalFloat     "\.\(\d\(_\?\d\+\)*\)\?[Ee][-+]\?\d\(_\?\d\+\)*\>"
syn match goLiteralDecimalFloat     "\<\d\(_\?\d\+\)*[Ee][-+]\?\d\(_\?\d\+\)*\>"
syn match goLiteralDecimalFloat     "\<\d\(_\?\d\+\)*\.\(\d\(_\?\d\+\)*\)*\([Ee][-+]\?\d\(_\?\d\+\)*\)\?\>"
syn match goLiteralHexadecimalFloat "\<0[Xx]\.\x\(_\?\x\+\)*[Pp][-+]\?\d\(_\?\d\+\)*\>"
syn match goLiteralHexadecimalFloat "\<0[Xx]\(_\?\x\+\)\+\(\.\(\x\(_\?\x\+\)*\)*\)\?[Pp][-+]\?\d\(_\?\d\+\)*\>"

hi def link goLiteralDecimalFloat     goLiteralFloat
hi def link goLiteralHexadecimalFloat goLiteralFloat
hi def link goLiteralFloat            Float

    " Imaginaries
syn match goLiteralImaginary      "\<\(0\|[1-9]\(_\?\d\+\)*\)i\>"
syn match goLiteralImaginary      "\<0[xX]\(_\?\x\+\)\+i\>"
syn match goLiteralImaginary      "\<0[oO]\?\(_\?\o\+\)\+i\>"
syn match goLiteralImaginary      "\<0[bB]\(_\?[01]\+\)\+i\>"
syn match goLiteralImaginaryFloat "\<\d\(_\?\d\+\)*\.i"
syn match goLiteralImaginaryFloat "\.\d\(_\?\d\+\)*i\>"
syn match goLiteralImaginaryFloat "\.\(\d\(_\?\d\+\)*\)\?[Ee][-+]\?\d\(_\?\d\+\)*i\>"
syn match goLiteralImaginaryFloat "\<\d\(_\?\d\+\)*[Ee][-+]\?\d\(_\?\d\+\)*i\>"
syn match goLiteralImaginaryFloat "\<\d\(_\?\d\+\)*\.\(\d\(_\?\d\+\)*\)*\([Ee][-+]\?\d\(_\?\d\+\)*\)\?i\>"
syn match goLiteralImaginaryFloat "\<0[Xx]\.\x\(_\?\x\+\)*[Pp][-+]\?\d\(_\?\d\+\)*i\>"
syn match goLiteralImaginaryFloat "\<0[Xx]\(_\?\x\+\)\+\(\.\(\x\(_\?\x\+\)*\)*\)\?[Pp][-+]\?\d\(_\?\d\+\)*i\>"

hi def link goLiteralImaginary      Number
hi def link goLiteralImaginaryFloat Float

  " Runes and strings
syn match goEscapeChar  display contained +\\[abfnrtv\\'"]+
syn match goEscapeO     display contained "\\[0-7]\{3}"
syn match goEscapeX     display contained "\\x\x\{2}"
syn match goEscapeU     display contained "\\u\x\{4}"
syn match goEscapeBigU  display contained "\\U\x\{8}"

hi def link goEscapeChar goEscape
hi def link goEscapeO    goEscape
hi def link goEscapeX    goEscape
hi def link goEscapeU    goEscape
hi def link goEscapeBigU goEscape
hi def link goEscape     Special

syn match goEscapeInvalid display contained +\\[^0-7xuUabfnrtv\\'"]+

hi def link goEscapeInvalid goEscapeError
hi def link goEscapeError   Error

    " Runes
syn match goEscapeRuneQuote   display contained +\\"+
syn match goEscapeRuneTooMany display contained "'\(\\[^0-7xuU]\|[^\\]\)[^']\{1,\}"hs=s+1

hi def link goEscapeRuneQuote   goEscapeError
hi def link goEscapeRuneTooMany goEscapeError

syn cluster goRuneGroup contains=goEscapeChar,goEscapeO,goEscapeX,goEscapeU,goEscapeBigU,goEscapeInvalid,goEscapeRuneQuote,goEscapeRuneTooMany

syn region goLiteralRune start=+'+ skip=+\\\\\|\\'+ end=+'+ keepend contains=@goRuneGroup

hi def link goLiteralRune Character

    " Strings
syn match goEscapeStringSQ display contained +\\'+

hi def link goEscapeStringSQ goEscapeError

" [n] notation is valid for specifying explicit argument indexes
" 1. Match a literal % not preceded by a %.
" 2. Match any number of -, #, 0, space, or +
" 3. Match * or [n]* or any number or nothing before a .
" 4. Match * or [n]* or any number or nothing after a .
" 5. Match [n] or nothing before a verb
" 6. Match a formatting verb
syn match goStringFormat /\
      \%([^%]\%(%%\)*\)\
      \@<=%[-#0 +]*\
      \%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\
      \%(\.\%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\)\=\
      \%(\[\d\+\]\)\=[vTtbcdoqxXUeEfFgGspw]/ contained

hi def link goStringFormat Identifier

syn cluster goStringGroup contains=goEscapeChar,goEscapeO,goEscapeX,goEscapeU,goEscapeBigU,goEscapeInvalid,goStringFormat,goEscapeStringSQ

syn region goLiteralStringR   start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@goStringGroup,@Spell
syn region goLiteralRawString start=+`+ end=+`+ contains=goStringFormat,@Spell

hi def link goLiteralStringR   goLiteralString
hi def link goLiteralRawString goLiteralString
hi def link goLiteralString    String

" -----------------------------------------------------------------------------
" Regions

syn region goBlockR  start="{" end="}" transparent fold
syn region goParenR  start='(' end=')' transparent

" -----------------------------------------------------------------------------
" Errors

syn match goSpaceError display " \+\t"me=e-1
syn match goSpaceError display excludenl "\s\+$"

hi def link goSpaceError Error

" -----------------------------------------------------------------------------

runtime! syntax/go-extras.vim

" Search backwards for a global declaration to start processing the syntax.
"syn sync match goSync grouphere NONE /^\(const\|var\|type\|func\)\>/

" There's a bug in the implementation of grouphere. For now, use the
" following as a more expensive/less precise workaround.
syn sync minlines=500

let b:current_syntax = "go"
