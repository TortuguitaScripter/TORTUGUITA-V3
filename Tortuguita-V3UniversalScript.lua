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
