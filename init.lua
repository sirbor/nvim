vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Ensure Mason bin directory is always on PATH for LSPs, formatters, and DAPs
local mason_bin = vim.fn.stdpath "data" .. "/mason/bin"
if not string.find(vim.env.PATH or "", mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. (vim.env.PATH or "")
end

-- Forward-compatible shim for vim.tbl_flatten in Neovim 0.11+ / 0.12+ to silence upstream plugin warnings
if vim.iter then
  vim.tbl_flatten = function(t)
    return vim.iter(t):flatten(math.huge):totable()
  end
end

-- Forward-compatible shim for vim.validate({ <table> }) in Neovim 0.11+ / 0.12+ to silence upstream plugin warnings
if vim.validate then
  local orig_validate = vim.validate
  vim.validate = function(opt, ...)
    if type(opt) == "table" and select("#", ...) == 0 then
      for k, v in pairs(opt) do
        if type(v) == "table" then
          orig_validate(k, v[1], v[2], v[3])
        end
      end
      return
    end
    return orig_validate(opt, ...)
  end
end

-- Backward-compatible shim for vim.health.report_* removed/deprecated in Neovim 0.12+
if vim.health then
  vim.health.report_start = vim.health.report_start or vim.health.start
  vim.health.report_ok = vim.health.report_ok or vim.health.ok
  vim.health.report_warn = vim.health.report_warn or vim.health.warn
  vim.health.report_error = vim.health.report_error or vim.health.error
  vim.health.report_info = vim.health.report_info or vim.health.info
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local result = vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim:\n" .. result)
  end
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme (safely guarded for clean bootstrapping on fresh devices)
pcall(dofile, vim.g.base46_cache .. "defaults")
pcall(dofile, vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
  require "utils.health"
end)
