-- Eclipse Loader — RoFront (Com Interface Gráfica e Universe ID)
local UNIVERSE_ID_ESPERADO = 10768172922 -- Universe ID do RoFront
local SCRIPT_URL = "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/Sniper_Arena.lua" -- O teu link do GitHub Raw

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local env = (typeof(getgenv) == "function" and getgenv()) or _G
if env.ECLIPSE_LOADING then return end

-- Valida se estás no universo correto
if game.GameId ~= UNIVERSE_ID_ESPERADO then
    return -- Para silenciosamente se estiveres noutro jogo
end

env.ECLIPSE_LOADING = true

-- Cria a Janela Visual do Loader (Interface)
local gui = Instance.new("ScreenGui")
gui.Name = "EclipseLoader"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = player:WaitForChild("PlayerGui") end

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(340, 150)
frame.Position = UDim2.new(0.5, -170, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 36)
title.Position = UDim2.fromOffset(10, 12)
title.BackgroundTransparency = 1
title.Text = "ECLIPSE | ROFRONT"
title.TextColor3 = Color3.fromRGB(160, 130, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 17

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -24, 0, 40)
status.Position = UDim2.fromOffset(12, 60)
status.BackgroundTransparency = 1
status.Text = "A carregar o script..."
status.TextColor3 = Color3.fromRGB(185, 185, 200)
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextWrapped = true

-- Carrega e executa o script externo automaticamente
task.spawn(function()
    if type(loadstring) ~= "function" then
        status.Text = "Erro: Executor não suporta loadstring."
        env.ECLIPSE_LOADING = nil
        return
    end

    local sucesso, codigo = pcall(function()
        return game:HttpGet(SCRIPT_URL)
    end)

    if not sucesso then
        status.Text = "Erro ao descarregar o script."
        env.ECLIPSE_LOADING = nil
        return
    end

    local chunk, erroCompilacao = loadstring(codigo)
    if not chunk then
        status.Text = "Erro de compilação no script."
        env.ECLIPSE_LOADING = nil
        return
    end

    status.Text = "Sucesso! A iniciar..."
    task.wait(0.8)
    gui:Destroy()
    env.ECLIPSE_LOADING = nil

    local rodou, erroExecucao = pcall(chunk)
    if not rodou then
        warn("[Eclipse] Erro ao executar: " + tostring(erroExecucao))
    end
end)
