-- Generic floating position
hl.window_rule({ match = { float = true }, center = true, persistent_size = true })

-- Picture-in-Picture
hl.window_rule({
	match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
	float = true,
	keep_aspect_ratio = true,
	size = { "max(monitor_w, monitor_h)*0.25", "min(monitor_w, monitor_h)*0.25" },
	pin = true,
})

-- Gaming
local gamingApps = "^(steam.*|steam_app.*|gamescope)$"
local gamingWorkspace = "name:gaming"

hl.window_rule({ match = { content = "game" }, workspace = gamingWorkspace })
hl.window_rule({
	match = { xdg_tag = "^(.*game.*)$" },
	workspace = gamingWorkspace,
	fullscreen_state = 2,
	content = "game",
	sync_fullscreen = true,
})
hl.window_rule({ match = { class = gamingApps }, workspace = gamingWorkspace })
hl.window_rule({ match = { class = "^(steam)$", title = "^(Friends List)$" }, float = true })
hl.window_rule({
	match = { class = "^(steam)$", title = "^(Launching\\.{3})$" },
	float = true,
	center = true,
	workspace = gamingWorkspace,
})
hl.window_rule({
	match = {
		class = gamingApps,
		title = "^(.+)$",
		initial_title = "negative:^(.*\\\\home\\\\.*)$",
	},
	content = "game",
	decorate = false,
	fullscreen_state = 2,
	size = { "monitor_w", "monitor_h" },
	sync_fullscreen = true,
})
hl.window_rule({
	match = {
		class = "^(steam_app.*)$",
		initial_title = "^$",
	},
	center = true,
	float = true,
	fullscreen = false,
	fullscreen_state = 0,
	workspace = gamingWorkspace,
})

-- Apps
hl.window_rule({
	match = { class = "^(.*\\.exe)$", float = true },
	center = true,
	fullscreen_state = 0,
})
hl.window_rule({ match = { class = "^(.*[Ll]auncher.*)$" }, float = true })
hl.window_rule({
	match = { class = "^(.*[Cc]alc.*)$" },
	float = true,
	size = { "max(monitor_w, monitor_h)*0.17", "min(monitor_w, monitor_h)*0.43" },
})
hl.window_rule({ match = { class = "^(org\\.kde\\.keditfiletype)$" }, float = true })
hl.window_rule({
	match = { class = "^(org\\.kde\\.ark)$" },
	size = { "max(monitor_w, monitor_h)*0.40", "min(monitor_w, monitor_h)*0.40" },
})
hl.window_rule({
	match = { class = "^(.*satty.*)$", title = "^(Satty)$" },
	min_size = { "max(monitor_w, monitor_h)*0.35", "min(monitor_w, monitor_h)*0.35" },
	float = true,
})
hl.window_rule({
	match = { class = "^(dev\\.)?(noctalia\\.Noctalia(\\.Settings)?)$" },
	float = true,
	size = { "monitor_w*0.70", "monitor_h*0.70" },
})
hl.window_rule({
	match = {
		class = "^(org\\.kde\\.dolphin)$",
		title = "negative:^(Moving.*|Create New.*|Extract.*|Compress.*|Copying.*|Progress.*|Configure.*|Properties.*|Choose\\sApplication.*)$",
	},
	float = true,
	size = { "max(monitor_w, monitor_h)*0.50", "min(monitor_w, monitor_h)*0.55" },
})

-- Opacity Overrides
local terminals = "^(kitty|ghostty|[Kk]onsole|Alacritty|gnome-terminal|xfce[0-9]?-terminal)$"

hl.window_rule({ match = { class = "^(firefox|zen)$" }, opacity = "1.0 override" })
hl.window_rule({ match = { class = terminals }, opacity = "1.0 override" }) -- Override opacity in favor of terminal settings for opacity. If your terminal doesn't support transparency, you can remove this rule.
hl.window_rule({
	match = { class = "^(mpv|org.kde.haruna|.*plex.*|org\\.kde\\.gwenview|.*vlc.*)$" },
	opacity = "1.0 override",
})

-- Float Utility Windows
local floatApps = {
	{ class = "^(kvantummanager|qt[56]ct|nwg-(look|displays))$" },
	{ class = "^(org.pulseaudio.pavucontrol|pavucontrol-qt|blueman-manager|nm-applet|nm-connection-editor)$" },
	{ class = "^(Bitwarden|org.keepassxc.KeePassXC|hyprpolkitagent|console-dropdown|com\\.gabm\\.satty)$" },
	{ title = "^(Winetricks.*|Protontricks.*)$" },
}
for _, m in ipairs(floatApps) do
	hl.window_rule({
		match = m,
		float = true,
		size = { "max(monitor_w, monitor_h)*0.50", "min(monitor_w, monitor_h)*0.55" },
	})
end

-- Float Common Modals
local modalMatches = {
	{
		title = "^(Open|Authentication Required|Add Folder to Workspace|Choose Files|Save As|Confirm to replace files|File Operation Progress|File Upload.*|Choose wallpaper.*|Library.*)$",
	},
	{ title = "^(Open File|Save As.*|Volume Control)$" },
	{ initial_title = "^(Open File|Save As.*)$" },
	{ class = "^([Xx]dg-desktop-portal-gtk|org\\.freedesktop\\.impl\\.portal\\.desktop\\.(hyprland|gtk))$" },
	{ class = "^(.*dialog.*)$" },
	{ title = "^(.*dialog.*)$" },
	{ class = "^(hyprland-share-picker)$" },
}
for _, m in ipairs(modalMatches) do
	hl.window_rule({ match = m, float = true })
end

-- PIN entry / strict auth dialogs: always centered and pinned
hl.window_rule({
	match = { class = "^(pinentry-.*)$" },
	float = true,
	center = true,
	pin = true,
	fullscreen = false,
})

-- XWayland video bridge: send to a hidden special workspace, invisible & inert
hl.window_rule({
	name = "xwayland-video-bridge",
	match = { class = "^(xwaylandvideobridge)$" },
	float = true,
	no_focus = true,
	no_initial_focus = true,
	no_anim = true,
	no_blur = true,
	no_follow_mouse = true,
	max_size = { 1, 1 },
	opacity = 0.0,
	workspace = "special:xwayland_video_bridge silent",
})

-- Ignore maximize requests from all apps. You'll probably like this.
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
