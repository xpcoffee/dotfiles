" Author: Rick Bosch

" Plugins
  " Vundle Begin
    set nocompatible                    " be iMproved required for Vundle
    filetype off                        " required for Vundle

    " set runtime path to include Vundle
    set rtp+=~/.vim/bundle/Vundle.vim
    " initialize
    call vundle#begin()

  "Installed Plugins
    " core
    Plugin 'gmarik/Vundle.vim'
    Plugin 'scrooloose/nerdtree'

    " ruby
    " Plugin 'tpope/vim-rbenv'
    Plugin 'vim-scripts/ruby-matchit'

    " rust
    "Plugin 'rust-lang/rust.vim'

    " movement
    Plugin 'Lokaltog/vim-easymotion'

    " input
    Plugin 'tpope/vim-surround'
    " Plugin 'godlygeek/tabular'

    " syntax
    Plugin 'vim-syntastic/syntastic'
    Plugin 'peitalin/vim-jsx-typescript'

    " colour
    Plugin 'chriskempson/base16-vim'

    " autocompletion
    " Plugin 'ervandew/supertab'
    Plugin 'Valloric/YouCompleteMe'

    " status bar
    " Plugin 'bling/vim-airline'
    " Plugin 'vim-airline/vim-airline-themes'

    " git
    Plugin 'tpope/vim-fugitive'
    Plugin 'kien/ctrlp.vim'

    " Vundle end
    call vundle#end()            " required
    filetype plugin indent on

  "let g:ruby_path = system('rbenv prefix')

" Bindings
  " leader
  let mapleader=","

  " edit .vimrc
  nnoremap <leader>v :e ~/.vimrc<CR>

  " source .vimrc
  nnoremap <leader>o :so %<CR>

  map <space> <Plug>(easymotion-prefix)

  " run ruby
  nnoremap <leader>r :!/usr/bin/env ruby %<CR>

  " edit .vimrc
  nnoremap <Left> :bp<CR>

  " edit .vimrc
  nnoremap <Right> :bn<CR>

  " source rc file
  nnoremap <leader>s :so ~/.vimrc<CR>:nohl<CR>

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
  if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
  endif

  " let g:airline_powerline_fonts = 1
  " let g:airline_theme='base16_eighties'

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

" Performance
  set lazyredraw  " no output while running macro
  set ttyfast     " better redrawing

" indentations
  set smarttab     " makes tabs at the beginning of a line an indent
  set shiftwidth=4 " size of indent
  set tabstop=4    " size of tab
  set autoindent   " new line has indent of previous line
  set expandtab    " converts tabs to spaces
