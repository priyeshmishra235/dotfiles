return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup {
        ensure_installed = {
          -- C/C++
          'clangd', -- LSP
          'clang-format', -- Formatter
          'cpplint', -- Linter

          -- Rust
          'rust-analyzer', -- LSP (use rustup for best experience)
          'rustfmt', -- Formatter (included with rustup)

          -- Lua
          'lua_ls', -- LSP
          'stylua', -- Formatter
          'luacheck', -- Linter

          -- Python
          'pyright', -- LSP
          'black', -- Formatter
          'flake8', -- Linter

          -- GLSL, WGSL, HLSL (Shader Languages)
          'glsl_analyzer', -- LSP (for GLSL, WGSL, HLSL)
          'wgsl_analyzer', -- LSP (for WGSL)

          -- HTML, CSS
          'html', -- LSP
          'cssls', -- LSP
          'prettier', -- Formatter (for both HTML & CSS)

          -- JavaScript/TypeScript
          'tsserver', -- LSP
          'prettier', -- Formatter
          'eslint_d', -- Linter

          -- PHP
          'intelephense', -- LSP
          'php-cs-fixer', -- Formatter
          'phpstan', -- Linter

          -- Go
          'gopls', -- LSP
          'goimports', -- Formatter
          'golangci-lint', -- Linter

          -- JSON, JSON5, TOML, YAML
          'jsonls', -- LSP (JSON/JSON5)
          'yamlls', -- LSP (YAML)
          'prettier', -- Formatter (for JSON, JSON5, YAML)
          'jsonlint', -- Linter (JSON)

          -- SQL
          'sqlls', -- LSP
          'sqlfluff', -- Formatter & Linter

          -- CMake, Make, Ninja
          'cmake', -- LSP
          'ninja', -- Build System (not an LSP)
          'shellcheck', -- Linter (useful for shell scripting in build systems)

          -- Bash
          'bashls', -- LSP
          'shfmt', -- Formatter
          'shellcheck', -- Linter

          -- Markdown
          'marksman', -- LSP
          'markdownlint', -- Linter
          'prettier', -- Formatter

          -- Vim
          'vimls', -- LSP

          -- Gitignore (General Git Support)
          'githtml', -- LSP
        },
      }
    end,
  },
}
