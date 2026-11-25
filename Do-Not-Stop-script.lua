-- key: no keyless script found for this game
--[[
    Do Not Stop Script  -  DarkSpawnerScript.com x DeltaScript.dev
    Key system: press Get Key, finish the short LootLabs link, paste your key.
    One key works for 24 hours on one device. The hub loads after the key is checked.
]]

local GAME_ID   = "dns"
local GAME_NAME = "Do Not Stop"
local KEY_FILE  = "DarkSpawner_DoNotStop_key.txt"
local SERVER    = "https://darkspawnerscript.com/k/"
local DISCORD   = "https://discord.com/invite/uGXZDvg4gR"

local Players     = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LP          = Players.LocalPlayer

local function copy(text)
    local f = setclipboard or toclipboard or (syn and syn.write_clipboard)
    if f then pcall(f, text) return true end
    return false
end

local function deviceId()
    local id
    if gethwid then pcall(function() id = gethwid() end) end
    if not id or id == "" then
        pcall(function() id = game:GetService("RbxAnalyticsService"):GetClientId() end)
    end
    return tostring(id or "")
end

local function enc(s) return HttpService:UrlEncode(s) end

-- asks the server; returns the hub code, or nil + reason
local function fetchHub(key)
    key = string.upper((tostring(key or ""):gsub("%s+", "")))
    if key == "" then return nil, "Paste your key first." end
    local url = SERVER .. "load.php?g=" .. GAME_ID .. "&k=" .. enc(key) .. "&h=" .. enc(deviceId()) .. "&n=" .. tostring(os.time())
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if not ok or type(res) ~= "string" then return nil, "Could not reach the key server. Try again." end
    if res:sub(1, 3) == "NO|" then return nil, res:sub(4) end
    if res:sub(1, 7) ~= "--DSOK|" then return nil, "Key server sent a bad reply. Try again." end
    return res, key
end

local function readSaved()
    if not (isfile and readfile) then return nil end
    local ok, v = pcall(function() return isfile(KEY_FILE) and readfile(KEY_FILE) or nil end)
    return ok and v or nil
end

local function saveKey(k)
    if writefile then pcall(writefile, KEY_FILE, k) end
end

local function runHub(code)
    local fn, err = loadstring(code)
    if not fn then warn("[DarkSpawner] hub failed to compile: " .. tostring(err)) return end
    task.spawn(fn)
end

-- saved key still good? load straight away
do
    local saved = readSaved()
    if saved and saved ~= "" then
        local code = fetchHub(saved)
        if code then runHub(code) return end
    end
end

---------------------------------------------------------------- key window
local gui = Instance.new("ScreenGui")
gui.Name = "DS_KeyGate"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
if not pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) or not gui.Parent then
    gui.Parent = LP:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 230)
frame.Position = UDim2.new(0.5, -170, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(23, 19, 31)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(155, 77, 255)
stroke.Thickness = 2

local function label(text, y, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(1, -30, 0, size + 6)
    l.Position = UDim2.new(0, 15, 0, y)
    l.Font = font or Enum.Font.Gotham
    l.TextSize = size
    l.TextColor3 = color
    l.TextWrapped = true
    l.Text = text
    l.Parent = frame
    return l
end
label("DarkSpawnerScript.com", 12, 16, Color3.fromRGB(201, 166, 255), Enum.Font.GothamBold)
label(GAME_NAME .. " | DeltaScript.dev - Key System", 34, 13, Color3.fromRGB(236, 230, 247))
local status = label("Press Get Key, finish the LootLabs link, paste your key.", 58, 12, Color3.fromRGB(154, 144, 173))

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -30, 0, 36)
box.Position = UDim2.new(0, 15, 0, 92)
box.BackgroundColor3 = Color3.fromRGB(15, 12, 23)
box.TextColor3 = Color3.new(1, 1, 1)
box.PlaceholderText = "Paste key here (DS-...)"
box.PlaceholderColor3 = Color3.fromRGB(120, 110, 140)
box.Font = Enum.Font.Code
box.TextSize = 14
box.ClearTextOnFocus = false
box.Text = ""
box.Parent = frame
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

local function btn(text, pos, size, color)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Text = text
    b.AutoButtonColor = true
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end
local getBtn     = btn("Get Key", UDim2.new(0, 15, 0, 140), UDim2.new(0.5, -20, 0, 34), Color3.fromRGB(155, 77, 255))
local checkBtn   = btn("Check Key", UDim2.new(0.5, 5, 0, 140), UDim2.new(0.5, -20, 0, 34), Color3.fromRGB(40, 150, 80))
local discordBtn = btn("Copy Discord invite", UDim2.new(0, 15, 0, 184), UDim2.new(1, -30, 0, 26), Color3.fromRGB(44, 35, 64))
discordBtn.Font = Enum.Font.Gotham
discordBtn.TextSize = 12
discordBtn.TextColor3 = Color3.fromRGB(201, 166, 255)

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -30, 0, 8)
close.BackgroundTransparency = 1
close.TextColor3 = Color3.fromRGB(200, 120, 120)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.Text = "X"
close.Parent = frame

local busy = false
getBtn.MouseButton1Click:Connect(function()
    local link = SERVER .. "go.php?g=" .. GAME_ID
    status.TextColor3 = Color3.fromRGB(154, 144, 173)
    status.Text = copy(link) and "Link copied! Open it in your browser." or ("Open: " .. link)
end)
checkBtn.MouseButton1Click:Connect(function()
    if busy then return end
    busy = true
    status.TextColor3 = Color3.fromRGB(154, 144, 173)
    status.Text = "Checking key..."
    local code, keyOrWhy = fetchHub(box.Text)
    busy = false
    if code then
        saveKey(keyOrWhy)
        status.TextColor3 = Color3.fromRGB(110, 230, 140)
        status.Text = "Key accepted! Loading..."
        task.wait(0.5)
        gui:Destroy()
        runHub(code)
    else
        status.TextColor3 = Color3.fromRGB(255, 120, 120)
        status.Text = keyOrWhy
    end
end)
discordBtn.MouseButton1Click:Connect(function()
    discordBtn.Text = copy(DISCORD) and "Discord invite copied!" or DISCORD
end)
close.MouseButton1Click:Connect(function() gui:Destroy() end)