" indentation
setlocal  tabstop=2
setlocal  shiftwidth=2
set re=1 " old regular expression functionality is MUCH faster for ruby syntax highlighting
" run ruby
nnoremap <leader>r :!/usr/bin/env ruby %<CR>
