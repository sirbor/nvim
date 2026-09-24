local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    vue = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    scss = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    jsonc = { "prettierd", "prettier", stop_after_first = true },
    yaml = { "prettierd", "prettier", stop_after_first = true },
    graphql = { "prettierd", "prettier", stop_after_first = true },
    python = { "ruff_organize_imports", "ruff_format" },
    java = { "google-java-format" },
    kotlin = { "ktlint" },
    rust = { "rustfmt" },
    go = { "goimports", "gofumpt" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
    hcl = { "terraform_fmt" },
    sql = { "sqlfluff", "sql_formatter", stop_after_first = true },
    mysql = { "sqlfluff", "sql_formatter", stop_after_first = true },
    plsql = { "sqlfluff", "sql_formatter", stop_after_first = true },
    toml = { "prettierd", "prettier", stop_after_first = true },
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
    swift = { "swift_format", "swiftformat", stop_after_first = true },
    dart = { "dart_format" },
    xml = { "xmlformatter", "prettierd", "prettier", stop_after_first = true },
  },

  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable then
      return
    end

    return {
      timeout_ms = 1000,
      lsp_fallback = true,
      notify_on_error = true,
    }
  end,
}

return options
