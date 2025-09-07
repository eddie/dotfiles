" auto-install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Initialize plugin system
call plug#begin()


" Core functionality
Plug 'neoclide/coc.nvim', {'branch': 'release'}           " Language server support
Plug 'github/copilot.vim', {'branch': 'release'}          " GitHub Copilot
Plug 'editorconfig/editorconfig-vim'                      " EditorConfig support

" Neovim-specific enhancements
Plug 'nvim-lua/plenary.nvim'                                " Lua utility functions (dependency)
Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.8'}      " Fuzzy finder
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Better syntax highlighting
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" Navigation & UI
Plug 'christoomey/vim-tmux-navigator'                      " Tmux integration
Plug 'scrooloose/nerdtree'                                 " File explorer
Plug 'Xuyuanp/nerdtree-git-plugin'                         " Git status in NerdTree
Plug 'vim-airline/vim-airline'                             " Status line
Plug 'vim-airline/vim-airline-themes'                      " Status line themes
Plug 'takac/vim-hardtime'                                  " Hard mode (no arrow keys)

" Editing enhancements
Plug 'tpope/vim-surround'                                  " Surround text objects
Plug 'tpope/vim-sleuth'                                    " Auto-detect indentation
Plug 'Raimondi/delimitMate'                                " Auto-close brackets/quotes

" Git integration
Plug 'tpope/vim-fugitive'                                  " Git commands
Plug 'airblade/vim-gitgutter', {'branch': 'main'}          " Git diff in gutter

" Search & utilities
Plug 'mileszs/ack.vim'                                     " Better search

" Language support
Plug 'pangloss/vim-javascript'                             " JavaScript
Plug 'leafgarland/typescript-vim'                          " TypeScript
Plug 'peitalin/vim-jsx-typescript'                         " JSX/TSX
Plug 'othree/html5.vim'                                    " HTML5
Plug 'nikvdp/ejs-syntax'                                   " EJS templates
Plug 'mustache/vim-mustache-handlebars'                    " Handlebars
Plug 'fatih/vim-go'                                        " Go
Plug 'vala-lang/vala.vim'                                  " Vala

" Web development
Plug 'mattn/emmet-vim'                                     " HTML/CSS shortcuts

call plug#end()

if (has("termguicolors"))
 set termguicolors
endif

" Core
set cmdheight=1
set mouse=a
set helpheight=10

let mapleader = ","
let g:mapleader = ","
nmap <leader>w :w!<cr>

set nolist 
set listchars=eol:$,tab:»\ ,trail:·,extends:>,precedes:<,space:.,nbsp:␣
set timeoutlen=500   " Time to wait for a mapped sequence
set ttimeoutlen=45   " Time to wait for terminal code
set hidden

nmap <leader>q <C-W>q
nmap <leader>x :qa!<cr>
inoremap jj <Esc>
nnoremap <leader>bd :bp\|bd #<CR>

" Misc
set noswapfile
set nowb
set nobackup

" Theme
syntax enable
set background=dark
hi Normal guibg=None ctermbg=None
colorscheme catppuccin

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
set colorcolumn=+1

" Folds
set foldmethod=syntax
set foldcolumn=0
set foldlevel=2
autocmd FileType vim setlocal foldmethod=marker

" Splits
set splitright
set splitbelow

" Tabs
set tabpagemax=2

" Wrapping, revise
set wrap 
set textwidth=0
set wrapmargin=0
set whichwrap=h,l,b,<,>,~,[,]
set lbr                 " Wrap long lines at word boundaries

" Searching
set ignorecase          " Ignore case in search patterns
set smartcase           " Override ignorecase if search contains uppercase
set hlsearch            " Highlight all search matches
set incsearch           " Show matches as you type the search
set gdefault            " Use global flag by default in substitute commands
set magic               " Enable extended regex features
set inccommand=split    " Preview substitutions in a split window (Neovim only)

" Config reload
nnoremap <leader>ec :tabnew $MYVIMRC<CR>
nnoremap <leader>lc :tabnew ~/.config/nvim/lua/config.lua<CR>
nnoremap <leader>sc :source $MYVIMRC<CR>
nnoremap <leader>pi :PlugInstall<CR>

" Search mappings
" Space starts forward search
map <space> /                        
" Ctrl-Space starts backward search
map <c-space> ?                      
" Clear search highlighting
map <silent> <leader><cr> :noh<cr>   

" Search navigation
" Enter jumps to next search result
nnoremap <cr> n                      
" Shift-Enter jumps to previous search result
nnoremap <s-cr> N                    

" Popup menu 
set pumheight=15
set pumblend=2
set pumwidth=20

" Retain visual selection after identing
set so=7
vnoremap < <gv
vnoremap > >gv

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

" Reconfigure horizontal mouse scroll, thanks @Administrative_chaos
nnoremap <ScrollWheelRight> <Nop>
nnoremap <ScrollWheelLeft> <Nop>
nnoremap <S-ScrollWheelUp> <ScrollWheelRight>
nnoremap <S-ScrollWheelDown> <ScrollWheelLeft>

" Navigation
map <leader>t :tabnew<CR>
nnoremap <Leader>c :cclose<cr>

" Buffer navigation
noremap <Leader><Leader> <C-^>  

" Completions
" Select longest by default, always show menu
set completeopt=longest,menuone
let g:SuperTabLongestEnhanced=1
let g:SuperTabDefaultCompletionType = "<c-n>" 


" Pretty Airline
" ---------------------------------

let g:airline_theme='catppuccin'
"let g:airline_section_error='' " Remove syntastic
"let g:airline_section_warning=''
"let g:airline_section_b=''     " Remove hunks and branch
let g:airline_inactive_collapse=1
let g:airline_symbols_ascii = 1
let g:airline_exclude_preview = 0

let g:airline#extensions#tabline#formatter = 'unique_tail'  " Full paths in tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_tab_count = 1
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#coc#show_coc_status = 1
let g:airline#extensions#branch#enabled = 0

" NERDTree
" ---------------------------------

let g:NERDTreeWinSize = 30
let g:NERDTreeMinimalUI = 1
let g:NERDTreeChDirMode = 2
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowHidden=1

let NERDTreeIgnore=['\~$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr', '\.pyc$', 'node_modules', 'bower_components', '__pycache__']
nmap ,e :NERDTreeToggle<CR>
nmap <F6> :NERDTreeToggle<CR>

" Map Leader f to reveal file in NERDTree
nmap ,f :NERDTreeFind<CR>

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif


" ACK
" ---------------------------------

" Use ag for ctrl-p super fast, uses ~/.agignore
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'
  let g:ackprg = 'ag --vimgrep'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor
endif


" Conquer of Completion (coc.nvim)
" ---------------------------------

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


" Helper function to check if cursor is after whitespace
function! s:CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Tab completion behavior
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Shift-Tab for previous completion
inoremap <silent><expr> <S-Tab> 
      \ coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Enter to accept completion or format
inoremap <silent><expr> <CR> 
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"


" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif


" Navigation and code actions (using <Plug> mappings)

nmap <silent><leader>r :CocRestart<CR>
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)

nmap <silent><nowait> do <Plug>(coc-codeaction)
"nnmap <silent><nowait><leader> rn <Plug>(coc-rename)

nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Git integration
nnoremap <silent> <Leader>lg :CocList gstatus<CR>

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


" Map function and class text objects
" e.g vif to select inner function
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)




" Copilot
" ---------------------------------
let g:copilot_no_tab_map = 1
let g:copilot_filetypes = {
      \ 'vimwiki': v:false,
      \ 'markdown': v:false,
      \ }

imap <leader><tab> <Plug>(copilot-accept-line)

" Python
let g:python2_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" Misc editing plugins
" ---------------------------------
" Delimmate
let delimitMate_expand_cr = 0
let delimitMate_expand_space = 1

" Emmet
let g:user_emmet_mode='a'

" Markdown spellcheck default
autocmd BufRead,BufNewFile *.md setlocal spell

" Fix highlighting for large files
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" Git-fugitive
" ---------------------------------
nmap <leader>gb :Git blame<CR>
nmap <leader>gd :Gvdiffsplit<CR>
nmap <leader>gcm :Gcommit<CR>
nmap <leader>gco :!git checkout

" Telescope 
" ---------------------------------
" Enable telescope preview
let g:telescope_preview = 1

nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>a <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>gs <cmd>Telescope git_status<cr>

nnoremap <silent><space><space>  <cmd>Telescope buffers<CR>

" Hardtime
" -----------------------------------

let g:hardtime_default_on = 1
let g:hardtime_showmsg = 1
let g:hardtime_ignore_buffer_patterns = [  "NERD.*" ]
let g:hardtime_allow_different_key = 1
let g:hardtime_ignore_quickfix = 1
let g:list_of_visual_keys = [ "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]

lua require('config')


