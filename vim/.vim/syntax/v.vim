" Vim syntax file
" Language:     V
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Filenames:    *.v
" Last Change:  2022 Jun 06
" NOTE:         Based on v.vim from https://github.com/ollykel/v-vim

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

syn case match

" -----------------------------------------------------------------------------

syn match       vDeclType           "\<\(struct\|interface\|type\|enum\)\>"
syn keyword     vDeclaration        pub mut var const
hi def link     vDeclType           Keyword
hi def link     vDeclaration        Keyword

syn keyword     vDirective          module import
hi def link     vDirective          Statement

syn region      vIncluded           display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match       vIncluded           display contained "<[^>]*>"
syn match       vFlagDefinition     display contained "\s\i[^\n]*"
hi def link     vIncluded           vString
hi def link     vFlagDefinition     vString

syn match       vInclude            display "^\s*\zs\(%:\|#\)\s*include\>\s*["<]" contains=vIncluded
syn match       vFlag               display "^\s*\zs\(%:\|#\)\s*flag\>\s*[^\n]*" contains=vFlagDefinition
syn region      vShebang            display start=/^#!/ end=/$/
hi def link     vInclude            Include
hi def link     vFlag               Include
hi def link     vShebang            Include

" Keywords within functions
syn keyword     vStatement          defer go goto return break continue
hi def link     vStatement          Statement

syn keyword     vConditional        if else match or select
hi def link     vConditional        Conditional

syn keyword     vRepeat             for in
hi def link     vRepeat             Repeat

syn match       vCodeGen            /$if\>/
" XXX Enable when compile-time code-gen is implemented in V
" syn match       vCodeGen            /\.fields\>/
" syn match       vCodeGen            /\.$\i*\>/
hi def link     vCodeGen            Identifier

" Predefined types
syn keyword     vType               any chan char map bool string error voidptr
syn match       vOptionalType       "\%(\<?\)\@<=\(chan\|map\|bool\|string\|error\|voidptr\)"
syn keyword     vSignedInts         int i8 i16 i64 isize rune intptr
syn keyword     vUnsignedInts       byte u16 u32 u64 usize byteptr
syn keyword     vFloats             f32 f64 floatptr
" XXX Enable when complex numbers are implemented in V
" syn keyword    	vComplexes          complex64 complex128

hi def link     vType               Type
hi def link     vOptionalType       Type
hi def link     vSignedInts         Type
hi def link     vUnsignedInts       Type
hi def link     vFloats             Type
" XXX Enable when complex numbers implemented in V
" hi def link    	vComplexes          Type

" Treat fn specially: it's a declaration at the start of a line, but a type
" elsewhere. Order matters here.
syn match       vDeclaration        /\<fn\>/
syn match       vDeclaration        contained /\<fn\>/

" Predefined functions and values
syn keyword     vBuiltins           assert C
syn keyword     vBuiltins           complex exit imag
syn keyword     vBuiltins           print println eprint eprintln
syn keyword     vBuiltins           malloc copy memdup  isnil
syn keyword     vBuiltins           panic recover
syn match       vBuiltins           /\<json\.\(encode\|decode\)\>/
hi def link     vBuiltins           Keyword

syn keyword     vConstants          true false
hi def link     vConstants          Keyword

" Comments; their contents
syn keyword     vTodo               contained TODO FIXME XXX BUG
hi def link     vTodo               Todo

syn cluster     vCommentGroup       contains=vTodo
syn region      vComment            start="/\*" end="\*/" contains=@vCommentGroup,@Spell
syn region      vComment            start="//" end="$" contains=@vCommentGroup,@Spell
hi def link     vComment            Comment

" V escapes
syn match       vStringVar          display contained +\$[0-9A-Za-z\._]*\([(][^)]*[)]\)\?+
syn match       vStringVar          display contained "\${[^}]*}"
syn match       vStringSpeChar      display contained +\\[abfnrtv\\'"`]+
syn match       vStringX            display contained "\\x\x\{1,2}"
syn match       vStringU            display contained "\\u\x\{4}"
syn match       vStringBigU         display contained "\\U\x\{8}"
syn match       vStringError        display contained +\\[^0-7xuUabfnrtv\\'"]+

hi def link     vStringVar          Special
hi def link     vStringSpeChar      Special
hi def link     vStringX            Special
hi def link     vStringU            Special
hi def link     vStringBigU         Special
hi def link     vStringError        Error

" Characters and their contents
syn cluster     vCharacterGroup     contains=vStringSpeChar,vStringVar,vStringX,vStringU,vStringBigU
syn region      vCharacter          start=+`+ end=+`+ contains=@vCharacterGroup
hi def link     vCharacter          Character

" Strings and their contents
syn cluster     vStringGroup        contains=@vCharacterGroup,vStringError

syn region      vString             start=+"+ skip=+\\\\\|\\'+ end=+"+ contains=@vStringGroup
syn region      vString             start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=@vStringGroup

syn region      vRawString          start=+r"+ end=+"+
syn region      vRawString          start=+r'+ end=+'+

hi def link     vString             String
hi def link     vRawString          String

" Regions
syn region      vBlock              start="{" end="}" transparent fold
syn region      vParen              start='(' end=')' transparent

" Integers
syn match       vDecimalInt         "\<\d\+\([Ee]\d\+\)\?\>"
syn match       vOctalInt           "\<0o\o\+\>"
syn match       vHexInt             "\<0x\x\+\>"
syn match       vBinaryInt          "\<0b[01]\+\>"
syn match       vSnakeInt           "\<[0-9_]\+\>"

hi def link     vDecimalInt         Integer
hi def link     vOctalInt           Integer
hi def link     vHexInt             Integer
hi def link     vBinaryInt          Integer
hi def link     vSnakeInt           Integer
hi def link     Integer             Number

" Floating point
syn match       vFloat              "\<\d\+\.\d*\([Ee][-+]\d\+\)\?\>"
syn match       vFloat              "\<\.\d\+\([Ee][-+]\d\+\)\?\>"
syn match       vFloat              "\<\d\+[Ee][-+]\d\+\>"

hi def link     vFloat              Float
hi def link     Float               Number

" Imaginary literals
" XXX Enable when complex numbers are implemented in V
" syn match       vImaginary          "\<\d\+i\>"
" syn match       vImaginary          "\<\d\+\.\d*\([Ee][-+]\d\+\)\?i\>"
" syn match       vImaginary          "\<\.\d\+\([Ee][-+]\d\+\)\?i\>"
" syn match       vImaginary          "\<\d\+[Ee][-+]\d\+i\>"
" 
" hi def link    	vImaginary          Number

" Generics
syn match     vGenericBrackets      display contained "[<>]"
syn match     vInterfaceDeclaration display "\s*\zsinterface\s*\i*\s*<[^>]*>" contains=vDeclType,vGenericBrackets
syn match     vStructDeclaration    display "\s*\zsstruct\s*\i*\s*<[^>]*>" contains=vDeclType,vGenericBrackets
" vFunctionName only appears when v_highlight_function_calls set
syn match     vFuncDeclaration      display "\s*\zsfn\s*\i*\s*<[^>]*>" contains=vFunctionName,vDeclaration,vGenericBrackets

hi def link   vGenericBrackets      Identifier

syn match vSpaceError display           / \+\t/me=e-1
syn match vSpaceError display excludenl /\s\+$/

hi def link vSpaceError Error

" Search backwards for a global declaration to start processing the syntax.
"syn sync match	vSync grouphere NONE /^\(const\|var\|type\|func\)\>/

" There's a bug in the implementation of grouphere. For now, use the
" following as a more expensive/less precise workaround.
syn sync minlines=500

let b:current_syntax = 'v'
