vim.opt.autochdir = false     -- DO NOT Set working directory to current file
vim.opt.autoindent = true     -- Auto indent
vim.opt.background = "dark"   -- Use dark background
vim.opt.copyindent = true     -- Use existing indents for new indents
vim.opt.expandtab = true      -- Expand tabs to spaces
vim.opt.foldmethod = "indent" -- Indent based folding
vim.opt.foldlevel = 2         -- Fold at 2 levels
vim.opt.hlsearch = true       -- Highlight searched text
vim.opt.ignorecase = true     -- Search case insensitive
vim.opt.incsearch = true      -- Complete searches
vim.opt.joinspaces = false    -- Only one space when joining lines
vim.opt.laststatus = 2        -- Always show status bar
vim.opt.linebreak = true      -- Break words while wrapping at 'breakat'
vim.opt.modeline = true       -- Enable modline
vim.opt.modelines = 3         -- Look at max 3 lines
vim.opt.mouse = ""            -- Turn of mouse mode
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show line numbers
vim.opt.ruler = true          -- Show the line number on the bar
vim.opt.shell = "/bin/zsh"    -- Set explicit shell
vim.opt.shiftwidth = 4        -- Shift width 4
vim.opt.showcmd = true        -- Show command
vim.opt.spell = true          -- Help me spell
vim.opt.syntax = "on"         -- Enable syntax highlighting
vim.opt.tabstop = 4           -- Tab stop 4
vim.opt.tags = "tags"         -- Set tags path
vim.opt.termguicolors = true  -- Use 'true color' in terminal
vim.opt.textwidth = 80        -- Set textwidth to 80 for wrapping
vim.opt.wrap = false          -- Don't wrap lines

-- show cursor line only in active window
local CursorLineOnlyInActiveWindow = vim.api.nvim_create_augroup("CursorLine", { clear = true })

local function is_floating_window()
  local win_config = vim.api.nvim_win_get_config(0)
  return win_config.relative ~= ""
end

vim.api.nvim_create_autocmd(
  { "VimEnter", "WinEnter", "BufWinEnter" },
  {
    pattern = "*",
    callback = function()
      -- We likely don't want to show colorcolumns in floats since they're
      -- likely not a window to write code but more something like
      -- diagnostics or a picker.
      if not is_floating_window() then
        vim.cmd("set cursorline colorcolumn=80,120")
      else
        vim.cmd("set colorcolumn=")
      end
    end,
    group = CursorLineOnlyInActiveWindow
  }
)

vim.api.nvim_create_autocmd(
  { "WinLeave" },
  {
    pattern = "*",
    command = "set nocursorline colorcolumn=",
    group = CursorLineOnlyInActiveWindow
  }
)

-- set proper indentation per file
-- needs to be changed for Lua to work properly since the LSP can't override
-- settings. https://luals.github.io/wiki/formatter/#default-configuration
local filetypedetect = vim.api.nvim_create_augroup("filetypedetect", { clear = false })
vim.api.nvim_create_autocmd(
  { "FileType" },
  { pattern = "lua", command = "setl sw=2 sts=2 et", group = filetypedetect }
)

-- make editor nice for screenshots
local function demo_settings()
  vim.cmd([[
    autocmd! CursorLine
    set nonumber norelativenumber nocursorline noruler noshowcmd showtabline=0 laststatus=0 colorcolumn= signcolumn=no
  ]])

  vim.diagnostic.config({ virtual_text = false })

  require("gitsigns").toggle_current_line_blame(false)
end

vim.api.nvim_create_user_command("Demo", demo_settings, {})

-- Trim trailing whitespace
require("editorconfig").trim_trailing_whitespace = true

-- Set diagnostics float border to rounded
local border = "rounded"
vim.diagnostic.config({
  virtual_text = true,
  underline = false,
  severity_sort = false, -- Less severity first, looks nicer for Rust
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  float = {
    show_header = false,
    source = true,
    border = border,
  },
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = border,
  }
)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = border,
  }
)
