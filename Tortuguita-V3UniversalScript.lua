local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TortuguitaHub V3",
   Icon = 6023426912, -- Exemplo ícone Roblox (coloque o seu ID aqui)
   LoadingTitle = "TortuguitaHub V3 Loading",
   LoadingSubtitle = "by TortuguitaXP",
   ShowText = "TortuguitaHub",
   Theme = "Dark",
   ToggleUIKeybind = "K",
   ConfigurationSaving = { Enabled = true, FolderName = "TortuguitaHub", FileName = "Config" },
   Discord = { Enabled = false },
   KeySystem = false,
})

-- Serviços e variáveis globais
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

-- ========== ESP ==========
local ESPEnabled = false
local ESPBoxes = {}
local ESPNames = {}
local ESPHealthBars = {}
local ESPHighlights = {}

local function createDrawing(type_)
    local d = Drawing.new(type_)
    d.Visible = false
    return d
end

local function updateESP()
    if not ESPEnabled then
        for _, v in pairs(ESPBoxes) do v.Visible = false end
        for _, v in pairs(ESPNames) do v.Visible = false end
        for _, v in pairs(ESPHealthBars) do v.Visible = false end
        for _, v in pairs(ESPHighlights) do
            if v.Adornee then v.Adornee = nil end
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local hrp = player.Character.HumanoidRootPart
            local humanoid = player.Character.Humanoid
            local screenPos, onScreen = Cam:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local box = ESPBoxes[player] or createDrawing("Square")
                ESPBoxes[player] = box
                box.Color = Color3.new(0, 1, 0)
                box.Thickness = 1.5
                box.Transparency = 1
                box.Filled = false

                local nameText = ESPNames[player] or createDrawing("Text")
                ESPNames[player] = nameText
                nameText.Text = player.Name
                nameText.Size = 14
                nameText.Color = Color3.new(1,1,1)
                nameText.Center = true
                nameText.Outline = true
                nameText.OutlineColor = Color3.new(0,0,0)

                local healthBar = ESPHealthBars[player] or createDrawing("Square")
                ESPHealthBars[player] = healthBar
                healthBar.Filled = true
                healthBar.Transparency = 1

                -- Box size (simples)
                local sizeX, sizeY = 100, 140
                box.Size = Vector2.new(sizeX, sizeY)
                box.Position = Vector2.new(screenPos.X - sizeX/2, screenPos.Y - sizeY/2)

                nameText.Position = Vector2.new(screenPos.X, screenPos.Y - sizeY/2 - 16)

                -- Health bar vertical ao lado da box
                local hpPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                healthBar.Color = Color3.fromHSV(hpPercent * 0.33, 1, 1) -- Verde para vermelho
                healthBar.Size = Vector2.new(6, sizeY * hpPercent)
                healthBar.Position = Vector2.new(box.Position.X - 8, box.Position.Y + (sizeY - sizeY * hpPercent))

                box.Visible = true
                nameText.Visible = true
                healthBar.Visible = true

                -- Highlight (Roblox highlight)
                if not ESPHighlights[player] then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = player.Character
                    hl.FillColor = Color3.fromRGB(0, 255, 0)
                    hl.OutlineColor = Color3.fromRGB(0, 255, 0)
                    hl.Parent = workspace
                    ESPHighlights[player] = hl
                end

            else
                if ESPBoxes[player] then ESPBoxes[player].Visible = false end
                if ESPNames[player] then ESPNames[player].Visible = false end
                if ESPHealthBars[player] then ESPHealthBars[player].Visible = false end
                if ESPHighlights[player] then ESPHighlights[player].Adornee = nil end
            end
        else
            if ESPBoxes[player] then ESPBoxes[player].Visible = false end
            if ESPNames[player] then ESPNames[player].Visible = false end
            if ESPHealthBars[player] then ESPHealthBars[player].Visible = false end
            if ESPHighlights[player] then ESPHighlights[player].Adornee = nil end
        end
    end
end

local ESPTab = Window:CreateTab("ESP", 6023426912)

ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPEnable",
    Callback = function(value)
        ESPEnabled = value
        if not value then
            for _, v in pairs(ESPBoxes) do v.Visible = false end
            for _, v in pairs(ESPNames) do v.Visible = false end
            for _, v in pairs(ESPHealthBars) do v.Visible = false end
            for _, v in pairs(ESPHighlights) do
                if v.Adornee then v.Adornee = nil end
            end
        end
    end,
})

RunService.RenderStepped:Connect(function()
    if ESPEnabled then updateESP() end
end)

-- ========== INVENTORY ==========
local InventoryEnabled = false
local InventoryTexts = {}

local function createInventoryText(player)
    local text = Drawing.new("Text")
    text.Text = ""
    text.Size = 14
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Center = true
    text.Outline = true
    text.OutlineColor = Color3.new(0,0,0)
    text.Visible = false
    return text
end

local function updateInventory()
    if not InventoryEnabled then
        for _, txt in pairs(InventoryTexts) do
            txt:Remove()
        end
        InventoryTexts = {}
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local screenPos, onScreen = Cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local invText = InventoryTexts[player] or createInventoryText(player)
                InventoryTexts[player] = invText

                -- Aqui você deve adaptar para pegar inventário real do jogo
                local inventoryItems = {
                    {Name = "Pistol", Amount = 1},
                    {Name = "Health Potion", Amount = 3},
                }

                local invStr = "Inventory:\n"
                for _, item in pairs(inventoryItems) do
                    invStr = invStr .. item.Name .. " x" .. item.Amount .. "\n"
                end

                local dist = (LP.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                invText.Text = string.format("%sDist: %.1f", invStr, dist)
                invText.Position = Vector2.new(screenPos.X, screenPos.Y + 30)
                invText.Visible = true
            else
                if InventoryTexts[player] then InventoryTexts[player].Visible = false end
            end
        else
            if InventoryTexts[player] then
                InventoryTexts[player]:Remove()
                InventoryTexts[player] = nil
            end
        end
    end
end

local InvToggle = ESPTab:CreateToggle({
    Name = "Inventory ESP",
    CurrentValue = false,
    Flag = "InventoryESP",
    Callback = function(value)
        InventoryEnabled = value
        if not value then
            for _, txt in pairs(InventoryTexts) do
                txt:Remove()
            end
            InventoryTexts = {}
        end
    end,
})

RunService.RenderStepped:Connect(function()
    if InventoryEnabled then
        updateInventory()
    end
end)

--[[
Aqui termina a parte da ESP + Inventory com toggle.
A próxima parte será o Aimbot (normal + silent), depois Movimento, Utilitários, Themes...
]]
