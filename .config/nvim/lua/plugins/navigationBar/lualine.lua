return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local anim_state = {}
    local last_update = {}

    local function next_frame(name, frames, interval)
      interval = interval or 150
      local now = vim.loop.now()
      if not anim_state[name] then
        anim_state[name] = 1
        last_update[name] = now
        return frames[1]
      end
      if now - last_update[name] >= interval then
        anim_state[name] = (anim_state[name] % #frames) + 1
        last_update[name] = now
      end
      return frames[anim_state[name]]
    end
    local function spinner()
      return next_frame("spinner", { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" })
    end
    -- local function bounce()
    --   return next_frame("bounce", { "⇅", "⇵", "⇳", "⇅" })
    -- end
    -- local function wave()
    --   return next_frame("wave", { "~  ", " ~ ", "  ~", " ~ " })
    -- end
    -- local function neon_pulse()
    --   return next_frame("pulse", { "▰▱▱", "▰▰▱", "▰▰▰", "▰▰▱", "▰▱▱" })
    -- end
    -- local function fill_bar()
    --   return next_frame("fill_bar", {
    --     "░░░░░░░░░░",
    --     "▒░░░░░░░░░",
    --     "▒▒░░░░░░░░",
    --     "▓▒▒░░░░░░░",
    --     "▓▓▒▒░░░░░░",
    --     "▓▓▓▒▒░░░░░",
    --     "▓▓▓▓▒▒░░░░",
    --     "▓▓▓▓▓▒▒░░░",
    --     "▓▓▓▓▓▓▒▒░░",
    --     "▓▓▓▓▓▓▓▒▒░",
    --     "▓▓▓▓▓▓▓▓▒▒",
    --     "▓▓▓▓▓▓▓▓▓▒",
    --     "▓▓▓▓▓▓▓▓▓▓",
    --   })
    -- end
    local function neural_arc()
      return next_frame("neural_arc", {
        "⊹────⊹────⊹",
        "⊹──⊹──⊹──⊹─",
        "⊹⊹──⊹──⊹──⊹",
        "─⊹⊹──⊹──⊹──",
        "──⊹⊹──⊹──⊹─",
      })
    end
    local function scan_grid()
      return next_frame("scan_grid", {
        "▤▥▦▧▨▩▧▦▥▤",
        "▥▦▧▨▩▧▦▥▤▤",
        "▦▧▨▩▧▦▥▤▤▥",
        "▧▨▩▧▦▥▤▥▦▧",
        "▨▩▧▦▥▤▥▦▧▨",
        "▩▧▦▥▤▥▦▧▨▩",
      })
    end
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = {
          normal = {
            a = { fg = '#ffffff', bg = '#4b1a1a', gui = 'bold' },
            b = { fg = '#ffd700', bg = '#2b1a1a' },
            c = { fg = '#dcdcdc', bg = '#1a1a1a' },
          },
          insert = { a = { fg = '#ffffff', bg = '#1a4b1a', gui = 'bold' } },
          visual = { a = { fg = '#ffffff', bg = '#1a1a4b', gui = 'bold' } },
          replace = { a = { fg = '#ffffff', bg = '#4b1a4b', gui = 'bold' } },
          command = { a = { fg = '#ffffff', bg = '#4b4b1a', gui = 'bold' } },
          inactive = {
            a = { fg = '#888888', bg = '#1a1a1a', gui = 'bold' },
            b = { fg = '#888888', bg = '#1a1a1a' },
            c = { fg = '#888888', bg = '#1a1a1a' },
          },
        },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { statusline = {}, winbar = {} },
        globalstatus = false,
        ignore_focus = {},
        always_show_tabline = true,
        refresh = { statusline = 100, tabline = 100, winbar = 100, },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { 'filename' },
        lualine_b = { {
          'diagnostics',
          sources = { 'nvim_lsp', 'nvim_diagnostic' },
          symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        } },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          { neural_arc, color = { fg = '#ff0080', bg = '#0a0a0a', gui = 'bold' } },
          { spinner,    color = { fg = '#fffa00', bg = '#0a0a0a', gui = 'bold' } },
          { scan_grid,  color = { fg = '#00fff7', bg = '#0a0a0a', gui = 'bold' } },
        }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}
