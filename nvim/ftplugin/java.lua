-- Java LSP（jdtls），只在打开 java 文件时启动
local ok, jdtls = pcall(require, 'jdtls')
if not ok then return end

local home = os.getenv('HOME')
local mason = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
-- jdtls 本身需要 JDK 21+ 才能运行
local java21 = '/opt/homebrew/opt/openjdk@21/bin/java'

local root_dir = vim.fs.root(0, { 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'build.gradle.kts', 'settings.gradle', '.git' })
if not root_dir then return end
-- 每个项目单独的索引目录
local workspace = home .. '/.cache/jdtls/workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t') .. '-' .. vim.fn.sha256(root_dir):sub(1, 8)

jdtls.start_or_attach({
  name = 'jdtls',
  cmd = {
    mason .. '/bin/jdtls',
    '--java-executable', java21,
    '--jvm-arg=-javaagent:' .. mason .. '/lombok.jar',
    '-data', workspace,
  },
  root_dir = root_dir,
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  settings = {
    java = {
      configuration = {
        -- 项目编译可用的 JDK
        runtimes = {
          { name = 'JavaSE-11', path = '/Library/Java/JavaVirtualMachines/jdk-11.jdk/Contents/Home' },
          { name = 'JavaSE-17', path = '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home', default = true },
          { name = 'JavaSE-21', path = '/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home' },
        },
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = 'fernflower' },
    },
  },
})
