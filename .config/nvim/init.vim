" auto-install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Initialize plugin system
call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'github/copilot.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree' 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Raimondi/delimitMate'
Plug 'mileszs/ack.vim'
Plug 'airblade/vim-gitgutter'
Plug 'mattn/emmet-vim'
Plug 'NLKNguyen/papercolor-theme'
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
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'mhartington/oceanic-next'
Plug 'amadeus/vim-mjml'


" Neovim specific
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


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

set timeoutlen=500
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
"noremap j <NOP>
"noremap k <NOP>

" Config reload
nnoremap <leader>ec :split $MYVIMRC<CR>
nnoremap <leader>sc :source $MYVIMRC<CR>
nnoremap <leader>pi :PlugInstall<CR>

" Theme
syntax enable
set background=dark
colorscheme PaperColor 

let g:airline_theme='catppuccin'
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
set clipboard=unnamedplus " System clipboard
set iskeyword+=_
set iskeyword+=-

" Colour the 81st column so that we don't type over our limit
set colorcolumn=+1

" Completions
" Select longest by default, always show menu
set completeopt=longest,menuone
let g:SuperTabLongestEnhanced=1
let g:SuperTabDefaultCompletionType = "<c-n>"

" Reconfigure horizontal mouse scroll, thanks @Administrative_chaos
nnoremap <ScrollWheelRight> <Nop>
nnoremap <ScrollWheelLeft> <Nop>
nnoremap <S-ScrollWheelUp> <ScrollWheelRight>
nnoremap <S-ScrollWheelDown> <ScrollWheelLeft>

" Wrapping, revise
set nowrap
set textwidth=0
set wrapmargin=0
set whichwrap=h,l,b,<,>,~,[,]

" Searching
set ignorecase
set smartcase
set hlsearch
set incsearch
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

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" 
" Clear search
map <silent> <leader><cr> :noh<cr>

let g:NERDTreeWinSize = 30
let g:NERDTreeMinimalUI = 1
let g:NERDTreeChDirMode = 2
let g:NERDTreeAutoDeleteBuffer = 1

let NERDTreeIgnore=['\~$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.pyc$', 'node_modules', 'bower_components', '__pycache__']
nmap ,e :NERDTreeToggle<CR>
nmap <F6> :NERDTreeToggle<CR>

" Use ag for ctrl-p super fast, uses ~/.agignore
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'
  let g:ackprg = 'ag --vimgrep'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Navigation
"map <leader>t :tabnew<CR>
nnoremap <Leader>c :cclose<cr>

" Fix highlighting for large files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" COC
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-git',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-pyright'
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
nmap <silent> do <Plug>(coc-codeaction)
nmap <silent><leader>r :CocRestart<CR>


" Python

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"


function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" Python
let g:python2_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" Delimmate
let delimitMate_expand_cr = 0
let delimitMate_expand_space = 1

" Emmet
let g:user_emmet_mode='a'

" Markdown spellcheck default
autocmd BufRead,BufNewFile *.md setlocal spell

" Git
nmap <leader>gb :Git blame<CR>
"nmap <leader>gs :Gstatus<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gcm :Gcommit<CR>
nmap <leader>gco :!git checkout

" Copilot
"
let g:copilot_no_tab_map = 1
let g:copilot_filetypes = {
      \ 'markdown': v:false,
      \ 'vimwiki': v:false,
      \ }

imap <leader><tab> <Plug>(copilot-accept-line)


" Clang-format
map <C-K> :pyf /usr/share/clang/clang-format.py<cr> 
imap <C-K> <c-o>:pyf /usr/share/clang/clang-format.py<cr>


function! Formatonsave()
  let l:formatdiff = 1
  pyf /usr/share/clang/clang-format.py
endfunction
"autocmd BufWritePre *.h,*.cc,*.cpp,*.c call Formatonsave()


" Find files using Telescope command-line sugar.
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>a <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>gs <cmd>Telescope git_status<cr>

" Tabs
set tabpagemax=2

" Folds
set foldmethod=syntax
set foldlevel=1
set foldclose=all
