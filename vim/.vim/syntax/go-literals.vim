" Vim syntax file
" Language:     Go
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Last Change:  2022 Jun 01
" NOTE:         Literal types.

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

syn case match

" -----------------------------------------------------------------------------
" Integers

syn match goLiteralDecimalInt     display "\<\(0\|[1-9]\(_\?\d\+\)*\)\>"
syn match goLiteralHexadecimalInt display "\<0[xX]\(_\?\x\+\)\+\>"
syn match goLiteralOctalInt       display "\<0[oO]\?\(_\?\o\+\)\+\>"
syn match goLiteralBinaryInt      display "\<0[bB]\(_\?[01]\+\)\+\>"

hi def link goLiteralDecimalInt     goLiteralInt
hi def link goLiteralHexadecimalInt goLiteralInt
hi def link goLiteralOctalInt       goLiteralInt
hi def link goLiteralBinaryInt      goLiteralInt
hi def link goLiteralInt            Number

" -----------------------------------------------------------------------------
" Floats

syn match goLiteralDecimalFloat     display "\<\d\(_\?\d\+\)*\."
syn match goLiteralDecimalFloat     display "\.\d\(_\?\d\+\)*\>"
syn match goLiteralDecimalFloat     display "\.\(\d\(_\?\d\+\)*\)\?[Ee][-+]\?\d\(_\?\d\+\)*\>"
syn match goLiteralDecimalFloat     display "\<\d\(_\?\d\+\)*[Ee][-+]\?\d\(_\?\d\+\)*\>"
syn match goLiteralDecimalFloat     display "\<\d\(_\?\d\+\)*\.\(\d\(_\?\d\+\)*\)*\([Ee][-+]\?\d\(_\?\d\+\)*\)\?\>"
syn match goLiteralHexadecimalFloat display "\<0[Xx]\.\x\(_\?\x\+\)*[Pp][-+]\?\d\(_\?\d\+\)*\>"
syn match goLiteralHexadecimalFloat display "\<0[Xx]\(_\?\x\+\)\+\(\.\(\x\(_\?\x\+\)*\)*\)\?[Pp][-+]\?\d\(_\?\d\+\)*\>"

hi def link goLiteralDecimalFloat     goLiteralFloat
hi def link goLiteralHexadecimalFloat goLiteralFloat
hi def link goLiteralFloat            Float

" -----------------------------------------------------------------------------
" Imaginaries

syn match goLiteralImaginary      display "\<\(0\|[1-9]\(_\?\d\+\)*\)i\>"
syn match goLiteralImaginary      display "\<0[xX]\(_\?\x\+\)\+i\>"
syn match goLiteralImaginary      display "\<0[oO]\?\(_\?\o\+\)\+i\>"
syn match goLiteralImaginary      display "\<0[bB]\(_\?[01]\+\)\+i\>"
syn match goLiteralImaginaryFloat display "\<\d\(_\?\d\+\)*\.i"
syn match goLiteralImaginaryFloat display "\.\d\(_\?\d\+\)*i\>"
syn match goLiteralImaginaryFloat display "\.\(\d\(_\?\d\+\)*\)\?[Ee][-+]\?\d\(_\?\d\+\)*i\>"
syn match goLiteralImaginaryFloat display "\<\d\(_\?\d\+\)*[Ee][-+]\?\d\(_\?\d\+\)*i\>"
syn match goLiteralImaginaryFloat display "\<\d\(_\?\d\+\)*\.\(\d\(_\?\d\+\)*\)*\([Ee][-+]\?\d\(_\?\d\+\)*\)\?i\>"
syn match goLiteralImaginaryFloat display "\<0[Xx]\.\x\(_\?\x\+\)*[Pp][-+]\?\d\(_\?\d\+\)*i\>"
syn match goLiteralImaginaryFloat display "\<0[Xx]\(_\?\x\+\)\+\(\.\(\x\(_\?\x\+\)*\)*\)\?[Pp][-+]\?\d\(_\?\d\+\)*i\>"

hi def link goLiteralImaginary      Number
hi def link goLiteralImaginaryFloat Float

" -----------------------------------------------------------------------------
" Runes and strings

syn match goLiteralEscapeChar display contained +\\[abfnrtv\\'"]+
syn match goLiteralEscapeO    display contained "\\[0-7]\{3}"
syn match goLiteralEscapeX    display contained "\\x\x\{2}"
syn match goLiteralEscapeU    display contained "\\u\x\{4}"
syn match goLiteralEscapeBigU display contained "\\U\x\{8}"

hi def link goLiteralEscapeChar goLiteralEscape
hi def link goLiteralEscapeO    goLiteralEscape
hi def link goLiteralEscapeX    goLiteralEscape
hi def link goLiteralEscapeU    goLiteralEscape
hi def link goLiteralEscapeBigU goLiteralEscape
hi def link goLiteralEscape     Special

syn match goLiteralEscapeInvalid display contained +\\[^0-7xuUabfnrtv\\'"]+

hi def link goLieralEscapeInvalid goLiteralEscapeError
hi def link goLieralEscapeError   Error

syn match goLiteralEscapeRuneQuote   display contained +\\"+
syn match goLiteralEscapeRuneTooMany display contained "'\(\\[^0-7xuU]\|[^\\]\)[^']\{1,\}"hs=s+1

hi def link goLiteralEscapeRuneQuote   goLiteralEscapeError
hi def link goLiteralEscapeRuneTooMany goLiteralEscapeError

syn cluster goLiteralRuneGroup contains=goLiteralEscapeChar,goLiteralEscapeO,goLiteralEscapeX,goLiteralEscapeU,goLiteralEscapeBigU,goLiteralEscapeInvalid,goLiteralEscapeRuneQuote,goLiteralEscapeRuneTooMany

syn region goLiteralRune start=+'+ skip=+\\\\\|\\'+ end=+'+ keepend
  \ contains=@goLiteralRuneGroup

hi def link goLiteralRune Character

syn match goLiteralEscapeStringSQ display contained +\\'+

hi def link goLiteralEscapeStringSQ goLiteralEscapeError

" [n] notation is valid for specifying explicit argument indexes
" 1. Match a literal % not preceded by a %.
" 2. Match any number of -, #, 0, space, or +
" 3. Match * or [n]* or any number or nothing before a .
" 4. Match * or [n]* or any number or nothing after a .
" 5. Match [n] or nothing before a verb
" 6. Match a formatting verb
syn match goLiteralStringFormat display contained /\
      \%([^%]\%(%%\)*\)\
      \@<=%[-#0 +]*\
      \%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\
      \%(\.\%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\)\=\
      \%(\[\d\+\]\)\=[vTtbcdoqxXUeEfFgGspw]/

hi def link goLiteralStringFormat Identifier

syn cluster goLiteralStringGroup contains=goLiteralEscapeChar,goLiteralEscapeO,goLiteralEscapeX,goLiteralEscapeU,goLiteralEscapeBigU,goLiteralEscapeInvalid,goLiteralEscapeStringSQ,goLiteralStringFormat

syn region goLiteralStringR start=+"+ skip=+\\\\\|\\"+ end=+"+
  \ contains=@goLiteralStringGroup,@Spell

syn region goLiteralRawString start=+`+ end=+`+
  \ contains=goLiteralStringFormat,@Spell

hi def link goLiteralStringR   goLiteralString
hi def link goLiteralRawString goLiteralString
hi def link goLiteralString    String
