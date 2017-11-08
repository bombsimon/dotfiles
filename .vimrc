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
set t_Co=256            " Enable 256 colors

filetype plugin indent on

colorscheme molokai     " https://github.com/tomasr/molokai.git

" Alias
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Wa ((getcmdtype() is# ':' && getcmdline() is# 'Wa')?('wa'):('Wa'))

" Mapping
nnoremap <F11> :tabprevious<CR>
nnoremap <F12> :tabnext<CR>
nnoremap <F2> :set invpaste paste?<CR>

cmap w!! w !sudo tee >/dev/null %

" Load vim-pathogen (autoload plugins from ~/.vim/bundle
execute pathogen#infect()

" vim-airline settings
let g:airline_theme='ubaryd'
let g:airline_powerline_fonts = 1 " Prepatched fonts: https://github.com/powerline/fonts.git
let g:airline#extensions#tabline#enabled = 1

" vim-go
let g:go_fmt_command = "goimports"

" Installed bundles
" pathogen              : https://github.com/tpope/vim-pathogen.git
" tabular               : https://github.com/godlygeek/tabular.git
" vim-airline           : https://github.com/vim-airline/vim-airline.git
" vim-airline-themes    : https://github.com/vim-airline/vim-airline-themes.git
" vim-commentary        : https://github.com/tpope/vim-commentary.git
" vim-fugitive          : https://github.com/tpope/vim-fugitive.git
" vim-gitgutter         : https://github.com/airblade/vim-gitgutter.git
" vim-go                : https://github.com/fatih/vim-go.git
" vim-signify           : https://github.com/mhinz/vim-signify.git
