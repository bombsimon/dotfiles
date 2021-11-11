if has('nvim')
  let g:vimSource   = '~/.local/share/nvim/plugged'
  let g:vimDownload = '~/.local/share/nvim/site/autoload/plug.vim'
else
  let g:vimSource   = '~/.vim/plugged'
  let g:vimDownload = '~/.vim/autoload/plug.vim'
endif

if empty(glob(g:vimDownload))
  silent exec "!curl -fLo " . g:vimDownload . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(g:vimSource)

Plug 'ray-x/material_plus.nvim'
Plug 'PProvost/vim-ps1'
Plug 'Yggdroot/indentLine'
Plug 'buoto/gotests-vim'
Plug 'cappyzawa/starlark.vim'
Plug 'cespare/vim-toml'
Plug 'dag/vim-fish'
Plug 'elixir-editors/vim-elixir'
Plug 'elmcast/elm-vim'
Plug 'elzr/vim-json' " Needed to use indentLine but don't conceal JSON quotes
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'gleam-lang/gleam.vim'
Plug 'godlygeek/tabular'
Plug 'google/vim-jsonnet'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-signify'
Plug 'morhetz/gruvbox', { 'as': 'gruvbox' }
Plug 'mxw/vim-jsx'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ollykel/v-vim'
Plug 'pangloss/vim-javascript'
Plug 'pearofducks/ansible-vim'
Plug 'pechorin/any-jump.vim'
Plug 'preservim/nerdtree'
Plug 'rust-lang/rust.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'w0rp/ale'

call plug#end()

" filetype detection:ON  plugin:ON  indent:ON
filetype plugin indent on

" Syntax and custom behaviour
augroup filetypedetect
  autocmd BufRead,BufNewFile *.make set  filetype=make
  autocmd FileType           yaml   setl sw=2 sts=2 et
  autocmd FileType           java   setl omnifunc=javacomplete#Complete
augroup END

syntax on                 " Enable syntax highlighting
set autoindent            " Auto indent
set background=dark       " Use dark background
set copyindent            " Use existing indents for new indents
set expandtab             " Expand tabs to spaces
set hlsearch              " Highlight serached text
set ignorecase            " Search case insensitive
set incsearch             " Complete searches
set laststatus=2          " Always show status bar
set linebreak             " Break words while wrapping at 'breakat'
set modeline              " Enable modline
set modelines=3           " Look at max 3 lines
set noautochdir           " DO NOT Set working directory to current file
set nojoinspaces          " Only one space when joining lines
set nowrap                " Don't wrap lines
set number                " Show line numbers
set pastetoggle=<F2>      " Enable paste toggle in insert mode
set rtp+=~/.fzf           " Add fzf to runtime path
set ruler                 " Show the line number on the bar
set shell=/bin/zsh        " Set explicit shell
set shiftwidth=4          " Shift width 4
set showcmd               " Show command
set spell spelllang=en_us " Help me spell
set t_Co=256              " Enable 256 colors
set tabstop=4             " Tab stop 4
set tags=tags;            " Set tags path
set termguicolors         " Use 'true color' in terminal
set textwidth=80          " Set textwidth to 80 for wrapping
set grepprg=rg\
  \ --vimgrep\
  \ --no-heading

" Configure Material theme
let g:material_style_fix = v:true
let g:material_italic_comments = v:true
let g:material_italic_string = v:true
let g:material_style = "mariana"

" Set the schema for vim - silently if not yet installed
" Set it after we change syntax and other things since those changes affect the
" colorscheme and might issue print statements.
silent! colorscheme material

" This will not work nice with macOS since I only access one register
if !has('macunix')
  set clipboard=unnamed " Set vim clipboard to to X clipboard
endif

let mapleader="\<space>"

" Only show cursor and colorcolumn in active windows when using splits
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline colorcolumn=80
  autocmd WinLeave * setlocal nocursorline colorcolumn=
augroup END

" Disable arrow keys in escape mode
map <up>    <nop>
map <down>  <nop>
map <left>  <nop>
map <right> <nop>

" Alias
command! W w
command! Wa wa

" Fix to save a file with sudo if permission is not sufficient
cmap w!! w !sudo tee >/dev/null %

" Mapping
" Jump between tabs
nnoremap <F11> :tabprevious<CR>
nnoremap <F12> :tabnext<CR>
nnoremap <leader>p :tabprevious<CR>
nnoremap <leader>n :tabnext<CR>

" Enable paste toggle
nnoremap <F2> :set invpaste paste?<CR>
nnoremap <leader>2 :set invpaste paste?<CR>

" Resize splits
nnoremap <C-h> :vertical resize -5<CR>
nnoremap <C-l> :vertical resize +5<CR>
nnoremap <C-j> :resize -5<CR>
nnoremap <C-k> :resize +5<CR>

" Fix to jump to tags since <C-]> is hard to reach on Swedish keyboards
nnoremap <leader>gd :tag <C-R><C-W><CR>
nnoremap <leader>ggd :ptag <C-R><C-W><CR>

" Tagbar toggle
nnoremap <leader>t :TagbarToggle<CR>

" Move to current directory (local buffer only or all buffers)
nnoremap <leader>cd :lcd %:p:h<CR>
nnoremap <leader>cc :cd %:p:h<CR>

" fzf
nmap <leader>f [fzf-p]
xmap <leader>f [fzf-p]

nnoremap <silent> [fzf-p]f     :<C-u>FzfPreviewProjectFiles<CR>

nnoremap <silent> [fzf-p]p     :<C-u>FzfPreviewFromResourcesRpc project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>FzfPreviewGitStatusRpc<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>FzfPreviewGitActionsRpc<CR>
nnoremap <silent> [fzf-p]b     :<C-u>FzfPreviewBuffersRpc<CR>
nnoremap <silent> [fzf-p]B     :<C-u>FzfPreviewAllBuffersRpc<CR>
nnoremap <silent> [fzf-p]o     :<C-u>FzfPreviewFromResourcesRpc buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>FzfPreviewJumpsRpc<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>FzfPreviewChangesRpc<CR>
nnoremap <silent> [fzf-p]/     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>FzfPreviewLinesRpc --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>FzfPreviewProjectGrepRpc<Space>
xnoremap          [fzf-p]gr    "sy:FzfPreviewProjectGrepRpc<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>FzfPreviewBufferTagsRpc<CR>
nnoremap <silent> [fzf-p]q     :<C-u>FzfPreviewQuickFixRpc<CR>
nnoremap <silent> [fzf-p]l     :<C-u>FzfPreviewLocationListRpc<CR>

" coc mappings
nmap <silent> <C-p> :call CocActionAsync('doHover')<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Set explorer style
let g:netrw_altv = 1         " Change to right splitting
let g:netrw_banner = 1       " Enable banner
let g:netrw_browse_split = 0 " Open files in same window
let g:netrw_liststyle = 0    " List style as default
let g:netrw_menu = 1         " Enable menu
let g:netrw_winsize = 20     " Use 20 columns for the netrw window

nnoremap <leader>. :NERDTreeToggle<CR>
nnoremap <leader>, :NERDTreeFind<CR>

" vim-json
" Don't conceal quotes
let g:vim_json_syntax_conceal = 0

" indentLine
" Ignore markdown files.
let g:indentLine_fileTypeExclude = ['markdown']

" vim-airline
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1 " Prepatched fonts: https://github.com/powerline/fonts.git
let g:airline#extensions#tabline#enabled = 1

" signify
nnoremap <leader>sd :SignifyDiff<cr>
nnoremap <leader>sp :SignifyHunkDiff<cr>
nnoremap <leader>su :SignifyHunkUndo<cr>

" hunk jumping
nmap <leader>sj <plug>(signify-next-hunk)
nmap <leader>sk <plug>(signify-prev-hunk)

" hunk text object
omap ic <plug>(signify-motion-inner-pending)
xmap ic <plug>(signify-motion-inner-visual)
omap ac <plug>(signify-motion-outer-pending)
xmap ac <plug>(signify-motion-outer-visual)

" vim-coc
call coc#add_extension(
  \ 'coc-go',
  \ 'coc-json',
  \ 'coc-yaml',
  \ 'coc-rust-analyzer',
  \ 'coc-python',
\ )

" vim-go
let g:go_code_completion_enabled = 0 " coc handles completion with LSP
let g:go_def_mode='godef'
let g:go_fmt_autosave = 0
let g:go_fmt_command = "goimports"
let g:go_gocode_propose_source = 0
let g:go_gocode_unimported_packages = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_metalinter_autosave = 0

" rust.vim
let g:rustfmt_autosave = 1
if has('macunix')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif

" ale
function! FormaV(buffer) abort
  return {
  \   'command': 'v fmt -'
  \}
endfunction

execute ale#fix#registry#Add('vfmt', 'FormatV', ['v'], 'v fmt for vlang')

let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 0 " Less distracting when opening a new file
let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '⚠'

let g:ale_go_gofmt_options = '-s'
let g:ale_go_golangci_lint_options = '--fast --config ~/.golangci.yml'
let g:ale_go_golangci_lint_package = 1

let g:ale_python_black_options = '--line-length 79'
" Configure flake8 according to black recommendation.
" https://github.com/PyCQA/flake8-bugbear#opinionated-warnings
" https://github.com/psf/black/blob/master/.flake8
let g:ale_python_flake8_options = '--ignore="E203,E266,E501,W503"'

let g:ale_rust_cargo_use_clippy = 1

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'go': ['goimports', 'gofmt'],
\   'javascript': ['prettier', 'eslint'],
\   'json': ['jq'],
\   'perl': ['perltidy'],
\   'python': ['black'],
\   'ruby': ['rubocop'],
\   'vlang': ['vfmt'],
\   'starlark': ['buildifier'],
\}

let g:ale_linters = {
\   'go': ['golangci-lint', 'golint'],
\   'javascript': ['eslint'],
\   'perl': ['perlcritic'],
\   'python': ['flake8', 'pylint'],
\}

" vim: set ts=2 sw=2 et:
