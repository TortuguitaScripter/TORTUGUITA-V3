-- Parte 1: Inicialização e Janela Principal

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TortuguitaHub V3",
   Icon = 0,
   LoadingTitle = "TortuguitaHub Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "TortuguitaHub",
   Theme = "Default",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "TortuguitaHubConfig"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "TortuguitaHub Key",
      Subtitle = "Key System",
      Note = "No key provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Atualizar humanoide quando trocar de personagem
local Humanoid
local function UpdateHumanoid()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = char:WaitForChild("Humanoid")
end
UpdateHumanoid()
LocalPlayer.CharacterAdded:Connect(UpdateHumanoid)

-- Parte 2: ESP

local ESPTab = Window:CreateTab("👁️ ESP", 4483362458)

local ESPSettings = {
    Enabled = false,
    Boxes = true,
    HealthBarVertical = true,
    Distance = true,
    Inventory = true,
    Highlights = true,
    MobileMode = false,
    HealthBarColors = {
        Green = Color3.fromRGB(0, 255, 0),
        Yellow = Color3.fromRGB(255, 255, 0),
        Red = Color3.fromRGB(255, 0, 0)
    },
}

ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "esp_toggle",
    Callback = function(value)
        ESPSettings.Enabled = value
        if value then UpdateAllESP() else ClearAllESP() end
    end
})

ESPTab:CreateToggle({
    Name = "Boxes",
    CurrentValue = true,
    Flag = "boxes_toggle",
    Callback = function(value)
        ESPSettings.Boxes = value
    end
})

ESPTab:CreateToggle({
    Name = "Health Bar (Vertical)",
    CurrentValue = true,
    Flag = "healthbar_toggle",
    Callback = function(value)
        ESPSettings.HealthBarVertical = value
    end
})

ESPTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = true,
    Flag = "distance_toggle",
    Callback = function(value)
        ESPSettings.Distance = value
    end
})

ESPTab:CreateToggle({
    Name = "Inventory ESP",
    CurrentValue = true,
    Flag = "inventory_toggle",
    Callback = function(value)
        ESPSettings.Inventory = value
    end
})

ESPTab:CreateToggle({
    Name = "Highlights",
    CurrentValue = true,
    Flag = "highlights_toggle",
    Callback = function(value)
        ESPSettings.Highlights = value
    end
})

ESPTab:CreateToggle({
    Name = "Mobile Mode (Simple ESP)",
    CurrentValue = false,
    Flag = "mobilemode_toggle",
    Callback = function(value)
        ESPSettings.MobileMode = value
    end
})

local ESPObjects = {}

local function ClearESPForPlayer(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        ESPObjects[player] = nil
    end
end

local function CreateESPForPlayer(player)
    if player == LocalPlayer then return end
    ClearESPForPlayer(player)

    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local hrp = char.HumanoidRootPart
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPBillboard"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 140, 0, 70)
    billboard.AlwaysOnTop = true
    billboard.Parent = hrp

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 0.6
    frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    frame.BorderSizePixel = 0
    frame.Parent = billboard

    -- Nome
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = player.Name
    nameLabel.TextScaled = true
    nameLabel.Parent = frame

    -- Barra de Vida vertical
    local healthBarFrame = Instance.new("Frame")
    healthBarFrame.Size = UDim2.new(0.15, 0, 0.6, 0)
    healthBarFrame.Position = UDim2.new(0, 0, 0.35, 0)
    healthBarFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    healthBarFrame.BorderSizePixel = 1
    healthBarFrame.BorderColor3 = Color3.fromRGB(255,255,255)
    healthBarFrame.Parent = frame

    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.Position = UDim2.new(0, 0, 0, 0)
    healthBar.BackgroundColor3 = ESPSettings.HealthBarColors.Green
    healthBar.Parent = healthBarFrame

    -- Distância
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(0.7, 0, 0.3, 0)
    distanceLabel.Position = UDim2.new(0.3, 0, 0.7, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = Color3.fromRGB(255,255,255)
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextScaled = true
    distanceLabel.Parent = frame

    ESPObjects[player] = {
        Billboard = billboard,
        HealthBar = healthBar,
        DistanceLabel = distanceLabel
    }

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not ESPSettings.Enabled or not player.Character or not player.Character:FindFirstChild("Humanoid") then
            ClearESPForPlayer(player)
            if conn then conn:Disconnect() end
            return
        end
        local hum = player.Character.Humanoid
        local healthPercent = hum.Health / hum.MaxHealth

        local color
        if healthPercent >= 0.75 then
            color = ESPSettings.HealthBarColors.Green
        elseif healthPercent >= 0.5 then
            color = ESPSettings.HealthBarColors.Yellow
        else
            color = ESPSettings.HealthBarColors.Red
        end
        healthBar.Size = UDim2.new(1, 0, healthPercent, 0)
        healthBar.BackgroundColor3 = color

        if ESPSettings.Distance then
            local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
            distanceLabel.Text = dist .. "m"
        else
            distanceLabel.Text = ""
        end
    end)
end

function UpdateAllESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESPForPlayer(player)
        end
    end
end

function ClearAllESP()
    for player, _ in pairs(ESPObjects) do
        ClearESPForPlayer(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if ESPSettings.Enabled then
            CreateESPForPlayer(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    ClearESPForPlayer(player)
end)

-- Parte 3: Aimbot (Normal + Silent)

local AimbotTab = Window:CreateTab("🎯 Aimbot", 4483362458)

local AimbotSettings = {
    Enabled = false,
    Silent = false,
    FOV = 50,
    Smoothness = 5,
    TargetPart = "Head",
}

AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "aimbot_toggle",
    Callback = function(value)
        AimbotSettings.Enabled = value
    end
})

AimbotTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "silentaim_toggle",
    Callback = function(value)
        AimbotSettings.Silent = value
    end
})

AimbotTab:CreateSlider({
    Name = "FOV",
    Min = 10,
    Max = 150,
    Default = 50,
    Precision = 1,
    Flag = "fov_slider",
    Callback = function(value)
        AimbotSettings.FOV = value
    end
})

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Min = 1,
    Max = 20,
    Default = 5,
    Precision = 1,
    Flag = "smoothness_slider",
    Callback = function(value)
        AimbotSettings.Smoothness = value
    end
})

AimbotTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = "Head",
    Flag = "targetpart_dropdown",
    Callback = function(value)
        AimbotSettings.TargetPart = value
    end
})

-- Função para encontrar o melhor alvo dentro do FOV
local function GetClosestTarget()
    local closestPlayer = nil
    local closestDistance = AimbotSettings.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimbotSettings.TargetPart) and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local targetPart = player.Character[AimbotSettings.TargetPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if dist < closestDistance then
                    closestDistance = dist
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

-- Aimbot Loop para movimentação da mira (normal aim)
RunService.RenderStepped:Connect(function()
    if AimbotSettings.Enabled and not AimbotSettings.Silent then
        local target = GetClosestTarget()
        if target and target.Character and target.Character:FindFirstChild(AimbotSettings.TargetPart) then
            local targetPart = target.Character[AimbotSettings.TargetPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                local diff = (targetPos - Vector2.new(mousePos.X, mousePos.Y)) / AimbotSettings.Smoothness

                local newMousePos = Vector2.new(mousePos.X, mousePos.Y) + diff
                -- Move o mouse suavemente para o alvo
                mousemoverel(diff.X, diff.Y)
            end
        end
    end
end)

-- Silent Aim: intercepta tiros ou mira de modo invisível
-- OBS: Silent Aim depende de como o jogo lida com os eventos de tiro,
-- essa implementação pode precisar ser adaptada para cada jogo

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if AimbotSettings.Enabled and AimbotSettings.Silent then
        if tostring(method) == "FireServer" and self.Name == "ShootEvent" then
            -- Substitua "ShootEvent" pelo nome do evento que o jogo usa para atirar
            local target = GetClosestTarget()
            if target and target.Character and target.Character:FindFirstChild(AimbotSettings.TargetPart) then
                args[1] = target.Character[AimbotSettings.TargetPart].Position
                return oldNamecall(self, unpack(args))
            end
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- Parte 4: Movimento (WalkSpeed, JumpPower, Infinite Jump, NoClip)

local MovementTab = Window:CreateTab("🚀 Movement", 4483362458)

local MovementSettings = {
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    NoClip = false,
}

-- WalkSpeed Slider
MovementTab:CreateSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 250,
    Default = 16,
    Precision = 1,
    Flag = "walkspeed_slider",
    Callback = function(value)
        MovementSettings.WalkSpeed = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end
})

-- JumpPower Slider
MovementTab:CreateSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 250,
    Default = 50,
    Precision = 1,
    Flag = "jumppower_slider",
    Callback = function(value)
        MovementSettings.JumpPower = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = value
        end
    end
})

-- Infinite Jump Toggle
MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "infinitejump_toggle",
    Callback = function(value)
        MovementSettings.InfiniteJump = value
    end
})

-- NoClip Toggle
MovementTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "noclip_toggle",
    Callback = function(value)
        MovementSettings.NoClip = value
    end
})

-- Infinite Jump handler
UserInputService.JumpRequest:Connect(function()
    if MovementSettings.InfiniteJump then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- NoClip function: toggle collision off for all parts
local RunService = game:GetService("RunService")
RunService.Stepped:Connect(function()
    if MovementSettings.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    elseif LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide == false then
                part.CanCollide = true
            end
        end
    end
end)

-- Reset WalkSpeed and JumpPower on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").WalkSpeed = MovementSettings.WalkSpeed
    char:WaitForChild("Humanoid").JumpPower = MovementSettings.JumpPower
end)

-- Parte 5: Utilitários

local UtilityTab = Window:CreateTab("🛠️ Utilities", 4483362458)

local UtilitySettings = {
    FOVCircle = false,
    FOVSize = 100,
    FOVTransparency = 0.5,
    FPSBoost = false,
    AntiAFK = false,
}

-- FOV Circle Toggle
UtilityTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Flag = "fovcircle_toggle",
    Callback = function(value)
        UtilitySettings.FOVCircle = value
        if value then
            if not UtilitySettings.FOVCircleInstance then
                UtilitySettings.FOVCircleInstance = Drawing.new("Circle")
            end
            UtilitySettings.FOVCircleInstance.Visible = true
        else
            if UtilitySettings.FOVCircleInstance then
                UtilitySettings.FOVCircleInstance.Visible = false
            end
        end
    end
})

-- FOV Size Slider
UtilityTab:CreateSlider({
    Name = "FOV Size",
    Min = 50,
    Max = 300,
    Default = 100,
    Precision = 1,
    Flag = "fovsize_slider",
    Callback = function(value)
        UtilitySettings.FOVSize = value
        if UtilitySettings.FOVCircleInstance then
            UtilitySettings.FOVCircleInstance.Radius = value
        end
    end
})

-- FOV Transparency Slider
UtilityTab:CreateSlider({
    Name = "FOV Transparency",
    Min = 0,
    Max = 1,
    Default = 0.5,
    Precision = 0.1,
    Flag = "fovtransparency_slider",
    Callback = function(value)
        UtilitySettings.FOVTransparency = value
        if UtilitySettings.FOVCircleInstance then
            UtilitySettings.FOVCircleInstance.Transparency = value
        end
    end
})

-- FPS Boost Toggle
UtilityTab:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = false,
    Flag = "fpsboost_toggle",
    Callback = function(value)
        UtilitySettings.FPSBoost = value
        if value then
            setfpscap(30)
        else
            setfpscap(1000)
        end
    end
})

-- Anti AFK Toggle
UtilityTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "antiafk_toggle",
    Callback = function(value)
        UtilitySettings.AntiAFK = value
    end
})

-- Anti AFK function
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if UtilitySettings.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end
end)

-- Draw FOV Circle
local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    if UtilitySettings.FOVCircle and UtilitySettings.FOVCircleInstance then
        local mouse = game.Players.LocalPlayer:GetMouse()
        UtilitySettings.FOVCircleInstance.Position = Vector2.new(mouse.X, mouse.Y)
        UtilitySettings.FOVCircleInstance.Color = Color3.fromRGB(255, 0, 0)
        UtilitySettings.FOVCircleInstance.Thickness = 1
        UtilitySettings.FOVCircleInstance.NumSides = 64
        UtilitySettings.FOVCircleInstance.Transparency = UtilitySettings.FOVTransparency
        UtilitySettings.FOVCircleInstance.Filled = false
    elseif UtilitySettings.FOVCircleInstance then
        UtilitySettings.FOVCircleInstance.Visible = false
    end
end)

local ThemesTab = Window:CreateTab("🎨 Themes", 4483362458)

-- Lista oficial de temas do Rayfield (exemplos)
local availableThemes = {
    "Default",
    "Midnight",
    "Ocean",
    "Blood",
    "Candy",
    "Classic",
    "Electric",
    "Forest",
    "Light",
    "Neon",
    "Pastel",
    "Synthwave"
}

-- Label explicativa
ThemesTab:CreateLabel("Select a theme to apply to the Hub")

-- Dropdown para selecionar tema
local themeDropdown = ThemesTab:CreateDropdown({
    Name = "Theme Selector",
    Options = availableThemes,
    CurrentOption = "Default",
    Flag = "theme_selector",
    Callback = function(selected)
        Rayfield:SetTheme(selected)
        Rayfield:Notify({
            Title = "Theme Changed",
            Content = "Theme set to: " .. selected,
            Duration = 4,
            Image = 4483362458
        })
    end
})

-- Botão para resetar ao tema padrão
ThemesTab:CreateButton({
    Name = "Reset to Default Theme",
    Callback = function()
        Rayfield:SetTheme("Default")
        themeDropdown:Update("Default")
        Rayfield:Notify({
            Title = "Theme Reset",
            Content = "Theme reverted to Default",
            Duration = 4,
            Image = 4483362458
        })
    end
})
