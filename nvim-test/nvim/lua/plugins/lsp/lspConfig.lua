return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require 'lspconfig'

      -- Define LSP servers
      local servers = {
        'clangd',
        'rust_analyzer',
        'lua_ls',
        'pyright',
        'tsserver',
        'html',
        'cssls',
        'jsonls',
        'yamlls',
        'gopls',
        'sqlls',
        'cmake',
        'bashls',
        'marksman',
        'vimls',
        'glsl_analyzer',
        'wgsl_analyzer',
        'intelephense',
      }

      -- Setup LSP servers
      for _, server in ipairs(servers) do
        lspconfig[server].setup {}
      end
    end,
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local null_ls = require 'null-ls'

      null_ls.setup {
        sources = {
          -- Formatters
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.rustfmt,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.sqlfluff,

          -- Linters
          null_ls.builtins.diagnostics.cpplint,
          null_ls.builtins.diagnostics.luacheck,
          null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.diagnostics.phpstan,
          null_ls.builtins.diagnostics.golangci_lint,
          null_ls.builtins.diagnostics.jsonlint,
          null_ls.builtins.diagnostics.sqlfluff,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.diagnostics.markdownlint,
        },
      }

      -- Auto-format on save
      vim.api.nvim_create_autocmd('BufWritePre', {
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end,
  },
}
