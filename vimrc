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

Plug 'elmcast/elm-vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'godlygeek/tabular'
Plug 'morhetz/gruvbox', { 'as': 'gruvbox' }
Plug 'mhinz/vim-signify'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'
Plug 'majutsushi/tagbar'
Plug 'artur-shaik/vim-javacomplete2', { 'for': ['java'] }
Plug 'elixir-editors/vim-elixir'

if has('ctags')
  Plug 'ludovicchabant/vim-gutentags'
endif

if has('nvim')
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif

call plug#end()

" Set the schema for vim - silently if not yet installed
silent! colorscheme gruvbox

" filetype detection:ON  plugin:ON  indent:ON
filetype plugin indent on

" Set omnifunc for autocomplete specifically for java files
autocmd FileType java setlocal omnifunc=javacomplete#Complete

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
set nojoinspaces        " Only one space when joining lines
set autochdir           " Set working directory to current file
set tags=tags;          " Set tags path
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
" Jump between tabs
nnoremap <F11> :tabprevious<CR>
nnoremap <leader>p :tabprevious<CR>
nnoremap <F12> :tabnext<CR>
nnoremap <leader>n :tabnext<CR>

" Enable paste toggle
nnoremap <F2> :set invpaste paste?<CR>

" Toggle text with to auto wrap text
nnoremap <leader>tt :call TextwidthToggle()<CR>

" Easier rezie
nnoremap <C-h> :vertical resize -5<CR>
nnoremap <C-l> :vertical resize +5<CR>
nnoremap <C-j> :resize -5<CR>
nnoremap <C-k> :resize +5<CR>

" Fix to jump to tags since <C-]> is hard to reach on Swedish keyboards
nnoremap <leader>gd :tag <C-R><C-W><CR>
nnoremap <leader>ggd :ptag <C-R><C-W><CR>

" Show autocomplete from deplete
inoremap <silent><expr><C-Space> deoplete#mappings#manual_complete()

" Denite mappings for quick searches
nnoremap <C-f> :<C-u>Denite file_rec<CR>
nnoremap <leader>b :<C-u>Denite buffer<CR>
nnoremap <leader>f :<C-u>DeniteCursorWord grep:. -mode=normal<CR>
nnoremap <leader>F :<C-u>Denite grep:. -mode=normal<CR>

" Fix to save a file with sudo if permission is not sufficient
cmap w!! w !sudo tee >/dev/null %

" denite settings - use ripgrep for file/rec, and grep,
if exists('*denite#custom#var')
  call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
  call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
endif

" Defx
autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
  " Define mappings
  nnoremap <silent><buffer><expr> <CR>
  \ defx#do_action('open')
  nnoremap <silent><buffer><expr> K
  \ defx#do_action('new_directory')
  nnoremap <silent><buffer><expr> N
  \ defx#do_action('new_file')
  nnoremap <silent><buffer><expr> h
  \ defx#do_action('cd', ['..'])
  nnoremap <silent><buffer><expr> ~
  \ defx#do_action('cd')
  nnoremap <silent><buffer><expr> <Space>
  \ defx#do_action('toggle_select') . 'j'
  nnoremap <silent><buffer><expr> j
  \ line('.') == line('$') ? 'gg' : 'j'
  nnoremap <silent><buffer><expr> k
  \ line('.') == 1 ? 'G' : 'k'
endfunction

" vim-airline settings
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1 " Prepatched fonts: https://github.com/powerline/fonts.git
let g:airline#extensions#tabline#enabled = 1

" vim-go
let g:go_fmt_command = "goimports"

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#disable_auto_complete = 0
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.java = '[^. *\t]\.\w*'
let g:deoplete#sources = {}
let g:deoplete#sources._ = []
let g:deoplete#file#enable_buffer_path = 1

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
