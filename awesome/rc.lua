-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")


------------------------------------------------
------------------ LIBRARIES -------------------
------------------------------------------------


-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local watch = require("awful.widget.watch")
local lain = require("lain")
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


------------------------------------------------
------------------- ERRORS ---------------------
------------------------------------------------


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    n_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })
    in_error = false
  end)
end
-- }}}


------------------------------------------------
------------------- OPTIONS --------------------
------------------------------------------------


-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "cat/theme.lua")


-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. "vim"
browser = "firefox"
fm = "nemo"

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  --awful.layout.suit.floating,
  awful.layout.suit.tile,
}
-- }}}


------------------------------------------------
------------------- WIDGETS --------------------
------------------------------------------------



-- RAM Widget
local mymem = lain.widget.mem {
  settings = function()
    widget:set_markup("   " .. mem_now.perc .. "% ")
  end
}

-- Widget Separator
tbox_separator = wibox.widget.textbox(" ")

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
mytextclock = wibox.widget.textclock()


------------------------------------------------
-------------------- WIBAR ---------------------
------------------------------------------------


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        { raise = true }
      )
    end
  end),
  awful.button({}, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end))

local function set_wallpaper(s)
  -- Wallpaper
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)





---------------------------------
-- Global Variables
---------------------------------

local widget_fg = "#a6adc8"
local widget_bg = "#1e1e2e"

---------------------------------
-- Cutom Widgets
---------------------------------


-- Memory widget
local memory_widget = wibox.widget {
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
}

local mem = lain.widget.cpu {
    settings = function()
        memory_widget.text = string.format("%.f%% ", mem_now.perc)
    end
}

local container_mem_widget = {
    {
        {
            {
                {
                    {
                        text = " ",
                        font = "JetBrainsMono Nerd Font 9",
                        widget = wibox.widget.textbox,
                    },
                    {
                        widget = memory_widget,
                    },
                    layout = wibox.layout.fixed.horizontal
                },
                left = 6,
                right = 10,
                widget = wibox.container.margin
            },
            shape = gears.shape.rounded_bar,
            fg = "#fab387",
            bg = widget_bg,
            widget = wibox.container.background
        },
        widget = wibox.container.margin
    },
    spacing = 0,
    layout = wibox.layout.fixed.horizontal,
}

-- CPU widget
local cpu_widget = wibox.widget {
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
}

local cpu = lain.widget.cpu {
    settings = function()
        cpu_widget.text = string.format("%d%% ", cpu_now.usage)
    end
}

local container_cpu_widget = {
    {
        {
            {
                {
                    text = " ",
                    font = "JetBrainsMono Nerd Font 9",
                    widget = wibox.widget.textbox,
                },
                {
                    widget = cpu_widget,
                },
                layout = wibox.layout.fixed.horizontal
            },
            left = 6,
            right = 10,
            widget = wibox.container.margin
        },
        shape = gears.shape.rounded_bar,
        fg = "#b4befe",
        bg = widget_bg,
        widget = wibox.container.background
    },
    widget = wibox.container.margin
}

-- Volume widget
local container_vol_widget = wibox.container
local vol_widget = wibox.widget({
  align = "center",
  valign = "center",
  widget = wibox.widget.textbox,
})

local update_vol_widget = function(vol)
  vol_widget.text = " " .. vol
end

local vo_signal
local vol_script = "/home/sato/.config/Scripts/wibar/volume-bar.sh"

local function check_volume_scripts()
  local vol_plus = "/home/sato/.config/Scripts/notify/volume+.sh"
  local vol_minus = "/home/sato/.config/Scripts/notify/volume-.sh"
  
  local handle = io.popen("pgrep -f " .. vol_plus .. " || pgrep -f " .. vol_minus)
  local result = handle:read("*a")
  handle:close()
  
  return #result > 0
end

local function update_volume_widget()
  if check_volume_scripts() then
    awful.spawn.easy_async(vol_script, function(stdout)
      local vol = stdout:gsub("\n", "") -- Remover a quebra de linha
      update_vol_widget(vol)
    end)
  end
end

vo_signal = awful.widget.watch(vol_script, 1, function(widget, stdout)
  if check_volume_scripts() then
    local vol = stdout:gsub("\n", "") -- Remover a quebra de linha
    update_vol_widget(vol)
  end
end)

container_vol_widget = {
  {
    {
      {
        widget = vol_widget,
      },
      left = 0,
      right = 10,
      top = 0,
      bottom = 0,
      widget = wibox.container.margin,
    },
    shape = gears.shape.rounded_bar,
    fg = "#f38ba8",    
    forced_width = 130,
    bg = widget_bg,
    widget = wibox.container.background,
  },
  spacing = 5,
  layout = wibox.layout.fixed.horizontal,
}

--Batery widget
local container_battery_widget = wibox.container
local battery_widget = wibox.widget({
  align = "center",
  valign = "center",
  widget = wibox.widget.textbox,
})

local update_battery_widget = function(bat, status)
  if status == "Charging" then
    battery_widget.text = "󰂄 " .. bat .. "%"
  else
    battery_widget.text = "󰁹 " .. bat .. "%"
  end
end

awful.widget.watch('bash -c "cat /sys/class/power_supply/BAT1/capacity && cat /sys/class/power_supply/BAT1/status"', 1, function(self, stdout)
  local bat, status = string.match(stdout, "(%d+)\n(%a+)")
  bat = tonumber(bat)
  update_battery_widget(bat, status)
end)

container_battery_widget = {
  {
    {
      {
        widget = battery_widget,
      },
      left = 0,
      right = 10,
      top = 0,
      bottom = 0,
      widget = wibox.container.margin,
    },
    shape = gears.shape.rounded_bar,
    fg = "#a6e3a1",
    bg = widget_bg,
    widget = wibox.container.background,
  },
  spacing = 5,
  layout = wibox.layout.fixed.horizontal,
}

-- wifi widget
local wifi_widget = wibox.widget.textbox()

local function update_network_widget(stdout_wifi, stdout_eth)
    local ssid = stdout_wifi:match("Connected network %s+(.-)%s%s")
    if ssid and ssid ~= "N/A" then
        wifi_widget.text = "  " .. ssid
    else
        local connected_ethernet = stdout_eth:match("state UP")
        if connected_ethernet then
            wifi_widget.text = " Ethernet"
        else
            wifi_widget.text = "󰖪 Disconnected"
        end
    end
end

awful.widget.watch("iwctl station wlo1 show", 1, function(widget, stdout_wifi)
    awful.spawn.easy_async_with_shell("ip link show dev enp2s0", function(stdout_eth)
        update_network_widget(stdout_wifi, stdout_eth)
    end)
end)

local wifi_container = {
    {
        {
            widget = wifi_widget,
        },
        left = 6,
        right = 0,
        top = 0,
        bottom = 0,
        widget = wibox.container.margin,
    },
    shape = gears.shape.rounded_bar,
    fg = "#f9e2af",
    bg = widget_bg,
    widget = wibox.container.background,
}

-- Clock widget
container_clock_widget = {
  {
    {
      {
        widget = mytextclock,
      },
      left = 6,
      right = 6,
      top = 0,
      bottom = 0,
      widget = wibox.container.margin,
    },
    shape = gears.shape.rounded_bar,
    fg = "#cba6f7",
    bg = widget_bg,
    widget = wibox.container.background,
  },
  spacing = 5,
  layout = wibox.layout.fixed.horizontal,
}

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag({ "", "", "", "", "", "" }, s, awful.layout.layouts[1])

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({}, 1, function() awful.layout.inc(1) end),
    awful.button({}, 3, function() awful.layout.inc(-1) end),
    awful.button({}, 4, function() awful.layout.inc(1) end),
    awful.button({}, 5, function() awful.layout.inc(-1) end)))


  local layoutbox = wibox.widget({
    s.mylayoutbox,
    top = 3,
    bottom = 4,
    left = 5,
    right = 10,
    widget = wibox.container.margin,
  })

  -- Create a taglist widget
  -- s.mytaglist = awful.widget.taglist {
  --   screen  = s,
  --   filter  = awful.widget.taglist.filter.all,
  --   buttons = taglist_buttons
  -- }
  s.mytaglist = require("mytaglist")(s)

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist ({
    screen = s,
    filter = awful.widget.tasklist.filter.focused,
    style = {
      shape = gears.shape.rounded_bar,
    },
    layout = {
      spacing = 10,
      layout = wibox.layout.fixed.horizontal,
    },
    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    -- not a widget instance.
    widget_template = {
      {
        {
          {
            {

              {
                id = "icon_role",
                widget = wibox.widget.imagebox,
              },
              left = 0,
              right = 5,
              top = 2,
              bottom = 2,
              widget = wibox.container.margin,
            },
            {
              id = "text_role",
              font = "JetBrainsMono Nerd Font 9",
              widget = wibox.widget.textbox,
            },
            layout = wibox.layout.fixed.horizontal,
          },
          left = 5,
          right = 5,
          top = 0,
          bottom = 2,
          widget = wibox.container.margin,
        },
        fg = widget_fg,
        bg = widget_bg,
        shape = gears.shape.rounded_bar,
        widget = wibox.container.background,
      },
      left = 0,
      right = 0,
      top = 0,
      bottom = 0,
      widget = wibox.container.margin,
    },
  })

  -- Create the wibox
  -- s.mywibox = awful.wibar({ position = "top", screen = s, visible = true })
  s.mywibox = awful.wibar({
    position = "top",
    border_width = 0,
    border_color = "#00000000",
    height = 35,
    input_passthrough = true,
    screen = s,
  })


	-- Add widgets to the wibox
	s.mywibox:setup({
		{
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				--mylauncher,
        tbox_separator,
				s.mytaglist,
				s.mypromptbox,
			},
			{ -- Middle widgets
				layout = wibox.layout.fixed.horizontal,
				s.mytasklist,
			},
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
--        container_brightness_widget,
				container_vol_widget,
				container_mem_widget,
				container_cpu_widget,
				container_battery_widget,
        wifi_container,
				container_clock_widget,
        wibox.widget.systray(),
			},
		},
		top = 0, -- don't forget to increase wibar height
		color = "#80aa80",
		widget = wibox.container.margin,
	})
end)
-- }}}


------------------------------------------------
----------------- KEYBINDINGS ------------------
------------------------------------------------


globalkeys = gears.table.join(

-- Layout manipulation
  awful.key({ modkey, }, "Left", awful.tag.viewprev,
    { description = "view previous", group = "tag" }),
  awful.key({ modkey, }, "Right", awful.tag.viewnext,
    { description = "view next", group = "tag" }),

  awful.key({ modkey, }, "j",
    function()
      awful.client.focus.byidx(1)
    end,
    { description = "focus next by index", group = "client" }
  ),
  awful.key({ modkey, }, "k",
    function()
      awful.client.focus.byidx(-1)
    end,
    { description = "focus previous by index", group = "client" }
  ),

  awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
    { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
    { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
    { description = "focus the next screen", group = "screen" }),
  awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
    { description = "focus the previous screen", group = "screen" }),
  awful.key({ modkey, }, "Tab",
    function()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    { description = "go back", group = "client" }),
  awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
    { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
    { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
    { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
    { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
    { description = "decrease the number of columns", group = "layout" }),
  awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
    { description = "select next", group = "layout" }),
  awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
    { description = "select previous", group = "layout" }),

  awful.key({ modkey, "Control" }, "n",
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", { raise = true }
        )
      end
    end,
    { description = "restore minimized", group = "client" }),


  -- Standard program
  awful.key({ modkey, }, "F1", function() awful.spawn(browser) end,
    { description = "open a browser", group = "launcher" }),
  awful.key({ modkey, }, "F2", function() awful.spawn(fm) end,
    { description = "open filemanager", group = "launcher" }),
  awful.key({ modkey, }, "F3", function() awful.spawn("alacritty -e ranger") end,
    { description = "open ranger", group = "launcher" }),
  awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
    { description = "open a terminal", group = "launcher" }),
  awful.key({ modkey, "Control" }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, "Shift" }, "q", awesome.quit,
    { description = "quit awesome", group = "awesome" }),
  awful.key({ modkey }, "a", function() awful.spawn("pavucontrol") end,
    { description = "exec pulsemixer", group = "Personal launchers" }),
  awful.key({ modkey, }, "=", function() awful.spawn("/home/sato/.config/Scripts/notify/volume+.sh") end,
    { description = "exec volup", group = "Personal launchers" }),
  awful.key({ modkey, }, "-", function() awful.spawn("/home/sato/.config/Scripts/notify/volume-.sh") end,
    { descrition = "exec voldown", group = "Personal launchers" }),
  awful.key({ modkey, }, "s", function() awful.spawn("/home/sato/.config/Scripts/screenshot.sh") end,
    { description = "Screenshot", group = "Personal launchers" }),
  awful.key({ modkey }, "x", function() awful.spawn("/home/sato/.config/rofi/powermenu/type-2/powermenu.sh") end,
    { description = "Rofi power menu", group = "Personal launchers" }),
  awful.key({ modkey }, "r", function() awful.spawn("/home/sato/.config/Scripts/rofi-beats-linux") end,
    { description = "Rofi beats", group = "Personal launchers" }),
  -- Menubar
  awful.key({ modkey, }, "p", function () awful.spawn("/home/sato/.local/bin/fullscreen_run.sh") end,
    { description = "menubar", group = "Personal launchers" })
)


clientkeys = gears.table.join(
  awful.key({ modkey, }, "f",
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "toggle fullscreen", group = "client" }),
  awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
    { description = "close", group = "client" }),
  awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }),
  awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
    { description = "move to master", group = "client" }),
  awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
    { description = "move to screen", group = "client" }),
  awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
    { description = "toggle keep on top", group = "client" }),
  awful.key({ modkey, }, "n",
    function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end,
    { description = "minimize", group = "client" }),
  awful.key({ modkey, }, "m",
    function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    { description = "(un)maximize", group = "client" }),
  awful.key({ modkey, "Control" }, "m",
    function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end,
    { description = "(un)maximize vertically", group = "client" }),
  awful.key({ modkey, "Shift" }, "m",
    function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end,
    { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag" }),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:toggle_tag(tag)
          end
        end
      end,
      { description = "toggle focused client on tag #" .. i, group = "tag" })
  )
end

clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)
-- }}}
local function client_status(client)
  local layout = awful.layout.get(mouse.screen)

  if (layout == awful.layout.suit.floating) or (client and client.floating) then
    return "floating"
  end

  if layout == awful.layout.suit.max then
    return "max"
  end

  return "other"
end


------------------------------------------------
-------------------- RULES ---------------------
------------------------------------------------


awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = 1,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
  },

  {
    rule = { class = "Alacritty" },
    properties = { floating = false, placement = awful.placement.centered }
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA",   -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "xtightvncviewer" },

      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
      },
      role = {
        "AlarmWindow",   -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = { floating = true }
  },

  -- Add titlebars to normal clients and dialogs
  {
    rule_any = { type = { "normal", "dialog" }
    },
    properties = { titlebars_enabled = true }
  },

  -- Set Firefox to always map on the tag named "2" on screen 1.
  -- { rule = { class = "Firefox" },
  --   properties = { screen = 1, tag = "2" } },
}
-- }}}


-------------------------------------------------
-------------------- SIGNALS --------------------
-------------------------------------------------


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-------------------------------------------------
-------------------- GAPS -----------------------
-------------------------------------------------


beautiful.useless_gap = 3


-------------------------------------------------
-------------------- START ----------------------
-------------------------------------------------

awful.spawn.with_shell('polkit-xfce-authentication-agent-1')
awful.spawn.with_shell('nitrogen --restore')
awful.spawn.with_shell('xset r rate 300 50')
awful.spawn.with_shell('picom --experimental-backends')
