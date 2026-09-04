-- ~/.config/hypr/hyprland.lua
-- Migrated from hyprland.conf. Noctalia wired in (replaces Waybar).
hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprland-session.target")
	hl.exec_cmd("/usr/libexec/xdg-desktop-portal-hyprland -r")
	hl.exec_cmd("sleep 1 && /usr/libexec/xdg-desktop-portal-gtk")
	hl.exec_cmd("noctalia")
	hl.exec_cmd("hyprpaper -c ~/.config/hypr/hyprpaper.conf")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("eval $(ssh-agent)")
	--	hl.exec_cmd("steam")
	--hl.exec_cmd("vmware")
	--hl.exec_cmd("obsidian")
	--hl.exec_cmd("blueman-manager")
	--	hl.exec_cmd("google-chrome")
	--	hl.exec_cmd("flatpak run org.signal.Signal")
	--hl.exec_cmd("discord")
end)
-----------------
---- MONITOR ----
-----------------
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@144.00Hz",
	position = "",
	scale = 1,
})
hl.monitor({
	output = "DP-7",
	mode = "3440x1440",
	position = "0x0",
	scale = 1,
})
hl.monitor({
	output = "DP-5",
	mode = "1920x1080",
	scale = 1,
	transform = 3,
})

------------------
---- PROGRAMS ----
------------------
local mainMod = "SUPER"
local secondMod = "SUPER + SHIFT"
local terminal = "alacritty"
local fileManager = "nautilus"
local music = "spotify"
local browser = "firefox"
local menu = "rofi -show run -show-icons"
local ipc = "noctalia msg"
--hl.window_rule({
--	match = { class = "^steam$", title = "^$" },
-- no_initial_focus = true,
-- suppress_event = "activate",
--	stay_focused = true,
--	min_size = "1 1",
--})
---------------
---- INPUT ----
---------------
hl.config({
	input = {
		follow_mouse = 1,
		mouse_refocus = false,
		kb_layout = "se",
	},
})

-----------------------
---- LOOK AND FEEL ----   -- Noctalia recommended
-----------------------
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 3,
	},
	decoration = {
		rounding = 10,
		rounding_power = 2,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},
		blur = {
			passes = 2,
			vibrancy = 0.1696,
		},
	},
})
-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprland-session.target")
	hl.exec_cmd("/usr/libexec/xdg-desktop-portal-hyprland -r")
	hl.exec_cmd("sleep 1 && /usr/libexec/xdg-desktop-portal-gtk")
	hl.exec_cmd("noctalia")
	hl.exec_cmd("hyprpaper -c ~/.config/hypr/hyprpaper.conf")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("eval $(ssh-agent)")
	--	hl.exec_cmd("steam")
	hl.exec_cmd("vmware")
	hl.exec_cmd("obsidian")
	hl.exec_cmd("blueman-manager")
	--	hl.exec_cmd("google-chrome")
	--	hl.exec_cmd("flatpak run org.signal.Signal")
	hl.exec_cmd("discord")
end)

---------------------
---- KEYBINDINGS ----
---------------------
hl.bind(secondMod .. " + W ", hl.dsp.submap("passthrough"))
hl.define_submap("passthrough", function()
	hl.bind(secondMod .. " + E", hl.dsp.submap("reset"))
end)
-- Apps
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(secondMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(music))

hl.bind(secondMod .. " + R", hl.dsp.exec_cmd("pkill -f quickshell; sleep 0.3; qs -c noctalia-shell & disown"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("hyprlock"))
hl.bind(secondMod .. " + S", hl.dsp.exec_cmd("hyprshot -m region -o /home/sweetboopd/Pictures/"))
-- clipboard history (moved off ALT+V to avoid clash with float toggle below)
hl.bind(secondMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

-- Window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(secondMod .. " + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(secondMod .. " + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(secondMod .. " + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(secondMod .. " + down", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Exit / shutdown
hl.bind(
	secondMod .. " + Q",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

-- Workspaces: ALT + [1-9] switch, ALT + SHIFT + [1-9] move window there
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(secondMod .. " + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Noctalia shell
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(ipc .. " settings-toggle"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. " brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness-down"))

------------------------------
---- PERSISTENT WORKSPACES ----
------------------------------
hl.workspace_rule({ workspace = "1", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "6", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "7", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "8", monitor = "eDP-1", persistent = true })
hl.workspace_rule({ workspace = "9", monitor = "eDP-1", persistent = true })

-------------------------------
---- NOCTALIA SURFACE BLUR ----
-------------------------------
hl.layer_rule({
	name = "noctalia",
	match = {
		namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
	},
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})
