local M = {}

M.config = {
  cmd = "agy",
  model = nil,
  effort = nil,
  mode = nil, -- "accept-edits" | "plan"
  position = "right", -- "right" | "float" | "bottom"
  width = 0.42,
  height = 0.85,
  border = "rounded",
}

function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", M.config, opts)
end

local function build_cmd(extra_args)
  local cmd_parts = { M.config.cmd }
  if M.config.model and M.config.model ~= "" then
    table.insert(cmd_parts, "--model " .. vim.fn.shellescape(M.config.model))
  end
  if M.config.effort and M.config.effort ~= "" then
    table.insert(cmd_parts, "--effort " .. vim.fn.shellescape(M.config.effort))
  end
  if M.config.mode and M.config.mode ~= "" then
    table.insert(cmd_parts, "--mode " .. vim.fn.shellescape(M.config.mode))
  end
  if extra_args and extra_args ~= "" then
    table.insert(cmd_parts, extra_args)
  end
  return table.concat(cmd_parts, " ")
end

--- Toggle the Antigravity interactive CLI terminal
---@param extra_args string?
function M.toggle(extra_args)
  local full_cmd = build_cmd(extra_args)

  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.terminal then
    local win_opts = {
      position = M.config.position,
      width = M.config.width,
      height = M.config.height,
      border = M.config.border,
    }
    snacks.terminal.toggle(full_cmd, {
      id = "agy_terminal",
      win = win_opts,
    })
    return
  end

  -- Fallback to NvChad terminal
  local pos = (M.config.position == "right" and "vsp") or (M.config.position == "bottom" and "sp") or "float"
  require("nvchad.term").toggle {
    pos = pos,
    id = "agyTerm",
    cmd = full_cmd,
  }
end

--- Focus the active Antigravity CLI terminal
function M.focus()
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.terminal then
    local term = snacks.terminal.get "agy_terminal"
    if term and term:valid() and term.win and vim.api.nvim_win_is_valid(term.win) then
      vim.api.nvim_set_current_win(term.win)
      vim.cmd "startinsert"
      return
    end
  end
  M.toggle()
end

--- Continue the most recent Antigravity conversation (agy --continue)
function M.continue_session()
  M.toggle "--continue"
end

--- Prompt dialog: query user for prompt and launch interactive session (agy -i "<prompt>")
function M.prompt()
  vim.ui.input({ prompt = "Antigravity prompt: " }, function(input)
    if input and vim.trim(input) ~= "" then
      M.toggle(string.format('-i "%s"', input:gsub('"', '\\"')))
    end
  end)
end

--- Send arbitrary text to the running Antigravity terminal session
---@param text string
function M.send_text(text)
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.terminal then
    local term = snacks.terminal.get "agy_terminal"
    if not term or not term:valid() then
      M.toggle()
      term = snacks.terminal.get "agy_terminal"
    end
    if term and term.buf and vim.api.nvim_buf_is_valid(term.buf) then
      local job = vim.b[term.buf].terminal_job_id
      if job then
        vim.api.nvim_chan_send(job, text)
        return
      end
    end
  end

  for _, opts in pairs(vim.g.nvchad_terms or {}) do
    if opts.id == "agyTerm" and vim.api.nvim_buf_is_valid(opts.buf) then
      local job = vim.b[opts.buf].terminal_job_id
      if job then
        vim.api.nvim_chan_send(job, text)
        return
      end
    end
  end
end

--- Add buffer context to Antigravity session (@filename)
---@param bufnr integer?
function M.add_buffer(bufnr)
  bufnr = bufnr or 0
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == "" then
    vim.notify("Buffer has no associated file", vim.log.levels.WARN)
    return
  end
  local relpath = vim.fn.fnamemodify(bufname, ":.")
  M.send_text(string.format("@%s\n", relpath))
  vim.notify("Added " .. relpath .. " to Antigravity context", vim.log.levels.INFO)
end

--- Send visual selection reference to Antigravity session (@filename lines:[start-end])
function M.send_selection()
  local mode = vim.fn.mode()
  local s_line, e_line
  if mode:match "[vV\22]" then
    s_line = vim.fn.line "v"
    e_line = vim.fn.line "."
    if s_line > e_line then
      s_line, e_line = e_line, s_line
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)
  else
    s_line = vim.fn.line "'<"
    e_line = vim.fn.line "'>"
    if s_line == 0 or e_line == 0 then
      s_line = vim.fn.line "."
      e_line = s_line
    end
  end

  local bufname = vim.api.nvim_buf_get_name(0)
  local relpath = bufname ~= "" and vim.fn.fnamemodify(bufname, ":.") or "unnamed"
  local ref = string.format("@%s lines:[%d-%d]\n", relpath, s_line, e_line)
  M.send_text(ref)
  vim.notify(string.format("Sent %s lines %d-%d to Antigravity", relpath, s_line, e_line), vim.log.levels.INFO)
end

--- Select Antigravity model
function M.select_model()
  local models = {
    "Gemini 3.8 Flash (High)",
    "Gemini 3.8 Pro (High)",
    "Gemini 3.8 Flash (Medium)",
    "Gemini 3.8 Flash-Lite",
    "Claude 3.7 Sonnet",
    "Claude 3.5 Sonnet",
  }
  vim.ui.select(models, { prompt = "Select Antigravity Model:" }, function(choice)
    if choice then
      M.config.model = choice
      vim.notify("Antigravity model set to: " .. choice, vim.log.levels.INFO)
    end
  end)
end

--- Select reasoning effort
function M.select_effort()
  local efforts = { "low", "medium", "high" }
  vim.ui.select(efforts, { prompt = "Select Antigravity Reasoning Effort:" }, function(choice)
    if choice then
      M.config.effort = choice
      vim.notify("Antigravity effort set to: " .. choice, vim.log.levels.INFO)
    end
  end)
end

--- Toggle Antigravity execution mode (plan vs accept-edits)
function M.toggle_mode()
  M.config.mode = (M.config.mode == "plan") and "accept-edits" or "plan"
  vim.notify("Antigravity execution mode: " .. M.config.mode, vim.log.levels.INFO)
end

-- Register User Commands
vim.api.nvim_create_user_command("Agy", function() M.toggle() end, { desc = "Toggle Antigravity CLI" })
vim.api.nvim_create_user_command("AgyToggle", function() M.toggle() end, { desc = "Toggle Antigravity CLI" })
vim.api.nvim_create_user_command("AgyFocus", function() M.focus() end, { desc = "Focus Antigravity CLI" })
vim.api.nvim_create_user_command("AgyContinue", function() M.continue_session() end, { desc = "Continue Antigravity session" })
vim.api.nvim_create_user_command("AgyPrompt", function() M.prompt() end, { desc = "Antigravity interactive prompt" })
vim.api.nvim_create_user_command("AgyAdd", function() M.add_buffer(0) end, { desc = "Add current buffer to Antigravity context" })
vim.api.nvim_create_user_command("AgySend", function() M.send_selection() end, { range = true, desc = "Send selection to Antigravity" })
vim.api.nvim_create_user_command("AgySelectModel", function() M.select_model() end, { desc = "Select Antigravity model" })
vim.api.nvim_create_user_command("AgyEffort", function() M.select_effort() end, { desc = "Select Antigravity reasoning effort" })
vim.api.nvim_create_user_command("AgyMode", function() M.toggle_mode() end, { desc = "Toggle Antigravity mode (plan / accept-edits)" })
vim.api.nvim_create_user_command("Antigravity", function() M.toggle() end, { desc = "Toggle Antigravity CLI (alias)" })

return M
