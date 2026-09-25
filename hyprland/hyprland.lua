--monitors.
hl.monitor({
  output = "DP-1",
  mode = "1920x1080@144",
  position = "1920x0",
  scale = 1,
})

hl.monitor({
  output = "eDP-1",
  mode = "1920x1080@165",
  position = "0x0",
  scale = 1,
})

--env variables.
hl.env("GTK_IM_MODULE", "simple")

--input.
hl.config({
  input = {
    kb_layout = "br,us",
    kb_variant = "abnt2,",
  },
})

--binds.
local mod = "SUPER"

--apps.
hl.bind(mod .. " + T", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.kill())
hl.bind(mod .. " + E", hl.dsp.exec_cmd("ghostty -e superfile"))

--floating.
hl.bind(mod .. " + C", function()
  hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  hl.dispatch(hl.dsp.window.resize({ x = 1152, y = 648 }))
  hl.dispatch(hl.dsp.window.center())
end)

hl.bind(
  mod .. " + mouse:272",
  hl.dsp.window.drag(),
  { mouse = true }
)

hl.bind(
  mod .. " + mouse:273",
  hl.dsp.window.resize(),
  { mouse = true }
)

--launcher.
hl.bind(
  mod .. " + RETURN",
  hl.dsp.exec_cmd("noctalia msg panel-toggle launcher")
)

--fullscreen.
hl.bind(
  mod .. " + F",
  hl.dsp.window.fullscreen({
    action = "toggle",
    mode = "fullscreen",
  })
)

--keyboard layout.
hl.bind(
  mod .. " + SPACE",
  hl.dsp.exec_cmd("hyprctl switchxkblayout all next")
)

--move windows.
hl.bind(
  mod .. " + SHIFT + h",
  hl.dsp.window.move({ direction = "l" })
)

hl.bind(
  mod .. " + SHIFT + l",
  hl.dsp.window.move({ direction = "r" })
)

hl.bind(
  mod .. " + SHIFT + k",
  hl.dsp.window.move({ direction = "u" })
)

hl.bind(
  mod .. " + SHIFT + j",
  hl.dsp.window.move({ direction = "d" })
)

--window focus.
hl.bind(
  mod .. " + h",
  hl.dsp.focus({ direction = "l" })
)

hl.bind(
  mod .. " + l",
  hl.dsp.focus({ direction = "r" })
)

hl.bind(
  mod .. " + k",
  hl.dsp.focus({ direction = "u" })
)

hl.bind(
  mod .. " + j",
  hl.dsp.focus({ direction = "d" })
)

--screenshot.
hl.bind(
  "Print",
  hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]])
)

--workspaces.
hl.bind(
  mod .. " + LEFT",
  hl.dsp.focus({ workspace = "-1" })
)

hl.bind(
  mod .. " + RIGHT",
  hl.dsp.focus({ workspace = "+1" })
)

hl.bind(
  mod .. " + SHIFT + LEFT",
  hl.dsp.window.move({
    workspace = "-1",
    follow = true,
  })
)

hl.bind(
  mod .. " + SHIFT + RIGHT",
  hl.dsp.window.move({
    workspace = "+1",
    follow = true,
  })
)

--special workspace.
hl.bind(
  mod .. " + M",
  hl.dsp.window.move({
    workspace = "special",
    follow = false,
  })
)

hl.bind(
  mod .. " + SHIFT + M",
  hl.dsp.workspace.toggle_special("")
)

--power menu.
hl.bind(
  mod .. " + X",
  hl.dsp.exec_cmd("noctalia msg panel-toggle session")
)

--clipboard.
hl.bind(
  mod .. " + V",
  hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard")
)

--notifications.
hl.bind(
  mod .. " + N",
  hl.dsp.exec_cmd("noctalia msg panel-toggle notifications")
)

--control center.
hl.bind(
  mod .. " + SHIFT + N",
  hl.dsp.exec_cmd("noctalia msg panel-toggle control-center")
)

--window resizing.
hl.bind(
  mod .. " + CONTROL + l",
  hl.dsp.window.resize({
    x = 20,
    y = 0,
    relative = true,
  }),
  { repeating = true }
)

hl.bind(
  mod .. " + CONTROL + h",
  hl.dsp.window.resize({
    x = -20,
    y = 0,
    relative = true,
  }),
  { repeating = true }
)

hl.bind(
  mod .. " + CONTROL + k",
  hl.dsp.window.resize({
    x = 0,
    y = -20,
    relative = true,
  }),
  { repeating = true }
)

hl.bind(
  mod .. " + CONTROL + j",
  hl.dsp.window.resize({
    x = 0,
    y = 20,
    relative = true,
  }),
  { repeating = true }
)

--window switcher.
hl.bind(
  "ALT + Tab",
  hl.dsp.exec_cmd("noctalia msg window-switcher")
)

--brightness & volume.
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("noctalia msg volume-up"),
  {
    repeating = true,
    locked = true,
  }
)

hl.bind(
  "XF86AudioLowerVolume",
  hl.dsp.exec_cmd("noctalia msg volume-down"),
  {
    repeating = true,
    locked = true,
  }
)

hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("noctalia msg volume-mute"),
  {
    repeating = true,
    locked = true,
  }
)

hl.bind(
  "XF86MonBrightnessUp",
  hl.dsp.exec_cmd("noctalia msg brightness-up"),
  {
    repeating = true,
    locked = true,
  }
)

hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("noctalia msg brightness-down"),
  {
    repeating = true,
    locked = true,
  }
)

--animations.
hl.config({
  animations = {
    enabled = true,
  },
})

hl.curve("easeOutExpo", {
  type = "bezier",
  points = {
    { 0.16, 1 },
    { 0.3, 1 },
  },
})

hl.curve("easeInOutCubic", {
  type = "bezier",
  points = {
    { 0.65, 0.05 },
    { 0.36, 1 },
  },
})

hl.curve("overshot", {
  type = "bezier",
  points = {
    { 0.05, 0.9 },
    { 0.1, 1.05 },
  },
})

hl.curve("smoothIn", {
  type = "bezier",
  points = {
    { 0.25, 0.1 },
    { 0.25, 1 },
  },
})

hl.animation({
  leaf = "windows",
  enabled = true,
  speed = 4,
  curve = "easeOutExpo",
  style = "popin 85%",
})

hl.animation({
  leaf = "windowsOut",
  enabled = true,
  speed = 4,
  curve = "easeInOutCubic",
  style = "popin 85%",
})

hl.animation({
  leaf = "windowsMove",
  enabled = true,
  speed = 4,
  curve = "easeOutExpo",
})

hl.animation({
  leaf = "border",
  enabled = true,
  speed = 8,
  curve = "default",
})

hl.animation({
  leaf = "borderangle",
  enabled = true,
  speed = 30,
  curve = "default",
  style = "loop",
})

hl.animation({
  leaf = "fade",
  enabled = true,
  speed = 4,
  curve = "smoothIn",
})

hl.animation({
  leaf = "workspaces",
  enabled = true,
  speed = 5,
  curve = "overshot",
  style = "slide",
})

hl.animation({
  leaf = "specialWorkspace",
  enabled = true,
  speed = 4,
  curve = "overshot",
  style = "slidevert",
})

--general.
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    layout = "dwindle",
    resize_on_border = true,
  },

  ["general.col.active_border"] = "rgba(ffffffee) rgba(888888aa) 45deg",
  ["general.col.inactive_border"] = "rgba(1a1a1aaa)",
})

--decoration.
hl.config({
  decoration = {
    rounding = 10,
    active_opacity = 1.0,
    inactive_opacity = 0.75,

    shadow = {
      enabled = true,
      range = 18,
      render_power = 3,
      color = "rgba(00000088)",
    },

    blur = {
      enabled = true,
      size = 6,
      passes = 3,
      new_optimizations = true,
      vibrancy = 0.25,
    },
  },
})

--dwindle layout.
hl.config({
  dwindle = {
    preserve_split = true,
    smart_resizing = true,
  },
})

--floating windows.
hl.window_rule({
  match = {
    float = true,
  },

  size = {
    "monitor_w * 0.6",
    "monitor_h * 0.6",
  },

  center = true,
})
