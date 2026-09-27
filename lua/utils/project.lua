local M = {}

local root_patterns = {
  ".git",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
  "pyproject.toml",
  "uv.lock",
  "poetry.lock",
  "requirements.txt",
  ".venv",
  "package.json",
  "pnpm-lock.yaml",
  "yarn.lock",
  "bun.lockb",
  "CMakeLists.txt",
  "Makefile",
  "compile_commands.json",
  "dbt_project.yml",
  "terraform.tfstate",
  "main.tf",
  "Dockerfile",
  "compose.yaml",
  "docker-compose.yml",
  "Cargo.toml",
  "go.mod",
  "pubspec.yaml",
  "Package.swift",
  "metro.config.js",
  "app.json",
  "AndroidManifest.xml",
  "Taskfile.yml",
  "Taskfile.yaml",
  "deno.json",
  "deno.jsonc",
  "artisan",
  "composer.json",
}

--- Find the project root for the given buffer or working directory
---@param bufnr integer?
---@return string
function M.get_root(bufnr)
  bufnr = bufnr or 0
  local bufpath = vim.api.nvim_buf_get_name(bufnr)
  local start_dir = (bufpath ~= "" and vim.fs.dirname(bufpath)) or vim.uv.cwd()

  local root_file = vim.fs.find(root_patterns, {
    path = start_dir,
    upward = true,
  })[1]

  if root_file then
    return vim.fs.dirname(root_file)
  end

  return vim.uv.cwd() or vim.fn.getcwd()
end

--- Detect the primary project type
---@param root string?
---@return string
function M.detect_project_type(root)
  root = root or M.get_root()

  local function has(file)
    return vim.fn.filereadable(root .. "/" .. file) == 1
  end

  -- Flutter / Dart
  if has "pubspec.yaml" then
    return "flutter"
  -- Kotlin Multiplatform
  elseif has "composeApp/build.gradle.kts" or has "shared/build.gradle.kts" then
    return "kmp"
  -- Android Native
  elseif has "app/build.gradle" or has "app/build.gradle.kts" or has "AndroidManifest.xml" then
    return "android"
  -- Java / Maven / Gradle
  elseif has "pom.xml" then
    return "java_maven"
  elseif has "build.gradle" or has "build.gradle.kts" then
    return "java_gradle"
  -- iOS / Swift
  elseif
    has "Package.swift"
    or #vim.fn.glob(root .. "/*.xcodeproj", true, true) > 0
    or #vim.fn.glob(root .. "/*.xcworkspace", true, true) > 0
  then
    return "ios_swift"
  -- Data Engineering / dbt
  elseif has "dbt_project.yml" then
    return "dbt"
  -- Systems (Rust / Go / C++)
  elseif has "Cargo.toml" then
    return "rust"
  elseif has "go.mod" then
    return "go"
  elseif has "CMakeLists.txt" or has "compile_commands.json" then
    return "cpp_cmake"
  elseif has "Makefile" then
    return "cpp_make"
  -- React Native / Expo
  elseif has "metro.config.js" then
    return "react_native"
  elseif has "app.json" and has "package.json" then
    return "expo"
  -- Node.js / Web
  elseif has "pnpm-lock.yaml" then
    return "node_pnpm"
  elseif has "yarn.lock" then
    return "node_yarn"
  elseif has "bun.lockb" then
    return "node_bun"
  elseif has "package.json" then
    return "node_npm"
  -- Deno
  elseif has "deno.json" or has "deno.jsonc" then
    return "deno"
  -- Python
  elseif has "uv.lock" or has "pyproject.toml" or has "requirements.txt" or has ".venv" then
    return "python"
  -- Cloud / DevOps
  elseif has "main.tf" then
    return "terraform"
  elseif has "compose.yaml" or has "docker-compose.yml" or has "Dockerfile" then
    return "docker"
  elseif has "Taskfile.yml" or has "Taskfile.yaml" then
    return "taskfile"
  -- PHP / Laravel
  elseif has "artisan" then
    return "laravel"
  elseif has "composer.json" then
    return "php_composer"
  end

  return "generic"
end

--- Resolve the best Python interpreter for the project (uv -> .venv -> poetry -> pyenv -> python3)
---@param root string?
---@return string
function M.get_python_path(root)
  root = root or M.get_root()

  local venv_candidates = {
    root .. "/.venv/bin/python",
    root .. "/venv/bin/python",
    root .. "/env/bin/python",
    root .. "/.env/bin/python",
  }

  for _, candidate in ipairs(venv_candidates) do
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end
  end

  -- Check if Poetry venv exists
  if vim.fn.filereadable(root .. "/poetry.lock") == 1 and vim.fn.executable "poetry" == 1 then
    local p = vim.fn.trim(vim.fn.system "poetry env info -p 2>/dev/null")
    if vim.v.shell_error == 0 and p ~= "" and vim.fn.filereadable(p .. "/bin/python") == 1 then
      return p .. "/bin/python"
    end
  end

  -- Check pyenv
  if vim.fn.executable "pyenv" == 1 then
    local p = vim.fn.trim(vim.fn.system "pyenv which python 2>/dev/null")
    if vim.v.shell_error == 0 and p ~= "" and vim.fn.filereadable(p) == 1 then
      return p
    end
  end

  return vim.fn.exepath "python3" or "python3"
end

--- Resolve project run command
---@param root string?
---@return string
function M.get_run_command(root)
  root = root or M.get_root()
  local ptype = M.detect_project_type(root)
  local file = vim.fn.expand "%:p"

  if ptype == "flutter" then
    return "flutter run"
  elseif ptype == "kmp" then
    return (vim.fn.filereadable(root .. "/gradlew") == 1 and "./gradlew :composeApp:desktopRun") or "./gradlew run"
  elseif ptype == "android" then
    return (vim.fn.filereadable(root .. "/gradlew") == 1 and "./gradlew installDebug") or "gradle installDebug"
  elseif ptype == "ios_swift" then
    return "swift run"
  elseif ptype == "react_native" then
    return "npx react-native start"
  elseif ptype == "expo" then
    return "npx expo start"
  elseif ptype == "java_maven" then
    return (vim.fn.filereadable(root .. "/mvnw") == 1 and "./mvnw spring-boot:run") or "mvn spring-boot:run"
  elseif ptype == "java_gradle" then
    return (vim.fn.filereadable(root .. "/gradlew") == 1 and "./gradlew bootRun") or "gradle bootRun"
  elseif ptype == "python" then
    local py = M.get_python_path(root)
    return py .. " " .. ((file ~= "" and file) or "main.py")
  elseif ptype == "node_pnpm" then
    return "pnpm dev || pnpm start"
  elseif ptype == "node_yarn" then
    return "yarn dev || yarn start"
  elseif ptype == "node_bun" then
    return "bun dev || bun start"
  elseif ptype == "node_npm" then
    return "npm run dev || npm start"
  elseif ptype == "deno" then
    return "deno task start || deno run main.ts"
  elseif ptype == "rust" then
    return "cargo run"
  elseif ptype == "go" then
    return "go run ."
  elseif ptype == "cpp_cmake" then
    return "cmake --build build && ./build/app"
  elseif ptype == "cpp_make" then
    return "make && ./a.out"
  elseif ptype == "dbt" then
    return "dbt run"
  elseif ptype == "docker" then
    return "docker compose up -d"
  elseif ptype == "taskfile" then
    return "task default || task start"
  elseif ptype == "laravel" then
    return "php artisan serve"
  elseif ptype == "php_composer" then
    return "php -S localhost:8000"
  end

  if file ~= "" and vim.bo.filetype == "python" then
    return M.get_python_path(root) .. " " .. file
  end

  return "echo 'No run command configured for this project type (" .. ptype .. ")'"
end

--- Resolve project build command
---@param root string?
---@return string
function M.get_build_command(root)
  root = root or M.get_root()
  local ptype = M.detect_project_type(root)

  if ptype == "flutter" then
    return "flutter build apk || flutter build ios"
  elseif ptype == "kmp" then
    return (vim.fn.filereadable(root .. "/gradlew") == 1 and "./gradlew assemble") or "./gradlew build"
  elseif ptype == "android" then
    return (vim.fn.filereadable(root .. "/gradlew") == 1 and "./gradlew assembleDebug") or "gradle assembleDebug"
  elseif ptype == "ios_swift" then
    return "swift build"
  elseif ptype == "react_native" then
    return "npx react-native run-android || npx react-native run-ios"
  elseif ptype == "expo" then
    return "npx eas build || npm run build"
  elseif ptype == "java_maven" then
    return (vim.fn.filereadable(root .. "/mvnw") == 1 and "./mvnw clean compile") or "mvn clean compile"
  elseif ptype == "java_gradle" then
    return (vim.fn.filereadable(root .. "/gradlew") == 1 and "./gradlew build") or "gradle build"
  elseif ptype == "node_pnpm" then
    return "pnpm build"
  elseif ptype == "node_yarn" then
    return "yarn build"
  elseif ptype == "node_bun" then
    return "bun run build"
  elseif ptype == "node_npm" then
    return "npm run build"
  elseif ptype == "deno" then
    return "deno compile main.ts"
  elseif ptype == "rust" then
    return "cargo build"
  elseif ptype == "go" then
    return "go build ./..."
  elseif ptype == "cpp_cmake" then
    return "cmake -B build && cmake --build build"
  elseif ptype == "cpp_make" then
    return "make"
  elseif ptype == "dbt" then
    return "dbt build"
  elseif ptype == "taskfile" then
    return "task build"
  elseif ptype == "laravel" then
    return "composer install && (npm run build || pnpm build || yarn build || bun run build || true)"
  elseif ptype == "php_composer" then
    return "composer install"
  end

  return "echo 'No build command configured for this project type (" .. ptype .. ")'"
end

--- Resolve project test command
---@param root string?
---@return string
function M.get_test_command(root)
  root = root or M.get_root()
  local ptype = M.detect_project_type(root)

  if ptype == "flutter" then
    return "flutter test"
  elseif ptype == "kmp" then
    return (vim.fn.filereadable(root .. "/gradlew") == 1 and "./gradlew check") or "./gradlew test"
  elseif ptype == "android" then
    return (vim.fn.filereadable(root .. "/gradlew") == 1 and "./gradlew test") or "gradle test"
  elseif ptype == "ios_swift" then
    return "swift test"
  elseif ptype == "react_native" or ptype == "expo" then
    return "npm test"
  elseif ptype == "java_maven" then
    return (vim.fn.filereadable(root .. "/mvnw") == 1 and "./mvnw test") or "mvn test"
  elseif ptype == "java_gradle" then
    return (vim.fn.filereadable(root .. "/gradlew") == 1 and "./gradlew test") or "gradle test"
  elseif ptype == "python" then
    local py = M.get_python_path(root)
    return py .. " -m pytest"
  elseif ptype == "node_pnpm" then
    return "pnpm test"
  elseif ptype == "node_yarn" then
    return "yarn test"
  elseif ptype == "node_bun" then
    return "bun test"
  elseif ptype == "node_npm" then
    return "npm test"
  elseif ptype == "deno" then
    return "deno test"
  elseif ptype == "rust" then
    return "cargo test"
  elseif ptype == "go" then
    return "go test -v ./..."
  elseif ptype == "dbt" then
    return "dbt test"
  elseif ptype == "taskfile" then
    return "task test"
  elseif ptype == "laravel" then
    return "php artisan test || ./vendor/bin/pest || ./vendor/bin/phpunit"
  elseif ptype == "php_composer" then
    return "./vendor/bin/phpunit || ./vendor/bin/pest || composer test"
  end

  return "echo 'No test command configured for this project type (" .. ptype .. ")'"
end

--- Execute a command inside the project root via NvChad terminal runner
---@param cmd string
---@param id string?
---@param pos string?
function M.run_in_project_terminal(cmd, id, pos)
  local root = M.get_root()
  id = id or "projectRunner"
  pos = pos or "sp"

  -- Ensure runner executes in project directory
  local full_cmd = string.format("cd %s && %s", vim.fn.shellescape(root), cmd)
  require("nvchad.term").runner {
    cmd = full_cmd,
    id = id,
    pos = pos,
  }
end

return M
