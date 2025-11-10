return {
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    Comment out Text                     │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
    dependencies = {
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        config = function()
          require('ts_context_commentstring').setup {
            enable_autocmd = false,
          }
        end,
      },
    },
    config = function()
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<C-c>', require('Comment.api').toggle.linewise.current, opts)
      -- vim.keymap.set('n', '<C-_>', require('Comment.api').toggle.linewise.current, opts)
      -- vim.keymap.set('n', '<C-/>', require('Comment.api').toggle.linewise.current, opts)
      vim.keymap.set('v', '<C-c>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
      -- vim.keymap.set('v', '<C-_>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
      -- vim.keymap.set('v', '<C-/>', "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", opts)
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        -- pre_hook = function()
        --     return vim.bo.commentstring
        -- end,
      }
    end,
  },
  -- ╭─────────────────────────────────────────────────────────╮
  -- │                    COMMENT-BOX.NVIM                     │
  -- ╰─────────────────────────────────────────────────────────╯
  {
    'LudoPinelli/comment-box.nvim',
    event = 'VeryLazy',
    cmd = { 'CBcatalog', 'CBcbox' },
    keys = {
      { '<leader>cb', '<cmd>CBlcbox<cr>',   desc = 'Comment Box Big' },
      { '<leader>cd', '<cmd>CBd<cr>',       desc = 'Comment Box Delete' },
      { '<leader>ca', '<cmd>CBalbox<cr>',   desc = 'Comment Box Auto' },
      { '<leader>cl', '<cmd>CBcatalog<cr>', desc = 'Comment Box Catalog' },
    },
    opts = {
      line_width = 60,
    },
  },
}
