" ───────────────────────────────────────────────
"  Close built‑in explorers (netrw, help, qf, man) with q
" ───────────────────────────────────────────────
augroup QuickQuit
  autocmd!
  autocmd FileType netrw,help,qf,man nnoremap <silent><buffer> q :bd<CR>
augroup END

" ───────────────────────────────────────────────
"  Default working directory: $HOME on startup
" ───────────────────────────────────────────────
autocmd VimEnter * execute 'cd' expand('$HOME')

" ───────────────────────────────────────────────
"  Strip trailing whitespace on write
" ───────────────────────────────────────────────
autocmd BufWritePre * %s/\s\+$//e

" ───────────────────────────────────────────────
"  Delete blank lines at the end of the file
" ───────────────────────────────────────────────
autocmd BufWritePre * silent! %s#\($\n\s*\)\+\%$##

" ───────────────────────────────────────────────
"  Retab (convert <Tab> → spaces) on write
" ───────────────────────────────────────────────
autocmd BufWritePre * retab

" ───────────────────────────────────────────────
"  Open :help in a new tab instead of a split
" ───────────────────────────────────────────────
autocmd FileType help wincmd T

" ───────────────────────────────────────────────
"  Jump to last edit position when reopening a file
" ───────────────────────────────────────────────
autocmd BufReadPost * silent! normal! g`"zv

" ───────────────────────────────────────────────
"  Leader keys
" ───────────────────────────────────────────────
let mapleader      =" "
let maplocalleader =" "

" Disable <Space> in Normal / Visual mode
nnoremap <silent> <Space> <Nop>
vnoremap <silent> <Space> <Nop>

" Common {nore,silent}
let s:ns = '<silent><nore>'

" ───────────────────────────────────────────────
"  Insert‑mode escape shortcuts
" ───────────────────────────────────────────────
inoremap <expr> kj   "\<Esc>"
inoremap <expr> KJ   "\<Esc>"
inoremap <expr> ;;   "\<Esc>"

" ───────────────────────────────────────────────
"  Basic file commands
" ───────────────────────────────────────────────
nnoremap  <C-s>       <silent><cmd>write<CR>
nnoremap  <leader>sw  <silent><cmd>noautocmd write<CR>
nnoremap  <C-q>       <silent><cmd>quit<CR>

" ───────────────────────────────────────────────
"  Better  ‘i’  on blank lines
" ───────────────────────────────────────────────
nnoremap <expr> i getline('.') =~ '^\s*$' ? '"_cc' : 'i'

" ───────────────────────────────────────────────
"  Delete without yanking
" ───────────────────────────────────────────────
nnoremap x "_x

" ───────────────────────────────────────────────
"  Scroll / search and center cursor
" ───────────────────────────────────────────────
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" ───────────────────────────────────────────────
"  Window resizing with arrows
" ───────────────────────────────────────────────
nnoremap <Up>    :resize -1<CR>
nnoremap <Down>  :resize +1<CR>
nnoremap <Left>  :vertical resize -1<CR>
nnoremap <Right> :vertical resize +1<CR>

" ───────────────────────────────────────────────
"  Buffer navigation
" ───────────────────────────────────────────────
nnoremap <Tab>    :bnext<CR>
nnoremap <S-Tab>  :bprevious<CR>

" ───────────────────────────────────────────────
"  Split helpers
" ───────────────────────────────────────────────
nnoremap <leader>v  <C-w>v
nnoremap <leader>h  <C-w>s
nnoremap <leader>se <C-w>=

nnoremap <leader>e  :Ex<CR>
inoremap jk <ESC>

" Navigate splits
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>

" ───────────────────────────────────────────────
"  Jump to last / newest change
" ───────────────────────────────────────────────
nnoremap g, g;
nnoremap g; g,

" ───────────────────────────────────────────────
"  Insert‑mode BoL / EoL
" ───────────────────────────────────────────────
inoremap <M-i> <Esc>I
inoremap <M-a> <Esc>A

" ───────────────────────────────────────────────
"  Text objects – quotes & brackets
" ───────────────────────────────────────────────
xnoremap iq i'
onoremap iq i'
xnoremap iQ i"
onoremap iQ i"

xnoremap aq a''
onoremap aq a''
xnoremap aQ a"
onoremap aQ a"
xnoremap a' a''
onoremap a' a''
xnoremap a" a"
onoremap a" a"

xnoremap ir i[
onoremap ir i[
xnoremap ar a[
onoremap ar a[

" ───────────────────────────────────────────────
"  Toggle wrap
" ───────────────────────────────────────────────
nnoremap <leader>lw :set wrap!<CR>

" ───────────────────────────────────────────────
"  Keep register when pasting over selection
" ───────────────────────────────────────────────
xnoremap p "_dP

" ───────────────────────────────────────────────
"  Quick spelling fix (`z.`)
" ───────────────────────────────────────────────
nnoremap z. 1z=

" ───────────────────────────────────────────────
"  Don't yank blank lines with dd
" ───────────────────────────────────────────────
nnoremap <expr> dd getline('.') ==# '' ? '"_dd' : 'dd'

" ───────────────────────────────────────────────
"  UI Settings
" ───────────────────────────────────────────────
set number
set relativenumber
set nocursorline
set signcolumn=no
set nowrap
set linebreak
set termguicolors
set numberwidth=4
set cmdheight=1
set showtabline=2
set colorcolumn=81

" ───────────────────────────────────────────────
"  Indentation & Formatting
" ───────────────────────────────────────────────
set autoindent
set smartindent
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab

" Disable auto-commenting on new line
set formatoptions-=c
set formatoptions-=r
set formatoptions-=o

" Allow dash `-` as part of a word
set iskeyword+=-

" ───────────────────────────────────────────────
"  Clipboard & Encoding
" ───────────────────────────────────────────────
set clipboard=unnamedplus
set fileencoding=utf-8

" ───────────────────────────────────────────────
"  Scrolling Behavior
" ───────────────────────────────────────────────
set scrolloff=4
set sidescrolloff=8
set pumheight=10

" ───────────────────────────────────────────────
"  Search Behavior
" ───────────────────────────────────────────────
set ignorecase
set incsearch
set smartcase
set hlsearch

" ───────────────────────────────────────────────
"  Window Splitting Behavior
" ───────────────────────────────────────────────
set splitbelow
set splitright

" ───────────────────────────────────────────────
"  Undo & Backup
" ───────────────────────────────────────────────
set noswapfile
set nobackup
set nowritebackup
set undofile

" ───────────────────────────────────────────────
"  Key Behavior
" ───────────────────────────────────────────────
set whichwrap+=b,s,<,>,[,],h,l
set backspace=indent,eol,start

" ───────────────────────────────────────────────
"  Performance Tweaks
" ───────────────────────────────────────────────
set updatetime=250
set timeoutlen=300

" ───────────────────────────────────────────────
"  Miscellaneous
" ───────────────────────────────────────────────
set noshowmode
set breakindent
set conceallevel=0
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions
set shortmess+=c
set shell=/bin/zsh
set confirm

syntax on             " enable syntax highlighting
set termguicolors     " enable true color if your terminal supports it
colorscheme slate " use 'desert' theme

" ───────────────────────────────────────────────
"  Cursor shape for different modes (in terminal)
" ───────────────────────────────────────────────
if &term =~ "xterm\\|rxvt\\|alacritty\\|kitty\\|wezterm"
  let &t_SI = "\e[6 q"   " Insert mode: bar (vertical)
  let &t_EI = "\e[2 q"   " Normal mode: block
  let &t_SR = "\e[4 q"   " Replace mode: underline
endif
" ───────────────────────────────────────────────
"  Make :find, :e, gf, etc. search sub‑folders
" ───────────────────────────────────────────────
set path+=**
set wildmenu                         " better command‑line completion menu
set wildmode=longest:full,full       " tab‑completion cycling

" ╭──────────────────────────────────────────────╮
" │  Minimal .vimrc — LSP *only* (clangd)        │
" │  Requires:                                   │
" │    1. vim-lsp in ~/.vim/pack/plugins/start   │
" │    2. clangd on $PATH                        │
" ╰──────────────────────────────────────────────╯

" ── Load vim‑lsp (Vim’s package system auto‑loads anything in …/start) ──
"   If you use another manager, just ensure vim‑lsp is the *only* plugin.
" ── Register clangd with vim‑lsp ─────────────────────────────────────────
if executable('clangd')
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

" ── Buffer‑local LSP keymaps (no other mappings in this file) ───────────
augroup LspKeys
  autocmd!
  autocmd User lsp_buffer_enabled call s:lsp_keys()
augroup END

function! s:lsp_keys() abort
  " Hover / docs
  nnoremap <buffer><silent>  K       <plug>(lsp-hover)

  " General prefix: gr…  (rename, refs, defs, etc.)
  nnoremap <buffer><silent>  ga     <plug>(lsp-code-action)

  nnoremap <buffer><silent>  gn     <plug>(lsp-rename)
  nnoremap <buffer><silent>  gr     <plug>(lsp-references)
  nnoremap <buffer><silent>  gd     <plug>(lsp-definition)
  nnoremap <buffer><silent>  gD     <plug>(lsp-declaration)
  nnoremap <buffer><silent>  gi     <plug>(lsp-implementation)
  nnoremap <buffer><silent>  gf     <plug>(lsp-format)
  nnoremap <buffer><silent>  gk     <plug>(lsp-signature-help)
  nnoremap <buffer><silent>  gs     <plug>(lsp-document-symbol)
  nnoremap <buffer><silent>  gt     <plug>(lsp-type-definition)
endfunction
