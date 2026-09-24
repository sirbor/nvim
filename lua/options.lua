require "nvchad.options"

local o = vim.opt
local g = vim.g

-- Identity
g.maplocalleader = "\\"

-- Discover Android SDK tools if installed in standard location
local android_sdk = vim.fn.expand "~/Library/Android/sdk"
if vim.fn.isdirectory(android_sdk) == 1 then
  vim.env.ANDROID_HOME = vim.env.ANDROID_HOME or android_sdk
  local emulator_bin = android_sdk .. "/emulator"
  local platform_tools = android_sdk .. "/platform-tools"
  if vim.fn.isdirectory(emulator_bin) == 1 and not string.find(vim.env.PATH or "", emulator_bin, 1, true) then
    vim.env.PATH = emulator_bin .. ":" .. (vim.env.PATH or "")
  end
  if vim.fn.isdirectory(platform_tools) == 1 and not string.find(vim.env.PATH or "", platform_tools, 1, true) then
    vim.env.PATH = platform_tools .. ":" .. (vim.env.PATH or "")
  end
end

-- Line numbers
o.number = true
o.relativenumber = true
o.numberwidth = 2

-- Indentation
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true
o.breakindent = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true
o.inccommand = "split"

-- Appearance
o.cursorline = true
o.cursorlineopt = "number,line"
o.signcolumn = "yes"
o.scrolloff = 8
o.sidescrolloff = 8
o.termguicolors = true
o.wrap = false
o.smoothscroll = true
o.pumheight = 12
if vim.fn.has "nvim-0.11" == 1 then
  o.winborder = "rounded"
end
o.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "▾",
  foldsep = " ",
  foldclose = "▸",
  diff = "╱",
}

-- Folding (nvim-ufo)
o.foldcolumn = "1"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true

-- Behavior
o.clipboard = "unnamedplus"
o.splitbelow = true
o.splitright = true
o.undofile = true
o.undolevels = 10000
o.updatetime = 200
o.timeoutlen = 300
o.confirm = true
o.backup = false
o.writebackup = false
o.virtualedit = "block"
o.jumpoptions = "view"

-- Whitespace (toggle with <leader>uw)
o.list = false
o.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }

-- Disable noisy providers
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
