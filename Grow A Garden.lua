if getgenv().DaraHubExecuted then
	FireClient(game:GetService("ReplicatedStorage").GameEvents.Notification, "Script Is Already Loaded, rejoin if you want to re-execute!")
	return
end
getgenv().DaraHubExecuted = true
local BaseURL = "https://darahub.pages.dev"
loadstring(game:HttpGet(BaseURL .. "/Module/Library/GUI/LoadAll.lua"))()
WindUI = loadstring(game:HttpGet(BaseURL .. "/Module/Library/GUI/WindUI-Moded/main.lua"))()
Window = WindUI:CreateWindow({
	NewElements = true,
	Title = "Dara Hub | Grow A Garden",
	Icon = BaseURL .. "/icon.png",
	Author = "Made by: Pnsdg And Yomka",
	Folder = "DaraHub/Games/Grow-A-Garden",
	Size = UDim2.fromOffset(580, 490),
	Theme = "Dark",
	HidePanelBackground = false,
	Acrylic = false,
	HideSearchBar = false,
	SideBarWidth = 200,
	OpenButton = {
		ShowIconOnly = true
	}
})
WindUI.TransparencyValue = 0.7
Window:ToggleTransparency(true)
Window:DisableTopbarButtons({
	"Fullscreen"
})
Window:Tag({
	Title = "v1.1.2",
	Color = Color3.fromHex("#30ff6a")
})
executor = identifyexecutor()
if type(executor) == "table" then
	for key, value in pairs(executor) do
		print(key .. ": " .. tostring(value))
	end
elseif type(executor) == "string" then
	Window:Tag({
		Title = "" .. executor
	})
else
	print("The injector does not support identifyexecutor()")
end
Tabs = {
	Main = Window:Tab({
		Title = "Main",
		Icon = "layout-grid"
	}),
	Player = Window:Tab({
		Title = "Player",
		Icon = "user"
	}),
	Garden = Window:Tab({
		Title = "Garden",
		Icon = "fence"
	}),
	Pet = Window:Tab({
		Title = "Pet",
		Icon = "paw-print"
	}),
	Item = Window:Tab({
		Title = "Item",
		Icon = "hammer"
	}),
	Visuals = Window:Tab({
		Title = "Visuals",
		Icon = "camera"
	}),
	Esp = Window:Tab({
		Title = "Esp",
		Icon = "eye"
	}),
	Event = Window:Tab({
		Title = "Event",
		Icon = "calendar-plus-2"
	}),
	Teleport = Window:Tab({
		Title = "Teleport",
		Icon = "navigation"
	}),
	Troll = Window:Tab({
		Title = "Troll Shit stuffs",
		Icon = "rbxassetid://6862780932"
	}),
	Misc = Window:Tab({
		Title = "Misc",
		Icon = "star"
	}),
	Utility = Window:Tab({
		Title = "Utility",
		Icon = "wrench"
	}),
	Shop = Window:Tab({
		Title = "Shop",
		Icon = "shopping-cart"
	}),
	Settings = Window:Tab({
		Title = "Settings",
		Icon = "settings"
	}),
	info = Window:Tab({
		Title = "Info",
		Icon = "info"
	}),
	Others = Window:Tab({
		Title = "Others",
		Icon = "https://em-content.zobj.net/source/apple/419/pile-of-poo_1f4a9.png"
	})
}
Tabs.Main:Section({
	Title = "Main",
	TextSize = 40
})
local UniverseServerTools = loadstring(game:HttpGet(BaseURL .. "/Module/UniverseServerTools.lua"))()
UniverseServerTools(Tabs)
Window:OnDestroy(function()
	ButtonLib:DestroyScreengui()
	if cleanupTracerESP then
		cleanupTracerESP()
	end
end)
local socialsModule = loadstring(game:HttpGet(BaseURL .. "/Module/info.lua"))()
socialsModule(Tabs)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:FindFirstChild("Backpack")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Tracer ESP Core
tracerGui = nil
tracerEntries = {}
function getTracerGui()
	if tracerGui and tracerGui.Parent then
		return tracerGui
	end
	local parentGui = PlayerGui
	if not parentGui then
		local lp = Players.LocalPlayer
		parentGui = lp and lp:FindFirstChild("PlayerGui")
	end
	if not parentGui then
		return nil
	end
	local gui = Instance.new("ScreenGui")
	gui.Name = "Tracer GUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = - 2147483648
	gui.Parent = parentGui
	tracerGui = gui
	return gui
end
function cleanupTracerESP()
	for _, data in pairs(tracerEntries) do
		if data.pivot then
			data.pivot:Destroy()
		end
	end
	tracerEntries = {}
	if tracerGui then
		tracerGui:Destroy()
		tracerGui = nil
	end
end
function ensureTracer(key, color)
	local data = tracerEntries[key]
	if data and data.pivot and data.pivot.Parent then
		if data.line then
			data.line.BackgroundColor3 = color
		end
		return data
	end
	local gui = getTracerGui()
	if not gui then
		return nil
	end
	local pivot = Instance.new("Frame")
	pivot.Name = "Tracer_" .. tostring(key)
	pivot.AnchorPoint = Vector2.new(0.5, 0.5)
	pivot.Position = UDim2.fromScale(0.5, 1)
	pivot.Size = UDim2.fromOffset(1, 1)
	pivot.BackgroundTransparency = 1
	pivot.Visible = false
	pivot.ZIndex = - 2147483648
	pivot.Parent = gui
	local line = Instance.new("Frame")
	line.Name = "Line"
	line.AnchorPoint = Vector2.new(0.5, 1)
	line.Position = UDim2.fromScale(0.5, 0.5)
	line.Size = UDim2.fromOffset(2, 0)
	line.BackgroundColor3 = color
	line.BorderSizePixel = 0
	line.ZIndex = - 2147483648
	line.Parent = pivot
	data = {
		pivot = pivot,
		line = line,
		lastPos = data and data.lastPos or nil
	}
	tracerEntries[key] = data
	return data
end
function drawTracer(data, worldPos, color)
	if not data or not data.pivot or not data.line then
		return
	end
	local camera = workspace.CurrentCamera
	if not camera or not worldPos then
		data.pivot.Visible = false
		return
	end
	data.line.BackgroundColor3 = color
	local screenPos = camera:WorldToViewportPoint(worldPos)
	local viewport = camera.ViewportSize
	local dirX = screenPos.X - (viewport.X * 0.5)
	local dirY = screenPos.Y - viewport.Y
	if screenPos.Z < 0 then
		dirX = - dirX
		dirY = - dirY
	end
	if dirX ~= dirX or dirY ~= dirY then
		data.pivot.Visible = false
		return
	end
	data.pivot.Visible = true
	data.pivot.Rotation = math.deg(math.atan2(dirX, - dirY))
	data.line.Size = UDim2.fromOffset(2, math.sqrt(dirX * dirX + dirY * dirY))
end
function tracerAnyEnabled()
	return playerTracersEnabled or npcTracersEnabled or toolTracersEnabled or downedTracersEnabled or enemyTracersEnabled or fruitTracersEnabled or gunTracersEnabled or ticketTracersEnabled or vehicleTracersEnabled or botTracersEnabled
end
function sweepDeadTracers(alive)
	for key, data in pairs(tracerEntries) do
		if not alive[key] then
			if data.pivot then
				data.pivot:Destroy()
			end
			tracerEntries[key] = nil
		end
	end
end
function getPartPos(inst)
	if not inst then
		return nil
	end
	if inst:IsA("BasePart") then
		return inst.Position
	end
	local hrp = inst:FindFirstChild("HumanoidRootPart")
	if hrp then
		return hrp.Position
	end
	local handle = inst:FindFirstChild("Handle")
	if handle then
		return handle.Position
	end
	if inst.PrimaryPart then
		return inst.PrimaryPart.Position
	end
	local part = inst:FindFirstChildWhichIsA("BasePart", true)
	if part then
		return part.Position
	end
	return nil
end
function trackTracer(key, inst, color)
	local data = ensureTracer(key, color)
	if not data then
		return
	end
	local pos = getPartPos(inst)
	if pos then
		data.lastPos = pos
	end
	if data.lastPos then
		drawTracer(data, data.lastPos, color)
	else
		data.pivot.Visible = false
	end
end
playerTracersEnabled = false
npcTracersEnabled = false
toolTracersEnabled = false
downedTracersEnabled = false
enemyTracersEnabled = false
fruitTracersEnabled = false
gunTracersEnabled = false
ticketTracersEnabled = false
vehicleTracersEnabled = false
botTracersEnabled = false
function updateTracerESP()
	if not tracerAnyEnabled() then
		cleanupTracerESP()
		return
	end
	local alive = {}
	if playerTracersEnabled then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local key = "player_" .. plr.UserId
				alive[key] = true
				local color = Color3.fromRGB(255, 255, 255)
				if getTeamColor then
					color = getTeamColor(plr)
				elseif getPlayerBoxColor then
					color = getPlayerBoxColor(plr)
				end
				trackTracer(key, plr.Character, color)
			end
		end
	end
	if fruitTracersEnabled and findCollectibleFruits then
		local fruits = findCollectibleFruits()
		for index, fruitData in ipairs(fruits) do
			local fruitPart = fruitData.part
			local fruitObj = fruitData.fruitObj or fruitPart
			if fruitPart and fruitPart.Parent then
				local key = "fruit_" .. index
				alive[key] = true
				local fruitColor = Color3.fromRGB(255, 215, 0)
				if getFruitColor then
					fruitColor = getFruitColor(fruitPart)
				end
				if checkFruitMutation and getMutationColor then
					local mutation = checkFruitMutation(fruitObj)
					if mutation then
						local mutationColor = getMutationColor(mutation)
						fruitColor = Color3.new((fruitColor.R * 0.7 + mutationColor.R * 0.3), (fruitColor.G * 0.7 + mutationColor.G * 0.3), (fruitColor.B * 0.7 + mutationColor.B * 0.3))
					end
				end
				if FruitESP and FruitESP.variant and checkFruitVariant and getVariantColor then
					local variant = checkFruitVariant(fruitObj)
					if variant then
						local variantColor = getVariantColor(variant)
						fruitColor = Color3.new((fruitColor.R * 0.6 + variantColor.R * 0.4), (fruitColor.G * 0.6 + variantColor.G * 0.4), (fruitColor.B * 0.6 + variantColor.B * 0.4))
					end
				end
				trackTracer(key, fruitPart, fruitColor)
			end
		end
	end
	sweepDeadTracers(alive)
end
if not tracerRenderConnection then
	tracerRenderConnection = RunService.RenderStepped:Connect(function()
		if tracerAnyEnabled() then
			updateTracerESP()
		end
	end)
end
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local Character
local Humanoid
local HumanoidRootPart
local function setupCharacter(CharacterInstance)
	Character = CharacterInstance
	Humanoid = Character:FindFirstChildOfClass("Humanoid")
	HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
end
if LocalPlayer.Character then
	setupCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(setupCharacter)
TPWALK = false
TpwalkValue = 1
JumpBoost = false
JumpPower = 5
SpeedHack = false
SpeedValue = 16
Noclip = false
coroutine.resume(coroutine.create(function()
	frame = PlayerGui:WaitForChild("Teleport_UI"):WaitForChild("Frame")
	if not frame:GetAttribute("UIScaled") then
		SCALE_FACTOR = 0.7
		COSMETICS_SCALE_FACTOR = 0.5
		function scaleUDim2(udim2, scale)
			return UDim2.new(udim2.X.Scale * scale, udim2.X.Offset * scale, udim2.Y.Scale * scale, udim2.Y.Offset * scale)
		end
		function scaleVector2(vector2, scale)
			return Vector2.new(vector2.X * scale, vector2.Y * scale)
		end
		frame.Size = scaleUDim2(UDim2.new(0.4, 0, 0.085, 0), SCALE_FACTOR)
		function ensureSizeConstraint(uiElement, minSize)
			sizeConstraint = uiElement:FindFirstChildOfClass("UISizeConstraint")
			if not sizeConstraint then
				sizeConstraint = Instance.new("UISizeConstraint")
				sizeConstraint.Parent = uiElement
			end
			sizeConstraint.MinSize = scaleVector2(minSize, SCALE_FACTOR)
		end
		function removeHoverEffects(button)
			button.HoverImage = ""
			button.PressedImage = ""
			button.AutoButtonColor = false
			hoverEffects = button:FindFirstChild("HoverEffects")
			if hoverEffects then
				hoverEffects:Destroy()
			end
			clickEffects = button:FindFirstChild("ClickEffects")
			if clickEffects then
				clickEffects:Destroy()
			end
		end
		sellButton = frame:WaitForChild("Sell")
		sellButton.Size = scaleUDim2(UDim2.new(0.22, 0, 0.791, 0), SCALE_FACTOR)
		ensureSizeConstraint(sellButton, Vector2.new(50, 1))
		removeHoverEffects(sellButton)
		seedsButton = frame:WaitForChild("Seeds")
		seedsButton.Size = scaleUDim2(UDim2.new(0.22, 0, 0.791, 0), SCALE_FACTOR)
		ensureSizeConstraint(seedsButton, Vector2.new(50, 1))
		removeHoverEffects(seedsButton)
		gardenButton = frame:WaitForChild("Garden")
		gardenButton.Size = scaleUDim2(UDim2.new(0.35, 0, 0.985, 0), SCALE_FACTOR)
		ensureSizeConstraint(gardenButton, Vector2.new(100, 1))
		removeHoverEffects(gardenButton)
		petsButton = frame:WaitForChild("Pets")
		removeHoverEffects(petsButton)
		gearButton = frame:WaitForChild("Gear")
		removeHoverEffects(gearButton)
		cosmeticsCraftingButton = frame:FindFirstChild("COSMETICS_and_crafting") or gearButton:Clone()
		cosmeticsCraftingButton.Name = "COSMETICS_and_crafting"
		cosmeticsCraftingButton.Size = scaleUDim2(UDim2.new(0.35, 0, 0.985, 0), COSMETICS_SCALE_FACTOR)
		cosmeticsCraftingButton.Position = scaleUDim2(UDim2.new(0, 0, 0, 250), COSMETICS_SCALE_FACTOR)
		cosmeticsCraftingButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
		cosmeticsCraftingButton.BackgroundTransparency = 0
		cosmeticsCraftingButton.Image = ""
		cosmeticsCraftingButton.Visible = false
		removeHoverEffects(cosmeticsCraftingButton)
		gearVisibility = cosmeticsCraftingButton:FindFirstChild("GearVisiblity")
		if gearVisibility then
			gearVisibility:Destroy()
		end
		cosmeticsCraftingStroke = cosmeticsCraftingButton:FindFirstChild("UIStroke") or Instance.new("UIStroke")
		cosmeticsCraftingStroke.Name = "UIStroke"
		cosmeticsCraftingStroke.Color = Color3.fromRGB(100, 0, 100)
		cosmeticsCraftingStroke.Thickness = 1 * COSMETICS_SCALE_FACTOR
		cosmeticsCraftingStroke.Parent = cosmeticsCraftingButton
		cosmeticsCraftingTextLabel = cosmeticsCraftingButton:FindFirstChild("Txt")
		if cosmeticsCraftingTextLabel and cosmeticsCraftingTextLabel:IsA("TextLabel") then
			cosmeticsCraftingTextLabel.Text = "COSM/CRAFT"
			cosmeticsCraftingTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			cosmeticsCraftingTextLabel.TextSize = cosmeticsCraftingTextLabel.TextSize * COSMETICS_SCALE_FACTOR
		else
			cosmeticsCraftingTextLabel = Instance.new("TextLabel")
			cosmeticsCraftingTextLabel.Name = "Txt"
			cosmeticsCraftingTextLabel.Text = "COSM/CRAFT"
			cosmeticsCraftingTextLabel.Size = UDim2.new(1, 0, 1, 0)
			cosmeticsCraftingTextLabel.BackgroundTransparency = 1
			cosmeticsCraftingTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			cosmeticsCraftingTextLabel.TextScaled = true
			cosmeticsCraftingTextLabel.Parent = cosmeticsCraftingButton
		end
		textStroke = cosmeticsCraftingTextLabel:FindFirstChild("UIStroke") or Instance.new("UIStroke")
		textStroke.Name = "UIStroke"
		textStroke.Color = Color3.fromRGB(58, 0, 0)
		textStroke.Thickness = 1 * COSMETICS_SCALE_FACTOR
		textStroke.Parent = cosmeticsCraftingTextLabel
		ensureSizeConstraint(cosmeticsCraftingButton, Vector2.new(100, 1))
		cosmeticsCraftingButton.Parent = frame
		eventButton = frame:FindFirstChild("Event") or gardenButton:Clone()
		eventButton.Name = "Event"
		eventButton.Size = scaleUDim2(UDim2.new(0.35, 0, 0.985, 0), SCALE_FACTOR)
		eventButton.Position = scaleUDim2(UDim2.new(0, 0, 0, 200), SCALE_FACTOR)
		eventButton.Image = "rbxassetid://110208924430993"
		removeHoverEffects(eventButton)
		eventTextLabel = eventButton:FindFirstChild("Txt")
		if eventTextLabel and eventTextLabel:IsA("TextLabel") then
			eventTextLabel.Text = "EVENT"
			eventTextLabel.TextSize = eventTextLabel.TextSize * SCALE_FACTOR
		else
			eventTextLabel = Instance.new("TextLabel")
			eventTextLabel.Name = "Txt"
			eventTextLabel.Text = "EVENT"
			eventTextLabel.Size = UDim2.new(1, 0, 1, 0)
			eventTextLabel.BackgroundTransparency = 1
			eventTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			eventTextLabel.TextScaled = true
			eventTextLabel.Parent = eventButton
		end
		ensureSizeConstraint(eventButton, Vector2.new(100, 1))
		eventButton.Parent = frame
		petsButton.Size = scaleUDim2(petsButton.Size, SCALE_FACTOR)
		gearButton.Size = scaleUDim2(gearButton.Size, SCALE_FACTOR)
		function scaleButtonText(button)
			textLabel = button:FindFirstChild("Txt")
			if textLabel and textLabel:IsA("TextLabel") then
				if not textLabel.TextScaled then
					textLabel.TextSize = textLabel.TextSize * SCALE_FACTOR
				end
			end
		end
		scaleButtonText(petsButton)
		scaleButtonText(gearButton)
		scaleButtonText(sellButton)
		scaleButtonText(seedsButton)
		scaleButtonText(gardenButton)
		petsButton.Visible = true
		gearButton.Visible = true
		eventButton.Visible = true
		task.spawn(function()
			task.wait(0)
			cosmeticsCraftingButton.Visible = true
		end)
		frame:SetAttribute("UIScaled", true)
		TeleportPlayer = require(ReplicatedStorage.Modules.TeleportPlayer)
		function teleportToTutorialPoint(pointName, displayName)
			tutorialPoints = workspace:FindFirstChild("Tutorial_Points")
			if tutorialPoints then
				targetPoint = tutorialPoints:FindFirstChild(pointName)
				if targetPoint then
					TeleportPlayer(LocalPlayer, targetPoint.CFrame, displayName)
				else
					warn("Tutorial point not found: " .. pointName)
				end
			else
				warn("Tutorial_Points folder not found in workspace")
			end
		end
		petsButton.MouseButton1Click:Connect(function()
			teleportToTutorialPoint("Tutorial_Point_4", "Pet Stand")
		end)
		gearButton.MouseButton1Click:Connect(function()
			teleportToTutorialPoint("Tutorial_Point_3", "Gear Stands")
		end)
		eventButton.MouseButton1Click:Connect(function()
			eventPoint = workspace:FindFirstChild("Event_Point", true)
			if eventPoint then
				TeleportPlayer(LocalPlayer, eventPoint.CFrame, "Event")
			else
				warn("Event_Point not found in workspace.Interaction")
			end
		end)
		cosmeticsCraftingButton.MouseButton1Click:Connect(function()
			craftingTables = workspace:FindFirstChild("CraftingTables")
			if craftingTables then
				targetCFrame = craftingTables:GetPivot()
				offsetPosition = targetCFrame.Position + Vector3.new(5, 0, 5)
				rotatedCFrame = CFrame.new(offsetPosition) * CFrame.Angles(0, math.rad(90), 0)
				TeleportPlayer(LocalPlayer, rotatedCFrame, "Crafting")
			else
				warn("CraftingTables not found in workspace")
			end
		end)
	end
end))
function IsAlive(Player, currentRoles)
	for i, v in pairs(currentRoles) do
		if Player.Name == i then
			if not v.Killed and not v.Dead then
				return true
			else
				return false
			end
		end
	end
	return false
end
function getOutlineColor(c)
	local lum = 0.299 * c.R + 0.587 * c.G + 0.114 * c.B
	if lum > 0.5 then
		return Color3.new(0, 0, 0)
	else
		return Color3.new(1, 1, 1)
	end
end
Tabs.Main:Section({
	Title = "Scan Highest Fruit from My Garden"
})
Tabs.Main:Divider()
gardenFruitList = {}
gardenFruitParagraph = Tabs.Main:Paragraph({
	Title = "No fruits found",
	Desc = "Click Refresh to scan your garden"
})
function scanGardenFruits()
	gardenFruitList = {}
	local myPlots = getMyFarmPlots()
	if not myPlots or # myPlots == 0 then
		return gardenFruitList
	end
	for _, plot in pairs(myPlots) do
		local important = plot:FindFirstChild("Important")
		if important then
			local plantsPhysical = important:FindFirstChild("Plants_Physical")
			if plantsPhysical then
				for _, plant in pairs(plantsPhysical:GetChildren()) do
					if plant:IsA("Model") then
						local fruitsFolder = plant:FindFirstChild("Fruits")
						if fruitsFolder then
							for _, fruit in pairs(fruitsFolder:GetChildren()) do
								local prompt = fruit:FindFirstChildWhichIsA("ProximityPrompt", true)
								if prompt and prompt.Enabled == false then
									continue
								end
								local weight = getFruitWeight(fruit) or 0
								local value = getFruitValue(fruit) or 0
								local mutation = checkMutation(fruit)
								local variant = checkVariant(fruit)
								table.insert(gardenFruitList, {
									Fruit = fruit,
									Plant = plant,
									Name = fruit.Name,
									Weight = weight,
									Value = value,
									Mutation = mutation,
									Variant = variant
								})
							end
						end
					end
				end
			end
		end
	end
	table.sort(gardenFruitList, function(a, b)
		return (a.Value or 0) > (b.Value or 0)
	end)
	return gardenFruitList
end
function collectGardenFruit(fruitObj, plantObj)
	if not fruitObj then
		return false
	end
	local prompt = fruitObj:FindFirstChildWhichIsA("ProximityPrompt", true)
	if prompt and prompt.Enabled then
		fireproximityprompt(prompt, 0)
		if plantObj then
			task.spawn(function()
				pcall(function()
					ReplicatedStorage.GameEvents.Crops.Collect:FireServer({
						plantObj
					})
				end)
			end)
		end
		playCollectSound()
		return true
	else
		if plantObj then
			task.spawn(function()
				pcall(function()
					ReplicatedStorage.GameEvents.Crops.Collect:FireServer({
						plantObj
					})
				end)
			end)
			playCollectSound()
			return true
		end
	end
	return false
end
Tabs.Main:Button({
	Title = "Refresh Garden Fruits",
	Callback = function()
		gardenFruitList = scanGardenFruits()
		if # gardenFruitList > 0 then
			local top = gardenFruitList[1]
			local mutationText = top.Mutation or "None"
			local variantText = top.Variant or "None"
			gardenFruitParagraph:SetTitle(top.Name)
			gardenFruitParagraph:SetDesc(string.format([[Mutation: %s
Weight: %s KG
Value: $%s
Variant: %s]], mutationText, tostring(top.Weight), tostring(math.floor(top.Value)), variantText))
			WindUI:Notify({
				Title = "Scan Complete",
				Content = string.format("Found %d fruit(s). Highest: %s ($%s)", # gardenFruitList, top.Name, math.floor(top.Value)),
				Duration = 3
			})
		else
			gardenFruitParagraph:SetTitle("No fruits found")
			gardenFruitParagraph:SetDesc("No fruits in your garden")
			WindUI:Notify({
				Title = "Scan Complete",
				Content = "No fruits found in your garden",
				Duration = 2
			})
		end
	end
})
Tabs.Main:Button({
	Title = "Collect Highest Fruit",
	Callback = function()
		gardenFruitList = scanGardenFruits()
		if # gardenFruitList == 0 then
			WindUI:Notify({
				Title = "Collection Failed",
				Content = "No fruits found in your garden",
				Duration = 3
			})
			return
		end
		local target = gardenFruitList[1]
		if target and target.Fruit and target.Plant then
			local success = collectGardenFruit(target.Fruit, target.Plant)
			if success then
				WindUI:Notify({
					Title = "Collection Success",
					Content = string.format("Collected %s (Value: $%s)", target.Name, math.floor(target.Value)),
					Duration = 3
				})
				task.wait(0.5)
				gardenFruitList = scanGardenFruits()
				if # gardenFruitList > 0 then
					local nextFruit = gardenFruitList[1]
					gardenFruitParagraph:SetTitle(nextFruit.Name)
					gardenFruitParagraph:SetDesc(string.format([[Mutation: %s
Weight: %s KG
Value: $%s
Variant: %s]], nextFruit.Mutation or "None", tostring(nextFruit.Weight), tostring(math.floor(nextFruit.Value)), nextFruit.Variant or "None"))
				else
					gardenFruitParagraph:SetTitle("No fruits found")
					gardenFruitParagraph:SetDesc("All fruits collected")
				end
			else
				WindUI:Notify({
					Title = "Collection Failed",
					Content = "Could not collect fruit. Try refreshing.",
					Duration = 3
				})
			end
		else
			WindUI:Notify({
				Title = "Collection Failed",
				Content = "Invalid fruit data",
				Duration = 3
			})
		end
	end
})
Tabs.Main:Divider()
Tabs.Main:Section({
	Title = "Steal Fruit"
})
Tabs.Main:Divider()
fruitList = {}
fruitParagraph = Tabs.Main:Paragraph({
	Title = "No fruits found",
	Desc = "Click Refresh to scan for fruits"
})
local billboardGui = nil
local billboardAdornee = nil
local function createBillboard(targetFruit)
	if billboardGui then
		billboardGui:Destroy()
		billboardGui = nil
		billboardAdornee = nil
	end
	if not targetFruit then
		return
	end
	billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(0, 80, 0, 20)
	billboardGui.StudsOffset = Vector3.new(0, 3, 0)
	billboardGui.AlwaysOnTop = true
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "STEAL TARGET"
	textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.TextStrokeTransparency = 0
	textLabel.Parent = billboardGui
	billboardGui.Parent = targetFruit
	billboardAdornee = targetFruit
end
local function removeBillboard()
	if billboardGui then
		billboardGui:Destroy()
		billboardGui = nil
		billboardAdornee = nil
	end
end
local function findProximityPrompt(obj)
	if not obj then
		return nil
	end
	local prompt = obj:FindFirstChild("ProximityPrompt")
	if prompt then
		return prompt
	end
	for _, child in pairs(obj:GetChildren()) do
		prompt = findProximityPrompt(child)
		if prompt then
			return prompt
		end
	end
	return nil
end
local function buildGetChildrenPath(fruit)
	if not fruit then
		return nil
	end
	local fruitsFolder = fruit.Parent
	local plant = fruitsFolder and fruitsFolder.Parent
	local plantsPhysical = plant and plant.Parent
	local important = plantsPhysical and plantsPhysical.Parent
	local plot = important and important.Parent
	local farm = plot and plot.Parent
	if not (farm and plot and important and plantsPhysical and plant and fruitsFolder) then
		return nil
	end
	local function findIndex(parent, child)
		if not parent or not child then
			return nil
		end
		for i, c in pairs(parent:GetChildren()) do
			if c == child then
				return i
			end
		end
		return nil
	end
	local plotIndex = findIndex(farm, plot)
	local plantIndex = findIndex(plantsPhysical, plant)
	local fruitIndex = findIndex(fruitsFolder, fruit)
	if not (plotIndex and plantIndex and fruitIndex) then
		return nil
	end
	local path = string.format("workspace.Farm:GetChildren()[%d].Important.Plants_Physical:GetChildren()[%d].Fruits:GetChildren()[%d]", plotIndex, plantIndex, fruitIndex)
	return path
end
Tabs.Main:Button({
	Title = "Scan highest value Fruits",
	Callback = function()
		fruitList = {}
		farmFolder = workspace:FindFirstChild("Farm")
		if not farmFolder then
			fruitParagraph:SetDesc("Farm folder not found")
			return
		end
		for _, plot in pairs(farmFolder:GetChildren()) do
			sign = plot:FindFirstChild("Sign")
			owner = sign and sign:GetAttribute("_owner")
			if owner and owner ~= LocalPlayer then
				important = plot:FindFirstChild("Important")
				if important then
					plantsPhysical = important:FindFirstChild("Plants_Physical")
					if plantsPhysical then
						for _, plant in pairs(plantsPhysical:GetChildren()) do
							fruitsFolder = plant:FindFirstChild("Fruits")
							if fruitsFolder then
								for _, fruit in pairs(fruitsFolder:GetChildren()) do
									local proximityPrompt = findProximityPrompt(fruit)
									if proximityPrompt and proximityPrompt.Enabled == false then
									else
										weight = fruit:FindFirstChild("Weight")
										weightValue = weight and weight.Value or 0
										value = 0
										pcall(function()
											value = require(ReplicatedStorage.Modules.CalculatePlantValue)(fruit)
										end)
										mutations = {}
										for attr, val in pairs(fruit:GetAttributes()) do
											if type(val) == "boolean" and val == true then
												table.insert(mutations, attr)
											end
										end
										variant = fruit:FindFirstChild("Variant")
										variantName = variant and variant.Value or "None"
										local path = buildGetChildrenPath(fruit)
										table.insert(fruitList, {
											Fruit = fruit,
											Name = fruit.Name,
											Owner = owner,
											Weight = weightValue,
											Value = value,
											Mutations = mutations,
											Variant = variantName,
											Plant = plant,
											ProximityPrompt = proximityPrompt,
											Path = path
										})
									end
								end
							end
						end
					end
				end
			end
		end
		table.sort(fruitList, function(a, b)
			return (a.Value or 0) > (b.Value or 0)
		end)
		if # fruitList > 0 then
			top = fruitList[1]
			mutationText = # top.Mutations > 0 and table.concat(top.Mutations, ", ") or "None"
			fruitParagraph:SetTitle(top.Name)
			fruitParagraph:SetDesc(string.format("Owner: %s\nMutation: %s\nWeight: %s\nValue: $%s\nVariant: %s", top.Owner, mutationText, tostring(top.Weight), tostring(math.floor(top.Value)), top.Variant))
			createBillboard(top.Fruit)
		else
			fruitParagraph:SetTitle("No fruits found")
			fruitParagraph:SetDesc("No fruits available to steal from other players")
			removeBillboard()
		end
	end
})
Tabs.Main:Button({
	Title = "Steal Now",
	Callback = function()
		if # fruitList == 0 then
			WindUI:Notify({
				Title = "Steal Failed",
				Content = "No fruits available to steal",
				Duration = 3
			})
			return
		end
		target = fruitList[1]
		if target and target.Path then
			local collectEvent = ReplicatedStorage.GameEvents.Crops.Collect
			if collectEvent then
				local loadstringFunc = loadstring("return " .. target.Path)
				if loadstringFunc then
					local success, result = pcall(loadstringFunc)
					if success and result then
						collectEvent:FireServer({
							result
						})
						WindUI:Notify({
							Title = "Steal Attempt",
							Content = string.format("Attempted to steal %s from %s", target.Name, target.Owner),
							Duration = 3
						})
						removeBillboard()
					else
						WindUI:Notify({
							Title = "Steal Failed",
							Content = "Failed to execute path to fruit",
							Duration = 3
						})
					end
				else
					WindUI:Notify({
						Title = "Steal Failed",
						Content = "Invalid path format",
						Duration = 3
					})
				end
			else
				WindUI:Notify({
					Title = "Steal Failed",
					Content = "Collect event not found",
					Duration = 3
				})
			end
		else
			WindUI:Notify({
				Title = "Steal Failed",
				Content = "No path found for fruit",
				Duration = 3
			})
		end
	end
})
Tabs.Main:Button({
	Title = "Add Billboard",
	Callback = function()
		if # fruitList > 0 then
			createBillboard(fruitList[1].Fruit)
			WindUI:Notify({
				Title = "Billboard Added",
				Content = "Steal target billboard is now visible",
				Duration = 2
			})
		else
			WindUI:Notify({
				Title = "No Target",
				Content = "Scan for fruits first",
				Duration = 2
			})
		end
	end
})
Tabs.Main:Button({
	Title = "Remove Billboard",
	Callback = function()
		removeBillboard()
		WindUI:Notify({
			Title = "Billboard Removed",
			Content = "Steal target billboard has been removed",
			Duration = 2
		})
	end
})
Tabs.Main:Section({
	Title = "Scan Best Fruit in Inventory"
})
Tabs.Main:Divider()
inventoryList = {}
inventoryParagraph = Tabs.Main:Paragraph({
	Title = "No items in inventory",
	Desc = "Click Find Highest price to scan your inventory"
})
Tabs.Main:Button({
	Title = "Find Highest price",
	Callback = function()
		inventoryList = {}
		if Backpack then
			for _, item in pairs(Backpack:GetChildren()) do
				if item:IsA("Tool") and item:FindFirstChild("Item_Seed") then
					value = 0
					pcall(function()
						value = require(ReplicatedStorage.Modules.CalculatePlantValue)(item)
					end)
					weightObj = item:FindFirstChild("Weight")
					weight = weightObj and weightObj.Value or 0
					mutations = {}
					for attr, val in pairs(item:GetAttributes()) do
						if type(val) == "boolean" and val == true then
							table.insert(mutations, attr)
						end
					end
					variant = item:FindFirstChild("Variant")
					variantName = variant and variant.Value or "None"
					table.insert(inventoryList, {
						Item = item,
						Name = item.Name,
						Value = value,
						Weight = weight,
						Mutations = mutations,
						Variant = variantName
					})
				end
			end
		end
		if Character then
			for _, item in pairs(Character:GetChildren()) do
				if item:IsA("Tool") and item:FindFirstChild("Item_Seed") then
					value = 0
					pcall(function()
						value = require(ReplicatedStorage.Modules.CalculatePlantValue)(item)
					end)
					weightObj = item:FindFirstChild("Weight")
					weight = weightObj and weightObj.Value or 0
					mutations = {}
					for attr, val in pairs(item:GetAttributes()) do
						if type(val) == "boolean" and val == true then
							table.insert(mutations, attr)
						end
					end
					variant = item:FindFirstChild("Variant")
					variantName = variant and variant.Value or "None"
					table.insert(inventoryList, {
						Item = item,
						Name = item.Name,
						Value = value,
						Weight = weight,
						Mutations = mutations,
						Variant = variantName
					})
				end
			end
		end
		table.sort(inventoryList, function(a, b)
			return (a.Value or 0) > (b.Value or 0)
		end)
		if # inventoryList > 0 then
			top = inventoryList[1]
			mutationText = # top.Mutations > 0 and table.concat(top.Mutations, ", ") or "None"
			cleanTitle = top.Name:gsub("%[.-%]", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
			inventoryParagraph:SetTitle(cleanTitle)
			inventoryParagraph:SetDesc(string.format("Weight: %s KG\nValue: $%s\nMutation: %s\nVariant: %s", tostring(top.Weight), tostring(math.floor(top.Value)), mutationText, top.Variant))
		else
			inventoryParagraph:SetTitle("No fruits found")
			inventoryParagraph:SetDesc("No fruits in your inventory")
		end
	end
})
Tabs.Main:Button({
	Title = "Equip Best Item",
	Callback = function()
		if # inventoryList == 0 then
			WindUI:Notify({
				Title = "Equip Failed",
				Content = "No fruits in inventory",
				Duration = 3
			})
			return
		end
		target = inventoryList[1]
		if target and target.Item then
			Character = LocalPlayer.Character
			Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if Humanoid and target.Item.Parent == LocalPlayer.Backpack then
				Humanoid:EquipTool(target.Item)
				WindUI:Notify({
					Title = "Equipped",
					Content = string.format("Equipped %s (Value: $%s)", target.Name, math.floor(target.Value)),
					Duration = 3
				})
			end
		end
	end
})
Tabs.Main:Divider()
Tabs.Main:Section({
	Title = "Scan Best Pet in Inventory"
})
Tabs.Main:Divider()
petList = {}
petParagraph = Tabs.Main:Paragraph({
	Title = "No pets in inventory",
	Desc = "Click Find Best Pet to scan your pets"
})
Tabs.Main:Button({
	Title = "Find Best Pet",
	Callback = function()
		petList = {}
		CalculatePetValue = require(ReplicatedStorage.Modules.CalculatePetValue)
		scanFunction = function(item)
			if item:IsA("Tool") and item:GetAttribute("ItemType") == "Pet" then
				value = 0
				pcall(function()
					value = CalculatePetValue(item)
				end)
				mutations = {}
				for attr, val in pairs(item:GetAttributes()) do
					if type(val) == "boolean" and val == true then
						table.insert(mutations, attr)
					end
				end
				level = item:GetAttribute("Level") or 1
				itemName = item.Name
				weight = 0
				weightMatch = itemName:match("%[(%d+%.?%d*)%s*KG%]")
				if not weightMatch then
					weightMatch = itemName:match("%[(%d+)%s*KG%]")
				end
				if weightMatch then
					weight = tonumber(weightMatch) or 0
				end
				age = 0
				ageMatch = itemName:match("%[Age%s*(%d+)%]")
				if not ageMatch then
					ageMatch = itemName:match("%[(%d+)%s*Age%]")
				end
				if ageMatch then
					age = tonumber(ageMatch) or 0
				end
				cleanName = itemName
				cleanName = cleanName:gsub("%[%d+%.?%d*%s*KG%]", "")
				cleanName = cleanName:gsub("%[Age%s*%d+%]", "")
				cleanName = cleanName:gsub("%[%d+%s*Age%]", "")
				cleanName = cleanName:gsub("%s+", " ")
				cleanName = cleanName:gsub("^%s*(.-)%s*$", "%1")
				if # cleanName == 0 then
					cleanName = itemName
				end
				table.insert(petList, {
					Pet = item,
					Name = itemName,
					CleanName = cleanName,
					Value = value,
					Mutations = mutations,
					Level = level,
					Age = age,
					Weight = weight
				})
			end
		end
		if Backpack then
			for _, item in pairs(Backpack:GetChildren()) do
				scanFunction(item)
			end
		end
		if Character then
			for _, item in pairs(Character:GetChildren()) do
				scanFunction(item)
			end
		end
		table.sort(petList, function(a, b)
			return (a.Value or 0) > (b.Value or 0)
		end)
		if # petList > 0 then
			top = petList[1]
			mutationText = # top.Mutations > 0 and table.concat(top.Mutations, ", ") or "None"
			displayText = string.format("Value: $%s\nLevel: %s\nMutation: %s", tostring(math.floor(top.Value)), tostring(top.Level), mutationText)
			if top.Weight and top.Weight > 0 then
				displayText = displayText .. string.format("\nWeight: %s KG", tostring(top.Weight))
			end
			if top.Age and top.Age > 0 then
				displayText = displayText .. string.format("\nAge: %s", tostring(top.Age))
			end
			petParagraph:SetTitle(top.CleanName)
			petParagraph:SetDesc(displayText)
		else
			petParagraph:SetTitle("No pets found")
			petParagraph:SetDesc("No pets in your inventory")
		end
	end
})
Tabs.Main:Button({
	Title = "Equip Best Pet",
	Callback = function()
		if # petList == 0 then
			WindUI:Notify({
				Title = "Equip Failed",
				Content = "No pets in inventory",
				Duration = 3
			})
			return
		end
		target = petList[1]
		if target and target.Pet then
			Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			if Humanoid and target.Pet.Parent == LocalPlayer.Backpack then
				Humanoid:EquipTool(target.Pet)
				WindUI:Notify({
					Title = "Equipped",
					Content = string.format("Equipped %s (Value: $%s)", target.CleanName, math.floor(target.Value)),
					Duration = 3
				})
			end
		end
	end
})
Tabs.Main:Divider()
Tabs.Main:Section({
	Title = "Current Hand Scanner"
})
Tabs.Main:Divider()
handParagraph = Tabs.Main:Paragraph({
	Title = "Nothing in hand",
	Desc = "Check your current item"
})
Tabs.Main:Button({
	Title = "Calculate Hand Value",
	Callback = function()
		handItem = nil
		if Character then
			for _, item in pairs(Character:GetChildren()) do
				if item:IsA("Tool") then
					handItem = item
					break
				end
			end
		end
		if not handItem then
			handParagraph:SetTitle("Nothing in hand")
			handParagraph:SetDesc("Your hand is empty")
			WindUI:Notify({
				Title = "Calculate Failed",
				Content = "Nothing in your hand",
				Duration = 3
			})
			return
		end
		value = 0
		itemType = handItem:GetAttribute("ItemType")
		itemName = handItem.Name
		cleanTitle = itemName:gsub("%[.-%]", ""):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
		if itemType == "Pet" then
			CalculatePetValue = require(ReplicatedStorage.Modules.CalculatePetValue)
			pcall(function()
				value = CalculatePetValue(handItem)
			end)
			mutations = {}
			for attr, val in pairs(handItem:GetAttributes()) do
				if type(val) == "boolean" and val == true then
					table.insert(mutations, attr)
				end
			end
			level = handItem:GetAttribute("Level") or 1
			mutationText = # mutations > 0 and table.concat(mutations, ", ") or "None"
			weight = 0
			weightMatch = itemName:match("%[(%d+%.?%d*)%s*KG%]")
			if not weightMatch then
				weightMatch = itemName:match("%[(%d+)%s*KG%]")
			end
			if weightMatch then
				weight = tonumber(weightMatch) or 0
			end
			age = 0
			ageMatch = itemName:match("%[Age%s*(%d+)%]")
			if not ageMatch then
				ageMatch = itemName:match("%[(%d+)%s*Age%]")
			end
			if ageMatch then
				age = tonumber(ageMatch) or 0
			end
			weightObj = handItem:FindFirstChild("Weight")
			if weightObj and weight == 0 then
				weight = weightObj.Value
			end
			displayText = string.format("Value: $%s\nType: Pet\nLevel: %s\nMutation: %s", tostring(math.floor(value)), tostring(level), mutationText)
			if weight and weight > 0 then
				displayText = displayText .. string.format("\nWeight: %s KG", tostring(weight))
			end
			if age and age > 0 then
				displayText = displayText .. string.format("\nAge: %s", tostring(age))
			end
			handParagraph:SetTitle(cleanTitle)
			handParagraph:SetDesc(displayText)
		else
			pcall(function()
				value = require(ReplicatedStorage.Modules.CalculatePlantValue)(handItem)
			end)
			weightObj = handItem:FindFirstChild("Weight")
			weight = weightObj and weightObj.Value or 0
			mutations = {}
			for attr, val in pairs(handItem:GetAttributes()) do
				if type(val) == "boolean" and val == true then
					table.insert(mutations, attr)
				end
			end
			variant = handItem:FindFirstChild("Variant")
			variantName = variant and variant.Value or "None"
			mutationText = # mutations > 0 and table.concat(mutations, ", ") or "None"
			handParagraph:SetTitle(cleanTitle)
			handParagraph:SetDesc(string.format("Value: $%s\nType: %s\nWeight: %s KG\nMutation: %s\nVariant: %s", tostring(math.floor(value)), itemType or "Fruit", tostring(weight), mutationText, variantName))
		end
		WindUI:Notify({
			Title = "Hand Value",
			Content = string.format("%s: $%s", cleanTitle, math.floor(value)),
			Duration = 4
		})
	end
})
Tabs.Player:Section({
	Title = "Player",
	TextSize = 40
})
Tabs.Player:Divider()
function onCharacterAdded(newCharacter)
	Character = newCharacter
	Humanoid = Character:WaitForChild("Humanoid", 5)
	rootPart = Character:WaitForChild("HumanoidRootPart", 5)
	if JumpBoost and Humanoid then
		Humanoid.JumpPower = JumpPower
		Humanoid.JumpHeight = JumpPower
		setupJumpBoost()
	end
	if SpeedHack and Humanoid then
		Humanoid.WalkSpeed = SpeedValue
	end
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then
	onCharacterAdded(LocalPlayer.Character)
end
local InfiniteJump = {
	State = nil,
	Connection = nil,
	Enabled = false
}
local function StartInfiniteJump()
	if InfiniteJump.Enabled then
		return
	end
	InfiniteJump.Enabled = true
	InfiniteJump.Connection = RunService.RenderStepped:Connect(function()
		if not InfiniteJump.Enabled then
			return
		end
		if not Humanoid then
			if LocalPlayer.Character then
				Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			end
			if not Humanoid then
				return
			end
		end
		if Humanoid.Jump then
			if InfiniteJump.State then
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				InfiniteJump.State = false
			end
		else
			InfiniteJump.State = true
		end
	end)
end
local function StopInfiniteJump()
	InfiniteJump.Enabled = false
	if InfiniteJump.Connection then
		InfiniteJump.Connection:Disconnect()
		InfiniteJump.Connection = nil
	end
	InfiniteJump.State = nil
end
InfiniteJumpToggle = Tabs.Player:Toggle({
	Title = "Infinite Jump",
	Flag = "InfiniteJumpToggle",
	Value = false,
	Callback = function(state)
		if state then
			StartInfiniteJump()
		else
			StopInfiniteJump()
		end
	end
})
Tabs.Player:Space()
SpeedToggle = Tabs.Player:Toggle({
	Title = "Speed Hack",
	Flag = "SpeedToggle",
	Value = SpeedHack,
	Callback = function(state)
		SpeedHack = state
		if state and Humanoid then
			Humanoid.WalkSpeed = SpeedValue
		elseif Humanoid then
			Humanoid.WalkSpeed = 16
		end
	end
})
SpeedSlider = Tabs.Player:Slider({
	Title = "Speed Value",
	Flag = "SpeedSlider",
	Desc = "Adjust walk speed",
	Value = {
		Min = 16,
		Max = 200,
		Default = SpeedValue,
		Step = 1
	},
	Callback = function(value)
		SpeedValue = value
		if SpeedHack and Humanoid then
			Humanoid.WalkSpeed = value
		end
	end
})
Tabs.Player:Space()
Noclip = nil
Clip = nil
function noclip()
	Clip = false
	function Nocl()
		if Clip == false and LocalPlayer.Character ~= nil then
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA('BasePart') and v.CanCollide then
					v.CanCollide = false
				end
			end
		end
		wait(0.21)
	end
	Noclip = RunService.Stepped:Connect(Nocl)
end
function clip()
	if Noclip then
		Noclip:Disconnect()
	end
	Clip = true
	if LocalPlayer.Character then
		for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
			if v:IsA('BasePart') then
				v.CanCollide = true
			end
		end
	end
end
NoclipToggle = Tabs.Player:Toggle({
	Title = "Noclip",
	Flag = "NoclipToggle",
	Value = Noclip,
	Callback = function(state)
		Noclip = state
		if state then
			noclip()
		else
			clip()
		end
	end
})
IsOnMobile = false
xpcall(function()
	IsOnMobile = table.find({
		Enum.Platform.Android,
		Enum.Platform.IOS
	}, UserInputService:GetPlatform()) ~= nil
end, function()
	IsOnMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end)
if IsOnMobile then
	LocalPlayer:WaitForChild("PlayerGui")
	local touchGui = LocalPlayer.PlayerGui:WaitForChild("TouchGui")
	local touchControlFrame = touchGui:WaitForChild("TouchControlFrame")
	local originalJumpButton = touchControlFrame:WaitForChild("JumpButton")
	local DownWardJumpBtn = nil
	function createDownwardButton()
		if DownWardJumpBtn and DownWardJumpBtn.Parent then
			DownWardJumpBtn:Destroy()
		end
		DownWardJumpBtn = Instance.new("ImageButton")
		DownWardJumpBtn.Name = "DownWardJumpBtn"
		DownWardJumpBtn.Size = originalJumpButton.Size
		DownWardJumpBtn.Image = originalJumpButton.Image
		DownWardJumpBtn.ImageRectOffset = originalJumpButton.ImageRectOffset
		DownWardJumpBtn.ImageRectSize = originalJumpButton.ImageRectSize
		DownWardJumpBtn.BackgroundTransparency = 1
		DownWardJumpBtn.AnchorPoint = Vector2.new(1, 0)
		DownWardJumpBtn.AutoButtonColor = false
		DownWardJumpBtn.Position = UDim2.new(1, 0, originalJumpButton.Position.Y.Scale, originalJumpButton.Position.Y.Offset)
		DownWardJumpBtn.Rotation = 180
		local originalRectOffset = originalJumpButton.ImageRectOffset
		local isHoldingDown = false
		DownWardJumpBtn.MouseButton1Down:Connect(function()
			isHoldingDown = true
			DownWardJumpBtn.ImageRectOffset = Vector2.new(146, 146)
			flyDownPressed = true
		end)
		DownWardJumpBtn.MouseButton1Up:Connect(function()
			if isHoldingDown then
				isHoldingDown = false
				DownWardJumpBtn.ImageRectOffset = originalRectOffset
				flyDownPressed = false
			end
		end)
		DownWardJumpBtn.MouseLeave:Connect(function()
			if isHoldingDown then
				isHoldingDown = false
				DownWardJumpBtn.ImageRectOffset = originalRectOffset
				flyDownPressed = false
			end
		end)
		DownWardJumpBtn.Parent = touchControlFrame
		function preventOverlap()
			if not DownWardJumpBtn or not DownWardJumpBtn.Parent then
				return
			end
			local buttonWidth = DownWardJumpBtn.AbsoluteSize.X
			local originalButton = touchControlFrame:FindFirstChild("JumpButton")
			if originalButton then
				local originalRightEdge = originalButton.AbsolutePosition.X + originalButton.AbsoluteSize.X
				local duplicateLeftEdge = DownWardJumpBtn.AbsolutePosition.X
				local distance = duplicateLeftEdge - originalRightEdge
				if distance < 1 then
					local neededOffset = 1 - distance
					local newXOffset = DownWardJumpBtn.Position.X.Offset - neededOffset
					DownWardJumpBtn.Position = UDim2.new(1, newXOffset, DownWardJumpBtn.Position.Y.Scale, DownWardJumpBtn.Position.Y.Offset)
				elseif distance > 1 then
					local neededOffset = distance - 1
					local newXOffset = DownWardJumpBtn.Position.X.Offset + neededOffset
					DownWardJumpBtn.Position = UDim2.new(1, newXOffset, DownWardJumpBtn.Position.Y.Scale, DownWardJumpBtn.Position.Y.Offset)
				end
			end
		end
		DownWardJumpBtn:GetPropertyChangedSignal("AbsoluteSize"):Connect(preventOverlap)
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(preventOverlap)
		preventOverlap()
	end
	local isHoldingJump = false
	local originalJumpRectOffset = originalJumpButton.ImageRectOffset
	originalJumpButton.MouseButton1Down:Connect(function()
		isHoldingJump = true
		originalJumpButton.ImageRectOffset = Vector2.new(146, 146)
		flyUpPressed = true
	end)
	originalJumpButton.MouseButton1Up:Connect(function()
		if isHoldingJump then
			isHoldingJump = false
			originalJumpButton.ImageRectOffset = originalJumpRectOffset
			flyUpPressed = false
		end
	end)
	originalJumpButton.MouseLeave:Connect(function()
		if isHoldingJump then
			isHoldingJump = false
			originalJumpButton.ImageRectOffset = originalJumpRectOffset
			flyUpPressed = false
		end
	end)
end
FLYING = false
flyspeed = 5
flyKeyDown = nil
flyKeyUp = nil
flyVelocityHandlerName = "FlyVelocity_" .. math.random(1000, 9999)
flyGyroHandlerName = "FlyGyro_" .. math.random(1000, 9999)
mfly1 = nil
mfly2 = nil
flyUpPressed = false
flyDownPressed = false
function getRoot(Humanoid)
	return Character and (Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso"))
end
function unmobilefly(speaker)
	pcall(function()
		FLYING = false
		flyUpPressed = false
		flyDownPressed = false
		root = getRoot(speaker.Character)
		if root then
			bv = root:FindFirstChild(flyVelocityHandlerName)
			bg = root:FindFirstChild(flyGyroHandlerName)
			if bv then
				bv:Destroy()
			end
			if bg then
				bg:Destroy()
			end
		end
		if speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid") then
			speaker.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
		end
		if mfly1 then
			mfly1:Disconnect()
			mfly1 = nil
		end
		if mfly2 then
			mfly2:Disconnect()
			mfly2 = nil
		end
		if DownWardJumpBtn and DownWardJumpBtn.Parent then
			DownWardJumpBtn:Destroy()
			DownWardJumpBtn = nil
		end
	end)
end
function mobilefly(speaker)
	unmobilefly(speaker)
	FLYING = true
	createDownwardButton()
	root = getRoot(speaker.Character)
	if not root then
		return
	end
	camera = workspace.CurrentCamera
	v3none = Vector3.new()
	v3zero = Vector3.new(0, 0, 0)
	v3inf = Vector3.new(9e9, 9e9, 9e9)
	controlModule = nil
	pcall(function()
		controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	end)
	bv = Instance.new("BodyVelocity")
	bv.Name = flyVelocityHandlerName
	bv.Parent = root
	bv.MaxForce = v3zero
	bv.Velocity = v3zero
	bg = Instance.new("BodyGyro")
	bg.Name = flyGyroHandlerName
	bg.Parent = root
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50
	mfly2 = RunService.RenderStepped:Connect(function()
		currentRoot = getRoot(speaker.Character)
		currentCamera = workspace.CurrentCamera
		currentHumanoid = speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid")
		if currentHumanoid and currentRoot and currentRoot:FindFirstChild(flyVelocityHandlerName) and currentRoot:FindFirstChild(flyGyroHandlerName) then
			VelocityHandler = currentRoot:FindFirstChild(flyVelocityHandlerName)
			GyroHandler = currentRoot:FindFirstChild(flyGyroHandlerName)
			VelocityHandler.MaxForce = v3inf
			GyroHandler.MaxTorque = v3inf
			currentHumanoid.PlatformStand = true
			GyroHandler.CFrame = currentCamera.CoordinateFrame
			moveVector = Vector3.new(0, 0, 0)
			if controlModule then
				direction = controlModule:GetMoveVector()
				speed = flyspeed * 50
				moveVector = (currentCamera.CFrame.RightVector * direction.X * speed) + (- currentCamera.CFrame.LookVector * direction.Z * speed)
			end
			if flyUpPressed then
				moveVector = moveVector + Vector3.new(0, flyspeed * 50, 0)
			end
			if flyDownPressed then
				moveVector = moveVector - Vector3.new(0, flyspeed * 50, 0)
			end
			VelocityHandler.Velocity = moveVector
		end
	end)
end
function pcfly()
	plr = Players.LocalPlayer
	char = plr.Character or plr.CharacterAdded:Wait()
	Humanoid = char:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		repeat
			task.wait()
		until char:FindFirstChildOfClass("Humanoid")
		Humanoid = char:FindFirstChildOfClass("Humanoid")
	end
	if flyKeyDown or flyKeyUp then
		flyKeyDown:Disconnect()
		flyKeyUp:Disconnect()
	end
	T = getRoot(char)
	if not T then
		return
	end
	WPressed = false
	SPressed = false
	APressed = false
	DPressed = false
	SpacePressed = false
	CtrlPressed = false
	function FLY()
		FLYING = true
		BG = Instance.new('BodyGyro')
		BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.CFrame = T.CFrame
		BV.Velocity = Vector3.new(0, 0, 0)
		BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			while FLYING do
				task.wait()
				camera = workspace.CurrentCamera
				Humanoid.PlatformStand = true
				moveDirection = Vector3.new(0, 0, 0)
				if WPressed then
					moveDirection = moveDirection + camera.CFrame.LookVector * flyspeed
				end
				if SPressed then
					moveDirection = moveDirection - camera.CFrame.LookVector * flyspeed
				end
				if APressed then
					moveDirection = moveDirection - camera.CFrame.RightVector * flyspeed
				end
				if DPressed then
					moveDirection = moveDirection + camera.CFrame.RightVector * flyspeed
				end
				if SpacePressed then
					moveDirection = moveDirection + Vector3.new(0, flyspeed * 2, 0)
				end
				if CtrlPressed then
					moveDirection = moveDirection - Vector3.new(0, flyspeed * 2, 0)
				end
				BV.Velocity = moveDirection * 16
				BG.CFrame = camera.CFrame
			end
			BG:Destroy()
			BV:Destroy()
			if Humanoid then
				Humanoid.PlatformStand = false
			end
		end)
	end
	flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end
		if input.KeyCode == Enum.KeyCode.W then
			WPressed = true
		elseif input.KeyCode == Enum.KeyCode.S then
			SPressed = true
		elseif input.KeyCode == Enum.KeyCode.A then
			APressed = true
		elseif input.KeyCode == Enum.KeyCode.D then
			DPressed = true
		elseif input.KeyCode == Enum.KeyCode.Space then
			SpacePressed = true
		elseif input.KeyCode == Enum.KeyCode.LeftControl then
			CtrlPressed = true
		end
		pcall(function()
			workspace.CurrentCamera.CameraType = Enum.CameraType.Track
		end)
	end)
	flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
		if processed then
			return
		end
		if input.KeyCode == Enum.KeyCode.W then
			WPressed = false
		elseif input.KeyCode == Enum.KeyCode.S then
			SPressed = false
		elseif input.KeyCode == Enum.KeyCode.A then
			APressed = false
		elseif input.KeyCode == Enum.KeyCode.D then
			DPressed = false
		elseif input.KeyCode == Enum.KeyCode.Space then
			SpacePressed = false
		elseif input.KeyCode == Enum.KeyCode.LeftControl then
			CtrlPressed = false
		end
	end)
	FLY()
end
function NOFLY()
	FLYING = false
	flyUpPressed = false
	flyDownPressed = false
	if flyKeyDown then
		flyKeyDown:Disconnect()
		flyKeyDown = nil
	end
	if flyKeyUp then
		flyKeyUp:Disconnect()
		flyKeyUp = nil
	end
	if IsOnMobile then
		unmobilefly(Players.LocalPlayer)
	else
		if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
			Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
		end
		root = getRoot(Players.LocalPlayer.Character)
		if root then
			root.Velocity = Vector3.new(0, 0, 0)
		end
	end
	pcall(function()
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	end)
end
function onCharacterAdded()
	if FlyToggle and FlyToggle.Value then
		task.wait(1)
		if IsOnMobile then
			mobilefly(Players.LocalPlayer)
		else
			pcfly()
		end
	end
end
Players.LocalPlayer.CharacterAdded:Connect(function()
	NOFLY()
	onCharacterAdded()
end)
Tabs.Player:Space()
FlyToggle = Tabs.Player:Toggle({
	Title = "Fly",
	Flag = "FlyToggle",
	Value = false,
	Callback = function(state)
		if state then
			if IsOnMobile then
				mobilefly(Players.LocalPlayer)
			else
				pcfly()
			end
		else
			NOFLY()
		end
	end
})
FlySpeedInput = Tabs.Player:Input({
	Title = "Fly Speed",
	Flag = "FlySpeedInput",
	Placeholder = "Enter speed value",
	Value = tostring(flyspeed),
	NumbersOnly = true,
	Callback = function(value)
		speed = tonumber(value)
		if speed and speed > 0 then
			flyspeed = speed
		end
	end
})
ShowFlyButtonToggle = Tabs.Player:Toggle({
	Title = "Fly Button",
	Flag = "ShowFlyButton",
	Value = false,
	Callback = function(state)
		IY = IY or {}
		IY.FlightBtn = state
		if ButtonLib and ButtonLib.Flight then
			ButtonLib.Flight:SetVisible(state)
		end
	end
})
ButtonLib.Create:Toggle({
	Text = "Flight",
	Flag = "Flight",
	Default = false,
	Visible = false,
	Callback = function(s)
		if FlyToggle then
			FlyToggle:Set(s)
		end
	end
}).Position = UDim2.new(0.5, - 125, 0.4, 0)
Tabs.Player:Space()
ToggleTpwalk = false
TpwalkConnection = nil
function Tpwalking()
	if ToggleTpwalk and Character and Humanoid and rootPart then
		moveDirection = Humanoid.MoveDirection
		moveDistance = TpwalkValue
		origin = rootPart.Position
		direction = moveDirection * moveDistance
		targetPosition = origin + direction
		raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {
			Character
		}
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastResult = workspace:Raycast(origin, direction, raycastParams)
		if raycastResult then
			hitPosition = raycastResult.Position
			distanceToHit = (hitPosition - origin).Magnitude
			if distanceToHit < math.abs(moveDistance) then
				targetPosition = origin + (direction.Unit * (distanceToHit - 0.1))
			end
		end
		rootPart.CFrame = CFrame.new(targetPosition) * rootPart.CFrame.Rotation
		rootPart.CanCollide = true
	end
end
function startTpwalk()
	ToggleTpwalk = true
	if TpwalkConnection then
		TpwalkConnection:Disconnect()
	end
	TpwalkConnection = RunService.Heartbeat:Connect(Tpwalking)
end
function stopTpwalk()
	ToggleTpwalk = false
	if TpwalkConnection then
		TpwalkConnection:Disconnect()
		TpwalkConnection = nil
	end
	if rootPart then
		rootPart.CanCollide = false
	end
end
TPWALKToggle = Tabs.Player:Toggle({
	Title = "TP WALK",
	Flag = "TPWALKToggle",
	Value = TPWALK,
	Callback = function(state)
		TPWALK = state
		if state then
			startTpwalk()
		else
			stopTpwalk()
		end
	end
})
TPWALKSlider = Tabs.Player:Slider({
	Title = "TPWALK VALUE",
	Flag = "TPWALKSlider",
	Desc = "Adjust TPWALK speed",
	Value = {
		Min = 1,
		Max = 200,
		Default = TpwalkValue,
		Step = 1
	},
	Callback = function(value)
		TpwalkValue = value
	end
})
Tabs.Player:Space()
jumpCount = 0
MAX_JUMPS = math.huge
function setupJumpBoost()
	if not Character or not Humanoid then
		return
	end
	Humanoid.StateChanged:Connect(function(oldState, newState)
		if newState == Enum.HumanoidStateType.Landed then
			jumpCount = 0
		end
	end)
	Humanoid.Jumping:Connect(function(isJumping)
		if isJumping and JumpBoost and jumpCount < MAX_JUMPS then
			jumpCount = jumpCount + 1
			Humanoid.JumpHeight = JumpPower
			if jumpCount > 1 then
				rootPart:ApplyImpulse(Vector3.new(0, JumpPower * rootPart.Mass, 0))
			end
		end
	end)
end
function startJumpBoost()
	if Humanoid then
		Humanoid.JumpPower = JumpPower
		Humanoid.JumpHeight = JumpPower
	end
	setupJumpBoost()
end
function stopJumpBoost()
	jumpCount = 0
	if Humanoid then
		Humanoid.JumpPower = 50
		Humanoid.JumpHeight = 50
	end
end
JumpBoostToggle = Tabs.Player:Toggle({
	Title = "Jump Height",
	Flag = "JumpBoostToggle",
	Value = JumpBoost,
	Callback = function(state)
		JumpBoost = state
		if state then
			startJumpBoost()
		else
			stopJumpBoost()
		end
	end
})
JumpBoostSlider = Tabs.Player:Slider({
	Title = "Jump Power",
	Flag = "JumpBoostSlider",
	Desc = "Adjust jump height",
	Value = {
		Min = 1,
		Max = 200,
		Default = JumpPower,
		Step = 1
	},
	Callback = function(value)
		JumpPower = value
		if JumpBoost then
			if Humanoid then
				Humanoid.JumpPower = JumpPower
				Humanoid.JumpHeight = JumpPower
			end
		end
	end
})
Tabs.Player:Space()
Tabs.Player:Button({
	Title = "Force Reset Character",
	Callback = function()
		ShowErrorPrompt({
			Title = "Reset Character",
			Message = [[Are you sure you want to Reset Character? Press ''Reset'' to continue]],
			Buttons = {
				{
					Text = "Cancel",
					Type = "Secondary",
					Stroke = true,
				},
				{
					Text = "Reset",
					Type = "Primary",
					WaitTimeClick = 5,
					Callback = function()
						local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
						if hum then
							hum.Health = 0
						end
					end
				},
			}
		})
	end
})
Tabs.Garden:Section({
	Title = "Auto Plant",
	TextSize = 20
})
AutoPlantEnabled = false
AutoPlantTask = nil
AutoPlantSelectedSeeds = {}
AutoPlantBlacklistedSeeds = {}
AutoPlantMode = "Random"
AutoPlantEquipSeed = true
AutoPlantDelay = 0.1
GameEvents = ReplicatedStorage.GameEvents
Plant_RE = GameEvents.Plant_RE
seedDataModule = ReplicatedStorage:WaitForChild("Data"):WaitForChild("SeedData")
function LoadSeedNames()
	local dropdownItems = {}
	local success, seedData = pcall(require, seedDataModule)
	if success then
		local seedsList = {}
		for seedName, seedInfo in pairs(seedData) do
			if seedInfo.SeedName and not string.find(seedName:lower(), "pack") then
				local rarity = seedInfo.SeedRarity or "Unknown"
				table.insert(seedsList, {
					Name = seedName,
					DisplayName = seedInfo.SeedName,
					Icon = seedInfo.FruitIcon or seedInfo.Asset or "",
					Rarity = rarity
				})
			end
		end
		table.sort(seedsList, function(a, b)
			return a.DisplayName < b.DisplayName
		end)
		for _, seed in ipairs(seedsList) do
			table.insert(dropdownItems, {
				Title = seed.DisplayName,
				Desc = "Rarity: " .. seed.Rarity,
				Icon = seed.Icon,
				Value = seed.Name,
				Data = {
					Name = seed.Name,
					DisplayName = seed.DisplayName,
					Rarity = seed.Rarity
				}
			})
		end
	end
	return dropdownItems
end
function GetEquippedSeed()
	if # AutoPlantSelectedSeeds > 0 then
		for _, container in ipairs({
			Character,
			Backpack
		}) do
			for _, tool in ipairs(container:GetChildren()) do
				if tool:IsA("Tool") then
					local itemType = tool:GetAttribute("ItemType")
					local seedName = tool:GetAttribute("ItemName") or tool:GetAttribute("Seed") or tool.Name
					if (itemType and itemType == "Seed") or (tool.Name:find("Seed") and not tool.Name:find("Pack")) then
						for _, selected in ipairs(AutoPlantSelectedSeeds) do
							if seedName == selected then
								return tool, seedName
							end
						end
					end
				end
			end
		end
	else
		for _, container in ipairs({
			Character,
			Backpack
		}) do
			for _, tool in ipairs(container:GetChildren()) do
				if tool:IsA("Tool") then
					local itemType = tool:GetAttribute("ItemType")
					local seedName = tool:GetAttribute("ItemName") or tool:GetAttribute("Seed") or tool.Name
					if (itemType and itemType == "Seed") or (tool.Name:find("Seed") and not tool.Name:find("Pack")) then
						if # AutoPlantBlacklistedSeeds == 0 or not table.find(AutoPlantBlacklistedSeeds, seedName) then
							return tool, seedName
						end
					end
				end
			end
		end
	end
	return nil, nil
end
function EquipSeed(tool)
	if tool and AutoPlantEquipSeed then
		local humanoid = Character:FindFirstChildOfClass("Humanoid")
		if humanoid and tool.Parent == Backpack then
			humanoid:EquipTool(tool)
			task.wait(0.1)
		end
	end
end
function GetPlantingPosition()
	if not Character then
		return Vector3.new(0, 4, 0)
	end
	if AutoPlantMode == "Under LocalPlayer" then
		local hrp = Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			return hrp.Position + Vector3.new(0, - 2, 0)
		end
		return Vector3.new(0, 4, 0)
	else
		local hrp = Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local basePos = hrp.Position
			local offsetX = math.random(- 20, 20)
			local offsetZ = math.random(- 20, 20)
			return basePos + Vector3.new(offsetX, - 2, offsetZ)
		end
		return Vector3.new(math.random(- 50, 50), 4, math.random(- 50, 50))
	end
end
function PlantSeed()
	if not Plant_RE then
		return false
	end
	local tool, seedName = GetEquippedSeed()
	if not tool then
		return false
	end
	EquipSeed(tool)
	local position = GetPlantingPosition()
	local success = pcall(function()
		Plant_RE:FireServer(position, seedName)
	end)
	return success
end
function StartAutoPlant()
	AutoPlantTask = task.spawn(function()
		while AutoPlantEnabled do
			PlantSeed()
			task.wait(AutoPlantDelay)
			for i = 1, 5 do
				if not AutoPlantEnabled then
					break
				end
				PlantSeed()
			end
			task.wait(0.05)
		end
	end)
end
AutoPlantWhitelistDropdown = Tabs.Garden:Dropdown({
	Title = "Select Seed (Whitelist)",
	Values = {
		{
			Title = "Click Refresh Whitelist",
			Icon = "refresh-cw"
		}
	},
	Value = {},
	Multi = true,
	AllowNone = true,
	SearchBarEnabled = true,
	Callback = function(options)
		AutoPlantSelectedSeeds = {}
		for _, option in ipairs(options) do
			if option.Value then
				table.insert(AutoPlantSelectedSeeds, option.Value)
			end
		end
	end
})
Tabs.Garden:Button({
	Title = "Refresh Whitelist",
	Icon = "refresh-cw",
	Callback = function()
		local items = LoadSeedNames()
		if # items > 0 then
			AutoPlantWhitelistDropdown:Refresh(items, {})
		else
			AutoPlantWhitelistDropdown:Refresh({
				{
					Title = "Failed to load",
					Icon = "x-circle"
				}
			})
		end
	end
})
AutoPlantBlacklistDropdown = Tabs.Garden:Dropdown({
	Title = "Blacklist Seeds",
	Values = {
		{
			Title = "Click Refresh Blacklist",
			Icon = "refresh-cw"
		}
	},
	Value = {},
	Multi = true,
	AllowNone = true,
	SearchBarEnabled = true,
	Callback = function(options)
		AutoPlantBlacklistedSeeds = {}
		for _, option in ipairs(options) do
			if option.Value then
				table.insert(AutoPlantBlacklistedSeeds, option.Value)
			end
		end
	end
})
Tabs.Garden:Button({
	Title = "Refresh Blacklist",
	Icon = "refresh-cw",
	Callback = function()
		local items = LoadSeedNames()
		if # items > 0 then
			AutoPlantBlacklistDropdown:Refresh(items, {})
		else
			AutoPlantBlacklistDropdown:Refresh({
				{
					Title = "Failed to load",
					Icon = "x-circle"
				}
			})
		end
	end
})
AutoPlantModeDropdown = Tabs.Garden:Dropdown({
	Title = "Select Mode",
	Values = {
		{
			Title = "Random",
			Icon = "shuffle",
			Value = "Random"
		},
		{
			Title = "Under LocalPlayer",
			Icon = "user",
			Value = "Under LocalPlayer"
		}
	},
	Value = {
		Title = "Random",
		Icon = "shuffle",
		Value = "Random"
	},
	Callback = function(option)
		AutoPlantMode = option.Value
	end
})
AutoPlantEquipToggle = Tabs.Garden:Toggle({
	Title = "Auto Equip Seed",
	Value = true,
	Callback = function(state)
		AutoPlantEquipSeed = state
	end
})
AutoPlantToggle = Tabs.Garden:Toggle({
	Title = "Auto Plant",
	Value = false,
	Callback = function(state)
		AutoPlantEnabled = state
		if state then
			StartAutoPlant()
		elseif AutoPlantTask then
			task.cancel(AutoPlantTask)
			AutoPlantTask = nil
		end
	end
})
AutoPlantDelaySlider = Tabs.Garden:Slider({
	Title = "Auto plant Delay",
	Step = 0.001,
	Value = {
		Min = 0.001,
		Max = 2,
		Default = 0.1
	},
	Callback = function(value)
		AutoPlantDelay = value
	end
})
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
fruitAuraEnabled = false
fruitAuraDelay = 0.01
fruitAuraRange = 1
fruitAuraThread = nil
fruitAuraConnection = nil
fruitAuraTimer = 0
PickupSoundEvent = ReplicatedStorage.GameEvents:FindFirstChild("PickupSound") or ReplicatedStorage.GameEvents:FindFirstChild("PickupEvent")
fruitWhitelist = {}
fruitBlacklist = {}
mutationWhitelist = {}
mutationBlacklist = {}
variantWhitelist = {}
variantBlacklist = {}
fruitWhitelistNormalized = {}
fruitBlacklistNormalized = {}
mutationWhitelistNormalized = {}
mutationBlacklistNormalized = {}
variantWhitelistNormalized = {}
variantBlacklistNormalized = {}
myFarmPlotsCache = {}
lastFarmUpdate = 0
farmCacheTTL = 5
fruitLimit = 30
weightFilterEnabled = false
minWeight = 0
maxWeight = 999999
maxBackpackCapacity = 0
CalculatePlantValue = require(ReplicatedStorage.Modules.CalculatePlantValue)
valueFilterEnabled = false
minValue = 0
maxValue = 999999999
fruitValueCache = {}
valueCacheTTL = 3
variantFilterEnabled = false
MutationHandler = require(ReplicatedStorage.Modules.MutationHandler)
SeedData = require(ReplicatedStorage.Data.SeedData)
local function getMaxBackpackCapacity()
	return math.ceil(200 + (LocalPlayer:GetAttribute("BonusBackpackSize") or 0))
end
maxBackpackCapacity = getMaxBackpackCapacity()
local function isBackpackFull()
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	if not backpack then
		return false
	end
	local fruitCount = 0
	for _, tool in pairs(backpack:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Item_Seed") then
			fruitCount = fruitCount + 1
		end
	end
	return fruitCount >= maxBackpackCapacity
end
local function getAvailableSpace()
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	if not backpack then
		return maxBackpackCapacity
	end
	local fruitCount = 0
	for _, tool in pairs(backpack:GetChildren()) do
		if tool:IsA("Tool") and tool:FindFirstChild("Item_Seed") then
			fruitCount = fruitCount + 1
		end
	end
	return math.max(0, maxBackpackCapacity - fruitCount)
end
local function getMaxFruitsToCollect()
	local availableSpace = getAvailableSpace()
	return math.min(fruitLimit, availableSpace)
end
function GetmutationsData()
	local data = {}
	local mutations = MutationHandler:GetMutations()
	for _, mutation in pairs(mutations) do
		if mutation.Name then
			table.insert(data, mutation.Name)
		end
	end
	table.sort(data)
	return data
end
function GetcropsData()
	local data = {}
	for fruitName, fruitInfo in pairs(SeedData) do
		table.insert(data, {
			Title = fruitName,
			Desc = "Rarity: " .. (fruitInfo.SeedRarity or "Unknown"),
			Icon = fruitInfo.FruitIcon or fruitInfo.Asset or "rbxassetid://132438947521974"
		})
	end
	table.sort(data, function(a, b)
		return a.Title < b.Title
	end)
	return data
end
function GetvariantData()
	local variantEnums = require(ReplicatedStorage.Data.EnumRegistry.VariantsEnums)
	local data = {}
	if type(variantEnums) == "table" then
		for variantName, _ in pairs(variantEnums) do
			if type(variantName) == "string" then
				table.insert(data, variantName)
			end
		end
	end
	table.sort(data)
	return data
end
function updateWhitelistNormalized()
	fruitWhitelistNormalized = {}
	for _, fruitData in pairs(fruitWhitelist) do
		local fruitName = fruitData.Title or fruitData
		if type(fruitName) == "string" then
			fruitWhitelistNormalized[fruitName:lower()] = true
		end
	end
	fruitBlacklistNormalized = {}
	for _, fruitData in pairs(fruitBlacklist) do
		local fruitName = fruitData.Title or fruitData
		if type(fruitName) == "string" then
			fruitBlacklistNormalized[fruitName:lower()] = true
		end
	end
	mutationWhitelistNormalized = {}
	for _, mutationData in pairs(mutationWhitelist) do
		local mutationName = mutationData.Title or mutationData
		if type(mutationName) == "string" then
			mutationWhitelistNormalized[mutationName:lower()] = true
		end
	end
	mutationBlacklistNormalized = {}
	for _, mutationData in pairs(mutationBlacklist) do
		local mutationName = mutationData.Title or mutationData
		if type(mutationName) == "string" then
			mutationBlacklistNormalized[mutationName:lower()] = true
		end
	end
	variantWhitelistNormalized = {}
	for _, variantData in pairs(variantWhitelist) do
		local variantName = variantData.Title or variantData
		if type(variantName) == "string" then
			variantWhitelistNormalized[variantName:lower()] = true
		end
	end
	variantBlacklistNormalized = {}
	for _, variantData in pairs(variantBlacklist) do
		local variantName = variantData.Title or variantData
		if type(variantName) == "string" then
			variantBlacklistNormalized[variantName:lower()] = true
		end
	end
end
function getMyFarmPlots()
	local now = tick()
	if now - lastFarmUpdate < farmCacheTTL and # myFarmPlotsCache > 0 then
		return myFarmPlotsCache
	end
	local myUsername = LocalPlayer.Name
	local myPlots = {}
	local farmFolder = Workspace:FindFirstChild("Farm")
	if farmFolder then
		for _, plot in pairs(farmFolder:GetChildren()) do
			local sign = plot:FindFirstChild("Sign")
			if sign then
				local owner = sign:GetAttribute("_owner")
				if owner and owner == myUsername then
					table.insert(myPlots, plot)
				end
			end
		end
	end
	myFarmPlotsCache = myPlots
	lastFarmUpdate = now
	return myPlots
end
function playCollectSound()
	if PickupSoundEvent then
		task.spawn(function()
			pcall(function()
				FireClient(PickupSoundEvent, "Collect")
			end)
		end)
	end
end
mutationCache = {}
function checkMutation(fruitObj)
	local fruitId = fruitObj:GetFullName()
	if mutationCache[fruitId] then
		return mutationCache[fruitId]
	end
	local mutation = nil
	for attrName, attrValue in pairs(fruitObj:GetAttributes()) do
		if type(attrValue) == "boolean" and attrValue == true then
			local attrLower = attrName:lower()
			if # mutationWhitelist > 0 and mutationWhitelistNormalized[attrLower] then
				mutation = attrName
				break
			end
			if # mutationBlacklist > 0 and mutationBlacklistNormalized[attrLower] then
				mutation = nil
				break
			end
			if # mutationWhitelist == 0 and # mutationBlacklist == 0 then
				mutation = attrName
				break
			end
		end
	end
	if not mutation then
		local current = fruitObj.Parent
		while current and current ~= Workspace do
			if current.Name == "Fruits" then
				local plant = current.Parent
				if plant and plant:IsA("Model") then
					for attrName, attrValue in pairs(plant:GetAttributes()) do
						if type(attrValue) == "boolean" and attrValue == true then
							local attrLower = attrName:lower()
							if # mutationWhitelist > 0 and mutationWhitelistNormalized[attrLower] then
								mutation = attrName
								break
							end
							if # mutationBlacklist > 0 and mutationBlacklistNormalized[attrLower] then
								mutation = nil
								break
							end
							if # mutationWhitelist == 0 and # mutationBlacklist == 0 then
								mutation = attrName
								break
							end
						end
					end
				end
				break
			end
			current = current.Parent
		end
	end
	mutationCache[fruitId] = mutation
	if # mutationCache > 100 then
		local newCache = {}
		local i = 1
		for k, v in pairs(mutationCache) do
			newCache[k] = v
			i = i + 1
			if i > 50 then
				break
			end
		end
		mutationCache = newCache
	end
	return mutation
end
function checkVariant(fruitObj)
	if not fruitObj then
		return nil
	end
	local variant = fruitObj:FindFirstChild("Variant")
	if variant and variant:IsA("StringValue") and variant.Value ~= "" then
		return variant.Value
	end
	local variantAttr = fruitObj:GetAttribute("Variant")
	if variantAttr and variantAttr ~= "" then
		return tostring(variantAttr)
	end
	local parent = fruitObj.Parent
	if parent then
		local parentVariant = parent:FindFirstChild("Variant")
		if parentVariant and parentVariant:IsA("StringValue") and parentVariant.Value ~= "" then
			return parentVariant.Value
		end
		local parentVariantAttr = parent:GetAttribute("Variant")
		if parentVariantAttr and parentVariantAttr ~= "" then
			return tostring(parentVariantAttr)
		end
		local grandParent = parent.Parent
		if grandParent then
			local grandVariant = grandParent:FindFirstChild("Variant")
			if grandVariant and grandVariant:IsA("StringValue") and grandVariant.Value ~= "" then
				return grandVariant.Value
			end
			local grandVariantAttr = grandParent:GetAttribute("Variant")
			if grandVariantAttr and grandVariantAttr ~= "" then
				return tostring(grandVariantAttr)
			end
		end
	end
	return nil
end
function getFruitWeight(fruitObj)
	local weightAttr = fruitObj:GetAttribute("Weight")
	if weightAttr then
		return tonumber(weightAttr)
	end
	local weightObj = fruitObj:FindFirstChild("Weight")
	if weightObj then
		if weightObj:IsA("NumberValue") or weightObj:IsA("IntValue") then
			return weightObj.Value
		elseif weightObj:IsA("StringValue") then
			return tonumber(weightObj.Value)
		end
	end
	local parent = fruitObj.Parent
	if parent then
		local parentWeightAttr = parent:GetAttribute("Weight")
		if parentWeightAttr then
			return tonumber(parentWeightAttr)
		end
	end
	return nil
end
function getFruitValue(fruitObj)
	local fruitId = fruitObj:GetFullName()
	local now = tick()
	if fruitValueCache[fruitId] and now - fruitValueCache[fruitId].timestamp < valueCacheTTL then
		return fruitValueCache[fruitId].value
	end
	local success, value = pcall(function()
		return CalculatePlantValue(fruitObj)
	end)
	if success and value and type(value) == "number" and value > 0 then
		fruitValueCache[fruitId] = {
			value = value,
			timestamp = now
		}
		if # fruitValueCache > 200 then
			local newCache = {}
			local count = 0
			for k, v in pairs(fruitValueCache) do
				if count < 100 then
					newCache[k] = v
					count = count + 1
				else
					break
				end
			end
			fruitValueCache = newCache
		end
		return value
	end
	return nil
end
function isWhitelisted(fruitObj)
	local fruitName = fruitObj.Name
	local fruitNameLower = fruitName:lower()
	if # fruitWhitelist > 0 and not fruitWhitelistNormalized[fruitNameLower] then
		return false
	end
	if # fruitBlacklist > 0 and fruitBlacklistNormalized[fruitNameLower] then
		return false
	end
	if # mutationWhitelist > 0 or # mutationBlacklist > 0 then
		local mutation = checkMutation(fruitObj)
		if # mutationWhitelist > 0 then
			if not mutation or not mutationWhitelistNormalized[mutation:lower()] then
				return false
			end
		end
		if # mutationBlacklist > 0 then
			if mutation and mutationBlacklistNormalized[mutation:lower()] then
				return false
			end
		end
	end
	if variantFilterEnabled then
		if # variantWhitelist > 0 or # variantBlacklist > 0 then
			local variant = checkVariant(fruitObj)
			if # variantWhitelist > 0 then
				if not variant or not variantWhitelistNormalized[variant:lower()] then
					return false
				end
			end
			if # variantBlacklist > 0 then
				if variant and variantBlacklistNormalized[variant:lower()] then
					return false
				end
			end
		end
	end
	if weightFilterEnabled then
		local weight = getFruitWeight(fruitObj)
		if weight then
			if weight < minWeight or weight > maxWeight then
				return false
			end
		else
			return false
		end
	end
	if valueFilterEnabled then
		local value = getFruitValue(fruitObj)
		if value then
			if value < minValue or value > maxValue then
				return false
			end
		else
			return false
		end
	end
	return true
end
function collectFromPlots(plots)
	if isBackpackFull() then
		return false
	end
	local character = LocalPlayer.Character
	if not character then
		return false
	end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return false
	end
	local hrpPos = hrp.Position
	local allCollectables = {}
	local collectedCount = 0
	local maxToCollect = getMaxFruitsToCollect()
	if maxToCollect <= 0 then
		return false
	end
	for _, plot in pairs(plots) do
		local descendants = plot:GetDescendants()
		for i = 1, # descendants do
			local obj = descendants[i]
			if obj:IsA("ProximityPrompt") and obj:HasTag("CollectPrompt") then
				if obj.Enabled == false then
					continue
				end
				local parent = obj.Parent
				if parent then
					local objPart = parent:IsA("BasePart") and parent or parent:FindFirstChildWhichIsA("BasePart")
					if objPart then
						local distance = (hrpPos - objPart.Position).Magnitude
						if distance > fruitAuraRange then
							continue
						end
					end
					local grandParent = parent.Parent
					if grandParent and isWhitelisted(grandParent) then
						if collectedCount >= maxToCollect then
							break
						end
						fireproximityprompt(obj, 0)
						parent:SetAttribute("Collected", true)
						table.insert(allCollectables, grandParent)
						collectedCount = collectedCount + 1
					end
				end
			end
		end
		if collectedCount >= maxToCollect then
			break
		end
	end
	if # allCollectables > 0 then
		task.delay(1, function()
			for _, collectable in pairs(allCollectables) do
				local parent = collectable.Parent
				if parent then
					parent:SetAttribute("Collected", nil)
				end
			end
		end)
		task.spawn(function()
			pcall(function()
				ReplicatedStorage.GameEvents.Crops.Collect:FireServer(allCollectables)
			end)
		end)
		return true
	end
	return false
end
function startFruitAura()
	if fruitAuraConnection then
		fruitAuraConnection:Disconnect()
		fruitAuraConnection = nil
	end
	if fruitAuraThread then
		task.cancel(fruitAuraThread)
		fruitAuraThread = nil
	end
	mutationCache = {}
	fruitValueCache = {}
	myFarmPlotsCache = {}
	fruitAuraTimer = 0
	fruitAuraConnection = RunService.Heartbeat:Connect(function(deltaTime)
		if not fruitAuraEnabled then
			return
		end
		fruitAuraTimer = fruitAuraTimer + deltaTime
		if fruitAuraTimer >= fruitAuraDelay then
			fruitAuraTimer = 0
			if not isBackpackFull() then
				local myPlots = getMyFarmPlots()
				if # myPlots > 0 then
					collectFromPlots(myPlots)
				end
			end
		end
	end)
end
function stopFruitAura()
	if fruitAuraConnection then
		fruitAuraConnection:Disconnect()
		fruitAuraConnection = nil
	end
	if fruitAuraThread then
		task.cancel(fruitAuraThread)
		fruitAuraThread = nil
	end
	fruitAuraTimer = 0
end
Tabs.Garden:Section({
	Title = "Fruit Aura",
	TextSize = 20
})
fruitAuraToggle = Tabs.Garden:Toggle({
	Title = "Enable Fruit Aura",
	Flag = "fruitAuraToggle",
	Value = fruitAuraEnabled,
	Callback = function(state)
		fruitAuraEnabled = state
		if fruitAuraEnabled then
			startFruitAura()
		else
			stopFruitAura()
		end
	end
})
FruitAuraDelay = Tabs.Garden:Slider({
	Title = "Collection Delay",
	Flag = "FruitAuraDelay",
	Step = 0.01,
	Value = {
		Min = 0.01,
		Max = 2,
		Default = fruitAuraDelay
	},
	Callback = function(value)
		fruitAuraDelay = value
	end
})
fruitAuraRangeSlider = Tabs.Garden:Slider({
	Title = "Aura Range",
	Flag = "FruitAuraRange",
	Step = 0.1,
	Value = {
		Min = 1,
		Max = 500,
		Default = fruitAuraRange
	},
	Callback = function(value)
		fruitAuraRange = value
	end
})
Tabs.Garden:Slider({
	Title = "Fruit Limit",
	Desc = "Auto-limited by available backpack space",
	Flag = "FruitAuraLimit",
	Step = 1,
	Value = {
		Min = 1,
		Max = maxBackpackCapacity,
		Default = fruitLimit
	},
	Callback = function(value)
		fruitLimit = value
	end
})
Tabs.Garden:Section({
	Title = "Fruit Whitelist",
	TextSize = 16
})
FruitDropdown = Tabs.Garden:Dropdown({
	Title = "Fruit Whitelist",
	Values = {
		"Click refresh to load fruits"
	},
	Multi = true,
	AllowNone = true,
	SearchBarEnabled = true,
	SearchPlaceholder = "Search fruits...",
	Callback = function(selected)
		fruitWhitelist = selected
		updateWhitelistNormalized()
	end
})
Tabs.Garden:Button({
	Title = "Refresh Fruits",
	Callback = function()
		local crops = GetcropsData()
		if # crops > 0 then
			FruitDropdown:Refresh(crops)
		end
	end
})
Tabs.Garden:Section({
	Title = "Fruit Blacklist",
	TextSize = 16
})
FruitBlacklistDropdown = Tabs.Garden:Dropdown({
	Title = "Fruit Blacklist",
	Values = {
		"Click refresh to load fruits"
	},
	Multi = true,
	AllowNone = true,
	SearchBarEnabled = true,
	SearchPlaceholder = "Search fruits to blacklist...",
	Callback = function(selected)
		fruitBlacklist = selected
		updateWhitelistNormalized()
	end
})
Tabs.Garden:Button({
	Title = "Refresh Fruits",
	Callback = function()
		local crops = GetcropsData()
		if # crops > 0 then
			FruitBlacklistDropdown:Refresh(crops)
		end
	end
})
Tabs.Garden:Section({
	Title = "Mutation Whitelist",
	TextSize = 16
})
MutationDropdown = Tabs.Garden:Dropdown({
	Title = "Mutation Whitelist",
	Values = {
		"Click refresh to load mutations"
	},
	Multi = true,
	AllowNone = true,
	SearchBarEnabled = true,
	SearchPlaceholder = "Search mutations...",
	Callback = function(selected)
		mutationWhitelist = selected
		updateWhitelistNormalized()
	end
})
Tabs.Garden:Button({
	Title = "Refresh Mutations",
	Callback = function()
		local mutations = GetmutationsData()
		if # mutations > 0 then
			MutationDropdown:Refresh(mutations)
		end
	end
})
Tabs.Garden:Section({
	Title = "Mutation Blacklist",
	TextSize = 16
})
MutationBlacklistDropdown = Tabs.Garden:Dropdown({
	Title = "Mutation Blacklist",
	Values = {
		"Click refresh to load mutations"
	},
	Multi = true,
	AllowNone = true,
	SearchBarEnabled = true,
	SearchPlaceholder = "Search mutations to blacklist...",
	Callback = function(selected)
		mutationBlacklist = selected
		updateWhitelistNormalized()
	end
})
Tabs.Garden:Button({
	Title = "Refresh Mutations",
	Callback = function()
		local mutations = GetmutationsData()
		if # mutations > 0 then
			MutationBlacklistDropdown:Refresh(mutations)
		end
	end
})
Tabs.Garden:Toggle({
	Title = "Enable Variant Filter",
	Flag = "VariantFilterToggle",
	Value = variantFilterEnabled,
	Callback = function(state)
		variantFilterEnabled = state
	end
})
Tabs.Garden:Section({
	Title = "Variant Whitelist",
	TextSize = 16
})
VariantDropdown = Tabs.Garden:Dropdown({
	Title = "Variant Whitelist",
	Values = {
		"Click refresh to load variants"
	},
	Multi = true,
	AllowNone = true,
	SearchBarEnabled = true,
	SearchPlaceholder = "Search variants...",
	Callback = function(selected)
		variantWhitelist = selected
		updateWhitelistNormalized()
	end
})
Tabs.Garden:Button({
	Title = "Refresh Variants",
	Callback = function()
		local variants = GetvariantData()
		if # variants > 0 then
			VariantDropdown:Refresh(variants)
		end
	end
})
Tabs.Garden:Section({
	Title = "Variant Blacklist",
	TextSize = 16
})
VariantBlacklistDropdown = Tabs.Garden:Dropdown({
	Title = "Variant Blacklist",
	Values = {
		"Click refresh to load variants"
	},
	Multi = true,
	AllowNone = true,
	SearchBarEnabled = true,
	SearchPlaceholder = "Search variants to blacklist...",
	Callback = function(selected)
		variantBlacklist = selected
		updateWhitelistNormalized()
	end
})
Tabs.Garden:Button({
	Title = "Refresh Variants",
	Callback = function()
		local variants = GetvariantData()
		if # variants > 0 then
			VariantBlacklistDropdown:Refresh(variants)
		end
	end
})
Tabs.Garden:Section({
	Title = "Weight Filter",
	TextSize = 16
})
Tabs.Garden:Toggle({
	Title = "Enable Weight Filter",
	Flag = "WeightFilterToggle",
	Value = weightFilterEnabled,
	Callback = function(state)
		weightFilterEnabled = state
	end
})
Tabs.Garden:Input({
	Title = "Minimum Weight",
	Flag = "MinWeightInput",
	Type = "Input",
	Placeholder = "Enter minimum weight...",
	Value = tostring(minWeight),
	Callback = function(value)
		local num = tonumber(value)
		if num then
			minWeight = num
		end
	end
})
Tabs.Garden:Input({
	Title = "Maximum Weight",
	Flag = "MaxWeightInput",
	Type = "Input",
	Placeholder = "Enter maximum weight...",
	Value = tostring(maxWeight),
	Callback = function(value)
		local num = tonumber(value)
		if num then
			maxWeight = num
		end
	end
})
Tabs.Garden:Section({
	Title = "Value Filter",
	TextSize = 16
})
Tabs.Garden:Toggle({
	Title = "Enable Value Filter",
	Flag = "ValueFilterToggle",
	Value = valueFilterEnabled,
	Callback = function(state)
		valueFilterEnabled = state
	end
})
Tabs.Garden:Input({
	Title = "Minimum Value",
	Flag = "MinValueInput",
	Type = "Input",
	Placeholder = "Enter minimum value...",
	Value = tostring(minValue),
	Callback = function(value)
		local num = tonumber(value)
		if num then
			minValue = num
		end
	end
})
Tabs.Garden:Input({
	Title = "Maximum Value",
	Flag = "MaxValueInput",
	Type = "Input",
	Placeholder = "Enter maximum value...",
	Value = tostring(maxValue),
	Callback = function(value)
		local num = tonumber(value)
		if num then
			maxValue = num
		end
	end
})
GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
Remove_Item = GameEvents:WaitForChild("Remove_Item")
DeleteObject = GameEvents:WaitForChild("DeleteObject")
GetFarm = require(ReplicatedStorage.Modules.GetFarm)
treeList = {}
selectedTrees = {}
autoRemoveTreeEnabled = false
autoRemoveTreeDelay = 0.01
treeRemovalThread = nil
fruitList = {}
selectedFruits = {}
autoRemoveFruitEnabled = false
autoRemoveFruitDelay = 0.01
weightFilterEnabled = false
minWeight = 0
maxWeight = 999
mutationWhitelist = {}
fruitRemovalThread = nil
function getMyFarmPlots()
	myUsername = LocalPlayer.Name
	myPlots = {}
	farmFolder = Workspace:FindFirstChild("Farm")
	if farmFolder then
		for _, plot in pairs(farmFolder:GetChildren()) do
			sign = plot:FindFirstChild("Sign")
			if sign then
				owner = sign:GetAttribute("_owner")
				if owner and owner == myUsername then
					table.insert(myPlots, plot)
				end
			end
		end
	end
	return myPlots
end
function scanTrees()
	treeList = {}
	treeCounts = {}
	myPlots = getMyFarmPlots()
	for _, plot in pairs(myPlots) do
		descendants = plot:GetDescendants()
		for i = 1, # descendants do
			obj = descendants[i]
			if obj:IsA("Model") and obj:FindFirstChild("Grow") then
				treeName = obj.Name
				treeCounts[treeName] = (treeCounts[treeName] or 0) + 1
			end
		end
	end
	for treeName, count in pairs(treeCounts) do
		table.insert(treeList, {
			Title = treeName .. " (x" .. count .. ")",
			TreeName = treeName,
			Count = count
		})
	end
	table.sort(treeList, function(a, b)
		return a.TreeName < b.TreeName
	end)
	return treeList
end
function scanFruits()
	fruitList = {}
	fruitCounts = {}
	myPlots = getMyFarmPlots()
	for _, plot in pairs(myPlots) do
		descendants = plot:GetDescendants()
		for i = 1, # descendants do
			obj = descendants[i]
			if obj:IsA("Model") then
				fruitsFolder = obj:FindFirstChild("Fruits")
				if fruitsFolder then
					for _, fruit in pairs(fruitsFolder:GetChildren()) do
						fruitName = fruit.Name
						fruitCounts[fruitName] = (fruitCounts[fruitName] or 0) + 1
					end
				end
			end
		end
	end
	for fruitName, count in pairs(fruitCounts) do
		table.insert(fruitList, {
			Title = fruitName .. " (x" .. count .. ")",
			FruitName = fruitName,
			Count = count
		})
	end
	table.sort(fruitList, function(a, b)
		return a.FruitName < b.FruitName
	end)
	return fruitList
end
function getFruitWeight(fruitObj)
	weightAttr = fruitObj:GetAttribute("Weight")
	if weightAttr then
		return tonumber(weightAttr)
	end
	weightObj = fruitObj:FindFirstChild("Weight")
	if weightObj then
		if weightObj:IsA("NumberValue") or weightObj:IsA("IntValue") then
			return weightObj.Value
		elseif weightObj:IsA("StringValue") then
			return tonumber(weightObj.Value)
		end
	end
	parent = fruitObj.Parent
	if parent then
		parentWeightAttr = parent:GetAttribute("Weight")
		if parentWeightAttr then
			return tonumber(parentWeightAttr)
		end
	end
	return nil
end
function getFruitMutations(fruitObj)
	mutations = {}
	for attrName, attrValue in pairs(fruitObj:GetAttributes()) do
		if type(attrValue) == "boolean" and attrValue == true then
			table.insert(mutations, attrName)
		end
	end
	parent = fruitObj.Parent
	if parent then
		plant = parent.Parent
		if plant and plant:IsA("Model") then
			for attrName, attrValue in pairs(plant:GetAttributes()) do
				if type(attrValue) == "boolean" and attrValue == true then
					table.insert(mutations, attrName)
				end
			end
		end
	end
	return mutations
end
function shouldRemoveFruit(fruitObj)
	fruitName = fruitObj.Name
	if # selectedFruits > 0 then
		found = false
		for _, selectedFruit in pairs(selectedFruits) do
			if selectedFruit.FruitName == fruitName then
				found = true
				break
			end
		end
		if not found then
			return false
		end
	end
	if weightFilterEnabled then
		weight = getFruitWeight(fruitObj)
		if weight then
			if weight < minWeight or weight > maxWeight then
				return false
			end
		else
			return false
		end
	end
	if # mutationWhitelist > 0 then
		mutations = getFruitMutations(fruitObj)
		hasMutation = false
		for _, mutation in pairs(mutations) do
			for _, whitelistedMutation in pairs(mutationWhitelist) do
				if mutation:lower() == whitelistedMutation:lower() then
					hasMutation = true
					break
				end
			end
			if hasMutation then
				break
			end
		end
		if not hasMutation then
			return false
		end
	end
	return true
end
function removeSelectedTrees()
	myPlots = getMyFarmPlots()
	treesRemoved = 0
	for _, plot in pairs(myPlots) do
		descendants = plot:GetDescendants()
		for i = 1, # descendants do
			obj = descendants[i]
			if obj:IsA("Model") and obj:FindFirstChild("Grow") then
				treeName = obj.Name
				for _, selectedTree in pairs(selectedTrees) do
					if selectedTree.TreeName == treeName then
						pcall(function()
							Remove_Item:FireServer(obj:FindFirstChildWhichIsA("BasePart") or obj)
						end)
						treesRemoved = treesRemoved + 1
						break
					end
				end
			end
		end
	end
	return treesRemoved
end
function removeSelectedFruits()
	myPlots = getMyFarmPlots()
	fruitsRemoved = 0
	for _, plot in pairs(myPlots) do
		descendants = plot:GetDescendants()
		for i = 1, # descendants do
			obj = descendants[i]
			if obj:IsA("Model") then
				fruitsFolder = obj:FindFirstChild("Fruits")
				if fruitsFolder then
					for _, fruit in pairs(fruitsFolder:GetChildren()) do
						if shouldRemoveFruit(fruit) then
							prompt = fruit:FindFirstChildWhichIsA("ProximityPrompt")
							if prompt then
								pcall(function()
									FireClient(prompt.Triggered)
								end)
								fruitsRemoved = fruitsRemoved + 1
							end
						end
					end
				end
			end
		end
	end
	return fruitsRemoved
end
function startAutoTreeRemoval()
	if treeRemovalThread then
		task.cancel(treeRemovalThread)
		treeRemovalThread = nil
	end
	treeRemovalThread = task.spawn(function()
		while autoRemoveTreeEnabled and # selectedTrees > 0 do
			removed = removeSelectedTrees()
			if removed > 0 then
				task.wait(autoRemoveTreeDelay)
			else
				task.wait(1)
			end
		end
		treeRemovalThread = nil
	end)
end
function startAutoFruitRemoval()
	if fruitRemovalThread then
		task.cancel(fruitRemovalThread)
		fruitRemovalThread = nil
	end
	fruitRemovalThread = task.spawn(function()
		while autoRemoveFruitEnabled do
			removed = removeSelectedFruits()
			if removed > 0 then
				task.wait(autoRemoveFruitDelay)
			else
				task.wait(1)
			end
		end
		fruitRemovalThread = nil
	end)
end
function stopAutoTreeRemoval()
	if treeRemovalThread then
		task.cancel(treeRemovalThread)
		treeRemovalThread = nil
	end
end
function stopAutoFruitRemoval()
	if fruitRemovalThread then
		task.cancel(fruitRemovalThread)
		fruitRemovalThread = nil
	end
end
Tabs.Garden:Section({
	Title = "Remove Tree",
	TextSize = 20
})
treeDropdown = Tabs.Garden:Dropdown({
	Title = "Tree List",
	Values = {
		"Click refresh to load trees"
	},
	Multi = true,
	AllowNone = true,
	SearchBarEnabled = true,
	SearchPlaceholder = "Search trees...",
	Callback = function(selected)
		selectedTrees = selected
	end
})
Tabs.Garden:Button({
	Title = "Refresh Tree List",
	Callback = function()
		trees = scanTrees()
		treeDropdown:Refresh(trees)
	end
})
Tabs.Garden:Button({
	Title = "Remove Random Selected Tree",
	Callback = function()
		removeSelectedTrees()
	end
})
Tabs.Garden:Toggle({
	Title = "Auto Remove Tree",
	Flag = "AutoRemoveTree",
	Value = autoRemoveTreeEnabled,
	Callback = function(state)
		autoRemoveTreeEnabled = state
		if autoRemoveTreeEnabled then
			startAutoTreeRemoval()
		else
			stopAutoTreeRemoval()
		end
	end
})
Tabs.Garden:Slider({
	Title = "Auto Remove Delay",
	Flag = "AutoRemoveTreeDelay",
	Step = 0.01,
	Value = {
		Min = 0.01,
		Max = 5,
		Default = autoRemoveTreeDelay
	},
	Callback = function(value)
		autoRemoveTreeDelay = value
		if autoRemoveTreeEnabled and treeRemovalThread then
			stopAutoTreeRemoval()
			startAutoTreeRemoval()
		end
	end
})
Tabs.Garden:Section({
	Title = "Remove Fruit",
	TextSize = 20
})
fruitDropdown = Tabs.Garden:Dropdown({
	Title = "Fruit List",
	Values = {
		"Click refresh to load fruits"
	},
	Multi = true,
	AllowNone = true,
	SearchPlaceholder = "Search fruits...",
	Callback = function(selected)
		selectedFruits = selected
	end
})
Tabs.Garden:Button({
	Title = "Refresh Fruit List",
	Callback = function()
		fruits = scanFruits()
		fruitDropdown:Refresh(fruits)
	end
})
Tabs.Garden:Button({
	Title = "Remove All Selected Fruit",
	Callback = function()
		removeSelectedFruits()
	end
})
Tabs.Garden:Toggle({
	Title = "Weight Selecting",
	Flag = "WeightFilter",
	Value = weightFilterEnabled,
	Callback = function(state)
		weightFilterEnabled = state
	end
})
Tabs.Garden:Input({
	Title = "Minimum Weight",
	Flag = "MinWeight",
	Type = "Input",
	Placeholder = "0",
	Value = tostring(minWeight),
	Callback = function(value)
		num = tonumber(value)
		if num then
			minWeight = num
		end
	end
})
Tabs.Garden:Input({
	Title = "Max Weight",
	Flag = "MaxWeight",
	Type = "Input",
	Placeholder = "999",
	Value = tostring(maxWeight),
	Callback = function(value)
		num = tonumber(value)
		if num then
			maxWeight = num
		end
	end
})
mutationDropdown = Tabs.Garden:Dropdown({
	Title = "Mutations Whitelist",
	Values = {
		"Click refresh to load mutations"
	},
	Multi = true,
	AllowNone = true,
	SearchBarEnabled = true,
	SearchPlaceholder = "Search mutations...",
	Callback = function(selected)
		mutationWhitelist = selected
	end
})
Tabs.Garden:Button({
	Title = "Refresh Mutations",
	Callback = function()
		mutations = GetmutationsData()
		if # mutations > 0 then
			mutationDropdown:Refresh(mutations)
		end
	end
})
Tabs.Garden:Toggle({
	Title = "Auto Remove Fruit",
	Flag = "AutoRemoveFruit",
	Value = autoRemoveFruitEnabled,
	Callback = function(state)
		autoRemoveFruitEnabled = state
		if autoRemoveFruitEnabled then
			startAutoFruitRemoval()
		else
			stopAutoFruitRemoval()
		end
	end
})
Tabs.Garden:Slider({
	Title = "Auto Remove Delay",
	Flag = "AutoRemoveFruitDelay",
	Step = 0.01,
	Value = {
		Min = 0.01,
		Max = 5,
		Default = autoRemoveFruitDelay
	},
	Callback = function(value)
		autoRemoveFruitDelay = value
		if autoRemoveFruitEnabled and fruitRemovalThread then
			stopAutoFruitRemoval()
			startAutoFruitRemoval()
		end
	end
})
Tabs.Garden:Section({
	Title = "Move Tree",
	TextSize = 20
})
MoveTree_RefreshButton = Tabs.Garden:Button({
	Title = "Refresh Trees",
	Callback = function()
		MoveTree_TreeList = {}
		MoveTree_TreeCounts = {}
		MoveTree_MyPlots = {}
		MoveTree_FarmFolder = workspace:FindFirstChild("Farm")
		MoveTree_MyUsername = Players.LocalPlayer.Name
		if MoveTree_FarmFolder then
			for _, MoveTree_Plot in pairs(MoveTree_FarmFolder:GetChildren()) do
				MoveTree_Sign = MoveTree_Plot:FindFirstChild("Sign")
				if MoveTree_Sign then
					MoveTree_Owner = MoveTree_Sign:GetAttribute("_owner")
					if MoveTree_Owner and MoveTree_Owner == MoveTree_MyUsername then
						table.insert(MoveTree_MyPlots, MoveTree_Plot)
					end
				end
			end
			for _, MoveTree_Plot in pairs(MoveTree_MyPlots) do
				MoveTree_Descendants = MoveTree_Plot:GetDescendants()
				for _, MoveTree_Obj in pairs(MoveTree_Descendants) do
					if MoveTree_Obj:IsA("Model") and MoveTree_Obj:FindFirstChild("Grow") then
						MoveTree_TreeName = MoveTree_Obj.Name
						MoveTree_TreeCounts[MoveTree_TreeName] = (MoveTree_TreeCounts[MoveTree_TreeName] or 0) + 1
					end
				end
			end
			for MoveTree_TreeName, MoveTree_Count in pairs(MoveTree_TreeCounts) do
				table.insert(MoveTree_TreeList, {
					Title = MoveTree_TreeName .. " (x" .. MoveTree_Count .. ")",
					TreeName = MoveTree_TreeName,
					Count = MoveTree_Count
				})
			end
			table.sort(MoveTree_TreeList, function(MoveTree_A, MoveTree_B)
				return MoveTree_A.TreeName < MoveTree_B.TreeName
			end)
		end
		MoveTree_TreeDropdown:Refresh(MoveTree_TreeList)
	end
})
MoveTree_TreeDropdown = Tabs.Garden:Dropdown({
	Title = "Tree List",
	Values = {},
	Multi = true,
	AllowNone = true,
	SearchBarEnabled = true,
	Callback = function(MoveTree_Selected)
		MoveTree_SelectedTrees = MoveTree_Selected
	end
})
MoveTree_SavePositionButton = Tabs.Garden:Button({
	Title = "Save Position",
	Callback = function()
		MoveTree_Character = Players.LocalPlayer.Character
		if MoveTree_Character then
			MoveTree_RootPart = MoveTree_Character:FindFirstChild("HumanoidRootPart")
			if MoveTree_RootPart then
				MoveTree_SavedPos = MoveTree_RootPart.Position
			end
		end
	end
})
MoveTree_ClearPositionButton = Tabs.Garden:Button({
	Title = "Clear Position",
	Callback = function()
		MoveTree_SavedPos = nil
	end
})
MoveTree_MoveAllButton = Tabs.Garden:Button({
	Title = "Move All Selected",
	Callback = function()
		MoveTree_MyUsername = Players.LocalPlayer.Name
		MoveTree_FarmFolder = workspace:FindFirstChild("Farm")
		MoveTree_MyPlots = {}
		MoveTree_TargetPos = MoveTree_SavedPos or Vector3.new(0, 0, 0)
		MoveTree_Mode = MoveTree_ModeValue or "Random"
		if MoveTree_FarmFolder then
			for _, MoveTree_Plot in pairs(MoveTree_FarmFolder:GetChildren()) do
				MoveTree_Sign = MoveTree_Plot:FindFirstChild("Sign")
				if MoveTree_Sign then
					MoveTree_Owner = MoveTree_Sign:GetAttribute("_owner")
					if MoveTree_Owner and MoveTree_Owner == MoveTree_MyUsername then
						table.insert(MoveTree_MyPlots, MoveTree_Plot)
					end
				end
			end
		end
		if MoveTree_Mode == "Under LocalPlayer" then
			MoveTree_Character = Players.LocalPlayer.Character
			if MoveTree_Character then
				MoveTree_RootPart = MoveTree_Character:FindFirstChild("HumanoidRootPart")
				if MoveTree_RootPart then
					MoveTree_TargetPos = MoveTree_RootPart.Position + Vector3.new(0, - 2, 0)
				end
			end
		elseif MoveTree_Mode == "Random" then
			MoveTree_Character = Players.LocalPlayer.Character
			if MoveTree_Character then
				MoveTree_RootPart = MoveTree_Character:FindFirstChild("HumanoidRootPart")
				if MoveTree_RootPart then
					MoveTree_BasePos = MoveTree_RootPart.Position
					MoveTree_TargetPos = MoveTree_BasePos + Vector3.new(math.random…