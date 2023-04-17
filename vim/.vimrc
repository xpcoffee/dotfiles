" Author: Emerick Bosch

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

    " UI enhancement
    Plug 'markonm/traces.vim'
    Plug 'preservim/nerdtree'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'airblade/vim-gitgutter'


    " colour
    Plug 'morhetz/gruvbox'
    Plug 'chriskempson/base16-vim'

    " git
    Plug 'tpope/vim-fugitive'
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

  " always show signcolumns
  set signcolumn=yes

  let g:coc_global_extensions = ['coc-tsserver', 'coc-html', 'coc-json', 'coc-sh', 'coc-markdownlint']


"Airline
  let g:airline_powerline_fonts = 1

  if !exists('g:airline_symbols')
      let g:airline_symbols = {}
  endif

  " unicode symbols
  let g:airline_left_sep = '»'
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '«'
  let g:airline_right_sep = '◀'
  let g:airline_symbols.linenr = '␊'
  let g:airline_symbols.linenr = '␤'
  let g:airline_symbols.linenr = '¶'
  let g:airline_symbols.branch = '⎇'
  let g:airline_symbols.paste = 'ρ'
  let g:airline_symbols.paste = 'Þ'
  let g:airline_symbols.paste = '∥'
  let g:airline_symbols.whitespace = 'Ξ'

  " airline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''

  let g:airline#extensions#tabline#enabled = 1
  let g:airline_section_y = ''
  let g:airline_section_z = 'ಠ_ಠ'


" Bindings
  " leader
  let mapleader=","

  " [ reqular use ]
  " edit vimrc
  nnoremap <leader>v :e ~/dev/.vimrc<CR>
  " source vimrc
  nnoremap <leader>s :so ~/dev/.vimrc<CR>:nohl<CR>
  " milinks
  nnoremap <leader>l :e ~/.milinks.json<CR>


  " [ current file ]
  " source
  nnoremap <leader>o :so %<CR>
  " run
  nnoremap <leader>r :echo "No execution binding set up for this type of file."<CR>

  " [ vim behaviour ]
  " backspace should work as expected
  set backspace=indent,eol,start  " more powerful backspacing

  " [ autocomplete ]
  " file names
  inoremap <C-f> <C-x><C-f>
  " brackets
  inoremap {<Enter> {<Enter>}<Esc>O<Tab>

  " [ File managment ]
  nnoremap <Down> :NERDTreeToggle<CR>
  nnoremap <Up> :GFiles<CR>
  nnoremap <C-b> :Buffers<CR>
  nnoremap <Left> :bp<CR>
  nnoremap <Right> :bn<CR>

  " [ Buffer navigation ]
  map <space> <Plug>(easymotion-prefix)
  map <C-m> :Marks<CR>

  " [ Vim commands ]
  nnoremap <C-r> :History:<CR>

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
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  autocmd vimenter * ++nested colorscheme gruvbox

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

