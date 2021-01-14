"colorscheme rebecca-dark
colorscheme solarized

let mapleader=","

set number       " always shows line numbers
set colorcolumn=80
set clipboard+=unnamedplus
set ignorecase   " Ignore case of searches
set smartcase    " no ignorecase if Uppercase char present
set mouse=a      " enable mouse in all modes
set title        " Show the filename in the window titlebar
set scrolloff=3  " Start scrolling 3 lines before the horizontal window border
set nofoldenable " disable auto folding
set autoindent   " Automatic indentation
set smartindent  " Make it smart
set autochdir    " Change current working dir to the file's dir

" show trailing spaces and tabs
set listchars=tab:▸\ ,trail:·,nbsp:_
set list

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

" vimwiki magic
let garden_wiki = {}
let garden_wiki.path = '~/vimwiki'
let garden_wiki.syntax = 'markdown'
let garden_wiki.ext = 'md'
let garden_wiki.auto_tags = 1
let g:vimwiki_list = [garden_wiki]
" no temporary wikis
let g:vimwiki_global_ext = 0

" add keywords to default zettel YAML tags
let front_matter = {}
let front_matter.front_matter = {}
let front_matter.front_matter.keywords = []
let front_matter.front_matter.draft = "false"
let g:zettel_options = [front_matter]
" change default new filename to date-title.md
let g:zettel_format = "%Y-%m-%d-%title"
" use [[bla|title]] for internal links
let g:zettel_link_format = "[[%link|%title]]"
