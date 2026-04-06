local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ─────────────────────────────────────────────────────────────
-- Section 1: Helpers
-- ─────────────────────────────────────────────────────────────

-- Package manager detection (prefers yarn > npm based on lock files)
local function pkg_run(script)
  return '{ if [ -f yarn.lock ]; then yarn ' .. script
    .. '; elif [ -f package-lock.json ]; then npm run ' .. script
    .. '; else echo "No lock file found (yarn.lock or package-lock.json)"; fi; }'
end

-- Tab pill shapes (Powerline half-circles from Nerd Font)
local LEFT_PILL = utf8.char(0xe0b6)    -- left half circle
local RIGHT_PILL = utf8.char(0xe0b4)   -- right half circle
local TAB_BAR_BG = '#101010'

-- Superscript digits for tab indices (visually smaller)
local SUPERSCRIPT = { '\u{00b9}', '\u{00b2}', '\u{00b3}', '\u{2074}', '\u{2075}', '\u{2076}', '\u{2077}', '\u{2078}', '\u{2079}' }

local function tab_index_label(n)
  return SUPERSCRIPT[n] or tostring(n)
end

local PROCESS_ICONS = {
  ['vim']    = ' ',
  ['nvim']   = ' ',
  ['node']   = ' ',
  ['python'] = ' ',
  ['python3'] = ' ',
  ['git']    = ' ',
  ['ssh']    = ' ',
  ['docker'] = ' ',
  ['npm']    = ' ',
  ['yarn']   = ' ',
  ['pnpm']   = ' ',
  ['cargo']  = ' ',
  ['go']     = ' ',
  ['ruby']   = ' ',
  ['lua']    = ' ',
  ['zsh']    = ' ',
  ['bash']   = ' ',
}

-- ─────────────────────────────────────────────────────────────
-- Section 2: Font
-- ─────────────────────────────────────────────────────────────

config.font = wezterm.font_with_fallback {
  { family = 'JetBrains Mono', weight = 'Regular' },
  'Symbols Nerd Font Mono',
}
config.font_size = 14.0
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

-- ─────────────────────────────────────────────────────────────
-- Section 3: Colors
-- ─────────────────────────────────────────────────────────────

config.colors = {
  foreground = '#afafaf',
  background = '#101010',
  cursor_bg = '#c7c7c7',
  cursor_border = '#c7c7c7',
  cursor_fg = '#101010',
  selection_bg = '#554c49',
  selection_fg = '#c3c7ca',

  ansi = {
    '#242627',
    '#e95384',
    '#bde25a',
    '#f2ab47',
    '#8fdcef',
    '#a98bf7',
    '#748387',
    '#d5d5d0',
  },

  brights = {
    '#636566',
    '#f086ac',
    '#cfec82',
    '#e9e091',
    '#8fdcef',
    '#a98bf7',
    '#b5c5c9',
    '#f9f9f5',
  },

  tab_bar = {
    background = '#101010',
    active_tab = {
      bg_color = '#2a2a2a',
      fg_color = '#eceff4',
    },
    inactive_tab = {
      bg_color = '#101010',
      fg_color = '#6c7086',
    },
    inactive_tab_hover = {
      bg_color = '#1a1a1a',
      fg_color = '#d8dee9',
    },
    new_tab = {
      bg_color = '#101010',
      fg_color = '#6c7086',
    },
    new_tab_hover = {
      bg_color = '#1a1a1a',
      fg_color = '#d8dee9',
    },
  },
}

-- ─────────────────────────────────────────────────────────────
-- Section 4: Window Appearance
-- ─────────────────────────────────────────────────────────────

config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.window_decorations = 'RESIZE'
config.native_macos_fullscreen_mode = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.tab_max_width = 32
config.adjust_window_size_when_changing_font_size = false

config.window_padding = {
  left = 20,
  right = 20,
  top = 20,
  bottom = 20,
}

-- Disable WezTerm's built-in libssh-rs domains
config.ssh_domains = {}

-- ─────────────────────────────────────────────────────────────
-- Section 6: Tab Bar Formatting
-- ─────────────────────────────────────────────────────────────

wezterm.on('format-tab-title', function(tab, tabs, panes, conf, hover, max_width)
  if not tab or not tab.active_pane then
    return { { Text = ' Terminal ' } }
  end

  local pane = tab.active_pane
  local process_name = pane.foreground_process_name or ''
  if process_name ~= '' then
    process_name = process_name:match('([^/]+)$') or process_name
  end

  local icon = PROCESS_ICONS[process_name] or ''
  local title = icon ~= '' and (icon .. ' ' .. process_name) or (pane.title or 'Terminal')

  -- Tab index (1-based, matches CMD+N shortcuts)
  local index = tab.tab_index + 1

  local pill_bg
  if tab.is_active then
    pill_bg = '#2a2a2a'
  elseif hover then
    pill_bg = '#1e1e1e'
  else
    pill_bg = '#161616'
  end

  local fg = tab.is_active and '#eceff4' or (hover and '#b0b0b0' or '#6c7086')

  local elements = {}

  -- Left rounded cap
  table.insert(elements, { Background = { Color = TAB_BAR_BG } })
  table.insert(elements, { Foreground = { Color = pill_bg } })
  table.insert(elements, { Text = LEFT_PILL })

  -- Pill body
  table.insert(elements, { Background = { Color = pill_bg } })

  -- Superscript index (turns purple when tab has unseen output)
  local has_unseen = pane.has_unseen_output and not tab.is_active
  local index_color = has_unseen and '#b086ac' or '#505050'
  table.insert(elements, { Foreground = { Color = index_color } })
  table.insert(elements, { Text = ' ' .. tab_index_label(index) })

  -- Title
  table.insert(elements, { Foreground = { Color = fg } })
  if tab.is_active then
    table.insert(elements, { Attribute = { Intensity = 'Bold' } })
  end
  table.insert(elements, { Text = title .. ' ' })
  if tab.is_active then
    table.insert(elements, { Attribute = { Intensity = 'Normal' } })
  end

  -- Right rounded cap
  table.insert(elements, { Background = { Color = TAB_BAR_BG } })
  table.insert(elements, { Foreground = { Color = pill_bg } })
  table.insert(elements, { Text = RIGHT_PILL })

  return elements
end)

-- ─────────────────────────────────────────────────────────────
-- Section 7: Right Status Bar
-- ─────────────────────────────────────────────────────────────

wezterm.on('update-right-status', function(window, pane)
  local elements = {}

  -- Git branch (from shell hook user var)
  local git_branch = pane:get_user_vars().git_branch or ''
  if git_branch ~= '' then
    table.insert(elements, { Foreground = { Color = '#a6da95' } })
    table.insert(elements, { Text = '  ' .. git_branch .. '  ' })
  end

  -- Active workspace (if not default)
  local workspace = window:active_workspace()
  if workspace ~= 'default' then
    table.insert(elements, { Foreground = { Color = '#8aadf4' } })
    table.insert(elements, { Text = '  ' .. workspace .. '  ' })
  end

  -- Battery (Nerd Font icons)
  for _, b in ipairs(wezterm.battery_info()) do
    if b.state_of_charge then
      local charge = math.floor(b.state_of_charge * 100)
      local icon

      if b.state == 'Charging' then
        icon = '󰂄'
      elseif charge >= 90 then
        icon = '󰁹'
      elseif charge >= 70 then
        icon = '󰂁'
      elseif charge >= 50 then
        icon = '󰁿'
      elseif charge >= 30 then
        icon = '󰁽'
      elseif charge >= 10 then
        icon = '󰁻'
      else
        icon = '󰂃'
      end

      local color = charge < 15 and '#e05561' or '#6c7086'
      table.insert(elements, { Foreground = { Color = color } })
      table.insert(elements, { Text = icon .. ' ' .. charge .. '%%  ' })
    end
  end

  -- Time
  table.insert(elements, { Foreground = { Color = '#6c7086' } })
  table.insert(elements, { Text = wezterm.strftime '%H:%M ' })

  window:set_right_status(wezterm.format(elements))
end)

-- ─────────────────────────────────────────────────────────────
-- Section 8: Auto-maximize on monitor move
-- ─────────────────────────────────────────────────────────────
-- Tracks which windows the user has maximized (via cmd+m).
-- When a tracked window moves to a screen with different DPI,
-- it re-maximizes to fill the new screen automatically.

local maximized_windows = {}  -- window_id -> true
local last_dpi = {}           -- window_id -> last known DPI

wezterm.on('window-resized', function(window, pane)
  local id = window:window_id()
  local dims = window:get_dimensions()

  if not maximized_windows[id] then
    last_dpi[id] = dims.dpi
    return
  end

  local prev_dpi = last_dpi[id]
  last_dpi[id] = dims.dpi

  if prev_dpi and prev_dpi ~= dims.dpi then
    window:maximize()
  end
end)

-- ─────────────────────────────────────────────────────────────
-- Section 9: Keybindings
-- ─────────────────────────────────────────────────────────────

config.keys = {
  -- Tab management
  { key = 't', mods = 'SUPER', action = act.SpawnTab 'DefaultDomain' },
  { key = 'w', mods = 'SUPER', action = act.CloseCurrentTab { confirm = true } },

  -- Pane splitting
  { key = 'd', mods = 'SUPER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'SUPER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = '\\', mods = 'SUPER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '\\', mods = 'SUPER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Pane navigation (arrow keys)
  { key = 'UpArrow', mods = 'SUPER', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'SUPER', action = act.ActivatePaneDirection 'Down' },

  -- Pane navigation (vim-style)
  { key = 'h', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection 'Down' },

  -- Pane resizing (arrow keys)
  { key = 'LeftArrow', mods = 'SUPER|ALT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'SUPER|ALT', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow', mods = 'SUPER|ALT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow', mods = 'SUPER|ALT', action = act.AdjustPaneSize { 'Down', 5 } },

  -- Pane resizing (vim-style)
  { key = 'h', mods = 'SUPER|ALT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'l', mods = 'SUPER|ALT', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'k', mods = 'SUPER|ALT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'j', mods = 'SUPER|ALT', action = act.AdjustPaneSize { 'Down', 5 } },

  -- Pane zoom (tmux-style)
  { key = 'z', mods = 'SUPER', action = act.TogglePaneZoomState },

  -- Close pane (not tab)
  { key = 'w', mods = 'SUPER|SHIFT', action = act.CloseCurrentPane { confirm = true } },

  -- Tab navigation
  { key = '{', mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = '}', mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(1) },

  -- Direct tab switching (CMD+1 through CMD+8)
  { key = '1', mods = 'SUPER', action = act.ActivateTab(0) },
  { key = '2', mods = 'SUPER', action = act.ActivateTab(1) },
  { key = '3', mods = 'SUPER', action = act.ActivateTab(2) },
  { key = '4', mods = 'SUPER', action = act.ActivateTab(3) },
  { key = '5', mods = 'SUPER', action = act.ActivateTab(4) },
  { key = '6', mods = 'SUPER', action = act.ActivateTab(5) },
  { key = '7', mods = 'SUPER', action = act.ActivateTab(6) },
  { key = '8', mods = 'SUPER', action = act.ActivateTab(7) },

  -- Tab renaming
  {
    key = 'r', mods = 'SUPER',
    action = act.PromptInputLine {
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

  -- Workspace management
  { key = 'n', mods = 'SUPER|SHIFT', action = act.SwitchWorkspaceRelative(1) },
  { key = 'p', mods = 'SUPER|SHIFT', action = act.SwitchWorkspaceRelative(-1) },
  {
    key = 'c', mods = 'SUPER|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter workspace name',
      action = wezterm.action_callback(function(window, pane, line)
        if line and line:len() > 0 then
          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
        end
      end),
    },
  },
  { key = 'w', mods = 'SUPER|ALT', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  { key = '9', mods = 'SUPER', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS' } },

  -- SSH host picker (Tailscale tagged devices via tssh)
  {
    key = 's', mods = 'SUPER|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      pane:send_text('tssh\n')
    end),
  },

  -- Font size
  { key = '=', mods = 'SUPER', action = act.IncreaseFontSize },
  { key = '-', mods = 'SUPER', action = act.DecreaseFontSize },
  { key = '0', mods = 'SUPER', action = act.ResetFontSize },

  -- Utilities
  { key = 'k', mods = 'SUPER', action = act.ClearScrollback 'ScrollbackAndViewport' },
  { key = 'f', mods = 'SUPER', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'u', mods = 'SUPER', action = act.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },

  -- Copy mode
  { key = 'Enter', mods = 'ALT', action = act.ActivateCopyMode },

  -- Fullscreen
  { key = 'Enter', mods = 'SUPER', action = act.ToggleFullScreen },

  -- Claude Code: Shift+Enter inserts newline instead of submitting
  { key = 'Enter', mods = 'SHIFT', action = act.SendString '\x1b\r' },

  -- Option+Left/Right: skip words (readline word navigation)
  { key = 'LeftArrow',  mods = 'OPT', action = act.SendString '\x1bb' },
  { key = 'RightArrow', mods = 'OPT', action = act.SendString '\x1bf' },

  -- Cmd+Left/Right: go to start/end of line
  { key = 'LeftArrow',  mods = 'SUPER', action = act.SendString '\x01' },
  { key = 'RightArrow', mods = 'SUPER', action = act.SendString '\x05' },

  -- Maximize window (remembered: auto-re-maximizes when moved to another monitor)
  { key = 'm', mods = 'SUPER', action = wezterm.action_callback(function(window, pane)
    local id = window:window_id()
    maximized_windows[id] = true
    last_dpi[id] = window:get_dimensions().dpi
    window:maximize()
  end) },

  -- Git actions (fuzzy picker)
  {
    key = 'g', mods = 'SUPER|SHIFT',
    action = act.InputSelector {
      title = '  Git Actions',
      choices = {
        { label = '  Pull (rebase)' },
        { label = '  Checkout master' },
        { label = '  Remaster' },
        { label = '  Status' },
        { label = '  Reset --hard' },
      },
      action = wezterm.action_callback(function(window, pane, id, label)
        if not label then return end
        local commands = {
          ['  Pull (rebase)']     = 'git pull -r',
          ['  Checkout master']   = 'git checkout master',
          ['  Remaster']          = 'git remaster',
          ['  Status']            = 'git status',
        }
        if label == '  Reset --hard' then
          window:perform_action(act.InputSelector {
            title = '⚠️  Confirm git reset --hard? This discards all local changes.',
            choices = {
              { label = 'Yes, reset' },
              { label = 'Cancel' },
            },
            action = wezterm.action_callback(function(w, p, _, confirm)
              if confirm == 'Yes, reset' then
                p:send_text('git reset --hard\n')
              end
            end),
          }, pane)
        else
          local cmd = commands[label]
          if cmd then pane:send_text(cmd .. '\n') end
        end
      end),
    },
  },

  -- Package script runner (auto-detects yarn/npm)
  {
    key = 'r', mods = 'SUPER|SHIFT',
    action = act.InputSelector {
      title = '  Run Script',
      choices = {
        { label = '  dev' },
        { label = '  build' },
        { label = '  build:modern' },
        { label = '  start' },
        { label = '  format' },
        { label = '  lint' },
        { label = '  ci (npm only)' },
        { label = '  install --frozen-lockfile (yarn only)' },
      },
      action = wezterm.action_callback(function(window, pane, id, label)
        if not label then return end
        local scripts = {
          ['  dev']          = pkg_run('dev'),
          ['  build']        = pkg_run('build'),
          ['  build:modern'] = pkg_run('build:modern'),
          ['  start']        = pkg_run('start'),
          ['  format']       = pkg_run('format'),
          ['  lint']         = pkg_run('lint'),
          ['  ci (npm only)'] = 'npm ci',
          ['  install --frozen-lockfile (yarn only)'] = 'yarn install --frozen-lockfile',
        }
        local cmd = scripts[label]
        if cmd then pane:send_text(cmd .. '\n') end
      end),
    },
  },

  -- macOS shortcuts
  { key = 'q', mods = 'SUPER', action = act.QuitApplication },
  { key = 'h', mods = 'SUPER', action = act.HideApplication },
  { key = 'n', mods = 'SUPER', action = act.SpawnWindow },
}

-- ─────────────────────────────────────────────────────────────
-- Section 10: Mouse Bindings
-- ─────────────────────────────────────────────────────────────

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  {
    event = { Up = { streak = 1, button = 'Middle' } },
    mods = 'NONE',
    action = act.PasteFrom 'PrimarySelection',
  },
}

-- ─────────────────────────────────────────────────────────────
-- Section 11: Command Palette
-- ─────────────────────────────────────────────────────────────

wezterm.on('augment-command-palette', function(window, pane)
  local commands = {}

  -- Workspaces
  local workspaces = { 'main', 'dev', 'ops', 'personal', 'projects' }
  for _, ws in ipairs(workspaces) do
    table.insert(commands, {
      brief = 'Switch to ' .. ws .. ' workspace',
      action = act.SwitchToWorkspace { name = ws },
    })
  end

  -- Git actions
  local git_actions = {
    { brief = 'Git: Pull (rebase)',     cmd = 'git pull -r' },
    { brief = 'Git: Checkout master',   cmd = 'git checkout master' },
    { brief = 'Git: Remaster',          cmd = 'git remaster' },
    { brief = 'Git: Status',            cmd = 'git status' },
  }
  for _, g in ipairs(git_actions) do
    table.insert(commands, {
      brief = g.brief,
      action = wezterm.action_callback(function(win, p)
        p:send_text(g.cmd .. '\n')
      end),
    })
  end

  table.insert(commands, {
    brief = 'Git: Reset --hard',
    action = act.InputSelector {
      title = '⚠️  Confirm git reset --hard? This discards all local changes.',
      choices = {
        { label = 'Yes, reset' },
        { label = 'Cancel' },
      },
      action = wezterm.action_callback(function(w, p, _, confirm)
        if confirm == 'Yes, reset' then
          p:send_text('git reset --hard\n')
        end
      end),
    },
  })

  -- Package scripts (auto-detects yarn/npm)
  local pkg_scripts = { 'dev', 'build', 'build:modern', 'start', 'format', 'lint' }
  for _, script in ipairs(pkg_scripts) do
    table.insert(commands, {
      brief = 'Run: ' .. script,
      action = wezterm.action_callback(function(win, p)
        p:send_text(pkg_run(script) .. '\n')
      end),
    })
  end

  table.insert(commands, {
    brief = 'Run: ci (npm only)',
    action = wezterm.action_callback(function(win, p)
      p:send_text('npm ci\n')
    end),
  })

  table.insert(commands, {
    brief = 'Run: install --frozen-lockfile (yarn only)',
    action = wezterm.action_callback(function(win, p)
      p:send_text('yarn install --frozen-lockfile\n')
    end),
  })

  -- macOS integration
  table.insert(commands, {
    brief = 'Open Finder here',
    action = wezterm.action_callback(function(win, p)
      p:send_text('open .\n')
    end),
  })

  table.insert(commands, {
    brief = 'Reveal in Finder',
    action = wezterm.action_callback(function(win, p)
      p:send_text('open -R .\n')
    end),
  })

  table.insert(commands, {
    brief = 'Copy current path',
    action = wezterm.action_callback(function(win, p)
      p:send_text('pwd | pbcopy\n')
    end),
  })

  return commands
end)

-- ─────────────────────────────────────────────────────────────
-- Section 13: Hyperlink Rules
-- ─────────────────────────────────────────────────────────────

config.hyperlink_rules = {
  { regex = [[\bhttps?://\S+\b]], format = '$0' },
  { regex = [[/[^\s]+]], format = '$0' },
  { regex = [[\b[0-9a-f]{7,40}\b]], format = 'https://github.com/search?q=$0&type=commits' },
}

-- ─────────────────────────────────────────────────────────────
-- Section 14: Performance & Misc
-- ─────────────────────────────────────────────────────────────

config.front_end = 'WebGpu'
config.enable_kitty_graphics = true

-- Quick select: press SUPER+SHIFT+Space to highlight and copy patterns
config.quick_select_patterns = {
  -- URLs
  'https?://[\\w./?=&#%-]+',
  -- Git SHAs
  '[0-9a-f]{7,40}',
  -- File paths
  '[/~][\\w./%-]+',
  -- IP addresses
  '\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}',
  -- GitHub PR / issue refs
  '#\\d+',
  -- npm package versions (semver)
  '\\d+\\.\\d+\\.\\d+',
}
config.webgpu_power_preference = 'HighPerformance'
config.max_fps = 120
config.animation_fps = 60
config.scrollback_lines = 50000
config.enable_scroll_bar = true
config.window_close_confirmation = 'AlwaysPrompt'

-- Bell (visual only)
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
  target = 'CursorColor',
}

-- Ensure Homebrew is on PATH
config.set_environment_variables = {
  PATH = '/opt/homebrew/bin:/opt/homebrew/sbin:' .. os.getenv('PATH'),
}

return config
