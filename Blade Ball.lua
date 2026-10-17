local __modules, __cache, __loading = {}, {}, {}
local function use(name)
    local cached = __cache[name]
    if cached ~= nil then
        return cached
    end
    local loader = __modules[name]
    if not loader then
        error("Slopix: no module named " .. tostring(name), 2)
    end
    if __loading[name] then
        error("Slopix: circular use of " .. tostring(name), 2)
    end
    __loading[name] = true
    -- A module that errors is unmarked, so the next use() reports its error, not a cycle.
    local trace = debug and type(debug.traceback) == 'function' and debug.traceback or tostring
    local ok, result = xpcall(loader, trace, use)
    __loading[name] = nil
    if not ok then
        error(result, 0)
    end
    if result == nil then
        result = true
    end
    __cache[name] = result
    return result
end
__modules["core/env"] = function(use) -- src/games/ballvsball/core/env.luau
-- Ball VS Ball: the game's own ModuleScripts and remotes. Everything else (services, the executor,
-- elevate) comes from shared/env.
--
-- Remotes use sleitnick Net names. Resolve their instances under Packages without invoking
-- the module loader while resolving a replicated event or function.

local Env = use("shared/env")

Env.checkMissing({
    { "queue_on_teleport", Env.queueOnTeleport },
    { "setclipboard", Env.setClipboard },
})
for name, _ in pairs({ readfile = true, writefile = true, isfile = true, isfolder = true,
    makefolder = true, listfiles = true, delfile = true }) do
    Env.checkMissing({ { name, Env.files[name] } })
end
table.sort(Env.missing)

local RS = Env.ReplicatedStorage
local SERVICE = { "Engine", "Service" }
local function service(name)
    return { SERVICE[1], SERVICE[2], name }
end

-- Env.loadModule("Config"), Env.loadModule("PlayerData"), ...: required on first use and cached.
Env.Game, Env.loadModule = Env.modules(RS, {
    Net = { "Packages", "Net" },
    Config = service("Config"), -- the game's CloudConfig: balls, codes, quests, crates, limits
    PlayerData = service("PlayerData"),
    ExperienceService = service("ExperienceService"),
    TimeService = service("TimeService"),
    GameModeRegistry = service("GameModeRegistry"),
    CheckInService = service("CheckInService"),
    OnlineRewardConfig = service("OnlineRewardConfig"),
    StatsCore = { "Engine", "Service", "BallBattleStatsService", "Core" },
    BattleConfig = { "BattleDemo", "BattleConfig" },
    BattleSimulation = { "BattleDemo", "BattleSimulation" },
    ArenaOverride = { "BattleDemo", "ArenaOverride" },
})

local remotes = {}
local CONSTRUCTORS = { event = "RemoteEvent", unreliable = "UnreliableRemoteEvent", fn = "RemoteFunction" }
local PREFIX = { event = "RE/", unreliable = "URE/", fn = "RF/" }
local function remote(kind, name)
    Env.elevate()
    local key = kind .. name
    if not remotes[key] or not remotes[key].Parent then
        -- Locate the replicated instance without requiring Net in a lazy-table lookup;
        -- matching the class avoids an event/function mixup.
        local packages = Env.need(RS, "Packages", 10)
        local found = packages:FindFirstChild(PREFIX[kind] .. name, true)
        local deadline = os.clock() + 5
        while not found and os.clock() < deadline do
            task.wait(0.1)
            found = packages:FindFirstChild(PREFIX[kind] .. name, true)
        end
        Env.elevate()
        if not found then
            error("Slopix: remote " .. name .. " is not available yet", 2)
        end
        assert(found:IsA(CONSTRUCTORS[kind]), "Slopix: remote " .. name .. " has an unexpected class")
        remotes[key] = found
    end
    return remotes[key]
end

-- The RemoteEvent the game calls `name` ("DuelTableState").
function Env.event(name)
    return remote("event", name)
end

-- The UnreliableRemoteEvent the game calls `name` ("DuelTableAimPreview").
function Env.unreliable(name)
    return remote("unreliable", name)
end

local pending, retryAt = {}, {}
Env.requestIssues = {}

-- A timeout cannot undo a server action. Keep that remote occupied until its original call
-- finishes, then allow replication time before another request. Never retry inside this helper.
function Env.invoke(name, ...)
    if Env.stopped then return false, "hub unloaded" end
    if pending[name] or os.clock() < (retryAt[name] or 0) then
        return false, "waiting for the previous " .. name .. " request"
    end
    local work, args = {}, table.pack(...)
    pending[name] = work
    task.spawn(function()
        work.result = table.pack(Env.call(function()
            local fn = remote("fn", name)
            return fn:InvokeServer(table.unpack(args, 1, args.n))
        end))
        work.done = true
        if work.timedOut then
            retryAt[name] = os.clock() + 30
            Env.requestIssues[name] = "Late reply received; waiting for inventory/balance updates."
            local untilAt = retryAt[name]
            task.delay(30, function()
                if retryAt[name] == untilAt then Env.requestIssues[name] = nil end
            end)
        end
        if pending[name] == work then pending[name] = nil end
    end)
    local deadline = os.clock() + 15
    while not work.done and not Env.stopped and os.clock() < deadline do task.wait(0.05) end
    Env.elevate()
    if Env.stopped then return false, "hub unloaded" end
    if not work.done then
        work.timedOut = true
        Env.requestIssues[name] = "No reply yet; duplicate requests are paused."
        return false, "request timed out; its result is not yet known"
    end
    Env.requestIssues[name] = nil
    return table.unpack(work.result, 1, work.result.n)
end

-- The local player's saved data as the game's client sees it: Env.data("coins") -> 490.
-- Nil when the value is not there (yet).
function Env.data(key)
    local ok, value = Env.call(function()
        return Env.loadModule("PlayerData").client[key]()
    end)
    if ok then return value end
    return nil
end

-- A ball's English name (roleIds are the game's Chinese ids, e.g. "刀片球" -> "Blade Ball").
function Env.ballName(roleId)
    local ok, ball = pcall(function()
        return Env.loadModule("Config").ball.byCnId[roleId]
    end)
    return ok and ball and ball.displayName or tostring(roleId)
end

return Env
end
__modules["core/fusion"] = function(use) -- src/games/ballvsball/core/fusion.luau
-- October 2026: rarity fusion takes ten Classic balls; form fusion takes six matching copies.
-- Keep tradeability groups separate so automatic fusion cannot bind a tradable copy's result.
local Env = use("core/env")
local Fusion = {}

function Fusion.requiredCount(mode)
    if mode == nil or mode == "Higher rarity" then
        return 10
    elseif mode == "Shiny" or mode == "Rainbow" then
        return 6
    end
end

function Fusion.kind(item)
    if item.serial ~= nil then
        return "Rainbow"
    end
    local kills
    if type(item.metadata) == "table" then
        kills = item.metadata.killCount
    end
    if kills == nil then
        kills = item.killCount
    end
    if kills == nil then
        return "Classic"
    end
    if type(kills) == "number" and kills >= 0 and kills < math.huge and kills % 1 == 0 then
        return "Shiny"
    end
    return nil -- malformed kill metadata must not turn a special copy into a Classic material
end

function Fusion.nextBatch(items, equipment, maxRating, reserved, allowedBall, mode)
    mode = mode or "Higher rarity"
    local required = Fusion.requiredCount(mode)
    if not required then
        return nil
    end
    reserved = reserved or {}
    local materialKind = mode == "Rainbow" and "Shiny" or "Classic"
    local equipped = {}
    for _, value in pairs(type(equipment) == "table" and equipment or {}) do
        local id = type(value) == "table" and (value.id or value.instanceId) or value
        if type(id) == "string" then
            equipped[id] = true
        end
    end
    local groups = {}
    for id, item in pairs(type(items) == "table" and items or {}) do
        if type(id) == "string" and type(item) == "table" and item.itemType == "Ball"
            and type(item.itemId) == "string" and item.ownerUserId == Env.LocalPlayer.UserId
            and Fusion.kind(item) == materialKind and (mode ~= "Higher rarity" or item.canFusion == true)
            and not equipped[id] and not reserved[id]
            and (item.locks == nil or (type(item.locks) == "table" and next(item.locks) == nil)) then
            local ball = Env.loadModule("Config").ball.byCnId[item.itemId]
            if ball and type(ball.rating) == "number" and ball.rating <= maxRating
                and (not allowedBall or allowedBall(item.itemId)) then
                local key = item.itemId .. (item.tradable == true and ":tradable" or ":bound")
                local group = groups[key]
                if not group then
                    group = { ballId = item.itemId, rating = ball.rating, key = key, ids = {} }
                    groups[key] = group
                end
                group.ids[#group.ids + 1] = id
            end
        end
    end
    local candidates = {}
    for _, group in pairs(groups) do
        if #group.ids > required then -- retain one copy of each ball/tradability group
            candidates[#candidates + 1] = group
        end
    end
    table.sort(candidates, function(a, b)
        return a.rating < b.rating or (a.rating == b.rating and a.key < b.key)
    end)
    local group = candidates[1]
    if not group then
        return nil
    end
    table.sort(group.ids)
    return table.move(group.ids, 2, required + 1, 1, {}), group.ballId
end

return Fusion
end
__modules["core/limits"] = function(use) -- src/games/ballvsball/core/limits.luau
-- How many duel coins are left today and this week. Duels pay nothing once either cap is reached
-- (the game's config: misc.coinsLimit, 6,000 a day and 30,000 a week at the time of writing).
-- The saved counters only count for the day/week key they were written under, the same way the
-- game's DuelCoinLimitService reads them.

local Env = use("core/env")

local Limits = {}

local function limitsConfig()
    local ok, limits = pcall(function()
        return Env.loadModule("Config").misc.coinsLimit
    end)
    return ok and type(limits) == "table" and limits or {}
end

-- { day, dayMax, week, weekMax, capped } (a max is nil when the game has no such cap).
-- The whole lookup is optional: a place without TimeService reports no progress rather than
-- throwing out of the panels and the duel loop that call this every half second.
function Limits.coins()
    local config = limitsConfig()
    local saved = Env.data("duelCoinLimit") or {}
    local dayMax, weekMax = config["每日金币上限"], config["每周金币上限"]
    local okDay, dayKey = Env.call(function()
        return Env.loadModule("TimeService").getDayKey(0, config["每日重置时间"])
    end)
    local okWeek, weekKey = Env.call(function()
        return Env.loadModule("TimeService").getWeekKey(0, config["每周重置时间"], config["每周重置日期"])
    end)
    local day = okDay and saved.dailyKey == dayKey and saved.dailyEarned or 0
    local week = okWeek and saved.weeklyKey == weekKey and saved.weeklyEarned or 0
    local capped = (type(dayMax) == "number" and day >= dayMax) or (type(weekMax) == "number" and week >= weekMax)
    return { day = day, dayMax = dayMax, week = week, weekMax = weekMax, capped = capped == true }
end

return Limits
end
__modules["core/match"] = function(use) -- src/games/ballvsball/core/match.luau
-- What the server tells us about our table: its state, the ball and upgrade offers, and the
-- replays of this match.
--
-- A match is rounds of Picking (30s to choose one of 3 offered balls), Aiming (30s to set the
-- launch direction) and Playing (the server simulates the battle and streams a replay). Each
-- player has 3 hp and a lost round costs 1. Battles are deterministic: the replay's seed, balls and
-- directions reproduce the result exactly (see core/sim), and round r's seed is round 1's seed
-- plus (r - 1) * 1009. So once round 1 has been replayed, every later round's seed is known while
-- we still choose.

local Env = use("core/env")
local Life = use("shared/life")

local SEED_STEP = 1009

local Match = {
    tableModel = nil,
    tableId = nil,
    state = nil, -- the latest DuelTableState of our table
    slot = nil, -- our key in state.players ("Blue", "Yellow", "Blue1"...)
    left = false, -- a state showed our table, or every table, without us
    offer = nil, -- the latest ball offer: { offer = {roleIds}, selectPrice, rerollPrice, at }
    selectList = nil, -- the free pick's list: { roleIds, at }
    weeklyFreeRoleIds = {}, -- server-provided weekly choices for this match; never infer owned items
    upgradeOffer = nil, -- { offer = { { kind, id } }, at }
    ballLocked = nil, -- { roleId, at }
    aimToken = nil, -- a new table each time Aiming starts
    aimStartedAt = 0, -- os.clock() when it did
    aimLocked = nil, -- { direction, at }
    teammateAim = nil, -- 2v2: { userId, direction, at } as the teammate drags their aim
    replays = {}, -- this match's replays by round
    lastReplay = nil,
    capped = false, -- the server said today's duel coins are used up
    status = nil, -- what auto duel is doing (set by features/duel, shown on Home)
    prediction = nil, -- the solver's reasoning for the round in play (set by features/duel)
    history = nil, -- recent rounds and whether their predictions held (set by features/duel)
    session = nil, -- this session's match, round and coin tally (set by features/duel)
}

local listeners = {}

function Match.phase()
    return Match.state and Match.state.state or nil
end

-- Bind independently so one missing optional event cannot prevent all match tracking. The
-- connector retries after replication and disconnects a replaced remote before rebinding.
--
-- Exported because binding a remote at module load means a renamed or absent one errors out of
-- the whole feature on the way up: a hub that loses the coin tally should not also lose auto duel.
function Match.listen(name, fn, unreliable)
    local current, connection
    Life.loop("remote:" .. name, 5, function()
        if connection and connection.Connected and current and current.Parent then return end
        if connection then connection:Disconnect() end
        current = unreliable and Env.unreliable(name) or Env.event(name)
        connection = Life.connect(current.OnClientEvent, fn, "match:" .. name)
    end)
end
local listen = Match.listen

-- fn(replay, won) after each replay of our table. `won` is true, false, or nil for a draw.
function Match.onRound(fn)
    listeners[#listeners + 1] = fn
end

local function hasMe(state)
    local players = type(state) == "table" and state.players
    if type(players) ~= "table" then
        return nil
    end
    for slot, player in pairs(players) do
        if type(player) == "table" and player.userId == Env.LocalPlayer.UserId then
            return slot
        end
    end
    return nil
end

local function newMatch()
    table.clear(Match.replays)
    table.clear(Match.weeklyFreeRoleIds)
    Match.lastReplay = nil
    Match.offer, Match.selectList, Match.upgradeOffer = nil, nil, nil
    Match.ballLocked, Match.aimLocked = nil, nil
    Match.aimToken, Match.teammateAim = nil, nil
end

local function applyState(state)
    local slot = hasMe(state)
    if not slot then
        return false
    end
    if state.tableId ~= Match.tableId or (state.state == "Countdown" and Match.phase() ~= "Countdown") then
        newMatch()
    end
    -- A fresh token each time the table enters Aiming, so each round is aimed once.
    if state.state == "Aiming" and (Match.phase() ~= "Aiming" or Match.aimToken == nil) then
        Match.aimToken, Match.aimLocked, Match.teammateAim = {}, nil, nil
        Match.aimStartedAt = os.clock()
    end
    Match.tableId = state.tableId
    if typeof(state.table) == "Instance" then
        Match.tableModel = state.table
    end
    Match.state, Match.slot, Match.left = state, slot, false
    return true
end

-- The server only sends states when a table changes, so there can be long quiet stretches (a
-- whole battle): being seated is decided by what the states say, never by how long ago one came.
listen("DuelTableState", function(payload)
    if type(payload) ~= "table" then
        return
    end
    if payload.table then
        if not applyState(payload) and payload.tableId == Match.tableId then
            Match.left = true
        end
        return
    end
    if type(payload.tables) ~= "table" then
        return
    end
    local found = false
    for _, state in pairs(payload.tables) do
        found = applyState(state) or found
    end
    -- A full snapshot (every table) without us: we are not at any table.
    if not found and Match.state then
        Match.left = true
    end
end)

-- Offers and locks are only sent to the players at the table, so they are ours.
local function stamp(payload)
    local copy = table.clone(type(payload) == "table" and payload or {})
    copy.at = os.clock()
    copy.revision = 0
    return copy
end

local function updateWeeklyFree(payload)
    if type(payload) ~= "table" or type(payload.weeklyFreeRoleIds) ~= "table" then
        return
    end
    table.clear(Match.weeklyFreeRoleIds)
    for _, id in ipairs(payload.weeklyFreeRoleIds) do
        if type(id) == "string" then
            Match.weeklyFreeRoleIds[id] = true
        end
    end
end

function Match.isWeeklyFree(roleId)
    return Match.weeklyFreeRoleIds[roleId] == true
end

listen("DuelTableBallOffer", function(model, payload)
    if typeof(model) ~= "Instance" or type(payload) ~= "table" then return end
    -- The first offer of a match is not a reselect: whatever we saw before belongs to another match
    -- (even at the same table), and its seed must not be used.
    if type(payload) == "table" and not payload.isReselect then
        newMatch()
    end
    Match.tableModel = model
    Match.offer, Match.selectList, Match.ballLocked = stamp(payload), nil, nil
    updateWeeklyFree(payload)
end)
-- Keep the offer's identity and original deadline. A reroll is a revision of that offer,
-- not another picking window. Failed replies also release the response wait.
local function rerolled(model, payload, offer)
    if not Life.alive or model ~= Match.tableModel or type(payload) ~= "table" or not offer then
        return
    end
    offer.rerollReplyAt = os.clock()
    offer.rerollPending = false
    offer.rerollError = payload.reason
    if payload.ok ~= false and type(payload.offer) == "table" then
        offer.offer = payload.offer
        offer.revision += 1
        updateWeeklyFree(payload)
    end
    for _, key in ipairs({ "rerollPrice", "rerollCurrency", "canReroll", "rerollsRemaining", "freeRerolls" }) do
        if payload[key] ~= nil then
            offer[key] = payload[key]
        end
    end
end
listen("DuelTableBallRerollResult", function(model, payload)
    if Match.phase() == "Picking" and not Match.ballLocked then
        rerolled(model, payload, Match.offer)
    end
end)
listen("DuelTableUpgradeRerollResult", function(model, payload)
    if Match.phase() == "Upgrading" then
        rerolled(model, payload, Match.upgradeOffer)
    end
end)
listen("DuelTableRerollDenied", function(model, reason)
    local offer = Match.phase() == "Picking" and Match.offer or Match.upgradeOffer
    rerolled(model, { ok = false, reason = reason }, offer)
end)
listen("DuelTableBallSelectPurchaseResult", function(model, payload)
    if model == Match.tableModel and type(payload) == "table" and payload.ok ~= false
        and type(payload.roleIds) == "table" and Match.phase() == "Picking" and not Match.ballLocked then
        Match.selectList = stamp(payload)
        if Match.offer then
            Match.offer.selectPending = false
            Match.offer.selectError = nil
        end
        updateWeeklyFree(payload)
    end
end)
listen("DuelTableBallSelectDenied", function(model, reason)
    if model == Match.tableModel and Match.offer then
        Match.offer.selectPending = false
        Match.offer.selectError = reason or "unavailable"
    end
end)
listen("DuelTableBallSelectConfirmDenied", function(model, reason, price)
    if model == Match.tableModel and Match.offer then
        Match.offer.selectConfirmError = reason or "refused"
        if type(price) == "number" then
            Match.offer.selectPrice = price
        end
    end
end)
listen("DuelTableBallLocked", function(model, payload)
    if model == Match.tableModel then
        Match.ballLocked = stamp(payload)
    end
end)
listen("DuelTableBallSelectConfirmed", function(model, payload)
    if model == Match.tableModel then
        Match.ballLocked = stamp(payload)
    end
end)
listen("DuelTableUpgradeOffer", function(model, payload)
    Match.tableModel = model
    Match.upgradeOffer = stamp(payload)
end)
listen("DuelTableUpgradeLocked", function(model)
    if model == Match.tableModel then
        Match.upgradeOffer = nil
    end
end)
listen("DuelTableLaunchLocked", function(model, payload)
    if model == Match.tableModel then Match.aimLocked = stamp(payload) end
end)
-- In 2v2 the server relays the teammate's aim while they drag it: (table, their userId, direction).
listen("DuelTableAimPreview", function(model, userId, direction)
    if model == Match.tableModel and typeof(direction) == "Vector2" then
        Match.teammateAim = { userId = userId, direction = direction, at = os.clock() }
    end
end, true)
listen("DuelCoinLimitReached", function()
    Match.capped = true
end)

listen("DuelTableReplayStream", function(replay)
    if type(replay) ~= "table" or replay.tableId ~= Match.tableId or type(replay.round) ~= "number" then
        return
    end
    Match.replays[replay.round] = replay
    Match.lastReplay = replay
    local me = Env.LocalPlayer.UserId
    local won = nil
    if replay.isDraw ~= true then
        won = table.find(type(replay.winnerUserIds) == "table" and replay.winnerUserIds or {}, me) ~= nil
            or replay.winnerUserId == me
    end
    for index, fn in ipairs(listeners) do
        Life.spawn("match:round:" .. index, fn, replay, won)
    end
end)

local function canReroll(offer, allowDiamonds)
    if not offer or offer.rerollTried or offer.rerollPending or offer.canReroll == false
        or (type(offer.rerollsRemaining) == "number" and offer.rerollsRemaining <= 0) then
        return false
    end
    if type(offer.freeRerolls) == "number" and offer.freeRerolls > 0 then
        return true
    end
    -- The shipped client hides a zero-price reroll; only explicit metadata enables a free one.
    local price = offer.rerollPrice
    if price == 0 then
        return offer.canReroll == true
    end
    -- DuelChoice handles an insufficient reroll by opening DiamondTopUpService. Rerolls
    -- without currency metadata are priced in diamonds, so coins cannot fund them.
    local currency = offer.rerollCurrency or "diamonds"
    if currency == "diamonds" and not allowDiamonds then
        return false
    end
    return (currency == "coins" or currency == "diamonds") and type(price) == "number" and price > 0
        and (tonumber(Env.data(currency)) or 0) >= price
end

function Match.canRerollBall(allowDiamonds)
    return Match.seated() and Match.phase() == "Picking" and not Match.ballLocked and canReroll(Match.offer, allowDiamonds)
end

function Match.canRerollUpgrade(allowDiamonds)
    return Match.seated() and Match.phase() == "Upgrading" and canReroll(Match.upgradeOffer, allowDiamonds)
end

-- True while we sit at a table whose match is not over.
function Match.seated()
    return Match.state ~= nil and not Match.left and Match.phase() ~= "Finished"
end

function Match.teamSize()
    return Match.state and Match.state.teamSize or 1
end

-- Everyone at our table: { { userId, team, index, roleId, me, teammate } }, from the latest state.
-- roleId is only there once balls are locked (Aiming on). `index` is the seat within the team
-- (always 1 in a 1v1).
function Match.players()
    local out = {}
    local players = Match.state and Match.state.players
    local mine = players and players[Match.slot]
    for slot, player in pairs(type(players) == "table" and players or {}) do
        if type(player) == "table" then
            local team = player.team or slot
            out[#out + 1] = {
                userId = player.userId,
                team = team,
                index = player.teamIndex or 1,
                roleId = player.roleId,
                me = slot == Match.slot,
                teammate = slot ~= Match.slot and mine ~= nil and team == (mine.team or Match.slot),
            }
        end
    end
    return out
end

-- Our team's name ("Blue" or "Yellow"): what the simulation reports as the winner.
function Match.team()
    local players = Match.state and Match.state.players
    local mine = players and players[Match.slot]
    return mine and mine.team or Match.slot
end

function Match.hp(player)
    local state = Match.state
    if not (state and type(state.hp) == "table" and player) then
        return nil
    end
    return state.hp[player.userId] or state.hp[tostring(player.userId)]
end

-- The round being chosen or aimed right now (1 before this match's first replay).
function Match.round()
    local replay = Match.lastReplay
    if not replay or type(replay.round) ~= "number" then
        return 1
    end
    local phase = Match.phase()
    local playing = phase == "Playing" or phase == "Finished"
    return replay.round + (playing and 0 or 1)
end

-- Our hp and the lowest hp on the other team, which is what decides whether a round is worth a
-- risk: a loss at 1 hp ends the match, and so does a win against someone on their last one.
function Match.stakes()
    local ours, theirs
    for _, player in ipairs(Match.players()) do
        local hp = tonumber(Match.hp(player))
        if hp then
            if player.me then
                ours = hp
            elseif not player.teammate then
                theirs = math.min(theirs or math.huge, hp)
            end
        end
    end
    return ours, theirs
end

-- The seed of the round being chosen now, or nil before this match's first replay.
function Match.nextSeed()
    local replay = Match.lastReplay
    if not replay or type(replay.seed) ~= "number" then
        return nil
    end
    return replay.seed + SEED_STEP
end

-- A replay keeps balls and directions by team: one value in a 1v1, a list by seat in team modes.
function Match.forPlayer(byTeam, team, index)
    local value = type(byTeam) == "table" and byTeam[team]
    if type(value) == "table" then
        return value[index]
    end
    return value
end

-- The ball and direction `player` (from Match.players) used last round, or nil.
function Match.lastPlay(player)
    local options = Match.lastReplay and Match.lastReplay.replayOptions
    if not options then
        return nil, nil
    end
    return Match.forPlayer(options.selectedRoles, player.team, player.index),
        Match.forPlayer(options.initialDirections, player.team, player.index)
end

-- Whether `player` launched in the same direction in this match's last two rounds: true or false,
-- or nil with fewer than two rounds played. Someone who re-aims is not worth predicting.
function Match.keepsAim(player)
    local last = Match.lastReplay
    local before = last and Match.replays[last.round - 1]
    if not before then
        return nil
    end
    local a = Match.forPlayer((last.replayOptions or {}).initialDirections, player.team, player.index)
    local b = Match.forPlayer((before.replayOptions or {}).initialDirections, player.team, player.index)
    return typeof(a) == "Vector2" and typeof(b) == "Vector2" and (a - b).Magnitude < 1e-3
end

-- The arena the round is fought in: nil for the 1v1 board, the 2v2 board's layout otherwise.
function Match.arena()
    local options = Match.lastReplay and Match.lastReplay.replayOptions
    if options then
        return options.arena
    end
    if Match.teamSize() > 1 and Match.tableModel then
        local ok, arena = Env.call(function()
            return Env.loadModule("ArenaOverride").buildArenaData(Env.loadModule("GameModeRegistry").getForTable(Match.tableModel))
        end)
        return ok and arena or nil
    end
    return nil
end

Life.onCleanup(function()
    newMatch()
    table.clear(listeners)
    Match.tableModel, Match.tableId, Match.state, Match.slot = nil, nil, nil, nil
    Match.left, Match.status = true, "Off"
    Match.prediction, Match.history, Match.session = nil, nil, nil
end)

return Match
end
__modules["core/profile"] = function(use) -- src/games/ballvsball/core/profile.luau
-- What we have learned about the people we duel, kept between sessions.
--
-- The aim solver needs one number from the opponent: how likely they are to launch where they
-- launched last round. The hub used to assume 0.6, or 0.8 after two matching rounds, for everyone.
-- That is a reasonable guess and it is wrong for most individual players: an afk account is re-sent
-- its old aim by the server every round and never deviates, while someone actually playing re-aims
-- constantly. Measuring it per player and remembering it turns a constant into evidence.
--
-- Ball choices are recorded for the same reason. The pick phase simulates our offered balls against
-- what the opponent played last round, which is only a good assumption for someone who keeps
-- playing the same ball -- and now we know who does.
--
-- Nothing here is required. Without file access it is a memory-only model that starts fresh each
-- session, which is still better than a constant.

local Env = use("core/env")
local Life = use("shared/life")

local Profile = {}

local FOLDER = "SlopixHub/BallVsBall"
local FILE = FOLDER .. "/opponents.json"
local SAVE_INTERVAL = 45
local MAX_ENTRIES = 400

-- The prior, as a count of imaginary rounds: a player seen once does not get a 0% or 100% model.
-- 3 of 5 kept starts everyone at the 0.6 the hub used to assume for all players.
local PRIOR_KEPT, PRIOR_SEEN = 3, 5

local players = {}
local dirty, savedAt = false, os.clock()

local function entry(userId)
    local key = tostring(userId)
    local found = players[key]
    if not found then
        found = { kept = 0, seen = 0, rounds = 0, won = 0, lost = 0, balls = {}, at = os.time() }
        players[key] = found
    end
    return found
end

-- Load ---------------------------------------------------------------------------------------

local function decode(body)
    if type(body) ~= "string" or body == "" then
        return nil
    end
    local ok, decoded = pcall(function()
        return Env.HttpService:JSONDecode(body)
    end)
    Env.elevate()
    return ok and type(decoded) == "table" and decoded or nil
end

-- A saved file is data we wrote, but it is still a file on disk that anything could have edited,
-- so every field is checked before it reaches the solver's weights.
local function sanitise(raw)
    local out = {}
    for key, value in pairs(type(raw) == "table" and raw or {}) do
        if type(key) == "string" and type(value) == "table" then
            local seen = tonumber(value.seen) or 0
            local kept = tonumber(value.kept) or 0
            if seen >= 0 and seen < math.huge and kept >= 0 and kept <= seen then
                local balls = {}
                for ball, count in pairs(type(value.balls) == "table" and value.balls or {}) do
                    local number = tonumber(count)
                    if type(ball) == "string" and number and number > 0 and number < math.huge then
                        balls[ball] = math.floor(number)
                    end
                end
                out[key] = {
                    kept = math.floor(kept),
                    seen = math.floor(seen),
                    rounds = math.max(0, math.floor(tonumber(value.rounds) or 0)),
                    won = math.max(0, math.floor(tonumber(value.won) or 0)),
                    lost = math.max(0, math.floor(tonumber(value.lost) or 0)),
                    balls = balls,
                    at = math.max(0, math.floor(tonumber(value.at) or 0)),
                }
            end
        end
    end
    return out
end

local files = Env.files
local canSave = files.writefile ~= nil and files.isfolder ~= nil and files.makefolder ~= nil

do
    local ok, body = pcall(function()
        return Env.canCache and files.isfile(FILE) and files.readfile(FILE)
    end)
    Env.elevate()
    players = ok and sanitise(decode(body)) or {}
end

-- Save ---------------------------------------------------------------------------------------

-- Oldest first, so a long-lived file keeps the people still being played against.
local function trim()
    local keys = {}
    for key in pairs(players) do
        keys[#keys + 1] = key
    end
    if #keys <= MAX_ENTRIES then
        return
    end
    table.sort(keys, function(a, b)
        return (players[a].at or 0) > (players[b].at or 0)
    end)
    for index = MAX_ENTRIES + 1, #keys do
        players[keys[index]] = nil
    end
end

local function write()
    if not canSave or not dirty then
        return
    end
    dirty, savedAt = false, os.clock()
    trim()
    local ok = pcall(function()
        local path = ""
        for part in FOLDER:gmatch("[^/]+") do
            path = path == "" and part or path .. "/" .. part
            if not files.isfolder(path) then
                files.makefolder(path)
            end
        end
        files.writefile(FILE, Env.HttpService:JSONEncode(players))
    end)
    Env.elevate()
    if not ok then
        canSave = false -- a filesystem that refuses once is not asked again every 45 seconds
    end
end

Life.loop("duel:profile-save", SAVE_INTERVAL, function()
    if dirty and os.clock() - savedAt >= SAVE_INTERVAL then
        write()
    end
end)

-- Record -------------------------------------------------------------------------------------

-- One round of one opponent. `kept` is whether they launched where we assumed (nil when there was
-- no previous round to compare against, which teaches us nothing either way).
function Profile.observe(userId, kept, roleId, won)
    if type(userId) ~= "number" then
        return
    end
    local found = entry(userId)
    found.rounds += 1
    found.at = os.time()
    if kept ~= nil then
        found.seen += 1
        found.kept += kept and 1 or 0
    end
    if type(roleId) == "string" then
        found.balls[roleId] = (found.balls[roleId] or 0) + 1
    end
    if won == true then
        found.lost += 1 -- we won, so they lost
    elseif won == false then
        found.won += 1
    end
    dirty = true
end

-- Read ---------------------------------------------------------------------------------------

-- How likely `userId` is to launch where they launched last round, as a probability the solver can
-- weight its first column by. Everyone starts at the old 0.6 assumption and moves from there.
function Profile.keepRate(userId)
    local found = players[tostring(userId)]
    local kept = (found and found.kept or 0) + PRIOR_KEPT
    local seen = (found and found.seen or 0) + PRIOR_SEEN
    return kept / seen
end

-- The whole table's keep rate, which is what a scenario weight actually needs: one opponent who
-- re-aims is enough to make the "everyone kept their aim" column unlikely.
function Profile.tableKeepRate(opponents)
    local rate = 1
    local counted = 0
    for _, player in ipairs(opponents) do
        if not player.me and not player.teammate then
            rate *= Profile.keepRate(player.userId)
            counted += 1
        end
    end
    return counted > 0 and rate or PRIOR_KEPT / PRIOR_SEEN
end

-- The ball `userId` plays most often, and how often, or nil when we have not seen them pick.
function Profile.likelyBall(userId)
    local found = players[tostring(userId)]
    if not found then
        return nil
    end
    local best, bestCount, total = nil, 0, 0
    for ball, count in pairs(found.balls) do
        total += count
        if count > bestCount then
            best, bestCount = ball, count
        end
    end
    if not best or total == 0 then
        return nil
    end
    return best, bestCount / total
end

-- A line per opponent for the Intel tab. `name` is what to call them (their user id otherwise).
function Profile.describe(player, name)
    local found = players[tostring(player.userId)]
    local keep = math.floor(Profile.keepRate(player.userId) * 100 + 0.5)
    name = name or tostring(player.userId)
    if not found or found.rounds == 0 then
        return string.format("%s: new opponent, assuming %d%% aim repeat", name, keep)
    end
    local ball, share = Profile.likelyBall(player.userId)
    local favourite = ball and string.format(", favours %s (%d%%)", Env.ballName(ball),
        math.floor(share * 100 + 0.5)) or ""
    return string.format("%s: %d rounds, repeats aim %d%% (%d/%d), %d-%d against you%s",
        name, found.rounds, keep, found.kept, found.seen, found.won, found.lost, favourite)
end

function Profile.count()
    local total = 0
    for _ in pairs(players) do
        total += 1
    end
    return total
end

function Profile.forget()
    table.clear(players)
    dirty = true
    write()
end

Life.onCleanup(write)

return Profile
end
__modules["core/sim"] = function(use) -- src/games/ballvsball/core/sim.luau
-- Runs the game's own battle simulation (BattleDemo.BattleSimulation) to see how a round would
-- end. It uses the game's deterministic inputs and yields between groups of simulation steps
-- so a slower client can still draw frames, handle events, and stop an obsolete search.
--
-- Balls and directions are keyed by team, as in the server's replays: { Blue = "刀片球" } in a 1v1,
-- { Blue = { "刀片球", "蛇球" } } (by seat) in a 2v2, which also needs the 2v2 arena.

local Env = use("core/env")
local Life = use("shared/life")

local Sim = {}

-- Only these two decide a battle. ArenaOverride and GameModeRegistry shape the 2v2 board, and
-- both callers already fall back to the 1v1 config when they are missing, so a place that does
-- not ship them must not hold Smart aim off for the whole session.
local REQUIRED = { "BattleConfig", "BattleSimulation" }
local OPTIONAL = { "ArenaOverride", "GameModeRegistry" }

-- Reads the module cache rather than a flag this file sets, so readiness follows what is actually
-- loaded instead of whether the loader loop below has had its turn yet.
function Sim.ready()
    for _, name in ipairs(REQUIRED) do
        if rawget(Env.Game, name) == nil then
            return false
        end
    end
    return true
end

local optionalTries = {}
Life.loop("duel:simulation-modules", 5, function()
    if not Sim.ready() then
        for _, name in ipairs(REQUIRED) do
            Env.loadModule(name)
        end
        return
    end
    -- The arena modules only matter in 2v2. A few attempts, then they are left alone: each miss
    -- costs this thread a 30-second wait, and the 1v1 board works without them.
    for _, name in ipairs(OPTIONAL) do
        if rawget(Env.Game, name) == nil and (optionalTries[name] or 0) < 3 then
            optionalTries[name] = (optionalTries[name] or 0) + 1
            pcall(Env.loadModule, name)
        end
    end
end)

local SCORE = { win = 1, draw = 0.5, loss = 0 }
local FAST_WIN_BONUS = 0.01 -- tie-break: a quicker win is a safer one

-- Giving a frame back costs ~16ms of a think budget measured in seconds, so yielding once per
-- simulation spent more time waiting for the next frame than simulating. Every search yields off
-- one shared slice clock instead.
local SLICE = 0.008
local sliceStart = os.clock()

function Sim.breathe()
    if os.clock() - sliceStart >= SLICE then
        task.wait()
        Env.elevate()
        sliceStart = os.clock()
    end
    return Life.alive
end

-- The shipped step() has no scratch-buffer argument. Keep its dispatch order, but reuse the
-- event container for this simulation only. Helpers still emit their event records; suppressing
-- those would require replacing combat code and could change deterministic results. No shared
-- module, table.insert, or live replay is patched.
local function headlessStep(self, dt)
    local events, state = self._headlessEvents, self.state
    table.clear(events)
    if state.finished then
        return state
    end
    state.elapsed += dt
    if self.multiEntityMode then
        self:_stepMultiEntity(dt, events)
    else
        local blue, yellow = state.balls.Blue, state.balls.Yellow
        self:_updateBallSkill(blue, yellow, dt, events)
        self:_updateBallSkill(yellow, blue, dt, events)
        if blue.vampireStateRemaining > 0 and type(blue.vampireAttachedTargetId) == "string"
            and blue.vampireAttachedTargetId == yellow.id then
            self:_moveAttachedPair(blue, yellow, dt, events)
            self:_handlePoisonSpikeCollisions(blue, events)
            self:_handlePoisonSpikeCollisions(yellow, events)
        elseif yellow.vampireStateRemaining > 0 and type(yellow.vampireAttachedTargetId) == "string"
            and yellow.vampireAttachedTargetId == blue.id then
            self:_moveAttachedPair(yellow, blue, dt, events)
            self:_handlePoisonSpikeCollisions(blue, events)
            self:_handlePoisonSpikeCollisions(yellow, events)
        else
            self:_moveBall(blue, dt, events)
            if not ((blue.traits.ChessPath and blue.traits.ChessPath.isActive)
                or (blue.traits.OnePunch and blue.traits.OnePunch.phase == "Dash")) then
                self:_handleWallBounce(blue, events)
                self:_handlePoisonSpikeCollisions(blue, events)
            end
            self:_moveBall(yellow, dt, events)
            if not ((yellow.traits.ChessPath and yellow.traits.ChessPath.isActive)
                or (yellow.traits.OnePunch and yellow.traits.OnePunch.phase == "Dash")) then
                self:_handleWallBounce(yellow, events)
                self:_handlePoisonSpikeCollisions(yellow, events)
            end
        end
        self:_updateThomas(blue, dt, events)
        self:_updateThomas(yellow, dt, events)
        self:_handleBallCollision(events)
        self:_handleDiceCollisions(events)
    end
    self:_refreshAllBuffIndicators()
    self:_updateWinner(events)
    return state
end

-- The battle config for an arena (nil: the 1v1 board), resolved once per board.
local configs = {}
local function battleConfig(arena)
    local key = arena and arena.boardAssetName or "default"
    if not configs[key] then
        local ok, resolved = Env.call(Env.loadModule("ArenaOverride").resolveConfig, Env.loadModule("BattleConfig"), arena)
        configs[key] = ok and resolved or Env.loadModule("BattleConfig")
    end
    return configs[key]
end

-- The longest a battle can run on this board, for scoring a fast win.
function Sim.maxDuration(arena)
    local ok, duration = pcall(function()
        return battleConfig(arena).replay.maxDuration
    end)
    return ok and type(duration) == "number" and duration > 0 and duration or 1
end

-- A battle is a pure function of (seed, balls, directions, stats, traits, board), and the same
-- combination comes up again and again: the coarse and refine passes share scenarios, the ball
-- search re-tests the same opponents, and the matrix solver re-reads rows it has already filled.
local CACHE_LIMIT = 4096
local cache, cacheCount = {}, 0

local function keyOf(value, out)
    local kind = typeof(value)
    if kind == "Vector2" then
        -- Rounded to the tolerance directions are compared by everywhere else (1e-3).
        out[#out + 1] = string.format("v%.4f,%.4f", value.X, value.Y)
    elseif kind == "table" then
        local keys = {}
        for key in pairs(value) do
            keys[#keys + 1] = key
        end
        table.sort(keys, function(a, b)
            return tostring(a) < tostring(b)
        end)
        out[#out + 1] = "{"
        for _, key in ipairs(keys) do
            out[#out + 1] = tostring(key)
            out[#out + 1] = "="
            keyOf(value[key], out)
            out[#out + 1] = ";"
        end
        out[#out + 1] = "}"
    else
        out[#out + 1] = tostring(value)
    end
    return out
end

-- The board goes in by name: resolveConfig already keys its own cache that way, and serialising a
-- whole arena layout per simulation would cost more than the lookup saves.
local function cacheKey(seed, roles, directions, statLevels, traits, arena)
    local out = { tostring(seed), "|", arena and tostring(arena.boardAssetName) or "default", "|" }
    keyOf(roles, out)
    out[#out + 1] = "|"
    keyOf(directions, out)
    out[#out + 1] = "|"
    keyOf(statLevels, out)
    out[#out + 1] = "|"
    keyOf(traits, out)
    return table.concat(out)
end

function Sim.clearCache()
    table.clear(cache)
    cacheCount = 0
end

-- Plays one battle out. Returns the winning team ("Blue", "Yellow" or "Draw") and its length in
-- seconds, or nil and the error.
function Sim.run(seed, roles, directions, statLevels, traits, arena, deadline, valid)
    if not Sim.ready() then return nil, "simulation modules are still loading" end
    local key = cacheKey(seed, roles, directions, statLevels, traits, arena)
    local hit = cache[key]
    if hit then
        return hit[1], hit[2]
    end
    local cfg = battleConfig(arena)
    local ok, winner, elapsed = Env.call(function()
        local sim = Env.loadModule("BattleSimulation").new(cfg, seed, roles, traits, statLevels, directions)
        sim._headlessEvents = {}
        sim.step = headlessStep
        local dt = cfg.replay.fixedDt
        assert(type(dt) == "number" and dt > 0 and dt < math.huge, "invalid simulation time step")
        local duration = cfg.replay.maxDuration
        assert(type(duration) == "number" and duration > 0 and duration < math.huge, "invalid simulation duration")
        for step = 1, math.ceil(duration / dt) do
            if sim:step(dt).finished then
                break
            end
            if step % 32 == 0 and os.clock() - sliceStart >= SLICE then
                task.wait()
                Env.elevate()
                sliceStart = os.clock()
                if not Life.alive or (deadline and os.clock() >= deadline) or (valid and not valid()) then
                    return nil, "simulation cancelled"
                end
            end
        end
        local state = sim:getState()
        table.clear(sim._headlessEvents)
        return state.finished and state.winner or "Draw", state.elapsed
    end)
    if not ok then
        return nil, winner
    end
    -- A cancelled run reports no winner; only a finished battle is a fact worth keeping.
    if winner == nil then
        return nil, elapsed
    end
    if cacheCount >= CACHE_LIMIT then
        Sim.clearCache()
    end
    cache[key] = { winner, elapsed }
    cacheCount += 1
    return winner, elapsed
end

-- `count` launch directions spread evenly around the circle.
function Sim.directions(count)
    local out = {}
    for index = 0, count - 1 do
        local angle = index / count * math.pi * 2
        out[#out + 1] = Vector2.new(math.cos(angle), math.sin(angle))
    end
    return out
end

local random = Random.new()

function Sim.randomDirection()
    local angle = random:NextNumber(0, math.pi * 2)
    return Vector2.new(math.cos(angle), math.sin(angle))
end

function Sim.randomSeed()
    return math.floor(workspace:GetServerTimeNow() * 1000) + random:NextInteger(-600000, 600000)
end

-- The plain result for `team`: 1 win, 0.5 draw, 0 loss. A draw costs no hp, so it really is worth
-- half a win and must never be lumped in with a loss.
function Sim.outcome(winner, team)
    if winner == team then
        return SCORE.win
    end
    return winner == "Draw" and SCORE.draw or SCORE.loss
end

-- How good one outcome is for `team`, plus a little for winning fast.
function Sim.score(winner, elapsed, team, maxDuration)
    local base = Sim.outcome(winner, team)
    if base ~= SCORE.win then
        return base
    end
    return base + FAST_WIN_BONUS * (1 - math.clamp((elapsed or 0) / maxDuration, 0, 1))
end

local score = Sim.score

-- The coarse pass gets this share of the think time; the rest refines around its best directions,
-- since a winning window can be narrower than the gap between two coarse directions.
local COARSE_SHARE = 0.65
local REFINE_TOP = 3
local REFINE_STEPS = { -1 / 3, -1 / 6, 1 / 6, 1 / 3 } -- of the gap between coarse directions

local function rotate(direction, angle)
    local c, s = math.cos(angle), math.sin(angle)
    return Vector2.new(direction.X * c - direction.Y * s, direction.X * s + direction.Y * c)
end

-- Tries every direction against each scenario in turn until the deadline (scenario 1 may run on to
-- `firstDeadline`). A scenario only counts once every direction has been tried against it, so the
-- directions stay comparable. Returns the weighted total per direction, how many scenarios
-- completed, and who wins scenario 1 with each.
local function evaluate(spec, directions, scenarios, deadline, firstDeadline)
    local maxDuration = Sim.maxDuration(spec.arena)
    local totals, rates, completed, firstWinners = {}, {}, 0, {}
    for scenarioIndex, scenario in ipairs(scenarios) do
        local results, outcomes = {}, {}
        local stopAt = scenarioIndex == 1 and (firstDeadline or deadline) or deadline
        for index, direction in ipairs(directions) do
            if not Life.alive or (spec.valid and not spec.valid()) or os.clock() > stopAt then
                break
            end
            local winner, elapsed = Sim.run(scenario.seed, spec.roles, spec.place(direction, scenario),
                spec.statLevels, spec.traits, spec.arena, stopAt, spec.valid)
            results[index] = winner and score(winner, elapsed, spec.team, maxDuration) or 0
            if not winner then
                return totals, completed, firstWinners, rates -- errors are not predicted losses
            end
            outcomes[index] = Sim.outcome(winner, spec.team)
            if scenarioIndex == 1 then
                firstWinners[index] = winner
            end
            Sim.breathe()
        end
        if #results < #directions then
            break -- out of time: this scenario is incomplete, so it is left out
        end
        for index, value in ipairs(results) do
            totals[index] = (totals[index] or 0) + value * scenario.weight
            rates[index] = (rates[index] or 0) + outcomes[index] * scenario.weight
        end
        completed = scenarioIndex
    end
    return totals, completed, firstWinners, rates
end

-- Finds our best launch direction.
-- spec = {
--   team            -- our team ("Blue" or "Yellow"): the winner we want
--   roles           -- every ball, keyed by team as in a replay
--   place           -- function(ourDirection, scenario) -> every direction, keyed by team
--   directions      -- our coarse candidate directions, evenly spaced (Sim.directions)
--   scenarios       -- { { seed, weight, ... } }, most likely first; `place` reads the rest
--   statLevels, traits, arena -- from the match's last replay (nil in round 1, arena nil in a 1v1)
--   deadline        -- os.clock() by which to answer
-- }
-- A coarse pass over `directions`, then a finer one around its best few, against the scenarios the
-- coarse pass completed. Returns the best direction, its expected score (0..1), how many coarse
-- directions win the first scenario, and who wins the first scenario with the best direction.
function Sim.bestDirection(spec)
    if not ready or not Life.alive then return nil, 0, 0, nil end
    local started = os.clock()
    local coarseDeadline = started + (spec.deadline - started) * COARSE_SHARE
    -- Scenario 1 (the likely one) may use the whole think time; more only fit in the coarse share.
    local totals, completed, winners, rates = evaluate(spec, spec.directions, spec.scenarios, coarseDeadline, spec.deadline)
    if completed == 0 then
        return nil, 0, 0, nil
    end
    local weights = 0
    for index = 1, completed do
        weights += spec.scenarios[index].weight
    end
    local firstWins = 0
    for _, winner in pairs(winners) do
        firstWins += winner == spec.team and 1 or 0
    end

    local best, bestTotal, bestWinner, bestRate = nil, -1, nil, 0
    local order = {}
    for index, total in ipairs(totals) do
        order[#order + 1] = index
        if total > bestTotal then
            best, bestTotal, bestWinner = spec.directions[index], total, winners[index]
            bestRate = rates[index]
        end
    end

    -- Refine: directions between the best coarse ones and their neighbours, scored on the same
    -- scenarios. Kept only if every one of them finishes, so the comparison stays fair.
    table.sort(order, function(a, b)
        return totals[a] > totals[b]
    end)
    local gap = math.pi * 2 / #spec.directions
    local finer = {}
    for rank = 1, math.min(REFINE_TOP, #order) do
        for _, step in ipairs(REFINE_STEPS) do
            finer[#finer + 1] = rotate(spec.directions[order[rank]], step * gap)
        end
    end
    local scenarios = table.move(spec.scenarios, 1, completed, 1, {})
    local fineTotals, fineCompleted, fineWinners, fineRates = evaluate(spec, finer, scenarios, spec.deadline)
    if fineCompleted == completed then
        for index, total in ipairs(fineTotals) do
            if total > bestTotal then
                best, bestTotal, bestWinner = finer[index], total, fineWinners[index]
                bestRate = fineRates[index]
            end
        end
    end
    return best, math.clamp(bestRate / weights, 0, 1), firstWins, bestWinner
end

Life.onCleanup(function()
    table.clear(configs)
    table.clear(optionalTries)
    Sim.clearCache()
end)

return Sim
end
__modules["core/solver"] = function(use) -- src/games/ballvsball/core/solver.luau
-- Solves the aim phase as the game it actually is.
--
-- From round 2 the seed is known exactly (core/match), every ball is locked before aiming starts,
-- and the battle is deterministic. The only thing left unknown is where the others launch. That
-- makes one round a finite two-player zero-sum simultaneous game whose payoff function we can
-- evaluate directly, so instead of guessing one opponent aim and answering it, this builds the
-- payoff matrix: our candidate directions down the rows, the opponent's down the columns.
--
-- Three numbers come out of a row, and they answer different questions:
--   expected  how the row does against the opponent we actually expect (core/profile weights it)
--   worst     the worst any opponent direction can do to it: a floor that holds whatever they pick
--   wins      how many opponent directions it beats outright, i.e. how forgiving the aim is
--
-- Ranking by `expected` alone exploits a predictable opponent but can be punished badly by a
-- surprise. Ranking by `worst` alone is the maximin play: it gives up some wins to never be
-- blown out. `lambda` slides between them, and hp moves it on its own, because the value of a
-- round is not symmetric when someone is one loss from going out.

local Life = use("shared/life")
local Sim = use("core/sim")

local Solver = {}

-- A row has to cover every column in the current comparison set before it can be ranked against
-- another row: a partly filled row has a flattering minimum and a meaningless average.
local function rank(a, b)
    if a.score ~= b.score then
        return a.score > b.score
    end
    if a.worst ~= b.worst then
        return a.worst > b.worst
    end
    return a.wins > b.wins
end

-- Fills columns `from`..`to` of one row. False when the search was cancelled or ran out of time,
-- in which case the row keeps whatever it had and must not be ranked at the new column count.
local function fill(spec, row, from, to)
    for column = from, to do
        if not Life.alive or (spec.valid and not spec.valid()) or os.clock() >= spec.deadline then
            return false
        end
        local scenario = spec.opponents[column]
        local winner, elapsed = Sim.run(spec.seed, spec.roles, spec.place(row.direction, scenario),
            spec.statLevels, spec.traits, spec.arena, spec.deadline, spec.valid)
        if not winner then
            return false -- an error or a cancellation is not a predicted loss
        end
        row.scores[column] = Sim.score(winner, elapsed, spec.team, spec.maxDuration)
        row.outcomes[column] = Sim.outcome(winner, spec.team)
        if column == 1 then
            row.winner = winner
        end
        Sim.breathe()
    end
    return true
end

-- Collapses a row's filled columns into the three numbers, under `lambda`.
local function summarise(row, spec, columns)
    local weighted, weights, worst, wins = 0, 0, math.huge, 0
    for column = 1, columns do
        local weight = spec.opponents[column].weight or 1
        weighted += row.scores[column] * weight
        weights += weight
        worst = math.min(worst, row.outcomes[column])
        wins += row.outcomes[column] >= 1 and 1 or 0
    end
    row.expected = weights > 0 and weighted / weights or 0
    row.worst = worst == math.huge and 0 or worst
    row.wins = wins
    row.columns = columns
    row.score = (1 - spec.lambda) * row.expected + spec.lambda * row.worst
end

local function newRow(direction)
    return { direction = direction, scores = {}, outcomes = {}, expected = 0, worst = 0, wins = 0, score = -1 }
end

-- Evaluates every candidate against columns 1..`columns` and returns the ones that covered them
-- all, best first. `done` is false when the stage was cut short, so the caller keeps the previous
-- stage's answer rather than comparing rows judged on different opponents.
local function stage(spec, candidates, columns)
    local complete, done = {}, true
    for _, row in ipairs(candidates) do
        local from = (row.columns or 0) + 1
        if from > columns then
            summarise(row, spec, columns)
            complete[#complete + 1] = row
        elseif fill(spec, row, from, columns) then
            summarise(row, spec, columns)
            complete[#complete + 1] = row
        else
            done = false
            break
        end
    end
    table.sort(complete, rank)
    return complete, done
end

local function rotate(direction, angle)
    local c, s = math.cos(angle), math.sin(angle)
    return Vector2.new(direction.X * c - direction.Y * s, direction.X * s + direction.Y * c)
end

-- How much weight the floor gets. A round is not worth the same to both sides once someone is one
-- loss from out: at 1 hp a loss ends the match, so the floor matters more than the average; when
-- the opponent is at 1 hp a win ends it, so it is worth reaching for.
local STYLE = { Exploit = 0, Balanced = 0.5, Safe = 1 }

function Solver.lambda(style, ourHp, theirHp)
    local lambda = STYLE[style] or STYLE.Balanced
    if ourHp == 1 then
        lambda += 0.25
    end
    if theirHp == 1 then
        lambda -= 0.2
    end
    return math.clamp(lambda, 0, 1)
end

-- The opponent's candidate directions, as scenarios the caller's `place` can read.
--
-- Column 1 is who we think they are: the aim core/profile expects them to keep. The rest cover
-- what else they could do. With one unknown opponent that space is just the circle, so it is
-- covered evenly and the row minimum becomes a real maximin over that discretisation. With two
-- (a 2v2) the joint space is square and sampling it is the only thing that fits the budget.
function Solver.columns(players, likely, modelled, count)
    local unknown = {}
    for _, player in ipairs(players) do
        if not player.me and not player.teammate then
            unknown[#unknown + 1] = player
        end
    end
    -- An opponent who changed their aim last round has no direction to expect. Their slot in
    -- column 1 is then as random as any other column, and giving it the model's weight would let
    -- a coin flip dominate the expected value -- so without a full prediction every column counts
    -- the same and the row's average is a plain average over the sweep.
    local predicted = true
    for _, player in ipairs(unknown) do
        predicted = predicted and likely[player.userId] ~= nil
    end
    local weight = predicted and math.clamp(modelled or 0.6, 0.05, 0.95) or 1 / math.max(1, count)
    local first = { others = {}, weight = weight, modelled = predicted }
    for _, player in ipairs(players) do
        if not player.me then
            first.others[player.userId] = likely[player.userId] or Sim.randomDirection()
        end
    end
    local columns = { first }
    local spread = (1 - first.weight) / math.max(1, count - 1)
    if #unknown == 1 then
        local opponent = unknown[1]
        local sweep = Sim.directions(count - 1)
        for _, direction in ipairs(sweep) do
            local others = {}
            for userId, value in pairs(first.others) do
                others[userId] = value -- the teammate's aim is known and stays put
            end
            others[opponent.userId] = direction
            columns[#columns + 1] = { others = others, weight = spread }
        end
        return columns
    end
    for _ = 2, count do
        local others = {}
        for userId, value in pairs(first.others) do
            others[userId] = value
        end
        for _, player in ipairs(unknown) do
            others[player.userId] = Sim.randomDirection()
        end
        columns[#columns + 1] = { others = others, weight = spread }
    end
    return columns
end

-- spec = {
--   team, seed, roles, statLevels, traits, arena -- the round, exactly as the server will run it
--   ours        -- our candidate directions, evenly spaced (Sim.directions)
--   opponents   -- Solver.columns(...): index 1 is the opponent we expect
--   place       -- function(ourDirection, scenario) -> directions keyed by team, as in a replay
--   lambda      -- Solver.lambda(...): 0 answers the expected opponent, 1 plays the floor
--   deadline, valid
-- }
--
-- Widens in stages so there is always an answer to give back: the whole grid against a few
-- opponent directions first, then the leaders against all of them, then finer directions around
-- the leaders. Every stage compares rows that saw the same opponents.
--
-- Returns the winning row { direction, score, expected, worst, wins, winner, columns } and how
-- many opponent directions it was judged against, or nil when nothing finished in time.
local NARROW = 4 -- opponent columns every one of our directions is tried against
local SURVIVORS = 4
local REFINE_STEPS = { -1 / 3, -1 / 6, 1 / 6, 1 / 3 } -- of the gap between our coarse directions
local PHI = (math.sqrt(5) - 1) / 2

-- Our directions in golden-ratio order rather than round the circle. If the clock runs out
-- partway through the first pass, the rows that did finish are still spread over every side of
-- the board, instead of all sitting in the one arc that happened to come first.
local function spread(directions)
    local order = {}
    for index = 1, #directions do
        order[index] = index
    end
    table.sort(order, function(a, b)
        return ((a - 1) * PHI) % 1 < ((b - 1) * PHI) % 1
    end)
    local out = {}
    for _, index in ipairs(order) do
        out[#out + 1] = directions[index]
    end
    return out
end

function Solver.solve(spec)
    if not Sim.ready() or not Life.alive or not spec.seed or #spec.ours == 0 or #spec.opponents == 0 then
        return nil
    end
    spec.lambda = math.clamp(spec.lambda or 0.5, 0, 1)
    spec.maxDuration = Sim.maxDuration(spec.arena)
    local narrow = math.min(NARROW, #spec.opponents)
    local full = #spec.opponents

    -- Every list `stage` returns holds only rows that covered all of its columns, so a stage cut
    -- short still ranks fairly; it just ranks fewer rows.
    local rows = {}
    for _, direction in ipairs(spread(spec.ours)) do
        rows[#rows + 1] = newRow(direction)
    end
    local best = stage(spec, rows, narrow)
    if #best == 0 then
        return nil
    end

    -- The leaders face every opponent column. The narrow pass is already cached, so this only
    -- pays for the columns it adds. Leaders run best first, so a cut-off loses the weakest.
    local leaders = table.move(best, 1, math.min(SURVIVORS, #best), 1, {})
    local widened, done = stage(spec, leaders, full)
    if #widened == 0 then
        return best[1], narrow
    end
    if not done then
        return widened[1], full
    end

    -- A winning window can be narrower than the gap between two coarse directions.
    local gap = math.pi * 2 / #spec.ours
    local finer = table.move(widened, 1, #widened, 1, {})
    for place = 1, math.min(2, #widened) do
        for _, step in ipairs(REFINE_STEPS) do
            finer[#finer + 1] = newRow(rotate(widened[place].direction, step * gap))
        end
    end
    -- The widened rows lead the list and are already complete, so this is never empty.
    local refined = stage(spec, finer, full)
    return refined[1], full
end

return Solver
end
__modules["core/stats"] = function(use) -- src/games/ballvsball/core/stats.luau
-- Every ball's win rate across all players, from the game's own BallBattleStats (the numbers its
-- Ball Index shows): overall, and head to head against each other ball.

local Env = use("core/env")
local Life = use("shared/life")

local Stats = {}

local REFRESH = 600 -- seconds; the server rate-limits the call
local MIN_MATCHUP_GAMES = 500 -- fewer head-to-head games than this and the overall rate is used

local raw, fetchedAt = nil, -math.huge
local fetching = false

local function all()
    if not fetching and os.clock() - fetchedAt > REFRESH then
        fetching, fetchedAt = true, os.clock()
        Life.spawn("duel:statistics", function()
            local moduleOk = Env.call(Env.loadModule, "StatsCore")
            local ok, result = Env.invoke("BallBattleStats/GetAll")
            if Life.alive and moduleOk and ok and type(result) == "table" then
                raw = type(result.data) == "table" and result.data or result
            else
                fetchedAt = os.clock() - REFRESH + 30
            end
            fetching = false
        end)
    end
    return raw
end

-- Refresh off the picking path: a slow statistics service must not use the pick timer.
all()

-- A ball's overall win rate (0..1), or nil when the game has no numbers for it.
function Stats.winRate(ball)
    local entry = (all() or {})[ball]
    if type(entry) ~= "table" then
        return nil
    end
    local core = rawget(Env.Game, "StatsCore")
    if not core then return nil end
    local ok, summary = Env.call(core.summarize, entry)
    return ok and summary and summary.winRate or nil
end

-- How often `ball` beats `versus`, falling back to its overall rate on too few games.
function Stats.against(ball, versus)
    local entry = (all() or {})[ball]
    local record = versus and type(entry) == "table" and type(entry.opponents) == "table" and entry.opponents[versus]
    if type(record) == "table" then
        local games = (record.wins or 0) + (record.losses or 0) + (record.draws or 0)
        if games >= MIN_MATCHUP_GAMES then
            return (record.wins + 0.5 * (record.draws or 0)) / games
        end
    end
    return Stats.winRate(ball)
end

return Stats
end
__modules["core/trajectory"] = function(use) -- src/games/ballvsball/core/trajectory.luau
-- Aim uses the same arena anchor and XY plane as DuelLaunchAimClient (local -Z is up).
local Env = use("core/env")
local Life = use("shared/life")
local Match = use("core/match")
local Trajectory = {}
local root, shownModel, shownToken

function Trajectory.clear()
    Env.elevate()
    if root then
        root:Destroy()
    end
    root, shownModel, shownToken = nil, nil, nil
end

-- `detail` is an optional second line: what the solver guarantees, next to what it expects.
function Trajectory.show(player, direction, expected, detail)
    Trajectory.clear()
    local model = Match.tableModel
    if not Life.alive or not Match.seated() or Match.phase() ~= "Aiming" or not model then
        return false
    end
    local anchor = model:FindFirstChild("棋盘锚点") or model:FindFirstChild("ArenaAnchor")
    if not anchor or not anchor:IsA("BasePart") or direction.Magnitude < 1e-6 then
        return false
    end
    local ok, cfg = Env.call(Env.loadModule("ArenaOverride").resolveConfig, Env.loadModule("BattleConfig"), Match.arena())
    if not ok or not Life.alive or model ~= Match.tableModel or Match.phase() ~= "Aiming" then
        return false
    end
    local slot = cfg.slots[player.team]
    local spawn = slot and ((slot.spawnPositionCorners or {})[player.index] or slot.spawnPosition)
    if typeof(spawn) ~= "Vector2" then
        return false
    end
    Env.elevate()
    root = Instance.new("Folder")
    root.Name = "SlopixAimTrajectory"
    root.Parent = model
    shownModel, shownToken = model, Match.aimToken
    local color = expected > 0.60 and Color3.fromRGB(70, 235, 115)
        or expected >= 0.45 and Color3.fromRGB(255, 215, 65) or Color3.fromRGB(255, 85, 85)
    direction = direction.Unit
    local length = math.min(cfg.arena.size.X, cfg.arena.size.Y) * 0.3
    -- Clip the launch segment to the board's edge, including corner spawns in team modes.
    for _, axis in ipairs({ "X", "Y" }) do
        local component = direction[axis]
        if math.abs(component) > 1e-6 then
            local edge = math.sign(component) * (cfg.arena.size[axis] / 2 - 0.2)
            length = math.min(length, math.max(0.2, (edge - spawn[axis]) / component))
        end
    end
    local tip = spawn + direction * length
    local wing = Vector2.new(-direction.Y, direction.X)
    local head = math.min(1.1, length * 0.3)
    local function point(position)
        local attachment = Instance.new("Attachment")
        attachment.Position = Vector3.new(position.X, position.Y, -0.3)
        attachment.Parent = anchor
        return attachment
    end
    -- Attachments are on a transparent anchor part owned by the visual, so one Destroy clears all.
    local holder = Instance.new("Part")
    holder.Name = "ArenaPlane"
    holder.Size = Vector3.new(0.1, 0.1, 0.1)
    holder.Transparency, holder.Anchored = 1, true
    holder.CanCollide, holder.CanTouch, holder.CanQuery = false, false, false
    holder.CFrame = anchor.CFrame
    holder.Parent = root
    anchor = holder
    local start, finish = point(spawn), point(tip)
    local function beam(a, b, width)
        local line = Instance.new("Beam")
        line.Attachment0, line.Attachment1 = a, b
        line.Width0, line.Width1 = width, width
        line.Color, line.Transparency = ColorSequence.new(color), NumberSequence.new(0)
        line.FaceCamera, line.LightEmission, line.Segments = true, 1, 1
        line.Parent = root
    end
    beam(start, finish, 0.16)
    beam(finish, point(tip - direction * head + wing * head * 0.5), 0.16)
    beam(finish, point(tip - direction * head - wing * head * 0.5), 0.16)
    local label = Instance.new("BillboardGui")
    label.Name, label.Adornee = "Prediction", holder
    label.Size = UDim2.fromOffset(260, detail and 58 or 44)
    label.StudsOffsetWorldSpace = holder.CFrame.LookVector * 3
    label.AlwaysOnTop, label.MaxDistance = true, 150
    label.Parent = root
    local text = Instance.new("TextLabel")
    text.Size, text.BackgroundTransparency = UDim2.fromScale(1, 1), 1
    text.TextColor3, text.TextStrokeTransparency = color, 0.25
    text.Font, text.TextSize = Enum.Font.GothamBold, 18
    local outcome = expected > 0.60 and "Win" or expected >= 0.45 and "Even" or "Loss"
    text.Text = string.format("Predicted: %s (%d%%)", outcome, math.floor(expected * 100 + 0.5))
        .. (detail and "\n" .. detail or "")
    text.Parent = label
    return true
end

local function refresh()
    if root and (not Life.alive or not Match.seated() or Match.phase() ~= "Aiming"
        or Match.tableModel ~= shownModel or Match.aimToken ~= shownToken or not root.Parent) then
        Trajectory.clear()
    end
end
-- Through Match, so an absent or renamed state remote costs the overlay its prompt refresh
-- rather than erroring out of this module while the hub is still loading.
Match.listen("DuelTableState", refresh)
Life.loop("duel:trajectory", 0.1, refresh)
Life.onCleanup(Trajectory.clear)

return Trajectory
end
__modules["core/ui"] = function(use) -- src/games/ballvsball/core/ui.luau
-- Ball VS Ball's window and tabs.

local Ui = use("shared/ui")

return Ui.create({
    library = function() return use("vendor/ui") end,
    icons = use("vendor/icons"),
    footer = "Ball VS Ball",
    tabs = {
        { "Home", "house", "Welcome to Slopix Hub" },
        { "Duel", "swords", "Auto duel, ball picks and aim" },
        { "Intel", "radar", "Opponents, the aim solver and prediction accuracy" },
        { "Rewards", "gift", "Daily quests, online rewards, check-in, mail and crates" },
        { "Settings", "settings", "Menu, themes and configs" },
    },
})
end
__modules["core/upgrades"] = function(use) -- src/games/ballvsball/core/upgrades.luau
-- Card ids are engine keys; upgradeChoice is indexed by the corresponding Chinese config id.
--
-- Two ways to judge a card. Upgrades.score reads its star rating out of the cloud config and adds
-- a bonus where its text lines up with the ball's traits: cheap, always available, and a guess.
-- Upgrades.bestBySimulation is the real answer, because a card is not a description -- it is an
-- entry in the statLevels and secondary-trait tables the server hands to the battle simulation.
-- Project the card into those tables, replay the next round with the game's own code, and the
-- question "which of these three wins" stops being a keyword match. The heuristic stays as the
-- tie-break and as the fallback for round 1, where there is no seed to replay against.
local Env = use("core/env")
local Sim = use("core/sim")
local Upgrades = {}

local function textOf(value)
    if type(value) ~= "table" then
        return tostring(value or "")
    end
    return table.concat({ tostring(value.behaviorKey or ""), tostring(value.displayName or ""),
        tostring(value.cnId or ""), tostring(value.trigger or "") }, " ")
end

local function contains(text, words)
    for _, word in ipairs(words) do
        if string.find(text, word, 1, true) then
            return true
        end
    end
    return false
end

function Upgrades.definition(candidate)
    if type(candidate) ~= "table" or type(candidate.id) ~= "string" then
        return nil
    end
    local battle = rawget(Env.Game, "BattleConfig")
    if not battle then return nil end
    local stats = type(battle.tournament_upgrade) == "table" and battle.tournament_upgrade.basicStats or nil
    local defs = candidate.kind == "effect" and battle.traits
        or candidate.kind == "basicStat" and stats
    local effect = type(defs) == "table" and defs[candidate.id] or nil
    local choice = Env.loadModule("Config").upgradeChoice
    local choices = type(choice) == "table" and choice.byTargetCnId or nil
    if type(choices) ~= "table" then
        return nil, effect
    end
    return choices[effect and effect.cnId or candidate.id], effect
end

function Upgrades.score(candidate, roleId, secondary)
    local choice, effect = Upgrades.definition(candidate)
    local star = choice and tonumber(choice.star) or 0
    if not choice then
        return -math.huge, nil -- unknown metadata must not be mistaken for a one-star card
    end
    local config, battle = Env.loadModule("Config"), Env.loadModule("BattleConfig")
    local ball = config.ball.byCnId[roleId]
    local role = battle.roles and battle.roles[roleId]
    local traitsByKey = type(battle.traits) == "table" and battle.traits or {}
    local active = { textOf(ball), textOf(role and role.skill) }
    -- Cloud ball.skills contains Chinese skill ids; resolve them to engine behavior keys.
    for _, id in ipairs(ball and ball.skills or {}) do
        active[#active + 1] = textOf(id)
        for key, trait in pairs(traitsByKey) do
            if type(trait) == "table" and trait.cnId == id then
                active[#active + 1] = key .. " " .. textOf(trait)
            end
        end
    end
    for _, id in ipairs(type(secondary) == "table" and secondary or {}) do
        active[#active + 1] = textOf(id) .. " " .. textOf(traitsByKey[id])
    end
    local traits = string.lower(table.concat(active, " "))
    local target = string.lower(candidate.id .. " " .. textOf(effect) .. " " .. textOf(choice))
    local bonus = 0
    if contains(traits, { "blade", "axe", "burst" })
        and contains(target, { "attackspeed", "attack speed", "bounceaccel", "bounce accel", "ballhitaccel" }) then
        bonus = 15
    elseif contains(traits, { "poison", "acid", "snake", "venom", "virus" })
        and contains(target, { "poisonduration", "poison duration", "poisonampl", "poison ampl", "lastingpoison", "damageamplification", "venom" }) then
        bonus = 15
    elseif contains(traits, { "electric", "electro", "voltaic" })
        and contains(target, { "stun", "paraly", "paralysis", "shockduration", "shock duration" }) then
        bonus = 15
    elseif candidate.id == "hp" or candidate.id == "LowHpArmor"
        or contains(target, { "defense", "shield", "health", "maxhp", "thick skin" }) then
        bonus = 3
    end
    return star * 10 + bonus, star
end

local function usable(candidate)
    return type(candidate) == "table" and type(candidate.id) == "string"
        and (candidate.kind == "effect" or candidate.kind == "basicStat")
end

function Upgrades.best(candidates, roleId, secondary)
    local best, bestScore, maxStar, known = nil, -math.huge, 0, true
    for _, candidate in ipairs(candidates) do
        local score, star = Upgrades.score(candidate, roleId, secondary)
        known = known and star ~= nil
        maxStar = math.max(maxStar, star or 0)
        if usable(candidate) and (not best or score > bestScore) then
            best, bestScore = candidate, score
        end
    end
    return best, maxStar, known
end

-- Projection -----------------------------------------------------------------------------------

-- Replaces one level of a container so the original (the live replay options) is never touched.
local function branch(container, key)
    local copy = table.clone(container)
    copy[key] = type(container[key]) == "table" and table.clone(container[key]) or nil
    return copy
end

-- Where our entry lives in a replay's per-team tables: one value per team in a 1v1, a list by seat
-- in a 2v2. `teamMode` says which, and the stored shape has to agree before anything is projected:
-- a mismatch means the game changed how it keys these, and simulating a guessed layout would be
-- worse than the heuristic it is meant to replace.
local function seat(container, team, index, teamMode)
    local value = type(container) == "table" and container[team]
    if type(value) ~= "table" then
        return nil
    end
    local perSeat = type(value[1]) == "table"
    if perSeat ~= (teamMode == true) then
        return nil
    end
    if not perSeat then
        return value
    end
    return type(value[index]) == "table" and value[index] or nil
end

-- The round's simulation inputs with `candidate` applied, or nil when the layout is unfamiliar.
-- A basic stat raises its level by one; an effect is appended to our secondary traits, which is
-- how the server records a chosen trait card.
function Upgrades.project(candidate, statLevels, traits, team, index, teamMode)
    if not usable(candidate) then
        return nil
    end
    if candidate.kind == "basicStat" then
        local current = seat(statLevels, team, index, teamMode)
        if not current or type(current[candidate.id]) ~= "number" then
            return nil
        end
        local projected = branch(statLevels, team)
        local target = projected[team]
        if teamMode then
            target[index] = table.clone(target[index])
            target = target[index]
        end
        target[candidate.id] += 1
        return projected, traits
    end
    local current = seat(traits, team, index, teamMode)
    if not current then
        return nil
    end
    for _, held in ipairs(current) do
        if held == candidate.id then
            return nil -- already carried; the card would change nothing to simulate
        end
    end
    local projected = branch(traits, team)
    local target = projected[team]
    if teamMode then
        target[index] = table.clone(target[index])
        target = target[index]
    end
    target[#target + 1] = candidate.id
    return statLevels, projected
end

-- Simulated selection -------------------------------------------------------------------------

-- Picks the card that actually wins the next round.
--
-- context = {
--   seed                      -- next round's seed (Match.nextSeed); nil means no simulation
--   team, index, teamMode     -- which entry in the per-team tables is ours
--   roles, directions         -- every ball and launch direction, keyed by team as in a replay
--   statLevels, traits, arena -- the round's inputs, from the last replay
--   roleId, secondary         -- for the heuristic tie-break
--   deadline, valid
-- }
--
-- Returns the card, a line explaining it, and the simulated outcome (1 win, 0.5 draw, 0 loss), or
-- nil when nothing could be simulated in time and the caller should fall back to Upgrades.best.
function Upgrades.bestBySimulation(candidates, context)
    if not context.seed or not Sim.ready() or type(context.roles) ~= "table"
        or type(context.directions) ~= "table" then
        return nil
    end
    local maxDuration = Sim.maxDuration(context.arena)
    local function play(statLevels, traits)
        local winner, elapsed = Sim.run(context.seed, context.roles, context.directions, statLevels, traits,
            context.arena, context.deadline, context.valid)
        if not winner then
            return nil
        end
        return Sim.outcome(winner, context.team), Sim.score(winner, elapsed, context.team, maxDuration)
    end

    -- The same round without any card, so the report can say what the choice is worth.
    local baseline = play(context.statLevels, context.traits)
    local best, bestOutcome, bestScore, bestHeuristic, tried = nil, -1, -1, -math.huge, 0
    for _, candidate in ipairs(candidates) do
        if os.clock() >= context.deadline or (context.valid and not context.valid()) then
            break
        end
        local statLevels, traits = Upgrades.project(candidate, context.statLevels, context.traits,
            context.team, context.index, context.teamMode)
        if statLevels then
            local outcome, score = play(statLevels, traits)
            if outcome then
                tried += 1
                local heuristic = Upgrades.score(candidate, context.roleId, context.secondary)
                -- Outcome first, then how fast, then the star/synergy guess for a genuine tie.
                if outcome > bestOutcome
                    or (outcome == bestOutcome and score > bestScore)
                    or (outcome == bestOutcome and score == bestScore and heuristic > bestHeuristic) then
                    best, bestOutcome, bestScore, bestHeuristic = candidate, outcome, score, heuristic
                end
            end
        end
        Sim.breathe()
    end
    if not best or tried < 2 then
        return nil -- one simulated card is not a comparison
    end
    local result = bestOutcome >= 1 and "wins" or bestOutcome >= 0.5 and "draws" or "loses"
    local change = baseline and bestOutcome > baseline and " (turns the round around)"
        or baseline and bestOutcome < baseline and " (best of a losing round)" or ""
    return best, string.format("%s: simulated, %s next round%s", best.id, result, change), bestOutcome
end

return Upgrades
end
__modules["features/duel"] = function(use) -- src/games/ballvsball/features/duel.luau
-- Duel tab: queue with Quick Play, pick the ball, aim, and queue again.
--
-- Picks: inventory choices use the free pick, then a pick voucher or diamonds when enabled.
-- DuelTableBallSelectPurchase lists eligible choices; DuelTableBallSelfSelect confirms one. "Smart"
-- simulates each offered ball against what everyone else played last round once the round's seed is
-- known (round 2 on, see core/match); otherwise, and in round 1, balls go by their win rate across
-- all players.
--
-- Aim: the launch direction decides the battle. Smart aim runs the game's own simulation for each
-- direction and locks the one that wins most. From round 2 the seed is exact and most players keep
-- the same direction every round, so the prediction is usually right; in round 1 it can only pick
-- the direction that wins most often over random seeds. 2v2 works the same way with four balls: the
-- replays key balls and directions by team and seat, the 2v2 board has its own arena, and the
-- server relays the teammate's aim while they drag it.

local Env = use("core/env")
local Life = use("shared/life")
local Ui = use("core/ui")
local Match = use("core/match")
local Sim = use("core/sim")
local Solver = use("core/solver")
local Profile = use("core/profile")
local Stats = use("core/stats")
local Limits = use("core/limits")
local Upgrades = use("core/upgrades")
local Trajectory = use("core/trajectory")

local Options = Ui.Options

local QUEUE_INTERVAL = 6 -- seconds between Quick Play requests while unseated
local PICK_WINDOW = 30 -- seconds the game gives to pick (and to aim)
local PICK_MARGIN = 4 -- answer this long before the game picks for us
local FREE_LIST_WAIT = 4
local LOCK_WAIT = 3
local PICK_DIRECTIONS = 12 -- directions tried per ball when picking by simulation
local AIM_DIRECTIONS = 36
local OPPONENT_SWEEP = 10 -- opponent launch directions the guaranteed floor is measured over
local REROLL_WAIT, REROLL_COOLDOWN = 3, 5
-- Round 1 has no seed, so there is no grid to solve: every scenario is a guessed seed and the
-- opponent's aim can only be averaged over. More think time buys more guesses.
local ROUND_ONE_SAMPLES, ROUND_ONE_MAX = 6, 14
-- 2v2: think once the teammate's aim has stopped moving this long (or when time runs short).
local TEAMMATE_SETTLE = 2
-- 2v2 Smart picks wait up to this long into the pick timer for the teammate to lock their ball,
-- leaving at least PICK_THINK_RESERVE seconds to simulate.
local TEAMMATE_PICK_WAIT, PICK_THINK_RESERVE = 12, 8

local MODES = { "1v1 (3 HP)", "2v2" }
local QUEUE_REMOTE = { ["1v1 (3 HP)"] = "DuelQuickPlayRequest", ["2v2"] = "Duel2v2QuickPlayRequest" }
local STRATEGIES = { "Smart", "Best win rate", "First offered", "Selected inventory ball" }

-- Ball names for the "Never pick" list.
local ballNames = {}
for _, ball in ipairs(Env.loadModule("Config").ball.list) do
    if ball.canPlayerUse then
        ballNames[#ballNames + 1] = ball.displayName
    end
end
table.sort(ballNames)

local tab = Ui.Tabs.Duel
local auto = tab:AddGroupbox({ Side = "Left", Name = "Auto duel", IconName = "swords" })
auto:AddToggle("AutoDuel", {
    Text = "Auto duel",
    Default = false,
    Tooltip = "Queues with Quick Play, picks your ball, aims, and queues again after each match.",
})
Ui.automation("AutoDuel")
auto:AddDropdown("DuelMode", { Text = "Mode", Values = MODES, Default = MODES[1] })
auto:AddToggle("StopAtCoinCap", {
    Text = "Stop at the coin cap",
    Default = true,
    Tooltip = "Duels pay nothing past the daily (and weekly) coin cap. Stops after the match in progress.",
})
auto:AddButton({
    Text = "Leave the table",
    Func = function()
        Env.event("DuelTableLeaveRequest"):FireServer()
    end,
    Tooltip = "Mid-match this forfeits.",
})

local picks = tab:AddGroupbox({ Side = "Left", Name = "Ball picks", IconName = "circle-dot" })
picks:AddDropdown("PickStrategy", {
    Text = "Pick by",
    Values = STRATEGIES,
    Default = STRATEGIES[1],
    Tooltip = "Smart simulates each offered ball against the opponent's last ball once the seed is known, and uses win rates before that.",
})
picks:AddToggle("FreePick", {
    Text = "Use the free pick",
    Default = true,
    Tooltip = "Takes the best server-approved free choice, including owned balls and weekly free balls you have unlocked.",
})
local NO_INVENTORY_BALL = "Choose an inventory ball"
local inventoryByLabel, inventorySignature = {}, nil
local function inventoryChoices()
    local items = Env.data("items")
    if type(items) ~= "table" then
        return nil
    end
    local labels, ids, seen = { NO_INVENTORY_BALL }, {}, {}
    for _, item in pairs(items) do
        if type(item) == "table" and item.itemType == "Ball" and type(item.itemId) == "string"
            and (item.ownerUserId == nil or item.ownerUserId == Env.LocalPlayer.UserId) and not seen[item.itemId] then
            local definition = Env.loadModule("Config").ball.byCnId[item.itemId]
            if definition and definition.canPlayerUse ~= false then
                seen[item.itemId] = true
                local label = Env.ballName(item.itemId) .. " [" .. item.itemId .. "]"
                ids[label] = item.itemId
                labels[#labels + 1] = label
            end
        end
    end
    table.sort(labels, function(a, b)
        if a == NO_INVENTORY_BALL then return b ~= NO_INVENTORY_BALL end
        if b == NO_INVENTORY_BALL then return false end
        return a < b
    end)
    return labels, ids
end
local initialInventory, initialIds = inventoryChoices()
inventoryByLabel = initialIds or {}
picks:AddDropdown("InventoryBall", {
    Text = "Inventory ball", Values = initialInventory or { NO_INVENTORY_BALL },
    Default = NO_INVENTORY_BALL, Searchable = true,
    Tooltip = "Set Pick by to Selected inventory ball to use this ball whenever the game allows it. The list follows your inventory.",
})
picks:AddToggle("PaidInventoryPick", {
    Text = "Allow paid inventory picks", Default = false,
    Tooltip = "After the free pick, allows the game's normal cost: a pick voucher first, otherwise your existing diamonds. Applies to every picking round while Auto duel is on.",
})
local inventoryCostLabel = picks:AddLabel("Inventory picks: waiting for a ball offer.", true)
local function selectedInventoryBall()
    if Options.PickStrategy.Value == "Selected inventory ball" then
        return inventoryByLabel[Options.InventoryBall.Value]
    end
end
local function inventoryPickAvailable(offer)
    local price = offer and offer.selectPrice
    if type(price) ~= "number" or price < 0 or price ~= price or price == math.huge then
        return false, "Inventory selection is unavailable."
    end
    if price == 0 then
        return true, "Inventory pick: free."
    end
    local vouchers = Env.data("vouchers")
    local count = type(vouchers) == "table" and tonumber(vouchers["指定卡"]) or 0
    if (count or 0) >= 1 then
        return Ui.on("PaidInventoryPick"), "Inventory pick: 1 pick voucher" .. (Ui.on("PaidInventoryPick") and "." or " (paid picks off).")
    end
    local enough = (tonumber(Env.data("diamonds")) or 0) >= price
    local suffix = not Ui.on("PaidInventoryPick") and " (paid picks off)." or not enough and " (not enough diamonds)." or "."
    return Ui.on("PaidInventoryPick") and enough, string.format("Inventory pick: %s diamonds%s", tostring(price), suffix)
end
Life.loop("duel:inventory", 3, function()
    local labels, ids = inventoryChoices()
    if labels then
        local signature = table.concat(labels, "\0")
        inventoryByLabel = ids
        if signature ~= inventorySignature then
            inventorySignature = signature
            Env.elevate()
            Options.InventoryBall:SetValues(labels)
        end
    end
    if not Life.alive then return end
    Env.elevate()
    if Match.seated() and Match.phase() == "Picking" and not Match.ballLocked then
        local _, text = inventoryPickAvailable(Match.offer)
        Env.elevate()
        inventoryCostLabel:SetText(text)
    else
        inventoryCostLabel:SetText("Inventory picks: available while choosing a ball.")
    end
end)
picks:AddDropdown("NeverPick", {
    Text = "Never pick",
    Values = ballNames,
    Multi = true,
    Searchable = true,
    Default = {},
})
picks:AddToggle("RerollBadOffers", {
    Text = "Reroll bad offers", Default = true,
    Tooltip = "Rerolls once when every offered ball is excluded or below the threshold. Diamond rerolls require the separate option below.",
})
picks:AddToggle("UseOwnedDiamondsForRerolls", {
    Text = "Use owned diamonds for rerolls", Default = false,
    Tooltip = "Allows ball and upgrade rerolls only when your existing diamonds cover the price. Off by default to avoid the game's Robux top-up prompt.",
})
picks:AddSlider("RerollThreshold", {
    Text = "Reroll below", Default = 50, Min = 30, Max = 70, Rounding = 0, Suffix = "%",
    Tooltip = "Rerolls when every offered ball's win rate across all players is below this. Higher holds out for strong balls but spends more rerolls.",
})
picks:AddSlider("PickDelay", {
    Text = "Pick after",
    Default = 2,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Suffix = "s",
    Tooltip = "Waits this long before picking. The pick always goes in before the game's timer ends.",
})

local aimBox = tab:AddGroupbox({ Side = "Right", Name = "Aim", IconName = "crosshair" })
aimBox:AddToggle("SmartAim", {
    Text = "Smart aim",
    Default = true,
    Tooltip = "Simulates the round for each launch direction with the game's own battle code and locks the best. Also aims for you when you play yourself.",
})
aimBox:AddToggle("AimTrajectory", {
    Text = "Show aim prediction", Default = true,
    Callback = function(value)
        if not value then
            Trajectory.clear()
        end
    end,
})
aimBox:AddDropdown("AimStyle", {
    Text = "Play style",
    Values = { "Balanced", "Exploit", "Safe" },
    Default = "Balanced",
    Tooltip = "Exploit answers the aim this opponent is expected to use. Safe takes the direction with the best worst case, so a surprise aim cannot blow the round out. Balanced weighs both, and all three lean safer at 1 hp and bolder when the opponent is on their last.",
})
aimBox:AddSlider("AimThinkTime", {
    Text = "Think time",
    Default = 10,
    Min = 3,
    Max = 22,
    Rounding = 0,
    Suffix = "s",
    Tooltip = "Longer tries more of the opponent's possible aims. Each simulation stalls the game for a moment.",
})
aimBox:AddLabel("From round 2 the seed is exact and every ball is locked, so the round is solved as a grid: your directions against theirs. You get the aim that beats the opponent you expect and the one that cannot be punished, and the Intel tab shows which is which.", true)

local matchBox = tab:AddGroupbox({ Side = "Right", Name = "Match", IconName = "activity" })
local panel = Ui.panel(matchBox, 6)
local upgrades = tab:AddGroupbox({ Side = "Left", Name = "Upgrades", IconName = "sparkles" })
upgrades:AddToggle("RerollLowUpgrades", {
    Text = "Reroll one-star offers", Default = true,
    Tooltip = "Rerolls once if every card is one star. Diamond rerolls also require Use owned diamonds for rerolls under Ball picks.",
})
upgrades:AddToggle("SimulateUpgrades", {
    Text = "Simulate upgrade cards", Default = true,
    Tooltip = "A card is an entry in the stat and trait tables the battle simulation reads, so each one can be played out instead of guessed at. Needs a known seed; before that, and whenever the card tables are not in a shape it recognises, the star rating decides.",
})
local upgradeLabel = upgrades:AddLabel("Cards score 10 per star, +15 for a matching ball trait, or +3 for defense, shield and health.", true)

-- Session tally --------------------------------------------------------------------------------

local session = { rounds = { won = 0, lost = 0, draw = 0 }, matches = { won = 0, lost = 0 }, coins = 0 }
Match.status = "Off"
local prediction = nil -- { text, ... } for the round being played
-- The last rounds, newest last, for checking predictions: what was assumed and what happened.
local history = {}
local HISTORY_SIZE = 30
-- Published on Match, the way `status` already is, so features/intel can report on the solver
-- without a feature having to use() another feature (and rebuild its tab if that one failed).
Match.history, Match.session = history, session

local function directionsMatch(a, b)
    return typeof(a) == "Vector2" and typeof(b) == "Vector2" and (a - b).Magnitude < 1e-3
end

local function otherTeam(team)
    return team == "Blue" and "Yellow" or "Blue"
end

-- Balls or directions for everyone at the table, keyed by team the way the simulation and the
-- replays have them: one value per team in a 1v1, a list by seat in a 2v2.
local function byTeam(players, valueOf)
    local out = {}
    local teamMode = Match.teamSize() > 1
    for _, player in ipairs(players) do
        if teamMode then
            out[player.team] = out[player.team] or {}
            out[player.team][player.index] = valueOf(player)
        else
            out[player.team] = valueOf(player)
        end
    end
    return out
end

-- "Ray Ball + Spider Ball" for a team's entry in a replay's selectedRoles.
local function teamBalls(roles, team)
    local value = type(roles) == "table" and roles[team]
    if type(value) ~= "table" then
        return Env.ballName(value)
    end
    local names = {}
    for _, role in ipairs(value) do
        names[#names + 1] = Env.ballName(role)
    end
    return table.concat(names, " + ")
end

Match.onRound(function(replay, won)
    local rounds = session.rounds
    if won == nil then
        rounds.draw += 1
    elseif won then
        rounds.won += 1
    else
        rounds.lost += 1
    end
    if prediction then
        prediction.result = won
    end
    local options = replay.replayOptions or {}
    local team = Match.team()
    local entry = {
        round = replay.round,
        won = won,
        balls = string.format("%s vs %s", teamBalls(options.selectedRoles, team), teamBalls(options.selectedRoles, otherTeam(team))),
    }
    if prediction and prediction.seed then
        -- Was the seed right, and did everyone else aim where we assumed?
        entry.seedRight = prediction.seed == replay.seed
        local kept, opponents, opponentsKept = true, 0, 0
        for _, player in ipairs(Match.players()) do
            local assumed = prediction.assumed[player.userId]
            local same = assumed ~= nil
                and directionsMatch(assumed, Match.forPlayer(options.initialDirections, player.team, player.index))
            if assumed and not same then
                kept = false
            end
            if player.teammate then
                entry.teammateKeptAim = same
            elseif not player.me then
                opponents += 1
                opponentsKept += same and 1 or 0
            end
        end
        entry.othersKeptAim = kept
        entry.opponentsKeptAim = string.format("%d/%d", opponentsKept, opponents)
        entry.opponentsKept, entry.opponents = opponentsKept, opponents
        entry.predicted = prediction.predicted
        entry.expected, entry.worst = prediction.expected, prediction.worst
    end
    -- Learn from the round regardless of whether we predicted it. keepsAim compares the replay
    -- that just landed against the one before it, which is exactly "did they launch there again",
    -- and is nil in round 1 where there is nothing to compare and nothing to learn.
    for _, player in ipairs(Match.players()) do
        if not player.me then
            Profile.observe(player.userId, Match.keepsAim(player),
                Match.forPlayer(options.selectedRoles, player.team, …
