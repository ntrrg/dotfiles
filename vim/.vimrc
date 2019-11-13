set nocompatible

set history=100
set nobackup
set autoread
set encoding=utf8
set ffs=unix,dos,mac
set sessionoptions-=options
set sessionoptions-=folds

" Interface
set nonumber
set relativenumber
set ruler
set laststatus=2
set mouse=a
set nomodeline
set wildmenu
set showcmd
set splitbelow
set splitright

if ! has("gui_running")
  set t_Co=256
endif

set background=dark
colors peaksea

" if &background=='light'
"   hi PrePro guifg=#009030 guibg=NONE gui=NONE
" 
"   if &t_Co==256
"     hi PreProc ctermfg=28 ctermbg=NONE cterm=NONE
"   endif
" elseif &background=='dark'
"   hi PreProc guifg=#60f080 guibg=NONE gui=NONE
" 
"   if &t_Co==256
"     hi PreProc ctermfg=28 ctermbg=NONE cterm=NONE
"   endif
" endif

set statusline=
set statusline+=%#Normal#
set statusline+=\ ⬓
set statusline+=%#PreProc#\ [%n]\ %t\ %m
set statusline+=\ %=
set statusline+=%#Number#
set statusline+=\ %l:%c%V
set statusline+=\ %<
set statusline+=\ %P
set statusline+=\ %#DiffDelete#\|\ %{&term}\ \|%#Normal#
set statusline+=\ %#DiffDelete#\|\ %{&fileformat}\ \|%#Normal#
set statusline+=\ %#DiffDelete#\|\ %{&encoding}\ \|%#Normal#
set statusline+=\ %#DiffDelete#\|\ %{TabStyle()}:\ %{&shiftwidth}\ \|%#Normal#
set statusline+=\ %#DiffDelete#\|\ %Y\ \|%#Normal#

function! TabStyle()
  return &expandtab == 1 ? "Spaces" : "Tabs"
endfunction

" File formatting and editing
syntax on

set listchars=precedes:…,tab:-›,space:·,trail:·,extends:…,eol:¶
set wrap
set autoindent
set smarttab
set expandtab tabstop=2 shiftwidth=2
autocmd Filetype go setlocal noexpandtab
autocmd Filetype c setlocal noexpandtab
autocmd Filetype cpp setlocal noexpandtab
autocmd Filetype make setlocal noexpandtab
autocmd Filetype markdown setlocal tabstop=4 shiftwidth=4
autocmd Filetype python setlocal tabstop=4 shiftwidth=4
autocmd Filetype rst setlocal tabstop=4 shiftwidth=4

" Searching
set incsearch
set hlsearch
set magic

" Keys
set backspace=indent,eol,start

" Keys - vimgrep
nnoremap [q :cprev
nnoremap ]q :cnext
nnoremap [Q :cfirst
nnoremap ]Q :clast

" Commands

