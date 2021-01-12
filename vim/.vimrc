set nocompatible

set history=100
set nobackup
set autoread
set encoding=utf8
set fileformats=unix,dos,mac
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
colors monokai

hi def link stNormal     Normal
hi def link stBuffNumber Number
hi def link stBuffName   Title
hi def link stBuffPos    Number
hi def link stBuffProps  Identifier

set statusline=
set statusline+=%#stNormal#
set statusline+=\ ⬓\ 

set statusline+=%#stBuffNumber#
set statusline+=[%n]

set statusline+=%#stNormal#\ 

set statusline+=%#stBuffName#
set statusline+=%t\ %m

set statusline+=%#stNormal#
set statusline+=\ %=\ 

set statusline+=%#stBuffPos#
set statusline+=%l:%c%V

set statusline+=%#stNormal#
set statusline+=\ %<

set statusline+=%#stBuffPos#
set statusline+=%P

set statusline+=%#stNormal#\ 

set statusline+=%#stBuffProps#
set statusline+=\|\ %{&term}\ 
set statusline+=\|\ %{&fileformat}\ 
set statusline+=\|\ %{&encoding}\ 
set statusline+=\|\ %{TabStyle()}:%{&shiftwidth}\ 
set statusline+=\|\ %Y\ 
set statusline+=\|

function! TabStyle()
  return &expandtab == 1 ? "S" : "T"
endfunction

" File formatting and editing
syntax on

set listchars=precedes:…,tab:-›,space:·,trail:·,extends:…,eol:¶
set wrap
set autoindent
set smarttab
set expandtab tabstop=2 shiftwidth=2
set noendofline nofixendofline

autocmd BufRead,BufNewFile go.mod setlocal filetype=gomod
autocmd BufRead,BufNewFile *.gohtml setlocal filetype=gohtmltmpl
autocmd BufRead,BufNewFile *.gotxt setlocal filetype=gotexttmpl
autocmd BufRead,BufNewFile *.tmpl setlocal filetype=gohtmltmpl
autocmd BufRead,BufNewFile *.trigger setlocal filetype=sh

autocmd Filetype go,gomod setlocal noexpandtab
autocmd Filetype c setlocal noexpandtab
autocmd Filetype cpp setlocal noexpandtab
autocmd Filetype make setlocal noexpandtab
autocmd Filetype markdown setlocal tabstop=4 shiftwidth=4
autocmd Filetype python setlocal tabstop=4 shiftwidth=4
autocmd Filetype rst setlocal tabstop=4 shiftwidth=4
autocmd Filetype sh setlocal noexpandtab

" Searching
set incsearch
set hlsearch
set magic

" Keys
set backspace=indent,eol,start

" Keys - vimgrep
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

" Commands

" Plugins
" filetype plugin indent on
