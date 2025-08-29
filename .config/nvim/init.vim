" auto-install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Initialize plugin system
call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'github/copilot.vim', {'branch': 'release'}
Plug 'christoomey/vim-tmux-navigator'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree' 
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Raimondi/delimitMate'
Plug 'mileszs/ack.vim'
Plug 'airblade/vim-gitgutter', {'branch': 'main'}
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
Plug 'vala-lang/vala.vim'

"Plug 'kbarrette/mediummode'

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

set nolist 
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:.,tab:^I
set timeoutlen=500   " Time to wait for a mapped sequence
set ttimeoutlen=45   " Time to wait for terminal code
set hidden

nmap <leader>q <C-W>q
nmap <leader>x :qd!<cr>
inoremap jj <Esc>
nnoremap <leader>bd :bp\|bd #<CR>


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
set shiftwidth=2        " Indentation amount for < and > commands.
set iskeyword+=_
set iskeyword+=-
set clipboard+=unnamedplus

" Wrapping, revise
set wrap 
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
set lbr 

map <space> /
map <c-space> ?
map <silent> <leader><cr> :noh<cr>   " Clear search highlighting
noremap <Space>                      " Map space to search forward


" Colour the 81st column so that we don't type over our limit
set colorcolumn=+1

" Completions
" Select longest by default, always show menu
set completeopt=longest,menuone
let g:SuperTabLongestEnhanced=1
let g:SuperTabDefaultCompletionType = "<c-n>" 

" Hard mode - disable arrows in all modes
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
vnoremap <Up> <NOP>
vnoremap <Down> <NOP>
vnoremap <Left> <NOP>
vnoremap <Right> <NOP>
nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>

noremap h <NOP>
noremap l <NOP>
nnoremap k gk
nnoremap j gj

" Tab nav quick
nnoremap <leader>1 :tabn 1<CR>
nnoremap <leader>2 :tabn 2<CR>
nnoremap <leader>3 :tabn <CR>
nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 6gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> 9gt

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Config reload
nnoremap <leader>ec :split $MYVIMRC<CR>
nnoremap <leader>sc :source $MYVIMRC<CR>
nnoremap <leader>pi :PlugInstall<CR>

" Navigation
map <leader>t :tabnew<CR>
nnoremap <Leader>c :cclose<cr>

" Buffer navigation
noremap <Leader><Leader> <C-^>  

let g:airline_theme='catppuccin'
let g:airline_section_error='' " Remove syntastic
let g:airline_section_warning=''
let g:airline_section_b=''     " Remove hunks and branch
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 0

" Reconfigure horizontal mouse scroll, thanks @Administrative_chaos
nnoremap <ScrollWheelRight> <Nop>
nnoremap <ScrollWheelLeft> <Nop>
nnoremap <S-ScrollWheelUp> <ScrollWheelRight>
nnoremap <S-ScrollWheelDown> <ScrollWheelLeft>

" Popup menu 
set pumheight=15
set pumblend=2
set pumwidth=20

" Retain visual selection after identing
set so=7
vnoremap < <gv
vnoremap > >gv


let g:NERDTreeWinSize = 30
let g:NERDTreeMinimalUI = 1
let g:NERDTreeChDirMode = 2
let g:NERDTreeAutoDeleteBuffer = 1

let NERDTreeIgnore=['\~$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.pyc$', 'node_modules', 'bower_components', '__pycache__']
nmap ,e :NERDTreeToggle<CR>
nmap <F6> :NERDTreeToggle<CR>

" Map Leader f to reveal file in NERDTree
nmap ,f :NERDTreeFind<CR>

" Use ag for ctrl-p super fast, uses ~/.agignore
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'
  let g:ackprg = 'ag --vimgrep'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Fix highlighting for large files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" COC
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-git',
  \ 'coc-json',
  \ 'coc-pyright',
  \ 'coc-html',
  \ 'coc-htmldjango'
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
nmap <silent> gi <Plug>(coc-implementation)

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>qf  <Plug>(coc-fix-current)


nmap <silent><leader>r :CocRestart<CR>

" Copilot
"
let g:copilot_no_tab_map = 1
let g:copilot_filetypes = {
      \ 'vimwiki': v:false,
      \ 'markdown': v:false,
      \ }

imap <leader><tab> <Plug>(copilot-accept-line)


function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"


" Python
let g:python2_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" Delimmate
let delimitMate_expand_cr = 0
let delimitMate_expand_space = 1

" Emmet
let g:user_emmet_mode='a'

" Prettier
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')


" Markdown spellcheck default
autocmd BufRead,BufNewFile *.md setlocal spell

" Git
nmap <leader>gb :Git blame<CR>
nmap <leader>gd :Gvdiffsplit<CR>
nmap <leader>gcm :Gcommit<CR>
nmap <leader>gco :!git checkout


" Find files using Telescope command-line sugar.
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>a <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>gs <cmd>Telescope git_status<cr>

" Tabs
set tabpagemax=2

" Theme
syntax enable
set background=dark
hi Normal guibg=None ctermbg=None
colorscheme catppuccin

lua require('config')

