-- [[ welcome to the NEW and IMPROVED fully global environmental initialization system. ]] --
-- [[ it LITERALLY dumbs down everything for us so simply. ]] --
-- [[ it's literally like one of the safest things I think I've ever created, EVERYTHING is checked. ]] --
if not game:IsLoaded() then game.Loaded:Wait() end
if getgenv().GlobalEnvironmentFramework_Initialized then return end
local g = getgenv()
local game_ref = game
local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
if not getgenv().Players then getgenv().Players = Players end
local Workspace = g.Workspace or cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
if not getgenv().Workspace then getgenv().Workspace = Workspace end
local HttpService = g.HttpService or cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
if not getgenv().HttpService then getgenv().HttpService = HttpService end
g.wait_until = function(condition, interval, max_tries)
    interval = tonumber(interval) or 0.05
    if typeof(max_tries) == "string" then
        local lower = max_tries:lower()
        -- [[ cannot be more obvious lol ]] --
        if lower == "inf" or lower == "infinite" or lower == "infinity" or lower == "∞" then
            max_tries = 999999999999
        else
            max_tries = tonumber(max_tries)
        end
    end

    max_tries = max_tries or 500
    if interval < 0.03 then interval = 0.05 end
    if typeof(condition) ~= "function" then
        local target = condition
        condition = function() return (typeof(target) == "Instance" and target.Parent ~= nil) or target end
    end

    local tries = 0
    repeat
        task.wait(interval)
        tries += 1
    until condition() or tries >= max_tries
    return condition() and true or false
end

g.FuzzyFindChild = function(parent, query, timeout)
    if not parent or typeof(parent) ~= "Instance" then return nil end
    if not query or query == "" then return nil end
    timeout = timeout or 3
    local Lowered_Query = query:lower()
    local Start_Time = os.clock()

    repeat
        for _, Child in ipairs(parent:GetChildren()) do if Child.Name:lower():find(Lowered_Query, 1, true) then return Child end end
        task.wait(0.1)
    until os.clock() - Start_Time >= timeout
    return nil
end

g.FuzzyFindChildWithClass = function(parent, query, class_name, timeout)
    if not parent or typeof(parent) ~= "Instance" then return nil end
    if not query or query == "" then return nil end
    timeout = timeout or 3
    local Lowered_Query = query:lower()
    local Lowered_Class = class_name and class_name:lower() or nil
    local Start_Time = os.clock()

    repeat
        for _, Child in ipairs(parent:GetChildren()) do
            local Name_Match = Child.Name:lower():find(Lowered_Query, 1, true)
            local Class_Match = not Lowered_Class or Child.ClassName:lower() == Lowered_Class
            if Name_Match and Class_Match then return Child end
        end
        task.wait(0.1)
    until os.clock() - Start_Time >= timeout
    return nil
end

g.FuzzyFindDescendantWithClass = function(parent, query, class_name, timeout)
    if not parent or typeof(parent) ~= "Instance" then return nil end
    if not query or query == "" then return nil end
    timeout = timeout or 3
    local Lowered_Query = query:lower()
    local Lowered_Class = class_name and class_name:lower() or nil
    local Start_Time = os.clock()

    repeat
        for _, Child in ipairs(parent:GetDescendants()) do
            local Name_Match = Child.Name:lower():find(Lowered_Query, 1, true)
            local Class_Match = not Lowered_Class or Child.ClassName:lower() == Lowered_Class
            if Name_Match and Class_Match then return Child end
        end
        task.wait(0.1)
    until os.clock() - Start_Time >= timeout
    return nil
end

g.colors = g.colors or {
	Color3.fromRGB(255,255,255),
	Color3.fromRGB(128,128,128),
	Color3.fromRGB(0,0,0),
	Color3.fromRGB(0,0,255),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,255,255),
	Color3.fromRGB(255,165,0),
	Color3.fromRGB(139,69,19),
	Color3.fromRGB(255,255,0),
	Color3.fromRGB(50,205,50),
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(255,155,172),
	Color3.fromRGB(128,0,128),
}

g.colors_color_three = g.colors_color_three or {
	Color3.new(1, 1, 1),
	Color3.new(0.5019607843137255, 0.5019607843137255, 0.5019607843137255),
	Color3.new(0, 0, 0),
	Color3.new(0, 0, 1),
	Color3.new(0, 1, 0),
	Color3.new(0, 1, 1),
	Color3.new(1, 0.6470588235294118, 0),
	Color3.new(0.5450980392156862, 0.27058823529411763, 0.07450980392156863),
	Color3.new(1, 1, 0),
	Color3.new(0.19607843137254902, 0.803921568627451, 0.19607843137254902),
	Color3.new(1, 0, 0),
	Color3.new(1, 0.6078431372549019, 0.6745098039215686),
	Color3.new(0.5019607843137255, 0, 0.5019607843137255),
}

local http_service = HttpService
g._rgb_conns = g._rgb_conns or {}
g._rgb_global_conn = g._rgb_global_conn or nil
g.rgb_color_map = g.rgb_color_map or {
    red = Color3.fromRGB(255,0,0),
    darkred = Color3.fromRGB(139,0,0),
    green = Color3.fromRGB(0,255,0),
    darkgreen = Color3.fromRGB(0,100,0),
    lime = Color3.fromRGB(50,205,50),
    blue = Color3.fromRGB(0,0,255),
    darkblue = Color3.fromRGB(0,0,139),
    lightblue = Color3.fromRGB(173,216,230),
    skyblue = Color3.fromRGB(135,206,235),
    white = Color3.fromRGB(255,255,255),
    black = Color3.fromRGB(0,0,0),
    gray = Color3.fromRGB(128,128,128),
    lightgray = Color3.fromRGB(211,211,211),
    darkgray = Color3.fromRGB(64,64,64),
    yellow = Color3.fromRGB(255,255,0),
    gold = Color3.fromRGB(255,215,0),
    orange = Color3.fromRGB(255,165,0),
    darkorange = Color3.fromRGB(255,140,0),
    purple = Color3.fromRGB(128,0,128),
    violet = Color3.fromRGB(238,130,238),
    indigo = Color3.fromRGB(75,0,130),
    pink = Color3.fromRGB(255,105,180),
    hotpink = Color3.fromRGB(255,20,147),
    cyan = Color3.fromRGB(0,255,255),
    teal = Color3.fromRGB(0,128,128),
    brown = Color3.fromRGB(139,69,19),
    tan = Color3.fromRGB(210,180,140),
    magenta = Color3.fromRGB(255,0,255),
    coral = Color3.fromRGB(255,127,80),
    salmon = Color3.fromRGB(250,128,114)
}

g.rgb_color_index = {}
do
    local i = 1
    for name in pairs(g.rgb_color_map) do
        g.rgb_color_index[i] = name
        i = i + 1
    end
end

local function ensure_global_loop()
    if g._rgb_global_conn then return end
    local rs = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
    local conn = rs.RenderStepped:Connect(function(dt)
        local conns = g._rgb_conns
        local any = false
        for _, data in pairs(conns) do
            if data and data.obj then
                any = true
                if not data.paused then
                    data.hue = (data.hue + (dt * data.speed)) % 1
                    data.obj.BackgroundColor3 = Color3.fromHSV(data.hue, 1, 1)
                end
            end
        end

        if not any then
            g._rgb_global_conn:Disconnect()
            g._rgb_global_conn = nil
        end
    end)

    g._rgb_global_conn = conn
end

g.flowrgb = g.flowrgb or function(name, speed, obj, toggle)
    local conns = g._rgb_conns
    if toggle == false then
        conns[name] = nil
        return
    end

    conns[name] = {
        obj = obj,
        speed = speed,
        hue = 0,
        paused = false
    }

    ensure_global_loop()
end

g.toggle_rgb = g.toggle_rgb or function(name, state) -- toggle a certain connection.
    local data = g._rgb_conns[name]
    if data then
        data.paused = state
    end
end

g.toggle_all_rgb = g.toggle_all_rgb or function(state) -- toggle all
    for _, data in pairs(g._rgb_conns) do
        if data then
            data.paused = state
        end
    end
end

g.set_rgb_color_smart = g.set_rgb_color_smart or function(name, input)
    local data = g._rgb_conns[name]
    if not data or not data.obj then return end

    local color

    if typeof(input) == "string" then
        color = g.rgb_color_map[input:lower()]
    elseif typeof(input) == "number" then
        local cname = g.rgb_color_index[input]
        if cname then color = g.rgb_color_map[cname] end
    elseif typeof(input) == "Color3" then
        color = input
    end

    if not color then
        local keys = {}
        for k in pairs(g.rgb_color_map) do keys[#keys+1] = k end
        color = g.rgb_color_map[keys[math.random(1, #keys)]]
    end

    data.obj.BackgroundColor3 = color
end

g.set_all_rgb_color_smart = g.set_all_rgb_color_smart or function(input)
    local color

    if typeof(input) == "string" then
        color = g.rgb_color_map[input:lower()]
    elseif typeof(input) == "number" then
        local cname = g.rgb_color_index[input]
        if cname then color = g.rgb_color_map[cname] end
    elseif typeof(input) == "Color3" then
        color = input
    end

    if not color then
        local keys = {}
        for k in pairs(g.rgb_color_map) do keys[#keys+1] = k end
        color = g.rgb_color_map[keys[math.random(1, #keys)]]
    end

    for _, data in pairs(g._rgb_conns) do
        if data and data.obj then
            data.obj.BackgroundColor3 = color
        end
    end
end

g.set_all_rgb_color = g.set_all_rgb_color or function(color)
    for _, data in pairs(g._rgb_conns) do
        if data and data.obj then
            data.obj.BackgroundColor3 = color
        end
    end
end

getgenv().type_chooser = function(value)
    local ok, result = pcall(function() return typeof(value) end)
    if ok and result then return result end
    local ok2, result2 = pcall(function() return type(value) end)
    if ok2 and result2 then return result2 end
    return nil
end
wait(0.1)
getgenv().service_cache = getgenv().service_cache or {}
local aliases = {
    rs = "ReplicatedStorage",
    rf = "ReplicatedFirst",
    ws = "Workspace",
    works = "Workspace",
    player = "Players",
    plr = "Players",
    plrs = "Players",
    ts = "TweenService",
    uis = "UserInputService",
    aes = "AvatarEditorService"
}

local virtuals = {lp = true, localplayer = true, localplr = true}
local function levenshtein(a, b)
    a = a:lower()
    b = b:lower()
    local len_a, len_b = #a, #b
    if len_a == 0 then return len_b end
    if len_b == 0 then return len_a end
    local matrix = {}
    for i = 0, len_a do matrix[i] = {[0] = i} end
    for j = 0, len_b do matrix[0][j] = j end
    for i = 1, len_a do
        for j = 1, len_b do
        local cost = (a:sub(i,i) == b:sub(j,j)) and 0 or 1
        matrix[i][j] = math.min(
            matrix[i-1][j] + 1,
            matrix[i][j-1] + 1,
            matrix[i-1][j-1] + cost
        )
        end
    end

    return matrix[len_a][len_b]
end

local function resolve_service(input)
    if not input then return nil end
    local lowered = tostring(input):lower()
    if aliases[lowered] then return aliases[lowered] end
    local children = game:GetChildren()

    for _, svc in ipairs(children) do
        if svc.Name:lower() == lowered then
            return svc.Name
        end
    end

    for _, svc in ipairs(children) do
        if svc.Name:lower():find(lowered, 1, true) then
            return svc.Name
        end
    end

    local best_name
    local best_score = math.huge

    for _, svc in ipairs(children) do
        local score = levenshtein(lowered, svc.Name:lower())
        if score < best_score then
            best_score = score
            best_name = svc.Name
        end
    end

    if best_score <= 4 then return best_name end
    return nil
end

local function fetch_value(name)
    if not name then return nil end
    local lowered = tostring(name):lower()

    if virtuals[lowered] then
        local ok, players = pcall(function() return getgenv().service_cache["Players"].LocalPlayer end)
        if not ok or not players then return nil end
        local lp = players.LocalPlayer
        if lp then return lowered, lp end
        return nil
    end

    local resolved = resolve_service(name)
    if not resolved then return nil end
    local ok, svc = pcall(function() return game:GetService(resolved) end)
    if not ok or not svc then return nil end
    if cloneref then local success, cloned = pcall(function() return cloneref(svc) end) if success and cloned then svc = cloned end end
    return resolved, svc
end

if setmetatable and getmetatable and rawget and rawset then
    if not getmetatable(getgenv().service_cache) then
        setmetatable(getgenv().service_cache, {
        __index = function(self, key)
            local existing = rawget(self, key)
            if existing then return existing end
            local resolved_key, value = fetch_value(key)
            if not value then return nil end
            rawset(self, key, value)
            if resolved_key and resolved_key ~= key then rawset(self, resolved_key, value) end
            return value
        end})
    end

    getgenv().safe_wrapper = function(name)
        if not name then return nil end
        return getgenv().service_cache[name]
    end
else
    getgenv().safe_wrapper = function(name)
        if not name then return nil end
        if getgenv().service_cache[name] then return getgenv().service_cache[name] end
        local resolved_key, value = fetch_value(name)
        if not value then return nil end
        getgenv().service_cache[name] = value
        if resolved_key and resolved_key ~= name then getgenv().service_cache[resolved_key] = value end
        return value
    end
end

local function resolve_property(map, search)
    local search_lower = search:lower()
    local matches = {}

    for _, prop_name in ipairs(map) do
        if prop_name:lower():find(search_lower) then
            table.insert(matches, prop_name)
        end
    end

    return matches
end

getgenv().FlamesLibrary = getgenv().FlamesLibrary or {}
getgenv().FlamesLibrary._connections = getgenv().FlamesLibrary._connections or {}
getgenv().FlamesLibrary.modules = getgenv().FlamesLibrary.modules or {} -- new
getgenv().FlamesLibrary.module_utils = getgenv().FlamesLibrary.module_utils or {} -- new
getgenv().FlamesLibrary.connect = function(name, connection)
    local existing = getgenv().FlamesLibrary._connections[name]
    if existing then
        for _, item in ipairs(existing) do
            if typeof(item) == "RBXScriptConnection" then
                pcall(function() item:Disconnect() end)
            elseif type(item) == "thread" then
                pcall(task.cancel, item)
            end
        end
    end
    getgenv().FlamesLibrary._connections[name] = {connection}
    return connection
end

getgenv().FlamesLibrary.disconnect = function(name)
	local list = getgenv().FlamesLibrary._connections[name]

	if list then
		for _, item in ipairs(list) do
			if typeof(item) == "RBXScriptConnection" then
				item:Disconnect()
			elseif type(item) == "thread" then
				pcall(task.cancel, item)
			end
		end
		getgenv().FlamesLibrary._connections[name] = nil
	end
end

getgenv().FlamesLibrary.spawn = function(name, mode, ...)
	if not name or not mode then return end
	if getgenv().FlamesLibrary._connections[name] then getgenv().FlamesLibrary.disconnect(name) end
	getgenv().FlamesLibrary._connections[name] = {}

	local thread
	local args = {...}
	if mode == "spawn" then
		local func = args[1]
		if type(func) ~= "function" then return end
		thread = task.spawn(func, table.unpack(args, 2))
	elseif mode == "defer" then
		local func = args[1]
		if type(func) ~= "function" then return end
		thread = task.defer(func, table.unpack(args, 2))
	elseif mode == "delay" then
		local delay_time = args[1]
		local func = args[2]
		if type(delay_time) ~= "number" or type(func) ~= "function" then return end
		thread = task.delay(delay_time, func, table.unpack(args, 3))
	elseif mode == "wrap" then
		local func = args[1]
		if type(func) ~= "function" then return end
		thread = coroutine.create(func)
		coroutine.resume(thread, table.unpack(args, 2))
	else
		return
	end

	table.insert(getgenv().FlamesLibrary._connections[name], thread)
	return thread
end

getgenv().FlamesLibrary.is_thread_alive = function(input)
    local lib = getgenv().FlamesLibrary
    if type(input) == "thread" then
        local ok, status = pcall(coroutine.status, input)
        if not ok then return false end
        return status ~= "dead"
    end

    if type(input) == "string" then
        local list = lib._connections[input]
        if not list then return false end
        for _, item in ipairs(list) do
            if type(item) == "thread" then
                local ok, status = pcall(coroutine.status, item)
                if ok and status ~= "dead" then return true end
            end
        end
        return false
    end

    return false
end

getgenv().FlamesLibrary.is_alive = function(name)
    local lib = getgenv().FlamesLibrary
    local list = lib._connections[name]
    if not list then return false end

    for _, item in ipairs(list) do
        if typeof(item) == "RBXScriptConnection" then
            if item.Connected then
                return true
            end
        elseif type(item) == "thread" then
            if lib.is_thread_alive(item) then
                return true
            end
        end
    end

    return false
end

getgenv().FlamesLibrary.safe_func = function(...)
    for i = 1, select("#", ...) do
        local f = select(i, ...)
        local ok, t = pcall(typeof, f)
        if ok and t == "function" then
            return f
        end
    end
    return function() end
end

-- [[ safer wait functionality. ]] --
getgenv().FlamesLibrary.wait = function(t)
    local r_s = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
    if not t or t <= 0 then r_s.Heartbeat:Wait() return end
    local ok = pcall(task.wait, t)
    if not ok then r_s.Heartbeat:Wait() end
end

getgenv().FlamesLibrary.cleanup_all = function() for name in pairs(getgenv().FlamesLibrary._connections) do getgenv().FlamesLibrary.disconnect(name) end end
getgenv().FlamesLibrary.modules.chat_filter_override = {
    enabled = false,
    start = function(self)
        if self.enabled then return end
        self.enabled = true
        local text_chat_service = cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")
        local players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
        local chat = cloneref and cloneref(game:GetService("Chat")) or game:GetService("Chat")
        local function will_tag(text)
            local filtered
            local success, response = pcall(function()
                filtered = chat:FilterStringForBroadcast(text, players.LocalPlayer)
            end)

            if not success then
                return true
            end

            return filtered ~= text
        end

        text_chat_service.OnIncomingMessage = function(v)
            local prop = Instance.new("TextChatMessageProperties")
            if v.TextSource and v.TextSource.UserId == players.LocalPlayer.UserId and will_tag(v.Text) then
                prop.Text = "."
                prop.PrefixText = "."
                getgenv().FlamesLibrary.wait(0.25)
                prop.Text = nil
                if getgenv().notify then getgenv().notify("Warning", "That message seems to have been filtered! We have stopped you from getting banned from it.", 3) end
                return prop
            end

            return prop
        end
    end,

    stop = function(self)
        if not self.enabled then return end
        self.enabled = false
        local text_chat_service = cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")
        text_chat_service.OnIncomingMessage = nil
    end,

    toggle = function(self, state)
        if state == nil then state = not self.enabled end
        if state then
            self:start()
        else
            self:stop()
        end
    end
}

getgenv().FlamesLibrary.modules.disable_all = function()
    for name, mod in pairs(getgenv().FlamesLibrary.modules) do
        if type(mod) == "table" and mod.stop then
            mod:stop()
        end
    end
end

getgenv().FlamesLibrary.modules.list_enabled = function()
    local active = {}
    for name, mod in pairs(getgenv().FlamesLibrary.modules) do
        if type(mod) == "table" and mod.enabled then
            table.insert(active, name)
        end
    end
    return active
end

getgenv().FlamesLibrary.modules.list_disabled = function()
    local inactive = {}
    for name, mod in pairs(getgenv().FlamesLibrary.modules) do
        if type(mod) == "table" and not mod.enabled then
            table.insert(inactive, name)
        end
    end
    return inactive
end

getgenv().FlamesLibrary.property_maps = getgenv().FlamesLibrary.property_maps or {}
getgenv().FlamesLibrary.property_maps.humanoid = {
    "AutoJumpEnabled",
    "AutoRotate",
    "AutomaticScalingEnabled",
    "BreakJointsOnDeath",
    "CameraOffset",
    "CollisionType",
    "DisplayDistanceType",
    "DisplayName",
    "EvaluateStateMachine",
    "FloorMaterial",
    "HealthDisplayDistance",
    "HealthDisplayType",
    "HipHeight",
    "Jump",
    "JumpHeight",
    "JumpPower",
    "LeftLeg",
    "MaxSlopeAngle",
    "MoveDirection",
    "NameDisplayDistance",
    "NameOcclusion",
    "PlatformStand",
    "RequiresNeck",
    "RigType",
    "RightLeg",
    "RootPart",
    "SeatPart",
    "Sit",
    "TargetPoint",
    "Torso",
    "UseJumpPower",
    "WalkSpeed",
    "WalkToPart",
    "WalkToPoint",
}

getgenv().FlamesLibrary.property_maps.starter_player = {
    "AllowCustomAnimations",
    "AutoJumpEnabled",
    "AvatarJointUpgrade",
    "CameraMaxZoomDistance",
    "CameraMinZoomDistance",
    "CameraMode",
    "CharacterBreakJointsOnDeath",
    "CharacterJumpHeight",
    "CharacterJumpPower",
    "CharacterMaxSlopeAngle",
    "CharacterUseJumpPower",
    "CharacterWalkSpeed",
    "ClassicDeath",
    "CreateDefaultPlayerModule",
    "DevCameraOcclusionMode",
    "DevComputerCameraMovementMode",
    "DevComputerMovementMode",
    "DevTouchCameraMovementMode",
    "DevTouchMovementMode",
    "EnableDynamicHeads",
    "EnableMouseLockOption",
    "GameSettingsAssetIDFace",
    "GameSettingsAssetIDHead",
    "GameSettingsAssetIDLeftArm",
    "GameSettingsAssetIDLeftLeg",
    "GameSettingsAssetIDPants",
    "GameSettingsAssetIDRightArm",
    "GameSettingsAssetIDRightLeg",
    "GameSettingsAssetIDShirt",
    "GameSettingsAssetIDTeeShirt",
    "GameSettingsAssetIDTorso",
    "GameSettingsAvatar",
    "GameSettingsR15Collision",
    "GameSettingsScaleRangeBodyType",
    "GameSettingsScaleRangeHead",
    "GameSettingsScaleRangeHeight",
    "GameSettingsScaleRangeProportion",
    "GameSettingsScaleRangeWidth",
    "HealthDisplayDistance",
    "LoadCharacterAppearance",
    "LoadCharacterLayeredClothing",
    "LuaCharacterController",
    "NameDisplayDistance",
    "UserEmotesEnabled",
}

getgenv().FlamesLibrary.set_humanoid_property = function(humanoid, property, value)
    if not humanoid or typeof(humanoid) ~= "Instance" or not humanoid:IsA("Humanoid") then
        return false, "invalid humanoid"
    end

    local matches = resolve_property(getgenv().FlamesLibrary.property_maps.humanoid, property)

    if #matches == 0 then
        return false, "no matching humanoid property for: " .. tostring(property)
    end

    if #matches > 1 then
        return false, "ambiguous property search: " .. tostring(property) .. " matched " .. table.concat(matches, ", ")
    end

    local resolved = matches[1]
    local success, err = pcall(function()
        humanoid[resolved] = value
    end)

    if not success then
        return false, "failed to set " .. resolved .. ": " .. tostring(err)
    end

    return true, resolved
end

getgenv().FlamesLibrary.set_starter_player_property = function(property, value)
    local starter_player = cloneref and cloneref(game:GetService("StarterPlayer")) or game:GetService("StarterPlayer")

    local matches = resolve_property(getgenv().FlamesLibrary.property_maps.starter_player, property)

    if #matches == 0 then
        return false, "no matching starter_player property for: " .. tostring(property)
    end

    if #matches > 1 then
        return false, "ambiguous property search: " .. tostring(property) .. " matched " .. table.concat(matches, ", ")
    end

    local resolved = matches[1]
    local success, err = pcall(function()
        starter_player[resolved] = value
    end)

    if not success then
        return false, "failed to set " .. resolved .. ": " .. tostring(err)
    end

    return true, resolved
end

g.blank = g.blank or function(...) return ... end
g.blankfunction = g.blankfunction or function(...) return ... end
g.set_fps = g.set_fps or function(fps)
    if setfpscap then
        return setfpscap(fps)
    elseif setfps then
        return setfps(fps)
    elseif set_fps_cap then
        return set_fps_cap(fps)
    elseif set_fps then
        return set_fps(fps)
    else
        return nil
    end
end

-- [[ not sure if it works correctly, but this is a BETA function checker I've implemented for now I plan to use later. ]] --
g._function_cache = g._function_cache or {}
g.check_function = function(func) -- might get rid of this.
    if typeof(func) == "function" then return func end
    if typeof(func) ~= "string" then return false end
    local name = func:lower()
    local cached = g._function_cache[name]
    if cached ~= nil then return cached or false end
    local genv = getgenv()
    for k, v in pairs(genv) do
        if typeof(v) == "function" and tostring(k):lower() == name then
            g._function_cache[name] = v
            return v
        end
    end

    local env = getfenv(0)
    for k, v in pairs(env) do
        if typeof(v) == "function" and tostring(k):lower() == name then
            g._function_cache[name] = v
            return v
        end
    end

    g._function_cache[name] = false
    return false
end

getgenv().low_level_executor = getgenv().low_level_executor or function()
    if executor_Name == "Solara" or string.find(executor_Name, "JJSploit") or executor_Name == "Xeno" then
        return true
    else
        return false
    end
end

g.Game = game_ref
g.JobID = game_ref.JobId
g.PlaceID = game_ref.PlaceId
pcall(function() g.set_fps(360) end)
g.AllClipboards = g.AllClipboards or getgenv().FlamesLibrary.safe_func(setclipboard, toclipboard, set_clipboard, Clipboard and Clipboard.set)
g.httprequest_Init = g.httprequest_Init or getgenv().FlamesLibrary.safe_func(syn and syn.request, http and http.request, http_request, fluxus and fluxus.request, request)
g.get_http = g.httprequest_Init
g.queueteleport = g.queueteleport or getgenv().FlamesLibrary.safe_func(syn and syn.queue_on_teleport, queue_on_teleport, fluxus and fluxus.queue_on_teleport)
queueteleport = g.queueteleport
g.get_or_set = g.get_or_set or function(name, value)
    if rawget and rawset then
        local existing = rawget(g, name)
        if existing == nil then
            rawset(g, name, value)
            return value
        end
        return existing
    end

    local existing = g[name]

    if existing == nil then
        g[name] = value
        return value
    end

    return existing
end

local uis = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local ts = g.TweenService or cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
local rs  = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService") or safe_wrapper("RunService")

do
    local active_frame     = nil
    local active_drag_start = nil
    local active_start_pos  = nil
    local last_input_pos    = nil
    local active_tween      = nil
    local GLOBAL_KEY = "dragify_global"
    local TWEEN_INFO = TweenInfo.new(0.05, Enum.EasingStyle.Linear)
    local MIN_DELTA  = 2
    local function cancel_tween()
        if active_tween then
            pcall(function() active_tween:Cancel() end)
            active_tween = nil
        end
    end

    local function stop_drag()
        active_frame      = nil
        active_drag_start = nil
        active_start_pos  = nil
        last_input_pos    = nil
        cancel_tween()
    end

    local function frame_valid(f)
        local ok, res = pcall(function()
        return f and f.Parent and f:IsDescendantOf(game)
        end)
        return ok and res
    end

    getgenv().FlamesLibrary.connect(GLOBAL_KEY .. "_heartbeat", rs.Heartbeat:Connect(function()
        if not active_frame or not last_input_pos then return end
        if not frame_valid(active_frame) then
            stop_drag()
            return
        end

        local delta = last_input_pos - active_drag_start
        if delta.Magnitude < MIN_DELTA then return end
        local sp  = active_start_pos
        local pos = UDim2.new(
            sp.X.Scale,
            sp.X.Offset + delta.X,
            sp.Y.Scale,
            sp.Y.Offset + delta.Y
        )

        cancel_tween()
        active_tween = ts:Create(active_frame, TWEEN_INFO, { Position = pos })
        active_tween:Play()
    end))

    getgenv().FlamesLibrary.connect(GLOBAL_KEY .. "_changed", uis.InputChanged:Connect(function(input)
        if not active_frame then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            last_input_pos = input.Position
        end
    end))

    getgenv().FlamesLibrary.connect(GLOBAL_KEY .. "_ended", uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            stop_drag()
        end
    end))

    getgenv().dragify = function(frame)
        if not frame then return end
        while not frame_valid(frame) do task.wait() end
        local frame_key = "dragify_" .. tostring(frame) .. "_" .. tostring(frame:GetDebugId())
        getgenv().FlamesLibrary.connect(frame_key .. "_began", frame.InputBegan:Connect(function(input)
            if not frame_valid(frame) then return end
            if uis:GetFocusedTextBox() then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if active_frame and active_frame ~= frame then
                    stop_drag()
                end
                active_frame      = frame
                active_drag_start = input.Position
                active_start_pos  = frame.Position
                last_input_pos    = input.Position
            end
        end))

        getgenv().FlamesLibrary.connect(frame_key .. "_ancestry", frame.AncestryChanged:Connect(function(_, parent)
            if not parent then
                if active_frame == frame then
                    stop_drag()
                end
                getgenv().FlamesLibrary.disconnect(frame_key .. "_began")
                getgenv().FlamesLibrary.disconnect(frame_key .. "_ancestry")
            end
        end))
    end
end

local fps = setfpscap or setfps or blank
SetFPSCap = get_or_set("SetFPSCap", fps)
local function hb() game.RunService.Heartbeat:Wait() end
local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Notify_Lib.lua"))()
local valid_titles = {success="Success",info="Info",warning="Warning",error="Error",succes="Success",sucess="Success",eror="Error",erorr="Error",warnin="Warning"}
local function format_title(str)
   if typeof(str)~="string" then return "Info" end
   local key=str:lower()
   return valid_titles[key] or "Info"
end

getgenv().notify = getgenv().notify or function(title,msg,dur)
    if getgenv().Notifications_Disabled_In_Flames_Hub then return end
    local fixed_title = format_title(title)
    NotifyLib:External_Notification(fixed_title, tostring(msg), tonumber(dur))
end
g.Characters = g.Characters or {}

if not getgenv().Initialized_Flames_All_Characters_Global_System then
    getgenv().Initialized_Flames_All_Characters_Global_System = true
    getgenv().wait_character = function(player)
        local char
        repeat
            char = player.Character
            hb()
        until char and char.Parent
        return char
    end

    getgenv().wait_instance = function(parent, resolver, timeout)
        timeout = timeout or 10
        local start_time = os.clock()
        local inst = resolver()
        if inst then return inst end

        local conn
        conn = parent.ChildAdded:Connect(function()
            inst = resolver()
        end)

        while not inst and os.clock() - start_time < timeout do
            hb()
        end

        conn:Disconnect()
        return inst
    end

    getgenv().char_currently_building = getgenv().char_currently_building or {}

    local function build_entry(player, character)
        if getgenv().char_currently_building[player] then return end
        getgenv().char_currently_building[player] = true
        local entry = g.Characters[player] or {}
        entry.character = character
        entry.humanoid = wait_instance(character, function() return character:FindFirstChildWhichIsA("Humanoid") end)
        entry.root = wait_instance(character, function() return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") end)
        entry.head = wait_instance(character, function() return character:FindFirstChild("Head") end)
        g.Characters[player] = entry
        getgenv().char_currently_building[player] = nil
    end

    local function hook_player(player)
        if player.Character and player.Character.Parent then task.spawn(function() build_entry(player, player.Character) end) end
        player.CharacterAdded:Connect(function(char)
            task.spawn(function()
                while not char or not char.Parent do hb() end
                build_entry(player, char)
            end)
        end)
    end

    for _, player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            hook_player(player)
        end
    end

    Players.PlayerAdded:Connect(hook_player)
    Players.PlayerRemoving:Connect(function(player)
        g.Characters[player] = nil
        getgenv().char_currently_building[player] = nil
    end)
end

local function retrieve_executor()
    local f = identifyexecutor
    if type(f) == "function" then return { Name = f() } end
    return { Name = tostring(f or "Unknown Executor") }
end

local function identify_executor_clean() return tostring(retrieve_executor().Name) end
local executor_string = identify_executor_clean()
local function executor_contains(substr) if type(executor_string) ~= "string" then return false end return string.find(executor_string:lower(), substr:lower(), 1, true) ~= nil end
executor_contains = g.get_or_set("executor_contains", executor_contains)
local function wait_for_datamodel(inst)
    if not inst then return false end
    local attempts = 0
    local maximum_attempts = 300

    while attempts < maximum_attempts do
        if inst.Parent and inst:IsDescendantOf(workspace) then
            return true
        end
        task.wait(0.1)
        attempts += 1
    end

    return false
end
wait(0.1)
get_or_set("wait_for_datamodel", wait_for_datamodel)
local function wait_for_child(parent, name)
    if not parent then return nil end

    local existing = parent:FindFirstChild(name)
    if existing then return existing end

    local ok, obj = pcall(function()
        return parent:WaitForChild(name, math.huge)
    end)

    return ok and obj or nil
end
wait(0.1)
get_or_set("wait_for_child", wait_for_child)
local function wait_for_descendant(parent, name)
    if not parent then return nil end
    local found = parent:FindFirstChild(name, true)
    if found then return found end
    local conn
    local result = nil

    conn = parent.DescendantAdded:Connect(function(d)
        if d.Name == name then
            result = d
            conn:Disconnect()
        end
    end)

    while not result do
        local check = parent:FindFirstChild(name, true)
        if check then
            result = check
            conn:Disconnect()
            break
        end
        task.wait()
    end

    return result
end
wait(0.1)
get_or_set("wait_for_descendant", wait_for_descendant)
local function wait_for_child_safe(parent, name)
    if not parent then return nil end
    local ok, obj = pcall(function() return parent:WaitForChild(name, 9e9) end)
    if ok and obj then return obj end
    return nil
end
wait(0.1)
get_or_set("wait_for_child_safe", wait_for_child_safe)
local function retry_find(func, retries, delay)
    for _ = 1, retries do
        local ok, result = pcall(func)
        if ok and result then
            return result
        end
        task.wait(delay)
    end
    return nil
end
wait(0.1)
getgenv().Encode_To_Lua_Escapes = function(Text)
    local Result = {}
    for i = 1, #Text do table.insert(Result, "\\" .. string.byte(Text, i)) end
    return table.concat(Result)
end

getgenv().Decode_Lua_Escapes = function(Escaped_String)
    local Bytes = {}
    for Byte_Str in Escaped_String:gmatch("\\(%d+)") do table.insert(Bytes, tonumber(Byte_Str)) end
    local Chars = {}
    for _, Byte in ipairs(Bytes) do table.insert(Chars, string.char(Byte)) end
    return table.concat(Chars)
end

get_or_set("retry_find", retry_find)
getgenv().return_char = function(Player, timeout)
	if not Player or not Player:IsA("Player") then return nil end
	timeout = tonumber(timeout) or 5
	local start = os.clock()
	while os.clock() - start < timeout do
		local char = Player.Character
		if char and char.Parent and char:IsDescendantOf(game) then local hum = char:FindFirstChildOfClass("Humanoid") if hum and hum.Health > 0 then return char end end
		task.wait()
	end

	return nil
end

g.get_char = function(player, time_out)
	time_out = tonumber(time_out) or 5
	if not player or not player:IsA("Player") then return nil end
	return wait_character(player, time_out)
end

g.get_human = function(player, time_out)
	time_out = tonumber(time_out) or 5
	local char = wait_character(player, time_out)
	if not char then return nil end
	return wait_instance(char, function() return char:FindFirstChildWhichIsA("Humanoid") end, time_out)
end

g.get_root = function(player, time_out)
	time_out = time_out and tonumber(time_out) or 5
	local char = wait_character(player, time_out)
	if not char then return nil end
	return wait_instance(char, function() return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end, time_out)
end

g.get_head = function(player, time_out)
	time_out = time_out and tonumber(time_out) or 5
	local char = wait_character(player, time_out)
	if not char then return nil end
	return wait_instance(char, function() return char:FindFirstChild("Head") end, time_out)
end
wait(0.1)
getgenv().service_cache = getgenv().service_cache or {}
g.Service_Wrap = g.Service_Wrap or function(name)
    local cache = getgenv().service_cache
    if cache[name] then return cache[name] end
    local ok, svc = pcall(function() local s = game:GetService(name) return cloneref and cloneref(s) or s end)
    if not ok or not svc then return nil end
    if rawset then rawset(cache, name, svc) else cache[name] = svc end
    return svc
end

local tries = 0
local max_tries = 100
if not g.Service_Wrap then
    repeat
        task.wait()
        tries += 1
    until (g.Service_Wrap and typeof(g.Service_Wrap) == "function") or tries >= max_tries
end

local function init_services()
    if getgenv().__services_init then return end
    getgenv().__services_init = true
    for _, name in ipairs({
        "Players","Workspace","Lighting","ReplicatedStorage","TweenService","RunService",
        "MaterialService","ReplicatedFirst","Teams","StarterPack","StarterPlayer",
        "VoiceChatInternal","VoiceChatService","CoreGui","SoundService","StarterGui",
        "MarketplaceService","TeleportService","Chat","AssetService","HttpService",
        "UserInputService","TextChatService","ContextActionService","GuiService",
        "PhysicsService","ScriptContext", "AvatarEditorService"
    }) do
        if not getgenv()[name] then
            local ok, svc = pcall(getgenv().Service_Wrap, name)
            if ok and typeof(svc) == "Instance" then
                getgenv()[name] = svc
            end
        end
    end

    local players = getgenv().Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
    if players then while not players.LocalPlayer do task.wait() end getgenv().LocalPlayer = players.LocalPlayer end
    local sp = getgenv().StarterPlayer or cloneref and cloneref(game:GetService("StarterPlayer")) or game:GetService("StarterPlayer")
    if sp then getgenv().StarterPlayerScripts = sp:FindFirstChildOfClass("StarterPlayerScripts") task.wait() getgenv().StarterCharacterScripts = sp:FindFirstChildOfClass("StarterCharacterScripts") end
end
wait(0.1)
init_services()

local cmdp = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local cmdlp = cmdp.LocalPlayer
getgenv().Character = getgenv().LocalPlayer.Character or game.Players.LocalPlayer.Character
getgenv().Humanoid = Character and (Character:FindFirstChild("Humanoid") or Character:FindFirstChildOfClass("Humanoid")) or Character and Character:WaitForChild("Humanoid", 10)
getgenv().HumanoidRootPart = Character and (Character:FindFirstChild("HumanoidRootPart") or Character and Character:WaitForChild("HumanoidRootPart", 10))
getgenv().Head = Character and (Character:FindFirstChild("Head") or Character and Character:WaitForChild("Head", 10))

g.findplr = g.findplr or function(args)
    local tbl = cmdp:GetPlayers()
    if args == "me" or args == cmdlp.Name or args == cmdlp.DisplayName or args == cmdlp then return end
    if args == "random" then
        local validPlayers = {}
        for _, v in pairs(tbl) do
            if v ~= cmdlp then
                table.insert(validPlayers, v)
            end
        end
        return #validPlayers > 0 and validPlayers[math.random(1, #validPlayers)] or nil
    end

    if args == "new" then
        local vAges = {}
        for _, v in pairs(tbl) do
            if v.AccountAge < 30 and v ~= cmdlp then
                table.insert(vAges, v)
            end
        end
        return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
    end

    if args == "old" then
        local vAges = {}
        for _, v in pairs(tbl) do
            if v.AccountAge > 30 and v ~= cmdlp then
                table.insert(vAges, v)
            end
        end
        return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
    end

    if args == "bacon" then
        local vAges = {}
        for _, v in pairs(tbl) do
            if v ~= cmdlp and get_char(v) and (get_char(v):FindFirstChild("Pal Hair") or get_char(v):FindFirstChild("Kate Hair")) then
                table.insert(vAges, v)
            end
        end
        return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
    end

    if args == "friend" then
        local friendList = {}
        for _, v in pairs(tbl) do
            if v:IsFriendsWith(cmdlp.UserId) and v ~= cmdlp then
                table.insert(friendList, v)
            end
        end
        return #friendList > 0 and friendList[math.random(1, #friendList)] or nil
    end

    if args == "notfriend" then
        local vAges = {}
        for _, v in pairs(tbl) do
            if not v:IsFriendsWith(cmdlp.UserId) and v ~= cmdlp then
                table.insert(vAges, v)
            end
        end
        return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
    end

    if args == "ally" then
        local vAges = {}
        for _, v in pairs(tbl) do
            if v.Team == cmdlp.Team and v ~= cmdlp then
                table.insert(vAges, v)
            end
        end
        return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
    end

    if args == "enemy" then
        local vAges = {}
        for _, v in pairs(tbl) do
            if v.Team ~= cmdlp.Team and v ~= cmdlp then
                table.insert(vAges, v)
            end
        end
        return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
    end

    if args == "near" then
        local vAges = {}
        for _, v in pairs(tbl) do
            if v ~= cmdlp then
                local vRootPart = get_root(v)
                local cmdlpRootPart = get_root(cmdlp)
                if vRootPart and cmdlpRootPart then
                    local distance = (vRootPart.Position - cmdlpRootPart.Position).magnitude
                    if distance < 30 then
                        table.insert(vAges, v)
                    end
                end
            end
        end
        return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
    end

    if args == "far" then
        local vAges = {}
        for _, v in pairs(tbl) do
            if v ~= cmdlp then
                local vRootPart = get_root(v)
                local cmdlpRootPart = get_root(cmdlp)
                if vRootPart and cmdlpRootPart then
                    local distance = (vRootPart.Position - cmdlpRootPart.Position).magnitude
                    if distance > 30 then
                        table.insert(vAges, v)
                    end
                end
            end
        end
        return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
    end

    if typeof(args) ~= "string" or args == "" then return nil end
    for _, v in pairs(tbl) do
        if v ~= cmdlp then
            local name, display = v.Name:lower(), v.DisplayName:lower()
            if name:find(args:lower()) or display:find(args:lower()) then
                return v
            end
        end
    end
end

g.randomString = g.randomString or function()
    local length = math.random(10,20)
    local array = {}
    for i = 1, length do array[i] = string.char(math.random(32, 126)) end
    return table.concat(array)
end

g.findplayerchild = g.findplayerchild or function(plr, target)
    if not plr or not target then return nil end
    target = tostring(target):lower()

    local class
    if target == "playergui" then
        class = "PlayerGui"
    elseif target == "playerscripts" then
        class = "PlayerScripts"
    elseif target == "backpack" then
        class = "Backpack"
    end

    local obj
    if class then
        obj = plr:FindFirstChildOfClass(class)
        if not obj then
            obj = plr:FindFirstChildWhichIsA(class)
        end
        if obj then return obj end
    else
        for _, c in ipairs(plr:GetChildren()) do
            if c.Name:lower() == target then
                return c
            end
        end
    end

    local conn
    conn = plr.ChildAdded:Connect(function(c)
        if class then
            if c:IsA(class) then
                obj = c
                conn:Disconnect()
            end
        else
            if c.Name:lower() == target then
                obj = c
                conn:Disconnect()
            end
        end
    end)

    while not obj do
        task.wait()
        if class then
            local a = plr:FindFirstChildOfClass(class)
            if not a then
                a = plr:FindFirstChildWhichIsA(class)
            end
            if a then
                obj = a
                conn:Disconnect()
                break
            end
        else
            for _, c in ipairs(plr:GetChildren()) do
                if c.Name:lower() == target then
                    obj = c
                    conn:Disconnect()
                    break
                end
            end
        end
    end

    return obj
end

g.findinstance = g.findinstance or function(class)
    class = tostring(class):lower()
    if class == "camera" and Workspace.CurrentCamera then return Workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera") end
    if class == "terrain" and Workspace.Terrain then return Workspace.Terrain end
    local canon = class:sub(1,1):upper() .. class:sub(2)
    local child = Workspace:FindFirstChild(canon)
    if child then return child end
    for _, obj in ipairs(Workspace:GetChildren()) do if obj.ClassName:lower() == class then return obj end end
    return nil
end

g.minigame_difficulty = {
    memory = "Medium",
    reaction = "Medium",
    keypad = "Medium",
    hacking = "Medium",
    safe = "Medium",
    wire = "Medium",
    simon = "Medium",
}

g.minigame_difficulty_presets = {
    memory = {
        Easy   = {show_time = 14, max_mistakes = 5, pattern_min = 4, pattern_max = 6},
        Medium = {show_time = 10, max_mistakes = 3, pattern_min = 6, pattern_max = 9},
        Hard   = {show_time = 6,  max_mistakes = 2, pattern_min = 9, pattern_max = 12},
    },
    reaction = {
        Easy   = {max_wins = 4, max_misses = 5, start_speed = 0.4, speed_step = 0.08, perfect_window = 0.03},
        Medium = {max_wins = 5, max_misses = 3, start_speed = 0.6, speed_step = 0.15, perfect_window = 0.02},
        Hard   = {max_wins = 7, max_misses = 2, start_speed = 0.9, speed_step = 0.22, perfect_window = 0.012},
    },
    keypad = {
        Easy   = {code_length = 3, max_attempts = 7},
        Medium = {code_length = 4, max_attempts = 5},
        Hard   = {code_length = 5, max_attempts = 4},
    },
    hacking = {
        Easy   = {sequence_length = 3, time_limit = 28, grid_cols = 6, grid_rows = 5},
        Medium = {sequence_length = 4, time_limit = 20, grid_cols = 8, grid_rows = 6},
        Hard   = {sequence_length = 6, time_limit = 14, grid_cols = 10, grid_rows = 7},
    },
    safe = {
        Easy   = {sequence_count = 2, time_limit = 40, dial_speed = 60, target_window = 2},
        Medium = {sequence_count = 3, time_limit = 30, dial_speed = 90, target_window = 1},
        Hard   = {sequence_count = 4, time_limit = 22, dial_speed = 130, target_window = 0.5},
    },
    wire = {
        Easy   = {wire_count = 4, time_limit = 32, clue_count = 3},
        Medium = {wire_count = 5, time_limit = 25, clue_count = 2},
        Hard   = {wire_count = 6, time_limit = 18, clue_count = 1},
    },
    simon = {
        Easy   = {rounds_to_win = 3, flash_duration = 0.5, gap_duration = 0.25},
        Medium = {rounds_to_win = 5, flash_duration = 0.4, gap_duration = 0.15},
        Hard   = {rounds_to_win = 8, flash_duration = 0.25, gap_duration = 0.08},
    },
}

g.minigame_reward_multiplier = {Easy = 0.7, Medium = 1, Hard = 1.5}
local DIFFICULTY_ORDER = {"Easy", "Medium", "Hard"}
local DIFFICULTY_COLOR = {
    Easy = Color3.fromRGB(60, 180, 100),
    Medium = Color3.fromRGB(220, 160, 30),
    Hard = Color3.fromRGB(200, 70, 70),
}

local function get_preset(game_key)
    local difficulty = g.minigame_difficulty[game_key] or "Medium"
    local presets = g.minigame_difficulty_presets[game_key]
    return presets[difficulty] or presets.Medium, difficulty
end

g.Memory_Mini_Game_GUI = function()
    local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
    local preset = get_preset("memory")
    local GRID_SIZE = 5
    local TILE_COUNT = GRID_SIZE * GRID_SIZE
    local SHOW_TIME = preset.show_time
    local MAX_MISTAKES = preset.max_mistakes
    local GREEN = Color3.fromRGB(0, 255, 0)
    local BLUE = Color3.fromRGB(30, 70, 120)
    local DARK = Color3.fromRGB(20, 20, 20)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local RED = Color3.fromRGB(150, 0, 0)
    if g.memory_mini_game_cooldown and tick() - g.memory_mini_game_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.memory_mini_game_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end
    
    if CoreGui:FindFirstChild("MemoryMinigameGUI") then CoreGui.MemoryMinigameGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "MemoryMinigameGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.Size = UDim2.fromScale(0.85, 0.85)
    frame.BackgroundColor3 = DARK
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

    local aspect = Instance.new("UIAspectRatioConstraint")
    aspect.AspectRatio = 1
    aspect.Parent = frame

    local size_limit = Instance.new("UISizeConstraint")
    size_limit.MaxSize = Vector2.new(520, 520)
    size_limit.Parent = frame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0.08, 0)
    padding.PaddingBottom = UDim.new(0.04, 0)
    padding.PaddingLeft = UDim.new(0.04, 0)
    padding.PaddingRight = UDim.new(0.04, 0)
    padding.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.fromScale(0.18, 0.08)
    cancel.Position = UDim2.fromScale(0.99, 0.02)
    cancel.AnchorPoint = Vector2.new(1, 0)
    cancel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    cancel.Text = "Cancel"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 12)

    local grid_frame = Instance.new("Frame")
    grid_frame.BackgroundTransparency = 1
    grid_frame.Size = UDim2.fromScale(1, 0.88)
    grid_frame.Position = UDim2.fromScale(0, 0.12)
    grid_frame.Parent = frame

    local grid = Instance.new("UIGridLayout")
    grid.CellPadding = UDim2.fromScale(0.03, 0.03)
    grid.CellSize = UDim2.fromScale(1 / GRID_SIZE - 0.03, 1 / GRID_SIZE - 0.03)
    grid.Parent = grid_frame

    local tiles = {}
    local pattern = {}
    local found = {}
    local mistakes = 0
    local input_locked = true
    local function cleanup() getgenv().Keybind_Input_Disabled_For_Mini_Game = false if gui then gui:Destroy() end end
    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Mini-game cancelled.", 3) end
        cleanup()
    end)

    for i = 1, TILE_COUNT do
        local btn = Instance.new("TextButton")
        btn.Text = ""
        btn.BackgroundColor3 = BLUE
        btn.AutoButtonColor = false
        btn.Parent = grid_frame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        tiles[i] = btn
    end

    local function generate_pattern()
        local count = math.random(preset.pattern_min, preset.pattern_max)
        local used = {}
        while #pattern < count do
            local pick = math.random(1, TILE_COUNT)
            if not used[pick] then
                used[pick] = true
                table.insert(pattern, pick)
            end
        end
    end

    local function check_win()
        for _, index in ipairs(pattern) do if not found[index] then return end end
        task.delay(0.02, function()
            g.memory_mini_game_cooldown = tick()
            if g.notify then g.notify("Success", "You completed the memory mini-game.", 5) end
            cleanup()
        end)
    end

    local function show_pattern() for _, index in ipairs(pattern) do tiles[index].BackgroundColor3 = GREEN end end
    local function hide_pattern()
        for i, btn in ipairs(tiles) do
            if not found[i] then
                btn.BackgroundColor3 = BLUE
            end
        end
        input_locked = false
    end

    local function fail()
        if g.notify then g.notify("Error", "You failed the memory mini-game.", 5) end
        cleanup()
    end

    local function on_tile_clicked(index)
        if input_locked then return end
        if found[index] then return end
        if table.find(pattern, index) then
            found[index] = true
            tiles[index].BackgroundColor3 = GREEN
            check_win()
        else
            mistakes = mistakes + 1
            tiles[index].BackgroundColor3 = RED
            if mistakes >= MAX_MISTAKES then
                fail()
            end
        end
    end

    for i, btn in ipairs(tiles) do
        btn.MouseButton1Click:Connect(function()
            on_tile_clicked(i)
        end)
    end

    generate_pattern()
    show_pattern()
    task.delay(SHOW_TIME, hide_pattern)
end

g.reaction_time_minigame = function()
    g.timing_game = g.timing_game or {}
    local tg = g.timing_game
    if tg.renderConn then tg.renderConn:Disconnect() end
    if tg.gui then tg.gui:Destroy() end
    if g.reaction_minigame_cooldown and tick() - g.reaction_minigame_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.reaction_minigame_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local preset = get_preset("reaction")
    local MAX_WINS = preset.max_wins
    local MAX_MISSES = preset.max_misses
    local PURPLE = Color3.fromRGB(170, 85, 255)
    local DARK = Color3.fromRGB(18, 18, 18)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local RED = Color3.fromRGB(200, 60, 60)
    tg.wins = 0
    tg.misses = 0
    tg.speed = preset.start_speed

    local gui = Instance.new("ScreenGui")
    gui.Name = "ReactionTimeMinigame"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui
    tg.gui = gui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromScale(0.9, 0.32)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

    local ui_scale = Instance.new("UIScale")
    ui_scale.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.fromScale(0.9, 0.25)
    bar.Position = UDim2.fromScale(0.05, 0.55)
    bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 14)

    local target = Instance.new("Frame")
    target.Size = UDim2.fromScale(0.12, 1)
    target.BackgroundColor3 = PURPLE
    target.Parent = bar
    Instance.new("UICorner", target).CornerRadius = UDim.new(0, 12)

    local arrow = Instance.new("Frame")
    arrow.Size = UDim2.fromScale(0.05, 1)
    arrow.BackgroundColor3 = WHITE
    arrow.Parent = bar
    Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 10)

    local feedback = Instance.new("TextLabel")
    feedback.Size = UDim2.fromScale(1, 0.25)
    feedback.Position = UDim2.fromScale(0, 0)
    feedback.BackgroundTransparency = 1
    feedback.TextScaled = true
    feedback.Font = Enum.Font.GothamBold
    feedback.TextColor3 = WHITE
    feedback.Text = "CLICK!"
    feedback.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0.0399999991, 0, 0.219999999, 0)
    cancel.Position = UDim2.new(1, 0, 0.00100000005, 0)
    cancel.AnchorPoint = Vector2.new(1, 0)
    cancel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 12)

    local function flash(text, color)
        feedback.Text = text
        feedback.TextColor3 = color
        task.delay(0.35, function()
            if tg.wins < MAX_WINS and tg.misses < MAX_MISSES then
                feedback.Text = "CLICK!"
                feedback.TextColor3 = WHITE
            end
        end)
    end

    local function cleanup()
        if tg.renderConn then tg.renderConn:Disconnect() end
        if tg.gui then tg.gui:Destroy() end
        getgenv().Keybind_Input_Disabled_For_Mini_Game = false
    end

    local function win()
        g.reaction_minigame_cooldown = tick()
        if g.notify then
            g.notify("Success", "You've won the mini-game.", 5)
        end
        task.delay(0.1, cleanup)
    end

    local function fail(msg)
        if g.notify then
            g.notify("Error", msg or "You failed the mini-game.", 5)
        end
        task.delay(0.1, cleanup)
    end

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Mini-game cancelled.", 3) end
        cleanup()
    end)

    local function new_target()
        target.Position = UDim2.fromScale(math.random(10, 78) / 100, 0)
    end

    new_target()

    local dir = 1
    local pos = 0
    tg.renderConn = RunService.RenderStepped:Connect(function(dt)
        pos = pos + dt * tg.speed * dir
        if pos >= 0.95 then dir = -1 end
        if pos <= 0 then dir = 1 end
        arrow.Position = UDim2.fromScale(pos, 0)
    end)

    local click = Instance.new("TextButton")
    click.Size = UDim2.fromScale(1, 1)
    click.Position = UDim2.fromScale(0, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.Parent = frame

    click.MouseButton1Click:Connect(function()
        local a_min = arrow.Position.X.Scale
        local a_max = a_min + arrow.Size.X.Scale
        local t_min = target.Position.X.Scale
        local t_max = t_min + target.Size.X.Scale
        local overlap = math.min(a_max, t_max) - math.max(a_min, t_min)

        if overlap > 0 then
            local center_dist = math.abs((a_min + a_max) / 2 - (t_min + t_max) / 2)
            if center_dist < preset.perfect_window then
                flash("PERFECT", Color3.fromRGB(180, 255, 255))
            else
                flash("GOOD", PURPLE)
            end
            tg.wins = tg.wins + 1
            tg.speed = tg.speed + preset.speed_step
            new_target()
            if tg.wins >= MAX_WINS then
                win()
            end
        else
            tg.misses = tg.misses + 1
            flash("BAD", RED)
            if tg.misses >= MAX_MISSES then
                fail()
            end
        end
    end)
end

g.keypad_minigame = function()
    if g.keypad_minigame_cooldown and tick() - g.keypad_minigame_cooldown < 25 then
        local remaining = math.ceil(25 - (tick() - g.keypad_minigame_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local preset = get_preset("keypad")
    local DARK = Color3.fromRGB(18, 18, 18)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local GREEN = Color3.fromRGB(0, 220, 100)
    local RED = Color3.fromRGB(200, 60, 60)
    local YELLOW = Color3.fromRGB(255, 200, 0)
    local GREY = Color3.fromRGB(40, 40, 40)
    local CODE_LENGTH = preset.code_length
    local MAX_ATTEMPTS = preset.max_attempts
    local secret_code = {}
    local current_input = {}
    local attempts = 0
    local game_over = false
    for i = 1, CODE_LENGTH do table.insert(secret_code, math.random(0, 9)) end
    if CoreGui:FindFirstChild("KeypadMinigame") then CoreGui.KeypadMinigame:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeypadMinigame"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 420)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(60, 60, 60)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "KEYPAD HACK"
    title.TextColor3 = YELLOW
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = frame

    local attempts_label = Instance.new("TextLabel")
    attempts_label.Size = UDim2.new(1, 0, 0, 24)
    attempts_label.Position = UDim2.new(0, 0, 0, 48)
    attempts_label.BackgroundTransparency = 1
    attempts_label.Text = "Attempts: " .. MAX_ATTEMPTS
    attempts_label.TextColor3 = WHITE
    attempts_label.Font = Enum.Font.Gotham
    attempts_label.TextSize = 13
    attempts_label.Parent = frame

    local display = Instance.new("Frame")
    display.Size = UDim2.new(0.8, 0, 0, 50)
    display.Position = UDim2.new(0.1, 0, 0, 78)
    display.BackgroundColor3 = GREY
    display.Parent = frame
    Instance.new("UICorner", display).CornerRadius = UDim.new(0, 10)

    local display_label = Instance.new("TextLabel")
    display_label.Size = UDim2.new(1, 0, 1, 0)
    display_label.BackgroundTransparency = 1
    display_label.Text = string.rep("_ ", CODE_LENGTH):sub(1, -2)
    display_label.TextColor3 = GREEN
    display_label.Font = Enum.Font.Code
    display_label.TextSize = 24
    display_label.Parent = display

    local feedback_label = Instance.new("TextLabel")
    feedback_label.Size = UDim2.new(1, 0, 0, 24)
    feedback_label.Position = UDim2.new(0, 0, 0, 134)
    feedback_label.BackgroundTransparency = 1
    feedback_label.Text = ""
    feedback_label.TextColor3 = WHITE
    feedback_label.Font = Enum.Font.Gotham
    feedback_label.TextSize = 12
    feedback_label.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 6)
    cancel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)
    local function cleanup() getgenv().Keybind_Input_Disabled_For_Mini_Game = false if gui then gui:Destroy() end end
    local function update_display()
        local parts = {}
        for i = 1, CODE_LENGTH do
            if current_input[i] then
                table.insert(parts, tostring(current_input[i]))
            else
                table.insert(parts, "_")
            end
        end
        display_label.Text = table.concat(parts, " ")
    end

    local function get_feedback(guess)
        local correct_pos = 0
        local correct_num = 0
        local secret_used = {}
        local guess_used = {}

        for i = 1, CODE_LENGTH do
            if guess[i] == secret_code[i] then
                correct_pos = correct_pos + 1
                secret_used[i] = true
                guess_used[i] = true
            end
        end

        for i = 1, CODE_LENGTH do
            if not guess_used[i] then
                for j = 1, CODE_LENGTH do
                    if not secret_used[j] and guess[i] == secret_code[j] then
                        correct_num = correct_num + 1
                        secret_used[j] = true
                        break
                    end
                end
            end
        end
        return correct_pos, correct_num
    end

    local function win()
        g.keypad_minigame_cooldown = tick()
        if g.notify then g.notify("Success", "Keypad cracked!.", 30) end
        task.delay(0.5, cleanup)
    end

    local function fail()
        if g.notify then g.notify("Error", "Keypad locked out!.", 5) end
        task.delay(0.5, cleanup)
    end

    local function submit()
        if #current_input < CODE_LENGTH then return end
        if game_over then return end
        local correct_pos, correct_num = get_feedback(current_input)
        if correct_pos == CODE_LENGTH then
            game_over = true
            display_label.TextColor3 = GREEN
            feedback_label.Text = "ACCESS GRANTED"
            feedback_label.TextColor3 = GREEN
            win()
            return
        end

        attempts = attempts + 1
        attempts_label.Text = "Attempts: " .. (MAX_ATTEMPTS - attempts)
        feedback_label.Text = correct_pos .. " correct position  |  " .. correct_num .. " correct number"
        feedback_label.TextColor3 = YELLOW
        current_input = {}
        update_display()

        if attempts >= MAX_ATTEMPTS then
            game_over = true
            display_label.TextColor3 = RED
            feedback_label.Text = "ACCESS DENIED"
            feedback_label.TextColor3 = RED
            fail()
        end
    end

    local button_grid = Instance.new("Frame")
    button_grid.Size = UDim2.new(0.85, 0, 0, 220)
    button_grid.Position = UDim2.new(0.075, 0, 0, 165)
    button_grid.BackgroundTransparency = 1
    button_grid.Parent = frame

    local grid_layout = Instance.new("UIGridLayout")
    grid_layout.CellSize = UDim2.new(0.3, 0, 0, 52)
    grid_layout.CellPadding = UDim2.new(0.033, 0, 0, 6)
    grid_layout.SortOrder = Enum.SortOrder.LayoutOrder
    grid_layout.Parent = button_grid

    local button_order = {7, 8, 9, 4, 5, 6, 1, 2, 3}
    for _, num in ipairs(button_order) do
        local btn = Instance.new("TextButton")
        btn.Text = tostring(num)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 20
        btn.TextColor3 = WHITE
        btn.BackgroundColor3 = GREY
        btn.LayoutOrder = num
        btn.Parent = button_grid
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        btn.MouseButton1Click:Connect(function()
            if game_over then return end
            if #current_input >= CODE_LENGTH then return end
            table.insert(current_input, num)
            update_display()
            if #current_input == CODE_LENGTH then
                task.delay(0.1, submit)
            end
        end)
    end

    local zero_btn = Instance.new("TextButton")
    zero_btn.Text = "0"
    zero_btn.Font = Enum.Font.GothamBold
    zero_btn.TextSize = 20
    zero_btn.TextColor3 = WHITE
    zero_btn.BackgroundColor3 = GREY
    zero_btn.LayoutOrder = 10
    zero_btn.Parent = button_grid
    Instance.new("UICorner", zero_btn).CornerRadius = UDim.new(0, 10)

    zero_btn.MouseButton1Click:Connect(function()
        if game_over then return end
        if #current_input >= CODE_LENGTH then return end
        table.insert(current_input, 0)
        update_display()
        if #current_input == CODE_LENGTH then
            task.delay(0.1, submit)
        end
    end)

    local clear_btn = Instance.new("TextButton")
    clear_btn.Text = "CLR"
    clear_btn.Font = Enum.Font.GothamBold
    clear_btn.TextSize = 14
    clear_btn.TextColor3 = WHITE
    clear_btn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
    clear_btn.LayoutOrder = 11
    clear_btn.Parent = button_grid
    Instance.new("UICorner", clear_btn).CornerRadius = UDim.new(0, 10)

    clear_btn.MouseButton1Click:Connect(function()
        if game_over then return end
        current_input = {}
        update_display()
        feedback_label.Text = ""
    end)

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Keypad cancelled.", 3) end
        cleanup()
    end)

    update_display()
end

g.hacking_minigame = function()
    if g.hacking_minigame_cooldown and tick() - g.hacking_minigame_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.hacking_minigame_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local preset = get_preset("hacking")
    local DARK = Color3.fromRGB(10, 10, 10)
    local GREEN = Color3.fromRGB(0, 255, 100)
    local DIM_GREEN = Color3.fromRGB(0, 100, 40)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local RED = Color3.fromRGB(200, 60, 60)
    local YELLOW = Color3.fromRGB(255, 200, 0)
    local GRID_COLS = preset.grid_cols
    local GRID_ROWS = preset.grid_rows
    local SEQUENCE_LENGTH = preset.sequence_length
    local TIME_LIMIT = preset.time_limit
    local chars = {"A","B","C","D","E","F","1","2","3","4","5","6","7","8","9","0"}
    local grid_data = {}
    local target_sequence = {}
    local current_sequence = {}
    local selected_col = nil
    local select_row = true
    local game_over = false
    local time_left = TIME_LIMIT
    local render_conn = nil
    local timer_conn = nil
    for row = 1, GRID_ROWS do
        grid_data[row] = {}
        for col = 1, GRID_COLS do grid_data[row][col] = chars[math.random(1, #chars)] end
    end

    local start_col = math.random(1, GRID_COLS)
    local cur_col = start_col
    local picking_col = true
    local cur_row = nil

    for i = 1, SEQUENCE_LENGTH do
        if picking_col then
            cur_row = math.random(1, GRID_ROWS)
            table.insert(target_sequence, grid_data[cur_row][cur_col])
            picking_col = false
        else
            cur_col = math.random(1, GRID_COLS)
            table.insert(target_sequence, grid_data[cur_row][cur_col])
            picking_col = true
        end
    end

    if CoreGui:FindFirstChild("HackingMinigame") then CoreGui.HackingMinigame:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "HackingMinigame"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, math.max(420, GRID_COLS * 62 + 20), 0, GRID_ROWS * 44 + 130)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = GREEN
    stroke.Thickness = 1.5

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, 0, 0, 36)
    title.Position = UDim2.new(0, 10, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "// BREACH PROTOCOL //"
    title.TextColor3 = GREEN
    title.Font = Enum.Font.Code
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local timer_label = Instance.new("TextLabel")
    timer_label.Size = UDim2.new(0.3, 0, 0, 36)
    timer_label.Position = UDim2.new(0.65, -40, 0, 6)
    timer_label.BackgroundTransparency = 1
    timer_label.Text = "00:" .. string.format("%02d", TIME_LIMIT)
    timer_label.TextColor3 = YELLOW
    timer_label.Font = Enum.Font.Code
    timer_label.TextSize = 16
    timer_label.TextXAlignment = Enum.TextXAlignment.Right
    timer_label.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 6)
    cancel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)

    local seq_label = Instance.new("TextLabel")
    seq_label.Size = UDim2.new(1, -20, 0, 22)
    seq_label.Position = UDim2.new(0, 10, 0, 44)
    seq_label.BackgroundTransparency = 1
    seq_label.Text = "TARGET: " .. table.concat(target_sequence, "  ")
    seq_label.TextColor3 = YELLOW
    seq_label.Font = Enum.Font.Code
    seq_label.TextSize = 14
    seq_label.TextXAlignment = Enum.TextXAlignment.Left
    seq_label.Parent = frame

    local progress_label = Instance.new("TextLabel")
    progress_label.Size = UDim2.new(1, -20, 0, 22)
    progress_label.Position = UDim2.new(0, 10, 0, 64)
    progress_label.BackgroundTransparency = 1
    progress_label.Text = "INPUT:  "
    progress_label.TextColor3 = GREEN
    progress_label.Font = Enum.Font.Code
    progress_label.TextSize = 14
    progress_label.TextXAlignment = Enum.TextXAlignment.Left
    progress_label.Parent = frame

    local hint_label = Instance.new("TextLabel")
    hint_label.Size = UDim2.new(1, -20, 0, 18)
    hint_label.Position = UDim2.new(0, 10, 0, 86)
    hint_label.BackgroundTransparency = 1
    hint_label.Text = "Select from highlighted column"
    hint_label.TextColor3 = DIM_GREEN
    hint_label.Font = Enum.Font.Code
    hint_label.TextSize = 11
    hint_label.TextXAlignment = Enum.TextXAlignment.Left
    hint_label.Parent = frame

    local grid_frame = Instance.new("Frame")
    grid_frame.Size = UDim2.new(1, -20, 0, GRID_ROWS * 46)
    grid_frame.Position = UDim2.new(0, 10, 0, 112)
    grid_frame.BackgroundTransparency = 1
    grid_frame.Parent = frame

    local cell_buttons = {}
    local function cleanup()
        if render_conn then render_conn:Disconnect() end
        if timer_conn then timer_conn:Disconnect() end
        if gui then gui:Destroy() end
        getgenv().Keybind_Input_Disabled_For_Mini_Game = false
    end

    local function update_progress()
        local parts = {}
        for _, v in ipairs(current_sequence) do table.insert(parts, v) end
        progress_label.Text = "INPUT:  " .. table.concat(parts, "  ")
    end

    local function win()
        game_over = true
        g.hacking_minigame_cooldown = tick()
        if g.notify then g.notify("Success", "Breach successful!.", 5) end
        task.delay(0.5, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then g.notify("Error", msg or "Breach failed!", 5) end
        task.delay(0.5, cleanup)
    end

    local function check_sequence()
        if #current_sequence < SEQUENCE_LENGTH then return end
        for i = 1, SEQUENCE_LENGTH do
            if current_sequence[i] ~= target_sequence[i] then
                fail("Wrong sequence!")
                return
            end
        end
        win()
    end

    local function highlight_cells()
        for row = 1, GRID_ROWS do
            for col = 1, GRID_COLS do
                local btn = cell_buttons[row] and cell_buttons[row][col]
                if not btn then continue end
                if select_row then
                    if selected_col and col == selected_col then
                        btn.BackgroundColor3 = Color3.fromRGB(0, 60, 30)
                        btn.TextColor3 = GREEN
                    else
                        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                        btn.TextColor3 = DIM_GREEN
                    end
                else
                    if selected_col and row == selected_col then
                        btn.BackgroundColor3 = Color3.fromRGB(0, 60, 30)
                        btn.TextColor3 = GREEN
                    else
                        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                        btn.TextColor3 = DIM_GREEN
                    end
                end
            end
        end
        if select_row then
            hint_label.Text = "Select from highlighted COLUMN " .. (selected_col or "?")
        else
            hint_label.Text = "Select from highlighted ROW " .. (selected_col or "?")
        end
    end

    for row = 1, GRID_ROWS do
        cell_buttons[row] = {}
        for col = 1, GRID_COLS do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 56, 0, 38)
            btn.Position = UDim2.new(0, (col - 1) * 62, 0, (row - 1) * 44)
            btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            btn.TextColor3 = DIM_GREEN
            btn.Font = Enum.Font.Code
            btn.TextSize = 16
            btn.Text = grid_data[row][col]
            btn.Parent = grid_frame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            cell_buttons[row][col] = btn
            btn.MouseButton1Click:Connect(function()
                if game_over then return end
                local valid = false
                if select_row and selected_col and col == selected_col then
                    valid = true
                elseif not select_row and selected_col and row == selected_col then
                    valid = true
                elseif selected_col == nil then
                    valid = true
                end

                if not valid then return end
                table.insert(current_sequence, grid_data[row][col])
                update_progress()
                if select_row then
                    selected_col = row
                    select_row = false
                else
                    selected_col = col
                    select_row = true
                end

                highlight_cells()
                check_sequence()
            end)
        end
    end

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Hack cancelled.", 3) end
        cleanup()
    end)

    selected_col = start_col
    highlight_cells()
    update_progress()
    local elapsed = 0
    timer_conn = RunService.Heartbeat:Connect(function(dt)
        if game_over then return end
        elapsed = elapsed + dt
        time_left = TIME_LIMIT - elapsed
        if time_left <= 0 then
            timer_label.Text = "00:00"
            fail("Time's up! -5 coins.")
            return
        end
        local mins = math.floor(time_left / 60)
        local secs = math.floor(time_left % 60)
        timer_label.Text = string.format("%02d:%02d", mins, secs)
        if time_left <= 5 then timer_label.TextColor3 = RED end
    end)
end

g.safe_cracker_minigame = function()
    if g.safe_cracker_cooldown and tick() - g.safe_cracker_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.safe_cracker_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local preset = get_preset("safe")
    local DARK = Color3.fromRGB(12, 10, 8)
    local GOLD = Color3.fromRGB(200, 160, 40)
    local DIM_GOLD = Color3.fromRGB(80, 60, 10)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local RED = Color3.fromRGB(200, 60, 60)
    local GREEN = Color3.fromRGB(60, 200, 100)
    local SEQUENCE_COUNT = preset.sequence_count
    local NOTCH_COUNT = 20
    local TIME_LIMIT = preset.time_limit
    local TARGET_WINDOW = preset.target_window
    local targets = {}
    for i = 1, SEQUENCE_COUNT do table.insert(targets, math.random(1, NOTCH_COUNT)) end
    local current_step = 1
    local dial_angle = 0
    local dial_speed = preset.dial_speed
    local spin_dir = 1
    local game_over = false
    local elapsed = 0
    local timer_conn = nil
    local render_conn = nil
    if CoreGui:FindFirstChild("SafeCrackerGUI") then CoreGui.SafeCrackerGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "SafeCrackerGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 380, 0, 440)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local fstroke = Instance.new("UIStroke", frame)
    fstroke.Color = GOLD
    fstroke.Thickness = 1.5

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.75, 0, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "// SAFE CRACKER //"
    title.TextColor3 = GOLD
    title.Font = Enum.Font.Code
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local timer_label = Instance.new("TextLabel")
    timer_label.Size = UDim2.new(0.25, -40, 0, 36)
    timer_label.Position = UDim2.new(0.65, -10, 0, 6)
    timer_label.BackgroundTransparency = 1
    timer_label.Text = "00:" .. string.format("%02d", TIME_LIMIT)
    timer_label.TextColor3 = GOLD
    timer_label.Font = Enum.Font.Code
    timer_label.TextSize = 15
    timer_label.TextXAlignment = Enum.TextXAlignment.Right
    timer_label.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 8)
    cancel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.BorderSizePixel = 0
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)

    local step_label = Instance.new("TextLabel")
    step_label.Size = UDim2.new(1, -20, 0, 22)
    step_label.Position = UDim2.new(0, 10, 0, 42)
    step_label.BackgroundTransparency = 1
    step_label.Text = "Step 1 of " .. SEQUENCE_COUNT .. "  —  Target: " .. targets[1]
    step_label.TextColor3 = GOLD
    step_label.Font = Enum.Font.Code
    step_label.TextSize = 13
    step_label.TextXAlignment = Enum.TextXAlignment.Left
    step_label.Parent = frame

    local hint_label = Instance.new("TextLabel")
    hint_label.Size = UDim2.new(1, -20, 0, 18)
    hint_label.Position = UDim2.new(0, 10, 0, 64)
    hint_label.BackgroundTransparency = 1
    hint_label.Text = "Click when the marker lands on the target notch"
    hint_label.TextColor3 = DIM_GOLD
    hint_label.Font = Enum.Font.Code
    hint_label.TextSize = 11
    hint_label.TextXAlignment = Enum.TextXAlignment.Left
    hint_label.Parent = frame

    local dial_holder = Instance.new("Frame")
    dial_holder.Size = UDim2.new(0, 240, 0, 240)
    dial_holder.AnchorPoint = Vector2.new(0.5, 0)
    dial_holder.Position = UDim2.new(0.5, 0, 0, 96)
    dial_holder.BackgroundTransparency = 1
    dial_holder.Parent = frame

    local dial_bg = Instance.new("Frame")
    dial_bg.Size = UDim2.fromScale(1, 1)
    dial_bg.BackgroundColor3 = Color3.fromRGB(28, 24, 16)
    dial_bg.BorderSizePixel = 0
    dial_bg.Parent = dial_holder
    Instance.new("UICorner", dial_bg).CornerRadius = UDim.new(0.5, 0)
    local dstroke = Instance.new("UIStroke", dial_bg)
    dstroke.Color = GOLD
    dstroke.Thickness = 2

    local notch_labels = {}
    for i = 1, NOTCH_COUNT do
        local angle = (i - 1) * (360 / NOTCH_COUNT)
        local rad = math.rad(angle - 90)
        local nx = 0.5 + math.cos(rad) * 0.42
        local ny = 0.5 + math.sin(rad) * 0.42
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 22, 0, 18)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Position = UDim2.new(nx, 0, ny, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = tostring(i)
        lbl.Font = Enum.Font.Code
        lbl.TextSize = 10
        lbl.TextColor3 = DIM_GOLD
        lbl.Parent = dial_holder
        notch_labels[i] = lbl
    end

    local marker = Instance.new("Frame")
    marker.Size = UDim2.new(0, 6, 0, 30)
    marker.AnchorPoint = Vector2.new(0.5, 1)
    marker.Position = UDim2.new(0.5, 0, 0.08, 0)
    marker.BackgroundColor3 = WHITE
    marker.BorderSizePixel = 0
    marker.Parent = dial_holder
    Instance.new("UICorner", marker).CornerRadius = UDim.new(0, 3)

    local click_btn = Instance.new("TextButton")
    click_btn.Size = UDim2.new(0, 120, 0, 42)
    click_btn.AnchorPoint = Vector2.new(0.5, 0)
    click_btn.Position = UDim2.new(0.5, 0, 0, 354)
    click_btn.BackgroundColor3 = Color3.fromRGB(38, 30, 10)
    click_btn.Text = "CRACK"
    click_btn.Font = Enum.Font.GothamBold
    click_btn.TextSize = 15
    click_btn.TextColor3 = GOLD
    click_btn.BorderSizePixel = 0
    click_btn.Parent = frame
    Instance.new("UICorner", click_btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", click_btn).Color = GOLD

    local feedback = Instance.new("TextLabel")
    feedback.Size = UDim2.new(1, -20, 0, 22)
    feedback.Position = UDim2.new(0, 10, 0, 406)
    feedback.BackgroundTransparency = 1
    feedback.Text = ""
    feedback.TextColor3 = GREEN
    feedback.Font = Enum.Font.Code
    feedback.TextSize = 13
    feedback.TextXAlignment = Enum.TextXAlignment.Center
    feedback.Parent = frame

    local function cleanup()
        if render_conn then render_conn:Disconnect() end
        if timer_conn then timer_conn:Disconnect() end
        if gui then gui:Destroy() end
        getgenv().Keybind_Input_Disabled_For_Mini_Game = false
    end

    local function get_current_notch()
        local normalized = dial_angle % 360
        local notch = math.round(normalized / (360 / NOTCH_COUNT)) % NOTCH_COUNT
        if notch == 0 then notch = NOTCH_COUNT end
        return notch
    end

    local function update_notch_colors()
        local cur = get_current_notch()
        local tgt = targets[current_step]
        for i, lbl in ipairs(notch_labels) do
            if i == tgt then
                lbl.TextColor3 = GOLD
            elseif i == cur then
                lbl.TextColor3 = WHITE
            else
                lbl.TextColor3 = DIM_GOLD
            end
        end
    end

    local function win()
        game_over = true
        g.safe_cracker_cooldown = tick()
        if g.notify then g.notify("Success", "Safe cracked!", 5) end
        task.delay(0.5, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then g.notify("Error", msg or "Safe locked!", 5) end
        task.delay(0.5, cleanup)
    end

    click_btn.MouseButton1Click:Connect(function()
        if game_over then return end
        local cur = get_current_notch()
        local tgt = targets[current_step]
        local diff = math.abs(cur - tgt)
        local within = diff <= TARGET_WINDOW or diff >= NOTCH_COUNT - TARGET_WINDOW
        if within then
            feedback.Text = "Notch: " .. tgt .. " hit!"
            feedback.TextColor3 = GREEN
            current_step = current_step + 1
            spin_dir = spin_dir * -1
            dial_speed = dial_speed + 20

            if current_step > SEQUENCE_COUNT then
                win()
            else
                step_label.Text = "Step " .. current_step .. " of " .. SEQUENCE_COUNT .. "  —  Target: " .. targets[current_step]
            end
        else
            feedback.Text = "✗ Missed! Got notch: " .. cur
            feedback.TextColor3 = RED
            fail("Wrong notch! -5 coins.")
        end
    end)

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Safe cracker cancelled.", 3) end
        cleanup()
    end)

    render_conn = RunService.RenderStepped:Connect(function(dt)
        if game_over then return end
        dial_angle = dial_angle + dial_speed * dt * spin_dir
        update_notch_colors()
    end)

    local time_elapsed = 0
    timer_conn = RunService.Heartbeat:Connect(function(dt)
        if game_over then return end
        time_elapsed = time_elapsed + dt
        local left = TIME_LIMIT - time_elapsed
        if left <= 0 then
            timer_label.Text = "00:00"
            fail("Time's up! -5 coins.")
            return
        end
        local mins = math.floor(left / 60)
        local secs = math.floor(left % 60)
        timer_label.Text = string.format("%02d:%02d", mins, secs)
        if left <= 5 then timer_label.TextColor3 = RED end
    end)
end

g.wire_cutter_minigame = function()
    if g.wire_cutter_cooldown and tick() - g.wire_cutter_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.wire_cutter_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local preset = get_preset("wire")
    local DARK = Color3.fromRGB(12, 12, 14)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local MUTED = Color3.fromRGB(120, 120, 130)
    local RED = Color3.fromRGB(220, 60, 60)
    local GREEN = Color3.fromRGB(60, 200, 100)
    local YELLOW = Color3.fromRGB(230, 200, 50)
    local BLUE = Color3.fromRGB(80, 140, 240)
    local ORANGE = Color3.fromRGB(230, 130, 40)
    local WHITE_W = Color3.fromRGB(200, 200, 200)
    local TIME_LIMIT = preset.time_limit
    local WIRE_COLORS = {
        {name = "Red",    color = RED},
        {name = "Green",  color = GREEN},
        {name = "Yellow", color = YELLOW},
        {name = "Blue",   color = BLUE},
        {name = "Orange", color = ORANGE},
        {name = "White",  color = WHITE_W},
    }
    local WIRE_COUNT = preset.wire_count
    local wires = {}
    local used = {}
    while #wires < WIRE_COUNT do
        local pick = math.random(1, #WIRE_COLORS)
        if not used[pick] then
            used[pick] = true
            table.insert(wires, {name = WIRE_COLORS[pick].name, color = WIRE_COLORS[pick].color, cut = false})
        end
    end

    local clues = {}
    local safe_wire = math.random(1, WIRE_COUNT)
    local positions = {"first", "second", "third", "fourth", "fifth", "sixth"}
    local clue_types = {}
    for i = 1, WIRE_COUNT do
        if i ~= safe_wire then
            local t = math.random(1, 3)
            if t == 1 then
                table.insert(clue_types, {wire = i, type = "color", text = "Do NOT cut the " .. wires[i].name .. " wire"})
            elseif t == 2 then
                table.insert(clue_types, {wire = i, type = "position", text = "The " .. positions[i] .. " wire is dangerous"})
            else
                table.insert(clue_types, {wire = i, type = "both", text = "Avoid the " .. positions[i] .. " (" .. wires[i].name .. ") wire"})
            end
        end
    end

    local shown_clues = {}
    local indices = {}
    for i = 1, #clue_types do indices[i] = i end
    for i = #indices, 2, -1 do
        local j = math.random(1, i)
        indices[i], indices[j] = indices[j], indices[i]
    end
    for i = 1, math.min(preset.clue_count, #clue_types) do table.insert(shown_clues, clue_types[indices[i]]) end
    local game_over = false
    local timer_conn = nil
    if CoreGui:FindFirstChild("WireCutterGUI") then CoreGui.WireCutterGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "WireCutterGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local wire_start_offset = 44 + (#shown_clues + 2) * 20
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, wire_start_offset + WIRE_COUNT * 56 + 20)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local fstroke = Instance.new("UIStroke", frame)
    fstroke.Color = Color3.fromRGB(60, 60, 70)
    fstroke.Thickness = 1

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.75, 0, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "// WIRE CUTTER //"
    title.TextColor3 = GREEN
    title.Font = Enum.Font.Code
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local timer_label = Instance.new("TextLabel")
    timer_label.Size = UDim2.new(0.2, 0, 0, 36)
    timer_label.Position = UDim2.new(0.72, 0, 0, 6)
    timer_label.BackgroundTransparency = 1
    timer_label.Text = "00:" .. string.format("%02d", TIME_LIMIT)
    timer_label.TextColor3 = YELLOW
    timer_label.Font = Enum.Font.Code
    timer_label.TextSize = 15
    timer_label.TextXAlignment = Enum.TextXAlignment.Right
    timer_label.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 8)
    cancel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.BorderSizePixel = 0
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)

    local clue_header = Instance.new("TextLabel")
    clue_header.Size = UDim2.new(1, -20, 0, 20)
    clue_header.Position = UDim2.new(0, 10, 0, 44)
    clue_header.BackgroundTransparency = 1
    clue_header.Text = "Intel:"
    clue_header.TextColor3 = MUTED
    clue_header.Font = Enum.Font.Code
    clue_header.TextSize = 12
    clue_header.TextXAlignment = Enum.TextXAlignment.Left
    clue_header.Parent = frame

    for i, clue in ipairs(shown_clues) do
        local clue_lbl = Instance.new("TextLabel")
        clue_lbl.Size = UDim2.new(1, -20, 0, 18)
        clue_lbl.Position = UDim2.new(0, 10, 0, 44 + i * 20)
        clue_lbl.BackgroundTransparency = 1
        clue_lbl.Text = "• " .. clue.text
        clue_lbl.TextColor3 = WHITE
        clue_lbl.Font = Enum.Font.Code
        clue_lbl.TextSize = 11
        clue_lbl.TextXAlignment = Enum.TextXAlignment.Left
        clue_lbl.Parent = frame
    end

    local wire_start_y = wire_start_offset
    local function cleanup()
        if timer_conn then timer_conn:Disconnect() end
        if gui then gui:Destroy() end
        getgenv().Keybind_Input_Disabled_For_Mini_Game = false
    end

    local function win()
        game_over = true
        g.wire_cutter_cooldown = tick()
        if g.notify then g.notify("Success", "Wire cut! Defused!", 5) end
        task.delay(0.5, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then g.notify("Error", msg or "Wrong wire!", 5) end
        task.delay(0.5, cleanup)
    end

    for i, wire in ipairs(wires) do
        local wire_row = Instance.new("Frame")
        wire_row.Size = UDim2.new(1, -20, 0, 48)
        wire_row.Position = UDim2.new(0, 10, 0, wire_start_y + (i - 1) * 56)
        wire_row.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        wire_row.BorderSizePixel = 0
        wire_row.Parent = frame
        Instance.new("UICorner", wire_row).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", wire_row).Color = Color3.fromRGB(40, 40, 50)

        local pos_lbl = Instance.new("TextLabel")
        pos_lbl.Size = UDim2.new(0, 20, 1, 0)
        pos_lbl.Position = UDim2.new(0, 8, 0, 0)
        pos_lbl.BackgroundTransparency = 1
        pos_lbl.Text = tostring(i)
        pos_lbl.Font = Enum.Font.Code
        pos_lbl.TextSize = 12
        pos_lbl.TextColor3 = MUTED
        pos_lbl.Parent = wire_row

        local wire_line = Instance.new("Frame")
        wire_line.Size = UDim2.new(0, 180, 0, 8)
        wire_line.AnchorPoint = Vector2.new(0, 0.5)
        wire_line.Position = UDim2.new(0, 30, 0.5, 0)
        wire_line.BackgroundColor3 = wire.color
        wire_line.BorderSizePixel = 0
        wire_line.Parent = wire_row
        Instance.new("UICorner", wire_line).CornerRadius = UDim.new(0.5, 0)

        local name_lbl = Instance.new("TextLabel")
        name_lbl.Size = UDim2.new(0, 60, 1, 0)
        name_lbl.Position = UDim2.new(0, 216, 0, 0)
        name_lbl.BackgroundTransparency = 1
        name_lbl.Text = wire.name
        name_lbl.Font = Enum.Font.Code
        name_lbl.TextSize = 12
        name_lbl.TextColor3 = wire.color
        name_lbl.Parent = wire_row

        local cut_btn = Instance.new("TextButton")
        cut_btn.Size = UDim2.new(0, 52, 0, 30)
        cut_btn.AnchorPoint = Vector2.new(1, 0.5)
        cut_btn.Position = UDim2.new(1, -8, 0.5, 0)
        cut_btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        cut_btn.Text = "CUT"
        cut_btn.Font = Enum.Font.GothamBold
        cut_btn.TextSize = 12
        cut_btn.TextColor3 = WHITE
        cut_btn.BorderSizePixel = 0
        cut_btn.Parent = wire_row
        Instance.new("UICorner", cut_btn).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", cut_btn).Color = Color3.fromRGB(70, 70, 80)

        local wire_index = i
        cut_btn.MouseButton1Click:Connect(function()
            if game_over then return end
            if wire_index == safe_wire then
                wire_line.Size = UDim2.new(0, 80, 0, 8)
                local gap = Instance.new("Frame")
                gap.Size = UDim2.new(0, 20, 0, 8)
                gap.AnchorPoint = Vector2.new(0, 0.5)
                gap.Position = UDim2.new(0, 115, 0.5, 0)
                gap.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
                gap.BorderSizePixel = 0
                gap.Parent = wire_row
                cut_btn.Text = "✅"
                cut_btn.TextColor3 = GREEN
                win()
            else
                cut_btn.TextColor3 = RED
                cut_btn.Text = "X"
                fail("Wrong wire cut!")
            end
        end)
    end

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Wire cutter cancelled.", 3) end
        cleanup()
    end)

    local time_elapsed = 0
    timer_conn = RunService.Heartbeat:Connect(function(dt)
        if game_over then return end
        time_elapsed = time_elapsed + dt
        local left = TIME_LIMIT - time_elapsed
        if left <= 0 then
            timer_label.Text = "00:00"
            fail("Time's up!.")
            return
        end
        local mins = math.floor(left / 60)
        local secs = math.floor(left % 60)
        timer_label.Text = string.format("%02d:%02d", mins, secs)
        if left <= 5 then timer_label.TextColor3 = RED end
    end)
end

g.simon_says_minigame = function()
    if g.simon_says_cooldown and tick() - g.simon_says_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.simon_says_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end
    local preset = get_preset("simon")
    local TweenService = cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
    local DARK = Color3.fromRGB(14, 14, 18)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local MUTED = Color3.fromRGB(100, 100, 110)
    local RED = Color3.fromRGB(220, 60, 60)
    local ROUNDS_TO_WIN = preset.rounds_to_win
    local BUTTONS = {
        {name = "Red",    color = Color3.fromRGB(200, 50, 50),   dim = Color3.fromRGB(60, 15, 15)},
        {name = "Green",  color = Color3.fromRGB(50, 200, 90),   dim = Color3.fromRGB(15, 60, 25)},
        {name = "Blue",   color = Color3.fromRGB(60, 120, 220),  dim = Color3.fromRGB(15, 35, 70)},
        {name = "Yellow", color = Color3.fromRGB(220, 200, 40),  dim = Color3.fromRGB(65, 58, 10)},
    }
    local sequence = {}
    local player_index = 1
    local round = 0
    local accepting_input = false
    local game_over = false
    if CoreGui:FindFirstChild("SimonSaysGUI") then CoreGui.SimonSaysGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "SimonSaysGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, 400)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(50, 50, 60)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.75, 0, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "// SIMON SAYS //"
    title.TextColor3 = Color3.fromRGB(180, 180, 220)
    title.Font = Enum.Font.Code
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 8)
    cancel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.BorderSizePixel = 0
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)

    local status_label = Instance.new("TextLabel")
    status_label.Size = UDim2.new(1, -20, 0, 22)
    status_label.Position = UDim2.new(0, 10, 0, 44)
    status_label.BackgroundTransparency = 1
    status_label.Text = "Watch the sequence..."
    status_label.TextColor3 = MUTED
    status_label.Font = Enum.Font.Code
    status_label.TextSize = 12
    status_label.TextXAlignment = Enum.TextXAlignment.Center
    status_label.Parent = frame

    local round_label = Instance.new("TextLabel")
    round_label.Size = UDim2.new(1, -20, 0, 20)
    round_label.Position = UDim2.new(0, 10, 0, 66)
    round_label.BackgroundTransparency = 1
    round_label.Text = "Round 0 / " .. ROUNDS_TO_WIN
    round_label.TextColor3 = MUTED
    round_label.Font = Enum.Font.Code
    round_label.TextSize = 11
    round_label.TextXAlignment = Enum.TextXAlignment.Center
    round_label.Parent = frame

    local grid = Instance.new("Frame")
    grid.Size = UDim2.new(0, 260, 0, 260)
    grid.AnchorPoint = Vector2.new(0.5, 0)
    grid.Position = UDim2.new(0.5, 0, 0, 100)
    grid.BackgroundTransparency = 1
    grid.Parent = frame

    local btn_refs = {}
    local positions = {
        UDim2.new(0, 0, 0, 0),
        UDim2.new(0, 136, 0, 0),
        UDim2.new(0, 0, 0, 136),
        UDim2.new(0, 136, 0, 136),
    }
    local function cleanup() getgenv().Keybind_Input_Disabled_For_Mini_Game = false if gui then gui:Destroy() end end
    local function win()
        game_over = true
        g.simon_says_cooldown = tick()
        if g.notify then g.notify("Success", "Simon says well done!", 5) end
        task.delay(0.5, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then g.notify("Error", msg or "Wrong button!", 5) end
        task.delay(0.3, cleanup)
    end

    local function flash_button(index, duration, callback)
        local b = btn_refs[index]
        if not b then if callback then callback() end return end
        b.BackgroundColor3 = BUTTONS[index].color
        task.delay(duration, function()
            b.BackgroundColor3 = BUTTONS[index].dim
            if callback then task.delay(preset.gap_duration, callback) end
        end)
    end

    local function play_sequence(step, callback)
        if step > #sequence then
            if callback then callback() end
            return
        end
        flash_button(sequence[step], preset.flash_duration, function()
            task.delay(preset.gap_duration, function()
                play_sequence(step + 1, callback)
            end)
        end)
    end

    local function start_round()
        if game_over then return end
        round = round + 1
        round_label.Text = "Round " .. round .. " / " .. ROUNDS_TO_WIN
        status_label.Text = "Watch..."
        status_label.TextColor3 = MUTED
        accepting_input = false
        player_index = 1
        table.insert(sequence, math.random(1, 4))
        task.delay(0.6, function()
            play_sequence(1, function()
                if not game_over then
                    accepting_input = true
                    status_label.Text = "Your turn! Repeat the sequence"
                    status_label.TextColor3 = WHITE
                end
            end)
        end)
    end

    for i, data in ipairs(BUTTONS) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 120, 0, 120)
        btn.Position = positions[i]
        btn.BackgroundColor3 = data.dim
        btn.Text = data.name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.TextColor3 = WHITE
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = grid
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        btn_refs[i] = btn

        local idx = i
        btn.MouseButton1Click:Connect(function()
            if game_over or not accepting_input then return end
            flash_button(idx, 0.2, nil)
            if sequence[player_index] == idx then
                player_index = player_index + 1
                if player_index > #sequence then
                    accepting_input = false
                    if round >= ROUNDS_TO_WIN then
                        win()
                    else
                        status_label.Text = "Correct! Next round..."
                        status_label.TextColor3 = Color3.fromRGB(60, 200, 100)
                        task.delay(0.8, start_round)
                    end
                end
            else
                fail("Wrong button!.")
            end
        end)
    end

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Simon Says cancelled.", 3) end
        cleanup()
    end)

    start_round()
end

g.open_difficulty_editor = function()
    if CoreGui:FindFirstChild("DifficultyEditorGUI") then
        CoreGui.DifficultyEditorGUI.Frame.Visible = true
        return
    end

    local DARK = Color3.fromRGB(18, 18, 18)
    local SURFACE = Color3.fromRGB(26, 26, 26)
    local BORDER = Color3.fromRGB(50, 50, 50)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local MUTED = Color3.fromRGB(140, 140, 140)
    local GAME_LABELS = {
        {key = "memory", name = "Memory Grid"},
        {key = "reaction", name = "Reaction Time"},
        {key = "keypad", name = "Keypad Hack"},
        {key = "hacking", name = "Breach Protocol"},
        {key = "safe", name = "Safe Cracker"},
        {key = "wire", name = "Wire Cutter"},
        {key = "simon", name = "Simon Says"},
        {key = "lockpick", name = "Lockpick"},
        {key = "laser", name = "Laser Grid"},
        {key = "signal", name = "Signal Triangulation"},
        {key = "pipe", name = "Pipe Reroute"},
        {key = "steady", name = "Steady Hand"},
        {key = "rhythm", name = "Rhythm Splice"},
        {key = "recall", name = "Vault Recall"},
    }

    local gui = Instance.new("ScreenGui")
    gui.Name = "DifficultyEditorGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local outer = Instance.new("Frame")
    outer.Name = "Frame"
    outer.AnchorPoint = Vector2.new(0.5, 0.5)
    outer.Position = UDim2.fromScale(0.5, 0.5)
    outer.Size = UDim2.new(0, 340, 0, 470)
    outer.BackgroundColor3 = DARK
    outer.BorderSizePixel = 0
    outer.Parent = gui
    Instance.new("UICorner", outer).CornerRadius = UDim.new(0, 14)
    Instance.new("UIStroke", outer).Color = BORDER

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 42)
    header.BackgroundColor3 = SURFACE
    header.BorderSizePixel = 0
    header.Parent = outer
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

    local hfix = Instance.new("Frame")
    hfix.Size = UDim2.new(1, 0, 0.5, 0)
    hfix.Position = UDim2.fromScale(0, 0.5)
    hfix.BackgroundColor3 = SURFACE
    hfix.BorderSizePixel = 0
    hfix.Parent = header

    local title_lbl = Instance.new("TextLabel")
    title_lbl.Size = UDim2.new(1, -50, 1, 0)
    title_lbl.Position = UDim2.new(0, 14, 0, 0)
    title_lbl.BackgroundTransparency = 1
    title_lbl.Text = "Difficulty Editor"
    title_lbl.Font = Enum.Font.GothamBold
    title_lbl.TextSize = 14
    title_lbl.TextColor3 = WHITE
    title_lbl.TextXAlignment = Enum.TextXAlignment.Left
    title_lbl.Parent = header

    local close_btn = Instance.new("TextButton")
    close_btn.Size = UDim2.new(0, 34, 0, 24)
    close_btn.Position = UDim2.new(1, -42, 0.5, -12)
    close_btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    close_btn.Text = "X"
    close_btn.TextColor3 = MUTED
    close_btn.Font = Enum.Font.GothamBold
    close_btn.TextSize = 13
    close_btn.BorderSizePixel = 0
    close_btn.Parent = header
    Instance.new("UICorner", close_btn).CornerRadius = UDim.new(0, 6)
    close_btn.MouseButton1Click:Connect(function() outer.Visible = false end)

    if dragify then dragify(outer) end
    local list_frame = Instance.new("ScrollingFrame")
    list_frame.Size = UDim2.new(1, 0, 1, -92)
    list_frame.Position = UDim2.new(0, 0, 0, 42)
    list_frame.BackgroundTransparency = 1
    list_frame.BorderSizePixel = 0
    list_frame.ScrollBarThickness = 3
    list_frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    list_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list_frame.Parent = outer

    local ui_list = Instance.new("UIListLayout")
    ui_list.Padding = UDim.new(0, 8)
    ui_list.SortOrder = Enum.SortOrder.LayoutOrder
    ui_list.Parent = list_frame

    local list_pad = Instance.new("UIPadding")
    list_pad.PaddingTop = UDim.new(0, 10)
    list_pad.PaddingBottom = UDim.new(0, 10)
    list_pad.PaddingLeft = UDim.new(0, 10)
    list_pad.PaddingRight = UDim.new(0, 10)
    list_pad.Parent = list_frame

    local refresh_row
    local function randomize_one(game_key)
        g.minigame_difficulty[game_key] = DIFFICULTY_ORDER[math.random(1, #DIFFICULTY_ORDER)]
        refresh_row(game_key)
    end

    local row_buttons = {}
    local function build_row(entry, order)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 62)
        card.BackgroundColor3 = SURFACE
        card.BorderSizePixel = 0
        card.LayoutOrder = order
        card.Parent = list_frame
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
        Instance.new("UIStroke", card).Color = BORDER

        local name_lbl = Instance.new("TextLabel")
        name_lbl.Size = UDim2.new(1, -20, 0, 18)
        name_lbl.Position = UDim2.new(0, 10, 0, 6)
        name_lbl.BackgroundTransparency = 1
        name_lbl.Text = entry.name
        name_lbl.Font = Enum.Font.GothamBold
        name_lbl.TextSize = 12
        name_lbl.TextColor3 = WHITE
        name_lbl.TextXAlignment = Enum.TextXAlignment.Left
        name_lbl.Parent = card

        local btn_row = Instance.new("Frame")
        btn_row.Size = UDim2.new(1, -20, 0, 28)
        btn_row.Position = UDim2.new(0, 10, 0, 26)
        btn_row.BackgroundTransparency = 1
        btn_row.Parent = card

        local btn_layout = Instance.new("UIListLayout")
        btn_layout.FillDirection = Enum.FillDirection.Horizontal
        btn_layout.Padding = UDim.new(0, 6)
        btn_layout.SortOrder = Enum.SortOrder.LayoutOrder
        btn_layout.Parent = btn_row

        row_buttons[entry.key] = {}

        for _, diff_name in ipairs(DIFFICULTY_ORDER) do
            local diff_btn = Instance.new("TextButton")
            diff_btn.Size = UDim2.new(0, 68, 1, 0)
            diff_btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            diff_btn.Text = diff_name
            diff_btn.Font = Enum.Font.GothamBold
            diff_btn.TextSize = 11
            diff_btn.TextColor3 = MUTED
            diff_btn.BorderSizePixel = 0
            diff_btn.Parent = btn_row
            Instance.new("UICorner", diff_btn).CornerRadius = UDim.new(0, 6)
            row_buttons[entry.key][diff_name] = diff_btn

            diff_btn.MouseButton1Click:Connect(function()
                g.minigame_difficulty[entry.key] = diff_name
                refresh_row(entry.key)
            end)
        end

        local dice_btn = Instance.new("TextButton")
        dice_btn.Size = UDim2.new(0, 28, 1, 0)
        dice_btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        dice_btn.Text = "🎲"
        dice_btn.TextSize = 13
        dice_btn.BorderSizePixel = 0
        dice_btn.Parent = btn_row
        Instance.new("UICorner", dice_btn).CornerRadius = UDim.new(0, 6)
        dice_btn.MouseButton1Click:Connect(function() randomize_one(entry.key) end)
    end

    refresh_row = function(game_key)
        local current = g.minigame_difficulty[game_key] or "Medium"
        for diff_name, btn in pairs(row_buttons[game_key]) do
            if diff_name == current then
                btn.BackgroundColor3 = DIFFICULTY_COLOR[diff_name]
                btn.TextColor3 = Color3.fromRGB(20, 20, 20)
            else
                btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                btn.TextColor3 = MUTED
            end
        end
    end

    for i, entry in ipairs(GAME_LABELS) do build_row(entry, i) end
    for _, entry in ipairs(GAME_LABELS) do refresh_row(entry.key) end
    local footer = Instance.new("Frame")
    footer.Size = UDim2.new(1, 0, 0, 50)
    footer.Position = UDim2.new(0, 0, 1, -50)
    footer.BackgroundColor3 = SURFACE
    footer.BorderSizePixel = 0
    footer.Parent = outer

    local randomize_all_btn = Instance.new("TextButton")
    randomize_all_btn.Size = UDim2.new(1, -20, 0, 32)
    randomize_all_btn.Position = UDim2.new(0, 10, 0, 9)
    randomize_all_btn.BackgroundColor3 = Color3.fromRGB(60, 50, 90)
    randomize_all_btn.Text = "🎲 Randomize All"
    randomize_all_btn.Font = Enum.Font.GothamBold
    randomize_all_btn.TextSize = 13
    randomize_all_btn.TextColor3 = WHITE
    randomize_all_btn.BorderSizePixel = 0
    randomize_all_btn.Parent = footer
    Instance.new("UICorner", randomize_all_btn).CornerRadius = UDim.new(0, 8)
    randomize_all_btn.MouseButton1Click:Connect(function() for _, entry in ipairs(GAME_LABELS) do randomize_one(entry.key) end end)
end

g.minigame_difficulty.lockpick = "Medium"
g.minigame_difficulty.laser = "Medium"
g.minigame_difficulty.signal = "Medium"
g.minigame_difficulty.pipe = "Medium"
g.minigame_difficulty.steady = "Medium"
g.minigame_difficulty.rhythm = "Medium"
g.minigame_difficulty.recall = "Medium"
g.minigame_difficulty_presets.lockpick = {
    Easy   = {pin_count = 3, sweet_width = 26, tension_max = 140, tension_rate = 6, dial_speed = 70},
    Medium = {pin_count = 4, sweet_width = 18, tension_max = 120, tension_rate = 9, dial_speed = 100},
    Hard   = {pin_count = 5, sweet_width = 12, tension_max = 100, tension_rate = 13, dial_speed = 140},
}

g.minigame_difficulty_presets.laser = {
    Easy   = {row_count = 4, beam_speed = 1.0, hazard_margin = 0.10, time_limit = 35},
    Medium = {row_count = 6, beam_speed = 1.5, hazard_margin = 0.16, time_limit = 25},
    Hard   = {row_count = 8, beam_speed = 2.2, hazard_margin = 0.24, time_limit = 18},
}

g.minigame_difficulty_presets.signal = {
    Easy   = {tolerance = 8, time_limit = 35, drift_speed = 0},
    Medium = {tolerance = 5, time_limit = 25, drift_speed = 6},
    Hard   = {tolerance = 3, time_limit = 18, drift_speed = 12},
}

g.minigame_difficulty_presets.pipe = {
    Easy   = {grid_size = 3, locked_count = 1, time_limit = 40},
    Medium = {grid_size = 4, locked_count = 2, time_limit = 30},
    Hard   = {grid_size = 5, locked_count = 3, time_limit = 22},
}

g.minigame_difficulty_presets.steady = {
    Easy   = {drift_force = 40, zone_width = 0.30, hold_duration = 3, time_limit = 30},
    Medium = {drift_force = 70, zone_width = 0.20, hold_duration = 4, time_limit = 25},
    Hard   = {drift_force = 110, zone_width = 0.12, hold_duration = 5, time_limit = 20},
}

g.minigame_difficulty_presets.rhythm = {
    Easy   = {note_count = 10, note_speed = 220, hit_window = 0.14, max_misses = 4},
    Medium = {note_count = 14, note_speed = 300, hit_window = 0.10, max_misses = 3},
    Hard   = {note_count = 18, note_speed = 400, hit_window = 0.07, max_misses = 2},
}

g.minigame_difficulty_presets.recall = {
    Easy   = {card_count = 4, show_time = 0.8, grid_cols = 4},
    Medium = {card_count = 6, show_time = 0.6, grid_cols = 4},
    Hard   = {card_count = 8, show_time = 0.45, grid_cols = 4},
}

g.lockpick_minigame = function()
    if g.lockpick_minigame_cooldown and tick() - g.lockpick_minigame_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.lockpick_minigame_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local preset = get_preset("lockpick")
    local DARK = Color3.fromRGB(16, 14, 12)
    local BRONZE = Color3.fromRGB(190, 140, 70)
    local DIM_BRONZE = Color3.fromRGB(70, 55, 30)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local RED = Color3.fromRGB(200, 60, 60)
    local GREEN = Color3.fromRGB(60, 200, 100)
    local PIN_COUNT = preset.pin_count
    local SWEET_WIDTH = preset.sweet_width
    local TENSION_MAX = preset.tension_max
    local TENSION_RATE = preset.tension_rate
    local DIAL_SPEED = preset.dial_speed
    local pin = 1
    local angle = 0
    local dir = 1
    local sweet_start = math.random(0, 359)
    local tension = 0
    local holding_tension = false
    local game_over = false
    local render_conn = nil
    local heartbeat_conn = nil
    if CoreGui:FindFirstChild("LockpickGUI") then CoreGui.LockpickGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "LockpickGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, 440)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local fstroke = Instance.new("UIStroke", frame)
    fstroke.Color = BRONZE
    fstroke.Thickness = 1.5

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.75, 0, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "// LOCKPICK //"
    title.TextColor3 = BRONZE
    title.Font = Enum.Font.Code
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 8)
    cancel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.BorderSizePixel = 0
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)

    local pin_label = Instance.new("TextLabel")
    pin_label.Size = UDim2.new(1, -20, 0, 22)
    pin_label.Position = UDim2.new(0, 10, 0, 44)
    pin_label.BackgroundTransparency = 1
    pin_label.Text = "Pin 1 of " .. PIN_COUNT
    pin_label.TextColor3 = BRONZE
    pin_label.Font = Enum.Font.Code
    pin_label.TextSize = 13
    pin_label.TextXAlignment = Enum.TextXAlignment.Left
    pin_label.Parent = frame

    local dial_holder = Instance.new("Frame")
    dial_holder.Size = UDim2.new(0, 240, 0, 240)
    dial_holder.AnchorPoint = Vector2.new(0.5, 0)
    dial_holder.Position = UDim2.new(0.5, 0, 0, 76)
    dial_holder.BackgroundTransparency = 1
    dial_holder.Parent = frame

    local dial_bg = Instance.new("Frame")
    dial_bg.Size = UDim2.fromScale(1, 1)
    dial_bg.BackgroundColor3 = Color3.fromRGB(24, 20, 16)
    dial_bg.BorderSizePixel = 0
    dial_bg.Parent = dial_holder
    Instance.new("UICorner", dial_bg).CornerRadius = UDim.new(0.5, 0)
    local dstroke = Instance.new("UIStroke", dial_bg)
    dstroke.Color = DIM_BRONZE
    dstroke.Thickness = 2

    local sweet_arc = Instance.new("Frame")
    sweet_arc.Size = UDim2.new(0, 10, 0, 40)
    sweet_arc.AnchorPoint = Vector2.new(0.5, 1)
    sweet_arc.BackgroundColor3 = GREEN
    sweet_arc.BorderSizePixel = 0
    sweet_arc.Parent = dial_holder
    Instance.new("UICorner", sweet_arc).CornerRadius = UDim.new(0, 4)

    local pick_marker = Instance.new("Frame")
    pick_marker.Size = UDim2.new(0, 6, 0, 90)
    pick_marker.AnchorPoint = Vector2.new(0.5, 1)
    pick_marker.BackgroundColor3 = WHITE
    pick_marker.BorderSizePixel = 0
    pick_marker.Parent = dial_holder
    Instance.new("UICorner", pick_marker).CornerRadius = UDim.new(0, 3)

    local function position_at_angle(part, degrees, radius)
        local rad = math.rad(degrees - 90)
        local px = 0.5 + math.cos(rad) * radius
        local py = 0.5 + math.sin(rad) * radius
        part.Position = UDim2.new(px, 0, py, 0)
        part.Rotation = degrees
    end

    position_at_angle(sweet_arc, sweet_start + SWEET_WIDTH / 2, 0.42)

    local tension_bg = Instance.new("Frame")
    tension_bg.Size = UDim2.new(1, -20, 0, 18)
    tension_bg.Position = UDim2.new(0, 10, 0, 328)
    tension_bg.BackgroundColor3 = Color3.fromRGB(30, 26, 20)
    tension_bg.BorderSizePixel = 0
    tension_bg.Parent = frame
    Instance.new("UICorner", tension_bg).CornerRadius = UDim.new(0, 8)

    local tension_fill = Instance.new("Frame")
    tension_fill.Size = UDim2.new(0, 0, 1, 0)
    tension_fill.BackgroundColor3 = GREEN
    tension_fill.BorderSizePixel = 0
    tension_fill.Parent = tension_bg
    Instance.new("UICorner", tension_fill).CornerRadius = UDim.new(0, 8)

    local tension_label = Instance.new("TextLabel")
    tension_label.Size = UDim2.new(1, -20, 0, 16)
    tension_label.Position = UDim2.new(0, 10, 0, 350)
    tension_label.BackgroundTransparency = 1
    tension_label.Text = "TENSION"
    tension_label.TextColor3 = DIM_BRONZE
    tension_label.Font = Enum.Font.Code
    tension_label.TextSize = 11
    tension_label.TextXAlignment = Enum.TextXAlignment.Center
    tension_label.Parent = frame

    local tension_btn = Instance.new("TextButton")
    tension_btn.Size = UDim2.new(0, 160, 0, 40)
    tension_btn.AnchorPoint = Vector2.new(0.5, 0)
    tension_btn.Position = UDim2.new(0.5, 0, 0, 376)
    tension_btn.BackgroundColor3 = Color3.fromRGB(38, 32, 20)
    tension_btn.Text = "HOLD + SET PIN"
    tension_btn.Font = Enum.Font.GothamBold
    tension_btn.TextSize = 13
    tension_btn.TextColor3 = BRONZE
    tension_btn.BorderSizePixel = 0
    tension_btn.Parent = frame
    Instance.new("UICorner", tension_btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", tension_btn).Color = BRONZE

    local function cleanup()
        if render_conn then render_conn:Disconnect() end
        if heartbeat_conn then heartbeat_conn:Disconnect() end
        if gui then gui:Destroy() end
        getgenv().Keybind_Input_Disabled_For_Mini_Game = false
    end

    local function win()
        game_over = true
        g.lockpick_minigame_cooldown = tick()
        if g.notify then g.notify("Success", "Lock picked!", 5) end
        task.delay(0.5, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then g.notify("Error", msg or "Pick broke!", 5) end
        task.delay(0.5, cleanup)
    end

    local function next_pin()
        pin = pin + 1
        if pin > PIN_COUNT then
            win()
            return
        end
        pin_label.Text = "Pin " .. pin .. " of " .. PIN_COUNT
        sweet_start = math.random(0, 359)
        position_at_angle(sweet_arc, sweet_start + SWEET_WIDTH / 2, 0.42)
        tension = math.max(0, tension - TENSION_MAX * 0.25)
    end

    tension_btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            holding_tension = true
        end
    end)

    tension_btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            holding_tension = false
        end
    end)

    tension_btn.MouseButton1Click:Connect(function()
        if game_over then return end
        local diff = math.abs(angle - (sweet_start + SWEET_WIDTH / 2))
        diff = math.min(diff, 360 - diff)
        if diff <= SWEET_WIDTH / 2 then
            next_pin()
        else
            tension = math.min(TENSION_MAX, tension + TENSION_RATE * 4)
        end
    end)

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Lockpick cancelled.", 3) end
        cleanup()
    end)

    render_conn = RunService.RenderStepped:Connect(function(dt)
        if game_over then return end
        angle = angle + DIAL_SPEED * dt * dir
        if angle >= 360 then angle = angle - 360 end
        if angle < 0 then angle = angle + 360 end
        position_at_angle(pick_marker, angle, 0.45)
    end)

    heartbeat_conn = RunService.Heartbeat:Connect(function(dt)
        if game_over then return end
        if holding_tension then
            tension = tension + TENSION_RATE * dt
        else
            tension = math.max(0, tension - TENSION_RATE * 1.5 * dt)
        end
        tension_fill.Size = UDim2.new(math.clamp(tension / TENSION_MAX, 0, 1), 0, 1, 0)
        tension_fill.BackgroundColor3 = tension > TENSION_MAX * 0.75 and RED or GREEN
        if tension >= TENSION_MAX then
            fail("Pick snapped!")
        end
    end)
end

g.laser_grid_minigame = function()
    if g.laser_grid_cooldown and tick() - g.laser_grid_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.laser_grid_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local preset = get_preset("laser")
    local DARK = Color3.fromRGB(10, 10, 14)
    local RED = Color3.fromRGB(220, 50, 50)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local GREEN = Color3.fromRGB(60, 200, 100)
    local MUTED = Color3.fromRGB(90, 90, 100)
    local ROW_COUNT = preset.row_count
    local BEAM_SPEED = preset.beam_speed
    local HAZARD_MARGIN = preset.hazard_margin
    local TIME_LIMIT = preset.time_limit
    local BEAM_WIDTH = 0.08
    local current_row = 1
    local game_over = false
    local timer_conn = nil
    local render_conn = nil
    local beam_phase = {}
    for i = 1, ROW_COUNT do beam_phase[i] = math.random() * math.pi * 2 end

    if CoreGui:FindFirstChild("LaserGridGUI") then CoreGui.LaserGridGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "LaserGridGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, ROW_COUNT * 46 + 130)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local fstroke = Instance.new("UIStroke", frame)
    fstroke.Color = RED
    fstroke.Thickness = 1

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "// LASER GRID //"
    title.TextColor3 = RED
    title.Font = Enum.Font.Code
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local timer_label = Instance.new("TextLabel")
    timer_label.Size = UDim2.new(0.2, 0, 0, 36)
    timer_label.Position = UDim2.new(0.72, 0, 0, 6)
    timer_label.BackgroundTransparency = 1
    timer_label.Text = "00:" .. string.format("%02d", TIME_LIMIT)
    timer_label.TextColor3 = WHITE
    timer_label.Font = Enum.Font.Code
    timer_label.TextSize = 15
    timer_label.TextXAlignment = Enum.TextXAlignment.Right
    timer_label.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 8)
    cancel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.BorderSizePixel = 0
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)

    local status_label = Instance.new("TextLabel")
    status_label.Size = UDim2.new(1, -20, 0, 20)
    status_label.Position = UDim2.new(0, 10, 0, 44)
    status_label.BackgroundTransparency = 1
    status_label.Text = "Row 1 of " .. ROW_COUNT .. " — advance between beams"
    status_label.TextColor3 = MUTED
    status_label.Font = Enum.Font.Code
    status_label.TextSize = 11
    status_label.TextXAlignment = Enum.TextXAlignment.Left
    status_label.Parent = frame

    local rows_holder = Instance.new("Frame")
    rows_holder.Size = UDim2.new(1, -20, 0, ROW_COUNT * 46)
    rows_holder.Position = UDim2.new(0, 10, 0, 70)
    rows_holder.BackgroundTransparency = 1
    rows_holder.Parent = frame

    local lanes = {}
    local token_col = 0.1
    for i = 1, ROW_COUNT do
        local lane = Instance.new("Frame")
        lane.Size = UDim2.new(1, 0, 0, 38)
        lane.Position = UDim2.new(0, 0, 0, (ROW_COUNT - i) * 46)
        lane.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        lane.BorderSizePixel = 0
        lane.Parent = rows_holder
        Instance.new("UICorner", lane).CornerRadius = UDim.new(0, 6)

        local beam = Instance.new("Frame")
        beam.Size = UDim2.new(BEAM_WIDTH, 0, 1, 0)
        beam.BackgroundColor3 = RED
        beam.BorderSizePixel = 0
        beam.Parent = lane
        Instance.new("UICorner", beam).CornerRadius = UDim.new(0, 6)

        lanes[i] = {lane = lane, beam = beam}
    end

    local token = Instance.new("Frame")
    token.Size = UDim2.new(0, 20, 0, 20)
    token.AnchorPoint = Vector2.new(0.5, 0.5)
    token.BackgroundColor3 = GREEN
    token.BorderSizePixel = 0
    token.Parent = lanes[1].lane
    token.Position = UDim2.new(token_col, 0, 0.5, 0)
    Instance.new("UICorner", token).CornerRadius = UDim.new(0.5, 0)

    local advance_btn = Instance.new("TextButton")
    advance_btn.Size = UDim2.new(0, 140, 0, 36)
    advance_btn.AnchorPoint = Vector2.new(0.5, 0)
    advance_btn.Position = UDim2.new(0.5, 0, 1, -46)
    advance_btn.BackgroundColor3 = Color3.fromRGB(38, 30, 30)
    advance_btn.Text = "ADVANCE"
    advance_btn.Font = Enum.Font.GothamBold
    advance_btn.TextSize = 13
    advance_btn.TextColor3 = RED
    advance_btn.BorderSizePixel = 0
    advance_btn.Parent = frame
    Instance.new("UICorner", advance_btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", advance_btn).Color = RED

    local function cleanup()
        if timer_conn then timer_conn:Disconnect() end
        if render_conn then render_conn:Disconnect() end
        if gui then gui:Destroy() end
        getgenv().Keybind_Input_Disabled_For_Mini_Game = false
    end

    local function win()
        game_over = true
        g.laser_grid_cooldown = tick()
        if g.notify then g.notify("Success", "Bypassed the laser grid!", 5) end
        task.delay(0.5, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then g.notify("Error", msg or "Tripped a laser!", 5) end
        task.delay(0.5, cleanup)
    end

    advance_btn.MouseButton1Click:Connect(function()
        if game_over then return end
        local row_data = lanes[current_row]
        local beam_min = row_data.beam.Position.X.Scale - HAZARD_MARGIN / 2
        local beam_max = beam_min + BEAM_WIDTH + HAZARD_MARGIN
        if token_col >= beam_min and token_col <= beam_max then
            fail("Tripped a laser!")
            return
        end
        current_row = current_row + 1
        if current_row > ROW_COUNT then
            win()
            return
        end
        token.Parent = lanes[current_row].lane
        status_label.Text = "Row " .. current_row .. " of " .. ROW_COUNT .. " — advance between beams"
    end)

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Laser grid cancelled.", 3) end
        cleanup()
    end)

    render_conn = RunService.RenderStepped:Connect(function(dt)
        if game_over then return end
        for i, row_data in ipairs(lanes) do
            beam_phase[i] = beam_phase[i] + dt * BEAM_SPEED
            local offset = (math.sin(beam_phase[i]) + 1) / 2 * (1 - BEAM_WIDTH)
            row_data.beam.Position = UDim2.new(offset, 0, 0, 0)
        end
    end)

    local time_elapsed = 0
    timer_conn = RunService.Heartbeat:Connect(function(dt)
        if game_over then return end
        time_elapsed = time_elapsed + dt
        local left = TIME_LIMIT - time_elapsed
        if left <= 0 then
            timer_label.Text = "00:00"
            fail("Time's up!")
            return
        end
        local mins = math.floor(left / 60)
        local secs = math.floor(left % 60)
        timer_label.Text = string.format("%02d:%02d", mins, secs)
        if left <= 5 then timer_label.TextColor3 = RED end
    end)
end

g.signal_triangulation_minigame = function()
    if g.signal_triangulation_cooldown and tick() - g.signal_triangulation_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.signal_triangulation_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local UserInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
    local preset = get_preset("signal")
    local DARK = Color3.fromRGB(10, 12, 16)
    local CYAN = Color3.fromRGB(60, 200, 220)
    local MUTED = Color3.fromRGB(90, 100, 110)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local RED = Color3.fromRGB(200, 60, 60)
    local GREEN = Color3.fromRGB(60, 200, 100)
    local TOLERANCE = preset.tolerance
    local DRIFT_SPEED = preset.drift_speed
    local TIME_LIMIT = preset.time_limit
    local target_pos = math.random(10, 90)
    local handle_pos = 50
    local dragging = false
    local game_over = false
    local drift_dir = 1
    local timer_conn = nil
    local input_ended_conn = nil
    local input_changed_conn = nil

    if CoreGui:FindFirstChild("SignalTriangulationGUI") then CoreGui.SignalTriangulationGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "SignalTriangulationGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 360, 0, 260)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local fstroke = Instance.new("UIStroke", frame)
    fstroke.Color = CYAN
    fstroke.Thickness = 1

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "// SIGNAL TRIANGULATION //"
    title.TextColor3 = CYAN
    title.Font = Enum.Font.Code
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local timer_label = Instance.new("TextLabel")
    timer_label.Size = UDim2.new(0.2, 0, 0, 36)
    timer_label.Position = UDim2.new(0.72, 0, 0, 6)
    timer_label.BackgroundTransparency = 1
    timer_label.Text = "00:" .. string.format("%02d", TIME_LIMIT)
    timer_label.TextColor3 = WHITE
    timer_label.Font = Enum.Font.Code
    timer_label.TextSize = 15
    timer_label.TextXAlignment = Enum.TextXAlignment.Right
    timer_label.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 8)
    cancel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.BorderSizePixel = 0
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)

    local strength_label = Instance.new("TextLabel")
    strength_label.Size = UDim2.new(1, -20, 0, 30)
    strength_label.Position = UDim2.new(0, 10, 0, 48)
    strength_label.BackgroundTransparency = 1
    strength_label.Text = "SIGNAL: 0%"
    strength_label.TextColor3 = CYAN
    strength_label.Font = Enum.Font.Code
    strength_label.TextSize = 20
    strength_label.TextXAlignment = Enum.TextXAlignment.Center
    strength_label.Parent = frame

    local strength_bar_bg = Instance.new("Frame")
    strength_bar_bg.Size = UDim2.new(1, -40, 0, 14)
    strength_bar_bg.Position = UDim2.new(0, 20, 0, 84)
    strength_bar_bg.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
    strength_bar_bg.BorderSizePixel = 0
    strength_bar_bg.Parent = frame
    Instance.new("UICorner", strength_bar_bg).CornerRadius = UDim.new(0, 8)

    local strength_bar_fill = Instance.new("Frame")
    strength_bar_fill.Size = UDim2.new(0, 0, 1, 0)
    strength_bar_fill.BackgroundColor3 = CYAN
    strength_bar_fill.BorderSizePixel = 0
    strength_bar_fill.Parent = strength_bar_bg
    Instance.new("UICorner", strength_bar_fill).CornerRadius = UDim.new(0, 8)

    local slider_bg = Instance.new("Frame")
    slider_bg.Size = UDim2.new(1, -40, 0, 8)
    slider_bg.Position = UDim2.new(0, 20, 0, 150)
    slider_bg.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    slider_bg.BorderSizePixel = 0
    slider_bg.Parent = frame
    Instance.new("UICorner", slider_bg).CornerRadius = UDim.new(0, 4)

    local handle = Instance.new("TextButton")
    handle.Size = UDim2.new(0, 24, 0, 24)
    handle.AnchorPoint = Vector2.new(0.5, 0.5)
    handle.Position = UDim2.new(handle_pos / 100, 0, 0.5, 0)
    handle.BackgroundColor3 = WHITE
    handle.Text = ""
    handle.BorderSizePixel = 0
    handle.Parent = slider_bg
    Instance.new("UICorner", handle).CornerRadius = UDim.new(0.5, 0)

    local lock_btn = Instance.new("TextButton")
    lock_btn.Size = UDim2.new(0, 140, 0, 36)
    lock_btn.AnchorPoint = Vector2.new(0.5, 0)
    lock_btn.Position = UDim2.new(0.5, 0, 0, 190)
    lock_btn.BackgroundColor3 = Color3.fromRGB(20, 34, 36)
    lock_btn.Text = "LOCK SIGNAL"
    lock_btn.Font = Enum.Font.GothamBold
    lock_btn.TextSize = 13
    lock_btn.TextColor3 = CYAN
    lock_btn.BorderSizePixel = 0
    lock_btn.Parent = frame
    Instance.new("UICorner", lock_btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", lock_btn).Color = CYAN

    local function cleanup()
        if timer_conn then timer_conn:Disconnect() end
        if input_ended_conn then input_ended_conn:Disconnect() end
        if input_changed_conn then input_changed_conn:Disconnect() end
        if gui then gui:Destroy() end
        getgenv().Keybind_Input_Disabled_For_Mini_Game = false
    end

    local function win()
        game_over = true
        g.signal_triangulation_cooldown = tick()
        if g.notify then g.notify("Success", "Signal triangulated!", 5) end
        task.delay(0.5, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then g.notify("Error", msg or "Signal lost!", 5) end
        task.delay(0.5, cleanup)
    end

    local function update_strength()
        local diff = math.abs(handle_pos - target_pos)
        local strength = math.clamp(100 - diff * 2, 0, 100)
        strength_label.Text = "SIGNAL: " .. math.floor(strength) .. "%"
        strength_bar_fill.Size = UDim2.new(strength / 100, 0, 1, 0)
        strength_bar_fill.BackgroundColor3 = strength > 80 and GREEN or CYAN
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    input_ended_conn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    input_changed_conn = UserInputService.InputChanged:Connect(function(input)
        if not dragging or game_over then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local bar_pos = slider_bg.AbsolutePosition.X
        local bar_size = slider_bg.AbsoluteSize.X
        local mouse_x = input.Position.X
        local scale = math.clamp((mouse_x - bar_pos) / bar_size, 0, 1)
        handle_pos = scale * 100
        handle.Position = UDim2.new(scale, 0, 0.5, 0)
        update_strength()
    end)

    lock_btn.MouseButton1Click:Connect(function()
        if game_over then return end
        if math.abs(handle_pos - target_pos) <= TOLERANCE then
            win()
        else
            fail("Signal lost!")
        end
    end)

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Signal triangulation cancelled.", 3) end
        cleanup()
    end)

    update_strength()

    local time_elapsed = 0
    timer_conn = RunService.Heartbeat:Connect(function(dt)
        if game_over then return end
        time_elapsed = time_elapsed + dt
        if DRIFT_SPEED > 0 then
            target_pos = target_pos + DRIFT_SPEED * dt * drift_dir
            if target_pos >= 95 then drift_dir = -1 end
            if target_pos <= 5 then drift_dir = 1 end
            update_strength()
        end
        local left = TIME_LIMIT - time_elapsed
        if left <= 0 then
            timer_label.Text = "00:00"
            fail("Time's up!")
            return
        end
        local mins = math.floor(left / 60)
        local secs = math.floor(left % 60)
        timer_label.Text = string.format("%02d:%02d", mins, secs)
        if left <= 5 then timer_label.TextColor3 = RED end
    end)
end

g.pipe_reroute_minigame = function()
    if g.pipe_reroute_cooldown and tick() - g.pipe_reroute_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.pipe_reroute_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local preset = get_preset("pipe")
    local DARK = Color3.fromRGB(14, 16, 14)
    local TEAL = Color3.fromRGB(60, 200, 170)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local MUTED = Color3.fromRGB(90, 100, 95)
    local GOLD = Color3.fromRGB(210, 170, 60)
    local RED = Color3.fromRGB(200, 60, 60)
    local GRID_SIZE = preset.grid_size
    local LOCKED_COUNT = preset.locked_count
    local TIME_LIMIT = preset.time_limit
    local DELTA = {[1] = {-1, 0}, [2] = {0, 1}, [3] = {1, 0}, [4] = {0, -1}}
    local OPPOSITE = {[1] = 3, [2] = 4, [3] = 1, [4] = 2}
    local GLYPHS_STRAIGHT = {"│", "─"}
    local GLYPHS_ELBOW = {"└", "┌", "┐", "┘"}
    local grid_data = {}
    local game_over = false
    local timer_conn = nil

    for r = 1, GRID_SIZE do
        grid_data[r] = {}
        for c = 1, GRID_SIZE do
            grid_data[r][c] = {
                kind = math.random(1, 2) == 1 and "straight" or "elbow",
                rotation = math.random(0, 3),
                locked = false,
            }
        end
    end

    local locked_set = 0
    while locked_set < LOCKED_COUNT do
        local r = math.random(1, GRID_SIZE)
        local c = math.random(1, GRID_SIZE)
        if not grid_data[r][c].locked then
            grid_data[r][c].locked = true
            locked_set = locked_set + 1
        end
    end

    local function connections_for(tile)
        if tile.kind == "straight" then
            if tile.rotation % 2 == 0 then return {[1] = true, [3] = true} else return {[2] = true, [4] = true} end
        else
            local a = ((1 - 1 + tile.rotation) % 4) + 1
            local b = ((2 - 1 + tile.rotation) % 4) + 1
            return {[a] = true, [b] = true}
        end
    end

    local function glyph_for(tile)
        if tile.kind == "straight" then
            return tile.rotation % 2 == 0 and GLYPHS_STRAIGHT[1] or GLYPHS_STRAIGHT[2]
        else
            return GLYPHS_ELBOW[tile.rotation + 1]
        end
    end

    local function check_solved()
        local visited = {}
        local queue = {{1, 1}}
        visited["1_1"] = true
        while #queue > 0 do
            local cur = table.remove(queue)
            local r, c = cur[1], cur[2]
            if r == GRID_SIZE and c == GRID_SIZE then return true end
            local conns = connections_for(grid_data[r][c])
            for dir, open in pairs(conns) do
                if open then
                    local delta = DELTA[dir]
                    local nr, nc = r + delta[1], c + delta[2]
                    if nr >= 1 and nr <= GRID_SIZE and nc >= 1 and nc <= GRID_SIZE then
                        local key = nr .. "_" .. nc
                        if not visited[key] then
                            local neighbor_conns = connections_for(grid_data[nr][nc])
                            if neighbor_conns[OPPOSITE[dir]] then
                                visited[key] = true
                                table.insert(queue, {nr, nc})
                            end
                        end
                    end
                end
            end
        end
        return false
    end

    if CoreGui:FindFirstChild("PipeRerouteGUI") then CoreGui.PipeRerouteGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "PipeRerouteGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local cell_size = 52
    local grid_pixel = GRID_SIZE * cell_size
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, grid_pixel + 100, 0, grid_pixel + 130)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local fstroke = Instance.new("UIStroke", frame)
    fstroke.Color = TEAL
    fstroke.Thickness = 1

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "// PIPE REROUTE //"
    title.TextColor3 = TEAL
    title.Font = Enum.Font.Code
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local timer_label = Instance.new("TextLabel")
    timer_label.Size = UDim2.new(0.2, 0, 0, 36)
    timer_label.Position = UDim2.new(0.6, 0, 0, 6)
    timer_label.BackgroundTransparency = 1
    timer_label.Text = "00:" .. string.format("%02d", TIME_LIMIT)
    timer_label.TextColor3 = WHITE
    timer_label.Font = Enum.Font.Code
    timer_label.TextSize = 15
    timer_label.TextXAlignment = Enum.TextXAlignment.Right
    timer_label.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 8)
    cancel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.BorderSizePixel = 0
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)

    local hint_label = Instance.new("TextLabel")
    hint_label.Size = UDim2.new(1, -20, 0, 20)
    hint_label.Position = UDim2.new(0, 10, 0, 44)
    hint_label.BackgroundTransparency = 1
    hint_label.Text = "Connect top-left to bottom-right."
    hint_label.TextColor3 = MUTED
    hint_label.Font = Enum.Font.Code
    hint_label.TextSize = 11
    hint_label.TextScaled = true
    hint_label.TextXAlignment = Enum.TextXAlignment.Left
    hint_label.Parent = frame

    local grid_frame = Instance.new("Frame")
    grid_frame.Size = UDim2.new(0, grid_pixel, 0, grid_pixel)
    grid_frame.AnchorPoint = Vector2.new(0.5, 0)
    grid_frame.Position = UDim2.new(0.5, 0, 0, 70)
    grid_frame.BackgroundTransparency = 1
    grid_frame.Parent = frame

    local function cleanup()
        if timer_conn then timer_conn:Disconnect() end
        if gui then gui:Destroy() end
        getgenv().Keybind_Input_Disabled_For_Mini_Game = false
    end

    local function win()
        game_over = true
        g.pipe_reroute_cooldown = tick()
        if g.notify then g.notify("Success", "Circuit rerouted!", 5) end
        task.delay(0.5, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then g.notify("Error", msg or "Time's up!", 5) end
        task.delay(0.5, cleanup)
    end

    for r = 1, GRID_SIZE do
        for c = 1, GRID_SIZE do
            local tile = grid_data[r][c]
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, cell_size - 6, 0, cell_size - 6)
            btn.Position = UDim2.new(0, (c - 1) * cell_size, 0, (r - 1) * cell_size)
            btn.BackgroundColor3 = tile.locked and Color3.fromRGB(50, 40, 15) or Color3.fromRGB(22, 24, 22)
            btn.Text = glyph_for(tile)
            btn.Font = Enum.Font.Code
            btn.TextSize = 26
            btn.TextColor3 = tile.locked and GOLD or TEAL
            btn.BorderSizePixel = 0
            btn.Parent = grid_frame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

            btn.MouseButton1Click:Connect(function()
                if game_over or tile.locked then return end
                tile.rotation = (tile.rotation + 1) % 4
                btn.Text = glyph_for(tile)
                if check_solved() then win() end
            end)
        end
    end

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Pipe reroute cancelled.", 3) end
        cleanup()
    end)

    local time_elapsed = 0
    timer_conn = RunService.Heartbeat:Connect(function(dt)
        if game_over then return end
        time_elapsed = time_elapsed + dt
        local left = TIME_LIMIT - time_elapsed
        if left <= 0 then
            timer_label.Text = "00:00"
            fail("Time's up!")
            return
        end
        local mins = math.floor(left / 60)
        local secs = math.floor(left % 60)
        timer_label.Text = string.format("%02d:%02d", mins, secs)
        if left <= 5 then timer_label.TextColor3 = RED end
    end)

    if check_solved() then win() end
end

g.steady_hand_minigame = function()
    if g.steady_hand_cooldown and tick() - g.steady_hand_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.steady_hand_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local preset = get_preset("steady")
    local DARK = Color3.fromRGB(14, 14, 16)
    local ORANGE = Color3.fromRGB(230, 140, 40)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local RED = Color3.fromRGB(200, 60, 60)
    local GREEN = Color3.fromRGB(60, 200, 100)
    local MUTED = Color3.fromRGB(90, 90, 100)
    local DRIFT_FORCE = preset.drift_force
    local ZONE_WIDTH = preset.zone_width
    local HOLD_DURATION = preset.hold_duration
    local TIME_LIMIT = preset.time_limit
    local needle_pos = 0.5
    local velocity = 0
    local holding = false
    local progress = 0
    local game_over = false
    local timer_conn = nil
    local heartbeat_conn = nil

    if CoreGui:FindFirstChild("SteadyHandGUI") then CoreGui.SteadyHandGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "SteadyHandGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 360, 0, 260)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local fstroke = Instance.new("UIStroke", frame)
    fstroke.Color = ORANGE
    fstroke.Thickness = 1

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "// STEADY HAND //"
    title.TextColor3 = ORANGE
    title.Font = Enum.Font.Code
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local timer_label = Instance.new("TextLabel")
    timer_label.Size = UDim2.new(0.2, 0, 0, 36)
    timer_label.Position = UDim2.new(0.72, 0, 0, 6)
    timer_label.BackgroundTransparency = 1
    timer_label.Text = "00:" .. string.format("%02d", TIME_LIMIT)
    timer_label.TextColor3 = WHITE
    timer_label.Font = Enum.Font.Code
    timer_label.TextSize = 15
    timer_label.TextXAlignment = Enum.TextXAlignment.Right
    timer_label.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 8)
    cancel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.BorderSizePixel = 0
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)

    local bar_bg = Instance.new("Frame")
    bar_bg.Size = UDim2.new(1, -40, 0, 40)
    bar_bg.Position = UDim2.new(0, 20, 0, 60)
    bar_bg.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    bar_bg.BorderSizePixel = 0
    bar_bg.Parent = frame
    Instance.new("UICorner", bar_bg).CornerRadius = UDim.new(0, 10)

    local zone = Instance.new("Frame")
    zone.Size = UDim2.new(ZONE_WIDTH, 0, 1, 0)
    zone.Position = UDim2.new(0.5 - ZONE_WIDTH / 2, 0, 0, 0)
    zone.BackgroundColor3 = GREEN
    zone.BackgroundTransparency = 0.6
    zone.BorderSizePixel = 0
    zone.Parent = bar_bg
    Instance.new("UICorner", zone).CornerRadius = UDim.new(0, 10)

    local needle = Instance.new("Frame")
    needle.Size = UDim2.new(0, 6, 1, 10)
    needle.AnchorPoint = Vector2.new(0.5, 0.5)
    needle.Position = UDim2.new(needle_pos, 0, 0.5, 0)
    needle.BackgroundColor3 = WHITE
    needle.BorderSizePixel = 0
    needle.Parent = bar_bg
    Instance.new("UICorner", needle).CornerRadius = UDim.new(0, 3)

    local progress_bg = Instance.new("Frame")
    progress_bg.Size = UDim2.new(1, -40, 0, 14)
    progress_bg.Position = UDim2.new(0, 20, 0, 116)
    progress_bg.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    progress_bg.BorderSizePixel = 0
    progress_bg.Parent = frame
    Instance.new("UICorner", progress_bg).CornerRadius = UDim.new(0, 8)

    local progress_fill = Instance.new("Frame")
    progress_fill.Size = UDim2.new(0, 0, 1, 0)
    progress_fill.BackgroundColor3 = GREEN
    progress_fill.BorderSizePixel = 0
    progress_fill.Parent = progress_bg
    Instance.new("UICorner", progress_fill).CornerRadius = UDim.new(0, 8)

    local hint_label = Instance.new("TextLabel")
    hint_label.Size = UDim2.new(1, -40, 0, 18)
    hint_label.Position = UDim2.new(0, 20, 0, 138)
    hint_label.BackgroundTransparency = 1
    hint_label.Text = "Hold STEADY to keep the needle in the zone"
    hint_label.TextColor3 = MUTED
    hint_label.Font = Enum.Font.Code
    hint_label.TextSize = 11
    hint_label.TextXAlignment = Enum.TextXAlignment.Center
    hint_label.Parent = frame

    local steady_btn = Instance.new("TextButton")
    steady_btn.Size = UDim2.new(0, 160, 0, 44)
    steady_btn.AnchorPoint = Vector2.new(0.5, 0)
    steady_btn.Position = UDim2.new(0.5, 0, 0, 168)
    steady_btn.BackgroundColor3 = Color3.fromRGB(40, 30, 16)
    steady_btn.Text = "STEADY"
    steady_btn.Font = Enum.Font.GothamBold
    steady_btn.TextSize = 14
    steady_btn.TextColor3 = ORANGE
    steady_btn.BorderSizePixel = 0
    steady_btn.Parent = frame
    Instance.new("UICorner", steady_btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", steady_btn).Color = ORANGE

    local function cleanup()
        if timer_conn then timer_conn:Disconnect() end
        if heartbeat_conn then heartbeat_conn:Disconnect() end
        if gui then gui:Destroy() end
        getgenv().Keybind_Input_Disabled_For_Mini_Game = false
    end

    local function win()
        game_over = true
        g.steady_hand_cooldown = tick()
        if g.notify then g.notify("Success", "Held steady!", 5) end
        task.delay(0.5, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then g.notify("Error", msg or "Hand slipped!", 5) end
        task.delay(0.5, cleanup)
    end

    steady_btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            holding = true
        end
    end)

    steady_btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            holding = false
        end
    end)

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Steady hand cancelled.", 3) end
        cleanup()
    end)

    heartbeat_conn = RunService.Heartbeat:Connect(function(dt)
        if game_over then return end
        local drift = (math.random() - 0.5) * DRIFT_FORCE
        velocity = velocity + drift * dt
        if holding then
            velocity = velocity + (0.5 - needle_pos) * DRIFT_FORCE * 1.2 * dt
        end
        velocity = velocity * 0.96
        needle_pos = math.clamp(needle_pos + velocity * dt, 0, 1)
        needle.Position = UDim2.new(needle_pos, 0, 0.5, 0)

        local zone_min = 0.5 - ZONE_WIDTH / 2
        local zone_max = 0.5 + ZONE_WIDTH / 2
        if needle_pos >= zone_min and needle_pos <= zone_max then
            progress = progress + dt
            progress_fill.BackgroundColor3 = GREEN
        else
            progress = math.max(0, progress - dt * 2)
            progress_fill.BackgroundColor3 = RED
        end
        progress_fill.Size = UDim2.new(math.clamp(progress / HOLD_DURATION, 0, 1), 0, 1, 0)
        if progress >= HOLD_DURATION then
            win()
        end
    end)

    local time_elapsed = 0
    timer_conn = RunService.Heartbeat:Connect(function(dt)
        if game_over then return end
        time_elapsed = time_elapsed + dt
        local left = TIME_LIMIT - time_elapsed
        if left <= 0 then
            timer_label.Text = "00:00"
            fail("Time's up!")
            return
        end
        local mins = math.floor(left / 60)
        local secs = math.floor(left % 60)
        timer_label.Text = string.format("%02d:%02d", mins, secs)
        if left <= 5 then timer_label.TextColor3 = RED end
    end)
end

g.rhythm_splice_minigame = function()
    if g.rhythm_splice_cooldown and tick() - g.rhythm_splice_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.rhythm_splice_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local preset = get_preset("rhythm")
    local DARK = Color3.fromRGB(12, 12, 18)
    local PINK = Color3.fromRGB(230, 80, 160)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local MUTED = Color3.fromRGB(90, 90, 100)
    local NOTE_COUNT = preset.note_count
    local NOTE_SPEED = preset.note_speed
    local HIT_WINDOW = preset.hit_window
    local MAX_MISSES = preset.max_misses
    local spawn_interval = 1.1
    local notes_spawned = 0
    local notes_resolved = 0
    local misses = 0
    local active_notes = {}
    local game_over = false
    local elapsed = 0
    local next_spawn = 0
    local render_conn = nil
    if CoreGui:FindFirstChild("RhythmSpliceGUI") then CoreGui.RhythmSpliceGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "RhythmSpliceGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 220)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local fstroke = Instance.new("UIStroke", frame)
    fstroke.Color = PINK
    fstroke.Thickness = 1

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, 0, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "// RHYTHM SPLICE //"
    title.TextColor3 = PINK
    title.Font = Enum.Font.Code
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local status_label = Instance.new("TextLabel")
    status_label.Size = UDim2.new(0.35, 0, 0, 36)
    status_label.Position = UDim2.new(0.62, 0, 0, 6)
    status_label.BackgroundTransparency = 1
    status_label.Text = "Misses: 0 / " .. MAX_MISSES
    status_label.TextColor3 = WHITE
    status_label.Font = Enum.Font.Code
    status_label.TextSize = 12
    status_label.TextXAlignment = Enum.TextXAlignment.Right
    status_label.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 8)
    cancel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.BorderSizePixel = 0
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)

    local lane = Instance.new("Frame")
    lane.Size = UDim2.new(1, -40, 0, 60)
    lane.Position = UDim2.new(0, 20, 0, 60)
    lane.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    lane.BorderSizePixel = 0
    lane.ClipsDescendants = true
    lane.Parent = frame
    Instance.new("UICorner", lane).CornerRadius = UDim.new(0, 10)

    local hit_line = Instance.new("Frame")
    hit_line.Size = UDim2.new(0, 4, 1, 0)
    hit_line.Position = UDim2.new(0, 40, 0, 0)
    hit_line.BackgroundColor3 = PINK
    hit_line.BorderSizePixel = 0
    hit_line.Parent = lane
    Instance.new("UICorner", hit_line).CornerRadius = UDim.new(0, 2)

    local hit_btn = Instance.new("TextButton")
    hit_btn.Size = UDim2.new(0, 160, 0, 44)
    hit_btn.AnchorPoint = Vector2.new(0.5, 0)
    hit_btn.Position = UDim2.new(0.5, 0, 0, 140)
    hit_btn.BackgroundColor3 = Color3.fromRGB(40, 16, 30)
    hit_btn.Text = "HIT"
    hit_btn.Font = Enum.Font.GothamBold
    hit_btn.TextSize = 16
    hit_btn.TextColor3 = PINK
    hit_btn.BorderSizePixel = 0
    hit_btn.Parent = frame
    Instance.new("UICorner", hit_btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", hit_btn).Color = PINK

    local function cleanup()
        if render_conn then render_conn:Disconnect() end
        if gui then gui:Destroy() end
        getgenv().Keybind_Input_Disabled_For_Mini_Game = false
    end

    local function win()
        game_over = true
        g.rhythm_splice_cooldown = tick()
        if g.notify then g.notify("Success", "Perfect splice!", 5) end
        task.delay(0.5, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then g.notify("Error", msg or "Splice failed!", 5) end
        task.delay(0.5, cleanup)
    end

    local function register_miss()
        misses = misses + 1
        notes_resolved = notes_resolved + 1
        status_label.Text = "Misses: " .. misses .. " / " .. MAX_MISSES
        if misses >= MAX_MISSES then
            fail("Too many misses!")
        elseif notes_resolved >= NOTE_COUNT and not game_over then
            win()
        end
    end

    local function register_hit()
        notes_resolved = notes_resolved + 1
        if notes_resolved >= NOTE_COUNT and not game_over then win() end
    end

    hit_btn.MouseButton1Click:Connect(function()
        if game_over then return end
        local best_index = nil
        local best_dist = math.huge
        for i, note in ipairs(active_notes) do
            local dist = math.abs(note.frame.Position.X.Offset - 40)
            if dist < best_dist then
                best_dist = dist
                best_index = i
            end
        end
        if best_index and best_dist <= HIT_WINDOW * NOTE_SPEED then
            active_notes[best_index].frame:Destroy()
            table.remove(active_notes, best_index)
            register_hit()
        end
    end)

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Rhythm splice cancelled.", 3) end
        cleanup()
    end)

    render_conn = RunService.Heartbeat:Connect(function(dt)
        if game_over then return end
        elapsed = elapsed + dt
        local lane_width = lane.AbsoluteSize.X

        if notes_spawned < NOTE_COUNT and elapsed >= next_spawn then
            notes_spawned = notes_spawned + 1
            next_spawn = elapsed + spawn_interval
            local note = Instance.new("Frame")
            note.Size = UDim2.new(0, 26, 0, 26)
            note.AnchorPoint = Vector2.new(0.5, 0.5)
            note.Position = UDim2.new(0, lane_width - 20, 0.5, 0)
            note.BackgroundColor3 = PINK
            note.BorderSizePixel = 0
            note.Parent = lane
            Instance.new("UICorner", note).CornerRadius = UDim.new(0.5, 0)
            table.insert(active_notes, {frame = note, spawn_time = elapsed})
        end

        for i = #active_notes, 1, -1 do
            local note = active_notes[i]
            local traveled = NOTE_SPEED * (elapsed - note.spawn_time)
            local new_x = (lane_width - 20) - traveled
            note.frame.Position = UDim2.new(0, new_x, 0.5, 0)
            if new_x < 40 - HIT_WINDOW * NOTE_SPEED then
                note.frame:Destroy()
                table.remove(active_notes, i)
                register_miss()
            end
        end
    end)
end

g.card_recall_minigame = function()
    if g.card_recall_cooldown and tick() - g.card_recall_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.card_recall_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local preset = get_preset("recall")
    local DARK = Color3.fromRGB(14, 12, 18)
    local PURPLE = Color3.fromRGB(160, 100, 220)
    local DIM_PURPLE = Color3.fromRGB(50, 40, 70)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local RED = Color3.fromRGB(200, 60, 60)
    local GREEN = Color3.fromRGB(60, 200, 100)
    local CARD_COUNT = preset.card_count
    local SHOW_TIME = preset.show_time
    local GRID_COLS = preset.grid_cols
    local reveal_order = {}
    for i = 1, CARD_COUNT do reveal_order[i] = i end
    for i = CARD_COUNT, 2, -1 do
        local j = math.random(1, i)
        reveal_order[i], reveal_order[j] = reveal_order[j], reveal_order[i]
    end

    local player_index = 1
    local accepting_input = false
    local game_over = false
    if CoreGui:FindFirstChild("CardRecallGUI") then CoreGui.CardRecallGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "CardRecallGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    getgenv().Keybind_Input_Disabled_For_Mini_Game = true
    local grid_rows = math.ceil(CARD_COUNT / GRID_COLS)
    local cell_size = 64
    local grid_width = GRID_COLS * cell_size
    local grid_height = grid_rows * cell_size
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, grid_width + 40, 0, grid_height + 110)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.BackgroundColor3 = DARK
    frame.BorderSizePixel = 0
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
    local fstroke = Instance.new("UIStroke", frame)
    fstroke.Color = PURPLE
    fstroke.Thickness = 1

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "// VAULT RECALL //"
    title.TextColor3 = PURPLE
    title.Font = Enum.Font.Code
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local cancel = Instance.new("TextButton")
    cancel.Size = UDim2.new(0, 28, 0, 28)
    cancel.Position = UDim2.new(1, -34, 0, 8)
    cancel.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    cancel.Text = "X"
    cancel.TextScaled = true
    cancel.Font = Enum.Font.GothamBold
    cancel.TextColor3 = WHITE
    cancel.BorderSizePixel = 0
    cancel.Parent = frame
    Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 6)

    local status_label = Instance.new("TextLabel")
    status_label.Size = UDim2.new(1, -20, 0, 22)
    status_label.Position = UDim2.new(0, 10, 0, 44)
    status_label.BackgroundTransparency = 1
    status_label.Text = "Watch the sequence..."
    status_label.TextColor3 = DIM_PURPLE
    status_label.Font = Enum.Font.Code
    status_label.TextSize = 12
    status_label.TextXAlignment = Enum.TextXAlignment.Center
    status_label.Parent = frame

    local grid_frame = Instance.new("Frame")
    grid_frame.Size = UDim2.new(0, grid_width, 0, grid_height)
    grid_frame.AnchorPoint = Vector2.new(0.5, 0)
    grid_frame.Position = UDim2.new(0.5, 0, 0, 74)
    grid_frame.BackgroundTransparency = 1
    grid_frame.Parent = frame

    local card_buttons = {}
    for i = 1, CARD_COUNT do
        local row = math.floor((i - 1) / GRID_COLS)
        local col = (i - 1) % GRID_COLS
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, cell_size - 8, 0, cell_size - 8)
        btn.Position = UDim2.new(0, col * cell_size, 0, row * cell_size)
        btn.BackgroundColor3 = DIM_PURPLE
        btn.Text = "?"
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.TextColor3 = WHITE
        btn.BorderSizePixel = 0
        btn.Parent = grid_frame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        card_buttons[i] = btn
    end

    local function cleanup() getgenv().Keybind_Input_Disabled_For_Mini_Game = false if gui then gui:Destroy() end end
    local function win()
        game_over = true
        g.card_recall_cooldown = tick()
        if g.notify then g.notify("Success", "Vault sequence recalled!", 5) end
        task.delay(0.4, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then g.notify("Error", msg or "Wrong card!", 5) end
        task.delay(0.4, cleanup)
    end

    local function show_sequence(step)
        if step > CARD_COUNT then
            status_label.Text = "Your turn! Repeat the sequence"
            status_label.TextColor3 = WHITE
            accepting_input = true
            return
        end
        local card_index = reveal_order[step]
        local btn = card_buttons[card_index]
        btn.BackgroundColor3 = PURPLE
        btn.Text = tostring(step)
        task.delay(SHOW_TIME, function()
            if game_over then return end
            btn.BackgroundColor3 = DIM_PURPLE
            btn.Text = "?"
            task.delay(0.15, function()
                show_sequence(step + 1)
            end)
        end)
    end

    for i, btn in ipairs(card_buttons) do
        btn.MouseButton1Click:Connect(function()
            if game_over or not accepting_input then return end
            if reveal_order[player_index] == i then
                btn.BackgroundColor3 = GREEN
                player_index = player_index + 1
                if player_index > CARD_COUNT then
                    win()
                end
            else
                btn.BackgroundColor3 = RED
                fail("Wrong card!")
            end
        end)
    end

    cancel.MouseButton1Click:Connect(function()
        if g.notify then g.notify("Info", "Vault recall cancelled.", 3) end
        cleanup()
    end)

    task.delay(0.6, function() show_sequence(1) end)
end

g.open_minigame_menu = function()
    if CoreGui:FindFirstChild("MinigameMenuGUI") and CoreGui:FindFirstChild("MinigameMenuGUI"):IsA("ScreenGui") then CoreGui.MinigameMenuGUI.Enabled = true return end
    local DARK        = Color3.fromRGB(18, 18, 18)
    local SURFACE     = Color3.fromRGB(26, 26, 26)
    local BORDER      = Color3.fromRGB(50, 50, 50)
    local WHITE       = Color3.fromRGB(240, 240, 240)
    local MUTED       = Color3.fromRGB(140, 140, 140)
    local GOLD        = Color3.fromRGB(255, 200, 50)
    local GREEN_C     = Color3.fromRGB(60, 180, 100)
    local RED_C       = Color3.fromRGB(200, 70, 70)
    local YELLOW_C    = Color3.fromRGB(220, 160, 30)
    local GAMES = {
        {
            key         = "memory",
            name        = "Memory Grid",
            sub         = "Memorize the pattern, then tap the tiles",
            desc        = "A 5x5 grid lights up several tiles briefly. Memorize their positions, then click every highlighted tile before making too many mistakes. Difficulty changes show time, mistake tolerance, and pattern size.",
            fn          = function() g.Memory_Mini_Game_GUI() end,
        },
        {
            key         = "reaction",
            name        = "Reaction Time",
            sub         = "Land the moving bar in the zone repeatedly",
            desc        = "A bar bounces left and right at increasing speed. Click when it overlaps the purple target zone. Difficulty changes required wins, miss tolerance, starting speed, and how tight a 'PERFECT' hit needs to be.",
            fn          = function() g.reaction_time_minigame() end,
        },
        {
            key         = "keypad",
            name        = "Keypad Hack",
            sub         = "Crack the digit code within your attempts",
            desc        = "A secret numeric code is generated. Enter your guess and receive hints — correct position vs. correct number. Difficulty changes code length and how many attempts you get before lockout.",
            fn          = function() g.keypad_minigame() end,
        },
        {
            key         = "hacking",
            name        = "Breach Protocol",
            sub         = "Input the target sequence from the grid",
            desc        = "A Cyberpunk-style matrix grid. Alternate selecting columns and rows to build a character sequence matching the target before time runs out. Difficulty changes sequence length, timer, and grid size.",
            fn          = function() g.hacking_minigame() end,
        },
        {
            key         = "safe",
            name        = "Safe Cracker",
            sub         = "Hit target notches on the spinning dial",
            desc        = "A dial spins at increasing speed across 20 notches. Click CRACK when the marker lands on the target notch for each step. Difficulty changes step count, dial speed, timer, and hit tolerance.",
            fn          = function() g.safe_cracker_minigame() end,
        },
        {
            key         = "wire",
            name        = "Wire Cutter",
            sub         = "Cut the correct wire using the intel clues",
            desc        = "Wires are presented with partial intel clues about which ones are dangerous. Deduce the safe wire and cut it before the timer runs out. Difficulty changes wire count, timer, and how many clues you're given.",
            fn          = function() g.wire_cutter_minigame() end,
        },
        {
            key         = "simon",
            name        = "Simon Says",
            sub         = "Repeat the growing color sequence",
            desc        = "Four colored buttons flash a growing sequence each round. Watch carefully then repeat it back in order. Difficulty changes rounds needed to win and how fast the sequence flashes.",
            fn          = function() g.simon_says_minigame() end,
        },
        {
            key = "lockpick", name = "Lockpick", sub = "Turn the pick into the sweet spot without snapping",
            desc = "A dial sweeps continuously around a pin lock. Hold to build tension while timing your click for when the pick lines up with the sweet spot. Too much tension and the pick snaps. Difficulty changes pin count, sweet spot size, and dial speed.",
            fn = function() g.lockpick_minigame() end,
        },
        {
            key = "laser", name = "Laser Grid", sub = "Advance through rows without tripping a beam",
            desc = "A moving laser sweeps across each row. Click Advance to move up one row when the beam isn't on your position. Difficulty changes row count, beam speed, and hazard margin.",
            fn = function() g.laser_grid_minigame() end,
        },
        {
            key = "signal", name = "Signal Triangulation", sub = "Drag the slider to find the hidden signal",
            desc = "Drag the handle along the bar and watch the signal strength readout to home in on a hidden target, then lock it in. Difficulty changes tolerance and whether the target drifts.",
            fn = function() g.signal_triangulation_minigame() end,
        },
        {
            key = "pipe", name = "Pipe Reroute", sub = "Rotate tiles to connect the circuit",
            desc = "A grid of pipe tiles needs rotating to form a connected path from top-left to bottom-right. Some tiles are locked in place. Difficulty changes grid size, locked tile count, and timer.",
            fn = function() g.pipe_reroute_minigame() end,
        },
        {
            key = "steady", name = "Steady Hand", sub = "Hold the needle in the zone",
            desc = "A needle drifts on its own. Hold Steady to counter the drift and keep it inside the target zone for a sustained duration. Difficulty changes drift force, zone width, and hold time.",
            fn = function() g.steady_hand_minigame() end,
        },
        {
            key = "rhythm", name = "Rhythm Splice", sub = "Hit the notes as they reach the line",
            desc = "Notes scroll toward a hit line. Click Hit when one lines up. Difficulty changes note count, speed, and hit window.",
            fn = function() g.rhythm_splice_minigame() end,
        },
        {
            key = "recall", name = "Vault Recall", sub = "Reproduce the flash order on the card grid",
            desc = "Cards flash in a hidden order. Watch closely, then click them back in the same sequence. Difficulty changes card count and flash speed.",
            fn = function() g.card_recall_minigame() end,
        },
    }

    local Is_Mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local gui = Instance.new("ScreenGui")
    gui.Name = "MinigameMenuGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local outer = Instance.new("Frame")
    outer.AnchorPoint = Vector2.new(0.5, 0.5)
    outer.Position = UDim2.fromScale(0.5, 0.5)
    if not Is_Mobile then
        outer.Size = UDim2.new(0, 360, 0, 520)
    else
        outer.Size = UDim2.new(0, 360, 0, 350) -- mobile size since it needs to shrink on mobile screens.
    end
    outer.BackgroundColor3 = DARK
    outer.BorderSizePixel = 0
    outer.Parent = gui
    Instance.new("UICorner", outer).CornerRadius = UDim.new(0, 14)

    local stroke = Instance.new("UIStroke", outer)
    stroke.Color = BORDER
    stroke.Thickness = 1

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 42)
    header.BackgroundColor3 = SURFACE
    header.BorderSizePixel = 0
    header.Parent = outer

    local hcorner = Instance.new("UICorner", header)
    hcorner.CornerRadius = UDim.new(0, 14)

    local hfix = Instance.new("Frame")
    hfix.Size = UDim2.new(1, 0, 0.5, 0)
    hfix.Position = UDim2.fromScale(0, 0.5)
    hfix.BackgroundColor3 = SURFACE
    hfix.BorderSizePixel = 0
    hfix.Parent = header

    local title_lbl = Instance.new("TextLabel")
    title_lbl.Size = UDim2.new(1, -125, 1, 0)
    title_lbl.Position = UDim2.new(0, 14, 0, 0)
    title_lbl.BackgroundTransparency = 1
    title_lbl.Text = "Flames Hub | Mini-Games"
    title_lbl.TextScaled = false
    title_lbl.Font = Enum.Font.GothamBold
    title_lbl.TextSize = 14
    title_lbl.TextColor3 = WHITE
    title_lbl.TextXAlignment = Enum.TextXAlignment.Left
    title_lbl.Parent = header

    if dragify then dragify(outer) end
    local minimized = false
    local content_frame
    local function make_header_btn(text, x_offset)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 34, 0, 24)
        btn.Position = UDim2.new(1, x_offset, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        btn.Text = text
        btn.TextColor3 = MUTED
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.BorderSizePixel = 0
        btn.Parent = header
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        return btn
    end

    local close_btn = make_header_btn("X", -45)
    local minimize_btn = make_header_btn("-", -80)
    local difficulty_btn = make_header_btn("⚙", -115)
    close_btn.MouseButton1Click:Connect(function() gui.Enabled = false end)
    difficulty_btn.MouseButton1Click:Connect(function() g.open_difficulty_editor() end)
    local function build_content()
        if content_frame then content_frame:Destroy() end
        content_frame = Instance.new("ScrollingFrame")
        content_frame.Size = UDim2.new(1, 0, 1, -42)
        content_frame.Position = UDim2.new(0, 0, 0, 42)
        content_frame.BackgroundTransparency = 1
        content_frame.BorderSizePixel = 0
        content_frame.ScrollBarThickness = 3
        content_frame.CanvasSize = UDim2.new(0, 0, 0, 0)
        content_frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        content_frame.Parent = outer

        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 8)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Parent = content_frame

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
        pad.Parent = content_frame

        for i, picked_game in ipairs(GAMES) do
            local difficulty = g.minigame_difficulty[picked_game.key] or "Medium"
            local diff_color = DIFFICULTY_COLOR[difficulty]
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 110)
            card.BackgroundColor3 = SURFACE
            card.BorderSizePixel = 0
            card.LayoutOrder = i
            card.Parent = content_frame
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

            local cstroke = Instance.new("UIStroke", card)
            cstroke.Color = BORDER
            cstroke.Thickness = 0.5

            local name_lbl = Instance.new("TextLabel")
            name_lbl.Size = UDim2.new(1, -110, 0, 20)
            name_lbl.Position = UDim2.new(0, 12, 0, 10)
            name_lbl.BackgroundTransparency = 1
            name_lbl.Text = picked_game.name
            name_lbl.Font = Enum.Font.GothamBold
            name_lbl.TextSize = 13
            name_lbl.TextColor3 = WHITE
            name_lbl.TextXAlignment = Enum.TextXAlignment.Left
            name_lbl.Parent = card

            local diff_lbl = Instance.new("TextLabel")
            diff_lbl.Size = UDim2.new(0, 60, 0, 18)
            diff_lbl.Position = UDim2.new(1, -72, 0, 11)
            diff_lbl.BackgroundColor3 = diff_color
            diff_lbl.BackgroundTransparency = 0.75
            diff_lbl.Text = difficulty
            diff_lbl.Font = Enum.Font.GothamBold
            diff_lbl.TextSize = 11
            diff_lbl.TextColor3 = diff_color
            diff_lbl.BorderSizePixel = 0
            diff_lbl.Parent = card
            Instance.new("UICorner", diff_lbl).CornerRadius = UDim.new(0, 5)

            local sub_lbl = Instance.new("TextLabel")
            sub_lbl.Size = UDim2.new(1, -24, 0, 16)
            sub_lbl.Position = UDim2.new(0, 12, 0, 30)
            sub_lbl.BackgroundTransparency = 1
            sub_lbl.Text = picked_game.sub
            sub_lbl.Font = Enum.Font.Gotham
            sub_lbl.TextSize = 11
            sub_lbl.TextColor3 = MUTED
            sub_lbl.TextXAlignment = Enum.TextXAlignment.Left
            sub_lbl.Parent = card

            local desc_open = false
            local desc_lbl = Instance.new("TextLabel")
            desc_lbl.Size = UDim2.new(1, -24, 0, 0)
            desc_lbl.Position = UDim2.new(0, 12, 0, 112)
            desc_lbl.BackgroundTransparency = 1
            desc_lbl.Text = picked_game.desc
            desc_lbl.Font = Enum.Font.Gotham
            desc_lbl.TextSize = 11
            desc_lbl.TextColor3 = MUTED
            desc_lbl.TextWrapped = true
            desc_lbl.TextXAlignment = Enum.TextXAlignment.Left
            desc_lbl.TextYAlignment = Enum.TextYAlignment.Top
            desc_lbl.Visible = false
            desc_lbl.Parent = card

            local desc_btn = Instance.new("TextButton")
            desc_btn.Size = UDim2.new(0, 100, 0, 24)
            desc_btn.Position = UDim2.new(0, 12, 0, 76)
            desc_btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            desc_btn.Text = "(i) Description"
            desc_btn.Font = Enum.Font.Gotham
            desc_btn.TextSize = 11
            desc_btn.TextColor3 = MUTED
            desc_btn.BorderSizePixel = 0
            desc_btn.Parent = card
            Instance.new("UICorner", desc_btn).CornerRadius = UDim.new(0, 6)

            local play_btn = Instance.new("TextButton")
            play_btn.Size = UDim2.new(0, 70, 0, 24)
            play_btn.Position = UDim2.new(1, -82, 0, 76)
            play_btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            play_btn.Text = "Play"
            play_btn.Font = Enum.Font.GothamBold
            play_btn.TextSize = 12
            play_btn.TextColor3 = WHITE
            play_btn.BorderSizePixel = 0
            play_btn.Parent = card
            Instance.new("UICorner", play_btn).CornerRadius = UDim.new(0, 6)

            desc_btn.MouseButton1Click:Connect(function()
                desc_open = not desc_open
                if desc_open then
                    local available_width = card.AbsoluteSize.X - 24
                    local text_bounds = TextService:GetTextSize(
                        picked_game.desc,
                        desc_lbl.TextSize,
                        desc_lbl.Font,
                        Vector2.new(available_width, math.huge)
                    )
                    desc_lbl.Size = UDim2.new(1, -24, 0, text_bounds.Y)
                    desc_lbl.Visible = true
                    card.Size = UDim2.new(1, 0, 0, 112 + text_bounds.Y + 16)
                    desc_btn.Text = "(X) Hide"
                else
                    desc_lbl.Visible = false
                    card.Size = UDim2.new(1, 0, 0, 110)
                    desc_btn.Text = "(i) Description"
                end
            end)

            play_btn.MouseButton1Click:Connect(function()
                gui:Destroy()
                task.wait(0.05)
                picked_game.fn()
            end)
        end
    end

    build_content()
    minimize_btn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            outer.Size = UDim2.new(0, 360, 0, 42)
            if content_frame then content_frame.Visible = false end
            minimize_btn.Text = "+"
        else
            outer.Size = UDim2.new(0, 360, 0, 520)
            if content_frame then content_frame.Visible = true end
            minimize_btn.Text = "-"
        end
    end)

    if getgenv().Keybind_Toggle_Initialized then pcall(function() getgenv().Keybind_Toggle_Initialized:Disconnect() end) task.wait() getgenv().Keybind_Toggle_Initialized = nil end
    wait(0.25)
    local Is_Mobile = UserInputService.TouchEnabled
    if not Is_Mobile then
        getgenv().Keybind_Toggle_Initialized = UserInputService.InputBegan:Connect(function(Input, Game_Processed_Event)
            if Game_Processed_Event then return end
            if Input.KeyCode == Enum.KeyCode.RightControl and getgenv().Keybind_Input_Disabled_For_Mini_Game == false then
                if gui and gui:IsA("ScreenGui") then gui.Enabled = not gui.Enabled end
            end
        end)
    end
end

local ok = pcall(function() get_or_set("Terrain", findinstance("Terrain")) end)
if not ok and g.notify then
    g.notify("Warning", "Failed to resolve Terrain, some features may not work.", 5)
end
get_or_set("Camera", workspace.CurrentCamera)
local lp = game.Players.LocalPlayer
get_or_set("LocalPlayer", lp)
get_or_set("Backpack", findplayerchild(lp, "Backpack"))
get_or_set("PlayerGui", findplayerchild(lp, "PlayerGui"))
get_or_set("PlayerScripts", findplayerchild(lp, "PlayerScripts"))
get_or_set("Character", nil)
get_or_set("get_player_gui", PlayerGui)
get_or_set("get_player_scripts", PlayerScripts)
get_or_set("get_player_backpack", Backpack)

if not getgenv().Anti_Idle_Controller_Loaded then
    getgenv().Anti_Idle_Controller_Loaded = true
    if getconnections or get_signal_cons then
        local gc = getconnections or get_signal_cons
        local idle = lp.Idled

        idle:Connect(function()
            task.wait()
            for _,v in pairs(gc(idle)) do
                if v.Disable then
                    v.Disable(v)
                elseif v.Disconnect then
                    v.Disconnect(v)
                end
            end
        end)
    end
end

getgenv().getRoot = getgenv().getRoot or function(char)
    local name_of_char = tostring(char.Name)
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum and hum.RootPart then return hum.RootPart end
	return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or get_root(Players:FindFirstChild(name_of_char), 5)
end

getgenv().resolve_character = function(character, timeout)
	local start = tick()
	while tick() - start < timeout do
		if not character or not character.Parent then return nil end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local head = character:FindFirstChild("Head")
		local root = getRoot(character)
		if root and root.Parent ~= character then root = nil end
		if humanoid and head and root then return {character = character, humanoid = humanoid, head = head, root = root} end
		task.wait(0.03)
	end

	return nil
end

getgenv().register_character = function(character)
	local timeout = Players.RespawnTime + Random.new():NextNumber(0.5, 3)
	local data = resolve_character(character, timeout)
	if not data then return end

	getgenv().Character = data.character
	getgenv().Humanoid = data.humanoid
	getgenv().Head = data.head
	getgenv().HumanoidRootPart = data.root
end

getgenv().setup_local_character = function()
	local player = Players.LocalPlayer
	if not player then return end
	if player.Character then task.spawn(getgenv().register_character, player.Character) end
	player.CharacterAdded:Connect(function(character) task.spawn(getgenv().register_character, character) end)
end

getgenv().setup_local_character()
