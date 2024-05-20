" CoC
  " if hidden is not set, TextEdit might fail.
  set hidden

  " Better display for messages
  set cmdheight=2

  " You will have bad experience for diagnostic messages when it's default 4000.
  set updatetime=300

  " always show signcolumns
  set signcolumn=yes

  command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
  let g:coc_global_extensions = ['coc-tsserver', 'coc-html', 'coc-json', 'coc-sh', 'coc-markdownlint']
