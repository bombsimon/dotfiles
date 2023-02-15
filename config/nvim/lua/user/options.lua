vim.opt.autochdir = false      -- DO NOT Set working directory to current file
vim.opt.autoindent = true      -- Auto indent
vim.opt.background = 'dark'    -- Use dark background
vim.opt.copyindent = true      -- Use existing indents for new indents
vim.opt.expandtab = true       -- Expand tabs to spaces
vim.opt.hlsearch = true        -- Highlight searched text
vim.opt.ignorecase = true      -- Search case insensitive
vim.opt.incsearch = true       -- Complete searches
vim.opt.joinspaces = false     -- Only one space when joining lines
vim.opt.laststatus = 2         -- Always show status bar
vim.opt.linebreak = true       -- Break words while wrapping at 'breakat'
vim.opt.modeline = true        -- Enable modline
vim.opt.modelines = 3          -- Look at max 3 lines
vim.opt.mouse = ''             -- Turn of mouse mode
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show line numbers
vim.opt.ruler = true           -- Show the line number on the bar
vim.opt.shell = '/bin/zsh'     -- Set explicit shell
vim.opt.shiftwidth = 4         -- Shift width 4
vim.opt.showcmd = true         -- Show command
vim.opt.spell = true           -- Help me spell
vim.opt.syntax = 'on'          -- Enable syntax highlighting
vim.opt.tabstop = 4            -- Tab stop 4
vim.opt.tags = 'tags'          -- Set tags path
vim.opt.termguicolors = true   -- Use 'true color' in terminal
vim.opt.textwidth = 80         -- Set textwidth to 80 for wrapping
vim.opt.wrap = false           -- Don't wrap lines

-- show cursor line only in active window
local CursorLineOnlyInActiveWindow = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd(
  { "VimEnter", "WinEnter", "BufWinEnter" },
  { pattern = "*", command = "set cursorline colorcolumn=80,120", group = CursorLineOnlyInActiveWindow }
)
vim.api.nvim_create_autocmd(
  { "WinLeave" },
  { pattern = "*", command = "set nocursorline colorcolumn=", group = CursorLineOnlyInActiveWindow }
)

-- set proper indentation for yaml
local filetypedetect = vim.api.nvim_create_augroup("filetypedetect", { clear = true })
vim.api.nvim_create_autocmd(
  { "FileType" },
  { pattern = "yaml", command = "setl sw=2 sts=2 et", group = filetypedetect }
)

-- play nice with NvimTree, skip loading netrw since we won't use it
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set custom leader
vim.g.mapleader = " "
