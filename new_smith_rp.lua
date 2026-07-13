if not game:IsLoaded() then
   local msg_instance = Instance.new("Message")
   local hint_instance = Instance.new("Hint")
   msg_instance.Text = "Flames Hub is waiting for the current experience to load fully."
   hint_instance.Text = "Flames Hub is currently waiting for the game to load."
   msg_instance.Parent = workspace
   hint_instance.Parent = workspace
   game.Loaded:Wait()
   task.wait(0.1)
   msg_instance:Destroy()
   hint_instance:Destroy()
end

local Raw_Version = "V1.2.0"
getgenv().Script_Version = tostring(Raw_Version).."-NewSmithRP"
local g = getgenv()
if not g.GlobalEnvironmentFramework_Initialized then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Global_Environment.lua"))()
    wait(0.1)
    g.GlobalEnvironmentFramework_Initialized = true
end
wait(0.2)
if getgenv().New_Smith_RP_Hub_Loaded then return warn("Flames Hub | New Smith RP is already loaded.") end
getgenv().New_Smith_RP_Hub_Loaded = true
local function blankfunction(...) return ... end
local Player = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local speaker = g.LocalPlayer or g.Players.LocalPlayer or Players.LocalPlayer or game.Players.LocalPlayer
local player_gui = g.PlayerGui or speaker:FindFirstChildWhichIsA("PlayerGui") or speaker:FindFirstChildOfClass("PlayerGui")
local ReplicatedStorage = g.ReplicatedStorage or cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
local ProximityPromptService = g.ProximityPromptService or cloneref and cloneref(game:GetService("ProximityPromptService")) or game:GetService("ProximityPromptService")
local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local Core_Gui = get_hidden_gui and get_hidden_gui() or gethui and gethui() or CoreGui or player_gui
local FlamesLibrary = g.FlamesLibrary or getgenv().FlamesLibrary or blankfunction -- lol
local fw = FlamesLibrary.wait or task.wait or wait
function FuzzyFindChild(parent, query, timeout)
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

function FuzzyFindChildWithClass(parent, query, class_name, timeout)
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

function FuzzyFindDescendantWithClass(parent, query, class_name, timeout)
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

-- [[ As of: 7/11/2026 - 11:58 PM (EST) there is 31 jobs. ]] --
g.job_numbers_list = {
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31
}

g.current_carry_methods = {
    "Back",
    "HeadBack",
    "PrincessHug"
}

g.Encode_To_Lua_Escapes = function(Text)
    local Result = {}
    for i = 1, #Text do table.insert(Result, "\\" .. string.byte(Text, i)) end
    return table.concat(Result)
end

g.Decode_Lua_Escapes = function(Escaped_String)
    local Bytes = {}
    for Byte_Str in Escaped_String:gmatch("\\(%d+)") do table.insert(Bytes, tonumber(Byte_Str)) end
    local Chars = {}
    for _, Byte in ipairs(Bytes) do table.insert(Chars, string.char(Byte)) end
    return table.concat(Chars)
end

local words_list = {
    "root_access","packet_inject","xor_key","decrypting",
    "init_stealth","spoof_id","kernel_hook","bruteforce",
    "sys_reboot","net_breach","ghost_mode","backdoor_init"
}
task.wait(0.15)
-- [[ Get everything for free that is directly under the LocalPlayer in BoolValue instances. ]] --
for _, v in ipairs(speaker:GetChildren()) do if v:IsA("BoolValue") and v.Value == false then v.Value = true end end
local Vehicle_Frame = FuzzyFindChildWithClass(player_gui, "vehicle", "frame")
wait(0.15) -- wait because it's nested and could take longer.
local Spawn_Vehicle_RE = Vehicle_Frame and FuzzyFindChildWithClass(Vehicle_Frame, "remoteevent", "remoteevent")
local Vehicles_Scrolling_Frame = Vehicle_Frame and FuzzyFindChildWithClass(Vehicle_Frame, "scrollingframe", "scrollingframe")
local Catalog_Equip_Function = FuzzyFindDescendantWithClass(ReplicatedStorage, "catalogequipfunction", "remotefunction")
g.Paid_Vehicles = g.Paid_Vehicles or {}
g.Free_Vehicles = g.Free_Vehicles or {}
g.all_vehicle_names = {} -- dynamic
g.RP_Text_Changer_Enabled = g.RP_Text_Changer_Enabled or false
g.RP_Text_Changer_Index = g.RP_Text_Changer_Index or 1
g.RP_Text_Changer_Interval = g.RP_Text_Changer_Interval or 0.1
g.RP_Text_Changer_Elapsed = g.RP_Text_Changer_Elapsed or 0
g.Rainbow_Skin_Enabled = g.Rainbow_Skin_Enabled or false
g.Rainbow_Skin_Index = g.Rainbow_Skin_Index or 1
g.Rainbow_Skin_Interval = g.Rainbow_Skin_Interval or 0.1
g.Rainbow_Skin_Elapsed = g.Rainbow_Skin_Elapsed or 0
g.Rainbow_Skin_Saved_Colors = g.Rainbow_Skin_Saved_Colors or nil
g.Anti_Sit_Enabled = g.Anti_Sit_Enabled or false
g.Anti_Sit_Radius = g.Anti_Sit_Radius or 25
g.FlyEnabled = g.FlyEnabled or false
g.FlySpeed = g.FlySpeed or 1
g.QEfly = (g.QEfly == nil) and true or g.QEfly
g.flyKeyDown = g.flyKeyDown or nil
g.flyKeyUp = g.flyKeyUp or nil
g.mobileFlyConn = g.mobileFlyConn or nil
g.pcFlyConn = g.pcFlyConn or nil
g.Enabled_Flying = g.Enabled_Flying or false
g.Fly2Speed = g.Fly2Speed or 5
g.Fly2Control = nil
g.fly2InputBegan = nil
g.fly2InputEnded = nil
g.fly2Heartbeat = nil
g.fly2MobileConn = nil

if Vehicles_Scrolling_Frame then
    for _, Vehicle_Button in ipairs(Vehicles_Scrolling_Frame:GetChildren()) do
        if Vehicle_Button:IsA("ImageButton") then
            local Dlc_Button = Vehicle_Button:FindFirstChild("dlc")
            if Dlc_Button and Dlc_Button:IsA("ImageButton") and Dlc_Button.Visible == true then
                table.insert(g.Paid_Vehicles, Vehicle_Button.Name)
            elseif Dlc_Button and Dlc_Button:IsA("ImageButton") and Dlc_Button.Visible == false then
                table.insert(g.Free_Vehicles, Vehicle_Button.Name)
            end
        end
    end
end

local function Has_Scrolling_Frame_Ancestor(instance)
	local current = instance.Parent
	while current and current ~= player_gui do
		if current:IsA("ScrollingFrame") then return true end
		current = current.Parent
	end
	return false
end

local function Has_BackPack_Ancestor(instance)
	local current = instance.Parent
	while current and current ~= player_gui do
		if current:IsA("Frame") and current.Name:lower():find("backpack") then return true end
		current = current.Parent
	end
	return false
end

g.rainbow_skin_color = function(state)
	if not Catalog_Equip_Function or not Catalog_Equip_Function:IsA("RemoteFunction") then return g.notify("Error", "CatalogEquipFunction does not exist or is not a RemoteFunction.", 3) end
	g.Rainbow_Skin_Enabled = state
	if state == true then
		local Character = g.Character or speaker.Character or g.get_char(speaker, 5)
		local Body_Colors = Character and Character:FindFirstChildOfClass("BodyColors")
		if Body_Colors then
			g.Rainbow_Skin_Saved_Colors = {
				HeadColor = Body_Colors.HeadColor3,
				TorsoColor = Body_Colors.TorsoColor3,
				LeftArmColor = Body_Colors.LeftArmColor3,
				RightArmColor = Body_Colors.RightArmColor3,
				LeftLegColor = Body_Colors.LeftLegColor3,
				RightLegColor = Body_Colors.RightLegColor3,
			}
		end
        wait(0.1)
		FlamesLibrary.connect("Rainbow_Skin", RunService.Heartbeat:Connect(function(Delta_Time)
			g.Rainbow_Skin_Elapsed += Delta_Time
			if g.Rainbow_Skin_Elapsed < g.Rainbow_Skin_Interval then return end
			g.Rainbow_Skin_Elapsed = 0
			g.Rainbow_Skin_Index = (g.Rainbow_Skin_Index % #g.colors_color_three) + 1
			local Rainbow_Color = g.colors_color_three[g.Rainbow_Skin_Index]
			local args = {
				"color",
				{
					HeadColor = Rainbow_Color,
					TorsoColor = Rainbow_Color,
					LeftArmColor = Rainbow_Color,
					RightArmColor = Rainbow_Color,
					LeftLegColor = Rainbow_Color,
					RightLegColor = Rainbow_Color,
				}
			}
			pcall(function() Catalog_Equip_Function:InvokeServer(unpack(args)) end)
		end))
		g.notify("Success", "Flames Hub | Rainbow Skin is now enabled.", 3)
	elseif state == false then
		FlamesLibrary.disconnect("Rainbow_Skin")
		if g.Rainbow_Skin_Saved_Colors then
			local args = { "color", g.Rainbow_Skin_Saved_Colors }
			pcall(function() Catalog_Equip_Function:InvokeServer(unpack(args)) end)
			g.Rainbow_Skin_Saved_Colors = nil
		end
		g.notify("Success", "Flames Hub | Rainbow Skin is now disabled.", 3)
	else
		return
	end
end

g.get_all_vehicles_folder = function(timeout)
	local cache = g.currently_cached_vehicles_folder
	if cache and cache:IsA("Folder") and cache.Parent then return cache end
	timeout = timeout or 3
	local Start_Time = os.clock()
	local Lowered_UserId = tostring(speaker.UserId):lower()
	local User_Folder

	repeat
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("Folder") and v.Name:lower():find(Lowered_UserId, 1, true) then
				User_Folder = v
				local stored_vehicles_folder = FuzzyFindDescendantWithClass(v, "vehicle", "Folder")
				if stored_vehicles_folder then
					g.currently_cached_vehicles_folder = stored_vehicles_folder
					return stored_vehicles_folder
				end
			end
		end
		task.wait(0.1)
	until os.clock() - Start_Time >= timeout

	local new_vehicles_folder = Instance.new("Folder")
	new_vehicles_folder.Name = "Vehicle"
	new_vehicles_folder.Parent = User_Folder
	g.currently_cached_vehicles_folder = new_vehicles_folder
	g.notify("Info", "Could not find existing Vehicles Folder, created a new one under: "..tostring(new_vehicles_folder.Parent and new_vehicles_folder.Parent:GetFullName() or "nil"), 5)

	if User_Folder then
		FlamesLibrary.connect("Real_Vehicle_Folder_Watcher", User_Folder.ChildAdded:Connect(function(child)
			if child ~= new_vehicles_folder and child:IsA("Folder") and child.Name:lower():find("vehicle") then
				task.wait(0.1)
				if new_vehicles_folder and new_vehicles_folder.Parent then new_vehicles_folder:Destroy() end
				g.currently_cached_vehicles_folder = child
				FlamesLibrary.disconnect("Real_Vehicle_Folder_Watcher")
			end
		end))
	end

	return new_vehicles_folder
end
wait(0.15)
if not g.currently_cached_vehicles_folder then pcall(function() g.get_all_vehicles_folder() end) end
wait(0.15)
g.get_current_vehicle = function()
    local vehicles_folder = g.get_all_vehicles_folder()
    if not vehicles_folder then return warn("Could not find Vehicles Folder, got: "..tostring(vehicles_folder)) end
    for _, v in ipairs(vehicles_folder:GetChildren()) do
        if v:IsA("Model") and v:GetAttribute("playerid") == speaker.UserId then
            return v
        end
    end

    return nil
end

g.get_vehicle_color_body_model = function()
    local current_vehicle = g.get_current_vehicle()
    if not current_vehicle then return g.notify("Error", "You do not have a Vehicle spawned.", 3) end
    local body = current_vehicle and current_vehicle:FindFirstChild("Body", true)
    if not body then return g.notify("Error", "Your Vehicle does not contain the Model: 'Body' needed to perform this task.", 3) end
    local str_to_find = "颜色"

    return body:FindFirstChild(str_to_find)
end

g.find_car_system_Remote_Event = function(timeout)
	local cache = g.car_system_RE
	if cache and cache:IsA("RemoteEvent") and cache.Parent then return cache end

	timeout = timeout or 3
	local Start_Time = os.clock()

	repeat
		local Car_System_Container = FuzzyFindDescendantWithClass(player_gui, "carsystem", nil)
		if Car_System_Container then
			local Found_Remote = FuzzyFindDescendantWithClass(Car_System_Container, "remoteevent", "RemoteEvent")
			if Found_Remote then
				g.car_system_RE = Found_Remote
				return Found_Remote
			end
		end
		task.wait(0.1)
	until os.clock() - Start_Time >= timeout

	return nil
end

g.Despawn_Current_Vehicle = function()
	local Car_System_RE = g.car_system_RE or g.find_car_system_Remote_Event()
	if not Car_System_RE or not Car_System_RE:IsA("RemoteEvent") then return g.notify("Error", "CarSystem RemoteEvent not found.", 3) end
	local Args = { "close" }
	local ok = pcall(function() Car_System_RE:FireServer(unpack(Args)) end)
	if ok then
		g.notify("Success", "Flames Hub | Vehicle despawned.", 3)
	else
		g.notify("Error", "Failed to despawn vehicle.", 3)
	end
end

g.get_vehicle_color_change_RE = function()
    local cache = g.color_changed_Remote_Event
    if cache and cache:IsA("RemoteEvent") and cache.Parent then return cache end
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("color") and v.Name:lower():find("change") then
            g.color_changed_Remote_Event = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.color_changed_Remote_Event then pcall(function() g.get_vehicle_color_change_RE() end) end
g.rainbow_vehicle = function(state)
    local change_car_color_RE = g.color_changed_Remote_Event or g.get_vehicle_color_change_RE()
    if not change_car_color_RE or not change_car_color_RE:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: ColorChanged does not exist or is not a RemoteEvent.", 3) end
    local current_vehicle = g.get_current_vehicle()
    if not current_vehicle then
        if g.Rainbow_Vehicle_UI_Toggle then g.Rainbow_Vehicle_UI_Toggle:Set(false, false) end
        return g.notify("Error", "You do not have a Vehicle spawned.", 3)
    end
    local body_colors_on_vehicle = g.get_vehicle_color_body_model()
    if not body_colors_on_vehicle then
        if g.Rainbow_Vehicle_UI_Toggle then g.Rainbow_Vehicle_UI_Toggle:Set(false, false) end
        return g.notify("Error", "Could not find colors inside Model: Body.", 3)
    end
    if state == true then
        g.rainbow_vehicle_enabled = true
        while g.rainbow_vehicle_enabled == true do
            task.wait()
            if not current_vehicle or not current_vehicle.Parent or not body_colors_on_vehicle or not body_colors_on_vehicle.Parent then
                if g.Rainbow_Vehicle_UI_Toggle then g.Rainbow_Vehicle_UI_Toggle:Set(false, false) end
                g.rainbow_vehicle_enabled = false
                break
            end
            for _, color in ipairs(g.colors_color_three) do
                if g.rainbow_vehicle_enabled == false then break end
                task.wait(0)
                change_car_color_RE:FireServer(body_colors_on_vehicle, color)
            end
        end
    elseif state == false then
        g.rainbow_vehicle_enabled = false
    else
        return
    end
end

g.find_body_parts_toggle_Remote_Function = function()
    local cache = g.body_parts_toggle_Remote_Function
    if cache and cache:IsA("RemoteFunction") and cache.Parent then return cache end

    local candidates = {}
    for _, v in ipairs(player_gui:GetDescendants()) do
        if v:IsA("RemoteFunction") and Has_BackPack_Ancestor(v) then
            table.insert(candidates, v)
        end
    end

    if #candidates == 0 then return nil end

    for _, v in ipairs(candidates) do
        local node = v
        while node and node ~= player_gui do
            if node.Name == "Avatar" then
                g.body_parts_toggle_Remote_Function = v
                return v
            end
            node = node.Parent
        end
    end

    g.body_parts_toggle_Remote_Function = candidates[1]
    return candidates[1]
end
wait(0.1)
if not g.body_parts_toggle_Remote_Function then pcall(function() g.find_body_parts_toggle_Remote_Function() end) end
g.Limb_Keywords = {"arm", "hand", "leg", "foot"}
g.Get_Limb_Parts = function(character)
    local parts = {}
    if not character then return parts end
    for _, v in ipairs(character:GetChildren()) do
        if v:IsA("BasePart") then
            for _, keyword in ipairs(g.Limb_Keywords) do
                if v.Name:lower():find(keyword) then
                    table.insert(parts, v)
                    break
                end
            end
        end
    end
    return parts
end

g.Is_Part_Invisible = function(part)
    if not part or not part:IsA("BasePart") then return false end
    return part.Transparency == 1
end

g.Get_Limb_Visibility = function(character)
    local results = {}
    local limb_parts = g.Get_Limb_Parts(character)
    for _, part in ipairs(limb_parts) do results[part.Name] = g.Is_Part_Invisible(part) end
    return results
end

g.Are_All_Limbs_Invisible = function(character)
    local limb_parts = g.Get_Limb_Parts(character)
    if #limb_parts == 0 then return false end
    for _, part in ipairs(limb_parts) do if not g.Is_Part_Invisible(part) then return false end end
    return true
end

g.Is_Any_Limb_Invisible = function(character)
    local limb_parts = g.Get_Limb_Parts(character)
    for _, part in ipairs(limb_parts) do if g.Is_Part_Invisible(part) then return true end end
    return false
end

for _, v in ipairs(player_gui:GetDescendants()) do
	if v:IsA("ScrollingFrame") and v.Parent.Name:lower():find("vehicle") then
		for _, car in ipairs(v:GetChildren()) do
            if car and car:IsA("ImageButton") then
                table.insert(g.all_vehicle_names, car.Name) -- I know, another table with cars, but these are all the vehicles, literally, not separating the free & paid ones.
            end
        end
	end
end
wait(0.15)
g.Leg_Keywords = {"leg", "foot"}
g.Arm_Keywords = {"arm", "hand"}
g.Get_Parts_By_Keywords = function(character, keywords)
    local parts = {}
    if not character then return parts end
    for _, v in ipairs(character:GetChildren()) do
        if v:IsA("BasePart") then
            for _, keyword in ipairs(keywords) do
                if v.Name:lower():find(keyword) then
                    table.insert(parts, v)
                    break
                end
            end
        end
    end
    return parts
end

g.Is_Any_Part_Invisible = function(parts)
    for _, part in ipairs(parts) do
        if g.Is_Part_Invisible(part) then
            return true
        end
    end
    return false
end

g.toggle_body_parts_flasher = function(state)
    local body_parts_toggler_RF = g.body_parts_toggle_Remote_Function or g.find_body_parts_toggle_Remote_Function()
    if not body_parts_toggler_RF or not body_parts_toggler_RF:IsA("RemoteFunction") then return g.notify("Error", "BodyParts RemoteFunction not found or is not a RemoteFunction.", 3) end

    if state == true then
        if g.Body_Parts_Flasher_Running then return end
        g.currently_toggling_flashing_body_parts = true
        g.Body_Parts_Flasher_Running = true
        FlamesLibrary.spawn("Body_Parts_Flasher_Loop", "spawn", function()
            while g.currently_toggling_flashing_body_parts do
                body_parts_toggler_RF:InvokeServer(3)
                body_parts_toggler_RF:InvokeServer(4)
                task.wait(0)
            end
            g.Body_Parts_Flasher_Running = false
        end)
    elseif state == false then
        g.currently_toggling_flashing_body_parts = false
        local waited = 0
        while g.Body_Parts_Flasher_Running and waited < 3 do
            task.wait(0.03)
            waited = waited + 0.03
        end

        local character = g.Character or speaker.Character or g.get_char(speaker, 5)
        if not character then return end
        local leg_parts = g.Get_Parts_By_Keywords(character, g.Leg_Keywords)
        local arm_parts = g.Get_Parts_By_Keywords(character, g.Arm_Keywords)
        if g.Is_Any_Part_Invisible(leg_parts) then body_parts_toggler_RF:InvokeServer(3) end
        if g.Is_Any_Part_Invisible(arm_parts) then body_parts_toggler_RF:InvokeServer(4) end
    else
        return
    end
end

g.Toggle_Anti_Sit = function(State)
	g.Anti_Sit_Enabled = State
	if not State then FlamesLibrary.disconnect("Anti_Sit") return g.notify("Success", "Flames Hub | Anti Sit is now disabled.", 3) end
	FlamesLibrary.connect("Anti_Sit", RunService.Heartbeat:Connect(function()
		local char = g.Character or speaker.Character or g.get_char(speaker, 5)
		local HumanoidRootPart = g.HumanoidRootPart or char and char:FindFirstChild("HumanoidRootPart") or g.get_root(speaker, 5)
		if not HumanoidRootPart then return end
		local Params = OverlapParams.new()
		Params.FilterType = Enum.RaycastFilterType.Exclude
		Params.FilterDescendantsInstances = { char }
		local Parts = workspace:GetPartBoundsInRadius(HumanoidRootPart.Position, g.Anti_Sit_Radius, Params)
		for _, Part in ipairs(Parts) do
			if Part:IsA("Seat") then
				pcall(function() Part.Disabled = true end)
				for _, v in ipairs(Part:GetDescendants()) do if v:IsA("ProximityPrompt") and v.Enabled then v.Enabled = false end end
			end
		end
	end))

	g.notify("Success", "Flames Hub | Anti Sit is now enabled.", 3)
end

g.Find_Stored_Plots_Model = function()
    local cached_model = g.stored_plots_cached_model
    if cached_model and cached_model:IsA("Model") and cached_model.Parent then return cached_model end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find("common") and v.Parent.Name:lower():find("homeserver") then
            cached_model = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.stored_plots_cached_model then pcall(function() g.Find_Stored_Plots_Model() end) end

g.find_currently_owned_home = function()
    local current_plots_model = g.stored_plots_cached_model or g.Find_Stored_Plots_Model()
    if not current_plots_model then return g.notify("Error", "Model: 'Common' was not found, cannot find home.", 3) end
    for _, v in ipairs(current_plots_model:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find("myhouse") then
            local attr = v:GetAttribute("playerid")
            if attr ~= nil and attr == speaker.UserId then
                return v
            end
        end
    end

    return nil
end

g.find_common_folder_replicated_storage_house_names = function()
    local cache = g.common_folder_house_names_RS
    if cache and cache:IsA("Folder") and cache.Parent then return cache end
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("Folder") and v.Name:lower():find("common") and v.Parent.Name:lower():find("model") then
            g.common_folder_house_names_RS = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.common_folder_house_names_RS then pcall(function() g.find_common_folder_replicated_storage_house_names() end) end
g.find_RP_Text_Function_Remote_Function = function()
	local cached = g.rp_text_function_RF
	if cached and cached:IsA("RemoteFunction") and cached.Parent then return cached end
	for _, v in ipairs(player_gui:GetDescendants()) do
		if v:IsA("RemoteFunction") and v.Name:lower() == "textfunction" then
			if Has_Scrolling_Frame_Ancestor(v) then
				g.rp_text_function_RF = v
				return v
			end
		end
	end

	return nil
end

g.find_job_changer_Remote_Function = function()
	local cached = g.job_switcher_Remote_Function
	if cached and cached:IsA("RemoteFunction") and cached.Parent then return cached end
	for _, v in ipairs(player_gui:GetDescendants()) do
		if v:IsA("RemoteFunction") and v.Name:lower():find("remote") and v.Name:lower():find("function") then
			if Has_Scrolling_Frame_Ancestor(v) then
				g.job_switcher_Remote_Function = v
				return v
			end
		end
	end

	return nil
end
wait(0.1)
if not g.job_switcher_Remote_Function then pcall(function() g.find_job_changer_Remote_Function() end) end
g.vehicle_fly = g.vehicle_fly or false
g.vehicle_fly_speed = g.vehicle_fly_speed or 3
g.vehiclefly_conns = g.vehiclefly_conns or {}
g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
g.vehiclefly_noclip = g.vehiclefly_noclip or false
g.vehiclefly_collisions = g.vehiclefly_collisions or {}
local controlModule
if UserInputService.TouchEnabled then controlModule = require(g.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")) end

g.cleanup = g.cleanup or function()
    for _, c in pairs(g.vehiclefly_conns) do
        pcall(function() c:Disconnect() end)
    end
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

g.enable_vehicle_noclip = g.enable_vehicle_noclip or function()
    if g.vehiclefly_noclip then return end
    g.vehiclefly_noclip = true
    g.vehiclefly_collisions = {}
    local car = g.get_current_vehicle()
    if not car then return end
    for _, v in ipairs(car:GetDescendants()) do
        if v:IsA("BasePart") then
            g.vehiclefly_collisions[v] = v.CanCollide
            v.CanCollide = false
        end
    end
end

g.disable_vehicle_noclip = g.disable_vehicle_noclip or function()
    if not g.vehiclefly_noclip then return end
    g.vehiclefly_noclip = false

    for part, state in pairs(g.vehiclefly_collisions) do
        if part and part.Parent then
            part.CanCollide = state
        end
    end
    g.vehiclefly_collisions = {}
end

g.vehiclefly_cam_yaw = g.vehiclefly_cam_yaw or 0
g.vehiclefly_cam_pitch = g.vehiclefly_cam_pitch or -0.25
g.vehiclefly_cam_distance = g.vehiclefly_cam_distance or 20
g.start_vehicle_fly = g.start_vehicle_fly or function()
    if g.vehiclefly_bg or g.vehiclefly_bv then return end
    local car = g.get_current_vehicle()
    if not car then g.disable_vehicle_noclip() task.wait() g.cleanup() getgenv().notify("Error", "You do not have a Vehicle spawned.", 5) return end

    local base = car.PrimaryPart or car:FindFirstChild("FloorPanel", true)
    if not base then
        g.disable_vehicle_noclip()
        task.wait()
        g.cleanup()
        getgenv().notify("Error", "Could not find FloorPanel/PrimaryPart on Vehicle.", 5)
        return
    end

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

    local cam = workspace.CurrentCamera
    g.vehiclefly_original_camera_type = cam.CameraType
    cam.CameraType = Enum.CameraType.Scriptable

    local initial_look = base.CFrame.LookVector
    g.vehiclefly_cam_yaw = math.atan2(-initial_look.X, -initial_look.Z)
    g.vehiclefly_cam_pitch = -0.25

    if not isMobile then
        g.vehiclefly_conns.mouselook = UserInputService.InputChanged:Connect(function(input, game_processed)
            if not g.vehicle_fly then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                g.vehiclefly_cam_yaw = g.vehiclefly_cam_yaw - (input.Delta.X * 0.003)
                g.vehiclefly_cam_pitch = math.clamp(g.vehiclefly_cam_pitch - (input.Delta.Y * 0.003), -1.2, 1.2)
            end
        end)
    end

    g.vehiclefly_conns.render = RunService.Heartbeat:Connect(function()
        if not g.vehicle_fly or not base.Parent then
            bv.Velocity = Vector3.zero
            g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
            if not base.Parent then
                if g.main_vehicle_fly_UI_toggle then g.main_vehicle_fly_UI_toggle:Set(false, false) end
                if g.stop_vehicle_fly then
                    g.stop_vehicle_fly()
                else
                    g.cleanup()
                end
            end
            return
        end

        base.AssemblyAngularVelocity = Vector3.zero

        local yaw_cframe = CFrame.Angles(0, g.vehiclefly_cam_yaw, 0)
        local look_direction = base.CFrame.LookVector
        local right_direction = base.CFrame.RightVector

        if isMobile then
            local mv = controlModule:GetMoveVector()
            local vel = Vector3.zero
            if mv.X ~= 0 then vel = vel + right_direction * (mv.X * (45 * g.vehicle_fly_speed)) end
            if mv.Z ~= 0 then vel = vel - look_direction * (mv.Z * (45 * g.vehicle_fly_speed)) end
            bv.Velocity = vel
        else
            local c = g.vehiclefly_control
            local forward = (c.f or 0) + (c.b or 0)
            local right = (c.l or 0) + (c.r or 0)
            local up = (c.q or 0) + (c.e or 0)

            local move_vector = (look_direction * forward + right_direction * right + Vector3.new(0, up, 0))
            bv.Velocity = move_vector * (45 * g.vehicle_fly_speed)

            if right ~= 0 then
                bg.CFrame = bg.CFrame * CFrame.Angles(0, -right * 0.03, 0)
            else
                bg.CFrame = CFrame.new(base.Position) * (bg.CFrame - bg.CFrame.Position)
            end
        end

        local cam_pitch_cframe = CFrame.Angles(g.vehiclefly_cam_pitch, 0, 0)
        local cam_offset = (yaw_cframe * cam_pitch_cframe) * CFrame.new(0, 0, g.vehiclefly_cam_distance)
        workspace.CurrentCamera.CFrame = CFrame.new(base.Position) * CFrame.new(cam_offset.Position) * (yaw_cframe * cam_pitch_cframe - (yaw_cframe * cam_pitch_cframe).Position)
    end)

    if not isMobile then
        g.vehiclefly_conns.render_input = RunService.Heartbeat:Connect(function()
            if not g.vehicle_fly then return end
            local c = g.vehiclefly_control
            c.f = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
            c.b = UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0
            c.l = UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
            c.r = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
            c.q = UserInputService:IsKeyDown(Enum.KeyCode.E) and 1 or 0
            c.e = UserInputService:IsKeyDown(Enum.KeyCode.Q) and -1 or 0
        end)
    end
end

g.stop_vehicle_fly = g.stop_vehicle_fly or function()
    g.vehicle_fly = false
    g.disable_vehicle_noclip()
    if g.vehiclefly_original_camera_type then
        workspace.CurrentCamera.CameraType = g.vehiclefly_original_camera_type
        g.vehiclefly_original_camera_type = nil
    end
    g.cleanup()
    g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
end

g.toggle_vehicle_fly = g.toggle_vehicle_fly or function()
    if g.vehicle_fly then
        g.stop_vehicle_fly()
    else
        g.vehicle_fly = true
        g.enable_vehicle_noclip()
        g.start_vehicle_fly()
    end
end

g.toggle_vehicle_noclip = g.toggle_vehicle_noclip or function(state)
	if state then
		local car = g.get_current_vehicle()
		if not car then
			if g.vehicle_noclip_switch_UI then g.vehicle_noclip_switch_UI:Set(false, false) end
			return g.notify("Error", "You do not have a Vehicle spawned.", 5)
		end
		g.enable_vehicle_noclip(car)
	else
		g.disable_vehicle_noclip()
	end
end

g.Vehicle_Setting_Limits = {
    MaxSpeed = {10, 300},
    ReverseSpeed = {5, 150},
    DrivingTorque = {1000, 150000},
    BrakingTorque = {1000, 200000},
    StrutSpringStiffnessFront = {1000, 80000},
    StrutSpringDampingFront = {100, 8000},
    StrutSpringStiffnessRear = {1000, 80000},
    StrutSpringDampingRear = {100, 8000},
    TorsionSpringStiffness = {1000, 80000},
    TorsionSpringDamping = {10, 800},
    MaxSteer = {0.1, 1.0},
    WheelFriction = {0.8, 4}
}

g.Set_Vehicle_Setting = function(vehicle_model, setting_name, value)
    if not vehicle_model or not vehicle_model:IsA("Model") then return false, "Invalid vehicle model" end
    local limits = g.Vehicle_Setting_Limits[setting_name]
    if not limits then return false, "Unknown setting: " .. tostring(setting_name) end
    local numeric_value = tonumber(value)
    if not numeric_value or numeric_value ~= numeric_value then return false, "Value must be a valid number, got " .. typeof(value) end
    local clamped_value = math.clamp(numeric_value, limits[1], limits[2])
    local ok, err = pcall(function() vehicle_model:SetAttribute(setting_name, clamped_value) end)
    if not ok then return false, "SetAttribute failed: " .. tostring(err) end

    return true, clamped_value
end

g.Set_Vehicle_Settings = function(vehicle_model, settings_table)
    vehicle_model = vehicle_model or g.get_current_vehicle()
    if not vehicle_model then return false, "No vehicle model found" end
    local results = {}
    for setting_name, value in pairs(settings_table) do
        local ok, result = g.Set_Vehicle_Setting(vehicle_model, setting_name, value)
        results[setting_name] = {Success = ok, Result = result}
    end

    return results
end

g.click_detector_Remote_Event_Finder = function()
    local cache = g.click_data_fun_detector_RE
    if cache and cache:IsA("RemoteEvent") and cache.Parent then return cache end

    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("click") and v.Name:lower():find("fun") and v.Name:lower():find("data") then
            g.click_data_fun_detector_RE = v
            return v
        end
    end
    
    return nil
end
wait(0.1)
if not g.click_data_fun_detector_RE then pcall(function() g.click_data_fun_detector_RE() end) end

g.click_obj_click_detector_RE = function(obj_to_click, data)
    if not obj_to_click then return end
    local Click_RE = g.click_data_fun_detector_RE or g.click_detector_Remote_Event_Finder()
    if not Click_RE or not Click_RE:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: ClickFunDataEvent not found or is not a RemoteEvent.", 3) end

    -- [[ soon ]] --
    -- Click_RE:FireServer(data)
end

g.house_data_server_Remote_Function_Finder = function()
    local cache = g.house_server_remote_controller_RF
    if cache and cache:IsA("RemoteFunction") and cache.Parent then return cache end
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteFunction") and v.Name:lower():find("house") and v.Name:lower():find("server") and v.Name:lower():find("event") then
            g.house_server_remote_controller_RF = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.house_server_remote_controller_RF then pcall(function() g.house_data_server_Remote_Function_Finder() end) end

g.house_light_switch_Remote_Event_Finder = function()
    local cache = g.house_light_switch_RE
    if cache and cache:IsA("RemoteEvent") and cache.Parent then return cache end
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("house") and v.Name:lower():find("light") and v.Name:lower():find("switch") then
            g.house_light_switch_RE = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.house_light_switch_RE then pcall(function() g.house_light_switch_Remote_Event_Finder() end) end

g.post_instagram_in_game_RF_Finder = function()
    local cache = g.instagram_post_in_game_RF
    if cache and cache:IsA("RemoteFunction") and cache.Parent then return cache end
    for _, v in ipairs(player_gui:GetDescendants()) do
        if v:IsA("RemoteFunction") and v.Parent and v.Parent.Name:lower():find("int") then
            g.instagram_post_in_game_RF = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.instagram_post_in_game_RF then pcall(function() g.post_instagram_in_game_RF_Finder() end) end

g.job_spammer_toggle = function(state)
    local job_switcher_RF = g.job_switcher_Remote_Function
    if not job_switcher_RF or not job_switcher_RF:IsA("RemoteFunction") then return g.notify("Error", "Job RemoteFunction does not exist or is not a RemoteFunction.", 3) end
    if state == true then
        g.spam_all_jobs_toggled = true
        while g.spam_all_jobs_toggled == true do
        task.wait()
            for _, job in ipairs(g.job_numbers_list) do
                task.wait(0)
                job_switcher_RF:InvokeServer(job)
            end
        end
    elseif state == false then
        g.spam_all_jobs_toggled = false
    else
        return 
    end
end

g.rainbow_RP_text_changer = function(state)
	local Text_Function_RF = g.rp_text_function_RF or g.find_RP_Text_Function_Remote_Function()
	if not Text_Function_RF or not Text_Function_RF:IsA("RemoteFunction") then return g.notify("Error", "RP Text Function RemoteFunction not found.", 3) end

	g.RP_Text_Changer_Enabled = state
	if state == true then
		FlamesLibrary.connect("RP_Text_Changer", RunService.Heartbeat:Connect(function(Delta_Time)
			g.RP_Text_Changer_Elapsed += Delta_Time
			if g.RP_Text_Changer_Elapsed < g.RP_Text_Changer_Interval then return end
			g.RP_Text_Changer_Elapsed = 0
			g.RP_Text_Changer_Index += 1
			local Color_Index = ((g.RP_Text_Changer_Index - 1) % #g.colors_color_three) + 1
			local Word_Index = ((g.RP_Text_Changer_Index - 1) % #words_list) + 1
			local Rainbow_Color = g.colors_color_three[Color_Index]
			local Rainbow_Word = words_list[Word_Index]
			local Name_Args = { "RP", Rainbow_Word, Rainbow_Color }
			local Bio_Args = { "Bio", Rainbow_Word, Rainbow_Color }
			pcall(function() Text_Function_RF:InvokeServer(unpack(Name_Args)) end)
			pcall(function() Text_Function_RF:InvokeServer(unpack(Bio_Args)) end)
		end))
		g.notify("Success", "Flames Hub | RP Text Changer is now enabled.", 3)
	elseif state == false then
		FlamesLibrary.disconnect("RP_Text_Changer")
		g.notify("Success", "Flames Hub | RP Text Changer is now disabled.", 3)
	else
		return 
	end
end

function CreateCreditsLabel()
    if getgenv().CreditsLabelGui then getgenv().CreditsLabelGui:Destroy() end
    wait(0.25)
    local credits_gui = Instance.new("ScreenGui")
    credits_gui.Name = "Credits_GUI_New_Smith_RP"
    credits_gui.ResetOnSpawn = false
    credits_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    credits_gui.Parent = Core_Gui

    local label = Instance.new("TextLabel")
    label.Name = "CreditsLabel"
    label.AnchorPoint = Vector2.new(0.5, 1)
    label.Position = UDim2.new(0.5, 0, 1, -10)
    label.Size = UDim2.new(0.6, 0, 0, 28)
    label.BackgroundColor3 = Color3.fromRGB(0, 172, 175)
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.Text = tostring(Script_Version).." | https://discord.gg/MTYKxQfpNJ"
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.RichText = false
    label.TextStrokeTransparency = 1
    label.BackgroundTransparency = 0
    label.ZIndex = 10
    label.Parent = credits_gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = label
    getgenv().CreditsLabelGui = credits_gui
    getgenv().CreditsLabelText = label
    if getgenv().flowrgb and typeof(getgenv().flowrgb) == "function" then getgenv().flowrgb("CreditsLabelNewSmithRP", 1, label, true) end
end
wait(0.2)
CreateCreditsLabel()

local UIS = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
g.EnableFly = function(state, speed, vfly)
    if g.FlyEnabled then
        if speed and tonumber(speed) then
            g.FlySpeed = tonumber(speed)
            return notify("Success", "Fly speed updated to: " .. tostring(g.FlySpeed), 3)
        end
        return notify("Warning", "Fly is already enabled! Provide a speed to update it.", 3)
    end

    local plr = g.LocalPlayer or g.Players.LocalPlayer or game.Players.LocalPlayer
    local char = g.get_char(plr) or g.Character or plr.Character
    local hrp = g.HumanoidRootPart or char:FindFirstChild("HumanoidRootPart") or get_root(plr)
    local hum = g.Humanoid or char:FindFirstChildOfClass("Humanoid") or get_human(plr)
    local cam = workspace.CurrentCamera
    if not hrp or not hum then return g.notify("Error", "Character is not ready or Humanoid doesn't exist.", 6) end
    if not state then
        g.DisableFly()
        return
    end

    if speed and tonumber(speed) then g.FlySpeed = tonumber(speed) end
    g.FlyEnabled = true
    if g.flyKeyDown then g.flyKeyDown:Disconnect() g.flyKeyDown = nil end
    if g.flyKeyUp then g.flyKeyUp:Disconnect() g.flyKeyUp = nil end
    if g.pcFlyConn then g.pcFlyConn:Disconnect() g.pcFlyConn = nil end
    if g.mobileFlyConn then g.mobileFlyConn:Disconnect() g.mobileFlyConn = nil end
    if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
    if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end

    local BG = Instance.new("BodyGyro")
    BG.P = 9e4
    BG.MaxTorque = Vector3.new(9e9,9e9,9e9)
    BG.CFrame = hrp.CFrame
    BG.Name = "FlyGyro"
    BG.Parent = hrp

    local BV = Instance.new("BodyVelocity")
    BV.MaxForce = Vector3.new(9e9,9e9,9e9)
    BV.Velocity = Vector3.zero
    BV.Name = "FlyVelocity"
    BV.Parent = hrp

    hum.PlatformStand = true
    if not isMobile then
        local CONTROL = {F=0,B=0,L=0,R=0,Q=0,E=0}
        g.pcFlyConn = RunService.RenderStepped:Connect(function(dt)
            if not g.FlyEnabled then return end
            if not cam or not hrp or not hum then return end
            local speedNow = ((vfly and (g.VehicleFlySpeed or g.FlySpeed)) or g.FlySpeed) * 50
            local look = cam.CFrame
            local move_vec = ((look.LookVector * (CONTROL.F + CONTROL.B)) + ((look * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.Q + CONTROL.E) * 0.2, 0).p) - look.p))
            if move_vec.Magnitude > 0 then
                move_vec = move_vec.Unit
                BV.Velocity = move_vec * speedNow
            else
                BV.Velocity = BV.Velocity * 0.9
            end

            BG.CFrame = cam.CFrame
        end)

        g.flyKeyDown = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 1 end
            if input.KeyCode == Enum.KeyCode.S then CONTROL.B = -1 end
            if input.KeyCode == Enum.KeyCode.A then CONTROL.L = -1 end
            if input.KeyCode == Enum.KeyCode.D then CONTROL.R = 1 end
            if g.QEfly then
                if input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 1 end
                if input.KeyCode == Enum.KeyCode.Q then CONTROL.E = -1 end
            end
            pcall(function() cam.CameraType = Enum.CameraType.Track end)
        end)

        g.flyKeyUp = UIS.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0 end
            if input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0 end
            if input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0 end
            if input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0 end
            if input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0 end
            if input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0 end
        end)

        g.notify("Success", "Fly-1 is now enabled | with speed: "..tostring(g.FlySpeed), 5)
        return
    end

    local ok, control_module = pcall(function()
        return require(plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    end)
    if not ok or not control_module then
        notify("Warning", "ControlModule unavailable; using simple touch fallback.", 5)
        g.mobileFlyConn = RunService.RenderStepped:Connect(function()
            if not g.FlyEnabled then return end
            BG.CFrame = cam.CFrame
            BV.Velocity = Vector3.zero
        end)
        return
    end

    g.mobileFlyConn = RunService.RenderStepped:Connect(function()
        if not g.FlyEnabled then return end
        if not hrp or not hum or not cam then return end
        BG.CFrame = cam.CFrame
        local direction = control_module:GetMoveVector()
        local speed_scaled = ((vfly and (g.VehicleFlySpeed or g.FlySpeed)) or g.FlySpeed) * 50
        if direction.Magnitude > 0 then
            BV.Velocity = (cam.CFrame.LookVector * -direction.Z + cam.CFrame.RightVector * direction.X) * speed_scaled
        else
            BV.Velocity = Vector3.zero
        end
    end)
    g.notify("Success", "Fly-1 is now enabled | with speed: "..tostring(g.FlySpeed), 3)
end

g.DisableFly = function()
    if not g.FlyEnabled then return notify("Warning", "Flames Hub | Fly-1 is not enabled!", 3) end
    g.FlyEnabled = false
    if g.flyKeyDown then g.flyKeyDown:Disconnect() g.flyKeyDown = nil end
    if g.flyKeyUp then g.flyKeyUp:Disconnect() g.flyKeyUp = nil end
    if g.pcFlyConn then g.pcFlyConn:Disconnect() g.pcFlyConn = nil end
    if g.mobileFlyConn then g.mobileFlyConn:Disconnect() g.mobileFlyConn = nil end
    local plr = g.LocalPlayer
    local char = g.Character or plr.Character or g.get_char(plr, 3)
    local hrp = g.HumanoidRootPart or char:FindFirstChild("HumanoidRootPart") or g.get_root(plr, 3)
    local hum = g.Humanoid or char:FindFirstChildWhichIsA("Humanoid") or g.get_human(plr, 3)
    if hrp and hrp.Parent and hrp:IsDescendantOf(game) then if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end end
    if hum then hum.PlatformStand = false end
    g.notify("Success", "Flames Hub | Fly-1 is now disabled.", 3)
end

function toggle_noclip(state)
    if state == true then
        if getgenv().Noclip_Enabled then return g.notify("Error", "Noclip is already enabled!", 3) end
        getgenv().Noclip_Enabled = true
        getgenv()._noclipModifiedParts = {}
        local function NoclipLoop()
            if getgenv().Character then
                for _, part in ipairs(getgenv().Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                        if getgenv()._noclipModifiedParts then getgenv()._noclipModifiedParts[part] = true end
                    end
                end
            end
        end
        getgenv().Noclip_Connection = RunService.Stepped:Connect(NoclipLoop)
        g.notify("Success", "Noclip has been enabled.", 5)
    else
        if not getgenv().Noclip_Enabled then return g.notify("Error", "Flames Hub | Noclip is not enabled!", 5) end
        if getgenv().Noclip_Connection then getgenv().Noclip_Connection:Disconnect() getgenv().Noclip_Connection = nil end
        getgenv().Noclip_Enabled = false
        if getgenv()._noclipModifiedParts then
            for part in pairs(getgenv()._noclipModifiedParts) do if part and part:IsA("BasePart") then part.CanCollide = true end end
            getgenv()._noclipModifiedParts = nil
        end
        g.notify("Success", "Disabled Noclip successfully.", 5)
    end
end

function toggle_antifling(state)
    if state == true then
        if getgenv().antiFlingEnabled then return g.notify("Error", "Anti Fling is already enabled!", 3) end
        getgenv().antiFlingEnabled = true
        getgenv().antiKnockbackEnabled = true
        local function Clean_Up_Forces()
            local hrp = HumanoidRootPart
            if not hrp then return end
            for _, obj in ipairs(hrp:GetChildren()) do if obj:IsA("BodyMover") or obj:IsA("VectorForce") or obj:IsA("Torque") or obj:IsA("LinearVelocity") then obj:Destroy() end end
        end

        local function Clean_Up_Forces_2()
            local char = getgenv().Character
            if not char then return end
            for _, obj in ipairs(char:GetChildren()) do if obj:IsA("BodyMover") or obj:IsA("VectorForce") or obj:IsA("Torque") or obj:IsA("LinearVelocity") then obj:Destroy() end end
        end

        local function On_Heartbeat()
            if not (getgenv().antiKnockbackEnabled or getgenv().antiFlingEnabled) then return end
            local hrp = HumanoidRootPart
            local humanoid = Humanoid
            if not hrp or not humanoid then return end
            local Max_Speed = 45
            local Max_Angular_Speed = 60
            if hrp.AssemblyLinearVelocity.Magnitude > Max_Speed then hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity.Unit * Max_Speed end
            if hrp.AssemblyAngularVelocity.Magnitude > Max_Angular_Speed then hrp.AssemblyAngularVelocity = Vector3.zero end
            if humanoid.PlatformStand then humanoid.PlatformStand = false end
            Clean_Up_Forces()
            Clean_Up_Forces_2()
        end

        if getgenv().anti_knockback_connection then getgenv().anti_knockback_connection:Disconnect() getgenv().anti_knockback_connection = nil end
        getgenv().anti_knockback_connection = RunService.Heartbeat:Connect(On_Heartbeat)
        g.notify("Success", "Flames Hub | Anti-Fling is now active.", 3)
    else
        getgenv().antiFlingEnabled = false
        getgenv().antiKnockbackEnabled = false
        if getgenv().anti_knockback_connection then getgenv().anti_knockback_connection:Disconnect() getgenv().anti_knockback_connection = nil end
        g.notify("Success", "Flames Hub | Anti-Fling is now in-active.", 3)
    end
end

g.EnableFly2 = g.EnableFly2 or function(speed)
    if g.Enabled_Flying then return notify("Warning", "Flames Hub | Rainbow Fly is already enabled.", 5) end
    local UIS = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
    local plr = g.LocalPlayer or game.Players.LocalPlayer
    local char = g.Character or plr.Character or get_char(plr, 10)
    local HRP = g.HumanoidRootPart or char and char:FindFirstChild("HumanoidRootPart") or get_root(plr, 5)
    local Humanoid = g.Humanoid or char and char:FindFirstChildOfClass("Humanoid") or get_human(plr, 5)
    local Workspace = g.Workspace or cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
    local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
    local Debris = g.Debris or cloneref and cloneref(game:GetService("Debris")) or game:GetService("Debris")
    if not HRP or not Humanoid then return notify("Error", "Character is not ready or Humanoid is missing.", 5) end
    g.Enabled_Flying = true
    g.Fly2Speed = tonumber(speed) or 10
    g.Fly2Control = {F=0,B=0,L=0,R=0}
    local flyY, lastPos = 0, nil
    local gyro = Instance.new("BodyGyro")
    gyro.P = 9e4
    gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    gyro.CFrame = HRP.CFrame
    gyro.Name = "Fly2Gyro"
    gyro.Parent = HRP

    local vel = Instance.new("BodyVelocity")
    vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    vel.Velocity = Vector3.zero
    vel.Name = "Fly2Velocity"
    vel.Parent = HRP

    Humanoid.PlatformStand = true
    if not isMobile then
        if g.fly2InputBegan then g.fly2InputBegan:Disconnect() end
        if g.fly2InputEnded then g.fly2InputEnded:Disconnect() end
        if g.fly2Heartbeat then g.fly2Heartbeat:Disconnect() end

        g.fly2InputBegan = UIS.InputBegan:Connect(function(input, gp)
            if gp then return end
            local s = g.Fly2Speed
            if input.KeyCode == Enum.KeyCode.W then g.Fly2Control.F = s end
            if input.KeyCode == Enum.KeyCode.S then g.Fly2Control.B = -s end
            if input.KeyCode == Enum.KeyCode.A then g.Fly2Control.L = -s end
            if input.KeyCode == Enum.KeyCode.D then g.Fly2Control.R = s end
            if input.KeyCode == Enum.KeyCode.Space then flyY = s end
            if input.KeyCode == Enum.KeyCode.LeftShift then flyY = -s end
        end)

        g.fly2InputEnded = UIS.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then g.Fly2Control.F = 0 end
            if input.KeyCode == Enum.KeyCode.S then g.Fly2Control.B = 0 end
            if input.KeyCode == Enum.KeyCode.A then g.Fly2Control.L = 0 end
            if input.KeyCode == Enum.KeyCode.D then g.Fly2Control.R = 0 end
            if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then flyY = 0 end
        end)

        g.fly2Heartbeat = RunService.RenderStepped:Connect(function()
            if not g.Enabled_Flying then return end
            local C, cam, SPEED = g.Fly2Control, Workspace.CurrentCamera, g.Fly2Speed * 50
            if C.F~=0 or C.B~=0 or C.L~=0 or C.R~=0 or flyY~=0 then
                local moveVec = ((cam.CFrame.LookVector * (C.F + C.B)) + ((cam.CFrame * CFrame.new(C.L + C.R, flyY * 0.5, 0).p) - cam.CFrame.p))
                if moveVec.Magnitude > 0 then vel.Velocity = moveVec.Unit * SPEED end
            else
                vel.Velocity = vel.Velocity * 0.9
            end

            gyro.CFrame = cam.CFrame
            local pos = HRP.Position
            if not lastPos or (pos - lastPos).Magnitude > 1 then
                local part = Instance.new("Part")
                part.Anchored = true
                part.CanCollide = false
                part.Material = Enum.Material.Neon
                part.Size = Vector3.new(1,1,(pos - (lastPos or pos)).Magnitude + 2)
                part.CFrame = CFrame.new((lastPos or pos) + ((pos - (lastPos or pos)) / 2), pos)
                part.Color = colors[math.random(1, #colors)]
                part.Parent = Workspace
                Debris:AddItem(part, 1)
                lastPos = pos
            end
        end)

        g.notify("Success", "Fly-2 is now enabled | with speed: "..tostring(g.Fly2Speed), 5)
        return
    end

    local controlModule
    local ok, result = pcall(function() return require(plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")) end)
    if ok then controlModule = result end
    g.fly2MobileConn = RunService.RenderStepped:Connect(function()
        if not g.Enabled_Flying then return end
        local cam = Workspace.CurrentCamera
        local s = g.Fly2Speed * 50
        local move = controlModule and controlModule:GetMoveVector() or Vector3.zero
        if move.Magnitude > 0 then vel.Velocity = (cam.CFrame.LookVector * -move.Z + cam.CFrame.RightVector * move.X) * s else vel.Velocity = Vector3.zero end
        gyro.CFrame = cam.CFrame
        local pos = HRP.Position
        if not lastPos or (pos - lastPos).Magnitude > 1 then
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.Size = Vector3.new(1,1,(pos - (lastPos or pos)).Magnitude + 2)
            part.CFrame = CFrame.new((lastPos or pos) + ((pos - (lastPos or pos)) / 2), pos)
            part.Color = colors[math.random(1, #colors)]
            part.Parent = Workspace
            Debris:AddItem(part, 1)
            lastPos = pos
        end
    end)
    notify("Success", "Fly-2 is now enabled | with speed: "..tostring(g.Fly2Speed), 5)
end

g.DisableFly2 = g.DisableFly2 or function()
    g.Enabled_Flying = false
    if g.fly2InputBegan then g.fly2InputBegan:Disconnect() end
    if g.fly2InputEnded then g.fly2InputEnded:Disconnect() end
    if g.fly2Heartbeat then g.fly2Heartbeat:Disconnect() end
    if g.fly2MobileConn then g.fly2MobileConn:Disconnect() end
    local HRP = g.HumanoidRootPart or g.Character:FindFirstChild("HumanoidRootPart") or get_root(g.LocalPlayer, 10)
    local Humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("Humanoid") or get_human(g.LocalPlayer, 10)
    if HRP then for _, v in ipairs(HRP:GetChildren()) do if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end end end
    if Humanoid then Humanoid.PlatformStand = false end
    g.notify("Success", "Fly-2 is now disabled.", 5)
end

g.get_player_interaction_events_Folder = function()
    local cache = g.player_interactions_Remote_Events_Folder
    if cache and cache:IsA("Folder") then return cache end
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("Folder") and v.Name:lower():find("玩家间") then
            g.player_interactions_Remote_Events_Folder = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.player_interactions_Remote_Events_Folder then pcall(function() g.get_player_interaction_events_Folder() end) end

g.get_player_request_pickup_Remote_Event = function()
    local cache = g.player_request_pickup_RE
    if cache and cache:IsA("RemoteEvent") then return cache end
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("发送交") then
            g.player_request_pickup_RE = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.player_request_pickup_RE then pcall(function() g.get_player_request_pickup_Remote_Event() end) end

g.find_Phone_Call_Remote_Event = function()
    local cache = g.player_phone_call_RE
    if cache and cache:IsA("RemoteEvent") then return cache end
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("phone") and v.Name:lower():find("call") then
            g.player_phone_call_RE = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.player_phone_call_RE then pcall(function() g.find_Phone_Call_Remote_Event() end) end

g.anti_call_func = function(state)
    local Phone_Handler_RE = g.player_phone_call_RE or g.find_Phone_Call_Remote_Event()
    if not Phone_Handler_RE or not Phone_Handler_RE:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: PhoneCallEvent does not exist or is not a RemoteEvent.", 3) end
    if state == true then
        if g.anti_call_flames_hub_running then return end
        g.currently_on_do_not_call = true
        g.anti_call_flames_hub_running = true
        FlamesLibrary.spawn("Stop_Calling_Everyone_Repeat_Loop", "spawn", function()
            while g.currently_on_do_not_call do
                Phone_Handler_RE:FireServer("UnCall")
                task.wait(0)
            end
            g.anti_call_flames_hub_running = false
        end)
    elseif state == false then
        g.currently_on_do_not_call = false
        FlamesLibrary.disconnect("Stop_Calling_Everyone_Repeat_Loop")
    else
        return 
    end
end

g.Interact_GUI_Exclusion_Keywords = {"cancel", "agreeorreject"}
g.Locate_Player_Interact_GUI = function()
    local cache = g.Player_Interact_Screen_GUI_Found
    if cache and cache:IsA("ScreenGui") then return cache end

    for _, v in ipairs(player_gui:GetDescendants()) do
        if v:IsA("ScreenGui") then
            local lowered = v.Name:lower()
            local excluded = false
            for _, keyword in ipairs(g.Interact_GUI_Exclusion_Keywords) do
                if lowered:find(keyword, 1, true) then
                    excluded = true
                    break
                end
            end

            if not excluded and lowered:find("playerinteractgui", 1, true) then
                g.Player_Interact_Screen_GUI_Found = v
                return v
            end
        end
    end

    return nil
end
wait(0.1)
if not g.Player_Interact_Screen_GUI_Found then pcall(function() g.Locate_Player_Interact_GUI() end) end

g.phone_call_local_event_Bindable_Event_finder = function()
    local cache = g.phone_call_bindable_event_found
    if cache and cache:IsA("BindableEvent") and cache.Parent then return cache end

    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
       if v:IsA("BindableEvent") and v.Name:lower():find("phone") and v.Name:lower():find("call") and v.Name:lower():find("event") then
            g.phone_call_bindable_event_found = v
            return v
        end
    end
    
    return nil
end
wait(0.1)
if not g.phone_call_bindable_event_found then pcall(function() g.phone_call_local_event_Bindable_Event_finder() end) end

g.Hang_Up_Call = function()
    local phone_call_local_event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PhoneCallLocalEvent")
    local ok, err = pcall(function() phone_call_local_event:Fire("UnCall") end)
    if ok then
        g.notify("Success", "Call ended.", 3)
    else
        g.notify("Error", "Failed to end call: "..tostring(err), 3)
    end
end

g.Call_Player_Func = function(player)
    local phone_handler = g.player_phone_call_RE or g.find_Phone_Call_Remote_Event()
    if not phone_handler or not phone_handler:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: PhoneCallEvent does not exist or is not a RemoteEvent.", 3) end
    local phone_event_bindable = g.phone_call_bindable_event_found or g.phone_call_local_event_Bindable_Event_finder()
    if not phone_event_bindable or not phone_event_bindable:IsA("BindableEvent") then return g.notify("Error", "BindableEvent: PhoneCallLocalEvent was not found or is not a BindableEvent.", 3) end
    if not player then return g.notify("Error", "Could not find player from: "..tostring(player), 3) end
    phone_handler:FireServer("Call", player.UserId)
    task.wait(0)
    phone_event_bindable:Fire("UnCall")
end

g.Carry_Request_Player = function(target, method)
    local pickup_request_RE = g.player_request_pickup_RE or g.get_player_request_pickup_Remote_Event()
    if not pickup_request_RE or not pickup_request_RE:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: 发送交互请求 does not exist or is not a RemoteEvent.", 3) end
    if not target then return g.notify("Error", "Could not find player from: "..tostring(method), 3) end
    local fun_click_data_RE = g.click_data_fun_detector_RE or g.click_detector_Remote_Event_Finder()
    if not fun_click_data_RE or not fun_click_data_RE:IsA("RemoteEvent") then return end
    local target_character = target.Character or g.get_char(target, 5)
    if not target_character then return g.notify("Error", "Target Character does exist or they have left the game!", 3) end
    local interaction_GUI = g.Player_Interact_Screen_GUI_Found or g.Locate_Player_Interact_GUI()
    
    if target_character and target_character:FindFirstChildOfClass("ClickDetector") then target_character:FindFirstChildOfClass("ClickDetector").MaxActivationDistance = 99999 end
    task.wait(0)
    fun_click_data_RE:FireServer(target_character and target_character:FindFirstChildOfClass("ClickDetector"), "PlayerHug", method)
    pickup_request_RE:FireServer(method)
    if interaction_GUI and interaction_GUI:IsA("ScreenGui") then interaction_GUI.Enabled = false end
end

g.Toggle_Interact_GUI_Suppression = function(state)
    if not state then return FlamesLibrary.disconnect("Interact_GUI_Suppressor") end
    local interact_gui = g.Player_Interact_Screen_GUI_Found or g.Locate_Player_Interact_GUI()
    if not interact_gui then return end
    interact_gui.Enabled = false
    FlamesLibrary.connect("Interact_GUI_Suppressor", interact_gui:GetPropertyChangedSignal("Enabled"):Connect(function()
        if g.annoy_active and interact_gui.Enabled == true then
            interact_gui.Enabled = false
        end
    end))
end

g.get_collection_module = function()
    local success, mod = pcall(function()
        return require(speaker:WaitForChild("Collection"))
    end)
    if success then return mod end
    return nil
end

g.Get_Owned_Pets = function()
    local collection = g.get_collection_module()
    if not collection then return {} end
    local ok, result = pcall(function() return collection.returntable() end)
    if not ok or not result then return {} end
    return result.pet or {}
end

g.Count_Pet_Duplicates = function(pet_id, stage)
    local collection = g.get_collection_module()
    if not collection then return 0 end
    local ok, count = pcall(function()
        return collection.PetSameDatasum("pet", {id = pet_id, stage = stage})
    end)
    return ok and count or 0
end

g.Get_Total_Pets = function()
    local collection = g.get_collection_module()
    if not collection then return 0 end
    local ok, count = pcall(function() return collection.PetfindDatasum("pet") end)
    return ok and count or 0
end

g.find_catalog_editor_Screen_Gui = function()
    local cache = g.catalog_editor_screen_main
    if cache and cache:IsA("ScreenGui") then return cache end
    for _, v in ipairs(player_gui:GetDescendants()) do
        if v:IsA("ScreenGui") and v.Name:lower():find("catalog") and v.Name:lower():find("system") then
            g.catalog_editor_screen_main = v
            return v
        end
    end

    return nil
end

g.JumpHeight_Value = g.JumpHeight_Value or 7
g.JumpPower_Value = g.JumpPower_Value or 50
g.Apply_Jump_Settings = function(character)
    if not character then return end
    local Humanoid
    local attempts = 0
    local max_attempts = 5
    repeat
        Humanoid = character:FindFirstChildOfClass("Humanoid")
        if not Humanoid then
            attempts += 1
            task.wait(0.5)
        end
    until Humanoid or attempts >= max_attempts

    if not Humanoid or not Humanoid:IsA("Humanoid") then return warn("Could not find Humanoid on Character after "..max_attempts.." attempts: "..tostring(character:GetFullName())) end
    local ok, err = pcall(function()
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = g.JumpPower_Value
        Humanoid.JumpHeight = g.JumpHeight_Value
    end)

    if not ok then warn("Failed to apply Jump Settings: "..tostring(err)) end
end

FlamesLibrary.connect("Jump_Settings_CharacterAdded", speaker.CharacterAdded:Connect(function(character) g.Apply_Jump_Settings(character) end))
local Current_Character = g.Character or speaker.Character or g.get_char(speaker, 5)
if Current_Character then g.Apply_Jump_Settings(Current_Character) end
wait(0.1)
if not g.catalog_editor_screen_main then pcall(function() g.find_catalog_editor_Screen_Gui() end) end
local Atlas = loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Atlas_UI.lua", true))()
local UI = Atlas.new({
    Name = "Flames Hub | NewSmith RP",
    ConfigFolder = "FlamesHub_New_Smith_RP_Menu_Configuration",
    Color = Color3.fromRGB(21, 103, 251),
    Credit = "Flames Hub",
    Bind = "RightShift",
})
wait(0.25)
g.create_ui_element = g.create_ui_element or function(element_type, parent, config, global_name, flag)
    local creators = {
        Tab         = function() return parent:CreateTab(config) end,
        Section     = function() return parent:CreateSection(config) end,
        Toggle      = function() return parent:CreateToggle(config, flag) end,
        Slider      = function() return parent:CreateSlider(config, flag) end,
        Button      = function() return parent:CreateButton(config, flag) end,
        ColorPicker = function() return parent:CreateColorPicker(config, flag) end,
        Input       = function() return parent:CreateTextBox(config, flag) end,
        Dropdown    = function() return parent:CreateDropdown(config, flag) end,
        Label = function() return parent:CreateParagraph(config) end,
    }

    local creator = creators[element_type]
    if not creator then return g.notify("Error", "Unknown element type: " .. tostring(element_type), 3) end
    local element
    local done = false
    task.defer(function() element = creator() done = true end)
    while not done do task.wait() end
    if global_name then getgenv()[global_name] = element end
    return element
end
wait(0.25)
local Home_Page = UI:CreatePage("Main")
local Home_Section = Home_Page:CreateSection("Main")
local LocalPlayer_Section = Home_Page:CreateSection("LocalPlayer")
local Vehicle_Section = Home_Page:CreateSection("Vehicle")
local Players_Section = Home_Page:CreateSection("Players")
local Extras_Section = Home_Page:CreateSection("Extras")
g.create_ui_element("Toggle", Home_Section, {
Name = "Toggle Catalog GUI (while moving)",
Default = g.catalog_editor_screen_main and g.catalog_editor_screen_main.Enabled or false,
Flag = "Toggle_Catalog_GUI_UI",
Callback = function(state)
    if not g.catalog_editor_screen_main then return g.notify("Error", "Could not find ScreenGui: CatalogSystem, got: "..tostring(g.catalog_editor_screen_main), 3) end
    if g.catalog_editor_screen_main and g.catalog_editor_screen_main:IsA("ScreenGui") then
        g.catalog_editor_screen_main.Enabled = state
    end
end})

g.Total_Pets_Label = g.create_ui_element("Label", Home_Section, {
Content = "Loading..."
}, "Total_Pets_Label")
g.Wallpaper_Equipped_Label = g.create_ui_element("Label", Home_Section, {
Content = "Loading..."
}, "Wallpaper_Equipped_Label")
g.Refresh_Home_Labels = function()
    local collection = g.get_collection_module()
    if not collection then return end
    local ok1, total_pets = pcall(function() return collection.PetfindDatasum("pet") end)
    if ok1 and g.Total_Pets_Label then pcall(function() g.Total_Pets_Label.Set("Total Pets Owned: " .. tostring(total_pets)) end) end
    local ok2, full_table = pcall(function() return collection.returntable() end)
    if ok2 and full_table and full_table.Wallpaper and g.Wallpaper_Equipped_Label then
        local equipped = full_table.Wallpaper.Equip or "None"
        pcall(function() g.Wallpaper_Equipped_Label.Set("Wallpaper Equipped: " .. tostring(equipped)) end)
    end
end

g.Refresh_Home_Labels()
g.Home_Labels_Elapsed = 0
g.Home_Labels_Interval = 2
FlamesLibrary.connect("Home_Labels_Refresher", RunService.Heartbeat:Connect(function(Delta_Time)
    g.Home_Labels_Elapsed += Delta_Time
    if g.Home_Labels_Elapsed < g.Home_Labels_Interval then return end
    g.Home_Labels_Elapsed = 0
    g.Refresh_Home_Labels()
end))

g.Rainbow_Vehicle_UI_Toggle = g.create_ui_element("Toggle", Vehicle_Section, {
Name = "RGB Vehicle (FE)",
Default = getgenv().rainbow_vehicle_enabled or false,
Flag = "RGB_Vehicle_Toggle",
Callback = function(state)
    g.rainbow_vehicle(state)
end}, "RGB_Vehicle_Toggle")

g.Rainbow_Skin_UI_Toggle = g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "RGB Skin (FE)",
Default = getgenv().Rainbow_Skin_Enabled or false,
Flag = "RGB_Skin_Toggle",
Callback = function(state)
    g.rainbow_skin_color(state)
end}, "RGB_Skin_Toggle")

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Job Spammer (FE)",
Default = getgenv().spam_all_jobs_toggled or false,
Flag = "Job_Spammer_Toggle_UI",
Callback = function(state)
    g.job_spammer_toggle(state)
end}, "Job_Spammer_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Rainbow Name/Bio (FE)",
Default = getgenv().RP_Text_Changer_Enabled or false,
Flag = "Rainbow_Name_Tag_Toggle",
Callback = function(state)
    g.rainbow_RP_text_changer(state)
end}, "Rainbow_Name_Tag_Toggle")

g.main_vehicle_fly_UI_toggle = g.create_ui_element("Toggle", Vehicle_Section, {
Name = "Vehicle Fly (FE)",
Default = getgenv().vehicle_fly or false,
Flag = "Vehicle_Fly_Toggle_UI",
Callback = function(state)
    g.toggle_vehicle_fly(state)
end}, "Vehicle_Fly_Toggle_UI")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Fly Speed",
Min = 1,
Max = 100,
Default = getgenv().vehicle_fly_speed or false,
Flag = "Vehicle_Fly_Speed",
Callback = function(val)
    if g.vehicle_fly then g.vehicle_fly_speed = val end
end}, "Vehicle_Fly_Speed")

g.vehicle_noclip_switch_UI = Vehicle_Section:CreateToggle({
Name = "Vehicle Noclip (FE)",
Flag = "Vehicle_Noclip_FE",
Default = g.vehiclefly_noclip or false,
Callback = function(new_value)
	g.toggle_vehicle_noclip(new_value)
end,})

-- [[ Will return when I find a better method for it, I know there's one in this game somewhere, I just haven't found it yet. ]] --
--[[g.Anti_Sit_Toggle_UI = g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Anti-Sit",
Default = getgenv().Anti_Sit_Enabled or false,
Flag = "Anti_Sit_UI_Toggle",
Callback = function(state)
    g.Toggle_Anti_Sit(state)
end}, "Anti_Sit_UI_Toggle")--]]

g.create_ui_element("Button", Vehicle_Section, {
Name = "Despawn Vehicle (FE)",
Callback = function()
    g.Despawn_Current_Vehicle()
end})

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Body Parts Flasher (FE)",
Default = getgenv().currently_toggling_flashing_body_parts or false,
Flag = "Body_Parts_Flasher_Toggle_UI",
Callback = function(state)
    g.toggle_body_parts_flasher(state)
end}, "Body_Parts_Flasher_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Fly-1",
Default = getgenv().FlyEnabled or false,
Flag = "Fly_UI_Toggle",
Callback = function(state)
    if state then
        g.EnableFly(true)
    else
        g.DisableFly()
    end
end}, "Fly_UI_Toggle")

g.create_ui_element("Slider", LocalPlayer_Section, {
Name = "Fly-1 Speed",
Min = 1,
Max = 100,
Default = getgenv().FlySpeed or 5,
Flag = "Fly_Speed_Slider",
Callback = function(value)
    if getgenv().FlyEnabled then getgenv().FlySpeed = value end
end}, "Fly_Speed_Slider")

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Rainbow Fly",
Default = getgenv().Enabled_Flying or false,
Flag = "Rainbow_Fly_Toggle",
Callback = function(state)
    if state == true then
        local fly_speed = getgenv().Rainbow_Fly_Speed_Slider and getgenv().Rainbow_Fly_Speed_Slider.Value or 10
        g.EnableFly2(fly_speed)
    else
        g.DisableFly2()
    end
end}, "Rainbow_Fly_Toggle")

g.create_ui_element("Slider", LocalPlayer_Section, {
Name = "Rainbow Fly Speed",
Min = 1,
Max = 100,
Default = getgenv().Fly2Speed or 5,
Flag = "Rainbow_Fly_Speed_Slider",
Callback = function(value)
    if getgenv().Enabled_Flying then getgenv().Fly2Speed = value end
end}, "Rainbow_Fly_Speed_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Max Speed",
Min = 10,
Max = 300,
Default = 119,
Flag = "Vehicle_Max_Speed_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "MaxSpeed", value) end
end}, "Vehicle_Max_Speed_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Reverse Speed",
Min = 5,
Max = 150,
Default = 71,
Flag = "Vehicle_Reverse_Speed_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "ReverseSpeed", value) end
end}, "Vehicle_Reverse_Speed_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Driving Torque",
Min = 1000,
Max = 150000,
Default = 30000,
Flag = "Vehicle_Driving_Torque_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "DrivingTorque", value) end
end}, "Vehicle_Driving_Torque_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Braking Torque",
Min = 1000,
Max = 200000,
Default = 70000,
Flag = "Vehicle_Braking_Torque_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "BrakingTorque", value) end
end}, "Vehicle_Braking_Torque_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Front Strut Stiffness",
Min = 1000,
Max = 80000,
Default = 28000,
Flag = "Vehicle_Strut_Stiffness_Front_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "StrutSpringStiffnessFront", value) end
end}, "Vehicle_Strut_Stiffness_Front_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Front Strut Damping",
Min = 100,
Max = 8000,
Default = 1430,
Flag = "Vehicle_Strut_Damping_Front_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "StrutSpringDampingFront", value) end
end}, "Vehicle_Strut_Damping_Front_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Rear Strut Stiffness",
Min = 1000,
Max = 80000,
Default = 27000,
Flag = "Vehicle_Strut_Stiffness_Rear_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "StrutSpringStiffnessRear", value) end
end}, "Vehicle_Strut_Stiffness_Rear_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Rear Strut Damping",
Min = 100,
Max = 8000,
Default = 1400,
Flag = "Vehicle_Strut_Damping_Rear_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "StrutSpringDampingRear", value) end
end}, "Vehicle_Strut_Damping_Rear_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Torsion Stiffness",
Min = 1000,
Max = 80000,
Default = 20000,
Flag = "Vehicle_Torsion_Stiffness_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "TorsionSpringStiffness", value) end
end}, "Vehicle_Torsion_Stiffness_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Torsion Damping",
Min = 10,
Max = 800,
Default = 150,
Flag = "Vehicle_Torsion_Damping_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "TorsionSpringDamping", value) end
end}, "Vehicle_Torsion_Damping_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Max Steer",
Min = 0.1,
Max = 1,
Default = 0.55,
Flag = "Vehicle_Max_Steer_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "MaxSteer", value) end
end}, "Vehicle_Max_Steer_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Wheel Friction",
Min = 0.8,
Max = 4,
Default = 2,
Flag = "Vehicle_Wheel_Friction_Slider",
Callback = function(value)
    local vehicle = g.get_current_vehicle()
    if vehicle then g.Set_Vehicle_Setting(vehicle, "WheelFriction", value) end
end}, "Vehicle_Wheel_Friction_Slider")

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Noclip",
Default = getgenv().Noclip_Enabled or false,
Flag = "Noclip_UI_Toggle",
Callback = function(state)
    toggle_noclip(state)
end}, "Noclip_UI_Toggle")

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Anti-Fling",
Default = getgenv().antiFlingEnabled or false,
Flag = "AntiFling_UI_Toggle",
Callback = function(state)
    toggle_antifling(state)
end}, "AntiFling_UI_Toggle")

g.create_ui_element("Toggle", Extras_Section, {
Name = "Anti Call (FE)",
Default = getgenv().currently_on_do_not_call or false,
Flag = "FlamesHub_AntiCallToggleUI",
Callback = function(state)
    g.anti_call_func(state)
end}, "FlamesHub_AntiCallToggleUI")

g.create_ui_element("Input", Players_Section, {
Name = "Annoy Player (FE)",
PlaceholderText = "Username or displayname...",
Flag = "Annoy_Player_Input_UI",
Callback = function(split)
    local Target = g.findplr(split)
    if not Target then return g.notify("Error", "That Player does not exist or has left the game.", 3) end
    if Target.Name == "CIippedByAura" or Target.Name == "L0CKED_1N1" then return end
    if g.Currently_Running_Annoy_Loop then
        if g.Currently_Annoying_Player then
            return g.notify("Error", "You are already annoying: " .. tostring(g.Currently_Annoying_Player) .. "!", 3)
        else
            return g.notify("Error", "You are already annoying a Player!", 3)
        end
    end

    local target_userid = Target.UserId
    local rejoin_limit = 60
    g.Currently_Annoying_Player = Target.Name
    g.annoy_active = true
    g.Toggle_Interact_GUI_Suppression(true)
    g.notify("Success", "Now annoying Player: "..tostring(Target.Name), 3)
    local Annoy_Thread = task.spawn(function()
        while g.annoy_active == true do
            local success, err = pcall(function()
                if not Target or not Target.Parent or not Target.Character then
                    local elapsed_time = 0
                    g.notify("Warning", "Target left, waiting 60 seconds for them to rejoin...", 7.5)
                    while elapsed_time < rejoin_limit and g.annoy_active == true do
                        local found_player = false
                        for _, plr in ipairs(g.Players:GetPlayers()) do
                            if plr.UserId == target_userid then
                                Target = plr
                                g.notify("Success", "Target rejoined, resuming annoyance loop!", 5)
                                found_player = true
                                break
                            end
                        end
                        if found_player then break end
                        task.wait(1)
                        elapsed_time += 1
                    end

                    if elapsed_time >= rejoin_limit then
                        g.annoy_active = false
                        g.Currently_Annoying_Player = nil
                        g.Currently_Running_Annoy_Loop = nil
                        g.Toggle_Interact_GUI_Suppression(false)
                        return g.notify("Warning", "Target did not rejoin within 60 seconds, loop disabled.", 5)
                    end
                end

                local carry_method = g.current_carry_methods[math.random(1, #g.current_carry_methods)]
                g.Carry_Request_Player(Target, carry_method)
                task.wait(0)
                g.Call_Player_Func(Target)
            end)

            if not success then
                warn("Annoy loop error: "..tostring(err))
                g.annoy_active = false
                g.Currently_Annoying_Player = nil
                g.Currently_Running_Annoy_Loop = nil
                g.Toggle_Interact_GUI_Suppression(false)
            end
            task.wait(0)
        end

        g.Currently_Annoying_Player = nil
        g.Currently_Running_Annoy_Loop = nil
        g.Toggle_Interact_GUI_Suppression(false)
    end)

    g.Currently_Running_Annoy_Loop = Annoy_Thread
end}, "Annoy_Player_Input_UI")

g.create_ui_element("Button", Players_Section, {
Name = "Stop Annoying Player (FE)",
Callback = function()
    if not g.Currently_Running_Annoy_Loop then return g.notify("Error", "You are not currently annoying anyone!", 3) end
    g.annoy_active = false
    g.notify("Success", "Annoy loop has been stopped.", 3)
end})

g.create_ui_element("Button", Extras_Section, {
Name = "Infinite Premium",
Callback = function()
    if getgenv().IY_LOADED then return end
    if getgenv().GET_LOADED_IY then return end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Infinite_Premium.lua"))()
end})

g.create_ui_element("Button", Extras_Section, {
Name = "Infinite Yield",
Callback = function()
    if getgenv().IY_LOADED then return end
    if getgenv().GET_LOADED_IY then return end
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end})
