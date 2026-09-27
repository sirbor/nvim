# Production-Grade Neovim / NvChad Configuration

An audited, hardened, high-performance Neovim configuration built on **NvChad v2.5** and **lazy.nvim**, tailored for serious software engineering, backend systems, data engineering, cloud/DevOps, and mobile platforms (**Native iOS/macOS**, **Native Android**, **Flutter**, **React Native / Expo**, and **Kotlin Multiplatform**).

---

## 1. System Requirements & External Dependencies

Run `:CheckDeps` inside Neovim at any time to audit your system dependencies.

| Dependency | Required For | Recommended Source | Category |
| :--- | :--- | :--- | :--- |
| **Neovim 0.11+ / 0.12+** | Native `vim.lsp.config` & declarative LSP runtime | `brew install neovim` / Nightly | Core |
| **Git** (>= 2.40) | Lazy plugin manager, Fugitive, Gitsigns, Diffview, Worktree | Xcode CLI / `brew install git` | Core |
| **Ripgrep** (`rg`) | `fzf-lua` live grep and code search | `brew install ripgrep` | Core |
| **Fd** (`fd`) | Fast file discovery in `fzf-lua` | `brew install fd` | Core |
| **Fzf** | Terminal fuzzy finder integration | `brew install fzf` | Core |
| **Node.js & npm** (>= 18) | LSPs (`ts_ls`, `pyright`, `yamlls`, `bashls`, `dockerls`, React Native) | `brew install node` | Language |
| **Python 3** & `pip` / `uv` | Python LSP, pytest, Jupyter, PySpark | `brew install python` / `uv` | Language |
| **`pynvim` + `jupyter_client`** (pip) | Molten's remote-plugin host & kernel connection (`<leader>M*`) | `pip install pynvim jupyter_client ipykernel` | Data Eng / Optional |
| **Java JDK** (>= 17) | Eclipse JDTLS, Android SDK, Maven, Gradle, Spring Boot | `brew install openjdk@21` | Language / Mobile |
| **C / C++ Compiler** | `clangd`, treesitter parser compilation | `xcode-select --install` | Language |
| **Go** (>= 1.20) | `gopls`, Delve debugger | `brew install go` | Language |
| **Rust / Cargo** | `rust-analyzer`, CodeLLDB | `rustup` | Language |
| **Xcode CLI Tools** | iOS/macOS compilation, `sourcekit-lsp`, Simulators | `xcode-select --install` | Mobile / iOS |
| **Flutter SDK** | Flutter cross-platform development (`dartls`, DevTools) | `brew install --cask flutter` | Mobile / Flutter |
| **Android SDK / ADB** | Android native APK builds, logcat streaming, Emulators | `brew install --cask android-commandlinetools` | Mobile / Android |
| **LazyGit** | Full-screen interactive terminal Git UI | `brew install lazygit` | Optional / GUI |
| **Claude Code CLI** (`claude`) | `claudecode.nvim` IDE integration (`<leader>l*`) | `curl https://downloads.anthropic.com/claude-code-install.sh \| bash` | Optional / AI |
| **Antigravity CLI** (`agy`) | `agy` / `antigravity-cli.nvim` IDE integration (`<leader>y*`) | `https://antigravity.google` / `brew` | Optional / AI |
| **OpenAI Codex CLI** (`codex`) | `codex.nvim` IDE integration (`<leader>x*` / `<leader>lx`) | `brew install --cask codex` / `npm i -g @openai/codex` | Optional / AI |
| **GitHub Copilot** | Inline completion (`copilot.lua`) & Copilot Chat (`<leader>k*`) | `:Copilot auth` (Active GitHub Copilot subscription) | Optional / AI |

---

## 2. Directory Architecture

```
~/.config/nvim/
├── .stylua.toml             # StyLua formatting standard
├── init.lua                 # Bootstrap lazy.nvim, Base46 theme, options, autocmds, mappings
├── lazy-lock.json           # Deterministic pinned plugin lockfile
├── README.md                # Comprehensive documentation
├── ftplugin/
│   └── java.lua             # Isolated Eclipse JDTLS workspace & Lombok/Spring Boot setup
└── lua/
    ├── autocmds.lua         # Smart autocmds (cursor restore, q-close, dir creation, resizing)
    ├── chadrc.lua           # NvChad overrides (theme, minimal statusline)
    ├── mappings.lua         # Core editing, search, LSP, Git, and window keymaps
    ├── options.lua          # Editor options (2-space indent, UFO folds, clipboard)
    ├── utils/
    │   ├── project.lua      # Root-marker project detection & smart runner
    │   ├── health.lua       # External CLI system dependency checker (:CheckDeps / :checkhealth utils)
    │   ├── notebook.lua     # REPL-backed `# %%` cell execution (IPython terminal)
    │   ├── agy.lua          # Antigravity CLI integration (terminal, context, models, modes)
    │   └── codex.lua        # OpenAI Codex CLI integration (terminal, context, models, review)
    ├── configs/
    │   ├── conform.lua      # Multi-language formatting matrix & format-on-save
    │   ├── lazy.lua         # Lazy.nvim setup & disabled runtime plugins
    │   └── lspconfig.lua    # Neovim 0.11 native LSP configs & Mason auto-enable
    └── plugins/
        ├── ai.lua           # Claude Code, AGY, Copilot Chat, & OpenAI Codex CLI
        ├── dap.lua          # nvim-dap, dap-ui, virtual text, venv-selector, debuggers
        ├── editor.lua       # surround, substitute, dial, ufo, spectre, copilot, flash
        ├── formatting.lua   # conform.nvim & safe nvim-lint orchestration
        ├── git.lua          # lazygit, diffview, fugitive
        ├── github.lua       # octo.nvim GitHub PRs & Issues (fzf-lua backend)
        ├── init.lua         # which-key groups, gitsigns, mason UI, telescope fallback
        ├── lsp.lua          # nvim-lspconfig, mason-tool-installer (44 tools), treesitter
        ├── mobile.lua       # xcodebuild.nvim (iOS), flutter-tools.nvim (Flutter), logcat.nvim (Android)
        ├── navigation.lua   # fzf-lua, oil.nvim, harpoon2
        ├── tasks.lua        # overseer.nvim (Tasks), treesj, dropbar, render-markdown, git-worktree, coverage
        ├── testing.lua      # neotest (python, go, jest, rust)
        ├── tooling.lua      # kulala.nvim (REST), dadbod (SQL), jupytext.nvim, molten-nvim (Jupyter kernel)
        └── ui.lua           # noice.nvim, nvim-notify, zen-mode, twilight, persistence
```

---

## 3. Project-Aware Architecture & Environment Detection

Neovim dynamically detects the project root directory and project type using established root markers:
* **iOS / macOS**: `Package.swift`, `*.xcodeproj`, `*.xcworkspace`
* **Flutter / Dart**: `pubspec.yaml`
* **Android Native**: `AndroidManifest.xml`, `app/build.gradle`, `app/build.gradle.kts`
* **Kotlin Multiplatform (KMP)**: `composeApp/build.gradle.kts`, `shared/build.gradle.kts`
* **React Native / Expo**: `metro.config.js`, `app.json`, `package.json`
* **Java / Spring Boot**: `pom.xml`, `build.gradle`, `build.gradle.kts`, `settings.gradle`
* **Python / Data Eng**: `pyproject.toml`, `uv.lock`, `poetry.lock`, `requirements.txt`, `.venv`
* **Node / TS / Deno**: `package.json`, `pnpm-lock.yaml`, `yarn.lock`, `bun.lockb`, `deno.json`
* **C / C++**: `CMakeLists.txt`, `Makefile`, `compile_commands.json`
* **Rust / Go**: `Cargo.toml`, `go.mod`
* **dbt / Data Pipelines**: `dbt_project.yml`
* **PHP / Laravel**: `artisan`, `composer.json`
* **Cloud & Containers**: `main.tf`, `*.tf`, `Dockerfile`, `compose.yaml`, `Taskfile.yml`

When executing project runs or terminal commands (`<leader>rr`, `<leader>rb`, `<leader>rt`), Neovim automatically runs within the detected project root directory.

---

## 4. Language & Tooling Matrix

| Language / Domain | LSP Server(s) | Formatter (`conform`) | Linter (`nvim-lint`) | Test Adapter | DAP Debugger |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **iOS / Swift / macOS** | `sourcekit-lsp` | `swift-format` / `swiftformat` | `swiftlint` | `xcodebuild.nvim` (XCTest) | `codelldb` / Native LLDB |
| **Flutter / Dart** | `dartls` (`flutter-tools.nvim`) | `dart format` | `dart analyze` | `flutter test` | Dart DAP (Built-in) |
| **Android Native (Kotlin/Java)** | `kotlin_language_server`, `jdtls`, `lemminx` | `ktlint`, `google-java-format`, `xmlformatter` | `ktlint` | Gradle / JUnit | `java-debug-adapter`, `codelldb` |
| **React Native / Expo** | `ts_ls`, `tailwindcss`, `jsonls` | `prettierd` / `prettier` | `eslint_d` | `neotest-jest` / `npm test` | `js-debug-adapter` |
| **Web (Vue 3, TS, HTML, CSS)** | `ts_ls` (hybrid), `vue_ls`, `tailwindcss`, `emmet_language_server` | `oxfmt` / `prettierd` / `prettier` (dynamic) | `oxlint` / `eslint_d` | `neotest-jest` / `npm test` | `js-debug-adapter` |
| **PHP & Laravel Blade** | `intelephense` | `php-cs-fixer` / `pint`, `blade-formatter` | `intelephense` (LSP) | Pest / PHPUnit | - |
| **Python / Data Eng** | `basedpyright` / `ruff` | `ruff_organize_imports`, `ruff_format` | `ruff` (LSP) | `neotest-python` (pytest) | `debugpy` |
| **Java / Spring Boot** | `jdtls` (via `ftplugin/java.lua`) | `google-java-format` | Native JDTLS | JDTLS / JUnit | `java-debug-adapter` |
| **C / C++** | `clangd` (with clang-tidy & IWYU) | `clang-format` | `clangd` (LSP) | - | `codelldb` |
| **Go** | `gopls` (`gofumpt`, staticcheck) | `goimports`, `gofumpt` | `golangci-lint` | `neotest-go` | `delve` |
| **Rust** | `rust_analyzer` (clippy) | `rustfmt` | `rust_analyzer` (LSP) | `neotest-rust` | `codelldb` |
| **SQL / Databases** | `vim-dadbod-completion` | `sqlfluff` / `sql_formatter` | `sqlfluff` | - | - |
| **Terraform / HCL** | `terraformls`, `tflint` | `terraform_fmt` | `tflint` | - | - |
| **Docker & K8s** | `dockerls`, `docker_compose_language_service`, `yamlls`, `helm_ls` | `prettierd` / `prettier` | `hadolint`, `yamllint` | - | - |
| **Shell / Bash** | `bashls` | `shfmt` | `shellcheck` | - | - |

> **Not everything above is Mason-managed.** `mason-tool-installer` (`lua/plugins/lsp.lua`)
> auto-installs the LSPs, formatters, linters, and debug adapters that Mason actually
> packages. `swift-format`/`swiftformat`, `dart format`, `swiftlint`, and `sql_formatter`
> are **not** in that list — they're expected to come from the Xcode toolchain, the
> Flutter SDK, and a global npm install respectively (see the dependency table in
> §1). If one of those is missing, format-on-save for that filetype silently no-ops.

> **Why `sqlfluff` instead of a dedicated `sqlls` completion server:** `sqlfluff`
> natively supports per-project dialect selection (`dialect = postgres|bigquery|snowflake|...`
> in a project's `.sqlfluff` file) — exactly the multi-dialect need called out for this
> stack — where `sql-language-server` doesn't cover those dialects meaningfully.
> Schema-aware column/table completion instead comes from `vim-dadbod-completion`
> (§ Database & Query Client below), which completes from a live DB connection rather
> than static schema files, so it works regardless of dialect.

> **dbt models (SQL + Jinja) — known limitation.** `jinja` / `jinja_inline` Treesitter
> parsers are installed (`lua/plugins/lsp.lua`) and give full highlighting to standalone
> `*.jinja` files. They do **not** highlight the `{{ }}` / `{% %}` tags inside `.sql`
> dbt models, because `tree-sitter-sql`'s own grammar has no injection query for
> embedded Jinja — Neovim ships no ready-made "SQL with Jinja injected" combination, and
> hand-rolling one against `tree-sitter-sql`'s error-node behavior wasn't something I
> could verify would actually work reliably, so it isn't included. Jinja tags in `.sql`
> files render as plain SQL text (readable, just not specially colored); `sqlfluff`'s
> jinja templater still lints these files correctly regardless.

---

## 5. Complete Keybindings Reference

### Core Editing & Navigation
* `;` — Command line (`:`)
* `jk` (insert mode) — Leave insert mode
* `<Esc>` — Clear search highlight
* `n` / `N` — Next / previous search match (centered)
* `<C-d>` / `<C-u>` — Half page down / up (centered)
* `j` / `k` — Move by display line when wrap is on (`gj` / `gk`)
* `J` (normal) — Join lines, cursor stays put
* `J` / `K` (visual) — Move selected lines down / up
* `<`/`>` (visual) — Indent left / right, reselect
* `p` (visual) — Paste without overwriting the unnamed register
* `<C-h/j/k/l>` — Move focus between windows
* `<leader>wv` / `<leader>ws` — Split window vertically / horizontally
* `<leader>we` / `<leader>wo` / `<leader>wx` — Equalize splits / keep only this one / close split
* `<leader>e` — Toggle NvimTree file explorer
* `-` / `<leader>o` — Open parent directory / Oil file manager buffer
* `<leader>oF` — Oil file manager (floating window)
* `<leader>b` — Buffers group: `<leader>bb` list, `<leader>bd` close, `<leader>bn`/`<leader>bp` next/prev
* `<leader>t` — Terminal group: `<leader>tt` floating, `<leader>th` horizontal, `<leader>tv` vertical, `<leader>tg` LazyGit
* Terminal mode: `<Esc><Esc>` exit to normal, `<C-h/j/k/l>` move to another window

### Find (`<leader>f` via FzfLua)
* `<leader>ff` / `<leader>fp` — Find files
* `<leader>fa` — Find files from home directory
* `<leader>fP` — Find files including hidden / git-ignored
* `<leader>fg` — Live grep
* `<leader>fw` — Grep word under cursor
* `<leader>fb` — Buffers
* `<leader>fo` — Recently opened files
* `<leader>fh` — Help tags
* `<leader>fk` — Keymaps
* `<leader>fc` — Commands
* `<leader>fr` — Resume last picker
* `<leader>fz` — Lines in current buffer
* `<leader>fs` / `<leader>fS` — LSP document symbols / workspace symbols
* `<leader>fd` — Document diagnostics
* `<leader>fm` — Marks
* `<leader>ft` — TODO comments (via Trouble)

### Git (`<leader>g`)
* `<leader>gg` / `<leader>gf` — LazyGit / LazyGit for current file
* `<leader>gd` — Diffview open
* `<leader>gX` — Diffview close
* `<leader>gh` / `<leader>gH` — File history / branch history (Diffview)
* `<leader>gG` — Fugitive `:Git` status
* `<leader>gc` — Commit browser (FzfLua)
* `<leader>gs` — Git status (FzfLua)
* `<leader>gi` / `<leader>gp` / `<leader>gr` — GitHub issues / pull requests / review PR (`octo.nvim`)
* `<leader>gw` / `<leader>gW` — Create / switch Git worktree

### LSP, Diagnostics & Formatting (`<leader>c`, `[d`/`]d`)
* `[d` / `]d` — Previous / next diagnostic (floating)
* `<leader>cd` — Line diagnostics (floating)
* `<leader>ds` — Buffer diagnostics (`Trouble`)
* `<leader>cf` — Format buffer or visual selection (`conform.nvim`)
* `<leader>cL` — Trigger asynchronous linting for current file (`nvim-lint`)

### iOS & Apple Development (`<leader>i` or `<leader>X`)
* `<leader>ip` / `<leader>Xp` — Project / Scheme / Target picker (`xcodebuild.nvim`)
* `<leader>ib` / `<leader>Xb` — Build iOS / macOS project
* `<leader>ir` / `<leader>Xr` — Build and Run on simulator or physical device
* `<leader>it` / `<leader>Xt` — Run all XCTest unit / UI tests
* `<leader>iT` / `<leader>XT` — Run current test class
* `<leader>id` / `<leader>Xd` — Select destination simulator / physical device
* `<leader>ic` / `<leader>Xc` — Toggle inline code coverage
* `<leader>il` / `<leader>Xl` — Toggle Xcode build / runtime logs
* `<leader>iq` / `<leader>Xq` — Cancel current Xcode build action

### Flutter & Dart Development (`<leader>F`)
* `<leader>Fc` — Launch Flutter application (`flutter run`)
* `<leader>Fr` — Trigger Flutter **Hot Reload**
* `<leader>FR` — Trigger Flutter **Hot Restart**
* `<leader>Fd` — Select active Flutter target device
* `<leader>Fe` — Launch iOS Simulator or Android Emulator
* `<leader>Fl` — Open Flutter DevTools in browser
* `<leader>Ft` — Toggle interactive Flutter Widget Tree outline
* `<leader>FL` — Toggle Flutter real-time development logs
* `<leader>Fq` — Terminate running Flutter application

### Android Development (`<leader>A`)
* `<leader>Al` — Open real-time `adb logcat` stream buffer (`logcat.nvim`)
* `<leader>Ac` — Clear Android Logcat output
* `<leader>Ap` — Pause Logcat streaming
* `<leader>Ar` — Resume Logcat streaming

### Tasks & Process Management (`<leader>O` via Overseer)
* `<leader>Oo` — Toggle Overseer task manager panel
* `<leader>Or` — Run task (auto-detects npm, Makefile, Cargo, Gradle, Docker, etc.)
* `<leader>Ob` — Run build task
* `<leader>Oq` — Quick action on selected task
* `<leader>Oi` — Overseer runner info

### Code Coverage (`<leader>C`)
* `<leader>Ct` — Toggle inline coverage sign indicators
* `<leader>Cs` — Open test coverage summary report
* `<leader>Cl` — Load coverage report (`lcov.info`, `.coverage`, `cobertura.xml`)
* `<leader>Cc` — Clear coverage highlights

### Git Worktrees (`<leader>gw` / `<leader>gW`)
* `<leader>gw` — Create and checkout new Git worktree
* `<leader>gW` — Switch between existing Git worktrees

### Code Refactoring & Block Manipulation (`<leader>c`)
* `<leader>cj` — Toggle split / join code block (`treesj`)
* `<leader>cS` — Split array, object, or argument list into multi-line (`treesj`)
* `<leader>cJ` — Join multi-line block into single line (`treesj`)
* `<leader>cf` — Format buffer or visual selection (`conform.nvim`)
* `<leader>ca` — Rich floating code actions (`actions-preview.nvim`)
* `<leader>cr` — Incremental symbol rename (`inc-rename.nvim`)
* `<leader>co` — Symbol outline sidebar (`aerial.nvim`) — **in Java buffers this is overridden to "Organize imports"** (`ftplugin/java.lua`); use `<leader>cO` for the outline there instead
* `<leader>cd` — Floating line diagnostics
* `<leader>cs` — Symbols outline panel (`Trouble`)
* `<leader>cl` — LSP references panel (`Trouble`)
* `<leader>cg` / `<leader>cF` / `<leader>cc` / `<leader>ct` — Generate docstrings: nearest / function / class / type (`neogen`)
* `<leader>cn` / `<leader>cp` — Swap function parameter with the next / previous one (Treesitter)

### Python & Data Engineering (`<leader>p`)
* `<leader>pv` — Select Python virtualenv (`venv-selector.nvim`; uv, poetry, venv, pyenv, conda)
* `<leader>pr` — Run current Python file (non-interactive, in a split)
* `<leader>pt` — Run Python tests for current file (`neotest`)
* `<leader>pd` — Debug nearest Python test method (DAP)
* `<leader>pC` — Debug nearest Python test class (DAP)
* `<leader>pi` — Toggle floating IPython REPL

### Jupyter & Notebook / Code Cells (`<leader>j`)
Cell execution is REPL-backed (a persistent `ipython` terminal), not a real Jupyter
kernel connection — there's no `jupyter_client` / kernel protocol involved, just
`%run -i <tmpfile>` sent to a shared IPython session so state persists between cells.
* `<leader>jc` — Insert a `# %%` cell marker
* `]j` / `[j` — Jump to next / previous cell marker
* `<leader>jr` — Run the `# %%` cell under the cursor in the REPL
* `<leader>jR` — Run the whole file in the REPL
* `<leader>ji` — Toggle the IPython REPL window
* `<leader>jx` — Interrupt whatever is running in the REPL (Ctrl-C)
* `<leader>jk` — Restart the IPython session (exit + relaunch, clears state)
* `<leader>jo` — Toggle the separate non-REPL script runner output (from `<leader>pr`)

### Claude Code IDE Integration (`<leader>l`)
`claudecode.nvim` runs a WebSocket/MCP server that a `claude` CLI session auto-discovers,
giving it visibility into open buffers, your selection, and diagnostics, and letting it
apply edits back as reviewable diffs instead of blind file writes. Requires the `claude`
CLI on PATH (see §1; `:CheckDeps` reports on it). Upstream's default keys all live under
`<leader>a`, which in this config is Harpoon's "add file" — using the same prefix here
would force a `timeoutlen` wait on every Harpoon-add press, so these are remapped onto
`<leader>l` instead.
* `<leader>lc` — Toggle the Claude Code terminal
* `<leader>lf` — Focus the Claude Code terminal
* `<leader>lr` — Resume the most recent session (`claude --resume`)
* `<leader>lC` — Continue the last session (`claude --continue`)
* `<leader>lm` — Select model
* `<leader>lb` — Add the current buffer as context
* `<leader>ls` — Send the visual selection to Claude
* `<leader>la` / `<leader>ln` — Accept / deny the diff under review
* `<leader>lX` — Close all open diffs

### Antigravity CLI (`agy`) IDE Integration (`<leader>y` / `<leader>ly`)
`antigravity-cli.nvim` and `lua/utils/agy.lua` run a dedicated, persistent session with Google
Antigravity (`agy`), giving you an in-editor pair programmer terminal with context injection,
model selection, prompt dialogs, and reasoning effort controls. Requires the `agy` CLI on PATH
(see §1; `:CheckDeps` reports on it). Keys live under `<leader>y` ("antigravity / agy"), with
fast toggle aliases under `<leader>l` ("claude / llm").
* `<leader>ya` / `<leader>yc` (or `<leader>ly`) — Toggle Antigravity CLI terminal
* `<leader>yf` — Focus the active Antigravity terminal
* `<leader>yC` (or `<leader>lY`) — Continue the last conversation (`agy --continue`)
* `<leader>yr` — Resume previous conversation
* `<leader>yp` — Interactive prompt dialog (`agy -i "<prompt>"`)
* `<leader>ym` — Select Antigravity model (Gemini 3.8 Flash, Gemini 3.8 Pro, Flash-Lite, Claude)
* `<leader>ye` — Select reasoning effort (`low`, `medium`, `high`)
* `<leader>yM` — Toggle execution mode (`plan` vs `accept-edits`)
* `<leader>yb` — Add the current buffer as context (`@filename`)
* `<leader>ys` (visual mode) — Send selected lines to Antigravity as context reference

### GitHub Copilot Chat (`<leader>k` / `<leader>lk`)
`CopilotChat.nvim` provides an interactive AI chat interface directly inside Neovim, using
the authenticated GitHub Copilot API (`:Copilot auth` via `copilot.lua`). It features model
switching (GPT-4o, Claude 3.5 Sonnet, o1), buffer/selection context injection, automated code
reviews, refactoring, diagnostic fixing, test generation, and diff reviews. Keys live under
`<leader>k` ("copilot / chat"), with a fast toggle alias under `<leader>l` ("claude / llm").
* `<leader>kc` / `<leader>ka` (or `<leader>lk`) — Toggle Copilot Chat split (vertical, right side)
* `<leader>kf` — Focus active Copilot Chat window
* `<leader>kr` — Reset chat history / start fresh conversation
* `<leader>kp` — Interactive prompt dialog (input prompt and ask Copilot)
* `<leader>kP` — Prompt actions menu (Explain, Review, Fix, Optimize, Tests, Commit)
* `<leader>km` — Select Copilot model (GPT-4o, Claude 3.5 Sonnet, o1-preview, etc.)
* `<leader>kb` — Ask Copilot with current buffer as context
* `<leader>ks` (visual mode) — Ask Copilot with visual selection as context
* `<leader>ke` — Explain code under cursor or visual selection
* `<leader>kR` — Review code for improvements and security issues
* `<leader>kF` — Fix bugs and issues in selected code
* `<leader>kt` — Generate unit tests for selected code
* `<leader>kd` — Fix diagnostic / LSP error under cursor
* `<leader>kg` — Generate conventional git commit message for staged changes

### OpenAI Codex CLI (`codex`) IDE Integration (`<leader>x` / `<leader>lx`)
`lua/utils/codex.lua` and `codex.nvim` run a persistent, dedicated terminal session with the
OpenAI Codex CLI (`codex`), providing interactive pair programming, session continuation, model
selection (o3, o3-mini, o1, GPT-4o), sandbox policy controls, automated non-interactive code
reviews, diff application (`codex apply`), and buffer/selection context injection. Requires the
`codex` CLI on PATH (see §1; `:CheckDeps` reports on it). Keys live under `<leader>x`
("codex / trouble"), with fast toggle aliases under `<leader>l` ("claude / llm").
* `<leader>xc` / `<leader>xa` (or `<leader>lx`, `<leader>lo`) — Toggle Codex CLI terminal
* `<leader>xf` — Focus the active Codex terminal
* `<leader>xr` (or `<leader>lO`) — Resume the most recent session (`codex resume --last`)
* `<leader>xR` — Open interactive session resume picker (`codex resume`)
* `<leader>xp` — Interactive prompt dialog (prompt user and launch `codex "<prompt>"`)
* `<leader>xm` — Select Codex model (`o3`, `o3-mini`, `o1`, `gpt-4o`, `gpt-4.5-preview`)
* `<leader>xw` — Select sandbox policy (`workspace-write`, `read-only`, `danger-full-access`)
* `<leader>xA` — Select human approval policy (`on-request`, `never`)
* `<leader>xS` — Toggle live web search (`--search`)
* `<leader>xv` — Review uncommitted git changes (`codex review --uncommitted`)
* `<leader>xd` — Apply task diff to working tree (`codex apply <TASK_ID>`)
* `<leader>xb` — Add current buffer to context (`@filename`)
* `<leader>xs` (visual mode) — Send selected lines to Codex as context reference

### Molten / Jupyter Kernel (`<leader>M`)
The real thing, unlike the REPL flow above: `molten-nvim` talks to an actual Jupyter
kernel (`jupyter_client`) and renders output (dataframes, tables, text) inline as
virtual text under the evaluated cell. Requires `pynvim` + `jupyter_client` (see §1) —
`:CheckDeps` reports whether they're importable. Plots/images are **not** wired up
(would need `image.nvim` + a Kitty-graphics-capable terminal, not installed here);
text and tabular `repr()` output work out of the box.
* `<leader>Mi` — Initialize a kernel for the current buffer (prompts for kernel name)
* `<leader>Ml` — Evaluate the current line
* `<leader>Mv` — Evaluate the visual selection
* `<leader>Me` — Evaluate operator (e.g. `<leader>Meip` for a paragraph)
* `<leader>Mc` — Re-evaluate the cell under the cursor
* `<leader>Mo` / `<leader>Mh` — Show / hide the output window for the cell under the cursor
* `<leader>Md` — Delete the cell/output under the cursor
* `<leader>Mx` — Interrupt the kernel
* `<leader>Mr` — Restart the kernel

### Maven / Gradle / Spring Boot (`<leader>m`)
* `<leader>mr` — Run (`mvnw`/`mvn spring-boot:run` or `gradlew`/`gradle bootRun`, auto-detected)
* `<leader>mb` — Build (`mvnw`/`mvn clean compile` or `gradlew`/`gradle build`)
* `<leader>mt` — Test (`mvnw`/`mvn test` or `gradlew`/`gradle test`)

### Project Commands (`<leader>r`)
* `<leader>rr` — Run project (auto-detects Flutter, iOS Swift, Android, Spring Boot, Python, Node, C++, Rust, Go)
* `<leader>rb` — Build project (auto-detects Xcode, Gradle, Maven, Cargo, CMake, npm, Flutter)
* `<leader>rt` — Test project (auto-detects pytest, Maven test, Jest, Cargo test, Flutter test)
* `<leader>rd` — Run dbt / data pipeline (`dbt run || pytest`)
* `<leader>rc` — Docker compose up (`docker compose up -d`)

### Debugging (`<leader>d` via DAP & Persistent Breakpoints)
* `<leader>db` / `<leader>dB` — Toggle persistent breakpoint / Conditional breakpoint (`persistent-breakpoints.nvim`)
* `<leader>dD` — Clear all breakpoints in buffer (`persistent-breakpoints.nvim`)
* `<leader>dc` / `<leader>dC` — Continue / Run to cursor
* `<leader>do` / `<leader>dn` — Step over
* `<leader>di` / `<leader>dO` — Step into / Step out
* `<leader>du` — Toggle DAP visual IDE UI
* `<leader>dr` — Open DAP REPL
* `<leader>dl` — Re-run last debug session
* `<leader>dx` / `<leader>dt` — Terminate debug session
* `<leader>dp` / `<leader>dP` — Insert plain debug print statement below / above (`debugprint.nvim`)
* `<leader>dv` / `<leader>dV` — Insert variable debug print statement below / above (`debugprint.nvim`)
* `<leader>dK` — Delete all generated debug print statements from buffer (`debugprint.nvim`)

### Dependencies & Packages (`<leader>n`)
* `<leader>nt` / `<leader>nr` — Toggle virtual text / reload Cargo crates (`crates.nvim`)
* `<leader>nu` / `<leader>na` — Update single crate / update all crates in Cargo.toml (`crates.nvim`)
* `<leader>nv` / `<leader>nf` / `<leader>nd` — Show crate versions / features / dependencies popup (`crates.nvim`)
* `<leader>nH` / `<leader>nD` — Open crate homepage / docs.rs documentation (`crates.nvim`)
* `<leader>ns` / `<leader>nh` — Show / hide package dependency versions in package.json (`package-info.nvim`)
* `<leader>nu` / `<leader>nd` — Update / delete package.json dependency (`package-info.nvim`)
* `<leader>ni` — Install new dependency into package.json (`package-info.nvim`)

### UI Toggles (`<leader>u`)
* `<leader>um` — Toggle rendered markdown view (`render-markdown.nvim`)
* `<leader>uM` — Toggle live Markdown browser preview (`markdown-preview.nvim`)
* `<leader>uv` — Toggle CSV / TSV aligned table view (`csvview.nvim`)
* `<leader>ui` — Toggle inline diagnostics under cursor (`tiny-inline-diagnostic.nvim`)
* `<leader>uh` — Toggle native LSP Inlay Hints
* `<leader>uf` — Toggle format-on-save globally
* `<leader>uw` — Toggle line wrap
* `<leader>ul` — Toggle invisible characters (`listchars`)
* `<leader>us` — Toggle spell check
* `<leader>un` / `<leader>ur` — Toggle line numbers / Relative numbers
* `<leader>uC` — Toggle colorizer highlights
* `<leader>uc` — Toggle sticky Treesitter context
* `<leader>ud` — Toggle Undotree
* `<leader>uN` — Dismiss active notifications

### General Editing & Utility Plugins
* `w` / `e` / `b` / `ge` — CamelCase and snake_case aware subword motions (`nvim-spider`)
* `y` / `p` / `P` / `gp` / `gP` — Advanced yank and put with clipboard ring (`yanky.nvim`)
* `<C-p>` / `<C-n>` (or `[y`/`]y`) — Cycle through previous yanks after pasting (`yanky.nvim`)
* `<leader>fy` — Search clipboard yank history via FzfLua (`yanky.nvim`)
* `m,` / `m]` / `m[` / `m:` — Set next mark, jump next, jump previous, preview mark in gutter (`marks.nvim`)
* `n` / `N` / `*` / `#` — Interactive match count lens and centered jumping (`hlslens`)
* `s` / `S` — Flash jump / Flash Treesitter jump (normal, visual, operator-pending)
* `r` (operator-pending) / `R` (operator-pending, visual) — Flash remote / Flash Treesitter search
* `<C-s>` (command-line) — Toggle Flash in search
* `<leader>xx` / `<leader>xX` — Toggle all diagnostics / current-buffer diagnostics (`Trouble`)
* `<leader>xL` / `<leader>xQ` — Toggle location list / quickfix list (`Trouble`)
* `<leader>a` — Harpoon: add current file
* `<leader>he` — Harpoon: toggle quick menu
* `<leader>1` – `<leader>4` — Harpoon: jump to file 1–4
* `<leader>hn` / `<leader>hN` — Harpoon: next / previous file
* `<leader>sg` / `<leader>sR` — Live workspace search & replace in buffer (`grug-far.nvim`)
* `<leader>sW` / `<leader>sF` — Search & replace current word / current file (`grug-far.nvim`)
* `<leader>sr` / `<leader>sw` / `<leader>sp` — Search & replace panel (`Spectre`)
* `<leader>sn` — Noice message history
* `<leader>gy` / `<leader>gY` — Copy shareable git permalink / open permalink in browser (`gitlinker.nvim`)
* `<leader>ci` — Paste image from clipboard into Markdown (`img-clip.nvim`)
* `<leader>ch` / `<leader>cM` / `<leader>cT` / `<leader>cS` — Clangd type hierarchy / memory / AST / switch header (`clangd_extensions.nvim`)
* `<C-a>` / `<C-x>` — Increment / decrement number, date, boolean, `&&`/`||`, etc. under cursor (`dial.nvim`); `g<C-a>` / `g<C-x>` target the next match on the line
* `gs` / `gss` — Substitute operator / substitute current line (`substitute.nvim`)
* `<M-n>` — Add cursor at next occurrence of word under cursor (`vim-visual-multi`)
* `<leader>qs` / `<leader>ql` — Restore session for cwd / restore last session (`persistence.nvim`)
* `<leader>qd` — Stop auto-saving the session
* `<leader>zz` — Zen Mode
* `<leader>tw` — Twilight (dim code outside current scope)
* `]t` / `[t` — Jump to next / previous TODO comment
* `]h` / `[h` — Jump to next / previous git hunk (`gitsigns`)
* `<leader>gS` / `<leader>gR` / `<leader>gP` — Stage / reset / preview git hunk
* `<leader>gb` / `<leader>gB` — Blame current line / toggle inline blame
* `<leader>D` / `<leader>Db` — Toggle Database UI (`vim-dadbod-ui`)
* `<leader>Dr` — Execute SQL query under cursor or visual selection
* `<leader>Dt` / `<leader>Ds` — Find table buffer / add DB connection
* `<leader>R…` — HTTP request runner keymaps, prefixed `<leader>R` (`kulala.nvim`, `.http`/`.rest` files)
* Text objects `af`/`if`, `ac`/`ic`, `aa`/`ia`, `al`/`il`, `ai`/`ii` — function / class / parameter / loop / conditional (Treesitter)
* `]m`/`[m`, `]M`/`[M`, `]c`/`[c`, `]C`/`[C` — Jump to next/previous function or class start/end (Treesitter)
* `zR`/`zM`/`zr`/`zm`/`zp` — Open/close all folds, open/close folds by kind, peek folded lines (`nvim-ufo`)
* `<C-space>` / `<BS>` (in a selection) — Expand / shrink Treesitter incremental selection
