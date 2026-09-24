require "nvchad.mappings"

local map = vim.keymap.set
local unmap = vim.keymap.del

-- Reclaim prefixes NvChad uses for one-shot terminals (Alt-h/v/i still toggle terms).
pcall(unmap, "n", "<leader>h")
pcall(unmap, "n", "<leader>v")

local function in_ui_buf()
  local ft = vim.bo.filetype
  return ft == "nvdash" or ft == "nvcheatsheet" or vim.bo.buftype ~= ""
end

--------------------------------------------------------------------------------
-- Core editing
--------------------------------------------------------------------------------
map("n", ";", ":", { desc = "Command line" })
map("i", "jk", "<Esc>", { desc = "Leave insert" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search" })

map("n", "n", "nzzzv", { desc = "Next match" })
map("n", "N", "Nzzzv", { desc = "Prev match" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

-- gj/gk only when wrap is on — global `j` remaps break NvDash button motion.
map({ "n", "x" }, "j", function()
  if vim.v.count == 0 and vim.wo.wrap and not in_ui_buf() then
    return "gj"
  end
  return "j"
end, { expr = true, silent = true, desc = "Down" })

map({ "n", "x" }, "k", function()
  if vim.v.count == 0 and vim.wo.wrap and not in_ui_buf() then
    return "gk"
  end
  return "k"
end, { expr = true, silent = true, desc = "Up" })

map("n", "J", "mzJ`z", { desc = "Join lines" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("v", "p", '"_dP', { desc = "Paste without yank" })

--------------------------------------------------------------------------------
-- Windows  <leader>w
--------------------------------------------------------------------------------
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

map("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>we", "<C-w>=", { desc = "Equal splits" })
map("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close split" })
map("n", "<leader>wo", "<C-w>o", { desc = "Only this window" })

--------------------------------------------------------------------------------
-- File Explorer (<leader>e and oil)
--------------------------------------------------------------------------------
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })

--------------------------------------------------------------------------------
-- Find  <leader>f  (FzfLua)
--------------------------------------------------------------------------------
map("n", "<leader>ff", function()
  require("fzf-lua").files()
end, { desc = "Files" })

map("n", "<leader>fp", function()
  require("fzf-lua").files()
end, { desc = "Files (preview)" })

map("n", "<leader>fa", function()
  require("fzf-lua").files { cwd = "~", hidden = true }
end, { desc = "Files (home)" })

map("n", "<leader>fP", function()
  require("fzf-lua").files { hidden = true, no_ignore = true }
end, { desc = "Files (all + preview)" })

map("n", "<leader>fg", function()
  require("fzf-lua").live_grep()
end, { desc = "Grep" })

map("n", "<leader>fw", function()
  require("fzf-lua").grep_cword()
end, { desc = "Grep word" })

map("n", "<leader>fb", function()
  require("fzf-lua").buffers()
end, { desc = "Buffers" })

map("n", "<leader>fo", function()
  require("fzf-lua").oldfiles()
end, { desc = "Recent files" })

map("n", "<leader>fh", function()
  require("fzf-lua").help_tags()
end, { desc = "Help" })

map("n", "<leader>fk", function()
  require("fzf-lua").keymaps()
end, { desc = "Keymaps" })

map("n", "<leader>fc", function()
  require("fzf-lua").commands()
end, { desc = "Commands" })

map("n", "<leader>fr", function()
  require("fzf-lua").resume()
end, { desc = "Resume" })

map("n", "<leader>fz", function()
  require("fzf-lua").blines()
end, { desc = "Buffer lines" })

map("n", "<leader>fs", function()
  require("fzf-lua").lsp_document_symbols()
end, { desc = "Symbols" })

map("n", "<leader>fS", function()
  require("fzf-lua").lsp_workspace_symbols()
end, { desc = "Workspace symbols" })

map("n", "<leader>fd", function()
  require("fzf-lua").diagnostics_document()
end, { desc = "Diagnostics" })

map("n", "<leader>fm", function()
  require("fzf-lua").marks()
end, { desc = "Marks" })

--------------------------------------------------------------------------------
-- Git extras (plugin keys cover gg/gd/gh; these fill the rest)
--------------------------------------------------------------------------------
map("n", "<leader>gc", "<cmd>FzfLua git_commits<CR>", { desc = "Commits" })
map("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", { desc = "Status" })
map("n", "<leader>gG", "<cmd>Git<CR>", { desc = "Fugitive status" })

--------------------------------------------------------------------------------
-- LSP / Formatting / Diagnostics  <leader>c
--------------------------------------------------------------------------------
map("n", "[d", function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = "Prev diagnostic" })

map("n", "]d", function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = "Next diagnostic" })

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>ds", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
map({ "n", "v" }, "<leader>cf", function()
  require("conform").format { lsp_fallback = true, async = false, timeout_ms = 1000 }
end, { desc = "Format file / range" })

--------------------------------------------------------------------------------
-- Python & Data Engineering (<leader>p)
--------------------------------------------------------------------------------
map("n", "<leader>pv", "<cmd>VenvSelect<CR>", { desc = "Select Python virtualenv" })
map("n", "<leader>pr", function()
  require("nvchad.term").runner { cmd = "python3 " .. vim.fn.expand "%", id = "pyRunner", pos = "sp" }
end, { desc = "Run Python file" })
map("n", "<leader>pt", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Run Python tests" })
map("n", "<leader>pd", function()
  local ok, dap_py = pcall(require, "dap-python")
  if ok then
    dap_py.test_method()
  else
    vim.notify("nvim-dap-python not loaded", vim.log.levels.WARN)
  end
end, { desc = "Debug Python method" })
map("n", "<leader>pi", function()
  require("nvchad.term").toggle { pos = "float", id = "ipythonTerm", cmd = "ipython || python3" }
end, { desc = "Python interactive REPL" })

--------------------------------------------------------------------------------
-- Jupyter & Notebook / Code Cells (<leader>j)
--------------------------------------------------------------------------------
map("n", "<leader>jc", "o# %%\n<Esc>", { desc = "Insert cell marker" })
map("n", "<leader>jr", function()
  require("utils.notebook").run_cell()
end, { desc = "Run cell in REPL" })
map("n", "<leader>jR", function()
  require("utils.notebook").run_all()
end, { desc = "Run whole file in REPL" })
map("n", "<leader>ji", function()
  require("nvchad.term").toggle { id = "ipythonTerm", pos = "float", cmd = "ipython || python3" }
end, { desc = "Toggle IPython REPL" })
map("n", "<leader>jx", function()
  require("utils.notebook").interrupt()
end, { desc = "Interrupt running cell (Ctrl-C)" })
map("n", "<leader>jk", function()
  require("utils.notebook").restart_kernel()
end, { desc = "Restart IPython session" })
map("n", "<leader>jo", function()
  require("nvchad.term").toggle { id = "pyRunner", pos = "sp" }
end, { desc = "Toggle script runner output (non-REPL)" })
map("n", "]j", "/^# %%\n<CR>", { silent = true, desc = "Next code cell" })
map("n", "[j", "?^# %%\n<CR>", { silent = true, desc = "Prev code cell" })

--------------------------------------------------------------------------------
-- Maven / Gradle / Spring Boot (<leader>m)
--------------------------------------------------------------------------------
map("n", "<leader>mr", function()
  local cmd = vim.fn.filereadable "mvnw" == 1 and "./mvnw spring-boot:run"
    or vim.fn.filereadable "gradlew" == 1 and "./gradlew bootRun"
    or vim.fn.filereadable "pom.xml" == 1 and "mvn spring-boot:run"
    or "gradle bootRun"
  require("nvchad.term").runner { cmd = cmd, id = "javaRunner", pos = "sp" }
end, { desc = "Spring Boot / Maven run" })

map("n", "<leader>mb", function()
  local cmd = vim.fn.filereadable "mvnw" == 1 and "./mvnw clean compile"
    or vim.fn.filereadable "gradlew" == 1 and "./gradlew build"
    or vim.fn.filereadable "pom.xml" == 1 and "mvn clean compile"
    or "gradle build"
  require("nvchad.term").runner { cmd = cmd, id = "javaRunner", pos = "sp" }
end, { desc = "Maven / Gradle build" })

map("n", "<leader>mt", function()
  local cmd = vim.fn.filereadable "mvnw" == 1 and "./mvnw test"
    or vim.fn.filereadable "gradlew" == 1 and "./gradlew test"
    or vim.fn.filereadable "pom.xml" == 1 and "mvn test"
    or "gradle test"
  require("nvchad.term").runner { cmd = cmd, id = "javaRunner", pos = "sp" }
end, { desc = "Maven / Gradle test" })

--------------------------------------------------------------------------------
-- Terminal toggles (<leader>t)
--------------------------------------------------------------------------------
map("n", "<leader>tt", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "Toggle floating terminal" })
map("n", "<leader>th", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "Toggle horizontal terminal" })
map("n", "<leader>tv", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "Toggle vertical terminal" })
map("n", "<leader>tg", function()
  require("nvchad.term").toggle { pos = "float", id = "lazygitTerm", cmd = "lazygit" }
end, { desc = "Toggle Lazygit terminal" })

--------------------------------------------------------------------------------
-- Buffers (<leader>b)
--------------------------------------------------------------------------------
map("n", "<leader>bb", "<cmd>FzfLua buffers<CR>", { desc = "Buffers list" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Prev buffer" })

--------------------------------------------------------------------------------
-- Project Command System (<leader>r)
--------------------------------------------------------------------------------
map("n", "<leader>rr", function()
  local proj = require "utils.project"
  proj.run_in_project_terminal(proj.get_run_command(), "projectRun")
end, { desc = "Run project" })

map("n", "<leader>rb", function()
  local proj = require "utils.project"
  proj.run_in_project_terminal(proj.get_build_command(), "projectBuild")
end, { desc = "Build project" })

map("n", "<leader>rt", function()
  local proj = require "utils.project"
  proj.run_in_project_terminal(proj.get_test_command(), "projectTest")
end, { desc = "Test project" })

map("n", "<leader>rd", function()
  local proj = require "utils.project"
  proj.run_in_project_terminal("dbt run || pytest", "dbtRun")
end, { desc = "Run dbt / data pipeline" })

map("n", "<leader>rc", function()
  local proj = require "utils.project"
  proj.run_in_project_terminal("docker compose up -d || docker-compose up -d", "dockerCompose")
end, { desc = "Docker compose up" })

--------------------------------------------------------------------------------
-- UI toggles  <leader>u
--------------------------------------------------------------------------------
map("n", "<leader>uh", function()
  if vim.lsp.inlay_hint then
    local current = vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
    vim.lsp.inlay_hint.enable(not current, { bufnr = 0 })
    vim.notify("Inlay hints: " .. (not current and "on" or "off"))
  end
end, { desc = "Toggle inlay hints" })
map("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Wrap" })
map("n", "<leader>ul", "<cmd>set list!<CR>", { desc = "Listchars" })
map("n", "<leader>us", "<cmd>set spell!<CR>", { desc = "Spell" })
map("n", "<leader>un", "<cmd>set nu!<CR>", { desc = "Line numbers" })
map("n", "<leader>ur", "<cmd>set rnu!<CR>", { desc = "Relative numbers" })
map("n", "<leader>uf", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
end, { desc = "Format on save" })

--------------------------------------------------------------------------------
-- Terminal Mode Navigation
--------------------------------------------------------------------------------
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal window left" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal window down" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal window up" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal window right" })
