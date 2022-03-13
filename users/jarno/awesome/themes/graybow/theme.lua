--[[

     Mash-up of Rainbow and Multicolor themes
     (based on github.com/lcpz/awesome-copycats)

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local naughty = require("naughty")

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.default_dir                               = require("awful.util").get_themes_dir() .. "default"
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/graybow"
theme.wallpaper                                 = theme.dir .. "/gray.png"
--theme.font                                      = "Terminus 10.5"
theme.font                                      = "Terminus 10"
--theme.icon_font                                 = "FontAwesome 9"
theme.icon_font                                 = "Font Awesome 5 Free 10"
theme.fg_normal                                 = "#9E9E9E"
theme.fg_focus                                  = "#EBEBFF"
theme.bg_normal                                 = "#242424"
theme.bg_focus                                  = "#242424"
theme.fg_urgent                                 = "#000000"
theme.bg_urgent                                 = "#FFFFFF"
theme.border_width                              = dpi(1)
theme.border_normal                             = "#333333"
theme.border_focus                              = "#2d4e99"
theme.taglist_fg_focus                          = "#EDEFFF"
theme.taglist_bg_focus                          = "#242424"
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_uptime                             = theme.dir .. "/icons/ac.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_weather                            = theme.dir .. "/icons/dish.png"
theme.widget_fs                                 = theme.dir .. "/icons/fs.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_note                               = theme.dir .. "/icons/note.png"
theme.widget_note_on                            = theme.dir .. "/icons/note_on.png"
theme.widget_netdown                            = theme.dir .. "/icons/net_down.png"
theme.widget_netup                              = theme.dir .. "/icons/net_up.png"
theme.widget_mail                               = theme.dir .. "/icons/mail.png"
theme.widget_batt                               = theme.dir .. "/icons/bat.png"
theme.widget_clock                              = theme.dir .. "/icons/clock.png"
theme.widget_vol                                = theme.dir .. "/icons/spkr.png"
theme.ocol                                      = "<span color='" .. theme.fg_normal .. "'>"
theme.tasklist_sticky                           = theme.ocol .. "[S]</span>"
theme.tasklist_ontop                            = theme.ocol .. "[T]</span>"
theme.tasklist_floating                         = theme.ocol .. "[F]</span>"
theme.tasklist_maximized_horizontal             = theme.ocol .. "[M] </span>"
theme.tasklist_maximized_vertical               = ""
theme.tasklist_disable_icon                     = true
theme.awesome_icon                              = theme.dir .."/icons/awesome.png"
theme.menu_submenu_icon                         = theme.dir .."/icons/submenu.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.useless_gap                               = 0
theme.layout_txt_tile                           = "[t]"
theme.layout_txt_tileleft                       = "[l]"
theme.layout_txt_tilebottom                     = "[b]"
theme.layout_txt_tiletop                        = "[tt]"
theme.layout_txt_fairv                          = "[fv]"
theme.layout_txt_fairh                          = "[fh]"
theme.layout_txt_spiral                         = "[s]"
theme.layout_txt_dwindle                        = "[d]"
theme.layout_txt_max                            = "[m]"
theme.layout_txt_fullscreen                     = "[F]"
theme.layout_txt_magnifier                      = "[M]"
theme.layout_txt_floating                       = "[*]"
theme.titlebar_close_button_normal              = theme.default_dir.."/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = theme.default_dir.."/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = theme.default_dir.."/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = theme.default_dir.."/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = theme.default_dir.."/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.default_dir.."/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.default_dir.."/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme.default_dir.."/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = theme.default_dir.."/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.default_dir.."/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.default_dir.."/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme.default_dir.."/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = theme.default_dir.."/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.default_dir.."/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.default_dir.."/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme.default_dir.."/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.default_dir.."/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.default_dir.."/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.default_dir.."/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme.default_dir.."/titlebar/maximized_focus_active.png"

-- lain related
theme.layout_txt_cascade                        = "[cascade]"
theme.layout_txt_cascadetile                    = "[cascadetile]"
theme.layout_txt_centerwork                     = "[centerwork]"
theme.layout_txt_termfair                       = "[termfair]"
theme.layout_txt_centerfair                     = "[centerfair]"

local markup = lain.util.markup
local white  = theme.fg_focus
local gray   = theme.fg_normal

-- https://fontawesome.com/cheatsheet
local icon_battery_empty = ""
local icon_battery_full = ""
local icon_battery_half = ""
local icon_battery_quarter = ""
local icon_battery_three_quarters = ""
local icon_plug = ""
local icon_database = ""
local icon_microchip = ""
local icon_volume_down = ""
local icon_volume_mute = ""
local icon_volume_off = ""
local icon_volume_up = ""
local icon_thermometer_half = ""
local icon_fan = ""
local icon_layer_group = ""
local icon_network_wired = ""
local icon_save = ""
local icon_random = ""


--local icon_dice_one



-- Textclock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local mytextclock = wibox.widget.textclock(markup(white, " %H:%M "))
mytextclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = "Terminus 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- Mail IMAP check
--[[ commented because it needs to be set before use
theme.mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        mail_notification_preset.fg = white

        mail  = ""
        count = ""

        if mailcount > 0 then
            mail = "Mail "
            count = mailcount .. " "
        end

        widget:set_markup(markup.font(theme.font, markup(gray, mail) .. markup(white, count)))
    end
})
--]]


local function markup_icon_text(color, icon, text)
   local icon_html = markup.font(theme.icon_font, icon)
   local html = markup.fontfg(theme.font, color, " " .. icon_html .. " " .. text .. " ")
   return html
end

local clear_timers = {}

local function update_widget(name, widget, show, content)
   if show and clear_timers[name] then
       -- cancel timer
       clear_timers[name]:stop()
       clear_timers[name] = nil
   end
   if show or clear_timers[name] then
       widget:set_markup(content)
       if not clear_timers[name] then
           -- schedule delayed clear
           clear_timers[name] = gears.timer({
               timeout = 7,
               autostart = true,
               single_shot = true,
               callback = function()
                  widget:set_markup("")
                  clear_timers[name] = nil
               end
           })
       end
   end
end

-- CPU
local cpu = lain.widget.cpu({
    settings = function()
        update_widget("cpu", widget, cpu_now.usage >= 10,
                      markup_icon_text("#ab5e76", icon_fan, cpu_now.usage .. "%"))
    end
})

-- Coretemp
local temp = lain.widget.temp({
    settings = function()
        local icon = icon_thermometer_half
        update_widget("temp", widget, coretemp_now >= 70,
                      markup_icon_text("#ab885e", icon, coretemp_now .. "°C"))
    end
})

-- Battery
local bat = lain.widget.bat({
    settings = function()
        if bat_now.perc == "N/A" then
           widget:set_markup("")
           return
        end

        local icon = icon_battery_empty
        if bat_now.perc >= 88 then icon = icon_battery_full
        elseif bat_now.perc >= 63 then icon = icon_battery_three_quarters
        elseif bat_now.perc >= 38 then icon = icon_battery_half
        elseif bat_now.perc >= 13 then icon = icon_battery_quarter
        end
        

        if bat_now.ac_status == 1 then
           icon = icon_plug
        end

        widget:set_markup(markup_icon_text("#aaaaaa", icon, bat_now.perc .. "%"))
    end
})

-- ALSA volume
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.level == nil then
           widget:set_markup("")
           return
        end

        local icon = icon_volume_up
        local text = volume_now.level .. "%"
        if volume_now.status == "off" then
            icon = icon_volume_mute
            text = ""
        end

        widget:set_markup(markup_icon_text("#5e78ab", icon, text))
    end
})

-- Net
local netinfo = lain.widget.net({
    units = 1024 * 1024,
    settings = function()
        if iface == "network off" then
           widget:set_markup("")
           return
        end

        local total = net_now.sent + net_now.received
        update_widget("net", widget, total >= 1, -- MB/sec
           markup_icon_text("#84ab5e", icon_network_wired, total .. "M"))
    end
})

-- MEM
local memory = lain.widget.mem({
    settings = function()
        update_widget("mem", widget, mem_now.perc >= 30,
                      markup_icon_text("#aba85e", icon_database, mem_now.perc .. "%"))
    end
})

-- I/O
local diskio = lain.widget.disk_io({
    units = 1024 * 1024,
    settings = function()
        local total = io_now.read + io_now.write
        update_widget("disk_io", widget, total >= 1, -- MB/sec
           markup_icon_text("#5eaba7", icon_save, total .. "M"))
    end
})

-- MPD
-- theme.mpd = lain.widget.mpd({
--     settings = function()
--         mpd_notification_preset.fg = white

--         artist = mpd_now.artist .. " "
--         title  = mpd_now.title  .. " "

--         if mpd_now.state == "pause" then
--             artist = "mpd "
--             title  = "paused "
--         elseif mpd_now.state == "stop" then
--             artist = ""
--             title  = ""
--         end

--         widget:set_markup(markup.font(theme.font, markup(gray, artist) .. markup(white, title)))
--     end
-- })

-- /home fs
--[[ commented because it needs Gio/Glib >= 2.54
theme.fs = lain.widget.fs({
    notification_preset = { fg = white, bg = theme.bg_normal, font = "Terminus 10.5" },
    settings  = function()
        local fs_header, fs_p = "", ""

        if fs_now["/home"].percentage >= 90 then
            fs_header = " Hdd "
            fs_p      = fs_now["/home"].percentage
        end

        widget:set_markup(markup.font(theme.font, markup(gray, fs_header) .. markup(white, fs_p)))
    end
})
--]]

-- ALSA volume bar
-- theme.volume = lain.widget.alsabar({
--     ticks = true, width = dpi(67),
--     notification_preset = { font = theme.font }
-- })
-- theme.volume.tooltip.wibox.fg = theme.fg_focus
-- theme.volume.tooltip.wibox.font = theme.font
-- theme.volume.bar:buttons(my_table.join (
--           awful.button({}, 1, function()
--             awful.spawn(string.format("%s -e alsamixer", terminal))
--           end),
--           awful.button({}, 2, function()
--             os.execute(string.format("%s set %s 100%%", theme.volume.cmd, theme.volume.channel))
--             theme.volume.update()
--           end),
--           awful.button({}, 3, function()
--             os.execute(string.format("%s set %s toggle", theme.volume.cmd, theme.volume.togglechannel or theme.volume.channel))
--             theme.volume.update()
--           end),
--           awful.button({}, 4, function()
--             os.execute(string.format("%s set %s 1%%+", theme.volume.cmd, theme.volume.channel))
--             theme.volume.update()
--           end),
--           awful.button({}, 5, function()
--             os.execute(string.format("%s set %s 1%%-", theme.volume.cmd, theme.volume.channel))
--             theme.volume.update()
--           end)
-- ))
-- local volumebg = wibox.container.background(theme.volume.bar, "#585858", gears.shape.rectangle)
-- local volumewidget = wibox.container.margin(volumebg, dpi(7), dpi(7), dpi(5), dpi(5))

-- Weather
-- theme.weather = lain.widget.weather({
--     city_id = 2643743, -- placeholder (London)
--     notification_preset = { font = theme.font, fg = white }
-- })

-- Separators
local first = wibox.widget.textbox(markup.font("Terminus 4", " "))
local spr   = wibox.widget.textbox(' ')

local function update_txt_layoutbox(s)
    -- Writes a string representation of the current layout in a textbox widget
    local txt_l = theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))] or ""
    s.mytxtlayoutbox:set_text(txt_l)
end

function theme.at_screen_connect(s)
    -- Quake application
    -- gnome-terminal doesn't work
    --s.quake = lain.util.quake({ app = awful.util.terminal })
    s.quake = lain.util.quake({ app = "urxvt" })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Textual layoutbox
    s.mytxtlayoutbox = wibox.widget.textbox(theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))])
    awful.tag.attached_connect_signal(s, "property::selected", function () update_txt_layoutbox(s) end)
    awful.tag.attached_connect_signal(s, "property::layout", function () update_txt_layoutbox(s) end)
    s.mytxtlayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function() awful.layout.inc(1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function() awful.layout.inc(-1) end),
                           awful.button({}, 4, function() awful.layout.inc(1) end),
                           awful.button({}, 5, function() awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(18), bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            first,
            s.mytaglist,
            spr,
            s.mytxtlayoutbox,
            --spr,
            s.mypromptbox,
            spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            netinfo,
            diskio.widget,
            memory.widget,
            cpu.widget,
            temp.widget,
            theme.volume.widget,
            bat.widget,
            --theme.mpd.widget,
            --theme.mail.widget,
            --theme.fs.widget,
            --volumewidget,
            wibox.widget.systray(),
            spr,
            mytextclock,
        },
    }
end

return theme
