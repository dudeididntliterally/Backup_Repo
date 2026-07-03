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
