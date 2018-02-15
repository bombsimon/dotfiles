call plug#begin('~/.vim/bundle')

Plug '~/git/fzf'
Plug 'junegunn/fzf.vim'
Plug 'godlygeek/tabular'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'mhinz/vim-signify'
Plug 'morhetz/gruvbox', { 'as': 'gruvbox' }

call plug#end()

colorscheme gruvbox
filetype plugin indent on
syntax on               " Needed for mac OS

set number              " Show line numbers
set showcmd             " Show command
set autoindent          " Auto indent
set nowrap              " Don't wrap lines
set ts=4                " Tab space 4
set sw=4                " Shift width 4
set et                  " Expand tabs
set copyindent          " Use existing indents for new indents
set ignorecase          " Search case insensitive
set ruler               " Show the line number on the bar
set linebreak           " Break words while wrapping at 'breakat'
set incsearch           " Complete searches
set hlsearch            " Highlight serached text
set modeline            " Enable modline
set modelines=3         " Look at max 3 lines
set laststatus=2        " Always show status bar
set pastetoggle=<F2>    " Enable paste toggle in insert mode
set cursorline          " Mark whole line with cursor
set t_Co=256            " Enable 256 colors
set background=dark

let mapleader=" "

" Disable Arrow keys in Escape mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Disable Arrow keys in Insert mode
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

" Alias
command! W w
command! Wa wa
command! E Files

" Mapping
nnoremap <F11> :tabprevious<CR>
nnoremap <F12> :tabnext<CR>
nnoremap <F2> :set invpaste paste?<CR>

cmap w!! w !sudo tee >/dev/null %

" vim-airline settings
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1 " Prepatched fonts: https://github.com/powerline/fonts.git
let g:airline#extensions#tabline#enabled = 1

" vim-go
let g:go_fmt_command = "goimports"
