
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
Plug 'Raimondi/delimitMate'
Plug 'mileszs/ack.vim'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/emmet-vim'
Plug 'vim-syntastic/syntastic'
Plug 'othree/yajs.vim'
Plug 'Quramy/vim-js-pretty-template'
Plug 'ervandew/supertab'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/seoul256.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Valloric/MatchTagAlways'
Plug 'othree/html5.vim'
Plug 'nikvdp/ejs-syntax'
call plug#end()

if (has("termguicolors"))
 set termguicolors
endif

" Core
set cmdheight=1
set mouse=a
let mapleader = ","
let g:mapleader = ","
nmap <leader>w :w!<cr>
set hidden

" nnoremap <leader>q :bp<cr>:bd #<cr>
nmap <leader>q <C-W>q
nmap <leader>x :qd!<cr>

" Hard mode
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
nnoremap <leader>pi :PlugInstall<CR>

" Theme
syntax enable
set background=dark
colorscheme OceanicNext
let g:airline_theme='oceanicnext'
"let g:airline_theme='gruvbox'
let g:airline_section_error='' " Remove syntastic 
let g:airline_section_warning=''
let g:airline_section_b=''     " Remove hunks and branch 


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
set iskeyword+=_
set iskeyword+=-
set spell        " Spell check on by default

" Colour the 81st column so that we don't type over our limit
set colorcolumn=+1

" Completions
" Select longest by default, always show menu
set completeopt=longest,menuone
let g:SuperTabLongestEnhanced=1
let g:SuperTabDefaultCompletionType = "<c-n>"

" Wrapping, revise
set nowrap
set textwidth=0
set wrapmargin=0
set whichwrap=h,l,b,<,>,~,[,]

" Searching
set ignorecase
set smartcase
set hlsearch
set gdefault
set magic

" Buffer navigation
noremap <Leader><Leader> <C-^>  " Fast buffer switch
map <leader>b :ls<CR>:b

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

let g:NERDTreeWinSize = 30
let g:NERDTreeMinimalUI = 1
let g:NERDTreeChDirMode = 2
let g:NERDTreeAutoDeleteBuffer = 1

let NERDTreeIgnore=['\~$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.pyc$', 'node_modules', 'bower_components']
:nmap ,e :NERDTreeToggle<CR>

" CtrlP
nnoremap <Leader>o :CtrlP<CR>

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
let g:ctrlp_by_filename = 1
let g:ctrlp_reuse_window = 1
" let g:ctrlp_brief_prompt = 1     " Exit quickly on <bs> 

" Use ag for ctrl-p super fast, uses ~/.agignore
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
endif

" Searching (Files)
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

nnoremap <Leader>c :cclose<cr>
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" Syntastic
let g:syntastic_check_on_open=1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_scss_checkers = ['sass_lint']
let g:syntastic_always_populate_loc_list=0
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-", " is not recognized!"]
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 1
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_style_warning_symbol = '✗'
let g:syntastic_warning_symbol = '✗'


" Python

let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" MatchTagAlways

let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'html.handlebars' : 1,
    \ 'xhtml' : 1,
    \ 'xml' : 1,
    \ 'jinja' : 1,
    \}

" Delimmate
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

" Emmet
let g:user_emmet_mode='a'
