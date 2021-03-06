" Use the Solarized Dark theme
set background=dark
colorscheme solarized
let g:solarized_termtrans=1

" Make Vim more useful
set nocompatible
" Enhance command-line completion
set wildmenu
" List all file matches in command mode without completing to the first match
set wildmode=longest:full
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Use UTF-8 without BOM
set encoding=utf-8 nobomb
set fileencoding=utf-8
" Set <EOL> to LF and CRLF as failsafe
set fileformat=unix
set fileformats=unix,dos
" Change mapleader
let mapleader=","
" Don’t add empty newlines at the end of files
set binary
set noeol
" remove backups, swapfiles, undofiles
"set noswapfile
set nobackup
set nowritebackup
set noundofile
" Respect modeline in files
set modeline
set modelines=5
" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure
" Enable line numbers
set number
" Enable syntax highlighting
syntax enable
" Make tabs as wide as 8 spaces
set tabstop=8
" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
set smartcase           " no ignorecase if Uppercase char present
" Highlight dynamically as pattern is typed
set incsearch
" Always show status line
set laststatus=2
" Enable mouse in all modes
set mouse=a
" Make mouse work in alacritty see:
" https://wiki.archlinux.org/index.php/Alacritty#Mouse_not_working_properly_in_Vim
set ttymouse=sgr
" Disable error bells
set noerrorbells
" Don’t reset cursor to start of line when moving around.
set nostartofline
" Show the cursor position
set ruler
" Show the current mode
set showmode
" Show the filename in the window titlebar
set title
" Show the (partial) command as it’s being typed
set showcmd
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

" text formatting
set formatoptions+=t " Auto-wrap text using textwidth
set formatoptions+=c " same for comments
set formatoptions+=q " Allow formatting of comments with 'gq'
set formatoptions-=l " make it work for older text

" Automatic commands
if has("autocmd")
	" Enable file type detection
	filetype on
	filetype plugin on
	filetype indent on
	" define csv filetype
	autocmd BufNewFile,BufRead *csv set filetype=csv

	" some line wraps :)
	autocmd FileType markdown set textwidth=79
	autocmd FileType yaml set ts=2 sts=2 sw=2 expandtab foldmethod=indent
	" disable line wdraps for csv
	autocmd FileType csv set textwidth=0
endif
" number of lines to keep in history
set history=50
" disable auto folding
set nofoldenable
" Automatic indentation
set autoindent
" Make it smart
set smartindent
" To paste from another application:
"    Start insert mode.
"    Press F2 (toggles the 'paste' option on).
"    Use your terminal to paste text from the clipboard.
"    Press F2 (toggles the 'paste' option off).
set pastetoggle=<F2>

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright
" Quicker window movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
