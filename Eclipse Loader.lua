-- Eclipse Loader — Diagnóstico Visual para Mobile
local UNIVERSE_ID_ESPERADO = 10768172922
local SCRIPT_URL = "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/Sniper_Arena.lua"

-- Cria uma caixinha temporária no ecrã para sabermos que o script arrancou
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EclipseTest"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not screenGui.Parent then screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

local label = Instance.new("TextLabel", screenGui)
label.Size = UDim2.new(0, 300, 0, 50)
label.Position = UDim2.new(0.5, -150, 0.1, 0)
label.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 14
label.Font = Enum.Font.GothamBold
label.Text = "Eclipse: A verificar o jogo..."
Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)

-- Validação do Universe ID
task.wait(0.5)
if game.GameId ~= UNIVERSE_ID_ESPERADO then
    label.Text = "Erro: Jogo incorreto! (ID: " .. tostring(game.GameId) .. ")"
    label.TextColor3 = Color3.fromRGB(255, 80, 80)
    task.wait(4)
    screenGui:Destroy()
    return
end

label.Text = "Eclipse: Jogo correto! A descarregar..."

-- Tentativa de descarregar e executar o script
local sucesso, codigo = pcall(function()
    return game:HttpGet(SCRIPT_URL)
end)

if not sucesso or not codigo then
    label.Text = "Erro: Falha ao descarregar do GitHub!"
    label.TextColor3 = Color3.fromRGB(255, 80, 80)
    task.wait(4)
    screenGui:Destroy()
    return
end

local funcao, erroCompilacao = loadstring(codigo)
if not funcao then
    label.Text = "Erro: Erro de compilação no script!"
    label.TextColor3 = Color3.fromRGB(255, 80, 80)
    task.wait(4)
    screenGui:Destroy()
    return
end

label.Text = "Sucesso! A iniciar o Eclipse..."
label.TextColor3 = Color3.fromRGB(80, 255, 120)
task.wait(1)
screenGui:Destroy()

-- Executa o script principal
local executou, erroExecucao = pcall(funcao)
if not executou then
    warn("[Eclipse] Erro na execução do script: " .. tostring(erroExecucao))
end
