" Smaller cursor for INSERT mode, like spacemacs
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" Load pathogen plugin system
execute pathogen#infect()
" Use the Solarized Dark theme
set background=light
colorscheme solarized

" Make Vim more useful
set nocompatible
" Map jjj to ESC, less hand movement
inoremap jj <ESC>
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow C-a/e to move begin/end of line
imap <C-e> <End>
imap <C-a> <Home>
nmap <C-e> <End>
nmap <C-a> <Home>
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Add the g flag to search/replace by default
set gdefault
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
" Change mapleader
let mapleader=" "
" Don’t add empty newlines at the end of files
set binary
set noeol
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files
set modeline
set modelines=4
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight current line
set cursorline
" Make tabs as wide as two spaces
set tabstop=2
" Set indents at 2 spaces
set shiftwidth=2
" Use spaces instead of tabs
set expandtab
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Use indentation from current line when starting new
set autoindent
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Show delimiter at 80th column
if (exists('+colorcolumn'))
	set colorcolumn=80
endif
" Don’t show the intro message when starting Vim
set shortmess=atI
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
" Use relative line numbers (but not in insert mode)
if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
	au BufEnter,FocusGained,InsertLeave * set relativenumber
	au BufLeave,FocusLost,InsertEnter   * set norelativenumber
endif
" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
	" Always start git commit msg on first line
	autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
	autocmd FileType gitcommit set tw=80
	autocmd FileType markdown  set tw=80
	" Source the vimrc file after saving it
	 autocmd bufwritepost .vimrc source $MYVIMRC
	 " autoformat Elixir files (once 1.6 comes out)
	 " http://devonestes.herokuapp.com/everything-you-need-to-know-about-elixirs-new-formatter
	 " autocmd BufWritePost *.exs silent :!mix format %
	 " autocmd BufWritePost *.ex silent :!mix format %
	 autocmd BufWritePost *.elm silent :!elm format --yes %
endif

" Commenting blocks of code.
autocmd FileType c,cpp,java       let b:comment_leader = '// '
autocmd FileType groovy,scala     let b:comment_leader = '// '
autocmd FileType sh,ruby,elixir   let b:comment_leader = '# '
autocmd FileType perl,python      let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
autocmd FileType sql,elm          let b:comment_leader = '-- '
noremap <silent> <leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> <leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Repeat last command, while in visual mode
vnoremap . :norm.<CR>
" Search for tags file (.tags), in current up, going up until HOME
set tags=./.tags,.tags;$HOME

" enable folding based on indentation
set foldenable
set foldmethod=indent
" auto fold after 15 indented lines
set foldlevelstart=15
" max _nested_ folds
set foldnestmax=5
" automatically reload changed file (when changed from outside)
set autoread

" edit vimrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" minimize delay for INSERT mode - esc + O (open line above after insert mode)
set timeout timeoutlen=1000 ttimeoutlen=100

" add some Spacemacs style bindings
inoremap <leader>fs <C-O>:w<CR>
nnoremap <leader>fs :w<CR>
map <D-s> <C-O>:w<CR>

" multicursor settings
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" netrw settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_winsize = 25
augroup ProjectDrawer
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END

" keep stuff selected after changing indent
vnoremap < <gv
vnoremap > >gv

" to use fzf ?
set rtp+=/usr/local/opt/fzf
" treat words with dash as one (ex: font-size)
set iskeyword+=-