set encoding=utf-8
set binary

set history=1000
syntax on

set number " precede each line with its line number
set textwidth=0 " Do not wrap words (insert)
set nowrap " Do not wrap words (view)
set backspace=indent,eol,start " fix backspace behaviour
set autoindent " automatically indent new line
set nobackup " do not write backup files
set showmatch " Show matching brackets.
set laststatus=2 " always show the status lines
" filetype indent on

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
nmap <leader>p :NERDTreeFind<CR>
map <leader>t :bufdo tab split<CR>

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

call vundle#end()
filetype plugin indent on

" activate color scheme (theme)
set background=dark
colorscheme solarized