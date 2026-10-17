-- Grow a Garden 2 Kaitun
-- larp x ronzy.exe
-- join our discord: https://discord.gg/76tHHGBrfz

if type(getgenv) ~= "function" then
	local _env = _G
	getgenv = function() return _env end
end

local CFG = {
	scriptVersion = "kaitun-1.0.0",
	farmLoopInterval = 0.08,
	harvestRange = 45,
	harvestBatch = 220,
	teleportHeight = 2.5,
	inventorySellAt = 92,
	inventoryLimit = 100,
	minMoneyKeep = 500,
	priorityBuySeeds = {
		Bamboo = { minMoney = 700, maxPerCycle = 30, maxOwned = 400 },
		Mushroom = { minMoney = 12000, maxPerCycle = 5, maxOwned = 40 },
	},
	skipSeeds = { "Rainbow", "Gold" },
	seedRoiRatio = 8,
	fillIdleWithFallback = true,
	fallbackFillMinScore = 80,
	fallbackFillMinFreeSpots = 20,
	cleanupSeeds = {
		Carrot = true, Blueberry = true, Apple = true, Strawberry = true,
		Tomato = true, Corn = true, Grape = true, Pineapple = true,
		Cactus = true, ["Green Bean"] = true, Banana = true, Coconut = true,
		Tulip = true, ["Baby Cactus"] = true, Mango = true, ["Dragon Fruit"] = true,
	},
	cleanupReplacementMinScore = 1000,
	cleanupReplacementRatio = 0.5,
	cleanupMaxPerCycle = 20,
	cleanupRetryCooldown = 45,
	wateringCans = { "Super Watering Can", "Common Watering Can" },
	sprinklers = {
		"Super Sprinkler", "Rare Sprinkler", "Uncommon Sprinkler", "Common Sprinkler",
	},
	buyGearWhenMoneyAbove = 50,
	gearMinMoneyReserve = 80000,
	wateringCanMinMoneyReserve = 3000,
	buyCratesWhenMoneyAbove = 25000,
	autoExpandGarden = true,
	maxGardenExpansionBought = 20,
	antiAfkInterval = 60,
	fpsCap = 8,
	actionFps = 60,
	muteAudio = true,
	disable3DRender = true,
}

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local LP = Players.LocalPlayer
while not LP do task.wait(0.05); LP = Players.LocalPlayer end

local SharedModules, Gardens, NET
local NET_OK = false
local FARM_GEN = (getgenv().GAG2_FARM_GEN or 0) + 1
getgenv().GAG2_FARM_GEN = FARM_GEN
local HOOK_GEN = (getgenv().GAG2_HOOK_GEN or 0) + 1
getgenv().GAG2_HOOK_GEN = HOOK_GEN

local function farmGenActive() return (getgenv().GAG2_FARM_GEN or 0) == FARM_GEN end
local function hookStillActive() return (getgenv().GAG2_HOOK_GEN or 0) == HOOK_GEN end

local STATS = {
	startClock = os.clock(),
	money = 0,
	inv = 0,
	invLimit = CFG.inventoryLimit,
	harvested = 0,
	soldCount = 0,
	soldValue = 0,
	bought = 0,
	planted = 0,
	watered = 0,
	sprinklersPlaced = 0,
	cleaned = 0,
	expansions = 0,
	crates = 0,
	cycles = 0,
	lastStatus = "starting...",
}

-- ===== utilities =====
local function wr(msg)
	print("[KAITUN] " .. tostring(msg))
end

local function getHRP()
	local char = LP.Character
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function getMoney()
	local ls = LP:FindFirstChild("leaderstats")
	local s = ls and ls:FindFirstChild("Sheckles")
	return s and s.Value or 0
end

local function getPlot()
	if not Gardens then return nil end
	for _, p in Gardens:GetChildren() do
		if p:GetAttribute("OwnerUserId") == LP.UserId then return p end
	end
end

local function getPlantAreaParts(plot)
	local parts = {}
	local vis = plot and plot:FindFirstChild("Visual")
	if not vis then return parts end
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
	return parts
end

local function teleportNear(pos, maxDist)
	maxDist = maxDist or 14
	local hrp = getHRP()
	if not hrp then return false end
	if (hrp.Position - pos).Magnitude <= maxDist then return true end
	hrp.CFrame = CFrame.new(pos)
	task.wait(0.06)
	return (hrp.Position - pos).Magnitude <= maxDist + 4
end

local function teleportToPlot(plot)
	local vis = plot and plot:FindFirstChild("Visual")
	if not vis then return false end
	for _, c in vis:GetChildren() do
		if c.Name:find("PlantAreaColumn") and c:IsA("BasePart") then
			return teleportNear(c.Position + Vector3.new(0, CFG.teleportHeight, 0), 999)
		end
	end
	return false
end

local function callRemote(remote, ...)
	if not remote then return false end
	local fn = remote.Invoke or remote.Fire
	if not fn then return false end
	local ok, a, b = pcall(fn, remote, ...)
	if not ok then return false end
	if a == false then return false end
	if type(a) == "string" then
		local lo = a:lower()
		if lo:find("fail") or lo:find("error") or lo:find("reject") or lo:find("cooldown") then
			return false
		end
	end
	return true
end

local _burstDepth, _idleFps = 0, nil
local function fpsBurstBegin()
	if type(setfpscap) ~= "function" then return end
	if _burstDepth == 0 then
		_idleFps = CFG.fpsCap
		pcall(setfpscap, CFG.actionFps)
	end
	_burstDepth = _burstDepth + 1
end

local function fpsBurstEnd()
	if type(setfpscap) ~= "function" then return end
	_burstDepth = math.max(0, _burstDepth - 1)
	if _burstDepth == 0 then
		pcall(setfpscap, _idleFps or 8)
	end
end

local function firePaced(remote, ...)
	local ok = callRemote(remote, ...)
	RunService.Heartbeat:Wait()
	return ok
end

-- ===== boot =====
local function waitForCoreAssets(timeoutSec)
	timeoutSec = timeoutSec or 120
	local deadline = os.clock() + timeoutSec
	wr("[BOOT] waiting for SharedModules...")
	pcall(function() LP:SetAttribute("LoadingScreenActive", false) end)

	local sm
	while os.clock() < deadline do
		sm = RS:FindFirstChild("SharedModules")
		if sm then break end
		task.wait(0.25)
	end
	if not sm then return nil, nil, nil end

	local gardens = workspace:FindFirstChild("Gardens")
		or workspace:WaitForChild("Gardens", math.max(1, deadline - os.clock()))

	local netMod = sm:WaitForChild("Networking", math.max(1, deadline - os.clock()))
	local net
	if netMod then
		local ok, r = pcall(require, netMod)
		if ok then net = r end
	end
	wr(string.format("[BOOT] NET=%s Gardens=%s", net and "yes" or "no", gardens and "yes" or "no"))
	return sm, gardens, net
end

SharedModules, Gardens, NET = waitForCoreAssets(120)
NET_OK = NET ~= nil

-- ===== seed data =====
local SELL_VALUES = {
	Carrot = 5, Strawberry = 3, Tomato = 9, Blueberry = 5, Apple = 12,
	Bamboo = 800, Cactus = 40, Pineapple = 30, ["Green Bean"] = 10,
	Banana = 35, Grape = 45, Mushroom = 13000, Coconut = 60, Mango = 90,
	["Dragon Fruit"] = 150, Acorn = 200, Cherry = 350, Sunflower = 1750,
	["Venus Fly Trap"] = 3000, Pomegranate = 900, ["Moon Bloom"] = 9000,
	["Dragon's Breath"] = 3400, ["Glow Mushroom"] = 700, Corn = 34,
	["Baby Cactus"] = 70, Tulip = 60, Romanesco = 1500,
}

local SEED_DATA = {
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
	Coconut = { yield = { 1, 1 }, price = 10 },
	Mango = { yield = { 1, 1 }, price = 15 },
	["Green Bean"] = { yield = { 1, 2 }, price = 15 },
	["Dragon Fruit"] = { yield = { 1, 1 }, price = 30 },
	["Venus Fly Trap"] = { yield = { 1, 1 }, price = 50 },
	["Moon Bloom"] = { yield = { 1, 1 }, price = 60 },
	["Dragon's Breath"] = { yield = { 1, 1 }, price = 100 },
	["Glow Mushroom"] = { yield = { 1, 1 }, price = 100 },
	Romanesco = { yield = { 1, 1 }, price = 80 },
}

local function getSeedScore(name)
	local d = SEED_DATA[name]
	if not d then return 0 end
	local avg = (d.yield[1] + d.yield[2]) / 2
	return avg * (SELL_VALUES[name] or d.price)
end

local function seedRoiOk(name)
	local d = SEED_DATA[name]
	if not d then return true end
	local score = getSeedScore(name)
	if score <= 0 then return false end
	return (d.price or 10) <= score * (CFG.seedRoiRatio or 8)
end

local function isNoPlantSeed(name)
	for _, sn in ipairs(CFG.skipSeeds or {}) do
		if sn == name then return true end
	end
	return false
end

-- ===== harvest =====
local function collectFruits(plot)
	if not NET or not NET.Garden or not NET.Garden.CollectFruit then return 0 end
	local pl = plot:FindFirstChild("Plants")
	if not pl then return 0 end

	local entries, seenKeys, plantById = {}, {}, {}
	for _, plant in pl:GetChildren() do
		if not plant:IsA("Model") then continue end
		local pid = plant:GetAttribute("PlantId")
		if pid then plantById[pid] = plant end
		local ff = pid and plant:FindFirstChild("Fruits")
		if not ff then continue end
		local pos = plant:FindFirstChild("Base") and plant.Base.Position
			or plant.PrimaryPart and plant.PrimaryPart.Position
		for _, fruit in ff:GetDescendants() do
			local fid = fruit:GetAttribute("FruitId")
			if fid and not seenKeys[pid .. "|" .. fid] then
				seenKeys[pid .. "|" .. fid] = true
				local age = fruit:GetAttribute("Age")
				local maxAge = fruit:GetAttribute("MaxAge")
				if not (age and maxAge and age < maxAge) then
					local fname = fruit:GetAttribute("CorePartName") or fruit.Name
					local sm = fruit:GetAttribute("SizeMulti") or 1
					local mut = tostring(fruit:GetAttribute("Mutation") or "")
					local base = SELL_VALUES[fname] or 10
					local mult = mut == "Bloodlit" and 60 or mut == "Starstruck" and 50
						or mut == "Rainbow" and 30 or mut == "Electric" and 25
						or mut == "Frozen" and 14 or mut == "Gold" and 10 or 1
					table.insert(entries, {
						pid = pid, fid = fid, pos = pos,
						score = base * (sm ^ 2.65) * mult,
					})
				end
			end
		end
	end

	if #entries == 0 then return 0 end
	table.sort(entries, function(a, b) return a.score > b.score end)
	teleportToPlot(plot)

	local done, anchor = 0, nil
	local limit = math.min(#entries, CFG.harvestBatch)
	table.sort(entries, function(a, b)
		if not a.pos or not b.pos then return false end
		if math.abs(a.pos.X - b.pos.X) > 8 then return a.pos.X < b.pos.X end
		if math.abs(a.pos.Z - b.pos.Z) > 8 then return a.pos.Z < b.pos.Z end
		return (a.score or 0) > (b.score or 0)
	end)

	fpsBurstBegin()
	for i = 1, limit do
		local e = entries[i]
		if e.pos and (not anchor or (e.pos - anchor).Magnitude > CFG.harvestRange) then
			local hrp = getHRP()
			if hrp then hrp.CFrame = CFrame.new(e.pos + Vector3.new(0, CFG.teleportHeight, 0)) end
			anchor = e.pos
			RunService.Heartbeat:Wait()
		end
		if firePaced(NET.Garden.CollectFruit, e.pid, e.fid) then
			done = done + 1
		end
	end
	fpsBurstEnd()
	if done > 0 then
		STATS.harvested = STATS.harvested + done
		wr("[HARVEST] collected " .. done)
	end
	return done
end

-- ===== sell =====
local function sellAll()
	if not NET or not NET.NPCS or not NET.NPCS.SellAll then return 0, 0 end
	local totalS, totalP = 0, 0
	local fnPrev = NET.NPCS.PreviewSellAll.Invoke or NET.NPCS.PreviewSellAll.Fire
	local fnSell = NET.NPCS.SellAll.Invoke or NET.NPCS.SellAll.Fire
	for _ = 1, 50 do
		local ok, prev = pcall(fnPrev, NET.NPCS.PreviewSellAll)
		if not ok or type(prev) ~= "table" or (prev.FruitCount or 0) == 0 then break end
		local ok2, resp = pcall(fnSell, NET.NPCS.SellAll)
		if ok2 and type(resp) == "table" then
			totalS = totalS + (resp.SoldCount or 0)
			totalP = totalP + (resp.SellPrice or 0)
		else break end
	end
	if totalS > 0 then
		STATS.soldCount = STATS.soldCount + totalS
		STATS.soldValue = STATS.soldValue + totalP
		wr(string.format("[SELL] %d = $%.0f", totalS, totalP))
	end
	return totalS, totalP
end

-- ===== plant =====
local function getToolsByAttr(attr)
	local tools = {}
	local backpack = LP:FindFirstChildOfClass("Backpack")
	if backpack then
		for _, t in backpack:GetChildren() do
			if t:IsA("Tool") and t:GetAttribute(attr) then table.insert(tools, t) end
		end
	end
	local char = LP.Character
	if char then
		for _, t in char:GetChildren() do
			if t:IsA("Tool") and t:GetAttribute(attr) then table.insert(tools, t) end
		end
	end
	return tools
end

local function equipTool(t)
	local char = LP.Character
	if not char then return false end
	pcall(function() t.Parent = char end)
	task.wait(0.1)
	return t.Parent == char
end

local function unequipTool(t)
	pcall(function() t.Parent = LP.Backpack end)
end

local function plantAll(plot)
	if not NET or not NET.Plant or not NET.Plant.PlantSeed then return 0 end
	local raw = getToolsByAttr("SeedTool")
	local sorted = {}
	for _, tool in ipairs(raw) do
		local st = tool:GetAttribute("SeedTool")
		if st and not isNoPlantSeed(st) then
			table.insert(sorted, { tool = tool, seed = st, score = getSeedScore(st) })
		end
	end
	table.sort(sorted, function(a, b) return a.score > b.score end)
	if #sorted == 0 then return 0 end

	teleportToPlot(plot)
	local areas = getPlantAreaParts(plot)
	if #areas == 0 then return 0 end

	local occupied = {}
	local plants = plot:FindFirstChild("Plants")
	if plants then
		for _, p in plants:GetChildren() do
			local base = p:FindFirstChild("Base")
			if base then table.insert(occupied, base.Position) end
		end
	end

	local function findSpot()
		for _ = 1, 40 do
			local a = areas[math.random(#areas)]
			local cf, sz = a.CFrame, a.Size
			local lp = Vector3.new(-sz.X / 2 + math.random() * sz.X, 0.5, -sz.Z / 2 + math.random() * sz.Z)
			local pos = cf:PointToWorldSpace(lp)
			local ok = true
			for _, o in ipairs(occupied) do
				if (pos - o).Magnitude < 3.5 then ok = false; break end
			end
			if ok then return pos end
		end
	end

	local done = 0
	for _, entry in ipairs(sorted) do
		local tool, st = entry.tool, entry.seed
		while tool and tool.Parent and done < 24 do
			local pos = findSpot()
			if not pos then break end
			teleportNear(pos + Vector3.new(0, CFG.teleportHeight, 0), 18)
			if not equipTool(tool) then break end
			if callRemote(NET.Plant.PlantSeed, pos, st, tool) then
				done = done + 1
				table.insert(occupied, pos)
				task.wait(0.05)
			else break end
		end
		unequipTool(tool)
		if done >= 24 then break end
	end
	if done > 0 then
		STATS.planted = STATS.planted + done
		wr("[PLANT] " .. done)
	end
	return done
end

-- ===== buy =====
local seedBuyBlock = {}
local function isSeedBuyBlocked(name)
	return seedBuyBlock[name] and os.clock() < seedBuyBlock[name]
end

local function getStock(folderName, itemName)
	local sv = RS:FindFirstChild("StockValues")
	local shop = sv and sv:FindFirstChild(folderName)
	local items = shop and shop:FindFirstChild("Items")
	local nv = items and items:FindFirstChild(itemName)
	return (nv and nv:IsA("NumberValue") and nv.Value) or 0
end

local function purchaseSeed(name)
	if not NET or not NET.SeedShop or not NET.SeedShop.PurchaseSeed then return false end
	local d = SEED_DATA[name]
	if not d then return false end
	local price = d.price or 10
	if getMoney() < price + CFG.minMoneyKeep then return false end
	if getStock("SeedShop", name) <= 0 then return false end
	local before = getMoney()
	local ok = callRemote(NET.SeedShop.PurchaseSeed, name)
	if not ok then
		seedBuyBlock[name] = os.clock() + 90
		return false
	end
	task.wait(0.2)
	if getMoney() < before then
		STATS.bought = STATS.bought + 1
		wr(string.format("[BUY] %s ($%d)", name, price))
		return true
	end
	return false
end

local function buyPrioritySeeds()
	local bought = 0
	local counts = {}
	for name, cfg in pairs(CFG.priorityBuySeeds) do
		if not isSeedBuyBlocked(name) and seedRoiOk(name) then
			local money = getMoney()
			local per = cfg.maxPerCycle or 5
			if money >= (cfg.minMoney or 50000) and (counts[name] or 0) < per then
				if getStock("SeedShop", name) > 0 then
					if purchaseSeed(name) then
						bought = bought + 1
						counts[name] = (counts[name] or 0) + 1
					end
				end
			end
		end
	end
	return bought
end

local function buyFallbackSeed()
	local bestName, bestScore
	for name, d in pairs(SEED_DATA) do
		if not isNoPlantSeed(name) and not isSeedBuyBlocked(name) then
			local score = getSeedScore(name)
			if score >= CFG.fallbackFillMinScore and seedRoiOk(name)
				and getStock("SeedShop", name) > 0
				and getMoney() >= (d.price or 10) + CFG.minMoneyKeep then
				if not bestScore or score > bestScore then
					bestName, bestScore = name, score
				end
			end
		end
	end
	return bestName and purchaseSeed(bestName)
end

-- ===== water =====
local function getWateringTools()
	local tools = getToolsByAttr("WateringCan")
	if #tools > 0 then return tools end
	for _, n in ipairs(CFG.wateringCans) do
		if NET and NET.GearShop and NET.GearShop.EquipGear then
			callRemote(NET.GearShop.EquipGear, n)
			task.wait(0.5)
			tools = getToolsByAttr("WateringCan")
			if #tools > 0 then return tools end
		end
	end
	return tools
end

local function waterAll(plot)
	if not NET or not NET.WateringCan or not NET.WateringCan.UseWateringCan then return 0 end
	local tools = getWateringTools()
	if #tools == 0 then return 0 end
	local plants = plot:FindFirstChild("Plants")
	if not plants then return 0 end

	local targets = {}
	for _, p in plants:GetChildren() do
		if p:IsA("Model") then
			local pid = p:GetAttribute("PlantId")
			local age, maxAge = p:GetAttribute("Age"), p:GetAttribute("MaxAge")
			if pid and age and maxAge and age < maxAge then
				local base = p:FindFirstChild("Base")
				if base then table.insert(targets, { pos = base.Position, plant = p }) end
			end
		end
	end
	if #targets == 0 then return 0 end

	teleportToPlot(plot)
	local done = 0
	fpsBurstBegin()
	for _, tool in ipairs(tools) do
		local ct = tool:GetAttribute("WateringCan") or tool.Name
		if equipTool(tool) then
			for _, t in ipairs(targets) do
				if done >= 24 then break end
				local hrp = getHRP()
				if hrp then hrp.CFrame = CFrame.new(t.pos + Vector3.new(0, CFG.teleportHeight, 0)) end
				RunService.Heartbeat:Wait()
				if firePaced(NET.WateringCan.UseWateringCan, t.pos - Vector3.new(0, 0.3, 0), ct, tool) then
					done = done + 1
				end
			end
			unequipTool(tool)
		end
		if done >= 24 then break end
	end
	fpsBurstEnd()
	if done > 0 then
		STATS.watered = STATS.watered + done
		wr("[WATER] " .. done)
	end
	return done
end

-- ===== buy gear =====
local ownedGear = {}
local function hasGear(name) return ownedGear[name] == true end

local function refreshOwnedGear()
	if not NET or not NET.GearShop or not NET.GearShop.RequestEquippableState then return end
	local fn = NET.GearShop.RequestEquippableState.Invoke or NET.GearShop.RequestEquippableState.Fire
	local ok, r = pcall(fn, NET.GearShop.RequestEquippableState)
	if ok and type(r) == "table" and type(r.OwnedEquippableGears) == "table" then
		for _, v in ipairs(r.OwnedEquippableGears) do
			if type(v) == "string" then ownedGear[v] = true end
		end
	end
end

local function autoBuyGear()
	if not NET or not NET.GearShop or getMoney() < CFG.buyGearWhenMoneyAbove then return 0 end
	refreshOwnedGear()
	local bought = 0
	for _, n in ipairs(CFG.sprinklers) do
		if not hasGear(n) then
			local stock = getStock("GearShop", n)
			if stock > 0 and callRemote(NET.GearShop.PurchaseGear, n) then
				ownedGear[n] = true
				bought = bought + 1
				wr("[BUY GEAR] " .. n)
				task.wait(0.2)
			end
		end
	end
	return bought
end

-- ===== cleanup =====
local cleanupRetryAt = {}
local function cleanupLowValue(plot)
	if not NET or not NET.Shovel or not NET.Shovel.UseShovel then return 0 end
	local plants = plot:FindFirstChild("Plants")
	if not plants then return 0 end

	local all = {}
	for _, plant in plants:GetChildren() do
		if plant:IsA("Model") then
			local seed = plant:GetAttribute("SeedName") or plant:GetAttribute("Seed") or plant.Name
			if CFG.cleanupSeeds[seed] then
				table.insert(all, { plant = plant, seed = seed, score = getSeedScore(seed) })
			end
		end
	end
	if #all == 0 then return 0 end
	table.sort(all, function(a, b) return a.score < b.score end)

	local tools = getToolsByAttr("Shovel")
	if #tools == 0 then return 0 end
	local tool = tools[1]
	if not equipTool(tool) then return 0 end

	local removed = 0
	for _, entry in ipairs(all) do
		if removed >= CFG.cleanupMaxPerCycle then break end
		local pid = entry.plant.Name
		if cleanupRetryAt[pid] and cleanupRetryAt[pid] > os.clock() then continue end
		local beforeParent = entry.plant.Parent
		local base = entry.plant:FindFirstChild("Base")
		if base then
			teleportNear(base.Position + Vector3.new(0, CFG.teleportHeight, 0), 18)
		end
		callRemote(NET.Shovel.UseShovel, pid, "", tool:GetAttribute("Shovel") or "Shovel", tool)
		task.wait(0.25)
		if beforeParent and not entry.plant.Parent then
			removed = removed + 1
			STATS.cleaned = STATS.cleaned + 1
		else
			cleanupRetryAt[pid] = os.clock() + CFG.cleanupRetryCooldown
		end
	end
	unequipTool(tool)
	return removed
end

-- ===== expansion =====
local EXPANSION_PRICES = { 5000, 25000, 100000, 500000, 2500000 }
local function buyExpansion()
	if not CFG.autoExpandGarden or not NET or not NET.Actions or not NET.Actions.ExpandGarden then return false end
	local data
	pcall(function()
		local mod = RS:FindFirstChild("ClientModules") and RS.ClientModules:FindFirstChild("PlayerStateClient")
		if mod then
			local client = require(mod)
			local rep = client.GetLocalReplica and client:GetLocalReplica()
			data = rep and rep.Data
		end
	end)
	local cur = data and data.OwnedExpansions or 0
	local nextIdx = cur + 1
	if nextIdx > #EXPANSION_PRICES or cur >= CFG.maxGardenExpansionBought then return false end
	local price = EXPANSION_PRICES[nextIdx]
	if getMoney() < price then return false end
	if callRemote(NET.Actions.ExpandGarden) then
		STATS.expansions = STATS.expansions + 1
		wr(string.format("[EXPAND] %d -> %d ($%d)", cur, nextIdx, price))
		return true
	end
	return false
end

-- ===== sprinklers =====
local function placeSprinklers(plot)
	if not NET or not NET.Place or not NET.Place.PlaceSprinkler then return 0 end
	local tools = getToolsByAttr("Sprinkler")
	if #tools == 0 then
		for _, n in ipairs(CFG.sprinklers) do
			if hasGear(n) and NET.GearShop then
				callRemote(NET.GearShop.EquipGear, n)
				task.wait(0.3)
				tools = getToolsByAttr("Sprinkler")
				if #tools > 0 then break end
			end
		end
	end
	if #tools == 0 then return 0 end

	local areas = getPlantAreaParts(plot)
	if #areas == 0 then return 0 end
	local a = areas[1]
	local pos = a.Position
	teleportNear(pos + Vector3.new(0, CFG.teleportHeight, 0), 999)

	local placed = 0
	for i, tool in ipairs(tools) do
		if i > 6 then break end
		if equipTool(tool) then
			local name = tool:GetAttribute("Sprinkler") or tool.Name
			local ok = callRemote(NET.Place.PlaceSprinkler, pos, name, tool, 0)
			if ok then
				placed = placed + 1
				STATS.sprinklersPlaced = STATS.sprinklersPlaced + 1
			end
			unequipTool(tool)
			task.wait(0.2)
		end
	end
	return placed
end

-- ===== anti afk =====
local function antiAfk()
	local vu = game:GetService("VirtualUser")
	vu:CaptureController()
	vu:ClickButton2(Vector2.new())
	local hrp = getHRP()
	if hrp then
		hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, 0.1)
	end
end

-- ===== main loop =====
local function mainLoop()
	wr("[KAITUN] booting v" .. CFG.scriptVersion)
	local lastAntiAfk = 0

	while farmGenActive() do
		local ok, err = pcall(function()
			STATS.cycles = STATS.cycles + 1
			STATS.money = getMoney()

			local plot = getPlot()
			if not plot then
				STATS.lastStatus = "no plot"
				task.wait(1)
				return
			end

			-- 1. harvest
			local harvested = collectFruits(plot)

			-- 2. sell if needed
			if harvested > 0 or STATS.inv >= CFG.inventorySellAt then
				sellAll()
			end

			-- 3. cleanup junk
			if STATS.cycles % 3 == 0 then
				cleanupLowValue(plot)
			end

			-- 4. plant
			plantAll(plot)

			-- 5. water
			if STATS.cycles % 4 == 0 then
				waterAll(plot)
			end

			-- 6. buy seeds
			if STATS.cycles % 2 == 0 then
				buyPrioritySeeds()
				if CFG.fillIdleWithFallback then
					local plants = plot:FindFirstChild("Plants")
					local count = plants and #plants:GetChildren() or 0
					local areas = getPlantAreaParts(plot)
					local cap = 0
					for _, ar in ipairs(areas) do
						local sz = ar.Size
						cap = cap + math.max(math.floor(sz.X / 4) * math.floor(sz.Z / 4), 1)
					end
					if cap - count >= CFG.fallbackFillMinFreeSpots then
						buyFallbackSeed()
					end
				end
			end

			-- 7. gear + sprinklers
			if STATS.cycles % 8 == 0 then
				autoBuyGear()
				placeSprinklers(plot)
			end

			-- 8. expansion
			if STATS.cycles % 12 == 0 then
				buyExpansion()
			end

			-- 9. anti afk
			if os.clock() - lastAntiAfk > CFG.antiAfkInterval then
				lastAntiAfk = os.clock()
				antiAfk()
			end

			STATS.lastStatus = string.format(
				"cyc=%d money=$%d harv=%d sold=%d($%d) planted=%d watered=%d cleaned=%d",
				STATS.cycles, STATS.money, STATS.harvested,
				STATS.soldCount, STATS.soldValue, STATS.planted,
				STATS.watered, STATS.cleaned
			)
		end)

		if not ok then
			wr("[ERR] " .. tostring(err))
		end

		task.wait(CFG.farmLoopInterval)
	end
	wr("[KAITUN] stopped")
end

getgenv().GAG2_FARM_STOP = function()
	getgenv().GAG2_FARM_GEN = (getgenv().GAG2_FARM_GEN or 0) + 1
	wr("[KAITUN] stop signal sent")
end

task.spawn(mainLoop)
wr("[KAITUN] loaded — made by @ronzy.exe — join our discord: https://discord.gg/76tHHGBrfz")