" NeoVim Configuration
" James A. Overton <james@overton.ca>
"
" # General

" Don't worry about vi compatibility
set nocompatible

" Don't use modelines
set nomodeline

" Don't complain about hiding modified buffers.
set hidden

" Spell Checking
set spelllang=en_ca

" Y yanks to end of line, similar to D and C
noremap Y yg_

" Backup and Undo
set undodir=~/.local/share/nvim/undo
set backupdir=~/.local/share/nvim/backup
set undolevels=1000

" Wrap Lines
set wrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0
set scrolloff=3 " minimum lines to keep above and below cursor

" Searching
set ignorecase
set smartcase

" Indentation
set shiftwidth=2
set softtabstop=2
set expandtab

" Cursor
set guicursor=


" # Mappings

" NeoVim Terminal
tnoremap <esc> <c-\><c-n>

" Use space for leader
let mapleader = "\<space>"

" Easier navigation between split windows.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Turn off higlight search
nnoremap <leader>h :nohlsearch<cr>

" Enter Markdown mode
nnoremap <leader>m :setf markdown<cr>

" Toggle paste mode
nnoremap <leader>p :set paste!<cr>

" Close buffer without changing window
nnoremap <leader>q :Bdelete<cr>

" Alternative to write
nnoremap <leader>w :w<cr>

" Close all other splits
nnoremap <leader>o :only<cr>


" # Plugins
"
" See https://github.com/junegunn/vim-plug
" Install: curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.local/share/nvim/plugged')

" General
Plug 'tpope/vim-sensible'            " sensible defaults
Plug 'tpope/vim-repeat'              " better command repeating
Plug 'tpope/vim-surround'            " surround text with stuff
Plug 'tpope/vim-unimpaired'          " navigation mappings
Plug 'editorconfig/editorconfig-vim' " respect .editorconfig files
Plug 'ctrlpvim/ctrlp.vim'            " fuzzy file and buffer search
Plug 'moll/vim-bbye'                 " better buffer controls
Plug 'kshenoy/vim-signature'         " show marks in signs column

" Version Control
Plug 'tpope/vim-fugitive'            " git integration
Plug 'airblade/vim-gitgutter'        " git status

" Styling
Plug 'altercation/vim-colors-solarized'
Plug 'jamesaoverton/vim-airline'     " fancy status line

" Clojure
Plug 'tpope/vim-fireplace',        { 'for': 'clojure' } " REPL
Plug 'guns/vim-clojure-static',    { 'for': 'clojure' } " static highlighting
Plug 'guns/vim-clojure-highlight', { 'for': 'clojure' } " dynamic highlighting
Plug 'venantius/vim-cljfmt',       { 'for': 'clojure' } " enforce cljfmt
Plug 'bhurlow/vim-parinfer',       { 'for': 'clojure' } " parinfer

" Filetypes
Plug 'neapel/vim-n3-syntax'          " rdf, turtle, etc.

call plug#end()


" # Plugin Config
"
" Remaining pluging configuration.
" Same order as plugin section.

" vim-gitgutter
" https://github.com/airblade/vim-gitgutter
nnoremap <c-g> :GitGutterToggle<cr>
set signcolumn=yes

" CtrlP fuzzy file searching
" https://github.com/kien/ctrlp.vim
" http://blog.patspam.com/2014/super-fast-ctrlp
nnoremap <NUL> :CtrlPBuffer<cr>
nnoremap <c-space> :CtrlPBuffer<cr>
nnoremap <leader>f :CtrlP<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>r :CtrlPMRU<cr>
let g:ctrlp_switch_buffer = ''
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
  \ --ignore .git
  \ --ignore .svn
  \ --ignore .hg
  \ --ignore .DS_Store
  \ --ignore .vagrant
  \ --ignore .local
  \ --ignore "**/*.pyc"
  \ -g ""'

" Solarized
let g:solarized_termtrans = 1
set background=light
colorscheme solarized

" Airline status line
" https://github.com/bling/vim-airline
let g:airline_powerline_fonts = 1

" vim-fireplace Eval
" https://github.com/tpope/vim-fireplace
nnoremap <C-e> :Eval<cr>
nnoremap <leader>r :w<cr>:Require!<cr>

" vim-clojure-static
" https://github.com/guns/vim-clojure-static
" Use hanging alignment for multiline strings
let g:clojure_align_multiline_strings = 1
" Align subforms to make cljfmt happier
let g:clojure_align_subforms = 1

" # Functions
" https://vimrcfu.com/snippet/31
function! RunBufferTests()
  let ns = fireplace#ns()
  let ns = substitute(ns, '-spec$', '', '')
  if ns !~ '-test$'
    let ns = ns . "-test"
  endif
  silent :Require
  exe "RunTests " . ns
endfunction
"nnoremap <leader>t :call RunBufferTests()<cr>

" Run command in buffer 1
let g:test = "make test"
function! RunCommand()
  if bufwinnr(1) == -1
    botright 10split
    buffer 1
  endif
  exec bufwinnr(1) . "wincmd w"
  call jobsend(b:terminal_job_id, g:test . "\n")
  wincmd p
endfunction
nnoremap <leader>t :call RunCommand()<cr>
"nnoremap <leader>y :source ~/.config/nvim/init.vim<cr>
"let g:test = "ls -lah"

" https://stackoverflow.com/a/6271254
function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction

" Send visual selection to draft-email
function! Email() range
  if !exists("$IMAP_PASSWORD")
    let g:imap_password=input("IMAP Password? ")
    let $IMAP_PASSWORD=g:imap_password
  endif
  echo system("draft-email", s:get_visual_selection())
endfunction
xnoremap e :call Email()<cr>


function! ToggleSignColumn()
  if &signcolumn == 'yes'
    set signcolumn=no
  else
    set signcolumn=yes
  endif
endfunction
nnoremap <leader>s :call ToggleSignColumn()<cr>

" # Filetypes

" Journal files
autocmd BufNewFile ~/Documents/Writing/Journal/*/*/*.txt execute "0read !~/Repositories/local/infrastructure/carnap/journal.py" expand('%:t:r')
autocmd BufRead,BufNewFile ~/Documents/Writing/Journal/*/*/*.txt setlocal filetype=markdown

" Terminals
autocmd TermOpen * setlocal nospell

" Text files
autocmd BufRead,BufNewFile *.{txt,tex,md,mdown,mkd,mkdn,markdown,mdwn} setlocal spell

" Makefiles
autocmd FileType make setlocal list noexpandtab tabstop=4 shiftwidth=4 softtabstop=0

" Turtle files
autocmd BufNewFile,BufRead *.ttl setlocal filetype=n3

