
" auto-install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Initialize plugin system
call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'christoomey/vim-tmux-navigator'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Raimondi/delimitMate'
Plug 'mileszs/ack.vim'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/emmet-vim'
Plug 'ervandew/supertab'
Plug 'NLKNguyen/papercolor-theme'
Plug 'junegunn/seoul256.vim'
Plug 'mustache/vim-mustache-handlebars'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'othree/html5.vim'
Plug 'nikvdp/ejs-syntax'
Plug 'fatih/vim-go'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

Plug 'morhetz/gruvbox'
Plug 'nightsense/forgotten'
Plug 'mhartington/oceanic-next'

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

nmap <leader>q <C-W>q
nmap <leader>x :qd!<cr>
inoremap jj <Esc>
nnoremap <leader>bd :bp\|bd #<CR>

" Hard mode
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
"noremap h <NOP>
"noremap l <NOP>
nnoremap k gk
nnoremap j gj


" Config reload
nnoremap <leader>ec :split $MYVIMRC<CR>
nnoremap <leader>sc :source $MYVIMRC<CR>
nnoremap <leader>pi :PlugInstall<CR>


" Theme
syntax enable
set background=dark
colorscheme PaperColor

let g:airline_theme='papercolor'
let g:airline_section_error='' " Remove syntastic
let g:airline_section_warning=''
let g:airline_section_b=''     " Remove hunks and branch
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 0

" Misc
set noswapfile
set nowb
set nobackup

" Editing
set number
set relativenumber
set numberwidth=5
set showmatch
set expandtab
set tabstop=2
set shiftwidth=2 " Indentation amount for < and > commands.
set clipboard=unnamed " System clipboard
set iskeyword+=_
set iskeyword+=-

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

" Pum
set pumheight=10

" Buffer navigation
noremap <Leader><Leader> <C-^>  " Fast buffer switch
map <leader>b :ls<CR>:b

set so=7

" Retain visual selection after identing
vnoremap < <gv
vnoremap > >gv

" Clear search
map <silent> <leader><cr> :noh<cr>

let g:NERDTreeWinSize = 30
let g:NERDTreeMinimalUI = 1
let g:NERDTreeChDirMode = 2
let g:NERDTreeAutoDeleteBuffer = 1

let NERDTreeIgnore=['\~$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.pyc$', 'node_modules', 'bower_components']
:nmap ,e :NERDTreeToggle<CR>

" CtrlP
nnoremap <Leader>o :CtrlPMixed<CR>

" Use ag for ctrl-p super fast, uses ~/.agignore
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
  let g:ackprg = 'ag --nogroup --column'
  "let g:ackprg = 'ag --vimgrep'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
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
let g:ctrlp_reuse_window = 1

nmap <leader>p :CtrlPClearAllCaches<CR>

" Navigation
map <leader>t :tabnew<CR>
nnoremap <Leader>c :cclose<cr>
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" Fix highlighting for large files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" COC
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-git',
  \ 'coc-prettier',
  \ 'coc-json',
  \ ]

if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif

if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" Coc-git

" Hover documentation
nnoremap <silent> K :call CocAction('doHover')<CR>

nmap <Leader>lg :CocList gstatus<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" Python

let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

" Delimmate
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1

" Emmet
let g:user_emmet_mode='a'

" Markdown spellcheck default
autocmd BufRead,BufNewFile *.md setlocal spell

" Git
nmap <leader>gb :Gblame<CR>
nmap <leader>gs :Gstatus<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gcm :Gcommit<CR>
nmap <leader>gco :!git checkout
