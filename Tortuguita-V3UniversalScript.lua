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

local UtilTab = Window:CreateTab("⚙️ Utilitários", 13014530549)

-- 🌐 Sistema
local sysSection = UtilTab:CreateSection("🌐 Sistema")

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
	Name = "Boost de FPS",
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
local cleanSection = UtilTab:CreateSection("🧹 Limpeza & Lag")

UtilTab:CreateButton({
	Name = "Limpar Sons",
	Callback = function()
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Sound") then
				v:Destroy()
			end
		end
	end,
})

UtilTab:CreateButton({
	Name = "Desativar Partículas",
	Callback = function()
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Enabled = false
			end
		end
	end,
})

UtilTab:CreateButton({
	Name = "Remover Explosões",
	Callback = function()
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("Explosion") then
				obj:Destroy()
			end
		end
	end,
})

-- 🔊 Áudio
local audioSection = UtilTab:CreateSection("🔊 Áudio")

UtilTab:CreateButton({
	Name = "Mutar Música do Jogo",
	Callback = function()
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("Sound") then
				v.Volume = 0
			end
		end
	end,
})

UtilTab:CreateToggle({
	Name = "Mute global (automaticamente)",
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

local espTab = Window:CreateTab("🧿 ESP", 13014530549)

-- 📌 ESP: Players
local playerSection = espTab:CreateSection("👥 Jogadores")

espTab:CreateToggle({
	Name = "Ativar ESP de Jogadores",
	CurrentValue = false,
	Callback = function(v)
		getgenv().espPlayersEnabled = v
	end,
})

espTab:CreateDropdown({
	Name = "Tipo de ESP",
	Options = {"Box", "Tracers", "Name", "HealthBar"},
	CurrentOption = "Box",
	Callback = function(option)
		getgenv().espMode = option
	end,
})

espTab:CreateColorPicker({
	Name = "Cor do ESP",
	Color = Color3.fromRGB(0, 255, 0),
	Callback = function(cor)
		getgenv().espColor = cor
	end,
})

espTab:CreateSlider({
	Name = "Distância Máxima",
	Range = {100, 2000},
	Increment = 50,
	CurrentValue = 1000,
	Callback = function(valor)
		getgenv().espMaxDistance = valor
	end,
})

espTab:CreateToggle({
	Name = "Mostrar apenas inimigos",
	CurrentValue = false,
	Callback = function(v)
		getgenv().espEnemiesOnly = v
	end,
})

-- 💾 ESP: Items
local itemSection = espTab:CreateSection("📦 Itens e Loot")

espTab:CreateToggle({
	Name = "ESP de Itens",
	CurrentValue = false,
	Callback = function(v)
		getgenv().espItems = v
	end,
})

espTab:CreateDropdown({
	Name = "Tipo de Itens",
	Options = {"Armas", "Poções", "Todos"},
	CurrentOption = "Todos",
	Callback = function(op)
		getgenv().itemFilter = op
	end,
})

-- 🧟‍♂️ ESP: NPCs e Mobs
local mobSection = espTab:CreateSection("🧟 NPCs / Mobs")

espTab:CreateToggle({
	Name = "ESP de NPCs/Mobs",
	CurrentValue = false,
	Callback = function(v)
		getgenv().espMobs = v
	end,
})

espTab:CreateDropdown({
	Name = "Tipo de Mob",
	Options = {"Todos", "Hostis", "Neutros"},
	CurrentOption = "Todos",
	Callback = function(tipo)
		getgenv().mobFilter = tipo
	end,
})

espTab:CreateColorPicker({
	Name = "Cor dos NPCs",
	Color = Color3.fromRGB(255, 0, 0),
	Callback = function(cor)
		getgenv().mobColor = cor
	end,
})

-- 👁️ Ativação geral (loop)
if not getgenv().espLoaded then
	getgenv().espLoaded = true
	getgenv().espLoop = task.spawn(function()
		while task.wait(1) do
			if getgenv().espPlayersEnabled then
				for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
					if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
						local hrp = plr.Character.HumanoidRootPart
						local dist = (hrp.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
						if dist <= (getgenv().espMaxDistance or 1000) then
							if getgenv().espEnemiesOnly then
								-- coloque aqui lógica de time, se existir
							end
							-- Aqui renderiza a ESP do tipo selecionado (Name, Box, etc)
							-- Isso depende de Drawing API de seu executor ou lib específica (como chamando uma ESP externa)
						end
					end
				end
			end
		end
	end)
end

local aimbotTab = Window:CreateTab("🎯 Aimbot", 13014530549)

-- 📌 SECTION: Silent Aim
aimbotTab:CreateSection("🤫 Silent Aim")

aimbotTab:CreateToggle({
	Name = "Ativar Silent Aim",
	CurrentValue = false,
	Callback = function(v)
		getgenv().silentAim = v
	end,
})

aimbotTab:CreateDropdown({
	Name = "Whitelist (Players que não serão atingidos)",
	Options = {"Nenhum", "Amigo1", "Amigo2"},
	CurrentOption = "Nenhum",
	Callback = function(plr)
		getgenv().aimWhitelist = plr
	end,
})

aimbotTab:CreateDropdown({
	Name = "Parte do corpo para mirar (Silent)",
	Options = {"Head", "Torso", "HumanoidRootPart"},
	CurrentOption = "Head",
	Callback = function(part)
		getgenv().silentAimTargetPart = part
	end,
})

-- 📌 SECTION: Aimbot (Legit)
aimbotTab:CreateSection("🎯 Aimbot Tradicional")

aimbotTab:CreateToggle({
	Name = "Ativar Aimbot",
	CurrentValue = false,
	Callback = function(v)
		getgenv().legitAimbot = v
	end,
})

aimbotTab:CreateKeybind({
	Name = "Tecla para Ativar Mira",
	CurrentKeybind = "Q",
	Callback = function(k)
		getgenv().aimKey = k
	end,
})

aimbotTab:CreateSlider({
	Name = "FOV (Raio de mira)",
	Range = {20, 300},
	Increment = 5,
	CurrentValue = 120,
	Callback = function(v)
		getgenv().aimFOV = v
	end,
})

aimbotTab:CreateToggle({
	Name = "Apenas quando visível",
	CurrentValue = true,
	Callback = function(v)
		getgenv().aimVisibilityCheck = v
	end,
})

aimbotTab:CreateDropdown({
	Name = "Parte do corpo para mirar (Aimbot)",
	Options = {"Head", "Torso", "HumanoidRootPart"},
	CurrentOption = "HumanoidRootPart",
	Callback = function(part)
		getgenv().aimPart = part
	end,
})

aimbotTab:CreateToggle({
	Name = "Mira Suave (Smooth)",
	CurrentValue = true,
	Callback = function(v)
		getgenv().smoothAiming = v
	end,
})

aimbotTab:CreateSlider({
	Name = "Velocidade da Mira Suave",
	Range = {1, 20},
	Increment = 1,
	CurrentValue = 8,
	Callback = function(v)
		getgenv().smoothSpeed = v
	end,
})

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
