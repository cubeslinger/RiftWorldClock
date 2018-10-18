--
-- Addon       RiftWorldClock.lua
-- Author      marcob@marcob.org
-- StartDate   17/10/2018
--	Version		0.0.2
--
local addon, rwc = ...
--

local function updateguicoordinates(win, newx, newy)

   if win ~= nil then
      local winName = win:GetName()

      if winName == "rwc_window" then
         rwc.gui.win.x  =  round(newx)
         rwc.gui.win.y  =  round(newy)
      end
   end

   return
end


local function setup_ui()

	rwc.o	=	{}

	--Global context (parent frame-thing).
   local context  = UI.CreateContext("rwc_context")

   -- Main Window
   rwc.o.window  =  UI.CreateFrame("Frame", "rwc_window", context)

   if rwc.gui.win.x == nil or rwc.gui.win.y == nil then
      -- first run, we position in the screen center
      rwc.o.window:SetPoint("CENTER", UIParent, "CENTER")
   else
      -- we have coordinates
      rwc.o.window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", rwc.gui.win.x or 0, rwc.gui.win.y or 0)
   end
   rwc.o.window:SetLayer(-1)
   rwc.o.window:SetWidth(rwc.gui.win.width)
   rwc.o.window:SetBackgroundColor(unpack(rwc.gui.color.black))

   rwc.o.frame =  UI.CreateFrame("Frame", "rwc_frame", rwc.o.window)
	rwc.o.frame:SetAllPoints(rwc.o.window)
--    rwc.o.frame:SetBackgroundColor(unpack(rwc.gui.color.deepblack))
   rwc.o.frame:SetBackgroundColor(unpack(rwc.gui.color.darkgrey))
   rwc.o.frame:SetLayer(1)

	-- Window Title
   rwc.o.text =  UI.CreateFrame("Text", "mano_window_title", rwc.o.frame)
   rwc.o.text:SetFontSize(rwc.gui.font.size)
   rwc.o.text:SetLayer(3)
   rwc.o.text:SetPoint("CENTER", rwc.o.frame, "CENTER")


   -- RESIZER WIDGET
   rwc.o.corner  =  UI.CreateFrame("Texture", "rwc_corner", rwc.o.frame)
   rwc.o.corner:SetTexture("Rift", "chat_resize_(over).png.dds")
   rwc.o.corner:SetHeight(rwc.gui.font.size)
   rwc.o.corner:SetWidth(rwc.gui.font.size)
   rwc.o.corner:SetLayer(3)
   rwc.o.corner:SetPoint("BOTTOMRIGHT", rwc.o.frame, "BOTTOMRIGHT")
   rwc.o.corner:EventAttach(Event.UI.Input.Mouse.Right.Down,  function()
                                                                  local mouse = Inspect.Mouse()
                                                                  rwc.o.corner.pressed = true
                                                                  rwc.o.corner.basex   =  rwc.o.window:GetLeft()
                                                                  rwc.o.corner.basey   =  rwc.o.window:GetTop()
                                                               end,
                                                               "Event.UI.Input.Mouse.Right.Down")

   rwc.o.corner:EventAttach(Event.UI.Input.Mouse.Cursor.Move, function()
                                                                  if  rwc.o.corner.pressed then
                                                                     local mouse = Inspect.Mouse()
                                                                     rwc.gui.win.width  = rwc.f.round(mouse.x - rwc.o.corner.basex)
                                                                     rwc.gui.win.height = rwc.f.round(mouse.y - rwc.o.corner.basey)
                                                                     rwc.o.window:SetWidth(rwc.gui.win.width)
                                                                     rwc.o.window:SetHeight(rwc.gui.win.height)
                                                                  end
                                                               end,
                                                               "Event.UI.Input.Mouse.Cursor.Move")

   rwc.o.corner:EventAttach(Event.UI.Input.Mouse.Right.Upoutside,   function()
                                                                        rwc.o.corner.pressed = false
--                                                                         rwc.adjustheight()
                                                                     end,
                                                                     "RWC: Event.UI.Input.Mouse.Right.Upoutside")

   rwc.o.corner:EventAttach(Event.UI.Input.Mouse.Right.Up, function()
                                                               rwc.o.corner.pressed = false
--                                                                rwc.adjustheight()
                                                            end,
                                                            "RWC: Event.UI.Input.Mouse.Right.Up")



	Library.LibDraggable.draggify(rwc.o.window, updateguicoordinates)

	return

end

-- end

local function calctime_1()

	local seconds	=	tonumber(Inspect.Time.Server() * 3.4)
	local hour, hours, mins, secs	=	0, 0, 0, 0, 0

	if seconds > 0 then
		hours	=	string.format("%02.f", math.floor(seconds/3600));
-- 		hour	=	math.floor(seconds/3600)
		hour	=	seconds/3600
		while hour > 7.04	do hour	=	math.floor(hour - 7.04) end
		mins	= 	string.format("%02.f", math.floor(seconds/60 - (hours*60)))
		secs 	= 	string.format("%02.f", math.floor(seconds - hours*3600 - mins *60))
	end


	return hour, mins, secs
end


local function calctime_2()

	local secsinaday		=	86400			-- 86400 = 24 hours in seconds
	local secsinanhour	=	3600
	local secsinamin		=	60
	local multiplyfactor	=	3.42			--	3.4			--	1 sec real == 3.4 secs Telara

	local seconds			=	tonumber(Inspect.Time.Server())
	local hours, mins, secs	=	0, 0, 0, 0, 0
	local tsecs			=	seconds

	while tsecs > secsinaday do	tsecs = tsecs - secsinaday end

	if tsecs > 0 then

		local wsecs	=	(tsecs * multiplyfactor) + rwc.telatimeoffset	--	(7 * 60)

		while wsecs > secsinaday do	wsecs = wsecs - secsinaday end

		hours	=	math.floor(wsecs / secsinanhour)
		wsecs = 	wsecs - (secsinanhour * hours)

		mins	= 	math.floor(wsecs/secsinamin)
		wsecs	=	wsecs - (secsinamin * mins)

		secs 	= 	math.floor(wsecs)
	end

	return hours, mins, secs
end

local function showtime()

	local hours, mins, secs	=	calctime_2()
	local ampm					=	'am'
	if tonumber(hours) > 12 then ampm = 'pm' end

	-- Update Clock Text
	rwc.o.text:SetText(string.format("%s:%s:%s %s", hours, mins, secs, ampm))


	return
end

local function savevariables(_, addonname)

   if addon.name == addonname then

      -- Save Character GUI data
      rwcguidata    	=	rwc.gui.win
   end

   return
end

local function loadvariables(_, addonname)

   if addon.name == addonname then

      -- Character GUI data
      if rwcguidata then	rwc.gui.win	=	rwcguidata	end

      Command.Event.Detach(Event.Addon.SavedVariables.Load.End,   loadvariables,  "RWC: Load Variables")

		--	timer hook
		rwc.timer       =  __timer()
		rwc.timer.add(showtime, 1, true)

		setup_ui()

		rwc.initialized	=	true

   end

   return
end

Command.Event.Attach(Event.Addon.SavedVariables.Load.End,   loadvariables, "RWC: Load Variables")
Command.Event.Attach(Event.Addon.SavedVariables.Save.Begin, savevariables,	"RWC: Save Variables")
