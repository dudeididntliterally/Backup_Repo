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

local g = getgenv()
local Raw_Version = "V9.0.7"
g.Script_Version = tostring(Raw_Version).."-LifeHub"
local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local localPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
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
g.LocalPlayer = g.LocalPlayer or localPlayer

if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Global_Environment.lua"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end
wait(0.25)
if not g.LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client then
    if g.notify then
        g.notify("Success", "Got LocalPlayer: "..tostring(g.LocalPlayer), 5)
    end
end

local has_gethui = (typeof(get_hui) == "function") or (typeof(g.get_hui) == "function")
local has_gethidden = (typeof(get_hidden_gui) == "function") or (typeof(g.get_hidden_gui) == "function")
local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
if not has_gethui and not has_gethidden and not g.roblox_hidden_gui_location then
    local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
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

local verify_file = "is_verified_in_Flames_Hub.txt"
local Insert = table.insert
-- [[ for the Command Handler, because it can check if there is a number in a string (like a command you send). ]] -- 
g.Is_Integer_In_Str = g.Is_Integer_In_Str or function(str)
    if type(str) == "number" then
        return str % 1 == 0
    end

    if type(str) == "string" then
        return str:match("^-?%d+$") ~= nil
    end

    return false
end

-- [[ NEW!: makes it way fucking easier to find attributes. ]] --
g._attr_cache = g._attr_cache or {}
g.attr_cached_fuzzy = g.attr_cached_fuzzy or function(obj, search)
    if not obj or not obj.Parent then return nil end
    local cache = g._attr_cache[obj]

    if cache then
        for name, value in pairs(cache) do
            if name:lower():find(search:lower(), 1, true) then
                return value
            end
        end
        return nil
    end

    local ok, attrs = pcall(function()
        return obj:GetAttributes()
    end)

    if not ok or not attrs then return nil end

    g._attr_cache[obj] = attrs

    for name, value in pairs(attrs) do
        if name:lower():find(search:lower(), 1, true) then
            return value
        end
    end

    return nil
end

g.attr_main_checker = g.attr_main_checker or function(obj, attr, expected)
    local ok, result = pcall(function()
        return obj:GetAttribute(attr)
    end)
    return ok and result == expected
end

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

local function isVerified()
    if not isfile then return false end
    if not isfile(verify_file) then return false end
    local content = readfile(verify_file)
    return type(content) == "string" and content:lower():find("true") ~= nil
end

local function setVerified()
    if writefile then
        writefile(verify_file, "true")
    end
end

local function waitForGuiGone()
    local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    while CoreGui:FindFirstChild("MemoryMinigameGUI") do
        task.wait()
    end
end

g.disabled_global_value_correctly = g.disabled_global_value_correctly or function(input)
    local ok, result = pcall(function()
        return input
    end)

    if not ok then
        return true
    end

    return not result
end

g.LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client = true
local userid = game.Players.LocalPlayer.UserId
local http = g.HttpService or cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
local lib = g.FlamesLibrary
getgenv().lib = getgenv().FlamesLibrary -- necessary for some reason.
local lib_attempts = 0
local lib_max_attempts = 15
while (not lib or type(lib) ~= "table") and lib_attempts < lib_max_attempts do
    task.wait(0.5)
    lib_attempts = lib_attempts + 1
    lib = g.FlamesLibrary
end

if not lib or type(lib) ~= "table" then
    if g.notify then g.notify("Error", "FlamesLibrary failed to load, title system cannot continue.", 10) end
    return
end

local function mask_unique_id(id)
    if not id then return nil end
    local parts = string.split(id, "-")
    local out = {}
    for i = 1, #parts do
        if i <= 2 then
            out[i] = parts[i]
        else
            out[i] = string.rep("*", #parts[i])
        end
    end

    return table.concat(out, "-")
end

function create_flames_hub_unique_id(target_user_id)
    local file_name = "flames_hub_unique_ID.txt"

    if userid ~= target_user_id then
        return nil
    end

    if isfile and isfile(file_name) then
        local id = readfile and readfile(file_name)
        if id and id ~= "" then
            return id
        end
    end

    local new_id = http:GenerateGUID(false)
    pcall(function() writefile(file_name, new_id) end)

    return new_id
end

function get_flames_hub_unique_id()
    local file_name = "flames_hub_unique_ID.txt"

    if isfile and isfile(file_name) then
        local id = readfile and readfile(file_name)
        if id and id ~= "" then
            return id
        end
    end

    return nil
end

function create_masked_flames_hub_unique_server_id(target_user_id)
    local raw = create_flames_hub_unique_id(target_user_id)
    return mask_unique_id(raw)
end

function get_masked_flames_hub_unique_id()
    local raw = get_flames_hub_unique_id()
    return mask_unique_id(raw)
end

local Chat = cloneref and cloneref(game:GetService("Chat")) or game:GetService("Chat")
local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local me = g.LocalPlayer or Players.LocalPlayer
local TextChatService = g.TextChatService or cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")
local ws_connect = (syn and syn.websocket and syn.websocket.connect) or (WebSocket and WebSocket.connect) or (websocket and websocket.connect)
local http_req = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
g.will_tag = g.will_tag or function(text)
    local filtered
    local success, response = pcall(function()
        filtered = Chat:FilterStringForBroadcast(text, me)
    end)
    if not success then print(tostring(response)) return true end
    return filtered ~= text
end

g.Memory_Mini_Game_GUI = function()
    local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
    local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local GRID_SIZE = 5
    local TILE_COUNT = GRID_SIZE * GRID_SIZE
    local SHOW_TIME = 10
    local MAX_MISTAKES = 3
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
    local function cleanup() if gui then gui:Destroy() end end
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
        local count = math.random(6, 9)
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
        for _, index in ipairs(pattern) do
            if not found[index] then return end
        end
        task.delay(0.02, function()
            g.memory_mini_game_cooldown = tick()
            if g.notify then
                g.notify("Success", "You completed the memory mini-game.", 5)
            end
            cleanup()
        end)
    end

    local function show_pattern()
        for _, index in ipairs(pattern) do
            tiles[index].BackgroundColor3 = GREEN
        end
    end

    local function hide_pattern()
        for i, btn in ipairs(tiles) do
            if not found[i] then
                btn.BackgroundColor3 = BLUE
            end
        end
        input_locked = false
    end

    local function fail()
        if g.notify then
            g.notify("Error", "You failed the memory mini-game.", 5)
        end
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

    local MAX_WINS = 5
    local MAX_MISSES = 3
    local PURPLE = Color3.fromRGB(170, 85, 255)
    local DARK = Color3.fromRGB(18, 18, 18)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local RED = Color3.fromRGB(200, 60, 60)
    tg.wins = 0
    tg.misses = 0
    tg.speed = 0.6

    local gui = Instance.new("ScreenGui")
    gui.Name = "ReactionTimeMinigame"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui
    tg.gui = gui

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
            if center_dist < 0.02 then
                flash("PERFECT", Color3.fromRGB(180, 255, 255))
            else
                flash("GOOD", PURPLE)
            end
            tg.wins = tg.wins + 1
            tg.speed = tg.speed + 0.15
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

    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local DARK = Color3.fromRGB(18, 18, 18)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local GREEN = Color3.fromRGB(0, 220, 100)
    local RED = Color3.fromRGB(200, 60, 60)
    local YELLOW = Color3.fromRGB(255, 200, 0)
    local GREY = Color3.fromRGB(40, 40, 40)
    local CODE_LENGTH = 4
    local MAX_ATTEMPTS = 5
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
    display_label.Text = "_ _ _ _"
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
    local function cleanup() if gui then gui:Destroy() end end
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
        if g.notify then
            g.notify("Success", "Keypad cracked!.", 30)
        end
        task.delay(0.5, cleanup)
    end

    local function fail()
        if g.notify then
            g.notify("Error", "Keypad locked out!.", 5)
        end
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

    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local RunService = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
    local DARK = Color3.fromRGB(10, 10, 10)
    local GREEN = Color3.fromRGB(0, 255, 100)
    local DIM_GREEN = Color3.fromRGB(0, 100, 40)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local RED = Color3.fromRGB(200, 60, 60)
    local YELLOW = Color3.fromRGB(255, 200, 0)
    local GRID_COLS = 8
    local GRID_ROWS = 6
    local SEQUENCE_LENGTH = 4
    local TIME_LIMIT = 20
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
        for col = 1, GRID_COLS do
            grid_data[row][col] = chars[math.random(1, #chars)]
        end
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

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 520, 0, 480)
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
    end

    local function update_progress()
        local parts = {}
        for _, v in ipairs(current_sequence) do
            table.insert(parts, v)
        end
        progress_label.Text = "INPUT:  " .. table.concat(parts, "  ")
    end

    local function win()
        game_over = true
        g.hacking_minigame_cooldown = tick()
        if g.notify then
            g.notify("Success", "Breach successful!.", 5)
        end
        task.delay(0.5, cleanup)
    end

    local function fail(msg)
        game_over = true
        if g.notify then
            g.notify("Error", msg or "Breach failed!", 5)
        end
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
        if time_left <= 5 then
            timer_label.TextColor3 = RED
        end
    end)
end

g.safe_cracker_minigame = function()
    if g.safe_cracker_cooldown and tick() - g.safe_cracker_cooldown < 30 then
        local remaining = math.ceil(30 - (tick() - g.safe_cracker_cooldown))
        if g.notify then g.notify("Warning", "You must wait " .. remaining .. " seconds before playing again.", 5) end
        return
    end

    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local RunService = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
    local DARK = Color3.fromRGB(12, 10, 8)
    local GOLD = Color3.fromRGB(200, 160, 40)
    local DIM_GOLD = Color3.fromRGB(80, 60, 10)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local RED = Color3.fromRGB(200, 60, 60)
    local GREEN = Color3.fromRGB(60, 200, 100)
    local SEQUENCE_COUNT = 3
    local NOTCH_COUNT = 20
    local TIME_LIMIT = 30
    local TARGET_WINDOW = 1.2
    local targets = {}
    for i = 1, SEQUENCE_COUNT do table.insert(targets, math.random(1, NOTCH_COUNT)) end
    local current_step = 1
    local dial_angle = 0
    local dial_speed = 90
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
        local within = diff <= 1 or diff >= NOTCH_COUNT - 1

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

    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local DARK = Color3.fromRGB(12, 12, 14)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local MUTED = Color3.fromRGB(120, 120, 130)
    local RED = Color3.fromRGB(220, 60, 60)
    local GREEN = Color3.fromRGB(60, 200, 100)
    local YELLOW = Color3.fromRGB(230, 200, 50)
    local BLUE = Color3.fromRGB(80, 140, 240)
    local ORANGE = Color3.fromRGB(230, 130, 40)
    local WHITE_W = Color3.fromRGB(200, 200, 200)
    local TIME_LIMIT = 25
    local WIRE_COLORS = {
        {name = "Red",    color = RED},
        {name = "Green",  color = GREEN},
        {name = "Yellow", color = YELLOW},
        {name = "Blue",   color = BLUE},
        {name = "Orange", color = ORANGE},
        {name = "White",  color = WHITE_W},
    }
    local WIRE_COUNT = 5
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
    local positions = {"first", "second", "third", "fourth", "fifth"}
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
    for i = 1, math.min(3, #clue_types) do
        table.insert(shown_clues, clue_types[indices[i]])
    end

    local game_over = false
    local timer_conn = nil
    if CoreGui:FindFirstChild("WireCutterGUI") then CoreGui.WireCutterGUI:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "WireCutterGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 480)
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

    local wire_start_y = 44 + (#shown_clues + 2) * 20
    local function cleanup()
        if timer_conn then timer_conn:Disconnect() end
        if gui then gui:Destroy() end
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
                cut_btn.Text = getgenv().Flames_Hub_Emojis and tostring(getgenv().Flames_Hub_Emojis["Checkmark"])
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
    timer_conn = g.RunService.Heartbeat:Connect(function(dt)
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

    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
    local DARK = Color3.fromRGB(14, 14, 18)
    local WHITE = Color3.fromRGB(240, 240, 240)
    local MUTED = Color3.fromRGB(100, 100, 110)
    local RED = Color3.fromRGB(220, 60, 60)
    local ROUNDS_TO_WIN = 5
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
    local function cleanup()
        if gui then gui:Destroy() end
    end

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
            if callback then task.delay(0.1, callback) end
        end)
    end

    local function play_sequence(step, callback)
        if step > #sequence then
            if callback then callback() end
            return
        end
        flash_button(sequence[step], 0.4, function()
            task.delay(0.15, function()
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

g.open_minigame_menu = function()
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    if CoreGui:FindFirstChild("MinigameMenuGUI") and CoreGui:FindFirstChild("MinigameMenuGUI"):IsA("ScreenGui") then CoreGui.MinigameMenuGUI:FindFirstChildOfClass("Frame").Visible = true return end
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
            name        = "Memory Grid",
            sub         = "Memorize the pattern, then tap the tiles",
            difficulty  = "Easy",
            diff_color  = GREEN_C,
            win_coins   = "+3",
            loss_coins  = "-5",
            desc        = "A 5x5 grid lights up 6-9 tiles for 10 seconds. Memorize their positions, then click every highlighted tile before making 3 mistakes.",
            fn          = function() g.Memory_Mini_Game_GUI() end,
        },
        {
            name        = "Reaction Time",
            sub         = "Land the moving bar in the zone 5 times successfully",
            difficulty  = "Medium",
            diff_color  = YELLOW_C,
            win_coins   = "+15",
            loss_coins  = "-5",
            desc        = "A bar bounces left and right at increasing speed. Click when it overlaps the purple target zone. Hit it 5 times to win — miss 3 and it's over.",
            fn          = function() g.reaction_time_minigame() end,
        },
        {
            name        = "Keypad Hack",
            sub         = "Crack the 4-digit code in 5 attempts",
            difficulty  = "Master",
            diff_color  = RED_C,
            win_coins   = "+30",
            loss_coins  = "-10",
            desc        = "A secret 4-digit code is generated. Enter your guess and receive hints — correct position vs. correct number. Deduce the code in 5 attempts or get locked out.",
            fn          = function() g.keypad_minigame() end,
        },
        {
            name        = "Breach Protocol",
            sub         = "Input the target sequence from the grid",
            difficulty  = "Medium",
            diff_color  = YELLOW_C,
            win_coins   = "+5",
            loss_coins  = "-5",
            desc        = "A Cyberpunk-style matrix grid. Alternate selecting columns and rows to build a 4-character sequence matching the target. You have 20 seconds before the breach fails.",
            fn          = function() g.hacking_minigame() end,
        },
        {
            name        = "Safe Cracker",
            sub         = "Hit 3 target notches on the spinning dial",
            difficulty  = "Hard",
            diff_color  = RED_C,
            win_coins   = "+12",
            loss_coins  = "-5",
            desc        = "A dial spins at increasing speed across 20 notches. Click CRACK when the marker lands on the target notch for each of 3 steps. One wrong click and the safe locks.",
            fn          = function() g.safe_cracker_minigame() end,
        },
        {
            name        = "Wire Cutter",
            sub         = "Cut the correct wire using the intel clues",
            difficulty  = "Easy",
            diff_color  = GREEN_C,
            win_coins   = "+10",
            loss_coins  = "-5",
            desc        = "Five wires are presented with partial intel clues about which ones are dangerous. Deduce the safe wire and cut it before the timer runs out.",
            fn          = function() g.wire_cutter_minigame() end,
        },
        {
            name        = "Simon Says",
            sub         = "Repeat the color sequence 5 rounds in a row",
            difficulty  = "Medium",
            diff_color  = YELLOW_C,
            win_coins   = "+10",
            loss_coins  = "-5",
            desc        = "Four colored buttons flash a growing sequence each round. Watch carefully then repeat it back in order. One wrong press and you lose. Survive 5 rounds to win.",
            fn          = function() g.simon_says_minigame() end,
        },
    }

    local gui = Instance.new("ScreenGui")
    gui.Name = "MinigameMenuGUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local outer = Instance.new("Frame")
    outer.AnchorPoint = Vector2.new(0.5, 0.5)
    outer.Position = UDim2.fromScale(0.5, 0.5)
    outer.Size = UDim2.new(0, 360, 0, 520)
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
    title_lbl.Size = UDim2.new(1, -90, 1, 0)
    title_lbl.Position = UDim2.new(0, 14, 0, 0)
    title_lbl.BackgroundTransparency = 1
    title_lbl.Text = "Flames Hub Mini-Games | Earn Coins"
    title_lbl.TextScaled = true
    title_lbl.Font = Enum.Font.GothamBold
    title_lbl.TextSize = 14
    title_lbl.TextColor3 = WHITE
    title_lbl.TextXAlignment = Enum.TextXAlignment.Left
    title_lbl.Parent = header

    dragify(outer)
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

    local close_btn    = make_header_btn("X", -45)
    local minimize_btn = make_header_btn("-", -80)
    close_btn.MouseButton1Click:Connect(function() gui:FindFirstChildOfClass("Frame").Visible = false end)
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
            diff_lbl.BackgroundColor3 = picked_game.diff_color
            diff_lbl.BackgroundTransparency = 0.75
            diff_lbl.Text = picked_game.difficulty
            diff_lbl.Font = Enum.Font.GothamBold
            diff_lbl.TextSize = 11
            diff_lbl.TextColor3 = picked_game.diff_color
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

            local reward_lbl = Instance.new("TextLabel")
            reward_lbl.Size = UDim2.new(1, -24, 0, 14)
            reward_lbl.Position = UDim2.new(0, 12, 0, 50)
            reward_lbl.BackgroundTransparency = 1
            reward_lbl.RichText = true
            reward_lbl.Text = '<font color="rgb(100,200,120)">Win ' .. picked_game.win_coins .. '</font>  <font color="rgb(190,80,80)">Loss ' .. picked_game.loss_coins .. '</font>'
            reward_lbl.Font = Enum.Font.Gotham
            reward_lbl.TextSize = 11
            reward_lbl.TextXAlignment = Enum.TextXAlignment.Left
            reward_lbl.TextColor3 = MUTED
            reward_lbl.Parent = card

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
                    desc_lbl.AutomaticSize = Enum.AutomaticSize.Y
                    desc_lbl.Size = UDim2.new(1, -24, 0, 0)
                    desc_lbl.Visible = true
                    task.defer(function()
                        local text_height = desc_lbl.AbsoluteSize.Y
                        card.Size = UDim2.new(1, 0, 0, 112 + text_height + 16)
                    end)
                    desc_btn.Text = "(X) Hide"
                else
                    desc_lbl.Visible = false
                    desc_lbl.AutomaticSize = Enum.AutomaticSize.None
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
end

create_flames_hub_unique_id(game.Players.LocalPlayer.UserId)
wait(0.3)
local flames_unique_server_ID = get_flames_hub_unique_id()
local masked_flames_hub_server_ID = get_masked_flames_hub_unique_id()
local Lib, lib = g.FlamesLibrary
g.masked_flames_hub_server_ID = masked_flames_hub_server_ID
wait(0.1)
if not isVerified() then
    if g.notify then
        g.notify("Warning", "Please complete this one time verification to boot into Flames Hub | Script Hub!", 30)
    end
    g.Memory_Mini_Game_GUI()
    waitForGuiGone()
    setVerified()
    if g.notify then
        g.notify("Success", "You have been verified in Flames Hub successfully.", 15)
        g.notify("Success", "Your special Flames Hub GUID: "..tostring(masked_flames_hub_server_ID), 11)
    end
else
    if g.notify then g.notify("Success", "We have verified you in our system | has already completed verification.", 20) end
    if g.notify then g.notify("Success", "Your special Flames Hub GUID: "..tostring(masked_flames_hub_server_ID), 10) end
end
wait(0.1)
g.safe_wrapper = g.safe_wrapper or function(service)
    if cloneref then
        return cloneref(game:GetService(service))
    else
        return game:GetService(service)
    end
end

local replicate_sig_func = replicatesignal or replicate_signal or DeltaSignal
local set_hid_func = sethiddenproperty or set_hidden_property or set_hidden_prop or sethiddenprop
g.originalIO = g.originalIO or {}
g.spectateConns = g.spectateConns or {}
local fw = getgenv().FlamesLibrary.wait
local name = "administrator_watcher_conn_Flames_Hub"
originalIO.ensureCam = function(spectateTarget)
    if not spectateTarget or not spectateSubject then return end
    if not workspace then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    if isProperty(cam, "CameraSubject") == nil then return end
    if cam.CameraSubject ~= spectateSubject then
        setProperty(cam, "CameraSubject", spectateSubject)
    end
end

originalIO.hookCameraGuard = function(spectateTarget)
    if not workspace then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    if spectateConns.cam then
        spectateConns.cam:Disconnect()
        spectateConns.cam = nil
    end
    wait(0.25)
    if isProperty(cam, "CameraSubject") ~= nil then
        spectateConns.cam = g.FlamesLibrary.connect("spectate_cam", cam:GetPropertyChangedSignal("CameraSubject"):Connect(function()
            if not spectateTarget or not spectateSubject then return end
            originalIO.ensureCam()
        end))
    end

    if not spectateConns.camW and isProperty(workspace, "CurrentCamera") ~= nil then
        spectateConns.camW = g.FlamesLibrary.connect("spectate_camW", workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            if not spectateTarget or not spectateSubject then return end
            originalIO.hookCameraGuard()
            originalIO.ensureCam()
        end))
    end
end

originalIO.captureIO = function(name)
    local fn
    if rawget then fn = rawget(_G, name) end
    if type(fn) ~= "function" then fn = _G[name] end
    if type(fn) == "function" then originalIO[name] = fn end
end
wait(0.1)
if not originalIO.__captured then
    originalIO.__captured = true
    originalIO.captureIO('readfile')
    originalIO.captureIO('writefile')
    originalIO.captureIO('appendfile')
    originalIO.captureIO('listfiles')
    originalIO.captureIO('makefolder')
    originalIO.captureIO('delfile')
    originalIO.captureIO('delfolder')
    originalIO.captureIO('isfile')
    originalIO.captureIO('isfolder')
end

originalIO.pathVariants = function(path)
    if type(path) ~= "string" then
        return { path }
    end
    if path:match('^[%w_]+://') then
        return { path }
    end
    local variants, seen = {}, {}
    local function add(value)
        if type(value) == "string" and value ~= "" and not seen[value] then
            seen[value] = true
            Insert(variants, value)
        end
    end
    add(path)
    add(path:gsub('\\+', '\\'))
    add(path:gsub('//+', '/'))
    add(path:gsub('/', '\\'))
    add(path:gsub('\\', '/'))
    local trimmed = path:gsub('^%.[/\\]+', '')
    if trimmed ~= path then
        add(trimmed)
        add(trimmed:gsub('/', '\\'))
        add(trimmed:gsub('\\', '/'))
    end
    return variants
end

originalIO.resolveWithListfiles = function(target)
    local lf = originalIO.listfiles
    if type(lf) ~= "function" then
        return nil
    end
    local dir, filename = target:match('^(.*)[/\\]([^/\\]+)$')
    if not dir or filename == '' then
        return nil
    end
    local dirVariants = originalIO.pathVariants(dir)
    local results = {}
    local lowered = filename:lower()
    for _, candidateDir in ipairs(dirVariants) do
        local ok, entries = pcall(lf, candidateDir)
        if ok and type(entries) == "table" then
            for _, entry in ipairs(entries) do
                local name = entry:match('([^/\\]+)$')
                if name and name:lower() == lowered then
                    Insert(results, entry)
                end
            end
        end
    end
    if #results > 0 then
        return results
    end
    return nil
end

g.input_to_String = g.input_to_String or function(input_value) return typeof(input_value) == "string" and input_value or tostring(input_value) end
if g.notify and typeof(g.notify) == "function" then g.notify("Info", "Booting up Life Together RP Hub, please wait a few moments while we initialize everything...", 8) end
g.service_cache = g.service_cache or {}
g.Sound_ID_Windows = g.Sound_ID_Windows or "rbxassetid://8183296024"
g.Sound_ID_iPhone = g.Sound_ID_iPhone or "rbxassetid://73722479618078"
g.Sound_ID_Android = g.Sound_ID_Android or "rbxassetid://17582299860"
g.Sound_ID_Universal = g.Sound_ID_Universal or "rbxassetid://18595195017"
local aliases = {
    rs = "ReplicatedStorage",
    rf = "ReplicatedFirst",
    ws = "Workspace",
    works = "Workspace",
    player = "Players",
    plr = "Players",
    plrs = "Players",
    ts = "TweenService",
    uis = "UserInputService"
}

local virtuals = {
    lp = true,
    localplayer = true,
    localplr = true
}

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

    if best_score <= 4 then
        return best_name
    end

    return nil
end

local function fetch_value(name)
    if not name then return nil end
    local lowered = tostring(name):lower()
    if virtuals[lowered] then
        local ok, players = pcall(function()
            return g.service_cache["Players"].LocalPlayer
        end)

        if not ok or not players then
            return nil
        end

        local lp = players.LocalPlayer
        if lp then
            return lowered, lp
        end

        return nil
    end

    local resolved = resolve_service(name)
    if not resolved then return nil end
    local ok, svc = pcall(function()
        return game:GetService(resolved)
    end)

    if not ok or not svc then return nil end

    if cloneref then
        local success, cloned = pcall(function()
            return cloneref(svc)
        end)
        if success and cloned then
            svc = cloned
        end
    end

    return resolved, svc
end

if setmetatable and getmetatable and rawget and rawset then
    if not getmetatable(g.service_cache) then
        setmetatable(g.service_cache, {
            __index = function(self, key)
                local existing = rawget(self, key)
                if existing then
                    return existing
                end

                local resolved_key, value = fetch_value(key)
                if not value then
                    return nil
                end

                rawset(self, key, value)

                if resolved_key and resolved_key ~= key then
                    rawset(self, resolved_key, value)
                end

                return value
            end
        })
    end

    g.safe_wrapper = function(name)
        if not name then return nil end
        return g.service_cache[name]
    end
else
    g.safe_wrapper = function(name)
        if not name then return nil end
        if g.service_cache[name] then return g.service_cache[name] end
        local resolved_key, value = fetch_value(name)
        if not value then return nil end

        g.service_cache[name] = value

        if resolved_key and resolved_key ~= name then
            g.service_cache[resolved_key] = value
        end

        return value
    end
end
wait(0.2)
g.type = typeof or type
g.string_contains_plain = g.string_contains_plain or function(source, needle)
    if typeof(source) ~= "string" or typeof(needle) ~= "string" then
        return false
    end
    return source:lower():find(needle:lower(), 1, true) ~= nil
end

g.load_youtube_music_player_func = g.load_youtube_music_player_func or function()
    if g.You_Tube_Music_Player_Loaded then return getgenv().notify("Warning", "YouTube Music Player is already loaded.", 5) end
    g.You_Tube_Music_Player_Loaded = true
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/YoutubeMusicPlayer.lua'), true))()
    local asset_id = "76673896881913"
    local target_image = "rbxassetid://" .. asset_id
    task.spawn(function()
        local core_gui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
        local screen_gui
        repeat
            task.wait(0.1)
            for _, v in ipairs(core_gui:GetChildren()) do
                if v:IsA("ScreenGui") then
                    for _, child in ipairs(v:GetDescendants()) do
                        if child:IsA("ImageButton") and child.Image == target_image then
                            screen_gui = v
                            break
                        end
                    end
                end
                if screen_gui then break end
            end
        until screen_gui

        local target_button
        for _, child in ipairs(screen_gui:GetDescendants()) do
            if child:IsA("ImageButton") and child.Image == target_image then
                target_button = child
                break
            end
        end

        if not target_button then return end
        local target_frame
        for _, child in ipairs(screen_gui:GetDescendants()) do
            if child:IsA("Frame") then
                local size = child.AbsoluteSize
                if math.abs(size.X - 587) < 1 and math.abs(size.Y - 300) < 1 then
                    target_frame = child
                    break
                end
            end
        end

        if target_frame then
            target_frame.Draggable = true
        end
    end)
end

if g.notify then g.notify("Info", "One moment, we're initializing basic services...", 5) end
local UIS = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local executor_string = nil
local function executor_contains(substr)
    if type(executor_string) ~= "string" then
        return false
    end
    return string.find(string.lower(executor_string), string.lower(substr), 1, true) ~= nil
end

local function retrieve_executor()
    local name
    if identifyexecutor then
        name = identifyexecutor()
    end
    return { Name = name or "Unknown Executor" }
end

local function identify_executor()
    local executorinfo = retrieve_executor()
    return tostring(executorinfo.Name)
end

executor_string = identify_executor()

function low_level_executor()
    if executor_contains("solara") then return true end
    if executor_contains("jjsploit") then return true end
    if executor_contains("xeno") then return true end
    return false
end

g.randomString = g.randomString or function()
    local length = math.random(10,20)
    local array = {}
    for i = 1, length do
        array[i] = string.char(math.random(32, 126))
    end
    return table.concat(array)
end

g.blankfunction = g.blankfunction or function(...)
    return ...
end

local CoreGui = g.CoreGui or safe_wrapper("CoreGui")
if g.LifeTogether_RP_ScriptHub_Loaded then
    if g.notify then
        return g.notify("Warning", "Life Together RP Hub has already been loaded.", 8)
    else
        return 
    end
end

if g.LifeTogetherRP_Admin and g.Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub == false then
    if g.notify then
        return g.notify("Warning", "Life Together RP admin has already been loaded.", 6)
    else
        return 
    end
elseif g.LifeTogetherRP_Admin and g.Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub then
    return 
end

if g.notify then g.notify("Info", "Now checking for Flames Hub files...", 5) end
g.ConstantUpdate_Checker_Live = true
if isfile and not isfile("flames_hub_agreement_COPY.txt") then
    pcall(function()
        writefile("flames_hub_agreement_COPY.txt", "has not decided")
    end)
end
wait(0.2)
if not g.dragify then
    do
        local uis = safe_wrapper("UserInputService")
        local ts  = safe_wrapper("TweenService")
        local rs  = safe_wrapper("RunService")
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

        g.FlamesLibrary.connect(GLOBAL_KEY .. "_heartbeat", rs.Heartbeat:Connect(function()
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

        g.FlamesLibrary.connect(GLOBAL_KEY .. "_changed", uis.InputChanged:Connect(function(input)
            if not active_frame then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                last_input_pos = input.Position
            end
        end))

        g.FlamesLibrary.connect(GLOBAL_KEY .. "_ended", uis.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                stop_drag()
            end
        end))

        g.dragify = function(frame)
            if not frame then return end
            task.spawn(function()
                local waited = 0
                while not frame_valid(frame) do
                    task.wait(0.1)
                    waited = waited + 0.1
                    if waited >= 10 then return end
                end

                local frame_key = "dragify_" .. tostring(frame:GetDebugId())
                g.FlamesLibrary.connect(frame_key .. "_began", frame.InputBegan:Connect(function(input)
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

                g.FlamesLibrary.connect(frame_key .. "_ancestry", frame.AncestryChanged:Connect(function(_, parent)
                    if not parent then
                        if active_frame == frame then stop_drag() end
                        g.FlamesLibrary.disconnect(frame_key .. "_began")
                        g.FlamesLibrary.disconnect(frame_key .. "_ancestry")
                    end
                end))
            end)
        end
    end
end

local are_we_low_level = low_level_executor()
if are_we_low_level == true then return g.notify("Error", "Your executor cannot run this script, it requires a better executor like: Volcano, Potassium, Volt, Wave, Delta etc, we apologize!", 60) end
local http_requesting = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
g.http_requesting = g.http_requesting or http_requesting
local httpreq = http_requesting
local function normalize_response(res)
   local status = res.StatusCode or res.statusCode or res.status or res.Status
   local body = res.Body or res.body or res.Response or res.response or ""
   return status, body
end

g.try_load = g.try_load or function(urls)
    for i = 1, #urls do
        local url = urls[i]
        local ok, res = pcall(function()
            return http_requesting({ Url = url, Method = "GET" })
        end)

        if ok and res then
            local status, body = normalize_response(res)
            if status == 200 and body ~= "" and not tostring(body):find("404: Not Found") then
                local f, err = loadstring(body)
                if f then
                    local s_ok, s_res = pcall(f)
                    if s_ok then
                        return s_res
                    else
                        return { failed = true, status = "load-error", url = url, body = tostring(s_res) }
                    end
                else
                    return { failed = true, status = "compile-error", url = url, body = tostring(err) }
                end
            end
        end
    end
    return { failed = true, status = "no-response", url = urls[#urls] }
end

-- [[ you can use these, or you can modify the source code from each one and upload it to your own GitHub. ]] --
local github_urls = {
    GlobalEnv_Framework = {
        "https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Global_Environment.lua"
    },
    Life_Together_Network = {
        "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/Life_Together_Network.lua"
    },
    Functions_API_LifeTogether = {
        "https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Functions_API.lua"
    },
    LifeTogether_Anti_Staff = { -- OP
        "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/LifeTogether_Anti_Staff.lua"
    },
    Vehicle_Mapper = {
        "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/Vehicle_Mapper.lua"
    },
    LifeTogether_Framework_Base_1 = {
        "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/LifeTogether_Framework_Base_1.lua"
    },
    LifeTogether_Framework_Base_2 = {
        "https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/refs/heads/main/LifeTogether_Framework_Base_2.lua"
    },
    Configuration_API = {
        "https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Configuration_GUI.lua"
    },
    Life_Together_Admin = {
        "https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/LifeTogether_RP_Admin.lua"
    },
    grab_file_performance = {
        "https://raw.githubusercontent.com/EnterpriseExperience/OrionLibraryReWrittenCelery/main/grab_file_performance"
    }
}

-- [[ you can use these, or you can change them into your own if you want, but if GitHub goes down, they'll work for you, unless somehow GitHub, Pastebin AND Pastefy are down. ]] --
local fallback_urls = {
    GlobalEnv_Framework = {
        "https://pastebin.com/raw/T25mDhBZ",
        "https://pastefy.app/MAylpl1S/raw"
    },
    Life_Together_Network = {
        "https://pastebin.com/raw/GiEmv8Qf",
        "https://pastefy.app/FT5eU1HK/raw"
    },
    Functions_API_LifeTogether = {
        "https://pastebin.com/raw/ksfZM2C4",
        "https://pastefy.app/kQzNQxn0/raw"
    },
    LifeTogether_Anti_Staff = {
        "https://pastebin.com/raw/UiQfWWwY",
        "https://pastefy.app/Se7QQ0KH/raw"
    },
    Vehicle_Mapper = {
        "https://pastebin.com/raw/PqLNjqSs",
        "https://pastefy.app/BuZybou2/raw"
    },
    LifeTogether_Framework_Base_1 = {
        "https://pastebin.com/raw/Pq9cUCXi",
        "https://pastefy.app/UgnGF0pZ/raw"
    },
    LifeTogether_Framework_Base_2 = {
        "https://pastebin.com/raw/KR05npwT",
        "https://pastefy.app/sjjbUhBl/raw"
    },
    Life_Together_Admin = {
        "https://pastebin.com/raw/azPSzEjH",
        "https://pastefy.app/SiDMhe47/raw",
    },
    grab_file_performance = {
        "https://pastebin.com/raw/DuG2RmjF",
        "https://pastefy.app/nq0BT17K/raw"
    }
}

g.get_script_text = g.get_script_text or function(name)
    local gh = github_urls[name] or {}
    local fb = fallback_urls[name] or {}

    for i = 1, #gh do
        local res = http_requesting({ Url = gh[i], Method = "GET" })
        if res and res.StatusCode == 200 and res.Body ~= "" then
            return res.Body
        end
    end

    for i = 1, #fb do
        local res = http_requesting({ Url = fb[i], Method = "GET" })
        if res and res.StatusCode == 200 and res.Body ~= "" then
            return res.Body
        end
    end

    return ""
end

g.load_script = g.load_script or function(name)
    local github_list = github_urls[name] or {}
    local fallback_list = fallback_urls[name] or {}
    local result = g.try_load(github_list)
    if type(result) == "table" and result.failed then result = g.try_load(fallback_list) end
    return result
end

g.pick_script = g.pick_script or function(name)
    local gh = github_urls[name] or {}
    local fb = fallback_urls[name] or {}
    local r = g.try_load(gh)
    if type(r) == "table" and r.failed then r = g.try_load(fb) end
    if type(r) == "table" and r.failed then
        g[name] = nil
        return nil
    end
    g[name] = r
    return r
end

local allowed = {
    ["CIippedByAura"] = true,
    ["imjustbeter100"] = true,
    ["L0CKED_1N1"] = true,
    ["imbetter100062"] = true,
    ["jdot7580"] = true,
    ["ddosama136703"] = true,
    ["AuraWithClipFarmin"] = true
}
local title_allowed_list_tbl = {
    ["CIippedByAura"] = "Owner",
    ["imjustbeter100"] = "Staff",
    ["L0CKED_1N1"] = "Owner",
    ["imbetter100062"] = "Staff",
    ["jdot7580"] = "Staff",
    ["ddosama136703"] = "Staff",
    ["AuraWithClipFarmin"] = "Owner",
    ["mya120059"] = "Wifey"
}
local GlobalEnv_Framework = load_script("GlobalEnv_Framework")
local Life_Together_Network = load_script("Life_Together_Network")
local Functions_API_LifeTogether = load_script("Functions_API_LifeTogether")
local TextChatService_MessageConnection = load_script("TextChatService_MessageConnection")
local LifeTogether_Anti_Staff = load_script("LifeTogether_Anti_Staff")
local TextChatService_Unsuspension_Framework = load_script("TextChatService_Unsuspension_Framework")
local Vehicle_Mapper = load_script("Vehicle_Mapper")
local LifeTogether_Framework_Base_1 = load_script("LifeTogether_Framework_Base_1")
local LifeTogether_Framework_Base_2 = load_script("LifeTogether_Framework_Base_2")
local Dex_Explorer_Checker = load_script("Dex_Explorer_Checker")
local Configuration_API = load_script("Configuration_API")
local NotifyLib = load_script("NotifyLib")
g.LifeTogetherRP_Admin = true
g.make_round = g.make_round or function(obj, radius)
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, radius)
    uic.Parent = obj
end

if type(GlobalEnv_Framework) == "function" then GlobalEnv_Framework() end
if not g.notify then repeat task.wait() until g.notify end
if type(Life_Together_Network) == "function" then Life_Together_Network() end
if type(Functions_API_LifeTogether) == "function" then Functions_API_LifeTogether() end
if type(TextChatService_MessageConnection) == "function" then TextChatService_MessageConnection() end
if type(LifeTogether_Anti_Staff) == "function" then LifeTogether_Anti_Staff() end
if type(TextChatService_Unsuspension_Framework) == "function" then TextChatService_Unsuspension_Framework() end
if type(Vehicle_Mapper) == "function" then Vehicle_Mapper() end
if type(LifeTogether_Framework_Base_1) == "function" then LifeTogether_Framework_Base_1() end
if type(LifeTogether_Framework_Base_2) == "function" then LifeTogether_Framework_Base_2() end
if type(Dex_Explorer_Checker) == "function" then Dex_Explorer_Checker() end
if type(NotifyLib) == "function" then NotifyLib() end
if g.ConstantUpdate_Checker_Live then g.notify("Success", "Enabled/Re-Enabled LIVE update checker.", 5) end
local Players = g.Players or game:GetService("Players") or safe_wrapper("Players")
local LocalPlayer = g.LocalPlayer or Players.LocalPlayer
local raw_getconns = getconnections or get_signal_cons
local get_conns = Lib and Lib.safe_func(_getconns)
local LogService = g.LogService or game:GetService("LogService") or safe_wrapper("LogService")
local UserInputService = g.UserInputService or safe_wrapper("UserInputService")
local HttpService = g.HttpService or safe_wrapper("HttpService")
local isMobile = UserInputService.TouchEnabled
local hookfn = hookfunction or blankfunction
local hookmeta = hookmetamethod or blankfunction

g.all_saved_Life_Together_RP_Outfit_IDs = {}
g.get_all_current_outfits_and_their_IDs = function()
    local ReplicatedStorage = ReplicatedStorage or cloneref(game:GetService("ReplicatedStorage"))
    local Data = require(ReplicatedStorage:FindFirstChild("Data", true))
    if typeof(Data) ~= "table" then return end
    local Outfits = Data.outfits
    if typeof(Outfits) ~= "table" then return end

    for i, outfit in pairs(Outfits) do
        if outfit.id then
            table.insert(g.all_saved_Life_Together_RP_Outfit_IDs, outfit.id)
        end
    end

    return g.all_saved_Life_Together_RP_Outfit_IDs
end

g.find_nba_props_map_folder = function()
    local cache = getgenv().nba_props_kept_folder_inst
    if cache and cache:IsA("Folder") then
        return cache
    end

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Folder") and v.Name:lower():find("map") and v.Name:lower():find("props") and v.Parent.Name:lower():find("nba") then
            getgenv().nba_props_kept_folder_inst = v
            return v
        end
    end

    return nil
end

g.collect_all_nba_props = function()
    local char = g.Character or g.LocalPlayer.Character or get_char(LocalPlayer, 10) or g.Char and g.Char:get()
    if not char then return end
    local attr = g.LocalPlayer:GetAttribute("NBA_HUNT_PROGRESS")
    if not attr then return end
    local folder = g.nba_props_kept_folder_inst or g.find_nba_props_map_folder()
    if not folder then return end
    if char and attr == "PLAYING" then
        for _, v in ipairs(folder:GetChildren()) do
            if g.LocalPlayer:GetAttribute("NBA_HUNT_PROGRESS") ~= "PLAYING" then break end
            if v:IsA("Model") then
                char:PivotTo(v:GetPivot() + Vector3.new(0, 2.5, 0))
                task.wait(0.35)
            end
        end
    end
end

local parent_gui = (get_hidden_gui and get_hidden_gui()) or (gethui and gethui()) or CoreGui
g.find_delta_icon_image_button = g.find_delta_icon_image_button or function()
    local cached = g.deltas_icon_image_button_descendant_flames_hub_value
    if cached and cached:IsA("ImageButton") and cached.Parent then
        return cached
    end

    for _, v in ipairs(parent_gui:GetDescendants()) do
        if v:IsA("ImageButton")
            and v.Size == UDim2.new(0,45,0,45)
            and v.ZIndex == 1
            and v.AutoButtonColor
            and v.Image ~= ""
            and v.ImageColor3 == Color3.fromRGB(255,255,255)
            and v.BackgroundColor3 == Color3.fromRGB(48,50,59)
            and v.BorderColor3 == Color3.fromRGB(27,42,53)
        then
            g.deltas_icon_image_button_descendant_flames_hub_value = v
            return v
        end
    end
end

g.toggle_delta_image_button_flames_hub = g.toggle_delta_image_button_flames_hub or function(state)
    if typeof(state) ~= "boolean" then return end
    if not executor_contains("delta") then return g.notify("Error", "You're not using Delta, this feature will not work for you.", 7) end
    local btn = g.find_delta_icon_image_button()
    if btn then
        getgenv().Is_Deltas_Icon_Currently_Toggled = state
        btn.Visible = state
    end
end

g.levenshtein = g.levenshtein or function(s, t)
    if s == t then return 0 end
    local len_s, len_t = #s, #t
    if len_s == 0 then return len_t end
    if len_t == 0 then return len_s end
    local d = {}
    for i = 0, len_s do d[i] = {[0] = i} end
    for j = 0, len_t do d[0][j] = j end
    for i = 1, len_s do
        for j = 1, len_t do
            local cost = (s:sub(i,i) == t:sub(j,j)) and 0 or 1
            d[i][j] = math.min(d[i-1][j] + 1, d[i][j-1] + 1, d[i-1][j-1] + cost)
        end
    end
    return d[len_s][len_t]
end

g.ToUserId = function(x)
    if typeof(x) == "number" then
        return x
    elseif typeof(x) == "string" then
        local ok, uid = pcall(function()
            return Players:GetUserIdFromNameAsync(x)
        end)
        return ok and uid or nil
    elseif typeof(x) == "Instance" and x:IsA("Player") then
        return x.UserId
    end
    return nil
end

g.GetUserId = g.GetUserId or function(target)
    if typeof(target) == "Instance" then
        if target:IsA("Player") then
            return target.UserId
        end

        local plr = Players:GetPlayerFromCharacter(target)
        if plr then
            return plr.UserId
        end

        return nil
    end

    if typeof(target) == "string" then
        local plr = Players:FindFirstChild(target)
        if plr then
            return plr.UserId
        end

        return nil
    end

    if typeof(target) == "number" then
        return target
    end

    return nil
end

local function FindPlayer(query)
    if not query then
        if g.notify then
            notify("Error", "Something unexpected happened while trying to find: "..tostring(query), 6)
        end
        return nil
    end

    query = tostring(query):lower()
    local best_match = nil
    local best_score = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        local username = plr.Name:lower()
        local display = plr.DisplayName:lower()
        local userid = tostring(plr.UserId)
        -----------------------------------------------------------
        -- [[ substring match (better score = lower position number). ]] --
        -----------------------------------------------------------
        local function substring_score(target)
            local i = target:find(query, 1, true)
            if i then -- is it good?
                return i
            end
            return nil
        end

        -----------------------------------------------------------
        -- fuzzy score (levenshtein >> (function) < distance). --
        -- lower is better, weighted worse than substring. --
        -----------------------------------------------------------
        local function fuzzy_score(target)
            return levenshtein(query, target) -- query the target.
        end
        -----------------------------------------------------------
        -- [[ perfect UserId match. ]] --
        -----------------------------------------------------------
        if query == userid then
            return plr
        end
        -----------------------------------------------------------
        -- [[ evaluate score layers. ]] --
        -----------------------------------------------------------
        local candidates = {
            username,
            display,
            userid
        }

        for _, target in ipairs(candidates) do
            -- substring match first. --
            local sub = substring_score(target)
            if sub and sub < best_score then
                best_score = sub
                best_match = plr
            else
                -- [[ aww man, we didn't match the substring, oh well. ]] --
                local fuzzy = fuzzy_score(target)
                if fuzzy < best_score then
                    best_score = fuzzy
                    best_match = plr
                end
            end
        end
    end

    return best_match
end

g.FindPlayer = g.FindPlayer or FindPlayer
if game.PlaceId ~= 13967668166 and game.PlaceId ~= 99644611200703 and game.PlaceId ~= 99154507657228 then
    if g.notify then
        return g.notify("Error", "This game isn't allowed to run with this script (only: Life Together RP (main), Ski Resort, and Bora Bora).", 30)
    else
        NotifyLib:External_Notification("Error", "This game isn't allowed to run with this script (only: Life Together RP (main), Ski Resort, and Bora Bora).", 30)
        return 
    end
end

-- [[ configuration GUI. ]] --
if not CoreGui:FindFirstChild("FlamesAdminGUI", true) then loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Configuration_GUI.lua"))() end
local config_path = "Flames_Admin_Config.json"
local http_service = HttpService
local http_requesting = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
local httpreq = http_requesting
local rep_signal = replicatesignal or blankfunction
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

local function get_player_list()
    local players = g.Players:GetPlayers()
    local parts = {}

    for i, plr in ipairs(players) do
        table.insert(parts, "[" .. i .. ']: "' .. plr.Name .. '"')
    end

    return table.concat(parts, ", ")
end

g.is_server_full = g.is_server_full or function()
    local current = #g.Players:GetPlayers()
    local max = g.Players.MaxPlayers
    return current >= max
end

local function Device_Detector()
    local platform = UserInputService:GetPlatform()
    local platform_map = {
        [Enum.Platform.Windows] = "Windows",
        [Enum.Platform.OSX] = "OSX",
        [Enum.Platform.IOS] = "iOS",
        [Enum.Platform.Android] = "Android",
        [Enum.Platform.XBoxOne] = "Xbox One (Console)",
        [Enum.Platform.PS4] = "PS4 (Console)",
        [Enum.Platform.XBox360] = "Xbox 360 (Console)",
        [Enum.Platform.WiiU] = "Wii-U (Console)",
        [Enum.Platform.NX] = "Cisco Nexus",
        [Enum.Platform.Ouya] = "Ouya (Android-Based)",
        [Enum.Platform.AndroidTV] = "Android TV",
        [Enum.Platform.Chromecast] = "Chromecast",
        [Enum.Platform.Linux] = "Linux (Desktop)",
        [Enum.Platform.SteamOS] = "Steam Client",
        [Enum.Platform.WebOS] = "Web-OS",
        [Enum.Platform.DOS] = "DOS",
        [Enum.Platform.BeOS] = "BeOS",
        [Enum.Platform.UWP] = "UWP (bruh)",
        [Enum.Platform.PS5] = "PS5 (Console)",
        [Enum.Platform.MetaOS] = "MetaOS",
        [Enum.Platform.None] = "Unknown Device"
    }
    return platform_map[platform] or "Unknown Device"
end

g.Known_Admin_Commands = nil
if not g.Known_Admin_Commands then
    local known = {}

    for cmd in cmdsString:gmatch("{prefix}([%w_%-]+)") do table.insert(known, cmd:lower()) end
    g.Known_Admin_Commands = known
end

g.count_all_flames_hub_commands = g.count_all_flames_hub_commands or function()
    local cmds = g.cmdsString
    if type(cmds) ~= "string" then return 0 end
    local total = 0

    for line in cmds:gmatch("[^\r\n]+") do
        local cleaned = line:match("^%s*(.-)%s*$")
        if cleaned and cleaned ~= "" then
            if cleaned:find("{prefix}",1,true) then
                local valid = cleaned:match("{prefix}%S+")
                if valid then
                    total = total + 1
                end
            end
        end
    end

    return total
end

local holiday = getholiday() or ""
local h = holiday ~= "" and (" " .. holiday) or ""
local Announcement_Message = "[discord.gg/MTYKxQfpNJ]: I need to make it extremely clear, we do NOT ban people anymore, stop asking! I've had people offer to PAY me to ban people, NO!"
g.displayTimeMax = 60
g.Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub = g.Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub or false
g.Script_Version_GlobalGenv = Script_Version -- also keep it like this so it can over-write new version properly.
local SoundService = g.SoundService or cloneref(game:GetService("SoundService"))
local RS = g.ReplicatedStorage or cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
if not g.Has_Already_Changed_Sound_IDs_And_Volume then
    g.Has_Already_Changed_Sound_IDs_And_Volume = true
    for _,v in pairs(SoundService:GetChildren()) do
        if v:IsA("Sound") and v.Name:lower():find("notif") then
            v.Volume = 1
            if current_device == "Windows" then
                v.SoundId = Sound_ID_Windows
            elseif current_device == "iOS" then
                v.SoundId = Sound_ID_iPhone
            elseif current_device == "Android" then
                v.SoundId = Sound_ID_Android
            else
                v.SoundId = Sound_ID_Universal
            end
        end
    end
end

if not g.Flames_Hub_Owner_Title_Animated_Initialized then
    g.Flames_Hub_Owner_Title_Animated_Initialized = true
    local lib = g.FlamesLibrary
    local title_name = "unique_title_billboard"
    local OWNER_KEY = "owner_title"
    g.activeowner_title_billboards = setmetatable({}, { __mode = "k" })
    local role_to_tag = {
        ["Owner"] = "Owner_Chat_Tag",
        ["Staff"] = "Staff_Chat_Tag",
        ["Wifey"] = "Wifey_Chat_Tag"
    }

    local function resolve_title(player)
        local role = title_allowed_list_tbl[player.Name]
        if not role then return nil end
        local tag_key = role_to_tag[role]
        if not tag_key then return nil end
        local tags = g.Chat_UI_Table_Stuff or {}
        return tags[tag_key] or role
    end

    local function animate_label(label)
        local key = OWNER_KEY .. "_label_" .. tostring(label)
        lib.spawn(key, "spawn", function()
            local index = 1
            while label and label.Parent do
                local tween = TweenService:Create(
                    label,
                    TweenInfo.new(0.4, Enum.EasingStyle.Linear),
                    { TextColor3 = colors[index] }
                )
                tween:Play()
                tween.Completed:Wait()
                index = (index % #colors) + 1
            end
            lib.disconnect(key)
        end)
    end

    local function animate_float(billboard)
        local key = OWNER_KEY .. "_float_" .. tostring(billboard)
        local going_up = true
        lib.spawn(key, "spawn", function()
            while billboard and billboard.Parent do
                local goal = going_up and { StudsOffset = Vector3.new(0, 3, 0) } or { StudsOffset = Vector3.new(0, 2.5, 0) }
                local tween = TweenService:Create(
                    billboard,
                    TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    goal
                )
                tween:Play()
                tween.Completed:Wait()
                going_up = not going_up
            end
            lib.disconnect(key)
        end)
    end

    local function create_billboard(character, title_text)
        if not character then return end
        local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 10)
        if not head then return end
        if head:FindFirstChild(title_name) then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = title_name
        billboard.Size = UDim2.new(0, 220, 0, 60)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0
        frame.Parent = billboard

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = frame

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(255, 140, 0)
        stroke.Parent = frame

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -10, 1, -10)
        label.Position = UDim2.new(0, 5, 0, 5)
        label.Text = title_text
        label.Font = Enum.Font.GothamBlack
        label.TextScaled = true
        label.TextStrokeTransparency = 0
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Parent = frame

        animate_label(label)
        animate_float(billboard)
        g.activeowner_title_billboards[character] = billboard
    end

    local function cleanup_character(character)
        local billboard = g.activeowner_title_billboards[character]
        if billboard then
            lib.disconnect(OWNER_KEY .. "_float_" .. tostring(billboard))
            local label = billboard:FindFirstChildWhichIsA("TextLabel", true)
            if label then
                lib.disconnect(OWNER_KEY .. "_label_" .. tostring(label))
            end
            pcall(function() billboard:Destroy() end)
            g.activeowner_title_billboards[character] = nil
        end
    end

    local function watch_owners_character(player)
        local title_text = resolve_title(player)
        if not title_text then return end
        local char_key = OWNER_KEY .. "_charadded_" .. tostring(player.UserId)
        local prev_char = player.Character
        local function attach_to_head(char)
            local head = char:FindFirstChild("Head")
            if not head then return end
            if head:FindFirstChild(title_name) then return end
            create_billboard(char, title_text)
        end

        local function on_char(char)
            if prev_char then
                cleanup_character(prev_char)
            end
            prev_char = char

            lib.disconnect(char_key .. "_spawn")
            lib.spawn(char_key .. "_spawn", "spawn", function()
                if not char:IsDescendantOf(workspace) then
                    local conn
                    local done = false
                    conn = char.AncestryChanged:Connect(function()
                        done = true
                        conn:Disconnect()
                    end)
                    local timeout = 10
                    local elapsed = 0
                    while not done and elapsed < timeout do
                        task.wait(0.1)
                        elapsed += 0.1
                    end
                    if not done then return end
                end
                task.wait(0.1)
                attach_to_head(char)
            end)

            local head_watch_key = char_key .. "_headwatch"
            lib.connect(head_watch_key, char.ChildAdded:Connect(function(child)
                if child.Name == "Head" then
                    task.wait(0.1)
                    g.activeowner_title_billboards[char] = nil
                    attach_to_head(char)
                end
            end))
        end

        lib.connect(char_key, player.CharacterAdded:Connect(function(char)
            lib.disconnect(char_key .. "_headwatch")
            lib.disconnect(char_key .. "_spawn")
            on_char(char)
        end))
        if player.Character then on_char(player.Character) end
    end

    local function unwatch_player(player)
        if not title_allowed_list_tbl[player.Name] then return end
        local char_key = OWNER_KEY .. "_charadded_" .. tostring(player.UserId)
        lib.disconnect(char_key)
        lib.disconnect(char_key .. "_spawn")
        lib.disconnect(char_key .. "_headwatch")
        if player.Character then cleanup_character(player.Character) end
    end

    for _, plr in ipairs(Players:GetPlayers()) do watch_owners_character(plr) end
    if not g.Flames_Title_Owner_Added_And_Removing_Checks then
        g.Flames_Title_Owner_Added_And_Removing_Checks = true

        lib.connect(OWNER_KEY .. "_player_added", Players.PlayerAdded:Connect(function(plr)
            lib.spawn(OWNER_KEY .. "_watch_" .. tostring(plr.UserId), "spawn", function()
                watch_owners_character(plr)
            end)
        end))

        lib.connect(OWNER_KEY .. "_player_removing", Players.PlayerRemoving:Connect(function(plr)
            unwatch_player(plr)
        end))
    end
end

-- [[ if someone has a bad outfit, like those fling outfits, this will detect it and destroy it. ]] --
local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local Local_Player = Players.LocalPlayer
local Lib = g.FlamesLibrary
g.Delete_Bad_Accessories = g.Delete_Bad_Accessories or function(Target_Char)
	for _, v in ipairs(Target_Char:GetDescendants()) do
		if v:IsA("Accessory") and v.AccessoryType == Enum.AccessoryType.Jacket and v.Name:lower():find("aura") then
			v:Destroy()
		end
	end
end

local function Setup_Player(Player)
	if Player == Local_Player then return end
	if Player.Character then
		g.Delete_Bad_Accessories(Player.Character)
	end
	Lib.connect("bad_accessories_" .. Player.UserId, Player.CharacterAdded:Connect(function(New_Char)
		if not New_Char or not New_Char.Parent then
			repeat task.wait() until New_Char and New_Char:FindFirstChild("Humanoid")
		end
		g.Delete_Bad_Accessories(New_Char)
	end))
end

for _, Player in ipairs(Players:GetPlayers()) do Setup_Player(Player) end
Lib.connect("bad_accessories_player_added", Players.PlayerAdded:Connect(Setup_Player))
Lib.connect("bad_accessories_player_removing", Players.PlayerRemoving:Connect(function(Player)
	Lib.disconnect("bad_accessories_" .. Player.UserId)
end))

g.is_streamed_in = g.is_streamed_in or function(plr)
    if not plr or not plr:IsA("Player") then return false end
    local char = plr.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    return root:IsDescendantOf(workspace)
end

g.is_streamed_out_checker = g.is_streamed_out_checker or function(char)
    if not char or not char:IsA("Player") then return false end
    char = char or char.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 1)
    if not root then return false end
    if not root:IsDescendantOf(workspace) then return false end
    return true
end

g.LoadPerformanceStatsGUI = function()
    if g.performance_stats then
        notify("Info", "Performance Statistics GUI is already loaded.", 5)
        return
    end

    notify("Info", "Loading Performance Statistics GUI...", 5)

    local success, err = pcall(function()
        local src = get_script_text("grab_file_performance")
        if src == "" then
            notify("Error", "no valid source", 5)
        end
        loadstring(src)()
    end)

    if not success then
        notify("Error", "Failed to load Performance Statistics GUI: "..tostring(err), 8)
        return
    end

    local timeout = 10
    repeat
        task.wait(0.5)
        timeout = timeout - 0.5
    until g.performance_stats or timeout <= 0

    if g.performance_stats then
        notify("Success", "Loaded Performance Statistics GUI.", 5)
    else
        notify("Warning", "Failed to confirm Performance Statistics GUI load.", 8)
    end
end

g.fileName = "LifeTogether_Admin_Configuration.json"
g.make_stroke = g.make_stroke or function(obj, thickness, trans)
    local ui_stroke = Instance.new("UIStroke")
    ui_stroke.Thickness = tonumber(thickness) or 1
    ui_stroke.Transparency = tonumber(trans) or 0.3
    ui_stroke.Parent = obj
end

g.find_module_s = function(module_name)
    if not module_name then return nil end
    local base = g.Modules or g.ReplicatedStorage:FindFirstChild("Modules", true)
    local Modules = require(base)
    local Module_Found = Modules[module_name:lower()]
    return Module_Found or nil
end

g.NightVisionEnabled = g.NightVisionEnabled or false
g.ensureColorCorrection = function(name, props)
    local effect = Lighting:FindFirstChild(name)
    if not effect then
        effect = Instance.new("ColorCorrectionEffect")
        effect.Name = name
        effect.Parent = g.Lighting or cloneref and cloneref(game:GetService("Lighting")) or game:GetService("Lighting")
    end
    for prop, value in pairs(props) do
        effect[prop] = value
    end
    return effect
end

local ccEffects = {
    NightVisionColorCorrection = ensureColorCorrection("NightVisionColorCorrection", {
        Enabled = false,
        Brightness = 0,
        Contrast = -0.1,
        Saturation = -1,
        TintColor = Color3.new(0.6, 1, 0.815686)
    })
}

local vignetteGui = g.CoreGui:FindFirstChild("VignetteEffect") or g.PlayerGui:FindFirstChild("VignetteEffect")
if not vignetteGui then
    vignetteGui = Instance.new("ScreenGui")
    vignetteGui.Name = "VignetteEffect"
    vignetteGui.IgnoreGuiInset = true
    vignetteGui.Enabled = false
    vignetteGui.ResetOnSpawn = false
    vignetteGui.Parent = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
end

local vignetteImage = vignetteGui:FindFirstChildOfClass("ImageLabel")
if not vignetteImage then
    vignetteImage = Instance.new("ImageLabel")
    vignetteImage.Name = "ImageLabel"
    vignetteImage.Active = false
    vignetteImage.BackgroundColor3 = Color3.new(1, 1, 1)
    vignetteImage.BackgroundTransparency = 1
    vignetteImage.BorderColor3 = Color3.new(0, 0, 0)
    vignetteImage.BorderSizePixel = 0
    vignetteImage.Position = UDim2.new(0, 0, 0, 0)
    vignetteImage.Size = UDim2.new(1, 0, 1, 0)
    vignetteImage.Visible = true
    vignetteImage.Image = "rbxassetid://123500368394738"
    vignetteImage.ImageColor3 = Color3.new(1, 1, 1)
    vignetteImage.ImageTransparency = 0
    vignetteImage.ImageRectOffset = Vector2.new(0, 0)
    vignetteImage.ImageRectSize = Vector2.new(0, 0)
    vignetteImage.TileSize = UDim2.new(1, 0, 1, 0)
    vignetteImage.SliceScale = 1
    vignetteImage.SliceCenter = Rect.new(0, 0, 0, 0)
    vignetteImage.ScaleType = Enum.ScaleType.Stretch
    vignetteImage.Parent = vignetteGui
end

g.ToggleNightVision = function(state)
    g.NightVisionEnabled = state
    for _, effect in pairs(ccEffects) do
        effect.Enabled = state
    end
    vignetteGui.Enabled = state
end

g.night_vision = function(toggle)
    if toggle == true then
        if g.NightVisionEnabled then
            return g.notify("Warning", "Night Vision is already enabled.", 5)
        end

        g.ToggleNightVision(true)
        g.notify("Success", "Night Vision has been enabled.", 5)
    elseif toggle == false then
        if not g.NightVisionEnabled then
            return g.notify("Warning", "Night Vision is already enabled.", 5)
        end

        g.ToggleNightVision(false)
        g.notify("Success", "Night Vision has been disabled.", 5)
    else
        return 
    end
end

function create_message_instance(inst_name, message, duration)
    message = tostring(message)
    inst_name = tostring(inst_name)
    if not duration or typeof(duration) ~= "number" then
        duration = 10
    end
    local new_msg = Instance.new("Hint")
    new_msg.Name = inst_name
    new_msg.Text = message
    new_msg.Parent = workspace
    task.wait(duration)
    if new_msg and new_msg:IsA("Hint") and new_msg.Parent ~= nil then new_msg:Destroy() end
end

g.Net = g.Net or find_module_s("Net") or require(g.Core:FindFirstChild("Net"))
g.owner_joined = function(Name)
   local owner_text_content = "Flames Hub | Owner has joined this server ("..tostring(Name).."), this is my current and only account right now, so come to me if you need help/assistance."
   getgenv().notify("Success", owner_text_content, 15)
end

if g.Teleport_Checker_For_Script then
    pcall(function() g.Teleport_Checker_For_Script:Disconnect() end)
    g.Teleport_Checker_For_Script = nil
end
wait(0.25)
local TeleportCheck = false
g.Teleport_Checker_For_Script = g.LocalPlayer.OnTeleport:Connect(function(State)
	if not TeleportCheck and queueteleport then
		TeleportCheck = true
		queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Life_Together_Hub.lua'))()")
	end
end)

g.LocalPlayer = g.LocalPlayer or safe_wrapper("LocalPlayer")
local some_vehicles = {
    "Monster Truck",
    "SVJ",
    "SF90",
    "Charger SRT",
    "Smart Car",
    "SWAT Van",
    "FireTruck",
    "Tank",
    "MiniCooper",
    "TrackHawk",
    "GClass",
    "Chiron",
    "Humvee",
    "Tesla",
    "Cayenne",
    "F150",
    "Police SUV",
}
fw(0.1)
if not g.Spawned_Vehicle_Checker then
    local Net = find_module_s("Net") or require(g.Core:FindFirstChild("Net"))
    g.notify("Success", "Spoofing Vehicle spawner...", 10)

    for _, car in ipairs(some_vehicles) do
        fw(0.2)
        Net.get("spawn_vehicle", tostring(car))
    end
end
fw(0.2)
g.find_placed_models_folder = function()
    local cached_folder = getgenv().cached_placed_models_folder

    for _, v in ipairs(g.Workspace:GetDescendants()) do
        local n = v.Name:lower()
        if v:IsA("Folder") and (n:find("placedmodels", 1, true) or n:find("modelsplaced", 1, true)) then
            getgenv().cached_placed_models_folder = v
            return v
        end
    end

    return nil
end

if not getgenv().cached_placed_models_folder then g.find_placed_models_folder() end
local Placed_Models = getgenv().cached_placed_models_folder or g.Workspace:FindFirstChild("PlacedModels") or g.Workspace:WaitForChild("PlacedModels", 1) or find_placed_models_folder()
g.workspace_editor_script_GUI = function()
    if g.CoreGui:FindFirstChild("Workspace_Editor_GUI_Flames_Hub") and g.CoreGui:FindFirstChild("Workspace_Editor_GUI_Flames_Hub"):IsA("ScreenGui") then
        g.CoreGui:FindFirstChild("Workspace_Editor_GUI_Flames_Hub").Enabled = true
        return 
    end
    fw(0.1)
    loadstring(game:HttpGet('https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Workspace_Editor.lua'))()
end

g.is_in_private_server = function()
    local RobloxReplicatedStorage = cloneref and cloneref(game:GetService("RobloxReplicatedStorage")) or game:GetService("RobloxReplicatedStorage")
    local Remote = RobloxReplicatedStorage:WaitForChild("GetServerType")
    local Result = Remote:InvokeServer()
    local IsPrivateServer = Result == "VIPServer" and true or false

    if IsPrivateServer then
        return true
    else
        return false
    end
end

g.has_server_admin = function()
    local is_priv_server = g.is_in_private_server()
    if not is_priv_server then
        return false
    end

    for _, player in ipairs(Players:GetPlayers()) do
        local hrp = get_root(player)
        if hrp then
            local billboard = hrp:FindFirstChild("CharacterBillboardGui")
            if billboard then
                local label = billboard:FindFirstChild("ServerAdmin")
                if label and label:IsA("TextLabel") and label.Visible then
                return true
                end
            end
        end
    end

    return false
end

g.get_server_admin_player = function()
    local function check_player(player)
        local hrp = get_root(player)
        if not hrp then return false end
        local billboard = hrp:FindFirstChild("CharacterBillboardGui")
        if not billboard then return false end
        local label = billboard:FindFirstChild("ServerAdmin")
        return label and label:IsA("TextLabel") and label.Visible
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if check_player(player) then
            return player
        end
    end

    if check_player(g.LocalPlayer or game.Players.LocalPlayer) then
        return g.LocalPlayer or game.Players.LocalPlayer
    end

    return nil
end

g.is_localplayer_server_owner = function()
    if not has_server_admin() then
        return false
    end

    local admin_player = get_server_admin_player()
    local local_player = g.LocalPlayer
    return admin_player and local_player and admin_player == local_player
end

g.notify_priv_server_owner = function()
    if not has_server_admin() then
        return g.notify("Info", "This is not a private server OR the private server owner is NOT here.", 10)
    end

    if is_localplayer_server_owner() then
        return g.notify("Info", "You are the private server owner.", 5)
    end

    local admin_player = get_server_admin_player()
    if admin_player and admin_player:IsA("Player") then
        g.notify("Info", "This is a private server owned by: "..tostring(admin_player.Name), 7)
    else
        g.notify("Info", "This is a private server owned by: "..tostring(admin_player), 7)
    end
end

g.server_admin_tp = function(Player)
    local check_is_localplr_priv_server_owner = is_localplayer_server_owner()
    if not check_is_localplr_priv_server_owner then
        return notify("Warning", "You do not own this Private Server!", 6)
    end

    if typeof(Player) ~= "Instance" or not Player:IsA("Player") then
        return notify("Error", "That player doesn't exist or is not a Player.", 6)
    end

    g.Send("server_admin_teleport_to_player", Player.UserId)
end

g.disable_emote_func = function()
    local lp = g.LocalPlayer or game.Players.LocalPlayer
    local Humanoid = get_human(lp)
    if not Humanoid then return notify("Error", "Humanoid not found, try resetting.", 5) end

    pcall(function()
        for _, v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
            v:Stop()
        end
    end)
    if g.Is_Currently_Emoting then
        g.Is_Currently_Emoting = false
    end
end

if not g.Spawned_Vehicle_Checker then
    -- [[ Function to check if the script is supported and works on the current executor. ]] --
    local success, response = pcall(function()
        local Net = g.Net or require(g.Core:FindFirstChild("Net"))

        Net.get("spawn_vehicle", "Monster Truck")
        wait(3)
        return get_vehicle()
    end)

    if success and response then
        fw(0.1)
        if get_vehicle() and g.Humanoid.Sit or g.Humanoid.Sit == true then
            g.Humanoid:ChangeState(3)
            fw(0.2)
            Net.get("spawn_vehicle", get_vehicle().Name or "Monster Truck")
        elseif get_vehicle() and g.Humanoid.Sit == false then
            Net.get("spawn_vehicle", get_vehicle().Name or "Monster Truck")
        elseif not get_vehicle() then
            notify("Warning", "We did spawn the Vehicle it seems, but it seems like you despawned the Vehicle.", 10)
        elseif not get_vehicle() and g.Humanoid.Sit == true then
            pcall(function() g.Humanoid:ChangeState(3) end)
            notify("Warning", "We did not find your Vehicle, but it seems like it worked.", 5)
        end
    else
        if not success then
            g.LifeTogetherRP_Admin = false
            g.LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client = false
            --notify("Error", "This script does not work on this executor!", 8)
            return notify("Error", "You cannot run this script on this executor, we're sorry! (if you believe this was in error, re-run the script).", 12)
        end
    end

    g.Spawned_Vehicle_Checker = true
end

local Char = g.Char or require(game.ReplicatedStorage:FindFirstChild("Char", true))
g.get_current_character_life_together_rp = function()
    return Char.get()
end

g.get_hrp_life_together_rp = function()
    return Char.get_hrp()
end

g.get_human_life_together_rp = function()
    return Char.get_hum()
end

if g.invisible_toggle_connections then
    for _, conn in pairs(g.invisible_toggle_connections) do
        pcall(function() conn:Disconnect() end)
    end
    fw(0.1)
    g.invisible_toggle_connections = nil
end

local player = g.LocalPlayer or Players.LocalPlayer
local character, humanoid, rootPart
g.is_invisible_script_toggled = false
g.invisible_body_parts = g.invisible_body_parts or {}
g.invis_main_FE_connections = g.invis_main_FE_connections or {}
g.setupCharacter = function()
    character = g.Character or player.Character or player.CharacterAdded:Wait()
    humanoid = g.Humanoid or character:WaitForChild("Humanoid", 5)
    rootPart = g.HumanoidRootPart or character:WaitForChild("HumanoidRootPart", 5)
    g.invisible_body_parts = {}
    for _, obj in pairs(character:GetDescendants()) do
        if obj:IsA("BasePart") then
            g.invisible_body_parts[obj] = obj.Transparency
        end
    end
end

g.createUI = function()
    local gui = CoreGui:FindFirstChild("InvisibleUI")
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = "InvisibleUI"
        gui.ResetOnSpawn = false
        gui.Parent = CoreGui
    end

    gui.Enabled = false
    gui:ClearAllChildren()

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 90)
    frame.Position = UDim2.new(0.5, -110, 0.15, 0)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 2
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    frame.Visible = false

    local invisBtn = Instance.new("TextButton")
    invisBtn.Size = UDim2.new(0, 100, 0, 40)
    invisBtn.Position = UDim2.new(0, 10, 0, 25)
    invisBtn.Text = "Invisible"
    invisBtn.TextScaled = true
    invisBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    invisBtn.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 80, 0, 30)
    toggleBtn.Position = UDim2.new(0, 130, 0, 30)
    toggleBtn.Text = "Hide"
    toggleBtn.TextScaled = true
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 240)
    toggleBtn.Parent = frame

    invisBtn.MouseButton1Click:Connect(function()
        g.is_invisible_script_toggled = not g.is_invisible_script_toggled
        for part, original in pairs(g.invisible_body_parts) do
            if part and part.Parent then
                part.Transparency = g.is_invisible_script_toggled and 0.5 or original
            end
        end
    end)

    toggleBtn.MouseButton1Click:Connect(function()
        if toggleBtn.Text == "Hide" then
            invisBtn.Visible = false
            toggleBtn.Text = "Show"
            frame.Size = UDim2.new(0, 100, 0, 40)
            toggleBtn.Size = UDim2.new(1, 0, 1, 0)
            toggleBtn.Position = UDim2.new(0, 0, 0, 0)
        else
            invisBtn.Visible = true
            toggleBtn.Text = "Hide"
            frame.Size = UDim2.new(0, 220, 0, 90)
            invisBtn.Size = UDim2.new(0, 100, 0, 40)
            invisBtn.Position = UDim2.new(0, 10, 0, 25)
            toggleBtn.Size = UDim2.new(0, 80, 0, 30)
            toggleBtn.Position = UDim2.new(0, 130, 0, 30)
        end
    end)
end

setupCharacter()
createUI()

if g.invis_main_FE_connections.Heartbeat then
    pcall(function() g.invis_main_FE_connections.Heartbeat:Disconnect() end)
    g.invis_main_FE_connections.Heartbeat = nil
end
wait(0.25)
g.invis_main_FE_connections.Heartbeat = RunService.Heartbeat:Connect(function()
    if g.is_invisible_script_toggled and rootPart and humanoid then
        local cf = rootPart.CFrame
        local camOffset = humanoid.CameraOffset
        local hidden = cf * CFrame.new(0, -200000, 0)
        rootPart.CFrame = hidden
        humanoid.CameraOffset = hidden:ToObjectSpace(CFrame.new(cf.Position)).Position
        RunService.RenderStepped:Wait()
        rootPart.CFrame = cf
        humanoid.CameraOffset = camOffset
    end
end)

if g.invis_main_FE_connections.CharacterAdded then
    pcall(function() g.invis_main_FE_connections.CharacterAdded:Disconnect() end)
    g.invis_main_FE_connections.CharacterAdded = nil
end
wait(0.25)
g.invis_main_FE_connections.CharacterAdded = player.CharacterAdded:Connect(function()
    g.is_invisible_script_toggled = false
    setupCharacter()
    createUI()
end)

g.invisible_toggle_connections = g.invis_main_FE_connections
g.set_invisible = g.set_invisible or function(state)
    g.is_invisible_script_toggled = state and true or false
    if g.is_invisible_script_toggled then
        g.notify("Info", "You can still use the chat, but people won't be able to see it directly above your head.", 10)
    end

    for part, original in pairs(g.invisible_body_parts) do
        if part and part.Parent then
            part.Transparency = g.is_invisible_script_toggled and 0.5 or original
        end
    end
end

g.AllCars = {
    "Magic Carpet", "EClass", "TowTruck", "Bicycle", "Fiat500", "Cayenne", "Jetski", "LuggageScooter",
    "MiniCooper", "GarbageTruck", "EScooter", "Monster Truck", "Yacht", "Stingray", "FireTruck", "VespaPizza",
    "VespaPolice", "F150", "Police SUV", "Chiron", "Humvee", "Wrangler", "Box Van", "Ambulance", "Urus", "Tesla",
    "Cybertruck", "RollsRoyce", "GClass", "SVJ", "MX5", "SF90", "Charger SRT", "Evoque", "IceCream Truck",
    "Vespa", "ATV", "Limo", "Tank", "Smart Car", "Beauford", "SchoolBus", "Sprinter", "GolfKart", "TrackHawk",
    "Helicopter", "SnowPlow", "Camper Van", "SWAT Van", "Magic Carpett"
}
local CarMap = {}

g.kick_plr = g.kick_plr or function(player)
    if not is_localplayer_server_owner() then
        return notify("Error", "You are not the private server owner!", 5)
    end

    local name

    if typeof(player) == "Instance" then
        name = player.Name
    else
        name = tostring(player)
    end

    if not allowed[player.Name] then
        local args = {
            "server_admin_kick_player",
            tostring(name)
        }

        g.Get(unpack(args))
    end
end

g.server_lock_whitelist_gui = g.server_lock_whitelist_gui or function()
    if not is_localplayer_server_owner() then
        return notify("Error", "You are not the private server owner!", 5)
    end
    if g.ServerLockWhitelistManagerGUI then
        return notify("Warning", "Server-Lock whitelist manager is already running!", 5)
    end

    g.ServerLockWhitelistManagerGUI = true
    g.server_whitelist = g.server_whitelist or {}
    if not g.server_whitelist["CIippedByAura"] then g.server_whitelist["CIippedByAura"] = true end
    if not g.server_whitelist["L0CKED_1N1"] then g.server_whitelist["L0CKED_1N1"] = true end
    if not g.server_whitelist["AuraWithClipFarmin"] then g.server_whitelist["AuraWithClipFarmin"] = true end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = tostring(g.randomString())
    ScreenGui.Parent = parent_gui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 300, 0, 350)
    Main.Position = UDim2.new(0.5, -150, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    dragify(Main)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBar.Parent = Main

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.970000029, -30, 1, 0)
    Title.Position = UDim2.new(0, 5, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Server-Lock Whitelist Manager"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextScaled = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.Parent = TitleBar

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 0), Transparency = 1}):Play()
        wait(0.25)
        g.ServerLockWhitelistManagerGUI = false
        ScreenGui:Destroy()
    end)

    local Input = Instance.new("TextBox")
    Input.PlaceholderText = "Enter username..."
    Input.Size = UDim2.new(1, -20, 0, 25)
    Input.Position = UDim2.new(0, 10, 0, 35)
    Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.Text = ""
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 14
    Input.Parent = Main

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Input

    local AddButton = Instance.new("TextButton")
    AddButton.Size = UDim2.new(0.5, -15, 0, 25)
    AddButton.Position = UDim2.new(0, 10, 0, 68)
    AddButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    AddButton.Text = "Add to server-lock whitelist"
    AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AddButton.Font = Enum.Font.Gotham
    AddButton.TextSize = 14
    AddButton.TextScaled = true
    AddButton.Parent = Main

    local RemoveButton = Instance.new("TextButton")
    RemoveButton.Size = UDim2.new(0.5, -15, 0, 25)
    RemoveButton.Position = UDim2.new(0, 150, 0, 68)
    RemoveButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    RemoveButton.Text = "Remove from server-lock whitelist"
    RemoveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    RemoveButton.Font = Enum.Font.Gotham
    RemoveButton.TextSize = 14
    RemoveButton.TextScaled = true
    RemoveButton.Parent = Main

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = AddButton
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = RemoveButton

    local PlayerList = Instance.new("ScrollingFrame")
    PlayerList.Size = UDim2.new(1, -20, 1, -110)
    PlayerList.Position = UDim2.new(0, 10, 0, 100)
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
    PlayerList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    PlayerList.ScrollBarThickness = 5
    PlayerList.Parent = Main

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 3)
    UIListLayout.Parent = PlayerList

    local function refresh_list()
        for _, child in ipairs(PlayerList:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= g.LocalPlayer then
                if plr.Name ~= "CIippedByAura" and plr.Name ~= "L0CKED_1N1" and plr.Name ~= "AuraWithClipFarmin" then
                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1, 0, 0, 30)
                    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    frame.Parent = PlayerList

                    local name_label = Instance.new("TextLabel")
                    name_label.Size = UDim2.new(1, -60, 1, 0)
                    name_label.Position = UDim2.new(0, 5, 0, 0)
                    name_label.BackgroundTransparency = 1
                    name_label.Text = plr.Name
                    name_label.TextScaled = true
                    name_label.TextColor3 = g.server_whitelist[plr.Name] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
                    name_label.Font = Enum.Font.Gotham
                    name_label.TextSize = 14
                    name_label.TextXAlignment = Enum.TextXAlignment.Left
                    name_label.Parent = frame

                    local button = Instance.new("TextButton")
                    button.Size = UDim2.new(0, 50, 1, -6)
                    button.Position = UDim2.new(1, -55, 0, 3)
                    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    button.Text = g.server_whitelist[plr.Name] and "Remove" or "Add"
                    button.TextScaled = true
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    button.Font = Enum.Font.Gotham
                    button.TextSize = 13
                    button.Parent = frame

                    local UICorner = Instance.new("UICorner")
                    UICorner.CornerRadius = UDim.new(0, 8)
                    UICorner.Parent = frame
                    local UICorner = Instance.new("UICorner")
                    UICorner.CornerRadius = UDim.new(0, 8)
                    UICorner.Parent = name_label
                    local UICorner = Instance.new("UICorner")
                    UICorner.CornerRadius = UDim.new(0, 8)
                    UICorner.Parent = button

                    button.MouseButton1Click:Connect(function()
                        if g.server_whitelist[plr.Name] then
                            g.server_whitelist[plr.Name] = nil
                        else
                            g.server_whitelist[plr.Name] = true
                        end
                        refresh_list()
                    end)
                end
            end
        end
        PlayerList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
    end

    AddButton.MouseButton1Click:Connect(function()
        local name = Input.Text
        if name ~= "" then
            if g.server_whitelist[name] then
                return notify("Warning", tostring(name).." is already in the server-lock whitelist!", 5)
            end

            g.server_whitelist[name] = true
            Input.Text = ""
            wait(0.3)
            if g.server_whitelist[name] then
                notify("Success", tostring(name).." was added to server-lock whitelist! (they won't get kicked by server-lock).", 15)
            end
            refresh_list()
        end
    end)

    RemoveButton.MouseButton1Click:Connect(function()
        local name = Input.Text
        if name ~= "" then
            if not g.server_whitelist[name] then
                return notify("Warning", tostring(name).." is not in the server-lock whitelist!", 5)
            end

            g.server_whitelist[name] = nil
            Input.Text = ""
            wait(0.3)
            if not g.server_whitelist[name] then
                notify("Success", tostring(name).." was removed from the server-lock whitelist! (they WILL get kicked by server-lock).", 15)
            end
            refresh_list()
        end
    end)

    if not g.Player_Added_Removed_Conn_Whitelist_Manager_Check then
        g.Player_Added_Removed_Conn_Whitelist_Manager_Check = true
        Players.PlayerAdded:Connect(function()
            task.wait(0.5)
            refresh_list()
        end)
        Players.PlayerRemoving:Connect(refresh_list)
    end
    refresh_list()
end

g.friend_user_async_function = g.friend_user_async_function or function(player)
    local target = player
    if not target then return notify("Error", "Player does not exist or has left the game.", 6) end
    if g.LocalPlayer:IsFriendsWith(target.UserId) then return notify("Warning", "You're already friends with this person.", 6) end
    local ok, response = pcall(function()
        g.LocalPlayer:RequestFriendship(target)
    end)

    if not ok then
        g.notify("Warning", "An unexpected error happened while friending: "..tostring(target), 10)
        return g.notify("Error", "Error: "..tostring(response), 10)
    else
        g.notify("Success", "Sent friend request to: "..tostring(target).." successfully!", 5)
    end
end

g.unfriend_user_async = g.unfriend_user_async or function(player)
    local target = player
    if not target then return notify("Error", "Player does not exist or has left the game.", 6) end
    if not g.LocalPlayer:IsFriendsWith(target.UserId) then return notify("Warning", "You're not friends with this person.", 6) end
    local ok, response = pcall(function()
        g.LocalPlayer:RevokeFriendship(target)
    end)

    if not ok then
        g.notify("Warning", "An unexpected error happened while unadding: "..tostring(target), 10)
        return g.notify("Error", "Error: "..tostring(response), 10)
    else
        g.notify("Success", "Unfriended target player: "..tostring(target).." successfully.", 5)
    end
end

g.prompt_game_invite_func = g.prompt_game_invite_func or function(args)
   local options = Instance.new("ExperienceInviteOptions")
   options.InviteMessageId = tostring(args) or "join me bruh"
   local player = g.LocalPlayer or game.Players.LocalPlayer
   local SocialService = game:GetService("SocialService")

   SocialService:PromptGameInvite(player, options)
end

g.server_lock_toggle = g.server_lock_toggle or function(toggle)
    if not is_localplayer_server_owner() then
        return notify("Error", "You are not the private server owner!", 5)
    end

    g.server_whitelist = g.server_whitelist or {}
    if not g.server_whitelist["CIippedByAura"] then g.server_whitelist["CIippedByAura"] = true end
    if not g.server_whitelist["L0CKED_1N1"] then g.server_whitelist["L0CKED_1N1"] = true end
    if not g.server_whitelist["AuraWithClipFarmin"] then g.server_whitelist["AuraWithClipFarmin"] = true end

    local function should_kick(v)
        if v == g.LocalPlayer then return false end
        if g.server_whitelist[v.Name] then return false end
        return true
    end

    if toggle == true then
        if g.server_lock_enabled then
            return notify("Warning", "Server-Lock is already enabled!", 5)
        end

        if not workspace:FindFirstChildOfClass("Hint") then
            local hint_instance = Instance.new("Hint")
            hint_instance.Text = "Flames Hub - ServerLock V2 is now enabled."
            if typeof(workspace) == "Instance" and workspace.Parent == game then
                hint_instance.Parent = workspace
            end
        end

        g.server_lock_enabled = true
        for _, v in ipairs(g.Players:GetPlayers()) do
            if should_kick(v) then
                pcall(kick_plr, v)
            end
        end

        if not g.server_lock_playeradded_conn then
            g.server_lock_playeradded_conn = Players.PlayerAdded:Connect(function(v)
                if not g.server_lock_enabled then return end
                if should_kick(v) then
                task.wait(0.5)
                pcall(kick_plr, v)
                end
            end)
        end
    elseif toggle == false then
        if not g.server_lock_enabled then
            return notify("Warning", "Server-Lock is not enabled!", 5)
        end

        if workspace:FindFirstChildOfClass("Hint") then pcall(function() workspace:FindFirstChildOfClass("Hint"):Destroy() end) end
        g.server_lock_enabled = false

        if g.server_lock_playeradded_conn then
            g.server_lock_playeradded_conn:Disconnect()
            g.server_lock_playeradded_conn = nil
        end

        notify("Success", "Server-Lock is now disabled.", 5)
    end
end

g.stop_time_toggle = g.stop_time_toggle or function(toggle)
    if not is_localplayer_server_owner() then
        return notify("Error", "You are not the private server owner!", 5)
    end

    if toggle == true then
        g.Send("time_toggle", true)
        g.is_time_currently_stopped_priv_server = true
        notify("Success", "Time has been stopped.", 3)
    elseif toggle == false then
        g.Send("time_toggle", false)
        g.is_time_currently_stopped_priv_server = false
        notify("Success", "Time is now resumed.", 3)
    else
        return 
    end
end

g.change_time_num = g.change_time_num or function(number_input)
    if not typeof(number_input) == "number" then
        return notify("Error", "That is not a number!", 5)
    end
    if not is_localplayer_server_owner() then
        return notify("Error", "You are not the private server owner!", 5)
    end

    local main_conv = tonumber(number_input) or number_input
    g.Send("change_time", main_conv)
end

g.flash_time_toggle = g.flash_time_toggle or function(toggled)
    if not is_localplayer_server_owner() then
        g.flashing_time_fe_toggle = false
        return notify("Error", "You are not the private server owner!", 5)
    end

    if toggled then
        if g.flashing_time_fe_toggle then
            return notify("Warning", "Time Flasher is already enabled!", 5)
        end

        if UserInputService.TouchEnabled then
            g.flashing_time_fe_toggle = true
            notify("Success", "Time Flasher is now enabled.", 5)
            g.Flashing_Time_FE_Toggle_Task = task.spawn(function()
                while g.flashing_time_fe_toggle == true do
                fw(0.1)
                    change_time_num(4.5)
                    fw(0)
                    change_time_num(12)
                    fw(.1)
                    change_time_num(23)
                end
            end)
        else
            g.flashing_time_fe_toggle = true
            notify("Success", "Time Flasher is now enabled.", 5)
            g.Flashing_Time_FE_Toggle_Task = task.spawn(function()
                while g.flashing_time_fe_toggle == true do
                fw(0)
                change_time_num(4.5)
                fw(0)
                change_time_num(12)
                fw(0)
                change_time_num(23)
                end
            end)
        end
    else
        if not g.flashing_time_fe_toggle then
            return notify("Warning", "Time Flasher is not enabled!", 5)
        end

        g.flashing_time_fe_toggle = false
        if g.Flashing_Time_FE_Toggle_Task then
            task.cancel(g.Flashing_Time_FE_Toggle_Task)
            g.Flashing_Time_FE_Toggle_Task = nil
        end
        g.notify("Success", "Time Flasher has been disabled.", 5)
    end
end

g.pick_new_weather = g.pick_new_weather or function(weather_set)
    local weather_args

    if weather_set:lower():find("snow") then
        weather_args = {
            "change_weather",
            {
                humidity = 1,
                wind = 0.55,
                temperature = 0
            }
        }
    elseif weather_set:lower():find("sun") then
        weather_args = {
            "change_weather",
            {
                humidity = 0.5,
                wind = 0.3,
                temperature = 1
            }
        }
    elseif weather_set:lower():find("rain") then
        weather_args = {
            "change_weather",
            {
                humidity = 1,
                wind = 0.7,
                temperature = 0.6
            }
        }
    end
    
    return weather_args
end

g.set_new_weather = g.set_new_weather or function(new_weather_input)
    if not is_localplayer_server_owner() then
        return g.notify("Error", "You are not the private server owner!", 5)
    end
    local changed_weather = g.pick_new_weather(new_weather_input)
    if not changed_weather then
        return g.notify("Error", "Invalid weather type: " .. tostring(new_weather_input), 5)
    end
    g.Send(unpack(changed_weather))
end

g.weather_flasher_loop = g.weather_flasher_loop or function(toggle)
    if not is_localplayer_server_owner() then
        return notify("Error", "You are not the private server owner!", 5)
    end
    local fw = g.FlamesLibrary.wait

    if toggle == true then
        if g.changing_weather_on_repeat then
            return g.notify("Warning", "Flames Hub - Weather Flasher is already enabled!", 5)
        end

        g.changing_weather_on_repeat = true
        g.notify("Success", "Flames Hub - Weather Flasher is now enabled.", 5)
        g.FlamesLibrary.spawn("weather_loop_repeater", "spawn", function()
            while g.changing_weather_on_repeat == true do
            fw(0)
                g.set_new_weather("snow")
                fw(.1)
                g.set_new_weather("rain")
                fw(0)
                g.set_new_weather("sun")
            end
        end)
    elseif toggle == false then
        if not g.changing_weather_on_repeat then
            return g.notify("Warning", "Flames Hub - Weather Flasher is not enabled!", 5)
        end

        g.changing_weather_on_repeat = false
        g.FlamesLibrary.disconnect("weather_loop_repeater")
        g.notify("Success", "Flames Hub - Weather Flasher is now disabled.", 5)
    else
        return 
    end
end

for _, name in ipairs(AllCars) do CarMap[name:lower()] = name end
g.car_listing_gui = g.car_listing_gui or function()
    if g.CarListingGUIValue then return end
    g.CarListingGUIValue = true
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = tostring(g.randomString())
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = parent_gui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = isMobile and UDim2.new(0, 280, 0, 350) or UDim2.new(0, 350, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset/2, 0.5, -MainFrame.Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Made by: "..tostring(Script_Creator)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Parent = MainFrame

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        g.CarListingGUIValue = false
    end)

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
    ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 6
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ScrollingFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = ScrollingFrame
    UIPadding.PaddingLeft = UDim.new(0, 5)
    UIPadding.PaddingTop = UDim.new(0, 5)

    for _, name in ipairs(AllCars) do
        local CarButton = Instance.new("TextButton")
        CarButton.Size = UDim2.new(1, -10, 0, 30)
        CarButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        CarButton.Text = name
        CarButton.Font = Enum.Font.Gotham
        CarButton.TextSize = 16
        CarButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        CarButton.Parent = ScrollingFrame

        local CarCorner = Instance.new("UICorner")
        CarCorner.CornerRadius = UDim.new(0, 10)
        CarCorner.Parent = CarButton

        CarButton.MouseButton1Click:Connect(function()
            if not g.Get then return end
            g.Get("spawn_vehicle", name)
        end)
    end

    dragify(MainFrame)
end

g.stop_all_anims = g.stop_all_anims or function()
    local Hum = g.Humanoid or g.Character:FindFirstChildOfClass("AnimationController") or g.Character:FindFirstChildOfClass("Humanoid")
    if not Hum then return end
    for i,v in next, Hum:GetPlayingAnimationTracks() do
        v:Stop()
    end
end

g.isTrackPlaying = g.isTrackPlaying or function(humanoid)
    if not humanoid then
        notify("Error", "Humanoid does not exist / was not found.", 1)
        return false
    end

    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        if track.IsPlaying or (track.TimePosition > 0 and track.Length > 0) then
            return true
        end
    end

    return false
end
fw(0.2)
g.main_emote_ID = 72074295131591
g.play_anim_on_local_plr = function(anim_selector)
    if g.isTrackPlaying(Humanoid) then
        g.stop_all_anims()
    end
    wait(0.25)
    if anim_selector == "1" then
        local Humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("AnimationController")
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://134313829527772"
        fw(0.1)
        local track = Humanoid:LoadAnimation(anim)
        track:Play(0, 1, 1)
        track.TimePosition = 3.2708375453948975
        track:AdjustSpeed(0)

        for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(0)
        end
    elseif anim_selector == "2" then
        local Humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("AnimationController")
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://124771204189379"
        fw(0.1)
        local track = Humanoid:LoadAnimation(anim)
        repeat task.wait() until track.Length > 0
        track:Play(0, 1, 1)
        repeat task.wait() until track.IsPlaying and track.Speed >= 0.5
        if not track.IsPlaying then return end
        for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(0)
        end
    elseif anim_selector == "3" then
        local Humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("AnimationController")
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://137126647656632"
        fw(0.1)
        local track = Humanoid:LoadAnimation(anim)
        track:Play(0, 1, 1)
        track:AdjustSpeed(0)

        for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(0)
        end
    elseif anim_selector == "4" then
        local Humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("AnimationController")
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://85233258054867"
        fw(0.1)
        local track = Humanoid:LoadAnimation(anim)
        track:Play(0, 1, 1)
        track:AdjustSpeed(0)

        for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(0)
        end
    elseif anim_selector == "5" then
        local Humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("AnimationController")
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://101847197011911"
        fw(0.1)
        local track = Humanoid:LoadAnimation(anim)
        track:Play(0, 1, 1)
        track:AdjustSpeed(2)

        for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(2)
        end
    elseif anim_selector == "6" then
        local Humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("AnimationController")
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://138990462417721"
        fw(0.1)
        local track = Humanoid:LoadAnimation(anim)
        track:Play(0, 1, 1)
        track:AdjustSpeed(0)
        track.TimePosition = 2.49
        fw(0.1)
        for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
            v:AdjustSpeed(0)
        end
    else
        return notify("Error", "Invalid Animation argument provided, pick between either 1 or 2.", 7)
    end
end

g.create_bindable = g.create_bindable or function()
    if g._localBindable then
        return g._localBindable
    end

    local b = Instance.new("BindableEvent")
    g._localBindable = b
    return b
end

g.is_me = g.is_me or function(input)
    if type(input) ~= "string" then return false end
    input = string.lower(input)
    local name = string.lower(LocalPlayer.Name)
    local display = string.lower(LocalPlayer.DisplayName)
    return name:sub(1, #input) == input or display:sub(1, #input) == input
end

local Bindable
if not allowed[LocalPlayer.Name] then Bindable = create_bindable() end
if allowed[LocalPlayer.Name] then
    g.notify("Success", "You're an Administrator/Staff in Flames Hub, you can do our PRIVATE commands by doing: ?flamescmds in the chat.", 15)
end

g.current_worn_cached_clothing_items = g.current_worn_cached_clothing_items or {}
g.GetWornAssetId = g.GetWornAssetId or function(AssetType)
    local Humanoid = g.LocalPlayer.Character and g.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return nil end
    local Desc = Humanoid:FindFirstChildOfClass("HumanoidDescription")
    if not Desc then Desc = Humanoid:GetAppliedDescription() end
    if not Desc then return nil end
    if AssetType:lower() == "shirt" then
        return Desc.Shirt ~= 0 and Desc.Shirt or nil
    elseif AssetType:lower() == "pants" then
        return Desc.Pants ~= 0 and Desc.Pants or nil
    end
    return nil
end
wait(0.25)
local LayeredTypes = {
    [Enum.AccessoryType.TShirt] = true,
    [Enum.AccessoryType.Shirt] = true,
    [Enum.AccessoryType.Pants] = true,
    [Enum.AccessoryType.Jacket] = true,
    [Enum.AccessoryType.Sweater] = true,
    [Enum.AccessoryType.Shorts] = true,
    [Enum.AccessoryType.LeftShoe] = true,
    [Enum.AccessoryType.RightShoe] = true,
    [Enum.AccessoryType.DressSkirt] = true,
}

g.CacheWornClothing = g.CacheWornClothing or function()
    g.current_worn_cached_clothing_items["shirt"] = g.GetWornAssetId("shirt")
    g.current_worn_cached_clothing_items["pants"] = g.GetWornAssetId("pants")
    g.current_worn_cached_clothing_items["layered"] = {}
    local Character = g.Character or g.LocalPlayer.Character or get_char(LocalPlayer, 10) or g.Char:get()
    if not Character then return end
    local hum = g.Humanoid or g.Character and g.Character:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer, 10) or g.Char:get_hum()
    if not hum then return end
    local desc = hum:GetAppliedDescription()
    for _, info in ipairs(desc:GetAccessories(true)) do
        if info.IsLayered then
            table.insert(g.current_worn_cached_clothing_items["layered"], {
                AssetId = info.AssetId,
                AccessoryType = info.AccessoryType.Name,
            })
        end
    end
end

g.GetCachedClothingId = g.GetCachedClothingId or function(AssetType)
    AssetType = AssetType:lower()
    return g.current_worn_cached_clothing_items[AssetType]
end

g.GetCachedLayered = g.GetCachedLayered or function()
    return g.current_worn_cached_clothing_items["layered"] or {}
end
wait(0.15)
g.CacheWornClothing()

local function GetControlModule()
    local PlayerScripts = g.LocalPlayer:WaitForChild("PlayerScripts")
    local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule"))
    return PlayerModule:GetControls()
end

local commands = {
    ["!anim"] = {
        display = "!anim [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            g.play_anim_on_local_plr("1")
        end
    },

    ["!reset"] = {
        display = "!reset [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if g.Humanoid then
                pcall(function() g.Humanoid.Health = 0 end)
            elseif not g.Humanoid or not g.Humanoid.Parent then
                repeat task.wait(10) until g.Character:FindFirstChildOfClass("Humanoid")
                wait(1)
                if g.Character:FindFirstChildOfClass("Humanoid") then
                g.Character:FindFirstChildOfClass("Humanoid").Health = 0
                end
            end
        end
    },

    ["!speed"] = {
        display = "!speed [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if g.Humanoid then pcall(function() g.Humanoid.WalkSpeed = 100 end) end
        end
    },

    ["!anim2"] = {
        display = "!anim2 [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            g.play_anim_on_local_plr("2")
        end
    },

    ["!anim3"] = {
        display = "!anim3 [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            g.play_anim_on_local_plr("3")
        end
    },

    ["!anim4"] = {
        display = "!anim4 [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            g.play_anim_on_local_plr("4")
        end
    },

    ["!anim5"] = {
        display = "!anim5 [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            g.play_anim_on_local_plr("5")
        end
    },

    ["!anim6"] = {
        display = "!anim6 [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            g.play_anim_on_local_plr("6")
        end
    },

    ["!jump"] = {
        display = "!jump [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if g.Humanoid and g.HumanoidRootPart then
                pcall(function()
                g.HumanoidRootPart.Anchored = true
                wait(0.3)
                g.Humanoid:ChangeState(3)
                wait(0.3)
                g.HumanoidRootPart.Anchored = false
                end)
            end
        end
    },

    ["!freeze"] = {
        display = "!freeze [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if g.Humanoid then pcall(function() g.Humanoid.WalkSpeed = 0 end) end
            if g.HumanoidRootPart then pcall(function() g.HumanoidRootPart.Anchored = true end) end
            local Controls = GetControlModule()
            if Controls then Controls:Disable() end
        end
    },

    ["!unfreeze"] = {
        display = "!unfreeze [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if g.HumanoidRootPart then pcall(function() g.HumanoidRootPart.Anchored = false end) end
            if g.Humanoid then pcall(function() g.Humanoid.WalkSpeed = 16 end) end
            local Controls = GetControlModule()
            if Controls then Controls:Enable() end
        end
    },

    ["!kick"] = {
        display = "!kick [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            g.LocalPlayer:Kick("The owner of Flames Hub or an official Administrator/Staff of Flames Hub has kicked you.")
            wait(3)
            while true do end
        end
    },

    ["!bring"] = {
        display = "!bring [player]",
        run = function(args, sender)
            local target = args[2]
            if not is_me(target) then return end
            if not sender then return end
            local sender_char = sender.Character
            local sender_hrp = sender_char:WaitForChild("HumanoidRootPart")
            if sender_char and sender_char:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    if g.HumanoidRootPart and g.Character:FindFirstChild("HumanoidRootPart") then
                        g.HumanoidRootPart.CFrame = CFrame.new(sender_hrp.Position + Vector3.new(0, 3, 0))
                        g.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(sender_hrp.Position + Vector3.new(0, 3, 0))
                    else
                        g.Character:PivotTo(sender_char:GetPivot() + Vector3.new(0, 3, 0))
                    end
                end)
            end
        end
    },

    ["!unanim"] = {
        display = "!unanim [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            g.stop_all_anims()
        end
    },

    ["!unemote"] = {
        display = "!unemote [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            g.stop_all_anims()
        end
    },

    ["!stopanims"] = {
        display = "!stopanims [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            g.stop_all_anims()
        end
    },

    ["!vis"] = {
        display = "!vis [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if g.LocalPlayer:GetAttribute("is_verified") == false then return end
            if not g.InvisibleMode then return end
            if g.InvisibleMode.enabled.get() then
                g.InvisibleMode.enabled.set(false)
            end
        end
    },

    ["!visible"] = {
        display = "!visible [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if g.LocalPlayer:GetAttribute("is_verified") == false then return end
            if not g.InvisibleMode then return end
            if g.InvisibleMode.enabled.get() then
                g.InvisibleMode.enabled.set(false)
            end
        end
    },

    ["!invis"] = {
        display = "!invis [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if g.LocalPlayer:GetAttribute("is_verified") == false then return end
            if not g.InvisibleMode then return end
            if not g.InvisibleMode.enabled.get() then
                g.InvisibleMode.enabled.set(true)
            end
        end
    },

    ["!invisible"] = {
        display = "!invisible [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            if g.LocalPlayer:GetAttribute("is_verified") == false then return end
            if not g.InvisibleMode then return end
            if not g.InvisibleMode.enabled.get() then
                g.InvisibleMode.enabled.set(true)
            end
        end
    },

    ["!remove"] = {
        display = "!remove [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            local blank_pants = 15885405395
            local blank_shirt = 15821796333
            local current_pants = g.GetWornAssetId("pants")
            local current_shirt = g.GetWornAssetId("shirt")
            if current_pants ~= blank_pants or current_shirt ~= blank_shirt then
                g.CacheWornClothing()
            end
            local Humanoid = g.Humanoid or g.LocalPlayer.Character and g.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or g.Char:get_hum()
            if Humanoid then
                local desc = Humanoid:GetAppliedDescription()
                for _, info in ipairs(desc:GetAccessories(true)) do
                if info.IsLayered then
                    g.Get("wear", info.AssetId, info.AccessoryType.Name .. "Accessory")
                    task.wait(0.45)
                end
                end
            end
            task.wait(0.25)
            if current_shirt and current_shirt ~= blank_shirt then
                g.Get("wear", current_shirt, "Shirt")
            end
            if current_pants and current_pants ~= blank_pants then
                g.Get("wear", current_pants, "Pants")
            end
            g.Get("wear", blank_shirt, "Shirt")
            g.Get("wear", blank_pants, "Pants")
        end
    },

    ["!erase"] = {
        display = "!erase [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            local blank_pants = 15885405395
            local blank_shirt = 15821796333
            local current_pants = g.GetWornAssetId("pants")
            local current_shirt = g.GetWornAssetId("shirt")
            if current_pants ~= blank_pants or current_shirt ~= blank_shirt then
                g.CacheWornClothing()
            end
            local Humanoid = g.Humanoid or g.LocalPlayer.Character and g.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or g.Char:get_hum()
            if Humanoid then
                local desc = Humanoid:GetAppliedDescription()
                for _, info in ipairs(desc:GetAccessories(true)) do
                    if info.IsLayered then
                        g.Get("wear", info.AssetId, info.AccessoryType.Name .. "Accessory")
                        task.wait(0.45)
                    end
                end
            end
            task.wait(0.25)
            if current_shirt and current_shirt ~= blank_shirt then
                g.Get("wear", current_shirt, "Shirt")
            end
            if current_pants and current_pants ~= blank_pants then
                g.Get("wear", current_pants, "Pants")
            end
            g.Get("wear", blank_shirt, "Shirt")
            g.Get("wear", blank_pants, "Pants")
        end
    },

    ["!restore"] = {
        display = "!restore [player]",
        run = function(args)
            local target = args[2]
            if not is_me(target) then return end
            local blank_pants = 15885405395
            local blank_shirt = 15821796333
            local cached_pants = g.GetCachedClothingId("pants")
            local cached_shirt = g.GetCachedClothingId("shirt")
            local current_pants = g.GetWornAssetId("pants")
            local current_shirt = g.GetWornAssetId("shirt")
            if current_shirt == blank_shirt and cached_shirt then
                g.Get("wear", cached_shirt, "Shirt")
            end
            if current_pants == blank_pants and cached_pants then
                g.Get("wear", cached_pants, "Pants")
            end
            for _, item in ipairs(g.GetCachedLayered()) do
                g.Get("wear", item.AssetId, item.AccessoryType .. "Accessory")
                task.wait(0.45)
            end
        end
    },

    ["!fix"] = {
        display = "!fix [player]",
        run = function(args)
            if g.Fix_Camera_Head_Cooldown_Plr_Active then return end
            g.Fix_Camera_Head_Cooldown_Plr_Active = true
            local cam = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
            local head = g.Head or g.Character:FindFirstChild("Head") or get_head(LocalPlayer, 10) or g.Char:get_head()
            if not head then return end
            workspace.CurrentCamera:remove()
            wait(.1)
            repeat wait() until LocalPlayer.Character ~= nil
            workspace.CurrentCamera.CameraSubject = g.Humanoid or g.Character:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer, 10)
            workspace.CurrentCamera.CameraType = "Custom"
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 99999
            LocalPlayer.CameraMode = "Classic"
            head.Anchored = false
            task.delay(5, function()
                g.Fix_Camera_Head_Cooldown_Plr_Active = false
            end)
        end
    }
}

g.run_command = function(cmdName, args, sender)
    local data = commands[cmdName]
    if data then
        data.run(args, sender)
    end
end

g.commands_menu_for_administrators_and_staffs = g.commands_menu_for_administrators_and_staffs or function()
    if g.CommandsMenuGui and g.CommandsMenuGui:IsA("ScreenGui") then
        g.CoreGui:FindFirstChild("CommandsMenu").Enabled = true
        return 
    end

    local Commands_Menu_For_Administration_Listing = Instance.new("ScreenGui")
    Commands_Menu_For_Administration_Listing.Name = "CommandsMenu"
    Commands_Menu_For_Administration_Listing.ResetOnSpawn = false
    Commands_Menu_For_Administration_Listing.Parent = CoreGui or g.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Parent = Commands_Menu_For_Administration_Listing
    wait(0.45)
    dragify(MainFrame)
    g.CommandsMenuGui = Commands_Menu_For_Administration_Listing

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Size = UDim2.new(1, -10, 0, 20)
    Subtitle.Position = UDim2.new(0, 5, 0, 35)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Commands only work on other Flames Hub users."
    Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    Subtitle.TextScaled = true
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextWrapped = true
    Subtitle.Parent = MainFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -10, 0, 30)
    Title.Position = UDim2.new(0, 5, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = "Commands Menu"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextScaled = true
    CloseButton.Parent = MainFrame
    CloseButton.MouseButton1Click:Connect(function()
        Commands_Menu_For_Administration_Listing.Enabled = false
    end)
    wait(0.5)
    make_round(CloseButton)

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Position = UDim2.new(0, 5, 0, 65)
    ScrollFrame.Size = UDim2.new(1, -10, 1, -75)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollFrame.ScrollBarThickness = 6
    ScrollFrame.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = ScrollFrame

    for _, data in pairs(commands) do
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -10, 0, 30)
        Label.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Label.Text = data.display
        Label.Font = Enum.Font.Gotham
        Label.TextScaled = true
        Label.TextWrapped = true
        Label.Parent = ScrollFrame

        local LabelCorner = Instance.new("UICorner")
        LabelCorner.CornerRadius = UDim.new(0, 5)
        LabelCorner.Parent = Label
    end

    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 5)
    end)
end

if g.Message_Received_Conn_Owner_Commands_Setup then
    pcall(function() g.Message_Received_Conn_Owner_Commands_Setup:Disconnect() end)
    g.Message_Received_Conn_Owner_Commands_Setup = nil
end
wait(0.25)
g.Message_Received_Conn_Owner_Commands_Setup = TextChatService.MessageReceived:Connect(function(message)
    local source = message.TextSource
    if not source then return end
    local sender = Players:GetPlayerByUserId(source.UserId)
    if not sender or not allowed[sender.Name] then return end
    local text = message.Text
    if type(text) ~= "string" or text == "" then return end
    local args = text:split(" ")
    local cmdName = string.lower(args[1])
    local data = commands[cmdName]
    if data then
        data.run(args, sender)
    end
end)

if g.Administrator_Staff_Message_Received_Commands_Section then
    pcall(function() g.Administrator_Staff_Message_Received_Commands_Section:Disconnect() end)
    g.Administrator_Staff_Message_Received_Commands_Section = nil
end
wait(0.25)
g.Administrator_Staff_Message_Received_Commands_Section = TextChatService.MessageReceived:Connect(function(message)
    local source = message.TextSource
    if not source then return end

    local sender = Players:GetPlayerByUserId(source.UserId)
    if not sender then return end
    if sender ~= LocalPlayer then return end
    if not allowed[sender.Name] then return end
    local text = message.Text
    if type(text) ~= "string" or text == "" then return end
    if text == "?flamescmds" then
        g.commands_menu_for_administrators_and_staffs()
    end
end)

if Bindable and Bindable:IsA("BindableEvent") then
    if g.Bindable_Event_Run_Command_LocalPlayer_Connection then
        pcall(function() g.Bindable_Event_Run_Command_LocalPlayer_Connection:Disconnect() end)
        g.Bindable_Event_Run_Command_LocalPlayer_Connection = nil
    end
    wait(0.25)
    g.Bindable_Event_Run_Command_LocalPlayer_Connection = Bindable.Event:Connect(function(cmdName, args)
        if type(cmdName) ~= "string" or type(args) ~= "table" then return end
        run_command(cmdName, args, nil)
    end)
end

if getgenv().get_enrolled_state == nil then
    g.notify("Info", "Waiting until 'get_enrolled_state' exists...", 6)
    repeat task.wait() until g.get_enrolled_state and g.get_enrolled_state ~= nil
    if getgenv().get_enrolled_state then
        notify("Success", "Found get_enrolled_state correctly.", 5)
    end
end

if CoreGui:FindFirstChild("FlamesAdminGUI", true) and CoreGui:FindFirstChild("FlamesAdminGUI", true):IsA("ScreenGui") then CoreGui:FindFirstChild("FlamesAdminGUI", true).Enabled = true end
g.get_other_vehicle = g.get_other_vehicle or function(Player)
    for _, v in pairs(g.Workspace:FindFirstChild("Vehicles"):GetChildren()) do
        local owner_object = v:FindFirstChild("owner") or v:FindFirstChild("owner", true)

        if owner_object and owner_object.Value == Player then
            return v
        end
    end

    return nil
end

local RGB_KEY = "rgb_phone_loop"
g.change_phone_color = g.change_phone_color or function(New_Color)
    g.Send("phone_color", New_Color)
end

g.RGB_Phone = g.RGB_Phone or function(Boolean)
    local lib = g.FlamesLibrary

    if Boolean == true then
        if g.RGB_Rainbow_Phone then
            return notify("Warning", "RGB/Rainbow Phone is already enabled.", 5)
        end

        g.RGB_Rainbow_Phone = true
        g.notify("Success", "Started RGB/Rainbow Phone.", 5)
        lib.spawn(RGB_KEY, "spawn", function()
            while g.RGB_Rainbow_Phone == true do
                for _, color in ipairs(colors) do
                    if g.RGB_Rainbow_Phone ~= true then return end
                    g.change_phone_color(color)
                    fw(0)
                end
            end
        end)
    elseif Boolean == false then
        if not g.RGB_Rainbow_Phone then
            return notify("Warning", "RGB/Rainbow Phone is not enabled.", 5)
        end

        g.RGB_Rainbow_Phone = false
        lib.disconnect(RGB_KEY)
        notify("Success", "Stopped RGB/Rainbow Phone.", 5)
        fw(0.1)
        g.change_phone_color(Color3.fromRGB(255, 255, 255))
    end
end

g.steal_car_functionality = g.steal_car_functionality or function(target_plr)
    local selected_player = nil

    if typeof(target_plr) == "Instance" and target_plr:IsA("Player") then
        selected_player = target_plr
    elseif typeof(target_plr) == "string" then
        for _, plr in pairs(g.Players:GetPlayers()) do
            if plr.Name == target_plr then
                selected_player = plr
                break
            end
        end
    end

    if not selected_player then return end
    for _, vehicle in pairs(g.Workspace:FindFirstChild("Vehicles"):GetChildren()) do
        local seat = vehicle:FindFirstChild("VehicleSeat") or vehicle:FindFirstChild("VehicleSeat", true)
        if not seat then return notify("Error", "We could not find VehicleSeat in this Vehicle.", 6) end
        local owner_object = vehicle:FindFirstChild("owner")
        if not owner_object then return notify("Error", "No 'owner' object found in this Vehicle.", 6) end
        if owner_object.Value == selected_player then
            if seat.Occupant == nil and vehicle:GetAttribute("locked") == false then
                local ok, response = pcall(function()
                    g.Get("sit", seat)
                end)

                if not ok and g.notify then
                    notify("Error", tostring(response), 15)
                end
                break
            else
                notify("Error", "Someone is already in this Vehicle, try again when they are not sitting in it.", 8)
                break
            end
        end
    end
end

g.save_outfits_GUI = g.save_outfits_GUI or function()
    if CoreGui:FindFirstChild("OutfitManagerUI", true) then
        return notify("Warning", "You're already running Outfits Manager!", 5)
    end
    if g.LoadedOutfit_Manager_GUI then
        return notify("Warning", "You're already running Outfits Manager!", 5)
    end

    local PLAYER_NAME = LocalPlayer.Name
    local cached_outfits = {}
    local ui_refs = {}
    local Send, Get = g.Send, g.Get
    local pending_callbacks = {}
    local FolderName = "lifetogether_admin_savedoutfits"
    local function save_outfit(name, outfit, callback)
        if not isfolder(FolderName) then makefolder(FolderName) end
        local filePath = FolderName .. "/" .. name .. ".json"
        if isfile(filePath) then
            cached_outfits[name] = outfit
            if callback then callback(true) end
            return
        end
        local ok, err = pcall(function()
            writefile(filePath, HttpService:JSONEncode(outfit))
        end)
        cached_outfits[name] = outfit
        if callback then callback(ok) end
    end

    local function delete_outfit(name, callback)
        local ok = pcall(function()
            if isfile(FolderName .. "/" .. name .. ".json") then
                delfile(FolderName .. "/" .. name .. ".json")
            end
        end)
        cached_outfits[name] = nil
        if callback then callback(ok) end
    end

    local function rename_outfit(old_name, new_name, callback)
        if not cached_outfits[old_name] then
            if callback then callback(false, "Outfit not found") end
            return
        end
        if cached_outfits[new_name] then
            if callback then callback(false, "Name already taken") end
            return
        end
        local outfit = cached_outfits[old_name]
        if not isfolder(FolderName) then makefolder(FolderName) end
        local ok = pcall(function()
            writefile(FolderName .. "/" .. new_name .. ".json", HttpService:JSONEncode(outfit))
            if isfile(FolderName .. "/" .. old_name .. ".json") then
                delfile(FolderName .. "/" .. old_name .. ".json")
            end
        end)
        if ok then
            cached_outfits[new_name] = outfit
            cached_outfits[old_name] = nil
        end
        if callback then callback(ok) end
    end

    local function fetch_outfit_list(callback)
        cached_outfits = {}
        if not isfolder(FolderName) then
            if callback then callback(true) end
            return
        end
        for _, f in ipairs(listfiles(FolderName)) do
            if f:match("%.json$") then
                local name = f:match("([^/\\]+)%.json$")
                local ok, content = pcall(readfile, f)
                if ok and content and #content > 0 then
                    local success, data = pcall(function() return HttpService:JSONDecode(content) end)
                    if success and type(data) == "table" then
                        cached_outfits[name] = data
                    end
                end
            end
        end
        if callback then callback(true) end
    end

    local function buildBatchPayload(data)
        local accessories = {}
        local order = 1
        if data.Accessories then
            for _, acc in ipairs(data.Accessories) do
                local isLayered = acc.IsLayered == true
                table.insert(accessories, {
                    AssetId = acc.AssetId,
                    AccessoryType = acc.AccessoryType,
                    IsLayered = isLayered,
                    Rotation = "  ",
                    Position = "  ",
                    Scale = "1 1 1",
                    Order = isLayered and order or nil,
                    Puffiness = isLayered and 0 or nil
                })
                if isLayered then order = order + 1 end
            end
        end
        return {
            accessories = accessories,
            properties = {
                Head = data.Head or 0,
                Torso = data.Torso or 0,
                LeftArm = data.LeftArm or 0,
                RightArm = data.RightArm or 0,
                LeftLeg = data.LeftLeg or 0,
                RightLeg = data.RightLeg or 0,
                Face = data.Face or 0,
                Shirt = data.Shirt or 0,
                Pants = data.Pants or 0,
                GraphicTShirt = data.GraphicTShirt or 0,
                RunAnimation = data.RunAnimation or 0,
                WalkAnimation = data.WalkAnimation or 0,
                JumpAnimation = data.JumpAnimation or 0,
                FallAnimation = data.FallAnimation or 0,
                ClimbAnimation = data.ClimbAnimation or 0,
                IdleAnimation = data.IdleAnimation or 0,
                SwimAnimation = data.SwimAnimation or 0,
                HeightScale = data.HeightScale or 1,
                WidthScale = data.WidthScale or 1,
                DepthScale = 1,
                HeadScale = 1,
                BodyTypeScale = 0,
                ProportionScale = 0,
                HeadColor = ";<,#",
                TorsoColor = ";<,#",
                LeftArmColor = ";<,#",
                RightArmColor = ";<,#",
                LeftLegColor = ";<,#",
                RightLegColor = ";<,#",
            }
        }
    end

    local function promptOutfitName(callback)
        local popup = Instance.new("ScreenGui")
        popup.Name = "OutfitNamePrompt"
        popup.IgnoreGuiInset = true
        popup.ResetOnSpawn = false
        popup.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        popup.Parent = parent_gui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 250, 0, 130)
        frame.Position = UDim2.new(0.5, -125, 0.5, -65)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        frame.Parent = popup
        Instance.new("UICorner", frame)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -10, 0, 30)
        title.Position = UDim2.new(0, 5, 0, 5)
        title.BackgroundTransparency = 1
        title.Text = "Enter Outfit Name"
        title.TextColor3 = Color3.new(1, 1, 1)
        title.Font = Enum.Font.GothamBold
        title.TextScaled = true
        title.Parent = frame

        local txt = Instance.new("TextBox")
        txt.PlaceholderText = "Outfit Name"
        txt.Size = UDim2.new(1, -20, 0, 35)
        txt.Position = UDim2.new(0, 10, 0, 40)
        txt.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        txt.TextColor3 = Color3.new(1, 1, 1)
        txt.Font = Enum.Font.Gotham
        txt.TextScaled = true
        txt.ClearTextOnFocus = true
        txt.Text = ""
        txt.Parent = frame
        Instance.new("UICorner", txt)

        local save_btn = Instance.new("TextButton")
        save_btn.Size = UDim2.new(1, -20, 0, 35)
        save_btn.Position = UDim2.new(0, 10, 0, 85)
        save_btn.Text = "Save"
        save_btn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        save_btn.TextColor3 = Color3.new(1, 1, 1)
        save_btn.Font = Enum.Font.GothamBold
        save_btn.TextScaled = true
        save_btn.Parent = frame
        Instance.new("UICorner", save_btn)

        save_btn.MouseButton1Click:Connect(function()
            local name = txt.Text:gsub("%s+", "")
            if name ~= "" then
                popup:Destroy()
                task.wait()
                callback(name)
            else
                g.notify("Error", "Enter a valid outfit name.", 5)
            end
        end)
    end

    local function fuzzy_match(name, query)
        local j = 1
        local qlen = #query
        for i = 1, #name do
            if name:sub(i, i) == query:sub(j, j) then
                j = j + 1
                if j > qlen then return true end
            end
        end
        return false
    end

    local function refreshOutfitList()
        local scroller = ui_refs.scroller
        if not scroller then return g.notify("Warning", "Scroller missing from UI.", 5) end
        local query = ""
        if ui_refs.searchbox then
            query = string.lower(ui_refs.searchbox.Text or "")
        end

        for _, child in ipairs(scroller:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end

        local visible_count = 0
        for name, outfitData in pairs(cached_outfits) do
            local lowered_name = string.lower(name)

            if query ~= "" then
                local exact_match = string.find(lowered_name, query, 1, true)
                local fuzzy_result = fuzzy_match(lowered_name, query)
                if not exact_match and not fuzzy_result then
                    continue
                end
            end

            visible_count = visible_count + 1
            local entry = Instance.new("Frame")
            entry.Size = UDim2.new(1, -5, 0, 35)
            entry.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            entry.Parent = scroller
            Instance.new("UICorner", entry)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.35, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Font = Enum.Font.Gotham
            label.TextScaled = true
            label.Parent = entry

            local wearBtn = Instance.new("TextButton")
            wearBtn.Size = UDim2.new(0.25, -30, 1, -10)
            wearBtn.Position = UDim2.new(0.5, 40, 0, 7)
            wearBtn.Text = "Wear"
            wearBtn.BackgroundColor3 = Color3.fromRGB(249, 232, 0)
            wearBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            wearBtn.Font = Enum.Font.Gotham
            wearBtn.TextScaled = true
            wearBtn.Parent = entry
            Instance.new("UICorner", wearBtn)

            local renameBtn = Instance.new("TextButton")
            renameBtn.Size = UDim2.new(0.25, -30, 1, -8)
            renameBtn.Position = UDim2.new(0, 180, 0, 7)
            renameBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
            renameBtn.TextColor3 = Color3.new(1, 1, 1)
            renameBtn.Font = Enum.Font.SourceSansBold
            renameBtn.TextScaled = true
            renameBtn.Text = "Rename"
            renameBtn.Parent = entry
            Instance.new("UICorner", renameBtn)

            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0.25, -30, 1, -10)
            delBtn.Position = UDim2.new(0, 380, 0.2, 0)
            delBtn.Text = "Delete"
            delBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
            delBtn.TextColor3 = Color3.new(1, 1, 1)
            delBtn.Font = Enum.Font.Gotham
            delBtn.TextScaled = true
            delBtn.Parent = entry
            Instance.new("UICorner", delBtn)

            wearBtn.MouseButton1Click:Connect(function()
                if g.is_busy_outfit_manager then
                    return g.notify("Warning", "Busy, wait!", 4)
                end
                g.is_busy_outfit_manager = true

                local data = outfitData
                if not data or type(data) ~= "table" then
                    g.is_busy_outfit_manager = false
                        return g.notify("Error", "Invalid outfit data!", 5)
                    end

                    g.clear_avatar()
                    task.wait(1)
                    local payload = buildBatchPayload(data)
                    for i = 1, math.random(1, 6) do
                        Send("wear_outfit_from_desc", payload)
                        task.wait(0.1)
                    end
                    task.wait(0.2)
                    if data.SkinTone then
                    pcall(function()
                        local c = Color3.new(data.SkinTone[1], data.SkinTone[2], data.SkinTone[3])
                        for i = 1, 3 do Send("skin_tone", c) task.wait(0.1) end
                    end)
                    task.wait(0.3)
                end

                if data.Age then
                    pcall(function()
                        Get("age", tostring(data.Age)) task.wait(0.3)
                        Get("age", tostring(data.Age))
                    end)
                    task.wait(0.3)
                end
                task.wait(0.1)
                if data.HeightScale then
                    pcall(function()
                        for i = 1, 3 do Send("body_scale", "HeightScale", data.HeightScale * 100) task.wait(0.15) end
                    end)
                end
                task.wait(0.1)
                if data.WidthScale then
                    pcall(function()
                        for i = 1, 3 do Send("body_scale", "WidthScale", data.WidthScale * 100) task.wait(0.15) end
                    end)
                end
                task.wait(0.2)
                g.is_busy_outfit_manager = false
                g.notify("Success", "Outfit applied successfully!", 5)
            end)

            renameBtn.MouseButton1Click:Connect(function()
                if g.is_busy_outfit_manager then
                    return g.notify("Warning", "Busy, wait!", 4)
                end
                g.is_busy_outfit_manager = true

                promptOutfitName(function(newName)
                    if not newName or newName == "" then
                        g.is_busy_outfit_manager = false
                        return g.notify("Error", "Invalid new name!", 4)
                    end
                    if cached_outfits[newName] then
                        g.is_busy_outfit_manager = false
                        return g.notify("Error", "An outfit with that name already exists!", 4)
                    end
                    rename_outfit(name, newName, function(success, reason)
                        g.is_busy_outfit_manager = false
                        if success then
                            g.notify("Success", "Outfit renamed to: " .. newName, 4)
                            refreshOutfitList()
                        else
                            g.notify("Error", "Failed to rename: " .. (reason or "unknown error"), 4)
                        end
                    end)
                end)
            end)

            local delete_armed = false
            delBtn.MouseButton1Click:Connect(function()
                if not delete_armed then
                    delete_armed = true
                    g.notify("Warning", "Click again to confirm delete: " .. name, 5)
                    task.delay(5, function() delete_armed = false end)
                else
                    delete_outfit(name, function(success)
                        if success then
                            g.notify("Success", "Deleted outfit: " .. name, 5)
                            refreshOutfitList()
                        else
                            g.notify("Error", "Failed to delete outfit.", 4)
                        end
                    end)
                end
            end)
        end
        if ui_refs.noOutfitsLabel then ui_refs.noOutfitsLabel.Visible = visible_count == 0 end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = tostring(g.randomString())
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = parent_gui
    g.LoadedOutfit_Manager_GUI = true

    local OutfitManagerFrameMain = Instance.new("Frame")
    OutfitManagerFrameMain.Size = UDim2.new(0, 500, 0, 400)
    OutfitManagerFrameMain.Position = UDim2.new(0.5, -250, 0.5, -200)
    OutfitManagerFrameMain.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    OutfitManagerFrameMain.BorderSizePixel = 0
    OutfitManagerFrameMain.Parent = ScreenGui
    Instance.new("UICorner", OutfitManagerFrameMain)

    dragify(OutfitManagerFrameMain)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundTransparency = 1
    Title.Text = "Outfits Manager V2"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.TextSize = 18
    Title.Parent = OutfitManagerFrameMain

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextScaled = true
    CloseButton.Parent = OutfitManagerFrameMain
    Instance.new("UICorner", CloseButton)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        g.LoadedOutfit_Manager_GUI = false
    end)

    local SaveButton = Instance.new("TextButton")
    SaveButton.Size = UDim2.new(0.5, -5, 0, 35)
    SaveButton.Position = UDim2.new(0, 5, 0, 40)
    SaveButton.Text = "Save Outfit"
    SaveButton.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
    SaveButton.TextColor3 = Color3.new(1, 1, 1)
    SaveButton.Font = Enum.Font.Gotham
    SaveButton.TextScaled = true
    SaveButton.TextSize = 16
    SaveButton.Parent = OutfitManagerFrameMain
    Instance.new("UICorner", SaveButton)

    local RefreshButton = Instance.new("TextButton")
    RefreshButton.Size = UDim2.new(0.5, -5, 0, 35)
    RefreshButton.Position = UDim2.new(0.5, 0, 0, 40)
    RefreshButton.Text = "Refresh"
    RefreshButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    RefreshButton.TextColor3 = Color3.new(1, 1, 1)
    RefreshButton.Font = Enum.Font.Gotham
    RefreshButton.TextScaled = true
    RefreshButton.TextSize = 16
    RefreshButton.Parent = OutfitManagerFrameMain
    Instance.new("UICorner", RefreshButton)

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -10, 0, 30)
    SearchBox.Position = UDim2.new(0, 5, 0, 75)
    SearchBox.PlaceholderText = "Search outfits..."
    SearchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SearchBox.TextColor3 = Color3.new(1, 1, 1)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextScaled = true
    SearchBox.ClearTextOnFocus = false
    SearchBox.Text = ""
    SearchBox.Parent = OutfitManagerFrameMain
    Instance.new("UICorner", SearchBox)

    ui_refs.searchbox = SearchBox
    ui_refs.frame = OutfitManagerFrameMain
    SearchBox:GetPropertyChangedSignal("Text"):Connect(refreshOutfitList)

    local scroller = Instance.new("ScrollingFrame")
    scroller.Position = UDim2.new(0, 5, 0, 110)
    scroller.Size = UDim2.new(1, -10, 1, -120)
    scroller.BackgroundTransparency = 1
    scroller.BorderSizePixel = 0
    scroller.ScrollBarThickness = 6
    scroller.ScrollingDirection = Enum.ScrollingDirection.Y
    scroller.Parent = OutfitManagerFrameMain

    ui_refs.scroller = scroller

    local noOutfitsLabel = Instance.new("TextLabel")
    noOutfitsLabel.Size = UDim2.new(1, 0, 0, 40)
    noOutfitsLabel.Position = UDim2.new(0, 0, 0, 10)
    noOutfitsLabel.BackgroundTransparency = 1
    noOutfitsLabel.Text = "No saved outfits."
    noOutfitsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    noOutfitsLabel.Font = Enum.Font.Gotham
    noOutfitsLabel.TextScaled = true
    noOutfitsLabel.Visible = false
    noOutfitsLabel.Parent = scroller

    ui_refs.noOutfitsLabel = noOutfitsLabel

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = scroller

    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroller.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)

    if ui_refs.noOutfitsLabel then
        local has_visible = false
        for _, child in ipairs(scroller:GetChildren()) do
            if child:IsA("Frame") then
                has_visible = true
                break
            end
        end
        noOutfitsLabel.Visible = not has_visible
    end

    SaveButton.MouseButton1Click:Connect(function()
        if g.is_busy_outfit_manager then
            return g.notify("Warning", "Busy, wait!", 4)
        end
        g.is_busy_outfit_manager = true

        promptOutfitName(function(name)
            local char = Character
            if not char or not char:FindFirstChildOfClass("Humanoid") then
                g.is_busy_outfit_manager = false
                return g.notify("Error", "Character or Humanoid missing!", 4)
            end

            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local desc = humanoid and humanoid:GetAppliedDescription()
            if not desc then
                g.is_busy_outfit_manager = false
                return g.notify("Error", "Failed to get HumanoidDescription!", 4)
            end

            local outfit = {}
            outfit.Accessories = {}
            for _, info in ipairs(desc:GetAccessories(true)) do
                table.insert(outfit.Accessories, {
                    AssetId = info.AssetId,
                    AccessoryType = info.AccessoryType.Name,
                    IsLayered = info.IsLayered
                })
            end

            outfit.Shirt = desc.Shirt
            outfit.Pants = desc.Pants
            outfit.GraphicTShirt = desc.GraphicTShirt
            outfit.Face = desc.Face
            outfit.Head = desc.Head
            outfit.Torso = desc.Torso
            outfit.LeftArm = desc.LeftArm
            outfit.RightArm = desc.RightArm
            outfit.LeftLeg = desc.LeftLeg
            outfit.RightLeg = desc.RightLeg
            outfit.ClimbAnimation = desc.ClimbAnimation
            outfit.FallAnimation = desc.FallAnimation
            outfit.IdleAnimation = desc.IdleAnimation
            outfit.JumpAnimation = desc.JumpAnimation
            outfit.RunAnimation = desc.RunAnimation
            outfit.SwimAnimation = desc.SwimAnimation
            outfit.WalkAnimation = desc.WalkAnimation
            outfit.HeightScale = desc.HeightScale
            outfit.WidthScale = desc.WidthScale

            local hc = desc.HeadColor
            outfit.SkinTone = { hc.R, hc.G, hc.B }
            local age = LocalPlayer:GetAttribute("age")
            if age then outfit.Age = tostring(age) end
            save_outfit(name, outfit, function(success)
                g.is_busy_outfit_manager = false
                if success then
                    g.notify("Success", "Saved outfit: " .. name, 5)
                    refreshOutfitList()
                else
                    g.notify("Error", "Failed to save outfit.", 4)
                end
            end)
        end)
    end)

    RefreshButton.MouseButton1Click:Connect(function()
        fetch_outfit_list(function(success)
            if success then
                refreshOutfitList()
                g.notify("Success", "Outfits refreshed!", 3)
            else
                g.notify("Error", "Failed to fetch outfits.", 4)
            end
        end)
    end)

    fetch_outfit_list(function(success)
        if not success then
            g.notify("Error", "Could not load outfits.", 5)
            return
        end
    end)
end

g.already_loaded_workaround_script_flames_hub = g.already_loaded_workaround_script_flames_hub or false
g.already_patched_discord_button = g.already_patched_discord_button or false
g.load_workaround_script = g.load_workaround_script or function()
	if g.already_loaded_workaround_script_flames_hub then
		return g.notify("Warning", "Chat Workaround has already been loaded.", 5)
	end

	local FL = getgenv().FlamesLibrary
	local hidden_gui_main = gethui and gethui() or get_hidden_gui and get_hidden_gui() or g.CoreGui or g.PlayerGui
	local HttpService = g.HttpService or (cloneref and cloneref(game:GetService("HttpService"))) or game:GetService("HttpService")
	g.already_loaded_workaround_script_flames_hub = true
	loadstring(game:HttpGet('https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Deadly_Chat.lua'))()
    local function patch_button(frame)
        if g.already_patched_discord_button then return end
        for _, desc in ipairs(frame:GetDescendants()) do
            if desc:IsA("ImageButton") and desc.Name == "Discord" and desc.Image == "rbxassetid://7552532178" then
                g.already_patched_discord_button = true
                FL.disconnect("discord_button_activated")
                FL.connect("discord_button_activated", desc.Activated:Connect(function()
                    if http_requesting then
                        http_requesting({
                            Url = 'http://127.0.0.1:6463/rpc?v=1',
                            Method = 'POST',
                            Headers = {
                                ['Content-Type'] = 'application/json',
                                Origin = 'https://discord.com'
                            },
                            Body = HttpService:JSONEncode({
                                cmd = 'INVITE_BROWSER',
                                nonce = HttpService:GenerateGUID(false),
                                args = {code = 'MTYKxQfpNJ'}
                            })
                        })
                    else
                        if g.AllClipboards then g.AllClipboards("https://discord.gg/MTYKxQfpNJ") end
                        if g.notify then g.notify("Success", "Successfully copied Discord link to Clipboard.", 5) end
                    end
                end))
                break
            end
        end
    end

	local function find_chat_frame()
		for _, gui in ipairs(hidden_gui_main:GetChildren()) do
			if gui:IsA("ScreenGui") then
				local frame = gui:FindFirstChild("Chat System")
				if frame and frame:IsA("Frame") then
                    frame.Draggable = true
                    frame.Position = UDim2.new(0.00741000008, 498, 0.0585100017, -8)
                    dragify(frame)
					return frame
				end
			end
		end
		return nil
	end

	local chat_frame = find_chat_frame()
	if chat_frame then
		patch_button(chat_frame)
	else
		local conn
		conn = FL.connect(hidden_gui_main, "ChildAdded", function(child)
			if child:IsA("ScreenGui") then
				local frame = child:FindFirstChild("Chat System")
				if frame and frame:IsA("Frame") then
					FL.disconnect(conn)
					patch_button(frame)
					return
				end
				FL.connect(child, "ChildAdded", function(grandchild)
					if grandchild.Name == "Chat System" and grandchild:IsA("Frame") then
						FL.disconnect(conn)
						patch_button(grandchild)
					end
				end)
			end
		end)
	end
end

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
    local car = get_vehicle()
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

g.start_vehicle_fly = g.start_vehicle_fly or function()
    if g.vehiclefly_bg or g.vehiclefly_bv then return end
    local car = get_vehicle()
    if not car then g.disable_vehicle_noclip() task.wait() g.cleanup() getgenv().notify("Error", "You do not have a Vehicle spawned.", 5) return end
    local base = car.Base or car:FindFirstChild("Base")
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
        g.vehiclefly_conns.down = UserInputService.InputBegan:Connect(function(i, g)
            if g then return end
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

g.stop_vehicle_fly = g.stop_vehicle_fly or function()
    g.vehicle_fly = false
    g.disable_vehicle_noclip()
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

g.owner_in_game = g.owner_in_game or function(user)
    local target = tostring(user):lower()
    for _, v in ipairs(Players:GetPlayers()) do
        if v.Name:lower() == target then
            return true
        end
    end

    return false
end

g.streamer_mode_script = g.streamer_mode_script or function()
    if g.hidden_loaded then
        return notify("Warning", "Streamer Mode script is already loaded.", 5)
    end

    loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Streamer_Mode.lua"))()
end

g.unload_streamer_mode_script = g.unload_streamer_mode_script or function()
    if g.hidden_settings then
        local h = g.hidden_settings
        if h.Enabled then h.Enabled = false end
        for _, c in pairs(h.conns) do
            pcall(function()
                c:Disconnect()
                c = nil
            end)
        end

        h.conns = {}
    end

    if g.hidden_person then
        for _, c in pairs(g.hidden_person.conns or {}) do
            pcall(function()
                c:Disconnect()
                c = nil
            end)
        end

        g.hidden_person.conns = {}
    end
    g.hidden_loaded = false
    g.hidden_settings = {enabled = false, conns = {}}
    g.hidden_person = {conns = {}}

    for _, v in ipairs(parent_gui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name:lower():find("streamermode") then
            v:Destroy()
        end
    end
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name:lower():find("streamermode") then
            v:Destroy()
        end
    end
end

g.Pick_Vehicle_Color_Func = g.Pick_Vehicle_Color_Func or function(input)
    if not input then return end
    local str = tostring(input):lower():match("^%s*(.-)%s*$")
    local chosen
    local r, g, b = str:match("(%d+)[,%s]+(%d+)[,%s]+(%d+)")
    if r and g and b then chosen = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)) end
    if not chosen then
        local hex = str:match("^#?(%x%x%x%x%x%x)$")
        if hex then
            chosen = Color3.fromRGB(
                tonumber(hex:sub(1,2), 16),
                tonumber(hex:sub(3,4), 16),
                tonumber(hex:sub(5,6), 16)
            )
        end
    end

    if not chosen then
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

        local normalized = str:gsub("%s+", "")
        chosen = color_mapper[normalized] or color_mapper[str]
    end

    if not chosen then return g.notify("Error", "Invalid color: "..tostring(input), 5) end
    change_vehicle_color(chosen, get_vehicle())
end

g.RGB_Vehicle = g.RGB_Vehicle or function(state)
    local lib = g.FlamesLibrary
    if state == true then
        if g.Rainbow_Vehicle then
            return g.notify("Warning", "Flames Hub | Rainbow Vehicle is already enabled.", 5)
        end

        g.Rainbow_Vehicle = true
        g.notify("Success", "Flames Hub | Rainbow Vehicle is now enabled.", 5)
        lib.spawn("rgb_vehicle", "spawn", function()
            while g.Rainbow_Vehicle == true do
                for _, color in ipairs(colors) do
                    change_vehicle_color(color, get_vehicle())
                    fw(0)
                end
                g.RunService.Heartbeat:Wait()
            end
        end)
    elseif state == false then
        if not g.Rainbow_Vehicle then
            return g.notify("Warning", "Flames Hub | Rainbow Vehicle is not enabled.", 5)
        end

        getgenv().Rainbow_Vehicle = false
        lib.disconnect("rgb_vehicle")
        g.notify("Success", "Flames Hub | Rainbow Vehicle is now disabled.", 5)
    end
end

g.two_color_switcher_FE_func = g.two_color_switcher_FE_func or function(state)
    local lib = g.FlamesLibrary
    if state == true then
        if g.two_tone_vehicle_colors_changing then
            return g.notify("Warning", "Two Color Switcher already enabled.", 5)
        end

        g.two_tone_vehicle_colors_changing = true
        local c1 = colors[math.random(1,#colors)]
        local c2 = colors[math.random(1,#colors)]
        while c1 == c2 do c2 = colors[math.random(1,#colors)] end
        g.notify("Success", "Flames Hub | Two Tone Vehicle is now enabled.", 5)
        lib.spawn("two_color_vehicle","spawn",function()
            while g.two_tone_vehicle_colors_changing == true do
                fw(0.1)
                change_vehicle_color(c1, get_vehicle())
                wait(.1)
                change_vehicle_color(c2, get_vehicle())
                wait(.1)
                g.RunService.Heartbeat:Wait()
            end
        end)
    elseif state == false then
        if not g.two_tone_vehicle_colors_changing then
            return g.notify("Warning", "Two Color Switcher not enabled.", 5)
        end

        g.two_tone_vehicle_colors_changing = false
        lib.disconnect("two_color_vehicle")
        g.notify("Success", "Flames Hub | Two Tone Vehicle is now disabled.", 5)
    end
end

g.find_vehicles_folder_Life_Together_RP = g.find_vehicles_folder_Life_Together_RP or function()
    local cached = g.vehicles_folder_instance_Life_Together_RP
    if cached and cached.Parent and cached:IsA("Folder") then return cached end
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Folder") and v.Name:lower():find("vehicles") then
            g.vehicles_folder_instance_Life_Together_RP = v
            return v
        end
    end

    return nil
end

if not g.vehicles_folder_instance_Life_Together_RP then pcall(function() g.find_vehicles_folder_Life_Together_RP() end) end
local function init_vehicle_esp()
    g.vehicle_esp_highlights = g.vehicle_esp_highlights or {}
    g.vehicle_esp_connections = g.vehicle_esp_connections or {}
    local highlights = g.vehicle_esp_highlights
    local connections = g.vehicle_esp_connections
    local vehiclesFolder = g.vehicles_folder_instance_Life_Together_RP or Workspace:FindFirstChild("Vehicles")
    local function clearESP(model)
        local hl = highlights[model]
        if hl then
            pcall(function()
                hl:Destroy()
            end)
            highlights[model] = nil
        end
        local conn = connections[model]
        if conn then
            pcall(function()
                conn:Disconnect()
            end)
            connections[model] = nil
        end
    end

    local function applyESP(model)
        if not model or not model:IsA("Model") then return end
        if highlights[model] then return end
        local hl = Instance.new("Highlight")
        hl.Adornee = model
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0
        hl.Parent = model

        highlights[model] = hl
        connections[model] = model.AncestryChanged:Connect(function(_, parent)
            if not parent then
                clearESP(model)
            end
        end)
    end

    g.vehicle_esp_toggle = g.vehicle_esp_toggle or function(toggled)
        if not vehiclesFolder then return end
        if toggled == true then
            if g.vehicle_esp_is_enabled then return g.notify("Warning", "Vehicle ESP is already enabled.", 5) end
            g.vehicle_esp_is_enabled = true
            for _, v in ipairs(vehiclesFolder:GetChildren()) do applyESP(v) end
            if g.vehicle_esp_folderAdded then
                g.vehicle_esp_folderAdded:Disconnect()
                g.vehicle_esp_folderAdded = nil
            end
            if g.vehicle_esp_folderRemoved then
                g.vehicle_esp_folderRemoved:Disconnect()
                g.vehicle_esp_folderRemoved = nil
            end

            g.vehicle_esp_folderAdded = vehiclesFolder.ChildAdded:Connect(function(child)
                applyESP(child)
            end)
            g.vehicle_esp_folderRemoved = vehiclesFolder.ChildRemoved:Connect(function(child)
                clearESP(child)
            end)
        elseif toggled == false then
            if not g.vehicle_esp_is_enabled then return g.notify("Warning", "Vehicle ESP is not enabled.", 5) end
            g.vehicle_esp_is_enabled = false
            for model in pairs(highlights) do clearESP(model) end
            if g.vehicle_esp_folderAdded then
                pcall(function()  g.vehicle_esp_folderAdded:Disconnect() end)
                g.vehicle_esp_folderAdded = nil
            end

            if g.vehicle_esp_folderRemoved then
                pcall(function() g.vehicle_esp_folderRemoved:Disconnect() end)
                g.vehicle_esp_folderRemoved = nil
            end
        end
    end
end
fw(0.1)
init_vehicle_esp()

g.RGB_Vehicle_Others = g.RGB_Vehicle_Others or function(Player, state)
    local lib = g.FlamesLibrary
    if not Player then return end
    local name = "rgb_other_"..Player.UserId
    local PlayersName = Player.Name

    if state == true then
        if lib.is_alive(name) then
            return g.notify("Warning", "RGB Vehicle is already enabled for: "..PlayersName, 5)
        end

        g.notify("Success", "Enabled Rainbow Vehicle for: "..tostring(PlayersName), 5)
        lib.spawn(name,"spawn",function()
            while true do
                if not Player or not Player.Parent then
                    lib.disconnect(name)
                    return g.notify("Error", PlayersName.." has left the game.", 5)
                end

                local vehicle = get_other_vehicle(Player)
                if not vehicle then
                    wait(.2)
                end

                if vehicle:GetAttribute("locked") == true then
                    lib.disconnect(name)
                    return
                end

                for _, color in ipairs(colors) do
                    change_vehicle_color(color, Player)
                    wait(.2)
                end
            end
        end)
    elseif state == false then
        if not lib.is_alive(name) then return end
        lib.disconnect(name)
    end
end

g.copy_emote_plr = g.copy_emote_plr or function(player)
    local targetChar = player.Character or g.get_char(player)
    local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid") or get_human(player)
    local myChar = g.Character or get_char(LocalPlayer)
    local myHum = g.Humanoid or get_human(LocalPlayer) or myChar and myChar:FindFirstChildOfClass("Humanoid")
    if not (targetHum and myHum) then return end
    for _, track in ipairs(myHum:GetPlayingAnimationTracks()) do
        pcall(function()
            track:Stop()
        end)
    end
    wait(0.05)
    for _, tTrack in ipairs(targetHum:GetPlayingAnimationTracks()) do
        local animObj = tTrack.Animation

        if animObj then
            local id = tostring(animObj.AnimationId)

            if id and id ~= "" and id ~= "0" and not id:find("507768375") then
                local newAnim = Instance.new("Animation")
                newAnim.AnimationId = id
                local myTrack = nil
                pcall(function()
                    myTrack = myHum:LoadAnimation(newAnim)
                end)

                if myTrack then
                    myTrack:Play(0.1, 1, tTrack.Speed)
                    myTrack.TimePosition = tTrack.TimePosition

                    g.TrackHasBeenStopped_Watcher_Task = g.TrackHasBeenStopped_Watcher_Task or task.spawn(function()
                        tTrack.Stopped:Wait()
                        pcall(function() myTrack:Stop() end)
                        pcall(function() myTrack:Destroy() end)
                        pcall(function() newAnim:Destroy() end)
                    end)
                else
                    newAnim:Destroy()
                end
            end
        end
    end
end

g.get_emote_properties_and_insert_properties = g.get_emote_properties_and_insert_properties or function()
    local hum = g.Humanoid or g.Character:FindFirstChildWhichIsA("Humanoid")
    if not hum then return end
    local tracks = hum:GetPlayingAnimationTracks()
    if #tracks == 0 then return g.notify("Error", "You're not playing an Animation.", 5) end
    local track = tracks[1]
    local anim = track.Animation
    if not anim then return g.notify("Error", "Your animation unexpectedly disappeared?", 5) end
    local animId = tostring(anim.AnimationId)
    local realId = tonumber(animId:match("%d+"))
    if not realId then return end

    table.insert(g.currently_saved_emotes_list, {
        Id = realId,
        AssetId = realId,
        Name = track.Name ~= "" and track.Name or "Unknown",
        AnimationId = "rbxassetid://" .. realId,
        Favorite = false
    })
end

g.save_copied_plrs_emote = g.save_copied_plrs_emote or function()
    if g.currently_saved_emotes_list and g.saveEmotesToData then
        notify("Info", "Saving currently playing emote, please wait.", 2.5)
        g.get_emote_properties_and_insert_properties()
        fw(0.1)
        g.saveEmotesToData()
        wait()
        notify("Success", "Saved currently playing emote.", 3)
    else
        if g.FreeEmotes_Enabled then
            return g.notify("Warning", "You already have Flames Emoting GUI loaded!", 6)
        end
        if CoreGui:FindFirstChild("FlamesEmoteGUI") then
            return g.notify("Warning", "You already have Flames Emoting GUI loaded!", 6)
        end

        g.FreeEmotes_Enabled = true
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Emotes_Backup.lua"))()
        wait(1)
        g.notify("Info", "Try the command again, you did not have our Free Emotes GUI loaded.", 15)
        wait(1)
        while not CoreGui:FindFirstChild("FlamesEmoteGUI", true) do task.wait(0.1) end
        local gui = CoreGui:FindFirstChild("FlamesEmoteGUI", true)
        if gui and gui:IsA("ScreenGui") then
            local Frame_Find = gui:FindFirstChildOfClass("Frame")
            if Frame_Find and Frame_Find.Parent then
                Frame_Find.Visible = false
            end
        end
    end
end

g.mutesounds = g.mutesounds or function()
    for _,v in ipairs(Placed_Models:GetDescendants()) do
        if v:IsA("Sound") then
            local n = v.Name
            if n == "SoundDefault" or n == "Music" or n == "Airhorn" then
                v.Volume = 0
            elseif n == "Sound" and v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "BoomBox" then
                v.Volume = 0
            end
        end
    end

    for _,p in ipairs(g.Players:GetPlayers()) do
        local c = p.Character or get_char(p, 3)

        if c then
            for _,v in ipairs(c:GetDescendants()) do
                if v:IsA("Sound") then
                    if v.Name == "Sound" and v.Parent and v.Parent.Parent and v.Parent.Parent:IsA("Tool") and v.Parent.Parent.Name == "BoomBox" then
                        v.Volume = 0
                    end
                end
            end
        end
    end
end

g.unmutesounds = g.unmutesounds or function()
    for _,v in ipairs(Placed_Models:GetDescendants()) do
        if v:IsA("Sound") then
            local n = v.Name
            if n == "SoundDefault" or n == "Music" or n == "Airhorn" then
                v.Volume = 1
            elseif n == "Sound" and v.Parent and v.Parent.Parent and v.Parent.Parent.Name == "BoomBox" then
                v.Volume = 0.5
            end
        end
    end

    for _,p in ipairs(g.Players:GetPlayers()) do
        local c = p.Character or get_char(p, 3)

        if c then
            for _,v in ipairs(c:GetDescendants()) do
                if v:IsA("Sound") then
                    if v.Name == "Sound" and v.Parent and v.Parent.Parent and v.Parent.Parent:IsA("Tool") and v.Parent.Parent.Name == "BoomBox" then
                        v.Volume = 0.5
                    end
                end
            end
        end
    end

    g.notify("Success", "Unmuted all tools.", 5)
end

g.mute_all_tools = g.mute_all_tools or function(toggle)
    if toggle == true then
        if g.autosilence then
            return notify("Warning", "Tool muter is already enabled.", 5)
        end

        g.autosilence = true
        notify("Success", "Tool muter is enabled.", 5)

        g.Muting_All_Tool_Sounds_Task = task.spawn(function()
            while g.autosilence == true do
                wait(1)
                mutesounds()
            end
        end)
    elseif toggle == false then
        if not g.autosilence then
            return notify("Warning", "Tools muter is not enabled.", 5)
        end

        if g.Muting_All_Tool_Sounds_Task then
            task.cancel(g.Muting_All_Tool_Sounds_Task)
            g.Muting_All_Tool_Sounds_Task = nil
        end

        g.autosilence = false
        wait(1)
        if not g.autosilence then
            notify("Info", "Making all the tools Volume: 1...", 5)
            unmutesounds()
        else
            notify("Warning", "Tools muter is not disabled yet, hold on...", 3)
            repeat task.wait() until not g.autosilence or g.autosilence == false
            wait(1.5)
            if not g.autosilence then
                notify("Success", "Unmuting all Tools...", 5)
                wait(0.5)
                unmutesounds()
                wait(0.5)
                notify("Success", "Unmuted all Tools.", 5)
            end
        end
    else
        return 
    end
end

g.find_skin_body_colors_in_char = g.find_skin_body_colors_in_char or function(char)
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BodyColors") then
            return v
        end

        local name = v.Name:lower()
        if name:find("body") and name:find("color") then
            return v
        end
    end

    return nil
end

g.original_skintone = g.original_skintone or nil
g.rainbow_skin = g.rainbow_skin or function(state)
    local lib = g.FlamesLibrary
    local name = "rainbow_skin"
    local char = g.Character or get_char(LocalPlayer, 10)
    if not char then return end
    local bodycolors = char and char:FindFirstChildOfClass("BodyColors")
    if not bodycolors then return end
    if state == true then
        if g.rainbow_skintone_currently_enabled then
            return g.notify("Warning", "Flames Hub - Rainbow Skin is already enabled.", 5)
        end

        g.original_skintone = {
            HeadColor3 = bodycolors.HeadColor3,
            LeftArmColor3 = bodycolors.LeftArmColor3,
            RightArmColor3 = bodycolors.RightArmColor3,
            LeftLegColor3 = bodycolors.LeftLegColor3,
            RightLegColor3 = bodycolors.RightLegColor3,
            TorsoColor3 = bodycolors.TorsoColor3
        }

        g.notify("Success", "Flames Hub | Rainbow Skin is now enabled.", 5)
        lib.spawn(name,"spawn",function()
            while true do
                for _, c in ipairs(colors) do
                    send_remote("skin_tone", c)
                    wait(.1)
                end
            end
        end)
    elseif state == false then
        if not lib.is_alive(name) then return end
        lib.disconnect(name)
        fw(0.2)
        if g.original_skintone then
            local old = g.original_skintone

            send_remote("skin_tone", old.HeadColor3)
            wait()
            send_remote("skin_tone", old.LeftArmColor3)
            wait()
            send_remote("skin_tone", old.RightArmColor3)
            wait()
            send_remote("skin_tone", old.LeftLegColor3)
            wait()
            send_remote("skin_tone", old.RightLegColor3)
            wait()
            send_remote("skin_tone", old.TorsoColor3)
            g.notify("Success", "Reset SkinTone back to your old SkinTone.", 3)
        end

        g.notify("Success", "Flames Hub | Rainbow Skin is now disabled.", 5)
    end
end

g.two_tone_skin = g.two_tone_skin or function(state)
    local lib = g.FlamesLibrary
    local fw = lib.wait
    local name = "two_tone_skin"
    local char = g.Character or get_char(LocalPlayer, 10)
    if not char then return end
    local bodycolors = char:FindFirstChildOfClass("BodyColors")
    if not bodycolors then return end

    if state == true then
        if g.Two_Tone_Skin_Tone_Loop_Toggled then
            return g.notify("Warning", "Two Tone Skin is already enabled.", 5)
        end

        g.original_skintone = {
            HeadColor3 = bodycolors.HeadColor3,
            LeftArmColor3 = bodycolors.LeftArmColor3,
            RightArmColor3 = bodycolors.RightArmColor3,
            LeftLegColor3 = bodycolors.LeftLegColor3,
            RightLegColor3 = bodycolors.RightLegColor3,
            TorsoColor3 = bodycolors.TorsoColor3
        }
        local c1 = colors[math.random(1, #colors)]
        local c2 = colors[math.random(1, #colors)]
        while c2 == c1 do c2 = colors[math.random(1, #colors)] end
        g.notify("Success", "Flames Hub | Two Tone Skin is now enabled.", 5)
        g.Two_Tone_Skin_Tone_Loop_Toggled = true
        lib.spawn(name, "spawn", function()
            while g.Two_Tone_Skin_Tone_Loop_Toggled == true do
                fw(0.1)
                g.Send("skin_tone", c1)
                fw(0.1)
                g.Send("skin_tone", c2)
            end
        end)
    elseif state == false then
        if not g.Two_Tone_Skin_Tone_Loop_Toggled then return g.notify("WArning", "Two Tone Skin is not enabled.", 5) end
        lib.disconnect(name)
        wait(0.25)
        if g.original_skintone then
            local old = g.original_skintone
            g.Send("skin_tone", old.HeadColor3)
            wait()
            g.Send("skin_tone", old.LeftArmColor3)
            wait()
            g.Send("skin_tone", old.RightArmColor3)
            wait()
            g.Send("skin_tone", old.LeftLegColor3)
            wait()
            g.Send("skin_tone", old.RightLegColor3)
            wait()
            g.Send("skin_tone", old.TorsoColor3)
            g.notify("Success", "Reset skintone back to original.", 3)
        end

        g.notify("Success", "Flames Hub | Two Tone Skin is now disabled.", 5)
    end
end

local Amount_Input = 5
g.set_fire_amount_FE = g.set_fire_amount_FE or function(amount)
    amount = tonumber(amount)
    if not amount then Amount_Input = 5 return end
    Amount_Input = amount
end

local Old_Name_From_Name_Spammer
g.name_changer_premium = g.name_changer_premium or function(state)
    local lib = g.FlamesLibrary
    local name = "name_spammer"
    local words = {
        "root_access","packet_inject","xor_key","decrypting",
        "init_stealth","spoof_id","kernel_hook","bruteforce",
        "sys_reboot","net_breach","ghost_mode","backdoor_init"
    }

    if state == true then
        if g.Name_Spammer_Currently_Enabled then return getgenv().notify("Warning", "Flames Hub | Name Spammer is already enabled.", 5) end
        g.Name_Spammer_Currently_Enabled = true
        Old_Name_From_Name_Spammer = g.LocalPlayer:GetAttribute("roleplay_name") or "SERVER"
        local index = 1
        local count = #words

        lib.spawn(name, "spawn", function()
            while g.Name_Spammer_Currently_Enabled == true do
                g.Send("roleplay_name", words[index])
                index = index + 1
                if index > count then index = 1 end
                fw(0)
            end
        end)

        g.notify("Success", "Name Spammer is now enabled.", 3)
    elseif state == false then
        if not g.Name_Spammer_Currently_Enabled then
            return getgenv().notify("Warning", "Flames Hub | Name Spammer is not enabled.", 5)
        end
        getgenv().Name_Spammer_Currently_Enabled = false
        lib.disconnect(name)
        fw(0.1)
        g.Send("roleplay_name", tostring(Old_Name_From_Name_Spammer))
        g.notify("Success", "Name Spammer is now disabled.", 3)
    end
end

g.spectate_plr_without_distance_limits = g.spectate_plr_without_distance_limits or function(plr)
    function spectatePlayer(targetPlayer)
        if not targetPlayer then return end

        spectateTarget = targetPlayer
        spectateSubject = nil
        originalIO.disconnectSpectateConns()

        local function setCamToCharacter(character)
            if spectateTarget ~= targetPlayer or not character then return end
            local hum = getPlrHum(character) or getHum(character, 5)
            local subj = hum or getRoot(character)
            if not subj then return end
            spectateSubject = subj
            originalIO.ensureCam()
            originalIO.hookCameraGuard()
        end

        setCamToCharacter(targetPlayer.Character)
        spectateConns.char = g.FlamesLibrary.connect("spectate_char", targetPlayer.CharacterAdded:Connect(function(character)
            if spectateTarget ~= targetPlayer then return end
            setCamToCharacter(character)
        end))

        spectateConns.leave = NAlib.connect("spectate_leave", Players.PlayerRemoving:Connect(function(player)
            if player == targetPlayer and spectateTarget == targetPlayer then
                cleanup(true)
                DebugNotif("Player left - camera reset")
            end
        end))

        spectateConns.loop = NAlib.connect("spectate_loop", RunService.RenderStepped:Connect(function()
            if spectateTarget ~= targetPlayer then return end
            local char = targetPlayer.Character
            if not char or not char.Parent then return end
            if not spectateSubject or spectateSubject.Parent ~= char then
                setCamToCharacter(char)
            else
                originalIO.ensureCam()
            end
        end))
    end

    spectatePlayer(plr)
end

local View_Outfit_State_Toggle = g.LocalPlayer:GetAttribute("hide_view_outfit") or true
g.anti_outfit_copier = function(toggle)
    if toggle == true then
        if g.anti_outfit_stealer then
            return notify("Error", "Anti Outfit Stealer is already enabled!", 5)
        end
        if g.FlamesLibrary.is_alive("AntiFitStealerConn") then
            return notify("Error", "Anti Outfit Stealer is already enabled! [connection]", 5)
        end

        g.notify("Success", "Flames Hub | Anti Outfit Stealer is now active.", 7)
        local lib = getgenv().FlamesLibrary
        g.ToggleAntiFit_Stealer = g.ToggleAntiFit_Stealer or function(state)
            if not state then
                g.anti_outfit_stealer = false
                lib.disconnect("AntiFitStealerConn")
                local hide_outfit_toggle = g.LocalPlayer:GetAttribute("hide_view_outfit")
                if hide_outfit_toggle and hide_outfit_toggle == false then
                    g.Send("hide_view_outfit", true)
                    notify("Success", "hide_view_outfit setting changed, reverted change (keep it on).", 3)
                end
            else
                g.anti_outfit_stealer = true
                g.Send("bio", "`~ Flames Hub Anti Stealer Is Enabled ~`")
            end

            local last_check = 0
            local target_bio = "`~ Flames Hub Anti Stealer Is Enabled ~`"
            lib.connect("AntiFitStealerConn", g.RunService.Heartbeat:Connect(function()
                local now = tick()
                if now - last_check < 0.4 then return end
                last_check = now

                local hide_outfit_toggle = g.LocalPlayer:GetAttribute("hide_view_outfit")
                if hide_outfit_toggle and hide_outfit_toggle == false then
                    g.Send("hide_view_outfit", true)
                    notify("Success", "hide_view_outfit setting changed, reverted change (keep it on).", 3)
                end

                if g.anti_outfit_stealer then
                    local current_bio = g.LocalPlayer:GetAttribute("bio")
                    if current_bio ~= target_bio then
                        g.Send("bio", target_bio)
                        notify("Success", "Bio was changed, reverted back.", 3)
                    end
                end
            end))
        end
        fw(0.1)
        g.ToggleAntiFit_Stealer(true)
    elseif toggle == false then
        if not g.anti_outfit_stealer then
            return notify("Error", "Anti Outfit Copier is not enabled!", 5)
        end

        g.anti_outfit_stealer = false
        g.FlamesLibrary.disconnect("AntiFitStealerConn")
        g.ToggleAntiFit_Stealer(false)
        notify("Success", "Disabled Anti Outfit Stealer.", 5)
    else
        return
    end
end

local upvalues_func_main = getupvalue or getupvalues or debug.getupvalues
local get_proto_func = getproto or debug.getproto or getprotos
g.hook_meta_main = g.hook_meta_main or function(obj, metamethod, func)
    if not getrawmetatable then return end
    local old = getrawmetatable and getrawmetatable(obj)

    if hookfunction then
        return hookfunction(old[metamethod],func)
    else
        local oldmetamethod = old[metamethod]
        if makewriteable then
            makewriteable(old)
        end
        old[metamethod] = func
        if makereadonly then
            makereadonly(old)
        end
        return oldmetamethod
    end
end

g.find_messages_modulescript = g.find_messages_modulescript or function()
    if g.Messages_Module_Found_Loc then
        return g.Messages_Module_Found_Loc
    end

    local reps = g.ReplicatedStorage or safe_wrapper("ReplicatedStorage")
    if not reps then return nil end
    local found = reps:FindFirstChild("Messages", true)
    if found and found:IsA("ModuleScript") then
        g.Messages_Module_Found_Loc = found
    end

    return g.Messages_Module_Found_Loc
end

g.find_UI_modulescript = g.find_UI_modulescript or function()
    if g.UI_Module_Main then
        return g.UI_Module_Main
    end

    local reps = g.ReplicatedStorage or safe_wrapper("ReplicatedStorage")
    if not reps then return nil end
    local found = reps:FindFirstChild("UI", true)
    if found and found:IsA("ModuleScript") then
        g.UI_Module_Main = found
    end

    return g.UI_Module_Main
end

g.find_RateLimiter_modulescript = g.find_RateLimiter_modulescript or function()
    if g.RateLimiter_Module_Main then
        return g.RateLimiter_Module_Main
    end

    local reps = g.ReplicatedStorage or safe_wrapper("ReplicatedStorage")
    if not reps then return nil end
    local found = reps:FindFirstChild("RateLimiter", true)
    if found and found:IsA("ModuleScript") then
        g.RateLimiter_Module_Main = found
    end

    return g.RateLimiter_Module_Main
end

if not g.RateLimiter_Bypass_Applied then
    if get_proto_func and upvalues_func_main and require then
        local ok, err = pcall(function()
            local message_module = g.Messages_Module_Found_Loc
                and require(g.Messages_Module_Found_Loc)
                or require(find_messages_modulescript())
            local rate_limiter = upvalues_func_main(get_proto_func(message_module.loaded, 4, true)[1], 5)
            if typeof(rate_limiter) == "table" and rate_limiter.is_limited then
                rate_limiter.is_limited = function() return false end
                g.RateLimiter_Bypass_Applied = true
                g.RateLimiter_Bypass_Applied_Method_2 = true
            end
        end)
        if not ok then
            warn("RateLimiter bypass method failed unexpectedly.")
        end
    end
end

g.spam_sign_text = g.spam_sign_text or function(toggle)
    local Character = g.Character
    local PlacedModels = Workspace:WaitForChild("PlacedModels")
    local random_words = {
        "yo","wsg bro","aye","lit","fire"
    }
    local function find_tool_partial(toolName)
        if not toolName then return nil end
        local query = toolName:lower()

        for _, v in ipairs(PlacedModels:GetChildren()) do
            if v:IsA("Model") and v.Name:lower() == query then
                local ownerAttr = v:GetAttribute("owner_id")
                if ownerAttr and tostring(ownerAttr) == tostring(LocalPlayer.UserId) then
                return v
                end
            end
        end

        for _, v in ipairs(Character:GetChildren()) do
            if v.Name:lower() == query then
                return v
            end
        end

        return nil
    end

    if toggle == true then
        if g.ToolChanger_FE then return notify("Warning", "Sign Spammer is already enabled!", 5) end
        g.ToolChanger_FE = true

        g.Sign_ChangeText_Fast_Loop_Task = task.spawn(function()
            while g.ToolChanger_FE == true do
                local tool = find_tool_partial("sign")
                if not tool then
                    g.Send("get_tool", "Sign")
                    fw(0.1)
                else
                    for _, word in ipairs(random_words) do
                        if not g.ToolChanger_FE then break end
                        g.Send("change_sign", tool, tostring(word))
                        fw(0)
                    end
                end
                fw(0.1)
            end
        end)
    elseif toggle == false then
        if g.Sign_ChangeText_Fast_Loop_Task then
            task.cancel(g.Sign_ChangeText_Fast_Loop_Task)
            g.Sign_ChangeText_Fast_Loop_Task = nil
        end
        g.ToolChanger_FE = false
    else
        return 
    end
end

g.AutoLockConnection = g.AutoLockConnection or nil
g.ToggleAutoLock = g.AutoLockConnection or function(state)
    if not state then
        g.AutoLockOn = false
        if g.AutoLockConnection then
            g.AutoLockConnection:Disconnect()
            g.AutoLockConnection = nil
        end

        local car = get_vehicle()
        if car and car:GetAttribute("locked") == true then
            lock_vehicle(car)
            g.notify("Success", "Flames Hub | Auto Lock Vehicle is now disabled.", 5)
        else
            g.notify("Warning", "Flames Hub | Auto Lock Vehicle is now disabled, vehicle not found.", 5)
        end
        return 
    else
        local car = get_vehicle()
        if not car then return getgenv().notify("Error", "Vehicle not found, spawn one!", 5) end
        g.AutoLockOn = true
    end

    g.notify("Success", "Flames Hub | Auto Lock Vehicle is now enabled.", 5)
    g.AutoLockConnection = g.RunService.Heartbeat:Connect(function()
        if tick() - (g._lastLockCheck or 0) < 1 then return end
        g._lastLockCheck = tick()
        
        local car = get_vehicle()
        if car and car:GetAttribute("locked") ~= true then
            lock_vehicle(car)
        end
    end)
end

if not g.player_esp_core then
    g.player_esp_core = true
    local players = g.Players or game:GetService("Players")
    local localplayer = g.LocalPlayer or players.LocalPlayer
    local esp_objects = {}
    g.Flames_Hub_Player_ESP_Core_Has_Been_Enabled = false
    local function wait_character(plr)
        local character = plr.Character
        while g.Flames_Hub_Player_ESP_Core_Has_Been_Enabled and plr.Parent and (not character or not character.Parent) do
            character = plr.Character
            g.heartbeat_wait_function(6)
        end
        return character
    end

    local function remove_esp(plr)
        if esp_objects[plr] then
            esp_objects[plr]:Destroy()
            esp_objects[plr] = nil
        end
    end

    local function apply_esp(plr)
        if not g.Flames_Hub_Player_ESP_Core_Has_Been_Enabled then return end
        if plr == localplayer then return end
        task.spawn(function()
            local character = wait_character(plr)
            if not g.Flames_Hub_Player_ESP_Core_Has_Been_Enabled or not character then return end
            remove_esp(plr)
            local highlight = Instance.new("Highlight")
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Adornee = character
            highlight.Parent = character
            esp_objects[plr] = highlight
        end)
    end

    local function track_player(plr)
        apply_esp(plr)
        FlamesLibrary.connect("esp_char_" .. tostring(plr.UserId), plr.CharacterAdded:Connect(function(new_char)
            if plr == localplayer then return end
            while g.Flames_Hub_Player_ESP_Core_Has_Been_Enabled and new_char and not new_char.Parent do
                task.wait()
            end
            apply_esp(plr)
        end))
    end

    local function untrack_player(plr)
        remove_esp(plr)
        FlamesLibrary.disconnect("esp_char_" .. tostring(plr.UserId))
    end

    g.enable_player_esp = function()
        if g.Flames_Hub_Player_ESP_Core_Has_Been_Enabled then
            return g.notify("Warning", "Flames Hub Player ESP is already enabled.", 5)
        end
        g.Flames_Hub_Player_ESP_Core_Has_Been_Enabled = true
        for _, plr in ipairs(players:GetPlayers()) do
            track_player(plr)
        end
        FlamesLibrary.connect("esp_playeradded", players.PlayerAdded:Connect(track_player))
        FlamesLibrary.connect("esp_playerremoving", players.PlayerRemoving:Connect(untrack_player))
    end

    g.disable_player_esp = function()
        if not g.Flames_Hub_Player_ESP_Core_Has_Been_Enabled then
            return g.notify("Warning", "Flames Hub Player ESP is not enabled.", 6)
        end
        g.Flames_Hub_Player_ESP_Core_Has_Been_Enabled = false
        for plr in pairs(esp_objects) do
            remove_esp(plr)
        end
        FlamesLibrary.disconnect("esp_playeradded")
        FlamesLibrary.disconnect("esp_playerremoving")
    end
end

if Drawing and not g.tracer_core_initialized then
    g.tracer_core_initialized = true
    local players = g.Players or game:GetService("Players")
    local runservice = g.RunService or game:GetService("RunService")
    local camera = workspace.CurrentCamera
    local localplayer = g.LocalPlayer or g.Players.LocalPlayer or players.LocalPlayer
    local tracer_objects = {}
    g.tracer_esp_currently_running_flag_Flames_Hub = false
    if g.disable_tracers and typeof(g.disable_tracers) == "function" then
        pcall(function() g.disable_tracers() end)
    end
    local function remove_tracer(plr)
        if tracer_objects[plr] then
            tracer_objects[plr]:Remove()
            tracer_objects[plr] = nil
        end
    end

    local function create_tracer(plr)
        if plr == localplayer then return end
        while g.tracer_esp_currently_running_flag_Flames_Hub and not plr.Parent do
            task.wait()
        end
        if not g.tracer_esp_currently_running_flag_Flames_Hub then return end
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Transparency = 1
        line.Visible = false
        tracer_objects[plr] = line
    end

    local function update_tracers()
        if not g.tracer_esp_currently_running_flag_Flames_Hub then
            pcall(function() g.disable_tracers() end)
            return 
        end
        local view = camera.ViewportSize
        for plr, line in pairs(tracer_objects) do
            local character = plr.Character or get_char(plr, 1)
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root then
                local pos, onscreen = camera:WorldToViewportPoint(root.Position)
                if onscreen then
                    line.Visible = true
                    line.From = Vector2.new(view.X / 2, view.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end
    end

    g.enable_tracers = function()
        if g.tracer_esp_currently_running_flag_Flames_Hub then
            return g.notify("Warning", "Tracer ESP is already enabled!", 5)
        end
        g.tracer_esp_currently_running_flag_Flames_Hub = true
        for _, plr in ipairs(players:GetPlayers()) do
            create_tracer(plr)
        end
        FlamesLibrary.connect("tracer_render", runservice.RenderStepped:Connect(update_tracers))
        FlamesLibrary.connect("tracer_playeradded", players.PlayerAdded:Connect(create_tracer))
        FlamesLibrary.connect("tracer_playerremoving", players.PlayerRemoving:Connect(remove_tracer))
    end

    g.disable_tracers = function()
        if not g.tracer_esp_currently_running_flag_Flames_Hub then
            return g.notify("Warning", "Tracer ESP is not enabled!", 5)
        end
        g.tracer_esp_currently_running_flag_Flames_Hub = false
        for plr in pairs(tracer_objects) do
            remove_tracer(plr)
        end
        FlamesLibrary.disconnect("tracer_render")
        FlamesLibrary.disconnect("tracer_playeradded")
        FlamesLibrary.disconnect("tracer_playerremoving")
    end
end
wait(0.25)
if g.RateLimiter_Bypass_Applied then
    if g.RateLimiter_Bypass_Applied_Method_1 then
        notify("Success", "RateLimiter bypass applied with method 1.", 10)
    elseif g.RateLimiter_Bypass_Applied_Method_2 then
        notify("Success", "RateLimiter bypass applied with method 2.", 10)
    elseif g.RateLimiter_Bypass_Applied_Method_3 then
        notify("Success", "RateLimiter bypass applied with method 3.", 10)
    else
        notify("Warning", "We we're unable to apply any RateLimiter bypass.", 10)
    end
else
    notify("Warning", "Not sure if RateLimiter bypass was applied or not.")
end

g.WalkFlingWhitelist = g.WalkFlingWhitelist or {}
g.walkflinging = g.walkflinging or false
g.WalkFlingConnections = g.WalkFlingConnections or {}
g.TouchingWhitelisted = g.TouchingWhitelisted or {}
g.AddToWalkFlingWhitelist = g.AddToWalkFlingWhitelist or function(user)
    local userid = g.ToUserId(user)
    if not userid then
        return notify("Warning", "That player is invalid or has left the game.", 5)
    end
    if g.WalkFlingWhitelist[userid] then
        return notify("Warning", "That player is already in the WalkFling Whitelist.", 5)
    end
    g.WalkFlingWhitelist[userid] = true
    return notify("Success", "Added to WalkFling Whitelist.", 5)
end

g.RemoveFromWalkFlingWhitelist = g.RemoveFromWalkFlingWhitelist or function(user)
    local userid = g.ToUserId(user)
    if not userid then
        return notify("Warning", "That player is invalid or has left the game.", 5)
    end
    if not g.WalkFlingWhitelist[userid] then
        return notify("Warning", "That player is not in the WalkFling Whitelist.", 5)
    end
    g.WalkFlingWhitelist[userid] = nil
    return notify("Success", "Removed from WalkFling Whitelist.", 5)
end

g.is_whitelisted = g.is_whitelisted or function(plr)
    if not plr then return false end
    return g.WalkFlingWhitelist[plr.UserId] == true
end

g.stop_walkfling = g.stop_walkfling or function()
    if not g.walkflinging then
        return notify("Error", "Flames Hub | WalkFling-V3.5 is not enabled.", 5)
    end

    g.walkflinging = false
    g.TouchingWhitelisted = {}
    g.FlamesLibrary.disconnect("walkflinger")
    for _, conn in pairs(g.WalkFlingConnections) do conn:Disconnect() end
    g.WalkFlingConnections = {}
    if g.WalkFlingRespawnConn then
        g.WalkFlingRespawnConn:Disconnect()
        g.WalkFlingRespawnConn = nil
    end

    if g.Noclip_Enabled then g.Toggleable_Noclip(false) end
    local root = g.HumanoidRootPart
    if root then root.Velocity = Vector3.zero end
    local hum = g.Humanoid or get_human(LocalPlayer or game.Players.LocalPlayer) or g.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    g.notify("Success", "Flames Hub | WalkFling-V3.5 has been stopped/disabled.", 5)
end

g.start_walkfling = g.start_walkfling or function()
    if g.walkflinging then
        return notify("Warning", "Flames Hub | WalkFling-V3.5 is already enabled!", 5)
    end

    g.walkflinging = true
    g.TouchingWhitelisted = {}
    if not g.Noclip_Enabled then g.Toggleable_Noclip(true) end
    notify("Success", "Flames Hub | WalkFling-V3.5 is now enabled.", 5)
    local lp = g.LocalPlayer or Players.LocalPlayer
    local function connect_touch_fling(character)
        for _, conn in pairs(g.WalkFlingConnections) do conn:Disconnect() end
        g.WalkFlingConnections = {}
        g.TouchingWhitelisted = {}

        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                local touchConn = part.Touched:Connect(function(hit)
                    if not g.walkflinging then return end
                    local hit_char = hit.Parent
                    while hit_char and not Players:GetPlayerFromCharacter(hit_char) and hit_char.Parent ~= workspace do hit_char = hit_char.Parent end
                    local hit_player = Players:GetPlayerFromCharacter(hit_char)
                    if not hit_player or hit_player == lp then return end

                    if g.is_whitelisted(hit_player) then
                        g.TouchingWhitelisted[hit_player.UserId] = true
                        return
                    end

                    if next(g.TouchingWhitelisted) then return end
                    local hit_root = hit_char:FindFirstChild("HumanoidRootPart")
                    if not hit_root then return end
                    local root = g.HumanoidRootPart
                    local v = root and root.CFrame.LookVector or Vector3.zero
                    local power = 10000
                    hit_root.Velocity = v * power + Vector3.new(0, power, 0)
                    RunService.RenderStepped:Wait()
                    if hit_root then hit_root.Velocity = v * power end
                    RunService.RenderStepped:Wait()
                    if hit_root then hit_root.Velocity = v * power + Vector3.new(0, 0.1, 0) end
                end)

                local untouchConn = part.TouchEnded:Connect(function(hit)
                    local hit_char = hit.Parent
                    while hit_char and not Players:GetPlayerFromCharacter(hit_char) and hit_char.Parent ~= workspace do
                        hit_char = hit_char.Parent
                    end
                    local hit_player = Players:GetPlayerFromCharacter(hit_char)
                    if hit_player and g.is_whitelisted(hit_player) then
                        g.TouchingWhitelisted[hit_player.UserId] = nil
                    end
                end)

                table.insert(g.WalkFlingConnections, touchConn)
                table.insert(g.WalkFlingConnections, untouchConn)
            end
        end
    end

    local char = g.Character or get_char(lp, 10)
    if char then connect_touch_fling(char) end
    if g.WalkFlingRespawnConn then
        g.WalkFlingRespawnConn:Disconnect()
        g.WalkFlingRespawnConn = nil
    end
    wait(0.25)
    g.WalkFlingRespawnConn = lp.CharacterAdded:Connect(function(new_char)
        if g.walkflinging then
            connect_touch_fling(new_char)
        end
    end)

    g.FlamesLibrary.disconnect("walkflinger")
    g.FlamesLibrary.connect("walkflinger", RunService.Heartbeat:Connect(function()
        if not g.walkflinging then return end
        local m = g.Character or get_char(lp, 10)
        local r = m and (g.HumanoidRootPart or m:FindFirstChild("HumanoidRootPart"))
        if not r then return end
        local v = r.Velocity
        r.Velocity = v * 10000 + Vector3.new(0, 10000, 0)
        RunService.RenderStepped:Wait()
        if r then r.Velocity = v end
        RunService.RenderStepped:Wait()
        if r then r.Velocity = v + Vector3.new(0, 0.1, 0) end
    end))
end

g.StartWalkFling = g.start_walkfling
g.StopWalkFling = g.stop_walkfling
g.getcharsize = g.getcharsize or function()
    local hum = g.Humanoid
    if not hum then return 5,2 end
    local d = hum:GetAppliedDescription()
    local h = 5 * (d.HeightScale or 1)
    local w = 2 * (d.WidthScale or 1)
    return h,w
end

g.autospinspeed = g.autospinspeed or function(base)
    local h,w = getcharsize()
    return base / h
end

g.change_spin_speed = g.change_spin_speed or function(speed)
    if typeof(speed) ~= "number" then
        if speed then
            return notify("Error", tostring(speed).." isn't a number! Input a number.", 5)
        else
            return notify("Error", "That wasn't a number! Input a number.", 5)
        end
    end
    if g.walkflinging then
        return notify("Error", "Turn off walkfling first for this to work properly.", 10)
    end

    for _, v in ipairs(g.HumanoidRootPart:GetChildren()) do
        if v.Name == "FlamesHub_Spin" then
            v.AngularVelocity = Vector3.new(0, speed, 0)
        end
    end
end

g.LockHouse_LastState = g.LockHouse_LastState or {}
g.LockHomeLoop = g.LockHomeLoop or false
g.get_plot_of_player = g.get_plot_of_player or function(player)
    if not player then 
        return nil, "No player provided" 
    end

    local plotList = PlotMarker and PlotMarker.class and PlotMarker.class.objects
    if type(plotList) ~= "table" then
        return nil, "Plots not available"
    end

    for _, plot in pairs(plotList) do
        if plot 
        and plot.states 
        and plot.states.owner
        and typeof(plot.states.owner.get) == "function"
        and plot.instance
        then
            local ok, owner = pcall(function()
                return plot.states.owner.get()
            end)

            if ok and owner == player then
                return plot.instance, plot
            end
        end
    end

    return nil, "Player has no plot"
end

g.toggle_house_lock = g.toggle_house_lock or function(player)
    local plotInstance = select(1, get_plot_of_player(player))
    if not plotInstance then return end
    g.Send("lock_home", plotInstance)
end

g.is_home_locked = g.is_home_locked or function(player)
    local plotInstance, plotObject = get_plot_of_player(player)
    if not plotObject then
        return nil, "Player has no plot"
    end

    if not plotObject.states 
    or not plotObject.states.locked 
    or typeof(plotObject.states.locked.get) ~= "function"
    then
        return nil, "Locked state unavailable"
    end

    local ok, locked = pcall(function()
        return plotObject.states.locked.get()
    end)

    if not ok then
        return nil, "Failed to read lock state"
    end

    return locked
end

g.LockHouse_LastState = g.LockHouse_LastState or {}
g.LockHomeLoop = g.LockHomeLoop or false
g.LockHomeToken = g.LockHomeToken or 0
g.keep_home_locked = g.keep_home_locked or function(toggle)
    if toggle then
        if g.LockHomeLoop then
            return notify("Warning", "Flames Hub | Auto Lock Home is already enabled.", 5)
        end

        g.LockHomeLoop = true
        g.LockHomeToken = (g.LockHomeToken or 0) + 1
        local myToken = g.LockHomeToken
        g.notify("Success", "Flames Hub | Auto Lock Home is now enabled.", 5)
        task.spawn(function()
            while g.LockHomeLoop and myToken == g.LockHomeToken do
                fw(0.2)
                local plotList = PlotMarker and PlotMarker.class and PlotMarker.class.objects
                if plotList then
                    for _, plot in pairs(plotList) do
                        if myToken ~= g.LockHomeToken then return end
                        local okOwner, owner = pcall(function()
                            return plot.states.owner.get()
                        end)

                        if okOwner and owner == g.LocalPlayer then
                            local id = plot.instance:GetDebugId()
                            if g.LockHouse_LastState[id] == nil then
                                g.LockHouse_LastState[id] = plot.states.locked.get()
                            end

                            local locked = plot.states.locked.get()
                            local last = g.LockHouse_LastState[id]
                            if locked == false and last == true then
                                toggle_house_lock(g.LocalPlayer)
                                g.LockHouse_LastState[id] = true
                            else
                                g.LockHouse_LastState[id] = locked
                            end
                        end
                    end
                end
            end
        end)
    else
        if not g.LockHomeLoop then
            return notify("Warning", "Flames Hub | Auto Lock Home is not enabled.", 5)
        end

        g.LockHomeLoop = false
        g.LockHomeToken = (g.LockHomeToken or 0) + 1
        table.clear(g.LockHouse_LastState)
        g.notify("Success", "Flames Hub | Auto Lock Home is now disabled.", 5)
    end
end

g.spin_plr = g.spin_plr or function(toggle, speed)
    local hrp = g.HumanoidRootPart or get_root(g.LocalPlayer)

    if toggle == true then
        if g.already_spinning_localplr then
            return notify("Warning", "You are already spinning, changing speed.", 5)
        end
        if typeof(speed) ~= "number" then
            return notify("Error", "That wasn't a number! Input a number.", 5)
        end
        if g.walkflinging then
            return notify("Error", "Turn off walkfling first for this to work properly.", 10)
        end

        g.already_spinning_localplr = true
        for _, v in pairs(hrp:GetChildren()) do
            if v.Name == "FlamesHub_Spin" then
                v:Destroy()
            end
        end
        wait(.1)
        local Spin = Instance.new("BodyAngularVelocity")
        Spin.Name = "FlamesHub_Spin"
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.AngularVelocity = Vector3.new(0, autospinspeed(speed), 0)
        Spin.Parent = hrp
    elseif toggle == false then
        if not g.already_spinning_localplr then
            return notify("Error", "You are not using Spin.", 5)
        end

        for _, v in ipairs(hrp:GetChildren()) do
            if v:IsA("BodyAngularVelocity") and v.Name == "FlamesHub_Spin" then
                v:Destroy()
            end
        end
        g.already_spinning_localplr = false
    else
        return
    end
end

g.OrbitConnections = g.OrbitConnections or {}
g.Is_Orbiting = g.Is_Orbiting or false
g.OrbitSpeed = g.OrbitSpeed or 1
g.set_orbit_speed = g.set_orbit_speed or function(new_speed)
    if type(new_speed) == "number" then
        g.OrbitSpeed = new_speed
        g.notify("Info", "Orbit speed set to " .. tostring(new_speed), 4)
    else
        g.notify("Error", "Invalid speed value.", 4)
    end
end

g.stop_orbit = g.stop_orbit or function()
    if not g.Is_Orbiting then
        return g.notify("Warning", "You're not orbiting anyone.", 5)
    end
    for _, conn in pairs(g.OrbitConnections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    table.clear(g.OrbitConnections)
    g.Is_Orbiting = false
    g.notify("Success", "Stopped orbiting Player.", 5)
end

g.start_orbit_plr = g.start_orbit_plr or function(target, speed, distance)
    if g.Is_Orbiting then
        return notify("Warning", "Already orbiting someone!", 5)
    end
    if not target or not target.Character then
        return notify("Error", "Target invalid or they're missing their Character.", 5)
    end

    local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
    local target_char = target.Character or g.get_char(target)
    local root = g.HumanoidRootPart or get_root(LocalPlayer)
    local humanoid = g.Humanoid or get_human(LocalPlayer) or g.Character:FindFirstChildOfClass("Humanoid")
    local targetRoot = target_char:FindFirstChild("HumanoidRootPart") or get_root(target)
    if not root or not humanoid or not targetRoot then
        g.Is_Orbiting = false
        return notify("Error", "Missing root or humanoid, cannot orbit this player.", 5)
    end

    speed = tonumber(speed) or g.OrbitSpeed or 1
    distance = tonumber(distance) or 3
    g.OrbitSpeed = speed
    g.Is_Orbiting = true
    local rotation = 0
    g.OrbitConnections.Heartbeat = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not g.Is_Orbiting or not target_char or not targetRoot or not root then
                return 
            end
            rotation = rotation + (g.OrbitSpeed or 0)
            root.CFrame = CFrame.new(targetRoot.Position) * CFrame.Angles(0, math.rad(rotation), 0) * CFrame.new(distance, 0, 0)
        end)
    end)

    g.OrbitConnections.RenderStepped = RunService.RenderStepped:Connect(function()
        pcall(function()
            if root and targetRoot then
                root.CFrame = CFrame.new(root.Position, targetRoot.Position)
            end
        end)
    end)

    g.OrbitConnections.Died = humanoid.Died:Connect(stop_orbit)
    g.OrbitConnections.Seated = humanoid.Seated:Connect(function(isSeated)
        if isSeated then stop_orbit() end
    end)

    notify("Success", "Started orbiting: "..tostring(target)..", with speed: "..tostring(speed)..", and with distance: "..tostring(distance), 5)
end

g.water_skie_trailer = g.water_skie_trailer or function(Bool, Vehicle)
    if not Vehicle then
        return notify("Warning", "You do not have a Vehicle spawned!", 5)
    end

    local HasTrailer = Vehicle:FindFirstChild("WaterSkies")

    if Bool == true then
        if HasTrailer then
            return notify("Error", "You already have the WaterSkies trailer.", 5)
        else
            g.Get("add_trailer", Vehicle, "WaterSkies")
        end
    elseif Bool == false then
        if HasTrailer then
            g.Get("add_trailer", Vehicle, "WaterSkies")
        else
            return notify("Warning", "You do not have the WaterSkies trailer to take it off!", 5)
        end
    else
        return notify("Error", "Invalid toggle value (expected: true/false).", 5)
    end
end

g.FlyEnabled = g.FlyEnabled or false
g.FlySpeed = g.FlySpeed or 1
g.QEfly = (g.QEfly == nil) and true or g.QEfly
g.flyKeyDown = g.flyKeyDown or nil
g.flyKeyUp = g.flyKeyUp or nil
g.mobileFlyConn = g.mobileFlyConn or nil
g.pcFlyConn = g.pcFlyConn or nil
local UIS = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
g.EnableFly = g.EnableFly or function(state, speed, vfly)
    if g.FlyEnabled then
        if speed and tonumber(speed) then
            g.FlySpeed = tonumber(speed)
            return notify("Success", "Fly speed updated to: " .. tostring(g.FlySpeed), 4)
        end
        return notify("Warning", "Fly is already enabled! Provide a speed to update it.", 5)
    end

    local plr = g.LocalPlayer or g.Players.LocalPlayer or game.Players.LocalPlayer
    local char = g.get_char(plr) or g.Character or plr.Character
    local hrp = g.HumanoidRootPart or char:FindFirstChild("HumanoidRootPart") or get_root(plr)
    local hum = g.Humanoid or char:FindFirstChildOfClass("Humanoid") or get_human(plr)
    local cam = workspace.CurrentCamera
    if not hrp or not hum then
        return g.notify("Error", "Character is not ready or Humanoid doesn't exist.", 6)
    end

    if not state then
        DisableFly()
        return
    end

    if speed and tonumber(speed) then
        g.FlySpeed = tonumber(speed)
    end

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
            local moveVec = ((look.LookVector * (CONTROL.F + CONTROL.B)) + ((look * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.Q + CONTROL.E) * 0.2, 0).p) - look.p))

            if moveVec.Magnitude > 0 then
                moveVec = moveVec.Unit
                BV.Velocity = moveVec * speedNow
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

        notify("Success", "Fly enabled (PC) | Speed: "..tostring(g.FlySpeed), 5)
        return
    end

    local ok, controlModule = pcall(function()
        return require(plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    end)
    if not ok or not controlModule then
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

        local direction = controlModule:GetMoveVector()
        local speedScaled = ((vfly and (g.VehicleFlySpeed or g.FlySpeed)) or g.FlySpeed) * 50

        if direction.Magnitude > 0 then
            BV.Velocity = (cam.CFrame.LookVector * -direction.Z + cam.CFrame.RightVector * direction.X) * speedScaled
        else
            BV.Velocity = Vector3.zero
        end
    end)

    notify("Success", "Fly enabled (Mobile) | Speed: "..tostring(g.FlySpeed), 5)
end

g.DisableFly = g.DisableFly or function()
    if not g.FlyEnabled then
        return notify("Warning", "Fly is not enabled!", 5)
    end

    g.FlyEnabled = false
    if g.flyKeyDown then g.flyKeyDown:Disconnect() g.flyKeyDown = nil end
    if g.flyKeyUp then g.flyKeyUp:Disconnect() g.flyKeyUp = nil end
    if g.pcFlyConn then g.pcFlyConn:Disconnect() g.pcFlyConn = nil end
    if g.mobileFlyConn then g.mobileFlyConn:Disconnect() g.mobileFlyConn = nil end
    local plr = g.LocalPlayer
    local char = g.Character or g.get_char(plr)
    local hrp = g.HumanoidRootPart or char:FindFirstChild("HumanoidRootPart") or get_root(plr)
    local hum = g.Humanoid or char:FindFirstChildWhichIsA("Humanoid") or get_human(plr)
    if hrp then
        if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
        if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
    end

    if hum then hum.PlatformStand = false end
    g.notify("Success", "Fly is now disabled.", 5)
end

g.VehicleStates = g.VehicleStates or {}
if not g.VehicleStates[g.LocalPlayer.Name] then g.VehicleStates[g.LocalPlayer.Name] = g.LocalPlayer end
g.find_core_folder = g.find_core_folder or function()
    for _, v in ipairs(g.ReplicatedStorage:GetDescendants()) do
        if v:IsA("Folder") and v.Name == "Core" and v.Parent.Name == "Modules" then
            return v
        end
    end

    return nil
end

g.send_msg_phone = g.send_msg_phone or function(player, msg)
    local Core_Folder = find_core_folder()
    if not Core_Folder then
        return notify("Error", "Core Folder not found (patched?).", 5)
    end
    local Privacy = require(Core_Folder:FindFirstChild("Privacy"))
    if not Privacy then
        return notify("Error", "Privacy ModuleScript not found (patched?).", 5)
    end

    local function get_dm_hash(id)
        local my = Players.LocalPlayer.UserId
        if not id then return nil end
        local a, b = (id < my) and id or my, (id < my) and my or id
        return tostring(a) .. " " .. tostring(b)
    end

    local function send_dm(target, text)
        local targetId = target.UserId
        local hash = get_dm_hash(targetId)
        if not hash then return false end
        local ok, res = pcall(function()
            return Privacy.send_message("messages", hash, text)
        end)

        if not ok or res == false then
            g.Sending_DMs_Main_Non_Loop_Task = g.Sending_DMs_Main_Non_Loop_Task or task.spawn(function()
                notify("Error", "Send message failed: "..tostring(res), 7)
            end)
            return false
        end

        return true
    end

    local text_to_send = msg

    if not text_to_send or text_to_send == "" then
        return g.notify("Error", "Please input a valid message to send!", 5)
    end

    send_dm(player, text_to_send)
end

local ui_mod = require(g.ReplicatedStorage.Modules.Core.UI)
local data_mod = require(g.ReplicatedStorage.Modules.Core:FindFirstChild("Data", true))
local messages_mod = require(g.ReplicatedStorage:FindFirstChild("Messages", true))
local scroll_frame = ui_mod.get("MessagesChatScrollFrame")
local function get_other_from_hash(hash, known_id)
    local id1, id2 = hash:match("(%-?%d+) (%-?%d+)")
    id1, id2 = tonumber(id1), tonumber(id2)
    if not id1 or not id2 then return nil end
    if id1 == known_id then return id2 end
    if id2 == known_id then return id1 end
    return nil
end

local function get_recipient_id()
    local convo = messages_mod.active_conversation
    if not convo then return nil end
    return get_other_from_hash(convo.hash, game.Players.LocalPlayer.UserId)
end

local function get_recipient_from_message(msg_id, sender_id)
    for _, convo in ipairs(data_mod.conversations or {}) do
        if convo.messages then
            for _, msg in ipairs(convo.messages) do
                if msg.id == msg_id then
                    return get_other_from_hash(convo.hash, sender_id)
                end
            end
        end
    end
    return nil
end

local function get_sender_id(msg_id)
    for _, convo in ipairs(data_mod.conversations or {}) do
        if convo.messages then
            for _, msg in ipairs(convo.messages) do
                if msg.id == msg_id then
                    return msg.sender_id, convo.hash
                end
            end
        end
    end
    return nil, nil
end

g.chat_logged_ids = g.chat_logged_ids or {}
g.chat_frame_locks = g.chat_frame_locks or {}
g.chat_text_conns = g.chat_text_conns or {}
g.chat_send_queue = g.chat_send_queue or {}
g.chat_sending = g.chat_sending or false
local function resolve_name(uid)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.UserId == uid then
            return p.Name
        end
    end
    return "User_" .. uid
end

local function enqueue_message(msg) table.insert(g.chat_send_queue, msg) end
local function log_message(frame, txt, msg_id, sender_id)
    local unique_id = msg_id .. "|" .. txt.Text
    if g.chat_logged_ids[unique_id] then return end
    g.chat_logged_ids[unique_id] = true
    local sender_name = resolve_name(sender_id)
    local recipient_id = tonumber(frame:GetAttribute("recipient_id"))
        or get_recipient_from_message(msg_id, sender_id)
        or get_recipient_id()
    local recipient_name = recipient_id and resolve_name(recipient_id) or "unknown"
    local recipient_str  = recipient_id
        and (recipient_name .. " (" .. recipient_id .. ")")
        or "unknown"
    enqueue_message(
        sender_name .. " (" .. sender_id .. " to " .. recipient_str .. "): " .. txt.Text
    )
end

local function process_message_frame(frame)
    if frame.Name ~= "Message" then return end
    local msg_id = frame:GetAttribute("id")
    if type(msg_id) ~= "string" then return end
    local sender_id, hash = get_sender_id(msg_id)
    if not sender_id then return end
    local recipient_id = get_other_from_hash(hash, sender_id)
    if recipient_id then
        frame:SetAttribute("recipient_id", recipient_id)
    end

    local txt = frame:FindFirstChildWhichIsA("TextLabel", true)
    if not txt then return end
    if not g.chat_text_conns[txt] then
        g.chat_text_conns[txt] = txt:GetPropertyChangedSignal("Text"):Connect(function()
            if txt.Text == "" then return end
            task.delay(0.02, function()
                if txt.Text ~= "" then
                    log_message(frame, txt, msg_id, sender_id)
                end
            end)
        end)
    end

    task.delay(0.05, function()
        if txt and txt.Text ~= "" then
            log_message(frame, txt, msg_id, sender_id)
        end
    end)
end

g.toggle_rgb_streetlights = g.toggle_rgb_streetlights or function(toggle)
    local genv = g

    if toggle == true then
        if genv.RGB_Street_Lights_NightTime_Loop or genv.StreetLightRainbowConnection then
            return genv.notify("Warning", "RGB/Rainbow StreetLights is already running!", 5)
        end

        local Map = Workspace:FindFirstChild("Map", true)
        if not Map then
            return genv.notify("Error", "Map Folder not found inside of Workspace!", 6)
        end

        local StreetLs = Map:FindFirstChild("StreetLights", true)
        if not StreetLs then
            return genv.notify("Error", "StreetLights not found inside of Map Folder!", 5)
        end

        if typeof(genv.all_street_lights) ~= "table" then genv.all_street_lights = {} end
        if next(genv.all_street_lights) == nil then
            for _, v in ipairs(StreetLs:GetDescendants()) do
                if v:IsA("PointLight") then
                table.insert(genv.all_street_lights, v)
                end
            end
        end

        local hue = 0
        genv.RGB_Street_Lights_NightTime_Loop = true
        genv.notify("Success", "RGB/Rainbow StreetLights enabled, they will only animate at night.", 10)
        genv.StreetLightRainbowConnection = RunService.Heartbeat:Connect(function(dt)
            local clock_time = Lighting.ClockTime
            if clock_time < 18.5 and clock_time > 7.5 then return end
            hue = (hue + dt * 0.0833) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            for i = #genv.all_street_lights, 1, -1 do
                local light = genv.all_street_lights[i]
                if not light or not light.Parent then
                    table.remove(genv.all_street_lights, i)
                else
                    light.Color = color
                end
            end
        end)
    elseif toggle == false then
        if not genv.RGB_Street_Lights_NightTime_Loop then return genv.notify("Warning", "RGB/Rainbow StreetLights is not enabled!", 5) end
        genv.RGB_Street_Lights_NightTime_Loop = false
        if genv.StreetLightRainbowConnection then
            genv.StreetLightRainbowConnection:Disconnect()
            genv.StreetLightRainbowConnection = nil
        end
        genv.notify("Success", "RGB/Rainbow StreetLights disabled.", 10)
    end
end

local excluded_functions = {
   HttpGet = true,
   appendfile = true,
   base64_decode = true,
   base64_encode = true,
   base64decode = true,
   base64encode = true,
   cansignalreplicate = true,
   checkcaller = true,
   checkclosure = true,
   clear_teleport_queue = true,
   cleardrawcache = true,
   clearqueueonteleport = true,
   clearteleportqueue = true,
   clonefunction = true,
   cloneref = true,
   clonereference = true,
   compareinstances = true,
   consoleclear = true,
   consolecreate = true,
   consoledestroy = true,
   consoleerror = true,
   consoleinput = true,
   consoleprint = true,
   consolesettitle = true,
   consolewarn = true,
   create_comm_channel = true,
   createrenderobj = true,
   createrenderobject = true,
   decompile = true,
   delfile = true,
   delfolder = true,
   dofile = true,
   dumpstring = true,
   disable_emote_func = true,
   filtergc = true,
   fireclickdetector = true,
   fireproximityprompt = true,
   firesignal = true,
   firetouchinterest = true,
   get_actor_threads = true,
   get_actors = true,
   get_comm_channel = true,
   get_deleted_actors = true,
   get_hidden_gui = true,
   get_hwid = true,
   get_internal_parent = true,
   get_namecall_method = true,
   get_thread_identity = true,
   get_user_identifier = true,
   getactors = true,
   getactorthreads = true,
   getallthreads = true,
   getbspval = true,
   getcallbackmember = true,
   getcallbackvalue = true,
   getcallingscript = true,
   getcaps = true,
   getclosurecaps = true,
   getconnection = true,
   getconnections = true,
   getconstant = true,
   getconstants = true,
   getcustomasset = true,
   getdeletedactors = true,
   getexecutorname = true,
   getfenv = true,
   getfflag = true,
   getfpscap = true,
   getfunctionhash = true,
   getgc = true,
   getgenv = true,
   gethiddenprop = true,
   gethiddenproperty = true,
   gethui = true,
   gethwid = true,
   getidentity = true,
   getinfo = true,
   getinstances = true,
   getinternalparent = true,
   getloadedmodules = true,
   getnamecallmethod = true,
   getnilinstances = true,
   getobjects = true,
   getpcd = true,
   getproto = true,
   getprotos = true,
   getproximitypromptduration = true,
   getrawmetatable = true,
   getreg = true,
   getregistry = true,
   getrenderproperty = true,
   getrendersteppedlist = true,
   getrenv = true,
   getrunningscripts = true,
   getsafeenv = true,
   getscriptbytecode = true,
   getscriptclosure = true,
   getscriptfromthread = true,
   getscriptfunction = true,
   getscripthash = true,
   getscripts = true,
   getscriptthread = true,
   getsenv = true,
   getsimulationradius = true,
   getstack = true,
   getsynasset = true,
   gettenv = true,
   getthreadcontext = true,
   getthreadidentity = true,
   getupvalue = true,
   getupvalues = true,
   hookfunc = true,
   hookfunction = true,
   hookmetamethod = true,
   http_request = true,
   httpget = true,
   identifyexecutor = true,
   is_parallel = true,
   is_readonly = true,
   iscclosure = true,
   isexecutorclosure = true,
   isfile = true,
   isfolder = true,
   isfunctionhooked = true,
   isgameactive = true,
   islclosure = true,
   isnetworkowner = true,
   isnewcclosure = true,
   isourclosure = true,
   isourthread = true,
   isparallel = true,
   isrbxactive = true,
   isreadonly = true,
   isrenderobj = true,
   isscriptable = true,
   isuntouched = true,
   isvalidlevel = true,
   iswindowactive = true,
   keyclick = true,
   keypress = true,
   keyrelease = true,
   keytap = true,
   listfiles = true,
   loadfile = true,
   loadstring = true,
   lz4compress = true,
   lz4decompress = true,
   makefolder = true,
   makereadonly = true,
   makewritable = true,
   messagebox = true,
   messageboxasync = true,
   mouse1click = true,
   mouse1press = true,
   mouse1release = true,
   mouse2click = true,
   mouse2press = true,
   mouse2release = true,
   mousemoveabs = true,
   mousemoverel = true,
   mousescroll = true,
   newcclosure = true,
   newlclosure = true,
   queue_on_teleport = true,
   queueonteleport = true,
   rconsoleclear = true,
   rconsolecreate = true,
   rconsoledestroy = true,
   rconsoleerr = true,
   rconsoleerror = true,
   rconsolehide = true,
   rconsoleinfo = true,
   rconsoleinput = true,
   rconsolename = true,
   rconsoleprint = true,
   rconsolesettitle = true,
   rconsoleshow = true,
   rconsolewarn = true,
   readfile = true,
   replaceclosure = true,
   replicatesignal = true,
   request = true,
   require = true,
   restorefunc = true,
   restorefunction = true,
   run_on_actor = true,
   run_on_thread = true,
   saveinstance = true,
   set_internal_parent = true,
   set_namecall_method = true,
   set_readonly = true,
   set_thread_identity = true,
   setcaps = true,
   setclipboard = true,
   setclosurecaps = true,
   setconstant = true,
   setfflag = true,
   setfpscap = true,
   sethiddenprop = true,
   sethiddenproperty = true,
   setidentity = true,
   setinternalparent = true,
   setname = true,
   setnamecallmethod = true,
   setproximitypromptduration = true,
   setrawmetatable = true,
   setrbxclipboard = true,
   setreadonly = true,
   setrenderproperty = true,
   setsafeenv = true,
   setscriptable = true,
   setsimulationradius = true,
   setstack = true,
   setstackhidden = true,
   setthreadcontext = true,
   setthreadidentity = true,
   setuntouched = true,
   setupvalue = true,
   setwindowtitle = true,
   toclipboard = true,
   validlevel = true,
   writefile = true,
   playemote = true,
   try_load = true,
   change_gravity_val = true,
   execCmd = true,
   disabled_global_value_correctly = true,
   name_changer_premium = true,
   Flames_Debugger_Function_Tester_GUI = true,
   notify = true,
   start_scan = true,
   SetFPSCap = true,
   low_level_executor = true
}

g.Flames_Debugger_Function_Tester_GUI = g.Flames_Debugger_Function_Tester_GUI or function()
    local genv = g
    local Players = genv.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
    local CoreGui = genv.CoreGui or (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui")
    local UIS = genv.UserInputService or game:GetService("UserInputService")
    local start_scan

    if genv.__flames_debugger_running then
        if g.notify then
            return g.notify("Warning", "Flames Debugger is already running!", 5)
        else
            return warn("Flames Debugger is already running.")
        end
    end

    if CoreGui:FindFirstChild("FlamesDebugger") then
        CoreGui.FlamesDebugger.Enabled = true
        genv.__flames_debugger_running = false
        getgenv().dont_receive_any_notifications_flames_hub = false
        return
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "FlamesDebugger"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(400,300)
    frame.Position = UDim2.fromScale(0.4,0.3)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    frame.Parent = gui

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-150,0,30)
    title.Position = UDim2.new(0,10,0,5)
    title.BackgroundTransparency = 1
    title.Text = "Flames Hub | Debugger"
    title.TextScaled = true
    title.TextColor3 = Color3.new(1,1,1)
    title.Parent = frame

    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(26,26)
    close.Position = UDim2.new(1,-32,0,4)
    close.Text = "X"
    close.TextScaled = true
    close.BackgroundColor3 = Color3.fromRGB(120,40,40)
    close.TextColor3 = Color3.new(1,1,1)
    close.Parent = frame

    Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

    close.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)

    local rescan = Instance.new("TextButton")
    rescan.Size = UDim2.fromOffset(90,24)
    rescan.Position = UDim2.new(1,-130,0,6)
    rescan.Text = "Start Scan"
    rescan.TextScaled = true
    rescan.BackgroundColor3 = Color3.fromRGB(40,90,140)
    rescan.TextColor3 = Color3.new(1,1,1)
    rescan.Parent = frame

    rescan.MouseButton1Click:Connect(function()
        if not genv.__flames_debugger_running then
            genv.__flames_debugger_running = true
            getgenv().dont_receive_any_notifications_flames_hub = true
            start_scan()
        end
    end)

    Instance.new("UICorner", rescan).CornerRadius = UDim.new(0,6)

    local list = Instance.new("ScrollingFrame")
    list.Position = UDim2.new(0,10,0,40)
    list.Size = UDim2.new(1,-20,1,-50)
    list.CanvasSize = UDim2.new(0,0,0,0)
    list.ScrollBarImageTransparency = 0.2
    list.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,4)
    layout.Parent = list

    local function update_canvas()
        list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 6)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update_canvas)
    local function add_row(text, success)
        local row = Instance.new("TextLabel")
        row.Size = UDim2.new(1,-6,0,24)
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.TextScaled = true
        row.TextColor3 = Color3.new(1,1,1)
        row.BackgroundColor3 = success and Color3.fromRGB(30,80,30) or Color3.fromRGB(90,30,30)
        row.Text = (success and "  ?  " or "  ?  ") .. text
        row.Parent = list
    end

    local function snapshot_guis()
        local snap = {}
        for _,v in ipairs(CoreGui:GetChildren()) do
            if v:IsA("ScreenGui") then
                snap[v] = true
            end
        end
        return snap
    end

    local function cleanup_guis(before)
        for _,v in ipairs(CoreGui:GetChildren()) do
            if v:IsA("ScreenGui") and not before[v] and v ~= gui then
                pcall(function()
                v:Destroy()
                end)
            end
        end
    end

    local function clear_list()
        for _,v in ipairs(list:GetChildren()) do
            if v:IsA("TextLabel") then
                v:Destroy()
            end
        end
    end

    if rescan and rescan:IsA("TextButton") then
        task.spawn(function()
            while true do
                wait(0.5)
                if g.button_text_changing_for_debug_scanner then
                    wait(0.5)
                    rescan.Text = "Scan Running."
                    wait(0.6)
                    if not g.button_text_changing_for_debug_scanner then continue end
                    rescan.Text = "Scan Running.."
                    wait(0.6)
                    if not g.button_text_changing_for_debug_scanner then continue end
                    rescan.Text = "Scan Running..."
                    wait(0.6)
                else
                    wait(0.6)
                end
            end
        end)
    end

    start_scan = function()
        task.spawn(function()
            g.button_text_changing_for_debug_scanner = true
            local function run_scan()
                clear_list()
                local tested = 0

                for name,value in next,genv do
                    if tested >= 25 then break end
                    if typeof(value) == "function" and not excluded_functions[name] then
                        tested = tested + 1
                        local before = snapshot_guis()
                        local ok, err = pcall(value)
                        cleanup_guis(before)

                        if ok then
                            add_row(name.."()", true)
                        else
                            if typeof(err) == "string" then
                                local lower = err:lower()
                                if lower:find("nil") or lower:find("argument") or lower:find("index") then
                                    add_row(name.."() - ignore", false)
                                else
                                    add_row(name.."() - runtime error", false)
                                end
                            else
                                add_row(name.."()", false)
                            end
                        end

                        wait(0.5)
                    end
                end

                if tested == 0 then
                    add_row("No functions found to test", false)
                    getgenv().dont_receive_any_notifications_flames_hub = false
                else
                    add_row("Completed testing "..tested.." functions", true)
                    getgenv().dont_receive_any_notifications_flames_hub = false
                end
            end

            local ok, response = pcall(function()
                run_scan()
            end)
            task.wait(0.15)
            g.button_text_changing_for_debug_scanner = false
            genv.__flames_debugger_running = false
            getgenv().dont_receive_any_notifications_flames_hub = false
            if rescan and rescan:IsA("TextButton") then rescan.Text = "Start Scan" end
        end)
    end

    local dragging = false
    local drag_start
    local start_pos
    local drag_input

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            drag_start = input.Position
            start_pos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            drag_input = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == drag_input and dragging then
            local delta = input.Position - drag_start
            frame.Position = UDim2.new(
                start_pos.X.Scale,
                start_pos.X.Offset + delta.X,
                start_pos.Y.Scale,
                start_pos.Y.Offset + delta.Y
            )
        end
    end)
end

g.CreateCreditsLabel = g.CreateCreditsLabel or function()
    if g.CreditsLabelGui then g.CreditsLabelGui:Destroy() end
    local creditsGui = Instance.new("ScreenGui")
    creditsGui.Name = "PrefixCreditsGui_LifeTogether"
    creditsGui.ResetOnSpawn = false
    creditsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    creditsGui.Parent = CoreGui

    local label = Instance.new("TextLabel")
    label.Name = "CreditsLabel"
    g.MainCreditsLabel_WithPrefix = label
    label.AnchorPoint = Vector2.new(0.5, 1)

    if isMobile then
        label.Position = UDim2.new(0.5, 0, 0.95, -10)
        label.Size = UDim2.new(0.3, 0, 0, 28)
    else
        label.Position = UDim2.new(0.5, 0, 0.949999988, 25)
        label.Size = UDim2.new(0.6, 0, 0, 28)
    end

    label.BackgroundColor3 = Color3.fromRGB(151, 0, 0)
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    flowrgb("PrefixCreditsLabelConn", 1, label, true)
    local parts = {tostring(g.Script_Version)}
    if holiday ~= "" then table.insert(parts, holiday) end
    table.insert(parts, "Made By: " .. tostring(Script_Creator))
    if masked_flames_hub_server_ID then table.insert(parts, "Your Flames-Hub UUID: " .. tostring(masked_flames_hub_server_ID)) end
    label.Text = table.concat(parts, " | ")
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.RichText = false
    label.TextStrokeTransparency = 1
    label.BackgroundTransparency = 0
    label.ZIndex = 10
    label.Parent = creditsGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = label

    g.CreditsLabelGui = creditsGui
    g.CreditsLabelText = label
    if g._PrefixUpdateConnection then g._PrefixUpdateConnection:Disconnect() end
    local parts = {tostring(g.Script_Version)}
    if holiday ~= "" then table.insert(parts, holiday) end
    table.insert(parts, "Made By: " .. tostring(Script_Creator))
    if masked_flames_hub_server_ID then table.insert(parts, "Your Flames-Hub UUID: " .. tostring(masked_flames_hub_server_ID)) end
    label.Text = table.concat(parts, " | ")
end

CreateCreditsLabel()
g.hidden_pcm = setmetatable({}, { __mode = "k" })
g.HidePhoneModels = g.HidePhoneModels or false
g.phone_model_anti_rgb_phone_hider_values = setmetatable({}, { __mode = "k" })
g._pcm_registry = setmetatable({}, { __mode = "k" })
local SavedValues = g.phone_model_anti_rgb_phone_hider_values
g.hide_pcm = g.hide_pcm or function(pcm)
    if not pcm or not pcm:IsA("Model") then return end
    if g.hidden_pcm[pcm] then return end
    SavedValues[pcm] = SavedValues[pcm] or {}

    for _, v in ipairs(pcm:GetDescendants()) do
        if v:IsA("BasePart") then
            SavedValues[pcm][v] = {
                LocalTransparencyModifier = v.LocalTransparencyModifier,
                CanCollide = v.CanCollide,
                CanQuery = v.CanQuery,
                CanTouch = v.CanTouch
            }
            v.LocalTransparencyModifier = 1
            v.CanCollide = false
            v.CanQuery = false
            v.CanTouch = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            SavedValues[pcm][v] = { Transparency = v.Transparency }
            v.Transparency = 1
        elseif v:IsA("Sound") then
            SavedValues[pcm][v] = { Volume = v.Volume }
            v.Volume = 0
        end
    end

    local desc_conn = pcm.DescendantAdded:Connect(function(v)
        if not g.HidePhoneModels then return end
        SavedValues[pcm] = SavedValues[pcm] or {}
        if v:IsA("BasePart") then
            SavedValues[pcm][v] = {
                LocalTransparencyModifier = v.LocalTransparencyModifier,
                CanCollide = v.CanCollide,
                CanQuery = v.CanQuery,
                CanTouch = v.CanTouch
            }
            v.LocalTransparencyModifier = 1
            v.CanCollide = false
            v.CanQuery = false
            v.CanTouch = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            SavedValues[pcm][v] = { Transparency = v.Transparency }
            v.Transparency = 1
        elseif v:IsA("Sound") then
            SavedValues[pcm][v] = { Volume = v.Volume }
            v.Volume = 0
        end
    end)

    g.hidden_pcm[pcm] = { conn = desc_conn }
end

g.show_pcm = g.show_pcm or function(pcm)
    if not pcm or not pcm:IsA("Model") then return end
    local entry = g.hidden_pcm[pcm]
    if not entry then return end
    if entry.conn and entry.conn.Connected then entry.conn:Disconnect() end
    local pcm_saved = SavedValues[pcm]
    if pcm_saved then
        for _, v in ipairs(pcm:GetDescendants()) do
            local orig = pcm_saved[v]
            if not orig then continue end
            if v:IsA("BasePart") then
                v.LocalTransparencyModifier = orig.LocalTransparencyModifier
                v.CanCollide = orig.CanCollide
                v.CanQuery = orig.CanQuery
                v.CanTouch = orig.CanTouch
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = orig.Transparency
            elseif v:IsA("Sound") then
                v.Volume = orig.Volume
            end
        end
        SavedValues[pcm] = nil
    end

    g.hidden_pcm[pcm] = nil
end

g.try_hide_pcm = g.try_hide_pcm or function(character)
    if not g.HidePhoneModels then return end
    if not character then return end
    local plr = Players:GetPlayerFromCharacter(character)
    if not plr or plr == LocalPlayer then return end
    local pcm = character:FindFirstChild("PhoneCharacterModel")
    if not pcm then return end

    g.hide_pcm(pcm)
end

g.scan_character = g.scan_character or function(character)
    if not character then return end
    task.defer(function() g.try_hide_pcm(character) end)
    local char_id = tostring(character) .. "_childadded"
    local cleanup_id = tostring(character) .. "_ancestry"

    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Model") and child.Name == "PhoneCharacterModel" then
            g._pcm_registry[child] = true
        end
    end

    FlamesLibrary.connect(char_id, character.ChildAdded:Connect(function(child)
        if child:IsA("Model") and child.Name == "PhoneCharacterModel" then
            g._pcm_registry[child] = true
            task.defer(function()
                if g.HidePhoneModels then
                    g.hide_pcm(child)
                end
            end)
        end
    end))

    FlamesLibrary.connect(cleanup_id, character.AncestryChanged:Connect(function(_, parent)
        if not parent then
            FlamesLibrary.disconnect(char_id)
            FlamesLibrary.disconnect(cleanup_id)
        end
    end))
end

g.hook_player = g.hook_player or function(plr)
    if plr == LocalPlayer then return end
    local plr_id = tostring(plr.UserId)
    FlamesLibrary.spawn(plr_id .. "_charwait", "spawn", function()
        local char = get_char(plr, 10)
        if char then g.scan_character(char) end
    end)

    FlamesLibrary.connect(plr_id .. "_charadded", plr.CharacterAdded:Connect(function(char)
        g.scan_character(char)
    end))
end

FlamesLibrary.disconnect("pmh_playeradded")
FlamesLibrary.disconnect("pmh_playerremoving")
FlamesLibrary.connect("pmh_playeradded", Players.PlayerAdded:Connect(g.hook_player))
FlamesLibrary.connect("pmh_playerremoving", Players.PlayerRemoving:Connect(function(plr)
    local plr_id = tostring(plr.UserId)
    FlamesLibrary.disconnect(plr_id .. "_charadded")
    FlamesLibrary.disconnect(plr_id .. "_charwait")
end))

for _, plr in ipairs(Players:GetPlayers()) do if plr ~= game.Players.LocalPlayer then g.hook_player(plr) end end
g.rescan_all_pcms = g.rescan_all_pcms or function()
    for pcm in pairs(g._pcm_registry) do
        if not pcm.Parent then
            g._pcm_registry[pcm] = nil
            continue
        end
        local char = pcm.Parent
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then
            if g.HidePhoneModels then
                g.hide_pcm(pcm)
            else
                g.show_pcm(pcm)
            end
        end
    end
end

g.TogglePhoneModelHider = g.TogglePhoneModelHider or function(state)
    if type(state) == "boolean" then
        g.HidePhoneModels = state
    else
        g.HidePhoneModels = not g.HidePhoneModels
    end

    if g.HidePhoneModels then
        g.rescan_all_pcms()
    else
        for pcm in pairs(g.hidden_pcm) do
            g.show_pcm(pcm)
        end
    end
end

g.ShutdownPhoneModelHider = g.ShutdownPhoneModelHider or function()
    for pcm in pairs(g.hidden_pcm) do g.show_pcm(pcm) end
    FlamesLibrary.disconnect("pmh_playeradded")
    FlamesLibrary.disconnect("pmh_playerremoving")

    for _, plr in ipairs(Players:GetPlayers()) do
        local plr_id = tostring(plr.UserId)
        FlamesLibrary.disconnect(plr_id .. "_charadded")
        FlamesLibrary.disconnect(plr_id .. "_charwait")
    end

    table.clear(g.hidden_pcm)
    table.clear(SavedValues)
    table.clear(g._pcm_registry)
end

if not g.FlamesHub_CharacterAdded_Initialized then
    g.FlamesHub_CharacterAdded_Initialized = true
    local function character_added_jump_height_changer_Life_Together_RP(Character)
        Character = g.Character or Character
        if not Character or not Character.Parent then Character = LocalPlayer.Character or get_char(LocalPlayer, 10) end
        if not Character or not Character.Parent then return end
        local Humanoid = g.Humanoid
        if not Humanoid or not Humanoid.Parent then
            Humanoid = Character:FindFirstChildOfClass("Humanoid") or Character:WaitForChild("Humanoid", 10) or get_human(LocalPlayer, 10)
        end

        if Humanoid and Humanoid.Parent then
            Humanoid.JumpHeight = 7
        end
    end

    if g.Character or LocalPlayer.Character then character_added_jump_height_changer_Life_Together_RP(g.Character or LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(character_added_jump_height_changer_Life_Together_RP)
end

g.always_show_title_of_player_regardless_of_chats = g.always_show_title_of_player_regardless_of_chats or function(toggled)
    local lib = g.FlamesLibrary
    local fw = lib.wait
    local key = "showing_billboard_titles_above_heads_anyways"

    if toggled == true then
        if g.always_show_title_above_head then
            return g.notify("Warning", "Flames Hub | Anti-Title_Hider is already enabled!", 6)
        end

        g.notify("Success", "Flames Hub | Anti-Title_Hider is now enabled.", 5)
        g.always_show_title_above_head = true
        lib.spawn(key, "spawn", function()
            while g.always_show_title_above_head == true do
            fw(0)
                for _, v in ipairs(Players:GetPlayers()) do
                    if v ~= Players.LocalPlayer then
                        if not v:GetAttribute("chatting") then lib.disconnect("showing_billboard_titles_above_heads_anyways") end
                        v:SetAttribute("chatting", false)
                    end
                end
            end
        end)
    elseif toggled == false then
        if not g.always_show_title_above_head then return g.notify("Warning", "Flames Hub | Anti-Title_Hider is not enabled!", 6) end
        g.always_show_title_above_head = false
        lib.disconnect(key)
        g.notify("Success", "Flames Hub | Anti-Title_Hider is now disabled.", 5)
    else
        return 
    end
end

g.change_RP_Name = g.change_RP_Name or function(New_Name)
    getgenv().Send("roleplay_name", tostring(New_Name))
end

g.change_bio = g.change_bio or function(New_Bio)
    getgenv().Send("bio", tostring(New_Bio))
end
wait(0.25)
-- [[ ultra safe checking that always works + falls back to your current roleplay name if not already saved so you don't have to do it yourself. ]] --
g.WaitForAttribute = g.WaitForAttribute or function(Instance, Attribute, Timeout)
    local Existing = Instance:GetAttribute(Attribute)
    if Existing ~= nil then return Existing end
    local Start = tick()
    while tick() - Start < (Timeout or 10) do
        local Val = Instance:GetAttribute(Attribute)
        if Val ~= nil then return Val end
        task.wait(0.1)
    end
    return nil
end

g.SafeRead = g.SafeRead or function(File, Fallback)
    if not (isfile and isfile(File)) then return Fallback end
    local Val = readfile(File)
    if not Val or #Val == 0 or Val == "nil" then return Fallback end
    return Val
end

g.SafeAttr = g.SafeAttr or function(Attribute)
    local Val = g.WaitForAttribute(g.LocalPlayer, Attribute, 10)
    if Val == nil then return nil end
    local Str = tostring(Val)
    return (#Str > 0 and Str ~= "nil") and Str or nil
end

if isfile and readfile and writefile and makefolder then
    local Folder = "Life_Together_Custom_Name_Configuration"
    local ConfigPath = Folder .. "/config.json"
    local HttpService = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
    if not isfolder(Folder) then makefolder(Folder) end
    local Config = { Name = "DEFAULT", Bio = "DEFAULT" }
    local Existing = g.SafeRead(ConfigPath, nil)
    if Existing then
        local Decoded = HttpService:JSONDecode(Existing)
        if Decoded then
            Config.Name = tostring(Decoded.Name or "DEFAULT")
            Config.Bio = tostring(Decoded.Bio or "DEFAULT")
        end
    else
        writefile(ConfigPath, HttpService:JSONEncode(Config))
        g.notify("Success", "Creating config file for you (it didn't exist)...", 10)
    end

    if Config.Name ~= "DEFAULT" then
        g.notify("Success", "Got your last RP name (it was erased by Life Together RP), but we're setting it back!", 15)
        g.change_RP_Name(Config.Name)
    else
        local Name_To_Write = g.SafeAttr("roleplay_name")
        g.change_RP_Name(Name_To_Write)
        if Name_To_Write then
            Config.Name = Name_To_Write
        end
    end

    if Config.Bio ~= "DEFAULT" then
        g.notify("Success", "Got your last RP bio (it was erased by Life Together RP), but we're setting it back!", 15)
        g.change_bio(Config.Bio)
    else
        local Bio_To_Write = g.SafeAttr("bio")
        g.change_bio(Bio_To_Write)
        if Bio_To_Write then
            Config.Bio = Bio_To_Write
        end
    end

    writefile(ConfigPath, HttpService:JSONEncode(Config))
end

g.job_spammer = g.job_spammer or function(toggle)
    local lib = g.FlamesLibrary
    local key = "job_spammer_loop"
    local fw = lib.wait

    if toggle == true then
        if g.Every_Job then return notify("Warning", "Job spammer is already enabled! disable it first.", 5) end
        g.Every_Job = true
        notify("Success", "Job Spammer has been enabled.", 5)
        lib.spawn(key, "spawn", function()
            while g.Every_Job == true do
            fw(0)
                g.Send("job", "Police")
                fw(0)
                g.Send("job", "Firefighter")
                fw(0)
                g.Send("job", "Baker")
                fw(0)
                g.Send("job", "Pizza Worker")
                fw(0)
                g.Send("job", "Barista")
                fw(0)
                g.Send("job", "Doctor")
                fw(0)
            end
            lib.disconnect(key)
        end)
    elseif toggle == false then
        if not g.Every_Job then return notify("Warning", "Job spammer is not enabled! enable it first.", 5) end
        g.Every_Job = false
        lib.disconnect(key)
        notify("Success", "Job Spammer has been disabled.", 5)
    end
end

g.stored_effects_main_tbl = g.stored_effects_main_tbl or {}
g.stored_parts_main_tbl = g.stored_parts_main_tbl or {}
g.parts_seen = g.parts_seen or {}
local lighting = g.Lighting or cloneref and cloneref(game:GetService("Lighting")) or game:GetService("Lighting")
local work = cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
g.validWorkspacePart = g.validWorkspacePart or function(inst)
    if not inst or not inst.Parent then return false end
    if inst:IsDescendantOf(lighting) then return false end
    if inst:IsDescendantOf(LocalPlayer.Character or Instance.new("Folder")) then return false end
    return true
end

g.saveAndModify = g.saveAndModify or function(inst)
    if g.parts_seen[inst] then return end
    g.parts_seen[inst] = true
    if inst:IsA("BasePart") then
        table.insert(g.stored_parts_main_tbl, {inst = inst, prop = "cast", val = inst.CastShadow})
        inst.CastShadow = false
    elseif inst:IsA("Decal") then
        table.insert(g.stored_parts_main_tbl, {inst = inst, prop = "decal", tex = inst.Texture, transp = inst.Transparency})
        inst.Transparency = 1
        inst.Texture = ""
    elseif inst:IsA("ParticleEmitter") then
        table.insert(g.stored_parts_main_tbl, {inst = inst, prop = "particle", enabled = inst.Enabled, rate = inst.Rate})
        inst.Enabled = false
        inst.Rate = 0
    elseif inst:IsA("Trail") then
        table.insert(g.stored_parts_main_tbl, {inst = inst, prop = "trail", enabled = inst.Enabled})
        inst.Enabled = false
    end
end

g.posteffparts = g.posteffparts or function(toggle)
    local genv = g

    if toggle then
        if genv.post_effects_off_main then return end
        genv.post_effects_off_main = true
        table.clear(genv.stored_effects_main_tbl)
        table.clear(genv.stored_parts_main_tbl)
        table.clear(genv.parts_seen)
        for _, v in ipairs(lighting:GetDescendants()) do
            if v:IsA("PostEffect") then
                table.insert(genv.stored_effects_main_tbl, {inst = v, enabled = v.Enabled})
                v.Enabled = false
            end
        end

        for _, v in ipairs(work:GetDescendants()) do
            if validWorkspacePart(v) then
                saveAndModify(v)
            end
        end

        genv._saved_fog_start = lighting.FogStart
        genv._saved_fog_end = lighting.FogEnd
        lighting.FogStart = 1e5
        lighting.FogEnd = 1e5

        if genv.parts_disabler_conn then genv.parts_disabler_conn:Disconnect() end
        genv.parts_disabler_conn = work.DescendantAdded:Connect(function(child)
            if not genv.post_effects_off_main then return end
            if not validWorkspacePart(child) then return end
            task.defer(function()
                if child.Parent then
                    saveAndModify(child)
                end
            end)
        end)
    else
        if not genv.post_effects_off_main then return end
        genv.post_effects_off_main = false

        for _, v in ipairs(genv.stored_effects_main_tbl) do
            if v.inst and v.inst.Parent then
                v.inst.Enabled = v.enabled
            end
        end

        for _, data in ipairs(genv.stored_parts_main_tbl) do
            if data.inst and data.inst.Parent then
                if data.prop == "cast" then
                    data.inst.CastShadow = data.val
                elseif data.prop == "decal" then
                    data.inst.Transparency = data.transp
                    data.inst.Texture = data.tex
                elseif data.prop == "particle" then
                    data.inst.Enabled = data.enabled
                    data.inst.Rate = data.rate
                elseif data.prop == "trail" then
                    data.inst.Enabled = data.enabled
                end
            end
        end

        if genv.parts_disabler_conn then
            genv.parts_disabler_conn:Disconnect()
            genv.parts_disabler_conn = nil
        end

        if genv._saved_fog_start then lighting.FogStart = genv._saved_fog_start end
        if genv._saved_fog_end then lighting.FogEnd = genv._saved_fog_end end
        table.clear(genv.stored_effects_main_tbl)
        table.clear(genv.stored_parts_main_tbl)
        table.clear(genv.parts_seen)
    end
end

g.TogglePostEffectsParts = posteffparts
g.FlamesLagReducerFunc = g.FlamesLagReducerFunc or function(toggle)
    if toggle then
        if g.ultimate_lag_reducer then return notify("Warning", "Flames Hub | Lag Reducer : is already enabled.", 10) end
        g.ultimate_lag_reducer = true
        notify("Success", "Flames Hub | Lag Reducer : is now enabled.", 5)
        pcall(function() g.Send("hide_other_names", true) end)
        pcall(function() g.Send("hide_map_icon", true) end)
        if togglergbflows and typeof(togglergbflows) == "function" then pcall(togglergbflows, false) end
        posteffparts(true)
    else
        if not g.ultimate_lag_reducer then return notify("Warning", "Flames Hub | Lag Reducer : is not enabled.", 10) end
        g.ultimate_lag_reducer = false
        notify("Success", "Flames Hub | Lag Reducer : is now disabled.", 5)
        pcall(function() g.Send("hide_other_names", false) end)
        pcall(function() g.Send("hide_map_icon", false) end)
        posteffparts(false)
    end
end

g.DefaultSpeed = g.StarterPlayer.CharacterWalkSpeed
g.DefaultJP = g.StarterPlayer.CharacterJumpHeight
g.Old_Workspace_Gravity = g.Workspace.Gravity
g.change_property = g.change_property or function(property, new_property_value)
    local properties_allowed_to_be_changed = {
        WalkSpeed = true,
        JumpHeight = true,
        HipHeight = true
    }

    if properties_allowed_to_be_changed[property] and g.Humanoid then g.Humanoid[property] = new_property_value end
end

g.change_gravity_val = g.change_gravity_val or function(new_val)
    if new_val > 300 then new_val = 196 end
    g.Workspace.Gravity = tonumber(new_val) or 196
end

g.reset_properties = g.reset_properties or function()
   if not g.Humanoid then return end
   g.Humanoid.WalkSpeed = DefaultSpeed or 16
   g.Humanoid.JumpHeight = DefaultJP or 7
   g.Workspace.Gravity = Old_Workspace_Gravity or 196
end

g.rainbow_car = g.rainbow_car or function()
    RGB_Vehicle(true)
end

g.stop_rainbow_car = g.stop_rainbow_car or function()
    RGB_Vehicle(false)
end

g.rainbow_others_car = g.rainbow_others_car or function(Player)
    RGB_Vehicle_Others(Player, true)
end

g.stop_rainbow_others_car = g.stop_rainbow_others_car or function(Player)
    RGB_Vehicle_Others(Player, false)
end

local character = g.Character or g.LocalPlayer.Character or get_char(LocalPlayer or game.Players.LocalPlayer)
local humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer or game.Players.LocalPlayer)
local camera = Workspace.CurrentCamera or g.Workspace.CurrentCamera or workspace.CurrentCamera
g.AdonisAdminFlyEnabled = g.AdonisAdminFlyEnabled or false
g.AdonisAdminFlySpeed = g.AdonisAdminFlySpeed or 15
g.FlyConnections = g.FlyConnections or {}
g.FlyPart = g.FlyPart or nil

g.SetAdonisFlySpeed = g.SetAdonisFlySpeed or function(v)
    v = tonumber(v)
    if not v then return end
    g.AdonisAdminFlySpeed = math.clamp(v, 1, 300)
end

g.StartAdonisAdminFlyScript = g.StartAdonisAdminFlyScript or function()
    if g.AdonisAdminFlyEnabled then return end
    g.AdonisAdminFlyEnabled = true
    local dir = {w = false, a = false, s = false, d = false, q = false, e = false}
    local cf = Instance.new("CFrameValue")

    if not g.FlyPart then
        g.FlyPart = Instance.new("Part")
        g.FlyPart.Name = "PART_SURFER"
        g.FlyPart.Anchored = true
        g.FlyPart.Parent = StarterPack
        g.FlyPart.CFrame = HumanoidRootPart and HumanoidRootPart.CFrame or CFrame.new()
    end

    g.FlyConnections.render = RunService.RenderStepped:Connect(function()
        if not g.AdonisAdminFlyEnabled or not HumanoidRootPart then return end
        local speed = tonumber(g.AdonisAdminFlySpeed) or 15
        speed = math.clamp(speed, 1, 300)

        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Velocity = Vector3.zero
                v.RotVelocity = Vector3.zero
            end
        end

        g.FlyPart.CFrame = CFrame.new(
            g.FlyPart.CFrame.Position,
            (camera.CFrame * CFrame.new(0, 0, -100)).Position
        )

        local offset = Vector3.zero
        if isMobile and controlModule then
            local mv = controlModule:GetMoveVector()
            if mv.Magnitude > 0 then
                offset =
                (camera.CFrame.LookVector * -mv.Z +
                camera.CFrame.RightVector * mv.X) * speed
            end
        else
            local x, y, z = 0, 0, 0
            if dir.w then z = -speed end
            if dir.s then z = speed end
            if dir.a then x = -speed end
            if dir.d then x = speed end
            if dir.q then y = speed end
            if dir.e then y = -speed end
            offset = Vector3.new(x, y, z)
        end

        local moveCF = CFrame.new(offset)
        cf.Value = cf.Value:Lerp(moveCF, 0.2)
        g.FlyPart.CFrame = g.FlyPart.CFrame:Lerp(g.FlyPart.CFrame * cf.Value, 0.2)
        HumanoidRootPart.CFrame = g.FlyPart.CFrame
        humanoid.PlatformStand = true
    end)

    g.FlyConnections.inputBegan = UserInputService.InputBegan:Connect(function(input, event)
        if event or not g.AdonisAdminFlyEnabled then return end
        local code, codes = input.KeyCode, Enum.KeyCode
        if code == codes.W then
            dir.w = true
        elseif code == codes.A then dir.a = true
        elseif code == codes.S then dir.s = true
        elseif code == codes.D then dir.d = true
        elseif code == codes.Q then dir.q = true
        elseif code == codes.E then dir.e = true
        elseif code == codes.Space then
            dir.q = true
        end
    end)

    g.FlyConnections.inputEnded = UserInputService.InputEnded:Connect(function(input, event)
        if event or not g.AdonisAdminFlyEnabled then return end
        local code, codes = input.KeyCode, Enum.KeyCode
        if code == codes.W then
            dir.w = false
        elseif code == codes.A then dir.a = false
        elseif code == codes.S then dir.s = false
        elseif code == codes.D then dir.d = false
        elseif code == codes.Q then dir.q = false
        elseif code == codes.E then dir.e = false
        elseif code == codes.Space then
            dir.q = false
        end
    end)
    fw(0.1)
    g.notify("Success", "Fly-3 has been enabled with speed: "..tostring(g.AdonisAdminFlySpeed), 6)
end

g.Stop_Fly_3_Function = g.Stop_Fly_3_Function or function()
    if not g.AdonisAdminFlyEnabled then return notify("Warning", "Fly-3 is not enabled.", 5) end
    g.AdonisAdminFlyEnabled = false

    for _, conn in pairs(g.FlyConnections) do if conn then conn:Disconnect() end end
    if next(g.FlyConnections) then g.FlyConnections = {} end
    if g.FlyPart then
        g.FlyPart:Destroy()
        g.FlyPart = nil
    end
    if humanoid then humanoid.PlatformStand = false end
end

g.Enabled_Flying = g.Enabled_Flying or false
g.Fly2Speed = g.Fly2Speed or 45
g.Fly2Control = nil
g.fly2InputBegan = nil
g.fly2InputEnded = nil
g.fly2Heartbeat = nil
g.fly2MobileConn = nil
g.EnableFly2 = g.EnableFly2 or function(speed)
    if g.Enabled_Flying then
        return notify("Warning", "Fly-2 is already enabled!", 5)
    end

    local UIS = g.UserInputService
    local plr = g.LocalPlayer or game.Players.LocalPlayer
    local char = g.Character or plr.Character or get_char(plr, 10)
    local HRP = g.HumanoidRootPart or char and char:FindFirstChild("HumanoidRootPart") or get_root(plr, 5)
    local Humanoid = g.Humanoid or char and char:FindFirstChildOfClass("Humanoid") or get_human(plr, 5)
    local Workspace = g.Workspace or safe_wrapper("Workspace")
    local RunService = g.RunService or safe_wrapper("RunService")
    local Debris = g.Debris or safe_wrapper("Debris")
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

        g.notify("Success", "Fly-2 enabled (PC) | Speed: " .. tostring(g.Fly2Speed), 5)
        return
    end

    local controlModule
    local ok, result = pcall(function()
        return require(plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    end)
    if ok then controlModule = result end
    g.fly2MobileConn = RunService.RenderStepped:Connect(function()
        if not g.Enabled_Flying then return end
        local cam = Workspace.CurrentCamera
        local s = g.Fly2Speed * 50
        local move = controlModule and controlModule:GetMoveVector() or Vector3.zero

        if move.Magnitude > 0 then
            vel.Velocity = (cam.CFrame.LookVector * -move.Z + cam.CFrame.RightVector * move.X) * s
        else
            vel.Velocity = Vector3.zero
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

    notify("Success", "Fly-2 enabled (Mobile) | Speed: " .. tostring(g.Fly2Speed), 5)
end

g.DisableFly2 = g.DisableFly2 or function()
    if not g.Enabled_Flying then return notify("Warning", "Fly-2 is not enabled, enable it first!", 5) end
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

g.vehicle_stats_viewer_GUI = g.vehicle_stats_viewer_GUI or function()
    local Vehicles = g.Workspace:FindFirstChild("Vehicles")
    if not Vehicles then
        return notify("Error", "Vehicles Folder not found!", 5)
    end
    if g.Vehicle_Stats_GUI_Active then
        return notify("Error", "Vehicle Stats Viewer already running!", 5)
    end

    g.Vehicle_Stats_GUI_Active = true
    g.VehicleUI = {}
    g.vehicle_attr_conns = {}
    g.Vehicle_Added_And_Removed_Conns = {}

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VehicleStatsGUI"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = parent_gui
    g.VehicleStatsGUI = ScreenGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,300,0,400)
    MainFrame.Position = UDim2.new(0,20,0,100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,12)
    repeat task.wait(1) until MainFrame and MainFrame:IsA("Frame") and ScreenGui:FindFirstChildOfClass("Frame")
    wait(0.5)
    dragify(MainFrame)
    g.notify("Info", "Loading Vehicle Stats viewer.", 3)

    function Unhook(vehicle)
        local ui = g.VehicleUI[vehicle]
        if not ui then return end

        local conns = g.vehicle_attr_conns[vehicle]
        if conns then
            for _,c in ipairs(conns) do
                if c then
                    pcall(function()
                        c:Disconnect()
                    end)
                end
            end
        end

        if ui.Frame then
            pcall(function()
                ui.Frame:Destroy()
            end)
        end

        g.vehicle_attr_conns[vehicle] = nil
        g.VehicleUI[vehicle] = nil
    end

    function Hook(vehicle)
        if g.VehicleUI[vehicle] then return end

        local ui = CreateEntry(vehicle)
        g.VehicleUI[vehicle] = ui
        local conns = {}
        g.vehicle_attr_conns[vehicle] = conns

        table.insert(conns, vehicle:GetAttributeChangedSignal("speed"):Connect(function()
            ui.Speed.Text = tostring(vehicle:GetAttribute("speed") or 0)
        end))

        table.insert(conns, vehicle:GetAttributeChangedSignal("acceleration"):Connect(function()
            ui.Accel.Text = tostring(vehicle:GetAttribute("acceleration") or 0)
        end))

        table.insert(conns, vehicle:GetAttributeChangedSignal("handling"):Connect(function()
            ui.Handling.Text = tostring(vehicle:GetAttribute("handling") or 0)
        end))

        table.insert(conns, vehicle:GetAttributeChangedSignal("color"):Connect(function()
            local c = vehicle:GetAttribute("color")
            if typeof(c) == "Color3" then
                ui.Color.BackgroundColor3 = c
            end
        end))

        table.insert(conns, vehicle.AncestryChanged:Connect(function(_, parent)
            if not parent then
                Unhook(vehicle)
            end
        end))
    end

    local Title = Instance.new("TextLabel")
    Title.Text = "Vehicle Stats Viewer"
    Title.Size = UDim2.new(1,-40,0,30)
    Title.Position = UDim2.new(0,10,0,5)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    local Close = Instance.new("TextButton")
    Close.Text = "X"
    Close.Size = UDim2.new(0,30,0,30)
    Close.Position = UDim2.new(1,-35,0,5)
    Close.BackgroundColor3 = Color3.fromRGB(50,50,50)
    Close.TextColor3 = Color3.fromRGB(255,255,255)
    Close.Parent = MainFrame
    Instance.new("UICorner", Close).CornerRadius = UDim.new(0,8)

    Close.MouseButton1Click:Connect(function()
        g.Vehicle_Stats_GUI_Active = false
        if g.Vehicle_Added_And_Removed_Conns then
            for _, conn in pairs(g.Vehicle_Added_And_Removed_Conns) do
                pcall(function() conn:Disconnect() end)
            end
            table.clear(g.Vehicle_Added_And_Removed_Conns)
        end

        for v in pairs(g.VehicleUI) do Unhook(v) end
        ScreenGui:Destroy()
    end)

    local Scroller = Instance.new("ScrollingFrame")
    Scroller.Size = UDim2.new(1,-20,1,-90)
    Scroller.Position = UDim2.new(0,10,0,40)
    Scroller.CanvasSize = UDim2.new(0,0,0,0)
    Scroller.ScrollBarThickness = 6
    Scroller.BackgroundTransparency = 1
    Scroller.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0,10)
    Layout.Parent = Scroller

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroller.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y + 10)
    end)

    local function Validate_Model(v)
        if not v:IsA("Model") then return false end
        if v:FindFirstChild("Base") then return true end
        v:WaitForChild("Base", 3)
        return v:FindFirstChild("Base") ~= nil
    end

    g.get_color_name = function(color)
        if not color or typeof(color) ~= "Color3" then return "Unknown" end
        local get_color_name_colors = {
            {"White",1,242,243,243},
            {"Grey",2,161,165,162},
            {"Light yellow",3,249,233,153},
            {"Brick yellow",5,215,197,154},
            {"Light green (Mint)",6,194,218,184},
            {"Light reddish violet",9,232,186,200},
            {"Pastel Blue",11,128,187,219},
            {"Light orange brown",12,203,132,66},
            {"Nougat",18,204,142,105},
            {"Bright red",21,196,40,28},
            {"Med. reddish violet",22,196,112,160},
            {"Bright blue",23,13,105,172},
            {"Bright yellow",24,245,205,48},
            {"Earth orange",25,98,71,50},
            {"Black",26,27,42,53},
            {"Dark grey",27,109,110,108},
            {"Dark green",28,40,127,71},
            {"Medium green",29,161,196,140},
            {"Lig. Yellowich orange",36,243,207,155},
            {"Bright green",37,75,151,75},
            {"Dark orange",38,160,95,53},
            {"Light bluish violet",39,193,202,222},
            {"Transparent",40,236,236,236},
            {"Tr. Red",41,205,84,75},
            {"Tr. Lg blue",42,193,223,240},
            {"Tr. Blue",43,123,182,232},
            {"Tr. Yellow",44,247,241,141},
            {"Light blue",45,180,210,228},
            {"Tr. Flu. Reddish orange",47,217,133,108},
            {"Tr. Green",48,132,182,141},
            {"Tr. Flu. Green",49,248,241,132},
            {"Phosph. White",50,236,232,222},
            {"Light red",100,238,196,182},
            {"Medium red",101,218,134,122},
            {"Medium blue",102,110,153,202},
            {"Light grey",103,199,193,183},
            {"Bright violet",104,107,50,124},
            {"Br. yellowish orange",105,226,155,64},
            {"Bright orange",106,218,133,65},
            {"Bright bluish green",107,0,143,156},
            {"Earth yellow",108,104,92,67},
            {"Bright bluish violet",110,67,84,147},
            {"Tr. Brown",111,191,183,177},
            {"Medium bluish violet",112,104,116,172},
            {"Tr. Medi. reddish violet",113,229,173,200},
            {"Med. yellowish green",115,199,210,60},
            {"Med. bluish green",116,85,165,175},
            {"Light bluish green",118,183,215,213},
            {"Br. yellowish green",119,164,189,71},
            {"Lig. yellowish green",120,217,228,167},
            {"Med. yellowish orange",121,231,172,88},
            {"Br. reddish orange",123,211,111,76},
            {"Bright reddish violet",124,146,57,120},
            {"Light orange",125,234,184,146},
            {"Tr. Bright bluish violet",126,165,165,203},
            {"Gold",127,220,188,129},
            {"Dark nougat",128,174,122,89},
            {"Silver",131,156,163,168},
            {"Neon orange",133,213,115,61},
            {"Neon green",134,216,221,86},
            {"Sand blue",135,116,134,157},
            {"Sand violet",136,135,124,144},
            {"Medium orange",137,224,152,100},
            {"Sand yellow",138,149,138,115},
            {"Earth blue",140,32,58,86},
            {"Earth green",141,39,70,45},
            {"Tr. Flu. Blue",143,207,226,247},
            {"Sand blue metallic",145,121,136,161},
            {"Sand violet metallic",146,149,142,163},
            {"Sand yellow metallic",147,147,135,103},
            {"Dark grey metallic",148,87,88,87},
            {"Black metallic",149,22,29,50},
            {"Light grey metallic",150,171,173,172},
            {"Sand green",151,120,144,130},
            {"Sand red",153,149,121,119},
            {"Dark red",154,123,46,47},
            {"Tr. Flu. Yellow",157,255,246,123},
            {"Tr. Flu. Red",158,225,164,194},
            {"Gun metallic",168,117,108,98},
            {"Dark stone grey",199,99,95,98},
            {"Medium stone grey",194,163,162,165},
            {"Light stone grey",208,229,228,223},
            {"Really black",1003,17,17,17},
            {"Really red",1004,255,0,0},
            {"Deep orange",1005,255,176,0},
            {"Alder",1006,180,128,255},
            {"Dusty Rose",1007,163,75,75},
            {"Olive",1008,193,190,66},
            {"New Yeller",1009,255,255,0},
            {"Really blue",1010,0,0,255},
            {"Navy blue",1011,0,32,96},
            {"Deep blue",1012,33,84,185},
            {"Cyan",1013,4,175,236},
            {"CGA brown",1014,170,85,0},
            {"Magenta",1015,170,0,170},
            {"Pink",1016,255,102,204},
            {"Deep orange",1017,255,175,0},
            {"Teal",1018,18,238,212},
            {"Toothpaste",1019,0,255,255},
            {"Lime green",1020,0,255,0},
            {"Camo",1021,58,125,21},
            {"Grime",1022,127,142,100},
            {"Lavender",1023,140,91,159},
            {"Pastel light blue",1024,175,221,255},
            {"Pastel orange",1025,255,201,201},
            {"Pastel violet",1026,177,167,255},
            {"Pastel blue-green",1027,159,243,233},
            {"Pastel green",1028,204,255,204},
            {"Pastel yellow",1029,255,255,204},
            {"Pastel brown",1030,255,204,153},
            {"Royal purple",1031,98,37,209},
            {"Hot pink",1032,255,0,191},
        }

        local closest, closestDist = "Unknown", math.huge
        local r, g, b = color.R * 255, color.G * 255, color.B * 255
        for _, c in ipairs(get_color_name_colors) do
            local _, _, R, G, B = unpack(c)
            local dist = (R - r)^2 + (G - g)^2 + (B - b)^2
            if dist < closestDist then
                closestDist = dist
                closest = c[1]
            end
        end

        return closest
    end

    local function WaitForAttribute(inst, attr, timeout)
        if inst:GetAttribute(attr) ~= nil then return inst:GetAttribute(attr) end
        local done = false
        local val
        local conn
        conn = inst:GetAttributeChangedSignal(attr):Connect(function()
            val = inst:GetAttribute(attr)
            done = true
            conn:Disconnect()
        end)

        local t = tick()
        while not done and tick() - t < (timeout or 5) do
            task.wait()
        end

        if conn then conn:Disconnect() end
        return inst:GetAttribute(attr)
    end

    local function CreateEntry(vehicle)
        local Holder = Instance.new("Frame")
        Holder.Size = UDim2.new(1,0,0,220)
        Holder.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Holder.Parent = Scroller
        Instance.new("UICorner", Holder).CornerRadius = UDim.new(0,10)

        local Click = Instance.new("TextButton")
        Click.Size = UDim2.new(1,0,1,0)
        Click.BackgroundTransparency = 1
        Click.Text = ""
        Click.Parent = Holder
        Click.Activated:Connect(function()
            g.SelectedVehicle = vehicle.Name
        end)

        local spawn = Instance.new("TextButton")
        spawn.Size = UDim2.new(1,-20,0,28)
        spawn.Position = UDim2.new(0,10,1,-34)
        spawn.Text = "Spawn"
        spawn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        spawn.TextColor3 = Color3.fromRGB(255,255,255)
        spawn.Font = Enum.Font.GothamMedium
        spawn.TextSize = 14
        spawn.Parent = Holder
        Instance.new("UICorner", spawn).CornerRadius = UDim.new(0,8)

        spawn.Activated:Connect(function()
            g.SelectedVehicle = vehicle.Name
            g.Send("spawn_vehicle", vehicle.Name)

            local my_vehicle
            local t = tick()

            repeat
                my_vehicle = get_vehicle()
                task.wait()
            until my_vehicle or tick() - t > 6

            if not my_vehicle then return end

            local col = vehicle:GetAttribute("color")
            if typeof(col) == "Color3" then
                g.Send("vehicle_color", col, my_vehicle)
            end
        end)

        local function label(txt,y)
            local l = Instance.new("TextLabel")
            l.Text = txt
            l.Size = UDim2.new(1,-10,0,18)
            l.Position = UDim2.new(0,5,0,y)
            l.BackgroundTransparency = 1
            l.TextColor3 = Color3.fromRGB(180,180,180)
            l.Font = Enum.Font.Gotham
            l.TextSize = 13
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.Parent = Holder
            return l
        end

        local name = label("Vehicle: "..vehicle.Name,5)
        name.TextColor3 = Color3.fromRGB(255,255,255)
        name.Font = Enum.Font.GothamMedium
        local owner = label("Owner: N/A",24)
        local maxAcc = label("Max Acceleration: N/A",44)
        local maxSpeed = label("Max Speed: N/A",64)
        local acc60 = label("Acceleration (0 To 60): N/A",84)
        local turn = label("Turn Angle: N/A",104)
        local locked = label("Locked: N/A",124)
        local color = label("Color: N/A",144)

        g.VehicleUI[vehicle] = {
            Frame = Holder,
            Owner = owner,
            MaxAcc = maxAcc,
            MaxSpeed = maxSpeed,
            Acc60 = acc60,
            TurnAngle = turn,
            LockedStatus = locked,
            ColorLabel = color
        }
    end

    local function Update(vehicle)
        local ui = g.VehicleUI[vehicle]
        if not ui then return end
        ui.MaxAcc.Text = "Max Acceleration: "..math.floor(vehicle:GetAttribute("max_acc") or 0)
        ui.MaxSpeed.Text = "Max Speed: "..math.floor(vehicle:GetAttribute("max_speed") or 0)
        ui.Acc60.Text = "Acceleration (0 To 60): "..math.floor(vehicle:GetAttribute("acc_0_60") or 0)
        ui.TurnAngle.Text = "Turn Angle: "..math.floor(vehicle:GetAttribute("turn_angle") or 0)
        ui.LockedStatus.Text = "Locked: "..tostring(vehicle:GetAttribute("locked"))

        local c = vehicle:GetAttribute("color")
        if typeof(c) ~= "Color3" then
            c = WaitForAttribute(vehicle, "color", 5)
        end

        if typeof(c) == "Color3" then
            ui.ColorLabel.Text = "Color: "..g.get_color_name(c)
        else
            ui.ColorLabel.Text = "Color: Unknown"
        end

        local owner = vehicle:GetAttribute("OwnerName")
        ui.Owner.Text = "Owner: "..(owner or "Server Spawned")
    end

    local function Hook(vehicle)
        if g.VehicleUI[vehicle] then return end
        if not Validate_Model(vehicle) then return end

        CreateEntry(vehicle)
        Update(vehicle)

        g.vehicle_attr_conns[vehicle] = {}
        for _,a in ipairs({"OwnerName","max_acc","max_speed","acc_0_60","turn_angle","locked","color"}) do
            table.insert(g.vehicle_attr_conns[vehicle], vehicle:GetAttributeChangedSignal(a):Connect(function()
                Update(vehicle)
            end))
        end
    end

    for _,v in ipairs(Vehicles:GetChildren()) do Hook(v) end
    if g.Vehicle_Added_And_Removed_Conns.Child_Added_Watcher then
        pcall(function() g.Vehicle_Added_And_Removed_Conns.Child_Added_Watcher:Disconnect() end)
    end
    if g.Vehicle_Added_And_Removed_Conns.Child_Removed_Watcher then
        pcall(function() g.Vehicle_Added_And_Removed_Conns.Child_Removed_Watcher:Disconnect() end)
    end
    wait(0.25)
    g.Vehicle_Added_And_Removed_Conns.Child_Added_Watcher = Vehicles.ChildAdded:Connect(function(v)
        task.defer(function()
            Hook(v)
        end)
    end)

    g.Vehicle_Added_And_Removed_Conns.Child_Removed_Watcher = Vehicles.ChildRemoved:Connect(function(v)
        task.defer(function()
            Unhook(v)
        end)
    end)
end

g.check_premium_player = g.check_premium_player or function(plr)
    if plr then
        if plr:GetAttribute("is_verified") == true then
            return true
        else
            return false
        end
    end
end

g.bansystem = g.bansystem or {
    enabled = false,
    list = {},
    connection = nil
}

function addban(input)
    if not input then return nil end
    if typeof(input) == "Instance" and input.Name then
        local n = input.Name:lower()
        g.bansystem.list[n] = true
        return n
    end
    local q = tostring(input):lower()
    if q == "" then return nil end
    for _,v in pairs(Players:GetPlayers()) do
        local ln = v.Name:lower()
        local ld = v.DisplayName:lower()
        if ln:find(q, 1, true) or ld:find(q, 1, true) then
            g.bansystem.list[ln] = true
            kick_plr(v)
            return ln
        end
    end
    g.bansystem.list[q] = true
    return q
end

function removeban(input)
    if not input then return nil end
    local q = tostring(input):lower()
    if q == "" then return nil end
    if g.bansystem.list[q] then
        g.bansystem.list[q] = nil
        return q
    end
    for name,_ in pairs(g.bansystem.list) do
        if name:find(q, 1, true) then
            g.bansystem.list[name] = nil
            return name
        end
    end
    return nil
end

function checkban(player)
    local n = player.Name:lower()
    if g.bansystem.list[n] then
        if g.bansystem.enabled then
            kick_plr(player)
        end
    end
end

function disablebans()
    g.bansystem.enabled = false
    if g.bansystem.connection then
        g.bansystem.connection:Disconnect()
        g.bansystem.connection = nil
    end
end

g.start_bansystem = g.start_bansystem or function()
    if g.bansystem.enabled then return end
    if g.bansystem.starting then return end
    g.bansystem.starting = true

    task.spawn(function()
        for i = 1, 5 do
            if is_localplayer_server_owner() then
                g.bansystem.enabled = true
                g.bansystem.starting = false
                for _, p in ipairs(Players:GetPlayers()) do
                    task.spawn(function()
                        fw(0.2)
                        checkban(p)
                    end)
                end

                if g.bansystem.connection then
                    pcall(function() g.bansystem.connection:Disconnect() end)
                    g.bansystem.connection = nil
                end
                wait(0.25)
                g.bansystem.connection = Players.PlayerAdded:Connect(checkban)
                g.notify("Success", "Ban system enabled.", 5)
                return
            end
            wait(1)
        end
        g.bansystem.starting = false
        g.notify("Info", "Ban system inactive.", 5)
    end)
end
fw(0.1)
if not g.Ban_System_In_Flames_Hub_Has_Been_Started_Already then
    g.Ban_System_In_Flames_Hub_Has_Been_Started_Already = true  -- actually set it!
    task.spawn(function() start_bansystem() end)
end

g.get_server_admin_title_player = g.get_server_admin_title_player or function()
    for _, obj in g.Character:GetDescendants() do
        if obj.Name:lower():find("server") and obj.Name:lower():find("admin") and obj:IsA("TextLabel") then
            return obj
        end
    end
end

g.flash_server_admin_title_client_sided = g.flash_server_admin_title_client_sided or function(toggle)
    local localplayer_admin_of_priv_server = g.get_server_admin_title_player()
    if not localplayer_admin_of_priv_server then return end
    local fw = g.FlamesLibrary.wait
    local preset_texts = {"Flames Admin", "Server Admin", "Destroyer Admin", "Owner Admin", "Demon Admin", "Straight Crime", "Powerful Admin", "Creator Admin", "fLaMeS rUlEs", "FLAMES ADMIN"}

    if toggle == true then
        if g.Server_Admin_Text_Title_Changer then
            return g.notify("Warning", "Server Admin Title Text changer is already enabled!", 5)
        end

        g.Server_Admin_Text_Title_Changer = true
        g.FlamesLibrary.spawn("server_admin_title_text_changer_main_loop", "spawn", function()
            while g.Server_Admin_Text_Title_Changer == true do
            fw(0)
                for _, text in ipairs(preset_texts) do
                    localplayer_admin_of_priv_server.Text = text
                    fw(0)
                end
            end
        end)
    elseif toggle == false then
        if not g.Server_Admin_Text_Title_Changer then
            return g.notify("Warning", "Server Admin Title Text changer is not enabled!", 5)
        end

        g.Server_Admin_Text_Title_Changer = false
        g.FlamesLibrary.disconnect("server_admin_title_text_changer_main_loop")
    else
        return 
    end
end

--if not g.Server_Admin_Text_Title_Changer then g.flash_server_admin_title_client_sided(true) end
g.is_tool_colorable = g.is_tool_colorable or function(tool)
    if tool:IsA("Tool") and (tool:GetAttribute("color1") or tool:GetAttribute("Color1")) then
        return true
    else
        return false
    end
end

g.find_backpack_tool = g.find_backpack_tool or function()
    for _, v in ipairs(g.Backpack:GetChildren()) do
        if v:IsA("Tool") and (v:GetAttribute("color1") or v:GetAttribute("Color1")) then
            return v
        end
    end

    return nil
end

g.find_character_tool = g.find_character_tool or function()
    for _, v in ipairs(g.Character:GetChildren()) do
        if v:IsA("Tool") and (v:GetAttribute("color1") or v:GetAttribute("Color1")) then
            return v
        end
    end

    return nil
end

g.find_placed_models_tool = g.find_placed_models_tool or function()
    for _, v in ipairs(g.Workspace:FindFirstChild("PlacedModels"):GetChildren()) do
        if v:IsA("Model") and (v:GetAttribute("color1") or v:GetAttribute("Color1")) then
            if v:GetAttribute("owner_id") == g.LocalPlayer.UserId then
                return v
            end
        end
    end

    return nil
end

g.find_owned_model = g.find_owned_model or function()
    local folder = Workspace:FindFirstChild("PlacedModels")
    if not folder then return nil end

    local uid = g.LocalPlayer.UserId

    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") and model:GetAttribute("owner_id") == uid then
            return model
        end
    end

    return nil
end

g.rainbow_tool = g.rainbow_tool or function(toggled)
    if toggled then
        notify("Success", "RGB Tool is now enabled.", 5)
        local tool = find_character_tool() or find_backpack_tool() or find_placed_models_tool()

        if not tool then
            g.Send("get_tool", "Gift")
            notify("Warning", "Wait! We're giving you a colorable Tool...", 5)
            fw(0.2)
            tool = find_character_tool() or find_backpack_tool() or find_placed_models_tool()
            if not tool then return notify("Error", "Tool still not found after giving you the Gift Tool.", 5) end
            if tool.Parent == g.Backpack then
                fw(0.1)
                tool.Parent = g.Character
            end

            for _, color in ipairs(colors) do
                g.Send("tool_color", tool, "color1", color)
                wait()
            end
        end

        if tool.Parent == g.Backpack then
            fw(0.1)
            tool.Parent = g.Character
        end

        g.Rainbow_Tools_FE = true
        while g.Rainbow_Tools_FE do
            tool = find_character_tool() or find_backpack_tool() or find_placed_models_tool()
            if not tool then
                g.Rainbow_Tools_FE = false
                return notify("Error", "Tool unexpectedly disappeared or was destroyed.", 5)
            end
            if tool.Parent == g.Backpack then
                fw(0.1)
                tool.Parent = g.Character
            end
            for _, color in ipairs(colors) do
                if not g.Rainbow_Tools_FE then break end
                g.Send("tool_color", tool, "color1", color)
                wait()
            end
        end
    else
        if not g.Rainbow_Tools_FE then
            return notify("Warning", "RGB Tools is not enabled!", 5)
        end

        g.Rainbow_Tools_FE = false
        notify("Success", "RGB tools has been disabled.", 5)
    end
end

g.toggle_name_func = g.toggle_name_func or function(boolean)
    if boolean == true then
        g.Send("hide_name", true)
    elseif boolean == false then
        g.Send("hide_name", false)
    else
        return notify("Error", "Invalid arguments provided.", 5)
    end
end

g.flashy_name = g.flashy_name or function(Toggle)
    local FL = getgenv().FlamesLibrary

    if Toggle == true then
        if getgenv().Flashing_Name_Title then
            return g.notify("Warning", "Name-Flasher is already enabled.", 5)
        end

        getgenv().Flashing_Name_Title = true
        FL.spawn("flashy_name_loop", "spawn", function()
            while getgenv().Flashing_Name_Title == true do
                toggle_name_func(true)
                fw(.1)
                toggle_name_func(false)
                fw(.1)
            end
        end)
    elseif Toggle == false then
        if not getgenv().Flashing_Name_Title then
            return g.notify("Warning", "Name-Flasher is not enabled.", 5)
        end

        getgenv().Flashing_Name_Title = false
        FL.disconnect("flashy_name_loop")
        fw(1.5)
        toggle_name_func(false)
    else
        return g.notify("Error", "Invalid argument(s) provided.", 5)
    end
end

g.flames_nameless_admin_ver = g.flames_nameless_admin_ver or function()
    if g.RealNamelessLoaded then
        return notify("Warning", "Nameless Admin (or the Flames Hub version) has already been loaded.", 11)
    end

    loadstring(game:HttpGet('https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua'))()
end

g.infinite_premium = g.infinite_premium or function()
    if g.GET_LOADED_IY then
        return notify("Warning", "You already have Infinite Premium running.", 5)
    end
    if g.IY_LOADED then
        return notify("Warning", "You already have Infinite Yield running! You cannot and should NOT run both at the same time.", 10)
    end

    loadstring(game:HttpGet('https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Infinite_Premium.lua'))()
end

g.infinite_yield = g.infinite_yield or function()
    if g.IY_LOADED then
        return notify("Warning", "You already have Infinite Yield running.", 10)
    end
    if g.GET_LOADED_IY then
        return notify("Warning", "You already have Infinite Premium running! You cannot and should NOT run both at the same time.", 15)
    end

    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end

g.send_msg_menu = g.send_msg_menu or function()
    if g.sendmsgmenu_loaded then
        return notify("Warning", "Send message menu is already loaded!", 5)
    end

    g.sendmsgmenu_loaded = true
    local tween = g.TweenService
    local players = g.Players
    local uis = g.UserInputService
    local gui = Instance.new("ScreenGui")
    gui.Name = tostring(g.randomString())
    gui.ResetOnSpawn = false
    gui.Parent = parent_gui
    gui.IgnoreGuiInset = true

    local message_menu_frame = Instance.new("Frame")
    message_menu_frame.Parent = gui
    message_menu_frame.AnchorPoint = Vector2.new(0.5,0.5)
    message_menu_frame.Position = UDim2.new(0.5,0,0.5,0)
    message_menu_frame.Size = UDim2.new(0,350,0,0)
    message_menu_frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
    message_menu_frame.BackgroundTransparency = 1
    message_menu_frame.BorderSizePixel = 0
    Instance.new("UICorner",message_menu_frame).CornerRadius = UDim.new(0,15)

    tween:Create(message_menu_frame,TweenInfo.new(0.22,Enum.EasingStyle.Quad),{
        Size = UDim2.new(0,350,0,360),
        BackgroundTransparency = 0
    }):Play()

    local title = Instance.new("TextLabel")
    title.Parent = message_menu_frame
    title.Size = UDim2.new(1, -110, 0, 35)
    title.Position = UDim2.new(0, 10, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "> Life Together RP - Message Sender <"
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(0, 0, 255)
    title.TextTransparency = 1
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    tween:Create(title,TweenInfo.new(0.3),{TextTransparency = 0}):Play()

    local refreshbtn = Instance.new("TextButton")
    refreshbtn.Parent = message_menu_frame
    refreshbtn.Size = UDim2.new(0,70,0,26)
    refreshbtn.Position = UDim2.new(1, -110, 0, 5)
    refreshbtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    refreshbtn.TextColor3 = Color3.fromRGB(255,255,255)
    refreshbtn.Text = "Refresh"
    refreshbtn.Font = Enum.Font.Gotham
    refreshbtn.TextScaled = true
    refreshbtn.BorderSizePixel = 0
    Instance.new("UICorner",refreshbtn).CornerRadius = UDim.new(0,6)
    refreshbtn.BackgroundTransparency = 1
    refreshbtn.TextTransparency = 1
    tween:Create(refreshbtn,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

    local closebtn = Instance.new("TextButton")
    closebtn.Parent = message_menu_frame
    closebtn.Size = UDim2.new(0, 30, 0, 30)
    closebtn.Position = UDim2.new(1, -30, 0, 0)
    closebtn.BackgroundColor3 = Color3.fromRGB(220,50,50)
    closebtn.TextColor3 = Color3.fromRGB(255,255,255)
    closebtn.Text = "X"
    closebtn.Font = Enum.Font.GothamBold
    closebtn.TextScaled = true
    closebtn.BorderSizePixel = 0
    Instance.new("UICorner",closebtn).CornerRadius = UDim.new(0,8)
    closebtn.BackgroundTransparency = 1
    closebtn.TextTransparency = 1
    tween:Create(closebtn,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

    local search = Instance.new("TextBox")
    search.Parent = message_menu_frame
    search.Size = UDim2.new(1,-20,0,30)
    search.Position = UDim2.new(0,10,0,50)
    search.BackgroundColor3 = Color3.fromRGB(45,45,45)
    search.TextColor3 = Color3.fromRGB(255,255,255)
    search.Text = ""
    search.PlaceholderText = "Search players..."
    search.Font = Enum.Font.Gotham
    search.TextScaled = true
    search.BackgroundTransparency = 1
    search.TextTransparency = 1
    Instance.new("UICorner",search).CornerRadius = UDim.new(0,8)
    tween:Create(search,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

    local playerscroll = Instance.new("ScrollingFrame")
    playerscroll.Parent = message_menu_frame
    playerscroll.Size = UDim2.new(1,-20,0,140)
    playerscroll.Position = UDim2.new(0,10,0,90)
    playerscroll.CanvasSize = UDim2.new(0,0,0,0)
    playerscroll.ScrollBarThickness = 5
    playerscroll.BackgroundColor3 = Color3.fromRGB(40,40,40)
    playerscroll.BorderSizePixel = 0
    playerscroll.BackgroundTransparency = 1
    Instance.new("UICorner",playerscroll).CornerRadius = UDim.new(0,10)
    tween:Create(playerscroll,TweenInfo.new(0.25),{BackgroundTransparency = 0}):Play()

    local layout = Instance.new("UIListLayout",playerscroll)
    layout.Padding = UDim.new(0,5)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top

    if dragify and typeof(dragify) == "function" then dragify(message_menu_frame) end
    local selected = nil
    local function refresh()
        for _,v in ipairs(playerscroll:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
        end
        selected = nil
        local filter = string.lower(search.Text or "")
        for _,plr in ipairs(players:GetPlayers()) do
            if plr ~= players.LocalPlayer then
                if filter == "" or string.find(string.lower(plr.Name), filter, 1, true) then
                    local b = Instance.new("TextButton")
                    b.Parent = playerscroll
                    b.Size = UDim2.new(1,-10,0,30)
                    b.BackgroundColor3 = Color3.fromRGB(55,55,55)
                    b.TextColor3 = Color3.fromRGB(255,255,255)
                    b.Text = plr.Name
                    b.Font = Enum.Font.Gotham
                    b.TextScaled = true
                    b.BorderSizePixel = 0
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

                    b.MouseButton1Click:Connect(function()
                        if selected == b then
                            b.BackgroundColor3 = Color3.fromRGB(55,55,55)
                            selected = nil
                            return
                        end
                        if selected then
                            selected.BackgroundColor3 = Color3.fromRGB(55,55,55)
                        end
                        selected = b
                        b.BackgroundColor3 = Color3.fromRGB(30,200,80)
                    end)
                end
            end
        end
        playerscroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
    end

    search:GetPropertyChangedSignal("Text"):Connect(refresh)
    refreshbtn.MouseButton1Click:Connect(refresh)
    if not g._msgmenu_connections then
        g._msgmenu_connections = true
        players.PlayerAdded:Connect(refresh)
        players.PlayerRemoving:Connect(refresh)
    end

    task.delay(0.1, refresh)
    local amount = Instance.new("TextBox")
    amount.Parent = message_menu_frame
    amount.Size = UDim2.new(1,-20,0,30)
    amount.Position = UDim2.new(0,10,0,235)
    amount.BackgroundColor3 = Color3.fromRGB(45,45,45)
    amount.TextColor3 = Color3.fromRGB(255,255,255)
    amount.Text = "1"
    amount.PlaceholderText = "Number of messages (max 15)."
    amount.Font = Enum.Font.Gotham
    amount.TextScaled = true
    amount.BackgroundTransparency = 1
    amount.TextTransparency = 1
    Instance.new("UICorner",amount).CornerRadius = UDim.new(0,10)
    tween:Create(amount,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

    local msgbox = Instance.new("TextBox")
    msgbox.Parent = message_menu_frame
    msgbox.Size = UDim2.new(1,-20,0,40)
    msgbox.Position = UDim2.new(0,10,0,275)
    msgbox.BackgroundColor3 = Color3.fromRGB(45,45,45)
    msgbox.TextColor3 = Color3.fromRGB(255,255,255)
    msgbox.Text = ""
    msgbox.PlaceholderText = "Enter message..."
    msgbox.Font = Enum.Font.Gotham
    msgbox.TextScaled = true
    msgbox.BackgroundTransparency = 1
    msgbox.TextTransparency = 1
    Instance.new("UICorner",msgbox).CornerRadius = UDim.new(0,10)
    tween:Create(msgbox,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

    local sendbtn = Instance.new("TextButton")
    sendbtn.Parent = message_menu_frame
    sendbtn.Size = UDim2.new(1,-20,0,35)
    sendbtn.Position = UDim2.new(0,10,0,320)
    sendbtn.BackgroundColor3 = Color3.fromRGB(60,120,255)
    sendbtn.TextColor3 = Color3.fromRGB(255,255,255)
    sendbtn.Text = "Send Message"
    sendbtn.Font = Enum.Font.GothamBold
    sendbtn.TextScaled = true
    sendbtn.BorderSizePixel = 0
    sendbtn.BackgroundTransparency = 1
    sendbtn.TextTransparency = 1
    Instance.new("UICorner",sendbtn).CornerRadius = UDim.new(0,10)
    tween:Create(sendbtn,TweenInfo.new(0.25),{BackgroundTransparency = 0, TextTransparency = 0}):Play()

    closebtn.MouseButton1Click:Connect(function()
        tween:Create(message_menu_frame,TweenInfo.new(0.22,Enum.EasingStyle.Quad),{
            Size = UDim2.new(0,350,0,0),
            BackgroundTransparency = 1
        }):Play()
        wait(0.25)
        gui:Destroy()
        g.sendmsgmenu_loaded = false
    end)

    sendbtn.MouseButton1Click:Connect(function()
        if not selected then
            return notify("Warning", "Select a player first!", 5)
        end
        local target = players:FindFirstChild(selected.Text)
        if not target then return notify("Warning", "Player not found!", 5) end
        local num = tonumber(amount.Text) or 1
        num = math.clamp(num,1,30)
        local raw = msgbox.Text or ""
        if raw == "" then return notify("Warning", "Message cannot be empty.", 5) end
        local msgs = {}
        if raw:find("||",1,true) then
            for part in string.gmatch(raw,"([^|]+)") do
                part = part:gsub("^%s+",""):gsub("%s+$","")
                if part ~= "" then table.insert(msgs,part) end
            end
        else
            table.insert(msgs,raw)
        end

        g.Send_Message_Main_Phone_Messages_Module_Task = getgenv().FlamesLibrary.spawn("send_message_phone_task", "spawn", function()
            for i = 1, num do
                local text = msgs[((i - 1) % #msgs) + 1]
                pcall(function()
                    send_msg_phone(target, text)
                end)
                fw(0.02)
            end
        end)
    end)
end

g.lock_vehicle = g.lock_vehicle or function(Vehicle)
    g.Get("lock_vehicle", Vehicle)
end

if not g.HasSeen_Loading_Screen then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Intro_Screen.lua"))()
    g.HasSeen_Loading_Screen = true
end

g.player_admins = g.player_admins or {}
g.friend_checked = g.friend_checked or {}
g.cmds_loaded_plr = g.cmds_loaded_plr or {}
g.Rainbow_Vehicles = g.Rainbow_Vehicles or {}
g.Locked_Vehicles = g.Locked_Vehicles or {}
g.Unlocked_Vehicles = g.Unlocked_Vehicles or {}
g.Rainbow_Tasks = g.Rainbow_Tasks or {}
g.Rainbow_Delays         = g.Rainbow_Delays         or {}
g.Rainbow_Indices        = g.Rainbow_Indices        or {}
g.Rainbow_Next           = g.Rainbow_Next           or {}
g.Rainbow_CachedVehicle  = g.Rainbow_CachedVehicle  or {}
g.Rainbow_ActiveCount    = g.Rainbow_ActiveCount    or 0
g.Rainbow_MIN_DELAY      = g.Rainbow_MIN_DELAY      or 0.04
g.Rainbow_Colors = g.Rainbow_Colors or {
    Color3.fromRGB(255,255,255), Color3.fromRGB(128,128,128), Color3.fromRGB(0,0,0),
    Color3.fromRGB(0,0,255),     Color3.fromRGB(0,255,0),     Color3.fromRGB(0,255,255),
    Color3.fromRGB(255,165,0),   Color3.fromRGB(139,69,19),   Color3.fromRGB(255,255,0),
    Color3.fromRGB(50,205,50),   Color3.fromRGB(255,0,0),     Color3.fromRGB(255,155,172),
    Color3.fromRGB(128,0,128),
}

g.alreadyCheckedUser = function(player)
    if not g.friend_checked[player.Name] then
        g.player_admins[player.Name] = player
    end
    if not g.friend_checked[player.Name] then
        g.friend_checked[player.Name] = player
    end
    if not g.cmds_loaded_plr[player.Name] then
        g.cmds_loaded_plr[player.Name] = player
    end
end

g.disable_rgb_for = function(plr)
    if not plr then
        return g.notify("Error", "Player was not found when trying to disable RGB vehicle!", 6)
    end

    local name = plr.Name
    local state = g.VehicleStates[name]
    if not state then
        if g.Rainbow_Tasks[name] then
            g.Rainbow_Tasks[name] = nil
        end
        if g.Rainbow_Indices[name] then
            g.Rainbow_Indices[name] = nil
        end
        return
    end

    local handle = g.Rainbow_Tasks[name]
    if handle then pcall(function() task.cancel(handle) end) end
    if g.Rainbow_Tasks[name] then g.Rainbow_Tasks[name] = nil end
    if g.Rainbow_Indices[name] then g.Rainbow_Indices[name] = nil end
    state.rainbow = false
    state.rainbowIndex = nil
    g.notify("Success", "Disabled Rainbow Vehicle for: "..tostring(name), 6)
end

if not g.fully_disable_rgb_plr then g.fully_disable_rgb_plr = disable_rgb_for end
fw(0.1)
g.enable_rgb_for = function(plr)
    if not plr then return end
    local name = plr.Name
    g.VehicleStates[name] = g.VehicleStates[name] or {}
    local state = g.VehicleStates[name]
    local vehicle = get_other_vehicle(plr)
    if not vehicle then
        state.rainbow = false
        state.rainbowIndex = nil
        g.Rainbow_Tasks[name] = nil
        g.Rainbow_Indices[name] = nil
        return false, "you don't have a vehicle"
    end

    if g.Rainbow_Tasks[name] then disable_rgb_for(plr) end
    state.rainbow = true
    state.rainbowIndex = 0
    g.Rainbow_Indices[name] = 0
    g.Rainbow_Tasks[name] = task.spawn(function()
        while state.rainbow do
            local v = get_other_vehicle(plr)
            if not v then
                state.rainbow = false
                state.rainbowIndex = nil
                g.Rainbow_Tasks[name] = nil
                g.Rainbow_Indices[name] = nil
                break
            end

            local i = (state.rainbowIndex or 0) + 1
            state.rainbowIndex = i
            local color = g.Rainbow_Colors[(i % #g.Rainbow_Colors) + 1]
            change_vehicle_color(color, v)
            fw(0.2)
        end
    end)
end

-- [[ I promise I'll use it later, I know, it's better. ]] --
g.find_configuration_manager_GUI = function()
    local find_GUI_main = CoreGui:FindFirstChild("FlamesAdminGUI", true)
    if find_GUI_main then return find_GUI_main end

    for _, v in ipairs(CoreGui:GetDescendants()) do
        if v:IsA("ScreenGui") and v.Name:lower():find("flames") and v.Name:lower():find("admin") then
            return v
        end
    end
end

g.toggle_config_manager = function(state)
    if state == true then
        if not CoreGui:FindFirstChild("FlamesAdminGUI", true) then
            return notify("Error", "Configuration Manager GUI was not found.", 6)
        end

        if CoreGui:FindFirstChild("FlamesAdminGUI", true) then
            CoreGui:FindFirstChild("FlamesAdminGUI", true).Enabled = true
        elseif CoreGui:FindFirstChild("FlamesAdminGUI", true) and CoreGui:FindFirstChild("FlamesAdminGUI", true).Enabled then
            return 
        end
    elseif state == false then
        if not CoreGui:FindFirstChild("FlamesAdminGUI", true) then
            return notify("Error", "Configuration Manager GUI was not found.", 6)
        end

        if CoreGui:FindFirstChild("FlamesAdminGUI", true) then
            CoreGui:FindFirstChild("FlamesAdminGUI", true).Enabled = false
        elseif CoreGui:FindFirstChild("FlamesAdminGUI", true) and CoreGui:FindFirstChild("FlamesAdminGUI", true).Enabled then
            return 
        end
    else
        return 
    end
end

g.set_rgb_delay = function(name, newDelay)
   if type(newDelay) ~= "number" then return false, "invalid time value" end
   if newDelay < g.Rainbow_MIN_DELAY then newDelay = g.Rainbow_MIN_DELAY end
   g.Rainbow_Delays[name] = newDelay
   g.Rainbow_Next[name] = 0
   return true
end

g.VehicleStates = g.VehicleStates or {}
g.setup_cmd_handler_plr = function(player)
    local TextChatService = g.TextChatService or cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")
    local prefix = ";"
    local localPlayerName = g.LocalPlayer.Name
    local channel = TextChatService:FindFirstChild("RBXGeneral", true)
    if not player:IsFriendsWith(g.LocalPlayer.UserId) then return end
    local function trim(str) return str:match("^%s*(.-)%s*$") end
    local function chat_reply(speakerName, msg)
        if not channel then return end
        channel:SendAsync("/w " .. speakerName .. " " .. msg .. " (this message was automatically sent)")
    end

    if getgenv().Message_Received_Connection_Other_Players then
        pcall(function() getgenv().Message_Received_Connection_Other_Players:Disconnect() end)
        getgenv().Message_Received_Connection_Other_Players = nil
    end
    wait(0.25)
    getgenv().Message_Received_Connection_Other_Players = TextChatService.MessageReceived:Connect(function(chatMessage)
        local speaker = chatMessage.TextSource
        if not (speaker and speaker.Name ~= localPlayerName and g.player_admins[speaker.Name]) then return end
        local normalizedMessage = trim(chatMessage.Text:lower())
        if normalizedMessage:sub(1, #prefix) ~= prefix then return end
        local command = normalizedMessage:sub(#prefix + 1)
        local playerVehicle = get_other_vehicle(g.Players[speaker.Name])
        if not g.Players[speaker.Name]:IsFriendsWith(g.LocalPlayer.UserId) then return end
        local Name = speaker and speaker.Name
        g.VehicleStates[Name] = g.VehicleStates[Name] or {
            locked = false,
            unlocked = false,
            rainbow = false,
        }
        local parts = command:split(" ")
        local cmd = parts[1]

        if levenshtein(cmd, "rgbcar") <= 1 then
            local Player = g.Players[speaker.Name]
            if not Player then
                return notify("Error", "This player does not exist!", 5)
            end

            local vehicle = get_other_vehicle(Player)
            if not vehicle then
                g.Rainbow_Vehicles[Player.Name] = nil
                return notify("Error", "The player doesn't have a car spawned!", 5)
            end

            enable_rgb_for(Player)
        elseif levenshtein(command:split(" ")[1], "rgbtime") <= 2 then
            local parts = command:split(" ")
            local delayStr = parts[2]
            local newDelay = tonumber(delayStr)

            if not newDelay then
                return 
            end

            if newDelay < 0.1 then
                newDelay = 0.1
            end

            local name = g.Players[speaker.Name].Name
            g.Rainbow_Delays[name] = newDelay
            g.Rainbow_Next[name] = time()
        elseif levenshtein(command, "norgbcar") <= 2 then
            disable_rgb_for(g.Players[speaker.Name])
        elseif levenshtein(command, "lockcar") <= 2 then
            if not playerVehicle then
                g.LockLoop_Vehicles[speaker.Name] = false
                return 
            end
            if g.Locked_Vehicles[speaker.Name] then
                return 
            end

            g.Unlocked_Vehicles[speaker.Name] = false
            fw(0.1)
            g.Locked_Vehicles[speaker.Name] = true
            local player = g.Players[speaker.Name]
            if not player then g.Locked_Vehicles[speaker.Name] = false end
            local v = get_other_vehicle(player)
            if v and not v:GetAttribute("locked") then
                g.Get("lock_vehicle", v)
            elseif not v then
                g.Locked_Vehicles[speaker.Name] = false
            end
        elseif levenshtein(command, "unlockcar") <= 2 then
            if not playerVehicle then
                g.Unlocked_Vehicles[speaker.Name] = false
                return 
            end

            if g.Unlocked_Vehicles[speaker.Name] then return end
            g.Locked_Vehicles[speaker.Name] = false
            fw(0.1)
            g.Unlocked_Vehicles[speaker.Name] = true
            local player = g.Players[speaker.Name]
            if not player then
                g.Unlocked_Vehicles[speaker.Name] = false
            end

            local v = get_other_vehicle(player)
            if v and v:GetAttribute("locked") then
                g.Get("lock_vehicle", v)
            elseif not v then
                g.Unlocked_Vehicles[speaker.Name] = false
            end
        elseif levenshtein(command, "trailer") <= 2 then
            local player = g.Players[speaker.Name]
            if not playerVehicle then
                g.Unlocked_Vehicles[speaker.Name] = false
                return 
            end

            local Vehicle = get_other_vehicle(player)
            if not Vehicle then return end
            if Vehicle:FindFirstChild("WaterSkies") then return end
            fw(0.1)
            water_skie_trailer(true, Vehicle)
        elseif levenshtein(command, "notrailer") <= 2 then
            local player = g.Players[speaker.Name]
            if not playerVehicle then
                g.Unlocked_Vehicles[speaker.Name] = false
                return 
            end

            local Vehicle = get_other_vehicle(player)
            if not Vehicle then return  end
            if not Vehicle:FindFirstChild("WaterSkies") then return end
            water_skie_trailer(false, Vehicle)
        elseif command:sub(1, 5) == "check" then
            if g.Check_Cooldown then return end
            g.Check_Cooldown = true
            task.delay(15, function()
                g.Check_Cooldown = false
            end)

            local args = command:split(" ")
            local checkTargetName = args[2]
            if not checkTargetName or #checkTargetName <= 0 then
                return getgenv().notify("Warning", "Target player invalid: "..tostring(checkTargetName), 1)
            end

            local target = findplr(checkTargetName)
            if not target then
                return getgenv().notify("Warning", "Could not find: "..tostring(target), 1)
            end

            local isVerified = target:GetAttribute("is_verified")
            local general_channel = g.TextChatService:FindFirstChild("RBXGeneral", true) or g.TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral")
            if general_channel then
                if isVerified == true then
                general_channel:SendAsync("Player: " .. target.DisplayName .. " has premium.")
                else
                general_channel:SendAsync("Player: " .. target.DisplayName .. " does not have premium.")
                end
            end
        elseif levenshtein(command, "lambo") <= 2 or levenshtein(command, "lamborghini") then
            spawn_any_vehicle("svj")
        elseif levenshtein(command, "ferrari") <= 2 or levenshtein(command, "sf90") or levenshtein(command, "corvette") then
            spawn_any_vehicle("sf90")
        elseif levenshtein(command, "bugatti") <= 2 or levenshtein(command, "chiron") then
            spawn_any_vehicle("chiron")
        elseif levenshtein(command, "charger") <= 2 or levenshtein(command, "chargersrt") or levenshtein(command, "srtcharger") or levenshtein(command, "srt") then
            spawn_any_vehicle("charger")
        elseif levenshtein(command, "cmds") <= 2 then
            if g.Is_OnCooldown then return end
            g.Is_OnCooldown = true
            g.Wait_Time_Cooldown = 45
            channel:SendAsync(
                ";lockcar | ;rgbcar | ;norgbcar | ;unlockcar | ;check Player | ;trailer | ;notrailer", ";lambo", ";sf90", ";charger", ";bugatti"
            )

            task.delay(g.Wait_Time_Cooldown, function()
                g.Is_OnCooldown = false
            end)
        end
    end)
end

g.addPlayerToScriptWhitelistTable = g.addPlayerToScriptWhitelistTable or function(player)
    if not g.player_admins[player.Name] then
        g.player_admins[player.Name] = player
        fw(0.2)
        if g.player_admins[player.Name] then
            notify("Success", tostring(player.Name)..", was added to Admins Whitelist.", 3)
        end
    end
end

g.removePlayerFromScriptWhitelistTable = g.removePlayerFromScriptWhitelistTable or function(player)
    if g.player_admins[player.Name] then
        g.player_admins[player.Name] = nil
        fw(0.15)
        if g.player_admins[player.Name] == nil then
            notify("Success", tostring(player.Name).." was removed from the Admins Whitelist!", 3)
        else
            return notify("Error", tostring(player)..", does not exist.", 5)
        end
    end
end

g.avgSkin = g.avgSkin or function(bc)
    local skin_tone_colors = {
        bc.HeadColor3,
        bc.LeftArmColor3,
        bc.RightArmColor3,
        bc.TorsoColor3,
        bc.LeftLegColor3,
        bc.RightLegColor3
    }

    local r,g,b = 0,0,0
    for _,c in ipairs(skin_tone_colors) do
        r = r + c.R
        g = g + c.G
        b = b + c.B
    end

    return Color3.new(r/6,g/6,b/6)
end

g.clear_avatar = g.clear_avatar or function()
    local args = {
        "wear_outfit_from_desc",
        {
            accessories = {
                {
                    Rotation = "  ",
                    AccessoryType = "Hair",
                    Position = "  ",
                    Scale = "1 1 1",
                    IsLayered = false,
                    AssetId = 0
                },
                {
                    Rotation = "  ",
                    AccessoryType = "Face",
                    Position = "  ",
                    Scale = "1 1 1",
                    IsLayered = false,
                    AssetId = 0
                },
                {
                    Rotation = "  ",
                    AccessoryType = "Face",
                    Position = "  ",
                    Scale = "1 1 1",
                    IsLayered = false,
                    AssetId = 0
                },
                {
                    Rotation = "  ",
                    AccessoryType = "Hat",
                    Position = "  ",
                    Scale = "1 1 1",
                    IsLayered = false,
                    AssetId = 0
                },
                {
                    Rotation = "  ",
                    AccessoryType = "Face",
                    Position = "  ",
                    Scale = "1 1 1",
                    IsLayered = false,
                    AssetId = 0
                },
                {
                    Rotation = "  ",
                    AccessoryType = "Shirt",
                    Scale = "1 1 1",
                    Position = "  ",
                    Order = 1,
                    IsLayered = true,
                    Puffiness = 0,
                    AssetId = 0
                },
                {
                    Rotation = "  ",
                    AccessoryType = "DressSkirt",
                    Scale = "1 1 1",
                    Position = "  ",
                    Order = 2,
                    IsLayered = true,
                    Puffiness = 0,
                    AssetId = 0
                },
                {
                    Rotation = "  ",
                    AccessoryType = "RightShoe",
                    Scale = "1 1 1",
                    Position = "  ",
                    Order = 3,
                    IsLayered = true,
                    Puffiness = 0,
                    AssetId = 0
                },
                {
                    Rotation = "  ",
                    AccessoryType = "LeftShoe",
                    Scale = "1 1 1",
                    Position = "  ",
                    Order = 4,
                    IsLayered = true,
                    Puffiness = 0,
                    AssetId = 0
                }
            },
            properties = {
                SwimAnimation = 0,
                RightLegColor = "^zH;",
                MoodAnimation = 0,
                Torso = 0,
                WidthScale = 1,
                BodyTypeScale = 0.25,
                ClimbAnimation = 0,
                LeftArmColor = "^zH;",
                Shirt = 0,
                GraphicTShirt = 0,
                RightArmColor = "^zH;",
                LeftArm = 0,
                RunAnimation = 0,
                JumpAnimation = 0,
                RightArm = 0,
                Face = 0,
                Head = 0,
                DepthScale = 1,
                LeftLegColor = "^zH;",
                FallAnimation = 0,
                Pants = 0,
                HeadColor = "^zH;",
                TorsoColor = "^zH;",
                IdleAnimation = 0,
                RightLeg = 0,
                HeadScale = 1,
                HeightScale = 1,
                ProportionScale = 0,
                LeftLeg = 0
            }
        }
    }

    pcall(function() g.Send(unpack(args)) end)
end
fw(0.2)
g.height_setter_busy = g.height_setter_busy or false
g.session_original_height = g.session_original_height or nil
g.session_original_width = g.session_original_width or nil
g.session_original_skin = g.session_original_skin or nil
g.session_active = g.session_active or false
g.last_height_scale = g.last_height_scale or nil
g.prev_height_scale = g.prev_height_scale or nil
g.last_skin_tone = g.last_skin_tone or nil
g.prev_skin_tone = g.prev_skin_tone or nil
g.apply_skin_tone = function(color) if not color then return end pcall(function() g.Send("skin_tone", color) end) end
g.copy_plr_avatar = function(Player)
    if g.is_copying_avatar_already_flames then
        return notify("Warning","Avatar copier already in progress!",6)
    end
    g.is_copying_avatar_already_flames = true

    if not Player or not Player.Character then
        g.is_copying_avatar_already_flames = false
        return notify("Warning","Target not found!",5)
    end

    local hum = Player.Character:FindFirstChildWhichIsA("Humanoid") or get_human(Player, 3)
    if not hum then
        g.is_copying_avatar_already_flames = false
        return notify("Warning","No humanoid!",5)
    end

    local desc = hum:GetAppliedDescription()
    if not desc then
        g.is_copying_avatar_already_flames = false
        return notify("Warning","No description!",5)
    end

    if Player.Name == "CIippedByAura" or Player.Name == "L0CKED_1N1" or Player.Name == "AuraWithClipFarmin" then
        g.is_copying_avatar_already_flames = false
        return notify("Warning", "Do not copy the owner of Flames Hub's avatar!", 10)
    end

    if Player:GetAttribute("bio") == "`~ Flames Hub Anti Stealer Is Enabled ~`" then return g.notify("Warning", "This Player has Flames Hub | Anti Stealer enabled!", 5) end
    g.clear_avatar()
    fw(0.2)
    local accessories = {}

    for _,acc in ipairs(desc:GetAccessories(true)) do
        table.insert(accessories,{
            Rotation = "  ",
            Position = "  ",
            Scale = "1 1 1",
            IsLayered = acc.IsLayered,
            AccessoryType = acc.AccessoryType.Name,
            AssetId = acc.AssetId,
            Order = acc.Order,
            Puffiness = acc.Puffiness
        })
    end

    local properties = {
        Head = desc.Head or 0,
        Torso = desc.Torso or 0,
        LeftArm = desc.LeftArm or 0,
        RightArm = desc.RightArm or 0,
        LeftLeg = desc.LeftLeg or 0,
        RightLeg = desc.RightLeg or 0,
        Face = desc.Face or 0,
        Shirt = desc.Shirt or 0,
        Pants = desc.Pants or 0,
        GraphicTShirt = desc.GraphicTShirt or 0,
        RunAnimation = desc.RunAnimation or 0,
        WalkAnimation = desc.WalkAnimation or 0,
        JumpAnimation = desc.JumpAnimation or 0,
        FallAnimation = desc.FallAnimation or 0,
        ClimbAnimation = desc.ClimbAnimation or 0,
        IdleAnimation = desc.IdleAnimation or 0,
        SwimAnimation = desc.SwimAnimation or 0,
        HeightScale = desc.HeightScale or 1,
        WidthScale = desc.WidthScale or 1,
        DepthScale = desc.DepthScale or 1,
        HeadScale = desc.HeadScale or 1,
        BodyTypeScale = desc.BodyTypeScale or 0,
        ProportionScale = desc.ProportionScale or 0,
    }

    local args = {
        "wear_outfit_from_desc",
        {
            accessories = accessories,
            properties = properties
        }
    }

    pcall(function() g.Send(unpack(args)) end)
    fw(0.1)
    local bodyColors = Player.Character:FindFirstChildOfClass("BodyColors")
    if Player.Character and bodyColors then g.Send("skin_tone", avgSkin(bodyColors)) end
    local height = math.clamp(math.floor((desc.HeightScale or 1)*100+0.5),90,105)
    local width  = math.clamp(math.floor((desc.WidthScale  or 1)*100+0.5),70,100)
    g.Send("body_scale","HeightScale",height)
    task.wait(0.15)
    g.Send("body_scale","WidthScale",width)
    local age = Player:GetAttribute("age")
    if age then g.Get("age",age) end
    notify("Success","Copied avatar from "..Player.Name,5)
    g.is_copying_avatar_already_flames = false
end

g.height_func_setter = g.height_func_setter or function(height_input)
    if g.height_setter_busy then return end
    g.height_setter_busy = true
    local player = g.LocalPlayer
    local char = g.Character or player and player.Character
    local hum = g.Humanoid or char and char:FindFirstChildOfClass("Humanoid")
    if not hum then
        g.height_setter_busy = false
        return
    end

    local desc = hum:GetAppliedDescription()
    if not desc then
        g.height_setter_busy = false
        return g.notify("Error", "Failed to grab HumanoidDescription.", 5)
    end

    local bodyColors = char and char:FindFirstChildOfClass("BodyColors")
    local current_skin = bodyColors and avgSkin(bodyColors)
    if not g.session_active then
        g.session_original_height = desc.HeightScale or 1
        g.session_original_width = desc.WidthScale or 1
        g.session_original_skin = current_skin
        g.session_active = true
    end

    if current_skin then
        g.prev_skin_tone = g.last_skin_tone or current_skin
        g.last_skin_tone = current_skin
    end

    local height = tonumber(height_input) or desc.HeightScale or 1
    g.prev_height_scale = g.last_height_scale or desc.HeightScale or 1
    g.last_height_scale = height
    local properties = {
        Head = desc.Head or 0,
        Torso = desc.Torso or 0,
        LeftArm = desc.LeftArm or 0,
        RightArm = desc.RightArm or 0,
        LeftLeg = desc.LeftLeg or 0,
        RightLeg = desc.RightLeg or 0,
        Face = desc.Face or 0,
        Shirt = desc.Shirt or 0,
        Pants = desc.Pants or 0,
        GraphicTShirt = desc.GraphicTShirt or 0,
        RunAnimation = desc.RunAnimation or 0,
        WalkAnimation = desc.WalkAnimation or 0,
        JumpAnimation = desc.JumpAnimation or 0,
        FallAnimation = desc.FallAnimation or 0,
        ClimbAnimation = desc.ClimbAnimation or 0,
        IdleAnimation = desc.IdleAnimation or 0,
        SwimAnimation = desc.SwimAnimation or 0,
        HeightScale = height,
        WidthScale = desc.WidthScale or 1,
        DepthScale = desc.DepthScale or 1,
        HeadScale = desc.HeadScale or 1,
        BodyTypeScale = desc.BodyTypeScale or 0,
        ProportionScale = desc.ProportionScale or 0,
    }

    local accessories = {}
    for _, acc in ipairs(desc:GetAccessories(true)) do
        table.insert(accessories,{
            Rotation = "  ",
            Position = "  ",
            Scale = "1 1 1",
            IsLayered = acc.IsLayered,
            AccessoryType = acc.AccessoryType.Name,
            AssetId = acc.AssetId,
            Order = acc.Order,
            Puffiness = acc.Puffiness
        })
    end

    pcall(function()
        g.Send("wear_outfit_from_desc", {
            accessories = accessories,
            properties = properties
        })
    end)

    task.delay(0.10, function()
        g.apply_skin_tone(g.session_original_skin)
        g.height_setter_busy = false
    end)
end

g.reset_to_original_height = g.reset_to_original_height or function()
    if g.height_setter_busy then return end
    if not g.session_original_height then return end
    g.height_func_setter(g.session_original_height)
    if g.session_original_skin then
        task.delay(0.1, function()
            g.apply_skin_tone(g.session_original_skin)
        end)
    end

    task.delay(0.3, function()
        g.session_original_height = nil
        g.session_original_width = nil
        g.session_original_skin = nil
        g.session_active = false
    end)
end

g.reapply_last_skin = g.reapply_last_skin or function()
    if g.last_skin_tone then
        g.apply_skin_tone(g.last_skin_tone)
    end
end

g.reapply_prev_skin = g.reapply_prev_skin or function()
    if g.prev_skin_tone then
        g.apply_skin_tone(g.prev_skin_tone)
    end
end

g.anti_sit_enabled = g.anti_sit_enabled or false
g.anti_sit_connections = g.anti_sit_connections or {}
local local_player = g.LocalPlayer or game.Players.LocalPlayer or cloneref and cloneref(game:GetService("Players")).LocalPlayer or game:GetService("Players").LocalPlayer
local function cleanup_connections()
	for _, conn in pairs(g.anti_sit_connections) do
		if conn and conn.Connected then
			conn:Disconnect()
		end
	end
	g.anti_sit_connections = {}
end

local function hook_character(character)
	if not character then
		character = get_char(local_player, 10)
	end
	if not character then return end
	if not character:FindFirstChild("HumanoidRootPart") then
		character:WaitForChild("HumanoidRootPart")
	end
	local humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("Humanoid") or get_human(local_player, 10)
	if not humanoid then return end
	local conn
	conn = humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
		if not g.anti_sit_enabled then return end
		if humanoid.Sit then
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
			task.spawn(function()
				if humanoid.SeatPart then
					local weld = humanoid.SeatPart:FindFirstChildOfClass("Weld")
					if weld then weld:Destroy() end
					local prox = humanoid.SeatPart:FindFirstChildOfClass("ProximityPrompt")
					if prox and prox.Enabled == false then
						prox.Enabled = true
					end
				end
				for _ = 1, 5 do
					task.wait()
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					humanoid.Sit = false
				end
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
			end)
		end
	end)
	table.insert(g.anti_sit_connections, conn)
end

local function start_anti_sit()
	if #g.anti_sit_connections > 0 then return end
	hook_character(local_player.Character)
	local char_conn = local_player.CharacterAdded:Connect(function(character) hook_character(character) end)
	table.insert(g.anti_sit_connections, char_conn)
end

local function stop_anti_sit() cleanup_connections() end
g.toggle_anti_sit = function(state)
	g.anti_sit_enabled = state
	if state then
		start_anti_sit()
	else
		stop_anti_sit()
	end
end

g.anti_sit_func = function(toggle)
    local lib = g.FlamesLibrary
    local key = "anti_sit_loop"
    local fw = lib.wait
    g.Seat = require(g.Game_Folder:FindFirstChild("Seat"))

    if toggle == true then
        if g.Not_Ever_Sitting then
            return notify("Warning", "AntiSit is already enabled!", 5)
        end

        g.Not_Ever_Sitting = true
        g.toggle_anti_sit(true)
        g.notify("Success", "Anti-Sit is now enabled!", 5)
        show_notification("Success:", "Anti-Sit is now enabled!", "Normal")
        lib.spawn(key, "spawn", function()
            while g.Not_Ever_Sitting == true do
                g.Seat.enabled.set(false)
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
        g.toggle_anti_sit(false)
        fw(0.2)
        g.Seat.enabled.set(true)
        notify("Success", "Sitting is now enabled!", 5)
        Phone.show_notification("Success:", "Sitting is now enabled!", "Normal")
    else
        return
    end
end

g.annoyance_GUI = function()
    if CoreGui:FindFirstChild("AnnoyGUI") and CoreGui:FindFirstChild("AnnoyGUI"):IsA("ScreenGui") then
        CoreGui:FindFirstChild("AnnoyGUI").Enabled = true
        return 
    end
    g.AnnoyList = g.AnnoyList or {}
    g.group_chatting_users = g.group_chatting_users or {}
    g.Creating_Groups = false

    local ScreenGui = CoreGui:FindFirstChild("AnnoyGUI") or Instance.new("ScreenGui")
    ScreenGui.Name = "AnnoyGUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local AnnoyerGUIFrame = Instance.new("Frame")
    AnnoyerGUIFrame.Size = UDim2.new(0, 300, 0, 400)
    AnnoyerGUIFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    AnnoyerGUIFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    AnnoyerGUIFrame.BorderSizePixel = 0
    AnnoyerGUIFrame.Parent = ScreenGui
    Instance.new("UICorner", AnnoyerGUIFrame).CornerRadius = UDim.new(0, 12)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = AnnoyerGUIFrame
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -35, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Text = "Annoy / Group Spam Menu | Made By: "..tostring(Script_Creator).."."
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextScaled = true
    Title.TextSize = 14
    Title.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
    CloseBtn.Text = "X"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextScaled = true
    CloseBtn.TextSize = 14
    CloseBtn.Parent = TitleBar
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
        g.easy_click_plr = false
        g.Creating_Groups = false
    end)

    local PlayerList = Instance.new("ScrollingFrame")
    PlayerList.Size = UDim2.new(1, -10, 1, -45)
    PlayerList.Position = UDim2.new(0, 5, 0, 40)
    PlayerList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    PlayerList.BorderSizePixel = 0
    PlayerList.ScrollBarThickness = 6
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
    PlayerList.Parent = AnnoyerGUIFrame
    Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0, 10)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = PlayerList
    UIListLayout.Padding = UDim.new(0, 5)

    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    if dragify and typeof(dragify) == "function" then dragify(AnnoyerGUIFrame) end
    local function ToggleAnnoy(plr, btn)
        if g.easy_click_plr and g.easy_click_target == plr.Name then
            g.easy_click_plr = false
            if g.Toggling_Annoyance_Loop_Carry_AndCall then
                pcall(function()
                    task.cancel(g.Toggling_Annoyance_Loop_Carry_AndCall)
                    g.Toggling_Annoyance_Loop_Carry_AndCall = nil
                end)
            end
            btn.Text = "Annoy Off"
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        else
            g.easy_click_target = plr.Name
            g.easy_click_plr = true
            btn.Text = "Annoy On"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            g.Toggling_Annoyance_Loop_Carry_AndCall = g.Toggling_Annoyance_Loop_Carry_AndCall or task.spawn(function()
                while g.easy_click_plr and g.easy_click_target == plr.Name do
                fw(0)
                    g.Send("request_carry", plr.Name)
                    fw(0)
                    g.Send("request_call", plr.Name)
                    fw(0)
                    g.Send("end_call", plr.Name)
                end
            end)
        end
    end

    local function ToggleGroupSpam(plr, btn)
        if table.find(g.group_chatting_users, plr.Name) then
            table.remove(g.group_chatting_users, table.find(g.group_chatting_users, plr.Name))
            if g.Always_Creating_TheGroups_Loop_Task then
                task.cancel(g.Always_Creating_TheGroups_Loop_Task)
                g.Always_Creating_TheGroups_Loop_Task = nil
            end
            btn.Text = "Group Spam Off"
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            if #g.group_chatting_users == 0 then
                g.Creating_Groups = false
            end
        else
            table.insert(g.group_chatting_users, plr.Name)
            btn.Text = "Group Spam On"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            g.Creating_Groups = true
            g.Always_Creating_TheGroups_Loop_Task = g.Always_Creating_TheGroups_Loop_Task or task.spawn(function()
                while g.Creating_Groups == true do
                wait(.4)
                    local userIds = {}
                    for _, name in ipairs(g.group_chatting_users) do
                        local success, userId = pcall(function()
                            return Players:GetUserIdFromNameAsync(name)
                        end)
                        if success and userId then
                            table.insert(userIds, userId)
                        end
                    end

                    if #userIds == 1 then
                        local others = {}
                        for _, other in ipairs(Players:GetPlayers()) do
                            if other.Name ~= g.group_chatting_users[1] and other ~= LocalPlayer then
                                table.insert(others, other)
                            end
                        end

                        for i = #others, 2, -1 do
                            local j = math.random(i)
                            others[i], others[j] = others[j], others[i]
                        end

                        for i = 1, math.min(3, #others) do
                            table.insert(userIds, others[i].UserId)
                        end
                    end

                    if #userIds > 0 then
                        g.Get("new_group", userIds)
                    end
                end
            end)
        end
    end

    local function createPlayerEntry(plr)
        if plr == LocalPlayer then return end
        local Container = Instance.new("Frame")
        Container.Size = UDim2.new(1, -5, 0, 110)
        Container.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Container.BorderSizePixel = 0
        Container.Parent = PlayerList
        Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(1, -10, 0, 20)
        NameLabel.Position = UDim2.new(0, 5, 0, 5)
        NameLabel.Text = "DisplayName: " .. plr.DisplayName
        NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameLabel.BackgroundTransparency = 1
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Font = Enum.Font.Gotham
        NameLabel.TextSize = 13
        NameLabel.Parent = Container

        local UserLabel = Instance.new("TextLabel")
        UserLabel.Size = UDim2.new(1, -10, 0, 20)
        UserLabel.Position = UDim2.new(0, 5, 0, 25)
        UserLabel.Text = "Username: " .. plr.Name
        UserLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        UserLabel.BackgroundTransparency = 1
        UserLabel.TextXAlignment = Enum.TextXAlignment.Left
        UserLabel.Font = Enum.Font.Gotham
        UserLabel.TextSize = 12
        UserLabel.Parent = Container

        local IdLabel = Instance.new("TextLabel")
        IdLabel.Size = UDim2.new(1, -10, 0, 20)
        IdLabel.Position = UDim2.new(0, 5, 0, 45)
        IdLabel.Text = "UserId: " .. tostring(plr.UserId)
        IdLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        IdLabel.BackgroundTransparency = 1
        IdLabel.TextXAlignment = Enum.TextXAlignment.Left
        IdLabel.Font = Enum.Font.Gotham
        IdLabel.TextSize = 12
        IdLabel.Parent = Container

        local AnnoyButton = Instance.new("TextButton")
        AnnoyButton.Size = UDim2.new(0, 110, 0, 20)
        AnnoyButton.Position = UDim2.new(0, 10, 0, 70)
        AnnoyButton.Text = "Annoy Off"
        AnnoyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        AnnoyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        AnnoyButton.Font = Enum.Font.GothamBold
        AnnoyButton.TextScaled = true
        AnnoyButton.TextSize = 13
        AnnoyButton.Parent = Container
        AnnoyButton.MouseButton1Click:Connect(function()
            ToggleAnnoy(plr, AnnoyButton)
        end)

        local GroupButton = Instance.new("TextButton")
        GroupButton.Size = UDim2.new(0, 110, 0, 20)
        GroupButton.Position = UDim2.new(0, 140, 0, 70)
        GroupButton.Text = "Group Spam Off"
        GroupButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        GroupButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        GroupButton.Font = Enum.Font.GothamBold
        GroupButton.TextScaled = true
        GroupButton.TextSize = 13
        GroupButton.Parent = Container
        Instance.new("UICorner", GroupButton).CornerRadius = UDim.new(0, 6)
        GroupButton.MouseButton1Click:Connect(function()
            ToggleGroupSpam(plr, GroupButton)
        end)

        Instance.new("UICorner", AnnoyButton).CornerRadius = UDim.new(0, 6)
        Instance.new("UICorner", GroupButton).CornerRadius = UDim.new(0, 6)
        if g.easy_click_plr and g.easy_click_target == plr.Name then
            AnnoyButton.Text = "Annoy On"
            AnnoyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        end

        if table.find(g.group_chatting_users, plr.Name) then
            GroupButton.Text = "Group Spam On"
            GroupButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        end

        PlayerList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end

    local function refreshPlayerList()
        for _, child in ipairs(PlayerList:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            createPlayerEntry(plr)
        end
    end

    if not g.RefreshPlayer_ListAdded_Conn then
        g.RefreshPlayer_ListAdded_Conn = true
        Players.PlayerAdded:Connect(refreshPlayerList)
        Players.PlayerRemoving:Connect(refreshPlayerList)
    end

    refreshPlayerList()
end

local Hum = g.Humanoid or g.Character and g.Character:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer or game.Players.LocalPlayer, 10)
local HD = Hum:FindFirstChildOfClass("HumanoidDescription")
g.GlitchIDs = {
   Shirts = {6028801590, 11595159513},
   Pants  = {6028804735, 11595172734}
}

g.isWearing = g.isWearing or function(desc, slot, id)
    return desc and tostring(desc[slot]) == tostring(id)
end

g.forceEquip = g.forceEquip or function(slot, id)
    if not isWearing(HD, slot, id) then
        g.Get("code", id, slot)
    end
end

g.forceUnequip = g.forceUnequip or function(slot, id)
    if isWearing(HD, slot, id) then
        g.Get("wear", id, slot)
    end
end

local humanoid = g.Humanoid or g.Character and g.Character:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer or game.Players.LocalPlayer, 10)
local applied = humanoid:GetAppliedDescription()
local Old_Shirt = applied.Shirt
local Old_Pants = applied.Pants
g.glitch_outfit = g.glitch_outfit or function(toggle)
    local FL = getgenv().FlamesLibrary

    if toggle == true then
        if getgenv().Glitching_Outfit then
            return g.notify("Warning", "Glitch Outfit is already enabled.", 5)
        end

        getgenv().Glitching_Outfit = true
        FL.spawn("glitch_outfit_loop", "spawn", function()
            while getgenv().Glitching_Outfit == true do
                fw(0)
                for _, shirtId in ipairs(GlitchIDs.Shirts) do
                    forceEquip("Shirt", shirtId)
                    task.wait()
                    forceUnequip("Shirt", shirtId)
                end
                fw(0.1)
                for _, pantsId in ipairs(GlitchIDs.Pants) do
                    forceEquip("Pants", pantsId)
                    task.wait()
                    forceUnequip("Pants", pantsId)
                end
            end
        end)
    else
        if not getgenv().Glitching_Outfit then
            return g.notify("Warning", "Glitch Outfit is not enabled.", 5)
        end

        getgenv().Glitching_Outfit = false
        FL.disconnect("glitch_outfit_loop")
        FL.spawn("glitch_outfit_restore", "delay", 0.5, function()
            g.Send("code", Old_Shirt, "Shirt")
            task.wait()
            g.Send("code", Old_Pants, "Pants")
        end)
    end
end

function check_friends()
    for _, v in ipairs(g.Players:GetPlayers()) do
        if v ~= g.LocalPlayer and v:IsFriendsWith(g.LocalPlayer.UserId) then
            alreadyCheckedUser(v)
        end
    end
end

function auto_add_friends()
    for _, v in ipairs(g.Players:GetPlayers()) do
        if v ~= g.LocalPlayer and v:IsFriendsWith(g.LocalPlayer.UserId) then
            check_friends()
            addPlayerToScriptWhitelistTable(v)
        end
    end
end

auto_add_friends()

local originalCFrame
local originalCameraType
if g.PlayerControls == nil then
    local PlayerModule = require(g.PlayerScripts:WaitForChild("PlayerModule"))
    g.PlayerControls = PlayerModule:GetControls()
end

g.Viewing_Plr_Tbl = g.Viewing_Plr_Tbl or {}
g.viewTarget = g.viewTarget or function(player)
    if g.Viewing_A_Player then
        if g.Viewing_Plr_Tbl[player.Name] then
            return notify("Error","You're already viewing: "..player.DisplayName,5)
        end
        return notify("Error","You're already viewing a Player.",5)
    end

    if not player or not player.Character then
        return notify("Error","Invalid player.",5)
    end

    local char = player.Character or g.get_char(player)
    local hum = get_human(player) or char:FindFirstChildWhichIsA("Humanoid")
    if not hum then
        return notify("Error","Player has no humanoid.",5)
    end

    local root = get_root(player) or hum.RootPart or char:FindFirstChild("HumanoidRootPart")
    g.Camera.CameraSubject = hum
    g.Viewing_A_Player = true
    g.Viewing_Plr_Tbl[player.Name] = {
        Name = player.Name,
        DisplayName = player.DisplayName,
        UserId = player.UserId,
        Character = char,
        Humanoid = hum,
        HumanoidRootPart = root
    }
end

g.unview_player = g.unview_player or function()
    local genv = g
    if not genv.Viewing_A_Player then return genv.notify("Error", "You're not viewing anyone.", 5) end
    local hum = genv.Humanoid or genv.Character:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer, 10)
    local char = genv.Character or genv.LocalPlayer.Character or get_char(LocalPlayer, 10)
    local subject = hum or (char and char:FindFirstChildWhichIsA("Humanoid")) or char

    if subject and genv.Camera then
        genv.Camera.CameraSubject = subject
    elseif not genv.Camera then
        workspace.CurrentCamera.CameraSubject = subject
    end

    if typeof(genv.Viewing_Plr_Tbl) ~= "table" then genv.Viewing_Plr_Tbl = {} end
    if next(genv.Viewing_Plr_Tbl) == nil then
        return genv.notify(
            "Error",
            "Viewing table is empty (tried unviewing nobody? how?).",
            10
        )
    end

    local viewed
    for k, v in pairs(genv.Viewing_Plr_Tbl) do
        viewed = (typeof(v) == "Instance" and v.DisplayName) or k
        break
    end

    genv.Viewing_A_Player = false
    table.clear(genv.Viewing_Plr_Tbl)

    genv.notify("Success", "Stopped viewing: " .. tostring(viewed), 5)
end

g.check_friend = g.check_friend or function(Player)
    if Player ~= g.LocalPlayer and Player:IsFriendsWith(g.LocalPlayer.UserId) then
        return true
    else
        return false
    end

    return 
end

g.spam_create_groups = g.spam_create_groups or function(toggle)
    local FL = getgenv().FlamesLibrary
    if toggle == true then
        if getgenv().Creating_Groups then
            return g.notify("Warning", "Group spammer is already enabled.", 5)
        end

        g.group_chatting_users = g.group_chatting_users or {}
        getgenv().Creating_Groups = true
        FL.spawn("spam_create_groups_loop", "spawn", function()
            while getgenv().Creating_Groups == true do
                fw(0)
                for _, name in ipairs(g.group_chatting_users) do
                    local success, userId = pcall(function()
                        return Players:GetUserIdFromNameAsync(name)
                    end)

                    if success and userId then
                        g.Get("new_group", userId)
                    end
                end
            end
        end)
    elseif toggle == false then
        if not getgenv().Creating_Groups then
            return g.notify("Warning", "Group spammer is not enabled.", 5)
        end

        getgenv().Creating_Groups = false
        FL.disconnect("spam_create_groups_loop")
    else
        return
    end
end

g.attach_with_script = g.attach_with_script or function()
    local Methods = {
        "Secret",
        "Sneaky",
        "Private",
        "Normal",
        "Bypass",
        "External",
        "Internal",
        "Rage",
        "Silent",
        "Source",
        "MainClass",
        "Class_C",
        "Non-Closure",
        "Encoded",
        "Bytecode",
        "Obfuscated"
    }

    local Attached = false
    g.Script_Was_Attached_Successfully = Attached
    local Old_Text = g.CreditsLabelText.Text
    task.wait(0.4)
    for i = 1, 3 do
        wait(0.6)
        g.CreditsLabelText.Text = "[Starting]: Attaching."
        wait(0.6)
        g.CreditsLabelText.Text = "[Starting]: Attaching.."
        wait(0.6)
        g.CreditsLabelText.Text = "[Starting]: Attaching..."
    end
    task.wait(.1)
    Attached = true
    task.wait(.1)
    if Attached == true then
        g.CreditsLabelText.Text = "[Starting]: Getting requirements."
        wait(0.6)
        g.CreditsLabelText.Text = "[Starting]: Getting requirements.."
        wait(0.6)
        g.CreditsLabelText.Text = "[Starting]: Getting requirements..."
        wait(0.5)
        g.CreditsLabelText.Text = "[Success]: Got requirements successfully!"
        wait(0.6)
        for i = 1, 3 do
            wait(0.6)
            g.CreditsLabelText.Text = "[Initializing]: Collecting prerequisites."
            wait(0.6)
            g.CreditsLabelText.Text = "[Initializing]: Collecting prerequisites.."
            wait(0.6)
            g.CreditsLabelText.Text = "[Initializing]: Collecting prerequisites..."
        end
    end
    task.wait(0.3)
    for i = 1, 8 do
        wait(0.6)
        g.CreditsLabelText.Text = "[Finalizing]: Collecting prerequisites."
        wait(0.6)
        g.CreditsLabelText.Text = "[Finalizing]: Collecting prerequisites.."
        wait(0.6)
        g.CreditsLabelText.Text = "[Finalizing]: Collecting prerequisites..."
    end
    fw(0.2)
    for i = 1, 4 do
        wait(0.6)
        g.CreditsLabelText.Text = "[Finishing]: Selecting method."
        wait(0.6)
        g.CreditsLabelText.Text = "[Finishing]: Selecting method.."
        wait(0.6)
        g.CreditsLabelText.Text = "[Finishing]: Selecting method..."
    end
    task.wait(0.3)
    local function ChooseMethod() return Methods[math.random(1, #Methods)] end
    g.CreditsLabelText.Text = "[Finished]: Method: "..tostring(ChooseMethod())
    wait(0.7)
    g.CreditsLabelText.Text = "Attached."
    wait(0.8)
    g.CreditsLabelText.Text = Old_Text
end

g.PlotAreas = {}
g.update_plot_areas = g.update_plot_areas or function()
    table.clear(g.PlotAreas)
    fw(0.2)
    for _, v in ipairs(g.Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "PlotArea" then
            g.PlotAreas[v] = v
        end
    end
end

g.in_humanoid_vehicle = g.in_humanoid_vehicle or function(PlayerOrName)
    local HumanoidVehicles = g.Workspace:FindFirstChild("HumanoidVehicles", true)
    if not HumanoidVehicles then return end
    local Player = PlayerOrName
    if typeof(PlayerOrName) == "string" then
        Player = g.Players:FindFirstChild(PlayerOrName)
        if not Player then return end
    end

    local Character = Player == g.LocalPlayer and g.Character or Player.Character
    if not Character then return end
    local humanoid = Character:FindFirstChildWhichIsA("Humanoid") or get_human(Player, 5)
    if not humanoid then return end
    local vehicleAttr = humanoid:GetAttribute("InHumanoidVehicle")
    if vehicleAttr == nil then return end
    if type(g.Humanoid_Vehicles) ~= "table" then return end
    if not table.find(g.Humanoid_Vehicles, vehicleAttr) then return end

    return vehicleAttr
end

g.hum_vehicle_name = g.hum_vehicle_name or function(plr)
    local hv = in_humanoid_vehicle(plr)
    if not hv then return nil end
    local folder = g.Workspace:FindFirstChild("HumanoidVehicles", true)
    if not folder then return nil end
    local inst = folder:FindFirstChild(hv)
    if not inst then return nil end

    return inst.Name
end

g.set_hum_vehicle_speed = g.set_hum_vehicle_speed or function(speed)
    speed = tonumber(speed) or 50
    if typeof(speed) ~= "number" then speed = 50 end
    if in_humanoid_vehicle(g.LocalPlayer) then pcall(function() g.Humanoid.WalkSpeed = tonumber(speed) end) end
end

update_plot_areas()

if CoreGui:FindFirstChild("TemporaryBanner_GUI") then
    pcall(function()
        if g.camConn then
            g.camConn:Disconnect()
            g.camConn = nil
        end
        if screenGui and screenGui.Parent then screenGui:Destroy() end
        g.updatePosition = nil
        g.clamp = nil
    end)
end
wait(0.7)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TemporaryBanner_GUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Name = "BannerFrame"
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = UDim2.new(0.5, 0, 0, 20)
frame.Size = UDim2.new(0.6, 0, 0, 48)
frame.BackgroundTransparency = 0
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

make_round(frame, 12)
flowrgb("banner_announcement_frame_flowing_rgb_smooth_conn", 3.5, frame, true)
g.make_stroke(frame, 1.5, 0.25)

local label = Instance.new("TextLabel")
label.Name = "BannerText"
label.AnchorPoint = Vector2.new(0.5, 0.5)
label.Position = UDim2.new(0.5, 0, 0.5, 0)
label.Size = UDim2.new(0.95, 0, 0.9, 0)
label.BackgroundTransparency = 1
label.Text = tostring(Announcement_Message)
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.RichText = false
label.TextWrapped = true
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Parent = frame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0)
shadow.Position = UDim2.new(0.5, 0, 0, 24)
shadow.Size = UDim2.new(0.62, 0, 0, 56)
shadow.Image = "rbxassetid://5059716102"
shadow.BackgroundTransparency = 1
shadow.ImageTransparency = 0.8
shadow.ZIndex = frame.ZIndex - 1
shadow.Parent = screenGui
shadow.Visible = false

g.clamp = g.clamp or function(n, lo, hi)
    if n < lo then return lo end
    if n > hi then return hi end
    return n
end

g.updatePosition = g.updatePosition or function()
    vw, vh = g.Workspace.CurrentCamera.ViewportSize.X, g.Workspace.CurrentCamera.ViewportSize.Y
    widthScale = clamp(0.6, 0.4, 0.8)
    heightPx = clamp(math.floor(vh * 0.07), 36, 72)
    frame.Size = UDim2.new(widthScale, 0, 0, heightPx)
    topOffset = math.max(12, math.floor(vh * 0.03))
    frame.Position = UDim2.new(0.5, 0, 0, topOffset)
    shadow.Position = UDim2.new(0.5, 0, 0, topOffset + math.floor(heightPx/2))
    shadow.Size = UDim2.new(widthScale + 0.02, 0, 0, heightPx + 12)
end

updatePosition()

g.camConn = nil
if g.Workspace and g.Workspace.CurrentCamera then g.camConn = g.Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updatePosition) end
frame.BackgroundTransparency = 1
label.TextTransparency = 1
shadow.ImageTransparency = 1
appearInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(frame, appearInfo, {BackgroundTransparency = 0}):Play()
TweenService:Create(label, appearInfo, {TextTransparency = 0}):Play()
shadow.Visible = false
TweenService:Create(shadow, appearInfo, {ImageTransparency = 0.8}):Play()
displayTime = displayTimeMax
delay(displayTime, function()
    fadeInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    t1 = TweenService:Create(frame, fadeInfo, {BackgroundTransparency = 1})
    t2 = TweenService:Create(label, fadeInfo, {TextTransparency = 1})
    t3 = TweenService:Create(shadow, fadeInfo, {ImageTransparency = 1})
    t1:Play(); t2:Play(); t3:Play()
    t1.Completed:Wait()
    pcall(function()
        if g.camConn then
            g.camConn:Disconnect()
            g.camConn = nil
        end
        screenGui:Destroy()
    end)
end)

if not g.SetupGone_Through_Flames_Hub then
    pcall(function()
        g.LocalPlayer:SetSuperSafeChat(false)
        g.LocalPlayer.CameraMaxZoomDistance = 100000
        g.LocalPlayer.CameraMinZoomDistance = 0.5
    
        if g.LocalPlayer.CameraMaxZoomDistance > 90000 then
            notify("Success", "Set CameraMaxZoomDistance to: "..tostring(g.LocalPlayer.CameraMaxZoomDistance), 7)
        else
            notify("Warning", "We we're not able to correctly set CameraMaxZoomDistance!", 5)
        end
        if g.LocalPlayer.CameraMinZoomDistance < 5 then
            notify("Success", "Set CameraMinZoomDistance to: "..tostring(g.LocalPlayer.CameraMinZoomDistance), 7)
        else
            notify("Warning", "We we're not able to correctly set CameraMinZoomDistance!", 5)
        end

        if g.StarterPlayer.CharacterUseJumpPower then
            g.Humanoid.JumpPower = 50
            notify("Success", "Spoofed JumpPower to: "..tostring(g.Humanoid.JumpPower))
        else
            g.Humanoid.JumpHeight = 7
            notify("Success", "Spoofed JumpHeight to: "..tostring(g.Humanoid.JumpHeight))
        end
        g.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
        if g.LocalPlayer.Name == "CIippedByAura" or g.LocalPlayer.Name == "L0CKED_1N1" or g.LocalPlayer.Name == "AuraWithClipFarmin" then
            g.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
            notify("Success", "Enabled Leaderboard & Backpack.", 5)
        else
            notify("Success", "Enabled Leaderboard.", 5)
        end
    end)

    g.SetupGone_Through_Flames_Hub = true
end

if not g.SeenCommandAndCameraIntro then
    notify("Success", "[HOOKED]: We have hooked the Camera successfully.", 5)
    fw(0.2)
    notify("Warning", "[INITIALIZING]: Setting up command receiver...", 5)
    fw(0.1)
    g.SeenCommandAndCameraIntro = true
end

for _, v in ipairs(game.Players:GetPlayers()) do setup_cmd_handler_plr(v) end
if not g.AdminHasBeenLoaded_NotificationCheck then
    g.notify("Success", "[INITIALIZED]: Life Together RP-Admin has been loaded!", 7)
    g.notify("Success", "[LOADED]: | [Life Together-RP : Admin_Commands]: Loaded!", 7)
    g.AdminHasBeenLoaded_NotificationCheck = true
end
function auto_add_friends()
    for _, v in ipairs(g.Players:GetPlayers()) do
        if v ~= g.LocalPlayer and v:IsFriendsWith(g.LocalPlayer.UserId) then
            alreadyCheckedUser(v)
        end
    end
end

function auto_remove_friends()
    for _, v in ipairs(g.Players:GetPlayers()) do
        if v ~= g.LocalPlayer and v:IsFriendsWith(g.LocalPlayer.UserId) and v.Character == nil then
            g.Rainbow_Others_Vehicle = false
        end
    end
end

if g.LifeTogetherRP_Admin and g.Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub and g.LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client then
    notify("Success", "Reloaded script successfully.", 15)
end

for _, v in ipairs(game.Players:GetPlayers()) do
    if v.Name == "CIippedByAura" or v.Name == "L0CKED_1N1" or v.Name == "AuraWithClipFarmin" then
        local owner_content = "Flames Hub | Owner is currently in this server, come to me: ("..tostring(v.Name)..") for assistance (if you need help)."
        getgenv().notify("Success", owner_content, 30)
    elseif allowed[v.Name] and v.Name ~= "CIippedByAura" and v.Name ~= "L0CKED_1N1" and v.Name ~= "AuraWithClipFarmin" then
        local staff_content = "A Flames Hub | Staff member is currently in this server, this is more rare and they can get in contact with me faster."
        getgenv().notify("Success", staff_content, 15)
    end
end

g.Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub = g.Script_Loaded_Correctly_LifeTogether_Admin_Flames_Hub or true
if not g.FlamesHubPlayerEvents_Check then
    g.FlamesHubPlayerEvents_Check = true
    g.FlamesLibrary.connect("PlayerAdded_OwnerAdminCheck", Players.PlayerAdded:Connect(function(Player)
        local Name = Player and Player.Name
        g.Blacklisted_Friends = g.Blacklisted_Friends or {}
        if Player:IsFriendsWith(g.LocalPlayer.UserId) then
            if not g.Blacklisted_Friends[Name] then
                auto_add_friends()
            end
        end

        -- [[ make who ever you want the owner, like yourself. ]] --
        if Name == "CIippedByAura" or Name == "L0CKED_1N1" or Name == "AuraWithClipFarmin" then
            owner_joined(Name)
            if g.friend_checked[Name] then
                g.player_admins[Name] = nil
                g.friend_checked[Name] = nil
            end
            if g.cmds_loaded_plr[Name] then
                g.cmds_loaded_plr[Name] = nil
            end
        elseif allowed[Name] and Name ~= "L0CKED_1N1" and Name ~= "CIippedByAura" and Name ~= "AuraWithClipFarmin" then
            g.notify("Success", "An official staff member of Flames Hub has joined your server, UserName: "..tostring(Name), 15)
        end
    end))

    g.FlamesLibrary.connect("PlayerRemoving_OwnerAdminRemoval", Players.PlayerRemoving:Connect(function(Player)
        local Name = Player.Name

        if Name == "CIippedByAura" or Name == "L0CKED_1N1" or Name == "AuraWithClipFarmin" then
            g.notify("Info", "The owner of this script has left the server.", 5)
        elseif allowed[Name] and Name ~= "L0CKED_1N1" and Name ~= "CIippedByAura" and Name ~= "AuraWithClipFarmin" then
            g.notify("Success", "Flames Hub | Staff member has left your server: "..tostring(Name), 15)
        end

        disable_rgb_for(Name)
        g.fully_disable_rgb_plr(Name)
        if g.Locked_Vehicles[Name] then
            g.Locked_Vehicles[Name] = false
        end
        if g.Unlocked_Vehicles[Name] then
            g.Unlocked_Vehicles[Name] = false
        end
    end))
end

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Luna.lua", true))()
local Window = Luna:CreateWindow({
    Name = "Flames Hub | Life Together RP",
    Subtitle = "welcome!",
    LogoID = "0",
    LoadingEnabled = true,
    LoadingTitle = "Flames Hub | Presents",
    LoadingSubtitle = "by Flames Hub.",
    ConfigSettings = {
        Enabled = true,
        RootFolder = nil,
        ConfigFolder = "FlamesHub_Life_Together_RP_Menu_Configuration"
    },
    KeySystem = false,
    KeySettings = {
        Title = "Flames Hub | Key System",
        Subtitle = "",
        Note = "Welcome to Flames Hub | Life Together RP!",
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
wait(0.25)
g.create_ui_element = g.create_ui_element or function(element_type, parent, config, global_name, flag)
    local creators = {
        Tab         = function() return parent:CreateTab(config) end,
        Section     = function() return parent:CreateSection(config) end,
        Toggle      = function() return parent:CreateToggle(config, flag) end,
        Slider      = function() return parent:CreateSlider(config, flag) end,
        Button      = function() return parent:CreateButton(config, flag) end,
        ColorPicker = function() return parent:CreateColorPicker(config, flag) end,
        Input       = function() return parent:CreateInput(config, flag) end,
        Dropdown    = function() return parent:CreateDropdown(config, flag) end,
        Label       = function() return parent:CreateLabel(config, flag) end,
    }

    local creator = creators[element_type]
    if not creator then return g.notify("Error", "Unknown element type: " .. tostring(element_type), 10) end
    local element
    local done = false
    task.defer(function()
        element = creator()
        done = true
    end)

    while not done do task.wait() end
    if global_name then getgenv()[global_name] = element end
    return element
end
wait(0.25)
getgenv().notify("Success", "Now loading UI elements...", 10)
local Home_Tab = Window:CreateTab({
    Name = "Home",
    Icon = "house",
    ImageSource = "Material",
    ShowTitle = true
})
local Home_Section = Home_Tab:CreateSection("Main / Home | Page")
local LocalPlayer_Tab = Window:CreateTab({
    Name = "LocalPlayer",
    Icon = "person",
    ImageSource = "Material",
    ShowTitle = true
})
local LocalPlayer_Section = LocalPlayer_Tab:CreateSection("LocalPlayer | Page")
local Vehicle_Tab = Window:CreateTab({
    Name = "Vehicle",
    Icon = "directions_car",
    ImageSource = "Material",
    ShowTitle = true
})
local Vehicle_Section = Vehicle_Tab:CreateSection("Vehicle | Page")
local Players_Tab = Window:CreateTab({
    Name = "Players",
    Icon = "group",
    ImageSource = "Material",
    ShowTitle = true
})
local Players_Section = Players_Tab:CreateSection("Players | Page")
local priv_server_is_in = g.is_in_private_server()
local PrivServer_Tab
local PrivServer_Section

if priv_server_is_in == true then
    PrivServer_Tab = Window:CreateTab({
        Name = "Private Server",
        Icon = "lock_outline",
        ImageSource = "Material",
        ShowTitle = true
    })
    PrivServer_Section = PrivServer_Tab:CreateSection("Private Server | Page")
end
local Phone_Tab = Window:CreateTab({
    Name = "Phone",
    Icon = "smartphone",
    ImageSource = "Material",
    ShowTitle = true
})
local Phone_Section = Phone_Tab:CreateSection("Phone | Page")
local Houses_Tab = Window:CreateTab({
    Name = "Houses",
    Icon = "home_filled",
    ImageSource = "Material",
    ShowTitle = true
})
local Houses_Section = Houses_Tab:CreateSection("Houses | Page")
local Extras_Tab = Window:CreateTab({
    Name = "Extras",
    Icon = "widgets",
    ImageSource = "Material",
    ShowTitle = true
})
local Extras_Section = Extras_Tab:CreateSection("Extras | Page")
wait(0.25)
g.create_ui_element("Button", Home_Tab, {
Name = "Join the Flames Hub Discord server.",
Description = "Redirects you to the official Discord server for Flames Hub, or copies it.",
Callback = function()
    local http_requesting_func = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
    local http_service = g.HttpService or (cloneref and cloneref(game:GetService("HttpService"))) or game:GetService("HttpService")
    local opened = false
    if http_requesting_func then
        local success = pcall(function()
            http_requesting_func({
                Url = 'http://127.0.0.1:6463/rpc?v=1',
                Method = 'POST',
                Headers = {
                    ['Content-Type'] = 'application/json',
                    Origin = 'https://discord.com'
                },
                Body = http_service:JSONEncode({
                    cmd = 'INVITE_BROWSER',
                    nonce = http_service:GenerateGUID(false),
                    args = {code = 'MTYKxQfpNJ'}
                })
            })
        end)
        opened = success
    end
    wait(0.25)
    if not opened then
        if g.AllClipboards then g.AllClipboards("https://discord.gg/MTYKxQfpNJ") end
        if g.notify then g.notify("Success", "Successfully copied Discord server link to your Clipboard.", 5) end
    end
end})

g.create_ui_element("Toggle", Home_Tab, {
Name = "Anti Hashtags (FE) BETA!",
Description = "Stops hashtagged messages from sending, preventing hashtags.",
CurrentValue = (getgenv().FlamesLibrary.modules and getgenv().FlamesLibrary.modules.chat_filter_override.enabled) or false,
Callback = function(state)
    if getgenv().FlamesLibrary.modules then getgenv().FlamesLibrary.modules.chat_filter_override:toggle(state) end
end})

g.create_ui_element("Button", Home_Tab, {
Name = "Destroy GUI",
Description = "Fully shuts-down this menu, but leaves everything on for you.",
Callback = function()
    if Luna then Luna:Destroy() end
end})

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Job Spammer (FE)",
Description = "Toggles Job Spammer, which spams every job available / RGB name.",
CurrentValue = getgenv().Every_Job or false,
Callback = function(state)
    g.job_spammer(state)
end}, "Job_Spammer_Toggled_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Glitch Outfit (FE)",
Description = "Toggles Glitch Outfit, which basically makes your clothing look bugged out.",
CurrentValue = getgenv().Glitching_Outfit or false,
Callback = function(state)
    g.glitch_outfit(state)
end}, "Glitch_Outfit_Toggle_UI")

g.create_ui_element("Button", Vehicle_Tab, {
Name = "Despawn Vehicle (FE)",
Description = "Despawns your currently spawned vehicle.",
Callback = function()
    local Current_Car = get_vehicle()
    if not Current_Car then return g.notify("Error", "You do not have a vehicle spawned!", 3) end
    if Current_Car then
        g.notify("Success", "Despawned Vehicle: " .. tostring(Current_Car), 5)
        spawn_any_vehicle(tostring(Current_Car.Name))
    end
end}, "Despawn_Vehicle_Button_UI")

g.create_ui_element("Toggle", Vehicle_Tab, {
Name = "Rainbow Vehicle (FE)",
Description = "Toggles Rainbow Car, which makes your car colors change rapidly.",
CurrentValue = getgenv().Rainbow_Vehicle or false,
Callback = function(state)
    g.RGB_Vehicle(state)
end}, "Rainbow_Vehicle_Toggle_UI")

g.create_ui_element("Toggle", Vehicle_Tab, {
Name = "Two Tone Vehicle (FE)",
Description = "Toggles Two Tone Car, which makes your car 2 different colors on loop.",
CurrentValue = getgenv().two_tone_vehicle_colors_changing or false,
Callback = function(state)
    g.two_color_switcher_FE_func(state)
end}, "Two_Tone_Car_Toggle_UI")

g.create_ui_element("Toggle", Phone_Tab, {
Name = "Rainbow Phone (FE)",
Description = "Toggles Rainbow Phone, which makes your Phone change colors rapidly.",
CurrentValue = getgenv().RGB_Rainbow_Phone or false,
Callback = function(state)
    g.RGB_Phone(state)
end}, "Rainbow_Phone_Toggle_UI")

g.create_ui_element("Toggle", Home_Tab, {
Name = "Free Premium (FE)",
Description = "This does not include houses, invisiblity, or extra outfit slots.",
CurrentValue = getgenv().Has_Free_LifePremium or false,
Callback = function(state)
    g.FreePayFuncToggle(state)
end}, "Free_Premium_Toggle_UI")

g.create_ui_element("Input", Vehicle_Tab, {
Name = "Spawn Vehicle (FE, Any)",
Description = "Spawns any Vehicle you type it if it matches one in the game.",
PlaceholderText = "Enter vehicle name...",
Callback = function(split)
    local input = split:lower():gsub("%s+", "")
    local matched = false
    if input:find("broom") or input:find("broomstick") then
        spawn_any_vehicle("Magic Carpet")
        g.notify("Success", "Spawning requested vehicle: Broomstick.", 3)
        return
    elseif input:find("magiccarpet") or input:find("carpet") then
        spawn_any_vehicle("Magic Carpett")
        g.notify("Success", "Spawning requested vehicle: Magic Carpet.", 3)
        return
    end

    for car_key, full_name in pairs(CarMap) do
        local cleanKey = car_key:lower():gsub("%s+", "")
        if cleanKey:find(input, 1, true) then
            spawn_any_vehicle(full_name)
            g.notify("Success", "Spawning requested vehicle: " .. tostring(full_name), 3)
            matched = true
            break
        end
    end

    if not matched then
        g.notify("Error", tostring(input) .. " did not match any existing Vehicles, if you want to spawn Vehicles easier use the command: " .. tostring(g.AdminPrefix) .. "allcars", 15)
    end
end}, "Spawn_Vehicle_Input_UI")

g.create_ui_element("Input", LocalPlayer_Tab, {
Name = "Teleport To Player",
Description = "Enter UserName / DisplayName, doesn't have to be full.",
PlaceholderText = "user or display...",
Callback = function(text)
    local Target = findplr(text)
    if not Target then return g.notify("Error", "That is not a valid Player.", 3) end
    local Target_Char = Target.Character or get_char(Target, 5)
    if not Target_Char then return g.notify("Error", "Target character is not loaded.", 3) end
    local Char = g.Character or g.LocalPlayer.Character or get_char(LocalPlayer, 10)
    if not Char then return g.notify("Error", "Your Character does not exist.", 5) end
    local Hum = g.Humanoid or Char:FindFirstChildOfClass("Humanoid") or get_human(LocalPlayer, 10)
    if not (Char and Hum) then return g.notify("Error", "Your character is not loaded yet!", 3) end
    if Hum.Sit then
        pcall(function() Hum:ChangeState(3) end)
        task.wait(0.2)
    end

    local Ok, Pivot = pcall(function() return Target_Char:GetPivot() end)
    if not Ok or not Pivot then return g.notify("Error", "Failed to get target position.", 3) end
    if Char and Char:FindFirstChildOfClass("Humanoid") then Char:PivotTo(Pivot * CFrame.new(0, 5, 0)) end
    g.notify("Success", "Teleported to "..Target.Name, 3)
end}, "Teleport_Player_Input_UI")

g.create_ui_element("Input", LocalPlayer_Tab, {
Name = "View Player",
Description = "Enter a username or displayname to spectate them.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local View_Target = findplr(split)
    if not View_Target then return g.notify("Error", "Target was not found or does not exist!", 5) end
    if g.Viewing_A_Player then return g.notify("Error", "You're already viewing someone, unview them first.", 5) end
    local target_char = View_Target.Character or get_char(View_Target, 5)
    if not target_char then return g.notify("Error", "Target character not loaded!", 5) end
    local target_human = target_char:FindFirstChildOfClass("Humanoid") or get_human(View_Target, 5)
    if not target_human then return g.notify("Error", "Target humanoid not found!", 5) end
    g.Viewing_A_Player = true
    workspace.CurrentCamera.CameraSubject = target_human or target_char or g.Character
end}, "View_Player_Input_UI")

g.create_ui_element("Button", LocalPlayer_Tab, {
Name = "Unview Player",
Description = "Unviews any player you're spectating.",
Callback = function()
    if not g.Viewing_A_Player then return g.notify("Error", "You're not viewing anyone.", 5) end
    g.Viewing_A_Player = false
    workspace.CurrentCamera.CameraSubject = g.Humanoid or g.Character or g.LocalPlayer.Character or get_char(LocalPlayer, 10)
end})

g.create_ui_element("Toggle", Vehicle_Tab, {
Name = "Vehicle Fly (FE)",
Description = "Enables a working Vehicle-Fly that will not break your car.",
CurrentValue = getgenv().vehicle_fly or false,
Callback = function(state)
    g.toggle_vehicle_fly(state)
end}, "Vehicle_Fly_Toggle_UI")

g.create_ui_element("Toggle", Vehicle_Tab, {
Name = "Anti Car Fling (FE)",
Description = "Enables anticarfling, preventing you from being flung by Vehicles.",
CurrentValue = getgenv().VehicleDestroyer_Enabled or false,
Callback = function(state)
    g.anti_car_fling(state)
end}, "Anti_Car_Fling_Toggle_UI")

g.create_ui_element("Toggle", Vehicle_Tab, {
Name = "Auto Lock Car (FE)",
Description = "Automatically (loop) locks your vehicle/car when there is one spawned.",
CurrentValue = getgenv().AutoLockOn or false,
Callback = function(state)
    if g.ToggleAutoLock then g.ToggleAutoLock(state) end
end}, "Auto_Lock_Car_Toggle_UI")

g.create_ui_element("Button", Vehicle_Tab, {
Name = "Lock Car (FE)",
Description = "Locks your currently spawned car.",
Callback = function()
    local Current_Car = get_vehicle()
    if not Current_Car then return g.notify("Error", "You do not have a vehicle spawned!", 5) end
    if Current_Car:GetAttribute("locked") == true then return g.notify("Error", "Your Vehicle is already locked.", 5) end
    lock_vehicle(get_vehicle())
    g.notify("Success", "Locked vehicle: " .. tostring(Current_Car), 5)
end}, "Lock_Car_Button_UI")

g.create_ui_element("Button", Vehicle_Tab, {
Name = "Unlock Car (FE)",
Description = "Unlocks your currently spawned car.",
Callback = function()
    local Current_Car = get_vehicle()
    if not Current_Car then return g.notify("Error", "You do not have a vehicle spawned!", 5) end
    if Current_Car:GetAttribute("locked") ~= true then return g.notify("Error", "Your vehicle is already unlocked!", 5) end
    lock_vehicle(get_vehicle())
    g.notify("Success", "Unlocked vehicle: " .. tostring(Current_Car), 5)
end}, "Unlock_Car_Button_UI")

g.create_ui_element("Toggle", Vehicle_Tab, {
Name = "Trailer (FE)",
Description = "Gives you the WaterSkies trailer on any vehicle.",
CurrentValue = getgenv().trailer_enabled or false,
Callback = function(state)
    local Vehicle = get_vehicle()
    if not Vehicle then return g.notify("Error", "You do not have a Vehicle spawned, spawn one and try again!", 7) end
    if state then
        g.notify("Success", "Added WaterSkies to Vehicle: " .. tostring(Vehicle), 5)
    else
        g.notify("Success", "Removed WaterSkies trailer from: " .. tostring(Vehicle), 5)
    end
    water_skie_trailer(state, get_vehicle())
end}, "Trailer_Toggle_UI")

g.create_ui_element("Toggle", Vehicle_Tab, {
Name = "View Car (FE)",
Description = "Views your Vehicle, setting your camera to it.",
CurrentValue = getgenv().viewing_car or false,
Callback = function(state)
    if state then
        local Camera = g.Camera or workspace.CurrentCamera
        local Vehicle = get_vehicle()
        if not Vehicle then return g.notify("Error", "You don't have a Vehicle spawned, spawn one and try again!", 7) end
        local fallback = g.Humanoid or g.Character or get_human(g.LocalPlayer, 30) or get_char(g.LocalPlayer, 45)
        if not fallback then return g.notify("Error", "No fallback camera subject found.", 5) end
        if g.CamWatcherConn then
            g.CamWatcherConn:Disconnect()
            g.CamWatcherConn = nil
        end
        local function find_vehicle_part(v)
            return v:FindFirstChildWhichIsA("VehicleSeat", true)
                or v:FindFirstChildWhichIsA("Seat", true)
                or v:FindFirstChildWhichIsA("BasePart", true)
        end
        local target = find_vehicle_part(Vehicle)
        if not target then return g.notify("Error", "Could not find a valid vehicle part.", 5) end
        Camera.CameraSubject = target
        getgenv().viewing_car = true
        g.notify("Info", "Now viewing Vehicle.", 5)
        g.CamWatcherConn = target.AncestryChanged:Connect(function()
            if not target:IsDescendantOf(workspace) then
                Camera.CameraSubject = fallback
                if g.CamWatcherConn then
                    g.CamWatcherConn:Disconnect()
                    g.CamWatcherConn = nil
                end
                getgenv().viewing_car = false
                g.notify("Info", "Vehicle lost, camera reset.", 5)
            end
        end)
    else
        local Camera = g.Camera or workspace.CurrentCamera
        local function fallbackto()
            return g.Humanoid or g.Character or g.LocalPlayer.Character
        end
        if g.CamWatcherConn then
            g.CamWatcherConn:Disconnect()
            g.CamWatcherConn = nil
        end
        local fb = fallbackto()
        if fb then
            Camera.CameraSubject = fb
            g.notify("Info", "Camera now set back to your character.", 5)
        end
        getgenv().viewing_car = false
    end
end}, "View_Car_Toggle_UI")

g.create_ui_element("Button", Vehicle_Tab, {
Name = "Bring Vehicle To Me (FE)",
Description = "Teleport car to you and sit in it.",
Callback = function()
    local Util = g.Util or require(g.ReplicatedStorage:FindFirstChild("Util", true))
    if not Util then return g.notify("Error", "ModuleScript: 'Util' does not seem to exist.", 5) end
    local function get_hrp()
        if g.HumanoidRootPart then return g.HumanoidRootPart end
        return g.Char.get_hrp()
    end
    local hrp = get_hrp()
    if not hrp then return g.notify("Error", "Could not find HumanoidRootPart!", 5) end
    local myVehicle = nil
    for _, v in ipairs(workspace:WaitForChild("Vehicles"):GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("owner") and v.owner.Value == game.Players.LocalPlayer then
            if v:FindFirstChild("VehicleSeat") then
                myVehicle = v
                break
            end
        end
    end
    if not myVehicle then return g.notify("Error", "No owned vehicle found!", 5) end
    local seat = myVehicle:FindFirstChild("VehicleSeat", true)
    local savedCF = hrp.CFrame
    if seat and g.Humanoid then
        g.Character:PivotTo(seat.CFrame)
        fw(0.2)
        seat:Sit(g.Humanoid)
    end
    fw(0.1)
    local targetCF = savedCF * CFrame.new(0, 10, 0)
    local tween = Util.tween_model(myVehicle, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), targetCF)
    if tween then tween.Completed:Wait() end
    g.notify("Success", "Brought your Vehicle to you!", 5)
end}, "Bring_Vehicle_Button_UI")

g.create_ui_element("Button", Vehicle_Tab, {
Name = "Go To Vehicle (FE)",
Description = "Teleports you straight to your car/vehicle directly.",
Callback = function()
    local Vehicle = get_vehicle()
    if not Vehicle then return g.notify("Error", "You do not have a vehicle spawned, spawn one and try again!", 7) end
    if g.Character and g.Character:FindFirstChild("HumanoidRootPart") then
        g.Character:PivotTo(get_vehicle():GetPivot() * CFrame.new(0, 5, 0))
    end
end}, "Go_To_Vehicle_Button_UI")

g.create_ui_element("Input", Vehicle_Tab, {
Name = "Teleport Car To Player (FE)",
Description = "Teleports your vehicle/car to the specified target.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local Vehicle = get_vehicle()
    if not Vehicle then return g.notify("Error", "You do not have a vehicle spawned, spawn one and try again!", 7) end
    local Goto_Player = findplr(split)
    if not Goto_Player then return g.notify("Error", "Target player not found / does not exist / or has left the game.", 8) end
    local Old_CFrame_TP_Car = g.Character:FindFirstChild("HumanoidRootPart").CFrame

    if Goto_Player and Goto_Player.Character and Goto_Player.Character:FindFirstChild("Humanoid") then
        local Target_Char = Goto_Player.Character or g.get_char(Goto_Player)
        if not Target_Char then return end
        local Target_CFrame = Target_Char and Target_Char:GetPivot() * CFrame.new(0, 5, 0)
        local myVehicle = nil

        for _, v in ipairs(g.Workspace.Vehicles:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("owner") and v.owner.Value == g.LocalPlayer then
                if v:FindFirstChild("VehicleSeat") then
                    myVehicle = v
                    break
                end
            end
        end

        if not myVehicle then return g.notify("Error", "No owned vehicle found.", 5) end
        local seat = myVehicle:FindFirstChild("VehicleSeat")
        if seat and g.Humanoid then
            g.Character:PivotTo(seat.CFrame)
            fw(0.2)
            seat:Sit(g.Humanoid)
        end
        fw(0.1)
        myVehicle:PivotTo(Target_CFrame)
        fw(0.3)
        if g.Humanoid.Sit then
            g.Humanoid:ChangeState(3)
            fw(0.2)
            g.HumanoidRootPart.CFrame = Old_CFrame_TP_Car
        else
            g.HumanoidRootPart.CFrame = Old_CFrame_TP_Car
        end

        g.notify("Success", "Teleported vehicle to target player: " .. tostring(Goto_Player), 5)
    end
end}, "TP_Car_To_Player_Input_UI")

g.create_ui_element("Input", Vehicle_Tab, {
Name = "Steal Car (FE)",
Description = "Allows you to swiftly take someones car.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local take_vehicle_target_plr = findplr(split)
    if not take_vehicle_target_plr then return g.notify("Error", "That Player does not exist, or has left the game.", 7) end
    local plrs_spawned_vehicle = g.get_other_vehicle(take_vehicle_target_plr)
    if not plrs_spawned_vehicle then return g.notify("Error", "That Player does not have a Vehicle spawned.", 6) end
    if g.Character and g.Character.Parent and g.Character:FindFirstChild("HumanoidRootPart") then
        g.Character:PivotTo(plrs_spawned_vehicle:GetPivot() + Vector3.new(0, 3, 0))
    end
    fw(0.2)
    g.steal_car_functionality(take_vehicle_target_plr)
end}, "Steal_Car_Input_UI")

g.create_ui_element("Toggle", Vehicle_Tab, {
Name = "Vehicle ESP",
Description = "Enables Vehicle ESP, which lets you see cars through walls from anywhere.",
CurrentValue = getgenv().vehicle_esp_enabled or false,
Callback = function(state)
    vehicle_esp_toggle(state)
end}, "Vehicle_ESP_Toggle_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Orbit Player (FE)",
Description = "Lets you Orbit around the target Player (FE).",
PlaceholderText = "User or Display...",
Callback = function(split)
    local Target = findplr(split)
    if not Target then return g.notify("Error", "Target doesn't exist or has left the game.", 5) end
    if g.Is_Orbiting then return g.notify("Warning", "You're already orbiting somebody.", 5) end
    local speed = getgenv().Orbit_Speed_Value or 1
    local distance = getgenv().Orbit_Distance_Value or 5
    start_orbit_plr(Target, speed, distance)
end}, "Orbit_Player_Input_UI")

g.create_ui_element("Slider", Players_Tab, {
Name = "Orbit Speed",
Range = {1, 75},
Increment = 1,
CurrentValue = getgenv().Orbit_Speed_Value or 1,
Callback = function(val)
    getgenv().Orbit_Speed_Value = val
    if g.Is_Orbiting then
        set_orbit_speed(val)
    end
end}, "Orbit_Speed_Slider_UI")

g.create_ui_element("Slider", Players_Tab, {
Name = "Orbit Distance",
Range = {1, 75},
Increment = 1,
CurrentValue = getgenv().Orbit_Distance_Value or 5,
Callback = function(val)
    getgenv().Orbit_Distance_Value = val
end}, "Orbit_Distance_Slider_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Annoy Player (FE)",
Description = "Spam calls + spam request carries the target player (FE).",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local Target = findplr(split)
    if not Target then return g.notify("Error", "That Player does not exist or has left the game.", 7) end
    if Target.Name == "CIippedByAura" or Target.Name == "L0CKED_1N1" then return end
    if g.Currently_Running_Annoy_Loop then
        if g.Currently_Annoying_Player then
            return g.notify("Error", "You are already annoying: " .. tostring(g.Currently_Annoying_Player) .. "!", 5)
        else
            return g.notify("Error", "You are already annoying a Player!", 5)
        end
    end

    local target_userid = Target.UserId
    local rejoin_limit = 60
    g.Currently_Annoying_Player = Target.Name
    g.annoy_active = true
    g.notify("Success", "Now annoying Player: " .. Target.Name, 7)

    local Annoy_Thread = task.spawn(function()
        while g.annoy_active == true do
            fw(0)
            local success = pcall(function()
                if not Target or not Target.Parent or not Target.Character then
                    local elapsed_time = 0
                    g.notify("Warning", "Target left, waiting 60 seconds for them to rejoin...", 12)
                    while elapsed_time < rejoin_limit and g.annoy_active == true do
                        local found_player = false
                        for _, plr in ipairs(g.Players:GetPlayers()) do
                            if plr.UserId == target_userid then
                                Target = plr
                                g.notify("Success", "Target rejoined, resuming annoyance loop!", 6)
                                found_player = true
                                break
                            end
                        end
                        if found_player then break end
                        fw(1)
                        elapsed_time += 1
                    end

                    if elapsed_time >= rejoin_limit then
                        g.annoy_active = false
                        g.Currently_Annoying_Player = nil
                        g.Currently_Running_Annoy_Loop = nil
                        return g.notify("Warning", "Target did not rejoin within 60 seconds, loop disabled.", 10)
                    end
                end

                g.Send("request_carry", Target)
                fw(0)
                g.Send("request_call", Target)
                fw(0)
                g.Send("end_call", Target)
            end)

            if not success then
                g.annoy_active = false
                g.Currently_Annoying_Player = nil
                g.Currently_Running_Annoy_Loop = nil
            end
        end

        g.Currently_Annoying_Player = nil
        g.Currently_Running_Annoy_Loop = nil
    end)

    g.Currently_Running_Annoy_Loop = Annoy_Thread
end}, "Annoy_Player_Input_UI")

g.create_ui_element("Button", Players_Tab, {
Name = "UnAnnoy Player",
Description = "Disables the Annoy loop that you've set above.",
Callback = function() 
    if not g.annoy_active then
        return g.notify("Warning", "Annoy Player is not currently running.", 5)
    end

    g.annoy_active = false
    if g.Currently_Annoying_Player then g.Currently_Annoying_Player = nil end
    if g.Currently_Running_Annoy_Loop then g.Currently_Running_Annoy_Loop = nil end
    g.notify("Success", "Annoy loop disabled.", 5)
end})

g.create_ui_element("Input", Players_Tab, {
Name = "Loop Fling Player (broken)",
Description = "Automatically flings the target Player on loop.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local loop_fling_victim = findplr(split)
    if not loop_fling_victim then return g.notify("Error", "That Player does not exist!", 5) end
    if loop_fling_victim and loop_fling_victim.Character then
        g.start_loopfling(loop_fling_victim)
    end
end}, "Loop_Fling_Input_UI")

g.create_ui_element("Button", Home_Tab, {
Name = "Tools Menu (Pistol + Laser) (FE)",
Description = "Executes the GUI used for Tools and what not.",
Callback = function()
    g.tools_menu_for_life_together_flames_hub()
end})

g.create_ui_element("Input", Players_Tab, {
Name = "Bring Player (FE)",
Description = "Uses the SchoolBus Vehicle to bring the target.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local target = findplr(split)
    if not target then return g.notify("Error", "Target not found.", 5) end
    if g.Not_Ever_Sitting then return g.notify("Error", "Anti-Sit is enabled, turn it off first!", 5) end
    local function wait_for_bus(timeout)
        local t = 0
        while t < timeout do
            for _, v in ipairs(g.Workspace.Vehicles:GetChildren()) do
                if v:IsA("Model") and v.Name == "SchoolBus" and v:FindFirstChild("owner") and v.owner.Value == g.LocalPlayer then
                    return v
                end
            end
            fw(0.2)
            t = t + 0.2
        end
        return nil
    end

    local Vehicle = get_vehicle()
    if not Vehicle or Vehicle.Name ~= "SchoolBus" then
        spawn_any_vehicle("SchoolBus")
        fw(0.5)
        Vehicle = wait_for_bus(5)
    end

    if Vehicle and Vehicle.Name == "SchoolBus" then
        vehicle_bring_player(target)
        g.notify("Success", "Bringing player: " .. target.Name, 3)
    else
        g.notify("Error", "Failed to spawn/find SchoolBus.", 3)
    end
end}, "Bring_Player_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Kill Player (FE)",
Description = "Uses the SchoolBus Vehicle to kill the target.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local target = findplr(split)
    if not target then return g.notify("Error", "Target not found.", 5) end
    if g.Not_Ever_Sitting then return g.notify("Error", "Anti-Sit is enabled, turn it off first!", 5) end
    local function wait_for_bus(timeout)
        local t = 0
        while t < timeout do
            for _, v in ipairs(g.Workspace.Vehicles:GetChildren()) do
                if v:IsA("Model") and v.Name == "SchoolBus" and v:FindFirstChild("owner") and v.owner.Value == g.LocalPlayer then
                    return v
                end
            end
            fw(0.2)
            t = t + 0.2
        end
        return nil
    end

    local Vehicle = get_vehicle()
    if not Vehicle or Vehicle.Name ~= "SchoolBus" then
        spawn_any_vehicle("SchoolBus")
        fw(0.5)
        Vehicle = wait_for_bus(5)
    end

    if Vehicle and Vehicle.Name == "SchoolBus" then
        vehicle_kill_player(target)
        g.notify("Success", "Killing player: " .. target.Name, 3)
    else
        g.notify("Error", "Failed to spawn/find SchoolBus.", 3)
    end
end}, "Kill_Player_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Void Player (FE)",
Description = "Uses the SchoolBus Vehicle to void the target.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local target = findplr(split)
    if not target then return g.notify("Error", "Target Player not found.", 5) end
    if g.Not_Ever_Sitting then return g.notify("Error", "Anti-Sit is enabled, turn it off first!", 5) end
    local function wait_for_bus(timeout)
        local t = 0
        while t < timeout do
            for _, v in ipairs(g.Workspace.Vehicles:GetChildren()) do
                if v:IsA("Model") and v.Name == "SchoolBus" and v:FindFirstChild("owner") and v.owner.Value == g.LocalPlayer then
                    return v
                end
            end
            fw(0.2)
            t = t + 0.2
        end
        return nil
    end

    local Vehicle = get_vehicle()
    if not Vehicle or Vehicle.Name ~= "SchoolBus" then
        spawn_any_vehicle("SchoolBus")
        fw(0.5)
        Vehicle = wait_for_bus(5)
    end

    if Vehicle and Vehicle.Name == "SchoolBus" then
        vehicle_void_player(target)
        g.notify("Success", "Sending player to the Void | player: " .. target.Name, 3)
    else
        g.notify("Error", "Failed to spawn/find SchoolBus.", 3)
    end
end}, "Void_Player_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Skydive Player (FE)",
Description = "Uses the SchoolBus Vehicle to skydive the target.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local target = findplr(split)
    if not target then return g.notify("Error", "Target not found.", 5) end
    if g.Not_Ever_Sitting then return g.notify("Error", "Anti-Sit is enabled, turn it off first!", 5) end

    local function wait_for_bus(timeout)
        local t = 0
        while t < timeout do
            for _, v in ipairs(g.Workspace.Vehicles:GetChildren()) do
                if v:IsA("Model") and v.Name == "SchoolBus" and v:FindFirstChild("owner") and v.owner.Value == g.LocalPlayer then
                    return v
                end
            end
            fw(0.2)
            t = t + 0.2
        end
        return nil
    end

    local Vehicle = get_vehicle()
    if not Vehicle or Vehicle.Name ~= "SchoolBus" then
        spawn_any_vehicle("SchoolBus")
        fw(0.5)
        Vehicle = wait_for_bus(5)
    end

    if Vehicle and Vehicle.Name == "SchoolBus" then
        vehicle_skydive_player(target)
        g.notify("Success", "Skydiving player: " .. target.Name, 3)
    else
        g.notify("Error", "Failed to spawn/find SchoolBus.", 3)
    end
end}, "Skydive_Player_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Copy Avatar (FE)",
Description = "Copies the target players entire avatar (FE).",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local Target = findplr(split)
    if not Target then return g.notify("Error", "That player doesn't exist in this game!", 5) end
    if g.is_copying_avatar_already_flames then return g.notify("Warning", "Copy avatar is already running!, wait a moment, until it's done.", 5) end
    if Target.Name == "CIippedByAura" or Target.Name == "L0CKED_1N1" then return g.notify("Error", "You can't copy this player's avatar!", 5) end
    copy_plr_avatar(Target)
end}, "Copy_Avatar_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Copy Player Emote (FE)",
Description = "Copies the Animation/Emote that the target Player is doing.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local target_plr = findplr(split)
    if not target_plr then return g.notify("Error", "Player not found or does not exist.", 5) end
    copy_emote_plr(target_plr)
end}, "Copy_Emote_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Check Premium",
Description = "Checks if a player has LifePay premium or not.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local Player = findplr(split)
    if not Player then return g.notify("Error", "Player doesn't exist or left the game.", 5) end
    local Result = check_premium_player(Player)

    if Result == true then
        return g.notify("Success", "[Result]: " .. tostring(Player.Name) .. " does have premium!", 6)
    elseif Result == false then
        return g.notify("Success", "[Result]: " .. tostring(Player.Name) .. " does not have premium.", 6)
    else
        return g.notify("Error", "Something unexpectedly happened while checking Player.", 5)
    end
end}, "Check_Premium_Input_UI")

g.create_ui_element("Input", LocalPlayer_Tab, {
Name = "WalkSpeed (FE)",
Description = "Changes your WalkSpeed.",
PlaceholderText = "Enter walkspeed...",
Callback = function(split)
    local New_Val = tonumber(split) or 16
    if not g.Humanoid then return g.notify("Warning", "Wait until you respawn (or reset), we think you're dead, Humanoid is missing.", 10) end
    if g.Humanoid.WalkSpeed == New_Val then return g.notify("Warning", "Your WalkSpeed is already: " .. tostring(New_Val), 5) end
    change_property("WalkSpeed", New_Val)
    g.notify("Success", "Updated WalkSpeed to: " .. tostring(New_Val), 5)
end}, "Speed_Input_UI")

g.create_ui_element("Input", LocalPlayer_Tab, {
Name = "Jump Height (FE)",
Description = "Changes your JumpHeight.",
PlaceholderText = "Enter jump height...",
Callback = function(split)
    local New_ValJP = tonumber(split) or 7
    if not g.Humanoid then return g.notify("Warning", "Wait until you respawn (or reset), we think you're dead, Humanoid is missing.", 10) end
    if g.Humanoid.JumpPower == New_ValJP then return g.notify("Warning", "Your JumpPower is already: " .. tostring(New_ValJP), 5) end
    change_property("JumpHeight", New_ValJP)
    g.notify("Success", "Updated JumpHeight to: " .. tostring(New_ValJP), 5)
end}, "Jump_Height_Input_UI")

g.create_ui_element("Input", LocalPlayer_Tab, {
Name = "Gravity (FE)",
Description = "Changes the current Gravity value.",
PlaceholderText = "Enter gravity value...",
Callback = function(split)
    local New_Grav = tonumber(split) or 196
    if g.Workspace.Gravity == New_Grav then return g.notify("Warning", "Gravity is already: " .. tostring(New_Grav), 5) end
    change_gravity_val(New_Grav)
    g.notify("Success", "Updated Gravity to: "..tostring(New_Grav), 5)
end}, "Gravity_Input_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Noclip (FE)",
Description = "Enables Noclip, letting you walk through everything.",
CurrentValue = getgenv().Noclip_Enabled or false,
Callback = function(state)
    if state then
        if g.Noclip_Connection then return g.notify("Warning", "Noclip connection is active, disable Noclip and try again.", 6) end
        g.Toggleable_Noclip(true)
    else
        if not g.Noclip_Enabled then return g.notify("Error", "Noclip is not enabled, enable it first.", 5) end
        g.Toggleable_Noclip(false)
    end
end}, "Noclip_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Invisible (FE)",
Description = "Allows you to go Invisible (for free) via the teleport method (FE).",
CurrentValue = getgenv().is_invisible_script_toggled or false,
Callback = function(state)
    if state then
        if g.is_invisible_script_toggled then return g.notify("Warning", "You're already Invisible.", 5) end
        g.set_invisible(true)
    else
        if not g.is_invisible_script_toggled then return g.notify("Warning", "You're not currently Invisible.", 5) end
        g.set_invisible(false)
    end
end}, "Invisible_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Float (FE)",
Description = "Allows you to literally float in the air and go up and down (FE).",
CurrentValue = getgenv().Float_Running_In_Flames_Hub or false,
Callback = function(state)
    if state then
        g.start_flames_float()
    else
        g.stop_flames_float()
    end
end}, "Float_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Spin (FE)",
Description = "Spins your character (FE).",
CurrentValue = getgenv().already_spinning_localplr or false,
Callback = function(state)
    if state then
        local speed = getgenv().Spin_Speed_Value or 5
        spin_plr(true, speed)
    else
        spin_plr(false)
    end
end}, "Spin_Toggle_UI")

g.create_ui_element("Slider", LocalPlayer_Tab, {
Name = "Spin Speed",
Range = {1, 100},
Increment = 1,
CurrentValue = getgenv().Spin_Speed_Value or 5,
Callback = function(val)
    getgenv().Spin_Speed_Value = val
    if g.already_spinning_localplr then
        change_spin_speed(val)
    end
end}, "Spin_Speed_Slider_UI")

g.create_ui_element("Input", LocalPlayer_Tab, {
Name = "Size Character (FE)",
Description = "Makes your Character whatever size you put in.",
PlaceholderText = "Enter size...",
Callback = function(split)
    local new_size = split
    if not new_size then return end
    g.height_func_setter(new_size)
end}, "Size_Input_UI")

g.create_ui_element("Button", LocalPlayer_Tab, {
Name = "Normal Size (FE)",
Description = "Makes your Character normal size again (FE).",
Callback = function()
    pcall(function()
        g.reset_to_original_height()
    end)
end}, "Normal_Size_Button_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Flash Name (FE)",
Description = "Toggles your name on and off really fast.",
CurrentValue = getgenv().Flashing_Name_Title or false,
Callback = function(state)
    if state then
        if g.Flashing_Name_Title then return g.notify("Error", "You're already running Flash Name!", 5) end
        g.flashy_name(true)
        g.notify("Success", "Flash Name is now enabled.", 5)
    else
        if not g.Flashing_Name_Title then return g.notify("Error", "You're not currently running Flash Name!", 5) end
        g.flashy_name(false)
        g.notify("Success", "Flash Name is now disabled.", 5)
    end
end}, "Flash_Name_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Flash Invisible (FE)",
Description = "Makes you invisible and visible really fast.",
CurrentValue = getgenv().Invisible_Flash or false,
Callback = function(state)
    if state then
        if g.LocalPlayer:GetAttribute("is_verified") == false then return g.notify("Error", "You do not have LifePay premium for this (will not be FE without it).", 10) end
        fw(0.2)
        local Is_Invis = g.InvisibleMode.enabled.get()
        g.Invisible_Flash = true
        if Is_Invis then g.InvisibleMode.enabled.set(false) end
        fw(0.1)
        g.FlamesLibrary.spawn("flames_flash_invis", "spawn", function()
            while g.Invisible_Flash == true do
                g.InvisibleMode.enabled.set(true)
                fw(0.05)
                g.InvisibleMode.enabled.set(false)
                fw(0.05)
            end
            g.InvisibleMode.enabled.set(false)
        end)
    else
        g.Invisible_Flash = false
    end
end}, "Flash_Invis_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Night Vision",
Description = "Enables Night Vision (green vision).",
CurrentValue = getgenv().NightVisionEnabled or false,
Callback = function(state)
    g.night_vision(state)
end}, "Night_Vision_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Anti Fling",
Description = "Fully prevents you from being flung by others.",
CurrentValue = getgenv().afEnabled or false,
Callback = function(state)
    if state then
        if g.afEnabled then return g.notify("Warning", "Anti-Fling is already enabled!", 5) end
        g.Toggle_AntiFling_Boolean_Func(true)
        g.ToggleNoclip(true)
        g.hasSeen_AntiFling_WarningPrompt = true
        g.notify("Success", "Successfully enabled Anti-Fling.", 9)
    else
        if not g.afEnabled then return g.notify("Error", "Anti-Fling is not enabled.", 5) end
        g.Toggle_AntiFling_Boolean_Func(false)
        g.ToggleNoclip(false)
    end
end}, "Anti_Fling_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Anti Void",
Description = "Enables anti-void, preventing you from falling into the void.",
CurrentValue = g.Anti_Void_Enabled_Bool or false,
Callback = function(state)
    anti_void(state)
end}, "Anti_Void_Toggle_UI")

g.create_ui_element("Toggle", Houses_Tab, {
Name = "Anti House Ban (FE)",
Description = "Prevents you from being banned/kicked/teleported out of houses.",
CurrentValue = getgenv().never_banned_houses or false,
Callback = function(state)
    if state then
        if g.never_banned_houses or g.AntiTeleport then return g.notify("Error", "AntiHouseBan / AntiTeleport is already enabled.", 6) end
        local lib = getgenv().FlamesLibrary
        g.never_banned_houses = true
        g.AntiTeleport = true
        local LocalPlayer = g.LocalPlayer or game.Players.LocalPlayer
        local Character = g.Character or LocalPlayer.Character or get_char(LocalPlayer, 10)
        local HRP = g.HumanoidRootPart or Character and Character:FindFirstChild("HumanoidRootPart") or get_root(LocalPlayer, 10)
        local safe_cframe = HRP.CFrame
        local last_position = HRP.Position
        local latch_until = 0
        local function rebind()
            Character = g.Character or LocalPlayer.Character or get_char(LocalPlayer, 10)
            HRP = g.HumanoidRootPart or Character and Character:FindFirstChild("HumanoidRootPart") or get_root(LocalPlayer, 10)
            if not HRP then return end
            safe_cframe = HRP.CFrame
            last_position = HRP.Position
            latch_until = 0
        end
        lib.connect("AntiHouseBan_CharAdded", LocalPlayer.CharacterAdded:Connect(function()
            fw(0.1)
            rebind()
        end))
        lib.connect("AntiHouseBan_Heartbeat", RunService.Heartbeat:Connect(function()
            if not g.AntiTeleport then return end
            if not HRP or not HRP.Parent then return end
            local now = os.clock()
            local current_position = HRP.Position
            local delta = (current_position - last_position).Magnitude
            if delta > 12 then
                latch_until = now + 0.4
                HRP.CFrame = safe_cframe
                last_position = safe_cframe.Position
            elseif latch_until > now then
                HRP.CFrame = safe_cframe
                last_position = safe_cframe.Position
            else
                safe_cframe = HRP.CFrame
                last_position = HRP.Position
            end
        end))
        if PlotAreas then
            lib.spawn("AntiHouseBan_PlotLoop", "spawn", function()
                while g.never_banned_houses == true do
                    fw()
                    for _, v in ipairs(PlotAreas) do
                        if v then v.CanCollide = false end
                    end
                end
            end)
        else
            lib.disconnect("AntiHouseBan_CharAdded")
            lib.disconnect("AntiHouseBan_Heartbeat")
            g.never_banned_houses = false
            g.AntiTeleport = false
            return g.notify("Error", "PlotAreas missing or patched.", 10)
        end
        g.notify("Success", "Flames Hub | Anti-House-Ban V2 is now enabled.", 7)
    else
        if not g.never_banned_houses and not g.AntiTeleport then return g.notify("Warning", "AntiHouseBan is not enabled.", 5) end
        local lib = getgenv().FlamesLibrary
        lib.disconnect("AntiHouseBan_CharAdded")
        lib.disconnect("AntiHouseBan_Heartbeat")
        lib.disconnect("AntiHouseBan_PlotLoop")
        g.never_banned_houses = false
        g.AntiTeleport = false
        g.notify("Success", "Flames Hub | Anti-House-Ban V2 is now disabled.", 7)
    end
end}, "Anti_House_Ban_Toggle_UI")

g.create_ui_element("Button", LocalPlayer_Tab, {
Name = "Set SpawnPoint",
Description = "Sets a SpawnPoint where you're at, will TP you back to that spot after resetting.",
Callback = function()
    g.set_spawnpoint(0.1)
end}, "Set_Spawnpoint_Button_UI")

g.create_ui_element("Button", LocalPlayer_Tab, {
Name = "Clear SpawnPoint",
Description = "Disables the spawnpoint and clears it.",
Callback = function()
    g.clear_spawnpoint()
end}, "Clear_Spawnpoint_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Rejoin",
Description = "Makes you rejoin the current server.",
Callback = function()
    local PlaceID = game.PlaceId
    local JobID = game.JobId
    local function safe_teleport()
        local success, err = pcall(function()
            if #g.Players:GetPlayers() <= 1 then
                g.notify("Success", "You are now going to rejoin into a different server (this server is empty).", 10)
                g.TeleportService:Teleport(PlaceID, g.LocalPlayer)
            else
                g.notify("Success", "You are now going to be rejoined.", 5)
                g.TeleportService:TeleportToPlaceInstance(PlaceID, JobID, g.LocalPlayer)
            end
        end)
        if not success then
            g.notify("Error", "Teleporting failed: " .. tostring(err) .. " | going to re-try.", 15)
            fw(3)
            safe_teleport()
        end
    end
    safe_teleport()
end}, "Rejoin_Button_UI")

g.create_ui_element("Button", Home_Tab, {
Name = "YouTube Music Player (MIGHT CRASH YOU!)",
Description = "Lets you play music in-game, no-one hears it but you.",
Callback = function()
    g.load_youtube_music_player_func()
end})

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Anti Sit",
Description = "Prevents you from sitting down.",
CurrentValue = getgenv().Not_Ever_Sitting or false,
Callback = function(state)
    anti_sit_func(state)
end}, "Anti_Sit_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Walk Fling (FE)",
Description = "Enables WalkFling, flinging players you walk into.",
CurrentValue = getgenv().walkflinging or false,
Callback = function(state)
    if state then
        local fn = g.FlamesLibrary.safe_func(g.StartWalkFling)
        fn()
    else
        local fn = g.FlamesLibrary.safe_func(g.StopWalkFling)
        fn()
    end
end}, "Walk_Fling_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Name Spam (FE)",
Description = "Spam changes your name with no hashtags (FE).",
CurrentValue = getgenv().Name_Spammer_Currently_Enabled or false,
Callback = function(state)
    name_changer_premium(state)
end}, "Name_Spam_Toggle_UI")

g.create_ui_element("Toggle", Phone_Tab, {
Name = "Block Calls (FE)",
Description = "Enables Calls_Blocker_V3, which auto-declines all incoming calls.",
CurrentValue = getgenv().Auto_Calls_Blocker_V3_Is_Enabled_Boolean_Flag or false,
Callback = function(state)
    if state then
        if g.Auto_Calls_Blocker_V3_Is_Enabled_Boolean_Flag then
            return g.notify("Warning", "You already have Calls_Blocker_V3 enabled!", 6)
        end
        g.notify("Success", "Calls_Blocker_V3 has been enabled.", 5)
        g.Auto_Calls_Blocker_V3_Is_Enabled_Boolean_Flag = true
        g.FlamesLibrary.spawn("calls_blocker", "spawn", function()
            local net = g.Net
            local incoming_hook
            local emergency_hook
            incoming_hook = net.hook("incoming_call", function(plr)
                pcall(function()
                    g.Send("end_call", plr)
                end)
                return false
            end)
            emergency_hook = net.hook("incoming_emergency_call", function(plr)
                pcall(function()
                    g.Send("end_call", plr)
                end)
                return false
            end)
            g.calls_blocker_hooks = {
                incoming = incoming_hook,
                emergency = emergency_hook
            }
            while g.FlamesLibrary.is_alive("calls_blocker") do
                fw(1)
            end
        end)
    else
        if not g.Auto_Calls_Blocker_V3_Is_Enabled_Boolean_Flag then
            return g.notify("Warning", "You do NOT have Calls_Blocker_V3 enabled!", 6)
        end
        if g.calls_blocker_hooks then
            for _, v in pairs(g.calls_blocker_hooks) do
                pcall(function()
                    if typeof(v) == "RBXScriptConnection" then
                        v:Disconnect()
                    elseif type(v) == "function" then
                        v()
                    end
                end)
            end
            g.calls_blocker_hooks = nil
        end
        g.Auto_Calls_Blocker_V3_Is_Enabled_Boolean_Flag = false
        g.FlamesLibrary.disconnect("calls_blocker")
        g.notify("Success", "Calls_Blocker_V3 has been disabled.", 5)
    end
end}, "Block_Calls_Toggle_UI")

g.create_ui_element("Slider", LocalPlayer_Tab, {
Name = "Fly Speed",
Range = {1, 200},
Increment = 1,
CurrentValue = getgenv().Fly_Speed_Value or 5,
Callback = function(val)
    getgenv().Fly_Speed_Value = val
end}, "Fly_Speed_Slider_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Fly (FE)",
Description = "Enables Fly (E = up, Q = down, WASD to move).",
CurrentValue = getgenv().FlyEnabled or false,
Callback = function(state)
    if state then
        if g.FlyEnabled then return g.notify("Error", "Fly is already enabled!", 5) end
        if g.Enabled_Flying then return g.notify("Error", "Another fly is already enabled!", 5) end
        local speed = getgenv().Fly_Speed_Value or nil
        EnableFly(true, speed)
        g.notify("Warning", "E = up, Q = down, WASD to move.", 5)
    else
        DisableFly()
    end
end}, "Fly_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Fly 2 - Magic Carpet (FE)",
Description = "Enables Fly-2, the magic carpet Fly.",
CurrentValue = getgenv().Enabled_Flying or false,
Callback = function(state)
    if state then
        if g.Enabled_Flying then return g.notify("Error", "Fly-2 is already enabled!", 5) end
        if g.FlyEnabled then return g.notify("Error", "Fly-1 is already enabled, disable it first.", 6) end
        local speed = getgenv().Fly_Speed_Value or nil
        g.EnableFly2(speed)
        g.notify("Info", "Space = up, Shift = down, WASD to move.", 5)
    else
        DisableFly2()
    end
end}, "Fly2_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Fly 3 - Adonis (FE)",
Description = "Enables Fly-3, which is like Adonis Admin's Fly.",
CurrentValue = g.AdonisAdminFlyEnabled or false,
Callback = function(state)
    if state then
        if g.Enabled_Flying then return g.notify("Error", "Fly-2 is already enabled, disable it first.", 5) end
        if g.FlyEnabled then return g.notify("Error", "Fly-1 is already enabled, disable it first.", 6) end
        local speed = getgenv().Fly_Speed_Value or nil
        if speed then g.SetAdonisFlySpeed(speed) end
        g.notify("Info", "E = up, Q = down, WASD to move.", 5)
        g.StartAdonisAdminFlyScript()
    else
        g.Stop_Fly_3_Function()
    end
end}, "Fly3_Toggle_UI")

g.create_ui_element("Input", Vehicle_Tab, {
Name = "Car Max Speed (FE)",
Description = "Modifies your vehicle's max_speed attribute.",
PlaceholderText = "Enter number...",
Callback = function(split)
    local Vehicle = get_vehicle()
    local Hum = in_humanoid_vehicle(g.LocalPlayer)
    local Hum_Vehicle_Name = hum_vehicle_name(g.LocalPlayer)
    local n = tonumber(split)
    if not n then return g.notify("Warning", "Enter a valid number!", 6) end
    if Hum and Hum_Vehicle_Name then
        set_hum_vehicle_speed(n)
        return g.notify("Success", "Set HumanoidVehicle: " .. tostring(Hum_Vehicle_Name) .. "'s speed to: " .. tostring(n), 5)
    end
    if Vehicle and Vehicle:GetAttribute("max_speed") ~= nil then
        Vehicle:SetAttribute("max_speed", n)
        return g.notify("Success", "Set Vehicle: " .. tostring(Vehicle) .. "'s speed to: " .. tostring(n), 5)
    end
    g.notify("Error", "No car or humanoid vehicle found.", 5)
end}, "Car_Speed_Input_UI")

g.create_ui_element("Input", Vehicle_Tab, {
Name = "Car Max Accel (FE)",
Description = "Modifies your vehicle's max_acc attribute.",
PlaceholderText = "Enter number...",
Callback = function(split)
    local val = tonumber(split)
    if not val then return g.notify("Warning", "Usage: enter a valid number.", 5) end
    local car = get_vehicle()
    local humcar = in_humanoid_vehicle(g.LocalPlayer)
    if humcar then
        set_hum_vehicle_speed(val)
    elseif car and car:GetAttribute("max_acc") then
        car:SetAttribute("max_acc", val)
        g.notify("Success", "Set car max_acc to: " .. val, 5)
    else
        g.notify("Error", "Could not find car or humanoid vehicle.", 10)
    end
end}, "Car_Accel_Input_UI")

g.create_ui_element("Input", Vehicle_Tab, {
Name = "Car Accel 0-60 (FE)",
Description = "Modifies your vehicle's acc_0_60 (take off speed) attribute.",
PlaceholderText = "Enter number...",
Callback = function(split)
    local val = tonumber(split)
    if not val then return g.notify("Warning", "Enter a valid number.", 5) end
    local car = get_vehicle()
    local humcar = in_humanoid_vehicle(g.LocalPlayer)
    if humcar then
        set_hum_vehicle_speed(val)
    elseif car and car:GetAttribute("acc_0_60") then
        car:SetAttribute("acc_0_60", val)
        g.notify("Success", "Set car acc_0_60 to: " .. val, 4)
    else
        g.notify("Error", "Could not find car or humanoid vehicle.", 10)
    end
end}, "Car_Accel_060_Input_UI")

g.create_ui_element("Input", Vehicle_Tab, {
Name = "Car Turn Angle (FE)",
Description = "Modifies your vehicle's turn_angle attribute.",
PlaceholderText = "Enter number...",
Callback = function(split)
    local val = tonumber(split)
    if not val then return g.notify("Warning", "Enter a valid number.", 5) end
    local car = get_vehicle()
    local humcar = in_humanoid_vehicle(g.LocalPlayer)
    if humcar then
        set_hum_vehicle_speed(val)
    elseif car and car:GetAttribute("turn_angle") then
        car:SetAttribute("turn_angle", val)
        g.notify("Success", "Set car turn_angle to: " .. tostring(val), 5)
    else
        g.notify("Error", "Could not find car or humanoid vehicle.", 10)
    end
end}, "Car_Turn_Angle_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Rainbow Car (Friend, FE)",
Description = "Makes a friend's car RGB/Rainbow (must be friends, FE).",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local Player_To_RGB_Car = findplr(split)
    if not Player_To_RGB_Car then return g.notify("Error", "Player does not exist!", 5) end
    if not get_other_vehicle(Player_To_RGB_Car) then return g.notify("Error", "Player does not have a Vehicle spawned!", 5) end
    local checker = check_friend(Player_To_RGB_Car)
    if not checker or checker ~= true then
        return g.notify("Error", "Player is not your friend, add them to use this!", 5)
    end
    if g.FlamesLibrary.is_alive("rainbow_car_" .. Player_To_RGB_Car.Name) then
        return g.notify("Error", "Player already has their car rainbow!", 5)
    end
    local colors = {
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(128, 128, 128),
        Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 165, 0), Color3.fromRGB(139, 69, 19),
        Color3.fromRGB(255, 255, 0), Color3.fromRGB(50, 205, 50),
        Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 155, 172),
        Color3.fromRGB(128, 0, 128),
    }
    local thread_name = "rainbow_car_" .. Player_To_RGB_Car.Name
    g.FlamesLibrary.spawn(thread_name, "spawn", function()
        while g.FlamesLibrary.is_alive(thread_name) do
            fw(0.2)
            local current_plr = g.Players:FindFirstChild(Player_To_RGB_Car.Name)
            if not current_plr then
                g.FlamesLibrary.disconnect(thread_name)
                return g.notify("Error", "Player must have left the game.", 5)
            end
            for _, color in ipairs(colors) do
                if not g.FlamesLibrary.is_alive(thread_name) then break end
                fw(0.2)
                change_vehicle_color(color, get_other_vehicle(current_plr))
            end
        end
    end)
    g.notify("Success", "Rainbow car enabled for: " .. Player_To_RGB_Car.Name, 5)
end}, "Rainbow_Car_Friend_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Stop Rainbow Car (Friend, FE)",
Description = "Disables the RGB for a friend's car (must be friends, FE).",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local Player_To_RGB_Car_Stop = findplr(split)
    if not Player_To_RGB_Car_Stop then return g.notify("Error", "Player does not exist!", 5) end
    if not get_other_vehicle(Player_To_RGB_Car_Stop) then return g.notify("Error", "Player does not have a Vehicle spawned!", 5) end
    local checker = check_friend(Player_To_RGB_Car_Stop) or Player_To_RGB_Car_Stop:IsFriendsWith(g.LocalPlayer.UserId)
    if checker ~= true then return g.notify("Error", "Player is not your friend, add them to use this!", 5) end
    local thread_name = "rainbow_car_" .. Player_To_RGB_Car_Stop.Name
    if not g.FlamesLibrary.is_alive(thread_name) then
        return g.notify("Warning", "This Player does not have Rainbow Vehicle enabled.", 6)
    end
    g.FlamesLibrary.disconnect(thread_name)
    disable_rgb_for(Player_To_RGB_Car_Stop)
    g.notify("Success", "Disabled Rainbow Vehicle for: " .. Player_To_RGB_Car_Stop.Name, 5)
end}, "Stop_Rainbow_Car_Friend_Input_UI")

g.create_ui_element("Button", Houses_Tab, {
Name = "Lock Home (FE)",
Description = "Locks your current Home (FE).",
Callback = function()
    local is_locked = is_home_locked(g.LocalPlayer)
    if is_locked == true then
        return g.notify("Warning", "Your home is already locked.", 5)
    elseif is_locked == false then
        toggle_house_lock(g.LocalPlayer)
        g.notify("Success", "Locked your home.", 5)
    else
        g.notify("Error", "Something unexpected happened while checking if House is locked.", 10)
    end
end}, "Lock_Home_Button_UI")

g.create_ui_element("Button", Houses_Tab, {
Name = "Unlock Home (FE)",
Description = "Unlocks your current Home (FE).",
Callback = function()
    local is_locked = g.is_home_locked(g.LocalPlayer)
    if is_locked == false then
        return g.notify("Warning", "Your home is not locked.", 5)
    elseif is_locked == true then
        g.toggle_house_lock(g.LocalPlayer)
        g.notify("Success", "Unlocked your home.", 5)
    else
        g.notify("Error", "Something unexpected happened while checking if House is locked.", 10)
    end
end}, "Unlock_Home_Button_UI")

g.create_ui_element("Toggle", Houses_Tab, {
Name = "Auto Lock Home (FE)",
Description = "Automatically locks your home when it gets unlocked (FE).",
CurrentValue = getgenv().LockHomeLoop or false,
Callback = function(state)
    g.keep_home_locked(state)
end}, "Auto_Lock_Home_Toggle_UI")

g.create_ui_element("Input", Houses_Tab, {
Name = "Lock Player Home (FE)",
Description = "Locks a friend's house (must be friends, FE).",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local plr_to_lock = findplr(split)
    if not plr_to_lock then return g.notify("Error", "Player not found or does not exist.", 5) end
    if not plr_to_lock:IsFriendsWith(g.LocalPlayer.UserId) then
        return g.notify("Error", "You must be friends with the player to lock their House!", 10)
    end
    local is_locked = is_home_locked(plr_to_lock)
    if is_locked == true then
        return g.notify("Warning", tostring(plr_to_lock) .. "'s home is already locked.", 5)
    elseif is_locked == false then
        toggle_house_lock(plr_to_lock)
        g.notify("Success", "Locked: " .. tostring(plr_to_lock) .. "'s home.", 5)
    else
        g.notify("Error", "Something happened while trying to lock: " .. tostring(plr_to_lock) .. "'s home!", 10)
    end
end}, "Lock_Player_Home_Input_UI")

g.create_ui_element("Input", Houses_Tab, {
Name = "Unlock Player Home (FE)",
Description = "Unlocks a friend's house (must be friends, FE).",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local plr_to_unlock = findplr(split)
    if not plr_to_unlock then return g.notify("Error", "Player not found or does not exist.", 5) end
    if not plr_to_unlock:IsFriendsWith(g.LocalPlayer.UserId) then
        return g.notify("Error", "You must be friends with the player to unlock their House!", 10)
    end
    local is_locked = g.is_home_locked(plr_to_unlock)
    if is_locked == false then
        return g.notify("Warning", tostring(plr_to_unlock) .. "'s home is not locked.", 5)
    elseif is_locked == true then
        toggle_house_lock(plr_to_unlock)
        g.notify("Success", "Unlocked: " .. tostring(plr_to_unlock) .. "'s home.", 5)
    else
        g.notify("Error", "Something happened while trying to unlock: " .. tostring(plr_to_unlock) .. "'s home!", 10)
    end
end}, "Unlock_Player_Home_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Friend Player",
Description = "Sends a friend request to the specified player in this server.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local target_friend_plr = findplr(split)
    if not target_friend_plr then return g.notify("Error", "That player does not exist or has left the game.", 6) end
    g.friend_user_async_function(target_friend_plr)
end}, "Friend_Player_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Unfriend Player",
Description = "Removes a friend request / unfriends the specified player in this server.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local target_unfriend_plr = findplr(split)
    if not target_unfriend_plr then return g.notify("Error", "That player does not exist or has left the game.", 6) end
    g.unfriend_user_async(target_unfriend_plr)
end}, "Unfriend_Player_Input_UI")

if executor_contains("delta") then
    g.create_ui_element("Toggle", Extras_Tab, {
    Name = "Toggle Delta Icon",
    Description = "Hides the Delta executor button icon (if you're using Delta).",
    CurrentValue = getgenv().Is_Deltas_Icon_Currently_Toggled or false,
    Callback = function(state)
        g.toggle_delta_image_button_flames_hub(not state)
    end}, "Hide_Delta_Toggle_UI")
end

g.create_ui_element("Toggle", Phone_Tab, {
Name = "Anti RGB Phone",
Description = "Enables Anti RGB Phone, which hides other RGB Phone Models.",
CurrentValue = getgenv().HidePhoneModels or false,
Callback = function(state)
    if state then
        if g.HidePhoneModels then return g.notify("Warning", "Anti RGB Phone is already enabled.", 5) end
        g.notify("Success", "Enabled Anti RGB Phone.", 5)
        g.TogglePhoneModelHider(true)
    else
        if not g.HidePhoneModels then return g.notify("Warning", "Anti RGB Phone is not enabled.", 5) end
        g.notify("Success", "Disabled Anti RGB Phone.", 5)
        g.TogglePhoneModelHider(false)
    end
end}, "Anti_RGB_Phone_Toggle_UI")

g.create_ui_element("Toggle", Extras_Tab, {
Name = "FPS Boost",
Description = "Lag reducer that boosts your FPS.",
CurrentValue = getgenv().ultimate_lag_reducer or false,
Callback = function(state)
    g.FlamesLagReducerFunc(state)
end}, "FPS_Boost_Toggle_UI")

g.create_ui_element("Toggle", Extras_Tab, {
Name = "Always Show Titles",
Description = "Always shows everyone's titles and bios when they chat.",
CurrentValue = g.always_show_title_above_head or false,
Callback = function(state)
    g.always_show_title_of_player_regardless_of_chats(state)
end}, "Always_Show_Titles_Toggle_UI")

g.create_ui_element("Toggle", Vehicle_Tab, {
Name = "RGB Skin (FE)",
Description = "Enables RGB Skin, making your skintone flash rainbow colors.",
CurrentValue = getgenv().rainbow_skintone_currently_enabled or false,
Callback = function(state)
    rainbow_skin(state)
end}, "RGB_Skin_Toggle_UI")

g.create_ui_element("Toggle", Vehicle_Tab, {
Name = "RGB Tool (FE)",
Description = "Enables RGB Tool, making your currently held tool flash rainbow colors.",
CurrentValue = getgenv().Rainbow_Tools_FE or false,
Callback = function(state)
    if state then
        if g.Rainbow_Tools_FE then return g.notify("Warning", "Rainbow Tool is already enabled.", 5) end
        rainbow_tool(true)
    else
        if not g.Rainbow_Tools_FE then return g.notify("Warning", "Rainbow Tool is not enabled.", 5) end
        rainbow_tool(false)
    end
end}, "RGB_Tool_Toggle_UI")

g.create_ui_element("Toggle", Extras_Tab, {
Name = "Anti Fire",
Description = "Automatically destroys any Fire being spawned into the game.",
CurrentValue = getgenv().firehidden or false,
Callback = function(state)
    if state then
        if g.firehidden then return g.notify("Warning", "Flames Anti-Fire Spammer V3 is already enabled.", 6) end
        if g.spamming_all_that_fire then return g.notify("Warning", "Flames Spammer is enabled, disable it first!", 10) end
        g.notify("Success", "Flames Anti-Fire Spammer V3 is now enabled.", 6)
        g.set_fire_state(true)
    else
        if not g.firehidden then return g.notify("Warning", "Flames Anti-Fire Spammer V3 is not enabled.", 6) end
        g.notify("Success", "Flames Anti-Fire Spammer V3 is now disabled.", 6)
        g.set_fire_state(false)
    end
end}, "Anti_Fire_Toggle_UI")

if priv_server_is_in == true then
    g.create_ui_element("Toggle", PrivServer_Tab, {
    Name = "Stop Time (FE)",
    Description = "Stops the current time (priv server only, FE).",
    CurrentValue = getgenv().is_time_currently_stopped_priv_server or false,
    Callback = function(state)
        stop_time_toggle(state)
    end}, "Stop_Time_Toggle_UI")

    g.create_ui_element("Toggle", PrivServer_Tab, {
    Name = "Flash Time (FE)",
    Description = "Makes the current time flash fast (priv server only, FE).",
    CurrentValue = getgenv().flashing_time_fe_toggle or false,
    Callback = function(state)
    flash_time_toggle(state)
    end}, "Flash_Time_Toggle_UI")

    g.create_ui_element("Toggle", PrivServer_Tab, {
    Name = "Flash Weather (FE)",
    Description = "Makes the current weather flash fast (priv server only, FE).",
    CurrentValue = getgenv().changing_weather_on_repeat or false,
    Callback = function(state)
    g.weather_flasher_loop(state)
    end}, "Flash_Weather_Toggle_UI")

    g.create_ui_element("Toggle", PrivServer_Tab, {
    Name = "Server Lock (FE)",
    Description = "Locks your private server so nobody else can join (priv server only).",
    CurrentValue = getgenv().server_lock_enabled or false,
    Callback = function(state)
        server_lock_toggle(state)
    end}, "Server_Lock_Toggle_UI")

    g.create_ui_element("Button", PrivServer_Tab, {
    Name = "Server Lock Manager",
    Description = "Opens the server lock whitelist GUI (priv server only, FE).",
    Callback = function()
        server_lock_whitelist_gui()
    end}, "Server_Lock_Manager_Button_UI")

    g.create_ui_element("Input", PrivServer_Tab, {
    Name = "Kick Player (FE)",
    Description = "Kicks a player from your private server (FE).",
    PlaceholderText = "Username or displayname...",
    Callback = function(split)
        local target_plr = findplr(split)
        if not target_plr then return g.notify("Error", "That player does not exist or has left.", 5) end
        if not is_localplayer_server_owner() then return g.notify("Error", "You are not the private server owner!", 5) end
        if target_plr.Name == "CIippedByAura" or target_plr.Name == "L0CKED_1N1" then return end
        kick_plr(target_plr)
        g.notify("Success", "Kicked Player: " .. tostring(target_plr), 5)
    end}, "Kick_Player_Input_UI")

    g.create_ui_element("Input", PrivServer_Tab, {
    Name = "Ban Player (FE)",
    Description = "Bans a player from your private server (FE).",
    PlaceholderText = "Username or displayname...",
    Callback = function(split)
        if not is_localplayer_server_owner() then
            local admin_player = get_server_admin_player()
            g.notify("Warning", "Private Server is owned by: " .. tostring(admin_player and admin_player.Name or "Unknown"), 7)
            return g.notify("Error", "Not a Private Server or you don't own it!", 6)
        end
        local target = findplr(split) or split
        local added = addban(target)
        if added then
            g.notify("Success", "Banned player: " .. added, 5)
        else
            g.notify("Error", "Failed to ban target.", 6)
        end
    end}, "Ban_Player_Input_UI")

    g.create_ui_element("Input", PrivServer_Tab, {
    Name = "Unban Player (FE)",
    Description = "Unbans a player from your private server (FE).",
    PlaceholderText = "Username or displayname...",
    Callback = function(split)
        if not is_localplayer_server_owner() then
            local admin_player = get_server_admin_player()
            g.notify("Warning", "Private Server is owned by: " .. tostring(admin_player and admin_player.Name or "Unknown"), 7)
            return g.notify("Error", "Not a Private Server or you don't own it!", 6)
        end
        local target = findplr(split) or split
        local removed = removeban(target)
        if removed then
            g.notify("Success", "Unbanned player: " .. removed, 5)
        else
            g.notify("Error", "Player is not banned.", 6)
        end
    end}, "Unban_Player_Input_UI")
end

g.create_ui_element("Toggle", Extras_Tab, {
Name = "RGB Street Lights",
Description = "Enables RGB StreetLights, flashing rainbow street lights (visual only, not FE).",
CurrentValue = getgenv().RGB_Street_Lights_NightTime_Loop or false,
Callback = function(state)
toggle_rgb_streetlights(state)
end}, "RGB_Street_Lights_Toggle_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Admin Player (FE)",
Description = "Adds a friend to the FE commands whitelist.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local Player = findplr(split)
    if not Player then return g.notify("Error", "Player does not exist!", 5) end
    if not Player:IsFriendsWith(g.LocalPlayer.UserId) then
        return g.notify("Error", "This player isn't friends with you, add them!", 5)
    end
    if g.player_admins[Player.Name] then
        return g.notify("Error", "Player is already an admin!", 5)
    end
    alreadyCheckedUser(Player)
    fw(0.5)
    g.notify("Success", "Added " .. tostring(Player.Name) .. " to the admin's table!", 5)
end}, "Admin_Player_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "UnAdmin Player (FE)",
Description = "Removes a friend's FE command access.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local Player = findplr(split)
    if not Player then return g.notify("Error", "Player does not exist!", 5) end
    if not Player:IsFriendsWith(g.LocalPlayer.UserId) then
        return g.notify("Error", "This player isn't friends with you!", 5)
    end
    local Name = Player.Name
    g.notify("Warning", "Removing admin for: " .. tostring(Name), 5)
    if g.player_admins[Name] then g.player_admins[Name] = nil end
    if g.Rainbow_Vehicles[Name] then g.Rainbow_Vehicles[Name] = false end
    if g.Locked_Vehicles[Name] then g.Locked_Vehicles[Name] = false end
    if g.Unlocked_Vehicles[Name] then g.Unlocked_Vehicles[Name] = false end
    if g.Rainbow_Tasks[Name] then g.Rainbow_Tasks[Name] = nil end
    fw(0.5)
    if not g.player_admins[Name] then
        g.notify("Success", "Player's admin has been removed successfully.", 5)
    else
        g.notify("Error", "Player's admin abilities were not removed.", 5)
    end
end}, "Unadmin_Player_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Blacklist Player (FE)",
Description = "Blacklists your friend from using YOUR admin commands.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local Player = findplr(split)
    if not Player then return end
    local Name = Player.Name
    if Player:IsFriendsWith(g.LocalPlayer.UserId) then
        if not g.Blacklisted_Friends[Name] then
            g.Blacklisted_Friends[Name] = Player
        end
    end
    fw(0.3)
    if g.player_admins[Name] then g.player_admins[Name] = nil end
    if g.Rainbow_Vehicles[Name] then g.Rainbow_Vehicles[Name] = false end
    if g.Locked_Vehicles[Name] then g.Locked_Vehicles[Name] = false end
    if g.Unlocked_Vehicles[Name] then g.Unlocked_Vehicles[Name] = false end
    if g.Rainbow_Tasks[Name] then g.Rainbow_Tasks[Name] = nil end
    g.notify("Success", "Blacklisted: " .. tostring(Name), 5)
end}, "Blacklist_Player_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Unblacklist Player (FE)",
Description = "Removes your friend from your admin blacklist.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local Player = findplr(split)
    if not Player then return end
    local Name = Player.Name
    if Player:IsFriendsWith(g.LocalPlayer.UserId) then
        if g.Blacklisted_Friends[Name] then
            g.Blacklisted_Friends[Name] = nil
            g.notify("Success", "Removed blacklist for: " .. tostring(Name), 5)
        else
            g.notify("Warning", tostring(Name) .. " is not blacklisted.", 5)
        end
    end
end}, "Unblacklist_Player_Input_UI")

g.create_ui_element("Input", Players_Tab, {
Name = "Rainbow Time (Friend, FE)",
Description = "Sets the rainbow delay speed for a whitelisted friend's car.",
PlaceholderText = "Username number (e.g. PlayerName 1)...",
Callback = function(split)
    local parts = split and split:split(" ") or {}
    local Player = findplr(parts[1])
    if not Player then return g.notify("Error", "Player doesn't exist or has left!", 5) end
    if not Player:IsFriendsWith(g.LocalPlayer.UserId) then
        return g.notify("Error", "Player is not friends with you, add them!", 5)
    end
    local new_delay = tonumber(parts[2]) or 1
    g.Rainbow_Delays = g.Rainbow_Delays or {}
    g.Rainbow_Delays[Player.Name] = new_delay
    fw(0.2)
    g.notify("Success", "Set rainbow delay for " .. Player.Name .. " to " .. new_delay, 5)
end}, "Rainbow_Time_Input_UI")

g.create_ui_element("Input", LocalPlayer_Tab, {
Name = "Walk Fling Whitelist",
Description = "Whitelists a player so WalkFling won't fling them.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local plr = findplr(split)
    if typeof(plr) ~= "Instance" or not plr:IsA("Player") then
        return g.notify("Error", "Player not found in game.", 5)
    end
    g.AddToWalkFlingWhitelist(plr)
end}, "Walk_Fling_Whitelist_Input_UI")

g.create_ui_element("Input", LocalPlayer_Tab, {
Name = "Walk Fling Unwhitelist",
Description = "Removes a player from the WalkFling whitelist.",
PlaceholderText = "Username or displayname...",
Callback = function(split)
    local plr = findplr(split)
    if typeof(plr) ~= "Instance" or not plr:IsA("Player") then
        return g.notify("Error", "Player not found in game.", 5)
    end
    g.RemoveFromWalkFlingWhitelist(plr)
end}, "Walk_Fling_Unwhitelist_Input_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Get Priv Server Owner",
Description = "Tells you who owns the current private server.",
Callback = function()
    notify_priv_server_owner()
end}, "Priv_Server_Owner_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Config Manager",
Description = "Opens the Configuration Manager GUI.",
Callback = function()
    toggle_config_manager(true)
end}, "Config_Manager_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Streamer Mode",
Description = "Gives you a GUI to hide your profile.",
Callback = function()
    streamer_mode_script()
end}, "Streamer_Mode_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Annoyer GUI",
Description = "Opens the GUI that lets you pick and toggle annoying players (FE).",
Callback = function()
    annoyance_GUI()
end}, "Annoy_GUI_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Car Stats GUI",
Description = "Shows vehicles you can spawn with preset settings.",
Callback = function()
    vehicle_stats_viewer_GUI()
end}, "Car_Stats_GUI_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "All Cars GUI",
Description = "Opens the GUI list showing all available car names.",
Callback = function()
    car_listing_gui()
end}, "All_Cars_GUI_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Free Emotes GUI",
Description = "Opens the Free Emotes GUI.",
Callback = function()
    if g.FreeEmotes_Enabled then
        return g.notify("Warning", "You already have Flames Emoting GUI loaded!", 6)
    end
    if CoreGui:FindFirstChild("FlamesEmoteGUI") then
        return g.notify("Warning", "You already have Flames Emoting GUI loaded!", 6)
    end
    g.FreeEmotes_Enabled = true
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Emotes_Backup.lua"))()
end}, "Free_Emotes_GUI_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Message GUI",
Description = "Let's you send messages with the in-game Phone easily.",
Callback = function()
    send_msg_menu()
end}, "Message_GUI_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Workspace Editor",
Description = "Let's you edit parts & models in the workspace.",
Callback = function()
    g.workspace_editor_script_GUI()
end}, "Workspace_Editor_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Debugger",
Description = "Let's you test if functions are working correctly in Flames Hub.",
Callback = function()
    if g.Flames_Debugger_Function_Tester_GUI then
        pcall(function() g.Flames_Debugger_Function_Tester_GUI() end)
    else
        g.notify("Error", "Flames Debugger function not found or was not created at runtime.", 10)
    end
end}, "Debugger_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Outfits Manager (Save outfits GUI)",
Description = "Opens the Outfits GUI, letting you save as many outfits as you want.",
Callback = function()
    save_outfits_GUI()
end}, "Outfits_Manager_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Chat Bypass",
Description = "Executes a chat script, so you can type freely to other users (FE).",
Callback = function()
    g.load_workaround_script()
end}, "Chat_Bypass_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Save Emote",
Description = "Saves your currently playing animation to the Flames Emotes GUI.",
Callback = function()
    g.save_copied_plrs_emote()
end}, "Save_Emote_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Infinite Yield",
Description = "Executes regular Infinite Yield.",
Callback = function()
    infinite_yield()
end}, "Infinite_Yield_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Infinite Premium",
Description = "Executes Infinite Premium.",
Callback = function()
    infinite_premium()
end}, "Infinite_Premium_Button_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Nameless Admin",
Description = "Executes Nameless Admin (FE Admin).",
Callback = function()
    flames_nameless_admin_ver()
end}, "Nameless_Admin_Button_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Flames (FE)",
Description = "Spams Fire all around you on loop.",
CurrentValue = getgenv().spamming_all_that_fire or false,
Callback = function(state)
    if state then
        if g.spamming_all_that_fire then return g.notify("Warning", "You're already spamming Fire!", 5) end
        if g.LocalPlayer:GetAttribute("is_verified") == false then
            return g.notify("Error", "You need actual LifePay premium to run this!", 6)
        end
        g.spamming_flames(true)
    else
        if not g.spamming_all_that_fire then return g.notify("Warning", "You're not spamming Fire!", 5) end
        g.spamming_flames(false)
    end
end}, "Flames_Toggle_UI")

g.create_ui_element("Input", LocalPlayer_Tab, {
Name = "Spawn Fire (FE)",
Description = "Spawns Fire with custom amount (requires premium).",
PlaceholderText = "Enter amount...",
Callback = function(split)
    local amount = tonumber(split) or 5
    local is_verified = g.LocalPlayer:GetAttribute("is_verified")
    if not is_verified then
        return g.notify("Error", "You do not have premium, you cannot run this!", 8)
    end
    g.HasSeen_Fire_AlertFlamesHub = g.HasSeen_Fire_AlertFlamesHub or false
    set_fire_amount_FE(amount)
    g.HasSeen_Fire_AlertFlamesHub = true
    fw(0.2)
    for i = 1, amount do
        g.Send("request_fire")
    end
end}, "Spawn_Fire_Input_UI")

g.create_ui_element("Toggle", Extras_Tab, {
Name = "Sign Spam (FE)",
Description = "Spams the text on your Tool Sign (FE).",
CurrentValue = getgenv().ToolChanger_FE or false,
Callback = function(state)
    if state then
        if g.ToolChanger_FE then return g.notify("Warning", "Sign spammer is already enabled!", 5) end
        spam_sign_text(true)
    else
        if not g.ToolChanger_FE then return g.notify("Warning", "Sign spammer is not enabled!", 5) end
        spam_sign_text(false)
    end
end}, "Sign_Spam_Toggle_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Collect All NBA Props (FE)",
Description = "Collects all NBA event items so you can get the badge instantly (FE).",
Callback = function()
    local attr = g.LocalPlayer:GetAttribute("NBA_HUNT_PROGRESS")
    if not attr then return end
    if attr ~= "PLAYING" then
        return g.notify("Warning", "Talk to the NPC first and enter before trying this!", 10)
    end
    g.collect_all_nba_props()
end}, "Collect_All_NBA_Button_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Anti Outfit Copier (FE)",
Description = "Prevents others from copying your outfit (FE).",
CurrentValue = getgenv().anti_outfit_stealer or false,
Callback = function(state)
    anti_outfit_copier(state)
end}, "Anti_Outfit_Copier_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Mute Tools",
Description = "Mutes all Boomboxes, Speakers and other tools in the game that play music.",
CurrentValue = getgenv().autosilence or false,
Callback = function(state)
    mute_all_tools(state)
end}, "Mute_Tools_Toggle_UI")

g.create_ui_element("Dropdown", Home_Tab, {
Name = "Emotes",
Description = "Play any emote on your character (FE).",
Options = {
    "Needy",
    "Griddy",
    "Jiggy",
    "Scenario",
    "Superman",
    "Zen",
    "Orange Justice",
    "Aura Farm",
    "Worm",
    "Jabba",
    "Popular",
    "Default Dance",
    "Koto Nai",
    "Glitching",
    "Billy Jean",
    "Billy Bounce",
    "Michael Myers",
    "Sturdy",
    "Electro Shuffle",
    "Take The L",
    "Laugh It Up",
    "Reanimated",
    "Motion",
    "Tuff",
},
CurrentOption = {},
MultipleOptions = false,
Callback = function(selected)
    local emote_map = {
        ["Needy"]           = "needy_twerk",
        ["Griddy"]          = "griddy",
        ["Jiggy"]           = "jiggy",
        ["Scenario"]        = "scenario",
        ["Superman"]        = "superman",
        ["Zen"]             = "zen",
        ["Orange Justice"]  = "orangej",
        ["Aura Farm"]       = "aura",
        ["Worm"]            = "worm",
        ["Jabba"]           = "jabba",
        ["Popular"]         = "popular",
        ["Default Dance"]   = "defaultdance",
        ["Koto Nai"]        = "kotonai",
        ["Glitching"]       = "glitch",
        ["Billy Jean"]      = "billyjean",
        ["Billy Bounce"]    = "billybounce",
        ["Michael Myers"]   = "michaelmyers",
        ["Sturdy"]          = "sturdy",
        ["Electro Shuffle"] = "electroshuffle",
        ["Take The L"]      = "takethel",
        ["Laugh It Up"]     = "laughitup",
        ["Reanimated"]      = "reanimated",
        ["Motion"]          = "motion",
        ["Tuff"]            = "tuff",
    }
    local emote = emote_map[selected]
    if not emote then return g.notify("Error", "Unknown emote selected.", 2.5) end
    do_emote(emote)
end}, "Emotes_Dropdown_UI")

g.create_ui_element("Button", Home_Tab, {
Name = "Stop Emoting",
Description = "Disables any emote you are currently doing.",
Callback = function()
    g.disable_emoting_script()
end}, "No_Emote_Button_UI")

g.create_ui_element("Input", LocalPlayer_Tab, {
Name = "RP Name (FE)",
Description = "Changes your roleplay name.",
PlaceholderText = "Enter new RP name...",
Callback = function(text)
    local max_len = 19
    if #text > max_len and writefile then
        g.notify("Info", "Your roleplay Name exceeds 19 characters, we're saving it for you, it'll be automatically set back once you reload the script.", 15)
        writefile("LifeTogether_RP_Admin_Custom_Name.txt", text)
    end
    change_RP_Name(text)
end}, "RP_Name_Input_UI")

g.create_ui_element("Input", LocalPlayer_Tab, {
Name = "RP Bio (FE)",
Description = "Changes your roleplay bio.",
PlaceholderText = "Enter new RP bio...",
Callback = function(text)
    local max_len = 49
    if #text > max_len and writefile then
        g.notify("Info", "Your roleplay Bio exceeds 49 characters, we're saving it for you, it'll be automatically set back once you reload the script.", 15)
        writefile("LifeTogether_RP_Admin_Custom_Bio.txt", text)
    end
    change_bio(text)
end}, "RP_Bio_Input_UI")

g.create_ui_element("Button", Extras_Tab, {
Name = "Performance GUI",
Description = "Gives you the menu showing your FPS, ping, etc.",
Callback = function()
    LoadPerformanceStatsGUI()
end}, "Stats_GUI_Button_UI")

g.create_ui_element("Toggle", LocalPlayer_Tab, {
Name = "Two Tone Skin (FE)",
Description = "Makes your skintone swap between two colors on a loop (FE).",
CurrentValue = getgenv().Two_Tone_Skin_Tone_Loop_Toggled or false,
Callback = function(state)
    g.two_tone_skin(state)
end}, "Two_Tone_Skin_Toggle_UI")

g.create_ui_element("ColorPicker", Vehicle_Tab, {
Name = "Car Color (FE)",
Color = Color3.fromRGB(255, 0, 0),
Flag = "Car_Color_Picker_UI",
Callback = function(color)
    local vehicle = get_vehicle()
    if not vehicle then return g.notify("Error", "You do not have a vehicle spawned!", 0.75) end
    change_vehicle_color(color, vehicle)
end}, "Car_Color_Picker_UI")

g.create_ui_element("Toggle", Players_Tab, {
Name = "Player ESP",
Description = "Enables Player ESP, allowing you to see any player through walls.",
CurrentValue = getgenv().Flames_Hub_Player_ESP_Core_Has_Been_Enabled or false,
Callback = function(state)
    if state then
        g.enable_player_esp()
    else
        g.disable_player_esp()
    end
end}, "Player_ESP_Toggle_UI")

g.create_ui_element("Toggle", Players_Tab, {
Name = "Tracer ESP",
Description = "Enables Tracer ESP, putting a line on every player anywhere.",
CurrentValue = getgenv().tracer_esp_currently_running_flag_Flames_Hub or false,
Callback = function(state)
    if state then
        g.enable_tracers()
    else
        g.disable_tracers()
    end
end}, "Tracer_ESP_Toggle_UI")

g.notify("Success", "Welcome back, "..tostring(g.LocalPlayer.DisplayName)..".", 10)
local function print_bytes(label, s)
    local bytes = {}
    for i = 1, #s do
        table.insert(bytes, string.byte(s, i))
    end
    print(label .. ": " .. table.concat(bytes, ","))
end
local function clean(s) return s:gsub("[%c%z%s]", ""):gsub("[^\32-\126]", "") end
local script_url = "https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Life_Together_Hub.lua"
local version_url = "https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Script_Versions_JSON.json"
local function ws_get_version()
    local http_req = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
    if not http_req then return nil end
    local ok, result = pcall(function()
        return http_req({
            Url = version_url .. "?cache=" .. tostring(os.clock()),
            Method = "GET",
            Headers = { ["Content-Type"] = "application/json" }
        })
    end)

    if not ok or not result or result.StatusCode ~= 200 then return nil end
    local ok2, data = pcall(function() return g.HttpService:JSONDecode(result.Body) end)
    if not ok2 or type(data) ~= "table" then return nil end
    local version = data.LifeTogether_Hub_Version
    if not version then return nil end
    return tostring(version):gsub("%s+", "")
end

local function Notify(msg, dur)
    dur = dur or 5
    local gui = Instance.new("ScreenGui")
    gui.Name = "CustomNotifyGui"
    gui.ResetOnSpawn = false
    gui.Parent = g.CoreGui

    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, 500, 0, 120)
    frame.Position = UDim2.new(0, 20, 0, 100)
    frame.Parent = gui

    local icon = Instance.new("ImageLabel")
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 15, 0.5, -25)
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Image = "rbxasset://textures/ui/Emotes/ErrorIcon.png"
    icon.ImageTransparency = 1
    icon.Parent = frame

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 80, 0, 10)
    label.Size = UDim2.new(1, -90, 1, -20)
    label.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json")
    label.Text = msg
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 20
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextTransparency = 1
    label.Parent = frame

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    g.TweenService:Create(frame, TweenInfo.new(0.3), { BackgroundTransparency = 0.3 }):Play()
    g.TweenService:Create(icon, TweenInfo.new(0.3), { ImageTransparency = 0 }):Play()
    g.TweenService:Create(label, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()

    task.delay(dur, function()
        if not frame.Parent then return end
        g.TweenService:Create(frame, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
        g.TweenService:Create(icon, TweenInfo.new(0.3), { ImageTransparency = 1 }):Play()
        g.TweenService:Create(label, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
        task.wait(0.35)
        gui:Destroy()
    end)
end

g.lta_updater_running = g.lta_updater_running or false
g.lta_updater_thread_id = (g.lta_updater_thread_id or 0) + 1
local thread_id = g.lta_updater_thread_id
if not g.lta_updater_running then
    g.lta_updater_running = true
    task.spawn(function()
        while g.lta_updater_running and thread_id == g.lta_updater_thread_id do
            task.wait(20)
            local local_version = tostring(g.Script_Version or ""):gsub("%s+", "")
            if local_version == "" then
                continue
            end

            local remote_version = ws_get_version()
            if not remote_version or remote_version == "" then
                continue
            end

            -- [[ for debugging. ]] --
            --print_bytes("local_version", local_version)
            --print_bytes("remote_version", remote_version)

            if remote_version ~= local_version then
                g.lta_updater_running = false
                Notify("[UPDATE DETECTED]:\nLocal: " .. local_version .. "\nServer: " .. remote_version .. "\nReloading...", 6)
                task.wait(0.6)
                g.LifeTogether_Actual_Flames_Hub_Running_Functioning_Currently_On_Client = false
                getgenv().Script_Version = nil
                g.LifeTogetherRP_Admin = false
                pcall(function()
                    loadstring(game:HttpGet(script_url .. "?cache=" .. tostring(os.clock())))()
                end)
                break
            end
        end
    end)
end
