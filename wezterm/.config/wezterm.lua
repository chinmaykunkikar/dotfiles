local wezterm = require 'wezterm'

-- Check if we're using a newer version of WezTerm
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Tab title formatting
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  if not tab or not tab.active_pane then
    return {{ Text = " Terminal " }}
  end

  local title = tab.active_pane.title or "Terminal"

  -- Truncate long titles
  -- local available_width = max_width - 4
  -- if #title > available_width then
  --   title = title:sub(1, available_width - 3) .. "..."
  -- end

  if tab.active_pane.has_unseen_output then
    return {
      { Foreground = { Color = "#b086ac" } },
      { Text = " ● " .. title },
    }
  end

  return {
    { Text = " " .. title .. " " },
  }
end)

-- Font configuration
config.font_size = 14.0

-- Colors
config.colors = {
  foreground = "#afafaf",
  background = "#101010",
  cursor_bg = "#c7c7c7",
  cursor_border = "#c7c7c7",
  cursor_fg = "#101010",
  selection_bg = "#554c49",
  selection_fg = "#c3c7ca",

  ansi = {
    "#242627",
    "#e95384",
    "#bde25a",
    "#f2ab47",
    "#8fdcef",
    "#a98bf7",
    "#748387",
    "#d5d5d0",
  },

  brights = {
    "#636566",
    "#f086ac",
    "#cfec82",
    "#e9e091",
    "#8fdcef",
    "#a98bf7",
    "#b5c5c9",
    "#f9f9f5",
  },
}

-- Window appearance
config.window_background_opacity = 1.0
config.macos_window_background_blur = 10
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.adjust_window_size_when_changing_font_size = false

-- Additional settings (with fallbacks)
config.scrollback_lines = 10000

-- Keybindings with correct syntax
config.keys = {
  -- Tab management
  { key = 't', mods = 'SUPER', action = wezterm.action.SpawnTab 'DefaultDomain' },
  { key = 'w', mods = 'SUPER', action = wezterm.action.CloseCurrentTab { confirm = true } },

  -- Pane management
  { key = 'd', mods = 'SUPER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'SUPER|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Pane navigation
  { key = 'LeftArrow', mods = 'SUPER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'SUPER', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'SUPER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'SUPER', action = wezterm.action.ActivatePaneDirection 'Down' },

  -- Tab navigation
  { key = '[', mods = 'SUPER|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
  { key = ']', mods = 'SUPER|SHIFT', action = wezterm.action.ActivateTabRelative(1) },

  -- Tab renaming
  {
    key = 'r', mods = 'SUPER',
    action = wezterm.action.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line and line:len() > 0 then
          local tab = window:active_tab()
          if tab then
            tab:set_title(line)
          end
        end
      end),
    },
  },

  -- Font size adjustment (correct syntax)
  { key = '=', mods = 'SUPER', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'SUPER', action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'SUPER', action = wezterm.action.ResetFontSize },
}

return config
