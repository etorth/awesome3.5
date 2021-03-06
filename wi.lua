--[[=============================================================================
#     FileName: wi.lua
#         Desc:  
#       Author: Lee Meng
#        Email: leaveboy@gmail.com
#     HomePage: http://leaveboy.is-programmer.com/
#      Version: 0.0.1
#   LastChange: 2013-01-07 17:21:57
#      History:
=============================================================================]]
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local vicious   = require("vicious")
local naughty   = require("naughty")
local cal       = require("utils.cal")

height      = 12
graphwidth  = 50
graphheight = height
pctwidth    = 40
cpu_low     = "#00ff00"
cpu_mid     = "#ffff00"
cpu_high    = "#ff0000"

fg_widget     = "#908884"
bg_widget     = "#2a2a2a"
bg_em         = "#ffcc00"
bg_tooltip    = "#d6d6d6"
fg_tooltip    = "#1a1a1a"
border_tooltip= "#444444"

-- {{{ SPAN_FUN
function span_color(color,string)
	return "<span color='"..color.."'>"..string.."</span>"
end
function span_fg_em(string)
	return span_color(beautiful.fg_em,string)
end
function span_bg_em(string)
	return span_color(bg_em,string)
end
-- }}}

-- {{{ SPACERS
space = wibox.widget.textbox()
space:set_text(" ")

comma = wibox.widget.textbox()
comma:set_markup(",")

pipe = wibox.widget.textbox()
pipe:set_markup(span_color(fg_widget,'┋'))

tab = wibox.widget.textbox()
tab:set_text("         ")

volspace = wibox.widget.textbox()
volspace:set_text("")
-- }}}

-- {{{ PROCESSOR
-- Cache
vicious.cache(vicious.widgets.cpu)
vicious.cache(vicious.widgets.cpuinf)

-- Core temperature 
tzswidget = wibox.widget.textbox()
vicious.register(tzswidget, vicious.widgets.thermal, "$1°C", 19, "thermal_zone0")

-- Core 2 %
--cpupct2 = wibox.widget.textbox()
--cpupct2.fit = function(box,w,h)
  --local w,h = wibox.widget.textbox.fit(box,w,h) return math.max(pctwidth,w),h
--vicious.register(cpupct2, vicious.widgets.cpu, "$4%", 2)
--end

-- Core 0 graph
cpugraph0 = awful.widget.graph()
cpugraph0:set_width(graphwidth):set_height(graphheight)
cpugraph0:set_border_color(nil)
cpugraph0:set_border_color(fg_widget)
cpugraph0:set_background_color(bg_widget)
cpugraph0:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(cpugraph0, vicious.widgets.cpu, "$1")

-- Core 1 graph
cpugraph1 = awful.widget.graph()
cpugraph1:set_width(graphwidth):set_height(graphheight)
cpugraph1:set_border_color(nil)
cpugraph1:set_border_color(fg_widget)
cpugraph1:set_background_color(bg_widget)
cpugraph1:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(cpugraph1, vicious.widgets.cpu, "$2")

-- Core 2 graph
cpugraph2 = awful.widget.graph()
cpugraph2:set_width(graphwidth):set_height(graphheight)
cpugraph2:set_border_color(nil)
cpugraph2:set_border_color(fg_widget)
cpugraph2:set_background_color(bg_widget)
cpugraph2:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(cpugraph2, vicious.widgets.cpu, "$3")

-- Core 3 graph
cpugraph3 = awful.widget.graph()
cpugraph3:set_width(graphwidth):set_height(graphheight)
cpugraph3:set_border_color(nil)
cpugraph3:set_border_color(fg_widget)
cpugraph3:set_background_color(bg_widget)
cpugraph3:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(cpugraph3, vicious.widgets.cpu, "$4")
-- }}}

-- {{{ MEMORY
-- Cache
vicious.cache(vicious.widgets.mem)

-- Ram used
memused = wibox.widget.textbox()
vicious.register(memused, vicious.widgets.mem,
  span_fg_em("▒") .. span_bg_em("$2MB $1%") .. span_fg_em("♻") .. span_bg_em("$5% $6M"), 5)

-- Ram bar
membar = awful.widget.progressbar()
membar:set_vertical(false):set_width(graphwidth):set_height(graphheight)
membar:set_ticks(false):set_ticks_size(2)
membar:set_border_color(nil)
membar:set_background_color(bg_widget)
membar:set_color({
  type = "linear",
  from = { 0, 0 },
  to = { graphwidth, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(membar, vicious.widgets.mem, "$1", 13)

-- {{{ FILESYSTEM
-- Cache
vicious.cache(vicious.widgets.fs)

-- Root used
rootfsused = wibox.widget.textbox()
vicious.register(rootfsused, vicious.widgets.fs,span_fg_em("FS:") .. span_bg_em("${/ used_gb}GB ${/ used_p}%"), 97)
-- }}}

-- {{{ DISK DIO
-- Cache
vicious.cache(vicious.widgets.dio)

-- Read and Write
diowidget = wibox.widget.textbox()
vicious.register(diowidget, vicious.widgets.dio, span_fg_em("◘") ..
  span_color("green","↓${sda write_kb}K") .. span_color("orange","↑${sda read_kb}K"),1)
-- }}}

-- {{{ UPTIME
-- Cache
vicious.cache(vicious.widgets.uptime)

-- Read and Write
uptimewidget = wibox.widget.textbox()
vicious.register(uptimewidget, vicious.widgets.uptime, "♨$1-$2:$3", 60)

-- Buttons
uptimewidget:buttons(awful.util.table.join(awful.button({ }, 1, 
function()
	local f = io.popen("uptime")
	p = f:read("*a")
	naughty.notify { text = span_fg_em(p), timeout = 5, hover_timeout = 0.5 }
end)))
-- }}}

-- {{{ Pianobar
-- Icon
mpdicon = wibox.widget.imagebox()
mpdicon:set_image(beautiful.widget_mpd)

-- Song info
mpdwidget = wibox.widget.textbox()
vicious.register(mpdwidget, vicious.widgets.mpd,
function(widget, args)
	local ret_str = span_fg_em("♫")
	if args["{state}"] == "Stop" then
		mpdicon:set_image(beautiful.widget_mpd)
		return ret_str .. span_bg_em("■")
	elseif args["{state}"] == "Pause" then
		mpdicon:set_image(beautiful.widget_pause)
		return ret_str .. span_bg_em("〓") .. args["{Artist}"]..'∙'.. args["{Title}"]
	else
		mpdicon:set_image(beautiful.widget_play)
		return ret_str .. span_bg_em("▶") .. args["{Artist}"]..'∙'.. args["{Title}"]
	end
end, 3)

-- Buttons
mpdwidget:buttons(awful.util.table.join(awful.button({ }, 1, 
function()
	local f = io.popen("mpc")
	p = f:read("*a")
	naughty.notify { text = span_fg_em(p), timeout = 5, hover_timeout = 0.5 }
end)))
mpdicon:buttons(mpdwidget:buttons())
-- }}}

-- {{{ NETWORK
-- Cache
vicious.cache(vicious.widgets.net)

-- UpSpeed/TX and DownSpeed/RX 
wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.net, span_fg_em("Ψ") ..
  span_color("green","↓${wlp3s0 down_kb}K") ..
  span_color("orange","↑${wlp3s0 up_kb}K"), 1)

-- Up graph
upgraph = awful.widget.graph()
upgraph:set_width(graphwidth):set_height(graphheight)
upgraph:set_border_color(nil)
upgraph:set_background_color(bg_widget)
upgraph:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(upgraph, vicious.widgets.net, "${wlp3s0 up_kb}")

-- Down graph
downgraph = awful.widget.graph()
downgraph:set_width(graphwidth):set_height(graphheight)
downgraph:set_border_color(nil)
downgraph:set_background_color(bg_widget)
downgraph:set_color({
  type = "linear",
  from = { 0, graphheight },
  to = { 0, 0 },
  stops = {
    { 0, cpu_low },
    { 0.50, cpu_mid },
    { 1, cpu_high }
  }})
vicious.register(downgraph, vicious.widgets.net, "${wlp3s0 down_kb}")

-- {{{ CLOCK
mytextclock = awful.widget.textclock("%a %R",1)
cal.register(mytextclock," [%s]")
--[[
   [clock_widget = wibox.widget.textbox()
   [vicious.register(clock_widget, vicious.widgets.date, "%R", 1)
   [
   [-- Buttons
   [clock_widget:buttons(awful.util.table.join(awful.button({ }, 1, 
   [function()
   [    local f = io.popen("cal -m")
   [    p = f:read("*a")
   [    naughty.notify { text = span_fg_em(p), timeout = 5, hover_timeout = 0.5 }
   [end)))
   ]]
-- }}}

-- {{{ WEATHER
weather = wibox.widget.textbox()
vicious.register(weather, vicious.widgets.weather,"${sky} ${tempc}°C",1800, "ZUUU")
weather:buttons(awful.util.table.join(awful.button({ }, 1, function()
	vicious.force({ weather, })
	--naughty.notify { text = 
	--span_fg_em("City :") ..span_bg_em(" ${city}\n")..
	--span_fg_em("Sky  :") ..span_bg_em(" ${sky}\n")..
	--span_fg_em("Temp :") ..span_bg_em(" ${tempc}\n")..
	--span_fg_em("Wind :") ..span_bg_em(" ${wind}\n")..
	--span_fg_em("Humid :") ..span_bg_em(" ${humid}\n")..
	--span_fg_em("Press:") ..span_bg_em(" ${press}")
	--, timeout = 5, hover_timeout = 0.5 }
end)))
-- }}}

-- {{{ PACMAN
-- Icon
pacicon = wibox.widget.imagebox()
pacicon:set_image(beautiful.widget_pac)

-- Upgrades
pacwidget = wibox.widget.textbox()
vicious.register(pacwidget, vicious.widgets.pkg, function(widget, args)
  if args[1] > 0 then
    pacicon:set_image(beautiful.widget_pacnew)
  else
    pacicon:set_image(beautiful.widget_pac)
  end

  return args[1]
end, 1801, "Arch S") -- Arch S for ignorepkg

-- Buttons
function popup_pac()
  local pac_updates = ""
  local f = io.popen("pacman -Sup --dbpath /tmp/pacsync")
  if f then
    pac_updates = f:read("*a"):match(".*/(.*)-.*\n$")
  end
  f:close()

  if not pac_updates then
    pac_updates = "System is up to date"
  end

	naughty.notify { text = span_fg_em(pac_updates), timeout = 5, hover_timeout = 0.5 }
end
pacwidget:buttons(awful.util.table.join(awful.button({ }, 1, popup_pac)))
pacicon:buttons(pacwidget:buttons())
-- }}}

-- {{{ VOLUME
-- Cache
vicious.cache(vicious.widgets.volume)

-- Icon
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)

-- Volume %
volpct = wibox.widget.textbox()
vicious.register(volpct, vicious.widgets.volume, "$1%", nil, "Master")

-- Buttons
volicon:buttons(awful.util.table.join(
  awful.button({ }, 1,
    function() awful.util.spawn_with_shell("ponymix toggle") end),
  awful.button({ }, 4,
    function() awful.util.spawn_with_shell("ponymix increase 1") end),
  awful.button({ }, 5,
    function() awful.util.spawn_with_shell("ponymix decrease 1") end)
))
volpct:buttons(volicon:buttons())
volspace:buttons(volicon:buttons())
-- }}}

-- {{{ BATTERY
-- Battery attributes
local bat_state  = ""
local bat_charge = 0
local bat_time   = 0
local blink      = true

-- Icon
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batfull)

-- Charge %
batpct = wibox.widget.textbox()
vicious.register(batpct, vicious.widgets.bat, function(widget, args)
  bat_state  = args[1]
  bat_charge = args[2]
  bat_time   = args[3]

  if args[1] == "−" then
    if bat_charge > 90 then
      baticon:set_image(beautiful.widget_batfull)
    elseif bat_charge > 30 then
      baticon:set_image(beautiful.widget_batmed)
    elseif bat_charge > 10 then
      baticon:set_image(beautiful.widget_batlow)
    elseif bat_charge > 3 then
      baticon:set_image(beautiful.widget_batempty)
			naughty.notify { text = span_fg_em("Charge :")..("Less 10%\n") .. span_fg_em("State  :")..("Hibernate at 3%"),
			timeout = 2, hover_timeout = 0.5 }
		else
			awful.util.spawn_with_shell("pm-hibernate")
    end
  else
    baticon:set_image(beautiful.widget_ac)
    if args[1] == "+" then
      blink = not blink
      if blink then
        baticon:set_image(beautiful.widget_acblink)
      end
    end
  end

  return args[2] .. "%"
end, nil, "BAT0")

-- Buttons
function popup_bat()
  local state = ""
  if bat_state == "↯" then
    state = "Full"
  elseif bat_state == "↯" then
    state = "Charged"
  elseif bat_state == "+" then
    state = "Charging"
  elseif bat_state == "−" then
    state = "Discharging"
  elseif bat_state == "⌁" then
    state = "Not charging"
  else
    state = "Unknown"
  end

  naughty.notify { text = span_fg_em("Charge : ") .. bat_charge .. "%\n" .. span_fg_em("State  : ") .. state ..
    " (" .. bat_time .. ")", timeout = 5, hover_timeout = 0.5 }
end
batpct:buttons(awful.util.table.join(awful.button({ }, 1, popup_bat)))
baticon:buttons(batpct:buttons())
-- }}}
