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

hi def link goBuiltins              Identifier
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

hi def link goLiteralDecimalInt     GoLiteralInt
hi def link goLiteralHexadecimalInt GoLiteralInt
hi def link goLiteralOctalInt       GoLiteralInt
hi def link goLiteralBinaryInt      GoLiteralInt
hi def link GoLiteralInt            Number

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

syn cluster goStringGroup contains=goEscapeChar,goEscapeO,goEscapeX,goEscapeU,goEscapeBigU,goEscapeInvalid,goStringFormat,goEscapeStringSQ

syn region goLiteralStringR   start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@goStringGroup
syn region goLiteralRawString start=+`+ end=+`+

hi def link goLiteralStringR   goLiteralString
hi def link goLiteralRawString goLiteralString
hi def link goLiteralString    String

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
      \%(\[\d\+\]\)\=[vTtbcdoqxXUeEfFgGspw]/ contained containedin=goString,goRawString

hi def link goStringFormat Identifier

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
" Stdlib types (Go 1.13)

syn match goStdlibType /\<tar\.Format\>/
syn match goStdlibType /\<tar\.Header\>/
syn match goStdlibType /\<tar\.Reader\>/
syn match goStdlibType /\<tar\.Writer\>/
syn match goStdlibType /\<zip\.Compressor\>/
syn match goStdlibType /\<zip\.Decompressor\>/
syn match goStdlibType /\<zip\.File\>/
syn match goStdlibType /\<zip\.FileHeader\>/
syn match goStdlibType /\<zip\.ReadCloser\>/
syn match goStdlibType /\<zip\.Reader\>/
syn match goStdlibType /\<zip\.Writer\>/
syn match goStdlibType /\<bufio\.ReadWriter\>/
syn match goStdlibType /\<bufio\.Reader\>/
syn match goStdlibType /\<bufio\.Scanner\>/
syn match goStdlibType /\<bufio\.SplitFunc\>/
syn match goStdlibType /\<bufio\.Writer\>/
syn match goStdlibType /\<builtin\.ComplexType\>/
syn match goStdlibType /\<builtin\.FloatType\>/
syn match goStdlibType /\<builtin\.IntegerType\>/
syn match goStdlibType /\<builtin\.Type\>/
syn match goStdlibType /\<builtin\.Type1\>/
syn match goStdlibType /\<bytes\.Buffer\>/
syn match goStdlibType /\<bytes\.Reader\>/
syn match goStdlibType /\<bzip2\.StructuralError\>/
syn match goStdlibType /\<flate\.CorruptInputError\>/
syn match goStdlibType /\<flate\.InternalError\>/
syn match goStdlibType /\<flate\.ReadError\>/
syn match goStdlibType /\<flate\.Reader\>/
syn match goStdlibType /\<flate\.Resetter\>/
syn match goStdlibType /\<flate\.WriteError\>/
syn match goStdlibType /\<flate\.Writer\>/
syn match goStdlibType /\<gzip\.Header\>/
syn match goStdlibType /\<gzip\.Reader\>/
syn match goStdlibType /\<gzip\.Writer\>/
syn match goStdlibType /\<lzw\.Order\>/
syn match goStdlibType /\<zlib\.Resetter\>/
syn match goStdlibType /\<zlib\.Writer\>/
syn match goStdlibType /\<heap\.Interface\>/
syn match goStdlibType /\<list\.Element\>/
syn match goStdlibType /\<list\.List\>/
syn match goStdlibType /\<ring\.Ring\>/
syn match goStdlibType /\<context\.CancelFunc\>/
syn match goStdlibType /\<context\.Context\>/
syn match goStdlibType /\<crypto\.Decrypter\>/
syn match goStdlibType /\<crypto\.DecrypterOpts\>/
syn match goStdlibType /\<crypto\.Hash\>/
syn match goStdlibType /\<crypto\.PrivateKey\>/
syn match goStdlibType /\<crypto\.PublicKey\>/
syn match goStdlibType /\<crypto\.Signer\>/
syn match goStdlibType /\<crypto\.SignerOpts\>/
syn match goStdlibType /\<aes\.KeySizeError\>/
syn match goStdlibType /\<cipher\.AEAD\>/
syn match goStdlibType /\<cipher\.Block\>/
syn match goStdlibType /\<cipher\.BlockMode\>/
syn match goStdlibType /\<cipher\.Stream\>/
syn match goStdlibType /\<cipher\.StreamReader\>/
syn match goStdlibType /\<cipher\.StreamWriter\>/
syn match goStdlibType /\<des\.KeySizeError\>/
syn match goStdlibType /\<dsa\.ParameterSizes\>/
syn match goStdlibType /\<dsa\.Parameters\>/
syn match goStdlibType /\<dsa\.PrivateKey\>/
syn match goStdlibType /\<dsa\.PublicKey\>/
syn match goStdlibType /\<ecdsa\.PrivateKey\>/
syn match goStdlibType /\<ecdsa\.PublicKey\>/
syn match goStdlibType /\<ed25519\.PrivateKey\>/
syn match goStdlibType /\<ed25519\.PublicKey\>/
syn match goStdlibType /\<elliptic\.Curve\>/
syn match goStdlibType /\<elliptic\.CurveParams\>/
syn match goStdlibType /\<rc4\.Cipher\>/
syn match goStdlibType /\<rc4\.KeySizeError\>/
syn match goStdlibType /\<rsa\.CRTValue\>/
syn match goStdlibType /\<rsa\.OAEPOptions\>/
syn match goStdlibType /\<rsa\.PKCS1v15DecryptOptions\>/
syn match goStdlibType /\<rsa\.PSSOptions\>/
syn match goStdlibType /\<rsa\.PrecomputedValues\>/
syn match goStdlibType /\<rsa\.PrivateKey\>/
syn match goStdlibType /\<rsa\.PublicKey\>/
syn match goStdlibType /\<tls\.Certificate\>/
syn match goStdlibType /\<tls\.CertificateRequestInfo\>/
syn match goStdlibType /\<tls\.ClientAuthType\>/
syn match goStdlibType /\<tls\.ClientHelloInfo\>/
syn match goStdlibType /\<tls\.ClientSessionCache\>/
syn match goStdlibType /\<tls\.ClientSessionState\>/
syn match goStdlibType /\<tls\.Config\>/
syn match goStdlibType /\<tls\.Conn\>/
syn match goStdlibType /\<tls\.ConnectionState\>/
syn match goStdlibType /\<tls\.CurveID\>/
syn match goStdlibType /\<tls\.RecordHeaderError\>/
syn match goStdlibType /\<tls\.RenegotiationSupport\>/
syn match goStdlibType /\<tls\.SignatureScheme\>/
syn match goStdlibType /\<x509\.CertPool\>/
syn match goStdlibType /\<x509\.Certificate\>/
syn match goStdlibType /\<x509\.CertificateInvalidError\>/
syn match goStdlibType /\<x509\.CertificateRequest\>/
syn match goStdlibType /\<x509\.ConstraintViolationError\>/
syn match goStdlibType /\<x509\.ExtKeyUsage\>/
syn match goStdlibType /\<x509\.HostnameError\>/
syn match goStdlibType /\<x509\.InsecureAlgorithmError\>/
syn match goStdlibType /\<x509\.InvalidReason\>/
syn match goStdlibType /\<x509\.KeyUsage\>/
syn match goStdlibType /\<x509\.PEMCipher\>/
syn match goStdlibType /\<x509\.PublicKeyAlgorithm\>/
syn match goStdlibType /\<x509\.SignatureAlgorithm\>/
syn match goStdlibType /\<x509\.SystemRootsError\>/
syn match goStdlibType /\<x509\.UnhandledCriticalExtension\>/
syn match goStdlibType /\<x509\.UnknownAuthorityError\>/
syn match goStdlibType /\<x509\.VerifyOptions\>/
syn match goStdlibType /\<pkix\.AlgorithmIdentifier\>/
syn match goStdlibType /\<pkix\.AttributeTypeAndValue\>/
syn match goStdlibType /\<pkix\.AttributeTypeAndValueSET\>/
syn match goStdlibType /\<pkix\.CertificateList\>/
syn match goStdlibType /\<pkix\.Extension\>/
syn match goStdlibType /\<pkix\.Name\>/
syn match goStdlibType /\<pkix\.RDNSequence\>/
syn match goStdlibType /\<pkix\.RelativeDistinguishedNameSET\>/
syn match goStdlibType /\<pkix\.RevokedCertificate\>/
syn match goStdlibType /\<pkix\.TBSCertificateList\>/
syn match goStdlibType /\<sql\.ColumnType\>/
syn match goStdlibType /\<sql\.Conn\>/
syn match goStdlibType /\<sql\.DB\>/
syn match goStdlibType /\<sql\.DBStats\>/
syn match goStdlibType /\<sql\.IsolationLevel\>/
syn match goStdlibType /\<sql\.NamedArg\>/
syn match goStdlibType /\<sql\.NullBool\>/
syn match goStdlibType /\<sql\.NullFloat64\>/
syn match goStdlibType /\<sql\.NullInt32\>/
syn match goStdlibType /\<sql\.NullInt64\>/
syn match goStdlibType /\<sql\.NullString\>/
syn match goStdlibType /\<sql\.NullTime\>/
syn match goStdlibType /\<sql\.Out\>/
syn match goStdlibType /\<sql\.RawBytes\>/
syn match goStdlibType /\<sql\.Result\>/
syn match goStdlibType /\<sql\.Row\>/
syn match goStdlibType /\<sql\.Rows\>/
syn match goStdlibType /\<sql\.Scanner\>/
syn match goStdlibType /\<sql\.Stmt\>/
syn match goStdlibType /\<sql\.Tx\>/
syn match goStdlibType /\<sql\.TxOptions\>/
syn match goStdlibType /\<driver\.ColumnConverter\>/
syn match goStdlibType /\<driver\.Conn\>/
syn match goStdlibType /\<driver\.ConnBeginTx\>/
syn match goStdlibType /\<driver\.ConnPrepareContext\>/
syn match goStdlibType /\<driver\.Connector\>/
syn match goStdlibType /\<driver\.Driver\>/
syn match goStdlibType /\<driver\.DriverContext\>/
syn match goStdlibType /\<driver\.Execer\>/
syn match goStdlibType /\<driver\.ExecerContext\>/
syn match goStdlibType /\<driver\.IsolationLevel\>/
syn match goStdlibType /\<driver\.NamedValue\>/
syn match goStdlibType /\<driver\.NamedValueChecker\>/
syn match goStdlibType /\<driver\.NotNull\>/
syn match goStdlibType /\<driver\.Null\>/
syn match goStdlibType /\<driver\.Pinger\>/
syn match goStdlibType /\<driver\.Queryer\>/
syn match goStdlibType /\<driver\.QueryerContext\>/
syn match goStdlibType /\<driver\.Result\>/
syn match goStdlibType /\<driver\.Rows\>/
syn match goStdlibType /\<driver\.RowsAffected\>/
syn match goStdlibType /\<driver\.RowsColumnTypeDatabaseTypeName\>/
syn match goStdlibType /\<driver\.RowsColumnTypeLength\>/
syn match goStdlibType /\<driver\.RowsColumnTypeNullable\>/
syn match goStdlibType /\<driver\.RowsColumnTypePrecisionScale\>/
syn match goStdlibType /\<driver\.RowsColumnTypeScanType\>/
syn match goStdlibType /\<driver\.RowsNextResultSet\>/
syn match goStdlibType /\<driver\.SessionResetter\>/
syn match goStdlibType /\<driver\.Stmt\>/
syn match goStdlibType /\<driver\.StmtExecContext\>/
syn match goStdlibType /\<driver\.StmtQueryContext\>/
syn match goStdlibType /\<driver\.Tx\>/
syn match goStdlibType /\<driver\.TxOptions\>/
syn match goStdlibType /\<driver\.Value\>/
syn match goStdlibType /\<driver\.ValueConverter\>/
syn match goStdlibType /\<driver\.Valuer\>/
syn match goStdlibType /\<dwarf\.AddrType\>/
syn match goStdlibType /\<dwarf\.ArrayType\>/
syn match goStdlibType /\<dwarf\.Attr\>/
syn match goStdlibType /\<dwarf\.BasicType\>/
syn match goStdlibType /\<dwarf\.BoolType\>/
syn match goStdlibType /\<dwarf\.CharType\>/
syn match goStdlibType /\<dwarf\.Class\>/
syn match goStdlibType /\<dwarf\.CommonType\>/
syn match goStdlibType /\<dwarf\.ComplexType\>/
syn match goStdlibType /\<dwarf\.Data\>/
syn match goStdlibType /\<dwarf\.DecodeError\>/
syn match goStdlibType /\<dwarf\.DotDotDotType\>/
syn match goStdlibType /\<dwarf\.Entry\>/
syn match goStdlibType /\<dwarf\.EnumType\>/
syn match goStdlibType /\<dwarf\.EnumValue\>/
syn match goStdlibType /\<dwarf\.Field\>/
syn match goStdlibType /\<dwarf\.FloatType\>/
syn match goStdlibType /\<dwarf\.FuncType\>/
syn match goStdlibType /\<dwarf\.IntType\>/
syn match goStdlibType /\<dwarf\.LineEntry\>/
syn match goStdlibType /\<dwarf\.LineFile\>/
syn match goStdlibType /\<dwarf\.LineReader\>/
syn match goStdlibType /\<dwarf\.LineReaderPos\>/
syn match goStdlibType /\<dwarf\.Offset\>/
syn match goStdlibType /\<dwarf\.PtrType\>/
syn match goStdlibType /\<dwarf\.QualType\>/
syn match goStdlibType /\<dwarf\.Reader\>/
syn match goStdlibType /\<dwarf\.StructField\>/
syn match goStdlibType /\<dwarf\.StructType\>/
syn match goStdlibType /\<dwarf\.Tag\>/
syn match goStdlibType /\<dwarf\.Type\>/
syn match goStdlibType /\<dwarf\.TypedefType\>/
syn match goStdlibType /\<dwarf\.UcharType\>/
syn match goStdlibType /\<dwarf\.UintType\>/
syn match goStdlibType /\<dwarf\.UnspecifiedType\>/
syn match goStdlibType /\<dwarf\.UnsupportedType\>/
syn match goStdlibType /\<dwarf\.VoidType\>/
syn match goStdlibType /\<elf\.Chdr32\>/
syn match goStdlibType /\<elf\.Chdr64\>/
syn match goStdlibType /\<elf\.Class\>/
syn match goStdlibType /\<elf\.CompressionType\>/
syn match goStdlibType /\<elf\.Data\>/
syn match goStdlibType /\<elf\.Dyn32\>/
syn match goStdlibType /\<elf\.Dyn64\>/
syn match goStdlibType /\<elf\.DynFlag\>/
syn match goStdlibType /\<elf\.DynTag\>/
syn match goStdlibType /\<elf\.File\>/
syn match goStdlibType /\<elf\.FileHeader\>/
syn match goStdlibType /\<elf\.FormatError\>/
syn match goStdlibType /\<elf\.Header32\>/
syn match goStdlibType /\<elf\.Header64\>/
syn match goStdlibType /\<elf\.ImportedSymbol\>/
syn match goStdlibType /\<elf\.Machine\>/
syn match goStdlibType /\<elf\.NType\>/
syn match goStdlibType /\<elf\.OSABI\>/
syn match goStdlibType /\<elf\.Prog\>/
syn match goStdlibType /\<elf\.Prog32\>/
syn match goStdlibType /\<elf\.Prog64\>/
syn match goStdlibType /\<elf\.ProgFlag\>/
syn match goStdlibType /\<elf\.ProgHeader\>/
syn match goStdlibType /\<elf\.ProgType\>/
syn match goStdlibType /\<elf\.R_386\>/
syn match goStdlibType /\<elf\.R_390\>/
syn match goStdlibType /\<elf\.R_AARCH64\>/
syn match goStdlibType /\<elf\.R_ALPHA\>/
syn match goStdlibType /\<elf\.R_ARM\>/
syn match goStdlibType /\<elf\.R_MIPS\>/
syn match goStdlibType /\<elf\.R_PPC\>/
syn match goStdlibType /\<elf\.R_PPC64\>/
syn match goStdlibType /\<elf\.R_RISCV\>/
syn match goStdlibType /\<elf\.R_SPARC\>/
syn match goStdlibType /\<elf\.R_X86_64\>/
syn match goStdlibType /\<elf\.Rel32\>/
syn match goStdlibType /\<elf\.Rel64\>/
syn match goStdlibType /\<elf\.Rela32\>/
syn match goStdlibType /\<elf\.Rela64\>/
syn match goStdlibType /\<elf\.Section\>/
syn match goStdlibType /\<elf\.Section32\>/
syn match goStdlibType /\<elf\.Section64\>/
syn match goStdlibType /\<elf\.SectionFlag\>/
syn match goStdlibType /\<elf\.SectionHeader\>/
syn match goStdlibType /\<elf\.SectionIndex\>/
syn match goStdlibType /\<elf\.SectionType\>/
syn match goStdlibType /\<elf\.Sym32\>/
syn match goStdlibType /\<elf\.Sym64\>/
syn match goStdlibType /\<elf\.SymBind\>/
syn match goStdlibType /\<elf\.SymType\>/
syn match goStdlibType /\<elf\.SymVis\>/
syn match goStdlibType /\<elf\.Symbol\>/
syn match goStdlibType /\<elf\.Type\>/
syn match goStdlibType /\<elf\.Version\>/
syn match goStdlibType /\<gosym\.DecodingError\>/
syn match goStdlibType /\<gosym\.Func\>/
syn match goStdlibType /\<gosym\.LineTable\>/
syn match goStdlibType /\<gosym\.Obj\>/
syn match goStdlibType /\<gosym\.Sym\>/
syn match goStdlibType /\<gosym\.Table\>/
syn match goStdlibType /\<gosym\.UnknownFileError\>/
syn match goStdlibType /\<gosym\.UnknownLineError\>/
syn match goStdlibType /\<macho\.Cpu\>/
syn match goStdlibType /\<macho\.Dylib\>/
syn match goStdlibType /\<macho\.DylibCmd\>/
syn match goStdlibType /\<macho\.Dysymtab\>/
syn match goStdlibType /\<macho\.DysymtabCmd\>/
syn match goStdlibType /\<macho\.FatArch\>/
syn match goStdlibType /\<macho\.FatArchHeader\>/
syn match goStdlibType /\<macho\.FatFile\>/
syn match goStdlibType /\<macho\.File\>/
syn match goStdlibType /\<macho\.FileHeader\>/
syn match goStdlibType /\<macho\.FormatError\>/
syn match goStdlibType /\<macho\.Load\>/
syn match goStdlibType /\<macho\.LoadBytes\>/
syn match goStdlibType /\<macho\.LoadCmd\>/
syn match goStdlibType /\<macho\.Nlist32\>/
syn match goStdlibType /\<macho\.Nlist64\>/
syn match goStdlibType /\<macho\.Regs386\>/
syn match goStdlibType /\<macho\.RegsAMD64\>/
syn match goStdlibType /\<macho\.Reloc\>/
syn match goStdlibType /\<macho\.RelocTypeARM\>/
syn match goStdlibType /\<macho\.RelocTypeARM64\>/
syn match goStdlibType /\<macho\.RelocTypeGeneric\>/
syn match goStdlibType /\<macho\.RelocTypeX86_64\>/
syn match goStdlibType /\<macho\.Rpath\>/
syn match goStdlibType /\<macho\.RpathCmd\>/
syn match goStdlibType /\<macho\.Section\>/
syn match goStdlibType /\<macho\.Section32\>/
syn match goStdlibType /\<macho\.Section64\>/
syn match goStdlibType /\<macho\.SectionHeader\>/
syn match goStdlibType /\<macho\.Segment\>/
syn match goStdlibType /\<macho\.Segment32\>/
syn match goStdlibType /\<macho\.Segment64\>/
syn match goStdlibType /\<macho\.SegmentHeader\>/
syn match goStdlibType /\<macho\.Symbol\>/
syn match goStdlibType /\<macho\.Symtab\>/
syn match goStdlibType /\<macho\.SymtabCmd\>/
syn match goStdlibType /\<macho\.Thread\>/
syn match goStdlibType /\<macho\.Type\>/
syn match goStdlibType /\<pe\.COFFSymbol\>/
syn match goStdlibType /\<pe\.DataDirectory\>/
syn match goStdlibType /\<pe\.File\>/
syn match goStdlibType /\<pe\.FileHeader\>/
syn match goStdlibType /\<pe\.FormatError\>/
syn match goStdlibType /\<pe\.ImportDirectory\>/
syn match goStdlibType /\<pe\.OptionalHeader32\>/
syn match goStdlibType /\<pe\.OptionalHeader64\>/
syn match goStdlibType /\<pe\.Reloc\>/
syn match goStdlibType /\<pe\.Section\>/
syn match goStdlibType /\<pe\.SectionHeader\>/
syn match goStdlibType /\<pe\.SectionHeader32\>/
syn match goStdlibType /\<pe\.StringTable\>/
syn match goStdlibType /\<pe\.Symbol\>/
syn match goStdlibType /\<plan9obj\.File\>/
syn match goStdlibType /\<plan9obj\.FileHeader\>/
syn match goStdlibType /\<plan9obj\.Section\>/
syn match goStdlibType /\<plan9obj\.SectionHeader\>/
syn match goStdlibType /\<plan9obj\.Sym\>/
syn match goStdlibType /\<encoding\.BinaryMarshaler\>/
syn match goStdlibType /\<encoding\.BinaryUnmarshaler\>/
syn match goStdlibType /\<encoding\.TextMarshaler\>/
syn match goStdlibType /\<encoding\.TextUnmarshaler\>/
syn match goStdlibType /\<ascii85\.CorruptInputError\>/
syn match goStdlibType /\<asn1\.BitString\>/
syn match goStdlibType /\<asn1\.Enumerated\>/
syn match goStdlibType /\<asn1\.Flag\>/
syn match goStdlibType /\<asn1\.ObjectIdentifier\>/
syn match goStdlibType /\<asn1\.RawContent\>/
syn match goStdlibType /\<asn1\.RawValue\>/
syn match goStdlibType /\<asn1\.StructuralError\>/
syn match goStdlibType /\<asn1\.SyntaxError\>/
syn match goStdlibType /\<base32\.CorruptInputError\>/
syn match goStdlibType /\<base32\.Encoding\>/
syn match goStdlibType /\<base64\.CorruptInputError\>/
syn match goStdlibType /\<base64\.Encoding\>/
syn match goStdlibType /\<binary\.ByteOrder\>/
syn match goStdlibType /\<csv\.ParseError\>/
syn match goStdlibType /\<csv\.Reader\>/
syn match goStdlibType /\<csv\.Writer\>/
syn match goStdlibType /\<gob\.CommonType\>/
syn match goStdlibType /\<gob\.Decoder\>/
syn match goStdlibType /\<gob\.Encoder\>/
syn match goStdlibType /\<gob\.GobDecoder\>/
syn match goStdlibType /\<gob\.GobEncoder\>/
syn match goStdlibType /\<hex\.InvalidByteError\>/
syn match goStdlibType /\<json\.Decoder\>/
syn match goStdlibType /\<json\.Delim\>/
syn match goStdlibType /\<json\.Encoder\>/
syn match goStdlibType /\<json\.InvalidUTF8Error\>/
syn match goStdlibType /\<json\.InvalidUnmarshalError\>/
syn match goStdlibType /\<json\.Marshaler\>/
syn match goStdlibType /\<json\.MarshalerError\>/
syn match goStdlibType /\<json\.Number\>/
syn match goStdlibType /\<json\.RawMessage\>/
syn match goStdlibType /\<json\.SyntaxError\>/
syn match goStdlibType /\<json\.Token\>/
syn match goStdlibType /\<json\.UnmarshalFieldError\>/
syn match goStdlibType /\<json\.UnmarshalTypeError\>/
syn match goStdlibType /\<json\.Unmarshaler\>/
syn match goStdlibType /\<json\.UnsupportedTypeError\>/
syn match goStdlibType /\<json\.UnsupportedValueError\>/
syn match goStdlibType /\<pem\.Block\>/
syn match goStdlibType /\<xml\.Attr\>/
syn match goStdlibType /\<xml\.CharData\>/
syn match goStdlibType /\<xml\.Comment\>/
syn match goStdlibType /\<xml\.Decoder\>/
syn match goStdlibType /\<xml\.Directive\>/
syn match goStdlibType /\<xml\.Encoder\>/
syn match goStdlibType /\<xml\.EndElement\>/
syn match goStdlibType /\<xml\.Marshaler\>/
syn match goStdlibType /\<xml\.MarshalerAttr\>/
syn match goStdlibType /\<xml\.Name\>/
syn match goStdlibType /\<xml\.ProcInst\>/
syn match goStdlibType /\<xml\.StartElement\>/
syn match goStdlibType /\<xml\.SyntaxError\>/
syn match goStdlibType /\<xml\.TagPathError\>/
syn match goStdlibType /\<xml\.Token\>/
syn match goStdlibType /\<xml\.TokenReader\>/
syn match goStdlibType /\<xml\.UnmarshalError\>/
syn match goStdlibType /\<xml\.Unmarshaler\>/
syn match goStdlibType /\<xml\.UnmarshalerAttr\>/
syn match goStdlibType /\<xml\.UnsupportedTypeError\>/
syn match goStdlibType /\<expvar\.Float\>/
syn match goStdlibType /\<expvar\.Func\>/
syn match goStdlibType /\<expvar\.Int\>/
syn match goStdlibType /\<expvar\.KeyValue\>/
syn match goStdlibType /\<expvar\.Map\>/
syn match goStdlibType /\<expvar\.String\>/
syn match goStdlibType /\<expvar\.Var\>/
syn match goStdlibType /\<flag\.ErrorHandling\>/
syn match goStdlibType /\<flag\.Flag\>/
syn match goStdlibType /\<flag\.FlagSet\>/
syn match goStdlibType /\<flag\.Getter\>/
syn match goStdlibType /\<flag\.Value\>/
syn match goStdlibType /\<fmt\.Formatter\>/
syn match goStdlibType /\<fmt\.GoStringer\>/
syn match goStdlibType /\<fmt\.ScanState\>/
syn match goStdlibType /\<fmt\.Scanner\>/
syn match goStdlibType /\<fmt\.State\>/
syn match goStdlibType /\<fmt\.Stringer\>/
syn match goStdlibType /\<ast\.ArrayType\>/
syn match goStdlibType /\<ast\.AssignStmt\>/
syn match goStdlibType /\<ast\.BadDecl\>/
syn match goStdlibType /\<ast\.BadExpr\>/
syn match goStdlibType /\<ast\.BadStmt\>/
syn match goStdlibType /\<ast\.BasicLit\>/
syn match goStdlibType /\<ast\.BinaryExpr\>/
syn match goStdlibType /\<ast\.BlockStmt\>/
syn match goStdlibType /\<ast\.BranchStmt\>/
syn match goStdlibType /\<ast\.CallExpr\>/
syn match goStdlibType /\<ast\.CaseClause\>/
syn match goStdlibType /\<ast\.ChanDir\>/
syn match goStdlibType /\<ast\.ChanType\>/
syn match goStdlibType /\<ast\.CommClause\>/
syn match goStdlibType /\<ast\.Comment\>/
syn match goStdlibType /\<ast\.CommentGroup\>/
syn match goStdlibType /\<ast\.CommentMap\>/
syn match goStdlibType /\<ast\.CompositeLit\>/
syn match goStdlibType /\<ast\.Decl\>/
syn match goStdlibType /\<ast\.DeclStmt\>/
syn match goStdlibType /\<ast\.DeferStmt\>/
syn match goStdlibType /\<ast\.Ellipsis\>/
syn match goStdlibType /\<ast\.EmptyStmt\>/
syn match goStdlibType /\<ast\.Expr\>/
syn match goStdlibType /\<ast\.ExprStmt\>/
syn match goStdlibType /\<ast\.Field\>/
syn match goStdlibType /\<ast\.FieldFilter\>/
syn match goStdlibType /\<ast\.FieldList\>/
syn match goStdlibType /\<ast\.File\>/
syn match goStdlibType /\<ast\.Filter\>/
syn match goStdlibType /\<ast\.ForStmt\>/
syn match goStdlibType /\<ast\.FuncDecl\>/
syn match goStdlibType /\<ast\.FuncLit\>/
syn match goStdlibType /\<ast\.FuncType\>/
syn match goStdlibType /\<ast\.GenDecl\>/
syn match goStdlibType /\<ast\.GoStmt\>/
syn match goStdlibType /\<ast\.Ident\>/
syn match goStdlibType /\<ast\.IfStmt\>/
syn match goStdlibType /\<ast\.ImportSpec\>/
syn match goStdlibType /\<ast\.Importer\>/
syn match goStdlibType /\<ast\.IncDecStmt\>/
syn match goStdlibType /\<ast\.IndexExpr\>/
syn match goStdlibType /\<ast\.InterfaceType\>/
syn match goStdlibType /\<ast\.KeyValueExpr\>/
syn match goStdlibType /\<ast\.LabeledStmt\>/
syn match goStdlibType /\<ast\.MapType\>/
syn match goStdlibType /\<ast\.MergeMode\>/
syn match goStdlibType /\<ast\.Node\>/
syn match goStdlibType /\<ast\.ObjKind\>/
syn match goStdlibType /\<ast\.Object\>/
syn match goStdlibType /\<ast\.Package\>/
syn match goStdlibType /\<ast\.ParenExpr\>/
syn match goStdlibType /\<ast\.RangeStmt\>/
syn match goStdlibType /\<ast\.ReturnStmt\>/
syn match goStdlibType /\<ast\.Scope\>/
syn match goStdlibType /\<ast\.SelectStmt\>/
syn match goStdlibType /\<ast\.SelectorExpr\>/
syn match goStdlibType /\<ast\.SendStmt\>/
syn match goStdlibType /\<ast\.SliceExpr\>/
syn match goStdlibType /\<ast\.Spec\>/
syn match goStdlibType /\<ast\.StarExpr\>/
syn match goStdlibType /\<ast\.Stmt\>/
syn match goStdlibType /\<ast\.StructType\>/
syn match goStdlibType /\<ast\.SwitchStmt\>/
syn match goStdlibType /\<ast\.TypeAssertExpr\>/
syn match goStdlibType /\<ast\.TypeSpec\>/
syn match goStdlibType /\<ast\.TypeSwitchStmt\>/
syn match goStdlibType /\<ast\.UnaryExpr\>/
syn match goStdlibType /\<ast\.ValueSpec\>/
syn match goStdlibType /\<ast\.Visitor\>/
syn match goStdlibType /\<build\.Context\>/
syn match goStdlibType /\<build\.ImportMode\>/
syn match goStdlibType /\<build\.MultiplePackageError\>/
syn match goStdlibType /\<build\.NoGoError\>/
syn match goStdlibType /\<build\.Package\>/
syn match goStdlibType /\<constant\.Kind\>/
syn match goStdlibType /\<constant\.Value\>/
syn match goStdlibType /\<doc\.Example\>/
syn match goStdlibType /\<doc\.Filter\>/
syn match goStdlibType /\<doc\.Func\>/
syn match goStdlibType /\<doc\.Mode\>/
syn match goStdlibType /\<doc\.Note\>/
syn match goStdlibType /\<doc\.Package\>/
syn match goStdlibType /\<doc\.Type\>/
syn match goStdlibType /\<doc\.Value\>/
syn match goStdlibType /\<importer\.Lookup\>/
syn match goStdlibType /\<parser\.Mode\>/
syn match goStdlibType /\<printer\.CommentedNode\>/
syn match goStdlibType /\<printer\.Config\>/
syn match goStdlibType /\<printer\.Mode\>/
syn match goStdlibType /\<scanner\.Error\>/
syn match goStdlibType /\<scanner\.ErrorHandler\>/
syn match goStdlibType /\<scanner\.ErrorList\>/
syn match goStdlibType /\<scanner\.Mode\>/
syn match goStdlibType /\<scanner\.Scanner\>/
syn match goStdlibType /\<token\.File\>/
syn match goStdlibType /\<token\.FileSet\>/
syn match goStdlibType /\<token\.Pos\>/
syn match goStdlibType /\<token\.Position\>/
syn match goStdlibType /\<token\.Token\>/
syn match goStdlibType /\<types\.Array\>/
syn match goStdlibType /\<types\.Basic\>/
syn match goStdlibType /\<types\.BasicInfo\>/
syn match goStdlibType /\<types\.BasicKind\>/
syn match goStdlibType /\<types\.Builtin\>/
syn match goStdlibType /\<types\.Chan\>/
syn match goStdlibType /\<types\.ChanDir\>/
syn match goStdlibType /\<types\.Checker\>/
syn match goStdlibType /\<types\.Config\>/
syn match goStdlibType /\<types\.Const\>/
syn match goStdlibType /\<types\.Error\>/
syn match goStdlibType /\<types\.Func\>/
syn match goStdlibType /\<types\.ImportMode\>/
syn match goStdlibType /\<types\.Importer\>/
syn match goStdlibType /\<types\.ImporterFrom\>/
syn match goStdlibType /\<types\.Info\>/
syn match goStdlibType /\<types\.Initializer\>/
syn match goStdlibType /\<types\.Interface\>/
syn match goStdlibType /\<types\.Label\>/
syn match goStdlibType /\<types\.Map\>/
syn match goStdlibType /\<types\.MethodSet\>/
syn match goStdlibType /\<types\.Named\>/
syn match goStdlibType /\<types\.Nil\>/
syn match goStdlibType /\<types\.Object\>/
syn match goStdlibType /\<types\.Package\>/
syn match goStdlibType /\<types\.PkgName\>/
syn match goStdlibType /\<types\.Pointer\>/
syn match goStdlibType /\<types\.Qualifier\>/
syn match goStdlibType /\<types\.Scope\>/
syn match goStdlibType /\<types\.Selection\>/
syn match goStdlibType /\<types\.SelectionKind\>/
syn match goStdlibType /\<types\.Signature\>/
syn match goStdlibType /\<types\.Sizes\>/
syn match goStdlibType /\<types\.Slice\>/
syn match goStdlibType /\<types\.StdSizes\>/
syn match goStdlibType /\<types\.Struct\>/
syn match goStdlibType /\<types\.Tuple\>/
syn match goStdlibType /\<types\.Type\>/
syn match goStdlibType /\<types\.TypeAndValue\>/
syn match goStdlibType /\<types\.TypeName\>/
syn match goStdlibType /\<types\.Var\>/
syn match goStdlibType /\<hash\.Hash\>/
syn match goStdlibType /\<hash\.Hash32\>/
syn match goStdlibType /\<hash\.Hash64\>/
syn match goStdlibType /\<crc32\.Table\>/
syn match goStdlibType /\<crc64\.Table\>/
syn match goStdlibType /\<template\.CSS\>/
syn match goStdlibType /\<template\.Error\>/
syn match goStdlibType /\<template\.ErrorCode\>/
syn match goStdlibType /\<template\.FuncMap\>/
syn match goStdlibType /\<template\.HTML\>/
syn match goStdlibType /\<template\.HTMLAttr\>/
syn match goStdlibType /\<template\.JS\>/
syn match goStdlibType /\<template\.JSStr\>/
syn match goStdlibType /\<template\.Srcset\>/
syn match goStdlibType /\<template\.Template\>/
syn match goStdlibType /\<template\.URL\>/
syn match goStdlibType /\<image\.Alpha\>/
syn match goStdlibType /\<image\.Alpha16\>/
syn match goStdlibType /\<image\.CMYK\>/
syn match goStdlibType /\<image\.Config\>/
syn match goStdlibType /\<image\.Gray\>/
syn match goStdlibType /\<image\.Gray16\>/
syn match goStdlibType /\<image\.Image\>/
syn match goStdlibType /\<image\.NRGBA\>/
syn match goStdlibType /\<image\.NRGBA64\>/
syn match goStdlibType /\<image\.NYCbCrA\>/
syn match goStdlibType /\<image\.Paletted\>/
syn match goStdlibType /\<image\.PalettedImage\>/
syn match goStdlibType /\<image\.Point\>/
syn match goStdlibType /\<image\.RGBA\>/
syn match goStdlibType /\<image\.RGBA64\>/
syn match goStdlibType /\<image\.Rectangle\>/
syn match goStdlibType /\<image\.Uniform\>/
syn match goStdlibType /\<image\.YCbCr\>/
syn match goStdlibType /\<image\.YCbCrSubsampleRatio\>/
syn match goStdlibType /\<color\.Alpha\>/
syn match goStdlibType /\<color\.Alpha16\>/
syn match goStdlibType /\<color\.CMYK\>/
syn match goStdlibType /\<color\.Color\>/
syn match goStdlibType /\<color\.Gray\>/
syn match goStdlibType /\<color\.Gray16\>/
syn match goStdlibType /\<color\.Model\>/
syn match goStdlibType /\<color\.NRGBA\>/
syn match goStdlibType /\<color\.NRGBA64\>/
syn match goStdlibType /\<color\.NYCbCrA\>/
syn match goStdlibType /\<color\.Palette\>/
syn match goStdlibType /\<color\.RGBA\>/
syn match goStdlibType /\<color\.RGBA64\>/
syn match goStdlibType /\<color\.YCbCr\>/
syn match goStdlibType /\<draw\.Drawer\>/
syn match goStdlibType /\<draw\.Image\>/
syn match goStdlibType /\<draw\.Op\>/
syn match goStdlibType /\<draw\.Quantizer\>/
syn match goStdlibType /\<gif\.GIF\>/
syn match goStdlibType /\<gif\.Options\>/
syn match goStdlibType /\<jpeg\.FormatError\>/
syn match goStdlibType /\<jpeg\.Options\>/
syn match goStdlibType /\<jpeg\.Reader\>/
syn match goStdlibType /\<jpeg\.UnsupportedError\>/
syn match goStdlibType /\<png\.CompressionLevel\>/
syn match goStdlibType /\<png\.Encoder\>/
syn match goStdlibType /\<png\.EncoderBuffer\>/
syn match goStdlibType /\<png\.EncoderBufferPool\>/
syn match goStdlibType /\<png\.FormatError\>/
syn match goStdlibType /\<png\.UnsupportedError\>/
syn match goStdlibType /\<suffixarray\.Index\>/
syn match goStdlibType /\<io\.ByteReader\>/
syn match goStdlibType /\<io\.ByteScanner\>/
syn match goStdlibType /\<io\.ByteWriter\>/
syn match goStdlibType /\<io\.Closer\>/
syn match goStdlibType /\<io\.LimitedReader\>/
syn match goStdlibType /\<io\.PipeReader\>/
syn match goStdlibType /\<io\.PipeWriter\>/
syn match goStdlibType /\<io\.ReadCloser\>/
syn match goStdlibType /\<io\.ReadSeeker\>/
syn match goStdlibType /\<io\.ReadWriteCloser\>/
syn match goStdlibType /\<io\.ReadWriteSeeker\>/
syn match goStdlibType /\<io\.ReadWriter\>/
syn match goStdlibType /\<io\.Reader\>/
syn match goStdlibType /\<io\.ReaderAt\>/
syn match goStdlibType /\<io\.ReaderFrom\>/
syn match goStdlibType /\<io\.RuneReader\>/
syn match goStdlibType /\<io\.RuneScanner\>/
syn match goStdlibType /\<io\.SectionReader\>/
syn match goStdlibType /\<io\.Seeker\>/
syn match goStdlibType /\<io\.StringWriter\>/
syn match goStdlibType /\<io\.WriteCloser\>/
syn match goStdlibType /\<io\.WriteSeeker\>/
syn match goStdlibType /\<io\.Writer\>/
syn match goStdlibType /\<io\.WriterAt\>/
syn match goStdlibType /\<io\.WriterTo\>/
syn match goStdlibType /\<log\.Logger\>/
syn match goStdlibType /\<syslog\.Priority\>/
syn match goStdlibType /\<syslog\.Writer\>/
syn match goStdlibType /\<big\.Accuracy\>/
syn match goStdlibType /\<big\.ErrNaN\>/
syn match goStdlibType /\<big\.Float\>/
syn match goStdlibType /\<big\.Int\>/
syn match goStdlibType /\<big\.Rat\>/
syn match goStdlibType /\<big\.RoundingMode\>/
syn match goStdlibType /\<big\.Word\>/
syn match goStdlibType /\<rand\.Rand\>/
syn match goStdlibType /\<rand\.Source\>/
syn match goStdlibType /\<rand\.Source64\>/
syn match goStdlibType /\<rand\.Zipf\>/
syn match goStdlibType /\<mime\.WordDecoder\>/
syn match goStdlibType /\<mime\.WordEncoder\>/
syn match goStdlibType /\<multipart\.File\>/
syn match goStdlibType /\<multipart\.FileHeader\>/
syn match goStdlibType /\<multipart\.Form\>/
syn match goStdlibType /\<multipart\.Part\>/
syn match goStdlibType /\<multipart\.Reader\>/
syn match goStdlibType /\<multipart\.Writer\>/
syn match goStdlibType /\<quotedprintable\.Reader\>/
syn match goStdlibType /\<quotedprintable\.Writer\>/
syn match goStdlibType /\<net\.Addr\>/
syn match goStdlibType /\<net\.AddrError\>/
syn match goStdlibType /\<net\.Buffers\>/
syn match goStdlibType /\<net\.Conn\>/
syn match goStdlibType /\<net\.DNSConfigError\>/
syn match goStdlibType /\<net\.DNSError\>/
syn match goStdlibType /\<net\.Dialer\>/
syn match goStdlibType /\<net\.Error\>/
syn match goStdlibType /\<net\.Flags\>/
syn match goStdlibType /\<net\.HardwareAddr\>/
syn match goStdlibType /\<net\.IP\>/
syn match goStdlibType /\<net\.IPAddr\>/
syn match goStdlibType /\<net\.IPConn\>/
syn match goStdlibType /\<net\.IPMask\>/
syn match goStdlibType /\<net\.IPNet\>/
syn match goStdlibType /\<net\.Interface\>/
syn match goStdlibType /\<net\.InvalidAddrError\>/
syn match goStdlibType /\<net\.ListenConfig\>/
syn match goStdlibType /\<net\.Listener\>/
syn match goStdlibType /\<net\.MX\>/
syn match goStdlibType /\<net\.NS\>/
syn match goStdlibType /\<net\.OpError\>/
syn match goStdlibType /\<net\.PacketConn\>/
syn match goStdlibType /\<net\.ParseError\>/
syn match goStdlibType /\<net\.Resolver\>/
syn match goStdlibType /\<net\.SRV\>/
syn match goStdlibType /\<net\.TCPAddr\>/
syn match goStdlibType /\<net\.TCPConn\>/
syn match goStdlibType /\<net\.TCPListener\>/
syn match goStdlibType /\<net\.UDPAddr\>/
syn match goStdlibType /\<net\.UDPConn\>/
syn match goStdlibType /\<net\.UnixAddr\>/
syn match goStdlibType /\<net\.UnixConn\>/
syn match goStdlibType /\<net\.UnixListener\>/
syn match goStdlibType /\<net\.UnknownNetworkError\>/
syn match goStdlibType /\<http\.Client\>/
syn match goStdlibType /\<http\.CloseNotifier\>/
syn match goStdlibType /\<http\.ConnState\>/
syn match goStdlibType /\<http\.Cookie\>/
syn match goStdlibType /\<http\.CookieJar\>/
syn match goStdlibType /\<http\.Dir\>/
syn match goStdlibType /\<http\.File\>/
syn match goStdlibType /\<http\.FileSystem\>/
syn match goStdlibType /\<http\.Flusher\>/
syn match goStdlibType /\<http\.Handler\>/
syn match goStdlibType /\<http\.HandlerFunc\>/
syn match goStdlibType /\<http\.Header\>/
syn match goStdlibType /\<http\.Hijacker\>/
syn match goStdlibType /\<http\.ProtocolError\>/
syn match goStdlibType /\<http\.PushOptions\>/
syn match goStdlibType /\<http\.Pusher\>/
syn match goStdlibType /\<http\.Request\>/
syn match goStdlibType /\<http\.Response\>/
syn match goStdlibType /\<http\.ResponseWriter\>/
syn match goStdlibType /\<http\.RoundTripper\>/
syn match goStdlibType /\<http\.SameSite\>/
syn match goStdlibType /\<http\.ServeMux\>/
syn match goStdlibType /\<http\.Server\>/
syn match goStdlibType /\<http\.Transport\>/
syn match goStdlibType /\<cgi\.Handler\>/
syn match goStdlibType /\<cookiejar\.Jar\>/
syn match goStdlibType /\<cookiejar\.Options\>/
syn match goStdlibType /\<cookiejar\.PublicSuffixList\>/
syn match goStdlibType /\<httptest\.ResponseRecorder\>/
syn match goStdlibType /\<httptest\.Server\>/
syn match goStdlibType /\<httptrace\.ClientTrace\>/
syn match goStdlibType /\<httptrace\.DNSDoneInfo\>/
syn match goStdlibType /\<httptrace\.DNSStartInfo\>/
syn match goStdlibType /\<httptrace\.GotConnInfo\>/
syn match goStdlibType /\<httptrace\.WroteRequestInfo\>/
syn match goStdlibType /\<httputil\.BufferPool\>/
syn match goStdlibType /\<httputil\.ClientConn\>/
syn match goStdlibType /\<httputil\.ReverseProxy\>/
syn match goStdlibType /\<httputil\.ServerConn\>/
syn match goStdlibType /\<mail\.Address\>/
syn match goStdlibType /\<mail\.AddressParser\>/
syn match goStdlibType /\<mail\.Header\>/
syn match goStdlibType /\<mail\.Message\>/
syn match goStdlibType /\<rpc\.Call\>/
syn match goStdlibType /\<rpc\.Client\>/
syn match goStdlibType /\<rpc\.ClientCodec\>/
syn match goStdlibType /\<rpc\.Request\>/
syn match goStdlibType /\<rpc\.Response\>/
syn match goStdlibType /\<rpc\.Server\>/
syn match goStdlibType /\<rpc\.ServerCodec\>/
syn match goStdlibType /\<rpc\.ServerError\>/
syn match goStdlibType /\<smtp\.Auth\>/
syn match goStdlibType /\<smtp\.Client\>/
syn match goStdlibType /\<smtp\.ServerInfo\>/
syn match goStdlibType /\<textproto\.Conn\>/
syn match goStdlibType /\<textproto\.Error\>/
syn match goStdlibType /\<textproto\.MIMEHeader\>/
syn match goStdlibType /\<textproto\.Pipeline\>/
syn match goStdlibType /\<textproto\.ProtocolError\>/
syn match goStdlibType /\<textproto\.Reader\>/
syn match goStdlibType /\<textproto\.Writer\>/
syn match goStdlibType /\<url\.Error\>/
syn match goStdlibType /\<url\.EscapeError\>/
syn match goStdlibType /\<url\.InvalidHostError\>/
syn match goStdlibType /\<url\.URL\>/
syn match goStdlibType /\<url\.Userinfo\>/
syn match goStdlibType /\<url\.Values\>/
syn match goStdlibType /\<os\.File\>/
syn match goStdlibType /\<os\.FileInfo\>/
syn match goStdlibType /\<os\.FileMode\>/
syn match goStdlibType /\<os\.LinkError\>/
syn match goStdlibType /\<os\.PathError\>/
syn match goStdlibType /\<os\.ProcAttr\>/
syn match goStdlibType /\<os\.Process\>/
syn match goStdlibType /\<os\.ProcessState\>/
syn match goStdlibType /\<os\.Signal\>/
syn match goStdlibType /\<os\.SyscallError\>/
syn match goStdlibType /\<exec\.Cmd\>/
syn match goStdlibType /\<exec\.Error\>/
syn match goStdlibType /\<exec\.ExitError\>/
syn match goStdlibType /\<user\.Group\>/
syn match goStdlibType /\<user\.UnknownGroupError\>/
syn match goStdlibType /\<user\.UnknownGroupIdError\>/
syn match goStdlibType /\<user\.UnknownUserError\>/
syn match goStdlibType /\<user\.UnknownUserIdError\>/
syn match goStdlibType /\<user\.User\>/
syn match goStdlibType /\<filepath\.WalkFunc\>/
syn match goStdlibType /\<plugin\.Plugin\>/
syn match goStdlibType /\<plugin\.Symbol\>/
syn match goStdlibType /\<reflect\.ChanDir\>/
syn match goStdlibType /\<reflect\.Kind\>/
syn match goStdlibType /\<reflect\.MapIter\>/
syn match goStdlibType /\<reflect\.Method\>/
syn match goStdlibType /\<reflect\.SelectCase\>/
syn match goStdlibType /\<reflect\.SelectDir\>/
syn match goStdlibType /\<reflect\.SliceHeader\>/
syn match goStdlibType /\<reflect\.StringHeader\>/
syn match goStdlibType /\<reflect\.StructField\>/
syn match goStdlibType /\<reflect\.StructTag\>/
syn match goStdlibType /\<reflect\.Type\>/
syn match goStdlibType /\<reflect\.Value\>/
syn match goStdlibType /\<reflect\.ValueError\>/
syn match goStdlibType /\<regexp\.Regexp\>/
syn match goStdlibType /\<syntax\.EmptyOp\>/
syn match goStdlibType /\<syntax\.Error\>/
syn match goStdlibType /\<syntax\.ErrorCode\>/
syn match goStdlibType /\<syntax\.Flags\>/
syn match goStdlibType /\<syntax\.Inst\>/
syn match goStdlibType /\<syntax\.InstOp\>/
syn match goStdlibType /\<syntax\.Op\>/
syn match goStdlibType /\<syntax\.Prog\>/
syn match goStdlibType /\<syntax\.Regexp\>/
syn match goStdlibType /\<runtime\.BlockProfileRecord\>/
syn match goStdlibType /\<runtime\.Error\>/
syn match goStdlibType /\<runtime\.Frame\>/
syn match goStdlibType /\<runtime\.Frames\>/
syn match goStdlibType /\<runtime\.Func\>/
syn match goStdlibType /\<runtime\.MemProfileRecord\>/
syn match goStdlibType /\<runtime\.MemStats\>/
syn match goStdlibType /\<runtime\.StackRecord\>/
syn match goStdlibType /\<runtime\.TypeAssertionError\>/
syn match goStdlibType /\<debug\.BuildInfo\>/
syn match goStdlibType /\<debug\.GCStats\>/
syn match goStdlibType /\<debug\.Module\>/
syn match goStdlibType /\<pprof\.LabelSet\>/
syn match goStdlibType /\<pprof\.Profile\>/
syn match goStdlibType /\<trace\.Region\>/
syn match goStdlibType /\<trace\.Task\>/
syn match goStdlibType /\<sort\.Float64Slice\>/
syn match goStdlibType /\<sort\.IntSlice\>/
syn match goStdlibType /\<sort\.Interface\>/
syn match goStdlibType /\<sort\.StringSlice\>/
syn match goStdlibType /\<strconv\.NumError\>/
syn match goStdlibType /\<strings\.Builder\>/
syn match goStdlibType /\<strings\.Reader\>/
syn match goStdlibType /\<strings\.Replacer\>/
syn match goStdlibType /\<sync\.Cond\>/
syn match goStdlibType /\<sync\.Locker\>/
syn match goStdlibType /\<sync\.Map\>/
syn match goStdlibType /\<sync\.Mutex\>/
syn match goStdlibType /\<sync\.Once\>/
syn match goStdlibType /\<sync\.Pool\>/
syn match goStdlibType /\<sync\.RWMutex\>/
syn match goStdlibType /\<sync\.WaitGroup\>/
syn match goStdlibType /\<atomic\.Value\>/
syn match goStdlibType /\<syscall\.Cmsghdr\>/
syn match goStdlibType /\<syscall\.Conn\>/
syn match goStdlibType /\<syscall\.Credential\>/
syn match goStdlibType /\<syscall\.Dirent\>/
syn match goStdlibType /\<syscall\.EpollEvent\>/
syn match goStdlibType /\<syscall\.Errno\>/
syn match goStdlibType /\<syscall\.FdSet\>/
syn match goStdlibType /\<syscall\.Flock_t\>/
syn match goStdlibType /\<syscall\.Fsid\>/
syn match goStdlibType /\<syscall\.ICMPv6Filter\>/
syn match goStdlibType /\<syscall\.IPMreq\>/
syn match goStdlibType /\<syscall\.IPMreqn\>/
syn match goStdlibType /\<syscall\.IPv6MTUInfo\>/
syn match goStdlibType /\<syscall\.IPv6Mreq\>/
syn match goStdlibType /\<syscall\.IfAddrmsg\>/
syn match goStdlibType /\<syscall\.IfInfomsg\>/
syn match goStdlibType /\<syscall\.Inet4Pktinfo\>/
syn match goStdlibType /\<syscall\.Inet6Pktinfo\>/
syn match goStdlibType /\<syscall\.InotifyEvent\>/
syn match goStdlibType /\<syscall\.Iovec\>/
syn match goStdlibType /\<syscall\.Linger\>/
syn match goStdlibType /\<syscall\.Msghdr\>/
syn match goStdlibType /\<syscall\.NetlinkMessage\>/
syn match goStdlibType /\<syscall\.NetlinkRouteAttr\>/
syn match goStdlibType /\<syscall\.NetlinkRouteRequest\>/
syn match goStdlibType /\<syscall\.NlAttr\>/
syn match goStdlibType /\<syscall\.NlMsgerr\>/
syn match goStdlibType /\<syscall\.NlMsghdr\>/
syn match goStdlibType /\<syscall\.ProcAttr\>/
syn match goStdlibType /\<syscall\.PtraceRegs\>/
syn match goStdlibType /\<syscall\.RawConn\>/
syn match goStdlibType /\<syscall\.RawSockaddr\>/
syn match goStdlibType /\<syscall\.RawSockaddrAny\>/
syn match goStdlibType /\<syscall\.RawSockaddrInet4\>/
syn match goStdlibType /\<syscall\.RawSockaddrInet6\>/
syn match goStdlibType /\<syscall\.RawSockaddrLinklayer\>/
syn match goStdlibType /\<syscall\.RawSockaddrNetlink\>/
syn match goStdlibType /\<syscall\.RawSockaddrUnix\>/
syn match goStdlibType /\<syscall\.Rlimit\>/
syn match goStdlibType /\<syscall\.RtAttr\>/
syn match goStdlibType /\<syscall\.RtGenmsg\>/
syn match goStdlibType /\<syscall\.RtMsg\>/
syn match goStdlibType /\<syscall\.RtNexthop\>/
syn match goStdlibType /\<syscall\.Rusage\>/
syn match goStdlibType /\<syscall\.Signal\>/
syn match goStdlibType /\<syscall\.SockFilter\>/
syn match goStdlibType /\<syscall\.SockFprog\>/
syn match goStdlibType /\<syscall\.Sockaddr\>/
syn match goStdlibType /\<syscall\.SockaddrInet4\>/
syn match goStdlibType /\<syscall\.SockaddrInet6\>/
syn match goStdlibType /\<syscall\.SockaddrLinklayer\>/
syn match goStdlibType /\<syscall\.SockaddrNetlink\>/
syn match goStdlibType /\<syscall\.SockaddrUnix\>/
syn match goStdlibType /\<syscall\.SocketControlMessage\>/
syn match goStdlibType /\<syscall\.Stat_t\>/
syn match goStdlibType /\<syscall\.Statfs_t\>/
syn match goStdlibType /\<syscall\.SysProcAttr\>/
syn match goStdlibType /\<syscall\.SysProcIDMap\>/
syn match goStdlibType /\<syscall\.Sysinfo_t\>/
syn match goStdlibType /\<syscall\.TCPInfo\>/
syn match goStdlibType /\<syscall\.Termios\>/
syn match goStdlibType /\<syscall\.Time_t\>/
syn match goStdlibType /\<syscall\.Timespec\>/
syn match goStdlibType /\<syscall\.Timeval\>/
syn match goStdlibType /\<syscall\.Timex\>/
syn match goStdlibType /\<syscall\.Tms\>/
syn match goStdlibType /\<syscall\.Ucred\>/
syn match goStdlibType /\<syscall\.Ustat_t\>/
syn match goStdlibType /\<syscall\.Utimbuf\>/
syn match goStdlibType /\<syscall\.Utsname\>/
syn match goStdlibType /\<syscall\.WaitStatus\>/
syn match goStdlibType /\<testing\.T\>/
syn match goStdlibType /\<testing\.B\>/
syn match goStdlibType /\<testing\.BenchmarkResult\>/
syn match goStdlibType /\<testing\.Cover\>/
syn match goStdlibType /\<testing\.CoverBlock\>/
syn match goStdlibType /\<testing\.InternalBenchmark\>/
syn match goStdlibType /\<testing\.InternalExample\>/
syn match goStdlibType /\<testing\.InternalTest\>/
syn match goStdlibType /\<testing\.M\>/
syn match goStdlibType /\<testing\.PB\>/
syn match goStdlibType /\<testing\.T\>/
syn match goStdlibType /\<testing\.TB\>/
syn match goStdlibType /\<quick\.CheckEqualError\>/
syn match goStdlibType /\<quick\.CheckError\>/
syn match goStdlibType /\<quick\.Config\>/
syn match goStdlibType /\<quick\.Generator\>/
syn match goStdlibType /\<quick\.SetupError\>/
syn match goStdlibType /\<scanner\.Position\>/
syn match goStdlibType /\<scanner\.Scanner\>/
syn match goStdlibType /\<tabwriter\.Writer\>/
syn match goStdlibType /\<template\.ExecError\>/
syn match goStdlibType /\<template\.FuncMap\>/
syn match goStdlibType /\<template\.Template\>/
syn match goStdlibType /\<parse\.ActionNode\>/
syn match goStdlibType /\<parse\.BoolNode\>/
syn match goStdlibType /\<parse\.BranchNode\>/
syn match goStdlibType /\<parse\.ChainNode\>/
syn match goStdlibType /\<parse\.CommandNode\>/
syn match goStdlibType /\<parse\.DotNode\>/
syn match goStdlibType /\<parse\.FieldNode\>/
syn match goStdlibType /\<parse\.IdentifierNode\>/
syn match goStdlibType /\<parse\.IfNode\>/
syn match goStdlibType /\<parse\.ListNode\>/
syn match goStdlibType /\<parse\.NilNode\>/
syn match goStdlibType /\<parse\.Node\>/
syn match goStdlibType /\<parse\.NodeType\>/
syn match goStdlibType /\<parse\.NumberNode\>/
syn match goStdlibType /\<parse\.PipeNode\>/
syn match goStdlibType /\<parse\.Pos\>/
syn match goStdlibType /\<parse\.RangeNode\>/
syn match goStdlibType /\<parse\.StringNode\>/
syn match goStdlibType /\<parse\.TemplateNode\>/
syn match goStdlibType /\<parse\.TextNode\>/
syn match goStdlibType /\<parse\.Tree\>/
syn match goStdlibType /\<parse\.VariableNode\>/
syn match goStdlibType /\<parse\.WithNode\>/
syn match goStdlibType /\<time\.Duration\>/
syn match goStdlibType /\<time\.Location\>/
syn match goStdlibType /\<time\.Month\>/
syn match goStdlibType /\<time\.ParseError\>/
syn match goStdlibType /\<time\.Ticker\>/
syn match goStdlibType /\<time\.Time\>/
syn match goStdlibType /\<time\.Timer\>/
syn match goStdlibType /\<time\.Weekday\>/
syn match goStdlibType /\<unicode\.CaseRange\>/
syn match goStdlibType /\<unicode\.Range16\>/
syn match goStdlibType /\<unicode\.Range32\>/
syn match goStdlibType /\<unicode\.RangeTable\>/
syn match goStdlibType /\<unicode\.SpecialCase\>/
syn match goStdlibType /\<unsafe\.ArbitraryType\>/
syn match goStdlibType /\<unsafe\.Pointer\>/

hi def link goStdlibType Type

" Search backwards for a global declaration to start processing the syntax.
"syn sync match goSync grouphere NONE /^\(const\|var\|type\|func\)\>/

" There's a bug in the implementation of grouphere. For now, use the
" following as a more expensive/less precise workaround.
syn sync minlines=500

let b:current_syntax = "go"
