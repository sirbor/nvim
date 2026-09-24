require("nvchad.configs.lspconfig").defaults()

-- Mason is initialized by the non-lazy plugin declaration before this config.
require "mason"

vim.diagnostic.config {
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
    severity = { min = vim.diagnostic.severity.WARN },
  },
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
}

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "tailwindcss",
  "basedpyright",
  "pyright",
  "ruff",
  "rust_analyzer",
  "gopls",
  "clangd",
  "kotlin_language_server",
  "jsonls",
  "yamlls",
  "bashls",
  "dockerls",
  "docker_compose_language_service",
  "terraformls",
  "helm_ls",
  "tflint",
  "lemminx",
  "sourcekit",
  "dartls",
}

-- Binary names used by each server (Mason installs these into mason/bin).
local server_bins = {
  html = "vscode-html-language-server",
  cssls = "vscode-css-language-server",
  ts_ls = "typescript-language-server",
  tailwindcss = "tailwindcss-language-server",
  basedpyright = "basedpyright-langserver",
  pyright = "pyright-langserver",
  ruff = "ruff",
  rust_analyzer = "rust-analyzer",
  gopls = "gopls",
  clangd = "clangd",
  kotlin_language_server = "kotlin-language-server",
  jsonls = "vscode-json-language-server",
  yamlls = "yaml-language-server",
  bashls = "bash-language-server",
  dockerls = "docker-langserver",
  docker_compose_language_service = "docker-compose-langserver",
  terraformls = "terraform-ls",
  helm_ls = "helm_ls",
  tflint = "tflint",
  lemminx = "lemminx",
  sourcekit = "sourcekit-lsp",
  dartls = "dart",
}

local function is_available(name)
  local bin = server_bins[name]
  return not bin or vim.fn.executable(bin) == 1
end

local function enable_available()
  local available = vim.tbl_filter(is_available, servers)
  -- If both basedpyright and pyright are available, prefer basedpyright
  if vim.tbl_contains(available, "basedpyright") and vim.tbl_contains(available, "pyright") then
    available = vim.tbl_filter(function(s) return s ~= "pyright" end, available)
  end
  if #available > 0 then
    vim.lsp.enable(available)
  end
end

-- Python: Ruff owns lint/imports; Basedpyright/Pyright owns types
vim.lsp.config("basedpyright", {
  root_markers = { "pyproject.toml", "uv.lock", "poetry.lock", "requirements.txt", ".venv", ".git" },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",
      },
    },
  },
})

vim.lsp.config("pyright", {
  root_markers = { "pyproject.toml", "uv.lock", "poetry.lock", "requirements.txt", ".venv", ".git" },
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",
      },
    },
  },
})

vim.lsp.config("ruff", {
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", "requirements.txt", ".git" },
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
})

-- TypeScript / JavaScript
vim.lsp.config("ts_ls", {
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
})

-- C / C++: Clangd with background indexing, clang-tidy, and project root detection
vim.lsp.config("clangd", {
  root_markers = { "compile_commands.json", "compile_flags.txt", "CMakeLists.txt", "Makefile", ".git" },
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
})

-- Go: Gopls with gofumpt, staticcheck, and analyses
vim.lsp.config("gopls", {
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      gofumpt = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
})

-- Rust: Rust-analyzer with clippy
vim.lsp.config("rust_analyzer", {
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
    },
  },
})

-- Kotlin
vim.lsp.config("kotlin_language_server", {
  root_markers = { "build.gradle.kts", "build.gradle", "settings.gradle.kts", "settings.gradle", "pom.xml", ".git" },
  settings = {
    kotlin = {
      compiler = {
        jvm = { target = "17" },
      },
      hints = {
        typeHints = true,
        parameterHints = true,
        chainedHints = true,
      },
    },
  },
})

-- YAML / Kubernetes / Cloud Schemas
local ok_schemastore, schemastore = pcall(require, "schemastore")

vim.lsp.config("yamlls", {
  root_markers = { "compose.yaml", "docker-compose.yml", "Chart.yaml", ".github", ".git" },
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = ok_schemastore and schemastore.yaml.schemas {
        extra = {
          {
            description = "Kubernetes YAML",
            fileMatch = { "*.k8s.yaml", "*.k8s.yml" },
            name = "k8s.yaml",
            url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0-standalone-strict/all.json",
          },
        },
      } or {
        kubernetes = "*.k8s.yaml",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/docker-compose"] = "docker-compose*.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "compose*.{yml,yaml}",
      },
    },
  },
})

-- Terraform / OpenTofu
vim.lsp.config("terraformls", {
  root_markers = { "main.tf", "*.tf", ".terraform", "terraform.tfstate", ".git" },
  filetypes = { "terraform", "terraform-vars", "hcl" },
})

-- JSON
vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = ok_schemastore and schemastore.json.schemas() or nil,
      validate = { enable = true },
    },
  },
})

-- XML / Android Layouts & Manifests
vim.lsp.config("lemminx", {
  root_markers = { "pom.xml", "AndroidManifest.xml", "build.gradle", "build.gradle.kts", ".git" },
  filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
})

-- Swift / iOS / macOS: SourceKit-LSP
vim.lsp.config("sourcekit", {
  cmd = { "sourcekit-lsp" },
  filetypes = { "swift", "objc", "objcpp" },
  root_markers = { "Package.swift", "*.xcodeproj", "*.xcworkspace", "compile_commands.json", ".git" },
})

-- Dart / Flutter (fallback if not managed directly by flutter-tools)
vim.lsp.config("dartls", {
  root_markers = { "pubspec.yaml", ".git" },
})

enable_available()

-- After Mason finishes installing tools, enable newly available servers
vim.api.nvim_create_autocmd("User", {
  pattern = "MasonToolsUpdateCompleted",
  callback = function()
    vim.schedule(enable_available)
  end,
})
