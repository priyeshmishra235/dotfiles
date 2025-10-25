local wezterm = require 'wezterm'

wezterm.on('gui-startup', function()
  local _, _, window = wezterm.mux.spawn_window({})
  window:gui_window():maximize()
end)

return {
  font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
  font_size = 13.0,
  window_decorations = "NONE",
  window_background_opacity = 1.0,
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },

  -- Tabs & Scroll
  enable_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  enable_scroll_bar = false,
  scrollback_lines = 0,

  -- Misc
  enable_wayland = false,
  check_for_updates = false,
  warn_about_missing_glyphs = false,
  adjust_window_size_when_changing_font_size = false,

  -- Cursor
  colors = {
    cursor_bg = "#FFFFFF",
    cursor_fg = "#000000",
    cursor_border = "#FFFFFF",
  },
}
