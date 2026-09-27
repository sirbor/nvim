require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local function group(name)
  return augroup("user_" .. name, { clear = true })
end

-- Highlight yanked text
autocmd("TextYankPost", {
  group = group "yank",
  callback = function()
    vim.highlight.on_yank { higroup = "IncSearch", timeout = 120 }
  end,
})

-- Restore last cursor position
autocmd("BufReadPost", {
  group = group "restore_cursor",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close utility buffers with q
autocmd("FileType", {
  group = group "close_with_q",
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
    "gitsigns-blame",
    "oil",
    "neotest-output",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, nowait = true })
  end,
})

-- Create missing parent dirs on save
autocmd("BufWritePre", {
  group = group "auto_create_dir",
  callback = function(event)
    if event.match:match "^%w%w+:[\\/][\\/]" then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Equalize splits when the terminal is resized
autocmd("VimResized", {
  group = group "resize_splits",
  callback = function()
    local current = vim.api.nvim_get_current_tabpage()
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      vim.api.nvim_set_current_tabpage(tab)
      vim.cmd "tabdo wincmd ="
    end
    vim.api.nvim_set_current_tabpage(current)
  end,
})

-- Check if file changed outside Neovim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = group "checktime",
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd "checktime"
    end
  end,
})

-- Register filetypes (Blade templates, Pug, Templ)
vim.filetype.add {
  pattern = {
    [".*%.blade%.php"] = "blade",
  },
  extension = {
    pug = "pug",
    templ = "templ",
  },
}

-- Register Blade parser for nvim-treesitter
autocmd("User", {
  pattern = "TSUpdate",
  group = group "blade_treesitter",
  callback = function()
    local ok_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
    if ok_parsers and not parsers.blade then
      parsers.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }
    end
  end,
})

-- Ensure blade filetype maps to the blade parser if treesitter is present
pcall(function()
  vim.treesitter.language.register("blade", "blade")
end)
