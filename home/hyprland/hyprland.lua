-- vim:set ft=lua
-- Hyprland Modern Lua Configuration File

---------------------
---- MY PROGRAMS ----
---------------------

local browser = "firefox-nightly"
local terminal = "foot"
local mainMod = "SUPER"

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "eDP-1", mode = "highres", position = "auto", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("~/.local/bin/wallpaper-changer ~/Pictures/Wallpapers/")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("playerctld daemon")
	hl.exec_cmd("waybar")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("HYPRLAND_LOG_WLR", "1")
hl.env("HYPRCURSOR_THEME", "Catppuccin-Mocha-Maroon-Cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "catppuccin-mocha-maroon-cursors")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("GBM_BACKEND", "nvidia")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	cursor = {
		no_hardware_cursors = true,
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
		},
	},

	general = {
		gaps_in = 1,
		gaps_out = 5,
		border_size = 3,
		col = {
			active_border = { colors = { "rgba(7dcfffff)", "rgba(bb9af7ff)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
	},

	decoration = {
		rounding = 10,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			new_optimizations = true,
		},
	},

	dwindle = {
		preserve_split = true,
		smart_split = true,
	},

	master = {
		new_status = "master",
	},

	render = {
		new_render_scheduling = false,
	},

	-- plugin = {
	--     hy3 = {
	--         no_gaps_when_only = true,
	--         autotile = {
	--             enable = true,
	--         },
	--     },
	--     hyprwinwrap = {
	--         class = "kitty-bg",
	--     },
	-- },

	-- ["debug:disable_logs"] = false,
})

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

------------------
---- GESTURES ----
------------------

hl.gesture({
	fingers = 3,
	direction = "swipe",
	action = "workspace",
})

---------------------
---- KEYBINDINGS ----
---------------------

-- Main Modifier Core Actions
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("anyrun"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + G", function()
	local game_mode = (hl.get_config("animations.enabled") == false)

	if game_mode then
		hl.exec_cmd("hyprctl reload")
		return
	end

	hl.config({
		general = {
			gaps_in = 0,
			gaps_out = 0, -- Disable gaps
			border_size = 0,
		},

		animations = {
			enabled = false, -- Disable animations
		},

		-- Disable blur, shadow and window rounding
		decoration = {
			shadow = { enabled = false },
			blur = { enabled = false },
			rounding = 0,
		},
	})
end)

-- Focus manipulation
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Window Movement (Using layout commands or explicit moves depending on hy3 setup)
hl.bind(mainMod .. " + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.window.move({ direction = "right" }))

-- Workspaces 1-10 (Focus & Move)
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Functional extra workspaces 11-20
for i = 11, 20 do
	local key = "F" .. (i - 10)
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
end

-- Workspace Trackpad Actions
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse Drag Actions
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Extras & Pipeline Binds
hl.bind(
	mainMod .. " + p",
	hl.dsp.exec_cmd(
		"cliphist list | anyrun --plugins ~/.local/lib/libstdin.so --show-results-immediately true --max-entries 100  | cliphist decode | wl-copy"
	)
)
hl.bind(mainMod .. " + x", hl.dsp.exec_cmd('kill -USR1 $(pgrep "waybar")'))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast --notify copysave area"))

-- Audio Utilities & Display Controls
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.local/bin/progress_notify.sh audio toggle"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))

hl.bind(mainMod .. " + Z", hl.dsp.workspace.swap_monitors({ monitor1 = "HDMI-A-1", monitor2 = "eDP-1" }))

-- Repeatable Media Actions
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.local/bin/progress_notify.sh audio up"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.local/bin/progress_notify.sh audio down"), { repeating = true })
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("brightnessctl s 5%+ && ~/.local/bin/progress_notify.sh brightness"),
	{ repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("brightnessctl s 5%- && ~/.local/bin/progress_notify.sh brightness"),
	{ repeating = true }
)

-----------------
---- SUBMAPS ----
-----------------

hl.define_submap("resize", function()
	-- Set repeating binds for resizing the active window.
	hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
	hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
	hl.bind("up", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
	hl.bind("down", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })

	-- Use `reset` to go back to the global submap
	hl.bind("escape", hl.dsp.submap("reset"))
end)

-- Mapping the submap toggle trigger in global scope
hl.bind("ALT + R", hl.dsp.submap("resize"))

---------------------------
---- RULES & WORKSPACES ----
---------------------------

hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })

hl.window_rule({
	name = "kitty-bounce",
	match = { class = "^(kitty)$" },
	animation = "easeInBounce",
})

hl.window_rule({
	name = "code-opacity",
	match = { class = "^(Code)$" },
	opacity = "0.90 0.80",
})

hl.window_rule({
	name = "tiled-no-gaps-1",
	match = { float = false, workspace = "w[tv1]s[false]" },
	border_size = 0,
	rounding = 0,
})

hl.window_rule({
	name = "tiled-no-gaps-2",
	match = { float = false, workspace = "f[1]s[false]" },
	border_size = 0,
	rounding = 0,
})
