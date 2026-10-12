local GameScripts = {
    [10768172922] = "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/Sniper_Arena.lua"
}

-- Pega o link correspondente ao jogo
local ScriptURL = GameScripts[game.GameId]

if not ScriptURL then
    warn("[Eclipse] Este jogo ainda não é suportado! GameId: " .. tostring(game.GameId))
    return
end

-- Função para descarregar o código com suporte a múltiplos executores
local function descarregarCodigo(url)
    local sucesso, resultado = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if sucesso and resultado and #resultado > 0 then
        return resultado
    end

    -- Fallback para executores mobile que bloqueiam game:HttpGet
    local req = (syn and syn.request) or (http and http.request) or request or http_request
    if type(req) == "function" then
        local resp = req({Url = url, Method = "GET"})
        if resp and (resp.Body or resp.body) then
            return resp.Body or resp.body
        end
    end
    
    return nil
end

-- Execução segura
task.spawn(function()
    local conteudoScript = descarregarCodigo(ScriptURL)
    
    if not conteudoScript then
        warn("[Eclipse] Não foi possível baixar o script do GitHub.")
        return
    end

    local Execute, ErroCompilacao = loadstring(conteudoScript)
    if not Execute then
        warn("[Eclipse] Erro de compilação: " .. tostring(ErroCompilacao))
        return
    end

    local Sucesso, ErroExecucao = pcall(Execute)
    if not Sucesso then
        warn("[Eclipse] Erro ao executar: " .. tostring(ErroExecucao))
    end
end)
