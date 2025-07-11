-- === INICIALIZAÇÃO E VARIÁVEIS ===
local Plrs = game:GetService("Players")
local LP = Plrs.LocalPlayer
local Cam = workspace.CurrentCamera
local RunS = game:GetService("RunService")

-- Tabela para guardar os GUIs ESP por player
local ESPGuis = {}

-- Configurações ESP controladas pela UI
local ESPSettings = {
    Enabled = false,
    Boxes = false,
    Highlights = false,
    Names = false,
    Distances = false,
    Inventory = false,
    HealthBar = false,
}

-- === FUNÇÃO QUE CRIA O GUI ESP PARA UM PLAYER ===
local function CreateESPGui(plr)
    if not plr.Character then return nil end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local espGui = Instance.new("BillboardGui")
    espGui.Name = "TortuguitaESP"
    espGui.Adornee = hrp
    espGui.AlwaysOnTop = true
    espGui.Size = UDim2.new(0, 100, 0, 50)
    espGui.StudsOffset = Vector3.new(0, 3, 0)

    local box = Instance.new("Frame")
    box.Name = "Box"
    box.BackgroundTransparency = 0.6
    box.BorderSizePixel = 1
    box.Size = UDim2.new(1, 0, 1, 0)
    box.Parent = espGui
    box.Visible = false

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.new(1, 0, 0, 15)
    nameLabel.Position = UDim2.new(0, 0, 0, -15)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 14
    nameLabel.Text = ""
    nameLabel.Parent = espGui
    nameLabel.Visible = false

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "Distance"
    distLabel.Size = UDim2.new(1, 0, 0, 15)
    distLabel.Position = UDim2.new(0, 0, 1, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(255,255,255)
    distLabel.TextStrokeTransparency = 0
    distLabel.Font = Enum.Font.SourceSans
    distLabel.TextSize = 12
    distLabel.Text = ""
    distLabel.Parent = espGui
    distLabel.Visible = false

    local invLabel = Instance.new("TextLabel")
    invLabel.Name = "Inventory"
    invLabel.Size = UDim2.new(1, 0, 0, 20)
    invLabel.Position = UDim2.new(1, 5, 0, 0)
    invLabel.BackgroundTransparency = 1
    invLabel.TextColor3 = Color3.fromRGB(0,255,0)
    invLabel.TextStrokeTransparency = 0
    invLabel.Font = Enum.Font.SourceSansItalic
    invLabel.TextSize = 12
    invLabel.Text = ""
    invLabel.Parent = espGui
    invLabel.Visible = false

    local healthBarBG = Instance.new("Frame")
    healthBarBG.Name = "HealthBarBG"
    healthBarBG.Size = UDim2.new(0, 5, 1, 0)
    healthBarBG.Position = UDim2.new(-0.1, 0, 0, 0)
    healthBarBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
    healthBarBG.BorderSizePixel = 0
    healthBarBG.Parent = espGui
    healthBarBG.Visible = false

    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.Position = UDim2.new(0, 0, 0, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBarBG

    return espGui
end

-- === FUNÇÃO QUE ATUALIZA O GUI ESP ===
local function UpdateESPGui(plr, gui)
    if not (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")) then 
        gui.Enabled = false 
        return 
    end

    local hrp = plr.Character.HumanoidRootPart
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")

    gui.Adornee = hrp
    gui.Enabled = ESPSettings.Enabled

    gui.Box.Visible = ESPSettings.Boxes
    gui.Name.Visible = ESPSettings.Names
    gui.Distance.Visible = ESPSettings.Distances
    gui.Inventory.Visible = ESPSettings.Inventory
    gui.HealthBarBG.Visible = ESPSettings.HealthBar

    if ESPSettings.Highlights and ESPSettings.Boxes then
        gui.Box.BorderColor3 = Color3.fromRGB(255, 215, 0)
    else
        gui.Box.BorderColor3 = Color3.new(0,0,0)
    end

    if ESPSettings.Names then
        gui.Name.Text = plr.Name
    end

    if ESPSettings.Distances then
        local dist = math.floor((Cam.CFrame.Position - hrp.Position).Magnitude)
        gui.Distance.Text = dist .. "m"
    end

    if ESPSettings.Inventory then
        local bp = plr:FindFirstChild("Backpack")
        if bp then
            local invItems = {}
            for _, item in pairs(bp:GetChildren()) do
                table.insert(invItems, item.Name)
            end
            gui.Inventory.Text = table.concat(invItems, ", ")
        else
            gui.Inventory.Text = "Sem Inventário"
        end
    end

    if ESPSettings.HealthBar and hum then
        local hpPercent = hum.Health / hum.MaxHealth
        hpPercent = math.clamp(hpPercent, 0, 1)
        gui.HealthBar.Size = UDim2.new(1, 0, hpPercent, 0)

        if hpPercent > 0.75 then
            gui.HealthBar.BackgroundColor3 = Color3.fromRGB(0,255,0)
        elseif hpPercent > 0.5 then
            gui.HealthBar.BackgroundColor3 = Color3.fromRGB(255,255,0)
        else
            gui.HealthBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
        end
    end
end

-- === LOOP DE ATUALIZAÇÃO ===
RunS.RenderStepped:Connect(function()
    if not ESPSettings.Enabled then
        for plr, gui in pairs(ESPGuis) do
            if gui then gui.Enabled = false end
        end
        return
    end

    for _, plr in pairs(Plrs:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPGuis[plr] then
                ESPGuis[plr] = CreateESPGui(plr)
                if ESPGuis[plr] then ESPGuis[plr].Parent = Cam end
            end
            if ESPGuis[plr] then
                UpdateESPGui(plr, ESPGuis[plr])
            end
        elseif ESPGuis[plr] then
            ESPGuis[plr].Enabled = false
        end
    end
end)

-- === LIMPAR QUANDO UM PLAYER SAI ===
Plrs.PlayerRemoving:Connect(function(plr)
    if ESPGuis[plr] then
        ESPGuis[plr]:Destroy()
        ESPGuis[plr] = nil
    end
end)

-- === RAYFIELD UI ===
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "TortuguitaHub V3 🐢",
   Icon = 10893912572, -- ID da tartaruga (logo)
   LoadingTitle = "TortuguitaHub",
   LoadingSubtitle = "Ultimate testing suite",
   ShowText = "TortuguitaHub 🐢",
   Theme = "Dark", -- Você pode trocar depois pelos temas do Rayfield

   ToggleUIKeybind = "K",

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "TortuguitaHubConfigs",
      FileName = "UserSettings"
   },

   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },

   KeySystem = false
})

local ESPTab = Window:CreateTab("ESP", 4483362458)

ESPTab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(value)
        ESPSettings.Enabled = value
    end
})

ESPTab:CreateToggle({
    Name = "Mostrar Boxes",
    CurrentValue = false,
    Flag = "ESPBoxes",
    Callback = function(value)
        ESPSettings.Boxes = value
    end
})

ESPTab:CreateToggle({
    Name = "Highlight (Borda Dourada)",
    CurrentValue = false,
    Flag = "ESPHighlights",
    Callback = function(value)
        ESPSettings.Highlights = value
    end
})

ESPTab:CreateToggle({
    Name = "Mostrar Nomes",
    CurrentValue = false,
    Flag = "ESPNomes",
    Callback = function(value)
        ESPSettings.Names = value
    end
})

ESPTab:CreateToggle({
    Name = "Mostrar Distância",
    CurrentValue = false,
    Flag = "ESPDistancia",
    Callback = function(value)
        ESPSettings.Distances = value
    end
})

ESPTab:CreateToggle({
    Name = "Mostrar Inventário",
    CurrentValue = false,
    Flag = "ESPInventory",
    Callback = function(value)
        ESPSettings.Inventory = value
    end
})

ESPTab:CreateToggle({
    Name = "Mostrar HealthBar",
    CurrentValue = false,
    Flag = "ESPHealthBar",
    Callback = function(value)
        ESPSettings.HealthBar = value
    end
})

--==[ Aimbot e Silent Aim ]==--

local AimbotConfig = {
    Enabled = false,
    TeamCheck = true,
    FOV = 100,
    Smoothness = 5,
    TargetPart = "Head" -- cabeça por padrão
}

local SilentAimConfig = {
    Enabled = false,
    TeamCheck = true,
    TargetPart = "Head",
    HitChance = 75 -- % de chance de acertar
}

local function GetClosestTarget(config)
    local closestPlayer = nil
    local shortestDist = math.huge
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild(config.TargetPart) and plr.Character:FindFirstChild("Humanoid") then
            local hum = plr.Character.Humanoid
            if hum.Health > 0 then
                if config.TeamCheck and plr.Team == LP.Team then
                    continue
                end

                local partPos, onScreen = Cam:WorldToViewportPoint(plr.Character[config.TargetPart].Position)
                if onScreen then
                    local screenPos = Vector2.new(partPos.X, partPos.Y)
                    local dist = (screenPos - mousePos).Magnitude
                    if dist < config.FOV and dist < shortestDist then
                        shortestDist = dist
                        closestPlayer = plr
                    end
                end
            end
        end
    end
    return closestPlayer
end

--==[ Aimbot ]==--

RunS.RenderStepped:Connect(function()
    if AimbotConfig.Enabled and Mouse.Button2Down then
        local target = GetClosestTarget(AimbotConfig)
        if target and target.Character and target.Character:FindFirstChild(AimbotConfig.TargetPart) then
            local targetPos = target.Character[AimbotConfig.TargetPart].Position
            local cameraPos = Cam.CFrame.Position
            local direction = (targetPos - cameraPos).Unit
            local currentCFrame = Cam.CFrame
            local desiredCFrame = CFrame.new(cameraPos, targetPos)
            -- Interpola suavemente (smooth) para o alvo
            Cam.CFrame = currentCFrame:Lerp(desiredCFrame, AimbotConfig.Smoothness / 100)
        end
    end
end)

--==[ Silent Aim Hook ]==--

-- Esta parte depende do jogo, vou fazer um hook básico simulando silent aim no "Hit" de armas que usam Raycasting

local oldRaycast = workspace.Raycast or workspace.RaycastAsync -- depende da versão, cuidado

local function SilentAimRaycast(origin, direction, ...)
    if SilentAimConfig.Enabled then
        local target = GetClosestTarget(SilentAimConfig)
        if target and target.Character and target.Character:FindFirstChild(SilentAimConfig.TargetPart) then
            -- Chance de acertar
            if math.random(1, 100) <= SilentAimConfig.HitChance then
                local targetPos = target.Character[SilentAimConfig.TargetPart].Position
                local newDirection = (targetPos - origin).Unit * direction.Magnitude
                return oldRaycast(workspace, origin, newDirection, ...)
            end
        end
    end
    return oldRaycast(workspace, origin, direction, ...)
end

-- Hook a função Raycast (apenas exemplo, pode variar por jogo)

workspace.Raycast = SilentAimRaycast

--==[ UI Rayfield ]==--

local AimbotTab = Window:CreateTab("Aimbot", 4483362458) -- Icon ID exemplo
local SilentAimTab = Window:CreateTab("Silent Aim", 4483362458)

-- Aimbot UI
AimbotTab:CreateToggle({
    Name = "Ativar Aimbot",
    CurrentValue = false,
    Flag = "Aimbot_Enable",
    Callback = function(val)
        AimbotConfig.Enabled = val
    end
})

AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "Aimbot_TeamCheck",
    Callback = function(val)
        AimbotConfig.TeamCheck = val
    end
})

AimbotTab:CreateSlider({
    Name = "FOV",
    Min = 10,
    Max = 300,
    Increment = 1,
    Suffix = " px",
    CurrentValue = AimbotConfig.FOV,
    Flag = "Aimbot_FOV",
    Callback = function(val)
        AimbotConfig.FOV = val
    end
})

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Min = 1,
    Max = 30,
    Increment = 1,
    Suffix = "%",
    CurrentValue = AimbotConfig.Smoothness,
    Flag = "Aimbot_Smoothness",
    Callback = function(val)
        AimbotConfig.Smoothness = val
    end
})

AimbotTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = "Head",
    Flag = "Aimbot_TargetPart",
    Callback = function(val)
        AimbotConfig.TargetPart = val
    end
})

-- Silent Aim UI
SilentAimTab:CreateToggle({
    Name = "Ativar Silent Aim",
    CurrentValue = false,
    Flag = "SilentAim_Enable",
    Callback = function(val)
        SilentAimConfig.Enabled = val
    end
})

SilentAimTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "SilentAim_TeamCheck",
    Callback = function(val)
        SilentAimConfig.TeamCheck = val
    end
})

SilentAimTab:CreateSlider({
    Name = "Hit Chance",
    Min = 1,
    Max = 100,
    Increment = 1,
    Suffix = "%",
    CurrentValue = SilentAimConfig.HitChance,
    Flag = "SilentAim_HitChance",
    Callback = function(val)
        SilentAimConfig.HitChance = val
    end
})

SilentAimTab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = "Head",
    Flag = "SilentAim_TargetPart",
    Callback = function(val)
        SilentAimConfig.TargetPart = val
    end
})

local UtilsTab = Window:CreateTab("Utilitários", 4483362458)

-- Auto Heal Toggle
local AutoHealToggle = UtilsTab:CreateToggle({
    Name = "Auto Heal",
    CurrentValue = false,
    Flag = "AutoHeal",
    Callback = function(state)
        if state then
            AutoHealLoop = RunService.Heartbeat:Connect(function()
                local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = math.min(humanoid.Health + 1, humanoid.MaxHealth)
                end
            end)
        else
            if AutoHealLoop then AutoHealLoop:Disconnect() AutoHealLoop = nil end
        end
    end,
})

-- Auto Respawn Toggle
local AutoRespawnToggle = UtilsTab:CreateToggle({
    Name = "Auto Respawn",
    CurrentValue = false,
    Flag = "AutoRespawn",
    Callback = function(state)
        if state then
            AutoRespawnLoop = RunService.Heartbeat:Connect(function()
                local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid.Health <= 0 then
                    wait(3)
                    if PlayersService and PlayersService.LocalPlayer then
                        PlayersService.LocalPlayer:LoadCharacter()
                    end
                end
            end)
        else
            if AutoRespawnLoop then AutoRespawnLoop:Disconnect() AutoRespawnLoop = nil end
        end
    end,
})

-- Inventory Viewer Toggle
local InventoryToggle = UtilsTab:CreateToggle({
    Name = "Inventory Viewer",
    CurrentValue = false,
    Flag = "InventoryViewer",
    Callback = function(state)
        if state then
            print("Inventário do player:")
            local backpack = LP:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, item in pairs(backpack:GetChildren()) do
                    print(item.Name)
                end
            else
                print("Backpack não encontrado.")
            end
        else
            print("Inventory Viewer desativado.")
        end
    end,
})

-- Global ESP Toggle
local GlobalESPToggle = UtilsTab:CreateToggle({
    Name = "ESP Geral",
    CurrentValue = false,
    Flag = "GlobalESP",
    Callback = function(state)
        if state then
            print("ESP ativado")
            -- Conecte aqui seu loop de ESP
        else
            print("ESP desativado")
            -- Desconecte e limpe ESP
        end
    end,
})

-- FPS Boost Toggle (desliga sombras, efeitos para mais FPS)
local FPSBoostToggle = UtilsTab:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = false,
    Flag = "FPSBoost",
    Callback = function(state)
        if state then
            -- Exemplo simples
            workspace.CurrentCamera.RenderingEnabled = false
            for _, v in pairs(LP.PlayerGui:GetChildren()) do
                if v:IsA("ScreenGui") then
                    v.Enabled = false
                end
            end
            print("FPS Boost ativado")
        else
            workspace.CurrentCamera.RenderingEnabled = true
            for _, v in pairs(LP.PlayerGui:GetChildren()) do
                if v:IsA("ScreenGui") then
                    v.Enabled = true
                end
            end
            print("FPS Boost desativado")
        end
    end,
})

-- Anti AFK Toggle (impede que você seja desconectado por inatividade)
local AntiAFKToggle = UtilsTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(state)
        if state then
            if not AntiAFKConnection then
                AntiAFKConnection = LP.Idled:Connect(function()
                    local vu = game:GetService("VirtualUser")
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    wait(1)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end)
            end
            print("Anti AFK ativado")
        else
            if AntiAFKConnection then
                AntiAFKConnection:Disconnect()
                AntiAFKConnection = nil
            end
            print("Anti AFK desativado")
        end
    end,
})

-- Misc Dropdown (Extras variados)
local MiscDropdown = UtilsTab:CreateDropdown({
    Name = "Outros Utilitários",
    Options = {"Nenhum", "Modo Invisível", "Modo God", "Modo Speed"},
    CurrentOption = "Nenhum",
    Flag = "MiscOptions",
    Callback = function(option)
        if option == "Modo Invisível" then
            print("Ativando Modo Invisível")
            if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.Transparency = 1
                for _, part in pairs(LP.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                    end
                end
            end
        elseif option == "Modo God" then
            print("Ativando God Mode")
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character:FindFirstChildOfClass("Humanoid").MaxHealth = math.huge
                LP.Character:FindFirstChildOfClass("Humanoid").Health = math.huge
            end
        elseif option == "Modo Speed" then
            print("Ativando Speed Mode")
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 50
            end
        else
            print("Nenhum utilitário selecionado")
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                local hum = LP.Character:FindFirstChildOfClass("Humanoid")
                hum.MaxHealth = 100
                hum.Health = 100
                hum.WalkSpeed = 16
                if LP.Character:FindFirstChild("HumanoidRootPart") then
                    for _, part in pairs(LP.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0
                        end
                    end
                end
            end
        end
    end,
})

-- Themes personalizados para Rayfield
local Themes = {
    ["Tortuguita"] = {
        MainColor = Color3.fromRGB(0, 170, 127),       -- Verde tortuga
        Background = Color3.fromRGB(20, 20, 20),       -- Fundo escuro
        Accent = Color3.fromRGB(0, 255, 191),           -- Destaque brilhante
        LightContrast = Color3.fromRGB(30, 30, 30),    -- Contraste leve
        DarkContrast = Color3.fromRGB(10, 10, 10),     -- Contraste escuro
        TextColor = Color3.fromRGB(230, 230, 230),     -- Texto claro
        Font = Enum.Font.GothamBold,
        TextSize = 15,
    },

    ["Cyberpunk"] = {
        MainColor = Color3.fromRGB(255, 20, 147),      -- Rosa vibrante
        Background = Color3.fromRGB(15, 15, 15),       -- Fundo bem escuro
        Accent = Color3.fromRGB(0, 255, 255),          -- Azul neon
        LightContrast = Color3.fromRGB(40, 40, 40),
        DarkContrast = Color3.fromRGB(5, 5, 5),
        TextColor = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
    },

    ["DarkMode"] = {
        MainColor = Color3.fromRGB(70, 70, 70),
        Background = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(100, 100, 100),
        LightContrast = Color3.fromRGB(40, 40, 40),
        DarkContrast = Color3.fromRGB(20, 20, 20),
        TextColor = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.SourceSansBold,
        TextSize = 14,
    }
}

-- Exemplo de uso na criação da janela Rayfield:
local Window = Rayfield:CreateWindow({
    Name = "TortuguitaHub V3",
    Icon = 2157234102, -- ID da tartaruga que você quiser
    LoadingTitle = "TortuguitaHub V3",
    LoadingSubtitle = "by Tortuguita",
    ShowText = "Tortuguita",
    Theme = Themes["Tortuguita"],  -- Aqui escolhe o tema
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TortuguitaHubConfigs",
        FileName = "ConfigV3"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Você pode criar um dropdown para trocar o tema em tempo real, por exemplo:
local themeDropdown = Window:CreateTab("Configurações", 4483362458):CreateDropdown({
    Name = "Escolha o tema",
    Options = {"Tortuguita", "Cyberpunk", "DarkMode"},
    CurrentOption = "Tortuguita",
    Flag = "ThemeSelector",
    Callback = function(selectedTheme)
        Window:UpdateTheme(Themes[selectedTheme])
    end,
})
