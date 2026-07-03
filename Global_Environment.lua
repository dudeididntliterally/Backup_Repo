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

    if interval < 0.03 then
        interval = 0.05
    end

    if typeof(condition) ~= "function" then
        local target = condition
        condition = function()
            return (typeof(target) == "Instance" and target.Parent ~= nil) or target
        end
    end

    local tries = 0

    repeat
        task.wait(interval)
        tries += 1
    until condition() or tries >= max_tries
    return condition() and true or false
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
        if not ok then
            return false
        end
        return status ~= "dead"
    end

    if type(input) == "string" then
        local list = lib._connections[input]
        if not list then
            return false
        end

        for _, item in ipairs(list) do
            if type(item) == "thread" then
                local ok, status = pcall(coroutine.status, item)
                if ok and status ~= "dead" then
                    return true
                end
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
    if not t or t <= 0 then safe_wrapper("RunService").Heartbeat:Wait() return end
    local ok = pcall(task.wait, t)
    if not ok then safe_wrapper("RunService").Heartbeat:Wait() end
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
getgenv().notify=getgenv().notify or function(title,msg,dur) local fixed_title=format_title(title) NotifyLib:External_Notification(fixed_title,tostring(msg),tonumber(dur)) end
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
