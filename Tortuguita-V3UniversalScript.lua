-- Carrega Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Configuração da janela
local Window = Rayfield:CreateWindow({
   Name = "TortuguitaHub V3",
   Icon = "rbxassetid://12725806138", 
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

-- Biblioteca ESP base
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/zzerexx/scripts/main/esp.lua"))()
ESP.Enabled = false
ESP.TeamCheck = false -- Desative se quiser ver inimigos apenas
ESP.Boxes = true
ESP.Names = true
ESP.Tracers = false
ESP.Distance = false
ESP.Health = false
ESP.Color = Color3.fromRGB(0, 170, 255)
ESP.Thickness = 2
ESP.Range = math.huge

-- UI - Aba ESP com sections
local Tab = Window:CreateTab("📦 ESP", 4483362458)

local SectionMain = Tab:CreateSection("🎯 ESP Principal")

Tab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Callback = function(Value)
        ESP.Enabled = Value
    end,
})

Tab:CreateToggle({
    Name = "Caixas (Boxes)",
    CurrentValue = true,
    Callback = function(Value)
        ESP.Boxes = Value
    end,
})

Tab:CreateToggle({
    Name = "Nomes dos Players",
    CurrentValue = true,
    Callback = function(Value)
        ESP.Names = Value
    end,
})

Tab:CreateToggle({
    Name = "Tracers (Linhas)",
    CurrentValue = false,
    Callback = function(Value)
        ESP.Tracers = Value
    end,
})

Tab:CreateToggle({
    Name = "Mostrar Distância",
    CurrentValue = false,
    Callback = function(Value)
        ESP.Distance = Value
    end,
})

Tab:CreateToggle({
    Name = "Health Bar",
    CurrentValue = false,
    Callback = function(Value)
        ESP.Health = Value
    end,
})

local SectionVisual = Tab:CreateSection("🎨 Visual")

Tab:CreateColorPicker({
    Name = "Cor do ESP",
    Color = Color3.fromRGB(0, 170, 255),
    Callback = function(Value)
        ESP.Color = Value
    end,
})

Tab:CreateSlider({
    Name = "Espessura (Thickness)",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 2,
    Callback = function(Value)
        ESP.Thickness = Value
    end,
})

Tab:CreateSlider({
    Name = "Alcance Máximo (Range)",
    Range = {100, 3000},
    Increment = 50,
    CurrentValue = 3000,
    Callback = function(Value)
        ESP.Range = Value
    end,
})

local SectionFilters = Tab:CreateSection("⚙️ Filtros")

Tab:CreateToggle({
    Name = "Team Check (só inimigos)",
    CurrentValue = false,
    Callback = function(Value)
        ESP.TeamCheck = Value
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
