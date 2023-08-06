local gears = require("gears")
local modular  = require("modular")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility


-- Pallete

local palette                                  = {}
palette.bg0                                    ="#111111"
palette.bg1                                    ="#282828"
palette.bg2                                    ="#282828"
palette.bg3                                    ="#3c3836"
palette.bg4                                    ="#3c3836"
palette.bg5                                    ="#504945"
palette.bg_statusline1                         ="#282828"
palette.bg_statusline2                         ="#32302f"
palette.bg_statusline3                         ="#504945"
palette.bg_diff_green                          ="#32361a"
palette.bg_visual_green                        ="#333e34"
palette.bg_diff_red                            ="#3c1f1e"
palette.bg_visual_red                          ="#442e2d"
palette.bg_diff_blue                           ="#0d3138"
palette.bg_visual_blue                         ="#2e3b3b"
palette.bg_visual_yellow                       ="#473c29"
palette.bg_current_word                        ="#32302f"
palette.fg0                                    ="#d4be98"
palette.fg1                                    ="#ddc7a1"
palette.fg_dim                                 ="#9a7940"
palette.red                                    ="#ea6962"
palette.orange                                 ="#e78a4e"
palette.yellow                                 ="#d8a657"
palette.green                                  ="#a9b665"
palette.aqua                                   ="#89b482"
palette.blue                                   ="#7daea3"
palette.purple                                 ="#d3869b"
palette.bg_red                                 ="#ea6962"
palette.bg_green                               ="#a9b665"
palette.bg_yellow                              ="#d8a657"

--

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/theme.lua"
theme.scripts_dir                               = os.getenv("HOME") .. "/.config/awesome/scripts/"
--theme.wallpaper                                 = theme.dir .. "/wall.png"
theme.font                                      = "Icons 10"
theme.fg_normal                                 = palette.fg0
theme.fg_focus                                  = palette.bg0
theme.fg_urgent                                 = palette.red
theme.bg_normal                                 = palette.bg0
theme.bg_focus                                  = palette.yellow
theme.bg_urgent                                 = palette.bg_red
theme.border_width                              = dpi(1)
theme.border_normal                             = palette.bg0 .. "00"
theme.border_focus                              = palette.aqua
theme.border_marked                             = palette.blue
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(3)

theme.taglist_bg_focus                          = palette.yellow
theme.taglist_bg_occupied                       = palette.yellow .. "55"
theme.taglist_shape                             = gears.shape.circle
theme.taglist_spacing                           = dpi(4)


local keyboardlayout = awful.widget.keyboardlayout:new()

-- Time
theme.time = modular.widget({
		bg = palette.blue,
		fg = palette.bg0,
		right = true,
	  command = theme.scripts_dir .. "dwm_time",
})

-- Memory
theme.memory = modular.widget({
		bg = palette.aqua,
		fg = palette.bg0,
	  command = theme.scripts_dir .. "dwm_memory",
})


-- Battery
theme.battery = modular.widget({
	  command = theme.scripts_dir .. "dwm_battery",
		bg = palette.purple,
		fg = palette.bg0,
})

-- Volume
theme.volume = modular.widget({
	  command = theme.scripts_dir .. "dwm_volume",
		bg = palette.red,
		fg = palette.bg0,
		left = true,
})

theme.volume.widget:buttons(awful.util.table.join(
                               awful.button({}, 4, function ()
                                     awful.util.spawn(theme.scripts_dir .. "dwm_volume_down")
                                     theme.volume.update()
                               end),
                               awful.button({}, 5, function ()
                                     awful.util.spawn(theme.scripts_dir .. "dwm_volume_up")
                                     theme.volume.update()
                               end)
))

-- Brightness
theme.brightness = modular.widget({
		bg = palette.yellow,
		fg = palette.bg0,
	  command = theme.scripts_dir .. "dwm_brightness",
})
theme.brightness.widget:buttons(awful.util.table.join(
                               awful.button({}, 4, function ()
                                     awful.util.spawn(theme.scripts_dir .. "dwm_brightness_down")
                                     theme.brightness.update()
                               end),
                               awful.button({}, 5, function ()
                                     awful.util.spawn(theme.scripts_dir .. "dwm_brightness_up")
                                     theme.brightness.update()
                               end)
))

-- Wifi
theme.wifi = modular.widget({
		bg = palette.orange,
		fg = palette.bg0,
	  command = theme.scripts_dir .. "dwm_wifi",
})

function theme.at_screen_connect(s)

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
			screen       	= s,
			filter 				= awful.widget.taglist.filter.all,
			buttons				= awful.util.taglist_buttons
		}

    -- Create the wibox
    s.mywibox = wibox({ 
			y = dpi(3),
			x = dpi(6),
			width = dpi(s.geometry.width - 12),
			screen = s,
			type = "dock",
			height = dpi(22), 
			bg = theme.bg_normal .. "00",
			fg = theme.fg_normal,
			visible = true,
		})

    s.mywibox:struts ({top=22})

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        nil, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            theme.volume,
            theme.brightness,
						theme.memory,
						theme.battery,
						theme.wifi,
            theme.time,
        },
    }
end

return theme
