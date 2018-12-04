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
set updatetime=750 " update faster, this helps vim-gitgutter
set lazyredraw " delay drawing when macros and other things are being applied
set ttyfast " smooth redrawing for faster connections
set list " show invisible characters
set listchars=tab:>·,trail:· " but only show tabs and trailing whitespace

set tabstop=4 " number of spaces in a tab (how it looks)
set shiftwidth=4 " number of spaces for indent (how many each tab will add)
set expandtab " expand tabs into spaces
":let g:detectindent_preferred_expandtab = 1
":let g:detectindent_preferred_indent = 2
":autocmd BufReadPost * :DetectIndent

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
"let mapleader = "\<Space>"
let mapleader = ","
map <C-n> :NERDTreeToggle<CR>
nmap <leader>nf :NERDTreeFind<CR>
nmap <leader>h :noh<CR>
"map <leader>t :bufdo tab split<CR>
"map <leader>t :TagbarToggle<CR>
" inoremap <C-X><C-F> <C-O>:lcd %:p:h<CR><C-X><C-F>
map <leader>md :silent !open -a Marked.app '%:p'<cr>
"map <leader>ns :Dispatch npm start<cr>
map <leader>ns :VimuxRunCommand "npm start"<cr>
map <leader>nn :VimuxRunCommand "node \"" . expand('%:p') . "\""<cr>
map <leader>m :VimuxRunCommand "!!\n"<cr>
nmap <leader>w :set wrap!<CR>
nmap <leader>r :so $MYVIMRC<CR>
nmap <leader>l :redraw!<CR>
nmap <leader>e :e<CR>
nmap <leader>E :e!<CR>
nmap <leader>3 :windo e!<CR>
nmap <leader>p :set paste!<CR>

" Send last yank to Clipper
nnoremap <leader>y :call system('nc localhost 8377', @0)<CR>

" Some key maps to make it easier to work with legacy code
nmap <leader><Space> :set ts=4 sw=4 expandtab<CR>
nmap <leader><Tab> :set ts=4 sw=4 noexpandtab<CR>

" Command alias to avoid mistakes
fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun
call SetupCommandAlias('W','w')
call SetupCommandAlias('Wa','wa')
call SetupCommandAlias('E','e')
call SetupCommandAlias('Q','q')

" directory for backup, swap and undo
set backupdir=/tmp//
set directory=/tmp//
set undodir=/tmp//

" ctrlp.vim
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = '\v[\/]\.?(git|node_modules)$'
let g:ctrlp_map = '<leader>O'
"nmap <leader>p :CtrlPBuffer<cr>
nmap <leader>o :CtrlPMRU<cr>

" ale
let g:ale_linters = {
\   'javascript': ['eslint'],
\}

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %code: %%s [%severity%]'

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

" vim-multiple-cursors
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_word_key      = 'N'
let g:multi_cursor_select_all_word_key = '<A-N>'
let g:multi_cursor_start_key           = 'gN'
let g:multi_cursor_select_all_key      = 'g<A-N>'
let g:multi_cursor_next_key            = 'N'
let g:multi_cursor_prev_key            = 'P'
let g:multi_cursor_skip_key            = 'X'
let g:multi_cursor_quit_key            = '<Esc>'

" disable arrows for visual mode
"map <up> <nop>
"map <down> <nop>
"map <left> <nop>
"map <right> <nop>
" disable arrows for insert mode
"imap <up> <nop>
"imap <down> <nop>
"imap <left> <nop>
"imap <right> <nop>

" vundle and plugins
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'altercation/vim-colors-solarized'
Plugin 'w0rp/ale'
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
"Plugin 'ciaranm/detectindent'
Plugin 'othree/html5.vim'
Plugin 'valloric/MatchTagAlways'
Plugin 'tpope/vim-fugitive'
Plugin 'w0ng/vim-hybrid'
Plugin 'benmills/vimux'
Plugin 'christoomey/vim-tmux-navigator'
"Plugin 'chaoren/vim-wordmotion'
Plugin 'airblade/vim-gitgutter'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'gil/vim-csscomb'
Plugin 'ConradIrwin/vim-bracketed-paste'
Plugin 'posva/vim-vue'
Plugin 'easymotion/vim-easymotion'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'Valloric/YouCompleteMe'

if !empty(glob('$OH_MY_GIL_SH/custom/.vimrc'))
  so $OH_MY_GIL_SH/custom/.vimrc
endif

call vundle#end()
filetype plugin indent on

" fzf
map <C-p> :FZF<CR>
"map <C-p> :call fzf#run({ 'source' : 'ag --hidden --ignore .git -g ""' })<CR>

" The Silver Searcher(Ag) config for Ack plugin
let g:ack_use_dispatch = 1
if executable('ag') && !exists('g:ackprg')
	let g:ackprg = 'ag --vimgrep --silent --max-count 1'
endif

" UltiSnips
let g:UltiSnipsExpandTrigger="<leader><tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" MatchTagAlways
let g:mta_filetypes = {
			\ 'html'  : 1,
			\ 'xhtml' : 1,
			\ 'xml'   : 1,
			\ 'inc'   : 1,
			\ 'tmpl'  : 1,
			\}

" DetectIndent
":let g:detectindent_preferred_when_mixed = 1
":let g:detectindent_preferred_expandtab = 1
":let g:detectindent_preferred_indent = 2

" CSScomb
let g:CSScombArguments = '--config ~/.csscomb.json'

" EasyMotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
"nmap s <Plug>(easymotion-overwin-f)
nmap s <Plug>(easymotion-overwin-f2)

" vim-session
set sessionoptions-=options " Don't persist options and mappings because it can corrupt sessions.
set sessionoptions-=buffers " Don't save hidden and unloaded buffers in sessions.
let g:session_autoload = 'yes'
let g:session_autosave = 'yes'
let g:session_autosave_periodic = 5
let g:session_autosave_silent = 1

" activate color scheme (theme)
set background=dark
"colorscheme solarized
let g:hybrid_custom_term_colors = 1
colorscheme hybrid

" spell check
set spellfile=$HOME/.vim/spell/en.utf-8.add
set complete+=kspell