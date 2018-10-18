--
-- Addon       _rwc_init.lua
-- Author      marcob@marcob.org
-- StartDate   17/10/2018
--
local addon, rwc = ...
--
--	Function
--
rwc.f	=	{}

function rwc.f.round(num, digits)
   local floor = math.floor
   local mult = 10^(digits or 0)

   return floor(num * mult + .5) / mult
end


rwc.addon           =  {}
rwc.addon.name      =  Inspect.Addon.Detail(Inspect.Addon.Current())["name"]
rwc.addon.version   =  Inspect.Addon.Detail(Inspect.Addon.Current())["toc"]["Version"]
--
--
--
rwc.initialized	=	false
--
-- GUI
--
rwc.gui                   	=  {}
--
-- Coordinates
--
rwc.gui.win               	=  {}
rwc.gui.win.x             	=  0
rwc.gui.win.y             	=  0
rwc.gui.win.width         	=  50
rwc.gui.win.visible			=  true
--
-- Borders
--
rwc.gui.borders           	=  {}
rwc.gui.borders.left      	=  2
rwc.gui.borders.right     	=  2
rwc.gui.borders.bottom    	=  2
rwc.gui.borders.top       	=  2
--
-- Fonts
--
rwc.gui.font              	=  {}
rwc.gui.font.size         	=  14
rwc.gui.font.name         	=  nil
--
--
-- Colors table (Rift format)
--
rwc.gui.color             	=  {}
rwc.gui.color.black       	=  {  0,  0,  0, .5}
rwc.gui.color.deepblack   	=  {  0,  0,  0,  1}
rwc.gui.color.red         	=  { .2,  0,  0, .5}
rwc.gui.color.green       	=  {  0,  1,  0, .5}
rwc.gui.color.lightgreen  	=  {  0,  6,  0, .5}
rwc.gui.color.blue        	=  {  0,  0,  6, .1}
rwc.gui.color.lightblue   	=  {  0,  0, .4, .1}
rwc.gui.color.darkblue    	=  {  0,  0, .2, .1}
rwc.gui.color.grey        	=  { .5, .5, .5, .5}
rwc.gui.color.darkgrey    	=  { .2, .2, .2, .5}
rwc.gui.color.yellow      	=  {  1,  1,  0, .5}
rwc.gui.color.white       	=  {  9,  9,  9, .5}
--
--	End
--
