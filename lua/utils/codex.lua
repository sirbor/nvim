local M = {}

M.config = {
  cmd = "codex",
  model = nil,
  sandbox = nil, -- "workspace-write" | "read-only" | "danger-full-access"
  approval = nil, -- "on-request" | "never"
  search = false, -- boolean: enable live web search (--search)
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
    table.insert(cmd_parts, "-m " .. vim.fn.shellescape(M.config.model))
  end
  if M.config.sandbox and M.config.sandbox ~= "" then
    table.insert(cmd_parts, "-s " .. vim.fn.shellescape(M.config.sandbox))
  end
  if M.config.approval and M.config.approval ~= "" then
    table.insert(cmd_parts, "-a " .. vim.fn.shellescape(M.config.approval))
  end
  if M.config.search then
    table.insert(cmd_parts, "--search")
  end
  if extra_args and extra_args ~= "" then
    table.insert(cmd_parts, extra_args)
  end
  return table.concat(cmd_parts, " ")
end

--- Toggle the Codex interactive CLI terminal
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
      id = "codex_terminal",
      win = win_opts,
    })
    return
  end

  -- Fallback to NvChad terminal
  local pos = (M.config.position == "right" and "vsp") or (M.config.position == "bottom" and "sp") or "float"
  require("nvchad.term").toggle {
    pos = pos,
    id = "codexTerm",
    cmd = full_cmd,
  }
end

--- Focus the active Codex CLI terminal
function M.focus()
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.terminal then
    local term = snacks.terminal.get "codex_terminal"
    if term and term:valid() and term.win and vim.api.nvim_win_is_valid(term.win) then
      vim.api.nvim_set_current_win(term.win)
      vim.cmd "startinsert"
      return
    end
  end
  M.toggle()
end

--- Continue / resume the most recent Codex conversation (codex resume --last)
function M.resume_last()
  M.toggle "resume --last"
end

--- Open interactive session picker (codex resume)
function M.resume_picker()
  M.toggle "resume"
end

--- Prompt dialog: query user for prompt and launch interactive session (codex "<prompt>")
function M.prompt()
  vim.ui.input({ prompt = "Codex prompt: " }, function(input)
    if input and vim.trim(input) ~= "" then
      M.toggle(string.format('"%s"', input:gsub('"', '\\"')))
    end
  end)
end

--- Send arbitrary text to the running Codex terminal session
---@param text string
function M.send_text(text)
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.terminal then
    local term = snacks.terminal.get "codex_terminal"
    if not term or not term:valid() then
      M.toggle()
      term = snacks.terminal.get "codex_terminal"
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
    if opts.id == "codexTerm" and vim.api.nvim_buf_is_valid(opts.buf) then
      local job = vim.b[opts.buf].terminal_job_id
      if job then
        vim.api.nvim_chan_send(job, text)
        return
      end
    end
  end
end

--- Add buffer context to Codex session (@filename)
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
  vim.notify("Added " .. relpath .. " to Codex context", vim.log.levels.INFO)
end

--- Send visual selection reference to Codex session (@filename lines:[start-end])
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
  vim.notify(string.format("Sent %s lines %d-%d to Codex", relpath, s_line, e_line), vim.log.levels.INFO)
end

--- Select Codex model
function M.select_model()
  local models = {
    "o3",
    "o3-mini",
    "o1",
    "gpt-4o",
    "gpt-4.5-preview",
  }
  vim.ui.select(models, { prompt = "Select Codex Model:" }, function(choice)
    if choice then
      M.config.model = choice
      vim.notify("Codex model set to: " .. choice, vim.log.levels.INFO)
    end
  end)
end

--- Select Codex sandbox mode
function M.select_sandbox()
  local modes = {
    "workspace-write",
    "read-only",
    "danger-full-access",
  }
  vim.ui.select(modes, { prompt = "Select Codex Sandbox Policy:" }, function(choice)
    if choice then
      M.config.sandbox = choice
      vim.notify("Codex sandbox set to: " .. choice, vim.log.levels.INFO)
    end
  end)
end

--- Select Codex human approval policy
function M.select_approval()
  local policies = {
    "on-request",
    "never",
  }
  vim.ui.select(policies, { prompt = "Select Codex Approval Policy:" }, function(choice)
    if choice then
      M.config.approval = choice
      vim.notify("Codex approval policy set to: " .. choice, vim.log.levels.INFO)
    end
  end)
end

--- Toggle Codex web search
function M.toggle_search()
  M.config.search = not M.config.search
  vim.notify("Codex live web search: " .. (M.config.search and "enabled" or "disabled"), vim.log.levels.INFO)
end

--- Run code review on uncommitted changes (codex review --uncommitted)
function M.review_uncommitted()
  M.toggle "review --uncommitted"
end

--- Prompt dialog for custom code review (codex review "<instructions>")
function M.review_prompt()
  vim.ui.input({ prompt = "Codex review instructions: " }, function(input)
    if input and vim.trim(input) ~= "" then
      M.toggle(string.format('review "%s"', input:gsub('"', '\\"')))
    end
  end)
end

--- Apply diff produced by Codex agent (codex apply <task_id>)
function M.apply_diff()
  vim.ui.input({ prompt = "Codex Task ID to apply diff from: " }, function(task_id)
    if task_id and vim.trim(task_id) ~= "" then
      M.toggle(string.format("apply %s", vim.trim(task_id)))
    end
  end)
end

-- Register User Commands
vim.api.nvim_create_user_command("Codex", function()
  M.toggle()
end, { desc = "Toggle Codex CLI" })
vim.api.nvim_create_user_command("CodexToggle", function()
  M.toggle()
end, { desc = "Toggle Codex CLI" })
vim.api.nvim_create_user_command("CodexFocus", function()
  M.focus()
end, { desc = "Focus Codex CLI" })
vim.api.nvim_create_user_command("CodexResume", function()
  M.resume_last()
end, { desc = "Resume most recent Codex session" })
vim.api.nvim_create_user_command("CodexResumePicker", function()
  M.resume_picker()
end, { desc = "Codex session resume picker" })
vim.api.nvim_create_user_command("CodexPrompt", function()
  M.prompt()
end, { desc = "Codex interactive prompt" })
vim.api.nvim_create_user_command("CodexAdd", function()
  M.add_buffer(0)
end, { desc = "Add current buffer to Codex context" })
vim.api.nvim_create_user_command("CodexSend", function()
  M.send_selection()
end, { range = true, desc = "Send selection to Codex" })
vim.api.nvim_create_user_command("CodexSelectModel", function()
  M.select_model()
end, { desc = "Select Codex model" })
vim.api.nvim_create_user_command("CodexSandbox", function()
  M.select_sandbox()
end, { desc = "Select Codex sandbox mode" })
vim.api.nvim_create_user_command("CodexApproval", function()
  M.select_approval()
end, { desc = "Select Codex approval policy" })
vim.api.nvim_create_user_command("CodexSearchToggle", function()
  M.toggle_search()
end, { desc = "Toggle Codex web search" })
vim.api.nvim_create_user_command("CodexReview", function()
  M.review_uncommitted()
end, { desc = "Codex review uncommitted changes" })
vim.api.nvim_create_user_command("CodexReviewPrompt", function()
  M.review_prompt()
end, { desc = "Codex custom review prompt" })
vim.api.nvim_create_user_command("CodexApply", function()
  M.apply_diff()
end, { desc = "Codex apply task diff" })

return M
