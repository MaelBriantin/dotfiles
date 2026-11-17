local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Appearance
config.color_scheme = "Atom" -- Atom One Dark
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })
config.font_size = 16.0
config.line_height = 1.2

-- Transparency and blur
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

-- Tab bar configuration (Warp style)
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32
config.show_tab_index_in_tab_bar = false

-- Tab styling
config.colors = {
	tab_bar = {
		background = "#21252b",
		active_tab = {
			bg_color = "#282c34",
			fg_color = "#61afef",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#21252b",
			fg_color = "#5c6370",
		},
		inactive_tab_hover = {
			bg_color = "#2c313c",
			fg_color = "#abb2bf",
		},
		new_tab = {
			bg_color = "#21252b",
			fg_color = "#5c6370",
		},
		new_tab_hover = {
			bg_color = "#2c313c",
			fg_color = "#abb2bf",
		},
	},
	-- Fix fish autosuggestions (gray text)
	foreground = "#abb2bf",
	background = "#282c34",
	cursor_bg = "#528bff",
	cursor_border = "#528bff",
	cursor_fg = "#282c34",
	selection_bg = "#3e4451",
	selection_fg = "#abb2bf",

	ansi = {
		"#282c34", -- black
		"#e06c75", -- red
		"#98c379", -- green
		"#d19a66", -- yellow
		"#61afef", -- blue
		"#c678dd", -- magenta
		"#56b6c2", -- cyan
		"#abb2bf", -- white
	},
	brights = {
		"#5c6370", -- bright black (for fish suggestions)
		"#e06c75",
		"#98c379",
		"#e5c07b",
		"#61afef",
		"#c678dd",
		"#56b6c2",
		"#ffffff",
	},
}

-- Warp-style tab formatting
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#21252b"
	local foreground = "#5c6370"

	if tab.is_active then
		background = "#3e4451"
		foreground = "#61afef"
	elseif hover then
		background = "#2c313c"
		foreground = "#abb2bf"
	end

	local title = tab.active_pane.title

	-- Process-specific icons
	local process_icons = {
		["docker"] = "🐳 ",
		["docker-compose"] = "🐳 ",
		["nvim"] = "",
		["vim"] = "",
		["node"] = "",
		["zsh"] = "",
		["bash"] = "",
		["fish"] = "",
		["cargo"] = "🦀 ",
		["rustlings"] = "🦀 ",
		["git"] = "",
		["python"] = "🐍 ",
		["zed"] = "",
		["lazygit"] = "🗃️ ",
		["lazydocker"] = "🐳 ",
		["htop"] = "📊 ",
	}

	local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
	local icon = process_icons[process_name] or "  "

	-- Clean up the title - show directory name
	local cwd = tab.active_pane.current_working_dir
	if cwd then
		local path = cwd.file_path or ""
		title = path:match("([^/]+)$") or title
	end

	-- Format: icon + title with good spacing
	local formatted = string.format("  %s%s  ", icon, title)

	if #formatted > max_width then
		formatted = wezterm.truncate_right(formatted, max_width - 2) .. "… "
	end

	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
		{ Text = formatted },
	}
end)

-- Custom status bar
config.status_update_interval = 1000

wezterm.on("update-status", function(window, pane)
	local date = wezterm.strftime("%H:%M:%S")
	local cwd = pane:get_current_working_dir()
	local path = cwd and cwd.file_path or ""

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#7aa2f7" } },
		{ Text = "  " .. path .. " | " .. date .. " " },
	}))
end)

-- Keybindings (style tmux avec Ctrl+a)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Splits
	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Navigation entre panes
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },

	-- Resize panes
	{ key = "LeftArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "UpArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "DownArrow", mods = "LEADER", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },

	-- Fermer pane
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

	-- Nouveau tab
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },

	-- Changer de tab
	{ key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },

	-- Recherche
	{ key = "f", mods = "LEADER", action = wezterm.action.Search("CurrentSelectionOrEmptyString") },
}

-- Numéros de tabs (Ctrl+a puis 1, 2, 3...)
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- Performance
config.front_end = "WebGpu" -- ou 'OpenGL' si problèmes
config.max_fps = 120

-- Padding
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

return config
