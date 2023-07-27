" Vim syntax file
" Language:     Zig
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Last Change:  2023 Jul 26
" NOTE:         Literal types.

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

syn case match

" -----------------------------------------------------------------------------
" Integers

syn match zigLiteralDecimalInt     display "\<\d\(_\?\d\+\)*\>"
syn match zigLiteralHexadecimalInt display "\<0x\(_\?\x\+\)\+\>"
syn match zigLiteralOctalInt       display "\<0o\(_\?\o\+\)\+\>"
syn match zigLiteralBinaryInt      display "\<0b\(_\?[01]\+\)\+\>"

hi def link zigLiteralDecimalInt     zigLiteralInt
hi def link zigLiteralHexadecimalInt zigLiteralInt
hi def link zigLiteralOctalInt       zigLiteralInt
hi def link zigLiteralBinaryInt      zigLiteralInt
hi def link zigLiteralInt            Number

" -----------------------------------------------------------------------------
" Floats

syn match zigLiteralDecimalFloat     display "\<\d\(_\?\d\+\)*\."
syn match zigLiteralDecimalFloat     display "\.\d\(_\?\d\+\)*\>"
syn match zigLiteralDecimalFloat     display "\.\(\d\(_\?\d\+\)*\)\?[Ee][-+]\?\d\(_\?\d\+\)*\>"
syn match zigLiteralDecimalFloat     display "\<\d\(_\?\d\+\)*[Ee][-+]\?\d\(_\?\d\+\)*\>"
syn match zigLiteralDecimalFloat     display "\<\d\(_\?\d\+\)*\.\(\d\(_\?\d\+\)*\)*\([Ee][-+]\?\d\(_\?\d\+\)*\)\?\>"
syn match zigLiteralHexadecimalFloat display "\<0x\.\x\(_\?\x\+\)*[Pp][-+]\?\d\(_\?\d\+\)*\>"
syn match zigLiteralHexadecimalFloat display "\<0x\(_\?\x\+\)\+\(\.\(\x\(_\?\x\+\)*\)*\)\?[Pp][-+]\?\d\(_\?\d\+\)*\>"

hi def link zigLiteralDecimalFloat     zigLiteralFloat
hi def link zigLiteralHexadecimalFloat zigLiteralFloat
hi def link zigLiteralFloat            Float

" -----------------------------------------------------------------------------
" Unicode points

syn match zigLiteralEscapeChar display contained +\\[nrt\\'"]+
syn match zigLiteralEscapeX    display contained "\\x\x\{2}"
syn match zigLiteralEscapeU    display contained "\\u{\x\{1,8}}"

hi def link zigLiteralEscapeChar zigLiteralEscape
hi def link zigLiteralEscapeX    zigLiteralEscape
hi def link zigLiteralEscapeU    zigLiteralEscape
hi def link zigLiteralEscape     Special

syn match zigLiteralEscapeInvalid display contained +\\[^xunrt\\'"]+

hi def link zigLiteralEscapeInvalid zigLiteralEscapeError
hi def link zigLiteralEscapeError   Error

syn match zigLiteralEscapeUnicodeQuote   display contained +\\"+
syn match zigLiteralEscapeUnicodeTooMany display contained "'\(\\[^xu]\|[^\\]\)[^']\{1,\}"hs=s+1
syn match zigLiteralEscapeInvalidUnicode display contained /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/

hi def link zigLiteralEscapeUnicodeQuote   zigLiteralEscapeError
hi def link zigLiteralEscapeUnicodeTooMany zigLiteralEscapeError
hi def link zigLiteralEscapeInvalidUnicode zigLiteralEscapeError

syn cluster zigLiteralUnicodeGroup contains=zigLiteralEscapeChar,zigLiteralEscapeX,zigLiteralEscapeU,zigLiteralEscapeInvalid,zigLiteralEscapeUnicodeQuote,zigLiteralEscapeUnicodeTooMany,zigLiteralEscapeInvalidUnicode

syn region zigLiteralUnicode start=+'+ skip=+\\\\\|\\'+ end=+'+ keepend
  \ contains=@zigLiteralUnicodeGroup

hi def link zigLiteralUnicode Character

" -----------------------------------------------------------------------------
" Strings

syn match zigLiteralEscapeStringSQ display contained +\\'+

hi def link zigLiteralEscapeStringSQ zigLiteralEscapeError

syn region zigLiteralStringFormat matchgroup=zigLiteralStringFormatDelimiter start=+{[^{]+rs=s+1 end=+}+ oneline contained

hi def link zigLiteralStringFormat          Identifier
hi def link zigLiteralStringFormatDelimiter Delimiter

syn cluster zigLiteralStringGroup contains=zigLiteralEscapeChar,zigLiteralEscapeX,zigLiteralEscapeU,zigLiteralEscapeInvalid,zigLiteralEscapeStringSQ,zigLiteralEscapeInvalidUnicode,zigLiteralStringFormat

syn region zigLiteralString matchgroup=zigLiteralStringDelimiter start=+c\?"+ skip=+\\\\\|\\"+ end=+"+ oneline contains=@zigLiteralStringGroup,@Spell

hi def link zigLiteralString          String
hi def link zigLiteralStringDelimiter Delimiter

syn match zigLiteralMultilineStringPrefix /c\?\\\\/ contained containedin=zigLiteralMultilineString
syntax region zigLiteralMultilineString matchgroup=zigLiteralMultilineStringDelimiter start='c\?\\\\' end='$' contains=zigLiteralMultilineStringPrefix,zigLiteralStringFormat display

hi def link zigLiteralMultilineString          String
hi def link zigLiteralMultilineStringPrefix    String
hi def link zigLiteralMultilineStringDelimiter Delimiter
