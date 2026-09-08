local var_mainMod = "SUPER"
local var_terminal = "kitty"
local var_fileManager = "thunar"
local var_menu = "kitty --class fsel --title fsel fsel --detach"
local var_browser = "zen-browser"

-- This is an example Hyprland config file.

-- Refer to the wiki for more information.

-- https://wiki.hyprland.org/Configuring/Configuring-Hyprland/

-- Please note not all available settings / options are set here.

-- For a full list, see the wiki

-- You can split this configuration into multiple files

-- Create your files separately and then link them to this file like this:

-- source = ~/.config/hypr/myColors.conf

-- ###############

-- ## MONITORS ###

-- ###############

-- See https://wiki.hyprland.org/Configuring/Monitors/
hl.monitor({
    output = "DP-2",
    disabled = false,
    mode = "2560x1440@165",
    position = "0x0",
    scale = 1,
})

-- monitor=HDMI-A-1, 1920x1080@60, -1080x0, 1, transform, 1
hl.monitor({
    output = "HDMI-A-1",
    disabled = false,
    mode = "1920x1080@60",
    position = "-1920x0",
    scale = 1,
})

-- ##################

-- ## MY PROGRAMS ###

-- ##################

-- See https://wiki.hyprland.org/Configuring/Keywords/

-- Set programs that you use

-- ################

-- ## AUTOSTART ###

-- ################

-- Autostart necessary processes (like notifications daemons, status bars, etc.)

-- Or execute your favorite apps at launch like this:

-- exec-once = $terminal

-- exec-once = nm-applet &
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & hyprpaper & swaync")
end)

-- ############################

-- ## ENVIRONMENT VARIABLES ###

-- ############################

-- See https://wiki.hyprland.org/Configuring/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("TERMINAL", "kitty")

-- ####################

-- ## LOOK AND FEEL ###

-- ####################

-- Refer to https://wiki.hyprland.org/Configuring/Variables/

-- https://wiki.hyprland.org/Configuring/Variables/#general
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,
    },
})

-- https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
hl.config({
    general = {
        col = {
            active_border = {
                colors = {"rgba(d580ffff)", "rgba(8000ffff)"},
                angle = 45,
            },
            inactive_border = "rgba(3d0073ee)",
        },
    },
})

-- Set to true enable resizing windows by clicking and dragging on borders and gaps
hl.config({
    general = {
        resize_on_border = false,
    },
})

-- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
hl.config({
    general = {
        allow_tearing = false,
        layout = "dwindle",
    },
})

-- https://wiki.hyprland.org/Configuring/Variables/#decoration
hl.config({
    decoration = {
        rounding = 10,
    },
})

-- # Change transparency of focused and unfocused windows
hl.config({
    decoration = {
        active_opacity = 1.0,
        inactive_opacity = 0.9,
    },
})

-- drop_shadow = true

-- shadow_range = 4

-- shadow_render_power = 3

-- col.shadow = rgba(1a1a1aee)

-- https://wiki.hyprland.org/Configuring/Variables/#blur
hl.config({
    decoration = {
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
})

-- https://wiki.hyprland.org/Configuring/Variables/#animations
hl.config({
    animations = {
        enabled = true,
    },
})

-- Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 7,
    bezier = "myBezier",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 7,
    bezier = "default",
    style = "popin 80%",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 10,
    bezier = "default",
})
hl.animation({
    leaf = "borderangle",
    enabled = true,
    speed = 8,
    bezier = "default",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 7,
    bezier = "default",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 6,
    bezier = "default",
})

-- See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- https://wiki.hyprland.org/Configuring/Variables/#misc
hl.config({
    misc = {
        vrr = 0,
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
})

-- ############

-- ## INPUT ###

-- ############

-- https://wiki.hyprland.org/Configuring/Variables/#input
hl.config({
    input = {
        kb_layout = "br",
        kb_variant = "",
        kb_model = "abnt2",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

-- https://wiki.hyprland.org/Configuring/Variables/#gestures

-- gestures {

-- workspace_swipe = false

-- }

-- Example per-device config

-- See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- ##################

-- ## KEYBINDINGS ###

-- ##################

-- See https://wiki.hyprland.org/Configuring/Keywords/

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
hl.bind(var_mainMod .. " + RETURN", hl.dsp.exec_cmd(var_terminal))
hl.bind(var_mainMod .. " + C", hl.dsp.window.close())
hl.bind(var_mainMod .. " + SHIFT + CTRL + M", hl.dsp.exit())
hl.bind(var_mainMod .. " + N", hl.dsp.exec_cmd(var_fileManager))
hl.bind(var_mainMod .. " + Y", hl.dsp.window.float({ action = "toggle" }))
hl.bind(var_mainMod .. " + space", hl.dsp.exec_cmd(var_menu))
hl.bind(var_mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(var_mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(var_mainMod .. " + B", hl.dsp.exec_cmd(var_browser))
hl.bind(var_mainMod .. " + SHIFT + CTRL + P", hl.dsp.exec_cmd("wlogout -b 4"))
hl.bind(var_mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(var_mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(var_mainMod .. " + S", hl.dsp.exec_cmd("steam-native"))
hl.bind(var_mainMod .. " + D", hl.dsp.exec_cmd("discord"))
hl.bind(var_mainMod .. " + H", hl.dsp.exec_cmd("heroic"))
hl.bind(var_mainMod .. " + K", hl.dsp.exec_cmd("keepassxc"))

-- Controle de Volume
hl.bind("SUPER + SHIFT + equal", hl.dsp.exec_cmd("~/.config/waybar/scripts/volume-control.sh up"), {
    repeating = true,
})
hl.bind("SUPER + SHIFT + minus", hl.dsp.exec_cmd("~/.config/waybar/scripts/volume-control.sh down"), {
    repeating = true,
})
hl.bind("SUPER + SHIFT + BackSpace", hl.dsp.exec_cmd("~/.config/waybar/scripts/volume-control.sh mute"))

-- Move focus with mainMod + arrow keys
hl.bind(var_mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(var_mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(var_mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(var_mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
hl.bind(var_mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(var_mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(var_mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(var_mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(var_mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(var_mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(var_mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(var_mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(var_mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(var_mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(var_mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(var_mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(var_mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(var_mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(var_mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(var_mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(var_mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(var_mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(var_mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(var_mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Example special workspace (scratchpad)

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(var_mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(var_mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(var_mainMod .. " + mouse:272", hl.dsp.window.drag(), {
    mouse = true,
})
hl.bind(var_mainMod .. " + mouse:273", hl.dsp.window.resize(), {
    mouse = true,
})

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), {
    repeating = true,
    locked = true,
})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), {
    repeating = true,
    locked = true,
})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {
    repeating = true,
    locked = true,
})
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), {
    repeating = true,
    locked = true,
})
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), {
    repeating = true,
    locked = true,
})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), {
    repeating = true,
    locked = true,
})

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), {
    locked = true,
})
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), {
    locked = true,
})
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), {
    locked = true,
})
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), {
    locked = true,
})

-- #############################

-- ## WINDOWS AND WORKSPACES ###

-- #############################

-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

-- See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
hl.workspace_rule({
    workspace = "name:1",
    monitor = "DP-2",
})

-- HyprMod managed settings
require("hyprland-gui")
