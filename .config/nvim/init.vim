colorscheme solarized

let mapleader=","

set number       " always shows line numbers
set colorcolumn=80
set clipboard+=unnamedplus
set nowrap
set ignorecase   " Ignore case of searches
set smartcase    " no ignorecase if Uppercase char present
set mouse=a      " enable mouse in all modes
set title        " Show the filename in the window titlebar
set scrolloff=3  " Start scrolling 3 lines before the horizontal window border
set nofoldenable " disable auto folding
set autoindent   " Automatic indentation
set smartindent  " Make it smart

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" text formatting
set formatoptions+=t " Auto-wrap text using textwidth
set formatoptions+=c " same for comments
set formatoptions+=q " Allow formatting of comments with 'gq'
set formatoptions-=l " make it work for older text

" Quicker window movement with ctrl-w + hjkl
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" define csv filetype
autocmd BufNewFile,BufRead *csv set filetype=csv

autocmd FileType csv set textwidth=0       " disable line wdraps for csv
autocmd FileType markdown set textwidth=79 " make text break lines at 79 chars
autocmd FileType yaml set ts=2 sts=2 sw=2 expandtab foldmethod=indent " magic

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>
