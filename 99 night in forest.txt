-- ============================================================
-- WISNU HUB | 99 NIGHT — Obsidian Edition
-- ============================================================
local Library     = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager  = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()
if not Library then return end

local Players          = game:GetService("Players")
local Workspace        = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui          = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local RunService       = game:GetService("RunService")

local LocalPlayer   = Players.LocalPlayer
local ItemsFolder   = Workspace:FindFirstChild("Items") or Workspace:WaitForChild("Items", 10)
local RemoteEvents  = ReplicatedStorage:FindFirstChild("RemoteEvents") or ReplicatedStorage:WaitForChild("RemoteEvents", 10)
local RemoteConsume = ReplicatedStorage:FindFirstChild("RequestConsumeItem")
local TreesFolder   = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Foliage")
local ScriptRunning = true
local CAMPFIRE_POS  = Vector3.new(0, 19, 0)
local MACHINE_POS   = Vector3.new(21, 16, -5)

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================
local function getRootPart()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end

local function findValidPart(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") and obj.PrimaryPart then return obj.PrimaryPart end
    for _, child in ipairs(obj:GetDescendants()) do
        if child:IsA("BasePart") or child:IsA("MeshPart") then return child end
    end
end

local function getItemPosition(item)
    if not item or not item:IsDescendantOf(workspace) then return nil end
    if item:IsA("Model") then return item:GetPivot().Position
    elseif item:IsA("BasePart") then return item.Position
    else local p = findValidPart(item); return p and p.Position end
end

local function resetVelocity(item)
    pcall(function()
        local parts = item:IsA("BasePart") and {item} or item:GetDescendants()
        for _, p in ipairs(parts) do
            if p:IsA("BasePart") then
                p.AssemblyLinearVelocity  = Vector3.zero
                p.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end)
end

local function setItemCFrame(item, pos)
    pcall(function()
        if item:IsA("BasePart") then item.CFrame = CFrame.new(pos)
        elseif item:IsA("Model") then item:PivotTo(CFrame.new(pos)) end
    end)
end

local WEAPON_BLACKLIST = {
    ["Pistol"]=true,["Revolver"]=true,["Rifle"]=true,["Chainsaw"]=true,
    ["Spear"]=true,["Old Axe"]=true,["Good Axe"]=true,["Strong Axe"]=true,
    ["Shotgun"]=true,["Knife"]=true,["Rifle Ammo"]=true,["Revolver Ammo"]=true,
    ["Old Flashlight"]=true,["MedKit"]=true,["Bandage"]=true,
}

local function reliableDragItemToPos(item, pos)
    if not item or not item:IsDescendantOf(workspace) then return end
    -- Jangan drag senjata/medic
    if WEAPON_BLACKLIST[item.Name] then return end
    pcall(function()
        local dragStart = RemoteEvents:FindFirstChild("RequestStartDraggingItem")
        local dragStop  = RemoteEvents:FindFirstChild("StopDraggingItem")
        if dragStart then dragStart:FireServer(item) end
        -- Pakai MoveTo (confirmed dari Lutosys opensrc)
        if item:IsA("Model") then
            item:MoveTo(pos)
        elseif item:IsA("BasePart") then
            item.CFrame = CFrame.new(pos)
        end
        task.wait(0.05)
        if dragStop then dragStop:FireServer(item) end
    end)
end

local function teleportTo(pos)
    local hrp = getRootPart()
    if hrp then pcall(function() hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0)) end) end
end

local function getLostChildPart(index)
    local ok, result = pcall(function()
        local path = string.format("Map.Landmarks.Jail Cellar%d.Dino", index)
        local cur = workspace
        for part in path:gmatch("[^%.]+") do
            cur = cur:FindFirstChild(part)
            if not cur then return nil end
        end
        return cur
    end)
    return ok and result and findValidPart(result)
end

-- ============================================================
-- TREE UTILITY
-- ============================================================
local TreeUtility = {}
TreeUtility.ToolDamageObject = RemoteEvents and RemoteEvents.ToolDamageObject
TreeUtility.HoldingAxe = function()
    local ok, r = pcall(function()
        for _, m in ipairs(LocalPlayer.Character:GetChildren()) do
            if m:IsA("Model") and m:GetAttribute("ToolName") and m:GetAttribute("ToolName"):find("Axe") then
                return m:FindFirstChild("OriginalItem").Value
            end
        end
    end)
    return ok and r
end
TreeUtility.CanChop = function(_, tree)
    if not tostring(tree):find("Big") then return true end
    for _, t in pairs(LocalPlayer.Inventory:GetChildren()) do
        if t:GetAttribute("ToolName") and t:GetAttribute("ToolName"):find("Chainsaw") then return true end
    end
    return false
end
TreeUtility.GetTreesInRadius = function(self, radius)
    local res = {}
    local hrp = getRootPart(); if not hrp then return res end
    local folder = TreesFolder or Workspace:FindFirstChild("Foliage") or Workspace:FindFirstChild("Trees")
    if not folder then return res end
    for _, tree in ipairs(folder:GetChildren()) do
        if tree:IsA("Model") and tree:FindFirstChild("Trunk") and self:CanChop(tree) then
            local trunk = tree:FindFirstChild("Trunk")
            local dist = (trunk.Position - hrp.Position).Magnitude
            if dist < radius and (tree:GetAttribute("Health") or 10) > 0 then
                table.insert(res, {Tree=tree, Trunk=trunk, Distance=dist})
            end
        end
    end
    table.sort(res, function(a,b) return a.Distance < b.Distance end)
    return res
end
TreeUtility.ChopTree = function(self, tree, trunk)
    local _, r = pcall(function()
        local hrp = getRootPart(); if not hrp then return end
        local axe = self.HoldingAxe(); if not axe then return end
        local EH = require(LocalPlayer.PlayerScripts.Client.EnemyHandler)
        return self.ToolDamageObject:InvokeServer(tree, axe, EH.GetHitRegId(), hrp.CFrame, true)
    end)
    return r
end

-- ============================================================
-- STATE
-- ============================================================
local State = {
    autoEat = false, autoCook = false, autoEatThreshold = 70,
    autoGrindItems = {}, autoFuelItems = {},
    killAura = false, auraRadius = 350,
    treeAura = false, treeAuraRadius = 80,
    espMobs = false, espItems = false, espTrees = false,
    fullbright = false,
    walkSpeed = 16, infiniteJump = false,
    showFPS = false,
}

local toolPriority = {"Chainsaw","Strong Axe","Good Axe","Spear","Old Axe"}
local toolIds      = {["Chainsaw"]="647",["Strong Axe"]="116",["Good Axe"]="112",["Spear"]="196",["Old Axe"]="1"}
local rawFoodsToCook = {"Morsel","Steak"}
local autoEatFoods   = {"Cooked Steak","Cooked Morsel","Berry","Carrot","Apple"}

local function getBestSpoofTool()
    for _, name in ipairs(toolPriority) do
        for _, loc in ipairs({LocalPlayer.Inventory, LocalPlayer.Backpack, LocalPlayer.Character}) do
            if loc then
                local t = loc:FindFirstChild(name)
                if t then return t, toolIds[name].."_"..tostring(LocalPlayer.UserId) end
            end
        end
    end
end

-- ============================================================
-- ESP
-- ============================================================
local espFolder = Instance.new("Folder"); espFolder.Name = "WisnuESP"; espFolder.Parent = CoreGui
local function createESP(inst, name, color)
    local part = findValidPart(inst); if not part then return end
    local hl = Instance.new("Highlight", espFolder)
    hl.Adornee = inst; hl.FillColor = color; hl.OutlineColor = Color3.new(1,1,1)
    hl.FillTransparency = 0.6; hl.OutlineTransparency = 0
    local bg = Instance.new("BillboardGui", espFolder)
    bg.Adornee = part; bg.Size = UDim2.new(0,120,0,25); bg.AlwaysOnTop = true; bg.StudsOffset = Vector3.new(0,3,0)
    local txt = Instance.new("TextLabel", bg)
    txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1
    txt.TextColor3 = color; txt.TextStrokeTransparency = 0.2
    txt.Font = Enum.Font.GothamBold; txt.TextScaled = true
    task.spawn(function()
        while bg.Parent and inst.Parent do
            local hrp = getRootPart()
            if hrp then txt.Text = string.format("%s [%dm]", name, math.floor((part.Position - hrp.Position).Magnitude)) end
            task.wait(0.5)
        end
        hl:Destroy(); bg:Destroy()
    end)
end
local function refreshESP()
    espFolder:ClearAllChildren()
    if State.espMobs then
        local chars = Workspace:FindFirstChild("Characters")
        if chars then for _, m in ipairs(chars:GetChildren()) do createESP(m, m.Name, Color3.fromRGB(255,50,50)) end end
    end
    if State.espItems then
        for _, item in ipairs(ItemsFolder:GetChildren()) do createESP(item, item.Name, Color3.fromRGB(50,255,50)) end
    end
end

-- Tree ESP
local treeESPList = {}
local function updateTreeESP(tree)
    if not treeESPList[tree] then
        local part = tree:FindFirstChild("Trunk") or findValidPart(tree); if not part then return end
        local bb = Instance.new("BillboardGui"); bb.Name="TreeESP"; bb.Size=UDim2.fromScale(4,1)
        bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true; bb.Parent=CoreGui; bb.Adornee=part
        local lbl = Instance.new("TextLabel",bb); lbl.Size=UDim2.fromScale(1,1)
        lbl.BackgroundTransparency=1; lbl.TextScaled=true; lbl.Font=Enum.Font.GothamBold; lbl.TextStrokeTransparency=0
        treeESPList[tree] = {gui=bb,label=lbl}
    end
    local hp = tree:GetAttribute("Health")
    if not hp or hp <= 0 then treeESPList[tree].gui:Destroy(); treeESPList[tree]=nil; return end
    treeESPList[tree].label.Text = "HP: "..hp
    treeESPList[tree].label.TextColor3 = hp>5 and Color3.fromRGB(0,255,0) or hp>2 and Color3.fromRGB(255,170,0) or Color3.fromRGB(255,0,0)
end

-- ============================================================
-- FPS/PING
-- ============================================================
if CoreGui:FindFirstChild("WISNU_FPS") then CoreGui.WISNU_FPS:Destroy() end
local fpsGui = Instance.new("ScreenGui"); fpsGui.Name="WISNU_FPS"; fpsGui.Parent=CoreGui
fpsGui.ResetOnSpawn=false; fpsGui.IgnoreGuiInset=true
local fpsFrame = Instance.new("Frame",fpsGui); fpsFrame.Size=UDim2.new(0,160,0,28)
fpsFrame.Position=UDim2.new(0,10,0,10); fpsFrame.BackgroundColor3=Color3.fromRGB(0,0,0)
fpsFrame.BackgroundTransparency=0.4; fpsFrame.Visible=false
Instance.new("UICorner",fpsFrame).CornerRadius=UDim.new(0,4)
local fpsTxt = Instance.new("TextLabel",fpsFrame); fpsTxt.Size=UDim2.new(1,0,1,0)
fpsTxt.BackgroundTransparency=1; fpsTxt.TextColor3=Color3.fromRGB(0,255,128)
fpsTxt.Font=Enum.Font.GothamBold; fpsTxt.TextSize=12; fpsTxt.Text=" FPS:0  Ping:0ms"
local _fc,_ft=0,0
RunService.RenderStepped:Connect(function(dt)
    if not State.showFPS then return end
    _fc+=1; _ft+=dt
    if _ft>=1 then
        local p=0; pcall(function() p=LocalPlayer:GetNetworkPing()*1000 end)
        fpsTxt.Text=string.format(" FPS:%d  Ping:%.0fms",_fc,p); _fc=0; _ft=0
    end
end)

-- ============================================================
-- BACKGROUND LOOPS
-- ============================================================
-- Kill Aura
task.spawn(function()
    while ScriptRunning do
        if State.killAura then
            local hrp = getRootPart()
            local tool, dmgID = getBestSpoofTool()
            if hrp and tool and dmgID then
                pcall(function() RemoteEvents.EquipItemHandle:FireServer("FireAllClients", tool) end)
                for _, folder in ipairs({Workspace:FindFirstChild("Characters"), Workspace}) do
                    if folder then
                        for _, mob in ipairs(folder:GetChildren()) do
                            local hum = mob:FindFirstChildOfClass("Humanoid")
                            if hum and hum.Health > 0 and mob ~= LocalPlayer.Character then
                                local mobHrp = mob:FindFirstChild("HumanoidRootPart") or findValidPart(mob)
                                if mobHrp and (mobHrp.Position - hrp.Position).Magnitude <= State.auraRadius then
                                    task.spawn(function() pcall(function() RemoteEvents.ToolDamageObject:InvokeServer(mob, tool, dmgID, mobHrp.CFrame) end) end)
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- Tree Aura
task.spawn(function()
    while true do
        if State.treeAura then
            for _, info in ipairs(TreeUtility:GetTreesInRadius(State.treeAuraRadius)) do
                if info.Tree:IsDescendantOf(workspace) then TreeUtility:ChopTree(info.Tree, info.Trunk); task.wait(0.1) end
            end
        end
        task.wait(0.3)
    end
end)

-- Tree ESP refresh
task.spawn(function()
    while true do
        if State.espTrees and TreesFolder then
            for _, t in ipairs(TreesFolder:GetChildren()) do
                if t.Name == "Small Tree" then updateTreeESP(t) end
            end
        end
        task.wait(0.5)
    end
end)

-- Auto Eat
task.spawn(function()
    while ScriptRunning do
        if State.autoEat then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health < hum.MaxHealth * (State.autoEatThreshold/100) then
                local hrp = getRootPart()
                local best, bestDist = nil, math.huge
                for _, item in ipairs(ItemsFolder:GetChildren()) do
                    if table.find(autoEatFoods, item.Name) and item:IsDescendantOf(workspace) then
                        local pos = getItemPosition(item)
                        if pos and hrp then
                            local d = (pos - hrp.Position).Magnitude
                            if d < bestDist then bestDist = d; best = item end
                        end
                    end
                end
                if best then
                    if hrp then reliableDragItemToPos(best, hrp.Position + Vector3.new(0,2,0)); task.wait(0.2) end
                    if RemoteConsume then pcall(function() RemoteConsume:InvokeServer(best) end) end
                end
            end
        end
        task.wait(1)
    end
end)

-- Auto Grind/Cook/Fuel
local processingItems = {}
task.spawn(function()
    while ScriptRunning do
        local hrp = getRootPart()
        if hrp then
            for _, item in ipairs(ItemsFolder:GetDescendants()) do
                if item and item:IsDescendantOf(workspace) and (item:IsA("Model") or item:IsA("Tool") or item:IsA("BasePart")) then
                    local id = tostring(item)
                    if not processingItems[id] then
                        local shouldGrind = State.autoGrindItems[item.Name]
                        local shouldFuel  = State.autoFuelItems[item.Name]
                        local shouldCook  = State.autoCook and table.find(rawFoodsToCook, item.Name)
                        if shouldGrind or shouldFuel or shouldCook then
                            local targetPos = shouldGrind and MACHINE_POS or CAMPFIRE_POS
                            local pos = getItemPosition(item)
                            if pos and (pos - hrp.Position).Magnitude <= 1000 and (pos - targetPos).Magnitude >= 12 then
                                processingItems[id] = true
                                task.spawn(function() reliableDragItemToPos(item, targetPos); task.wait(1); processingItems[id] = nil end)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

-- Walk speed + inf jump
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    hum.WalkSpeed = State.walkSpeed
end)
UserInputService.JumpRequest:Connect(function()
    if State.infiniteJump then
        local c = LocalPlayer.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Day/Night notification
local wasNight = nil
Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
    local t = Lighting.ClockTime; local isNight = t >= 18 or t < 6
    if wasNight ~= nil and isNight ~= wasNight then
        Library:Notify({Title = isNight and "Night Time" or "Day Time", Description = isNight and "Malam — hati hati mob!" or "Siang — aman!", Duration = 4})
    end
    wasNight = isNight
end)
wasNight = Lighting.ClockTime >= 18 or Lighting.ClockTime < 6

-- F5 toggle tree aura
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F5 then
        State.treeAura = not State.treeAura
        Library:Notify({Title="Tree Aura", Description=State.treeAura and "ON" or "OFF", Duration=2})
    end
end)

-- Fullbright connection
local fullbrightConn = nil
local function setFullbright(v)
    if fullbrightConn then fullbrightConn:Disconnect(); fullbrightConn = nil end
    if v then
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
        fullbrightConn = RunService.RenderStepped:Connect(function()
            Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
        end)
    else
        Lighting.Brightness = 1; Lighting.ClockTime = 12; Lighting.GlobalShadows = true
    end
end

-- ============================================================
-- WINDOW
-- ============================================================
local Window = Library:CreateWindow({
    Title    = "WISNU HUB",
    Footer   = "99 Night v5.32",
    AutoShow = true,
    Center   = true,
    MobileButtonsSide = "Right",
})
local Tabs = {
    Main     = Window:AddTab({Name="Main",    Icon="home"}),
    Aura     = Window:AddTab({Name="Aura",    Icon="zap"}),
    Tree     = Window:AddTab({Name="Tree",    Icon="activity"}),
    ItemTP   = Window:AddTab({Name="Item TP", Icon="package"}),
    TeleTP   = Window:AddTab({Name="Teleport",Icon="map-pin"}),
    Visual   = Window:AddTab({Name="Visual",  Icon="eye"}),
    Player   = Window:AddTab({Name="Player",  Icon="user"}),
    Misc     = Window:AddTab({Name="Misc",    Icon="tool"}),
    Config   = Window:AddTab({Name="Config",  Icon="settings"}),
}
local function N(t,d,dur) Library:Notify({Title=t,Description=d,Duration=dur or 3}) end

-- ── MAIN ─────────────────────────────────────────────────────
local grpFarm = Tabs.Main:AddLeftGroupbox("Auto Farm")
grpFarm:AddToggle("AutoEat",  {Text="Auto Eat",  Default=false, Tooltip="Makan saat HP < threshold", Callback=function(v) State.autoEat=v end})
grpFarm:AddToggle("AutoCook", {Text="Auto Cook", Default=false, Tooltip="Masak makanan mentah di Campfire", Callback=function(v) State.autoCook=v end})
grpFarm:AddSlider("EatThresh",{Text="Eat HP Threshold", Min=10, Max=95, Default=70, Rounding=0, Callback=function(v) State.autoEatThreshold=v end})
grpFarm:AddDropdown("AutoGrind",{Text="Auto Grind Items", Multi=true,
    Values={"UFO Junk","UFO Component","Old Car Engine","Broken Fan","Old Microwave","Bolt","Log","Cultist Gem","Sheet Metal","Old Radio","Tyre","Washing Machine","Gem of the Forest Fragment","Broken Microwave"},
    Callback=function(v) State.autoGrindItems={}; for k,s in pairs(v) do if s then State.autoGrindItems[k]=true end end
})
grpFarm:AddDropdown("AutoFuel",{Text="Auto Fuel Items", Multi=true,
    Values={"Log","Coal","Fuel Canister","Oil Barrel","Biofuel"},
    Callback=function(v) State.autoFuelItems={}; for k,s in pairs(v) do if s then State.autoFuelItems[k]=true end end
})

-- ── AURA ─────────────────────────────────────────────────────
local grpKill = Tabs.Aura:AddLeftGroupbox("Kill Aura")
grpKill:AddToggle("KillAura", {Text="Kill Aura", Default=false, Callback=function(v) State.killAura=v end})
grpKill:AddInput("AuraRadius",{Text="Radius", Default="350", Numeric=true, Finished=true, Callback=function(v) State.auraRadius=tonumber(v) or 350 end})

-- ── TREE AURA ─────────────────────────────────────────────────
local grpTree = Tabs.Tree:AddLeftGroupbox("Tree Aura")
grpTree:AddToggle("TreeAura", {Text="Tree Aura (F5)", Default=false, Callback=function(v) State.treeAura=v end})
grpTree:AddInput("TreeRadius",{Text="Radius", Default="80", Numeric=true, Finished=true, Callback=function(v) State.treeAuraRadius=tonumber(v) or 80 end})
grpTree:AddButton({Text="Chop All (1x)", Callback=function()
    local trees = TreeUtility:GetTreesInRadius(State.treeAuraRadius)
    local n = 0
    for _, info in ipairs(trees) do TreeUtility:ChopTree(info.Tree, info.Trunk); n+=1; task.wait(0.05) end
    N("Tree Aura", "Chopped "..n.." trees", 3)
end})

-- ── ITEM TP ───────────────────────────────────────────────────
local grpItemTP = Tabs.ItemTP:AddLeftGroupbox("Item Teleport")
local itemCategories = {
    Food       = {"Berry","Carrot","Cake","Apple","Steak","Morsel","Cooked Steak","Cooked Morsel","Pumpkin","Ribs"},
    Equipment  = {"Pistol","Revolver","Rifle","Chainsaw","Old Flashlight","Rifle Ammo","Revolver Ammo","Spear"},
    Medic      = {"MedKit","Bandage"},
    Armor      = {"Iron Body","Leather Body"},
    Fuel       = {"Log","Coal","Fuel Canister","Oil Barrel","Biofuel","Chair","Metal Chair"},
    Junk       = {"UFO Junk","UFO Component","Old Car Engine","Broken Fan","Old Microwave","Bolt","Sheet Metal","Old Radio","Tyre","Washing Machine","Broken Microwave","Mossy Coin"},
}
local selectedItem = {}
for catName, listItems in pairs(itemCategories) do
    selectedItem[catName] = listItems[1]
    grpItemTP:AddDropdown("TP_"..catName, {Text=catName, Values=listItems, Default=1, Callback=function(v) selectedItem[catName]=v end})
    local cn = catName
    grpItemTP:AddButton({Text="Bring "..cn, Callback=function()
        local hrp = getRootPart(); if not hrp then return end
        local sel = selectedItem[cn]; local list = {}
        for _, item in ipairs(ItemsFolder:GetDescendants()) do
            if item.Name == sel and (item:IsA("Model") or item:IsA("Tool") or item:IsA("BasePart")) then
                local pos = getItemPosition(item)
                if pos then table.insert(list, {item=item, dist=(pos-hrp.Position).Magnitude}) end
            end
        end
        table.sort(list, function(a,b) return a.dist < b.dist end)
        local base = hrp.Position + Vector3.new(0,2,0)
        for i, d in ipairs(list) do
            local tp = base + Vector3.new((i-1)%3*1.5, math.floor((i-1)/3)*1.5, 0)
            task.spawn(function() reliableDragItemToPos(d.item, tp) end)
        end
        N("Item TP", "Brought "..#list.."x "..sel, 2)
    end})
end

-- ── TELEPORT ─────────────────────────────────────────────────
local grpTP = Tabs.TeleTP:AddLeftGroupbox("Teleport")
grpTP:AddButton({Text="TP to Campfire", Callback=function() teleportTo(CAMPFIRE_POS) end})
for i = 1, 4 do
    local idx = i
    grpTP:AddButton({Text="Lost Child "..idx, Callback=function()
        local part = getLostChildPart(idx)
        if part then teleportTo(part.Position); N("Teleport","Lost Child "..idx.." — OK",2)
        else N("Error","Lost Child "..idx.." not found",2) end
    end})
end

-- ── VISUAL ───────────────────────────────────────────────────
local grpESP = Tabs.Visual:AddLeftGroupbox("ESP")
grpESP:AddToggle("ESPMobs",  {Text="ESP Mobs",  Default=false, Callback=function(v) State.espMobs=v;  refreshESP() end})
grpESP:AddToggle("ESPItems", {Text="ESP Items", Default=false, Callback=function(v) State.espItems=v; refreshESP() end})
grpESP:AddToggle("ESPTrees", {Text="ESP Trees (HP)", Default=false, Callback=function(v)
    State.espTrees = v
    if not v then for _, e in pairs(treeESPList) do pcall(function() e.gui:Destroy() end) end; treeESPList = {} end
end})

local grpViz = Tabs.Visual:AddRightGroupbox("Performance")
grpViz:AddToggle("ShowFPS",   {Text="FPS & Ping", Default=false, Callback=function(v) State.showFPS=v; fpsFrame.Visible=v end})
grpViz:AddToggle("Fullbright",{Text="Fullbright", Default=false, Callback=function(v) State.fullbright=v; setFullbright(v) end})
grpViz:AddButton({Text="Reduce Map (Potato)", Callback=function()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material=Enum.Material.SmoothPlastic; obj.Reflectance=0
            elseif obj:IsA("Texture") or obj:IsA("Decal") then obj:Destroy()
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj:Destroy()
            elseif obj:IsA("PostEffect") then obj.Enabled=false
            end
        end
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") or e:IsA("Atmosphere") or e:IsA("Sky") then e:Destroy() end
        end
        Lighting.GlobalShadows = false; Lighting.FogEnd = 999999
    end)
    N("Reduce Map", "Potato mode active!", 3)
end})

-- ── PLAYER ───────────────────────────────────────────────────
local grpPlayer = Tabs.Player:AddLeftGroupbox("Player")
grpPlayer:AddSlider("WalkSpeed",   {Text="Walk Speed", Min=0, Max=200, Default=16, Rounding=0, Callback=function(v) State.walkSpeed=v end})
grpPlayer:AddToggle("InfiniteJump",{Text="Infinite Jump", Default=false, Callback=function(v) State.infiniteJump=v end})

-- ── MISC ─────────────────────────────────────────────────────
local grpMisc = Tabs.Misc:AddLeftGroupbox("Misc")
grpMisc:AddToggle("FPS_Misc", {Text="FPS & Ping", Default=false, Callback=function(v) State.showFPS=v; fpsFrame.Visible=v end})

-- ── CONFIG ───────────────────────────────────────────────────
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("WisnuHub_99Night")
SaveManager:BuildConfigSection(Tabs.Config)
ThemeManager:ApplyToTab(Tabs.Config)

N("WISNU HUB", "99 Night loaded!", 3)