-- REPL-backed cell execution for `# %%` notebook-style Python files.
-- Not a real Jupyter kernel connection (no jupyter_client / molten) — this
-- shells out to a persistent `ipython` terminal (id "ipythonTerm", shared
-- with <leader>pi / <leader>ji) and drives it via `%run -i <tmpfile>`, which
-- keeps the process's namespace alive between cells like a real kernel would.
local M = {}

local CELL_MARKER = "^#%s?%%%%"
local TERM_ID = "ipythonTerm"

local function get_ipython_term()
  for _, opts in pairs(vim.g.nvchad_terms or {}) do
    if opts.id == TERM_ID and vim.api.nvim_buf_is_valid(opts.buf) then
      return opts.buf
    end
  end
  return nil
end

-- Opens the REPL if it doesn't exist yet, or re-shows it if hidden.
-- Never closes an already-visible REPL (unlike `nvchad.term.toggle`).
local function ensure_ipython_open()
  local buf = get_ipython_term()
  local freshly_spawned = buf == nil

  if buf == nil then
    require("nvchad.term").toggle { pos = "float", id = TERM_ID, cmd = "ipython || python3" }
    buf = get_ipython_term()
  elseif vim.fn.bufwinid(buf) == -1 then
    require("nvchad.term").toggle { pos = "float", id = TERM_ID }
  end

  return buf, freshly_spawned
end

local function send_to_ipython(code)
  if vim.trim(code) == "" then
    vim.notify("Nothing to run", vim.log.levels.WARN)
    return
  end

  local buf, freshly_spawned = ensure_ipython_open()
  if not buf then
    vim.notify("Could not open IPython terminal", vim.log.levels.ERROR)
    return
  end

  vim.defer_fn(function()
    local job = vim.b[buf].terminal_job_id
    if not job then
      vim.notify("IPython terminal has no active job", vim.log.levels.ERROR)
      return
    end
    local tmp = vim.fn.tempname() .. ".py"
    vim.fn.writefile(vim.split(code, "\n"), tmp)
    vim.api.nvim_chan_send(job, string.format("%%run -i %s\n", tmp))
  end, freshly_spawned and 800 or 50)
end

--- Find the `# %%` cell containing `cursor_line` within `lines`.
---@param cursor_line integer 1-indexed
---@param lines string[]
---@return integer start_line, integer end_line (1-indexed, inclusive)
local function get_cell_range(cursor_line, lines)
  local start_line, end_line = 1, #lines

  if lines[cursor_line] and lines[cursor_line]:match(CELL_MARKER) then
    start_line = cursor_line + 1
  else
    for i = cursor_line - 1, 1, -1 do
      if lines[i]:match(CELL_MARKER) then
        start_line = i + 1
        break
      end
    end
  end

  for i = start_line, #lines do
    if lines[i]:match(CELL_MARKER) then
      end_line = i - 1
      break
    end
  end

  return start_line, end_line
end

--- Run the `# %%` cell under the cursor in the persistent IPython REPL.
function M.run_cell()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local s, e = get_cell_range(cursor_line, lines)
  send_to_ipython(table.concat(lines, "\n", s, e))
end

--- Run the entire buffer in the persistent IPython REPL.
function M.run_all()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  send_to_ipython(table.concat(lines, "\n"))
end

--- Send Ctrl-C to interrupt whatever is currently running in the REPL.
function M.interrupt()
  local buf = get_ipython_term()
  if not buf then
    vim.notify("No active IPython session", vim.log.levels.WARN)
    return
  end
  local job = vim.b[buf].terminal_job_id
  if job then
    vim.api.nvim_chan_send(job, "\003")
  end
end

--- Exit and relaunch IPython in the same terminal buffer, clearing state.
function M.restart_kernel()
  local buf = get_ipython_term()
  if not buf then
    vim.notify("No active IPython session — start one with <leader>ji first", vim.log.levels.WARN)
    return
  end
  local job = vim.b[buf].terminal_job_id
  if not job then
    return
  end
  vim.api.nvim_chan_send(job, "exit()\n")
  vim.defer_fn(function()
    vim.api.nvim_chan_send(job, "clear; ipython\n")
  end, 400)
  vim.notify("Restarting IPython session...", vim.log.levels.INFO)
end

return M
