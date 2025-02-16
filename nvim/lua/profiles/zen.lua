-- Minimal Neovim UI Configuration

-- Remove statusline
vim.o.laststatus = 0

-- Hide mode indicator
vim.o.showmode = false

-- Remove tabline
vim.o.showtabline = 0

-- Hide command line
vim.o.cmdheight = 0

-- Remove line numbers
vim.wo.number = false
vim.wo.relativenumber = false

-- Hide ruler
vim.o.ruler = false

-- Minimize messages
vim.opt.shortmess:append("F")

-- Remove sign column
vim.wo.signcolumn = "no"

-- Additional minimal settings
vim.o.fillchars = "eob: "  -- Remove ~ for empty lines
vim.o.showcmd = false      -- Don't show command in bottom bar
vim.o.showmatch = false    -- Don't highlight matching brackets
vim.o.wrap = false         -- Disable line wrapping
vim.o.cursorline = false   -- Disable highlighting of current line

-- Disable startup message
vim.opt.shortmess:append("I")

-- Disable mouse
vim.o.mouse = ""

-- Disable folding
vim.o.foldenable = false
