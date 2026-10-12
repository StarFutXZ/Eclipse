local GameScripts = {
    [10768172922] = "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/Sniper_Arena.lua"
}

-- Aguarda até que o jogo e o GameId estejam totalmente carregados (evita falhas de início)
local ScriptURL = nil
repeat
    ScriptURL = GameScripts[game.GameId]
    if not ScriptURL and (game.GameId == nil or game.GameId == 0) then
        task.wait(0.5) -- Espera meio segundo e tenta de novo se o ID ainda não carregou
    else
        break
    end
until game.GameId ~= 0 and game.GameId ~= nil

-- Se mesmo após carregar não encontrar o ID na lista
if not ScriptURL then
    warn("[Eclipse] Este jogo ainda não é suportado! GameId atual: " .. tostring(game.GameId))
    return
end

local Success, ErrorMessage = pcall(function()
    local Source = game:HttpGet(ScriptURL)
    local Execute = loadstring(Source)
    
    assert(Execute, "Não foi possível carregar o script")
    Execute()
end)

if not Success then
    warn("[Eclipse] Erro: " .. tostring(ErrorMessage))
end
