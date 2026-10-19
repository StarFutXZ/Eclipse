
local SniperArena = "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/Sniper_Arena.lua"
local Rivals = "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/Rivals.lua"
local StealAnEgg = "https://raw.githubusercontent.com/tienkhanh1/Chilli-Hub-Script/refs/heads/main/StealAnEgg"
local MurderMystery2 = "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/Murder%20Mystery%202.lua"
local DeadRails = "loadstring(game:HttpGet("https://darahub.pages.dev/api/script/Darahub-DeadRail/Lobby.lua"))()"
local Nights99 = "https://raw.githubusercontent.com/StarFutXZ/Eclipse/refs/heads/main/99%20Nights%20in%20the%20Forest.lua"

local byGameId = {
    [9534705677]  = SniperArena,
    [6035872082]  = Rivals,
    [10563114921] = StealAnEgg,
    [66654135]    = MurderMystery2,
    [7018190066]  = DeadRails,
    [1686885941]  = Nights99,
}

-- Identify the current experience
local gameId = game.GameId
local url = byGameId[gameId]

if not url then
    warn("Eclipse: unsupported game. GameId:", gameId)
    return
end

-- Fetch the selected script
local requestOk, source = pcall(function()
    return game:HttpGet(url)
end)

if not requestOk or type(source) ~= "string" or source == "" then
    warn("Eclipse: failed to fetch the script.")
    return
end

-- Compile the downloaded source
if type(loadstring) ~= "function" then
    warn("Eclipse: loadstring is unavailable in this environment.")
    return
end

local compileOk, chunk = pcall(loadstring, source)

if not compileOk or type(chunk) ~= "function" then
    warn("Eclipse: failed to compile the script.")
    return
end

-- Execute the selected script
local runOk, err = pcall(chunk)

if not runOk then
    warn("Eclipse: script execution failed:", err)
end
