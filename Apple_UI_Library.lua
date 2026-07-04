local TweenService = cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
local Debris = cloneref and cloneref(game:GetService("Debris")) or game:GetService("Debris")
local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local RunService = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local UserInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local lib = {}
local sections = {}
local workareas = {}
local notifs = {}
local visible = true
local dbcooper = false
local function tp(ins, pos, time, thing) TweenService:Create(ins, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),{Position = pos}):Play() end
local has_gethui = typeof(get_hui) == "function"
local has_gethidden = typeof(get_hidden_gui) == "function"
if not has_gethui and not has_gethidden and not g.roblox_hidden_gui_location then
    g.roblox_hidden_gui_location = g.roblox_hidden_gui_location or nil
    if not g.roblox_hidden_gui_location then
        for _, v in ipairs(CoreGui:GetChildren()) do
            if v:IsA("ScreenGui") and v.Name == "RobloxGui" then
                g.roblox_hidden_gui_location = v
            end
        end
    end

    g.get_hui = function()
        if g.roblox_hidden_gui_location and g.roblox_hidden_gui_location:IsA("ScreenGui") then
            return g.roblox_hidden_gui_location
        else
            return CoreGui
        end
    end

    g.get_hidden_gui = function()
        if g.roblox_hidden_gui_location and g.roblox_hidden_gui_location:IsA("ScreenGui") then
            return g.roblox_hidden_gui_location
        else
            return CoreGui
        end
    end
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

local uis = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local ts = cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
local rs  = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService") or safe_wrapper("RunService")

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
wait(0.25)
function lib:init(ti, dosplash, visiblekey, deleteprevious)
    local function find_existing()
        local cg = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
        return cg:FindFirstChild("Apple_UI")
    end

    if deleteprevious then
        local existing = find_existing()
        if existing then
            local main = existing:FindFirstChild("main")
            if main then
                main:TweenPosition(main.Position + UDim2.new(0,0,2,0), "InOut", "Quart", 0.5)
            end
            Debris:AddItem(existing, 1)
        end
    end

    scrgui = Instance.new("ScreenGui")
    scrgui.Name = "Apple_UI"
    local core_gui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    scrgui.Parent = core_gui

    if dosplash then
        local splash = Instance.new("Frame")
        splash.Name = "splash"
        splash.Parent = scrgui
        splash.AnchorPoint = Vector2.new(0.5, 0.5)
        splash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        splash.BackgroundTransparency = 0.600
        splash.Position = UDim2.new(0.5, 0, 2, 0)
        splash.Size = UDim2.new(0, 340, 0, 340)
        splash.Visible = true
        splash.ZIndex = 40

        local uc_22 = Instance.new("UICorner")
        uc_22.CornerRadius = UDim.new(0, 18)
        uc_22.Parent = splash

        local sicon = Instance.new("ImageLabel")
        sicon.Name = "sicon"
        sicon.Parent = splash
        sicon.AnchorPoint = Vector2.new(0.5, 0.5)
        sicon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sicon.BackgroundTransparency = 1
        sicon.Position = UDim2.new(0.5, 0, 0.5, 0)
        sicon.Size = UDim2.new(0, 191, 0, 190)
        sicon.ZIndex = 40
        sicon.Image = "rbxassetid://12621719043"
        sicon.ScaleType = Enum.ScaleType.Fit
        sicon.TileSize = UDim2.new(1, 0, 20, 0)

        local ug = Instance.new("UIGradient")
        ug.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.01, Color3.fromRGB(61, 61, 61)), ColorSequenceKeypoint.new(0.47, Color3.fromRGB(41, 41, 41)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))}
        ug.Rotation = 90
        ug.Parent = sicon

        local sshadow = Instance.new("ImageLabel")
        sshadow.Name = "sshadow"
        sshadow.Parent = splash
        sshadow.AnchorPoint = Vector2.new(0.5, 0.5)
        sshadow.BackgroundTransparency = 1
        sshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        sshadow.Size = UDim2.new(1.20000005, 0, 1.20000005, 0)
        sshadow.ZIndex = 39
        sshadow.Image = "rbxassetid://313486536"
        sshadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        sshadow.ImageTransparency = 0.400
        sshadow.TileSize = UDim2.new(0, 1, 0, 1)
        splash:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "InOut", "Quart", 1)
        wait(2)
        splash:TweenPosition(UDim2.new(0.5, 0, 2, 0), "InOut", "Quart", 1)
        Debris:AddItem(splash, 1)
    end

    local main = Instance.new("Frame")
    main.Name = "main"
    main.Parent = scrgui
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    main.BackgroundTransparency = 0.150
    main.Position = UDim2.new(0.5, 0, 2, 0)
    main.Size = UDim2.new(0, 721, 0, 584)

    local uc = Instance.new("UICorner")
    uc.CornerRadius = UDim.new(0, 18)
    uc.Parent = main

    if getgenv().dragify and typeof(getgenv().dragify) == "function" then getgenv().dragify(main) end
    local workarea = Instance.new("Frame")
    workarea.Name = "workarea"
    workarea.Parent = main
    workarea.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    workarea.Position = UDim2.new(0.36403501, 0, 0, 0)
    workarea.Size = UDim2.new(0, 458, 0, 584)

    local uc_2 = Instance.new("UICorner")
    uc_2.CornerRadius = UDim.new(0, 18)
    uc_2.Parent = workarea

    local workareacornerhider = Instance.new("Frame")
    workareacornerhider.Name = "workareacornerhider"
    workareacornerhider.Parent = workarea
    workareacornerhider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    workareacornerhider.BorderSizePixel = 0
    workareacornerhider.Size = UDim2.new(0, 18, 0.99895674, 0)

    local ui_scale = Instance.new("UIScale")
    ui_scale.Parent = main
    local base_width = 721
    local base_height = 584
    local function update_ui_scale()
        local camera = workspace.CurrentCamera
        if not camera then return end
        local viewport = camera.ViewportSize
        local scale_x = (viewport.X * 0.92) / base_width
        local scale_y = (viewport.Y * 0.92) / base_height
        local scale = math.min(scale_x, scale_y, 1)
        ui_scale.Scale = scale
    end

    update_ui_scale()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(update_ui_scale)
    local search = Instance.new("Frame")
    search.Name = "search"
    search.Parent = main
    search.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    search.Position = UDim2.new(0.0256588068, 0, 0.0958904102, 0)
    search.Size = UDim2.new(0, 225, 0, 34)

    local uc_8 = Instance.new("UICorner")
    uc_8.CornerRadius = UDim.new(0, 9)
    uc_8.Parent = search

    local searchicon = Instance.new("ImageButton")
    searchicon.Name = "searchicon"
    searchicon.Parent = search
    searchicon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    searchicon.BackgroundTransparency = 1
    searchicon.BorderColor3 = Color3.fromRGB(27, 42, 53)
    searchicon.Position = UDim2.new(0.0379999988, -2, 0.138999999, 2)
    searchicon.Size = UDim2.new(0, 24, 0, 21)
    searchicon.Image = "rbxassetid://2804603863"
    searchicon.ImageColor3 = Color3.fromRGB(95, 95, 95)
    searchicon.ScaleType = Enum.ScaleType.Fit

    local searchtextbox = Instance.new("TextBox")
    searchtextbox.Name = "searchtextbox"
    searchtextbox.Parent = search
    searchtextbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    searchtextbox.BackgroundTransparency = 1
    searchtextbox.ClipsDescendants = true
    searchtextbox.Position = UDim2.new(0.180257514, 0, -0.0162218884, 0)
    searchtextbox.Size = UDim2.new(0, 176, 0, 34)
    searchtextbox.Font = Enum.Font.Gotham
    searchtextbox.LineHeight = 0.870
    searchtextbox.PlaceholderText = "Search"
    searchtextbox.Text = ""
    searchtextbox.TextColor3 = Color3.fromRGB(95, 95, 95)
    searchtextbox.TextSize = 22
    searchtextbox.TextXAlignment = Enum.TextXAlignment.Left

    searchicon.MouseButton1Click:Connect(function()
        searchtextbox:CaptureFocus()
    end)

    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = "sidebar"
    sidebar.Parent = main
    sidebar.Active = true
    sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sidebar.BackgroundTransparency = 1
    sidebar.BorderSizePixel = 0
    sidebar.Position = UDim2.new(0.0249653254, 0, 0.181506842, 0)
    sidebar.Size = UDim2.new(0, 233, 0, 463)
    sidebar.AutomaticCanvasSize = "Y"
    sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebar.ScrollBarThickness = 2

    local ull_2 = Instance.new("UIListLayout")
    ull_2.Parent = sidebar
    ull_2.SortOrder = Enum.SortOrder.LayoutOrder
    ull_2.Padding = UDim.new(0, 5)

    if not getgenv().Apple_UI_Search_Bind_Render_Step then
        getgenv().Apple_UI_Search_Bind_Render_Step = RunService:BindToRenderStep("search", 1, function()
            if not searchtextbox:IsFocused() then 
                for b,v in next, sidebar:GetChildren() do
                    if not v:IsA("TextButton") then return end
                    v.Visible = true
                end
            end

            local InputText = string.upper(searchtextbox.Text)
            for _, button in pairs(sidebar:GetChildren())do
                if button:IsA("TextButton")then
                    if InputText == "" or string.find(string.upper(button.Text),InputText) ~= nil then
                        button.Visible = true
                    else
                        button.Visible = false
                    end
                end
            end
        end)
    end

    local buttons = Instance.new("Frame")
    buttons.Name = "buttons"
    buttons.Parent = main
    buttons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    buttons.BackgroundTransparency = 1
    buttons.Size = UDim2.new(0, 105, 0, 57)

    local ull_3 = Instance.new("UIListLayout")
    ull_3.Parent = buttons
    ull_3.FillDirection = Enum.FillDirection.Horizontal
    ull_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ull_3.SortOrder = Enum.SortOrder.LayoutOrder
    ull_3.VerticalAlignment = Enum.VerticalAlignment.Center
    ull_3.Padding = UDim.new(0, 10)

    local close = Instance.new("TextButton")
    close.Name = "close"
    close.Parent = buttons
    close.BackgroundColor3 = Color3.fromRGB(254, 94, 86)
    close.Size = UDim2.new(0, 16, 0, 16)
    close.AutoButtonColor = false
    close.Font = Enum.Font.SourceSans
    close.Text = ""
    close.TextColor3 = Color3.fromRGB(255, 50, 50)
    close.TextSize = 14
    close.MouseButton1Click:Connect(function() scrgui:Destroy() end)

    local uc_18 = Instance.new("UICorner")
    uc_18.CornerRadius = UDim.new(1, 0)
    uc_18.Parent = close

    local minimize = Instance.new("TextButton")
    minimize.Name = "minimize"
    minimize.Parent = buttons
    minimize.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
    minimize.Size = UDim2.new(0, 16, 0, 16)
    minimize.AutoButtonColor = false
    minimize.Font = Enum.Font.SourceSans
    minimize.Text = ""
    minimize.TextColor3 = Color3.fromRGB(255, 50, 50)
    minimize.TextSize = 14

    local uc_19 = Instance.new("UICorner")
    uc_19.CornerRadius = UDim.new(1, 0)
    uc_19.Parent = minimize

    local resize = Instance.new("TextButton")
    resize.Name = "resize"
    resize.Parent = buttons
    resize.BackgroundColor3 = Color3.fromRGB(39, 200, 63)
    resize.Size = UDim2.new(0, 16, 0, 16)
    resize.AutoButtonColor = false
    resize.Font = Enum.Font.SourceSans
    resize.Text = ""
    resize.TextColor3 = Color3.fromRGB(255, 50, 50)
    resize.TextSize = 14

    local uc_20 = Instance.new("UICorner")
    uc_20.CornerRadius = UDim.new(1, 0)
    uc_20.Parent = resize

    local title = Instance.new("TextLabel")
    title.Name = "title"
    title.Parent = main
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.BorderSizePixel = 2
    title.Position = UDim2.new(0.389000326, 0, 0.055, 0)
    title.Size = UDim2.new(0, 400, 0, 15)
    title.Font = Enum.Font.Gotham
    title.LineHeight = 1.180
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.TextSize = 28
    title.TextWrapped = true
    title.TextXAlignment = Enum.TextXAlignment.Left

    local notif = Instance.new("Frame")
    notif.Name = "notif"
    notif.Parent = main
    notif.AnchorPoint = Vector2.new(0.5, 0.5)
    notif.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notif.Position = UDim2.new(0.5, 0, 0.5, 0)
    notif.Size = UDim2.new(0, 304, 0, 362)
    notif.Visible = false
    notif.ZIndex = 3

    local uc_11 = Instance.new("UICorner")
    uc_11.CornerRadius = UDim.new(0, 18)
    uc_11.Parent = notif

    local notificon = Instance.new("ImageLabel")
    notificon.Name = "notificon"
    notificon.Parent = notif
    notificon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notificon.BackgroundTransparency = 1
    notificon.Position = UDim2.new(0.335526317, 0, 0.0994475111, 0)
    notificon.Size = UDim2.new(0, 100, 0, 100)
    notificon.ZIndex = 3
    notificon.Image = "rbxassetid://4871684504"
    notificon.ImageColor3 = Color3.fromRGB(95, 95, 95)

    local notifbutton1 = Instance.new("TextButton")
    notifbutton1.Name = "notifbutton1"
    notifbutton1.Parent = notif
    notifbutton1.BackgroundColor3 = Color3.fromRGB(21, 103, 251)
    notifbutton1.Position = UDim2.new(0.0559210554, 0, 0.817679524, 0)
    notifbutton1.Size = UDim2.new(0, 270, 0, 50)
    notifbutton1.ZIndex = 3
    notifbutton1.Font = Enum.Font.Gotham
    notifbutton1.Text = "OK"
    notifbutton1.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifbutton1.TextSize = 21

    local uc_12 = Instance.new("UICorner")
    uc_12.CornerRadius = UDim.new(0, 9)
    uc_12.Parent = notifbutton1

    local notifshadow = Instance.new("ImageLabel")
    notifshadow.Name = "notifshadow"
    notifshadow.Parent = notif
    notifshadow.AnchorPoint = Vector2.new(0.5, 0.5)
    notifshadow.BackgroundTransparency = 1
    notifshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    notifshadow.Size = UDim2.new(1.20000005, 0, 1.20000005, 0)
    notifshadow.Image = "rbxassetid://313486536"
    notifshadow.ImageColor3 = Color3.fromRGB(0, 0, 0)

    local notifdarkness = Instance.new("Frame")
    notifdarkness.Name = "notifdarkness"
    notifdarkness.Parent = notif
    notifdarkness.AnchorPoint = Vector2.new(0.5, 0.5)
    notifdarkness.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notifdarkness.BackgroundTransparency = 0.600
    notifdarkness.Position = UDim2.new(0.5, 0, 0.5, 0)
    notifdarkness.Size = UDim2.new(0, 721, 0, 584)
    notifdarkness.ZIndex = 2

    local uc_13 = Instance.new("UICorner")
    uc_13.CornerRadius = UDim.new(0, 18)
    uc_13.Parent = notifdarkness

    local notiftitle = Instance.new("TextLabel")
    notiftitle.Name = "notiftitle"
    notiftitle.Parent = notif
    notiftitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notiftitle.BackgroundTransparency = 1
    notiftitle.Position = UDim2.new(0.167763159, 0, 0.375690609, 0)
    notiftitle.Size = UDim2.new(0, 200, 0, 50)
    notiftitle.ZIndex = 3
    notiftitle.Font = Enum.Font.GothamMedium
    notiftitle.Text = "Notice"
    notiftitle.TextColor3 = Color3.fromRGB(95, 95, 95)
    notiftitle.TextSize = 28

    local notiftext = Instance.new("TextLabel")
    notiftext.Name = "notiftext"
    notiftext.Parent = notif
    notiftext.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notiftext.BackgroundTransparency = 1
    notiftext.Position = UDim2.new(0.0822368413, 0, 0.513812184, 0)
    notiftext.Size = UDim2.new(0, 254, 0, 66)
    notiftext.ZIndex = 3
    notiftext.Font = Enum.Font.Gotham
    notiftext.Text = "67 is requesting an update." -- ok
    notiftext.TextColor3 = Color3.fromRGB(95, 95, 95)
    notiftext.TextSize = 16
    notiftext.TextWrapped = true

    local notif2 = Instance.new("Frame")
    notif2.Name = "notif2"
    notif2.Parent = main
    notif2.AnchorPoint = Vector2.new(0.5, 0.5)
    notif2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notif2.Position = UDim2.new(0.5, 0, 0.5, 0)
    notif2.Size = UDim2.new(0, 304, 0, 362)
    notif2.Visible = false
    notif2.ZIndex = 3

    local uc_14 = Instance.new("UICorner")
    uc_14.CornerRadius = UDim.new(0, 18)
    uc_14.Parent = notif2

    local notif2icon = Instance.new("ImageLabel")
    notif2icon.Name = "notif2icon"
    notif2icon.Parent = notif2
    notif2icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notif2icon.BackgroundTransparency = 1
    notif2icon.Position = UDim2.new(0.335526317, 0, 0.0994475111, 0)
    notif2icon.Size = UDim2.new(0, 100, 0, 100)
    notif2icon.ZIndex = 3
    notif2icon.Image = "rbxassetid://12608260095"
    notif2icon.ImageColor3 = Color3.fromRGB(95, 95, 95)

    local notif2title = Instance.new("TextLabel")
    notif2title.Name = "notif2title"
    notif2title.Parent = notif2
    notif2title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notif2title.BackgroundTransparency = 1
    notif2title.Position = UDim2.new(0.167763159, 0, 0.375690609, 0)
    notif2title.Size = UDim2.new(0, 200, 0, 50)
    notif2title.ZIndex = 3
    notif2title.Font = Enum.Font.GothamMedium
    notif2title.Text = "Notice"
    notif2title.TextColor3 = Color3.fromRGB(95, 95, 95)
    notif2title.TextSize = 28

    local notif2text = Instance.new("TextLabel")
    notif2text.Name = "notif2text"
    notif2text.Parent = notif2
    notif2text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notif2text.BackgroundTransparency = 1
    notif2text.Position = UDim2.new(0.0822368413, 0, 0.513812184, 0)
    notif2text.Size = UDim2.new(0, 254, 0, 66)
    notif2text.ZIndex = 3
    notif2text.Font = Enum.Font.Gotham
    notif2text.Text = "Lebron James is requesting a video call."
    notif2text.TextColor3 = Color3.fromRGB(95, 95, 95)
    notif2text.TextSize = 16
    notif2text.TextWrapped = true

    local notif2button1 = Instance.new("TextButton")
    notif2button1.Name = "notif2button1"
    notif2button1.Parent = notif2
    notif2button1.BackgroundColor3 = Color3.fromRGB(21, 103, 251)
    notif2button1.Position = UDim2.new(0.0559210517, 0, 0.715469658, 0)
    notif2button1.Size = UDim2.new(0, 270, 0, 40)
    notif2button1.ZIndex = 3
    notif2button1.Font = Enum.Font.Gotham
    notif2button1.Text = "Sure!"
    notif2button1.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif2button1.TextSize = 21

    local uc_15 = Instance.new("UICorner")
    uc_15.CornerRadius = UDim.new(0, 9)
    uc_15.Parent = notif2button1

    local notif2shadow = Instance.new("ImageLabel")
    notif2shadow.Name = "notif2shadow"
    notif2shadow.Parent = notif2
    notif2shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    notif2shadow.BackgroundTransparency = 1
    notif2shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    notif2shadow.Size = UDim2.new(1.20000005, 0, 1.20000005, 0)
    notif2shadow.Image = "rbxassetid://313486536"
    notif2shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)

    local notif2darkness = Instance.new("Frame")
    notif2darkness.Name = "notif2darkness"
    notif2darkness.Parent = notif2
    notif2darkness.AnchorPoint = Vector2.new(0.5, 0.5)
    notif2darkness.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif2darkness.BackgroundTransparency = 0.600
    notif2darkness.Position = UDim2.new(0.5, 0, 0.5, 0)
    notif2darkness.Size = UDim2.new(0, 721, 0, 584)
    notif2darkness.ZIndex = 2

    local uc_16 = Instance.new("UICorner")
    uc_16.CornerRadius = UDim.new(0, 18)
    uc_16.Parent = notif2darkness

    local notif2button2 = Instance.new("TextButton")
    notif2button2.Name = "notif2button2"
    notif2button2.Parent = notif2
    notif2button2.BackgroundColor3 = Color3.fromRGB(21, 103, 251)
    notif2button2.BackgroundTransparency = 1
    notif2button2.Position = UDim2.new(0.0526315793, 0, 0.842541456, 0)
    notif2button2.Size = UDim2.new(0, 270, 0, 40)
    notif2button2.ZIndex = 3
    notif2button2.Font = Enum.Font.Gotham
    notif2button2.Text = "Go away."
    notif2button2.TextColor3 = Color3.fromRGB(95, 95, 95)
    notif2button2.TextSize = 21

    local uc_17 = Instance.new("UICorner")
    uc_17.CornerRadius = UDim.new(0, 9)
    uc_17.Parent = notif2button2

    if ti then
        title.Text = ti
    else
        title.Text = ""
    end
    tp(main, UDim2.new(0.5, 0, 0.5, 0), 1)
    window = {}

    function window:ToggleVisible()
        if dbcooper then return end
        visible = not visible
        dbcooper = true
        if visible then
            tp(main, UDim2.new(0.5, 0, 0.5, 0), 0.5)
            task.wait(0.5)
            dbcooper = false
        else
            tp(main, main.Position + UDim2.new(0,0,2,0), 0.5)
            task.wait(0.5)
            dbcooper = false
        end
    end

    local is_mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    if is_mobile then
        local ScreenGui = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
        
        local toggle_gui = Instance.new("ScreenGui")
        toggle_gui.Name = "FlamesToggle"
        toggle_gui.ResetOnSpawn = false
        toggle_gui.DisplayOrder = 999
        toggle_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        toggle_gui.Parent = game:GetService("CoreGui")

        local toggle_btn = Instance.new("TextButton")
        toggle_btn.Name = "ToggleBtn"
        toggle_btn.Size = UDim2.new(0, 40, 0, 40)
        toggle_btn.Position = UDim2.new(1, -8, 0, 8)
        toggle_btn.AnchorPoint = Vector2.new(1, 0)
        toggle_btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        toggle_btn.BorderSizePixel = 0
        toggle_btn.Text = "Toggle AppleUI"
        toggle_btn.TextScaled = true
        toggle_btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle_btn.TextSize = 22
        toggle_btn.Font = Enum.Font.GothamBold
        toggle_btn.ZIndex = 10
        toggle_btn.Parent = toggle_gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = toggle_btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(80, 80, 80)
        stroke.Thickness = 1
        stroke.Parent = toggle_btn

        toggle_btn.MouseButton1Click:Connect(function()
            window:ToggleVisible()
        end)
        minimize.Visible = false
    elseif visiblekey then
        minimize.MouseButton1Click:Connect(function()
            window:ToggleVisible()
        end)
        if getgenv().Toggle_Window_Keybind_Connection then
            getgenv().Toggle_Window_Keybind_Connection:Disconnect()
        end
        wait(0.25)
        getgenv().Toggle_Window_Keybind_Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.KeyCode == visiblekey then
                window:ToggleVisible()
            end
        end)
    end

    function window:GreenButton(callback)
        if getgenv().gbutton_123123 then getgenv().gbutton_123123:Disconnect() end
        wait(0.25)
        getgenv().gbutton_123123 = resize.MouseButton1Click:Connect(function()
            callback()
        end)
    end

    function window:TempNotify(text1, text2, icon)
        for b,v in next, scrgui:GetChildren() do
            if v.Name == "tempnotif" then 
                v.Position += UDim2.new(0,0,0,130)
            end
        end
        wait(0.1)
        local tempnotif = Instance.new("Frame")
        tempnotif.Name = "tempnotif"
        tempnotif.Parent = scrgui
        tempnotif.AnchorPoint = Vector2.new(0.5, 0.5)
        tempnotif.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tempnotif.BackgroundTransparency = 0.150
        tempnotif.Position = UDim2.new(1, -250, 0.0794737339, 0)
        tempnotif.Size = UDim2.new(0, 447, 0, 117)
        tempnotif.Visible = true
        tempnotif.ZIndex = 4

        local uc_21 = Instance.new("UICorner")
        uc_21.CornerRadius = UDim.new(0, 18)
        uc_21.Parent = tempnotif

        local t2 = Instance.new("TextLabel")
        t2.Name = "t2"
        t2.Parent = tempnotif
        t2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        t2.BackgroundTransparency = 1
        t2.Position = UDim2.new(0.236927822, 0, 0.470085472, 0)
        t2.Size = UDim2.new(0, 326, 0, 52)
        t2.ZIndex = 4
        t2.Font = Enum.Font.Gotham
        t2.Text = text2
        t2.TextColor3 = Color3.fromRGB(95, 95, 95)
        t2.TextSize = 16
        t2.TextWrapped = true
        t2.TextXAlignment = Enum.TextXAlignment.Left
        t2.TextYAlignment = Enum.TextYAlignment.Top

        local t1 = Instance.new("TextLabel")
        t1.Name = "t1"
        t1.Parent = tempnotif
        t1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        t1.BackgroundTransparency = 1
        t1.Position = UDim2.new(0.234690696, 0, 0.193464488, 0)
        t1.Size = UDim2.new(0, 327, 0, 25)
        t1.ZIndex = 4
        t1.Font = Enum.Font.GothamMedium
        t1.Text = text1
        t1.TextColor3 = Color3.fromRGB(95, 95, 95)
        t1.TextSize = 28
        t1.TextXAlignment = Enum.TextXAlignment.Left

        local ticon = Instance.new("ImageLabel")
        ticon.Name = "ticon"
        ticon.Parent = tempnotif
        ticon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ticon.BackgroundTransparency = 1
        ticon.Position = UDim2.new(0.0311112702, 0, 0.193464488, 0)
        ticon.Size = UDim2.new(0, 71, 0, 71)
        ticon.ZIndex = 4
        ticon.Image = icon
        ticon.ImageColor3 = Color3.fromRGB(95, 95, 95)
        ticon.ScaleType = Enum.ScaleType.Fit

        local tshadow = Instance.new("ImageLabel")
        tshadow.Name = "tshadow"
        tshadow.Parent = tempnotif
        tshadow.AnchorPoint = Vector2.new(0.5, 0.5)
        tshadow.BackgroundTransparency = 1
        tshadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        tshadow.Size = UDim2.new(1.12, 0, 1.20000005, 0)
        tshadow.ZIndex = 3
        tshadow.Image = "rbxassetid://313486536"
        tshadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        tshadow.ImageTransparency = 0.400
        tshadow.TileSize = UDim2.new(0, 1, 0, 1)
        Debris:AddItem(tempnotif, 5)
    end

    function window:Notify(txt1, txt2, b1, icohn, callback)
        if notif.Visible == true or notif2.Visible == true then return "Already visible" end
        notiftitle.Text = txt1
        notiftext.Text = txt2
        notificon = icohn
        notif.Visible = true
        notifbutton1.Text = b1
        if callback then
            con1 = notifbutton1.MouseButton1Click:Connect(function()
                con1:Disconnect()
                callback()
                notif.Visible = false
            end)
        end
    end

    function window:Notify2(txt1, txt2, b1, b2, icohn, callback, callback2)
        if notif.Visible == true or notif2.Visible == true then return "Already visible" end
        notif2title.Text = txt1
        notif2text.Text = txt2
        notif2icon = icohn
        notif2.Visible = true
        notif2button1.Text = b1
        notif2button2.Text = b2
        if callback and callback2 then
            con1 = notif2button1.MouseButton1Click:Connect(function()
                con1:Disconnect()
                con2:Disconnect()
                callback()
                notif2.Visible = false
            end)
            con2 = notif2button2.MouseButton1Click:Connect(function()
                con1:Disconnect()
                con2:Disconnect()
                callback2()
                notif2.Visible = false
            end)
        end
    end

    function window:Divider(name)
        local sidebardivider = Instance.new("TextLabel")
        sidebardivider.Name = "sidebardivider"
        sidebardivider.Parent = sidebar
        sidebardivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sidebardivider.BackgroundTransparency = 1
        sidebardivider.BorderSizePixel = 2
        sidebardivider.Position = UDim2.new(0, 0, 0.00215982716, 0)
        sidebardivider.Size = UDim2.new(0, 226, 0, 26)
        sidebardivider.Font = Enum.Font.Gotham
        sidebardivider.Text = name
        sidebardivider.TextColor3 = Color3.fromRGB(95, 95, 95)
        sidebardivider.TextSize = 21
        sidebardivider.TextWrapped = true
        sidebardivider.TextXAlignment = Enum.TextXAlignment.Left
        sidebardivider.TextYAlignment = Enum.TextYAlignment.Bottom
    end

    function window:Section(name)
        local sidebar2 = Instance.new("TextButton")
        sidebar2.Name = "sidebar2"
        sidebar2.Parent = sidebar
        sidebar2.BackgroundColor3 = Color3.fromRGB(21, 103, 251)
        sidebar2.BackgroundTransparency = 1
        sidebar2.Size = UDim2.new(0, 226, 0, 37)
        sidebar2.ZIndex = 2
        sidebar2.AutoButtonColor = false
        sidebar2.Font = Enum.Font.Gotham
        sidebar2.Text = name
        sidebar2.TextColor3 = Color3.fromRGB(0, 0, 0)
        sidebar2.TextSize = 21
        
        local uc_10 = Instance.new("UICorner")
        uc_10.CornerRadius = UDim.new(0, 9)
        uc_10.Parent = sidebar2
        table.insert(sections, sidebar2)

        local workareamain = Instance.new("ScrollingFrame")
        workareamain.Name = "workareamain"
        workareamain.Parent = workarea
        workareamain.Active = true
        workareamain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        workareamain.BackgroundTransparency = 1
        workareamain.BorderSizePixel = 0
        workareamain.Position = UDim2.new(0.0393013097, 0, 0, 100)
        workareamain.Size = UDim2.new(0, 422, 0, 468)
        workareamain.ZIndex = 3
        workareamain.CanvasSize = UDim2.new(0, 0, 0, 0)
        workareamain.AutomaticCanvasSize = Enum.AutomaticSize.Y
        workareamain.ScrollBarThickness = 2
        workareamain.Visible = false

        local ull = Instance.new("UIListLayout")
        ull.Parent = workareamain
        ull.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ull.SortOrder = Enum.SortOrder.LayoutOrder
        ull.Padding = UDim.new(0, 5)
    
        table.insert(workareas, workareamain)

        local sec = {}
        function sec:Select()
            for b, v in next, sections do
                v.BackgroundTransparency = 1
                v.TextColor3 = Color3.fromRGB(0, 0, 0)
            end
            sidebar2.BackgroundTransparency = 0
            sidebar2.TextColor3 = Color3.fromRGB(255, 255, 255)
            for b, v in next, workareas do
                v.Visible = false
            end
            workareamain.Visible = true
        end

        function sec:Divider(name)
            local section = Instance.new("TextLabel")
            section.Name = "section"
            section.Parent = workareamain
            section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            section.BackgroundTransparency = 1
            section.BorderSizePixel = 2
            section.Size = UDim2.new(0, 418, 0, 50)
            section.Font = Enum.Font.Gotham
            section.LineHeight = 1.180
            section.Text = name
            section.TextColor3 = Color3.fromRGB(0, 0, 0)
            section.TextSize = 25
            section.TextWrapped = true
            section.TextXAlignment = Enum.TextXAlignment.Left
            section.TextYAlignment = Enum.TextYAlignment.Bottom
        end

        function sec:Button(name, callback)
            local button = Instance.new("TextButton")
            button.Name = "button"
            button.Text = name
            button.Parent = workareamain
            button.BackgroundColor3 = Color3.fromRGB(216, 216, 216)
            button.BackgroundTransparency = 1
            button.Size = UDim2.new(0, 418, 0, 37)
            button.ZIndex = 2
            button.Font = Enum.Font.Gotham
            button.TextColor3 = Color3.fromRGB(21, 103, 251)
            button.TextSize = 21

            local uc_3 = Instance.new("UICorner")
            uc_3.CornerRadius = UDim.new(0, 9)
            uc_3.Parent = button

            local us = Instance.new("UIStroke", button)
            us.ApplyStrokeMode = "Border"
            us.Color = Color3.fromRGB(21, 103, 251)
            us.Thickness = 1

            if callback then
                button.MouseButton1Click:Connect(function() 
                    coroutine.wrap(function()
                        button.TextSize -= 3
                        task.wait(0.06)
                        button.TextSize += 3
                    end)()
                    callback()
                end)
            end
        end

        function sec:Dropdown(name, options, default, callback)
            local selected = default or options[1]
            local open = false
            local container = Instance.new("Frame")
            container.Name = "dropdown"
            container.Parent = workareamain
            container.BackgroundTransparency = 1
            container.Size = UDim2.new(0, 418, 0, 37)
            container.ClipsDescendants = false
            container.ZIndex = 5

            local header = Instance.new("TextButton")
            header.Name = "header"
            header.Parent = container
            header.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            header.Size = UDim2.new(1, 0, 0, 37)
            header.ZIndex = 5
            header.Font = Enum.Font.Gotham
            header.Text = name .. ":  " .. tostring(selected)
            header.TextColor3 = Color3.fromRGB(95, 95, 95)
            header.TextSize = 21
            header.AutoButtonColor = false

            local uc_dd = Instance.new("UICorner")
            uc_dd.CornerRadius = UDim.new(0, 9)
            uc_dd.Parent = header

            local us_dd = Instance.new("UIStroke")
            us_dd.Color = Color3.fromRGB(21, 103, 251)
            us_dd.Thickness = 1
            us_dd.Parent = header

            local dropdown_list = Instance.new("Frame")
            dropdown_list.Name = "dropdown_list"
            dropdown_list.Parent = container
            dropdown_list.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            dropdown_list.Position = UDim2.new(0, 0, 1, 4)
            dropdown_list.Size = UDim2.new(1, 0, 0, 0)
            dropdown_list.ClipsDescendants = true
            dropdown_list.ZIndex = 6
            dropdown_list.Visible = false

            local uc_ddl = Instance.new("UICorner")
            uc_ddl.CornerRadius = UDim.new(0, 9)
            uc_ddl.Parent = dropdown_list

            local ull_dd = Instance.new("UIListLayout")
            ull_dd.Parent = dropdown_list
            ull_dd.SortOrder = Enum.SortOrder.LayoutOrder
            ull_dd.Padding = UDim.new(0, 2)

            local total_height = 0
            for _, opt in ipairs(options) do
                local opt_btn = Instance.new("TextButton")
                opt_btn.Parent = dropdown_list
                opt_btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                opt_btn.BackgroundTransparency = 1
                opt_btn.Size = UDim2.new(1, 0, 0, 34)
                opt_btn.ZIndex = 6
                opt_btn.Font = Enum.Font.Gotham
                opt_btn.Text = tostring(opt)
                opt_btn.TextColor3 = Color3.fromRGB(21, 103, 251)
                opt_btn.TextSize = 20
                opt_btn.AutoButtonColor = false

                local us_opt = Instance.new("UIStroke")
                us_opt.Color = Color3.fromRGB(21, 103, 251)
                us_opt.Thickness = 1
                us_opt.Parent = opt_btn

                local uc_opt = Instance.new("UICorner")
                uc_opt.CornerRadius = UDim.new(0, 7)
                uc_opt.Parent = opt_btn

                opt_btn.MouseButton1Click:Connect(function()
                    selected = opt
                    header.Text = name .. ":  " .. tostring(opt)
                    open = false
                    dropdown_list.Visible = false
                    workareamain.AutomaticCanvasSize = Enum.AutomaticSize.Y
                    container.Size = UDim2.new(0, 418, 0, 37)
                    if callback then callback(opt) end
                end)

                total_height += 36
            end

            header.MouseButton1Click:Connect(function()
                open = not open
                dropdown_list.Visible = open
                if open then
                    dropdown_list.Size = UDim2.new(1, 0, 0, total_height + 4)
                    container.Size = UDim2.new(0, 418, 0, 37 + total_height + 8)
                else
                    container.Size = UDim2.new(0, 418, 0, 37)
                end
                workareamain.AutomaticCanvasSize = Enum.AutomaticSize.Y
            end)
        end
        
        function sec:Slider(name, min, max, default, decimals, callback)
            if type(decimals) == "function" then callback, decimals = decimals, nil end
            if decimals == nil and default then
                local frac = tostring(default):match("%.(%d+)")
                if frac then decimals = #frac end
            end
            decimals = decimals or 0
            local mult = 10 ^ decimals
            local value = default or min
            value = math.clamp(value, min, max)
            local container = Instance.new("TextLabel")
            container.Name = "slider"
            container.Parent = workareamain
            container.BackgroundTransparency = 1
            container.Size = UDim2.new(0, 418, 0, 65)
            container.Font = Enum.Font.Gotham
            container.Text = name .. ":  " .. tostring(value)
            container.TextColor3 = Color3.fromRGB(95, 95, 95)
            container.TextSize = 21
            container.TextXAlignment = Enum.TextXAlignment.Left
            container.TextYAlignment = Enum.TextYAlignment.Top
            container.ZIndex = 2

            local track = Instance.new("Frame")
            track.Name = "track"
            track.Parent = container
            track.BackgroundColor3 = Color3.fromRGB(216, 216, 216)
            track.Position = UDim2.new(0, 0, 0, 42)
            track.Size = UDim2.new(1, 0, 0, 8)
            track.ZIndex = 2

            local uc_tr = Instance.new("UICorner")
            uc_tr.CornerRadius = UDim.new(1, 0)
            uc_tr.Parent = track

            local fill = Instance.new("Frame")
            fill.Name = "fill"
            fill.Parent = track
            fill.BackgroundColor3 = Color3.fromRGB(21, 103, 251)
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            fill.ZIndex = 2

            local uc_fi = Instance.new("UICorner")
            uc_fi.CornerRadius = UDim.new(1, 0)
            uc_fi.Parent = fill

            local knob = Instance.new("TextButton")
            knob.Name = "knob"
            knob.Parent = track
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.AnchorPoint = Vector2.new(0.5, 0.5)
            knob.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
            knob.Size = UDim2.new(0, 18, 0, 18)
            knob.Text = ""
            knob.ZIndex = 3
            knob.AutoButtonColor = false

            local uc_kn = Instance.new("UICorner")
            uc_kn.CornerRadius = UDim.new(1, 0)
            uc_kn.Parent = knob

            local dragging_slider = false
            knob.MouseButton1Down:Connect(function() dragging_slider = true end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging_slider = false
                end
            end)

            UserInputService.InputChanged:Connect(function(i)
                if not dragging_slider then return end
                if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
                local track_pos = track.AbsolutePosition.X
                local track_size = track.AbsoluteSize.X
                local rel = math.clamp((i.Position.X - track_pos) / track_size, 0, 1)
                local raw = min + (max - min) * rel
                local rounded = math.round(raw * mult) / mult
                rounded = math.clamp(rounded, min, max)
                value = rounded
                local newRel = (value - min) / (max - min)
                fill.Size = UDim2.new(newRel, 0, 1, 0)
                knob.Position = UDim2.new(newRel, 0, 0.5, 0)
                container.Text = name .. ":  " .. tostring(value)
                if callback then callback(value) end
            end)
        end

        function sec:ColorPicker(name, default, callback)
            local hue, sat, val = 0, 1, 1
            if default then
                hue, sat, val = Color3.toHSV(default)
            end
            local picked = Color3.fromHSV(hue, sat, val)
            local open = false
            local container = Instance.new("Frame")
            container.Name = "colorpicker"
            container.Parent = workareamain
            container.BackgroundTransparency = 1
            container.Size = UDim2.new(0, 418, 0, 37)
            container.ClipsDescendants = false
            container.ZIndex = 4

            local header = Instance.new("TextButton")
            header.Name = "header"
            header.Parent = container
            header.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            header.Size = UDim2.new(1, 0, 0, 37)
            header.ZIndex = 4
            header.Font = Enum.Font.Gotham
            header.Text = name
            header.TextColor3 = Color3.fromRGB(95, 95, 95)
            header.TextSize = 21
            header.AutoButtonColor = false
            header.TextXAlignment = Enum.TextXAlignment.Center

            local uc_hd = Instance.new("UICorner")
            uc_hd.CornerRadius = UDim.new(0, 9)
            uc_hd.Parent = header

            local us_hd = Instance.new("UIStroke")
            us_hd.Color = Color3.fromRGB(21, 103, 251)
            us_hd.Thickness = 1
            us_hd.Parent = header

            local swatch = Instance.new("Frame")
            swatch.Name = "swatch"
            swatch.Parent = header
            swatch.AnchorPoint = Vector2.new(1, 0.5)
            swatch.Position = UDim2.new(1, -10, 0.5, 0)
            swatch.Size = UDim2.new(0, 28, 0, 22)
            swatch.BackgroundColor3 = picked
            swatch.ZIndex = 5

            local uc_sw = Instance.new("UICorner")
            uc_sw.CornerRadius = UDim.new(0, 5)
            uc_sw.Parent = swatch

            local panel = Instance.new("Frame")
            panel.Name = "panel"
            panel.Parent = container
            panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            panel.Position = UDim2.new(0, 0, 1, 4)
            panel.Size = UDim2.new(1, 0, 0, 148)
            panel.ZIndex = 5
            panel.Visible = false
            panel.ClipsDescendants = true

            local uc_pn = Instance.new("UICorner")
            uc_pn.CornerRadius = UDim.new(0, 9)
            uc_pn.Parent = panel

            local sv_map = Instance.new("ImageLabel")
            sv_map.Name = "sv_map"
            sv_map.Parent = panel
            sv_map.Position = UDim2.new(0, 8, 0, 8)
            sv_map.Size = UDim2.new(0, 200, 0, 130)
            sv_map.ZIndex = 5
            sv_map.Image = "rbxassetid://698052532"
            sv_map.ImageColor3 = Color3.fromHSV(hue, 1, 1)
            sv_map.ClipsDescendants = true

            local uc_sv = Instance.new("UICorner")
            uc_sv.CornerRadius = UDim.new(0, 7)
            uc_sv.Parent = sv_map

            local sv_knob = Instance.new("Frame")
            sv_knob.Name = "sv_knob"
            sv_knob.Parent = sv_map
            sv_knob.AnchorPoint = Vector2.new(0.5, 0.5)
            sv_knob.Size = UDim2.new(0, 12, 0, 12)
            sv_knob.Position = UDim2.new(sat, 0, 1 - val, 0)
            sv_knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sv_knob.ZIndex = 6

            local uc_svk = Instance.new("UICorner")
            uc_svk.CornerRadius = UDim.new(1, 0)
            uc_svk.Parent = sv_knob

            local hue_bar = Instance.new("ImageLabel")
            hue_bar.Name = "hue_bar"
            hue_bar.Parent = panel
            hue_bar.Position = UDim2.new(0, 218, 0, 8)
            hue_bar.Size = UDim2.new(0, 20, 0, 130)
            hue_bar.ZIndex = 5
            hue_bar.Image = "rbxassetid://698053938"
            hue_bar.ClipsDescendants = true

            local uc_hb = Instance.new("UICorner")
            uc_hb.CornerRadius = UDim.new(0, 7)
            uc_hb.Parent = hue_bar

            local hue_knob = Instance.new("Frame")
            hue_knob.Name = "hue_knob"
            hue_knob.Parent = hue_bar
            hue_knob.AnchorPoint = Vector2.new(0.5, 0.5)
            hue_knob.Size = UDim2.new(1, 4, 0, 6)
            hue_knob.Position = UDim2.new(0.5, 0, hue, 0)
            hue_knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            hue_knob.ZIndex = 6

            local hex_box = Instance.new("TextBox")
            hex_box.Name = "hex_box"
            hex_box.Parent = panel
            hex_box.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            hex_box.Position = UDim2.new(0, 248, 0, 8)
            hex_box.Size = UDim2.new(0, 162, 0, 34)
            hex_box.ZIndex = 5
            hex_box.Font = Enum.Font.GothamMedium
            hex_box.TextSize = 17
            hex_box.TextColor3 = Color3.fromRGB(30, 30, 30)
            hex_box.PlaceholderText = "Hex..."
            hex_box.Text = string.format("%02X%02X%02X", math.round(picked.R*255), math.round(picked.G*255), math.round(picked.B*255))
            hex_box.ClearTextOnFocus = false

            local uc_hx = Instance.new("UICorner")
            uc_hx.CornerRadius = UDim.new(0, 7)
            uc_hx.Parent = hex_box

            local function update_color()
                picked = Color3.fromHSV(hue, sat, val)
                swatch.BackgroundColor3 = picked
                sv_map.ImageColor3 = Color3.fromHSV(hue, 1, 1)
                sv_knob.Position = UDim2.new(sat, 0, 1 - val, 0)
                hue_knob.Position = UDim2.new(0.5, 0, hue, 0)
                hex_box.Text = string.format("%02X%02X%02X", math.round(picked.R*255), math.round(picked.G*255), math.round(picked.B*255))
                if callback then callback(picked) end
            end

            local dragging_sv = false
            local dragging_hue = false

            sv_map.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging_sv = true
                end
            end)
            hue_bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging_hue = true
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging_sv = false
                    dragging_hue = false
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
                if dragging_sv then
                    local rel_x = math.clamp((i.Position.X - sv_map.AbsolutePosition.X) / sv_map.AbsoluteSize.X, 0, 1)
                    local rel_y = math.clamp((i.Position.Y - sv_map.AbsolutePosition.Y) / sv_map.AbsoluteSize.Y, 0, 1)
                    sat = rel_x
                    val = 1 - rel_y
                    update_color()
                elseif dragging_hue then
                    local rel_y = math.clamp((i.Position.Y - hue_bar.AbsolutePosition.Y) / hue_bar.AbsoluteSize.Y, 0, 1)
                    hue = rel_y
                    update_color()
                end
            end)

            hex_box.FocusLost:Connect(function()
                local hex = hex_box.Text:gsub("#", "")
                if #hex == 6 then
                    local r = tonumber(hex:sub(1,2), 16)
                    local g = tonumber(hex:sub(3,4), 16)
                    local b = tonumber(hex:sub(5,6), 16)
                    if r and g and b then
                        picked = Color3.fromRGB(r, g, b)
                        hue, sat, val = Color3.toHSV(picked)
                        update_color()
                    end
                end
            end)

            header.MouseButton1Click:Connect(function()
                open = not open
                panel.Visible = open
                container.Size = open and UDim2.new(0, 418, 0, 37 + 152) or UDim2.new(0, 418, 0, 37)
                workareamain.AutomaticCanvasSize = Enum.AutomaticSize.Y
            end)
        end

        function sec:Label(name)
            local label = Instance.new("TextLabel")
            label.Name = "label"
            label.Parent = workareamain
            label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            label.BackgroundTransparency = 1
            label.BorderSizePixel = 2
            label.Size = UDim2.new(0, 418, 0, 37)
            label.Font = Enum.Font.Gotham
            label.TextColor3 = Color3.fromRGB(95, 95, 95)
            label.TextSize = 21
            label.TextWrapped = true
            label.Text = name
        end

function sec:Switch(name, defaultmode, callback)
            local mode = defaultmode

            local debug_lines = {}
            local function dbg(...)
                local parts = {...}
                for i, v in ipairs(parts) do
                    parts[i] = tostring(v)
                end
                local line = table.concat(parts, " ")
                table.insert(debug_lines, line)
                print(line)
                if setclipboard then
                    pcall(setclipboard, table.concat(debug_lines, "\n"))
                end
            end

            local toggleswitch = Instance.new("TextLabel")
            toggleswitch.Name = "toggleswitch"
            toggleswitch.Parent = workareamain
            toggleswitch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleswitch.BackgroundTransparency = 1
            toggleswitch.BorderSizePixel = 2
            toggleswitch.Size = UDim2.new(0, 418, 0, 37)
            toggleswitch.Font = Enum.Font.Gotham
            toggleswitch.Text = name
            toggleswitch.TextColor3 = Color3.fromRGB(95, 95, 95)
            toggleswitch.TextSize = 21
            toggleswitch.TextWrapped = true
            toggleswitch.TextXAlignment = Enum.TextXAlignment.Left

            local Frame = Instance.new("TextButton")
            Frame.Parent = toggleswitch
            Frame.Position = UDim2.new(0.832535863, 0, 0.0270270277, 0)
            Frame.Size = UDim2.new(0, 70, 0, 36)
            Frame.Text = ""
            Frame.AutoButtonColor = false

            local uc_4 = Instance.new("UICorner")
            uc_4.CornerRadius = UDim.new(5, 0)
            uc_4.Parent = Frame

            local TextButton = Instance.new("TextButton")
            TextButton.Parent = Frame
            TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextButton.Size = UDim2.new(0, 34, 0, 34)
            TextButton.AutoButtonColor = false
            TextButton.Text = ""

            local uc_5 = Instance.new("UICorner")
            uc_5.CornerRadius = UDim.new(5, 0)
            uc_5.Parent = TextButton

            dbg("[Switch]", name, "created")

            task.defer(function()
                dbg("[Switch]", name, "toggleswitch AbsSize", toggleswitch.AbsoluteSize, "AbsPos", toggleswitch.AbsolutePosition)
                dbg("[Switch]", name, "Frame AbsSize", Frame.AbsoluteSize, "AbsPos", Frame.AbsolutePosition, "ZIndex", Frame.ZIndex)
                dbg("[Switch]", name, "TextButton AbsSize", TextButton.AbsoluteSize, "AbsPos", TextButton.AbsolutePosition, "ZIndex", TextButton.ZIndex)
                dbg("[Switch]", name, "workareamain Visible", workareamain.Visible, "ClipsDescendants", workareamain.ClipsDescendants)
                dbg("[Switch]", name, "ui_scale.Scale", ui_scale and ui_scale.Scale)
            end)

            Frame.InputBegan:Connect(function(input)
                dbg("[Switch]", name, "Frame InputBegan", input.UserInputType.Name)
            end)

            Frame.InputEnded:Connect(function(input)
                dbg("[Switch]", name, "Frame InputEnded", input.UserInputType.Name)
            end)

            TextButton.InputBegan:Connect(function(input)
                dbg("[Switch]", name, "TextButton InputBegan", input.UserInputType.Name)
            end)

            TextButton.InputEnded:Connect(function(input)
                dbg("[Switch]", name, "TextButton InputEnded", input.UserInputType.Name)
            end)

            local function apply(new_mode, fireCallback, animate)
                dbg("[Switch]", name, "apply() new_mode", new_mode, "fireCallback", fireCallback, "animate", animate)
                mode = new_mode
                if mode then
                    if animate then
                        TextButton:TweenPosition(UDim2.new(0, 35, 0, 1), "In", "Sine", 0.1, true)
                    else
                        TextButton.Position = UDim2.new(0, 35, 0, 1)
                    end
                    Frame.BackgroundColor3 = Color3.fromRGB(21, 103, 251)
                else
                    if animate then
                        TextButton:TweenPosition(UDim2.new(0, 1, 0, 1), "In", "Sine", 0.1, true)
                    else
                        TextButton.Position = UDim2.new(0, 1, 0, 1)
                    end
                    Frame.BackgroundColor3 = Color3.fromRGB(216, 216, 216)
                end
                if fireCallback and callback then
                    dbg("[Switch]", name, "firing callback with", mode)
                    task.spawn(callback, mode)
                end
            end

            apply(defaultmode, false, false)

            Frame.MouseButton1Click:Connect(function()
                dbg("[Switch]", name, "Frame.MouseButton1Click FIRED")
                apply(not mode, true, true)
            end)

            Frame.MouseButton1Down:Connect(function()
                dbg("[Switch]", name, "Frame.MouseButton1Down FIRED")
            end)

            TextButton.MouseButton1Click:Connect(function()
                dbg("[Switch]", name, "TextButton.MouseButton1Click FIRED")
                apply(not mode, true, true)
            end)

            TextButton.MouseButton1Down:Connect(function()
                dbg("[Switch]", name, "TextButton.MouseButton1Down FIRED")
            end)

            local switchObject = {}
            function switchObject:Set(new_mode, fireCallback)
                if fireCallback == nil then fireCallback = true end
                apply(new_mode, fireCallback, true)
            end

            function switchObject:Get() return mode end
            return switchObject
        end

        function sec:TextField(name, placeholder, callback)
            local textfield = Instance.new("TextLabel")
            textfield.Name = "textfield"
            textfield.Parent = workareamain
            textfield.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textfield.BackgroundTransparency = 1
            textfield.BorderSizePixel = 2
            textfield.Size = UDim2.new(0, 418, 0, 37)
            textfield.Font = Enum.Font.Gotham
            textfield.Text = name
            textfield.TextColor3 = Color3.fromRGB(95, 95, 95)
            textfield.TextSize = 21
            textfield.TextWrapped = true
            textfield.TextXAlignment = Enum.TextXAlignment.Left

            local Frame_2 = Instance.new("Frame")
            Frame_2.Parent = textfield
            Frame_2.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            Frame_2.Position = UDim2.new(0.441926777, 0, 0.0270270277, 0)
            Frame_2.Size = UDim2.new(0, 233, 0, 34)

            local uc_6 = Instance.new("UICorner")
            uc_6.CornerRadius = UDim.new(0, 9)
            uc_6.Parent = Frame_2

            local TextBox = Instance.new("TextBox")
            TextBox.Parent = Frame_2
            TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.BackgroundTransparency = 1
            TextBox.BorderColor3 = Color3.fromRGB(27, 42, 53)
            TextBox.BorderSizePixel = 0
            TextBox.ClipsDescendants = true
            TextBox.Position = UDim2.new(0.0643776804, 0, 0, -2)
            TextBox.Size = UDim2.new(0, 203, 0, 34)
            TextBox.ClearTextOnFocus = false
            TextBox.Font = Enum.Font.Gotham
            TextBox.LineHeight = 0.870
            TextBox.PlaceholderColor3 = Color3.fromRGB(113, 113, 113)
            TextBox.PlaceholderText = placeholder or "Type..."
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(12, 12, 12)
            TextBox.TextSize = 21
            TextBox.TextXAlignment = Enum.TextXAlignment.Left

            if callback then
                TextBox.FocusLost:Connect(function()
                    callback(TextBox.Text)
                end)
            end
        end

        sidebar2.MouseButton1Click:Connect(function()
            sec:Select()
        end)

        return sec
    end

    return window
end

return lib
