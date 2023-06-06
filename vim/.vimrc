set nocompatible

set history=100
set nobackup
set autoread
set encoding=utf8
set fileformats=unix,dos,mac
set sessionoptions-=options
set sessionoptions-=folds

" -----------------------------------------------------------------------------
" UI

set colorcolumn=80
set nonumber
set relativenumber
set signcolumn=number
set ruler
set laststatus=2
set mouse=a
set ttymouse=sgr
set nomodeline
set wildmenu
set showcmd
set updatetime=500
set balloondelay=250
set completeopt+=popup
set completepopup=align:menu,highlight:Pmenu
set splitbelow
set splitright

if ! has('gui_running')
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
  return &expandtab == 1 ? 'S' : 'T'
endfunction

" -----------------------------------------------------------------------------
" File formatting and editing

syntax on

set listchars=precedes:…,tab:-›,space:·,trail:·,extends:…,eol:¶
set wrap
set autoindent
filetype indent on
set smarttab
set expandtab tabstop=2 shiftwidth=2
set noendofline nofixendofline

autocmd BufRead,BufNewFile go.mod setlocal filetype=gomod
autocmd BufRead,BufNewFile go.sum setlocal filetype=gosum
autocmd BufRead,BufNewFile *.astro setlocal filetype=html
autocmd BufRead,BufNewFile *.gohtml setlocal filetype=gohtml
autocmd BufRead,BufNewFile *.gotmpl,*.gotxt,*.tmpl setlocal filetype=gotmpl
autocmd BufRead,BufNewFile *.slide setlocal filetype=markdown
autocmd BufRead,BufNewFile *.svelte setlocal filetype=html
autocmd BufRead,BufNewFile *.trigger setlocal filetype=sh
autocmd BufRead,BufNewFile *.v setlocal filetype=v
autocmd BufRead,BufNewFile *.vue setlocal filetype=html
autocmd BufRead,BufNewFile *.zig setlocal filetype=zig
autocmd BufRead,BufNewFile *.zir setlocal filetype=zir

autocmd Filetype c setlocal noexpandtab
autocmd Filetype cpp setlocal noexpandtab
autocmd Filetype go,gomod,gosum setlocal noexpandtab
autocmd Filetype make setlocal noexpandtab
autocmd Filetype markdown setlocal tabstop=4 shiftwidth=4
autocmd Filetype python setlocal tabstop=4 shiftwidth=4
autocmd Filetype rst setlocal tabstop=4 shiftwidth=4
autocmd Filetype sh setlocal noexpandtab
autocmd Filetype v setlocal noexpandtab
autocmd Filetype zig,zir setlocal tabstop=4 shiftwidth=4

" -----------------------------------------------------------------------------
" Searching

set incsearch
set hlsearch
set magic

" -----------------------------------------------------------------------------
" Keys

nmap <Space> <Leader>

set backspace=indent,eol,start

" vimgrep
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

" -----------------------------------------------------------------------------
" Commands

" -----------------------------------------------------------------------------
" Plugins

filetype plugin on

"""""""""""
" vim-lsp "
"""""""""""

"let g:lsp_diagnostics_enabled = 0
"let g:lsp_document_highlight_enabled = 0
"highlight lspReference ctermfg=red guifg=red ctermbg=green guibg=green

if executable('gopls')
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['gopls']},
    \ 'allowlist': ['go'],
    \ })
endif

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  nmap <buffer> <Leader>s <plug>(lsp-document-symbol-search)
  nmap <buffer> <Leader>S <plug>(lsp-workspace-symbol-search)
  nmap <buffer> <Leader>d <plug>(lsp-peek-definition)
  nmap <buffer> <Leader>D <plug>(lsp-definition)
  nmap <buffer> <Leader>i <plug>(lsp-peek-implementation)
  nmap <buffer> <Leader>I <plug>(lsp-implementation)
  nmap <buffer> <Leader>t <plug>(lsp-peek-type-definition)
  nmap <buffer> <Leader>T <plug>(lsp-type-definition)
  nmap <buffer> <Leader>R <plug>(lsp-references)
  nmap <buffer> <Leader>, <plug>(lsp-previous-reference)
  nmap <buffer> <Leader>. <plug>(lsp-next-reference)
  nmap <buffer> <Leader>! <plug>(lsp-next-diagnostic)

  nmap <buffer> <Leader>r <plug>(lsp-rename)

  nmap <buffer> <Leader><Space> <plug>(lsp-hover)
  nmap <buffer> <expr><c-j> lsp#scroll(+4)
  nmap <buffer> <expr><c-k> lsp#scroll(-4)

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre * call execute('LspDocumentFormatSync')

  " File type.
  "autocmd FileType go nmap <buffer> gd <plug>(lsp-definition)

  " File extension.
  "autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction
