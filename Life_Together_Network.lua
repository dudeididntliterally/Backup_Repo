if not game:IsLoaded() then game.Loaded:Wait() end
-- [[ Better Network system, it'll grab ALL the ModuleScripts. ]] --
local g = getgenv()
local excluded = { Lighting = true }
g.Game = cloneref and cloneref(game) or game
g.service_cache = g.service_cache or {}
g.Chat_UI_Table_Stuff = { ["Owner_Chat_Tag"] = "😉🤫😈 | OWNER | ⚔️👑⭐", ["Staff_Chat_Tag"] = "⚔️ | STAFF | ⚔️", ["Wife_Chat_Tag"] = "💘 | WIFEY | 💘", }
g.safewrap = function(name)
    local cache = g.service_cache
    if cache[name] then return cache[name] end
    local ok, svc = pcall(function()
        local s = game:GetService(name)
        return cloneref and cloneref(s) or s
    end)
    if not ok or not svc then return nil end
    if rawset then rawset(cache, name, svc) else cache[name] = svc end
    return svc
end

local function getorset(global, value)
    local v = rawget(g, global)
    if v == nil then
        g[global] = value
        return value
    end
    return v
end

network = nil

local function retrieveexecutor()
    local name
    if identifyexecutor then name = identifyexecutor() end
    return { Name = name or "Unknown Executor" }
end

local function identifyexecutorname()
    return tostring(retrieveexecutor().Name)
end

local executorstring = identifyexecutorname()
local function executorcontains(substr)
    if type(executorstring) ~= "string" then return false end
    return string.find(string.lower(executorstring), string.lower(substr), 1, true) ~= nil
end

if executorcontains("LX63") then
    local Net
    for _, obj in pairs(getgc(true)) do
        if typeof(obj) == "table" then
            if typeof(rawget(obj, "send")) == "function" and typeof(rawget(obj, "get")) == "function" then
                local info = debug.getinfo(obj.get)
                if info and info.source and info.source:find("Net") then
                    Net = obj
                    break
                end
            end
        end
    end
    if Net then network = Net end
end

HttpService    = getorset("HttpService",    safewrap("HttpService"))
Players        = getorset("Players",        safewrap("Players"))
RunService     = getorset("RunService",     safewrap("RunService"))
LocalPlayer    = getorset("LocalPlayer",    Players.LocalPlayer)
ReplicatedStorage = getorset("ReplicatedStorage", safewrap("ReplicatedStorage"))
Workspace      = getorset("Workspace",      safewrap("Workspace"))
Modules        = getorset("Modules",        ReplicatedStorage:FindFirstChild("Modules", true))
Core           = getorset("Core", ReplicatedStorage:FindFirstChild("Core", true) or Modules:FindFirstChild("Core", true))
Game_Folder    = getorset("Game_Folder", ReplicatedStorage:FindFirstChild("Game", true) or Modules:FindFirstChild("Game", true))

if not g.LifeTogether_Network_Modules_Already_Loaded_Initialized then
    g.LifeTogether_Network_Modules_Already_Loaded_Initialized = true

    local function load_modules(folder)
        for _, child in ipairs(folder:GetChildren()) do
            if excluded[child.Name] then
                for _, module in ipairs(child:GetChildren()) do
                    if module:IsA("ModuleScript") then
                        local ok, result = pcall(require, module)
                        if ok then getorset(module.Name, result) end
                    end
                end
            elseif child:IsA("ModuleScript") then
                local ok, result = pcall(require, child)
                if ok then getorset(child.Name, result) end
            else
                for _, module in ipairs(child:GetDescendants()) do
                    if module:IsA("ModuleScript") then
                        local ok, result = pcall(require, module)
                        if ok then getorset(module.Name, result) end
                    end
                end
            end
        end
    end

    if executorcontains("LX63") then
        local targets = {}
        for _, obj in ipairs(Core:GetChildren()) do
            if obj:IsA("ModuleScript") and not excluded[obj.Name] then
                table.insert(targets, obj.Name)
            end
        end
        for _, obj in ipairs(Game_Folder:GetChildren()) do
            if obj:IsA("ModuleScript") and not excluded[obj.Name] then
                table.insert(targets, obj.Name)
            end
        end
        for _, target in ipairs(targets) do
            for _, obj in pairs(getgc(true)) do
                if typeof(obj) == "table" then
                    local info
                    for _, v in pairs(obj) do
                        if typeof(v) == "function" then
                            info = debug.getinfo(v)
                            break
                        end
                    end
                    if info and info.source and info.source:find(target) then
                        getorset(target, obj)
                        break
                    end
                end
            end
        end
    else
        load_modules(Core)
        load_modules(Game_Folder)
    end

    Network  = getorset("Network", g.Net)
    Char     = getorset("Char",    g.Char)
    UI       = getorset("UI",      g.UI)
    Phone    = getorset("Phone",   g.Phone)
    Messages = getorset("Messages", g.Messages)
end
wait(0.4)
local function shownotification(title, text, method, image)
    if method == "Normal" and not image then
        Phone.show_notification(tostring(title), tostring(text))
    elseif method == "Warning" then
        Phone.show_notification(tostring(title), tostring(text), nil, "rbxassetid://13828984843")
    elseif method == "Error" then
        Phone.show_notification(tostring(title), tostring(text), nil, "rbxassetid://14930908086")
    end
end

getorset("show_notification", shownotification)
getorset("Modules",   Modules)
getorset("Core",      Core)
getorset("Game_Folder", Game_Folder)
getorset("Net",       network)

local function sendfunction(...) Network.get(...) end
local function sendremote(...) Network.send(...) end

getorset("send_remote", sendremote)
getorset("send_function", sendfunction)
getorset("Get", sendfunction)
getorset("Send", sendremote)
