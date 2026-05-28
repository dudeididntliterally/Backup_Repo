if not game:IsLoaded() then game.Loaded:Wait() end
task.wait()
local g = getgenv()
if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Global_Environment.lua"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end
task.wait(0.5)
local player = g.LocalPlayer or game.Players.LocalPlayer
local p_g = player:FindFirstChild("PlayerGui") or player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")
local FlamesLibrary = getgenv().FlamesLibrary
local RunService = getgenv().RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local UserInputService = getgenv().UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local Silent_Streamer = loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Silent_Streamer_Parts.lua"))()
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Nebula.lua", true))()
local Window = Luna:CreateWindow({
    Name = "Flames Hub | CDU",
    Subtitle = "Flames Hub | Car Driving Ultimate.",
    LogoID = "0",
    LoadingEnabled = true,
    LoadingTitle = "Flames Hub | Presents",
    LoadingSubtitle = "by Flames Hub.",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "Big Hub"
    },

    KeySystem = false,
    KeySettings = {
        Title = "Flames Hub | Key System",
        Subtitle = "",
        Note = "Welcome to: Flames Hub | Car Driving Ultimate!",
        SaveInRoot = false,
        SaveKey = true,
        Key = {"Example Key"},
        SecondAction = {
            Enabled = false,
            Type = "Link",
            Parameter = ""
        }
    }
})

for _, v in ipairs(p_g:GetChildren()) do
	if v:IsA("ScreenGui") and v.Name:lower():find("loading") then
		if v.Enabled then
            if getgenv().notify then getgenv().notify("Info", "Waiting on the game to load...", 10) end
			repeat task.wait() until not v.Enabled or not v.Parent
		end
	end
end
wait(0.25)
local function find_value(cache_key, parent, class_name, search_terms)
    if not cache_key or not parent then return nil end
    local cache = getgenv()[cache_key]
    if cache and cache.Parent and cache:IsA(class_name) then return cache end

    for _, v in ipairs(parent:GetDescendants()) do
        if v:IsA(class_name) then
            local name_lower = v.Name:lower()
            local match = true

            for _, term in ipairs(search_terms) do
                if not name_lower:find(term:lower()) then
                    match = false
                    break
                end
            end

            if match then
                getgenv()[cache_key] = v
                return v
            end
        end
    end

    return nil
end

local function find_value_via_children(cache_key, parent, class_name, search_terms)
    if not cache_key or not parent then return nil end
    local cache = getgenv()[cache_key]
    if cache and cache.Parent and cache:IsA(class_name) then return cache end

    for _, v in ipairs(parent:GetChildren()) do
        if v:IsA(class_name) then
            local name_lower = v.Name:lower()
            local match = true

            for _, term in ipairs(search_terms) do
                if not name_lower:find(term:lower()) then
                    match = false
                    break
                end
            end

            if match then
                getgenv()[cache_key] = v
                return v
            end
        end
    end

    return nil
end
wait(0.25)
local r_s = getgenv().ReplicatedStorage or cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
local p_s = getgenv().Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local human = getgenv().Humanoid or getgenv().Character and getgenv().Character:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer, 5)
local speaker = getgenv().LocalPlayer or p_s.LocalPlayer
local player_g = getgenv().PlayerGui or p_g or speaker:FindFirstChild("PlayerGui") or speaker:FindFirstChildOfClass("PlayerGui")
local Home_Tab = Window:CreateTab({Name = "🏡 Home 🏡", Icon = "view_in_ar", ImageSource = "Material", ShowTitle = true})
local Home_Section = Home_Tab:CreateSection("Section | Home Page")
local Vehicle_Tab = Window:CreateTab({Name = "🏎️ Vehicle 🏎️", Icon = "view_in_ar", ImageSource = "Material", ShowTitle = true})
local Vehicle_Section = Vehicle_Tab:CreateSection("Section | Vehicle Page")
local function check_graphics_and_stream()
	if getgenv().Streaming_Parts_In_Has_Finished then return end
	local quality = settings().Rendering.QualityLevel.Value
    local new_message = Instance.new("Message")
    new_message.Name = "FlamesHubMessage"
    new_message.Text = "We are currently streaming in parts for your graphics, please wait!\n\nThis won't take very long.\n\nBrought to you by: Flames Hub."
    new_message.Parent = workspace
	if quality < 8 then
		getgenv().notify("Warning", "Low graphics detected (level " .. quality .. "), streaming in chunks... (WAIT!)", 10)
		if getgenv().StartStream then
			getgenv().StartStream()
			repeat task.wait(0.5) until getgenv().Streaming_Parts_In_Has_Finished == true
			getgenv().notify("Success", "Streaming done.", 5)
            if workspace:FindFirstChildOfClass("Message") then workspace:FindFirstChildOfClass("Message"):Destroy() end
		end
	end
end

getgenv().check_graphics_and_stream = check_graphics_and_stream
getgenv().check_graphics_and_stream()
getgenv().get_current_vehicle = function()
	for _, v in ipairs(workspace:GetChildren()) do
		if v:IsA("Model") and v.Name == speaker.Name.."sCar" then
			return v
		end
	end

	return nil
end

getgenv().get_player_vehicle = function(player)
    player = findplr(player)
    if not player then return nil end

    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v.Name == player.Name.."sCar" then
            return v
        end
    end

    return nil
end

-- [[ very specific, I know. ]] --
local function find_correct_race_countdown_label()
    for _, v in ipairs(p_g:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == "RaceCountdownGui" then
            for _, label in ipairs(v:GetChildren()) do
                if label:IsA("TextLabel") and label.TextBounds == Vector2.new(137, 47) then
                    return label
                end
            end
        end
    end

    return nil
end

local TweenService = getgenv().TweenService or cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
local TWEEN_TIME = 1.5
local TOUCH_WAIT = 0.1
local TOUCHED_THRESHOLD = 0.9
local VEHICLE_HEIGHT_OFFSET = 5
local function is_checkpoint_active(checkpoint_name)
    local folder = workspace:FindFirstChild("Checkpoints")
    if not folder or not folder:IsA("Folder") then getgenv().notify("Error", "Checkpoints not found in Workspace or is not a Folder.", 5) return false end
	local part = workspace.Checkpoints:FindFirstChild(checkpoint_name)
	if not part then return false end
	return part.LocalTransparencyModifier < 0.9
end

local function get_missing_checkpoints()
	local folder = workspace:FindFirstChild("Checkpoints")
	if not folder then
		getgenv().notify("Error", "workspace.Checkpoints not found.", 5)
		return nil
	end

	local missing = {}
	for i = 1, 20 do
		local name = "Checkpoint" .. i
		if not folder:FindFirstChild(name) then
			table.insert(missing, name)
		end
	end

	if #missing > 0 then
		getgenv().notify("Warning", "Missing " .. #missing .. " checkpoint(s), streaming in...", 5)
		if getgenv().StartStream then getgenv().StartStream() end
		repeat task.wait(0.5) until getgenv().Streaming_Parts_In_Has_Finished == true
		getgenv().notify("Success", "Streaming done, all checkpoints present.", 5)
	else
		getgenv().notify("Success", "All checkpoints present.", 5)
	end

	return missing
end

local function is_in_race()
	local folder = workspace:FindFirstChild("Checkpoints")
	if not folder then return false end
	local parts = folder:GetChildren()
	if #parts == 0 then return false end
	local checks = {
		parts[1],
		parts[math.floor(#parts / 2)],
		parts[#parts]
	}

	local count = 0
	for _, part in ipairs(checks) do
		if part:IsA("BasePart") and part:FindFirstChildOfClass("TouchTransmitter") then
			count = count + 1
		end
	end

	return count >= 2
end

local function get_vehicle_root()
	if not getgenv().get_current_vehicle then
		getgenv().notify("Error", "get_current_vehicle is not defined.", 5)
		return nil, nil
	end

	local vehicle = getgenv().get_current_vehicle()
	if not vehicle then
		getgenv().notify("Error", "get_current_vehicle() returned nil.", 5)
		return nil, nil
	end

	if not vehicle:IsDescendantOf(workspace) then
		getgenv().notify("Error", "Vehicle is not in workspace.", 5)
		return nil, nil
	end

	local root = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
	if not root then
		getgenv().notify("Error", "Vehicle has no BasePart.", 5)
		return nil, nil
	end

	return vehicle, root
end

local function get_checkpoint_part(checkpoint_name)
	if not checkpoint_name or type(checkpoint_name) ~= "string" then
		getgenv().notify("Error", "Checkpoint name must be a string.", 5)
		return nil
	end

	local folder = workspace:FindFirstChild("Checkpoints")
	if not folder then
		getgenv().notify("Error", "workspace.Checkpoints not found.", 5)
		return nil
	end

	local part = folder:FindFirstChild(checkpoint_name)
	if not part then
		local timeout = 10
		local elapsed = 0
		repeat
			task.wait(0.1)
			elapsed = elapsed + 0.1
			part = folder:FindFirstChild(checkpoint_name)
		until part or elapsed >= timeout
	end

	if not part then
		getgenv().notify("Error", "Checkpoint not found after waiting: " .. checkpoint_name, 5)
		return nil
	end

	return part
end

local function tween_vehicle_to(target_cf)
	if not target_cf then getgenv().notify("Error", "No target CFrame provided.", 5) return false end
	local vehicle, root = get_vehicle_root()
	if not vehicle or not root then return false end
	local was_flying = getgenv().vehicle_fly
	if not was_flying then getgenv().toggle_vehicle_fly() task.wait(0.1) end
	local base = vehicle:FindFirstChild("DriveSeat") or root
	local start_cf = base.CFrame
	local target = target_cf + Vector3.new(0, VEHICLE_HEIGHT_OFFSET, 0)
	local elapsed = 0

	getgenv().FlamesLibrary.connect("checkpoint_tween", RunService.Heartbeat:Connect(function(dt)
		elapsed = elapsed + dt
		local alpha = math.clamp(elapsed / TWEEN_TIME, 0, 1)
		local eased = 1 - math.pow(1 - alpha, 3)
		base.CFrame = start_cf:Lerp(target, eased)
		if alpha >= 1 then
			getgenv().FlamesLibrary.disconnect("checkpoint_tween")
		end
	end))
	task.wait(TWEEN_TIME)
	if not was_flying then getgenv().toggle_vehicle_fly() end
	return true
end

local function fire_checkpoint(checkpoint_name)
	local part = get_checkpoint_part(checkpoint_name)
	if not part then return false end
	local _, root = get_vehicle_root()
	if not root then return false end
    if firetouchinterest then
        firetouchinterest(root, part, 0)
        task.wait(TOUCH_WAIT)
        firetouchinterest(root, part, 1)
    end
	return true
end

local function teleport_to_checkpoint(checkpoint_name)
	local part = get_checkpoint_part(checkpoint_name)
	if not part then return false end
	local tweened = tween_vehicle_to(part.CFrame)
	if not tweened then return false end
	local fired = fire_checkpoint(checkpoint_name)
	if fired then getgenv().notify("Success", "Teleported to: "..tostring(checkpoint_name), 1) end

	return fired
end

local function is_finish_touched()
	local part = workspace:FindFirstChild("FinishPartTwo")
	if not part then return false end
	return part.LocalTransparencyModifier < TOUCHED_THRESHOLD
end

local function fire_finish()
	local part = workspace:FindFirstChild("FinishPartTwo")
	if not part then
		getgenv().notify("Error", "FinishPartTwo not found.", 5)
		return false
	end

	local _, root = get_vehicle_root()
	if not root then return false end

	local tweened = tween_vehicle_to(part.CFrame)
	if not tweened then return false end

	if firetouchinterest then
		firetouchinterest(root, part, 0)
		task.wait(TOUCH_WAIT)
		firetouchinterest(root, part, 1)
	end

	getgenv().notify("Success", "Race finished!", 5)
	return true
end

local function skip_to_checkpoint(checkpoint_name)
	if not is_in_race() then
		getgenv().notify("Warning", "Not currently in a race.", 5)
		return false
	end

	local target_num = tonumber(checkpoint_name:match("%d+"))
	if not target_num or target_num < 1 or target_num > 20 then
		getgenv().notify("Error", "Invalid checkpoint: " .. tostring(checkpoint_name), 5)
		return false
	end

	local missing = get_missing_checkpoints()
	if missing and #missing > 0 then
		if not is_in_race() then
			getgenv().notify("Error", "Race ended while streaming checkpoints.", 5)
			return false
		end
	end

	for i = 1, target_num do
		local name = "Checkpoint" .. i
		if not is_checkpoint_active(name) then
			local done = teleport_to_checkpoint(name)
			if not done then
				getgenv().notify("Warning", "Failed at: " .. name, 5)
				return false
			end
		end
	end

	if target_num == 20 then return fire_finish() end
	return true
end

getgenv().teleport_to_checkpoint = teleport_to_checkpoint
getgenv().skip_to_checkpoint = skip_to_checkpoint
getgenv().is_checkpoint_active = is_checkpoint_active
getgenv().is_finish_touched = is_finish_touched
getgenv().get_missing_checkpoints = get_missing_checkpoints
-- [[ Really helpful system to locate the correct RemoteEvent to use for manipulating Sound instances in the currently spawned Vehicle. ]] --
getgenv().get_vehicle_sound_system = function(Vehicle)
    if not Vehicle then
        getgenv().Vehicle_Sound_Remote_System = nil
        return
    end
    local AC6_Sound = Vehicle:FindFirstChild("AC6_Sound")
    if AC6_Sound and AC6_Sound:IsA("RemoteEvent") then
        local Exhaust = Vehicle:FindFirstChild("Exh", true)
        getgenv().Vehicle_Sound_Remote_System = {
            Type = "AC6",
            Remote = AC6_Sound,
            Exhaust = Exhaust,
            Play = function()
                if not Exhaust then return end
                for _, v in ipairs(Exhaust:GetChildren()) do
                    if v:IsA("Sound") then AC6_Sound:FireServer("playSound", v) end
                end
            end,
            Stop = function()
                if not Exhaust then return end
                for _, v in ipairs(Exhaust:GetChildren()) do
                    if v:IsA("Sound") then AC6_Sound:FireServer("stopSound", v) end
                end
            end
        }
        return
    end
    local Sounds = Vehicle:FindFirstChild("Sounds")
    if Sounds and Sounds:IsA("RemoteEvent") then
        local BoostSounds = Vehicle:FindFirstChild("BoostSounds")
        local Has_Boost = BoostSounds and BoostSounds:IsA("RemoteEvent") or false
        getgenv().Vehicle_Sound_Remote_System = {
            Type = "Engine",
            Remote = Sounds,
            BoostRemote = Has_Boost and BoostSounds or nil,
            Play = function()
                Sounds:FireServer(Vehicle, "play")
                if Has_Boost then BoostSounds:FireServer(Vehicle, "play") end
            end,
            Stop = function()
                Sounds:FireServer(Vehicle, "stop")
                if Has_Boost then BoostSounds:FireServer(Vehicle, "stop") end
            end
        }
        return
    end
    local BoostSounds = Vehicle:FindFirstChild("BoostSounds")
    if BoostSounds and BoostSounds:IsA("RemoteEvent") then
        getgenv().Vehicle_Sound_Remote_System = {
            Type = "Boost",
            Remote = BoostSounds,
            Play = function()
                BoostSounds:FireServer(Vehicle, "play")
            end,
            Stop = function()
                BoostSounds:FireServer(Vehicle, "stop")
            end
        }
        return
    end
    getgenv().Vehicle_Sound_Remote_System = nil
end

-- [[ keep it at: task.wait(0.18), any lower will increase lag and the map won't load, especially if the user is on low graphics settings. ]] --
getgenv().start_flames_value_watcher = function(Values)
    if not Values then return end
    local RPM_Value = Values:FindFirstChild("RPM")
    local Throttle_Value = Values:FindFirstChild("Throttle")
    local RPM_Locked = false
    local Throttle_Locked = false
    if RPM_Value and RPM_Value:IsA("NumberValue") then
        RPM_Value.Value = 9999
        getgenv().FlamesLibrary.connect("flames_rpm_watcher", RPM_Value.Changed:Connect(function(val)
            if RPM_Locked then return end
            if val ~= 9999 then
                RPM_Locked = true
                task.wait(0.18)
                RPM_Value.Value = 9999
                RPM_Locked = false
            end
        end))
    end
    if Throttle_Value and Throttle_Value:IsA("NumberValue") then
        Throttle_Value.Value = 0
        getgenv().FlamesLibrary.connect("flames_throttle_watcher", Throttle_Value.Changed:Connect(function(val)
            if Throttle_Locked then return end
            if val ~= 0 then
                Throttle_Locked = true
                task.wait(0.18)
                Throttle_Value.Value = 0
                Throttle_Locked = false
            end
        end))
    end
end

getgenv().stop_flames_value_watcher = function()
    getgenv().FlamesLibrary.disconnect("flames_rpm_watcher")
    getgenv().FlamesLibrary.disconnect("flames_throttle_watcher")
end

-- [[ The current name: 'A-Chassis Interface', but this is just for if they ever change it, it'll still hopefully find it. ]] --
getgenv().Find_A_Chassis_GUI = function()
    for _, v in ipairs(player_g:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name:lower():find("chassis") then
            return v
        end
    end

    return nil
end

getgenv().start_flames_on_car = function(flames_toggled)
    if flames_toggled == true then
        if getgenv().flames_on_car_loop_toggled then return end
        local current_vehicle = getgenv().get_current_vehicle()
        if not current_vehicle then
            if getgenv().Flames_Loop_Enabled_Toggle then getgenv().Flames_Loop_Enabled_Toggle:Set({CurrentValue = false}) end
            getgenv().flames_on_car_loop_toggled = false
            return getgenv().notify("Error", "You do not have a Vehicle spawned or it was destroyed.", 5)
        end
        local A_Chassis_Tune_GUI = getgenv().Find_A_Chassis_GUI()
        if not A_Chassis_Tune_GUI or not A_Chassis_Tune_GUI:IsA("ScreenGui") then
            if getgenv().Flames_Loop_Enabled_Toggle then getgenv().Flames_Loop_Enabled_Toggle:Set({CurrentValue = false}) end
            getgenv().flames_on_car_loop_toggled = false
            return getgenv().notify("Error", "A-Chassis ScreenGui not found or is not a ScreenGui!", 5)
        end
        local Values = A_Chassis_Tune_GUI:FindFirstChild("Values", true)
        if not Values or not Values:IsA("Folder") then
            if getgenv().Flames_Loop_Enabled_Toggle then getgenv().Flames_Loop_Enabled_Toggle:Set({CurrentValue = false}) end
            getgenv().flames_on_car_loop_toggled = false
            return getgenv().notify("Error", "Values Folder not found or is not a Folder!", 5)
        end
        getgenv().flames_on_car_loop_toggled = true
        getgenv().start_flames_value_watcher(Values)
        getgenv().notify("Success", "Vehicle Flames is now enabled.", 1.5)
    elseif flames_toggled == false then
        getgenv().flames_on_car_loop_toggled = false
        getgenv().stop_flames_value_watcher()
        getgenv().notify("Success", "Vehicle Flames is now disabled.", 1.5)
    end
end

getgenv().start_all_smoked_car = function(smoke_toggled)
	if smoke_toggled == true then
		if getgenv().smoked_car_loop_toggled then return end
		local current_vehicle = getgenv().get_current_vehicle()
		if not current_vehicle then
            if getgenv().Car_Smoke_Enabled_Toggle then getgenv().Car_Smoke_Enabled_Toggle:Set({CurrentValue = false}) end
            return getgenv().notify("Error", "You do not have a Vehicle spawned or it was destroyed.", 5)
        end
		local smoke_re = current_vehicle:FindFirstChild("Smoke_FE")
		if not smoke_re or not smoke_re:IsA("RemoteEvent") then
            if getgenv().Car_Smoke_Enabled_Toggle then getgenv().Car_Smoke_Enabled_Toggle:Set({CurrentValue = false}) end
            return getgenv().notify("Error", "Smoke_FE RemoteEvent not found or is not a RemoteEvent!", 5)
        end
		getgenv().smoked_car_loop_toggled = true
        getgenv().notify("Success", "Vehicle Smoke is now enabled.", 1.5)
		while getgenv().smoked_car_loop_toggled == true do
			task.wait(0.003)
			if not current_vehicle or not current_vehicle.Parent then
				getgenv().smoked_car_loop_toggled = false
                if getgenv().Car_Smoke_Enabled_Toggle then getgenv().Car_Smoke_Enabled_Toggle:Set({CurrentValue = false}) end
				break
			end
			smoke_re:FireServer("UpdateSmoke", 50, 50)
		end
	elseif smoke_toggled == false then
		getgenv().smoked_car_loop_toggled = false
        getgenv().notify("Success", "Vehicle Smoke is now disabled.", 1.5)
	end
end

getgenv().start_backfiring_flames_car = function(backfiring_toggled)
	if backfiring_toggled == true then
		if getgenv().backfired_car_loop_toggled then return end
		local current_vehicle = getgenv().get_current_vehicle()
		if not current_vehicle then
            if getgenv().Car_Backfiring_FE_Enabled_Toggle then getgenv().Car_Backfiring_FE_Enabled_Toggle:Set({CurrentValue = false}) end
            return getgenv().notify("Error", "You do not have a Vehicle spawned or it was destroyed.", 5)
        end
		local backfire_re = current_vehicle:FindFirstChild("Backfire_FE")
		if not backfire_re or not backfire_re:IsA("RemoteEvent") then
            if getgenv().Car_Backfiring_FE_Enabled_Toggle then getgenv().Car_Backfiring_FE_Enabled_Toggle:Set({CurrentValue = false}) end
            return getgenv().notify("Error", "Backfire_FE RemoteEvent not found or is not a RemoteEvent!", 5)
        end
		getgenv().backfired_car_loop_toggled = true
        getgenv().notify("Success", "Vehicle Back-Fire is now enabled.", 1.5)
		while getgenv().backfired_car_loop_toggled == true do
			task.wait(0.001)
			if not current_vehicle or not current_vehicle.Parent then
                if getgenv().Car_Backfiring_FE_Enabled_Toggle then getgenv().Car_Backfiring_FE_Enabled_Toggle:Set({CurrentValue = false}) end
				getgenv().backfired_car_loop_toggled = false
				break
			end
            backfire_re:FireServer("Backfire2")
		end
	elseif backfiring_toggled == false then
		getgenv().backfired_car_loop_toggled = false
        getgenv().notify("Success", "Vehicle Back-Fire is now disabled.", 1.5)
	end
end

getgenv().gamepass_cars_unlocked_hooked = getgenv().gamepass_cars_unlocked_hooked or false
getgenv().unlock_gamepass_cars_menus = function()
    if getgenv().gamepass_cars_unlocked_hooked then return end
    getgenv().gamepass_cars_unlocked_hooked = true
    for _, v in ipairs(cloneref(game:GetService("Players")).LocalPlayer.PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") and v:FindFirstChild("Spawn") and v.Name ~= "Spawn dos" and v.Name ~= "ShopGpass" then
            local Button = v:FindFirstChildOfClass("ImageButton")
            local Frame = v:FindFirstChildOfClass("Frame")
            local Button_LocalScript = Button and Button:FindFirstChildOfClass("LocalScript")
            if Button and Button.Name:lower():find("spawn") then
                local Connection_Name = "gamepass_spawn_btn_" .. v.Name
                getgenv().FlamesLibrary.connect(Connection_Name, Button.Activated:Connect(function()
                    if Button_LocalScript then Button_LocalScript.Disabled = true end
                    if Frame then Frame.Visible = not Frame.Visible end
                end))
            end
        end
    end
    getgenv().FlamesLibrary.connect("gamepass_respawn_watcher", cloneref(game:GetService("Players")).LocalPlayer.CharacterAdded:Connect(function()
        getgenv().gamepass_cars_unlocked_hooked = false
        task.wait(1)
        getgenv().unlock_gamepass_cars_menus()
    end))
end

getgenv().glitched_sound_on_vehicle_toggle = function(toggled)
    if toggled == true then
        local Vehicle = getgenv().get_current_vehicle()
        if not Vehicle then
            if getgenv().Glitch_Sound_Effects_Vehicle then getgenv().Glitch_Sound_Effects_Vehicle:Set({CurrentValue = false}) end
            getgenv().play_glitching_sound_on_vehicle = false
            return getgenv().notify("Error", "You do not have a Vehicle spawned or it was destroyed.", 5)
        end
        getgenv().get_vehicle_sound_system(Vehicle)
        local System = getgenv().Vehicle_Sound_Remote_System
        if not System then
            if getgenv().Glitch_Sound_Effects_Vehicle then getgenv().Glitch_Sound_Effects_Vehicle:Set({CurrentValue = false}) end
            getgenv().play_glitching_sound_on_vehicle = false
            return getgenv().notify("Error", "No sound system found on Vehicle.", 5)
        end
        getgenv().play_glitching_sound_on_vehicle = true
        getgenv().notify("Success", "Vehicle Sounds Glitcher is now enabled.", 1.5)
        while getgenv().play_glitching_sound_on_vehicle == true do
            if not Vehicle or not Vehicle.Parent then
                if getgenv().Glitch_Sound_Effects_Vehicle then getgenv().Glitch_Sound_Effects_Vehicle:Set({CurrentValue = false}) end
                getgenv().play_glitching_sound_on_vehicle = false
                break
            end
            System.Play() task.wait(0.035)
            System.Stop() task.wait(0.035)
            System.Play() task.wait(0.035)
        end
    elseif toggled == false then
        getgenv().play_glitching_sound_on_vehicle = false
        getgenv().notify("Success", "Vehicle Sounds Glitcher is now disabled.", 1.5)
    end
end

getgenv().stop_sounds_on_vehicle_toggle = function(toggled)
    if toggled == true then
        local Vehicle = getgenv().get_current_vehicle()
        if not Vehicle then
            if getgenv().Stop_Sound_Effects_Vehicle then getgenv().Stop_Sound_Effects_Vehicle:Set({CurrentValue = false}) end
            getgenv().stopping_sound_on_vehicle = false
            return getgenv().notify("Error", "You do not have a Vehicle spawned or it was destroyed.", 5)
        end
        getgenv().get_vehicle_sound_system(Vehicle)
        local System = getgenv().Vehicle_Sound_Remote_System
        if not System then
            if getgenv().Stop_Sound_Effects_Vehicle then getgenv().Stop_Sound_Effects_Vehicle:Set({CurrentValue = false}) end
            getgenv().stopping_sound_on_vehicle = false
            return getgenv().notify("Error", "No sound system found on Vehicle.", 5)
        end
        getgenv().stopping_sound_on_vehicle = true
        getgenv().notify("Success", "Vehicle Sounds Stopper is now enabled.", 1.5)
        while getgenv().stopping_sound_on_vehicle == true do
            if not Vehicle or not Vehicle.Parent then
                if getgenv().Stop_Sound_Effects_Vehicle then getgenv().Stop_Sound_Effects_Vehicle:Set({CurrentValue = false}) end
                getgenv().stopping_sound_on_vehicle = false
                break
            end
            System.Stop() task.wait(0.035)
        end
    elseif toggled == false then
        getgenv().stopping_sound_on_vehicle = false
        getgenv().notify("Success", "Vehicle Sounds Stopper is now disabled.", 1.5)
        local Vehicle = getgenv().get_current_vehicle()
        if not Vehicle then return end
        local System = getgenv().Vehicle_Sound_Remote_System
        if not System then return end
        task.wait(0.25)
        System.Play()
    end
end

getgenv().vehicle_speed_boost_toggle = function(toggled)
    if toggled == true then
        if getgenv().vehicle_speed_boost_active then return end
        local current_vehicle = getgenv().get_current_vehicle()
        if not current_vehicle then
            if getgenv().Vehicle_Speed_Boost_Toggle then getgenv().Vehicle_Speed_Boost_Toggle:Set({CurrentValue = false}) end
            return getgenv().notify("Error", "No vehicle found.", 5)
        end
        local DriveSeat = current_vehicle:FindFirstChildOfClass("VehicleSeat")
        if not DriveSeat then
            if getgenv().Vehicle_Speed_Boost_Toggle then getgenv().Vehicle_Speed_Boost_Toggle:Set({CurrentValue = false}) end
            return getgenv().notify("Error", "No VehicleSeat found.", 5)
        end
        local Player = cloneref(game:GetService("Players")).LocalPlayer
        local Current_Speed = 0
        local S_Hold_Start = nil
        local Is_Mobile = cloneref(game:GetService("UserInputService")).TouchEnabled
        local BV = DriveSeat:FindFirstChild("FlamesSpeedBoost") or Instance.new("BodyVelocity")
        BV.Name = "FlamesSpeedBoost"
        BV.MaxForce = Vector3.new(9e9, 0, 9e9)
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.Parent = DriveSeat
        local BG = DriveSeat:FindFirstChild("FlamesSpeedGyro") or Instance.new("BodyGyro")
        BG.Name = "FlamesSpeedGyro"
        BG.P = 9e4
        BG.MaxTorque = Vector3.new(0, 9e9, 0)
        BG.CFrame = DriveSeat.CFrame
        BG.Parent = DriveSeat
        getgenv().vehicle_speed_boost_active = true
        getgenv().vehicle_speed_boost_max_forward = getgenv().vehicle_speed_boost_max_forward or 425
        getgenv().vehicle_speed_boost_max_backward = getgenv().vehicle_speed_boost_max_backward or 125
        getgenv().vehicle_speed_boost_acceleration = getgenv().vehicle_speed_boost_acceleration or 10
        getgenv().notify("Success", "Vehicle Speed Boost is now enabled.", 1.5)
        getgenv().FlamesLibrary.spawn("vehicle_speed_boost_loop", "spawn", function()
            while getgenv().vehicle_speed_boost_active do
                if not current_vehicle or not current_vehicle.Parent then
                    getgenv().vehicle_speed_boost_active = false
                    if getgenv().Apply_Best_Vehicle_Settings then getgenv().Apply_Best_Vehicle_Settings:Set({CurrentValue = false}) end
                    break
                end
                local Max_Forward_Speed = getgenv().vehicle_speed_boost_max_forward or 425
                local Max_Backward_Speed = getgenv().vehicle_speed_boost_max_backward or 125
                local Acceleration = getgenv().vehicle_speed_boost_acceleration or 10
                local Throttle = DriveSeat.Throttle
                if Is_Mobile then
                    local ControlModule = require(Player.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
                    local Direction = ControlModule:GetMoveVector()
                    Throttle = -Direction.Z
                end
                if Throttle > 0 then
                    S_Hold_Start = nil
                    Current_Speed = math.min(Current_Speed + Acceleration, Max_Forward_Speed)
                    BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
                    BG.CFrame = DriveSeat.CFrame
                elseif Throttle < 0 then
                    if not S_Hold_Start then S_Hold_Start = tick() end
                    if tick() - S_Hold_Start >= 0.45 then
                        Current_Speed = math.max(Current_Speed - Acceleration, -Max_Backward_Speed)
                        BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
                    else
                        Current_Speed = math.max(Current_Speed - Acceleration * 3, 0)
                        BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
                    end
                else
                    S_Hold_Start = nil
                    Current_Speed = math.max(Current_Speed - Acceleration * 2, 0)
                    BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
                end
                task.wait(0.03)
            end
            BV:Destroy()
            BG:Destroy()
        end)
    elseif toggled == false then
        getgenv().vehicle_speed_boost_active = false
        local current_vehicle = getgenv().get_current_vehicle()
        if not current_vehicle then return end
        local DriveSeat = current_vehicle:FindFirstChildOfClass("VehicleSeat")
        if not DriveSeat then return end
        local BV = DriveSeat:FindFirstChild("FlamesSpeedBoost")
        local BG = DriveSeat:FindFirstChild("FlamesSpeedGyro")
        if BV then BV:Destroy() end
        if BG then BG:Destroy() end
        getgenv().notify("Success", "Vehicle Speed Boost is now disabled.", 1.5)
    end
end

getgenv().delete_currently_spawned_vehicle = function()
    local cache = getgenv().Delete_Vehicle_Remote_Event
    if cache and cache:IsA("RemoteEvent") then
        return cache
    end

    for _, v in ipairs(r_s:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("delete") and v.Name:lower():find("car") then
            getgenv().Delete_Vehicle_Remote_Event = v
            return v
        end
    end

    return nil
end

local isMobile = UserInputService.TouchEnabled
g.vehicle_fly = g.vehicle_fly or false
g.vehicle_fly_speed = g.vehicle_fly_speed or 3
g.vehiclefly_conns = g.vehiclefly_conns or {}
g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
g.vehiclefly_noclip = g.vehiclefly_noclip or false
g.vehiclefly_collisions = g.vehiclefly_collisions or {}
local controlModule
if UserInputService.TouchEnabled then controlModule = require(g.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")) end
g.cleanup = function()
    for _, c in pairs(g.vehiclefly_conns) do pcall(function() c:Disconnect() end) end
    g.vehiclefly_conns = {}
    if g.vehiclefly_bv then
        g.vehiclefly_bv.Velocity = Vector3.zero
        g.vehiclefly_bv:Destroy()
        g.vehiclefly_bv = nil
    end

    if g.vehiclefly_bg then
        g.vehiclefly_bg:Destroy()
        g.vehiclefly_bg = nil
    end
end

g.enable_vehicle_noclip = function()
    if g.vehiclefly_noclip then return end
    g.vehiclefly_noclip = true
    g.vehiclefly_collisions = {}
    local car = getgenv().get_current_vehicle()
    local wheels_model = car:FindFirstChild("Wheels")

    for _, v in ipairs(car:GetDescendants()) do
        if v:IsA("BasePart") then
            if wheels_model and v:IsDescendantOf(wheels_model) then continue end
            g.vehiclefly_collisions[v] = v.CanCollide
            v.CanCollide = false
        end
    end
end

g.disable_vehicle_noclip = function()
    if not g.vehiclefly_noclip then return end
    g.vehiclefly_noclip = false
    for part, state in pairs(g.vehiclefly_collisions) do if part and part.Parent then part.CanCollide = state end end
    g.vehiclefly_collisions = {}
end

g.start_vehicle_fly = function()
    if g.vehiclefly_bg or g.vehiclefly_bv then return end
    local car = getgenv().get_current_vehicle()
    local base = car:FindFirstChild("DriveSeat") or car:FindFirstChildWhichIsA("BasePart")
    if not base then return end
    local bg = Instance.new("BodyGyro")
    bg.P = 3e4
    bg.D = 1e3
    bg.MaxTorque = Vector3.new(0, 9e9, 0)
    bg.CFrame = base.CFrame
    bg.Parent = base

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = base
    g.vehiclefly_bg = bg
    g.vehiclefly_bv = bv

    g.vehiclefly_conns.render = RunService.Heartbeat:Connect(function()
        if not g.vehicle_fly or not base.Parent then
            bv.Velocity = Vector3.zero
            g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
            return
        end

        base.AssemblyAngularVelocity = Vector3.zero
        local cam = workspace.CurrentCamera

        if isMobile then
            bg.CFrame = cam.CFrame
            local mv = controlModule:GetMoveVector()
            local vel = Vector3.zero
            if mv.X ~= 0 then vel = vel + cam.CFrame.RightVector * (mv.X * (45 * g.vehicle_fly_speed)) end
            if mv.Z ~= 0 then vel = vel - cam.CFrame.LookVector * (mv.Z * (45 * g.vehicle_fly_speed)) end
            bv.Velocity = vel
        else
            local look = cam.CFrame.LookVector
            local yaw = math.atan2(-look.X, -look.Z)
            bg.CFrame = CFrame.new(base.Position) * CFrame.Angles(0, yaw, 0)
            local c = g.vehiclefly_control
            local forward = (c.f or 0) + (c.b or 0)
            local right = (c.l or 0) + (c.r or 0)
            local up = (c.q or 0) + (c.e or 0)
            bv.Velocity = (cam.CFrame.LookVector * forward + cam.CFrame.RightVector * right + Vector3.new(0, up, 0)) * (45 * g.vehicle_fly_speed)
        end
    end)

    if not isMobile then
        g.vehiclefly_conns.down = UserInputService.InputBegan:Connect(function(i, gameProcessed)
            if gameProcessed then return end
            if i.KeyCode == Enum.KeyCode.W then g.vehiclefly_control.f = 1  end
            if i.KeyCode == Enum.KeyCode.S then g.vehiclefly_control.b = -1 end
            if i.KeyCode == Enum.KeyCode.A then g.vehiclefly_control.l = -1 end
            if i.KeyCode == Enum.KeyCode.D then g.vehiclefly_control.r = 1  end
            if i.KeyCode == Enum.KeyCode.E then g.vehiclefly_control.q = 1  end
            if i.KeyCode == Enum.KeyCode.Q then g.vehiclefly_control.e = -1 end
        end)

        g.vehiclefly_conns.up = UserInputService.InputEnded:Connect(function(i)
            if i.KeyCode == Enum.KeyCode.W then g.vehiclefly_control.f = 0 end
            if i.KeyCode == Enum.KeyCode.S then g.vehiclefly_control.b = 0 end
            if i.KeyCode == Enum.KeyCode.A then g.vehiclefly_control.l = 0 end
            if i.KeyCode == Enum.KeyCode.D then g.vehiclefly_control.r = 0 end
            if i.KeyCode == Enum.KeyCode.E then g.vehiclefly_control.q = 0 end
            if i.KeyCode == Enum.KeyCode.Q then g.vehiclefly_control.e = 0 end
        end)
    end
end

g.stop_vehicle_fly = function()
    g.vehicle_fly = false
    g.disable_vehicle_noclip()
    g.cleanup()
    g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
end

g.toggle_vehicle_fly = function()
    if g.vehicle_fly then
        g.stop_vehicle_fly()
    else
        g.vehicle_fly = true
        g.enable_vehicle_noclip()
        g.start_vehicle_fly()
    end
end

-- [[ if they for some reason don't try & use these, there's no way they'd do that though. ]] --
local arguments_to_try = {
    "destroy", "DESTROY",
    "delete", "DELETE",
    "despawn", "DESPAWN",
    "despawn_vehicle", "DESPAWN_VEHICLE",
    "despawn_car", "DESPAWN_CAR",
    "despawncar", "DESPAWNCAR",
    "despawnvehicle", "DESPAWNVEHICLE",
    "deletecar", "DELETECAR",
    "deletevehicle", "DELETEVEHICLE",
    "destroycar", "DESTROYCAR",
    "destroyvehicle", "DESTROYVEHICLE",
    "remove", "REMOVE",
    "removevehicle", "REMOVEVEHICLE",
    "removecar", "REMOVECAR",
    "deletemycar", "DELETEMYCAR",
    "deletemyvehicle", "DELETEMYVEHICLE",
    "destroymycar", "DESTROYMYCAR",
    "destroymyvehicle", "DESTROYMYVEHICLE",
    "despawnmycar", "DESPAWNMYCAR",
    "despawnmyvehicle", "DESPAWNMYVEHICLE",
    "removemycar", "REMOVEMYCAR",
    "removemyvehicle", "REMOVEMYVEHICLE",
    "delvehicle", "DELVEHICLE",
    "delcar", "DELCAR",
    "del", "DEL",
    "Remove_Vehicle", "REMOVE_VEHICLE",
    "Delete_Vehicle", "DELETE_VEHICLE",
    "Destroy_Vehicle", "DESTROY_VEHICLE",
    "Despawn_Vehicle", "DESPAWN_VEHICLE",
    "Remove_Car", "REMOVE_CAR",
    "Delete_Car", "DELETE_CAR",
    "Destroy_Car", "DESTROY_CAR",
    "Despawn_Car", "DESPAWN_CAR",
    "RemoveVehicle", "DeleteVehicle",
    "DestroyVehicle", "DespawnVehicle",
    "RemoveCar", "DeleteCar",
    "DestroyCar", "DespawnCar",
    "SpawnDelete", "SPAWNDELETE",
    "spawn_delete", "SPAWN_DELETE",
    "vehicle_delete", "VEHICLE_DELETE",
    "vehicle_destroy", "VEHICLE_DESTROY",
    "vehicle_despawn", "VEHICLE_DESPAWN",
    "vehicle_remove", "VEHICLE_REMOVE",
    "car_delete", "CAR_DELETE",
    "car_destroy", "CAR_DESTROY",
    "car_despawn", "CAR_DESPAWN",
    "car_remove", "CAR_REMOVE",
}

if not getgenv().Delete_Vehicle_Remote_Event then getgenv().delete_currently_spawned_vehicle() end
wait(0.15)
-- [[ this game will NOT be able to break this system. 😭😭🙏🥀💔 ]] --
getgenv().Delete_Currently_Spawned_Vehicle_Button = Home_Tab:CreateButton({
Name = "Delete Current Vehicle (FE)",
Description = "Detects and deletes your currently spawned Vehicle.",
Callback = function()
    if getgenv().delete_vehicle_running then return getgenv().notify("Warning", "Already attempting to delete vehicle.", 3) end
    local current_vehicle = getgenv().get_current_vehicle()
    if not current_vehicle then return getgenv().notify("Error", "You do not have a Vehicle spawned or it was destroyed.", 5) end
    local RE = getgenv().Delete_Vehicle_Remote_Event or getgenv().delete_currently_spawned_vehicle()
    if not RE then return getgenv().notify("Error", "No RemoteEvent found.", 5) end
    local wait_time_out_maximum_time = 20
    getgenv().delete_vehicle_running = true
    local function check_deleted()
        local start = tick()
        while tick() - start < wait_time_out_maximum_time do
            if not current_vehicle or not current_vehicle.Parent then
                getgenv().notify("Success", "Vehicle deleted.", 3)
                getgenv().delete_vehicle_running = false
                return true
            end
            task.wait(0.5)
        end
        getgenv().delete_vehicle_running = false
        return false
    end
    local function try_one(fire_func)
        pcall(fire_func)
        return check_deleted()
    end
    local function try_remote(fire_func)
        if try_one(fire_func) then return true end
        if try_one(function() fire_func(current_vehicle) end) then return true end
        for _, arg in ipairs(arguments_to_try) do
            if try_one(function() fire_func(arg) end) then return true end
            if try_one(function() fire_func(arg, current_vehicle) end) then return true end
            if try_one(function() fire_func(current_vehicle, arg) end) then return true end
        end
        if try_one(function() fire_func(current_vehicle.Name) end) then return true end
        if try_one(function() fire_func(current_vehicle.Name:lower()) end) then return true end
        if try_one(function() fire_func(current_vehicle.Name, current_vehicle) end) then return true end
        if try_one(function() fire_func(current_vehicle.Name:lower(), current_vehicle) end) then return true end
        return false
    end
    if RE:IsA("RemoteEvent") then
        if try_remote(function(...) RE:FireServer(...) end) then return end
    end
    if RE:IsA("RemoteFunction") then
        if try_remote(function(...) RE:InvokeServer(...) end) then return end
    end
    getgenv().delete_vehicle_running = false
    getgenv().notify("Error", "Failed to delete Vehicle.", 5)
end})

getgenv().Apply_Best_Vehicle_Settings = Home_Tab:CreateToggle({
Name = "Better Speed System (FE)",
Description = "Applies the best & fastest Vehicle settings.",
CurrentValue = getgenv().vehicle_speed_boost_active or false,
Callback = function(toggled)
    if toggled then
        getgenv().vehicle_speed_boost_toggle(true)
    else
        getgenv().vehicle_speed_boost_toggle(false)
    end
end}, "Apply_Best_Vehicle_Settings_Toggle")

getgenv().Set_System_Forward_Speed = Home_Tab:CreateSlider({
Name = "Set 'Better System' Forward Speed (FE)",
Range = {50, 550},
Increment = 10,
CurrentValue = getgenv().vehicle_speed_boost_max_forward or 300,
Callback = function(new_forward_speed)
    getgenv().vehicle_speed_boost_max_forward = new_forward_speed
end}, "Slider_Value_Forward_Speed")

getgenv().Set_System_Backward_Speed = Home_Tab:CreateSlider({
Name = "Set 'Better System' Backward Speed (FE)",
Range = {50, 175},
Increment = 10,
CurrentValue = getgenv().vehicle_speed_boost_max_backward or 125,
Callback = function(new_backward_speed)
    getgenv().vehicle_speed_boost_max_backward = new_backward_speed
end}, "Slider_Value_Backward_Speed")

getgenv().Set_System_Acceleration = Home_Tab:CreateSlider({
Name = "Set 'Better System' Acceleration (FE)",
Range = {10, 100},
Increment = 10,
CurrentValue = getgenv().vehicle_speed_boost_acceleration or 10,
Callback = function(new_boost_acceleration)
    getgenv().vehicle_speed_boost_acceleration = new_boost_acceleration
end}, "Slider_Value_Acceleration")

getgenv().Vehicle_Fly_Toggle = Home_Tab:CreateToggle({
Name = "Vehicle Fly (FE)",
Description = "Allows you to fly your Vehicle, other people will see.",
CurrentValue = getgenv().vehicle_fly or false,
Callback = function(vehicle_fly_enabled_system)
    if vehicle_fly_enabled_system then
        getgenv().toggle_vehicle_fly()
    else
        getgenv().toggle_vehicle_fly()
    end
end,})

-- [[ I'm working on it, don't worry, it's going to be very specifically detailed though. ]] --
--[[getgenv().Finish_Race_FE = Home_Tab:CreateButton({
Name = "Finish Race (FE)",
Description = "Allows you to automatically finish the current race you're in.",
Callback = function()
    local is_racing_currently = is_in_race()
    if not is_racing_currently then return getgenv().notify("Error", "You're not currently in a race! Join one first!", 3) end
    skip_to_checkpoint("Checkpoint20")
end})--]]

getgenv().Flames_Loop_Enabled_Toggle = Vehicle_Tab:CreateToggle({
Name = "Vehicle Flames (FE)",
Description = "Makes your vehicle produce flames, which everyone can see.",
CurrentValue = getgenv().flames_on_car_loop_toggled or false,
Callback = function(flames_on_vehicle_enabled)
    if flames_on_vehicle_enabled then
        getgenv().start_flames_on_car(true)
    else
        getgenv().start_flames_on_car(false)
    end
end}, "ProduceFireFromVehicle_FE_Toggle")

getgenv().Car_Smoke_Enabled_Toggle = Vehicle_Tab:CreateToggle({
Name = "Vehicle Smoke (FE)",
Description = "Makes your vehicle produce smoke, which everyone can see.",
CurrentValue = getgenv().smoked_car_loop_toggled or false,
Callback = function(smoke_on_vehicle_toggled)
    if smoke_on_vehicle_toggled then
        getgenv().start_all_smoked_car(true)
    else
        getgenv().start_all_smoked_car(false)
    end
end}, "ProduceSmokeFromVehicle_FE_Toggle")

getgenv().Car_Backfiring_FE_Enabled_Toggle = Vehicle_Tab:CreateToggle({
Name = "Vehicle Back-Fire (FE)",
Description = "Makes your vehicle produce fire (from Backfire), which everyone can see.",
CurrentValue = getgenv().backfired_car_loop_toggled or false,
Callback = function(back_fire_on_vehicle_toggled)
    if back_fire_on_vehicle_toggled then
        getgenv().start_backfiring_flames_car(true)
    else
        getgenv().start_backfiring_flames_car(false)
    end
end}, "Back_Fire_FromVehicle_FE_Toggle")

getgenv().Unlock_All_GamePasses_FE = Vehicle_Tab:CreateButton({
Name = "Unlock All Vehicles (FE)",
Description = "Let's you use any type of Vehicle you want, without owning the gamepasses.",
Callback = function()
    getgenv().unlock_gamepass_cars_menus()
end})

getgenv().Glitch_Sound_Effects_Vehicle = Vehicle_Tab:CreateToggle({
Name = "Glitch Vehicle Sounds (FE)",
Description = "Makes your vehicles sounds glitched out, which other players can hear.",
CurrentValue = getgenv().play_glitching_sound_on_vehicle or false,
Callback = function(toggled_glitch_sounds)
    if toggled_glitch_sounds then
        getgenv().glitched_sound_on_vehicle_toggle(true)
    else
        getgenv().glitched_sound_on_vehicle_toggle(false)
    end
end}, "GlitchingSound_Effects_FE_Toggle")

getgenv().Stop_Sound_Effects_Vehicle = Vehicle_Tab:CreateToggle({
Name = "Quiet Vehicle (FE)",
Description = "Constantly stops your vehicle sounds, which other players can hear?",
CurrentValue = getgenv().stopping_sound_on_vehicle or false,
Callback = function(toggled_stop_sounds)
    if toggled_stop_sounds then
        getgenv().stop_sounds_on_vehicle_toggle(true)
    else
        getgenv().stop_sounds_on_vehicle_toggle(false)
    end
end}, "Stopping_Sound_Effects_FE_Toggle")
