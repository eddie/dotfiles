
" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs\
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
  autocmd VimEnter * PlugInstall
endif

" Initialize plugin system
call plug#begin('~/.config/nvim/plugged')
Plug 'mhartington/oceanic-next'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'
Plug 'mileszs/ack.vim'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/emmet-vim'
Plug 'vim-syntastic/syntastic'
call plug#end()

if (has("termguicolors"))
 set termguicolors
endif

" Core
set cmdheight=1
let mapleader = ","
let g:mapleader = ","
nmap <leader>w :w!<cr>
" nnoremap <leader>q :bp<cr>:bd #<cr>
nmap <leader>q <C-W>q
nmap <leader>x :qd!<cr>

" Hard mode
map <Enter> <nop>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
noremap h <NOP>
noremap l <NOP>
nnoremap k gk
nnoremap j gj

" Config reload
nnoremap <leader>ec :split $MYVIMRC<CR>
nnoremap <leader>sc :source $MYVIMRC<CR>

" Theme
syntax enable
colorscheme OceanicNext

" Misc
set noswapfile
set nowb
set nobackup

" Editing
set number
set relativenumber
set showmatch
set expandtab
set tabstop=2
set shiftwidth=2 " Indentation amount for < and > commands.
set clipboard=unnamed " System clipboard
set iskeyword-=_

" Wrapping, revise
set wrap
set formatoptions+=t
set whichwrap+=<,>,h,l
set textwidth=80

" Searching
set ignorecase
set smartcase
set hlsearch
set gdefault
set magic

" Buffer navigation
noremap <Leader><Leader> <C-^>  " Fast buffer switch
set so=7

" Retain visual selection after identing
vnoremap < <gv
vnoremap > >gv

" Window navigation
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Clear search
map <silent> <leader><cr> :noh<cr>

let g:NERDTreeWinSize = 24
let g:NERDTreeMinimalUI = 1

let NERDTreeIgnore=['\~$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.pyc$', 'node_modules', 'bower_components']
:nmap ,e :NERDTreeToggle<CR>

" CtrlP
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>

" Use ag for ctrl-p super fast, uses ~/.agignore
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
endif

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$|\node_modules|\bower_components'

" search for nearest ancestor like .git, .hg, and the directory of the current file
let g:ctrlp_working_path_mode = 'ra'  

" show the match window at the top of the screen
let g:ctrlp_match_window_bottom = 1  
let g:ctrlp_max_height = 8      " maxiumum height of match window
let g:ctrlp_switch_buffer = 'et'    " jump to a file if it's open already
let g:ctrlp_use_caching = 1       " enable caching
let g:ctrlp_clear_cache_on_exit=0     " speed up by not removing clearing cache evertime
let g:ctrlp_show_hidden = 1       " show me dotfiles
let g:ctrlp_mruf_max = 250        " number of recently opened files

" Searching (Files)
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

nnoremap <Leader>c :cclose<cr>
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" Airline
let g:airline_theme='oceanicnext'

" Syntastic
let g:syntastic_check_on_open=1
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_always_populate_loc_list=0
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-", " is not recognized!"]
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 1
