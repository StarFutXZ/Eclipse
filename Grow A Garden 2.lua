
if type(getgenv) ~= "function" then
	local _env = _G
	getgenv = function()
		return _env
	end
end
pcall(function()
	local g = (getgenv and getgenv()) or _G
	if type(g) == "table" then
		g.GAG2_FARM_LOADED = true
	end
end)

local CFG = {
	configVersion = 16,
	scriptVersion = "10.13.0",
	autoStart = true,
	pipelineMode = true,
	fastFarm = true,
	farmActivePause = 0.08,
	farmIdlePause = 0.12,
	harvestLoopInterval = 0.05,
	harvestPassesPerCycle = 4,
	harvestTeleportStep = 8,
	actionFps = 60, -- FPS cap during harvest/collect/water bursts (idle stays at fpsCap)
	harvestClusterRange = 45, -- collect everything within this radius of one anchor (server allows ~55)
	maintenanceInterval = 14,
	petManagerInterval = 12,
	buyMaxSecondsActive = 2.5,
	cycleInterval = 2,
	minMoneyKeep = 500,
	inventoryLimit = 100,
	inventorySellAt = 92,
	harvestBatchSoftLimit = 88,
	harvestMaxPerCycle = 220,
	harvestLogTop = 8,
	onlyHarvestRipe = true,
	harvestDynamicMinRatio = 0.05,
	harvestDynamicMinWhenBestAbove = 500,
	buyGearWhenMoneyAbove = 50,
	gearMinMoneyReserve = 80000,
	wateringCanMinMoneyReserve = 3000,
	buySeedsFallbackBelowTier = false, -- never plant cheap junk (Strawberry sells 3); Bamboo backbone fills the plot
	buyFallbackOnlyBelowMoney = 20000,
	buyTrustFire = false,
	maxBuySeconds = 6,
	maxBuyAttemptsPerCycle = 4,
	seedBuyBlockSeconds = 90,
	buyCratesWhenMoneyAbove = 25000,
	autoExpandGarden = true,
	maxGardenExpansionBought = 20,
	antiAfkInterval = 60,
	-- Anti idle-kick (VirtualUser + micro-nudge). serverGuard = recover after server hop / respawn.
	antiKick = { enabled = true, nudgeInterval = 55, virtualUser = true, idleKickSec = 600 },
	serverGuard = { enabled = true, watchInterval = 4, recoverCooldown = 8, staleHeartbeatSec = 30 },
	maxActionDistance = 14,
	teleportHeight = 2.5,
	wateringCans = { "Super Watering Can", "Common Watering Can" },
	sprinklers = {
		-- Super is strictly better value than Legendary in current game data:
		-- Super $300k r55 growx5 sizeLuck100 vs Legendary $1.2m r40 growx4 sizeLuck65.
		"Super Sprinkler",
		"Rare Sprinkler",
		"Uncommon Sprinkler",
		"Common Sprinkler",
	},
	-- Never PLANT these (mail/event reserve). Already-planted crops are still harvested & sold.
	skipSeeds = { "Rainbow", "Gold" },
	eventOnlySeeds = { "Rainbow", "Gold" },
	priorityBuySeeds = {
		-- Bamboo is the backbone crop: cheap (~700), ALWAYS in stock (~80% restock),
		-- fast (120s prime), high value (sell 800, yield 7-11). The old maxOwned=6
		-- left a ~200-slot plot to fill with Strawberry (sell 3). Fill it with Bamboo.
		Bamboo = { minMoney = 700, maxPerCycle = 30, maxOwned = 400 },
		Mushroom = { minMoney = 12000, maxPerCycle = 5, maxOwned = 40 },
	},
	minBuySeedScore = 600, -- only buy seeds worth >= this (avg yield x sell); Bamboo=7200/GlowMushroom=700 pass, junk (Strawberry 13, Coconut 60, Tulip 210) fails
	-- never buy a seed whose shop price > score*ratio (blocks traps like Banana $30k)
	maxPriceScoreRatio = 8,
	-- Idle-capacity fill: expansions can grow the plot far past Bamboo's restock
	-- supply, leaving most of it empty (and capital idle) during Bamboo droughts.
	-- When the priority crop is out of stock AND real empty spots remain, plant the
	-- best in-stock affordable crop as a filler. Fillers are cleanupSeeds, so Bamboo
	-- reclaims their spots on the next restock. Relaxes minBuySeedScore but KEEPS the
	-- ROI gate, so trap seeds (Banana) stay blocked.
	fillIdleWithFallback = true,
	fallbackFillMinScore = 80, -- relaxed filler floor (Corn passes; pure trash blocked)
	fallbackFillMinFreeSpots = 20, -- only fill when >= this many spots are genuinely idle
	skipPlantBelowPrice = 0,
	skipHarvestBelowScore = 0,
	-- Harvest EVERYTHING ripe. The old high thresholds (150/80/40) skipped
	-- low-value fruit, which then sat ripe forever and clogged the plot so no
	-- new (good) seeds could be planted -> money bled. Always clearing the
	-- plot keeps it cycling; planting logic decides VALUE, harvest just clears.
	harvestScoreTiers = {
		{ money = 0, minScore = 0 },
	},
	maxSeedsPerCycle = 12,
	maxPlantsPerCycle = 24,
	plantFallbackBelowTier = true,
	sprinklerGridStep = 14,
	sprinklerMinDistance = 10,
	maxSprinklersPerCycle = 6,
	wildPetScanInterval = 0.25,
	wildPetRushInterval = 0.05,
	wildPetDetectEvery = 1,
	wildPetMaxTameAttempts = 4,
	wildPetRushAttempts = 20,
	wildPetTameDistance = 14,
	wildPetInstantListen = true,
	eventCollectInterval = 0.35,
	eventCollectIntervalWeather = 0.1,
	eventRushInterval = 0.06,
	eventRushSpawnWait = 0.03,
	eventInstantListen = true,
	eventBurstDuringWeather = true,
	eventBurstMaxSeconds = 6,
	eventMaxPerSweep = 24,
	eventReadyTimeout = 1.2,
	eventCollectDistance = 12,
	eventSpawnWait = 0.15,
	collectSeedPacks = true,
	logToFile = true,
	logToConsole = false,
	silent = true,
	verboseLogs = true,
	telemetryErrors = true,
	telemetryVerbose = false,
	telemetryStatusInterval = 120,
	logFlushInterval = 2,
	logMaxPending = 200,
	optimizeClient = true,
	optimizeInterval = 20,
	memoryTrimInterval = 120,
	lowPower = true,
	fpsCap = 8,
	disable3DRender = true,
	muteAudio = true,
	dashboard = { enabled = true, toggleKey = "RightShift", opacity = 1, liveInterval = 0.5 },
	harvestDebug = false,
	cleanupLowValuePlants = true,
	cleanupMoneyAbove = 3000,
	cleanupMinBestScore = 0,
	cleanupMaxPerCycle = 20,
	cleanupRetryCooldown = 45,
	cleanupOnlyWhenGardenFull = false, -- purge junk plants continuously to convert the plot to Bamboo/high-value faster
	cleanupReplacementMinScore = 1000,
	cleanupReplacementRatio = 0.5,
	cleanupSeeds = {
		Carrot = true,
		Blueberry = true,
		Apple = true,
		Strawberry = true,
		Tomato = true,
		Corn = true,
		Grape = true,
		Pineapple = true,
		Cactus = true,
		["Green Bean"] = true,
		Banana = true,
		Coconut = true,
		Tulip = true,
		["Baby Cactus"] = true,
		Mango = true,
		["Dragon Fruit"] = true,
	},
	harvestDebugInterval = 30,
	harvestDebugImportantSeeds = {
		Bamboo = true,
		Mushroom = true,
		["Moon Bloom"] = true,
		["Dragon's Breath"] = true,
		["Venus Fly Trap"] = true,
	},
	mail = {
		enabled = true,
		targetUsername = "",
		message = "GAG2 auto mail",
		autoClaim = true,
		claimCooldown = 8,
		maxClaimsPerCycle = 16,
		pets = { "Raccoon", "Dragonfly", "Unicorn" },
		seeds = { "Rainbow", "Gold" },
		minPetPriority = 70, -- mail any pet with priority >= this (covers Golden/variant rares)
		keepBestPetCount = 0,
		keepSeedMinCount = 0, -- farm accounts never plant Rainbow/Gold -> mail ALL of them
		maxPetsPerCycle = 18, -- batch up to ~18 pets in one SendBatch (server cap ~20 items/gift)
		maxSeedsPerCycle = 18, -- server caps a gift at ~20 items total (pets + seeds)
		maxPerSeed = 50,
		cooldown = 8, -- server gift cooldown ~10s; 8 keeps us ready without spamming
		loopInterval = 10,
	},
	-- Pet policy (overridable from getgenv). farm = pets equipped for utility
	-- (Deer = +10% grow speed). priority/keep = rare pets we always tame and
	-- mail to main (never equipped). Anything not listed here is ignored.
	pets = {
		farm = { "Deer" },
		priority = { "Raccoon", "Dragonfly", "Unicorn" },
	},
	smartPets = {
		maxPerCycle = 1,
		rushPriority = 70,
		rushMaxPerCycle = 10,
		rushMaxSpendFraction = 0.98,
		rushAttempts = 20,
		minPriorityForEmptySlot = 30,
		minUpgradeGain = 10,
		maxSpendFraction = 0.35,
		reserveFraction = 0.25,
		reserveFlat = 5000,
		skipCommonBelowPriority = 30,
		forceReequip = true,
	},
	enabled = {
		harvest = true,
		sell = true,
		plant = true,
		water = true,
		gear = true,
		buy = true,
		crates = true,
		expansion = true,
		antiAfk = true,
		events = true,
		pets = true,
		wildPets = true,
	},
	smartWater = {
		enabled = true,
		rewaterAfterMinutes = 8,
		sweepInterval = 8,
		maxPerSweep = 24,
		logEmptyEvery = 20,
	},
	moneyTiers = {
		{ money = 50000, minSeedPrice = 500 },
		{ money = 20000, minSeedPrice = 100 },
		{ money = 5000, minSeedPrice = 25 },
		{ money = 1000, minSeedPrice = 5 },
		{ money = 0, minSeedPrice = 0 },
	},
	-- Discord webhook routing is done SERVER-SIDE (URLs never live in this script).
	-- Client only reports natural catches; the license server decides where to forward.
	webhook = {
		reportPets = true, -- report naturally-obtained pets to the server
		detectNewPets = true, -- detect brand-new pet GUIDs (not only wild-tamed)
		mailSuppressSeconds = 60, -- treat new pets within N sec of mailbox activity as mail (skip)
	},
	-- snapshot pushed to getgenv().GAG2_STATS for the web cabinet / admin live view
	statsSnapshot = { enabled = true, interval = 4 },
}

-- A table is treated as a "list" (config array) when it has a [1] element or
-- is empty. Lists are REPLACED wholesale on merge (so shrinking e.g. mail.pets
-- in getgenv doesn't leave stale entries); dictionaries are merged recursively.
local function isConfigList(t)
	return type(t) == "table" and (t[1] ~= nil or next(t) == nil)
end

function deepMerge(dst, src)
	if type(src) ~= "table" then
		return dst
	end
	for k, v in pairs(src) do
		if type(v) == "table" and type(dst[k]) == "table" and not isConfigList(v) then
			deepMerge(dst[k], v)
		else
			dst[k] = v
		end
	end
	return dst
end

if getgenv then
	local env = getgenv()
	if type(env.GAG2_FARM_CFG) == "table" then
		-- применяем пользовательские настройки (даже частичные)
		deepMerge(CFG, env.GAG2_FARM_CFG)
	end
	env.GAG2_FARM_CFG = CFG
end

local function copyConfigValue(v)
	if type(v) ~= "table" then
		return v
	end
	if isConfigList(v) then
		local t = {}
		for i, x in ipairs(v) do
			t[i] = x
		end
		return t
	end
	local out = {}
	for k, x in pairs(v) do
		out[k] = copyConfigValue(x)
	end
	return out
end

local REMOTE_CFG_ROOTS = { "mail", "pets", "skipSeeds", "eventOnlySeeds", "enabled" }

function exportRemoteFarmConfig()
	local out = {}
	for _, root in ipairs(REMOTE_CFG_ROOTS) do
		if CFG[root] ~= nil then
			out[root] = copyConfigValue(CFG[root])
		end
	end
	return out
end

function applyRemoteFarmConfig(overlay)
	if type(overlay) ~= "table" then
		return false
	end
	deepMerge(CFG, overlay)
	if getgenv then
		getgenv().GAG2_FARM_CFG = CFG
	end
	if type(invalidatePetPolicyCache) == "function" then
		invalidatePetPolicyCache()
	end
	if wr then
		wr("[CFG] remote config applied")
	end
	return true
end

if getgenv then
	getgenv().GAG2_EXPORT_FARM_CFG = exportRemoteFarmConfig
	getgenv().GAG2_APPLY_FARM_CFG = applyRemoteFarmConfig
	if type(getgenv().GAG2_PENDING_FARM_CFG) == "table" then
		applyRemoteFarmConfig(getgenv().GAG2_PENDING_FARM_CFG)
		getgenv().GAG2_PENDING_FARM_CFG = nil
	end
end

function applyLowPowerProfile()
	if not CFG.lowPower then
		return
	end
	if CFG.verboseLogs then
		CFG.silent = false
		CFG.logToConsole = CFG.logToConsole ~= false
		CFG.logToFile = CFG.logToFile ~= false
		CFG.logFlushInterval = math.min(tonumber(CFG.logFlushInterval) or 2, 4)
		CFG.logMaxPending = math.max(tonumber(CFG.logMaxPending) or 200, 120)
	else
		CFG.silent = CFG.silent ~= false
		CFG.logToConsole = false
		CFG.logToFile = false
	end
	if not CFG.fastFarm then
		CFG.farmActivePause = math.max(tonumber(CFG.farmActivePause) or 0.2, 0.35)
		CFG.farmIdlePause = math.max(tonumber(CFG.farmIdlePause) or 0.75, 1.1)
		CFG.harvestMaxPerCycle = math.min(tonumber(CFG.harvestMaxPerCycle) or 88, 48)
		CFG.harvestBatchSoftLimit = math.min(tonumber(CFG.harvestBatchSoftLimit) or 88, 48)
		CFG.maxPlantsPerCycle = math.min(tonumber(CFG.maxPlantsPerCycle) or 24, 14)
		CFG.maxSeedsPerCycle = math.min(tonumber(CFG.maxSeedsPerCycle) or 12, 8)
	end
	-- wild pets stay fast even in low-power (Raccoon/Dragonfly sniping)
	CFG.wildPetScanInterval = math.min(tonumber(CFG.wildPetScanInterval) or 0.35, 0.45)
	CFG.wildPetRushInterval = math.min(tonumber(CFG.wildPetRushInterval) or 0.1, 0.15)
	CFG.petManagerInterval = math.max(tonumber(CFG.petManagerInterval) or 12, 14)
	CFG.maintenanceInterval = math.max(tonumber(CFG.maintenanceInterval) or 14, 16)
	-- Rainbow/Gold + event collection stays at FULL speed in low-power (like wild-pet
	-- sniping) so overnight farming earns the same — only rendering/FPS is throttled.
	CFG.eventRushInterval = math.min(tonumber(CFG.eventRushInterval) or 0.06, 0.08)
	CFG.eventCollectIntervalWeather = math.min(tonumber(CFG.eventCollectIntervalWeather) or 0.1, 0.12)
	CFG.eventCollectInterval = math.min(tonumber(CFG.eventCollectInterval) or 0.35, 0.4)
	-- eventMaxPerSweep intentionally NOT reduced in low-power (was capped to 16).
	CFG.optimizeInterval = math.max(tonumber(CFG.optimizeInterval) or 20, 120)
	CFG.logFlushInterval = math.max(tonumber(CFG.logFlushInterval) or 2, 30)
	CFG.logMaxPending = math.min(tonumber(CFG.logMaxPending) or 200, 40)
	CFG.memoryTrimInterval = math.max(tonumber(CFG.memoryTrimInterval) or 120, 60)
	CFG.fpsCap = math.min(tonumber(CFG.fpsCap) or 8, 6)
	CFG.maintenanceInterval = math.max(tonumber(CFG.maintenanceInterval) or 14, 20)
	CFG.petManagerInterval = math.max(tonumber(CFG.petManagerInterval) or 12, 18)
	if type(CFG.dashboard) == "table" then
		CFG.dashboard.enabled = CFG.dashboard.enabled ~= false
		CFG.dashboard.liveInterval = math.max(tonumber(CFG.dashboard.liveInterval) or 0.5, 1.5)
	end
	if type(CFG.statsSnapshot) == "table" then
		CFG.statsSnapshot.interval = math.max(tonumber(CFG.statsSnapshot.interval) or 4, 20)
	end
	if type(CFG.mail) == "table" then
		CFG.mail.cooldown = math.min(tonumber(CFG.mail.cooldown) or 60, 45)
		CFG.mail.maxSeedsPerCycle = math.max(tonumber(CFG.mail.maxSeedsPerCycle) or 10, 15)
	end
end

function applyFastFarmProfile()
	if CFG.fastFarm == false then
		return
	end
	CFG.farmActivePause = math.min(tonumber(CFG.farmActivePause) or 0.08, 0.08)
	CFG.farmIdlePause = math.min(tonumber(CFG.farmIdlePause) or 0.12, 0.12)
	CFG.harvestMaxPerCycle = math.max(tonumber(CFG.harvestMaxPerCycle) or 100, 100)
	CFG.harvestBatchSoftLimit = math.max(tonumber(CFG.harvestBatchSoftLimit) or 100, 100)
	CFG.harvestLoopInterval = math.min(tonumber(CFG.harvestLoopInterval) or 0.05, 0.08)
	CFG.harvestPassesPerCycle = math.max(tonumber(CFG.harvestPassesPerCycle) or 4, 3)
	CFG.maxPlantsPerCycle = math.max(tonumber(CFG.maxPlantsPerCycle) or 24, 20)
	CFG.maxSeedsPerCycle = math.max(tonumber(CFG.maxSeedsPerCycle) or 12, 10)
	CFG.harvestTeleportStep = math.min(tonumber(CFG.harvestTeleportStep) or 8, 5)
end

applyLowPowerProfile()
applyFastFarmProfile()

getgenv().GAG2_HOOKS = {}
getgenv().GAG2_HOOK_GEN = (getgenv().GAG2_HOOK_GEN or 0) + 1
local HOOK_GEN = getgenv().GAG2_HOOK_GEN

pcall(function()
	if type(getgenv().GAG2_FARM_STOP) == "function" then
		getgenv().GAG2_FARM_STOP()
	end
end)
getgenv().GAG2_FARM_GEN = (getgenv().GAG2_FARM_GEN or 0) + 1
local FARM_GEN = getgenv().GAG2_FARM_GEN

function farmGenActive()
	return (getgenv().GAG2_FARM_GEN or 0) == FARM_GEN
end

local FARM_STATE = getgenv().GAG2_FARM_STATE
if type(FARM_STATE) ~= "table" then
	FARM_STATE = {
		running = false,
		events = false,
		wild = false,
		live = false,
		maintenance = false,
		petsMgr = false,
		harvest = false,
	}
end
getgenv().GAG2_FARM_STATE = FARM_STATE

function getFarmState()
	local st = getgenv().GAG2_FARM_STATE
	if type(st) ~= "table" then
		return nil
	end
	return st
end

function hookStillActive()
	return (getgenv().GAG2_HOOK_GEN or 0) == HOOK_GEN
end

local PET_PRIORITY = {
	Raccoon = 100,
	Unicorn = 95,
	["Golden Dragonfly"] = 90,
	GoldenDragonfly = 90,
	Dragonfly = 85,
	["Black Dragon"] = 80,
	BlackDragon = 80,
	["Ice Serpent"] = 75,
	IceSerpent = 75,
	Bee = 70,
	Owl = 40,
	Deer = 35,
	Monkey = 30,
	Robin = 28,
	Frog = 20,
	Bunny = 15,
}

-- Portal dropdown catalog (license server parses this table on deploy — add new pets here)
local GAG2_PORTAL_PETS = {
	"Raccoon",
	"Unicorn",
	"Dragonfly",
	"Golden Dragonfly",
	"Black Dragon",
	"Ice Serpent",
	"Bee",
	"Queen Bee",
	"Disco Bee",
	"Honey Bee",
	"Bear Bee",
	"Petal Bee",
	"Golden Bee",
	"Butterfly",
	"Mimic Octopus",
	"Red Fox",
	"Fennec Fox",
	"Hedgehog",
	"Blood Hedgehog",
	"Kitsune",
	"Corrupted Kitsune",
	"Owl",
	"Night Owl",
	"Cooked Owl",
	"Dog",
	"Cat",
	"Bunny",
	"Golden Lab",
	"Black Bunny",
	"Moon Cat",
	"Chicken",
	"Deer",
	"Spotted Deer",
	"Frog",
	"Echo Frog",
	"Snail",
	"Monkey",
	"Silver Monkey",
	"Giant Ant",
	"Praying Mantis",
	"Caterpillar",
	"Pig",
	"Rooster",
	"Squirrel",
	"Turtle",
	"Sea Otter",
	"Polar Bear",
	"Grey Mouse",
	"Brown Mouse",
	"Hyacinth Macaw",
	"Scarlet Macaw",
	"Toucan",
	"Capybara",
	"Pterodactyl",
	"Triceratops",
	"Dilophosaurus",
	"Stegosaurus",
	"Brontosaurus",
	"Raptor",
	"Tyrannosaurus Rex",
}

-- Real price multipliers from SharedModules.MutationData (verified in-game 2026-06).
-- The old values (Bloodlit 4, Starstruck 6, Electric 3, Frozen 3) massively
-- UNDERvalued mutated fruit, so the bot deprioritised/cleaned away 50-60x plants.
local MUTATION_MULT = {
	Bloodlit = 60,
	Starstruck = 50,
	Rainbow = 30,
	Electric = 25,
	Frozen = 14,
	Gold = 10,
	Golden = 10,
	Chained = 8,
}

local SEED_DATA = setmetatable({
	Apple = { yield = { 1, 1 }, price = 5 },
	Banana = { yield = { 1, 1 }, price = 5 },
	Grape = { yield = { 1, 1 }, price = 5 },
	Carrot = { yield = { 3, 4 }, price = 10 },
	Strawberry = { yield = { 4, 5 }, price = 15 },
	Blueberry = { yield = { 1, 2 }, price = 8 },
	Tulip = { yield = { 3, 4 }, price = 12 },
	Tomato = { yield = { 2, 3 }, price = 10 },
	Corn = { yield = { 1, 1 }, price = 5 },
	Cactus = { yield = { 1, 2 }, price = 8 },
	Pineapple = { yield = { 1, 3 }, price = 15 },
	Mushroom = { yield = { 2, 5 }, price = 20 },
	Bamboo = { yield = { 7, 11 }, price = 50 },
	Sunflower = { yield = { 1, 1 }, price = 10 },
	Coconut = { yield = { 1, 1 }, price = 10 },
	Mango = { yield = { 1, 1 }, price = 15 },
	Cherry = { yield = { 1, 1 }, price = 15 },
	Acorn = { yield = { 1, 3 }, price = 20 },
	["Green Bean"] = { yield = { 1, 2 }, price = 15 },
	["Dragon Fruit"] = { yield = { 1, 1 }, price = 30 },
	Pomegranate = { yield = { 1, 1 }, price = 25 },
	["Venus Fly Trap"] = { yield = { 1, 1 }, price = 50 },
	["Poison Apple"] = { yield = { 1, 1 }, price = 40 },
	["Moon Bloom"] = { yield = { 1, 1 }, price = 60 },
	["Dragon's Breath"] = { yield = { 1, 1 }, price = 100 },
	["Ghost Pepper"] = { yield = { 1, 1 }, price = 80 },
	["Poison Ivy"] = { yield = { 1, 1 }, price = 75 },
	["Baby Cactus"] = { yield = { 1, 1 }, price = 50 },
	["Glow Mushroom"] = { yield = { 1, 1 }, price = 100 },
	Romanesco = { yield = { 1, 1 }, price = 80 },
	["Horned Melon"] = { yield = { 1, 1 }, price = 120 },
	Gold = { yield = { 1, 1 }, price = 500 },
	Rainbow = { yield = { 1, 1 }, price = 1000 },
}, {
	__index = function()
		return { yield = { 1, 1 }, price = 10 }
	end,
})

function normalizeSeedName(raw)
	if type(raw) ~= "string" or raw == "" then
		return nil
	end
	if SEED_DATA[raw] then
		return raw
	end
	local lower = raw:lower()
	for name in pairs(SEED_DATA) do
		if name:lower() == lower then
			return name
		end
	end
	-- event drops often arrive as "Rainbow Seed" / "Gold Seed" in tools or inventory
	local base = lower:gsub("%s+seed%s*$", "")
	if base == "golden" then
		base = "gold"
	end
	if base ~= lower then
		for name in pairs(SEED_DATA) do
			if name:lower() == base then
				return name
			end
		end
	end
	return raw
end

local GEAR_PRICES = {}
local EXPANSION_PRICES = {}
local SELL_VALUES = {
	Carrot = 5,
	Strawberry = 3,
	Tomato = 9,
	Blueberry = 5,
	Apple = 12,
	Pinetree = 100,
	Bamboo = 800,
	Pumpkin = 350,
	Cactus = 40,
	Pineapple = 30,
	["Green Bean"] = 10,
	Banana = 35,
	Grape = 45,
	Mushroom = 13000,
	Coconut = 60,
	Mango = 90,
	["Thorn Rose"] = 140,
	["Dragon Fruit"] = 150,
	Acorn = 200,
	Cherry = 350,
	Sunflower = 1750,
	["Venus Fly Trap"] = 3000,
	Lotus = 6500,
	Pomegranate = 900,
	Beanstalk = 2000,
	["Poison Apple"] = 900,
	["Moon Bloom"] = 9000,
	["Dragon's Breath"] = 3400,
	["Poison Ivy"] = 1700,
	["Glow Mushroom"] = 700,
	["Ghost Pepper"] = 2500,
	["Horned Melon"] = 200,
	Corn = 34,
	["Baby Cactus"] = 70,
	Tulip = 60,
	Romanesco = 1500,
}
local CollectionService = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
while not LP do
	task.wait(0.05)
	LP = Players.LocalPlayer
end

local SharedModules, Gardens, NET
local NET_OK = false

local ownedPetCache = {}
local petIdByName = {}
local petIdToName = {}
local petIdsByName = {}
local petEquipKeyByName = {}
-- PetEquipController maps some pets to top-level inventory folders (e.g. Raccoon -> Raccoons).
local PET_INV_ALT_FOLDERS = { Raccoon = "Raccoons" }
local petEquipFailUntil = {}
local seedPriority = {}
local lastEquippedTarget = {}

local logFolder = "GAG2_FARM_LOGS"
local logFileName = "gag2_farm_" .. tostring(LP.UserId) .. ".log"
local logPath = logFolder .. "/" .. logFileName
local logFallbackPath = logFileName
local petCacheFileName = "gag2_pets_" .. tostring(LP.UserId) .. ".txt"
local petCachePath = logFolder .. "/" .. petCacheFileName
local petCacheLegacyPath = petCacheFileName
local petCacheSavePending = false
local lastPetCacheSave = 0
local lastLogFlush = 0
local pendingLog = {}
local fullLogCache = ""
local logInitDone = false
local logWarned = false

function ensureLogFolder()
	if makefolder and (not isfolder or not isfolder(logFolder)) then
		pcall(makefolder, logFolder)
	end
end

function cleanupLegacyPetWorkspaceFiles()
	if not delfile or not isfile then
		return
	end
	local removed = 0
	local function tryDelete(path)
		if isfile(path) then
			pcall(delfile, path)
			removed = removed + 1
		end
	end
	-- Old single-file cache at workspace root (content was Bunny/Deer/Frog/Owl lines).
	tryDelete(petCacheLegacyPath)
	-- Some executors created one file per pet name from older builds — purge them.
	for name in pairs(PET_PRIORITY) do
		tryDelete(name)
		tryDelete(name .. ".txt")
	end
	if removed > 0 then
		wr(string.format("[CFG] cleaned %d legacy pet file(s) from workspace root", removed))
	end
end

function initLogFile()
	if logInitDone then
		return
	end
	logInitDone = true
	if not CFG.logToFile or not writefile then
		return
	end
	ensureLogFolder()
	local header = string.format("\n=== GAG2 Farm log start %s user=%d ===\n", os.date("%Y-%m-%d %H:%M:%S"), LP.UserId)
	pcall(writefile, logPath, header)
	pcall(writefile, logFallbackPath, header)
end

function flushLogs(force)
	if not CFG.logToFile or not writefile then
		return
	end
	initLogFile()
	if not force and os.clock() - lastLogFlush < CFG.logFlushInterval then
		return
	end
	if #pendingLog == 0 then
		return
	end
	lastLogFlush = os.clock()
	local chunk = table.concat(pendingLog, "\n") .. "\n"
	table.clear(pendingLog)
	local ok1, ok2
	if appendfile then
		ok1 = pcall(appendfile, logPath, chunk)
		ok2 = pcall(appendfile, logFallbackPath, chunk)
	else
		fullLogCache = fullLogCache .. chunk
		ok1 = pcall(writefile, logPath, fullLogCache)
		ok2 = pcall(writefile, logFallbackPath, fullLogCache)
	end
	if not ok1 and not ok2 and not logWarned then
		logWarned = true
		warn("[FARM] log write failed: executor file API rejected writefile/appendfile")
	end
end

-- ==========================================================================
--  Telemetry -> license server (errors with stack + context for admin panel)
-- ==========================================================================
local telemetryDedup = {}

function traceErr(err, level)
	level = level or 2
	if debug and debug.traceback then
		return debug.traceback(tostring(err), level)
	end
	return tostring(err)
end

function shouldReportTelemetry(msg, level)
	if level == "fatal" then
		return true
	end
	if level == "error" and CFG.telemetryErrors ~= false then
		return true
	end
	if not CFG.telemetryVerbose then
		return false
	end
	if level == "warn" then
		return true
	end
	local s = tostring(msg):lower()
	return s:find("exception", 1, true) or s:find("crash", 1, true)
end

function installGlobalErrorReporter()
	if getgenv().GAG2_ERROR_HOOK then
		return
	end
	getgenv().GAG2_ERROR_HOOK = true
	pcall(function()
		game:GetService("ScriptContext").Error:Connect(function(msg, trace)
			if CFG.telemetryErrors == false then
				return
			end
			local text = tostring(msg)
			if not text:find("GAG2", 1, true) and not text:find("FARM", 1, true) then
				return
			end
			reportTelemetry({
				level = "fatal",
				message = text:sub(1, 500),
				stack = type(trace) == "string" and trace:sub(1, 4000) or nil,
				context = { phase = "ScriptContext" },
			})
		end)
	end)
end

function safeDefer(label, fn)
	task.defer(function()
		if not hookStillActive() then
			return
		end
		local ok, err = xpcall(fn, traceErr)
		if not ok then
			reportTelemetry({
				level = "fatal",
				message = tostring(label) .. ": " .. tostring(err),
				stack = tostring(err),
				context = { phase = label },
			})
		end
	end)
end

function buildTelemetryContext(extra)
	local ctx = {
		scriptVersion = CFG.scriptVersion,
		cycle = STATS and STATS.cycles or 0,
		money = STATS and STATS.money or 0,
		lastStatus = STATS and STATS.lastStatus or "",
		user = LP and LP.Name or nil,
		userId = LP and LP.UserId or nil,
		placeId = game.PlaceId,
		jobId = game.JobId,
		netOk = NET_OK == true,
		plot = LP and LP:GetAttribute("PlotId") or nil,
		mailTarget = CFG.mail and CFG.mail.targetUsername or nil,
		uptimeSec = STATS and math.floor(os.clock() - (STATS.startClock or os.clock())) or 0,
	}
	if type(extra) == "table" then
		for k, v in pairs(extra) do
			ctx[k] = v
		end
	end
	return ctx
end

function reportTelemetry(opts)
	opts = opts or {}
	local level = opts.level or "error"
	local message = tostring(opts.message or opts.msg or "unknown")
	if message == "" then
		return
	end

	local sig = level .. "|" .. message:sub(1, 160)
	local now = os.clock()
	if telemetryDedup[sig] and (now - telemetryDedup[sig]) < 25 then
		return
	end
	telemetryDedup[sig] = now

	local stack = opts.stack or opts.trace
	if not stack and (level == "error" or level == "fatal") then
		stack = traceErr(message, 3)
	end

	local fn = getgenv().GAG2_REPORT_TELEMETRY
	if type(fn) ~= "function" then
		if CFG.telemetryErrors or CFG.verboseLogs then
			wr("[TELEM] reporter missing — runtime not loaded yet")
		end
		return
	end
	pcall(fn, {
		type = "telemetry",
		level = level,
		message = message,
		stack = stack,
		context = buildTelemetryContext(opts.context),
		ts = os.time(),
	})
end

function wr(msg)
	local toConsole = CFG.verboseLogs or (CFG.logToConsole and not CFG.silent)
	if toConsole then
		print(msg)
	end
	if not CFG.logToFile then
		return
	end
	local line = os.date("%H:%M:%S") .. " -- " .. tostring(msg)
	table.insert(pendingLog, line)
	local cap = tonumber(CFG.logMaxPending) or 200
	while #pendingLog > cap do
		table.remove(pendingLog, 1)
	end
	flushLogs(false)
end

function skipLoadingScreen()
	pcall(function()
		LP:SetAttribute("LoadingScreenActive", false)
	end)
	pcall(function()
		LP:SetAttribute("LoadingScreenDone", true)
	end)
	pcall(function()
		local gui = LP:FindFirstChild("PlayerGui")
		if not gui then
			return
		end
		for _, c in gui:GetChildren() do
			if c:IsA("ScreenGui") then
				local n = c.Name:lower()
				if n:find("loading") or c:GetAttribute("LoadingScreen") then
					c.Enabled = false
				end
			end
		end
	end)
	pcall(function()
		local cam = workspace.CurrentCamera
		if cam and cam.CameraType == Enum.CameraType.Scriptable then
			cam.CameraType = Enum.CameraType.Custom
		end
		local lsc = cam and cam:FindFirstChild("LoadingScreenCam")
		if lsc then
			lsc:Destroy()
		end
	end)
end

function waitForChildTimeout(parent, name, timeoutSec)
	local existing = parent:FindFirstChild(name)
	if existing then
		return existing
	end
	return parent:WaitForChild(name, timeoutSec)
end

function waitForCoreAssets(timeoutSec)
	timeoutSec = timeoutSec or 120
	local deadline = os.clock() + timeoutSec
	wr("[BOOT] Waiting for ReplicatedStorage.SharedModules...")
	skipLoadingScreen()

	local sm
	while os.clock() < deadline do
		skipLoadingScreen()
		sm = RS:FindFirstChild("SharedModules")
		if sm then
			break
		end
		task.wait(0.25)
	end
	if not sm then
		sm = waitForChildTimeout(RS, "SharedModules", math.max(1, deadline - os.clock()))
	end
	if not sm then
		wr("[BOOT] ERROR: SharedModules missing — game not loaded")
		return nil, nil, nil
	end

	local gardens = workspace:FindFirstChild("Gardens")
		or waitForChildTimeout(workspace, "Gardens", math.max(1, deadline - os.clock()))

	if not LP.Character then
		pcall(function()
			LP.CharacterAdded:Wait()
		end)
	end

	skipLoadingScreen()
	pcall(function()
		LP:SetAttribute("LoadingScreenDone", true)
	end)

	local netMod = waitForChildTimeout(sm, "Networking", math.max(1, deadline - os.clock()))
	local net
	if netMod then
		local ok, result = pcall(require, netMod)
		if ok then
			net = result
		end
	end

	wr(string.format("[BOOT] Core assets OK (NET=%s Gardens=%s)", net and "yes" or "no", gardens and "yes" or "no"))
	return sm, gardens, net
end

SharedModules, Gardens, NET = waitForCoreAssets(120)
NET_OK = NET ~= nil

function saveOwnedPets(force)
	if not writefile then
		return
	end
	local now = os.clock()
	if not force and now - lastPetCacheSave < 5 then
		petCacheSavePending = true
		return
	end
	lastPetCacheSave = now
	petCacheSavePending = false
	ensureLogFolder()
	local list = {}
	-- Persist only farm/priority pets — never Bunny/Owl/Frog junk in workspace files.
	for name in pairs(ownedPetCache) do
		if isWantedPet(name) then
			table.insert(list, name)
		end
	end
	table.sort(list)
	pcall(writefile, petCachePath, table.concat(list, "\n"))
end

function loadOwnedPets()
	if not readfile or not isfile then
		return
	end
	cleanupLegacyPetWorkspaceFiles()
	local path = isfile(petCachePath) and petCachePath or petCacheLegacyPath
	if not isfile(path) then
		return
	end
	local ok, data = pcall(readfile, path)
	if not ok or type(data) ~= "string" then
		return
	end
	for line in data:gmatch("[^\r\n]+") do
		local name = line:match("^%s*(.-)%s*$")
		if name ~= "" then
			ownedPetCache[name] = true
		end
	end
end

loadOwnedPets()

local STATS = {
	startClock = os.clock(),
	startMoney = nil,
	money = 0,
	inv = 0,
	invLimit = CFG.inventoryLimit,
	harvested = 0,
	soldCount = 0,
	soldValue = 0,
	bought = 0,
	planted = 0,
	petsEquipped = {},
	bestPets = "-",
	cycles = 0,
	lastStatus = "starting...",
	mailStatus = "pending",
	weather = "",
	eventSeeds = {},
	eventSeedsLine = "-",
}

function getPetPriority(name)
	if not name then
		return 0
	end
	return PET_PRIORITY[name] or PET_PRIORITY[name:gsub("%s+", "")] or 0
end

function countKnownPets()
	local n = 0
	for name in pairs(ownedPetCache) do
		if isWantedPet(name) then
			n = n + 1
		end
	end
	return n
end

function getPetUpgradeFloor()
	local maxSlots = LP:GetAttribute("MaxEquippedPets") or 3
	local priorities = {}
	for name in pairs(ownedPetCache) do
		table.insert(priorities, getPetPriority(name))
	end
	table.sort(priorities, function(a, b)
		return a > b
	end)
	if #priorities < maxSlots then
		return 0, maxSlots - #priorities
	end
	return priorities[maxSlots] or 0, 0
end

-- skipSeeds gate: block planting only. Harvest/sell ignores this list.
function isNoPlantSeed(name)
	if type(name) ~= "string" or name == "" then
		return false
	end
	local norm = normalizeSeedName(name) or name
	for _, sn in ipairs(CFG.skipSeeds or {}) do
		if sn == name or sn == norm then
			return true
		end
	end
	return false
end

function shouldPlantSeed(name)
	return not isNoPlantSeed(name)
end

function isEventOnlySeed(name)
	for _, sn in ipairs(CFG.eventOnlySeeds or { "Rainbow", "Gold" }) do
		if sn == name then
			return true
		end
	end
	return false
end

function isShopBuyBlocked(name)
	return isEventOnlySeed(name)
end

function getPriorityBuyCfg(name)
	local list = CFG.priorityBuySeeds
	if type(list) ~= "table" then
		return nil
	end
	local cfg = list[name]
	if type(cfg) == "table" then
		return cfg
	end
	for _, entry in ipairs(list) do
		if type(entry) == "string" and entry == name then
			return {}
		end
		if type(entry) == "table" and entry.seed == name then
			return entry
		end
	end
	return nil
end

function reprice()
	local scored = {}
	for name, data in pairs(SEED_DATA) do
		if isNoPlantSeed(name) then
			continue
		end
		local avg = (data.yield[1] + data.yield[2]) / 2
		local sellValue = SELL_VALUES[name] or data.price
		table.insert(scored, { name = name, pps = avg * sellValue, price = data.price })
	end
	table.sort(scored, function(a, b)
		if a.pps ~= b.pps then
			return a.pps > b.pps
		end
		return a.price > b.price
	end)
	seedPriority = {}
	for _, s in ipairs(scored) do
		table.insert(seedPriority, s.name)
	end
	if scored[1] then
		wr(
			string.format(
				"[CFG] Top seeds: %s(%.0f) %s(%.0f) %s(%.0f)",
				scored[1].name,
				scored[1].pps,
				scored[2] and scored[2].name or "-",
				scored[2] and scored[2].pps or 0,
				scored[3] and scored[3].name or "-",
				scored[3] and scored[3].pps or 0
			)
		)
	end
end

function loadPrices()
	if not SharedModules then
		return
	end
	local mod = SharedModules:FindFirstChild("SeedData")
	if mod then
		local ok, data = pcall(require, mod)
		if ok and type(data) == "table" then
			local n = 0
			for _, v in pairs(data) do
				if type(v) == "table" and v.SeedName and v.PurchasePrice and SEED_DATA[v.SeedName] then
					SEED_DATA[v.SeedName].price = v.PurchasePrice
					n = n + 1
				end
			end
			if n > 0 then
				wr(string.format("[CFG] Loaded %d seed prices", n))
			end
		end
	end
	local mod2 = SharedModules:FindFirstChild("GearShopData")
	if mod2 then
		local ok, data = pcall(require, mod2)
		if ok and type(data) == "table" and type(data.Data) == "table" then
			for _, item in pairs(data.Data) do
				if type(item) == "table" and item.ItemName and item.Cost then
					GEAR_PRICES[item.ItemName] = item.Cost
				end
			end
			wr("[CFG] Loaded gear prices")
		end
	end
	local sharedData = RS:FindFirstChild("SharedData")
	local expMod = sharedData and sharedData:FindFirstChild("ExpansionPrices")
	if expMod then
		local ok3, mod3 = pcall(require, expMod)
		if ok3 and type(mod3) == "table" then
			for i, entry in ipairs(mod3) do
				if type(entry) == "table" and entry.Price then
					EXPANSION_PRICES[i] = entry.Price
				end
			end
			if #EXPANSION_PRICES > 0 then
				wr(string.format("[EXPAND] Loaded %d expansion prices", #EXPANSION_PRICES))
			end
		end
	end
	if #EXPANSION_PRICES == 0 then
		EXPANSION_PRICES = { 5000, 25000, 100000, 500000, 2500000 }
	end
	local sellMod = SharedModules:FindFirstChild("SellValueData")
	if sellMod then
		local ok4, sellData = pcall(require, sellMod)
		if ok4 and type(sellData) == "table" then
			for k, v in pairs(sellData) do
				if type(v) == "number" then
					SELL_VALUES[k] = v
				end
			end
		end
	end
end

if SharedModules then
	loadPrices()
	reprice()
else
	wr("[BOOT] Skipped price load — SharedModules unavailable")
end

function isFailMessage(v)
	if v == false then
		return true
	end
	if v == nil then
		return false
	end
	if type(v) == "string" then
		local lo = v:lower()
		if
			lo:find("fail")
			or lo:find("error")
			or lo:find("invalid")
			or lo:find("denied")
			or lo:find("reject")
			or lo:find("cannot")
			or lo:find("can't")
			or lo:find("too far")
			or lo:find("cooldown")
			or lo:find("wait")
			or lo:find("not ")
			or lo:find("no inventory")
		then
			return true
		end
	end
	if type(v) == "table" then
		if v.Success == false or v.Ok == false then
			return true
		end
		if type(v.Reason) == "string" and isFailMessage(v.Reason) then
			return true
		end
		if type(v.Error) == "string" and isFailMessage(v.Error) then
			return true
		end
	end
	return false
end

function callRemote(remote, ...)
	if not remote then
		return false, nil, "no remote"
	end
	local fn = remote.Invoke or remote.Fire
	if not fn then
		return false, nil, "no fn"
	end
	local ok, a, b, c = pcall(fn, remote, ...)
	if not ok then
		return false, nil, tostring(a)
	end
	-- Mailbox SendBatch/Claim return (success:boolean, errMsg:string)
	if type(a) == "boolean" then
		if a then
			return true, a, b
		end
		return false, a, tostring(b or "remote rejected")
	end
	if isFailMessage(a) then
		return false, a, tostring(a)
	end
	if isFailMessage(b) then
		return false, b, tostring(b)
	end
	return true, a, nil
end

function getPetNet()
	return NET and (NET.Pets or (NET.Actions and NET.Actions.Pets))
end

function getMailNet()
	if not NET then
		return nil
	end
	if NET.Mailbox then
		return NET.Mailbox
	end
	if NET.Actions and NET.Actions.Mailbox then
		return NET.Actions.Mailbox
	end
	return nil
end

function normalizeMailUsername(raw)
	if type(raw) ~= "string" then
		return ""
	end
	local name = raw:gsub("^%s*@?", ""):gsub("%s+$", "")
	return name
end

function findMyPlot()
	if not Gardens then
		return nil
	end
	for _, p in Gardens:GetChildren() do
		if p:GetAttribute("OwnerUserId") == LP.UserId then
			return p
		end
	end
end

function getPlotId(plot)
	if not plot then
		return 0
	end
	local n = plot.Name:match("Plot(%d+)")
	return n and tonumber(n) or 0
end

function getPlotRemoteIds(plot)
	local ids, seen = {}, {}
	local function add(v)
		v = tonumber(v)
		if v and v >= 0 and not seen[v] then
			seen[v] = true
			table.insert(ids, v)
		end
	end
	add(LP:GetAttribute("PlotId"))
	local plotId = getPlotId(plot)
	add(plotId - 1) -- SimpleSpy for Plot4 showed trailing \003.
	add(plotId)
	if #ids == 0 then
		add(0)
	end
	return ids
end

function getMoney()
	local ls = LP:FindFirstChild("leaderstats")
	local s = ls and ls:FindFirstChild("Sheckles")
	return s and s.Value or 0
end

function getBuyMoneyReserve(forPrice)
	forPrice = forPrice or 0
	local money = getMoney()
	local keep = CFG.minMoneyKeep or 0
	if LP:GetAttribute("TutorialComplete") == false then
		return 0
	end
	if CollectionService:HasTag(LP, "InTutorial") then
		return 0
	end
	if money < keep + forPrice then
		return math.max(0, money - forPrice)
	end
	return keep
end

function canAffordSeed(price)
	return getMoney() >= price + getBuyMoneyReserve(price)
end

function getHRP()
	local char = LP.Character
	return char and char:FindFirstChild("HumanoidRootPart")
end

function distTo(pos)
	local hrp = getHRP()
	if not hrp then
		return math.huge
	end
	return (hrp.Position - pos).Magnitude
end

function teleportNear(pos, maxDist)
	maxDist = maxDist or CFG.maxActionDistance
	local hrp = getHRP()
	if not hrp then
		return false
	end
	if distTo(pos) <= maxDist then
		return true
	end
	hrp.CFrame = CFrame.new(pos)
	task.wait(0.06)
	return distTo(pos) <= maxDist + 4
end

-- ===== Action FPS burst + paced firing (perf-critical) =====
-- lowPower idles at a low FPS cap to save CPU, but the Packet networking layer
-- coalesces multiple Fires issued in the SAME frame into one (only ~1 lands).
-- So action throughput is FPS-bound. We briefly raise the cap during action
-- bursts (harvest/collect/water) and yield one frame between fires so each lands.
local _RunSvc = game:GetService("RunService")
local _burstDepth, _idleFps = 0, nil
function fpsBurstBegin()
	if type(setfpscap) ~= "function" then
		return
	end
	if _burstDepth == 0 then
		_idleFps = (CFG.fpsCap and CFG.fpsCap > 0) and CFG.fpsCap or 8
		pcall(setfpscap, CFG.actionFps or 60)
	end
	_burstDepth = _burstDepth + 1
end
function fpsBurstEnd()
	if type(setfpscap) ~= "function" then
		return
	end
	_burstDepth = math.max(0, _burstDepth - 1)
	if _burstDepth == 0 then
		pcall(setfpscap, _idleFps or 8)
	end
end
-- Fire a remote then yield exactly one frame so the Packet layer flushes it.
function firePaced(remote, ...)
	local ok = callRemote(remote, ...)
	_RunSvc.Heartbeat:Wait()
	return ok
end

function teleportToPlot(plot)
	if shouldDeferFarmTeleport() then
		return false
	end
	local vis = plot and plot:FindFirstChild("Visual")
	if not vis then
		return false
	end
	for _, c in vis:GetChildren() do
		if c.Name:find("PlantAreaColumn") and c:IsA("BasePart") then
			return teleportNear(c.Position + Vector3.new(0, CFG.teleportHeight, 0), 999)
		end
	end
	for _, c in vis:GetChildren() do
		if c:IsA("BasePart") then
			return teleportNear(c.Position + Vector3.new(0, CFG.teleportHeight, 0), 999)
		end
	end
	return false
end

function getPlantAreaParts(plot)
	local parts = {}
	local vis = plot and plot:FindFirstChild("Visual")
	if not vis then
		return parts
	end
	for _, c in vis:GetDescendants() do
		if c:IsA("BasePart") and CollectionService:HasTag(c, "PlantArea") then
			table.insert(parts, c)
		end
	end
	if #parts == 0 then
		for _, c in vis:GetChildren() do
			if c:IsA("BasePart") and c.Name:find("PlantArea") then
				table.insert(parts, c)
			end
		end
	end
	if #parts == 0 then
		for _, c in vis:GetChildren() do
			if c:IsA("BasePart") then
				table.insert(parts, c)
			end
		end
	end
	return parts
end

function raycastPlantArea(plot, worldPos)
	local parts = getPlantAreaParts(plot)
	if #parts == 0 then
		return worldPos
	end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = parts
	local origin = Vector3.new(worldPos.X, worldPos.Y + 80, worldPos.Z)
	local hit = workspace:Raycast(origin, Vector3.new(0, -200, 0), params)
	return hit and hit.Position or worldPos
end

function waterRemotePos(hitPos)
	-- WateringcanController fires UseWateringCan(hit.Position - Vector3(0, 0.3, 0), ...).
	-- The old -35 offset put the point ~35 studs below the plant => server "too far away".
	return hitPos - Vector3.new(0, 0.3, 0)
end

function getStock(folderName, itemName)
	local sv = RS:FindFirstChild("StockValues")
	local shop = sv and sv:FindFirstChild(folderName)
	local items = shop and shop:FindFirstChild("Items")
	local nv = items and items:FindFirstChild(itemName)
	return (nv and nv:IsA("NumberValue") and nv.Value) or 0
end

function getToolsByAttr(attr)
	local tools = {}
	local backpack = LP:FindFirstChildOfClass("Backpack")
	if backpack then
		for _, t in backpack:GetChildren() do
			if t:IsA("Tool") and t:GetAttribute(attr) then
				table.insert(tools, t)
			end
		end
	end
	local char = LP.Character
	if char then
		for _, t in char:GetChildren() do
			if t:IsA("Tool") and t:GetAttribute(attr) then
				table.insert(tools, t)
			end
		end
	end
	return tools
end

function findToolsByNames(names)
	local out, seen = {}, {}
	local function check(container)
		if not container then
			return
		end
		for _, t in container:GetChildren() do
			if not t:IsA("Tool") or seen[t] then
				continue
			end
			for _, n in ipairs(names) do
				if t.Name == n or t.Name:find("Watering", 1, true) then
					seen[t] = true
					table.insert(out, t)
					break
				end
			end
		end
	end
	check(LP:FindFirstChildOfClass("Backpack"))
	check(LP.Character)
	return out
end

function petInventoryReady()
	local ok, state = pcall(function()
		local mod = RS:FindFirstChild("ClientModules") and RS.ClientModules:FindFirstChild("PlayerStateClient")
		if not mod then
			return nil
		end
		local client = require(mod)
		local replica = client.GetLocalReplica and client:GetLocalReplica()
		return replica and replica.Data
	end)
	if not ok or type(state) ~= "table" then
		return false
	end
	local inv = state.Inventory
	return type(inv) == "table" and type(inv.Pets) == "table"
end

function getPlayerReplicaData()
	local ok, data = pcall(function()
		local mod = RS:FindFirstChild("ClientModules") and RS.ClientModules:FindFirstChild("PlayerStateClient")
		if not mod then
			return nil
		end
		local client = require(mod)
		local replica = client.GetLocalReplica and client:GetLocalReplica()
		return replica and replica.Data
	end)
	if ok and type(data) == "table" then
		return data
	end
end

local seedBuyBlock = {}
local lastNoBuyReason = ""
local lastNoBuyLog = 0

function isSeedBuyBlocked(name)
	local untilT = seedBuyBlock[name]
	return untilT ~= nil and os.clock() < untilT
end

function blockSeedBuy(name)
	seedBuyBlock[name] = os.clock() + (CFG.seedBuyBlockSeconds or 90)
end

function clearSeedBuyBlocks()
	seedBuyBlock = {}
end

function getPersonalSeedStock(name)
	local data = getPlayerReplicaData()
	if not data then
		return nil
	end
	local buckets = {
		data.SeedShop and data.SeedShop.Stock,
		data.SeedShop and data.SeedShop.Items,
		data.SeedShopStock,
		data.Shops and data.Shops.SeedShop,
		data.ShopStocks and data.ShopStocks.SeedShop,
	}
	for _, bucket in ipairs(buckets) do
		if type(bucket) == "table" then
			local v = bucket[name]
			if type(v) == "number" then
				return v
			end
			if type(v) == "table" then
				return v.Stock or v.Count or v.Amount
			end
		end
	end
	return nil
end

function getSeedShopStock(name)
	if isSeedBuyBlocked(name) then
		return 0
	end
	local personal = getPersonalSeedStock(name)
	if personal ~= nil then
		return personal
	end
	return getStock("SeedShop", name)
end

function getOwnedSeedCount(name)
	local total = 0
	for _, tool in ipairs(getToolsByAttr("SeedTool")) do
		local st = tool:GetAttribute("SeedTool") or tool.Name
		if st == name then
			local qty = tool:GetAttribute("Quantity")
				or tool:GetAttribute("Amount")
				or tool:GetAttribute("Count")
				or tool:GetAttribute("Stack")
			total = total + (qty or 1)
		end
	end
	local data = getPlayerReplicaData()
	local seeds = data and data.Inventory and data.Inventory.Seeds
	if type(seeds) == "table" then
		local v = seeds[name]
		if type(v) == "number" then
			total = total + v
		elseif type(v) == "table" then
			total = total + (v.Count or v.Amount or v.Quantity or v.Qty or 0)
		end
	end
	return total
end

function getTotalOwnedSeedCount()
	local total = 0
	for _, tool in ipairs(getToolsByAttr("SeedTool")) do
		local qty = tool:GetAttribute("Quantity")
			or tool:GetAttribute("Amount")
			or tool:GetAttribute("Count")
			or tool:GetAttribute("Stack")
		total = total + (qty or 1)
	end
	local data = getPlayerReplicaData()
	local seeds = data and data.Inventory and data.Inventory.Seeds
	if type(seeds) == "table" then
		for _, v in pairs(seeds) do
			if type(v) == "number" then
				total = total + v
			elseif type(v) == "table" then
				total = total + (v.Count or v.Amount or v.Quantity or v.Qty or 0)
			end
		end
	end
	return total
end

local lastSeedRestockRequest = 0

function hookSeedShopEvents()
	if not NET or not NET.SeedShop then
		return
	end
	getgenv().GAG2_HOOKS = getgenv().GAG2_HOOKS or {}
	if getgenv().GAG2_HOOKS.seedShop then
		return
	end
	getgenv().GAG2_HOOKS.seedShop = true
	local pr = NET.SeedShop.PersonalRestock
	if pr and pr.OnClientEvent then
		pr.OnClientEvent:Connect(function()
			clearSeedBuyBlocks()
		end)
	end
end

function refreshSeedShopState()
	if not NET or not NET.SeedShop then
		return
	end
	local now = os.clock()
	if now - lastSeedRestockRequest < 15 then
		return
	end
	lastSeedRestockRequest = now
	local pr = NET.SeedShop.PersonalRestock
	if pr and pr.Fire then
		pcall(pr.Fire, pr)
	end
	task.wait(0.15)
end

function firePurchaseSeed(name)
	local remote = NET and NET.SeedShop and NET.SeedShop.PurchaseSeed
	if not remote or not remote.Fire then
		return false, "no remote"
	end
	local ok, resp = pcall(remote.Fire, remote, name)
	if not ok then
		return false, tostring(resp)
	end
	if isFailMessage(resp) then
		return false, tostring(resp)
	end
	return true
end

function getMinSeedPriceForMoney(money)
	for _, tier in ipairs(CFG.moneyTiers) do
		if money >= tier.money then
			return tier.minSeedPrice
		end
	end
	return 0
end

function getSeedScore(name)
	local d = SEED_DATA[name]
	if not d then
		return 0
	end
	local avg = (d.yield[1] + d.yield[2]) / 2
	return avg * (SELL_VALUES[name] or d.price)
end

-- ROI gate: a seed is worth buying only if its shop price isn't absurd vs its
-- per-harvest value. Stops the bot from wasting money on trap seeds (e.g. Banana
-- at $30000 that sells for ~35). Plants regrow forever, so a small ratio is safe.
function seedRoiOk(name)
	local d = SEED_DATA[name]
	if not d then
		return true
	end
	local ratio = CFG.maxPriceScoreRatio or 0
	if ratio <= 0 then
		return true
	end
	local score = getSeedScore(name)
	if score <= 0 then
		return false
	end
	return (d.price or 10) <= score * ratio
end

function getMinHarvestScoreForMoney(money)
	local minScore = CFG.skipHarvestBelowScore or 0
	for _, tier in ipairs(CFG.harvestScoreTiers or {}) do
		if money >= tier.money then
			minScore = math.max(minScore, tier.minScore or 0)
			break
		end
	end
	return minScore
end

function equipTool(t)
	local char = LP.Character
	if not char then
		return false
	end
	pcall(function()
		t.Parent = char
	end)
	task.wait(0.1)
	return t.Parent == char
end

function unequipTool(t)
	pcall(function()
		t.Parent = LP.Backpack
	end)
end

local ownedGear = {}
local gearCacheExpiry = 0

function refreshOwnedGear()
	if os.clock() < gearCacheExpiry and next(ownedGear) then
		return ownedGear
	end
	ownedGear = {}
	if not NET or not NET.GearShop then
		return ownedGear
	end
	local fn = NET.GearShop.RequestEquippableState.Invoke or NET.GearShop.RequestEquippableState.Fire
	local ok, r = pcall(fn, NET.GearShop.RequestEquippableState)
	if ok and type(r) == "table" then
		local raw = r.OwnedEquippableGears
		if type(raw) == "table" then
			for k, v in pairs(raw) do
				if type(v) == "string" then
					ownedGear[v] = true
				elseif type(k) == "string" then
					ownedGear[k] = true
				end
			end
			for _, v in ipairs(raw) do
				if type(v) == "string" then
					ownedGear[v] = true
				end
			end
		end
	end
	gearCacheExpiry = os.clock() + 8
	return ownedGear
end

function hasGear(name)
	refreshOwnedGear()
	return ownedGear[name] == true
end

function equipGear(name)
	if not NET or not NET.GearShop then
		return false
	end
	return callRemote(NET.GearShop.EquipGear, name)
end

function previewInventory()
	if not NET or not NET.NPCS or not NET.NPCS.PreviewSellAll then
		return nil
	end
	local fn = NET.NPCS.PreviewSellAll.Invoke or NET.NPCS.PreviewSellAll.Fire
	local ok, prev = pcall(fn, NET.NPCS.PreviewSellAll)
	if ok and type(prev) == "table" then
		return prev
	end
end

function getInventoryFruitCount()
	local prev = previewInventory()
	return prev and (prev.FruitCount or 0) or 0
end

function getPlantSeedName(plant)
	if not plant then
		return nil
	end
	return plant:GetAttribute("SeedName") or plant:GetAttribute("Seed") or plant:GetAttribute("PlantName") or plant.Name
end

function getFruitName(fruit, plant)
	if not fruit then
		return getPlantSeedName(plant)
	end
	return fruit:GetAttribute("CorePartName")
		or fruit:GetAttribute("FruitName")
		or fruit:GetAttribute("SeedName")
		or getPlantSeedName(plant)
end

function getFruitScore(fruit, plant)
	local fname = getFruitName(fruit, plant)
	local sm = fruit:GetAttribute("SizeMulti") or fruit:GetAttribute("SizeMultiplier") or 1
	local mut = tostring(
		fruit:GetAttribute("Mutation") or fruit:GetAttribute("MutationName") or plant:GetAttribute("Mutation") or ""
	)
	local base = SELL_VALUES[fname] or (SEED_DATA[fname] and SEED_DATA[fname].price) or 10
	local mutMult = MUTATION_MULT[mut] or 1
	if mut ~= "" and mutMult == 1 then
		mutMult = 1.5
	end
	return base * (sm ^ 2.65) * mutMult
end

local sellAll

function isFruitReady(fruit)
	if not CFG.onlyHarvestRipe then
		return true
	end
	local age = fruit:GetAttribute("Age")
	local maxAge = fruit:GetAttribute("MaxAge")
	if age and maxAge and age < maxAge then
		return false
	end
	local ready = fruit:GetAttribute("FruitGrowthReady")
	if ready == false then
		return false
	end
	return true
end

function fruitLabel(entry)
	return string.format("%s %.0f", tostring(entry.fruit or entry.seed), entry.score or 0)
end

function getPlantPos(plant)
	local base = plant:FindFirstChild("Base")
	if base then
		return base.Position
	end
	local pp = plant.PrimaryPart
	if pp then
		return pp.Position
	end
	local ok, pivot = pcall(plant.GetPivot, plant)
	if ok then
		return pivot.Position
	end
end

function getInstancePos(inst)
	if not inst then
		return nil
	end
	if inst:IsA("BasePart") then
		return inst.Position
	end
	if inst:IsA("Model") then
		return getPlantPos(inst)
	end
	local parentModel = inst:FindFirstAncestorWhichIsA("Model")
	if parentModel then
		return getPlantPos(parentModel)
	end
end

local lastHarvestDebug = 0

function collectFruits(plot)
	if not CFG.enabled.harvest or not NET or not NET.Garden then
		return 0, 0, 0
	end
	local pl = plot:FindFirstChild("Plants")
	if not pl then
		return 0, 0, 0
	end

	local entries = {}
	local minHarvestScore = getMinHarvestScoreForMoney(getMoney())
	local debugSeeds = {}
	local plantById = {}
	local seenKeys = {}
	for _, plant in pl:GetChildren() do
		if not plant:IsA("Model") then
			continue
		end
		local pid = plant:GetAttribute("PlantId")
		if pid then
			plantById[pid] = plant
		end
		local ff = pid and plant:FindFirstChild("Fruits")
		local seedName = getPlantSeedName(plant)
		if not ff then
			if CFG.harvestDebugImportantSeeds[seedName] then
				local childNames = {}
				for _, child in ipairs(plant:GetChildren()) do
					table.insert(childNames, child.ClassName .. ":" .. child.Name)
					if #childNames >= 6 then
						break
					end
				end
				debugSeeds[plant.Name] = {
					seed = seedName,
					children = #plant:GetChildren(),
					ids = 0,
					ready = 0,
					noFolder = true,
					age = plant:GetAttribute("Age"),
					maxAge = plant:GetAttribute("MaxAge"),
					plantReady = plant:GetAttribute("PlantGrowthReady"),
					childList = table.concat(childNames, "|"),
				}
			end
			continue
		end
		local pos = getPlantPos(plant)
		local seenFids = {}
		local debugInfo = CFG.harvestDebugImportantSeeds[seedName]
				and {
					seed = seedName,
					children = #ff:GetChildren(),
					ids = 0,
					ready = 0,
				}
			or nil
		local fruitNodes = {}
		for _, node in ff:GetChildren() do
			table.insert(fruitNodes, node)
		end
		for _, node in ff:GetDescendants() do
			table.insert(fruitNodes, node)
		end
		for _, fruit in ipairs(fruitNodes) do
			local fid = fruit:GetAttribute("FruitId")
			if fid and not seenFids[fid] then
				seenFids[fid] = true
				if debugInfo then
					debugInfo.ids = debugInfo.ids + 1
				end
				if isFruitReady(fruit) then
					if debugInfo then
						debugInfo.ready = debugInfo.ready + 1
					end
					local score = getFruitScore(fruit, plant)
					if score >= minHarvestScore then
						seenKeys[pid .. "|" .. fid] = true
						table.insert(entries, {
							pid = pid,
							fid = fid,
							score = score,
							pos = getInstancePos(fruit) or pos,
							seed = getPlantSeedName(plant),
							fruit = getFruitName(fruit, plant),
						})
					end
				end
			end
		end
		if debugInfo then
			debugSeeds[plant.Name] = debugInfo
		end
	end

	-- Universal pass: plants harvested via HarvestPrompt without a Fruits/FruitId folder
	-- (e.g. Bamboo, Mushroom). The game collects these via CollectFruit(PlantId, FruitId or "").
	local okTagged, tagged = pcall(function()
		return CollectionService:GetTagged("HarvestPrompt")
	end)
	if okTagged and type(tagged) == "table" then
		local promptCount = 0
		for _, prompt in ipairs(tagged) do
			if promptCount >= 400 then
				break
			end
			promptCount = promptCount + 1
			if prompt:GetAttribute("Collected") then
				continue
			end
			local host = prompt.Parent
			local ancestor = host and host:FindFirstAncestorWhichIsA("Model")
			if not ancestor then
				continue
			end
			local apid = ancestor:GetAttribute("PlantId")
			local plant = apid and plantById[apid]
			if not plant then
				continue
			end
			local afid = ancestor:GetAttribute("FruitId") or ""
			local key = apid .. "|" .. afid
			if seenKeys[key] then
				continue
			end
			seenKeys[key] = true
			local fruitInst = (afid ~= "" and ancestor:GetAttribute("FruitId")) and ancestor or nil
			local score
			if fruitInst then
				score = getFruitScore(fruitInst, plant)
			else
				local sn = getPlantSeedName(plant)
				score = SELL_VALUES[sn] or (SEED_DATA[sn] and SEED_DATA[sn].price) or 10
			end
			if score >= minHarvestScore then
				table.insert(entries, {
					pid = apid,
					fid = afid,
					score = score,
					pos = getInstancePos(host) or getInstancePos(ancestor) or getPlantPos(plant),
					seed = getPlantSeedName(plant),
					fruit = getPlantSeedName(plant),
				})
				if debugSeeds[plant.Name] then
					debugSeeds[plant.Name] = nil
				end
			end
		end
	end

	if CFG.harvestDebug and os.clock() - lastHarvestDebug > CFG.harvestDebugInterval then
		lastHarvestDebug = os.clock()
		for plantName, info in pairs(debugSeeds) do
			if info.ids == 0 or info.ready == 0 then
				wr(
					string.format(
						"[HARVESTDBG] %s plant=%s Fruits=%s children=%d fruitIds=%d ready=%d age=%s/%s plantReady=%s childList=%s",
						info.seed,
						plantName,
						tostring(not info.noFolder),
						info.children or 0,
						info.ids or 0,
						info.ready or 0,
						tostring(info.age or "?"),
						tostring(info.maxAge or "?"),
						tostring(info.plantReady),
						tostring(info.childList or "-")
					)
				)
			end
		end
	end
	if #entries == 0 then
		return 0, 0, 0
	end

	table.sort(entries, function(a, b)
		return a.score > b.score
	end)
	if not CFG.fastFarm and entries[1].score >= CFG.harvestDynamicMinWhenBestAbove then
		local minScore = entries[1].score * CFG.harvestDynamicMinRatio
		local filtered = {}
		for _, entry in ipairs(entries) do
			if entry.score >= minScore then
				table.insert(filtered, entry)
			end
		end
		if #filtered > 0 then
			entries = filtered
		end
	end
	local topParts = {}
	for i = 1, math.min(CFG.harvestLogTop, #entries) do
		table.insert(topParts, fruitLabel(entries[i]))
	end
	wr(
		string.format(
			"[HARVEST] %d ripe fruits | TOP: %s | worst=%.0f",
			#entries,
			table.concat(topParts, ", "),
			entries[#entries].score
		)
	)

	teleportToPlot(plot)
	local done, soldDuring, soldValueDuring, lastPos = 0, 0, 0, nil
	local invCount = getInventoryFruitCount()
	if invCount >= CFG.inventorySellAt and sellAll then
		local sold, soldVal = sellAll()
		soldDuring = soldDuring + (sold or 0)
		soldValueDuring = soldValueDuring + (soldVal or 0)
		invCount = getInventoryFruitCount()
	end
	if invCount >= CFG.inventoryLimit then
		wr(string.format("[HARVEST] skipped: inventory full after sell attempt (%d/%d)", invCount, CFG.inventoryLimit))
		return 0, soldDuring, soldValueDuring
	end
	local limit = math.min(#entries, CFG.harvestMaxPerCycle)
	-- Spatial sort so nearby fruits are consecutive -> we collect whole clusters
	-- from a single anchor (server accepts CollectFruit within ~55 studs, proven).
	-- This minimises teleports; the per-frame pacing below makes every Fire land.
	table.sort(entries, function(a, b)
		if not a.pos then
			return false
		end
		if not b.pos then
			return true
		end
		if math.abs(a.pos.X - b.pos.X) > 8 then
			return a.pos.X < b.pos.X
		end
		if math.abs(a.pos.Z - b.pos.Z) > 8 then
			return a.pos.Z < b.pos.Z
		end
		return (a.score or 0) > (b.score or 0)
	end)
	local clusterRange = CFG.harvestClusterRange or 45
	local anchor = nil
	fpsBurstBegin()
	for i = 1, limit do
		local e = entries[i]
		if invCount >= CFG.inventorySellAt and sellAll then
			local sold, soldVal = sellAll()
			soldDuring = soldDuring + (sold or 0)
			soldValueDuring = soldValueDuring + (soldVal or 0)
			invCount = getInventoryFruitCount()
			if invCount >= CFG.inventoryLimit then
				wr(string.format("[HARVEST] paused: inventory still full (%d/%d)", invCount, CFG.inventoryLimit))
				break
			end
		end
		-- Cluster anchor: only relocate when the next fruit is outside collect range.
		if e.pos and (not anchor or (e.pos - anchor).Magnitude > clusterRange) then
			local hrp = getHRP()
			if hrp then
				hrp.CFrame = CFrame.new(e.pos + Vector3.new(0, CFG.teleportHeight, 0))
			end
			anchor = e.pos
			_RunSvc.Heartbeat:Wait()
		end
		-- firePaced yields one frame after firing so the Packet layer flushes it
		-- (rapid same-frame fires get coalesced and silently dropped otherwise).
		if firePaced(NET.Garden.CollectFruit, e.pid, e.fid) then
			done = done + 1
			invCount = invCount + 1
		end
	end
	fpsBurstEnd()
	if done > 0 then
		local nextEntry = entries[done + 1]
		wr(
			string.format(
				"[HARVEST] Collected priority batch %d/%d (available=%d next=%s soldDuring=%d inv=%d/%d)",
				done,
				limit,
				#entries,
				nextEntry and fruitLabel(nextEntry) or "-",
				soldDuring,
				getInventoryFruitCount(),
				CFG.inventoryLimit
			)
		)
		if sellAll then
			local s, v = sellAll()
			soldDuring = soldDuring + (s or 0)
			soldValueDuring = soldValueDuring + (v or 0)
		end
	end
	return done, soldDuring, soldValueDuring
end

sellAll = function()
	if not CFG.enabled.sell or not NET or not NET.NPCS then
		return 0, 0
	end
	local totalS, totalP = 0, 0
	local fnPrev = NET.NPCS.PreviewSellAll.Invoke or NET.NPCS.PreviewSellAll.Fire
	local fnSell = NET.NPCS.SellAll.Invoke or NET.NPCS.SellAll.Fire
	for _ = 1, 50 do
		local ok, prev = pcall(fnPrev, NET.NPCS.PreviewSellAll)
		if not ok or type(prev) ~= "table" then
			break
		end
		local fc = prev.FruitCount or 0
		if fc == 0 then
			break
		end
		local ok2, resp = pcall(fnSell, NET.NPCS.SellAll)
		if ok2 and type(resp) == "table" and not isFailMessage(resp) then
			totalS = totalS + (resp.SoldCount or fc)
			totalP = totalP + (resp.SellPrice or 0)
		else
			break
		end
	end
	if totalS > 0 then
		wr(string.format("[SELL] %d = $%.0f", totalS, totalP))
	end
	return totalS, totalP
end

function countTools()
	local n = 0
	local backpack = LP:FindFirstChildOfClass("Backpack")
	if backpack then
		for _, t in backpack:GetChildren() do
			if t:IsA("Tool") then
				n = n + 1
			end
		end
	end
	local char = LP.Character
	if char then
		for _, t in char:GetChildren() do
			if t:IsA("Tool") then
				n = n + 1
			end
		end
	end
	return n
end

function countSeedTool(name)
	local n = 0
	for _, tool in ipairs(getToolsByAttr("SeedTool")) do
		local st = tool:GetAttribute("SeedTool") or tool.Name
		if st == name then
			n = n + 1
		end
	end
	return n
end

function purchaseGearVerified(name)
	if hasGear(name) then
		return false
	end
	local stock = getStock("GearShop", name)
	if stock <= 0 then
		return false
	end
	local price = GEAR_PRICES[name]
	if not price or getMoney() < price + CFG.minMoneyKeep then
		return false
	end
	local isWaterCan = name:find("Watering", 1, true) ~= nil
	local reserve = isWaterCan and (CFG.wateringCanMinMoneyReserve or 3000) or (CFG.gearMinMoneyReserve or 0)
	if getMoney() - price < reserve then
		return false
	end
	local moneyBefore = getMoney()
	local ok = callRemote(NET.GearShop.PurchaseGear, name)
	if not ok then
		return false
	end
	task.wait(0.2)
	if getMoney() >= moneyBefore then
		return false
	end
	ownedGear[name] = true
	wr(string.format("[BUY] %s ($%d, stock=%d)", name, price, stock))
	equipGear(name)
	return true
end

function autoBuyGear()
	if not CFG.enabled.gear or getMoney() < CFG.buyGearWhenMoneyAbove then
		return 0
	end
	refreshOwnedGear()
	local bought = 0
	-- watering cans are reusable tools; only buy if we don't already hold one
	if #getToolsByAttr("WateringCan") == 0 then
		for _, n in ipairs(CFG.wateringCans) do
			if purchaseGearVerified(n) then
				bought = bought + 1
			end
		end
	end
	for _, n in ipairs(CFG.sprinklers) do
		if purchaseGearVerified(n) then
			bought = bought + 1
		end
	end
	return bought
end

function pickBestInStockSeed(tried, minPrice)
	local money = getMoney()
	local bestName, bestScore
	for name in pairs(SEED_DATA) do
		if
			not (tried and tried[name])
			and not isSeedBuyBlocked(name)
			and not isShopBuyBlocked(name)
			and not getPriorityBuyCfg(name)
		then
			local price = SEED_DATA[name].price or 10
			if
				price >= (minPrice or 0)
				and getSeedScore(name) >= (CFG.minBuySeedScore or 0)
				and seedRoiOk(name)
				and getSeedShopStock(name) > 0
				and canAffordSeed(price)
			then
				local score = getSeedScore(name)
				if not bestScore or score > bestScore then
					bestName, bestScore = name, score
				end
			end
		end
	end
	return bestName
end

function pickRelaxedShopSeed(tried)
	return pickBestInStockSeed(tried, 0)
end

-- Idle-capacity filler: pick the highest-score in-stock crop we can afford,
-- relaxing the minBuySeedScore floor down to fallbackFillMinScore (these are
-- throwaway fillers) but keeping the ROI gate so trap seeds stay blocked.
function pickIdleFillSeed(tried)
	local minScore = CFG.fallbackFillMinScore or 0
	local bestName, bestScore
	for name in pairs(SEED_DATA) do
		if
			not (tried and tried[name])
			and not isSeedBuyBlocked(name)
			and not isShopBuyBlocked(name)
			and not getPriorityBuyCfg(name)
			and not isNoPlantSeed(name)
		then
			local score = getSeedScore(name)
			if
				score >= minScore
				and seedRoiOk(name)
				and getSeedShopStock(name) > 0
				and canAffordSeed(SEED_DATA[name].price or 10)
			then
				if not bestScore or score > bestScore then
					bestName, bestScore = name, score
				end
			end
		end
	end
	return bestName
end

-- When money tier requires expensive seeds but shop only stocks cheap ones, relax tier.
function tierBlocksAllShopStock()
	local minPrice = getMinSeedPriceForMoney(getMoney())
	if minPrice <= 0 then
		return false
	end
	for name in pairs(SEED_DATA) do
		if
			not isSeedBuyBlocked(name)
			and not isShopBuyBlocked(name)
			and getSeedShopStock(name) > 0
			and seedRoiOk(name)
			and getSeedScore(name) >= (CFG.minBuySeedScore or 0)
		then
			local price = SEED_DATA[name].price or 10
			if price >= minPrice and canAffordSeed(price) then
				return false
			end
		end
	end
	for name in pairs(SEED_DATA) do
		if
			not isSeedBuyBlocked(name)
			and not isShopBuyBlocked(name)
			and getSeedShopStock(name) > 0
			and seedRoiOk(name)
			and getSeedScore(name) >= (CFG.minBuySeedScore or 0)
			and canAffordSeed(SEED_DATA[name].price or 10)
		then
			return true
		end
	end
	return false
end

function resolveSeedMinPrice(money, allowBelowTier)
	if allowBelowTier then
		return 0
	end
	return getMinSeedPriceForMoney(money)
end

function purchaseSeedVerified(name, allowBelowTier, relaxed)
	local info = SEED_DATA[name]
	local price = info and info.price or 10
	local money = getMoney()
	if not canAffordSeed(price) then
		return false, "money"
	end
	if not seedRoiOk(name) then
		return false, "roi"
	end
	if not relaxed then
		local minPrice = resolveSeedMinPrice(money, allowBelowTier)
		if price < minPrice then
			return false, "tier"
		end
	end
	local stock = getSeedShopStock(name)
	if stock <= 0 then
		return false, "stock"
	end
	if countTools() >= 95 then
		return false, "tools"
	end
	local moneyBefore = money
	local seedsBefore = getOwnedSeedCount(name)
	local ok, err = firePurchaseSeed(name)
	if not ok then
		return false, "remote"
	end
	for _ = 1, 10 do
		task.wait(0.15)
		if getMoney() < moneyBefore - 1 then
			seedBuyBlock[name] = nil
			wr(string.format("[BUY] %s ($%d, stock=%d)", name, price, stock))
			return true
		end
		if getOwnedSeedCount(name) > seedsBefore then
			seedBuyBlock[name] = nil
			wr(string.format("[BUY] %s ($%d, stock=%d)", name, price, stock))
			return true
		end
	end
	if CFG.buyTrustFire then
		wr(string.format("[BUY] %s ($%d, stock=%d) [fire]", name, price, stock))
		return true
	end
	blockSeedBuy(name)
	return false, "verify"
end

function countPlants(plot)
	local pl = plot and plot:FindFirstChild("Plants")
	if not pl then
		return 0
	end
	local n = 0
	for _ in pl:GetChildren() do
		n = n + 1
	end
	return n
end

function countPlantableSpots(plot)
	local vis = plot:FindFirstChild("Visual")
	if not vis then
		return 0
	end
	local total = 0
	for _, c in vis:GetChildren() do
		if c.Name:find("PlantAreaColumn") and c:IsA("BasePart") then
			local sz = c.Size
			total = total + math.max(math.floor(sz.X / 4) * math.floor(sz.Z / 4), 1)
		end
	end
	return total
end

function pickBestBuySeed(allowBelowTier, tried)
	local money = getMoney()
	local minPrice = resolveSeedMinPrice(money, allowBelowTier)
	for _, name in ipairs(seedPriority) do
		if
			not (tried and tried[name])
			and not isSeedBuyBlocked(name)
			and not isShopBuyBlocked(name)
			and not getPriorityBuyCfg(name)
		then
			local price = SEED_DATA[name] and SEED_DATA[name].price or 10
			if
				price >= minPrice
				and getSeedScore(name) >= (CFG.minBuySeedScore or 0)
				and seedRoiOk(name)
				and getSeedShopStock(name) > 0
				and canAffordSeed(price)
			then
				return name, price
			end
		end
	end
	return pickBestInStockSeed(tried, minPrice)
end

function pickPriorityStockSeed(tried, boughtCounts)
	local money = getMoney()
	local list = CFG.priorityBuySeeds
	if type(list) ~= "table" then
		return nil
	end

	local candidates = {}
	local function consider(name, cfg)
		cfg = cfg or {}
		if tried and tried[name] then
			return
		end
		if isSeedBuyBlocked(name) or isEventOnlySeed(name) then
			return
		end
		if not getPriorityBuyCfg(name) then
			return
		end
		if not seedRoiOk(name) then
			return
		end
		local minMoney = cfg.minMoney or 50000
		local maxPer = cfg.maxPerCycle or 5
		if money < minMoney then
			return
		end
		if (boughtCounts[name] or 0) >= maxPer then
			return
		end
		-- don't hoard: keep at most maxOwned in reserve to plant as spots free up
		if cfg.maxOwned and getOwnedSeedCount(name) >= cfg.maxOwned then
			return
		end
		local price = SEED_DATA[name] and SEED_DATA[name].price or 10
		if getSeedShopStock(name) <= 0 then
			return
		end
		if not canAffordSeed(price) then
			return
		end
		table.insert(candidates, { name = name, score = getSeedScore(name), minMoney = minMoney })
	end

	for name, cfg in pairs(list) do
		if type(name) == "string" and SEED_DATA[name] then
			consider(name, type(cfg) == "table" and cfg or {})
		elseif type(cfg) == "table" and cfg.seed then
			consider(cfg.seed, cfg)
		elseif type(cfg) == "string" then
			consider(cfg, {})
		end
	end

	table.sort(candidates, function(a, b)
		if a.minMoney ~= b.minMoney then
			return a.minMoney > b.minMoney
		end
		return a.score > b.score
	end)
	return candidates[1] and candidates[1].name
end

function buyPriorityStockSeeds()
	if not CFG.enabled.buy then
		return 0
	end
	refreshSeedShopState()
	local bought = 0
	local tried = {}
	local boughtCounts = {}
	local guard = 0
	while guard < 10 do
		guard = guard + 1
		local name = pickPriorityStockSeed(tried, boughtCounts)
		if not name then
			break
		end
		local ok, reason = purchaseSeedVerified(name, true, true)
		if ok then
			bought = bought + 1
			boughtCounts[name] = (boughtCounts[name] or 0) + 1
			wr("[BUY] stock: " .. name)
		else
			tried[name] = true
			if reason == "money" or reason == "stock" then
				break
			end
		end
		task.wait(0.05)
	end
	return bought
end

function seedShopDebugSummary(limit)
	local rows = {}
	for name in pairs(SEED_DATA) do
		local stock = getSeedShopStock(name)
		if stock > 0 then
			local price = SEED_DATA[name] and SEED_DATA[name].price or 10
			table.insert(rows, { name = name, price = price, stock = stock, score = getSeedScore(name) })
		end
	end
	table.sort(rows, function(a, b)
		return a.score > b.score
	end)
	local out = {}
	for i = 1, math.min(limit or 5, #rows) do
		local r = rows[i]
		table.insert(out, string.format("%s($%d x%d)", r.name, r.price, r.stock))
	end
	return #out > 0 and table.concat(out, ", ") or "stock=0"
end

function autoBuySeeds()
	if not CFG.enabled.buy then
		return 0
	end
	refreshSeedShopState()
	local plot = findMyPlot()
	if not plot then
		return 0
	end

	local stockBought = buyPriorityStockSeeds()

	local freeSpots = math.max(0, countPlantableSpots(plot) - countPlants(plot))
	if freeSpots < 1 then
		return stockBought
	end

	local bought = 0
	local limit = math.min(freeSpots, CFG.maxSeedsPerCycle, CFG.maxBuyAttemptsPerCycle or 4)
	local fallback = tierBlocksAllShopStock()
	if fallback and CFG.verboseLogs then
		wr("[BUY] tier relax: shop has no seeds at money tier")
	end
	local relaxed = fallback
	local tried = {}
	local triedNames = {}
	local failReasons = {}
	local idleFillTried = false
	local guard = 0
	local buyStart = os.clock()
	local maxBuySec = (CFG.pipelineMode ~= false and CFG.buyMaxSecondsActive) or CFG.maxBuySeconds or 6
	while bought < limit do
		if os.clock() - buyStart >= maxBuySec then
			failReasons.timeout = 1
			break
		end
		guard = guard + 1
		if guard > 20 then
			break
		end
		local name = pickBestBuySeed(fallback, tried)
		if not name and CFG.buySeedsFallbackBelowTier and not fallback then
			fallback = true
			name = pickBestBuySeed(true, tried)
			if name then
				wr("[BUY] fallback: " .. name)
			end
		end
		if not name and not relaxed then
			relaxed = true
			name = pickRelaxedShopSeed(tried)
			if name then
				wr("[BUY] relaxed: " .. name)
			end
		end
		-- Last resort: priority crop is out of stock and the plot has real idle
		-- spots -> fill with the best affordable in-stock filler instead of leaving
		-- capital idle. Gated so it only triggers during genuine Bamboo droughts.
		if
			not name
			and CFG.fillIdleWithFallback
			and not idleFillTried
			and stockBought == 0
			and freeSpots >= (CFG.fallbackFillMinFreeSpots or 0)
		then
			idleFillTried = true
			relaxed = true
			name = pickIdleFillSeed(tried)
			if name then
				wr("[BUY] idle-fill: " .. name)
			end
		end
		if not name then
			break
		end
		table.insert(triedNames, name)
		local ok, reason = purchaseSeedVerified(name, fallback or relaxed, relaxed)
		if ok then
			bought = bought + 1
		else
			tried[name] = true
			failReasons[reason or "fail"] = (failReasons[reason or "fail"] or 0) + 1
		end
		task.wait(0.05)
	end
	if bought == 0 and stockBought == 0 and freeSpots > 0 then
		local reasons = {}
		for k, v in pairs(failReasons) do
			table.insert(reasons, k .. "=" .. v)
		end
		table.sort(reasons)
		local reasonStr = #reasons > 0 and table.concat(reasons, ",") or "-"
		-- троттлинг: не спамим один и тот же повод чаще раза в 20 сек
		local now = os.clock()
		if reasonStr ~= lastNoBuyReason or (now - lastNoBuyLog) >= 20 then
			lastNoBuyReason = reasonStr
			lastNoBuyLog = now
			wr(
				string.format(
					"[BUY] no seed bought (freeSpots=%d money=$%.0f tools=%d ownedSeeds=%d tried=%s reasons=%s shop=%s)",
					freeSpots,
					getMoney(),
					countTools(),
					getTotalOwnedSeedCount(),
					#triedNames > 0 and table.concat(triedNames, ",") or "-",
					reasonStr,
					seedShopDebugSummary(5)
				)
			)
		end
	end
	return bought + stockBought
end

function buildSprinklerGrid(plot)
	local areas = getPlantAreaParts(plot)
	local points = {}
	for _, area in ipairs(areas) do
		local cf, sz = area.CFrame, area.Size
		local cols = math.max(1, math.floor(sz.X / CFG.sprinklerGridStep))
		local rows = math.max(1, math.floor(sz.Z / CFG.sprinklerGridStep))
		for cx = 0, cols do
			for cz = 0, rows do
				local lx = -sz.X / 2 + (cx / math.max(cols, 1)) * sz.X
				local lz = -sz.Z / 2 + (cz / math.max(rows, 1)) * sz.Z
				local world = cf:PointToWorldSpace(Vector3.new(lx, 0, lz))
				table.insert(points, raycastPlantArea(plot, world))
			end
		end
	end
	if #points == 0 then
		local center = areas[1]
		if center then
			table.insert(points, raycastPlantArea(plot, center.Position))
		end
	end
	return points
end

function getHighValuePlantPositions(plot)
	local positions = {}
	local pl = plot:FindFirstChild("Plants")
	if not pl then
		return positions
	end
	for _, plant in pl:GetChildren() do
		if plant:IsA("Model") then
			local seed = getPlantSeedName(plant)
			local score = seed and getSeedScore(seed) or 0
			local pos = getPlantPos(plant)
			if pos and score > 0 then
				table.insert(positions, { pos = pos, score = score })
			end
		end
	end
	table.sort(positions, function(a, b)
		return a.score > b.score
	end)
	return positions
end

function sortGridByPlants(grid, plantPositions)
	if #plantPositions == 0 then
		return grid
	end
	table.sort(grid, function(a, b)
		local function nearestScore(p)
			local best = 0
			for _, pp in ipairs(plantPositions) do
				local d = (p - pp.pos).Magnitude
				if d < 40 then
					best = math.max(best, pp.score * (1 - d / 40))
				end
			end
			return best
		end
		return nearestScore(a) > nearestScore(b)
	end)
	return grid
end

function placeSprinklers(plot)
	if not CFG.enabled.gear or not NET or not NET.Place then
		return 0
	end
	local tools = getToolsByAttr("Sprinkler")
	if #tools == 0 then
		for _, n in ipairs(CFG.sprinklers) do
			if hasGear(n) then
				equipGear(n)
				task.wait(0.15)
				break
			end
		end
		tools = getToolsByAttr("Sprinkler")
	end
	if #tools == 0 then
		return 0
	end

	local plotIds = getPlotRemoteIds(plot)
	if #plotIds == 0 then
		wr("[SPRINKLER] WARN: no plot ids")
	end

	local grid = buildSprinklerGrid(plot)
	grid = sortGridByPlants(grid, getHighValuePlantPositions(plot))
	local usedSpots = {}
	local sprFolder = plot:FindFirstChild("Sprinklers")
	if sprFolder then
		for _, s in sprFolder:GetChildren() do
			local pp = s.PrimaryPart or s:FindFirstChildWhichIsA("BasePart")
			if pp then
				table.insert(usedSpots, pp.Position)
			end
		end
	end

	local function spotFree(pos)
		for _, u in ipairs(usedSpots) do
			if (u - pos).Magnitude < CFG.sprinklerMinDistance then
				return false
			end
		end
		return true
	end

	local placed = 0
	local gridIdx = 1
	for ti = 1, math.min(#tools, CFG.maxSprinklersPerCycle) do
		local tool = tools[ti]
		if not tool or not tool.Parent then
			continue
		end
		local name = tool:GetAttribute("Sprinkler")
		if not name then
			continue
		end

		local ground
		while gridIdx <= #grid do
			local candidate = grid[gridIdx]
			gridIdx = gridIdx + 1
			if spotFree(candidate) then
				ground = candidate
				break
			end
		end
		if not ground then
			break
		end

		teleportNear(ground + Vector3.new(0, CFG.teleportHeight, 0), 999)
		if not equipTool(tool) then
			continue
		end

		local before = sprFolder and #sprFolder:GetChildren() or 0
		local ok, err, after = false, nil, before
		for _, plotId in ipairs(plotIds) do
			ok, _, err = callRemote(NET.Place.PlaceSprinkler, ground, name, tool, plotId)
			task.wait(0.12)
			after = sprFolder and #sprFolder:GetChildren() or 0
			if ok and after > before then
				break
			end
		end

		if ok and after > before then
			wr(string.format("[SPRINKLER] Placed %s @ grid", name))
			table.insert(usedSpots, ground)
			placed = placed + 1
		elseif err and tostring(err):lower():find("far") then
			teleportNear(ground + Vector3.new(0, CFG.teleportHeight, 0), 999)
			for _, plotId in ipairs(plotIds) do
				ok, _, err = callRemote(NET.Place.PlaceSprinkler, ground, name, tool, plotId)
				task.wait(0.12)
				after = sprFolder and #sprFolder:GetChildren() or 0
				if ok and after > before then
					break
				end
			end
			if ok and after > before then
				wr(string.format("[SPRINKLER] Placed %s (retry)", name))
				table.insert(usedSpots, ground)
				placed = placed + 1
			end
		end
		unequipTool(tool)
	end
	return placed
end

local weatherState = { rainbow = false, starfall = false, rain = false }
local eventPriorityActive = false
local eventDropBusy = {}
local eventDropsSinceStatus = 0

local waterHistory = {}
local lastWaterSkipLog = 0
local lastWaterAttempt = 0
local lastWaterFailLog = 0
local lastWaterEmptyLog = 0
local lastWaterSweep = 0
local lastPetEquipFailLog = 0

function fireWateringCan(pos, canType, tool)
	local remote = NET and NET.WateringCan and NET.WateringCan.UseWateringCan
	if not remote or not remote.Fire then
		return false, "no remote"
	end
	-- We no longer GATE success on WateringCanFx: that event is unreliable
	-- (timing/identity) and produced false "no fx (server rejected?)" failures,
	-- which triggered a 3-position retry storm + "too far" spam. UseWateringCan
	-- has no Response, so a clean Fire from close range (caller teleports onto
	-- the plant) is treated as success. firePaced yields one frame so it flushes.
	local ok, err = pcall(remote.Fire, remote, pos, canType, tool)
	_RunSvc.Heartbeat:Wait()
	if not ok then
		return false, tostring(err)
	end
	return true, nil
end

function needsWatering(plant)
	if not CFG.smartWater.enabled then
		return true
	end
	local pid = plant:GetAttribute("PlantId")
	if not pid then
		return true
	end
	local age, maxAge = plant:GetAttribute("Age"), plant:GetAttribute("MaxAge")
	if age and maxAge and age >= maxAge then
		return false
	end
	local last = waterHistory[pid]
	return not last or (os.clock() - last) > CFG.smartWater.rewaterAfterMinutes * 60
end

function tryWaterAt(plot, pos, ct, tool)
	local hit = raycastPlantArea(plot, pos)
	-- Teleport DIRECTLY onto the plant (not "within 20 studs"). The old
	-- teleportNear(maxDist+6) often left us ~15-20 studs out, so the server
	-- rejected the water as too far. Setting CFrame onto the spot is reliable.
	local hrp = getHRP()
	if hrp then
		hrp.CFrame = CFrame.new(hit + Vector3.new(0, CFG.teleportHeight, 0))
	end
	if not equipTool(tool) then
		if CFG.verboseLogs and os.clock() - lastWaterFailLog > 8 then
			lastWaterFailLog = os.clock()
			wr("[WATER] fail: could not equip watering-can tool")
		end
		return false
	end
	_RunSvc.Heartbeat:Wait()
	-- Signature (verified): UseWateringCan(Vector3 pos, String canType, Instance tool).
	-- Mirror the game client: pos = plant-area hit - 0.3 on Y.
	local ok = fireWateringCan(waterRemotePos(hit), ct, tool)
	return ok
end

function resolveWateringTools()
	local tools = getToolsByAttr("WateringCan")
	if #tools == 0 then
		tools = findToolsByNames(CFG.wateringCans)
	end
	if #tools > 0 then
		return tools
	end
	-- Own the can but it's not in the backpack yet: equip the gear and wait for the
	-- Tool to materialise. We must return a REAL Tool instance (the server needs it).
	refreshOwnedGear()
	for _, n in ipairs(CFG.wateringCans) do
		if not hasGear(n) then
			continue
		end
		equipGear(n)
		for _ = 1, 15 do
			task.wait(0.2)
			tools = getToolsByAttr("WateringCan")
			if #tools == 0 then
				tools = findToolsByNames({ n })
			end
			if #tools > 0 then
				return tools
			end
		end
	end
	return tools
end

function waterAll(plot)
	if not CFG.enabled.water or not NET or not NET.WateringCan then
		return 0
	end
	if weatherState.rain then
		return 0
	end
	local tools = resolveWateringTools()
	if #tools == 0 then
		if os.clock() - lastWaterSkipLog > 30 then
			lastWaterSkipLog = os.clock()
			wr("[WATER] skip: no watering-can tool (buy/equip gear first)")
		end
		return 0
	end

	local plants = plot:FindFirstChild("Plants")
	if not plants then
		return 0
	end
	local targets = {}
	local plantCount = 0
	for _, p in plants:GetChildren() do
		if p:IsA("Model") then
			plantCount = plantCount + 1
		end
		if p:IsA("Model") and needsWatering(p) then
			local seed = getPlantSeedName(p)
			local pos = getPlantPos(p)
			if pos then
				table.insert(targets, {
					plant = p,
					pos = pos,
					score = seed and getSeedScore(seed) or 0,
				})
			end
		end
	end
	if #targets == 0 then
		local every = CFG.smartWater and (tonumber(CFG.smartWater.logEmptyEvery) or 20) or 20
		if CFG.verboseLogs and os.clock() - lastWaterEmptyLog > every then
			lastWaterEmptyLog = os.clock()
			wr(
				string.format(
					"[WATER] no targets (plants=%d tools=%d rain=%s)",
					plantCount,
					#tools,
					tostring(weatherState.rain)
				)
			)
		end
		return 0
	end
	table.sort(targets, function(a, b)
		return a.score > b.score
	end)

	teleportToPlot(plot)
	local done = 0
	local limit = math.max(tonumber(CFG.smartWater and CFG.smartWater.maxPerSweep) or 24, 1)
	fpsBurstBegin()
	for _, tool in ipairs(tools) do
		local ct = tool:GetAttribute("WateringCan") or tool.Name
		if equipTool(tool) then
			for _, t in ipairs(targets) do
				if done >= limit then
					break
				end
				if needsWatering(t.plant) and tryWaterAt(plot, t.pos, ct, tool) then
					done = done + 1
					local pid = t.plant:GetAttribute("PlantId")
					if pid then
						waterHistory[pid] = os.clock()
					end
				end
			end
			unequipTool(tool)
		end
		if done >= limit then
			break
		end
	end
	fpsBurstEnd()
	if done > 0 then
		wr(string.format("[WATER] %d/%d", done, #targets))
	elseif CFG.verboseLogs and os.clock() - lastWaterFailLog > 6 then
		lastWaterFailLog = os.clock()
		wr(string.format("[WATER] tried %d target(s), success=0", #targets))
	end
	return done
end

function shouldWaterThisCycle(plantedCount)
	if not (CFG.enabled.water and CFG.smartWater and CFG.smartWater.enabled) then
		return false
	end
	if weatherState and weatherState.rain then
		return false
	end
	if (tonumber(plantedCount) or 0) > 0 then
		return true
	end
	local interval = math.max(tonumber(CFG.smartWater.sweepInterval) or 8, 2)
	if os.clock() - lastWaterSweep >= interval then
		return true
	end
	return false
end

function sortSeedTools(tools)
	local minPrice = CFG.skipPlantBelowPrice or 0
	local sorted = {}
	local fallback = {}
	for _, tool in ipairs(tools) do
		local st = tool:GetAttribute("SeedTool")
		if st then
			if isNoPlantSeed(st) then
				continue
			end
			local price = SEED_DATA[st] and SEED_DATA[st].price or 0
			local entry = { tool = tool, seed = st, score = getSeedScore(st) }
			if price >= minPrice then
				table.insert(sorted, entry)
			elseif CFG.plantFallbackBelowTier then
				table.insert(fallback, entry)
			end
		end
	end
	if #sorted == 0 then
		sorted = fallback
	end
	table.sort(sorted, function(a, b)
		return a.score > b.score
	end)
	return sorted
end

function plantAll(plot)
	if not CFG.enabled.plant or not NET or not NET.Plant then
		return 0
	end
	local sorted = sortSeedTools(getToolsByAttr("SeedTool"))
	if #sorted == 0 then
		local raw = getToolsByAttr("SeedTool")
		if #raw > 0 then
			local skipNames = {}
			for _, tool in ipairs(raw) do
				local st = tool:GetAttribute("SeedTool") or tool.Name
				if st and isNoPlantSeed(st) and not skipNames[st] then
					skipNames[st] = true
				end
			end
			local listed = {}
			for n in pairs(skipNames) do
				table.insert(listed, n)
			end
			table.sort(listed)
			if #listed > 0 then
				wr("[PLANT] skip: skipSeeds in backpack (hold/mail, not plant): " .. table.concat(listed, ", "))
			else
				wr("[PLANT] skip: no plantable seed tools in backpack")
			end
		end
		return 0
	end
	teleportToPlot(plot)
	local areas = getPlantAreaParts(plot)
	if #areas == 0 then
		return 0
	end

	local occupied = {}
	local plants = plot:FindFirstChild("Plants")
	if plants then
		for _, p in plants:GetChildren() do
			local base = p:FindFirstChild("Base")
			if base then
				table.insert(occupied, base.Position)
			end
		end
	end

	local function findSpot()
		for _ = 1, 40 do
			local a = areas[math.random(#areas)]
			local cf, sz = a.CFrame, a.Size
			local localPos = Vector3.new(-sz.X / 2 + math.random() * sz.X, 0.5, -sz.Z / 2 + math.random() * sz.Z)
			local pos = cf:PointToWorldSpace(localPos)
			local ok = true
			for _, o in ipairs(occupied) do
				if (pos - o).Magnitude < 3.5 then
					ok = false
					break
				end
			end
			if ok then
				return raycastPlantArea(plot, pos)
			end
		end
	end

	local done = 0
	for _, entry in ipairs(sorted) do
		local tool, st = entry.tool, entry.seed
		while tool and tool.Parent and done < CFG.maxPlantsPerCycle do
			local pos = findSpot()
			if not pos then
				break
			end
			teleportNear(pos + Vector3.new(0, CFG.teleportHeight, 0), CFG.maxActionDistance + 4)
			if not equipTool(tool) then
				break
			end
			if callRemote(NET.Plant.PlantSeed, pos, st, tool) then
				done = done + 1
				table.insert(occupied, pos)
				task.wait(0.05)
			else
				break
			end
		end
		unequipTool(tool)
		if done >= CFG.maxPlantsPerCycle then
			break
		end
	end
	if done > 0 then
		wr("[PLANT] " .. done)
	end
	return done
end

local cleanupRetryAt = {}

-- Best seed we could replant with: backpack first, then buyable shop stock.
-- During droughts the backpack is often empty while Bamboo or idle-fill crops
-- are still in the shop; without this, cleanup stalls and junk persists.
function getCleanupReplacementScore()
	local tools = sortSeedTools(getToolsByAttr("SeedTool"))
	local best = tools[1] and tools[1].score or 0
	if best >= CFG.cleanupReplacementMinScore then
		return best
	end

	refreshSeedShopState()
	local shopBest = 0
	for name in pairs(SEED_DATA) do
		if
			not isNoPlantSeed(name)
			and not isSeedBuyBlocked(name)
			and not isShopBuyBlocked(name)
			and getSeedShopStock(name) > 0
			and seedRoiOk(name)
			and canAffordSeed(SEED_DATA[name].price or 10)
		then
			local score = getSeedScore(name)
			if getPriorityBuyCfg(name) then
				shopBest = math.max(shopBest, score)
			elseif CFG.fillIdleWithFallback and score >= (CFG.fallbackFillMinScore or 0) then
				shopBest = math.max(shopBest, score)
			end
		end
	end
	if shopBest >= CFG.cleanupReplacementMinScore then
		return shopBest
	end
	if CFG.fillIdleWithFallback and shopBest > best then
		return shopBest
	end
	return best
end

function removeLowValuePlants(plot)
	if not CFG.cleanupLowValuePlants or not NET or not NET.Shovel or not NET.Shovel.UseShovel then
		return 0
	end
	if getMoney() < CFG.cleanupMoneyAbove then
		return 0
	end
	local plants = plot:FindFirstChild("Plants")
	if not plants then
		return 0
	end
	local capacity = countPlantableSpots(plot)
	local plantCount = countPlants(plot)
	if CFG.cleanupOnlyWhenGardenFull and plantCount < capacity then
		return 0
	end

	local replacementScore = getCleanupReplacementScore()
	if
		replacementScore
		< (CFG.fillIdleWithFallback and (CFG.fallbackFillMinScore or 0) or CFG.cleanupReplacementMinScore)
	then
		return 0
	end

	local all, bestScore = {}, 0
	for _, plant in plants:GetChildren() do
		if plant:IsA("Model") then
			local seed = getPlantSeedName(plant)
			local score = seed and getSeedScore(seed) or 0
			bestScore = math.max(bestScore, score)
			table.insert(all, { plant = plant, seed = seed, score = score })
		end
	end
	if bestScore < CFG.cleanupMinBestScore then
		return 0
	end

	table.sort(all, function(a, b)
		return a.score < b.score
	end)
	local tools = getToolsByAttr("Shovel")
	if #tools == 0 then
		return 0
	end
	local tool = tools[1]
	if not equipTool(tool) then
		return 0
	end

	local removed, tried = 0, 0
	local shovelName = tool:GetAttribute("Shovel") or "Shovel"
	for _, entry in ipairs(all) do
		if removed >= CFG.cleanupMaxPerCycle then
			break
		end
		if not entry.seed or not CFG.cleanupSeeds[entry.seed] then
			continue
		end
		-- remove only whitelisted junk that's far worse than what we can replant
		if entry.score >= replacementScore * CFG.cleanupReplacementRatio then
			continue
		end

		local pid = entry.plant.Name
		if not pid then
			continue
		end
		if cleanupRetryAt[pid] and cleanupRetryAt[pid] > os.clock() then
			continue
		end
		local beforeParent = entry.plant.Parent
		tried = tried + 1
		local pos = getPlantPos(entry.plant)
		if pos then
			teleportNear(pos + Vector3.new(0, CFG.teleportHeight, 0), CFG.maxActionDistance + 4)
		end
		callRemote(NET.Shovel.UseShovel, pid, "", shovelName, tool)
		task.wait(0.25)
		if beforeParent and not entry.plant.Parent then
			removed = removed + 1
			wr(string.format("[CLEANUP] removed %s score=%.0f best=%.0f", entry.seed, entry.score, bestScore))
		else
			cleanupRetryAt[pid] = os.clock() + CFG.cleanupRetryCooldown
		end
	end
	unequipTool(tool)
	if tried > 0 and removed == 0 then
		wr(
			string.format(
				"[CLEANUP] tried %d low-value plants with shovel args (plantModelName,'',%s,tool); none removed yet",
				tried,
				shovelName
			)
		)
	end
	return removed
end

local CRATE_RARITY = {
	["Common Guild Crate"] = 1,
	["Uncommon Guild Crate"] = 2,
	["Rare Guild Crate"] = 3,
	["Epic Guild Crate"] = 4,
	["Super Guild Crate"] = 5,
	["Legendary Guild Crate"] = 6,
	["Mythic Guild Crate"] = 7,
}

function autoOpenCrates()
	if not CFG.enabled.crates or not NET or not NET.CrateShop then
		return 0
	end
	if getMoney() < CFG.buyCratesWhenMoneyAbove then
		return 0
	end
	local items = RS.StockValues:FindFirstChild("CrateShop")
	items = items and items:FindFirstChild("Items")
	if not items then
		return 0
	end
	local opened = 0
	local crates = {}
	for _, v in items:GetChildren() do
		if v:IsA("NumberValue") and v.Value > 0 and CRATE_RARITY[v.Name] then
			table.insert(crates, { name = v.Name, stock = v.Value, r = CRATE_RARITY[v.Name] })
		end
	end
	table.sort(crates, function(a, b)
		return a.r > b.r
	end)
	for _, c in ipairs(crates) do
		if getMoney() < CFG.buyCratesWhenMoneyAbove then
			break
		end
		if callRemote(NET.CrateShop.PurchaseCrate, c.name) then
			opened = opened + 1
			task.wait(0.2)
			local fn = NET.Crate.OpenCrate.Invoke or NET.Crate.OpenCrate.Fire
			pcall(fn, NET.Crate.OpenCrate, c.name)
		end
	end
	return opened
end

function getGardenExpansionLevel()
	local data = getPlayerReplicaData()
	if data and type(data.OwnedExpansions) == "number" then
		return data.OwnedExpansions
	end
	local plot = findMyPlot()
	if plot then
		local v = plot:GetAttribute("GardenExpansion")
		if type(v) == "number" then
			return v
		end
	end
	return 0
end

function buyGardenExpansion()
	if not CFG.enabled.expansion or not CFG.autoExpandGarden or not NET or not NET.Actions then
		return false
	end
	if not NET.Actions.ExpandGarden then
		return false
	end
	local cur = getGardenExpansionLevel()
	local nextIdx = cur + 1
	if nextIdx > #EXPANSION_PRICES or cur >= CFG.maxGardenExpansionBought then
		return false
	end
	local price = EXPANSION_PRICES[nextIdx]
	if not price or getMoney() < price then
		return false
	end
	local ok, res = callRemote(NET.Actions.ExpandGarden)
	if ok then
		wr(string.format("[EXPAND] %d -> %d ($%.0f)", cur, nextIdx, price))
		return true
	end
	return false
end

function checkWeather()
	local wv = RS:FindFirstChild("WeatherValues")
	if not wv then
		return
	end
	local wasRainbow, wasStarfall = weatherState.rainbow, weatherState.starfall
	weatherState.rainbow = wv:GetAttribute("Rainbow_Playing") == true
	weatherState.starfall = wv:GetAttribute("Starfall_Playing") == true
	weatherState.rain = wv:GetAttribute("Rain_Playing") == true
	if weatherState.rainbow and not wasRainbow then
		wr("[EVENT] Rainbow STARTED")
	end
	if weatherState.starfall and not wasStarfall then
		wr("[EVENT] Starfall STARTED")
	end
end

function getDropDisplayName(item)
	local dn = item:GetAttribute("DisplayName")
		or item:GetAttribute("ItemName")
		or item:GetAttribute("SeedPack")
		or item:GetAttribute("PackName")
	if dn and dn ~= "" then
		return tostring(dn)
	end
	if item:GetAttribute("SeedPack") then
		return "SeedPack"
	end
	if item:GetAttribute("RainbowSeed") == true then
		return "Rainbow Seed"
	end
	if item:GetAttribute("GoldSeed") == true then
		return "Gold Seed"
	end
	return item.Name
end

function isEventWeatherActive()
	return weatherState.rainbow or weatherState.starfall
end

function shouldDeferFarmTeleport()
	if not eventPriorityActive then
		return false
	end
	local drops = workspace:FindFirstChild("DroppedItems")
	if not drops then
		return false
	end
	for _, item in drops:GetChildren() do
		if shouldCollectDrop(item) then
			return true
		end
	end
	return false
end

function isRushSeedDrop(item)
	if not item or not item.Parent then
		return false
	end
	if item:GetAttribute("RainbowSeed") == true then
		return true
	end
	if item:GetAttribute("GoldSeed") == true then
		return true
	end
	local name = getDropDisplayName(item):lower()
	if name:find("rainbow", 1, true) then
		return true
	end
	if name:find("gold", 1, true) and name:find("seed", 1, true) then
		return true
	end
	return false
end

function hasRushSeedsVisible()
	if isEventWeatherActive() then
		return true
	end
	local drops = workspace:FindFirstChild("DroppedItems")
	if drops then
		for _, item in drops:GetChildren() do
			if isRushSeedDrop(item) then
				return true
			end
		end
	end
	if CFG.collectSeedPacks then
		local map = workspace:FindFirstChild("Map")
		local folders = {
			map and map:FindFirstChild("SeedPackSpawnClient"),
			map and map:FindFirstChild("SeedPackSpawnServerLocations"),
		}
		for _, folder in ipairs(folders) do
			if folder then
				for _, item in folder:GetChildren() do
					if isRushSeedDrop(item) or isValuableEventDrop(item) then
						return true
					end
				end
			end
		end
	end
	return false
end

function shouldCollectDrop(item)
	if not item.Parent then
		return false
	end
	if isEventWeatherActive() then
		return true
	end
	local name = getDropDisplayName(item):lower()
	return name:find("rainbow") ~= nil
		or name:find("starfall") ~= nil
		or name:find("gold") ~= nil
		or name:find("seedpack") ~= nil
		or name:find("seed pack") ~= nil
end

local GENERIC_DROP_NAMES = {
	part = true,
	meshpart = true,
	model = true,
	folder = true,
	attachment = true,
	weldconstraint = true,
	proximityprompt = true,
}

function isValuableEventDrop(item)
	if not item or not item.Parent then
		return false
	end
	if item:GetAttribute("SeedPack") then
		return true
	end
	if item:GetAttribute("RainbowSeed") == true then
		return true
	end
	if item:GetAttribute("GoldSeed") == true then
		return true
	end
	if item:GetAttribute("DisplayName") or item:GetAttribute("ItemName") then
		return true
	end
	local name = item.Name:lower()
	if GENERIC_DROP_NAMES[name] then
		return false
	end
	return shouldCollectDrop(item)
end

function getDropPosition(item)
	if not item or not item.Parent then
		return nil
	end
	local visual = item:FindFirstChild("Visual")
	if visual then
		if visual:IsA("Model") then
			local ok, cf = pcall(function()
				return visual:GetBoundingBox()
			end)
			if ok and cf then
				return cf.Position
			end
			local pp = visual.PrimaryPart or visual:FindFirstChildWhichIsA("BasePart")
			if pp then
				return pp.Position
			end
		elseif visual:IsA("BasePart") then
			return visual.Position
		end
	end
	if item:IsA("BasePart") then
		return item.Position
	end
	if item:IsA("Model") then
		local pp = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
		return pp and pp.Position
	end
end

function firePrompt(prompt)
	if not prompt then
		return
	end
	if typeof(fireproximityprompt) == "function" then
		pcall(fireproximityprompt, prompt, 0)
	end
	pcall(function()
		prompt.Enabled = true
		prompt.MaxActivationDistance = math.max(prompt.MaxActivationDistance or 8, 18)
		prompt.RequiresLineOfSight = false
		prompt:InputHoldBegin()
		task.wait(math.max(prompt.HoldDuration or 0, 0.08) + 0.12)
		prompt:InputHoldEnd()
	end)
	if typeof(getconnections) == "function" then
		local ok, conns = pcall(getconnections, prompt.Triggered)
		if ok and type(conns) == "table" then
			for _, conn in ipairs(conns) do
				pcall(function()
					if conn.Function then
						conn.Function(LP)
					elseif conn.Fire then
						conn:Fire(LP)
					end
				end)
			end
		end
	end
end

function getEventSeedWatchKeys(item)
	local keys = {}
	if item:GetAttribute("RainbowSeed") == true then
		keys[#keys + 1] = "Rainbow"
	end
	if item:GetAttribute("GoldSeed") == true then
		keys[#keys + 1] = "Gold"
	end
	local dn = getDropDisplayName(item):lower()
	if dn:find("rainbow", 1, true) then
		keys[#keys + 1] = "Rainbow"
	end
	if dn:find("gold", 1, true) and dn:find("seed", 1, true) then
		keys[#keys + 1] = "Gold"
	end
	local seen = {}
	local out = {}
	for _, k in ipairs(keys) do
		if not seen[k] then
			seen[k] = true
			out[#out + 1] = k
		end
	end
	return out
end

function snapshotEventSeeds(keys)
	local snap = {}
	for _, k in ipairs(keys) do
		snap[k] = getOwnedSeedCount(k)
	end
	return snap
end

function eventSeedsIncreased(before, keys)
	for _, k in ipairs(keys) do
		if getOwnedSeedCount(k) > (before[k] or 0) then
			return true
		end
	end
	return false
end

function isActiveMapSeedSpawn(item)
	if not item or not item.Parent then
		return false
	end
	local folder = item.Parent.Name
	if folder == "SeedPackSpawnClient" then
		return false
	end
	if folder == "DroppedItems" then
		return isValuableEventDrop(item)
	end
	if folder == "SeedPackSpawnServerLocations" then
		if item:GetAttribute("RainbowSeed") == true then
			return true
		end
		if item:GetAttribute("GoldSeed") == true then
			return true
		end
		local sp = item:GetAttribute("SeedPack")
		if type(sp) == "string" and sp ~= "" then
			return true
		end
		if isEventWeatherActive() then
			return true
		end
		return false
	end
	return isValuableEventDrop(item)
end

function forceTouchCollect(item, pos)
	local hrp = getHRP()
	if not hrp or not pos then
		return
	end
	local part = getDropPrimaryPart(item)
	if part and part:IsA("BasePart") then
		pcall(function()
			part.CanTouch = true
		end)
	end
	pcall(function()
		hrp.CanTouch = true
	end)
	hrp.CFrame = CFrame.new(pos + Vector3.new(0, 1.2, 0))
	pcall(function()
		h…