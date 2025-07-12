-- Carrega Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Configuração da janela
local Window = Rayfield:CreateWindow({
   Name = "TortuguitaHub V3",
   Icon = 14047754281, -- ID de uma tartaruga no Roblox, pode mudar
   LoadingTitle = "TortuguitaHub V3",
   LoadingSubtitle = "Inicializando...",
   ShowText = "Tortuguita",
   Theme = "Default",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "TortuguitaHub",
      FileName = "Config"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false
})

-- Criação da aba ESP
local ESPTab = Window:CreateTab("ESP", 4483362458) -- ID de ícone opcional

-- Variáveis básicas
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ESPEnabled = false

-- Função para desenhar ESP box
local function CreateESP(player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(0, 255, 0)
    Box.Thickness = 1
    Box.Filled = false

    local Connection
    Connection = RunService.RenderStepped:Connect(function()
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and ESPEnabled then
            local root = player.Character.HumanoidRootPart
            local pos, visible = Camera:WorldToViewportPoint(root.Position)
            if visible then
                local size = Vector2.new(50, 100) / (root.Position - Camera.CFrame.Position).Magnitude
                Box.Size = size
                Box.Position = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)
                Box.Visible = true
            else
                Box.Visible = false
            end
        else
            Box.Visible = false
        end
    end)

    player.AncestryChanged:Connect(function()
        if not player:IsDescendantOf(game) then
            Connection:Disconnect()
            Box:Remove()
        end
    end)
end

-- Toggle no menu para ligar o ESP
ESPTab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        ESPEnabled = Value
        if Value then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    CreateESP(plr)
                end
            end
            Players.PlayerAdded:Connect(function(plr)
                if plr ~= LocalPlayer then
                    CreateESP(plr)
                end
            end)
        end
    end
})

local ESPTab = Window:CreateTab("ESP 🔍", 4483362458)

-- 📌 SEÇÃO: Configurações Gerais
ESPTab:CreateSection("⚙️ Configurações Gerais")

local espEnabled = false
local espDistance = 250
local espColor = Color3.new(1, 1, 1)
local espMode = "Box"

ESPTab:CreateToggle({
   Name = "Ativar ESP Global",
   CurrentValue = false,
   Callback = function(value)
      espEnabled = value
   end,
})

ESPTab:CreateSlider({
   Name = "Distância Máxima",
   Range = {50, 1000},
   Increment = 50,
   Suffix = " studs",
   CurrentValue = 250,
   Callback = function(value)
      espDistance = value
   end,
})

ESPTab:CreateDropdown({
   Name = "Modo de ESP",
   Options = {"Box", "Tracers", "Name", "Health Bar"},
   CurrentOption = "Box",
   Callback = function(option)
      espMode = option
   end,
})

-- 🧍 SEÇÃO: Jogadores
ESPTab:CreateSection("🧍 Jogadores")

ESPTab:CreateToggle({
   Name = "ESP em Players",
   CurrentValue = false,
   Callback = function(state)
      getgenv().ESPPlayers = state
   end,
})

ESPTab:CreateToggle({
   Name = "Mostrar Nome",
   CurrentValue = false,
   Callback = function(state)
      getgenv().ESPPlayerName = state
   end,
})

ESPTab:CreateToggle({
   Name = "Mostrar Health",
   CurrentValue = false,
   Callback = function(state)
      getgenv().ESPPlayerHealth = state
   end,
})

-- 🤖 SEÇÃO: NPCs e Mobs
ESPTab:CreateSection("🤖 NPCs / Mobs")

ESPTab:CreateToggle({
   Name = "ESP em NPCs",
   CurrentValue = false,
   Callback = function(state)
      getgenv().ESPNPCs = state
   end,
})

-- 🎒 SEÇÃO: Itens e Objetos
ESPTab:CreateSection("🎒 Itens e Objetos")

ESPTab:CreateToggle({
   Name = "ESP em Itens Dropados",
   CurrentValue = false,
   Callback = function(state)
      getgenv().ESPItems = state
   end,
})

ESPTab:CreateToggle({
   Name = "ESP em Baús / Containers",
   CurrentValue = false,
   Callback = function(state)
      getgenv().ESPChests = state
   end,
})

-- 📦 SISTEMA DE RENDERIZAÇÃO (EXEMPLO FUNCIONAL SIMPLES)
local function createESP(part, labelText)
   if part:FindFirstChild("ESPBox") then return end

   local box = Instance.new("BillboardGui", part)
   box.Name = "ESPBox"
   box.Size = UDim2.new(0, 100, 0, 40)
   box.AlwaysOnTop = true
   box.StudsOffset = Vector3.new(0, 2, 0)

   local label = Instance.new("TextLabel", box)
   label.Size = UDim2.new(1, 0, 1, 0)
   label.BackgroundTransparency = 1
   label.Text = labelText
   label.TextColor3 = espColor
   label.TextStrokeTransparency = 0
end

task.spawn(function()
   while task.wait(1) do
      if espEnabled then
         for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
            if plr ~= LocalPlayer and getgenv().ESPPlayers then
               local char = plr.Character
               if char and char:FindFirstChild("HumanoidRootPart") then
                  local dist = (char.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                  if dist <= espDistance then
                     createESP(char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"), plr.Name)
                  end
               end
            end
         end
      end
   end
end)

local AimbotTab = Window:CreateTab("🎯 Aimbot", 6026569809)

AimbotTab:CreateSection("⚙️ Configurações Gerais")

local aimbotEnabled = false
local aimbotSmoothness = 0.1
local aimbotFOV = 100
local aimbotPart = "Head"
local aimbotDistance = 500
local aimbotWhitelist = {}

AimbotTab:CreateToggle({
   Name = "Ativar Aimbot",
   CurrentValue = false,
   Callback = function(v)
      aimbotEnabled = v
   end,
})

AimbotTab:CreateDropdown({
   Name = "Parte do Corpo",
   Options = {"Head", "HumanoidRootPart", "Torso"},
   CurrentOption = "Head",
   Callback = function(opt)
      aimbotPart = opt
   end,
})

AimbotTab:CreateSlider({
   Name = "FOV (Campo de Visão)",
   Range = {20, 300},
   Increment = 10,
   Suffix = " px",
   CurrentValue = 100,
   Callback = function(v)
      aimbotFOV = v
   end,
})

AimbotTab:CreateSlider({
   Name = "Suavidade",
   Range = {0.01, 1},
   Increment = 0.01,
   Suffix = "",
   CurrentValue = 0.1,
   Callback = function(v)
      aimbotSmoothness = v
   end,
})

AimbotTab:CreateSlider({
   Name = "Distância Máxima",
   Range = {50, 2000},
   Increment = 50,
   Suffix = " studs",
   CurrentValue = 500,
   Callback = function(v)
      aimbotDistance = v
   end,
})

AimbotTab:CreateSection("🔒 Whitelist (Ignore jogadores)")

AimbotTab:CreateInput({
   Name = "Nome do Jogador para Whitelist",
   PlaceholderText = "Digite o nome exato",
   RemoveTextAfterFocusLost = true,
   Callback = function(name)
      table.insert(aimbotWhitelist, name)
   end,
})

-- 🎯 Função para encontrar alvo
local function GetClosestTarget()
   local players = game:GetService("Players")
   local localPlayer = players.LocalPlayer
   local character = localPlayer.Character
   if not character or not character:FindFirstChild("HumanoidRootPart") then return end

   local closest
   local shortestDist = math.huge

   for _, plr in ipairs(players:GetPlayers()) do
      if plr ~= localPlayer and not table.find(aimbotWhitelist, plr.Name) then
         local char = plr.Character
         if char and char:FindFirstChild(aimbotPart) then
            local part = char[aimbotPart]
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
            local mag = (part.Position - character.HumanoidRootPart.Position).Magnitude
            if onScreen and dist < aimbotFOV and mag <= aimbotDistance then
               if dist < shortestDist then
                  shortestDist = dist
                  closest = part
               end
            end
         end
      end
   end
   return closest
end

-- 🧠 Aimbot Loop
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local aiming = false

UIS.InputBegan:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton2 then
      aiming = true
   end
end)

UIS.InputEnded:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton2 then
      aiming = false
   end
end)

RunService.RenderStepped:Connect(function()
   if aimbotEnabled and aiming then
      local target = GetClosestTarget()
      if target then
         local current = camera.CFrame.LookVector
         local direction = (target.Position - camera.CFrame.Position).Unit
         local smoothed = current:Lerp(direction, aimbotSmoothness)
         camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + smoothed)
      end
   end
end)

-- === Aba Movement Completa ===

local MovementTab = Window:CreateTab("🏃 Movement", 6026569809)

-- Variáveis internas para controle
local walkspeed_enabled = false
local jumppower_enabled = false
local noclip_enabled = false
local custom_speed = 16
local custom_jump = 50
local noclip_active = false

MovementTab:CreateSection("🚶‍♂️ Velocidade & Pulo")

MovementTab:CreateToggle({
   Name = "Ativar Velocidade Personalizada",
   CurrentValue = false,
   Callback = function(v)
      walkspeed_enabled = v
      if not walkspeed_enabled then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- reset padrão
      end
   end,
})

MovementTab:CreateSlider({
   Name = "Velocidade (WalkSpeed)",
   Range = {16, 200},
   Increment = 2,
   CurrentValue = 16,
   Suffix = " stud/s",
   Callback = function(value)
      custom_speed = value
      if walkspeed_enabled then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = custom_speed
      end
   end,
})

MovementTab:CreateToggle({
   Name = "Ativar Pulo Personalizado",
   CurrentValue = false,
   Callback = function(v)
      jumppower_enabled = v
      if not jumppower_enabled then
         game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50 -- reset padrão
      end
   end,
})

MovementTab:CreateSlider({
   Name = "Força do Pulo (JumpPower)",
   Range = {50, 300},
   Increment = 5,
   CurrentValue = 50,
   Suffix = "",
   Callback = function(value)
      custom_jump = value
      if jumppower_enabled then
         game.Players.LocalPlayer.Character.Humanoid.JumpPower = custom_jump
      end
   end,
})

MovementTab:CreateSection("👻 Noclip")

local noclip_toggle = MovementTab:CreateToggle({
   Name = "Ativar Noclip",
   CurrentValue = false,
   Callback = function(v)
      noclip_enabled = v
      if not noclip_enabled then
         noclip_active = false
      else
         noclip_active = true
      end
   end,
})

MovementTab:CreateKeybind({
   Name = "Tecla Toggle Noclip",
   CurrentKeybind = "N",
   HoldToInteract = false,
   Callback = function()
      noclip_enabled = not noclip_enabled
      noclip_toggle:Toggle(noclip_enabled)
      noclip_active = noclip_enabled
   end,
})

-- Noclip loop
game:GetService("RunService").Stepped:Connect(function()
   if noclip_active then
      local character = game.Players.LocalPlayer.Character
      if character then
         for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide == true then
               part.CanCollide = false
            end
         end
      end
   end
end)

-- Atualiza WalkSpeed e JumpPower constantemente (caso personagem respawne)
game:GetService("RunService").Heartbeat:Connect(function()
   local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
   if humanoid then
      if walkspeed_enabled then
         if humanoid.WalkSpeed ~= custom_speed then
            humanoid.WalkSpeed = custom_speed
         end
      else
         if humanoid.WalkSpeed ~= 16 then
            humanoid.WalkSpeed = 16
         end
      end
      if jumppower_enabled then
         if humanoid.JumpPower ~= custom_jump then
            humanoid.JumpPower = custom_jump
         end
      else
         if humanoid.JumpPower ~= 50 then
            humanoid.JumpPower = 50
         end
      end
   end
end)
