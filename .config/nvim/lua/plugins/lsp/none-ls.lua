return {
  'nvimtools/none-ls.nvim',
  dependencies = { 'nvimtools/none-ls-extras.nvim', 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',

  config = function()
    local null_ls = require 'null-ls'
    local code_actions = null_ls.builtins.code_actions
    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting
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
        -- formatting.clang_format.with { filetypes = { 'c', 'cpp', 'java', 'cuda' } },

        -- ╭───────────────╮
        -- │ Diagnostics   │
        -- ╰───────────────╯
        diagnostics.textlint,
        diagnostics.codespell,
        diagnostics.markdownlint.with { filetypes = { 'markdown' } },
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
