local wezterm = require 'wezterm'

return {
  -- Font setup
  font_size = 14.0,

  -- Colors
  colors = {
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
  },

  -- Optional eye-candy
  window_background_opacity = 1,

  -- Window look & feel
  window_background_opacity = 1,
  macos_window_background_blur = 10, -- macOS-only blur effect
  hide_tab_bar_if_only_one_tab = true,

  -- Quality of life
  use_fancy_tab_bar = false,
  adjust_window_size_when_changing_font_size = false,

  -- Keybindings (mimic iTerm2 / macOS Terminal)
  keys = {
    { key="t", mods="SUPER", action=wezterm.action{SpawnTab="DefaultDomain"} },
    { key="w", mods="SUPER", action=wezterm.action{CloseCurrentTab={confirm=true}} },
    { key="d", mods="SUPER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}} },
    { key="d", mods="SUPER|SHIFT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}} },
    { key="LeftArrow", mods="SUPER", action=wezterm.action{ActivatePaneDirection="Left"} },
    { key="RightArrow", mods="SUPER", action=wezterm.action{ActivatePaneDirection="Right"} },
    { key="UpArrow", mods="SUPER", action=wezterm.action{ActivatePaneDirection="Up"} },
    { key="DownArrow", mods="SUPER", action=wezterm.action{ActivatePaneDirection="Down"} },
    {key="r", mods="SUPER", action=wezterm.action.PromptInputLine{
    description = "Enter new name for tab",
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }},
  },
}
