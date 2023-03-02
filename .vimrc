" Author:               Emerick Bosch


" Plugins
    if empty(glob('~/dev/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/dev/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source '~/dev/.vimrc'
    endif


call plug#begin('~/dev/.vim/plugged')
  "Installed Plugins
    " core
    Plug 'gmarik/Vundle.vim'
    Plug 'scrooloose/nerdtree'

    " languages
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'peitalin/vim-jsx-typescript'
    Plug 'pangloss/vim-javascript'
    Plug 'leafgarland/typescript-vim'
    Plug 'godlygeek/tabular'
    Plug 'plasticboy/vim-markdown'

    " Wiki
    Plug 'vimwiki/vimwiki'

    " movement
    Plug 'Lokaltog/vim-easymotion'

    " input
    Plug 'tpope/vim-surround'

    " syntax
    " Disabled because extremely slow startup (2s)
    " Plug 'vim-syntastic/syntastic'

    " colour
    Plug 'chriskempson/base16-vim'

    " git
    Plug 'tpope/vim-fugitive'
    Plug 'kien/ctrlp.vim'
    Plug 'zivyangll/git-blame.vim'

call plug#end()

" Global
  filetype plugin indent on
  filetype plugin on
  set nocompatible

" CoC

  " if hidden is not set, TextEdit might fail.
  set hidden

  " Better display for messages
  set cmdheight=2

  " You will have bad experience for diagnostic messages when it's default 4000.
  set updatetime=300

  " don't give |ins-completion-menu| messages.
  set shortmess+=c

  " always show signcolumns
  set signcolumn=yes

  let g:coc_global_extensions = ['coc-tsserver', 'coc-html', 'coc-json', 'coc-sh', 'coc-markdownlint']


" Bindings
  " leader
  let mapleader=","

  " edit .vimrc
  nnoremap <leader>v :e ~/dev/.vimrc<CR>

  " source .vimrc
  nnoremap <leader>o :so %<CR>

  " EasyMotion
  map <space> <Plug>(easymotion-prefix)

  " backspace should work as expected
  set backspace=indent,eol,start  " more powerful backspacing

  " run the content of the file
  nnoremap <leader>r :echo "No execution binding set up for this type of file."<CR>

  " edit .vimrc
  nnoremap <Left> :bp<CR>

  " edit .vimrc
  nnoremap <Right> :bn<CR>

  " source rc file
  nnoremap <leader>s :so ~/dev/.vimrc<CR>:nohl<CR>

  " automatic bracket completion in INSERT mode
  inoremap {<Enter> {<Enter>}<Esc>O<Tab>

  " remap ctrl-F to autocomplete file-names in INSERT mode
  inoremap <C-f> <C-x><C-f>

  " NERDTree
  nnoremap <Up> :NERDTreeToggle<CR>
  nnoremap <Down> :NERDTreeFind<CR>

  " Speed up ctrl p
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard']

  " FKeys
  nnoremap <F10> :nohl<CR>

  " Move lines up or down
  nnoremap <C-j> :m .+1<CR>==
  nnoremap <C-k> :m .-2<CR>==
  inoremap <C-j> <Esc>:m .+1<CR>==gi
  inoremap <C-k> <Esc>:m .-2<CR>==gi
  vnoremap <C-j> :m '>+1<CR>gv=gv
  vnoremap <C-k> :m '<-2<CR>gv=gv

  " Blame
  nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

" Appearance
  set showmatch       " show matching bracket
  set number          " line numbers
  set scrolloff=20    " scroll to keep cursor # lines from screen edge
  set laststatus=2    " always show file path
  syntax on           " syntax highlighting
  set t_Co=256        " enable 256 colour terminal
  set textwidth=120
  set list
  set listchars=tab:>-
  set cursorline
  if filereadable(expand("~/dev/.vimrc_background"))
    let base16colorspace=256
    source ~/dev/.vimrc_background
  endif

" Languages
  au BufNewFile,BufRead,BufReadPost *.mdx set syntax=markdown

" Input
  " keyboard
  set whichwrap+=<,>,h,l

  " mouse
  set mouse=a  " allow mouse-click

  "format json
  command FormatJSON %!python -m json.tool

  " line wraping
  set textwidth=0    " don't automatically wrap lines

  " autocompletion
  set wildmenu               " tab-completion in command-mode
  set wildmode=longest,list  " filename completion, show list if many

" Searching and highlighting
  " within buffer
  set incsearch  " incremental search
  set hlsearch   " highlight all matches

  " vim grep
  set grepprg=ag\ --nogroup\ --nocolor
  set grepformat=%f:%l:%c:%m

  " speed up ctrl P
  let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

" Whitespace
  fun! TrimWhitespace()
      let l:save = winsaveview()
      %s/\s\+$//e
      call winrestview(l:save)
  endfun

  autocmd BufWritePre * :call TrimWhitespace() " trim whitespace before saving

" Wiki
  let g:vimwiki_list = [{'path': '~/vimwiki/', 'auto_generate_links': 1}]
  let g:vimwiki_list = [{'path': '~/vimwiki/', 'auto_generate_tags': 1}]

" Performance
  set lazyredraw  " no output while running macro
  set ttyfast     " better redrawing

" indentations
  set smarttab     " makes tabs at the beginning of a line an indent
  set shiftwidth=2 " size of indent
  set tabstop=2    " size of tab
  set autoindent   " new line has indent of previous line
  set expandtab    " converts tabs to spaces

