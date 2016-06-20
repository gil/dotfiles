set encoding=utf-8
set binary

set history=1000

" syntax highlight
syntax on

set number " precede each line with its line number
set relativenumber " set relative line numbers
set textwidth=0 " Do not wrap words (insert)
set nowrap " Do not wrap words (view)
set backspace=indent,eol,start " fix backspace behaviour
set autoindent " automatically indent new line
set nobackup " do not write backup files
set showmatch " Show matching brackets.
set laststatus=2 " always show the status lines
" filetype indent on
set wildmenu " visual menu for file and command auto complete (like zsh)
set splitbelow " open split bellow the current

set ts=2 " number of spaces in a tab
set sw=2 " number of spaces for indent
set et " expand tabs into spaces

" search settings
set incsearch " Incremental search
set hlsearch " Highlight search match
set ignorecase " Do case insensitive matching
set smartcase " do not ignore if search pattern has CAPS

" highlight current line (and optionally column)
au WinLeave * set nocursorline "nocursorcolumn
au WinEnter * set cursorline "cursorcolumn
set cursorline "cursorcolumn

" key mappings
inoremap jj <Esc>
let mapleader = "\<Space>"
map <C-n> :NERDTreeToggle<CR>
nmap <leader>n :NERDTreeFind<CR>
nmap <leader>h :noh<CR>
"map <leader>t :bufdo tab split<CR>
map <leader>t :TagbarToggle<CR>
" inoremap <C-X><C-F> <C-O>:lcd %:p:h<CR><C-X><C-F>
map <leader>md :silent !open -a Marked.app '%:p'<cr>
map <leader>ns :Dispatch npm start<cr>

" ctrlp.vim
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = '\v[\/]\.?(git|node_modules)$'
nmap <leader>p :CtrlPBuffer<cr>
nmap <leader>o :CtrlPMRU<cr>

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" disable arrows for visual mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
" disable arrows for insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" vundle and plugins
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/syntastic'
Plugin 'rking/ag.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'ahayman/vim-nodejs-complete'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'majutsushi/tagbar'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-sleuth'
Plugin 'othree/html5.vim'

call vundle#end()
filetype plugin indent on

" The Silver Searcher config
let g:ag_prg="ag --vimgrep --silent"

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" activate color scheme (theme)
set background=dark
colorscheme solarized

" spell check
set spellfile=$HOME/.vim/spell/en.utf-8.add
set complete+=kspell