return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require 'conform'
    conform.setup {
      formatters_by_ft = {
        markdown = { 'prettier' },
        lua = { 'stylua' },
        python = { 'black', 'isort' },
        -- python = function(bufnr)
        --   if require('conform').get_formatter_info('ruff', bufnr).available then
        --     return { 'ruff_format' }
        --   else
        --     return { 'isort', 'black' }
        --   end
        -- end,
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        go = { 'goimports', 'gofmt' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        json = { 'prettierd', 'prettier' },
        yaml = { 'prettierd', 'prettier' },
        vim = { 'vim-beautify' },
        glsl = { 'clang-format' },
        wgsl = { 'clang-format' },
        -- Use the "*" filetype to run formatters on all filetypes.
        ['*'] = { 'codespell', 'cspell' },
      },
      format_on_save = {
        lsp_format = 'fallback',
        timeout_ms = 500,
      },
      log_level = vim.log.levels.ERROR,
      notify_on_error = true,
      notify_no_formatters = true,
    }

    -- Keybinding to manually format
    vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
      conform.format {
        lsp_fallback = true,
        async = false,
        timeout_ms = 500,
      }
    end, { desc = 'Format file or range (in visual mode)' })
  end,
}
