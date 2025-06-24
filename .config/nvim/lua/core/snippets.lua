-- Custom code snippets for different purposes

-- Prevent LSP from overwriting Treesitter color settings
-- https://github.com/NvChad/NvChad/issues/1907
vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, Treesitter's priority level

-- Appearance of diagnostics
-- vim.diagnostic.config {
--   virtual_text = {
--     prefix = '●',
--     -- Add a custom format function to show error codes
--     format = function(diagnostic)
--       local code = diagnostic.code and string.format('[%s]', diagnostic.code) or ''
--       return string.format('%s %s', code, diagnostic.message)
--     end,
--   },
--   underline = true,
--   update_in_insert = true,
--   float = {
--     source = 'if_many', -- Or "if_many"
--   },
-- }

-- Make diagnostic background transparent
-- vim.cmd 'highlight DiagnosticVirtualText guibg=NONE'
