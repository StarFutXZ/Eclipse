local GameScripts = {
    [9534705677] = "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/Sniper_Arena.lua",

    [7326934954] = "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/99%20Nights%20in%20the%20Forest.lua"
}

local ScriptURL = GameScripts[game.GameId]

if not ScriptURL then
    warn("[Eclipse] Este jogo ainda não é suportado!")
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