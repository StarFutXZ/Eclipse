-- Eclipse Loader — RoFront (Versão Simples com Universe ID)
local UNIVERSE_ID_ESPERADO = 10768172922 -- Universe ID do RoFront
local SCRIPT_URL = "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/Sniper_Arena.lua" -- O teu link do GitHub Raw

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local env = (typeof(getgenv) == "function" and getgenv()) or _G
if env.ECLIPSE_LOADING then return end

-- Valida diretamente se estás no universo correto (funciona no jogo principal e em qualquer sub-lugar)
if game.GameId ~= UNIVERSE_ID_ESPERADO then
    return -- Para silenciosamente se estiveres noutro jogo
end

env.ECLIPSE_LOADING = true

-- Carrega e executa o teu script principal
task.spawn(function()
    if type(loadstring) ~= "function" then
        warn("[Eclipse] Este executor não suporta loadstring.")
        env.ECLIPSE_LOADING = nil
        return
    end

    local sucesso, codigo = pcall(function()
        return game:HttpGet(SCRIPT_URL)
    end)

    if not sucesso then
        warn("[Eclipse] Falha ao descarregar o script: " .. tostring(codigo))
        env.ECLIPSE_LOADING = nil
        return
    end

    local chunk, erroCompilacao = loadstring(codigo)
    if not chunk then
        warn("[Eclipse] Erro de compilação: " .. tostring(erroCompilacao))
        env.ECLIPSE_LOADING = nil
        return
    end

    local rodou, erroExecucao = pcall(chunk)
    if not rodou then
        warn("[Eclipse] Erro ao executar o script: " .. tostring(erroExecucao))
        env.ECLIPSE_LOADING = nil
    end
end)
