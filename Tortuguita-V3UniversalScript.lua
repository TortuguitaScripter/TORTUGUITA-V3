-- Carrega Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Configuração da janela
local Window = Rayfield:CreateWindow({
   Name = "TortuguitaHub V3",
   Icon = 12725806138, 
   LoadingTitle = "TortuguitaHub V3 🐢",
   LoadingSubtitle = "by TortuguitaXP_ofc",
   ShowText = "TortugaHub 🐢",
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

local UtilTab = Window:CreateTab("Utilities", 13014530549)

-- 🌐 Sistema
local sysSection = UtilTab:CreateSection("🌐 System")

UtilTab:CreateButton({
	Name = "Anti-AFK",
	Callback = function()
		local vu = game:GetService("VirtualUser")
		game:GetService("Players").LocalPlayer.Idled:Connect(function()
			vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
			wait(1)
			vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		end)
	end,
})

UtilTab:CreateToggle({
	Name = "Boost FPS",
	CurrentValue = false,
	Callback = function(v)
		if v then
			for _, obj in pairs(game:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.Material = Enum.Material.SmoothPlastic
					obj.Reflectance = 0
				elseif obj:IsA("Decal") or obj:IsA("Texture") then
					obj.Transparency = 1
				elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
					obj.Enabled = false
				end
			end
			setfpscap(120)
		end
	end,
})

-- 🧹 Limpeza
local cleanSection = UtilTab:CreateSection("🧹 Cleaning & Lag")

UtilTab:CreateButton({
	Name = "Clear Sounds",
	Callback = function()
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Sound") then
				v:Destroy()
			end
		end
	end,
})

UtilTab:CreateButton({
	Name = "Disable Particles ",
	Callback = function()
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Enabled = false
			end
		end
	end,
})

UtilTab:CreateButton({
	Name = "Remove Explosions ",
	Callback = function()
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("Explosion") then
				obj:Destroy()
			end
		end
	end,
})

-- 🔊 Áudio
local audioSection = UtilTab:CreateSection("🔊 Sounds")

UtilTab:CreateButton({
	Name = "Mute Game Music",
	Callback = function()
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Sound") then
				v.Volume = 0
			end
		end
	end,
})

UtilTab:CreateToggle({
	Name = "Mute Globally (Automatically)",
	CurrentValue = false,
	Callback = function(v)
		getgenv().mutando = v
		while getgenv().mutando do
			task.wait(1)
			for _, s in pairs(workspace:GetDescendants()) do
				if s:IsA("Sound") then
					s.Volume = 0
				end
			end
		end
	end,
})

-- 👁️ Visual
local visualSection = UtilTab:CreateSection("👁️ Visual")

UtilTab:CreateButton({
	Name = "Remover Nevoeiro",
	Callback = function()
		game:GetService("Lighting").FogEnd = 100000
	end,
})

UtilTab:CreateButton({
	Name = "Remover Pós Efeitos",
	Callback = function()
		for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
			if v:IsA("PostEffect") or v:IsA("BlurEffect") then
				v:Destroy()
			end
		end
	end,
})

-- 📡 Rede e Ping
local netSection = UtilTab:CreateSection("📡 Rede & Ping")

UtilTab:CreateButton({
	Name = "Mostrar Ping",
	Callback = function()
		local Stats = game:GetService("Stats")
		local Net = Stats:FindFirstChild("Network")
		if Net then
			print("Ping atual:", math.floor(Net:FindFirstChild("ServerStatsItem")["Data Ping"]:GetValue()))
		else
			warn("Não foi possível obter o ping.")
		end
	end,
})

-- 💻 Execução
local execSection = UtilTab:CreateSection("💻 Execução")

UtilTab:CreateInput({
	Name = "Executar Script",
	PlaceholderText = "Cole script para executar",
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
		loadstring(Value)()
	end,
})

local TabESP = Window:CreateTab("ESP Universal", 4483362458)

-- ==== Section: Controle Geral ====
local SectionGeneral = TabESP:CreateSection("Controle Geral")

local espEnabled = false
local espBoxesEnabled = true
local espNamesEnabled = true
local espDistanceEnabled = true

SectionGeneral:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Callback = function(val)
        espEnabled = val
        if not espEnabled then
            -- Remove tudo
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local espFolder = head:FindFirstChild("ESPFolder")
                        if espFolder then
                            espFolder:Destroy()
                        end
                    end
                end
            end
        end
    end
})

SectionGeneral:CreateToggle({
    Name = "Mostrar Boxes",
    CurrentValue = true,
    Callback = function(val) espBoxesEnabled = val end
})

SectionGeneral:CreateToggle({
    Name = "Mostrar Nome",
    CurrentValue = true,
    Callback = function(val) espNamesEnabled = val end
})

SectionGeneral:CreateToggle({
    Name = "Mostrar Distância",
    CurrentValue = true,
    Callback = function(val) espDistanceEnabled = val end
})

-- ==== Section: Aparência ====
local SectionVisuals = TabESP:CreateSection("Aparência")

local boxColor = Color3.fromRGB(0, 255, 0)
local nameColor = Color3.fromRGB(255, 255, 255)
local distanceColor = Color3.fromRGB(255, 255, 0)
local transparency = 0.4
local boxThickness = 1

SectionVisuals:CreateColorPicker({
    Name = "Cor das Boxes",
    Color = boxColor,
    Callback = function(color) boxColor = color end
})

SectionVisuals:CreateColorPicker({
    Name = "Cor dos Nomes",
    Color = nameColor,
    Callback = function(color) nameColor = color end
})

SectionVisuals:CreateColorPicker({
    Name = "Cor da Distância",
    Color = distanceColor,
    Callback = function(color) distanceColor = color end
})

SectionVisuals:CreateSlider({
    Name = "Transparência das Boxes",
    Range = {0, 1},
    Increment = 0.05,
    CurrentValue = transparency,
    Callback = function(val) transparency = val end
})

SectionVisuals:CreateSlider({
    Name = "Espessura das Boxes",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = boxThickness,
    Callback = function(val) boxThickness = val end
})

-- ==== Section: Configurações Avançadas ====
local SectionAdvanced = TabESP:CreateSection("Configurações Avançadas")

local updateRate = 0.1 -- segundos entre atualizações do ESP

SectionAdvanced:CreateSlider({
    Name = "Taxa de Atualização (segundos)",
    Range = {0.05, 1},
    Increment = 0.05,
    CurrentValue = updateRate,
    Callback = function(val) updateRate = val end
})

-- Função para criar ESP para cada player
local function CreateESPForPlayer(player)
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end

    local espFolder = head:FindFirstChild("ESPFolder")
    if espFolder then espFolder:Destroy() end

    espFolder = Instance.new("Folder")
    espFolder.Name = "ESPFolder"
    espFolder.Parent = head

    -- Box (BoxHandleAdornment)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "Box"
    box.Adornee = head
    box.Size = Vector3.new(2, 5, 1)
    box.Color3 = boxColor
    box.AlwaysOnTop = true
    box.Transparency = transparency
    box.ZIndex = 5
    box.Parent = espFolder

    -- Nome (BillboardGui)
    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Name = "NameTag"
    nameBillboard.Adornee = head
    nameBillboard.AlwaysOnTop = true
    nameBillboard.Size = UDim2.new(0, 100, 0, 30)
    nameBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
    nameBillboard.Parent = espFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = nameColor
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 18
    nameLabel.Text = player.Name
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.Parent = nameBillboard

    -- Distância (BillboardGui)
    local distBillboard = Instance.new("BillboardGui")
    distBillboard.Name = "DistanceTag"
    distBillboard.Adornee = head
    distBillboard.AlwaysOnTop = true
    distBillboard.Size = UDim2.new(0, 100, 0, 20)
    distBillboard.StudsOffset = Vector3.new(0, 1.5, 0)
    distBillboard.Parent = espFolder

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = distanceColor
    distLabel.TextStrokeTransparency = 0.5
    distLabel.Font = Enum.Font.SourceSans
    distLabel.TextSize = 14
    distLabel.Text = ""
    distLabel.Parent = distBillboard
end

-- Atualiza as propriedades visuais dos ESPs
local function UpdateESPVisuals(player)
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    local espFolder = head:FindFirstChild("ESPFolder")
    if not espFolder then return end

    local box = espFolder:FindFirstChild("Box")
    local nameBillboard = espFolder:FindFirstChild("NameTag")
    local distBillboard = espFolder:FindFirstChild("DistanceTag")

    if box then
        box.Color3 = boxColor
        box.Transparency = transparency
        box.Adornee = head
        box.Size = Vector3.new(2, 5, 1)
        box.ZIndex = 5
        box.AlwaysOnTop = true
        box.LineThickness = boxThickness -- OBS: BoxHandleAdornment não tem LineThickness, mas deixei para ideia visual
    end

    if nameBillboard and nameBillboard:FindFirstChild("NameLabel") then
        nameBillboard.NameLabel.TextColor3 = nameColor
        nameBillboard.Adornee = head
        nameBillboard.StudsOffset = Vector3.new(0, 2.5, 0)
    end

    if distBillboard and distBillboard:FindFirstChild("DistLabel") then
        distBillboard.DistLabel.TextColor3 = distanceColor
        distBillboard.Adornee = head
        distBillboard.StudsOffset = Vector3.new(0, 1.5, 0)
    end
end

-- Atualiza o texto da distância
local function UpdateDistance(player)
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    local espFolder = head:FindFirstChild("ESPFolder")
    if not espFolder then return end
    local distBillboard = espFolder:FindFirstChild("DistanceTag")
    if not distBillboard or not distBillboard:FindFirstChild("DistLabel") then return end

    local localChar = game.Players.LocalPlayer.Character
    if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then return end

    local distance = (localChar.HumanoidRootPart.Position - head.Position).Magnitude
    distBillboard.DistLabel.Text = string.format("Dist: %.1f", distance)
end

-- Atualiza visibilidade dos elementos
local function UpdateVisibility(player)
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    local espFolder = head:FindFirstChild("ESPFolder")
    if not espFolder then return end

    local box = espFolder:FindFirstChild("Box")
    local nameBillboard = espFolder:FindFirstChild("NameTag")
    local distBillboard = espFolder:FindFirstChild("DistanceTag")

    if box then box.Visible = espBoxesEnabled and espEnabled end
    if nameBillboard then nameBillboard.Enabled = espNamesEnabled and espEnabled end
    if distBillboard then distBillboard.Enabled = espDistanceEnabled and espEnabled end
end

-- Main ESP update loop
spawn(function()
    while true do
        if espEnabled then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    if player.Character and player.Character:FindFirstChild("Head") then
                        if not player.Character.Head:FindFirstChild("ESPFolder") then
                            CreateESPForPlayer(player)
                        else
                            UpdateESPVisuals(player)
                        end
                        UpdateDistance(player)
                        UpdateVisibility(player)
                    end
                end
            end
        end
        wait(updateRate)
    end
end)

-- Atualiza ESP para novos jogadores que entrarem
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- espera carregar a character
        if espEnabled and player ~= game.Players.LocalPlayer then
            CreateESPForPlayer(player)
        end
    end)
end)

print("[ESP] Script ESP Universal carregado com sucesso")

-- === Aba Movement Completa ===

local MovementTab = Window:CreateTab("🏃 Movement", nil)

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
