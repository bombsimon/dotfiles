if has('nvim')
    let g:vimSource = '~/.local/share/nvim/plugged'
else
    let g:vimSource = '~/.vim/plugged'
endif

if empty(glob(g:vimSource))
    silent exec "!curl -fLo " . g:vimSource . "--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(g:vimSource)

Plug '~/git/fzf'
Plug 'elmcast/elm-vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'godlygeek/tabular'
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox', { 'as': 'gruvbox' }
Plug 'mhinz/vim-signify'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif

call plug#end()

silent! colorscheme gruvbox
filetype plugin indent on
syntax on               " Needed for mac OS

set number              " Show line numbers
set showcmd             " Show command
set autoindent          " Auto indent
set nowrap              " Don't wrap lines
set tabstop=4           " Tab stop 4
set shiftwidth=4        " Shift width 4
set expandtab           " Expand tabs
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
set background=dark     " Use dark background

let mapleader="\<space>"

" Only show cursor in active windows when using splits
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

" Disable arrow keys in escape mode
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Alias
command! W w
command! Wa wa
command! E Files

" Mapping
nnoremap <F11> :tabprevious<CR>
nnoremap <leader>p :tabprevious<CR>
nnoremap <F12> :tabnext<CR>
nnoremap <leader>n :tabnext<CR>
nnoremap <F2> :set invpaste paste?<CR>
nnoremap <leader>tt :call TextwidthToggle()<CR>

inoremap <silent><expr><C-Space> deoplete#mappings#manual_complete()

cmap w!! w !sudo tee >/dev/null %

" vim-airline settings
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1 " Prepatched fonts: https://github.com/powerline/fonts.git
let g:airline#extensions#tabline#enabled = 1

" vim-go
let g:go_fmt_command = "goimports"

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 0

" ale
let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '.'
let g:ale_lint_on_enter = 0 " Less distracting when opening a new file

" rust.vim
let g:rustfmt_autosave = 1

" Functions
function! TextwidthToggle()
  if &textwidth =~ '80'
    set tw=0
  else
    set tw=80
  endif

  echom "Textwidth set to " . &tw
endfunction

" Fix for deoplete in macOS
if glob('/usr/local/bin/python2')
    let g:python3_host_prog='/usr/local/bin/python3'
    let g:python2_host_prog='/usr/local/bin/python2'
endif
