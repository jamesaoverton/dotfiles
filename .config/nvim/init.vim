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
set signcolumn=yes

" CtrlP fuzzy file searching
" https://github.com/ctrlp/ctrlp.vim
" http://blog.patspam.com/2014/super-fast-ctrlp
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

" vim-clojure-static
" https://github.com/guns/vim-clojure-static
" Use hanging alignment for multiline strings
let g:clojure_align_multiline_strings = 1
" Align subforms to make cljfmt happier
let g:clojure_align_subforms = 1


" # Functions

" Run Clojure tests for buffer
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

" Run command in buffer 1, maybe opening a split
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

" Get the visual selection
" Why is this not a built-in Vim script function?!
" https://stackoverflow.com/a/6271254
function! s:get_visual_selection()
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

" Toggle the sign column
function! ToggleSignColumn()
  if &signcolumn == 'yes'
    set signcolumn=no
  else
    set signcolumn=yes
  endif
endfunction
nnoremap <leader>s :call ToggleSignColumn()<cr>

" Set journal marks
function! SetJournalMarks()
  let @j=@"
  normal gg
  keeppatterns /TIME
  normal dd
  mark t
  keeppatterns /DONE
  normal dd
  mark d
  keeppatterns /JOURNAL
  normal dd
  mark j
  normal 't
  SignatureRefresh
  let @"=@j
endfunction

" Set global journal marks
function! SetGlobalJournalMarks()
  let cursor_pos = getpos(".")
  normal 't
  mark T
  normal 'd
  mark D
  normal 'j
  mark J
  SignatureRefresh
  call setpos('.', cursor_pos)
endfunction
nnoremap <leader>j :call SetGlobalJournalMarks()<cr>


" # Filetypes

" Journal files
augroup journal
  autocmd!
  autocmd BufNewFile ~/Documents/Writing/Journal/*/*/*.txt execute "0read !~/Repositories/local/automation/carnap/journal.py" expand('%:t:r')
  autocmd BufNewFile ~/Documents/Writing/Journal/*/*/*.txt call SetJournalMarks()
  autocmd BufRead,BufNewFile ~/Documents/Writing/Journal/*/*/*.txt setlocal filetype=markdown
augroup END

" Terminals
autocmd TermOpen * setlocal nospell

" Text files
autocmd BufRead,BufNewFile *.{txt,tex,md,mdown,mkd,mkdn,markdown,mdwn} setlocal spell

" Makefiles
autocmd FileType make setlocal list noexpandtab tabstop=4 shiftwidth=4 softtabstop=0

" Turtle files
autocmd BufNewFile,BufRead *.ttl setlocal filetype=n3


" # Mappings
" Use space for leader
let mapleader = "\<space>"

noremap Y yg_ " Y yanks to end of line, similar to D and C

inoremap <c-j> <esc><c-w>w
inoremap <c-space> <space>

nnoremap <c-e> :Eval<cr>
nnoremap <c-g> :GitGutterToggle<cr>
nnoremap <c-j> <c-w>w
nnoremap <c-k> :CtrlPBuffer<cr>
nnoremap <leader>1 :only<cr>
nnoremap <leader>2 :only<cr>:vsplit<cr>
nnoremap <leader>3 :only<cr>:vsplit<cr>:split<cr>
nnoremap <leader>c :b1<cr>
nnoremap <leader>f :CtrlP<cr>
nnoremap <leader>h :nohlsearch<cr>
nnoremap <leader>m :setf markdown<cr>
nnoremap <leader>p :set paste!<cr>
nnoremap <leader>q :Bdelete<cr>
nnoremap <leader>r :w<cr>:Require!<cr>
nnoremap <leader>t :call RunCommand()<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>y :source ~/.config/nvim/init.vim<cr>

" NeoVim Terminal
tnoremap <c-j> <c-\><c-n><c-w>w
tnoremap <esc> <c-\><c-n>
