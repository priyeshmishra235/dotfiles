return {
  'nvimtools/none-ls.nvim',
  dependencies = { 'nvimtools/none-ls-extras.nvim', 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',

  config = function()
    local null_ls = require 'null-ls'
    local code_actions = null_ls.builtins.code_actions
    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting
    local hover = null_ls.builtins.hover
    local completion = null_ls.builtins.completion

    null_ls.setup {
      sources = {
        -- ╭──────────────╮
        -- │ Code Actions │
        -- ╰──────────────╯
        code_actions.gitsigns,
        code_actions.refactoring.with {
          filetypes = { 'go', 'javascript', 'lua', 'python', 'typescript',
            'c', 'cpp', 'java', 'rust', 'sh' },
          extra_filetypes = { 'html', 'css', 'scss', 'json', 'yaml',
            'markdown', 'php' },
        },
        vim.keymap.set('v', '<leader>grr', vim.lsp.buf.code_action,
          { noremap = true, silent = true, desc = 'Refactor code' }),
        code_actions.textlint,

        -- ╭────────────╮
        -- │ Completion │
        -- ╰────────────╯
        completion.luasnip,
        completion.nvim_snippets,
        completion.spell,

        -- ╭────────────╮
        -- │ Formatters │
        -- ╰────────────╯
        formatting.codespell,
        formatting.markdownlint,
        formatting.prettier.with { filetypes = { 'javascript', 'typescript',
          'json', 'yaml', 'html', 'css', 'scss', 'markdown' } },
        formatting.prettierd.with { filetypes = { 'javascript', 'typescript',
          'json', 'yaml', 'html', 'css', 'scss', 'markdown' } },
        formatting.stylua,
        formatting.textlint,
        formatting.black,
        formatting.cbfmt,
        formatting.isort,
        formatting.goimports,
        formatting.gofumpt,
        -- formatting.clang_format.with { filetypes = { 'c', 'cpp', 'java', 'cuda' } },
        formatting.shfmt,
        formatting.sqlfluff.with { filetypes = { 'sql', 'postgres' } },

        -- ╭───────────────╮
        -- │ Diagnostics   │
        -- ╰───────────────╯
        diagnostics.textlint,
        diagnostics.codespell,
        -- diagnostics.cppcheck.with { filetypes = { 'c', 'cpp' } },
        diagnostics.gitlint,
        -- diagnostics.gccdiag.with { filetypes = { 'c', 'cpp' } },
        diagnostics.cmake_lint.with { filetypes = { 'cmake' } },
        diagnostics.pylint,
        diagnostics.phpstan,
        diagnostics.golangci_lint.with { filetypes = { 'go' } },
        diagnostics.sqlfluff.with { filetypes = { 'sql', 'postgres' } },
        diagnostics.markdownlint.with { filetypes = { 'markdown' } },
        diagnostics.commitlint,
        diagnostics.markuplint.with { filetypes = { 'html', 'xml' } },
        diagnostics.stylelint.with { filetypes = { 'css', 'scss', 'less', 'sass' } },
        diagnostics.vint.with { filetypes = { 'vim' } },
        diagnostics.yamllint.with { filetypes = { 'yaml', 'yml' } },

        -- Hover
        hover.printenv,
      },
    }

    -- Autoformat on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function()
        vim.lsp.buf.format { timeout_ms = 2000, async = false }
      end,
    })
  end,
}
