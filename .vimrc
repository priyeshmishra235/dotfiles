" ╭────────────────────────────────╮
" │         Core Modules           │
" ╰────────────────────────────────╯
source ~/.vim/core/options.vim
source ~/.vim/core/keymaps.vim
source ~/.vim/core/snippets.vim
source ~/.vim/core/autocommands.vim

" ╭────────────────────────────────╮
" │      Plugin Manager Setup      │
" ╰────────────────────────────────╯
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  " Install after first start‑up, then re‑source .vimrc
  autocmd VimEnter * ++once PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" ╭─────────╮
" │ code UI │
" ╰─────────╯
Plug 'jiangmiao/auto-pairs'
Plug 'luochen1990/rainbow'

" ╭─────────────────────────────╮
" │ FileManager and Navigation │
" ╰─────────────────────────────╯
Plug 'justinmk/vim-dirvish'

" ╭───────────╮
" │ Fuzzy‑find │
" ╰───────────╯
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" ╭─────╮
" │ git │
" ╰─────╯
Plug 'airblade/vim-gitgutter'

" ╭─────────────────────╮
" │ LSP‑related plugins │
" ╰─────────────────────╯
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'honza/vim-snippets'

" ╭─────╮
" │ DAP │
" ╰─────╯
Plug 'puremourning/vimspector'

" ╭───────────────────────╮
" │ Miscellaneous plugins │
" ╰───────────────────────╯
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" ╭────────────────────────╮
" │ Navigation‑bar plugins │
" ╰────────────────────────╯
Plug 'liuchengxu/vim-which-key'

" ╭──────────────────────╮
" │ Text‑editing plugins │
" ╰──────────────────────╯
Plug 'mg979/vim-visual-multi'
Plug 'b3nj5m1n/kommentary'
Plug 'gbprod/yanky.nvim'

" ╭─────────────────╮
" │ Utility plugins │
" ╰─────────────────╯
Plug 'voldikss/vim-floaterm'

call plug#end()


" ╭─────────────────────────────────────────────╮
" │      Load plugin‑specific configurations    │
" ╰─────────────────────────────────────────────╯

" ── helper: source a file only if it exists ────────────────────────────────
function! s:SourceIf(path) abort
  if filereadable(expand(a:path))
    execute 'source' fnameescape(expand(a:path))
  endif
endfunction

" code UI
call <SID>SourceIf('~/.vim/plugins/codeUI/autopairs.vim')
call <SID>SourceIf('~/.vim/plugins/codeUI/rainbowCurly.vim')

" fuzzy finder
call <SID>SourceIf('~/.vim/plugins/fuzzyFinder/flash.vim')
call <SID>SourceIf('~/.vim/plugins/fuzzyFinder/fzf.vim')
call <SID>SourceIf('~/.vim/plugins/fuzzyFinder/treesitter.vim')

" git
call <SID>SourceIf('~/.vim/plugins/git/gitSigns.vim')

" LSP
call <SID>SourceIf('~/.vim/plugins/lsp/coc.vim')

" text‑editing
call <SID>SourceIf('~/.vim/plugins/textEditing/vim-visual-multi.vim')
call <SID>SourceIf('~/.vim/plugins/textEditing/comment.vim')
call <SID>SourceIf('~/.vim/plugins/textEditing/yanky.vim')

" utilities
call <SID>SourceIf('~/.vim/plugins/utilities/whichKey.vim')
call <SID>SourceIf('~/.vim/plugins/utilities/terminal.vim')

" file / undo
call <SID>SourceIf('~/.vim/plugins/fileAndUndo/oil.vim')

" misc / ui
call <SID>SourceIf('~/.vim/plugins/misc/pendulum.vim')
call <SID>SourceIf('~/.vim/plugins/ui/dashboard.vim')
call <SID>SourceIf('~/.vim/plugins/ui/notificationManager.vim')
