local GameScripts = {
    [122446657157717] =
        "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/Sniper_Arena.lua",
}

local ScriptURL = GameScripts[game.PlaceId]

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
