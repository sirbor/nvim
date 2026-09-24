local status_ok, jdtls = pcall(require, "jdtls")
if not status_ok then
  return
end

local root_markers = {
  ".git",
  "mvnw",
  "gradlew",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
}

local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath "data" .. "/jdtls-workspaces/" .. project_name

local mason_path = vim.fn.stdpath "data" .. "/mason/packages/jdtls"
local launcher_jar = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1]

local os_config
if vim.fn.has "mac" == 1 then
  os_config = "config_mac"
elseif vim.fn.has "unix" == 1 then
  os_config = "config_linux"
elseif vim.fn.has "win32" == 1 then
  os_config = "config_win"
end

local lombok_jar = mason_path .. "/lombok.jar"
if vim.fn.filereadable(lombok_jar) == 0 then
  local alt_lombok = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/packages/*lombok*/**/*.jar", true, true)[1]
  if alt_lombok and vim.fn.filereadable(alt_lombok) == 1 then
    lombok_jar = alt_lombok
  end
end

local cmd = {
  "java",
  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.level=ALL",
  "-Xmx2G",
  "--add-modules=ALL-SYSTEM",
  "--add-opens",
  "java.base/java.util=ALL-UNNAMED",
  "--add-opens",
  "java.base/java.lang=ALL-UNNAMED",
}

if lombok_jar and vim.fn.filereadable(lombok_jar) == 1 then
  table.insert(cmd, string.format("-javaagent:%s", lombok_jar))
end

if launcher_jar and vim.fn.filereadable(launcher_jar) == 1 then
  table.insert(cmd, "-jar")
  table.insert(cmd, launcher_jar)
  table.insert(cmd, "-configuration")
  table.insert(cmd, mason_path .. "/" .. os_config)
  table.insert(cmd, "-data")
  table.insert(cmd, workspace_dir)
else
  cmd = { "jdtls", "-data", workspace_dir }
end

local bundles = {}
local java_debug_path = vim.fn.stdpath "data" .. "/mason/packages/java-debug-adapter"
local java_debug_jar = vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)[1]
if java_debug_jar and vim.fn.filereadable(java_debug_jar) == 1 then
  table.insert(bundles, java_debug_jar)
end

local java_test_path = vim.fn.stdpath "data" .. "/mason/packages/java-test"
local java_test_jars = vim.fn.glob(java_test_path .. "/extension/server/*.jar", true, true)
if java_test_jars then
  for _, jar in ipairs(java_test_jars) do
    if vim.fn.filereadable(jar) == 1 then
      table.insert(bundles, jar)
    end
  end
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
  cmd = cmd,
  root_dir = root_dir,
  init_options = {
    bundles = bundles,
    extendedClientCapabilities = extendedClientCapabilities,
  },
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 99,
          staticStarThreshold = 99,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      referencesCodeLens = { enabled = true },
      inlayHints = {
        parameterNames = { enabled = "all" },
      },
    },
  },
  on_attach = function(client, bufnr)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- <leader>co is globally bound to the Aerial symbol outline (lua/plugins/lsp.lua);
    -- Java overrides it buffer-locally for organize-imports, so give outline a fallback here.
    map("n", "<leader>co", jdtls.organize_imports, "Java: Organize imports")
    map("n", "<leader>cO", "<cmd>AerialToggle!<cr>", "Java: Symbol outline (Aerial)")
    map("n", "<leader>ce", jdtls.extract_variable, "Java: Extract variable")
    map("v", "<leader>ce", function()
      jdtls.extract_variable(true)
    end, "Java: Extract variable")
    map("n", "<leader>cE", jdtls.extract_constant, "Java: Extract constant")
    map("v", "<leader>cE", function()
      jdtls.extract_constant(true)
    end, "Java: Extract constant")
    map("v", "<leader>cm", function()
      jdtls.extract_method(true)
    end, "Java: Extract method")
    map("n", "<leader>tc", jdtls.test_class, "Java: Test class")
    map("n", "<leader>tm", jdtls.test_nearest_method, "Java: Test nearest method")

    if #bundles > 0 then
      pcall(jdtls.setup_dap, { hotcodereplace = "auto" })
      pcall(require("jdtls.dap").setup_dap_main_class_configs)
    end
  end,
}

jdtls.start_or_attach(config)
