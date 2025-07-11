local Rayfield = loadstring(game:HttpGet("https://sirius.menu/Rayfield"))()

local Themes = {
    ["Tortuguita"] = {
        MainColor = Color3.fromRGB(0, 170, 127),
        Background = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(0, 255, 191),
        LightContrast = Color3.fromRGB(30, 30, 30),
        DarkContrast = Color3.fromRGB(10, 10, 10),
        TextColor = Color3.fromRGB(230, 230, 230),
        Font = Enum.Font.GothamBold,
        TextSize = 15,
    },
    ["Cyberpunk"] = {
        MainColor = Color3.fromRGB(255, 20, 147),
        Background = Color3.fromRGB(15, 15, 15),
        Accent = Color3.fromRGB(0, 255, 255),
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

local Window = Rayfield:CreateWindow({
    Name = "TortuguitaHub V3",
    Icon = 2157234102, -- seu ID de tartaruga
    LoadingTitle = "TortuguitaHub V3",
    LoadingSubtitle = "by Tortuguita",
    ShowText = "Tortuguita",
    Theme = Themes["Tortuguita"],
    ToggleUIKeybind = "K",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TortuguitaHubConfigs",
        FileName = "ConfigV3"
    },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- Aba Configurações para escolher tema
local ConfigTab = Window:CreateTab("Configurações", 4483362458)
ConfigTab:CreateDropdown({
    Name = "Escolha o tema",
    Options = {"Tortuguita", "Cyberpunk", "DarkMode"},
    CurrentOption = "Tortuguita",
    Callback = function(selectedTheme)
        Window:UpdateTheme(Themes[selectedTheme])
    end,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESPTab = Window:CreateTab("ESP", 4483362458)

-- Configurações ESP
local espEnabled = false
local espBox = true
local espHealthBar = true
local espName = true
local espDistance = 200
local espHighlight = true
local espInventory = true

-- Criando toggles e sliders na aba ESP

ESPTab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(value)
        espEnabled = value
    end,
})

ESPTab:CreateToggle({
    Name = "Mostrar Caixa",
    CurrentValue = true,
    Flag = "ESPBox",
    Callback = function(value)
        espBox = value
    end,
})

ESPTab:CreateToggle({
    Name = "Mostrar Barra de Vida",
    CurrentValue = true,
    Flag = "ESPHealthBar",
    Callback = function(value)
        espHealthBar = value
    end,
})

ESPTab:CreateToggle({
    Name = "Mostrar Nome",
    CurrentValue = true,
    Flag = "ESPName",
    Callback = function(value)
        espName = value
    end,
})

ESPTab:CreateSlider({
    Name = "Distância Máxima",
    Min = 50,
    Max = 1000,
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 200,
    Flag = "ESPDist",
    Callback = function(value)
        espDistance = value
    end,
})

ESPTab:CreateToggle({
    Name = "Highlight",
    CurrentValue = true,
    Flag = "ESPHighlight",
    Callback = function(value)
        espHighlight = value
    end,
})

ESPTab:CreateToggle({
    Name = "Mostrar Inventário",
    CurrentValue = true,
    Flag = "ESPInventory",
    Callback = function(value)
        espInventory = value
    end,
})

-- Função para criar ESP para um jogador
local function createESPForPlayer(player)
    if player == LocalPlayer then return end

    local espObjects = {}

    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        local head = character:WaitForChild("Head", 5)
        if not humanoid or not head then return end

        -- Create Drawing objects
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = Color3.new(1, 1, 1)
        box.Thickness = 2
        box.Filled = false

        local healthBar = Drawing.new("Line")
        healthBar.Visible = false
        healthBar.Color = Color3.new(0, 1, 0)
        healthBar.Thickness = 3

        local nameText = Drawing.new("Text")
        nameText.Visible = false
        nameText.Text = player.Name
        nameText.Color = Color3.new(1, 1, 1)
        nameText.Size = 16
        nameText.Center = true
        nameText.Outline = true

        local highlight = Drawing.new("Square")
        highlight.Visible = false
        highlight.Color = Color3.fromRGB(0, 255, 255)
        highlight.Thickness = 2
        highlight.Filled = false

        local inventoryText = Drawing.new("Text")
        inventoryText.Visible = false
        inventoryText.Text = ""
        inventoryText.Color = Color3.new(1, 1, 1)
        inventoryText.Size = 14
        inventoryText.Center = true
        inventoryText.Outline = true

        espObjects = {box = box, healthBar = healthBar, nameText = nameText, highlight = highlight, inventoryText = inventoryText}

        RunService:BindToRenderStep(player.Name .. "_ESP", 301, function()
            if not espEnabled then
                for _, obj in pairs(espObjects) do
                    obj.Visible = false
                end
                return
            end
            if not character or not character.Parent then
                for _, obj in pairs(espObjects) do
                    obj.Visible = false
                end
                RunService:UnbindFromRenderStep(player.Name .. "_ESP")
                return
            end

            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then
                for _, obj in pairs(espObjects) do
                    obj.Visible = false
                end
                return
            end

            local dist = (rootPart.Position - Camera.CFrame.Position).Magnitude
            if dist > espDistance then
                for _, obj in pairs(espObjects) do
                    obj.Visible = false
                end
                return
            end

            local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if not onScreen then
                for _, obj in pairs(espObjects) do
                    obj.Visible = false
                end
                return
            end

            -- Box
            if espBox then
                local size = Vector2.new(50, 100)
                box.Size = size
                box.Position = Vector2.new(rootPos.X - size.X/2, rootPos.Y - size.Y/2)
                box.Visible = true
            else
                box.Visible = false
            end

            -- Health Bar vertical ao lado da box
            if espHealthBar then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                    local barHeight = 100 * healthPercent
                    healthBar.From = Vector2.new(box.Position.X - 6, box.Position.Y + 100)
                    healthBar.To = Vector2.new(box.Position.X - 6, box.Position.Y + 100 - barHeight)
                    healthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    healthBar.Visible = true
                else
                    healthBar.Visible = false
                end
            else
                healthBar.Visible = false
            end

            -- Nome
            if espName then
                nameText.Position = Vector2.new(rootPos.X, box.Position.Y - 18)
                nameText.Text = player.Name
                nameText.Visible = true
            else
                nameText.Visible = false
            end

            -- Highlight
            if espHighlight then
                highlight.Size = box.Size + Vector2.new(4, 4)
                highlight.Position = box.Position - Vector2.new(2, 2)
                highlight.Visible = true
            else
                highlight.Visible = false
            end

            -- Inventory (mostra texto simplificado do inventário do jogador)
            if espInventory then
                local backpack = player:FindFirstChild("Backpack")
                local inventoryString = ""
                if backpack then
                    for _, item in pairs(backpack:GetChildren()) do
                        inventoryString = inventoryString .. item.Name .. ", "
                    end
                end
                if inventoryString ~= "" then
                    inventoryString = inventoryString:sub(1, -3)
                    inventoryText.Text = "Inv: " .. inventoryString
                    inventoryText.Position = Vector2.new(rootPos.X, box.Position.Y + 110)
                    inventoryText.Visible = true
                else
                    inventoryText.Visible = false
                end
            else
                inventoryText.Visible = false
            end
        end)
    end

    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- Aplica ESP em todos os jogadores, atualiza ao entrar/ sair
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESPForPlayer(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createESPForPlayer(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RunService:UnbindFromRenderStep(player.Name .. "_ESP")
end)

local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local SilentAimTab = Window:CreateTab("Silent Aim", 4483362458)

-- Variáveis Aimbot
local aimbotEnabled = false
local aimbotFov = 50
local aimbotAimPart = "Head"
local aimbotSmoothness = 5

-- Variáveis Silent Aim
local silentAimEnabled = false
local silentAimFov = 70
local silentAimAimPart = "Head"

-- UI - Aimbot
AimbotTab:CreateToggle({
    Name = "Ativar Aimbot",
    CurrentValue = false,
    Flag = "AimbotEnabled",
    Callback = function(value)
        aimbotEnabled = value
    end,
})

AimbotTab:CreateSlider({
    Name = "FOV",
    Min = 10,
    Max = 200,
    Increment = 1,
    Suffix = "°",
    CurrentValue = 50,
    Flag = "AimbotFov",
    Callback = function(value)
        aimbotFov = value
    end,
})

AimbotTab:CreateDropdown({
    Name = "Parte do Corpo",
    Options = {"Head", "Torso"},
    CurrentOption = "Head",
    Flag = "AimbotAimPart",
    Callback = function(option)
        aimbotAimPart = option
    end,
})

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Min = 1,
    Max = 20,
    Increment = 1,
    CurrentValue = 5,
    Flag = "AimbotSmooth",
    Callback = function(value)
        aimbotSmoothness = value
    end,
})

-- UI - Silent Aim
SilentAimTab:CreateToggle({
    Name = "Ativar Silent Aim",
    CurrentValue = false,
    Flag = "SilentAimEnabled",
    Callback = function(value)
        silentAimEnabled = value
    end,
})

SilentAimTab:CreateSlider({
    Name = "FOV",
    Min = 10,
    Max = 200,
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "SilentAimFov",
    Callback = function(value)
        silentAimFov = value
    end,
})

SilentAimTab:CreateDropdown({
    Name = "Parte do Corpo",
    Options = {"Head", "Torso"},
    CurrentOption = "Head",
    Flag = "SilentAimAimPart",
    Callback = function(option)
        silentAimAimPart = option
    end,
})

-- Função auxiliar para encontrar o alvo dentro do FOV e distância
local function getClosestTarget(fov, aimPartName)
    local target = nil
    local closestDist = math.huge
    local mousePos = game.Players.LocalPlayer:GetMouse().Hit.Position
    local camera = workspace.CurrentCamera
    local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimPartName) then
            local part = player.Character[aimPartName]
            local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local pos2d = Vector2.new(screenPos.X, screenPos.Y)
                local dist = (pos2d - screenCenter).Magnitude
                if dist < fov and dist < closestDist then
                    target = player
                    closestDist = dist
                end
            end
        end
    end
    return target
end

-- Aimbot Loop
RunService:BindToRenderStep("Aimbot", 301, function()
    if aimbotEnabled then
        local target = getClosestTarget(aimbotFov, aimbotAimPart)
        if target and target.Character and target.Character:FindFirstChild(aimbotAimPart) then
            local camera = workspace.CurrentCamera
            local targetPos = target.Character[aimbotAimPart].Position
            local cameraCFrame = camera.CFrame
            local direction = (targetPos - cameraCFrame.Position).Unit
            local targetCFrame = CFrame.new(cameraCFrame.Position, cameraCFrame.Position + direction)
            -- Smooth lerp para mirar
            camera.CFrame = cameraCFrame:Lerp(targetCFrame, 1 / aimbotSmoothness)
        end
    end
end)

-- Silent Aim Hook
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, key)
    if silentAimEnabled and self == workspace.CurrentCamera and key == "CFrame" then
        local target = getClosestTarget(silentAimFov, silentAimAimPart)
        if target and target.Character and target.Character:FindFirstChild(silentAimAimPart) then
            return CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character[silentAimAimPart].Position)
        end
    end
    return oldIndex(self, key)
end)

setreadonly(mt, true)

local MovementTab = Window:CreateTab("Movimento", 4483362458)

-- Variáveis de movimento
local noclipEnabled = false
local speedEnabled = false
local speedValue = 16
local jumpBoostEnabled = false
local jumpPowerValue = 50
local flyEnabled = false
local flySpeed = 50

-- Noclip toggle
MovementTab:CreateToggle({
    Name = "Ativar Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclipEnabled = value
        if noclipEnabled then
            noclipLoop = RunService.Stepped:Connect(function()
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end)
        else
            if noclipLoop then
                noclipLoop:Disconnect()
                noclipLoop = nil
            end
            -- Restaurar colisão
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end,
})

-- Speed toggle + slider
MovementTab:CreateToggle({
    Name = "Ativar Speed",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(value)
        speedEnabled = value
        if not speedEnabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- padrão
        end
    end,
})

MovementTab:CreateSlider({
    Name = "Velocidade (WalkSpeed)",
    Min = 16,
    Max = 150,
    Increment = 1,
    CurrentValue = 16,
    Flag = "SpeedValue",
    Callback = function(value)
        speedValue = value
        if speedEnabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
        end
    end,
})

-- Jump Boost toggle + slider
MovementTab:CreateToggle({
    Name = "Ativar Jump Boost",
    CurrentValue = false,
    Flag = "JumpBoostToggle",
    Callback = function(value)
        jumpBoostEnabled = value
        if not jumpBoostEnabled then
            LocalPlayer.Character.Humanoid.JumpPower = 50 -- padrão
        end
    end,
})

MovementTab:CreateSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 250,
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPowerValue",
    Callback = function(value)
        jumpPowerValue = value
        if jumpBoostEnabled then
            LocalPlayer.Character.Humanoid.JumpPower = jumpPowerValue
        end
    end,
})

-- Fly toggle + speed slider
MovementTab:CreateToggle({
    Name = "Ativar Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(value)
        flyEnabled = value
        if flyEnabled then
            startFly()
        else
            stopFly()
        end
    end,
})

MovementTab:CreateSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Increment = 1,
    CurrentValue = 50,
    Flag = "FlySpeedValue",
    Callback = function(value)
        flySpeed = value
        if flyEnabled and flyBodyVelocity then
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            flySpeed = value
        end
    end,
})

-- Fly functions
local flyBodyVelocity
local flyLoop

function startFly()
    local character = LocalPlayer.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVelocity.Parent = humanoidRootPart

    flyLoop = RunService.Heartbeat:Connect(function()
        local camera = workspace.CurrentCamera
        local direction = Vector3.new(0, 0, 0)

        local userInput = game:GetService("UserInputService")
        if userInput:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + camera.CFrame.LookVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - camera.CFrame.LookVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - camera.CFrame.RightVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + camera.CFrame.RightVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if userInput:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, 1, 0)
        end

        flyBodyVelocity.Velocity = direction.Unit * flySpeed
    end)
end

function stopFly()
    if flyLoop then
        flyLoop:Disconnect()
        flyLoop = nil
    end
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
end

local UtilityTab = Window:CreateTab("Utilitários", 4483362458)

-- Variables
local antiAfkEnabled = false
local fpsBoostEnabled = false
local fpsCapValue = 60

-- Anti-AFK toggle
UtilityTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAfkToggle",
    Callback = function(value)
        antiAfkEnabled = value
        if antiAfkEnabled then
            local vu = game:GetService("VirtualUser")
            antiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        else
            if antiAfkConnection then
                antiAfkConnection:Disconnect()
                antiAfkConnection = nil
            end
        end
    end,
})

-- FPS Boost toggle + slider
UtilityTab:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = false,
    Flag = "FPSBoostToggle",
    Callback = function(value)
        fpsBoostEnabled = value
        if fpsBoostEnabled then
            setFPSCap(fpsCapValue)
        else
            setFPSCap(0) -- remove cap
        end
    end,
})

UtilityTab:CreateSlider({
    Name = "FPS Cap",
    Min = 30,
    Max = 144,
    Increment = 1,
    CurrentValue = 60,
    Flag = "FPSCapSlider",
    Callback = function(value)
        fpsCapValue = value
        if fpsBoostEnabled then
            setFPSCap(fpsCapValue)
        end
    end,
})

-- Função para limitar FPS (simples workaround)
function setFPSCap(fps)
    if fps > 0 then
        game:GetService("RunService").RenderStepped:Connect(function()
            wait(1/fps)
        end)
    else
        -- Desativa o limite de FPS (não faz nada)
    end
end

-- Teleport to player dropdown
local playersList = {}
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr ~= game.Players.LocalPlayer then
        table.insert(playersList, plr.Name)
    end
end

local teleportTo = nil

UtilityTab:CreateDropdown({
    Name = "Teleportar para jogador",
    Options = playersList,
    Flag = "TeleportDropdown",
    Callback = function(value)
        teleportTo = value
    end,
})

UtilityTab:CreateButton({
    Name = "Teleportar",
    Callback = function()
        if teleportTo then
            local target = game.Players:FindFirstChild(teleportTo)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = target.Character.HumanoidRootPart
                local lp = game.Players.LocalPlayer
                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    lp.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end
    end,
})

-- Rejoin button
UtilityTab:CreateButton({
    Name = "Reentrar no servidor",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local PlaceID = game.PlaceId
        local Player = game.Players.LocalPlayer
        TeleportService:Teleport(PlaceID, Player)
    end,
})

-- Server hop button (troca para servidor diferente)
UtilityTab:CreateButton({
    Name = "Trocar de servidor",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local PlaceID = game.PlaceId

        local servers = {}
        local cursor = ""

        repeat
            local response = game:HttpGetAsync("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100&cursor="..cursor)
            local data = HttpService:JSONDecode(response)
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers then
                    table.insert(servers, server.id)
                end
            end
            cursor = data.nextPageCursor
        until not cursor

        if #servers > 0 then
            local randomServer = servers[math.random(1,#servers)]
            TeleportService:TeleportToPlaceInstance(PlaceID, randomServer, game.Players.LocalPlayer)
        else
            warn("Nenhum servidor disponível para troca.")
        end
    end,
})

-- Clear console button
UtilityTab:CreateButton({
    Name = "Limpar Console",
    Callback = function()
        if syn and syn.queue_on_teleport then
            syn.queue_on_teleport('print("Console limpo")')
        else
            print("Limpar console não suportado neste executor.")
        end
    end,
})
