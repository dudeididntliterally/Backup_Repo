if not game:IsLoaded() then game.Loaded:Wait() end
local g = getgenv()
g.Game = game -- dynamically updating.
local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local Workspace = g.Workspace or cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
local StarterGui = g.StarterGui or cloneref and cloneref(game:GetService("StarterGui")) or game:GetService("StarterGui")
local TextChatService = g.TextChatService or cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")
local UserInputService = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local SoundService = g.SoundService or cloneref and cloneref(game:GetService("SoundService")) or game:GetService("SoundService")
local avatar_editor = g.AvatarEditorService or cloneref and cloneref(game:GetService("AvatarEditorService")) or game:GetService("AvatarEditorService")
local ReplicatedStorage = g.ReplicatedStorage or cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
local parent_gui = (get_hidden_gui and get_hidden_gui()) or (gethui and gethui()) or CoreGui
local runservice = RunService
local InstanceNew = Instance.new
local orgDestroyHeight = workspace.FallenPartsDestroyHeight
g.Script_Creator = "👑 Flames Hub 👑"
g.Script_Owner = "✅ Flames Hub | ✅"
getgenv().Flames_Hub_Emojis = {
   ["Checkmark"] = "✅",
   ["Coin"] = "🪙",
   ["Fire"] = "🔥",
   ["Sunglasses"] = "😎",
   ["Smirk"] = "😏",
   ["Wink"] = "😉",
   ["Devil"] = "😈",
   ["Demon"] = "😈",
   ["MadDevil"] = "👿",
   ["MadDemon"] = "👿",
   ["Shop"] = "🏪"
}
g.Announcement_Banner_Notification_Emoji = g.Announcement_Banner_Notification_Emoji or "😎"
g.Chat_UI_Table_Stuff = {
   ["Owner_Chat_Tag"] = "✅ Flames Hub | OWNER (I made the script). ✅",
   ["Staff_Chat_Tag"] = "⚔️ | STAFF | ⚔️",
   ["Wifey_Chat_Tag"] = "💖 Girlfriend 💖"
}
g.Title_System_Texts_With_Emojis = {
   "⭐ Flames Hub | Settings ⭐"
}
g.Flames_Emojis_Content_Stuff = {
   ["Feedback_Menu_Title"] = "⭐ Flames Hub | Feedback ⭐",
   ["Feedback_Menu_Feedback_Selection"] = "👍 Feedback 👍",
   ["Feedback_Menu_Bug_Selection"] = "🕷️ Bug 🕷️",
   ["Feedback_Menu_Issue_Selection"] = "⚠️ Issue ⚠️",
   ["Feedback_Menu_User_Report_Selection"] = "❗ User Report ❗",
   ["Holiday_New_Years"] = "🎆",
   ["Holiday_Chocolate_Cake"] = "🎂",
   ["Holiday_Data_Privacy"] = "💻",
   ["Holiday_Hot_Chocolate"] = "🍵",
   ["Holiday_MLK"] = "✊🏿",
   ["Holiday_Valentines"] = "💘",
   ["Holiday_Texas"] = "🤠",
   ["Holiday_Groundhog"] = "🐿️",
   ["Holiday_Mail_Carrier"] = "✉️",
   ["Holiday_Pizza"] = "🍕",
   ["Holiday_Presidents"] = "🦅",
   ["Holiday_Bubble_Gum"] = "🍬",
   ["Holiday_Safer_Internet"] = "🖥️",
   ["Holiday_Pigs"] = "🐖",
   ["Holiday_Anthem_Sons"] = "🎶👦",
   ["Holiday_Grammar"] = "📚✍️",
   ["Holiday_Oreo"] = "🍪🥛",
   ["Holiday_Cereal"] = "🥣🥛",
   ["Holiday_St_Patricks"] = "🍀🇮🇪",
   ["Holiday_Easter"] = "🐰🥚",
   ["Holiday_Mothers"] = "💐💖",
   ["Holiday_Memorial"] = "🇺🇸🪖",
   ["Holiday_Fathers"] = "👔💙",
   ["Holiday_Independence"] = "🇺🇸🎆",
   ["Holiday_Dollar"] = "💵🤑",
   ["Holiday_Labor"] = "🛠️🇺🇸",
   ["Holiday_Columbus"] = "🧭🚢",
   ["Holiday_Halloween"] = "🎃👻",
   ["Holiday_Veterans"] = "🇺🇸🎖️",
   ["Holiday_Thanksgiving"] = "🦃🍂",
   ["Holiday_Christmas"] = "🎄🎁",
   ["Holiday_Donut"] = "🍩☕",
   ["Coin"] = "🪙"
}

if getgenv().anti_server_logging_enabled_flames_hub then
   getgenv().anti_server_logging_enabled_flames_hub = true
   local ok, ws_log_attr = pcall(function()
      return workspace:GetAttribute("loggingEnabled")
   end)

   if ok and ws_log_attr ~= false then workspace:SetAttribute("loggingEnabled", false) end
end

-- [[ Doesn't really work anyway. ]] --
--[[if not getgenv().Flames_Hub_Annoying_Messages_Blocker then
   getgenv().Flames_Hub_Annoying_Messages_Blocker = true
   if hookfunction and newcclosure then
      local Timer = g.Timer or require(ReplicatedStorage:FindFirstChild("Timer", true))
      if Timer and typeof(Timer) == "table" then
         local old_new
         old_new = hookfunction(Timer.new, newcclosure(function(interval, callback, ...)
            if interval >= 100 then
               if getgenv().notify then getgenv().notify("Success", "Flames Hub has blocked an annoying message.", 0.75) end
               return {
                  enabled = false,
                  start = function() end,
                  stop = function() end,
               }
            end

            return old_new(interval, callback, ...)
         end))
      end
   end
end--]]

local E = g.Flames_Emojis_Content_Stuff
local function wrap(t, e) return e.." "..t.." "..e end
g.getholiday = g.getholiday or function()
   local m = tonumber(os.date("%m"))
   local d = tonumber(os.date("%d"))
   local w = tonumber(os.date("%w"))
   local y = tonumber(os.date("%Y"))

   if m == 1 and d == 1 then return wrap("New Years", E["Holiday_New_Years"]) end
   if m == 1 and d == 27 then return wrap("National Chocolate Cake Day", E["Holiday_Chocolate_Cake"]) end
   if m == 1 and d == 28 then return wrap("Data Privacy Day", E["Holiday_Data_Privacy"]) end
   if m == 1 and d == 31 then return wrap("National Hot Chocolate Day", E["Holiday_Hot_Chocolate"]) end
   if m == 1 then
      local wd = tonumber(os.date("%w", os.time({year=y,month=1,day=1})))
      local off = (1 - wd + 7) % 7
      if d == 1 + off + 14 then return wrap("Martin Luther King Jr Day", E["Holiday_MLK"]) end
   end

   if m == 2 and d == 14 then return wrap("Valentines Day", E["Holiday_Valentines"]) end
   if m == 2 and d == 1 then return wrap("National Texas Day", E["Holiday_Texas"]) end
   if m == 2 and d == 2 then return wrap("Groundhog Day", E["Holiday_Groundhog"]) end
   if m == 2 and d == 4 then return wrap("National Mail Carrier Day", E["Holiday_Mail_Carrier"]) end
   if m == 2 and d == 9 then return wrap("National Pizza Day", E["Holiday_Pizza"]) end
   if m == 2 then
      local wd = tonumber(os.date("%w", os.time({year=y,month=2,day=1})))
      local off = (1 - wd + 7) % 7
      if d == 1 + off + 14 then return wrap("Presidents Day", E["Holiday_Presidents"]) end
   end
   if m == 2 then
      local wd = tonumber(os.date("%w", os.time({year=y,month=2,day=1})))
      local off = (5 - wd + 7) % 7
      if d == 1 + off then return wrap("Bubble Gum Day", E["Holiday_Bubble_Gum"]) end
   end
   if m == 2 then
      local wd = tonumber(os.date("%w", os.time({year=y,month=2,day=1})))
      local off = (2 - wd + 7) % 7
      if d == 1 + off + 7 then return wrap("Safer Internet Day", E["Holiday_Safer_Internet"]) end
   end

   if m == 3 and d == 1 then return wrap("National Pigs Day", E["Holiday_Pigs"]) end
   if m == 3 and d == 3 then return wrap("National Anthem Day / National Sons Day", E["Holiday_Anthem_Sons"]) end
   if m == 3 and d == 4 then return wrap("National Grammar Day", E["Holiday_Grammar"]) end
   if m == 3 and d == 6 then return wrap("National Oreo Cookie Day", E["Holiday_Oreo"]) end
   if m == 3 and d == 7 then return wrap("National Cereal Day", E["Holiday_Cereal"]) end
   if m == 3 and d == 17 then return wrap("St Patricks Day", E["Holiday_St_Patricks"]) end
   local function easterdate(year)
      local a = year % 19
      local b = math.floor(year / 100)
      local c = year % 100
      local d1 = math.floor(b / 4)
      local e = b % 4
      local f = math.floor((b + 8) / 25)
      local g = math.floor((b - f + 1) / 3)
      local h = (19 * a + b - d1 - g + 15) % 30
      local i = math.floor(c / 4)
      local k = c % 4
      local l = (32 + 2 * e + 2 * i - h - k) % 7
      local m1 = math.floor((a + 11 * h + 22 * l) / 451)
      local month = math.floor((h + l - 7 * m1 + 114) / 31)
      local day = ((h + l - 7 * m1 + 114) % 31) + 1
      return month, day
   end

   local em, ed = easterdate(y)
   if m == em and d == ed then return wrap("Easter", E["Holiday_Easter"]) end
   if m == 5 then
      if tonumber(os.date("%w", os.time({year=y,month=5,day=d}))) == 0 and d > 7 and d < 15 then
         return wrap("Mothers Day", E["Holiday_Mothers"])
      end
   end

   if m == 5 then
      local wd = tonumber(os.date("%w", os.time({year=y,month=5,day=31})))
      if d == 31 - wd then return wrap("Memorial Day", E["Holiday_Memorial"]) end
   end

   if m == 6 then
      if tonumber(os.date("%w", os.time({year=y,month=6,day=d}))) == 0 and d > 14 and d < 22 then
         return wrap("Fathers Day", E["Holiday_Fathers"])
      end
   end

   if m == 7 and d == 4 then return wrap("Independence Day", E["Holiday_Independence"]) end
   if m == 8 and d == 8 then return wrap("National Dollar Day", E["Holiday_Dollar"]) end
   if m == 9 then
      local wd = tonumber(os.date("%w", os.time({year=y,month=9,day=1})))
      local off = (1 - wd + 7) % 7
      if d == 1 + off then return wrap("Labor Day", E["Holiday_Labor"]) end
   end

   if m == 10 then
      local wd = tonumber(os.date("%w", os.time({year=y,month=10,day=1})))
      local off = (1 - wd + 7) % 7
      if d == 1 + off + 7 then return wrap("Columbus Day", E["Holiday_Columbus"]) end
   end

   if m == 10 and d == 31 then return wrap("Halloween", E["Holiday_Halloween"]) end
   if m == 11 and d == 11 then return wrap("Veterans Day", E["Holiday_Veterans"]) end
   local function thanksgivingdate(year)
      local t = os.time({year=year, month=11, day=1})
      local wd = tonumber(os.date("%w", t))
      local off = (4 - wd + 7) % 7
      return 1 + off + 21
   end

   if m == 11 and d == thanksgivingdate(y) then return wrap("Happy Thanksgiving", E["Holiday_Thanksgiving"]) end
   if m == 12 and d == 25 then return wrap("Christmas", E["Holiday_Christmas"]) end
   if m == 6 then
      local wd = tonumber(os.date("%w", os.time({year=y,month=6,day=1})))
      local off = (5 - wd + 7) % 7
      if d == 1 + off then return wrap("National Donut Day", E["Holiday_Donut"]) end
   end

   return nil
end
local _na_env = g
local Lower    = string.lower
local Sub      = string.sub
local GSub     = string.gsub
local Find     = string.find
local Match    = string.match
local Format   = string.format
local Unpack   = table.unpack
local Insert   = table.insert
local Concat   = table.concat
local Discover = table.find
local Spawn    = task.spawn
local Delay    = task.delay
local Wait     = task.wait
local Defer    = task.defer
local LocalPlayer = g.LocalPlayer or Players.LocalPlayer
g.flingManager = g.flingManager or { FlingOldPos = nil; lFlingOldPos = nil; cFlingOldPos = nil; }
local color_mapper = {
   red = Color3.fromRGB(255,0,0),
   darkred = Color3.fromRGB(139,0,0),
   crimson = Color3.fromRGB(220,20,60),
   firebrick = Color3.fromRGB(178,34,34),
   indianred = Color3.fromRGB(205,92,92),
   lightcoral = Color3.fromRGB(240,128,128),
   salmon = Color3.fromRGB(250,128,114),
   darksalmon = Color3.fromRGB(233,150,122),
   lightsalmon = Color3.fromRGB(255,160,122),
   tomato = Color3.fromRGB(255,99,71),
   orangered = Color3.fromRGB(255,69,0),
   orange = Color3.fromRGB(255,165,0),
   darkorange = Color3.fromRGB(255,140,0),
   coral = Color3.fromRGB(255,127,80),
   yellow = Color3.fromRGB(255,255,0),
   lightyellow = Color3.fromRGB(255,255,224),
   gold = Color3.fromRGB(255,215,0),
   goldenrod = Color3.fromRGB(218,165,32),
   darkgoldenrod = Color3.fromRGB(184,134,11),
   palegoldenrod = Color3.fromRGB(238,232,170),
   khaki = Color3.fromRGB(240,230,140),
   darkkhaki = Color3.fromRGB(189,183,107),
   lemonchiffon = Color3.fromRGB(255,250,205),
   green = Color3.fromRGB(0,128,0),
   lime = Color3.fromRGB(0,255,0),
   limegreen = Color3.fromRGB(50,205,50),
   forestgreen = Color3.fromRGB(34,139,34),
   darkgreen = Color3.fromRGB(0,100,0),
   seagreen = Color3.fromRGB(46,139,87),
   mediumseagreen = Color3.fromRGB(60,179,113),
   lightseagreen = Color3.fromRGB(32,178,170),
   springgreen = Color3.fromRGB(0,255,127),
   mediumspringgreen = Color3.fromRGB(0,250,154),
   palegreen = Color3.fromRGB(152,251,152),
   lightgreen = Color3.fromRGB(144,238,144),
   olivedrab = Color3.fromRGB(107,142,35),
   darkolivegreen = Color3.fromRGB(85,107,47),
   olive = Color3.fromRGB(128,128,0),
   chartreuse = Color3.fromRGB(127,255,0),
   lawngreen = Color3.fromRGB(124,252,0),
   greenyellow = Color3.fromRGB(173,255,47),
   yellowgreen = Color3.fromRGB(154,205,50),
   blue = Color3.fromRGB(0,0,255),
   navy = Color3.fromRGB(0,0,128),
   darkblue = Color3.fromRGB(0,0,139),
   mediumblue = Color3.fromRGB(0,0,205),
   royalblue = Color3.fromRGB(65,105,225),
   steelblue = Color3.fromRGB(70,130,180),
   lightsteelblue = Color3.fromRGB(176,196,222),
   dodgerblue = Color3.fromRGB(30,144,255),
   deepskyblue = Color3.fromRGB(0,191,255),
   skyblue = Color3.fromRGB(135,206,235),
   lightskyblue = Color3.fromRGB(135,206,250),
   cornflowerblue = Color3.fromRGB(100,149,237),
   cadetblue = Color3.fromRGB(95,158,160),
   midnightblue = Color3.fromRGB(25,25,112),
   slateblue = Color3.fromRGB(106,90,205),
   mediumslateblue = Color3.fromRGB(123,104,238),
   darkslateblue = Color3.fromRGB(72,61,139),
   powderblue = Color3.fromRGB(176,224,230),
   lightblue = Color3.fromRGB(173,216,230),
   purple = Color3.fromRGB(128,0,128),
   darkpurple = Color3.fromRGB(75,0,100),
   rebeccapurple = Color3.fromRGB(102,51,153),
   indigo = Color3.fromRGB(75,0,130),
   violet = Color3.fromRGB(238,130,238),
   darkviolet = Color3.fromRGB(148,0,211),
   blueviolet = Color3.fromRGB(138,43,226),
   mediumpurple = Color3.fromRGB(147,112,219),
   mediumorchid = Color3.fromRGB(186,85,211),
   darkorchid = Color3.fromRGB(153,50,204),
   orchid = Color3.fromRGB(218,112,214),
   plum = Color3.fromRGB(221,160,221),
   thistle = Color3.fromRGB(216,191,216),
   lavender = Color3.fromRGB(230,230,250),
   magenta = Color3.fromRGB(255,0,255),
   fuchsia = Color3.fromRGB(255,0,255),
   darkmagenta = Color3.fromRGB(139,0,139),
   pink = Color3.fromRGB(255,192,203),
   lightpink = Color3.fromRGB(255,182,193),
   hotpink = Color3.fromRGB(255,105,180),
   deeppink = Color3.fromRGB(255,20,147),
   mediumvioletred = Color3.fromRGB(199,21,133),
   palevioletred = Color3.fromRGB(219,112,147),
   cyan = Color3.fromRGB(0,255,255),
   aqua = Color3.fromRGB(0,255,255),
   teal = Color3.fromRGB(0,128,128),
   darkcyan = Color3.fromRGB(0,139,139),
   darkturquoise = Color3.fromRGB(0,206,209),
   mediumturquoise = Color3.fromRGB(72,209,204),
   turquoise = Color3.fromRGB(64,224,208),
   paleturquoise = Color3.fromRGB(175,238,238),
   aquamarine = Color3.fromRGB(127,255,212),
   mediumaquamarine = Color3.fromRGB(102,205,170),
   brown = Color3.fromRGB(165,42,42),
   darkbrown = Color3.fromRGB(101,67,33),
   saddlebrown = Color3.fromRGB(139,69,19),
   sienna = Color3.fromRGB(160,82,45),
   chocolate = Color3.fromRGB(210,105,30),
   peru = Color3.fromRGB(205,133,63),
   tan = Color3.fromRGB(210,180,140),
   burlywood = Color3.fromRGB(222,184,135),
   wheat = Color3.fromRGB(245,222,179),
   sandybrown = Color3.fromRGB(244,164,96),
   rosybrown = Color3.fromRGB(188,143,143),
   maroon = Color3.fromRGB(128,0,0),
   white = Color3.fromRGB(255,255,255),
   black = Color3.fromRGB(0,0,0),
   gray = Color3.fromRGB(128,128,128),
   grey = Color3.fromRGB(128,128,128),
   lightgray = Color3.fromRGB(211,211,211),
   lightgrey = Color3.fromRGB(211,211,211),
   darkgray = Color3.fromRGB(169,169,169),
   darkgrey = Color3.fromRGB(169,169,169),
   silver = Color3.fromRGB(192,192,192),
   dimgray = Color3.fromRGB(105,105,105),
   dimgrey = Color3.fromRGB(105,105,105),
   slategray = Color3.fromRGB(112,128,144),
   slategrey = Color3.fromRGB(112,128,144),
   lightslategray = Color3.fromRGB(119,136,153),
   lightslategrey = Color3.fromRGB(119,136,153),
   darkslategray = Color3.fromRGB(47,79,79),
   darkslategrey = Color3.fromRGB(47,79,79),
   gainsboro = Color3.fromRGB(220,220,220),
   whitesmoke = Color3.fromRGB(245,245,245),
   beige = Color3.fromRGB(245,245,220),
   ivory = Color3.fromRGB(255,255,240),
   snow = Color3.fromRGB(255,250,250),
   honeydew = Color3.fromRGB(240,255,240),
   mintcream = Color3.fromRGB(245,255,250),
   azure = Color3.fromRGB(240,255,255),
   aliceblue = Color3.fromRGB(240,248,255),
   ghostwhite = Color3.fromRGB(248,248,255),
   linen = Color3.fromRGB(250,240,230),
   antiquewhite = Color3.fromRGB(250,235,215),
   bisque = Color3.fromRGB(255,228,196),
   moccasin = Color3.fromRGB(255,228,181),
   peachpuff = Color3.fromRGB(255,218,185),
   mistyrose = Color3.fromRGB(255,228,225),
   lavenderblush = Color3.fromRGB(255,240,245),
   seashell = Color3.fromRGB(255,245,238),
   oldlace = Color3.fromRGB(253,245,230),
   floralwhite = Color3.fromRGB(255,250,240),
   cornsilk = Color3.fromRGB(255,248,220),
   blanchedalmond = Color3.fromRGB(255,235,205),
   navajowhite = Color3.fromRGB(255,222,173),
   papayawhip = Color3.fromRGB(255,239,213),
}
wait(0.1)
local FL = g.FlamesLibrary
local fw = FL.wait
g.big_color_mapper = g.big_color_mapper or color_mapper
g.isProperty = g.isProperty or function(inst, prop)
	local s, r = pcall(function() return inst[prop] end)
	if not s then return nil end
	return r
end

g.hasProp = g.hasProp or function(inst, prop)
   return inst and isProperty(inst, prop) ~= nil
end

g.setProperty = g.setProperty or function(inst, prop, v)
	local s, _ = pcall(function() inst[prop] = v end)
	return s
end

g.safeSet = g.safeSet or function(inst, prop, val)
   if inst and hasProp(inst, prop) then setProperty(inst, prop, val) end
end

g.cmdsString = [[
   {prefix}rgbcar - Enables RGB/Rainbow Vehicle (FE Rainbow Vehicle).
   {prefix}unrgbcar - Disables RGB/Rainbow Vehicle (FE, Rainbow Vehicle).
   {prefix}collectall (🔥 NEWEST + EVENT 🔥) - Collects all of the NBA event items so you can get the badge instantly (FE).
   {prefix}serverinv (💬 DISCORD 🗨️) - Gives you our invite to our Discord server.
   {prefix}twotonecar - Enables Two Tone Vehicle (flashes two colors, FE).
   {prefix}untwotonecar - Disables Two Tone Vehicle (flashes two colors, FE).
   {prefix}infpremium - Executes Infinite Premium.
   {prefix}alwaysshowtitles - Always shows everyones titles / bios when they chat.
   {prefix}alwayshidetitles - Always hides everyones titles / bios when they chat.
   {prefix}infyield - Executes regular Infinite Yield.
   {prefix}nameless - Executes Nameless Admin (FE Admin).
   {prefix}streamermode - Gives you a GUI that allows you to hide your username and other usernames while rec/live streaming.
   {prefix}spawnfire NUMBER - Spawns fire with a specified number argument.
   {prefix}rainbowcar [Player] - Makes a players car RGB (FRIENDS ONLY!, FE).
   {prefix}chatbypass (🗨️ working 💬) - Executes a chat workaround script, which lets you type to other users freely.
   {prefix}copyav [Player] (🔥POPULAR FEATURE🔥) - Copies the target players avatar/outfit in full (animations, body, everything! FE!).
   {prefix}norainbowcar [Player] - Disables the RGB for a players car (FRIENDS ONLY!, FE).
   {prefix}annoyergui - Enables the GUI that lets you pick and toggle annoy players (FE).
   {prefix}rgbstreetlights - Enables RGB StreetLights (flashing Rainbow StreetLights, NOT FE! VISUAL!).
   {prefix}unrgbstreetlights - Disables RGB StreetLights (NOT FE! VISUAL!).
   {prefix}signspam - Spams the text on your Tool Sign (FE).
   {prefix}unsignspam - Stops spamming the text on your Tool Sign.
   {prefix}countcmds - Tells you how many commands are currently in Flames Hub right now.
   {prefix}carfly SPEED - Enables a working (not wacky) VehicleFly that will not break your car too, also is entirely FE.
   {prefix}uncarfly - Disables Vehicle-Fly.
   {prefix}debugger - Executes Flames Debugger GUI, so if you have a problem with the script, it'll bring up a menu to tell you if our functions work or not.
   {prefix}orbit [Player] [Speed] [Distance] - Lets you Orbit around the target Player (FE).
   {prefix}size [number] - Makes your Character what ever size you put in (FE, bypasses height limit!).
   {prefix}normalsize - Makes your Character normal size again (FE).
   {prefix}unorbit - Stops orbiting the target Player.
   {prefix}blockcalls - Enables call_blocker_V2, which stops all calls from coming in (auto hangs up, FE).
   {prefix}unblockcalls - Disables Call_Blocker_V2 (FE).
   {prefix}msggui - Gives you a GUI that lets you send messages automatically through the Phone system in-game (FE).
   {prefix}float (😎 FIXED! 😎) - Allows you to literally float in the air and go up and down (FE) (better than Infinite Yields version).
   {prefix}unfloat - Disables the 'float' command.
   {prefix}lockhome - Locks your current Home (FE).
   {prefix}unlockhome - Unlocks your current Home (FE).
   {prefix}statsgui - Gives you the menu at the top displaying your FPS, ping, etc.
   {prefix}lockplrhome [Player] - Locks the target players house (FE).
   {prefix}unlockplrhome [Player] - Unlocks the target players house (FE).
   {prefix}autolockhome - Automatically locks your house when unlocked (FE).
   {prefix}unautolockhome - Disables 'autolockhome' command.
   {prefix}ban [Player] - Bans the player from your Private Server (FE, ONLY works in YOUR priv server).
   {prefix}unban [Player] - Unbans the player from your Private Server (FE, ONLY works in YOUR priv server).
   {prefix}walkfling - Enables WalkFling.
   {prefix}unwalkfling - Disables WalkFling.
   {prefix}setspawn - Will set your Spawn Point where you're at currently, once you respawn, you'll teleport back to that spot.
   {prefix}unsetsp - Disables the 'setspawn' command and clears Spawn Point.
   {prefix}stealcar [Player] - Allows you to swiftly take someones car, so if they have one spawned, it'll automatically jump in it.
   {prefix}wfwl [Player] - Whitelists the Player to WalkFling (you won't fling them when walking).
   {prefix}unwfwl [Player] - Removes that Player from the WalkFling Whitelist.
   {prefix}speed Number - Changes your WalkSpeed.
   {prefix}jp Number - Changes your JumpHeight.
   {prefix}grav Number - Changes your Gravity.
   {prefix}caresp - Enables Vehicle ESP, which lets you see all cars through walls from anywhere.
   {prefix}uncaresp - Disables Vehicle ESP.
   {prefix}esp - Enables Player ESP, which allows you to see any Player anywhere through walls.
   {prefix}unesp - Disables the Player ESP command.
   {prefix}traceresp - Enables Tracer ESP, which puts a Line on every Player anywhere.
   {prefix}untraceresp - Disables the Tracer ESP command.
   {prefix}saveanim - Saves the currently playing Animation to Flames Emotes GUI, so that you can play it once you load it back up.
   {prefix}namespam - Spam changes your name (no hashtags! FE!).
   {prefix}unnamespam - Unspam changes your name (turns off 'namespam').
   {prefix}orbitspeed NewSpeed - Lets you modify your Orbit speed.
   {prefix}antifitstealer (👑 #1 FEATURE 👑) - Allows you to toggle on Anti Outfit Copier (FE).
   {prefix}unanticopyfit - Disables Anti Outfit Copier (FE).
   {prefix}hidedelta - Hides the Delta button icon (if you're using Delta).
   {prefix}unhidedelta - Shows the Delta button icon (if you're using Delta).
   {prefix}outfitsui (🔥POPULAR FEATURE🔥) - Allows you to save how ever many outfits you want with our new GUI.
   {prefix}anticarfling (🔥HOT🔥) - Enables 'anticarfling', preventing you from being flung by Vehicles.
   {prefix}unanticarfling - Disables 'anticarfling' command.
   {prefix}rainbowtime [Player] NUMBER - Sets your whitelisted friends rainbow car speed.
   {prefix}unadmin [Player] - Removes the player's FE commands (if they're your friend).
   {prefix}admin [Player] - Adds the player to the FE commands whitelist (if they're your friend).
   {prefix}rgbskin - Enable RGB Skin (flashing Rainbow Skintone).
   {prefix}unrgbskin - Disable RGB Skin (flashing Rainbow Skintone).
   {prefix}checkpremium [Player] - Checks if a player has premium or not.
   {prefix}rgbphone (🔥HOT🔥) - Enable RGB Phone (flashing Rainbow Phone).
   {prefix}unrgbphone - Disable RGB Phone (flashing Rainbow Phone).
   {prefix}fpsboost - Lag reducer that boosts your FPS (sort of).
   {prefix}updlogs - Shows you a menu with all the recent updates, making it easier to know what was added/removed/changed.
   {prefix}startrgbtool - Enables RGB Tool (FE, Flashing Rainbow Tool).
   {prefix}stoprgbtool - Disables RGB Tool (FE, Flashing Rainbow Tool).
   {prefix}glitchoutfit - Enables the glitching of your outfit.
   {prefix}noglitchoutfit - Disables the glitching of your outfit.
   {prefix}copyanim [Player] - Copies the Animation/Emote that 'Player' is doing.
   {prefix}stoptime - Stops the current time (FE, priv server only!).
   {prefix}resumetime - Resumes the current time (FE, priv server only!).
   {prefix}loopfling [Player] - Allows you loop-fling someone even when they die and respawn (FE).
   {prefix}unloopfling - Disables the 'loopfling' command entirely.
   {prefix}privserver - Notifies you who the Private Server owner is (if you're in a private server).
   {prefix}flashweather - Makes the current weather flash fast (FE, priv server only!).
   {prefix}unflashweather - Stops Weather Flasher (FE) (priv server only!).
   {prefix}flashtime - Makes the current time flash fast (FE, priv server only!).
   {prefix}unflashtime - Stops Time Flasher (FE) (priv server only!).
   {prefix}slock - Allows you lock your priv server (nobody will be able to join, FE, priv server only!).
   {prefix}unslock - Disables 'slock' command (priv server only!).
   {prefix}slockgui - Gives you a GUI to add people to server-lock whitelist (FE, priv server only!).
   {prefix}kick [Player] - Kicks the player from your Private Server (ur priv server only! FE).
   {prefix}spin Speed - Spins your character at the provided speed (FE).
   {prefix}unspin - Unspins your character.
   {prefix}flames - Spams fire all over you (if you actually have LifePay/Premium, FE).
   {prefix}noflames - Disables the spamming of fire.
   {prefix}antifire (💯 REBRAND 💯) - Automatically destroys any Fire being spawned into the game.
   {prefix}unantifire (💯 REBRAND 💯) - Disables the anti-fire command.
   {prefix}wseditor (💻🖱️ DEBUG 🖱️💻) - Executes Workspace Editor, which allows you to basically literally edit the Workspace (where the parts and models and stuff are).
   {prefix}carstats - Gives you a GUI that lets you see the speed of other Vehicles and spawn them with their settings (speed, color, etc) FE.
   {prefix}name NewName - Lets you change your RP name.
   {prefix}bio NewBio - Lets you change your RP bio.
   {prefix}mutetools - Mutes all Boomboxes, Speakers and other tools in the game that play music.
   {prefix}unmutetools - Unmutes all Boomboxes, Speakers and other tools in the game that play music.
   {prefix}freeemotes - Gives you the Free Emotes GUI.
   {prefix}allcars - Gives you the GUI list that shows all the car names.
   {prefix}noemote - Disables any emote you are currently doing.
   {prefix}needy - Makes you basically Twerk (FE), bro?.
   {prefix}griddy - Makes you do the Griddy emote (FE).
   {prefix}jiggy - Makes you do the Jiggy emote(s) (FE).
   {prefix}scenario - Makes you do the Scenario emote (FE).
   {prefix}superman - Makes you do the Superman emote (FE).
   {prefix}zen - Makes you do the Zen emote (FE).
   {prefix}orangej - Makes you do the Orange Justice emote (FE).
   {prefix}aurafarm - Makes you do an Aura Float emote (FE).
   {prefix}worm - Makes you do The Worm emote (FE).
   {prefix}jabba - Makes you do the Jabba emote (FE).
   {prefix}popular - Makes you do the Popular emote (FE).
   {prefix}defaultd - Makes you do the Default Dance emote (FE).
   {prefix}kotonai - Makes you do the Koto Nai emote (FE).
   {prefix}glitching - Makes you do the Glitching emote (FE).
   {prefix}billyjean - Makes you do the Billie Jean emote (FE).
   {prefix}billybounce - Makes you do the Billy Bounce emote (FE).
   {prefix}michaelmyers - Makes you do the Michael Myers emote (FE).
   {prefix}sturdy - Makes you do the New York Sturdy emote (FE).
   {prefix}eshuffle - Makes you do the Electro Shuffle emote (FE).
   {prefix}takethel - Makes you do the Take The L emote (FE).
   {prefix}laughitup - Makes you do the Donkey Laugh emote (FE).
   {prefix}reanimated - Makes you do the Reanimated emote (FE).
   {prefix}motion - Makes you do the Motion emote (FE).
   {prefix}tuff - Makes you do the Tuff emote (FE).
   {prefix}config - Shows you the Configuration Manager GUI.
   {prefix}antirgbphone - Enables Anti RGB Phone (boosts performance!).
   {prefix}unantirgbphone - Disables Anti RGB Phone, potentially reducing performance.
   {prefix}antivoid - Enables anti-void.
   {prefix}unantivoid - Disables anti-void.
   {prefix}alljobs - Repeatedly spams all jobs.
   {prefix}jobsoff - Stops spamming all jobs.
   {prefix}fly Speed - Enable/disable flying.
   {prefix}unfly - Disables (Fly) command.
   {prefix}fly3 - Enables Fly-3, which is like Adonis Admins Fly.
   {prefix}unfly3 - Disables Fly-3.
   {prefix}annoy [Player] - Spam calls + spam request carries the target player (FE).
   {prefix}unannoy - Disables annoy player system.
   {prefix}fly2 Speed - Enables magic carpet fly (ONLY VISUAL rainbow!).
   {prefix}unfly2 - Disables Fly2/Magic carpet fly (with the client side rainbow).
   {prefix}noclip - Enables Noclip, letting you walk through everything.
   {prefix}clip - Disables Noclip, so you cannot walk through everything.
   {prefix}trailer - Gives you the WaterSkies trailer (on any car/vehicle).
   {prefix}notrailer - Removes the WaterSkies trailer (on your current spawned car/vehicle).
   {prefix}autolockcar - Automatically (loop) locks your vehicle/car when there is one spawned.
   {prefix}unautolockcar - Turn off/disables the loop that automatically locks your vehicle/car.
   {prefix}lockcar - Locks your car.
   {prefix}unlockcar - Unlocks your car.
   {prefix}despawn - Despawns your car.
   {prefix}viewcar - Views your Vehicle.
   {prefix}unviewcar - Unviews your Vehicle.
   {prefix}blacklist [Player] - Blacklists friends you specify from using the admin commands (even if they are already on).
   {prefix}unblacklist [Player] - Removes the blacklist from the friend you specified in the 'blacklist' command, allowing them to do ;rgbcar and such again.
   {prefix}antifling - Fully prevents you from being flung, by other exploiters/cheaters, and fling outfits (FULL BYPASS).
   {prefix}unantifling - Disables anti-fling.
   {prefix}friend [Player] - Lets you add someone in the server via this script.
   {prefix}unfriend [Players] - Lets you unadd someone in the server via this script.
   {prefix}bringcar - Teleport car to you and sit in it.
   {prefix}flashname - Enables the flashing of your "Bio" and "Name" (above your head).
   {prefix}unflashname - Disables the flashing of your "Bio" and "Name" (above your head).
   {prefix}invis - Allows you to go Invisible (for free) via the teleport method (FE).
   {prefix}uninvis - Turns off the 'invis' command and makes you visible.
   {prefix}flashinvis - Enables the flashing of the invisibility GamePass for you're character (you need to actually own the GamePass).
   {prefix}noflashinvis - Disables the flashing of the invisibility GamePass for you're character (you need to actually own the GamePass).
   {prefix}nosit - Prevents you from sitting down.
   {prefix}resit - Stops the 'nosit' command, allowing you to sit down again.
   {prefix}view [Player] - Smooth view's the target's Character.
   {prefix}unview - Disables the 'view' command.
   {prefix}void [Player] - Uses the SchoolBus Vehicle to void the target.
   {prefix}kill [Player] - Uses the SchoolBus Vehicle to kill the target.
   {prefix}bring [Player] - Uses the SchoolBus Vehicle to bring the target.
   {prefix}goto [Player] - Teleports your Character to the target player.
   {prefix}skydive [Player] - Uses the SchoolBus Vehicle to skydive the target.
   {prefix}freepay - Gives you LifePay Premium for free (no premium houses!).
   {prefix}rejoin - Makes you rejoin the current server.
   {prefix}caraccel Number - Modifies your "max_acc" on your car/vehicle.
   {prefix}carspeed Number - Modifies your "max_speed" on your car/vehicle.
   {prefix}accel Number - Modifies your "acc_0_60" on your car/vehicle (take off time/speed).
   {prefix}turnangle Number - Modifies your "turn_angle" on your car/vehicle (how fast you turn).
   {prefix}gotocar - Teleports you straight to your car/vehicle directly.
   {prefix}tpcar [Player] - Teleports your vehicle/car to the specified target.
   {prefix}antihouseban - Prevents you from being banned/kicked/teleported out of houses.
   {prefix}unantiban - Turns off 'antihouseban' command.
   {prefix}spawn CarName - Allows you to spawn any Vehicle in the game (FE).
   {prefix}prefix NewPrefixHere - Changes your prefix.
   {prefix}cmds - Displays all the available commands.
   {prefix}inject - Secret (⚔️).
]]

if not g.LocalPlayer then g.LocalPlayer = LocalPlayer or Players.LocalPlayer end
local function safe(p) return p and typeof(p) == "Instance" end
local function try(f) local ok = pcall(f) return ok end
local control_module = require(g.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
g.heartbeat_wait_function = g.heartbeat_wait_function or function(timeout)
   local rs = g.RunService or RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
   local start = os.clock()
   while true do
      if timeout and os.clock() - start >= timeout then
         break
      end
      if rs and rs.Heartbeat then
         rs.Heartbeat:Wait()
      else
         task.wait()
      end
      break
   end
end

Foreach = function(Table, Func, Loop)
	for Index, Value in next, Table do
		pcall(function()
			if Loop and typeof(Value) == 'table' then
				for Index2, Value2 in next, Value do
					Func(Index2, Value2)
				end
			else
				Func(Index, Value)
			end
		end)
	end
end

do
   local tabs = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")
   if tabs then try(function() tabs.Enabled = true end) end
end

g.NA_GRAB_BODY = g.NA_GRAB_BODY or (function()
	local T = {};
	local _cache = setmetatable({}, {
		__mode = "k"
	});
	local overrideModel = nil;
	local overrideConn = nil;
	local selectingOverride = false;
	local setOverrideModel;
	local pickOverrideModel;
	local function asChar(obj)
		if not obj or typeof(obj) ~= "Instance" then
			return nil;
		end;
		if obj:IsA("Player") then
			return obj.Character;
		end;
		if obj:IsA("Model") then
			return obj;
		end;
		return nil;
	end;
	local function firstPart(model)
		for _, d in ipairs(model:GetDescendants()) do
			if d:IsA("BasePart") then
				return d;
			end;
		end;
		return nil;
	end;
	setOverrideModel = function(model)
		if overrideConn then
			overrideConn:Disconnect();
			overrideConn = nil;
		end;
		overrideModel = model;
		if model then
			overrideConn = model.AncestryChanged:Connect(function(_, parent)
				if not parent then
					if overrideConn then
						overrideConn:Disconnect();
						overrideConn = nil;
					end;
					overrideModel = nil;
					selectingOverride = false;
					if Players and Players.LocalPlayer and workspace then
						local lp = Players.LocalPlayer;
						local cur = lp.Character;
						if cur and cur.Parent and (not cur:IsDescendantOf(workspace)) then
							Spawn(function()
								pickOverrideModel();
							end);
						end;
					end;
				end;
			end);
		end;
	end;
	pickOverrideModel = function(force)
		if selectingOverride then
			return overrideModel;
		end;
		if not (Players and Players.LocalPlayer and workspace) then
			return overrideModel;
		end;
		local lp = Players.LocalPlayer;
		local cur = lp.Character;
		if not cur then
			return overrideModel;
		end;
		if not force and cur:IsDescendantOf(workspace) then
			return overrideModel;
		end;
		selectingOverride = true;
		local btns = {};
		local cands = {};
		local seen = {};
		for _, plr in ipairs(Players:GetPlayers()) do
			local ch = plr.Character;
			if ch and ch:IsDescendantOf(workspace) and (not seen[ch]) then
				seen[ch] = true;
				Insert(cands, ch);
			end;
		end;
		for _, inst in ipairs(workspace:GetDescendants()) do
			if inst:IsA("Model") and CheckIfNPC and CheckIfNPC(inst) and (not seen[inst]) then
				seen[inst] = true;
				Insert(cands, inst);
			end;
		end;
		local nCnt = {};
		for i = 1, #cands do
			local m = cands[i];
			local n = m.Name;
			nCnt[n] = (nCnt[n] or 0) + 1;
		end;
		local nUse = {};
		local done = false;
		local function fin()
			if done then
				return;
			end;
			done = true;
			selectingOverride = false;
		end;
		if #cands == 0 then
			Insert(btns, {
				Text = "No characters found",
				Callback = function()
					setOverrideModel(nil);
					fin();
				end
			});
		else
			for i = 1, #cands do
				local m = cands[i];
				local n = m.Name;
				local suffix = "";
				if nCnt[n] and nCnt[n] > 1 then
					nUse[n] = (nUse[n] or 0) + 1;
					suffix = " (" .. nUse[n] .. ")";
				end;
				Insert(btns, {
					Text = n .. suffix,
					Callback = function()
						setOverrideModel(m);
						fin();
					end
				});
			end;
		end;
		Insert(btns, {
			Text = "Cancel",
			Callback = function()
				setOverrideModel(nil);
				fin();
			end
		});
		return overrideModel;
	end;
	local function rebuild(model, rec)
		rec.head = nil;
		rec.root = nil;
		rec.torso = nil;
		rec.humanoid = nil;
		if not model then
			rec.dirty = false;
			return rec;
		end;
		for _, inst in ipairs(model:GetDescendants()) do
			if inst:IsA("Humanoid") or inst:IsA("AnimationController") then
				rec.humanoid = rec.humanoid or inst;
			elseif inst:IsA("BasePart") then
				local name = inst.Name:lower();
				if name:find("root") then
					rec.root = rec.root or inst;
				elseif name:find("torso") then
					rec.torso = rec.torso or inst;
				elseif name:find("head") then
					rec.head = rec.head or inst;
				end;
			end;
		end;
		rec.dirty = false;
	end;
	local function ensure(obj)
		local model = asChar(obj);
		if obj == Players.LocalPlayer then
			if overrideModel then
				model = overrideModel;
			elseif model and model.Parent and (not model:IsDescendantOf(workspace)) then
				model = pickOverrideModel(true) or model;
			end;
		elseif not model then
			model = overrideModel;
		end;
		if not model then
			return nil;
		end;
		local rec = _cache[model];
		if not rec then
			rec = {
				dirty = true
			};
			_cache[model] = rec;
			rec.a = model.DescendantAdded:Connect(function()
				rec.dirty = true;
			end);
			rec.r = model.DescendantRemoving:Connect(function()
				rec.dirty = true;
			end);
			rec.c = model.AncestryChanged:Connect(function(_, parent)
				if not parent then
					if rec.a then
						rec.a:Disconnect();
					end;
					if rec.r then
						rec.r:Disconnect();
					end;
					if rec.c then
						rec.c:Disconnect();
					end;
					_cache[model] = nil;
				end;
			end);
		end;
		if rec.dirty or rec.humanoid and rec.humanoid.Parent == nil then
			rebuild(model, rec);
		end;
		return rec, model;
	end;
	T.ensure = ensure;
	T.firstPart = firstPart;
	T.asChar = asChar;
	T.pickOverride = function()
		selectingOverride = false;
		setOverrideModel(nil);
		return pickOverrideModel(true);
	end;
	return T;
end)();

function getRoot(char)
	local rec, model = NA_GRAB_BODY.ensure(char)
	if not rec then return nil end
	return rec.root or (model and NA_GRAB_BODY.firstPart(model)) or nil
end

function getTorso(char)
	local rec, model = NA_GRAB_BODY.ensure(char)
	if not rec then return nil end
	return rec.torso or (model and NA_GRAB_BODY.firstPart(model)) or nil
end

function getHead(char)
	local rec, model = NA_GRAB_BODY.ensure(char)
	if not rec then return nil end
	return rec.head or (model and NA_GRAB_BODY.firstPart(model)) or nil
end

function getChar()
	local plr = Players.LocalPlayer
	if not plr then return nil end
	local rec, model = NA_GRAB_BODY.ensure(plr)
	return model
end

function getPlrChar(plr)
	return NA_GRAB_BODY.asChar(plr)
end

g.grab_char_as_flames_nameless_fetcher = g.grab_char_as_flames_nameless_fetcher or getPlrChar

function getBp()
	local plr = Players.LocalPlayer
	return plr and plr:FindFirstChildOfClass("Backpack") or nil
end

g.getHum = g.getHum or function(char, waitSeconds)
	local target

	if char then
		target = NA_GRAB_BODY.asChar(char) or char
	else
		local plr = Players.LocalPlayer
		if plr then
			target = plr.Character
		end
	end

	if not target then
		return nil
	end

	local hum = target:FindFirstChildOfClass("Humanoid") or target:FindFirstChildOfClass("AnimationController")
	if hum then
		return hum
	end

	local timeout = tonumber(waitSeconds) or 3
	if not timeout or timeout <= 0 then
		local rec = NA_GRAB_BODY.ensure(target)
		return rec and rec.humanoid or nil
	end

	timeout = math.max(0, timeout)
	local deadline = os.clock() + timeout

	local function findHumanoid()
		return target:FindFirstChildOfClass("Humanoid") or target:FindFirstChildOfClass("AnimationController")
	end

	while not hum and os.clock() < deadline do
		Wait(0.05)
		hum = findHumanoid()
	end

	if hum then
		return hum
	end

	local rec = NA_GRAB_BODY.ensure(target)
	return rec and rec.humanoid or nil
end

g.getPlrHum = g.getPlrHum or function(plr)
	return getHum(plr)
end

function IsR15(plr)
	plr=(plr or Players.LocalPlayer)
	if plr then
		local h=getPlrHum(plr)
		if h and h.RigType==Enum.HumanoidRigType.R15 then return true end
	end
	return false
end

function IsR6(plr)
	plr=(plr or Players.LocalPlayer)
	if plr then
		local h=getPlrHum(plr)
		if h and h.RigType==Enum.HumanoidRigType.R6 then return true end
	end
	return false
end

local fireFolder = SoundService:FindFirstChild("FireTemporaryReparentFolder", true)
if not fireFolder then
   fireFolder = Instance.new("Folder")
   fireFolder.Name = "FireTemporaryReparentFolder"
   fireFolder.Parent = g.SoundService or SoundService or cloneref and cloneref(game:GetService("SoundService")) or game:GetService("SoundService")
end

for _,v in ipairs(fireFolder:GetChildren()) do try(function() v:Destroy() end) end
g.decodeHTMLEntities = function(str) return str:gsub("&gt;", ">"):gsub("&lt;", "<"):gsub("&amp;", "&"):gsub("&quot;", '"'):gsub("&#39;", "'") end
g.Float_Running_In_Flames_Hub = g.Float_Running_In_Flames_Hub or false
local float_part
local inc = false
local dec = false
local float_name = "FlamesFloat_" .. tostring(math.random(1000, 9999))
local UIS = UserInputService
local isMobile = UIS.TouchEnabled

g.start_flames_float = function()
   if g.Float_Running_In_Flames_Hub then
      return g.notify("Warning", "Flames Float-V1 is already enabled.", 5)
   end

   local char = g.Character or LocalPlayer.Character or get_char(LocalPlayer, 5)
   local root = g.HumanoidRootPart or char and char:FindFirstChild("HumanoidRootPart") or get_root(LocalPlayer, 6)
   local hum = g.Humanoid or char and char:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer, 6)
   if not char or not root or not hum then return end

   g.Float_Running_In_Flames_Hub = true

   float_part = Instance.new("Part")
   float_part.Name = float_name
   float_part.Parent = workspace
   float_part.Size = Vector3.new(10, 2, 10)
   float_part.Transparency = 1
   float_part.Anchored = true
   float_part.CanCollide = true
   float_part.CastShadow = false

   local controlModule
   if isMobile then
      local ok, cm = pcall(function()
         return require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
      end)
      if ok then controlModule = cm end
   end

   if not isMobile then
      g.FlamesLibrary.connect("flames_float_input_began",
         UIS.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.KeyCode == Enum.KeyCode.E then inc = true end
            if i.KeyCode == Enum.KeyCode.Q then dec = true end
         end)
      )
      g.FlamesLibrary.connect("flames_float_input_ended",
         UIS.InputEnded:Connect(function(i)
            if i.KeyCode == Enum.KeyCode.E then inc = false end
            if i.KeyCode == Enum.KeyCode.Q then dec = false end
         end)
      )
   end

   local offset = 0

   if g.FlamesLibrary.is_alive("flames_float_heartbeat") then
      g.FlamesLibrary.disconnect("flames_float_heartbeat")
   end
   wait(0.1)
   g.FlamesLibrary.connect("flames_float_heartbeat", RunService.RenderStepped:Connect(function()
      if not float_part then return end

      local char_now = g.Character or LocalPlayer.Character
      if not char_now then return end
      local root_now = g.HumanoidRootPart or char_now:FindFirstChild("HumanoidRootPart")
      local hum_now = g.Humanoid or char_now:FindFirstChildOfClass("Humanoid")
      if not root_now or not hum_now then return end

      local hrp_half = (root_now.Size.Y or 2) * 0.5
      local part_half = float_part.Size.Y * 0.5

      local feet_from_root
      if hum_now.RigType == Enum.HumanoidRigType.R6 then
         feet_from_root = hrp_half + (hum_now.HipHeight > 0 and hum_now.HipHeight or 2)
      else
         feet_from_root = hrp_half + (hum_now.HipHeight or 2)
      end

      local base_offset = feet_from_root + part_half

      local moveUp = false
      local moveDown = false

      if isMobile and controlModule then
         local mv = controlModule:GetMoveVector()
         moveUp = hum_now:GetState() == Enum.HumanoidStateType.Jumping
         moveDown = mv.Z > 0.1
      else
         moveUp = inc
         moveDown = dec
      end

      local delta = (moveDown and 1.5) or (moveUp and -1.5) or 0
      offset = math.max(0, base_offset + delta)

      float_part.CFrame = CFrame.new(
         root_now.Position.X,
         root_now.Position.Y - offset,
         root_now.Position.Z
      )
   end))

   if isMobile then
      g.notify("Success", "Flames Float-V1 enabled (Jump = Up | Move Back = Down)", 7)
   else
      g.notify("Success", "Flames Float-V1 enabled (Hold E = Up | Hold Q = Down)", 7)
   end
end

g.stop_flames_float = g.stop_flames_float or function()
   if not g.Float_Running_In_Flames_Hub then
      return g.notify("Warning", "Flames Float-V1 is not enabled.", 5)
   end

   g.Float_Running_In_Flames_Hub = false

   g.FlamesLibrary.disconnect("flames_float_input_began")
   g.FlamesLibrary.disconnect("flames_float_input_ended")
   g.FlamesLibrary.disconnect("flames_float_heartbeat")

   if float_part then
      float_part:Destroy()
      float_part = nil
   end

   inc = false
   dec = false

   g.notify("Success", "Flames Float-V1 is now disabled.", 5)
end

-- [[ For LoopFling ]] --
g.Loop_Flinging_Player_Flames_Hub = g.Loop_Flinging_Player_Flames_Hub or false
g.loopprotect = g.loopprotect or nil
-- [[ For LoopFling ]] --

-- [[ Spawn Point ]] --
g.spawnpoint = g.spawnpoint or false
g.spawnpos = g.spawnpos or nil
g.sp_delay = g.sp_delay or 0.1
g.sp_max_tries = g.sp_max_tries or 100
-- [[ Spawn Point ]] --

g.set_spawnpoint = g.set_spawnpoint or function(delay)
	local hrp = g.HumanoidRootPart or g.Character:FindFirstChild("HumanoidRootPart") or get_root(game.Players.LocalPlayer, 5)
	if not hrp then return end

	g.spawnpos = hrp.CFrame
	g.spawnpoint = true
	g.sp_delay = tonumber(delay) or g.sp_delay
   g.notify("Success", "Set SpawnPoint at current Position.", 6)
end

g.clear_spawnpoint = g.clear_spawnpoint or function()
   if not g.spawnpos then
      return g.notify("Error", "You do not have a SpawnPoint set anywhere!", 5)
   end
   if not g.spawnpoint then
      if g.spawnpos then
         pcall(function() g.spawnpos = nil end)
      end
      return g.notify("Warning", "You do not have SpawnPoint enabled!", 5)
   end

   g.spawnpoint = false
   g.spawnpos = nil
   g.notify("Success", "Cleared SpawnPoint.", 2)
end

if g.Current_Character_Added_Connection_HRP_Spawn_Point_System then
	g.Current_Character_Added_Connection_HRP_Spawn_Point_System:Disconnect()
   g.Current_Character_Added_Connection_HRP_Spawn_Point_System = nil
end
wait(0.25)
g.Current_Character_Added_Connection_HRP_Spawn_Point_System = game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
   if not char or not char.Parent then char = game.Players.LocalPlayer.CharacterAdded:Wait() end
   local humanoid = char and char:WaitForChild("Humanoid", 10)
   local hrp = char and char:WaitForChild("HumanoidRootPart", 10)
   if not humanoid or not hrp then return end
   g.Character = char
   g.HumanoidRootPart = hrp
   if not g.spawnpoint or not g.spawnpos then return end
   task.wait(g.sp_delay)
   if g.Character ~= char or not hrp.Parent then return end
   local tries = 0
   repeat
      tries += 1
      hrp.CFrame = g.spawnpos
      task.wait()
   until
      (hrp.Position - g.spawnpos.Position).Magnitude < 1
      or tries >= g.sp_max_tries
end)

local function cleanup_fling_resources()
	if g.loopprotect then
		pcall(function() g.loopprotect:Destroy() end)
		g.loopprotect = nil
	end
	if g.fling_bv then
		pcall(function() g.fling_bv:Destroy() end)
		g.fling_bv = nil
	end
end

g.skid_fling = g.skid_fling or function(target_player)
	local Player = g.LocalPlayer or Players.LocalPlayer or game.Players.LocalPlayer
	local Character = g.Character or Player.Character or get_char(LocalPlayer, 5)
	local Humanoid = g.Humanoid or Character and Character:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer, 0.5) or getHum(Character, 0.5)
	local HRP = g.HumanoidRootPart or Character and Character:FindFirstChild("HumanoidRootPart") or Humanoid and Humanoid.RootPart or get_root(LocalPlayer, 1)
	local TCharacter = target_player.Character or get_char(target_player, 0.75)
	if not Character or not Humanoid or not HRP or not TCharacter then return end
	cleanup_fling_resources()
	local camera = workspace.CurrentCamera
	g.loopprotect = InstanceNew("Part")
	g.loopprotect.Size = Vector3.new(1,1,1)
	g.loopprotect.Transparency = 1
	g.loopprotect.CanCollide = false
	g.loopprotect.Anchored = false
	g.loopprotect.Parent = camera

	local weld = InstanceNew("WeldConstraint")
	weld.Part0 = HRP
	weld.Part1 = g.loopprotect
	weld.Parent = g.loopprotect

	local bodyGyro = InstanceNew("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(4e5,4e5,4e5)
	bodyGyro.D = 1000
	bodyGyro.P = 2000
	bodyGyro.Parent = g.loopprotect

	local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid") or getPlrHum(TCharacter)
	local TRootPart = TCharacter and TCharacter:FindFirstChild("HumanoidRootPart") or THumanoid and THumanoid.RootPart
	local THead = TCharacter and TCharacter:FindFirstChild("Head") or getHead(TCharacter)
	local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
	local Handle = Accessory and Accessory:FindFirstChild("Handle")
	local RootPart = HRP
	if not TRootPart and not THead and not Handle then return end
	if not g.flingManager.lFlingOldPos or RootPart.Velocity.Magnitude < 50 then pcall(function() g.flingManager.lFlingOldPos = RootPart.CFrame end) end
	if THumanoid and THumanoid.Sit then return end
	if THead and THead.Parent then
		workspace.CurrentCamera.CameraSubject = THead
	elseif Handle then
		workspace.CurrentCamera.CameraSubject = Handle
	elseif TRootPart and THumanoid then
		workspace.CurrentCamera.CameraSubject = THumanoid
	end

   local function FPos(BasePart, Pos, Ang)
      pcall(function()
         RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
         Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
         RootPart.Velocity = Vector3.new(9e7, 9e8, 9e7)
         RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
      end)
   end

   local function SFBasePart(BasePart)
      local TimeToWait = 2
      local Time = tick()
      local Angle = 0
      local direction = 1

      repeat
         if RootPart and THumanoid then
            local moveDir = THumanoid.MoveDirection
            local speedBoost = BasePart.Velocity.Magnitude / 1.25

            if BasePart.Velocity.Magnitude < 50 then
               Angle = Angle + 100
               FPos(BasePart, CFrame.new(0, 1.5, 0) * direction + moveDir * speedBoost, CFrame.Angles(math.rad(Angle), 0, 0))
               task.wait()
               FPos(BasePart, CFrame.new(0, -1.5, 0) * direction + moveDir * speedBoost, CFrame.Angles(math.rad(Angle), 0, 0))
               task.wait()

               FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) * direction + moveDir * speedBoost, CFrame.Angles(math.rad(Angle), 0, 0))
               task.wait()
               FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) * direction + moveDir * speedBoost, CFrame.Angles(math.rad(Angle), 0, 0))
               task.wait()
            else
               local offset = direction * (THumanoid.WalkSpeed * 0.8)
               FPos(BasePart, CFrame.new(0, 1.5, offset) + moveDir * speedBoost, CFrame.Angles(math.rad(90), 0, 0))
               task.wait()
               FPos(BasePart, CFrame.new(0, -1.5, -offset) + moveDir * speedBoost, CFrame.Angles(0, 0, 0))
               task.wait()
            end

            direction = -direction
         else
            break
         end
      until BasePart.Velocity.Magnitude > 500 
         or BasePart.Parent ~= target_player.Character 
         or target_player.Parent ~= Players 
         or THumanoid.Sit 
         or Humanoid.Health <= 0 
         or tick() > Time + TimeToWait
   end

	workspace.FallenPartsDestroyHeight = 0/0
	g.fling_bv = InstanceNew("BodyVelocity")
	g.fling_bv.Parent = RootPart
	g.fling_bv.Velocity = Vector3.new(9e8,9e8,9e8)
	g.fling_bv.MaxForce = Vector3.new(1/0,1/0,1/0)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

	if TRootPart and THead then
		if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
			SFBasePart(THead)
		else
			SFBasePart(TRootPart)
		end
	elseif TRootPart then
		SFBasePart(TRootPart)
	elseif THead then
		SFBasePart(THead)
	elseif Handle then
		SFBasePart(Handle)
	end

	pcall(function() g.fling_bv:Destroy() end)
	g.fling_bv = nil
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
	workspace.CurrentCamera.CameraSubject = Humanoid

	repeat
		RootPart.CFrame = g.flingManager.lFlingOldPos * CFrame.new(0,0.5,0)
		Character:SetPrimaryPartCFrame(g.flingManager.lFlingOldPos * CFrame.new(0,0.5,0))
		Humanoid:ChangeState("GettingUp")
		Foreach(Character:GetChildren(), function(_, x)
			if x:IsA("BasePart") then
				x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
			end
		end)
		task.wait()
	until (RootPart.Position - g.flingManager.lFlingOldPos.p).Magnitude < 25
	cleanup_fling_resources()
end

g.youtube_music_player = function()
   if not g.yt_music_player_loaded_flames_hub then
      return g.notify("Warning", "YouTube Music player is not loaded yet.", 5)
   end

   local gui = g.found_image_button_for_yt_music_player
   if gui and gui:IsA("ScreenGui") then
      local frame = gui:FindFirstChildOfClass("Frame")
      if frame and frame.Parent then
         frame.Visible = true
      end
   else
      g.notify("Warning", "YouTube Music player GUI not found yet, try again later (broken?).", 10)
   end
end

g.find_tool_folder_searcher_info = function()
   local cache = g.tool_information_folder_instance
   if cache and cache:IsA("Folder") then
      return cache
   end

   for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
      if v:IsA("Folder") and v.Name:lower():find("tool") and v.Name:lower():find("info") then
         g.tool_information_folder_instance = v
         return v
      end
   end

   return nil
end
if not g.tool_information_folder_instance then task.spawn(function() g.find_tool_folder_searcher_info() end) end

g.FlamesUI = g.FlamesUI or {}
local ui = g.FlamesUI
local lib = g.FlamesLibrary
local function get_certain_tool(tool_name_str)
   tool_name_str = tool_name_str:lower()
   local aliases = {
      ["assault rifle"] = {"assault", "rifle"},
      ["pistol"]        = {"pistol"},
      ["shotgun"]       = {"shotgun"},
      ["sniper rifle"]  = {"sniper", "rifle"},
      ["ak47"]          = {"ak"},
      ["stun gun"]      = {"stun"},
   }

   local function matches_tool(name, patterns)
      name = name:lower()
      for _, p in ipairs(patterns) do
         if not name:find(p) then return false end
      end
      return true
   end

   local function search_in(parent)
      if not parent then return nil end
      for _, v in ipairs(parent:GetChildren()) do
         if v:IsA("Tool") then
            for _, patterns in pairs(aliases) do
               if matches_tool(v.Name, patterns) and matches_tool(tool_name_str, patterns) then
                  return v
               end
            end
         end
      end
      return nil
   end

   return search_in(g.Character or lp.Character or get_char(LocalPlayer, 5))
end

local function check_missing_tools()
   local lp = g.LocalPlayer or game.Players.LocalPlayer
   local needed = { "LaserPointer", "Pistol" }
   local found = {}
   local function search(parent)
      if not parent then return end
      for _, v in ipairs(parent:GetChildren()) do
         if v:IsA("Tool") then
            found[v.Name] = true
         end
      end
   end

   search(g.Backpack or lp.Backpack)
   search(g.Character or lp.Character or get_char(LocalPlayer, 5))

   local missing = {}
   for _, name in ipairs(needed) do
      if not found[name] then
         table.insert(missing, name)
      end
   end

   return missing
end

local function retrieve_missing_tools()
   local missing = check_missing_tools()
   if #missing > 0 then
      for _, tool_name in ipairs(missing) do
         g.Send("get_tool", tool_name)
      end
   end
end

ui.objects = ui.objects or {
   windows = {},
   tabs = {},
   sections = {},
   elements = {}
}

ui.load = ui.load or function()
   if ui.rayfield then return ui.rayfield end
   ui.rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
   return ui.rayfield
end

ui.create_window = ui.create_window or function(name, key)
   local Rayfield = ui.load()
   local window = Rayfield:CreateWindow({
      Name = name,
      Icon = 0,
      LoadingTitle = "Loading current GUI...",
      LoadingSubtitle = "by Flames Hub",
      ShowText = "FLAMES_HUB",
      Theme = "Default",
      ToggleUIKeybind = key or "K",
      DisableRayfieldPrompts = true,
      DisableBuildWarnings = true,
      ConfigurationSaving = {
         Enabled = false,
         FolderName = nil,
         FileName = name.."_config"
      },
      Discord = {
         Enabled = false,
         Invite = "nah",
         RememberJoins = true
      },
      KeySystem = false,
      KeySettings = {
         Title = "Key",
         Subtitle = "System",
         Note = "nah",
         FileName = "Key",
         SaveKey = true,
         GrabKeyFromSite = false,
         Key = {"key"}
      }
   })

   ui.objects.windows[name] = window
   return window
end

ui.create_tab = function(window, name)
   local tab = window:CreateTab(name, 0)
   ui.objects.tabs[name] = tab
   return tab
end

ui.create_section = function(tab, name)
   local section = tab:CreateSection(name)
   ui.objects.sections[name] = section
   return section
end

ui.button = function(tab, name, callback)
   local obj = tab:CreateButton({
      Name = name,
      Callback = callback
   })

   ui.objects.elements[name] = obj
   return obj
end

ui.toggle = function(tab, name, flag, default, callback)
   local obj = tab:CreateToggle({
   Name = name,
   CurrentValue = default or false,
   Flag = flag,
   Callback = function(val)
      callback(val)
   end,})

   ui.objects.elements[flag] = obj
   return obj
end

ui.slider = function(tab, name, flag, min, max, inc, default, suffix, callback)
   local obj = tab:CreateSlider({
   Name = name,
   Range = {min, max},
   Increment = inc,
   Suffix = suffix or "",
   CurrentValue = default,
   Flag = flag,
   Callback = function(val)
      callback(val)
   end,})

   ui.objects.elements[flag] = obj
   return obj
end

ui.colorpicker = function(tab, name, flag, default, callback)
   local obj = tab:CreateColorPicker({
   Name = name,
   Color = default,
   Flag = flag,
   Callback = function(val)
      callback(val)
   end,})

   ui.objects.elements[flag] = obj
   return obj
end

ui.input = function(tab, name, flag, placeholder, callback)
   local obj = tab:CreateInput({
   Name = name,
   CurrentValue = "",
   PlaceholderText = placeholder or "",
   RemoveTextAfterFocusLost = false,
   Flag = flag,
   Callback = function(text)
      callback(text)
   end,})

   ui.objects.elements[flag] = obj
   return obj
end

ui.dropdown = function(tab, name, flag, options, current, multi, callback)
   local obj = tab:CreateDropdown({
   Name = name,
   Options = options,
   CurrentOption = current,
   MultipleOptions = multi or false,
   Flag = flag,
   Callback = function(opt)
      callback(opt)
   end,})

   ui.objects.elements[flag] = obj
   return obj
end

ui.keybind = function(tab, name, flag, key, hold, callback)
   local obj = tab:CreateKeybind({
   Name = name,
   CurrentKeybind = key,
   HoldToInteract = hold or false,
   Flag = flag,
   Callback = function(k)
      callback(k)
   end,})

   ui.objects.elements[flag] = obj
   return obj
end

ui.destroy_window = function(name)
   local to_remove = {}
   for name in pairs(ui.objects.windows) do
      table.insert(to_remove, name)
   end

   for _, name in ipairs(to_remove) do
      local window = ui.objects.windows[name]
      local ok, err = pcall(function()
         if window:IsA("ScreenGui") and window.Enabled then
            window.Enabled = false
         elseif window:IsA("Frame") and window.Visible then
            window.Visible = false
         end
      end)
      if not ok then
         pcall(function()
            if ui.rayfield:IsA("ScreenGui") and ui.rayfield.Enabled then
               ui.rayfield.Enabled = false
            elseif ui.rayfield:IsA("Frame") and ui.rayfield.Visible then
               ui.rayfield.Visible = false
            end
         end)
      end
   end
end

ui.ensure_visibility = function(name)
   local to_remove = {}
   for name in pairs(ui.objects.windows) do
      table.insert(to_remove, name)
   end

   for _, name in ipairs(to_remove) do
      local window = ui.objects.windows[name]
      local ok, err = pcall(function()
         if window:IsA("ScreenGui") and window.Enabled then
            window.Enabled = true
         elseif window:IsA("Frame") and window.Visible then
            window.Visible = true
         end
      end)
      if not ok then
         pcall(function()
            if ui.rayfield:IsA("ScreenGui") and ui.rayfield.Enabled then
               ui.rayfield.Enabled = true
            elseif ui.rayfield:IsA("Frame") and ui.rayfield.Visible then
               ui.rayfield.Visible = true
            end
         end)
      end
   end
end

g.tools_menu_for_life_together_flames_hub = g.tools_menu_for_life_together_flames_hub or function()
   if ui.objects.windows["©️ Tools Menu | Flames Hub LLC ©️"] then
      pcall(function() ui.ensure_visibility() end)
      return g.notify("Warning", "Flames Hub - Tools Menu is already loaded!", 5)
   end
   local main_window = ui.create_window("©️ Tools Menu | Flames Hub LLC ©️")
   local tab_1 = ui.create_tab(main_window, "Tools")
   local section_1 = ui.create_section(tab_1, "||| Tools Section |||")
   local FL = g.FlamesLibrary
   local lp = g.LocalPlayer or game.Players.LocalPlayer
   local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
   local tool_map = {
      ["assault rifle"] = { patterns = {"assault", "rifle"}, net = "shoot_ar",      module = "AssaultRifle" },
      ["shotgun"]       = { patterns = {"shotgun"},           net = "shoot_shotgun", module = "Shotgun" },
      ["sniper rifle"]  = { patterns = {"sniper", "rifle"},   net = "shoot_sniper",  module = "SniperRifle" },
      ["ak47"]          = { patterns = {"ak"},                net = "shoot_ar",      module = "AssaultRifle" },
      ["rocket"]        = { patterns = {"rocket"},            net = "shoot_rocket",  module = "RocketLauncher" },
   }

   local function MatchPatterns(name, patterns)
      name = name:lower()
      for _, p in ipairs(patterns) do
         if not name:find(p) then return false end
      end
      return true
   end

   local function get_tool_data(tool_instance)
      local name = tool_instance.Name:lower()
      for _, data in pairs(tool_map) do
         if MatchPatterns(name, data.patterns) then
            return data
         end
      end
      return nil
   end

   local function get_equipped_tool()
      if not lp.Character then return nil, nil end
      for _, v in ipairs(lp.Character:GetChildren()) do
         if v:IsA("Tool") then
            local data = get_tool_data(v)
            if data then return v, data end
         end
      end
      return nil, nil
   end

   local function GetObj(tool, module_name)
      if not module_name then return nil end
      local ok, mod = pcall(require, g.Modules:FindFirstChild(module_name, true))
      if not ok or not mod then return nil end
      local ok2, obj = pcall(mod.class.get, tool)
      if not ok2 or not obj then return nil end
      return obj
   end

   local firing = false
   local function start_firing()
      if firing then return end
      local tool, data = get_equipped_tool()
      if not tool or not data then return end
      local obj = GetObj(tool, data.module)

      if obj then
         obj.states.reloading.hook(function(p)
            if p then
               task.wait(0)
               obj.states.bullets.set(30)
               obj.states.reloading.set(false)
            end
         end)
      end

      firing = true
      FL.spawn("firing_weapon_loop", "spawn", function()
         while firing do
            local t, d = get_equipped_tool()
            if not t or not t:IsDescendantOf(lp.Character) then
               firing = false
               break
            end
            if obj then
               obj.states.shoot.update(function(p) return not p end)
            end
            g.Send(d.net, t)
            FL.wait(0.0001)
         end
      end)
   end

   local function stop_firing()
      firing = false
      FL.disconnect("firing_weapon_loop")
   end

   local function Setup_Input()
      if isMobile then
         FL.connect("tool_input", UIS.TouchStarted:Connect(function(_, gpe)
            if gpe then return end
            start_firing()
         end))
         FL.connect("tool_input", UIS.TouchEnded:Connect(function()
            stop_firing()
         end))
      else
         FL.connect("tool_input", UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
               start_firing()
            end
         end))
         FL.connect("tool_input", UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
               stop_firing()
            end
         end))
      end

      FL.connect("tool_char", lp.CharacterRemoving:Connect(function()
         stop_firing()
      end))
   end

   local function Teardown_Input()
      stop_firing()
      FL.disconnect("tool_input")
      FL.disconnect("tool_char")
   end

   ui.toggle(tab_1, "Rapid Fire Weapons (FE)", "AlwaysRapidFireAR_Easily", g.currently_toggled_rapid_fire_AR, function(is_toggled)
      if is_toggled then
         if g.currently_toggled_rapid_fire_AR then
            Teardown_Input()
            task.wait(0.2)
         end

         g.currently_toggled_rapid_fire_AR = true
         Setup_Input()
      else
         g.currently_toggled_rapid_fire_AR = false
         Teardown_Input()
      end
   end)

   local tool_information = g.tool_information_folder_instance or g.find_tool_folder_searcher_info()
   local options = {}
   local tool_data_main = {}

   if tool_information then
      for _, v in ipairs(tool_information:GetChildren()) do
         if v:IsA("Tool") then
            table.insert(options, v.Name)
            tool_data_main[v.Name] = v
         end
      end
   end

   ui.dropdown(tab_1, "Get Any Weapon (FE)", "GetAnyWeapon", options, nil, false, function(selected)
      local tool = tool_data_main[selected]
      if tool then
         if g.Send then g.Send("get_tool", tool.Name) end
      end
   end)

   ui.button(tab_1, "Laser + Pistol (FE)", function()
      local lp = g.LocalPlayer or game.Players.LocalPlayer
      local backpack = g.Backpack or lp.Backpack
      local character = g.Character or lp.Character
      if not character or not backpack then return end
      local function is_wanted(name)
         name = name:lower()
         return name:find("laser") or name:find("pistol")
      end

      local function already_equipped(name)
         for _, v in ipairs(character:GetChildren()) do
            if v:IsA("Tool") and v.Name == name then
               return true
            end
         end
         return false
      end

      if already_equipped("LaserPointer") and already_equipped("Pistol") then return end
      local function has_unwanted()
         for _, v in ipairs(character:GetChildren()) do
            if v:IsA("Tool") and not is_wanted(v.Name) then return true end
         end
         for _, v in ipairs(backpack:GetChildren()) do
            if v:IsA("Tool") and not is_wanted(v.Name) then return true end
         end
         return false
      end

      if has_unwanted() then
         g.Send("delete_tool")
         task.wait(0.25)
      end

      local wanted = { "LaserPointer", "Pistol" }
      for _, tool_name in ipairs(wanted) do
         local in_backpack = false
         for _, v in ipairs(backpack:GetChildren()) do
            if v:IsA("Tool") and v.Name == tool_name then
               in_backpack = true
               break
            end
         end
         if not already_equipped(tool_name) and not in_backpack then
            g.Send("get_tool", tool_name)
            task.wait(0.1)
         end
      end
      task.wait(0.25)
      for _, v in ipairs(backpack:GetChildren()) do
         if v:IsA("Tool") and is_wanted(v.Name) and not already_equipped(v.Name) then
            v.Parent = character
         end
      end
   end)

   ui.button(tab_1, "Shutdown/Close Menu", function()
      pcall(function() ui.destroy_window() end)
   end)
end

g.stop_loopfling = function()
	local lib = g.FlamesLibrary
	if not g.Loop_Flinging_Player_Flames_Hub then return g.notify("Warning", "Flames Hub | LoopFling-V2 is not enabled.", 5) end
	g.Loop_Flinging_Player_Flames_Hub = false
	lib.disconnect("loopfling")
	cleanup_fling_resources()
   local Camera = workspace.CurrentCamera
   if not Camera then
      warn("CurrentCamera not found")
      return
   end
   local Char = g.Character or (g.LocalPlayer and g.LocalPlayer.Character) or (g.get_char and g.get_char(LocalPlayer, 5))
   if not Char then
      warn("Char not found")
      return
   end

   local Hum = g.Humanoid or Char:FindFirstChildWhichIsA("Humanoid") or (g.get_human and g.get_human(LocalPlayer, 5))
   if not Hum then
      warn("Hum not found")
      return
   end
   
   if Camera.CameraSubject ~= Char and Camera.CameraSubject ~= Hum then
      repeat
         Camera.CameraSubject = Char or Hum
         task.wait()
      until Camera.CameraSubject == Char or Camera.CameraSubject == Hum
   end
	g.notify("Success", "Flames Hub | LoopFling-V2 is now disabled.", 5)
end

g.start_loopfling = function(target_player)
	local lib = g.FlamesLibrary
   local fw = lib.wait
	if g.Loop_Flinging_Player_Flames_Hub then return g.notify("Warning", "You're already using Flames Hub | LoopFling-V2 on someone!", 3) end
	if not target_player or not target_player.Parent then return g.notify("Error", "That player does not exist / left the game.", 3) end
   if g.Noclip_Enabled then return g.notify("Error", "NoClip is enabled, please turn it off first.", 3) end
   if g.afEnabled then return g.notify("Error", "Anti-Fling is enabled, please turn it off first.", 3) end
	g.Loop_Flinging_Player_Flames_Hub = true
   lib.spawn("loopfling", "spawn", function()
      local was_dead = false
      local waiting_for_respawn = false
      while g.Loop_Flinging_Player_Flames_Hub == true do
         fw(0)
         if not target_player or not target_player.Parent then
            g.notify("Warning", "Target left, stopping LoopFling.", 5)
            g.stop_loopfling()
            break
         end

         local character = target_player.Character or get_char(target_player, 0.75)
         local humanoid = character and character:FindFirstChildOfClass("Humanoid") or character and getHum(character, 0.5) or get_human(target_player, 0.5)
         local root_part = character and character:FindFirstChild("HumanoidRootPart") or humanoid and humanoid.RootPart or get_root(target_player, 0.5)
         if not character or not humanoid or humanoid.Health <= 0 or not root_part then
            if not waiting_for_respawn then
               waiting_for_respawn = true
               g.notify("Info", "Target dead/respawning, waiting...", 1)
            end

            repeat
               fw(0.1)
               character = target_player.Character or get_char(target_player, 0.75)
               humanoid = character and character:FindFirstChildOfClass("Humanoid") or character and getHum(character, 0.5) or get_human(target_player, 0.5)
               root_part = character and character:FindFirstChild("HumanoidRootPart") or humanoid and humanoid.RootPart or get_root(target_player, 0.5)
            until not g.Loop_Flinging_Player_Flames_Hub
               or not target_player.Parent
               or (humanoid and humanoid.Health > 0 and root_part)
            waiting_for_respawn = false
            was_dead = false
            continue
         end

         if humanoid.Health <= 0 then
            if not was_dead then
               was_dead = true
            end
            continue
         end

         was_dead = false

         local ok, err = pcall(function()
            g.skid_fling(target_player)
         end)

         if not ok then
            warn("LoopFling error: "..tostring(err))
         end
      end
   end)

	g.notify("Success", "Flames Hub | LoopFling-V2 is now enabled.", 5)
end

g.firehidden      = g.firehidden      or false
g.firemanual      = g.firemanual      or false
g.firesystem_init = g.firesystem_init or false
local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local FireClasses = {
   Fire           = true,
   Smoke          = true,
   Sparkles       = true,
   ParticleEmitter = true,
   Beam           = true,
}

local PendingQueue = {}
local QueueDirty   = false
local function is_fire_class(obj) return FireClasses[obj.ClassName] ~= nil end
local function disable_fire_object(obj)
   pcall(function()
      if obj.ClassName ~= "Beam" then
         obj.Enabled = false
      end
      obj:Destroy()
   end)
end

local function destroy_fire_model(model)
   for _, v in ipairs(model:GetDescendants()) do
      if is_fire_class(v) then
         disable_fire_object(v)
      end
   end
   pcall(function() model:Destroy() end)
end

local function handle_object(obj)
   if not obj or not obj.Parent then return end
   if obj.ClassName == "Model" and obj.Name == "Fire" then
      destroy_fire_model(obj)
   elseif is_fire_class(obj) then
      disable_fire_object(obj)
   end
end

local function purge_all_fire()
   for _, v in ipairs(workspace:GetDescendants()) do
      if v.ClassName == "Model" and v.Name == "Fire" then
         destroy_fire_model(v)
      elseif is_fire_class(v) then
         disable_fire_object(v)
      end
   end
end

local function flush_queue()
   if not QueueDirty then return end
   QueueDirty = false
   local snapshot = PendingQueue
   PendingQueue = {}
   for i = 1, #snapshot do
      handle_object(snapshot[i])
   end
end

if not g.firesystem_init then g.firesystem_init = true end
g.set_fire_state = function(state)
   local lib = getgenv().FlamesLibrary
   local da_key  = "anti_fire_descendant_added"
   local hb_key  = "anti_fire_heartbeat"

   if state == true then
      if g.firehidden then
         return g.notify("Warning", "Flames Hub | Anti-Fire V2 is already enabled.", 6)
      end

      g.firemanual = true
      g.firehidden = true
      g.notify("Success", "Flames Hub | Anti-Fire V2 is now enabled.", 5)
      purge_all_fire()
      if lib.is_alive(da_key) then lib.disconnect(da_key) end
      if lib.is_alive(hb_key) then lib.disconnect(hb_key) end
      task.wait(0.25)
      lib.connect(da_key, workspace.DescendantAdded:Connect(function(obj)
         if not g.firehidden then return end
         PendingQueue[#PendingQueue + 1] = obj
         QueueDirty = true
      end))

      lib.connect(hb_key, RunService.Heartbeat:Connect(function()
         if not g.firehidden then return end
         flush_queue()
      end))
   else
      if not g.firehidden then
         return g.notify("Warning", "Anti-Fire V2 is not enabled.", 6)
      end

      g.firemanual = false
      g.firehidden = false
      g.notify("Success", "Anti-Fire V2 is now disabled.", 5)
      lib.disconnect(da_key)
      lib.disconnect(hb_key)
      PendingQueue = {}
      QueueDirty   = false
   end
end

g.tool_configuration_system_func = g.tool_configuration_system_func or function(option)
   option = option:lower()
   task.wait(0.1)
   if option == "get_tool" or option == "gettool" or option == "grab_tool" or option == "request_tool" then
      if g.Send then
         g.Send("get_tool", tostring(Tool_Name))
      end
   elseif option == "delete_tool" or option == "delete_tools" or option == "remove_tool" or option == "removetools" or option == "remove_tools" or option == "deletetools" then
      if g.Send then
         g.Send("delete_tool")
      end
   elseif option == "equip_tools" or option == "equiptools" or option == "equipalltools" or option == "equip_all_tools" then
      if g.Character and g.Character:FindFirstChildOfClass("Humanoid") and g.Humanoid then
         for _, v in ipairs(g.LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") then
               pcall(function() g.Humanoid:EquipTool(v) end)
            end
         end
      else
         for _, v in ipairs(g.LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") then
               pcall(function()
                  v.Parent = g.Character or g.LocalPlayer.Character or get_char(g.LocalPlayer or game.Players.LocalPlayer)
               end)
            end
         end
      end
   end
end

g.AdminPrefix = g.AdminPrefix or "-"
g.AdminVersion = g.AdminVersion or "v1.0"
g.AdminConfigChanged = g.AdminConfigChanged or Instance.new("BindableEvent")
g.setAdminPrefix = g.setAdminPrefix or function(newPrefix)
   if typeof(newPrefix) == "string" and g.AdminPrefix ~= newPrefix then
      g.AdminPrefix = newPrefix
      g.AdminConfigChanged:Fire("prefix")
   end
end

g.setAdminVersion = g.setAdminVersion or function(newVersion)
   if typeof(newVersion) == "string" and g.AdminVersion ~= newVersion then
      g.AdminVersion = newVersion
      g.AdminConfigChanged:Fire("version")
   end
end

local ismobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
g.CommandsMenu_Tooltip_Init = g.CommandsMenu_Tooltip_Init or function()
   if g.CommandsMenu_Tooltip and g.CommandsMenu_Tooltip.Parent then return end

   local tooltipGui = parent_gui:FindFirstChild("AdminTooltipUI") or Instance.new("ScreenGui")
   tooltipGui.Name = "AdminTooltipUI"
   tooltipGui.ResetOnSpawn = false
   tooltipGui.IgnoreGuiInset = true
   tooltipGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
   tooltipGui.DisplayOrder = 9999
   tooltipGui.Parent = parent_gui

   local tooltip = tooltipGui:FindFirstChild("CommandTooltip") or Instance.new("TextLabel")
   tooltip.Name = "CommandTooltip"
   tooltip.BackgroundColor3 = Color3.fromRGB(50,50,50)
   tooltip.TextColor3 = Color3.new(1,1,1)
   tooltip.Font = Enum.Font.GothamSemibold
   tooltip.TextSize = 14
   tooltip.TextWrapped = true
   tooltip.AutomaticSize = Enum.AutomaticSize.XY
   tooltip.BackgroundTransparency = 1
   tooltip.TextTransparency = 1
   tooltip.Visible = false
   tooltip.ZIndex = 10000
   tooltip.AnchorPoint = Vector2.new(0,1)
   tooltip.TextYAlignment = Enum.TextYAlignment.Top
   tooltip.Parent = tooltipGui

   if not tooltip:FindFirstChildOfClass("UICorner") then
      Instance.new("UICorner", tooltip).CornerRadius = UDim.new(0,6)
      local pad = Instance.new("UIPadding", tooltip)
      pad.PaddingLeft = UDim.new(0,6)
      pad.PaddingRight = UDim.new(0,6)
      pad.PaddingTop = UDim.new(0,3)
      pad.PaddingBottom = UDim.new(0,3)
   end

   g.CommandsMenu_Tooltip = tooltip
end

if FlamesLibrary.is_alive("CommandsMenu_Tooltip_RenderStepped") then
   FlamesLibrary.disconnect("CommandsMenu_Tooltip_RenderStepped")
end

if FlamesLibrary.is_alive("CommandsMenu_Tooltip_InputChanged") then
   FlamesLibrary.disconnect("CommandsMenu_Tooltip_InputChanged")
end

local mousePos = Vector2.new()
FlamesLibrary.connect("CommandsMenu_Tooltip_InputChanged", UserInputService.InputChanged:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseMovement then
      mousePos = Vector2.new(input.Position.X, input.Position.Y)
   end
end))

FlamesLibrary.connect("CommandsMenu_Tooltip_RenderStepped", RunService.RenderStepped:Connect(function()
   local tooltip = g.CommandsMenu_Tooltip
   if tooltip and tooltip.Visible then
      tooltip.Position = UDim2.fromOffset(mousePos.X + 15, mousePos.Y - 10)
   end
end))

g.CommandsMenu_ShowTooltip = g.CommandsMenu_ShowTooltip or function(text)
   local tooltip = g.CommandsMenu_Tooltip
   if not tooltip or text == "" then return end
   tooltip.Text = text
   tooltip.Visible = true
   TweenService:Create(tooltip, TweenInfo.new(0.15), {
      BackgroundTransparency = 0.15,
      TextTransparency = 0
   }):Play()
end

g.CommandsMenu_HideTooltip = g.CommandsMenu_HideTooltip or function()
   local tooltip = g.CommandsMenu_Tooltip
   if not tooltip then return end
   TweenService:Create(tooltip, TweenInfo.new(0.15), {
      BackgroundTransparency = 1,
      TextTransparency = 1
   }):Play()
   task.delay(0.15, function()
      if tooltip then tooltip.Visible = false end
   end)
end

g.CommandsMenu_Rebuild = g.CommandsMenu_Rebuild or function(Filter)
   local Scroll = g.CommandsMenu_Scroll
   if not Scroll then return end

   Filter = Filter and string.lower(Filter) or ""

   for _, V in ipairs(Scroll:GetChildren()) do
      if not V:IsA("UIListLayout") and not V:IsA("UIPadding") then
         V:Destroy()
      end
   end

   local Rebuilt = string.gsub(cmdsString, "{prefix}", g.AdminPrefix)

   for Line in string.gmatch(Rebuilt, "[^\r\n]+") do
      Line = Line:match("^%s*(.-)%s*$")
      if Line ~= "" then
         local Parts = string.split(Line, " - ")
         local Cmd_Text = Parts[1] or Line
         local Desc = Parts[2] or ""

         if Filter ~= "" then
            local Cmd_Lower = string.lower(Cmd_Text)
            local Desc_Lower = string.lower(Desc)
            if not string.find(Cmd_Lower, Filter, 1, true) and not string.find(Desc_Lower, Filter, 1, true) then
               continue
            end
         end

         local Frame = Instance.new("Frame")
         Frame.Size = UDim2.new(1, -10, 0, ismobile and 70 or 60)
         Frame.BackgroundTransparency = 1
         Frame.Parent = Scroll

         local Label = Instance.new("TextLabel")
         Label.AutomaticSize = Enum.AutomaticSize.Y
         Label.Size = UDim2.new(1, -130, 0, 20)
         Label.BackgroundTransparency = 1
         Label.Font = Enum.Font.GothamSemibold
         Label.TextSize = 15
         Label.TextColor3 = Color3.fromRGB(0, 0, 0)
         Label.TextWrapped = true
         Label.RichText = true
         Label.TextXAlignment = Enum.TextXAlignment.Left
         Label.TextYAlignment = Enum.TextYAlignment.Top
         Label.Text = Cmd_Text
         Label.Parent = Frame

         local Button = Instance.new("TextButton")
         Button.Size = UDim2.new(0, ismobile and 110 or 100, 0, ismobile and 44 or 30)
         Button.Position = UDim2.new(1, -(ismobile and 110 or 100), 0, ismobile and 13 or 15)
         Button.Text = "Run"
         Button.Font = Enum.Font.GothamBold
         Button.TextSize = 14
         Button.TextColor3 = Color3.new(1, 1, 1)
         Button.BackgroundColor3 = Color3.fromRGB(27, 42, 53)
         Button.Parent = Frame
         Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

         Label.MouseEnter:Connect(function()
            g.CommandsMenu_ShowTooltip(Desc)
         end)
         Label.MouseLeave:Connect(function()
            g.CommandsMenu_HideTooltip()
         end)
         Button.MouseEnter:Connect(function()
            g.CommandsMenu_ShowTooltip(Desc)
         end)
         Button.MouseLeave:Connect(function()
            g.CommandsMenu_HideTooltip()
         end)
         Button.MouseButton1Click:Connect(function()
            if g.DirectCommand then
               g.DirectCommand(Cmd_Text)
            end
         end)
      end
   end
end

g.CommandsMenu = function()
   if g.CommandsMenuGUI and g.CommandsMenuGUI.Parent then
      g.CommandsMenuGUI.Enabled = true
      g.CommandsMenu_Rebuild()
      return
   end

   g.CommandsMenu_Tooltip_Init()

   local gui = Instance.new("ScreenGui")
   gui.Name = "AdminCommandList_LifeTogether_RP"
   gui.ResetOnSpawn = false
   gui.Parent = parent_gui
   g.CommandsMenuGUI = gui

   local Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context = Instance.new("Frame")
   Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.AnchorPoint = Vector2.new(0.5, 0.5)
   Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.Position = UDim2.new(0.5, 0, 0.5, 0)
   Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.Size = ismobile and UDim2.new(0.7, 0, 1.02, 0) or UDim2.new(0,600,0,500)
   Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.BackgroundColor3 = Color3.fromRGB(151,0,0)
   Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.BackgroundTransparency = ismobile and 0.05 or 0
   Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.Parent = gui
   Instance.new("UICorner", Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context).CornerRadius = UDim.new(0,12)
   while not Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context or not Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context.Parent do
      g.heartbeat_wait_function(3)
   end
   dragify(Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context)
   --g.flowrgb("Commands_Menu_Main_Flow_RGB_Connection", 3, Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context, true)

   local header = Instance.new("Frame")
   header.Size = UDim2.new(1,0,0,36)
   header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
   header.Parent = Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context
   Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)

   local title = Instance.new("TextLabel")
   title.Size = UDim2.new(1,-60,1,0)
   title.Position = UDim2.new(0,12,0,0)
   title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
   title.BackgroundTransparency = 1
   title.Text = "👑 Flames Hub - Administrator Commands 👑"
   title.Font = Enum.Font.GothamBold
   title.TextSize = 16
   title.TextColor3 = Color3.new(1,1,1)
   title.TextXAlignment = Enum.TextXAlignment.Left
   title.Parent = header
   while not title or not title.Parent do
      g.heartbeat_wait_function(3)
   end

   if ismobile then
      local close = Instance.new("TextButton")
      close.Size = UDim2.new(0,36,0,36)
      close.Position = UDim2.new(1,-40,0,0)
      close.Text = "X"
      close.TextScaled = true
      close.Font = Enum.Font.GothamBold
      close.TextSize = 24
      close.TextColor3 = Color3.new(1,1,1)
      close.BackgroundColor3 = Color3.fromRGB(90,0,0)
      close.Parent = header
      Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)
      close.MouseButton1Click:Connect(function()
         gui.Enabled = false
      end)
   else
      local close = Instance.new("TextButton")
      close.Size = UDim2.new(0,32,0,32)
      close.Position = UDim2.new(1,-36,0,2)
      close.Text = "X"
      close.TextScaled = true
      close.Font = Enum.Font.GothamBold
      close.TextSize = 18
      close.TextColor3 = Color3.new(1,1,1)
      close.BackgroundColor3 = Color3.fromRGB(90,0,0)
      close.Parent = header
      Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)
      close.MouseButton1Click:Connect(function()
         gui.Enabled = false
      end)
   end

   local Search_Bar_Height = ismobile and 38 or 30
   local Search_Bar = Instance.new("TextBox")
   Search_Bar.Size = UDim2.new(1, -20, 0, Search_Bar_Height)
   Search_Bar.Position = UDim2.new(0, 10, 0, 42)
   Search_Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
   Search_Bar.PlaceholderText = "Search commands..."
   Search_Bar.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
   Search_Bar.Text = ""
   Search_Bar.Font = Enum.Font.GothamSemibold
   Search_Bar.TextSize = 14
   Search_Bar.TextColor3 = Color3.new(1, 1, 1)
   Search_Bar.ClearTextOnFocus = false
   Search_Bar.Parent = Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context
   Instance.new("UICorner", Search_Bar).CornerRadius = UDim.new(0, 6)
   local Search_Pad = Instance.new("UIPadding", Search_Bar)
   Search_Pad.PaddingLeft = UDim.new(0, 8)
   Search_Pad.PaddingRight = UDim.new(0, 8)
   local Scroll_Top = 42 + Search_Bar_Height + 8
   local scroll = Instance.new("ScrollingFrame")
   scroll.Size = UDim2.new(1, -20, 1, -(Scroll_Top + 10))
   scroll.Position = UDim2.new(0, 10, 0, Scroll_Top)
   scroll.BackgroundTransparency = 1
   scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
   scroll.ScrollBarThickness = 6
   scroll.Parent = Commands_Menu_Main_Frame_Content_In_Flames_Hub_Context

   local layout = Instance.new("UIListLayout")
   layout.Padding = UDim.new(0,6)
   layout.Parent = scroll

   local padding = Instance.new("UIPadding")
   padding.PaddingTop = UDim.new(0,5)
   padding.PaddingBottom = UDim.new(0,5)
   padding.PaddingLeft = UDim.new(0,5)
   padding.PaddingRight = UDim.new(0,5)
   padding.Parent = scroll

   Search_Bar:GetPropertyChangedSignal("Text"):Connect(function()
      g.CommandsMenu_Rebuild(Search_Bar.Text)
   end)

   g.CommandsMenu_Scroll = scroll
   g.CommandsMenu_Rebuild()
end

if FlamesLibrary.is_alive("CommandsMenu_AdminConfigChanged") then
   FlamesLibrary.disconnect("CommandsMenu_AdminConfigChanged")
end

FlamesLibrary.connect("CommandsMenu_AdminConfigChanged", g.AdminConfigChanged.Event:Connect(function(Kind)
   if Kind == "prefix" then
      g.CommandsMenu_Rebuild()
   elseif Kind == "version" then
      if g.CommandsMenu_VersionLabel then
         g.CommandsMenu_VersionLabel.Text = "Version: " .. g.AdminVersion
      end
   end
end))

local overlap_params = OverlapParams.new()
overlap_params.FilterType = Enum.RaycastFilterType.Exclude
g.protect_enabled = g.protect_enabled or false
g.player_overlap_tracking = g.player_overlap_tracking or {}
local function protect_local_character()
	if not g.protect_enabled then return end
	local localplayer = LocalPlayer
	if not localplayer then return end
	local char = g.Character or localplayer.Character or get_char(LocalPlayer, 10)
	if not char then return end
	local hrp = g.HumanoidRootPart or char:FindFirstChild("HumanoidRootPart") or get_root(LocalPlayer, 5)
	if not hrp then return end
	if not g.walkflinging then
		local max_linear = 350
		local max_angular = 60
		local lv = hrp.AssemblyLinearVelocity
		if lv.Magnitude > max_linear then hrp.AssemblyLinearVelocity = Vector3.zero end
		local av = hrp.AssemblyAngularVelocity
		if av.Magnitude > max_angular then hrp.AssemblyAngularVelocity = av.Unit * max_angular end
	end

	overlap_params.FilterDescendantsInstances = {char}
	local tracking = g.player_overlap_tracking
	local parts = workspace:GetPartsInPart(hrp, overlap_params)
	local now = os.clock()

	for _, part in ipairs(parts) do
		local model = part:FindFirstAncestorOfClass("Model")
		if model then
			local plr = Players:GetPlayerFromCharacter(model)
			if plr and plr ~= localplayer then
				if not tracking[plr] then
					tracking[plr] = {attempts = 0, last_time = 0, reset_time = now}
				end
				local data = tracking[plr]
				if (now - data.last_time) > 3 then
					data.attempts = 0
					data.reset_time = now
				end

				if data.attempts < 2 and (now - data.last_time) > 0.4 then
					data.attempts += 1
					data.last_time = now
					local attacker_hrp = model:FindFirstChild("HumanoidRootPart")
					local push_origin = attacker_hrp and attacker_hrp.Position or part.Position
					local push_dir = hrp.Position - push_origin
					if push_dir.Magnitude > 0 then
						hrp.CFrame += push_dir.Unit * 3
					end
				end
			end
		end
	end

	for plr in pairs(tracking) do
		if not plr or not plr.Parent then
			tracking[plr] = nil
		end
	end
end

function set_protect_state(state)
	g.protect_enabled = state and true or false
	if g.protect_enabled then
		if not FlamesLibrary.is_alive("protect_heartbeat") then
			FlamesLibrary.connect("protect_heartbeat", RunService.Heartbeat:Connect(protect_local_character))
		end
	else
		if FlamesLibrary.is_alive("protect_heartbeat") then
			FlamesLibrary.disconnect("protect_heartbeat")
		end
		g.player_overlap_tracking = {}
	end
end

g.anti_follow_reset = g.anti_follow_reset or function()
   local char = g.Character or g.LocalPlayer.Character or LocalPlayer.Character
   if not char then return end
   local root = g.HumanoidRootPart or char:FindFirstChild("HumanoidRootPart") or get_root(LocalPlayer, 5)
   if not root then return end
   getgenv().Org_Destroy_Height = getgenv().Org_Destroy_Height or workspace.FallenPartsDestroyHeight
   if not getgenv().Org_Destroy_Height then getgenv().Org_Destroy_Height = 500 end
   local old_pos = root.CFrame
   workspace.FallenPartsDestroyHeight = 0
   root.CFrame = CFrame.new(Vector3.new(0, getgenv().Org_Destroy_Height - 25, 0))
   task.wait(1)
   root.CFrame = old_pos
   workspace.FallenPartsDestroyHeight = getgenv().Org_Destroy_Height
end

g.afEnabled = g.afEnabled or false
g.EnableAntiFling = function()
   if g.afEnabled then return end
   g.afEnabled = true
   g.antifling_enabled = true
   g.FlamesLibrary.disconnect("antifling")
   g.FlamesLibrary.connect("antifling", RunService.Stepped:Connect(function()
      if not g.afEnabled then return end
      for _, plr in ipairs(Players:GetPlayers()) do
         if plr ~= Players.LocalPlayer and plr.Character then
            for _, part in ipairs(plr.Character:GetDescendants()) do
               if part:IsA("BasePart") then
                  part.CanCollide = false
               end
            end
         end
      end
   end))
end

g.DisableAntiFling = function()
   if not g.afEnabled then return end
   g.afEnabled = false
   g.antifling_enabled = false
   g.FlamesLibrary.disconnect("antifling")
end

g.resolve_humanoid = function() -- specifically for do_emote and safe_emote, but I'll definitely use it for other stuff, like in the main code.
   local hum = g.Humanoid
   if hum and hum.Parent and hum:IsDescendantOf(game) then
      return hum
   end

   local char = g.Character
   if char and char.Parent then
      hum = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildWhichIsA("Humanoid")
      if hum then
         g.Humanoid = hum
         return hum
      end
   end

   local plr = Players and Players.LocalPlayer
   if plr then
      local resolvedChar = g.return_char and g.return_char(plr,10)
      if resolvedChar then
         hum = resolvedChar:FindFirstChildOfClass("Humanoid") or resolvedChar:FindFirstChildWhichIsA("Humanoid")
         if hum then
            g.Character = resolvedChar
            g.Humanoid = hum
            return hum
         end
      end
   end

   if g.getHum then
      local fallback = g.getHum(nil,5)
      if fallback then
         if fallback:IsA("Humanoid") then
            g.Humanoid = fallback
            g.Character = fallback.Parent
         elseif fallback.Parent then
            g.Character = fallback.Parent
         end
         return fallback
      end
   end

   return nil
end

g.Noclip_Enabled = g.Noclip_Enabled or false
g.Noclip_Connection = g.Noclip_Connection or nil
g.noclip_parts = g.noclip_parts or {}
local function refresh_parts()
   table.clear(g.noclip_parts)
   local Character = g.Character or LocalPlayer.Character or get_char(LocalPlayer, 10)
   if not Character then return end
   for _, inst in ipairs(Character:GetDescendants()) do
      if inst:IsA("BasePart") then
         table.insert(g.noclip_parts, inst)
      end
   end
end

local function noclip_step()
   local parts = g.noclip_parts
   for i = 1, #parts do
      local p = parts[i]
      if p and p.Parent and p.CanCollide then
         p.CanCollide = false
      end
   end
end

g.ToggleNoclip = function(state)
   local lib = getgenv().FlamesLibrary
   local key = "noclip_stepped"

   if state == true then
      if g.Noclip_Enabled then
         if g.notify then
            return g.notify("Warning", "Noclip is already enabled!", 5)
         end
         return
      end

      if lib.is_alive(key) then
         lib.disconnect(key)
      end

      refresh_parts()
      lib.connect(key, RunService.Stepped:Connect(noclip_step))
      g.Noclip_Enabled = true
      if g.notify then g.notify("Success", "Noclip has been enabled.", 5) end
   elseif state == false then
      if not g.Noclip_Enabled then
         if g.notify then
            return g.notify("Error", "Noclip is not enabled!", 5)
         end
         return
      end

      lib.disconnect(key)

      for i = 1, #g.noclip_parts do
         local part = g.noclip_parts[i]
         if part and part.Parent then
            part.CanCollide = true
         end
      end

      table.clear(g.noclip_parts)
      g.Noclip_Enabled = false

      if g.notify then g.notify("Success", "Noclip has been disabled.", 5) end
   else
      if g.notify then
         return g.notify("Error", "Invalid arg, expected true/false", 5)
      end
   end
end

g.spamming_flames = function(toggle)
   local lib = g.FlamesLibrary
   local connection_name = "flames_spammer"

   if toggle == true then
      if g.spamming_all_that_fire then
         return g.notify("Warning", "Flames Spammer V2 is already enabled.", 5)
      end

      g.spamming_all_that_fire = true
      lib.spawn(connection_name, "spawn", function()
         while g.spamming_all_that_fire == true do
            fw(0)
            g.Send("request_fire")
         end
      end)
   elseif toggle == false then
      if not g.spamming_all_that_fire then
         return g.notify("Warning", "Flames Spammer V2 is not enabled.", 5)
      end

      g.spamming_all_that_fire = false
      lib.disconnect(connection_name)
   end
end

g.Toggleable_Noclip = g.ToggleNoclip
wait(0.1)
g.Toggle_AntiFling_Boolean_Func = function(flag)
   if flag == true then
      if g.EnableAntiFling then
         g.EnableAntiFling()
      end
      if g.ToggleNoclip then
         g.ToggleNoclip(true)
      end
   elseif flag == false then
      if g.DisableAntiFling then
         g.DisableAntiFling()
      end
      if g.ToggleNoclip then
         g.ToggleNoclip(false)
      end
   else
      if g.notify then
         return g.notify("Warning", "Invalid arguments have been provided.", 3)
      else
         return 
      end
   end
end

g.anti_sit_func = function(toggle)
   local lib = g.FlamesLibrary
   local key = "anti_sit_loop"
   g.Seat = require(g.Game_Folder:FindFirstChild("Seat"))

   if toggle == true then
      if g.Not_Ever_Sitting then
         return notify("Warning", "AntiSit is already enabled!", 5)
      end

      g.Not_Ever_Sitting = true
      g.notify("Success", "Anti-Sit is now enabled!", 5)
      show_notification("Success:", "Anti-Sit is now enabled!", "Normal")
      lib.spawn(key, "spawn", function()
         while g.Not_Ever_Sitting == true do
            g.Seat.enabled.set(false)
            g.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            fw(0)
         end
         lib.disconnect(key)
      end)
   elseif toggle == false then
      if not g.Not_Ever_Sitting then
         return notify("Warning", "AntiSit is not enabled!", 5)
      end

      g.Not_Ever_Sitting = false
      lib.disconnect(key)
      fw(0.2)
      g.Seat.enabled.set(true)
      notify("Success", "Sitting is now enabled!", 5)
      Phone.show_notification("Success:", "Sitting is now enabled!", "Normal")
   else
      return 
   end
end

g.anti_void = function(flag)
   local lib = getgenv().FlamesLibrary
   local key = "anti_void_stepped"
   if flag == true then
      if g.Anti_Void_Enabled_Bool then return g.notify("Warning", "Anti-Void is already enabled.", 5) end
      if lib.is_alive(key) then return g.notify("Warning", "Anti-Void is already enabled.", 5) end
      if not g.originalFPDH then g.originalFPDH = workspace.FallenPartsDestroyHeight end
      task.wait(0.15)
      workspace.FallenPartsDestroyHeight = -100000
      lib.connect(key, RunService.Stepped:Connect(function()
         local root = g.HumanoidRootPart or g.Character and g.Character:FindFirstChild("HumanoidRootPart") or g.get_root(LocalPlayer, 5)
         if root and root.Position.Y <= g.originalFPDH + 25 then root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + Vector3.new(0, 300, 0) end
      end))

      g.Anti_Void_Enabled_Bool = true
      if g.notify then g.notify("Success", "Flames Hub | Anti-Void V2 has been enabled.", 5) end
   elseif flag == false then
      if not g.Anti_Void_Enabled_Bool then return g.notify("Warning", "Anti-Void is not enabled.", 5) end
      workspace.FallenPartsDestroyHeight = g.originalFPDH or -500
      lib.disconnect(key)
      g.Anti_Void_Enabled_Bool = false
      if g.notify then g.notify("Success", "Flames Hub | Anti-Void V2 has been disabled.", 5) end
   end
end

g.VehicleDestroyer_Enabled = g.VehicleDestroyer_Enabled or false
g.vehicle_parts_cache = g.vehicle_parts_cache or {}
local lib = getgenv().FlamesLibrary
local _uid = 0
local function make_key(prefix, inst) _uid = _uid + 1 return prefix .. "_" .. tostring(inst):gsub("[^%w]", "") .. "_" .. _uid end
local function is_in_vehicle(obj, vehicle) return vehicle and obj and obj:IsDescendantOf(vehicle) end
local function process_veh_part(part)
   if not part:IsA("BasePart") then return end
   if g.vehicle_parts_cache[part] then return end
   local my_vehicle = get_vehicle and get_vehicle()
   if my_vehicle and is_in_vehicle(part, my_vehicle) then return end
   part.CanCollide = false
   g.vehicle_parts_cache[part] = true

   local key = make_key("VehicleDestroyer_PartCleanup", part)
   lib.connect(key, part.AncestryChanged:Connect(function()
      if not part:IsDescendantOf(game) then
         g.vehicle_parts_cache[part] = nil
         lib.disconnect(key)
      end
   end))
end

local function process_veh_model(model)
   if not model or not model.Parent then
      local elapsed = 0
      repeat task.wait(0.5) elapsed = elapsed + 0.5 until (model and model.Parent) or elapsed >= 10
      if not model or not model.Parent then return end
   end
   local key = make_key("VehicleDestroyer_ModelCleanup", model)
   for _, inst in ipairs(model:GetDescendants()) do
      if inst:IsA("BasePart") then
         process_veh_part(inst)
      end
   end

   lib.connect(make_key("VehicleDestroyer_DescAdded", model), model.DescendantAdded:Connect(function(desc)
      if not g.VehicleDestroyer_Enabled then return end
      if desc:IsA("BasePart") then
         process_veh_part(desc)
      end
   end))
end

local function setup_vehicles_folder(folder)
   for _, child in ipairs(folder:GetChildren()) do
      if child:IsA("Model") then
         process_veh_model(child)
      elseif child:IsA("BasePart") then
         process_veh_part(child)
      end
   end

   if lib.is_alive("VehicleDestroyer_ChildAdded") then
      lib.disconnect("VehicleDestroyer_ChildAdded")
   end

   lib.connect("VehicleDestroyer_ChildAdded", folder.ChildAdded:Connect(function(child)
      if not g.VehicleDestroyer_Enabled then return end
      if child:IsA("Model") then
         process_veh_model(child)
      elseif child:IsA("BasePart") then
         process_veh_part(child)
      end
   end))

   if g.notify then
      g.notify("Success", "Flames Hub | Anti Vehicle Fling is now enabled.", 5)
   end
end

local function clear_all()
   g.VehicleDestroyer_Enabled = false
   table.clear(g.vehicle_parts_cache)
   lib.cleanup_all()
end

g.anti_car_fling = function(state)
   if state == true then
      if g.VehicleDestroyer_Enabled then
         if g.notify then
            g.notify("Warning", "Flames Hub | Anti Vehicle Fling is already enabled.", 5)
         end
         return
      end

      g.VehicleDestroyer_Enabled = true
      table.clear(g.vehicle_parts_cache)

      local vehicles_folder = Workspace:FindFirstChild("Vehicles")
      if vehicles_folder then
         setup_vehicles_folder(vehicles_folder)
      end

      lib.connect("VehicleDestroyer_FolderWatch", Workspace.ChildAdded:Connect(function(child)
         if not g.VehicleDestroyer_Enabled then return end
         if child.Name == "Vehicles" and child:IsA("Folder") then
            setup_vehicles_folder(child)
         end
      end))
   elseif state == false then
      if not g.VehicleDestroyer_Enabled then
         if g.notify then
            g.notify("Warning", "Anti Vehicle Fling not enabled.", 5)
         end
         return
      end

      clear_all()

      if g.notify then
         g.notify("Success", "Anti Vehicle Fling disabled.", 5)
      end
   end
end

local Emotes = {
   griddy = {
      129149402922241,
      77017926307035,
      106715239721951,
      75519433871034,
      71599151163683,
      84423618364170
   },
   scenario = {103046131635200},
   worm = {
      132950274861655,
      127882676467351,
      77625642316480,
      127068135887882,
      102075861555461,
   },
   zen = {84943987730610, 76095183942765, 81184089862052, 89693047872266, 119227859593753, 123243642228406, 128477274737746, 102077334254005},
   glitching = {131961970776128, 95208749251803, 107555663156717, 97629104004619, 132916125159592},
   superman = {
      134861929761233,
      93202303625509,
      75684443936987,
      71498318840551,
      107357050902519,
      137759282507703,
      113298527970213,
   },
   aura = {
      121547391421211,
      78755795767408,
      88425531063616,
      111426928948833,
      111499780397123,
      88553023837929,
      120398163328092,
      95412133796590,
      132887675877488,
      95483853291380,
      70921452128720,
      138869443549653,
      139398539248787,
      133648741119386,
      130211190821898, -- supposed to be a matching emote, but I don't care.
      116061178568954,
      139010389792767,
      80682104018373,
      126292220920227,
      104762088712460,
      125436944152254,
      85491240960235,
      86617727183442,
      135502214162191,
      107282826166809,
      107357050902519,
      122430864477945,
      115607505668069,
      99436360152977,
      84052327668385,
      124573843932871,
      83502723504906,
      77605999050017,
      121269961544903,
      82740818250922,
      116826272832592, -- like flippin sexy
      116520353469867,
      103040723950430,
      111474274315212,
      85452015445985,
	   124094170750791,
      133995514450232,
      119268981291283,
      98189714319894,
      102123532321843,
      73723042388431,
      83445140188306,
	   110511723808460,
      127504816844209,
      106383862917130,
      119895570354822,
      87952355078673, -- lowkey my favorite to use.
      89740608652762,
      138488768673643,
      110077386833639,
      89841968488285,
      110559530726888,
      125538647347467,
      -- [[ all favorites below here. ]] --
      133594786690861,
      107231572255639,
      88342628481682,
      134633282441756, -- lowkey a favorite.
      118621002438382,
      114815620875713,
      78068633604332,
      107572993172129,
      114939972688532,
      95866865865101,
      130095116338584,
      85491240960235,
      95413909467411,
      73532860571147,
      120349910050318,
      133837116020009,
   },
   orangejustice = {
      133160900449608,
      110064349530772,
      117638432093760,
      76494145762351,
      84419755287539,
      98578127060782,
   },
   default = {
      80877772569772,
      99818263438846,
      121094705979021,
      128801735413980,
      83559276301867,
      100099256371667,
   },
   koto = {
      91927498467600,
      130655908439646,
      108129969514208,
      121962822800440,
      105003458897417,
   },
   popular = {
      71302743123422,
   },
   billybounce = {
      126516908191316,
      93450937830334,
      131013364061967,
      79167827943499,
      117671570219174,
   },
   billyjean = {
      98915045016286,
      118867650282719,
      124924265548892,
   },
   michaelmyers = {
      103115491327846,
      114619890795549,
      85106566131117,
      120061939060268, -- I fw that lowkey lmfao.
      131290182355038,
      108434770822522,
      130952080730659,
   },
   sturdy = {
      122687759897103,
      133826541787717,
      85608190427964,
      136037836393259,
      113117373434389,
   },
   louisiana_jigg = {
      75625820126017,
      125646873823019,
      107053470249601,
   },
   takethel = {
      112884830175040,
      73593666217037,
      120292213172333,
      133545170540942,
      107451871815376,
      82405492529515,
      71490439912804,
      113855231967763,
   },
   electroshuffle = {
      102699471013529,
      96426537876059,
      140499299581464,
      82438623948539,
      105718839118743,
      132194448573369,
   },
   laughitup = {
      90599528248903,
   },
   reanimated = {
      88624941199927,
      112989413190899,
   },
   jabba = {
      103538719480738,
      81074563419184,
      116936259925650,
      91111622942605,
      97502008524120,
      78000690242935,
      97263887198327,
      126450121068943,
   },
   freaky = {
      71014156366577, -- deleted
      135404588651407, -- deleted
   },
   motion = {
      116986761294290,
   },
   tuff = {
      97505694413413,
   },
   needydance = {
      73810609930655,
      128404559301134,
      85116004655341,
      117694627966105,
      111139266390945,
      109334537949622,
      73823025897559,
      110470494752196,
      121021070983682,
      106954828406312,
      120297764741811,
      111539333518905,
      75710785243393,
      107014304867611,
      89635826639063,
      105856550104502,
      91510776097850,
      106512155105010,
   }
}
wait(0.1)
g.Emotes = Emotes -- needs to dynamically update, I'm not sure why in the hell I wouldn't make it that way.

local function safeemote(emote_id)
   local hum = g.Humanoid or g.Character:FindFirstChildWhichIsA("Humanoid") or get_human(LocalPlayer or game.Players.LocalPlayer)
   if not hum or not hum.Parent then
      if g.notify then
         return g.notify("Error", "Humanoid missing or invalid.", 5)
      else
         return 
      end
   end

   local tries = 0
   while not hum:IsDescendantOf(game) and tries < 30 do
      task.wait(0.1)
      tries += 1
   end

   if not hum:IsDescendantOf(game) then
      if g.notify then
         return g.notify("Error", "Humanoid not fully initialized in DataModel.", 5)
      else
         return 
      end
   end

   hum:PlayEmoteAndGetAnimTrackById(emote_id)
end

local Aliases = {
   ["orange justice"] = "orangejustice",
   ["orange_justice"] = "orangejustice",
   ["orangej"] = "orangejustice",
   ["default dance"] = "default",
   ["defaultdance"] = "default",
   ["kotonai"] = "koto",
   ["pop"] = "popular",
   ["glitch"] = "glitching",
   ["buggingout"] = "glitching",
   ["glitchingout"] = "glitching",
   ["glitched"] = "glitching",
   ["vibrating"] = "glitching",
   ["shaking"] = "glitching",
   ["aurafarming"] = "aura",
   ["aurafloating"] = "aura",
   ["aurafloat"] = "aura",
   ["aurafarm"] = "aura",
   ["billyb"] = "billybounce",
   ["billybouncing"] = "billybounce",
   ["bbounce"] = "billybounce",
   ["michaelmyer"] = "michaelmyers",
   ["michaelbounce"] = "michaelmyers",
   ["nysturdy"] = "sturdy",
   ["newyorksturdy"] = "sturdy",
   ["jiggy"] = "louisiana_jigg",
   ["takel"] = "takethel",
   ["takeanl"] = "takethel",
   ["ldance"] = "takethel",
   ["elecshuffle"] = "electroshuffle",
   ["eshuffle"] = "electroshuffle",
   ["reanimate"] = "reanimated",
   ["donkeylaugh"] = "laughitup",
   ["laughing"] = "laughitup",
   ["fnlaugh"] = "laughitup",
   ["fortnitelaugh"] = "laughitup",
   ["sus"] = "freaky",
   ["bang"] = "freaky",
   ["suspicious"] = "freaky",
   ["weird"] = "freaky",
   ["hellamotion"] = "motion",
   ["tuffdance"] = "tuff",
   ["needy"] = "needydance",
   ["needytwerk"] = "needydance",
   ["needyshake"] = "needydance",
   ["needy_twerk"] = "needydance"
}
wait(0.1)
g.Aliases = Aliases -- this also needs to be dynamic, leave it as such.
wait(0.2)
g.disable_emoting_from_broken_animation = function()
   local Humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("Humanoid")
   if not Humanoid then
      if g.notify then
         return g.notify("Error", "Humanoid not found, try resetting.", 5)
      else
         return 
      end
   end

   if g.Humanoid and g.Humanoid.Sit then
      pcall(function() g.Humanoid:ChangeState(3) end)
   end

   pcall(function()
      for _, v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
         v:Stop()
      end
   end)

   if g.Humanoid and g.Humanoid.Parent and g.Humanoid:IsDescendantOf(game) then
      pcall(function() g.Humanoid.WalkSpeed = 0 end)
      wait(0.3)
      pcall(function() g.Humanoid:ChangeState(3) end)
   end
   wait(1.2)
   if g.Is_Currently_Emoting then
      g.Is_Currently_Emoting = false
      g.Humanoid.WalkSpeed = 16
   else
      g.Humanoid.WalkSpeed = 16
   end
end

function disable_emoting()
   local Humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("Humanoid")
   if not Humanoid then
      if g.notify then
         return g.notify("Error", "Humanoid not found, try resetting.", 5)
      else
         return 
      end
   end

   if g.Humanoid and g.Humanoid.Sit then
      pcall(function() g.Humanoid:ChangeState(3) end)
   end

   pcall(function()
      for _, v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
         v:Stop()
      end
   end)

   if g.Humanoid and g.Humanoid.Parent and g.Humanoid:IsDescendantOf(game) then
      pcall(function() g.Humanoid.WalkSpeed = 0 end)
      wait(0.3)
      pcall(function() g.Humanoid:ChangeState(3) end)
   end
   wait(1.2)
   if g.Is_Currently_Emoting then
      g.Is_Currently_Emoting = false
      g.Humanoid.WalkSpeed = 16
   else
      g.Humanoid.WalkSpeed = 16
   end
end
wait(0.1)
g.disable_emoting_script = disable_emoting
g.disable_emoting = disable_emoting

local function safe_emote(emote_id)
   while not g.Humanoid or not g.Humanoid:IsDescendantOf(game) do
      task.wait(0.1)
   end

   local animator = g.Humanoid:FindFirstChildOfClass("Animator")
   if not animator then
      animator = Instance.new("Animator")
      animator.Parent = g.Humanoid
   end

   local resolvedTrack
   local connection
   connection = g.Humanoid.AnimationPlayed:Connect(function(track)
      resolvedTrack = track
   end)

   local result = g.Humanoid:PlayEmoteAndGetAnimTrackById(emote_id)

   task.wait()

   connection:Disconnect()

   if typeof(resolvedTrack) ~= "Instance" or not resolvedTrack:IsA("AnimationTrack") then
      if g.notify then
         if g.disable_emoting_script then
            pcall(function() g.disable_emoting_from_broken_animation() end)
         end
         return g.notify("Error", "Could not resolve Emote animation, try again.", 6)
      else
         return warn("Could not resolve Emote animation, try again.")
      end
   end

   local animObject = resolvedTrack.Animation
   if not animObject or not animObject.AnimationId then
      resolvedTrack:Stop()
      return
   end

   local internalId = animObject.AnimationId
   resolvedTrack:Stop()

   for _, v in ipairs(g.Humanoid:GetPlayingAnimationTracks()) do pcall(function() v:Stop() end) end
   local newAnim = Instance.new("Animation")
   newAnim.AnimationId = internalId

   local newTrack = animator:LoadAnimation(newAnim)
   newAnim:Destroy()
   newTrack.Priority = Enum.AnimationPriority.Movement
   newTrack.Looped = true
   newTrack:Play()

   g.Is_Currently_Emoting = true

   task.defer(function()
      newTrack.Stopped:Wait()
      g.Is_Currently_Emoting = false
   end)
end

local function playemote(emote_id)
   if g.Is_Currently_Emoting then
      for _, v in ipairs(g.Humanoid:GetPlayingAnimationTracks()) do
         pcall(function() v:Stop() end)
      end
      g.Is_Currently_Emoting = false
   end

   task.spawn(function()
      safe_emote(emote_id)
   end)
end

g.playemote = playemote

function do_emote(input)
   if not g.Humanoid or not g.Humanoid.Parent then
      if g.notify then
         return g.notify("Error", "Humanoid missing, reset and try again!", 7)
      else
         return 
      end
   end

   local key = input:lower():gsub("%s+", "")
   key = g.Aliases[key] or key

   local list = g.Emotes[key]
   if not list then
      if g.notify then
         return g.notify("Error", "Unknown emote: "..tostring(key), 5)
      else
         return 
      end
   end

   local id = list[math.random(1, #list)]
   playemote(id)
end

g.do_emote = do_emote

local function fetch_emotes(keyword, count)
   count = count or 25
   local params = CatalogSearchParams.new()
   params.SearchKeyword = keyword or ""
   params.CategoryFilter = Enum.CatalogCategoryFilter.None
   params.SalesTypeFilter = Enum.SalesTypeFilter.All
   params.AssetTypes = { Enum.AvatarAssetType.EmoteAnimation }
   params.IncludeOffSale = true
   params.SortType = Enum.CatalogSortType.Relevance
   params.Limit = 10

   local ok, pages = pcall(function()
      return avatar_editor:SearchCatalog(params)
   end)

   if not ok or not pages then
      warn("fetch failed")
      return {}
   end

   local results = {}
   while #results < count do
      local ok2, page = pcall(function()
         return pages:GetCurrentPage()
      end)

      if not ok2 or not page then break end

      for _, item in ipairs(page) do
         table.insert(results, {
            id       = item.Id,
            asset_id = item.AssetId or item.Id,
            name     = item.Name or "Unknown",
         })
         if #results >= count then break end
      end

      if pages.IsFinished or #results >= count then break end

      local ok3 = pcall(function()
         pages:AdvanceToNextPageAsync()
      end)

      if not ok3 then break end
   end

   return results
end

local emotes = fetch_emotes("needy", 25)

g.emote_list = emotes
g.play_random_emote = function()
   if #emotes == 0 then return getgenv().notify("Warning", "No emotes loaded.", 5) end
   local emote = emotes[math.random(1, #emotes)]
   g.playemote(emote.asset_id)
end

g.play_emote_by_index = function(index)
   local emote = emotes[index]
   if not emote then getgenv().notify("Error", "No emote at index: "..tostring(index), 5) return end
   g.playemote(emote.asset_id)
end
