#!/bin/sh -e

cat > /etc/vim/vimrc.local <<EOF
set background=dark
syntax on
set hlsearch

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

set spell spelllang=en_us
let g:tex_comment_nospell=1
set shiftwidth=4
set tabstop=4

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.PT,*.TT2 let &bin=1
  au BufReadPost *.PT,*.TT2 if &bin | %!xxd
  au BufReadPost *.PT,*.TT2 set ft=xxd | endif
  au BufWritePre *.PT,*.TT2 if &bin | %!xxd -r
  au BufWritePre *.PT,*.TT2 endif
  au BufWritePost *.PT,*.TT2 if &bin | %!xxd
  au BufWritePost *.PT,*.TT2 set nomod | endif
augroup END

let g:syntastic_python_python_exec = 'python'
EOF

user=$(getent passwd 1000 | cut -d: -f1)
echo "==> Setting up the python vim IDE for $user"
su -c "vim-addons install python-jedi" $user

