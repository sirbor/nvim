return {
  -- ============================================================================
  -- iOS & Apple Platforms (Swift, SwiftUI, Objective-C)
  -- ============================================================================
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    cmd = {
      "XcodebuildSetup",
      "XcodebuildPicker",
      "XcodebuildBuild",
      "XcodebuildBuildRun",
      "XcodebuildTest",
      "XcodebuildTestClass",
      "XcodebuildSelectDevice",
      "XcodebuildSelectScheme",
      "XcodebuildToggleCodeCoverage",
      "XcodebuildToggleLogs",
      "XcodebuildCancel",
      "XcodebuildCleanDerivedData",
    },
    ft = { "swift", "objc", "objcpp" },
    opts = {
      show_build_progress_bar = true,
      logs = {
        auto_open_on_success_tests = false,
        auto_open_on_failed_tests = true,
        auto_close_on_success_build = true,
        auto_focus = false,
      },
      code_coverage = {
        enabled = true,
      },
    },
    keys = {
      -- Lowercase <leader>i (Fast access for iOS)
      { "<leader>is", "<cmd>XcodebuildSetup<cr>", desc = "iOS: Initial Project Setup Wizard" },
      { "<leader>ip", "<cmd>XcodebuildPicker<cr>", desc = "iOS: Actions / Scheme picker" },
      { "<leader>ib", "<cmd>XcodebuildBuild<cr>", desc = "iOS: Build project" },
      { "<leader>ir", "<cmd>XcodebuildBuildRun<cr>", desc = "iOS: Build and Run" },
      { "<leader>it", "<cmd>XcodebuildTest<cr>", desc = "iOS: Run all tests" },
      { "<leader>iT", "<cmd>XcodebuildTestClass<cr>", desc = "iOS: Run test class" },
      { "<leader>id", "<cmd>XcodebuildSelectDevice<cr>", desc = "iOS: Select device / simulator" },
      { "<leader>ic", "<cmd>XcodebuildToggleCodeCoverage<cr>", desc = "iOS: Toggle code coverage" },
      { "<leader>il", "<cmd>XcodebuildToggleLogs<cr>", desc = "iOS: Toggle build logs" },
      { "<leader>iq", "<cmd>XcodebuildCancel<cr>", desc = "iOS: Cancel current action" },
      -- Uppercase <leader>X (Xcode alias)
      { "<leader>Xs", "<cmd>XcodebuildSetup<cr>", desc = "Xcode: Initial Project Setup Wizard" },
      { "<leader>Xp", "<cmd>XcodebuildPicker<cr>", desc = "Xcode: Actions / Scheme picker" },
      { "<leader>Xb", "<cmd>XcodebuildBuild<cr>", desc = "Xcode: Build project" },
      { "<leader>Xr", "<cmd>XcodebuildBuildRun<cr>", desc = "Xcode: Build and Run" },
      { "<leader>Xt", "<cmd>XcodebuildTest<cr>", desc = "Xcode: Run all tests" },
      { "<leader>XT", "<cmd>XcodebuildTestClass<cr>", desc = "Xcode: Run test class" },
      { "<leader>Xd", "<cmd>XcodebuildSelectDevice<cr>", desc = "Xcode: Select device / simulator" },
      { "<leader>Xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", desc = "Xcode: Toggle code coverage" },
      { "<leader>Xl", "<cmd>XcodebuildToggleLogs<cr>", desc = "Xcode: Toggle build logs" },
      { "<leader>Xq", "<cmd>XcodebuildCancel<cr>", desc = "Xcode: Cancel current action" },
    },
  },

  -- ============================================================================
  -- Flutter & Dart
  -- ============================================================================
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ui = {
        border = "rounded",
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
        },
      },
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        highlight = "Comment",
        prefix = "// ",
        enabled = true,
      },
      dev_log = {
        enabled = true,
        open_cmd = "tabedit",
      },
      dev_tools = {
        autostart = false,
        auto_open_browser = false,
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
        register_configurations = function(_)
          require("dap").configurations.dart = {}
          pcall(function()
            require("dap.ext.vscode").load_launchjs()
          end)
        end,
      },
    },
    keys = {
      { "<leader>Fc", "<cmd>FlutterRun<cr>", desc = "Flutter: Run app" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter: Quit app" },
      { "<leader>Fr", "<cmd>FlutterReload<cr>", desc = "Flutter: Hot Reload" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Flutter: Hot Restart" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter: Select device" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter: Launch emulator" },
      { "<leader>Fl", "<cmd>FlutterDevTools<cr>", desc = "Flutter: DevTools" },
      { "<leader>Ft", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter: Widget outline" },
      { "<leader>FL", "<cmd>FlutterLogToggle<cr>", desc = "Flutter: Toggle dev logs" },
    },
  },

  -- ============================================================================
  -- Android & Logcat Tooling
  -- ============================================================================
  {
    "AntoineGagnon/android.nvim",
    cmd = { "Android", "AndroidLogcat", "AndroidDevices", "AndroidBuild" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      {
        "<leader>Al",
        function()
          require("nvchad.term").toggle {
            id = "androidLogcat",
            pos = "sp",
            cmd = "adb logcat -v color || echo 'ADB not found or no device connected'",
          }
        end,
        desc = "Android: Logcat stream (color)",
      },
      {
        "<leader>Ac",
        function()
          vim.fn.system "adb logcat -c"
          vim.notify("Android Logcat cleared", vim.log.levels.INFO)
        end,
        desc = "Android: Clear Logcat buffer",
      },
      {
        "<leader>Ad",
        function()
          require("nvchad.term").toggle {
            id = "androidDevices",
            pos = "float",
            cmd = "adb devices -l && echo '' && emulator -list-avds",
          }
        end,
        desc = "Android: List devices / emulators",
      },
      {
        "<leader>Ab",
        function()
          local proj = require "utils.project"
          proj.run_in_project_terminal("./gradlew assembleDebug || gradle assembleDebug", "androidBuild")
        end,
        desc = "Android: Build Debug APK",
      },
      {
        "<leader>Ar",
        function()
          local proj = require "utils.project"
          proj.run_in_project_terminal("./gradlew installDebug || gradle installDebug", "androidRun")
        end,
        desc = "Android: Install & Run Debug APK",
      },
    },
  },
}
