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

set statusline=
set statusline+=%#Normal#
set statusline+=\ ⬓
set statusline+=%#Number#\ [%n]
set statusline+=%#Title#\ %t\ %m
set statusline+=\ %=
set statusline+=%#Number#
set statusline+=\ %l:%c%V
set statusline+=\ %<
set statusline+=%P
set statusline+=\ %#DiffAdd#\|
set statusline+=\ %{&term}
set statusline+=\ \|
set statusline+=\ %{&fileformat}
set statusline+=\ \|
set statusline+=\ %{&encoding}
set statusline+=\ \|
set statusline+=\ %{TabStyle()}:\ %{&shiftwidth}
set statusline+=\ \|
set statusline+=\ %Y
set statusline+=\ \|%#Normal#

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

