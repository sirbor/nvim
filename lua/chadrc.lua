---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "oceanic-next",
  transparency = false,

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.nvdash = {
  load_on_startup = true,
}

M.ui = {
  tabufline = {
    lazyload = false,
  },
  statusline = {
    theme = "minimal",
  },
}

M.lsp = {
  signature = true,
}

return M
