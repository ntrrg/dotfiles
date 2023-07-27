" Vim syntax file
" Language:     Zig
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Filenames:    *.zig
" Last Change:  2023 Jul 26
" NOTE:         Based on the official zig.vim file.

" Quit when a (custom) syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" -----------------------------------------------------------------------------
" Comments

syn match zigNote display "//\s[A-Z]\{3,\}:\s"hs=s+3,he=e-1

syn region zigComment start='//' end='$' contains=zigNote,@Spell
syn region zigCommentDoc start='//[/!]/\@!' end='$' contains=zigNote,@Spell

hi default link zigNote       Todo
hi default link zigComment    Comment
hi default link zigCommentDoc Comment

" -----------------------------------------------------------------------------
" Operators

" =
"syn match zigOperator display /=/

" +  +%  +|  -  -%  -|  *  *%  *|
" += +%= +|= -= -%= -|= *= *%= *|=
"syn match zigOperator display /[+\-*][%|]\?=\?/

" / /=
"syn match zigOperator display "/\(=\|\ze[^/*]\)"

" % %=
"syn match zigOperator display /[%]=\?/

" <<  <<|  >>  >>|
" <<= <<|= >>= >>|=
"syn match zigOperator display /\%(<<\|>>\)|\?=\?/

" &  |  ^
" &= |= ^=
"syn match zigOperator display /[&|^]=\?/

" ~
"syn match zigOperator display /~/

" orelse
"syn keyword zigOperator orelse

" .?
"syn match zigOperator display /\.?/

" ++ -- ->
"syn match zigOperator display /++\|--\|->/

" <<  >>  &^
" <<= >>= &^=
"syn match zigOperator display /\%(<<\|>>\|&\^\)=\?/

" <  >  !  =
" <= >= != ==
"syn match zigOperator display "[<>!&|^=]=\?"

" && ||
"syn match zigOperator display /&&\|||/

" ( ) [ ] { } . : , ; ~
"syn match zigOperator display /[()\[\]{}.:,;~]/

"syn match zigOperator display '\V\[-+/*=^&?|!><%~]'
"syn match zigArrowOperator display '\V->'

"hi default link zigArrowOperator zigOperator
"hi default link zigOperator Operator

" -----------------------------------------------------------------------------
" Keywords

" TODO: Catogorize this keywords.
syn keyword zigKeyword     asm linksection noalias

syn keyword zigDefine      const fn test usingnamespace var
syn keyword zigExecution   break continue return
syn keyword zigConditional else if switch
syn keyword zigRepeat      for while
syn keyword zigComparation and or
syn keyword zigAsync       async await nosuspend resume suspend
syn keyword zigMacro       comptime defer errdefer catch orelse try unreachable

hi def link zigKeyword     Keyword
hi def link zigDefine      Define
hi def link zigExecution   Special
hi def link zigConditional Conditional
hi def link zigRepeat      Repeat
hi def link zigComparation Operator
hi def link zigAsync       Macro
hi def link zigMacro       Macro

syn keyword zigModifier
  \ addrspace align allowzero callconv export extern inline noinline packed
  \ pub threadlocal volatile

hi def link zigModifier Define

" Constants

syn keyword zigBoolean  true false
syn keyword zigConstant null undefined

hi def link zigBoolean  Boolean
hi def link zigConstant Constant

" Identifiers

syn keyword zigPredefinedIdentifiers _

hi def link zigPredefinedIdentifiers Identifier

syn keyword zigBuiltins 
  \ @This @Type @TypeOf @Vector @addWithOverflow @addrSpaceCast @alignCast
  \ @alignOf @as @atomicLoad @atomicRmw @atomicStore @bitCast @bitOffsetOf
  \ @bitReverse @bitSizeOf @breakpoint @byteSwap @cDefine @cImport @cInclude
  \ @cUndef @cVaArg @cVaCopy @cVaEnd @cVaStart @call @ceil @clz @cmpxchgStrong
  \ @cmpxchgWeak @compileError @compileLog @constCast @cos @ctz @divExact
  \ @divFloor @divTrunc @embedFile @enumFromInt @errSetCast @errorFromInt
  \ @errorName @errorReturnTrace @exp @exp2 @export @extern @fabs @fence
  \ @field @fieldParentPtr @floatCast @floatFromInt @floor @frameAddress
  \ @hasDecl @hasField @import @inComptime @intCast @intFromBool @intFromEnum
  \ @intFromError @intFromFloat @intFromPtr @log @log10 @log2 @max @memcpy
  \ @memset @min @mod @mulAdd @mulWithOverflow @offsetOf @panic @popCount
  \ @prefetch @ptrCast @ptrFromInt @reduce @rem @returnAddress @round @select
  \ @setAlignStack @setCold @setEvalBranchQuota @setFloatMode
  \ @setRuntimeSafety @shlExact @shlWithOverflow @shrExact @shuffle @sin
  \ @sizeOf @splat @sqrt @src @subWithOverflow @tagName @tan @trap @trunc
  \ @truncate @typeInfo @typeName @unionInit @volatileCast @wasmMemoryGrow
  \ @wasmMemorySize @workGroupId @workGroupSize @workItemId

hi def link zigBuiltins Function

" Types

syn keyword zigTypeBool    bool
syn match   zigTypeInt     '\v<i\d+>'
syn keyword zigTypeInt     isize comptime_int
syn match   zigTypeUInt    '\v<u\d+>'
syn keyword zigTypeUInt    usize
syn keyword zigTypeFloat   comptime_float f16 f32 f64 f80 f128
syn keyword zigTypeStruct  enum error opaque struct union
syn keyword zigTypeGeneric anyerror anyframe anyopaque anytype type
syn keyword zigTypeVoid    noreturn void

hi def link zigTypeBool    zigType
hi def link zigTypeInt     zigType
hi def link zigTypeUInt    zigType
hi def link zigTypeFloat   zigType
hi def link zigTypeStruct  zigType
hi def link zigTypeGeneric zigType
hi def link zigTypeVoid    zigType

syn keyword zigTypeC
  \ c_int c_short c_long c_longdouble c_longlong
  \ c_uint c_ushort c_ulong c_ulonglong

hi def link zigTypeC zigType

hi def link zigType Type

" -----------------------------------------------------------------------------
" Literals

runtime! syntax/zig-literals.vim

" -----------------------------------------------------------------------------
" Blocks

syn region zigParen start="("  end=")"  transparent fold
syn region zigSqrBr start="\[" end="\]" transparent fold
syn region zigBlock start="{"  end="}"  transparent fold

" -----------------------------------------------------------------------------

let b:current_syntax = 'zig'

let &cpo = s:save_cpo
unlet! s:save_cpo
