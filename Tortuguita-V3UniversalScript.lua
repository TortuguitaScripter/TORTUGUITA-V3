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

local ESPtab = Window:CreateTab("📦 ESP", 4483362458)

-- 📌 Seção: Geral
ESPtab:CreateSection("🎯 Geral")

ESPtab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Enabled = Value
    end,
})

ESPtab:CreateToggle({
    Name = "Caixas (Box ESP)",
    CurrentValue = true,
    Callback = function(Value)
        Settings.Boxes = Value
    end,
})

ESPtab:CreateToggle({
    Name = "Mostrar Nomes",
    CurrentValue = true,
    Callback = function(Value)
        Settings.Names = Value
    end,
})

ESPtab:CreateToggle({
    Name = "Mostrar Distância",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Distance = Value
    end,
})

ESPtab:CreateToggle({
    Name = "Tracers (Linhas)",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Tracers = Value
    end,
})

ESPtab:CreateToggle({
    Name = "Health Bar",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Health = Value
    end,
})

-- 📌 Seção: Visual
ESPtab:CreateSection("🎨 Visual")

ESPtab:CreateColorPicker({
    Name = "Cor do ESP",
    Color = Color3.fromRGB(0, 170, 255),
    Callback = function(Value)
        Settings.Color = Value
    end,
})

ESPtab:CreateSlider({
    Name = "Espessura (Thickness)",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 2,
    Callback = function(Value)
        Settings.Thickness = Value
    end,
})

ESPtab:CreateSlider({
    Name = "Alcance Máximo (Range)",
    Range = {100, 3000},
    Increment = 50,
    CurrentValue = 3000,
    Callback = function(Value)
        Settings.Range = Value
    end,
})

-- 📌 Seção: Filtros e Utilitários
ESPtab:CreateSection("⚙️ Filtros & Utilitários")

ESPtab:CreateToggle({
    Name = "Team Check (inimigos apenas)",
    CurrentValue = false,
    Callback = function(Value)
        Settings.TeamCheck = Value
    end,
})

ESPtab:CreateDropdown({
    Name = "Modo de ESP",
    Options = {"Todos", "Jogadores", "NPCs"},
    CurrentOption = "Todos",
    Callback = function(Value)
        Settings.TargetMode = Value
    end,
})

ESPtab:CreateButton({
    Name = "Recarregar ESP Manualmente",
    Callback = function()
        ReloadESP() -- você define essa função
    end,
})
