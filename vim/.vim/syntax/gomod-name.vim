" Vim syntax file
" Language:     Go
" Maintainer:   Miguel Angel Rivera Notararigo (https://ntrrg.dev)
" Last Change:  2022 May 25
" NOTE:         Go module naming.

" -----------------------------------------------------------------------------
" Package name

syn match goModName display #"\?[A-Za-z0-9\-._~!$&'()*+,;=:@%/]\+"\?$#
syn match goModName display #"\?[A-Za-z0-9\-._~!$&'()*+,;=:@%/]\+"\?\s#he=e-1

hi def link goModName String
