return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    vim.opt.termguicolors = true -- Removed the trailing comma

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }

    -- ╭──────────────────────────────╮
    -- │ Toggle bufferline visibility │
    -- ╰──────────────────────────────╯
    map('n', '<leader>tb', ':ToggleTabline<CR>', opts)
    -- Show bufferline always
    map('n', '<leader>bs', ':set showtabline=2<CR>', opts)
    -- Show bufferline only when multiple buffers exist
    map('n', '<leader>bt', ':set showtabline=3<CR>', opts)

    -- ╭──────────────────────╮
    -- │ Close current buffer │
    -- ╰──────────────────────╯
    map('n', '<leader>bd', ':bdelete<CR>', opts)
    -- Force close current buffer
    map('n', '<leader>bD', ':bdelete!<CR>', opts)
    -- Close all buffers except the current one
    map('n', '<leader>bo', ':%bd|e#<CR>', opts)
    -- Pick a buffer to close visually
    map('n', '<leader>bp', ':BufferLinePickClose<CR>', opts)

    local bufferline = require 'bufferline'
    bufferline.setup {
      options = {
        mode = 'buffers', -- set to "tabs" to only show tabpages instead
        style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
        themable = true, -- allows highlight groups to be overridden i.e. sets highlights as default
        numbers = 'buffer_id', -- Fixed invalid Lua syntax
        close_command = 'bdelete! %d', -- can be a string | function | false see "Mouse actions"
        right_mouse_command = 'bdelete! %d', -- can be a string | function | false, see "Mouse actions"
        left_mouse_command = 'buffer %d', -- can be a string | function | false see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function | false see "Mouse actions"
        indicator = {
          icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = 'icon',
        },
        buffer_close_icon = '󰅖',
        modified_icon = '● ',
        close_icon = ' ',
        left_trunc_marker = ' ',
        right_trunc_marker = ' ',
        name_formatter = function(buf)
          return buf.name
        end,
        max_name_length = 15,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = true, -- whether or not tab names should be truncated
        tab_size = 10,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false, -- only applies to coc
        diagnostics_update_on_event = true, -- use nvim's diagnostic handler
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          return '(' .. count .. ')'
        end,
        custom_filter = function(buf_number, buf_numbers)
          if vim.bo[buf_number].filetype ~= '<i-dont-want-to-see-this>' then
            return true
          end
          return false -- Ensured function always returns a value
        end,
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            text_align = 'left', -- Fixed invalid Lua syntax
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        show_duplicate_prefix = false,
        duplicates_across_groups = true,
        persist_buffer_sort = true,
        move_wraps_at_ends = false,
        separator_style = 'thin',
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        auto_toggle_bufferline = false,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
        sort_by = 'insert_after_current',
        pick = {
          alphabet = 'abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890',
        },
      },
    }
  end,
}
