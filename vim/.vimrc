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

set tabstop=2 " number of spaces in a tab
set shiftwidth=2 " number of spaces for indent
set expandtab " expand tabs into spaces
":let g:detectindent_preferred_expandtab = 1
":let g:detectindent_preferred_indent = 2
:autocmd BufReadPost * :DetectIndent

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
"map <leader>t :TagbarToggle<CR>
" inoremap <C-X><C-F> <C-O>:lcd %:p:h<CR><C-X><C-F>
map <leader>md :silent !open -a Marked.app '%:p'<cr>
"map <leader>ns :Dispatch npm start<cr>
map <leader>ns :VimuxRunCommand "npm start"<cr>
nmap <leader>w :set wrap!<CR>
nmap <leader>r :so $MYVIMRC<CR>
nmap <leader>l :redraw!<CR>

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

let g:syntastic_javascript_checkers = ['eslint', 'jshint']

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
Plugin 'mileszs/ack.vim'
Plugin 'pangloss/vim-javascript'
"Plugin 'ahayman/vim-nodejs-complete'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
"Plugin 'majutsushi/tagbar'
Plugin 'plasticboy/vim-markdown'
Plugin 'tpope/vim-dispatch'
"Plugin 'tpope/vim-sleuth'
Plugin 'ciaranm/detectindent'
Plugin 'othree/html5.vim'
Plugin 'valloric/MatchTagAlways'
Plugin 'tpope/vim-fugitive'
Plugin 'w0ng/vim-hybrid'
Plugin 'benmills/vimux'
Plugin 'christoomey/vim-tmux-navigator'

call vundle#end()
filetype plugin indent on

" The Silver Searcher(Ag) config for Ack plugin
let g:ack_use_dispatch = 1
if executable('ag')
	let g:ackprg = 'ag --vimgrep --silent --max-count 1'
endif

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" MatchTagAlways
let g:mta_filetypes = {
			\ 'html'  : 1,
			\ 'xhtml' : 1,
			\ 'xml'   : 1,
			\ 'inc' 	: 1,
			\ 'tmpl'  : 1,	
			\}

" DetectIndent
:let g:detectindent_preferred_when_mixed = 1
:let g:detectindent_preferred_expandtab = 1
:let g:detectindent_preferred_indent = 2

" activate color scheme (theme)
set background=dark
"colorscheme solarized
let g:hybrid_custom_term_colors = 1
colorscheme hybrid

" spell check
set spellfile=$HOME/.vim/spell/en.utf-8.add
set complete+=kspell