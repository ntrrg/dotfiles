" Copyright 2020 Miguel Angel Rivera Notararigo. All rights reserved.
" This source code was released under the MIT license.
"
" This systax file is based on the official gotexttmpl.vim file.

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn case match

" -----------------------------------------------------------------------------
" Keywords

syn keyword goTmplDef contained define template block
syn cluster goTmplSyntax contains=goTmplDef

hi def link goTmplDef Define

  " Operators;
syn match goTmplOperator contained /:\?=/
syn cluster goTmplSyntax add=goTmplOperator

hi def link goTmplOperator Operator

  " Builtins
syn keyword goTmplBuiltins              contained and call html index js len not or print printf println slice urlquery eq ne lt le gt ge
syn keyword goTmplPredefinedIdentifiers contained nil
syn cluster goTmplSyntax add=goTmplBuiltins,goTmplPredefinedIdentifiers

hi def link goTmplBuiltins              Function
hi def link goTmplPredefinedIdentifiers Boolean

syn keyword goTmplConditional contained else if with
syn keyword goTmplRepeat      contained range
syn keyword goTmplStatement   contained end
syn cluster goTmplSyntax add=goTmplConditional,goTmplRepeat,goTmplStatement

hi def link goTmplConditional Conditional
hi def link goTmplRepeat      Repeat
hi def link goTmplStatement   Statement

" -----------------------------------------------------------------------------
" Identifiers

syn match goTmplDot        contained /\./
syn match goTmplIdentifier contained /\$\?\.\w\+/
syn match goTmplVariable   contained /\$[a-zA-Z0-9_]*\>/
syn cluster goTmplSyntax add=goTmplDot,goTmplIdentifier,goTmplVariable

hi def link goTmplDot        Identifier
hi def link goTmplIdentifier Identifier
hi def link goTmplVariable   Identifier

" -----------------------------------------------------------------------------
" Literals
  " Numerics
    " Integers
syn match goTmplLiteralDecimalInt     contained "\<\(0\|[1-9]\(_\?\d\+\)*\)\>"
syn match goTmplLiteralHexadecimalInt contained "\<0[xX]\(_\?\x\+\)\+\>"
syn match goTmplLiteralOctalInt       contained "\<0[oO]\?\(_\?\o\+\)\+\>"
syn match goTmplLiteralBinaryInt      contained "\<0[bB]\(_\?[01]\+\)\+\>"
syn cluster goTmplSyntax add=goTmplLiteralDecimalInt,goTmplLiteralHexadecimalInt,goTmplLiteralOctalInt,goTmplLiteralBinaryInt

hi def link goTmplLiteralDecimalInt     goTmplLiteralInt
hi def link goTmplLiteralHexadecimalInt goTmplLiteralInt
hi def link goTmplLiteralOctalInt       goTmplLiteralInt
hi def link goTmplLiteralBinaryInt      goTmplLiteralInt
hi def link goTmplLiteralInt            Number

    " Floats
syn match goTmplLiteralDecimalFloat     contained "\<\d\(_\?\d\+\)*\."
syn match goTmplLiteralDecimalFloat     contained "\.\d\(_\?\d\+\)*\>"
syn match goTmplLiteralDecimalFloat     contained "\.\(\d\(_\?\d\+\)*\)\?[Ee][-+]\?\d\(_\?\d\+\)*\>"
syn match goTmplLiteralDecimalFloat     contained "\<\d\(_\?\d\+\)*[Ee][-+]\?\d\(_\?\d\+\)*\>"
syn match goTmplLiteralDecimalFloat     contained "\<\d\(_\?\d\+\)*\.\(\d\(_\?\d\+\)*\)*\([Ee][-+]\?\d\(_\?\d\+\)*\)\?\>"
syn match goTmplLiteralHexadecimalFloat contained "\<0[Xx]\.\x\(_\?\x\+\)*[Pp][-+]\?\d\(_\?\d\+\)*\>"
syn match goTmplLiteralHexadecimalFloat contained "\<0[Xx]\(_\?\x\+\)\+\(\.\(\x\(_\?\x\+\)*\)*\)\?[Pp][-+]\?\d\(_\?\d\+\)*\>"
syn cluster goTmplSyntax add=goTmplLiteralDecimalFloat,goTmplLiteralDecimalFloat,goTmplLiteralDecimalFloat,goTmplLiteralDecimalFloat,goTmplLiteralDecimalFloat,goTmplLiteralHexadecimalFloat,goTmplLiteralHexadecimalFloat

hi def link goTmplLiteralDecimalFloat     goTmplLiteralFloat
hi def link goTmplLiteralHexadecimalFloat goTmplLiteralFloat
hi def link goTmplLiteralFloat            Float

    " Imaginaries
syn match goTmplLiteralImaginary      contained "\<\(0\|[1-9]\(_\?\d\+\)*\)i\>"
syn match goTmplLiteralImaginary      contained "\<0[xX]\(_\?\x\+\)\+i\>"
syn match goTmplLiteralImaginary      contained "\<0[oO]\?\(_\?\o\+\)\+i\>"
syn match goTmplLiteralImaginary      contained "\<0[bB]\(_\?[01]\+\)\+i\>"
syn match goTmplLiteralImaginaryFloat contained "\<\d\(_\?\d\+\)*\.i"
syn match goTmplLiteralImaginaryFloat contained "\.\d\(_\?\d\+\)*i\>"
syn match goTmplLiteralImaginaryFloat contained "\.\(\d\(_\?\d\+\)*\)\?[Ee][-+]\?\d\(_\?\d\+\)*i\>"
syn match goTmplLiteralImaginaryFloat contained "\<\d\(_\?\d\+\)*[Ee][-+]\?\d\(_\?\d\+\)*i\>"
syn match goTmplLiteralImaginaryFloat contained "\<\d\(_\?\d\+\)*\.\(\d\(_\?\d\+\)*\)*\([Ee][-+]\?\d\(_\?\d\+\)*\)\?i\>"
syn match goTmplLiteralImaginaryFloat contained "\<0[Xx]\.\x\(_\?\x\+\)*[Pp][-+]\?\d\(_\?\d\+\)*i\>"
syn match goTmplLiteralImaginaryFloat contained "\<0[Xx]\(_\?\x\+\)\+\(\.\(\x\(_\?\x\+\)*\)*\)\?[Pp][-+]\?\d\(_\?\d\+\)*i\>"
syn cluster goTmplSyntax add=goTmplLiteralImaginary,goTmplLiteralImaginary,goTmplLiteralImaginary,goTmplLiteralImaginary,goTmplLiteralImaginaryFloat,goTmplLiteralImaginaryFloat,goTmplLiteralImaginaryFloat,goTmplLiteralImaginaryFloat,goTmplLiteralImaginaryFloat,goTmplLiteralImaginaryFloat,goTmplLiteralImaginaryFloat

hi def link goTmplLiteralImaginary      Number
hi def link goTmplLiteralImaginaryFloat Float

  " Runes and strings
syn match goTmplEscapeChar  display contained +\\[abfnrtv\\'"]+
syn match goTmplEscapeO     display contained "\\[0-7]\{3}"
syn match goTmplEscapeX     display contained "\\x\x\{2}"
syn match goTmplEscapeU     display contained "\\u\x\{4}"
syn match goTmplEscapeBigU  display contained "\\U\x\{8}"

hi def link goTmplEscapeChar goTmplEscape
hi def link goTmplEscapeO    goTmplEscape
hi def link goTmplEscapeX    goTmplEscape
hi def link goTmplEscapeU    goTmplEscape
hi def link goTmplEscapeBigU goTmplEscape
hi def link goTmplEscape     Special

syn match goTmplEscapeInvalid display contained +\\[^0-7xuUabfnrtv\\'"]+

hi def link goTmplEscapeInvalid goTmplEscapeError
hi def link goTmplEscapeError   Error

    " Runes
syn match goTmplEscapeRuneQuote   display contained +\\"+
syn match goTmplEscapeRuneTooMany display contained "'\(\\[^0-7xuU]\|[^\\]\)[^']\{1,\}"hs=s+1

hi def link goTmplEscapeRuneQuote   goTmplEscapeError
hi def link goTmplEscapeRuneTooMany goTmplEscapeError

syn cluster goTmplRuneGroup contains=goTmplEscapeChar,goTmplEscapeO,goTmplEscapeX,goTmplEscapeU,goTmplEscapeBigU,goTmplEscapeInvalid,goTmplEscapeRuneQuote,goTmplEscapeRuneTooMany

syn region goTmplLiteralRune start=+'+ skip=+\\\\\|\\'+ end=+'+ contained keepend contains=@goTmplRuneGroup
syn cluster goTmplSyntax add=goTmplLiteralRune

hi def link goTmplLiteralRune Character

    " Strings
syn match goTmplEscapeStringSQ display contained +\\'+

hi def link goTmplEscapeStringSQ goTmplEscapeError

" [n] notation is valid for specifying explicit argument indexes
" 1. Match a literal % not preceded by a %.
" 2. Match any number of -, #, 0, space, or +
" 3. Match * or [n]* or any number or nothing before a .
" 4. Match * or [n]* or any number or nothing after a .
" 5. Match [n] or nothing before a verb
" 6. Match a formatting verb
syn match goTmplStringFormat /\
      \%([^%]\%(%%\)*\)\
      \@<=%[-#0 +]*\
      \%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\
      \%(\.\%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\)\=\
      \%(\[\d\+\]\)\=[vTtbcdoqxXUeEfFgGspw]/ contained

hi def link goTmplStringFormat Identifier

syn cluster goTmplStringGroup contains=goTmplEscapeChar,goTmplEscapeO,goTmplEscapeX,goTmplEscapeU,goTmplEscapeBigU,goTmplEscapeInvalid,goTmplStringFormat,goTmplEscapeStringSQ

syn region goTmplLiteralStringR   start=+"+ skip=+\\\\\|\\"+ end=+"+ contained contains=@goTmplStringGroup,@Spell
syn region goTmplLiteralRawString start=+`+ end=+`+ contained contains=@Spell
syn cluster goTmplSyntax add=goTmplLiteralStringR,goTmplLiteralRawString

hi def link goTmplLiteralStringR   goTmplLiteralString
hi def link goTmplLiteralRawString goTmplLiteralString
hi def link goTmplLiteralString    String

" -----------------------------------------------------------------------------
" Regions

syn region goTmplAction start="{{" end="}}" display keepend contains=@goTmplSyntax

hi def link goTmplAction Normal

syn region goTmplComment start="{{\(- \)\?/\*" end="\*/\( -\)\?}}" display

hi def link goTmplComment Comment

let b:current_syntax = "gotexttmpl"
