local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

-- Maximize on launch
wezterm.on('gui-startup', function()
  local _, _, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

-- Optional background image cycling stubs (add images logic if needed)
-- wezterm.on("cycle-bg-random", function(_) end)
-- wezterm.on("cycle-bg-next", function(_) end)
-- wezterm.on("cycle-bg-prev", function(_) end)
-- wezterm.on("cycle-bg-fuzzy", function(_) end)
-- wezterm.on("toggle-bg-focus", function(_) end)

local config = wezterm.config_builder()

-- Appearance
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 12.0
config.line_height = 1.1
config.color_scheme = 'Apple System Colors'

-- Window
config.enable_wayland = false
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.inactive_pane_hsb = { saturation = 0.2, brightness = 0.6 }

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- Leader key for modal tables
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Key bindings
config.keys = {
  -- Misc / Utilities
  { key = 'f', mods = 'ALT',        action = act.Search { CaseSensitiveString = "" } },
  { key = 'u', mods = 'ALT|CTRL',   action = act.OpenLinkAtMouseCursor },

  -- Copy & Paste
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

  -- Tabs
  { key = 't', mods = 'ALT',        action = act.SpawnTab 'DefaultDomain' },
  { key = 'q', mods = 'ALT|CTRL',   action = act.CloseCurrentTab { confirm = false } },
  { key = '[', mods = 'ALT',        action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'ALT',        action = act.ActivateTabRelative(1) },
  { key = '[', mods = 'ALT|CTRL',   action = act.MoveTabRelative(-1) },
  { key = ']', mods = 'ALT|CTRL',   action = act.MoveTabRelative(1) },
  {
    key = '0',
    mods = 'ALT',
    action = act.PromptInputLine {
      description = "Rename Tab",
      action = wezterm.action_callback(function(window, _, line)
        if line then window:active_tab():set_title(line) end
      end)
    }
  },

  -- Window
  { key = 'n',     mods = 'ALT',      action = act.SpawnWindow },
  { key = '=',     mods = 'ALT',      action = act.IncreaseFontSize },
  { key = '-',     mods = 'ALT',      action = act.DecreaseFontSize },

  -- Panes: splits
  { key = '\\',    mods = 'ALT|CTRL', action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = '\\',    mods = 'ALT',      action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },

  -- Panes: zoom & close
  { key = 'Enter', mods = 'ALT',      action = act.TogglePaneZoomState },
  { key = 'q',     mods = 'ALT',      action = act.CloseCurrentPane { confirm = false } },

  -- Panes: navigation
  { key = 'h',     mods = 'ALT',      action = act.ActivatePaneDirection 'Left' },
  { key = 'j',     mods = 'ALT',      action = act.ActivatePaneDirection 'Down' },
  { key = 'k',     mods = 'ALT',      action = act.ActivatePaneDirection 'Up' },
  { key = 'l',     mods = 'ALT',      action = act.ActivatePaneDirection 'Right' },
  { key = 'p',     mods = 'ALT',      action = act.PaneSelect { mode = 'SwapWithActive' } },
}
return config
