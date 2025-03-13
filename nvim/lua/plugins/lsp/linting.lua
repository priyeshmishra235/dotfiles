return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    lint.linters_by_ft = {
      -- cpp = { 'cpplint', 'clang-tidy', 'clangd' },
      cpp = { 'cpplint' },
      c = { 'cpplint' },
      -- c = { 'cpplint', 'clang-tidy', 'clangd' },
      lua = { 'luacheck' },
      python = { 'pylint', 'ruff' },
      html = { 'markuplint' },
      css = { 'stylelint' },
      json = { 'jsonlint' },
      yaml = { 'yamllint' },
      cmake = { 'cmakelint' },
      sh = { 'shellcheck' },
      markdown = { 'markdownlint' },
      vim = { 'vint' },
      glsl = { 'glsllint' },
      wgsl = { 'wgsl-analyzer' },
      -- General spellchecking & typos
      ['*'] = { 'cspell', 'typos' },
    }

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Keybinding to trigger linting manually
    vim.keymap.set('n', '<leader>li', function()
      lint.try_lint()
    end, { desc = 'Trigger linting for current file' })
  end,
}
