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

null_ls.setup({
  sources = {
    -- ╭──────────────╮
    -- │ Code Actions │
    -- ╰──────────────╯
    code_actions.gitsigns,
    code_actions.refactoring.with({
      filetypes = { 'go', 'javascript', 'lua', 'python', 'typescript', 'c', 'cpp', 'java', 'rust', 'sh' },
      extra_filetypes = { 'html', 'css', 'scss', 'json', 'yaml', 'markdown', 'php' },
    }),
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
    formatting.prettier.with({ filetypes = { 'javascript', 'typescript', 'json', 'yaml', 'html', 'css', 'scss', 'markdown' } }),
    formatting.prettierd.with({ filetypes = { 'javascript', 'typescript', 'json', 'yaml', 'html', 'css', 'scss', 'markdown' } }),
    formatting.stylua,
    formatting.textlint,
    formatting.clang_format.with({
      filetypes = { "glsl", "vert", "frag", "comp", "geom" },
      extra_args = { "--style=file" },
    }),
    {
      name = "wgslfmt",
      method = null_ls.methods.FORMATTING,
      filetypes = { "wgsl" },
      generator = null_ls.generator({
        command = "wgslfmt",
        args = { "--stdin" },
        to_stdin = true,
      }),
    },

    -- ╭────────────────────────────╮
    -- │ Custom GLSL Diagnostics    │
    -- ╰────────────────────────────╯
    {
      name = "glsl_analyzer",
      method = null_ls.methods.DIAGNOSTICS,
      filetypes = { "glsl", "vert", "frag", "comp" },
      generator = null_ls.generator({
        command = "glsl_analyzer",
        args = { "--format", "json", "-" },
        to_stdin = true,
        from_stderr = false,
        format = "json",
        check_exit_code = function(code, _)
          return code <= 1
        end,
        on_output = function(params)
          local diagnostics = {}
          local ok, decoded = pcall(vim.fn.json_decode, params.output)
          if not ok or not decoded or not decoded.diagnostics then
            return diagnostics
          end
          for _, d in ipairs(decoded.diagnostics) do
            table.insert(diagnostics, {
              row = d.line,
              col = d.column,
              end_row = d.end_line or d.line,
              end_col = d.end_column or d.column,
              message = d.message,
              severity = d.severity == "error" and 1 or 2,
              source = "glsl_analyzer",
            })
          end
          return diagnostics
        end,
      }),
    },
  },
})

    -- Autoformat on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function()
        vim.lsp.buf.format { timeout_ms = 2000, async = false }
      end,
    })
  end,
}
