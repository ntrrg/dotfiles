hi clear

if exists("syntax_on")
  syntax reset
endif

set t_Co=16
let g:colors_name = "monokai"

hi Normal ctermfg=7    ctermbg=NONE cterm=NONE

if &background ==# 'light'
  hi Normal ctermfg=0    ctermbg=15 cterm=NONE
endif

hi Comment        ctermfg=8    ctermbg=NONE cterm=NONE
hi Todo           ctermfg=9    ctermbg=NONE cterm=bold
hi Directory      ctermfg=4    ctermbg=NONE cterm=NONE
hi Keyword        ctermfg=1    ctermbg=NONE cterm=NONE
hi Statement      ctermfg=1    ctermbg=NONE cterm=NONE
hi Define         ctermfg=1    ctermbg=NONE cterm=NONE
hi StorageClass   ctermfg=6    ctermbg=NONE cterm=NONE
hi Conditional    ctermfg=1    ctermbg=NONE cterm=NONE
hi Label          ctermfg=3    ctermbg=NONE cterm=NONE
hi PreProc        ctermfg=1    ctermbg=NONE cterm=NONE
hi Special        ctermfg=11   ctermbg=NONE cterm=bold
hi SpecialComment ctermfg=3    ctermbg=NONE cterm=NONE
hi SpecialKey     ctermfg=1    ctermbg=NONE cterm=NONE
hi SpecialChar    ctermfg=5    ctermbg=NONE cterm=NONE
hi Operator       ctermfg=1    ctermbg=NONE cterm=NONE
hi MatchParen     ctermfg=1    ctermbg=NONE cterm=NONE
hi Identifier     ctermfg=2    ctermbg=NONE cterm=NONE
hi Function       ctermfg=2    ctermbg=NONE cterm=NONE
hi Type           ctermfg=6    ctermbg=NONE cterm=NONE
hi Constant       ctermfg=5    ctermbg=NONE cterm=NONE
hi Boolean        ctermfg=5    ctermbg=NONE cterm=NONE
hi Character      ctermfg=5    ctermbg=NONE cterm=NONE
hi Number         ctermfg=5    ctermbg=NONE cterm=NONE
hi Float          ctermfg=5    ctermbg=NONE cterm=NONE
hi String         ctermfg=3    ctermbg=NONE cterm=NONE
hi Tag            ctermfg=1    ctermbg=NONE cterm=NONE
hi NonText        ctermfg=8    ctermbg=NONE cterm=NONE
hi Underlined     ctermfg=NONE ctermbg=NONE cterm=underline

" UI
hi Cursor       ctermfg=NONE ctermbg=NONE cterm=inverse
hi CursorLine   ctermfg=NONE ctermbg=NONE cterm=inverse
hi CursorLineNr ctermfg=NONE ctermbg=NONE cterm=inverse
hi CursorColumn ctermfg=NONE ctermbg=NONE cterm=inverse
hi ColorColumn  ctermfg=NONE ctermbg=NONE cterm=inverse
hi SignColumn   ctermfg=8    ctermbg=NONE cterm=NONE
hi LineNr       ctermfg=8    ctermbg=NONE cterm=NONE
hi Visual       ctermfg=0    ctermbg=7    cterm=NONE
hi IncSearch    ctermfg=0    ctermbg=2    cterm=bold
hi Search       ctermfg=0    ctermbg=2    cterm=bold
hi Folded       ctermfg=4    ctermbg=NONE cterm=NONE
hi Conceal      ctermfg=7    ctermbg=8    cterm=NONE
hi Pmenu        ctermfg=NONE ctermbg=NONE cterm=NONE
hi PmenuSel     ctermfg=NONE ctermbg=NONE cterm=inverse
hi PmenuSbar    ctermfg=NONE ctermbg=NONE cterm=NONE
hi PmenuThumb   ctermfg=NONE ctermbg=NONE cterm=inverse
hi TabLine      ctermfg=8    ctermbg=NONE cterm=NONE
hi TabLineSel   ctermfg=NONE ctermbg=NONE cterm=bold
hi TabLineFill  ctermfg=NONE ctermbg=NONE cterm=NONE
hi VertSplit    ctermfg=NONE ctermbg=NONE cterm=NONE
hi StatusLine   ctermfg=7    ctermbg=NONE cterm=bold
hi StatusLineNC ctermfg=7    ctermbg=NONE cterm=NONE
hi Title        ctermfg=NONE ctermbg=NONE cterm=bold
hi ModeMsg      ctermfg=NONE ctermbg=NONE cterm=bold
hi MoreMsg      ctermfg=10   ctermbg=NONE cterm=NONE
hi ErrorMsg     ctermfg=9    ctermbg=NONE cterm=NONE
hi WarningMsg   ctermfg=11   ctermbg=NONE cterm=NONE
hi Question     ctermfg=10   ctermbg=NONE cterm=NONE
hi SpellBad     ctermfg=9    ctermbg=NONE cterm=bold
hi SpellCap     ctermfg=12   ctermbg=NONE cterm=bold
hi SpellLocal   ctermfg=14   ctermbg=NONE cterm=bold
hi SpellRare    ctermfg=13   ctermbg=NONE cterm=bold

" Diff
hi DiffChange    ctermfg=NONE ctermbg=NONE cterm=NONE
hi DiffText      ctermfg=12   ctermbg=NONE cterm=bold
hi DiffAdd       ctermfg=10   ctermbg=NONE cterm=bold
hi DiffDelete    ctermfg=9    ctermbg=NONE cterm=bold
hi diffAdded     ctermfg=10   ctermbg=NONE cterm=NONE
hi diffFile      ctermfg=14   ctermbg=NONE cterm=NONE
hi diffIndexLine ctermfg=8    ctermbg=NONE cterm=NONE
hi diffLine      ctermfg=14   ctermbg=NONE cterm=NONE
hi diffRemoved   ctermfg=9    ctermbg=NONE cterm=NONE
hi diffSubname   ctermfg=8    ctermbg=NONE cterm=NONE

" Netrw
hi netrwPlain   ctermfg=NONE ctermbg=NONE cterm=NONE
hi netrwDir     ctermfg=4    ctermbg=NONE cterm=NONE
hi netrwSpecial ctermfg=5    ctermbg=NONE cterm=NONE
hi netrwSymLink ctermfg=6    ctermbg=NONE cterm=NONE
hi netrwExe     ctermfg=2    ctermbg=NONE cterm=NONE
