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
set mouse=                " Turn of mouse mode
set noautochdir           " DO NOT Set working directory to current file
set nojoinspaces          " Only one space when joining lines
set nowrap                " Don't wrap lines
set number                " Show line numbers
set pastetoggle=<F2>      " Enable paste toggle in insert mode
set rtp+=~/.fzf           " Add fzf to runtime path
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
