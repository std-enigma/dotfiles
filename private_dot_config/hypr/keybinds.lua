--- Variables ---
local mainMod = "SUPER"
local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- "

--- Window Management ---

-- Window Manipulation
-- TODO: Add hyprland shutdown keybinding
hl.bind(mainMod .. " + W", hl.dsp.window.float(), { desc = "Toggle floating" })
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { desc = "Toggle split" })
hl.bind(mainMod .. " + SHIFT + F", function()
	local active_window = hl.get_active_window()
	if not active_window then
		return
	end

	local is_floating = active_window.floating
	local is_pinned = active_window.pinned

	if not is_floating and not is_pinned then
		hl.dispatch(hl.dsp.window.float())
	end

	hl.dispatch(hl.dsp.window.pin())

	if is_floating and is_pinned then
		hl.dispatch(hl.dsp.window.float())
	end
end, { desc = "Toggle pin on focused window" })
hl.bind("SHIFT + F11", hl.dsp.window.fullscreen(), { desc = "Toggle fullscreen" })
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { desc = "Close focused window" })
hl.bind("ALT + F4", hl.dsp.window.kill(), { desc = "Force-kill focused window" })

-- Window Navigation
hl.bind(mainMod .. " + Left", hl.dsp.focus({ direction = "left" }), { desc = "Focus left" })
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }), { desc = "Focus right" })
hl.bind(mainMod .. " + Up", hl.dsp.focus({ direction = "up" }), { desc = "Focus up" })
hl.bind(mainMod .. " + Down", hl.dsp.focus({ direction = "down" }), { desc = "Focus down" })
hl.bind("ALT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end, { desc = "Cycle focus" })
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd(noctCall .. "window-switcher"), { desc = "Window switcher" })

-- Window Resizing
hl.bind(
	mainMod .. " + SHIFT + Left",
	hl.dsp.window.resize({ x = -30, y = 0, relative = true }),
	{ repeating = true, desc = "Resize window left" }
)
hl.bind(
	mainMod .. " + SHIFT + Right",
	hl.dsp.window.resize({ x = 30, y = 0, relative = true }),
	{ repeating = true, desc = "Resize window right" }
)
hl.bind(
	mainMod .. " + SHIFT + Up",
	hl.dsp.window.resize({ x = 0, y = -30, relative = true }),
	{ repeating = true, desc = "Resize window up" }
)
hl.bind(
	mainMod .. " + SHIFT + Down",
	hl.dsp.window.resize({ x = 0, y = 30, relative = true }),
	{ repeating = true, desc = "Resize window down" }
)
hl.bind(mainMod .. " + Z", hl.dsp.window.resize(), { mouse = true, desc = "Hold to resize window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, desc = "Hold to resize window" })

-- Window Arrangement
hl.bind(mainMod .. " + SHIFT + CONTROL + Left", function()
	local active_window = hl.get_active_window()
	if not active_window then
		return
	end
	local args = active_window.floating and { x = -30, y = 0, relative = true } or { direction = "left" }
	hl.dispatch(hl.dsp.window.move(args))
end, { repeating = true, desc = "Move focused window left" })
hl.bind(mainMod .. " + SHIFT + CONTROL + Right", function()
	local active_window = hl.get_active_window()
	if not active_window then
		return
	end
	local args = active_window.floating and { x = 30, y = 0, relative = true } or { direction = "right" }
	hl.dispatch(hl.dsp.window.move(args))
end, { repeating = true, desc = "Move focused window right" })
hl.bind(mainMod .. " + SHIFT + CONTROL + Up", function()
	local active_window = hl.get_active_window()
	if not active_window then
		return
	end
	local args = active_window.floating and { x = 0, y = -30, relative = true } or { direction = "up" }
	hl.dispatch(hl.dsp.window.move(args))
end, { repeating = true, desc = "Move focused window up" })
hl.bind(mainMod .. " + SHIFT + CONTROL + Down", function()
	local active_window = hl.get_active_window()
	if not active_window then
		return
	end
	local args = active_window.floating and { x = 0, y = 30, relative = true } or { direction = "down" }
	hl.dispatch(hl.dsp.window.move(args))
end, { repeating = true, desc = "Move focused window down" })
hl.bind(mainMod .. " + X", hl.dsp.window.drag(), { mouse = true, desc = "Hold to move window" })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, desc = "Hold to move window" })

-- Window Grouping
hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { desc = "Toggle group" })
hl.bind(mainMod .. " + CTRL + H", hl.dsp.group.prev(), { desc = "Switch to the previous active group" })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.group.next(), { desc = "Switch to the next active group" })

--- Workspace Management ---

-- Workspace Navigation
hl.bind(mainMod .. " + CONTROL + Left", hl.dsp.focus({ workspace = "r-1" }), { desc = "Go to previous workspace" })
hl.bind(mainMod .. " + CONTROL + Right", hl.dsp.focus({ workspace = "r+1" }), { desc = "Go to next workspace" })
hl.bind(
	mainMod .. " + CONTROL + Down",
	hl.dsp.focus({ workspace = "empty" }),
	{ desc = "navigate to the nearest empty workspace" }
)
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { desc = "Next workspace" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { desc = "Previous workspace" })
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { desc = "Navigate to workspace " .. i })
end

-- Move Windows Between Workspaces
hl.bind(
	mainMod .. " + CONTROL + ALT + Left",
	hl.dsp.window.move({ workspace = "r-1" }),
	{ desc = "Move focused window to previous workspace" }
)
hl.bind(
	mainMod .. " + CONTROL + ALT + Right",
	hl.dsp.window.move({ workspace = "r+1" }),
	{ desc = "Move focused window to next workspace" }
)
for i = 1, 10 do
	local key = i % 10
	hl.bind(
		mainMod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ desc = "Move focused window to workspace " .. i }
	)
	hl.bind(
		mainMod .. " + ALT + " .. key,
		hl.dsp.window.move({ workspace = i, follow = false }),
		{ desc = "Move focused window to workspace " .. i .. " (silent)" }
	)
end

-- Scratchpad
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }), { desc = "Move to scratchpad" })
hl.bind(
	mainMod .. " + ALT + S",
	hl.dsp.window.move({ workspace = "special", follow = false }),
	{ desc = "Move to scratchpad (silent)" }
)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special(), { desc = "Toggle scratchpad" })

--- Hardware Controls ---

-- Audio
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(noctCall .. "volume-up"),
	{ locked = true, repeating = true, desc = "Increase volume" }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(noctCall .. "volume-down"),
	{ locked = true, repeating = true, desc = "Decrease volume" }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noctCall .. "volume-mute"), { locked = true, desc = "Toggle output mute" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(noctCall .. "mic-mute"), { locked = true, desc = "Toggle microphone mute" })
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(noctCall .. "mic-mute"), { locked = true, desc = "Toggle microphone mute" })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(noctCall .. "media toggle"), { locked = true, desc = "Toggle media playback" })
hl.bind(
	"XF86AudioPause",
	hl.dsp.exec_cmd(noctCall .. "media toggle"),
	{ locked = true, desc = "Toggle media playback" }
)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(noctCall .. "media next"), { locked = true, desc = "Play next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true, desc = "Play previous track" })

-- Brightness
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(noctCall .. "brightness-up"),
	{ locked = true, repeating = true, desc = "Increase brightness" }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(noctCall .. "brightness-down"),
	{ locked = true, repeating = true, desc = "Decrease brightness" }
)

--- Apps & Launchers ---
-- TODO: Add a floating terminal binding (use pyprland maybe?)
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(launchPrefix .. TERMINAL), { desc = "Launch terminal emulator" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER), { desc = "Launch file manager" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(launchPrefix .. BROWSER), { desc = "Launch web browser" })
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"), { desc = "Toggle app launcher" })
hl.bind(
	mainMod .. " + C",
	hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"),
	{ desc = "Toggle control-center" }
)
hl.bind(mainMod .. " + COMMA", hl.dsp.exec_cmd(noctCall .. "settings-toggle"), { desc = "Toggle settings" })
hl.bind(
	"CONTROL + SHIFT + ESCAPE",
	hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center system"),
	{ desc = "Toggle system monitor" }
)
hl.bind("CONTROL + ALT + DELETE", hl.dsp.exec_cmd(noctCall .. "panel-toggle session"), { desc = "Toggle logout menu" })
hl.bind(
	mainMod .. " + PERIOD",
	hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"),
	{ desc = "Toggle emoji picker" }
)

--- Utilities ---

-- Keyboard layout
-- TODO: Add game-mode keybinding (use pyrpland maybe?)
hl.bind(
	mainMod .. " + K",
	hl.dsp.exec_cmd("hyprctl switchxkblayout all next"),
	{ locked = true, desc = "Cycle keyboard layout" }
)

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"), { desc = "Toggle clipboard" })

-- Notifications
hl.bind(
	mainMod .. " + SHIFT + N",
	hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center notifications"),
	{ desc = "Toggle notification-center" }
)

-- Screen Capture
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -an"), { locked = true, desc = "Pick a screen color" })
hl.bind(
	mainMod .. " + P",
	hl.dsp.exec_cmd(noctCall .. "screenshot-region"),
	{ locked = true, desc = "Capture a screen region" }
)
hl.bind(
	mainMod .. " + ALT + P",
	hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"),
	{ locked = true, desc = "Capture the current monitor" }
)
hl.bind(
	"Print",
	hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen all"),
	{ locked = true, desc = "Capture all monitors" }
)

--- Theming & Wallpaper ---
hl.bind(
	mainMod .. " + SHIFT + W",
	hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /wall"),
	{ desc = "Select a wallpaper" }
)
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(noctCall .. "panel-toggle wallpaper"), { desc = "Select a theme" })

--- Miscellaneous ---
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(noctCall .. "session lock"), { desc = "Lock session" })
