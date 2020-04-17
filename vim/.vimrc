set encoding=utf-8
set binary
set nocompatible
filetype off

set history=1000

" syntax highlight
syntax on

set number " precede each line with its line number
" set relativenumber " set relative line numbers, can be slow
set re=1 " regexpengine, the old version seems to be faster
set textwidth=0 " Do not wrap words (insert)
set nowrap " Do not wrap words (view)
set backspace=indent,eol,start " fix backspace behaviour
set autoindent " automatically indent new line
set nobackup " do not write backup files
"set showmatch " Show matching brackets.
"set matchtime=2 "Make showmatch faster
set laststatus=2 " always show the status lines
" filetype indent on
set wildmenu " visual menu for file and command auto complete (like zsh)
set splitbelow " open split bellow the current
set updatetime=750 " update faster, this helps vim-gitgutter
set lazyredraw " delay drawing when macros and other things are being applied
set ttyfast " smooth redrawing for faster connections
set list " show invisible characters
set listchars=tab:>·,trail:· " but only show tabs and trailing whitespace

set tabstop=2 " number of spaces in a tab (how it looks)
set shiftwidth=2 " number of spaces for indent (how many each tab will add)
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

" remove some input delay (for quicker escape)
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

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
map <leader>Md :silent !open -a Marked.app '%:p'<cr>
"map <leader>ns :Dispatch npm start<cr>
map <leader>ns :VimuxRunCommand "npm start"<cr>
map <leader>nn :VimuxRunCommand "node \"" . expand('%:p') . "\""<cr>
map <leader>m :VimuxRunCommand "!!\n"<cr>
nmap <leader>w :set wrap!<CR>
nmap <leader>r :so $MYVIMRC<CR>
nmap <leader>l :redraw!<CR>:syntax sync fromstart<CR>
nmap <leader>e :e<CR>
nmap <leader>E :e!<CR>
nmap <leader>3 :windo e!<CR>
nmap <leader>p :set paste!<CR>

" Make ctrl+c behave as ESC and also trigger InsertLeave. Trying to get used
" to it because of the annoying Macbook touchbar
inoremap <C-c> <ESC>

" Send last yank to Clipper
nnoremap <leader>y :call system('nc localhost 8377', @0)<CR>

" Some key maps to make it easier to work with legacy code
nmap <leader><Space> :set ts=2 sw=2 expandtab<CR>
nmap <leader><Space><Space> :set ts=4 sw=4 expandtab<CR>
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

" directory for backup and swap
set backupdir=/tmp//
set directory=/tmp//

" unlimited undo
if !isdirectory($HOME . "/.vim/undodir")
    call mkdir($HOME . "/.vim/undodir", "p")
endif
set undofile
set undodir=~/.vim/undodir
let s:undos = split(globpath(&undodir, '*'), "\n")
call filter(s:undos, 'getftime(v:val) < localtime() - (60 * 60 * 24 * 90)')
call map(s:undos, 'delete(v:val)')

" ale
let g:ale_linters = {
\   'javascript': ['eslint'],
\}

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %code: %%s [%severity%]'

" YouCompleteMe
let g:ycm_auto_trigger = 0
let g:ycm_key_invoke_completion = '<C-j>'
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

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, guifg)
    exec 'autocmd FileType nerdtree highlight ' . a:extension .' guifg='. a:guifg
    exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('md', '#3366FF')
call NERDTreeHighlightFile('html', '#E34F26')
call NERDTreeHighlightFile('css', '#3C9AD1')
call NERDTreeHighlightFile('js', '#F7DF1E')
call NERDTreeHighlightFile('jsx', '#61DAFB')
call NERDTreeHighlightFile('rb', '#CC342D')
call NERDTreeHighlightFile('py', '#4B90C6')
call NERDTreeHighlightFile('pl', '#0092CC')
call NERDTreeHighlightFile('yml', 'yellow')
call NERDTreeHighlightFile('config', 'yellow')
call NERDTreeHighlightFile('conf', 'yellow')
call NERDTreeHighlightFile('json', 'yellow')

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

" vim-plug and plugins
if !filereadable(expand('~/.vim/autoload/plug.vim'))
    let answer = confirm('plug.vim not found. Can I download it?', "&Yes\n&No", 1)
    if answer == 1
        call system('curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    endif
endif

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' ", { 'on': ['FZF', 'History'] }
Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'
Plug 'w0rp/ale'
Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'MarcWeber/vim-addon-mw-utils' " for vim-snipmate
Plug 'tomtom/tlib_vim' " for vim-snipmate
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
"Plug 'majutsushi/tagbar'
"Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
"Plug 'tpope/vim-dispatch'
"Plug 'tpope/vim-sleuth'
"Plug 'ciaranm/detectindent'
Plug 'othree/html5.vim'
Plug 'valloric/MatchTagAlways'
Plug 'tpope/vim-fugitive', { 'on': ['Gblame', 'GV'] }
Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'airblade/vim-gitgutter'
"Plug 'altercation/vim-colors-solarized'
Plug 'w0ng/vim-hybrid'
Plug 'benmills/vimux', { 'on': 'VimuxRunCommand' }
Plug 'christoomey/vim-tmux-navigator'
"Plug 'chaoren/vim-wordmotion'
Plug 'bronson/vim-trailing-whitespace'
Plug 'gil/vim-csscomb', { 'on': 'CSScomb' }
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'posva/vim-vue', { 'for': 'vue' }
Plug 'easymotion/vim-easymotion'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
"Plug 'terryma/vim-multiple-cursors'
Plug 'Valloric/YouCompleteMe', { 'do': 'git submodule sync --recursive && git -c fetch.fsckobjects=false -c transfer.fsckobjects=false -c receive.fsckobjects=false submodule update --init --recursive && ./install.py --ts-completer' }
Plug 'wesq3/vim-windowswap'
Plug 'ryanoasis/vim-devicons', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
"Plug 'ap/vim-css-color', { 'for': 'css' }
Plug 'sjl/gundo.vim', { 'on': ['GundoToggle'] }

if !empty(glob('$OH_MY_GIL_SH/custom/.vimrc'))
  so $OH_MY_GIL_SH/custom/.vimrc
endif

call plug#end()

" tmuxline.vim
let g:tmuxline_preset = {
      \'a'    : '#W',
      \'win'  : '#I #W',
      \'cwin' : '#I #W',
      \'x'    : '#H \uf98c',
      \'y'    : "#(uptime | awk '{print $3}' | sed 's/,//g') \uFa51",
      \'z'    : '%R \ue385 ',
      \'options' : {'status-justify' : 'left'}}

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#parts#ffenc#skip_expected_string = '[unix]'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#show_close_button = 0

let g:airline#extensions#tmuxline#enabled = 1
let g:airline#extensions#tmuxline#snapshot_file = $OH_MY_GIL_SH . "/scripts/tools/assets/tmux-statusline-colors.conf"

" vim-snipmate
imap <leader><tab> <Plug>snipMateNextOrTrigger
smap <leader><tab> <Plug>snipMateNextOrTrigger

" gundo
let g:gundo_prefer_python3 = 1

" vim-devicons
if exists("g:loaded_webdevicons")
    call webdevicons#refresh() " don't break on refresh
endif

" fzf
map <C-p> :Files<CR>
map <leader>o :History<CR>
"map <C-p> :call fzf#run({ 'source' : 'ag --hidden --ignore .git -g ""' })<CR>

" The Silver Searcher(Ag) config for Ack plugin
"let g:ack_use_dispatch = 1
if executable('ag') && !exists('g:ackprg')
    let g:ackprg = 'ag --vimgrep --silent' " --max-count 1'
endif
" Keep the trailing space bellow
map <leader>a :Ack 
map <leader>A :Ack  <C-R>=expand('%:h')<CR><C-Left><Left>

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
let g:session_autoload = 'no'
let g:session_autosave = 'yes'
let g:session_autosave_periodic = 5
let g:session_autosave_silent = 1

" set Vim-specific sequences for RGB colors
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" activate color scheme (theme)
set background=dark
"colorscheme solarized
let g:hybrid_custom_term_colors = 1
colorscheme hybrid

" spell check
set spellfile=$HOME/.vim/spell/en.utf-8.add
set complete+=kspell

" Note taking
" For now, we need: npm install --global slugify-cli
let g:vim_notes_repo_path = "~/dev/notes"
command! NoteSave execute ("saveas " . substitute(system("slugify \"" . getline(1) . "\""), '\n\+$', '', '') . ".md")
command! NoteSync VimuxRunCommand("cd " . g:vim_notes_repo_path . " && glr && git add . && gc -a -m \"Updating notes: $(date)\" && gp")
