hi clear

if exists("syntax_on")
  syntax reset
endif

set t_Co=256
let g:colors_name = "monokai"

if &t_Co==8 || &t_Co==16
elseif &t_Co==256
  hi SpecialKey      ctermfg=59   ctermbg=237  cterm=NONE
  hi NonText         ctermfg=59   ctermbg=NONE cterm=NONE
  hi Directory       ctermfg=148  ctermbg=NONE cterm=NONE
  hi ErrorMsg        ctermfg=231  ctermbg=9    cterm=NONE
  hi IncSearch       ctermfg=235  ctermbg=186  cterm=NONE
  hi Search          ctermfg=NONE ctermbg=NONE cterm=underline,bold,italic
  " hi MoreMsg         ctermfg=NONE ctermbg=NONE cterm=NONE
  " hi ModeMsg         ctermfg=NONE ctermbg=NONE cterm=NONE
  hi LineNr          ctermfg=102  ctermbg=NONE cterm=NONE
  " hi CursorLineNr    ctermfg=NONE ctermbg=NONE cterm=NONE
  " hi Question        ctermfg=NONE ctermbg=NONE cterm=NONE
  hi VertSplit       ctermfg=241  ctermbg=NONE cterm=NONE
  hi Title           ctermfg=231  ctermbg=NONE cterm=bold
  hi Visual          ctermfg=NONE ctermbg=NONE cterm=inverse
  " hi VisualNOS       ctermfg=NONE ctermbg=NONE cterm=NONE
  hi WarningMsg      ctermfg=0    ctermbg=11   cterm=NONE
  " hi WildMenu        ctermfg=NONE ctermbg=NONE cterm=NONE
  hi Folded          ctermfg=242  ctermbg=235  cterm=NONE
  " hi FoldedColumn    ctermfg=NONE ctermbg=NONE cterm=NONE
  hi DiffAdd         ctermfg=231  ctermbg=2    cterm=bold
  hi DiffChange      ctermfg=0    ctermbg=11   cterm=NONE
  hi DiffDelete      ctermfg=231  ctermbg=9    cterm=NONE
  hi DiffText        ctermfg=231  ctermbg=24   cterm=bold
  hi SignColumn      ctermfg=NONE ctermbg=237  cterm=NONE
  " hi Conceal         ctermfg=NONE ctermbg=NONE cterm=NONE
  hi SpellBad        ctermfg=209  ctermbg=NONE cterm=undercurl
  hi SpellCap        ctermfg=69   ctermbg=NONE cterm=undercurl
  hi SpellRare       ctermfg=225  ctermbg=NONE cterm=undercurl
  hi SpellLocal      ctermfg=153  ctermbg=NONE cterm=undercurl
  hi Pmenu           ctermfg=NONE ctermbg=237  cterm=NONE
  hi PmenuSel        ctermfg=NONE ctermbg=59   cterm=NONE
  " hi PmenuSbar       ctermfg=NONE ctermbg=59   cterm=NONE
  hi PmenuThumb      ctermfg=NONE ctermbg=236  cterm=NONE
  hi TabLine         ctermfg=NONE ctermbg=237  cterm=NONE
  hi TabLineSel      ctermfg=NONE ctermbg=235  cterm=bold
  hi TabLineFill     ctermfg=NONE ctermbg=237  cterm=NONE
  hi CursorColumn    ctermfg=NONE ctermbg=237  cterm=NONE
  hi CursorLine      ctermfg=NONE ctermbg=238  cterm=NONE
  hi ColorColumn     ctermfg=NONE ctermbg=237  cterm=NONE
  hi StatusLine      ctermfg=NONE ctermbg=237  cterm=bold
  hi StatusLineNC    ctermfg=NONE ctermbg=237  cterm=NONE
  " hi Normal          ctermfg=231  ctermbg=235  cterm=NONE
  hi Normal          ctermfg=231  ctermbg=NONE cterm=NONE

  hi MatchParen      ctermfg=197  ctermbg=NONE cterm=underline
  " hi ToolbarLine     ctermfg=NONE ctermbg=NONE cterm=NONE
  " hi ToolbarButton   ctermfg=NONE ctermbg=NONE cterm=NONE
  hi Cursor          ctermfg=235  ctermbg=231  cterm=NONE
  hi Boolean         ctermfg=141  ctermbg=NONE cterm=NONE
  hi Character       ctermfg=141  ctermbg=NONE cterm=NONE
  hi Comment         ctermfg=242  ctermbg=NONE cterm=italic
  hi Conditional     ctermfg=81   ctermbg=NONE cterm=NONE
  hi Constant        ctermfg=NONE ctermbg=NONE cterm=NONE
  hi Define          ctermfg=197  ctermbg=NONE cterm=NONE
  hi Float           ctermfg=141  ctermbg=NONE cterm=NONE
  hi Function        ctermfg=148  ctermbg=NONE cterm=NONE
  hi Identifier      ctermfg=148  ctermbg=NONE cterm=NONE
  hi Keyword         ctermfg=197  ctermbg=NONE cterm=NONE
  hi Label           ctermfg=186  ctermbg=NONE cterm=NONE
  hi Number          ctermfg=141  ctermbg=NONE cterm=NONE
  hi Operator        ctermfg=197  ctermbg=NONE cterm=NONE
  hi PreProc         ctermfg=197  ctermbg=NONE cterm=NONE
  hi Special         ctermfg=11   ctermbg=NONE cterm=NONE
  hi SpecialComment  ctermfg=242  ctermbg=NONE cterm=italic
  hi Statement       ctermfg=81   ctermbg=NONE cterm=NONE
  hi StorageClass    ctermfg=81   ctermbg=NONE cterm=NONE
  hi String          ctermfg=186  ctermbg=NONE cterm=NONE
  hi Tag             ctermfg=197  ctermbg=NONE cterm=NONE
  hi Todo            ctermfg=95   ctermbg=NONE cterm=inverse,bold,italic
  hi Type            ctermfg=81   ctermbg=NONE cterm=NONE
  hi Underlined      ctermfg=NONE ctermbg=NONE cterm=underline
  hi Ignore          ctermfg=242  ctermbg=NONE cterm=NONE
  hi Error           ctermfg=231  ctermbg=9    cterm=NONE
endif
