require("core")
require("lazySetup")
vim.lsp.enable({"jdtls","hyprls","sqlls", "lua_ls", "clangd", "bash", "glsl_analyzer", "wgsl-analyzer", "cmake-language-server" })
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
