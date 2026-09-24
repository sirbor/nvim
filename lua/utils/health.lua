local M = {}

local groups = {
  {
    name = "CORE DEPENDENCIES (Required for Core Neovim & Fuzzy Finder)",
    tools = {
      { bin = "git", desc = "Git version control" },
      { bin = "rg", desc = "Ripgrep fast search" },
      { bin = "fd", desc = "Fd file finder" },
      { bin = "fzf", desc = "Fzf fuzzy finder" },
    },
  },
  {
    name = "LANGUAGE RUNTIMES & COMPILERS",
    tools = {
      { bin = "node", desc = "Node.js JavaScript/TypeScript runtime" },
      { bin = "npm", desc = "Node package manager" },
      { bin = "python3", desc = "Python 3 runtime" },
      { bin = "java", desc = "Java runtime (JRE/JDK 17+ for JDTLS)" },
      { bin = "javac", desc = "Java compiler" },
      { bin = "clang", desc = "C compiler" },
      { bin = "clang++", desc = "C++ compiler" },
      { bin = "go", desc = "Go compiler" },
      { bin = "rustc", desc = "Rust compiler" },
      { bin = "cargo", desc = "Rust package manager" },
    },
  },
  {
    name = "MOBILE & CROSS-PLATFORM (iOS, Android, Flutter, React Native)",
    tools = {
      { bin = "xcodebuild", desc = "Xcode CLI build system (iOS/macOS)" },
      { bin = "swift", desc = "Swift toolchain & compiler" },
      { bin = "xcbeautify", desc = "Clean Xcode build log formatter" },
      { bin = "swiftlint", desc = "Swift static analysis linter" },
      { bin = "adb", desc = "Android Debug Bridge" },
      { bin = "emulator", desc = "Android virtual device emulator" },
      { bin = "flutter", desc = "Flutter cross-platform SDK" },
      { bin = "dart", desc = "Dart SDK runtime & analyzer" },
    },
  },
  {
    name = "DATA ENGINEERING & PYTHON TOOLS",
    tools = {
      { bin = "uv", desc = "Fast Python package manager" },
      { bin = "poetry", desc = "Poetry Python environment manager" },
      { bin = "sqlfluff", desc = "SQL linter and formatter" },
      { pymod = "pynvim", desc = "Required by molten-nvim's remote plugin host" },
      { pymod = "jupyter_client", desc = "Required by molten-nvim to talk to a kernel" },
    },
  },
  {
    name = "CONTAINERS & CLOUD / DEVOPS",
    tools = {
      { bin = "docker", desc = "Docker container engine" },
      { bin = "kubectl", desc = "Kubernetes CLI" },
      { bin = "terraform", desc = "Terraform infrastructure CLI" },
      { bin = "helm", desc = "Helm Kubernetes package manager" },
    },
  },
  {
    name = "AI ASSISTANTS & DEVELOPER TERMINAL HELPERS",
    tools = {
      { bin = "agy", desc = "Antigravity CLI (agy.nvim IDE integration)" },
      { bin = "claude", desc = "Claude Code CLI (claudecode.nvim IDE integration)" },
      { bin = "codex", desc = "OpenAI Codex CLI (codex.nvim IDE integration)" },
      { bin = "lazygit", desc = "LazyGit terminal interface" },
    },
  },
}

local function has_pymod(mod)
  if vim.fn.executable "python3" == 0 then
    return false
  end
  vim.fn.system { "python3", "-c", "import " .. mod }
  return vim.v.shell_error == 0
end

--- Standard Neovim :checkhealth integration for module "utils"
function M.check()
  local start = vim.health.start or vim.health.report_start
  local ok = vim.health.ok or vim.health.report_ok
  local warn = vim.health.warn or vim.health.report_warn

  start "External System Dependency Audit"

  for _, g in ipairs(groups) do
    start(g.name)
    for _, t in ipairs(g.tools) do
      if t.pymod then
        local name = "python3:" .. t.pymod
        if has_pymod(t.pymod) then
          ok(string.format("%s: importable (%s)", name, t.desc))
        else
          warn(string.format("%s: missing (%s)", name, t.desc), { "pip install " .. t.pymod })
        end
      else
        local path = vim.fn.exepath(t.bin)
        if path ~= "" then
          ok(string.format("%-14s -> %s (%s)", t.bin, path, t.desc))
        else
          warn(string.format("%-14s -> Not found on PATH (%s)", t.bin, t.desc))
        end
      end
    end
  end
end

--- Interactive floating modal for :CheckDeps command
function M.show_deps_window()
  local lines = { "=== Neovim External System Dependency Audit ===", "" }

  for _, g in ipairs(groups) do
    table.insert(lines, string.format("## %s", g.name))
    for _, t in ipairs(g.tools) do
      if t.pymod then
        local name = "python3:" .. t.pymod
        if has_pymod(t.pymod) then
          table.insert(lines, string.format("  ✅ OK      %-14s -> importable (%s)", name, t.desc))
        else
          table.insert(lines, string.format("  ⚠️ MISSING %-14s -> `pip install %s` (%s)", name, t.pymod, t.desc))
        end
      else
        local path = vim.fn.exepath(t.bin)
        if path ~= "" then
          table.insert(lines, string.format("  ✅ OK      %-14s -> %s (%s)", t.bin, path, t.desc))
        else
          table.insert(lines, string.format("  ⚠️ MISSING %-14s -> Not found on PATH (%s)", t.bin, t.desc))
        end
      end
    end
    table.insert(lines, "")
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    title = " System Dependencies Audit ",
    title_pos = "center",
  })
end

-- Register User Command
vim.api.nvim_create_user_command("CheckDeps", function()
  M.show_deps_window()
end, { desc = "Check external system CLI dependencies in a floating window" })

return M
