-- Deobfuscated By Ron

local chilliGithubFastManualDefaultsRu, v, v2, defaultTab, esp, Misc, Server, v3, Players, RunService
local Workspace, Lighting, CoreGui, HttpService, ReplicatedStorage, UserInputService, TeleportService, TextService, Stats, localPlayer
local v4, fn, obj, tbl, v5, flag, fn2, tbl2, fn3, v6
local v7, v8

do
	local v9, ContextActionService, v10, v11

	do
		local Helper, ProximityPromptService, TweenService, v12, str, n, flag2, flag3, flag4, n2
		local flag5, n3, flag6, n4, RagdollController, UserInputService2, connection, flag7, n5, n6
		local prompt, tbl3, n7, folder, bindableEvent, fn4, fn5, fn6, fn7, fn8
		local fn9, prompt2, fn10, fn11, fn12, str2, fn13, fn14, screenGui, fn15
		local fn16, fn17, fn18, fn19, screenGui2, frame, textLabel, textLabel2, frame2

		do
			local value = rawget(_G, "__ChilliGithubFastManualDefaultsRun")

			if type(value) == "table" then
				local window = value.Window

				if type(window) == "table" and window._destroyed ~= true then
					pcall(function()
						window:Open()
					end)

					return
				end

				local now = tonumber(value.StartedAt) or os.clock()
				if value.Status == "loading" and os.clock() - now < 30 then
					return
				end
			end

			chilliGithubFastManualDefaultsRu = { Status = "loading", StartedAt = os.clock() }
			_G.__ChilliGithubFastManualDefaultsRun = chilliGithubFastManualDefaultsRu

			local function fn20()
				local response = game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/refs/heads/main/Chilli%20Library")
				local chunk, v13 = loadstring(response)
				assert(chunk, v13)
				local v14 = chunk()
				assert(type(v14) == "function", "Chilli Library bootstrap is invalid.")
				local v15 = table.create(45)
				local n8 = 1

				for i_ = 1, 90, 2 do
					v15[n8] = string.char(bit32.bxor(tonumber(string.sub("306908100841206d474f00185f26635b2101387507010810127d7d477a473b6f435a0916573165562900226c00", i_, i_ + 1), 16), string.byte("s9K!2vQ#", (n8 - 1) % 8 + 1)))
					n8 += 1
				end

				return v14(table.concat(v15))
			end

			v = fn20()
			assert(type(v) == "table" and type(v.CreateWindow) == "function" and type(v.Finalize) == "function", "Chilli Library returned an invalid API.")
			chilliGithubFastManualDefaultsRu.Library = v

			v.ManualQuickDefaults = {
				PinnedFeatures = {
					"Stealer > Auto Steal Brainrot > Auto Steal",
					"Helper > Movement & Combat > Float",
					"Helper > Movement & Combat > Auto Hit Nearest Player",
					"Player > Jump Boost > Auto Jump",
					"Player > Jump Boost > Limit Jump Height",
					"Player > Invisibility > Invisible",
					"Server > Server > Kick",
					"Helper > Unlock Base > Auto Unlock Base",
					"Helper > Unlock Base > Unlock Floor 3",
					"Helper > Unlock Base > Unlock Floor 2",
					"Helper > Unlock Base > Unlock Floor 1",
					"Player > Respawn > Fast Reset",
					"Player > Speed Boost > Tool Speed Boost",
					"Stealer > Auto Steal Brainrot > Drop Brainrot",
					"Helper > Helper > Instant Clone Swap",
					"Player > Speed Boost > Adjust Auto Speed",
					"Player > Invisibility > Auto Invisible On Steal",
					"Player > Invisibility > Rotation",
					"Player > Invisibility > Auto Rotation",
					"Player > Invisibility > Depth",
					"Player > Invisibility > Lagback Detect",
					"Player > Invisibility > Auto Fix Lagback",
				},
				Keybinds = {
					["Player > Respawn > Fast Reset"] = "X",
					["Player > Jump Boost > Limit Jump Height"] = "N",
					["Player > Speed Boost > Tool Speed Boost"] = "Q",
					["Player > Jump Boost > Auto Jump"] = "V",
					["Player > Invisibility > Invisible"] = "U",
					["Helper > Movement & Combat > Float"] = "B",
					["Helper > Movement & Combat > Auto Hit Nearest Player"] = "G",
					["Stealer > Auto Steal Brainrot > Drop Brainrot"] = "R",
					["Server > Server > Kick"] = "J",
					["Helper > Helper > Instant Clone Swap"] = "F",
					["__ChilliDefaultKeyInstalled::Player > Speed Boost > Tool Speed Boost"] = true,
					["__ChilliDefaultKeyInstalled::Player > Invisibility > Invisible"] = true,
				},
				PinGroups = {
					["Player > Respawn > Fast Reset"] = 5,
					["Helper > Movement & Combat > Auto Hit Nearest Player"] = 1,
					["Helper > Unlock Base > Unlock Floor 3"] = 4,
					["Helper > Helper > Instant Clone Swap"] = 5,
					["Player > Speed Boost > Adjust Speed"] = 2,
					["Player > Jump Boost > Jump Height"] = 1,
					["Player > Invisibility > Auto Rotation"] = 2,
					["Helper > Unlock Base > Auto Unlock Base"] = 4,
					["Helper > Aimbot > Auto Paintball"] = 3,
					["Helper > Unlock Base > Unlock Floor 1"] = 4,
					["Player > Speed Boost > Adjust Auto Speed"] = 2,
					["Player > Invisibility > Lagback Detect"] = 2,
					["Player > Invisibility > Auto Invisible On Steal"] = 2,
					["Player > Invisibility > Invisible"] = 2,
					["Player > Invisibility > Auto Fix Lagback"] = 2,
					["Player > Speed Boost > Tool Speed Boost"] = 1,
					["Player > Invisibility > Depth"] = 2,
					["Stealer > Auto Kick > Auto Kick on Steal"] = 5,
					["Helper > Helper > Anti Body Swap"] = 5,
					["Player > Invisibility > Rotation"] = 2,
					["Helper > Unlock Base > Unlock Floor 2"] = 4,
					["Stealer > Auto Steal Brainrot > Drop Brainrot"] = 5,
					["Server > Server > Kick"] = 5,
				},
				LeftCenterHidden = true,
			}

			v2 = v:CreateWindow({ Name = "Chilli Hub", DefaultTab = "Main" })
			chilliGithubFastManualDefaultsRu.Window = v2
			defaultTab = v2:GetDefaultTab()
			local v13

			do
				local Stealer = v2:CreateTab("Stealer")
				Helper = v2:CreateTab("Helper")
				v9 = v2:CreateTab({ Name = "Player", SectionsExpanded = false })
				esp = v2:CreateTab("ESP")
				Misc = v2:CreateTab("Misc")
				Server = v2:CreateTab("Server")
				v3 = v2:CreateTab("AP&TP")
				Players = game:GetService("Players")
				RunService = game:GetService("RunService")
				Workspace = game:GetService("Workspace")
				Lighting = game:GetService("Lighting")
				CoreGui = game:GetService("CoreGui")
				HttpService = game:GetService("HttpService")
				ReplicatedStorage = game:GetService("ReplicatedStorage")
				UserInputService = game:GetService("UserInputService")
				ContextActionService = game:GetService("ContextActionService")
				TeleportService = game:GetService("TeleportService")
				ProximityPromptService = game:GetService("ProximityPromptService")
				TextService = game:GetService("TextService")
				TweenService = game:GetService("TweenService")
				Stats = game:GetService("Stats")
				localPlayer = Players.LocalPlayer
				local str3 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
				v4 = Random.new()

				fn = function()
					local v14 = table.create(64)
					local str4 = HttpService:GenerateGUID(false):gsub("-", "")

					for i_ = 1, #str4 do
						v14[#v14 + 1] = str4:sub(i_, i_)
					end

					for i_ = 1, 32 do
						local v15 = v4:NextInteger(1, #str3)
						v14[#v14 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"):sub(v15, v15)
					end

					for i_ = #v14, 2, -1 do
						local v15 = v4:NextInteger(1, i_)
						local v16 = v14[i_]
						v14[i_] = v14[v15]
						v14[v15] = v16
					end

					return table.concat(v14)
				end

				obj = setmetatable({}, { __mode = "k" })
				tbl = {}
				v12 = Stealer:CreateSection({ Name = "Auto Steal Brainrot", Expanded = true })
				v13 = Stealer:CreateSection({ Name = "Auto Kick", Expanded = true })
			end

			do
				local flag8 = false
				local flag9 = true
				local flag10 = false
				local n8 = 0
				local n9 = 1000000
				local v14 = nil
				local n10 = -math.huge
				local tbl4 = {}
				local obj2 = setmetatable({}, { __mode = "k" })
				local tbl5 = {}

				pcall(function()
					local Animals = require(ReplicatedStorage.Datas.Animals)

					if type(Animals) == "table" then
						tbl5 = Animals
					end
				end)

				local function fn21(arg)
					local match, v15 = tostring(arg or ""):gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")
					if not match then
						return nil
					end
					local num = tonumber(match)
					if not num then
						return nil
					end
					return num * (({ K = 1000, M = 1000000, B = 1e9, T = 1e12 })[string.upper(v15)] or 1)
				end

				local function fn22(arg)
					local v15 = tbl5[tostring(arg or "")]
					return type(v15) == "table" and tonumber(v15.Generation) or 0
				end

				local function fn23()
					local tbl6 = {}
					local debris = Workspace:FindFirstChild("Debris")
					if not debris then
						return tbl6
					end

					for _, child in ipairs(debris:GetChildren()) do
						if child:IsA("BasePart") and child.Name == "FastOverheadTemplate" then
							local animalOverhead = child:FindFirstChild("AnimalOverhead")
							local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")
							animalOverhead = animalOverhead and animalOverhead:FindFirstChild("Generation")

							if displayName and animalOverhead and displayName:IsA("TextLabel") and animalOverhead:IsA("TextLabel") then
								local v15 = fn21(animalOverhead.Text)

								if v15 then
									local str3 = tostring(displayName.Text)
									tbl6[str3] = tbl6[str3] or {}
									tbl6[str3][#tbl6[str3] + 1] = { Position = child.Position, Generation = v15 }
								end
							end
						end
					end

					return tbl6
				end

				local function fn24(arg, arg2, arg3)
					local generation = fn22(arg)
					if not arg2 then
						return generation
					end
					local v15, v16, v17 = ipairs((arg3 or fn23())[tostring(arg or "")] or {})
					local n11 = 14

					for _, v18 in v15, v16, v17 do
						local magnitude = (v18.Position - arg2).Magnitude

						if magnitude < n11 then
							generation = v18.Generation
							n11 = magnitude
						end
					end

					return generation
				end

				local function fn25()
					local v15 = Workspace:FindFirstChild(localPlayer.Name)
					if not v15 or not v15:IsA("Model") then
						return nil
					end
					return v15:FindFirstChild("HumanoidRootPart") or v15:FindFirstChild("__HITBOX")
				end

				local chilliAutoKickOnStealRuntime = CoreGui:FindFirstChild("__ChilliAutoKickOnStealRuntime")

				if chilliAutoKickOnStealRuntime then
					local cleanup = chilliAutoKickOnStealRuntime:FindFirstChild("Cleanup")

					if cleanup and cleanup:IsA("BindableEvent") then
						pcall(function()
							cleanup:Fire()
						end)
					end

					pcall(function()
						chilliAutoKickOnStealRuntime:Destroy()
					end)
				end

				local folder2 = Instance.new("Folder")
				folder2.Name = "__ChilliAutoKickOnStealRuntime"
				folder2.Archivable = false
				folder2.Parent = CoreGui
				local bindableEvent2 = Instance.new("BindableEvent")
				bindableEvent2.Name = "Cleanup"
				bindableEvent2.Parent = folder2

				local function fn26()
					for _, v15 in ipairs(tbl4) do
						if v15.Connected then
							v15:Disconnect()
						end
					end

					table.clear(tbl4)
					table.clear(obj2)
				end

				local fn27 = nil

				fn27 = function(arg, arg2, arg3)
					local kind = typeof(arg)

					if kind == "string" then
						local v15 = string.lower(arg)
						if string.find(v15, "you stole", 1, true) or string.find(v15, "successfully stole", 1, true) then
							return arg
						end
						return nil
					end

					if kind ~= "table" or arg3 >= 3 or arg2[arg] then
						return nil
					end
					arg2[arg] = true

					for k, v15 in pairs(arg) do
						local v16 = fn27(k, arg2, arg3 + 1) or fn27(v15, arg2, arg3 + 1)
						if v16 then
							return v16
						end
					end

					return nil
				end

				local function fn28(...)
					if not flag8 then
						return
					end
					local v15 = table.pack(...)
					local tbl6 = {}

					for i_ = 1, v15.n do
						local v16 = fn27(v15[i_], tbl6, 0)

						if v16 then
							local v17 = string.match(v16, ">([^<>]-)</font>")
							local v18 = fn25()
							if fn24(v17, v18 and v18.Position) < n9 then
								return
							end
							local flag11 = v17 and v17 ~= ""
							local str3 = "\nAUTO KICK ACTIVATED"

							if flag11 then
								str3 = "\nAUTO KICK ACTIVATED" .. "\nYou stole: " .. v17
							end

							flag8 = false
							localPlayer:Kick(str3)
							return
						end
					end
				end

				local function fn29(descendant)
					if not flag8 or not descendant:IsA("RemoteEvent") or obj2[descendant] then
						return
					end
					obj2[descendant] = true
					tbl4[#tbl4 + 1] = descendant.OnClientEvent:Connect(fn28)
				end

				local function fn30()
					flag8 = false
					fn26()
				end

				local function fn31()
					fn30()
					flag8 = true
					local packages = ReplicatedStorage:FindFirstChild("Packages")
					packages = packages and packages:FindFirstChild("Net")
					if not packages then
						flag8 = false
						return
					end

					for _, descendant in ipairs(packages:GetDescendants()) do
						fn29(descendant)
					end

					fn29(packages)
					tbl4[#tbl4 + 1] = packages.DescendantAdded:Connect(fn29)
				end

				local function fn32()
					flag9 = false
					flag10 = false
					n8 += 1
					fn30()
				end

				bindableEvent2.Event:Connect(fn32)
				folder2.Destroying:Connect(fn32)

				v13:CreateToggle({
					Name = "Auto Kick on Steal",
					Default = false,
					Callback = function(arg)
						if arg then
							fn31()
						else
							fn30()
						end
					end,
				})

				local tbl6 = {
					["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
					["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
					["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
				}

				local v15 = nil
				local n11 = 1
				local str3 = "M/s"

				local function fn33(arg, arg2)
					if arg ~= nil then
						n11 = math.floor(tonumber(arg) or n11)
					end

					if arg2 ~= nil then
						str3 = tostring(arg2)
					elseif v15 and v15.GetUnit then
						local unit = v15:GetUnit()

						if unit and unit ~= "" then
							str3 = tostring(unit)
						end
					end

					n9 = n11 * (tbl6[str3] or tbl6["M/s"]).Mult
					v14 = nil
					n10 = -math.huge
				end

				local function fn34(arg)
					str3 = tostring(arg)
					local ms = tbl6[str3] or tbl6["M/s"]

					if v15 and v15.SetRange then
						v15:SetRange(ms.Min, ms.Max)
						local min = v15:Get() or ms.Min
						local min2 = ms.Min
						local max = ms.Max
						local n12 = math.clamp(math.floor(min + 0.5), min2, max)

						if n12 ~= min then
							v15:Set(n12)
						else
							fn33(n12, str3)
						end
					else
						fn33(nil, str3)
					end
				end

				v15 = v13:CreateSlider({
					Name = "Auto Kick Min Value",
					Note = "Only kicks for Brainrots at or above this generation value.",
					Min = 0,
					Max = 1000,
					Default = 10,
					AllowDecimals = false,
					Increment = 1,
					Unit = {
						Default = "M/s",
						Selector = true,
						Options = { "K/s", "M/s", "B/s" },
						ColorEnabled = true,
						Colors = {
							Number = Color3.fromRGB(255, 255, 255),
							Suffix = Color3.fromRGB(58, 255, 55),
						},
						Callback = function(arg)
							fn34(arg)
						end,
					},
					Quick = false,
					Callback = function(arg)
						fn33(arg, nil)
					end,
				})
			end

			str = "Steal"
			local n8
			n8 = 2
			n = 0.25
			flag2 = true
			flag3 = false
			flag4 = false
			n2 = 1000000
			flag5 = false
			n3 = 20
			flag6 = false
			n4 = 0
			RagdollController = nil

			pcall(function()
				RagdollController = require(game:GetService("ReplicatedStorage").Controllers.RagdollController)
			end)

			UserInputService2 = game:GetService("UserInputService")

			connection = UserInputService2.InputBegan:Connect(function(input, gameProcessed)
				if not gameProcessed and input.KeyCode == Enum.KeyCode.Backspace then
					n4 = os.clock()
				end
			end)

			flag7 = false
			n5 = 0
			local n9
			n9 = 0
			n6 = -math.huge
			prompt = nil
			tbl3 = {}
			n7 = -math.huge
			local fn21

			do
				local tbl4 = {}
				local chilliAutoGetRuntime = CoreGui:FindFirstChild("__ChilliAutoGetRuntime")

				if chilliAutoGetRuntime then
					local cleanup = chilliAutoGetRuntime:FindFirstChild("Cleanup")

					if cleanup and cleanup:IsA("BindableEvent") then
						pcall(function()
							cleanup:Fire()
						end)
					end

					pcall(function()
						chilliAutoGetRuntime:Destroy()
					end)
				end

				folder = Instance.new("Folder")
				folder.Name = "__ChilliAutoGetRuntime"
				folder.Archivable = false
				folder.Parent = CoreGui
				bindableEvent = Instance.new("BindableEvent")
				bindableEvent.Name = "Cleanup"
				bindableEvent.Parent = folder

				fn4 = function(arg)
					tbl4[#tbl4 + 1] = arg
					return arg
				end

				local n10 = 10
				local obj2 = setmetatable({}, { __mode = "k" })

				fn21 = function(arg, arg2)
					if not arg or not arg.Parent or not arg.Visible then
						return false
					end
					local absolutePosition = arg.AbsolutePosition
					local absoluteSize = arg.AbsoluteSize
					return arg2.X >= absolutePosition.X and arg2.X <= absolutePosition.X + absoluteSize.X and arg2.Y >= absolutePosition.Y and arg2.Y <= absolutePosition.Y + absoluteSize.Y
				end

				fn4(UserInputService2.InputChanged:Connect(function(input)
					local v14 = obj2[input]
					if not v14 then
						return
					end
					local vector2 = Vector2.new(input.Position.X, input.Position.Y)
					v14.Position = vector2

					if (vector2 - v14.Start).Magnitude > n10 then
						v14.Cancelled = true
					end
				end))

				fn4(UserInputService2.InputEnded:Connect(function(input)
					local v14 = obj2[input]
					if not v14 then
						return
					end
					local vector2 = Vector2.new(input.Position.X, input.Position.Y)
					v14.Position = vector2

					if (vector2 - v14.Start).Magnitude > n10 or not fn21(v14.Button, vector2) then
						v14.Cancelled = true
					end

					task.delay(0.2, function()
						if obj2[input] == v14 then
							obj2[input] = nil
						end
					end)
				end))

				fn5 = function(arg, arg2)
					fn4(arg.InputBegan:Connect(function(input)
						if input.UserInputType ~= Enum.UserInputType.Touch or input.UserInputState ~= Enum.UserInputState.Begin then
							return
						end
						local vector2 = Vector2.new(input.Position.X, input.Position.Y)

						if fn21(arg, vector2) then
							obj2[input] = { Button = arg, Start = vector2, Position = vector2, Cancelled = false }
						end
					end))

					return fn4(arg.Activated:Connect(function(inputObject)
						if inputObject and inputObject.UserInputType == Enum.UserInputType.Touch then
							local v14 = obj2[inputObject]
							if not v14 or v14.Button ~= arg or v14.Cancelled or not fn21(arg, v14.Position) then
								return
							end
						end

						arg2()
					end))
				end

				fn6 = function()
					for _, v14 in ipairs(tbl4) do
						if v14.Connected then
							v14:Disconnect()
						end
					end

					table.clear(tbl4)
				end
			end

			local v14, v15, fn22, fn23, fn24

			do
				local v16 = nil
				v14 = nil
				v15 = nil
				local datas = ReplicatedStorage:FindFirstChild("Datas")

				if datas then
					local animals = datas:FindFirstChild("Animals")

					if animals and animals:IsA("ModuleScript") then
						local ok, result = pcall(require, animals)

						if ok and type(result) == "table" then
							v16 = result
						end
					end

					local mutations = datas:FindFirstChild("Mutations")

					if mutations and mutations:IsA("ModuleScript") then
						local ok, result = pcall(require, mutations)

						if ok and type(result) == "table" then
							v14 = result
						end
					end

					local traits = datas:FindFirstChild("Traits")

					if traits and traits:IsA("ModuleScript") then
						local ok, result = pcall(require, traits)

						if ok and type(result) == "table" then
							v15 = result
						end
					end
				end

				fn22 = function(arg)
					return string.lower(tostring(arg or ""))
				end

				fn23 = function(arg)
					arg = arg and arg.Parent

					while arg and arg ~= Workspace do
						if arg:IsA("BasePart") and arg.Name == "Spawn" then
							return arg
						end
						arg = arg.Parent
					end

					return nil
				end

				fn24 = function(arg)
					if not v16 or not arg or arg == "" then
						return 0
					end
					local v17 = v16[arg]
					if type(v17) ~= "table" then
						return 0
					end
					return tonumber(v17.Generation) or 0
				end
			end

			local brainrotNameTiers
			brainrotNameTiers = {}
			local tbl4
			tbl4 = { Limit = 1000000 }

			do
				local colorSequence = ColorSequence.new
				local tbl5 = {}
				local v16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))
				local v17 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
				local new = ColorSequenceKeypoint.new
				local color = Color3.fromRGB
				tbl5[1] = v16
				tbl5[2] = v17

				do
					local values = table.pack(new(1, color(214, 142, 12)))
					table.move(values, 1, values.n, 3, tbl5)
				end

				tbl4.Text = colorSequence(tbl5)
			end

			do
				local colorSequence = ColorSequence.new
				local tbl5 = {}
				local v16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
				local v17 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
				local new = ColorSequenceKeypoint.new
				local color = Color3.fromRGB
				tbl5[1] = v16
				tbl5[2] = v17

				do
					local values = table.pack(new(1, color(20, 12, 0)))
					table.move(values, 1, values.n, 3, tbl5)
				end

				tbl4.Stroke = colorSequence(tbl5)
			end

			local tbl5
			tbl5 = { Limit = 10000000 }

			do
				local colorSequence = ColorSequence.new
				local tbl6 = {}
				local v16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
				local v17 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
				local new = ColorSequenceKeypoint.new
				local color = Color3.fromRGB
				tbl6[1] = v16
				tbl6[2] = v17

				do
					local values = table.pack(new(1, color(206, 92, 0)))
					table.move(values, 1, values.n, 3, tbl6)
				end

				tbl5.Text = colorSequence(tbl6)
			end

			do
				local colorSequence = ColorSequence.new
				local tbl6 = {}
				local v16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 54, 0))
				local v17 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 27, 0))
				local new = ColorSequenceKeypoint.new
				local color = Color3.fromRGB
				tbl6[1] = v16
				tbl6[2] = v17

				do
					local values = table.pack(new(1, color(18, 8, 0)))
					table.move(values, 1, values.n, 3, tbl6)
				end

				tbl5.Stroke = colorSequence(tbl6)
			end

			do
				local tbl6 = { Limit = 100000000 }
				local colorSequence = ColorSequence.new
				local tbl7 = {}
				local v16 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 168, 140))
				local v17 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
				local new = ColorSequenceKeypoint.new
				local color = Color3.fromRGB
				tbl7[1] = v16
				tbl7[2] = v17

				do
					local values = table.pack(new(1, color(196, 42, 0)))
					table.move(values, 1, values.n, 3, tbl7)
				end

				tbl6.Text = colorSequence(tbl7)
				local colorSequence2 = ColorSequence.new
				local tbl8 = {}
				local v18 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 26, 0))
				local v19 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 13, 0))
				local new2 = ColorSequenceKeypoint.new
				local color2 = Color3.fromRGB
				tbl8[1] = v18
				tbl8[2] = v19

				do
					local values = table.pack(new2(1, color2(18, 4, 0)))
					table.move(values, 1, values.n, 3, tbl8)
				end

				tbl6.Stroke = colorSequence2(tbl8)
				local tbl9 = { Limit = math.huge }
				local colorSequence3 = ColorSequence.new
				local tbl10 = {}
				local v20 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
				local v21 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))
				local new3 = ColorSequenceKeypoint.new
				local color3 = Color3.fromRGB
				tbl10[1] = v20
				tbl10[2] = v21

				do
					local values = table.pack(new3(1, color3(184, 0, 18)))
					table.move(values, 1, values.n, 3, tbl10)
				end

				tbl9.Text = colorSequence3(tbl10)
				local colorSequence4 = ColorSequence.new
				local tbl11 = {}
				local v22 = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
				local v23 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
				local new4 = ColorSequenceKeypoint.new
				local color4 = Color3.fromRGB
				tbl11[1] = v22
				tbl11[2] = v23

				do
					local values = table.pack(new4(1, color4(18, 0, 3)))
					table.move(values, 1, values.n, 3, tbl11)
				end

				tbl9.Stroke = colorSequence4(tbl11)
				brainrotNameTiers[1] = tbl4
				brainrotNameTiers[2] = tbl5
				brainrotNameTiers[3] = tbl6
				brainrotNameTiers[4] = tbl9
			end

			chilliGithubFastManualDefaultsRu.BrainrotNameTiers = brainrotNameTiers

			chilliGithubFastManualDefaultsRu.BrainrotNameTier = function(arg)
				local n10 = tonumber(arg) or 0

				for _, brainrotNameTier in ipairs(chilliGithubFastManualDefaultsRu.BrainrotNameTiers) do
					if n10 < brainrotNameTier.Limit then
						return brainrotNameTier
					end
				end

				return chilliGithubFastManualDefaultsRu.BrainrotNameTiers[#chilliGithubFastManualDefaultsRu.BrainrotNameTiers]
			end

			chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle = function(parent)
				parent.TextColor3 = Color3.fromRGB(255, 255, 255)
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(255, 255, 255)
				uiStroke.Thickness = 1.15
				uiStroke.Transparency = 0.08
				uiStroke.Parent = parent
				local uiGradient = Instance.new("UIGradient")
				uiGradient.Rotation = 90
				uiGradient.Parent = uiStroke
				local uiGradient2 = Instance.new("UIGradient")
				uiGradient2.Rotation = 90
				uiGradient2.Parent = parent
				return { Label = parent, Outline = uiStroke, Text = uiGradient2, Stroke = uiGradient }
			end

			chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle = function(arg, arg2)
				if not arg then
					return
				end

				if tonumber(arg2) == nil then
					arg.Label.TextColor3 = Color3.fromRGB(238, 238, 242)
					arg.Outline.Color = Color3.fromRGB(0, 0, 0)
					arg.Outline.Transparency = 0.28
					arg.Text.Enabled = false
					arg.Stroke.Enabled = false
					return
				end

				local v16 = chilliGithubFastManualDefaultsRu.BrainrotNameTier(arg2)
				arg.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				arg.Outline.Transparency = 0.08
				arg.Text.Enabled = true
				arg.Stroke.Enabled = true
				arg.Text.Color = v16.Text
				arg.Stroke.Color = v16.Stroke
			end

			do
				local n10 = 0.5
				local obj2 = setmetatable({}, { __mode = "k" })

				local function fn25(arg)
					local v16 = fn23(arg)
					if not v16 then
						return false
					end

					if fn22(v16.Name) == "lucky block" then
						return true
					end

					for _, descendant in ipairs(v16:GetDescendants()) do
						if descendant:IsA("TextLabel") and fn22(descendant.Name) == "stolen" and descendant.Visible and fn22(descendant.Text) == "fusing" then
							return true
						end
					end

					return false
				end

				fn7 = function(arg)
					local now = os.clock()
					local v16 = obj2[arg]
					if v16 and now < v16.ExpiresAt then
						return v16.Value
					end
					local v17 = fn25(arg)

					if v16 then
						v16.Value = v17
						v16.ExpiresAt = now + n10
					else
						obj2[arg] = { Value = v17, ExpiresAt = now + n10 }
					end

					return v17
				end
			end

			fn8 = function(arg)
				local n10 = tonumber(arg) or 0
				if n10 >= 1e9 then
					return string.format("%.2fB/s", n10 / 1e9)
				end

				if n10 >= 1000000 then
					return string.format("%.2fM/s", n10 / 1000000)
				end

				if n10 >= 1000 then
					return string.format("%.1fK/s", n10 / 1000)
				end
				return string.format("%d/s", math.floor(n10))
			end

			do
				local function fn25(arg)
					if not arg or arg == "" then
						return nil
					end
					local match, v16 = arg:gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")

					if match then
						local n10 = tonumber(match) or 0
						local str3 = v16:upper()

						if str3 == "K" then
							n10 *= 1000
						elseif str3 == "M" then
							n10 *= 1000000
						elseif str3 == "B" then
							n10 *= 1e9
						elseif str3 == "T" then
							n10 *= 1e12
						end

						return n10
					end

					return nil
				end

				local function fn26(arg, arg2, arg3, arg4)
					local v16 = fn24(arg3)
					arg = arg and arg.Position
					if not arg then
						return v16
					end
					local v17 = arg4 and arg4[arg3]
					local overhead = nil

					if v17 then
						local v18, v19, v20 = ipairs(arg4[arg3])
						local n10 = 14
						overhead = nil

						for _, v21 in v18, v19, v20 do
							local magnitude = (v21.Position - arg).Magnitude

							if magnitude < n10 then
								overhead = v21.Overhead
								n10 = magnitude
							end
						end
					end

					local v18 = nil

					if arg2 then
						local v19, v20, v21 = ipairs(arg2:GetChildren())
						local n10 = 14
						v18 = nil

						for _, v22 in v19, v20, v21 do
							if v22:IsA("Model") and v22.Name == arg3 then
								local rootPart = v22:FindFirstChild("RootPart") or v22.PrimaryPart or v22:FindFirstChildWhichIsA("BasePart")

								if rootPart then
									local magnitude = (rootPart.Position - arg).Magnitude

									if magnitude < n10 then
										n10 = magnitude
										v18 = v22
									end
								end
							end
						end
					end

					local text

					if overhead and overhead:FindFirstChild("Mutation") and overhead.Mutation.Visible and overhead.Mutation.Text ~= "" then
						text = overhead.Mutation.Text
					else
						text = nil

						if v18 then
							local attribute = v18:GetAttribute("Mutation") or v18:GetAttribute("__mutation")
							local flag8 = attribute and tostring(attribute) ~= ""
							text = nil

							if flag8 then
								text = tostring(attribute)
							end
						end
					end

					local tbl6 = {}
					local tbl7 = {}

					if v18 then
						for _, child in ipairs(v18:GetChildren()) do
							local match = child.Name:match("^_Trait%.(.+)$")

							if match and not tbl7[match] then
								tbl7[match] = true
								table.insert(tbl6, match)
							end
						end

						local attribute = v18:GetAttribute("Trait") or v18:GetAttribute("Traits")

						if attribute then
							local str3 = tostring(attribute)

							if not tbl7[str3] then
								tbl7[str3] = true
								table.insert(tbl6, str3)
							end
						end
					end

					local v19 = text and v14 and v14[text]
					local n10 = 1

					if v19 then
						n10 = 1 + (tonumber(v14[text].Modifier) or 0)
					end

					local flag8 = false

					if v15 then
						for _, v20 in ipairs(tbl6) do
							local v21 = v15[v20] or v15[v20:gsub("_", " ")]

							if v21 then
								if v20 == "Sleepy" or v21.Name == "Sleepy" then
									flag8 = true
								else
									n10 += tonumber(v21.MultiplierModifier) or 0
								end
							end
						end
					end

					local v20 = math.round(v16 * n10 * (flag8 and 0.5 or 1))
					local v21 = fn25(overhead and overhead:FindFirstChild("Generation") and overhead.Generation.Text)
					if v21 and v21 > v20 then
						return v21
					end
					return v20 > 0 and v20 or v21 or v16
				end

				fn9 = function(arg)
					local now = os.clock()
					if not arg and now - n7 < n8 then
						return
					end
					n7 = now
					local tbl6 = {}
					local plots = Workspace:FindFirstChild("Plots")
					if not plots then
						tbl3 = tbl6
						return
					end
					local debris = Workspace:FindFirstChild("Debris")
					local tbl7 = {}

					if debris then
						for _, child in ipairs(debris:GetChildren()) do
							if child.Name == "FastOverheadTemplate" and child:IsA("BasePart") then
								local animalOverhead = child:FindFirstChild("AnimalOverhead")
								local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")

								if displayName and displayName:IsA("TextLabel") and displayName.Text ~= "" then
									local text = displayName.Text
									tbl7[text] = tbl7[text] or {}
									table.insert(tbl7[text], { Position = child.Position, Overhead = animalOverhead })
								end
							end
						end
					end

					for _, child in ipairs(plots:GetChildren()) do
						local animalPodiums = child:FindFirstChild("AnimalPodiums")

						if animalPodiums then
							for _, child2 in ipairs(animalPodiums:GetChildren()) do
								local base = child2:FindFirstChild("Base")
								base = base and base:FindFirstChild("Spawn")

								if base and base:IsA("BasePart") then
									local promptAttachment = base:FindFirstChild("PromptAttachment")
									local v16 = ipairs
									promptAttachment = promptAttachment or base
									local v17 = nil

									for _, descendant in v16(promptAttachment:GetDescendants()) do
										if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == str then
											v17 = descendant
											break
										else
											v17 = nil
										end
									end

									if v17 then
										local str3 = tostring(v17.ObjectText or "")

										tbl6[#tbl6 + 1] = {
											Prompt = v17,
											Plot = child,
											Spawn = base,
											Name = str3,
											Generation = fn26(base, child, str3, tbl7),
										}
									end
								end
							end
						end
					end

					tbl3 = tbl6
				end
			end

			local n10
			n10 = 0.03
			local n11
			n11 = -math.huge
			local v16
			v16 = nil
			local v17
			v17 = nil
			local v18
			v18 = nil
			local v19
			v19 = nil
			local v20
			v20 = nil
			local v21
			v21 = nil
			local fn25

			fn25 = function(arg, arg2, distance, generation)
				local tbl6 = { Prompt = arg.Prompt, Plot = arg.Plot, Position = arg2 }
				local name = arg.Name
				local name2

				if name then
					name2 = name
				else
					name2 = tostring(arg.Prompt.ObjectText or "")
				end

				tbl6.Name = name2
				tbl6.Generation = generation
				tbl6.Distance = distance
				return tbl6
			end

			prompt2 = nil

			fn10 = function(arg)
				if not arg then
					return nil
				end

				for _, v22 in ipairs(tbl3) do
					if v22.Prompt == arg then
						return v22
					end
				end

				return nil
			end

			fn11 = function(arg)
				if not (prompt2 and prompt2.Parent and arg) then
					return nil
				end
				local v22 = fn10(prompt2)
				if not v22 then
					return nil
				end
				local position = v22.Spawn.Position
				return fn25(v22, position, (arg.Position - position).Magnitude, v22.Generation or 0)
			end

			fn12 = function(arg, arg2, arg3, arg4)
				if flag4 then
					arg2 = arg4 or arg2
					if arg2 and arg2.Distance <= n3 then
						return arg2
					end
					return nil
				end

				local v22 = fn11(arg)
				if v22 then
					return v22
				end
				return arg3
			end

			str2 = "Default (Chilli Hub)"
			fn13 = nil
			fn14 = nil
			screenGui = Instance.new("ScreenGui")
			screenGui.Name = "ChilliMacLibTargetGui"
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.Enabled = false

			pcall(function()
				screenGui.Parent = type(gethui) == "function" and gethui() or CoreGui
			end)

			do
				local frame3 = Instance.new("Frame")
				frame3.Name = "TargetCard"
				frame3.AnchorPoint = Vector2.new(0.5, 0)
				frame3.Position = UDim2.new(0.5, 0, 0, 72)
				frame3.Size = UDim2.fromOffset(270, 48)
				frame3.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
				frame3.BackgroundTransparency = 0.15
				frame3.BorderSizePixel = 0
				frame3.Parent = screenGui
				Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 10)
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(58, 255, 55)
				uiStroke.Thickness = 1.2
				uiStroke.Transparency = 0.3
				uiStroke.Parent = frame3
				local textLabel3 = Instance.new("TextLabel")
				textLabel3.BackgroundTransparency = 1
				textLabel3.Position = UDim2.fromOffset(12, 5)
				textLabel3.Size = UDim2.new(1, -24, 0, 14)
				textLabel3.Font = Enum.Font.GothamBold
				textLabel3.TextSize = 11
				textLabel3.TextColor3 = Color3.fromRGB(58, 255, 55)
				textLabel3.TextXAlignment = Enum.TextXAlignment.Left
				textLabel3.Text = "AUTO STEAL (MAC LIB) - MỤC TIÊU GẦN NHẤT"
				textLabel3.Parent = frame3
				local textLabel4 = Instance.new("TextLabel")
				textLabel4.BackgroundTransparency = 1
				textLabel4.Position = UDim2.fromOffset(12, 22)
				textLabel4.Size = UDim2.new(1, -24, 0, 20)
				textLabel4.Font = Enum.Font.GothamBlack
				textLabel4.TextSize = 13
				textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
				textLabel4.TextXAlignment = Enum.TextXAlignment.Left
				textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel4.Text = "Đang quét tìm brainrot gần nhất..."
				textLabel4.Parent = frame3
				local flag8 = false
				local v22 = nil
				local vector2 = Vector2.new(0, 0)
				local position = nil

				fn4(frame3.InputBegan:Connect(function(input)
					local v23 = flag8
					local flag9

					if flag8 then
						flag9 = v23
					else
						flag9 = input.UserInputState ~= Enum.UserInputState.Begin
					end

					if flag9 then
						return
					end
					local flag10 = input.UserInputType == Enum.UserInputType.Touch
					if not (input.UserInputType == Enum.UserInputType.MouseButton1) and not flag10 then
						return
					end
					local vector22 = Vector2.new(input.Position.X, input.Position.Y)
					if not fn21(frame3, vector22) then
						return
					end
					flag8 = true
					v22 = flag10 and input or nil
					vector2 = vector22
					position = frame3.Position
				end))

				fn4(UserInputService2.InputChanged:Connect(function(input)
					if not flag8 or not position then
						return
					end

					if v22 and input == v22 or not v22 and input.UserInputType == Enum.UserInputType.MouseMovement then
						local n12 = Vector2.new(input.Position.X, input.Position.Y) - vector2
						frame3.Position = UDim2.new(position.X.Scale, position.X.Offset + n12.X, position.Y.Scale, position.Y.Offset + n12.Y)
					end
				end))

				fn4(UserInputService2.InputEnded:Connect(function(input)
					if not flag8 then
						return
					end

					if v22 and input == v22 or not v22 and input.UserInputType == Enum.UserInputType.MouseButton1 then
						flag8 = false
						v22 = nil
						position = nil
					end
				end))

				fn15 = function(arg)
					if not screenGui.Parent then
						return
					end

					if not (str2 and string.find(str2, "Mac")) then
						screenGui.Enabled = false
						return
					end
					screenGui.Enabled = true

					if arg and arg.Name then
						local str3 = arg.Distance and string.format("%.1fm", arg.Distance) or ""
						local str4 = arg.Generation and arg.Generation > 0 and " | " .. fn8(arg.Generation) or ""
						textLabel4.Text = string.format("%s (%s)%s", tostring(arg.Name), str3, str4)
					else
						textLabel4.Text = "Đang quét tìm brainrot gần nhất..."
					end
				end
			end

			fn16 = function(arg)
				fn15(arg)
			end

			do
				local function fn26(arg)
					local match, v22 = tostring(arg or ""):match("%$?([%d%.]+)%s*([KMB]?)")
					if not match then
						return 0
					end
					local n12 = tonumber(match) or 0

					if v22 == "K" then
						n12 *= 1000
					elseif v22 == "M" then
						n12 *= 1000000
					elseif v22 == "B" then
						n12 *= 1e9
					end

					return n12
				end

				local function fn27()
					local name = localPlayer.Name
					local displayName = localPlayer.DisplayName
					local plots = Workspace:FindFirstChild("Plots")
					if not plots then
						return nil
					end

					for _, child in ipairs(plots:GetChildren()) do
						local plotSign = child:FindFirstChild("PlotSign")

						if plotSign then
							local surfaceGui = plotSign:FindFirstChild("SurfaceGui")

							if surfaceGui then
								local frame3 = surfaceGui:FindFirstChild("Frame")

								if frame3 then
									local textLabel3 = frame3:FindFirstChildOfClass("TextLabel")

									if textLabel3 and type(textLabel3.Text) == "string" then
										local text = textLabel3.Text
										if string.find(text, displayName, 1, true) or string.find(text, name, 1, true) then
											return child
										end
										continue
									end

									continue
								end
							end
						end
					end

					return nil
				end

				local function fn28(arg)
					if not (arg and arg:IsA("Model")) then
						return nil
					end

					for _, descendant in ipairs(arg:GetDescendants()) do
						if descendant:IsA("TextLabel") then
							local v22 = string.lower(descendant.Name)
							if v22 == "generation" or v22 == "gen" or v22:find("generation") or v22:find("gen") then
								return descendant
							end
						end
					end

					return nil
				end

				fn17 = function(arg)
					if not arg then
						return nil, nil, 0
					end
					local position = arg.Position
					local v22 = nil
					local v23 = nil
					local n12 = -math.huge
					local huge = math.huge
					local n13 = 0

					local function fn29(arg2, arg3, arg4, arg5)
						if not (arg2 and arg2.Parent) then
							return
						end

						if tostring(arg2.ActionText) ~= str then
							return
						end

						if fn7(arg2) then
							return
						end

						if not arg4 then
							arg4 = tostring(arg2.ObjectText or "")
						end

						if type(arg5) ~= "number" then
							local flag8 = type(arg5) == "string" and arg5 ~= ""
							local n14 = 0

							if flag8 then
								arg5 = fn26(arg5)
							else
								arg5 = n14
							end
						end

						if arg5 == 0 then
							arg5 = fn24(arg4)
						end

						if n2 and n2 > 1000 and arg5 > 0 and arg5 < n2 then
							return
						end
						n13 += 1
						local magnitude = (position - arg3).Magnitude

						if magnitude <= n3 then
							local tbl6 = {
								Prompt = arg2,
								Spawn = { Position = arg3 },
								Position = arg3,
								Name = arg4,
								Generation = arg5,
								Distance = magnitude,
							}

							if not v22 or arg5 > n12 then
								v22 = tbl6
								n12 = arg5
							end

							if not v23 or magnitude < huge then
								v23 = tbl6
								huge = magnitude
							end
						end
					end

					local plots = Workspace:FindFirstChild("Plots")
					local n14 = 0

					if n9 then
						n14 = os.clock() < n9
					end

					if plots and not n14 then
						local v24 = fn27()

						for _, child in ipairs(plots:GetChildren()) do
							if child ~= v24 then
								local animalPodiums = child:FindFirstChild("AnimalPodiums")

								if animalPodiums then
									for _, child2 in ipairs(animalPodiums:GetChildren()) do
										local base = child2:FindFirstChild("Base")
										local spawn = base and base:FindFirstChild("Spawn")

										if spawn and spawn:IsA("BasePart") then
											local promptAttachment = spawn:FindFirstChild("PromptAttachment") or spawn
											local v25 = nil

											for _, descendant in ipairs(promptAttachment:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == str then
													v25 = descendant
													break
												else
													v25 = nil
												end
											end

											if v25 then
												local str3 = tostring(v25.ObjectText or "")
												local attachment = spawn:FindFirstChild("Attachment")
												attachment = attachment and attachment:FindFirstChild("AnimalOverhead")
												local str4 = ""

												if attachment then
													local generation = attachment:FindFirstChild("Generation")

													if generation and generation:IsA("TextLabel") then
														str4 = generation.Text
													end
												end

												if str4 == "" and str3 ~= "" then
													local v26 = child:FindFirstChild(str3) or child:FindFirstChild(str3, true)

													if v26 and v26:IsA("Model") then
														local v27 = fn28(v26)

														if v27 then
															str4 = v27.Text
														end
													end
												end

												fn29(v25, spawn.Position, str3, str4, child.Name, tostring(i))
											end
										end
									end
								end
							end
						end
					end

					local debris = Workspace:FindFirstChild("Debris")

					if debris then
						for _, child in ipairs(debris:GetChildren()) do
							local v24 = string.lower(child.Name or "")

							if v24 ~= "lucky block" and v24 ~= "camera" and not child:IsA("Camera") then
								local v25 = nil

								for _, descendant in ipairs(child:GetDescendants()) do
									if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == str then
										v25 = descendant
										break
									else
										v25 = nil
									end
								end

								if v25 then
									local position2 = child:IsA("BasePart") and child.Position or child:IsA("Model") and child.PrimaryPart and child.PrimaryPart.Position or v25.Parent and v25.Parent:IsA("BasePart") and v25.Parent.Position

									if position2 then
										local str3 = ""

										if child:IsA("Model") then
											local v26 = fn28(child)

											if v26 then
												str3 = v26.Text
											end
										end

										fn29(v25, position2, tostring(v25.ObjectText or child.Name), str3, nil, nil)
									end
								end
							end
						end
					end

					for _, player in ipairs(Players:GetPlayers()) do
						if player.Character then
							local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

							if humanoidRootPart then
								for _, descendant in ipairs(player.Character:GetDescendants()) do
									if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == str then
										fn29(descendant, humanoidRootPart.Position, tostring(descendant.ObjectText or "Carried Brainrot"), "", nil, nil)
									end
								end
							end
						end
					end

					return v22, v23, n13
				end
			end

			fn18 = function(arg)
				if not arg then
					return nil, nil, nil, nil, 0
				end
				local now = os.clock()
				local position = arg.Position
				if now - n11 < n10 and v16 and (position - v16).Magnitude < 0.5 then
					return v17, v18, v19, v20, v21
				end
				fn9(false)
				local n12 = 0
				local v22 = nil
				local v23 = nil
				local v24 = nil
				local v25 = nil
				local v26 = nil
				local v27 = nil
				local v28 = nil
				local v29 = nil

				for _, v30 in ipairs(tbl3) do
					local prompt3 = v30.Prompt

					if prompt3.Parent and prompt3.Enabled and tostring(prompt3.ActionText) == str and not fn7(prompt3) then
						local generation = v30.Generation or 0
						local v31 = flag4
						local flag8

						if flag4 then
							flag8 = v31
						else
							flag8 = generation >= n2
						end

						if flag8 then
							n12 += 1
							local position2 = v30.Spawn.Position
							local magnitude = (position - position2).Magnitude

							if not v22 or generation > v23 then
								v22 = fn25(v30, position2, magnitude, generation)
								v23 = generation
							end

							if not v24 or magnitude < v25 then
								v24 = fn25(v30, position2, magnitude, generation)
								v25 = magnitude
							end

							if magnitude <= n3 then
								if not v26 or generation > v27 then
									v26 = fn25(v30, position2, magnitude, generation)
									v27 = generation
								end

								if not v28 or magnitude < v29 then
									v28 = fn25(v30, position2, magnitude, generation)
									v29 = magnitude
								end
							end
						end
					end
				end

				n11 = now
				v16 = position
				v17 = v26
				v18 = v28
				v19 = v22
				v20 = v24
				v21 = n12
				return v26, v28, v22, v24, n12
			end

			fn19 = function(arg)
				if not arg or not arg:IsA("ProximityPrompt") or not arg.Parent or type(getconnections) ~= "function" then
					return nil
				end
				local tbl6 = {}
				local tbl7 = {}

				if not pcall(function()
					for _, v22 in pairs(getconnections(arg.PromptButtonHoldBegan)) do
						if v22 and v22.Function then
							tbl6[#tbl6 + 1] = v22.Function
						end
					end

					for _, v22 in pairs(getconnections(arg.Triggered)) do
						if v22 and v22.Function then
							tbl7[#tbl7 + 1] = v22.Function
						end
					end
				end) or #tbl7 == 0 then
					return nil
				end

				return tbl6, tbl7
			end

			do
				local v22 = CoreGui

				pcall(function()
					if type(gethui) == "function" then
						local hui = gethui()

						if typeof(hui) == "Instance" then
							v22 = hui
						end
					end
				end)

				local chilliAutoGetBarGui = v22:FindFirstChild("ChilliAutoGetBarGui")

				if chilliAutoGetBarGui then
					pcall(function()
						chilliAutoGetBarGui:Destroy()
					end)
				end

				screenGui2 = Instance.new("ScreenGui")
				screenGui2.Name = "ChilliAutoGetBarGui"
				screenGui2.ResetOnSpawn = false
				screenGui2.IgnoreGuiInset = true
				screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				screenGui2.Enabled = false
				screenGui2.Parent = v22
			end

			local color
			color = Color3.fromRGB(58, 255, 55)
			local color2
			color2 = Color3.fromRGB(20, 109, 0)
			local createUIGradient

			do
				local gothamBold = Enum.Font.GothamBold

				pcall(function()
					gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
				end)

				local function fn26(arg)
					if typeof(gothamBold) == "Font" then
						arg.FontFace = gothamBold
					else
						arg.Font = Enum.Font.GothamBold
					end
				end

				createUIGradient = function(parent, arg, arg2)
					local uiGradient = Instance.new("UIGradient")
					local new = ColorSequenceKeypoint.new
					uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, arg), new(1, arg2) })
					uiGradient.Rotation = 90
					uiGradient.Parent = parent
					return uiGradient
				end

				frame = Instance.new("Frame")
				frame.Name = "Holder"
				frame.AnchorPoint = Vector2.new(0.5, 0)
				frame.Position = UDim2.new(0.5, 0, 0, 10)
				frame.Size = UDim2.fromOffset(248, 46)
				frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
				frame.BackgroundTransparency = 0.28
				frame.BorderSizePixel = 0
				frame.Parent = screenGui2
				Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(255, 255, 255)
				uiStroke.Thickness = 1
				uiStroke.Transparency = 0.93
				uiStroke.Parent = frame
				local n12 = 0.125
				local n13 = 248
				local n14 = 1
				local uiScale = Instance.new("UIScale")
				uiScale.Parent = frame

				local function fn27()
					local currentCamera = Workspace.CurrentCamera
					local viewportSize = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)

					if viewportSize.X < 1 then
						viewportSize = Vector2.new(1280, 720)
					end

					uiScale.Scale = math.clamp(viewportSize.X * n12 * n14 / n13, 0.6, 1.4)
				end

				fn27()
				local currentCamera = Workspace.CurrentCamera

				if currentCamera then
					fn4(currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn27))
				end

				fn4(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(fn27))
				textLabel = Instance.new("TextLabel")
				textLabel.BackgroundTransparency = 1
				textLabel.Position = UDim2.fromOffset(14, 8)
				textLabel.Size = UDim2.new(1, -104, 0, 15)
				textLabel.TextSize = 13
				textLabel.TextScaled = true
				textLabel.TextXAlignment = Enum.TextXAlignment.Left
				textLabel.TextTruncate = Enum.TextTruncate.None
				textLabel.TextColor3 = Color3.fromRGB(238, 238, 242)
				textLabel.Text = ""
				fn26(textLabel)
				textLabel.Parent = frame
				local uiTextSizeConstraint = Instance.new("UITextSizeConstraint")
				uiTextSizeConstraint.MinTextSize = 8
				uiTextSizeConstraint.MaxTextSize = 13
				uiTextSizeConstraint.Parent = textLabel
				chilliGithubFastManualDefaultsRu.AutoStealBarNameStyle = chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle(textLabel)
				textLabel2 = Instance.new("TextLabel")
				textLabel2.BackgroundTransparency = 1
				textLabel2.AnchorPoint = Vector2.new(1, 0)
				textLabel2.Position = UDim2.new(1, -14, 0, 8)
				textLabel2.Size = UDim2.fromOffset(88, 15)
				textLabel2.TextSize = 13
				textLabel2.TextXAlignment = Enum.TextXAlignment.Right
				textLabel2.TextColor3 = color
				textLabel2.Text = ""
				fn26(textLabel2)
			end

			textLabel2.Parent = frame
			local frame3 = Instance.new("Frame")
			frame3.Position = UDim2.fromOffset(14, 30)
			frame3.Size = UDim2.new(1, -28, 0, 6)
			frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame3.BackgroundTransparency = 0.88
			frame3.BorderSizePixel = 0
			frame3.Parent = frame
			Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
			frame2 = Instance.new("Frame")
			frame2.Size = UDim2.new(0, 0, 1, 0)
			frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame2.BorderSizePixel = 0
			frame2.Parent = frame3
			Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
			createUIGradient(frame2, color, color2)
		end

		local frame3, visible, flag8, n8, n9, n10, n11, fn20, fn21, v13
		local fn22, fn23, fn24

		do
			local frame4 = Instance.new("Frame")
			frame4.Position = UDim2.fromOffset(14, 41)
			frame4.Size = UDim2.new(1, -28, 0, 4)
			frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame4.BackgroundTransparency = 0.9
			frame4.BorderSizePixel = 0
			frame4.Visible = false
			frame4.Parent = frame
			Instance.new("UICorner", frame4).CornerRadius = UDim.new(1, 0)
			frame3 = Instance.new("Frame")
			frame3.Size = UDim2.new(0, 0, 1, 0)
			frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame3.BackgroundTransparency = 0.55
			frame3.BorderSizePixel = 0
			frame3.Parent = frame4
			Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
			visible = false
			flag8 = false
			n8 = 0
			n9 = 1
			n10 = 0
			n11 = 0

			fn20 = function()
				flag8 = false
			end

			fn21 = function(arg)
				if not flag5 or not screenGui2.Parent then
					flag8 = false
					return
				end
				n9 = math.max(tonumber(arg) or 1, 0.01)
				n8 = os.clock()
				flag8 = true
			end

			local n12 = 0.22
			local n13 = 10
			local color = Color3.fromRGB(255, 255, 255)
			v13 = nil
			local v14 = nil
			local radius = 0

			fn22 = function()
				if connection then
					connection:Disconnect()
					connection = nil
				end

				if v14 then
					pcall(function()
						v14:Destroy()
					end)

					v14 = nil
				end

				if v13 then
					pcall(function()
						v13:Destroy()
					end)

					v13 = nil
				end

				radius = 0
			end

			local function fn25()
				if v13 and v13.Parent and v14 then
					return
				end
				fn22()
				local part = Instance.new("Part")
				part.Name = fn()
				part.Anchored = true
				part.CanCollide = false
				part.CanQuery = false
				part.CanTouch = false
				part.CastShadow = false
				part.Massless = true
				part.Size = Vector3.one
				part.Transparency = 1
				part.Parent = Workspace
				local cylinderHandleAdornment = Instance.new("CylinderHandleAdornment")
				cylinderHandleAdornment.Name = fn()
				cylinderHandleAdornment.Adornee = part
				cylinderHandleAdornment.AlwaysOnTop = true
				cylinderHandleAdornment.Color3 = color
				cylinderHandleAdornment.Height = 0.05
				cylinderHandleAdornment.InnerRadius = 0
				cylinderHandleAdornment.Radius = 0
				cylinderHandleAdornment.Transparency = 0.25
				cylinderHandleAdornment.ZIndex = 1
				cylinderHandleAdornment.Parent = part
				v13 = part
				v14 = cylinderHandleAdornment
			end

			fn23 = function(arg)
				local character_ = localPlayer.Character
				character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

				if not visible or not character_ then
					if v13 then
						fn22()
					end

					return
				end

				fn25()
				local n14 = math.max(tonumber(n3) or 20, 1)
				local n15 = math.min(arg or 0.016, 0.1)

				if radius <= 0 then
					radius = n14
				else
					radius += (n14 - radius) * (1 - math.exp(-n15 * n13))
				end

				v13.CFrame = CFrame.new(character_.Position - Vector3.new(0, 2.9, 0)) * CFrame.Angles(-1.5707963267948966, 0, 0)
				v14.Radius = radius
				v14.InnerRadius = math.max(radius - n12, 0)
			end

			fn24 = function(arg)
				visible = arg == true
				frame4.Visible = visible
				frame.Size = UDim2.fromOffset(248, visible and 55 or 46)

				if not visible then
					n11 = 0
					frame3.Size = UDim2.new(0, 0, 1, 0)
					fn22()
				end
			end
		end

		local fn25

		fn25 = function(arg, arg2, arg3)
			if textLabel.Parent then
				textLabel.Text = tostring(arg or "")
				chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle(chilliGithubFastManualDefaultsRu.AutoStealBarNameStyle, arg3)
			end

			if textLabel2.Parent then
				textLabel2.Text = tostring(arg2 or "")
			end
		end

		do
			local flag9 = false
			local v14 = nil
			local vector2 = Vector2.new(0, 0)
			local position = nil

			fn4(frame.InputBegan:Connect(function(input)
				if flag9 or input.UserInputState ~= Enum.UserInputState.Begin then
					return
				end
				local flag10 = input.UserInputType == Enum.UserInputType.Touch
				if not (input.UserInputType == Enum.UserInputType.MouseButton1) and not flag10 then
					return
				end
				local vector22 = Vector2.new(input.Position.X, input.Position.Y)
				local absolutePosition = frame.AbsolutePosition
				local absoluteSize = frame.AbsoluteSize
				if vector22.X < absolutePosition.X or vector22.X > absolutePosition.X + absoluteSize.X or vector22.Y < absolutePosition.Y or vector22.Y > absolutePosition.Y + absoluteSize.Y then
					return
				end
				flag9 = true
				v14 = flag10 and input or nil
				vector2 = vector22
				position = frame.Position
			end))

			fn4(UserInputService2.InputChanged:Connect(function(input)
				if not flag9 then
					return
				end

				if not (v14 and input == v14 or not v14 and input.UserInputType == Enum.UserInputType.MouseMovement) or not position then
					return
				end
				local n12 = Vector2.new(input.Position.X, input.Position.Y) - vector2
				frame.Position = UDim2.new(position.X.Scale, position.X.Offset + n12.X, position.Y.Scale, position.Y.Offset + n12.Y)
			end))

			fn4(UserInputService2.InputEnded:Connect(function(input)
				if not flag9 then
					return
				end
				local flag10 = v14 and input == v14
				local flag11

				if flag10 then
					flag11 = flag10
				else
					flag11 = not v14 and input.UserInputType == Enum.UserInputType.MouseButton1
				end

				if flag11 then
					flag9 = false
					v14 = nil
					position = nil
				end
			end))
		end

		local fn26

		fn26 = function()
			if screenGui2.Parent then
				screenGui2.Enabled = flag3 and flag5
			end

			if not flag3 or not flag5 then
				fn20()
				fn25("", "")
			end
		end

		do
			local n12 = 1
			local n13 = 0.25
			local n14 = -math.huge
			local n15 = -math.huge

			local function fn27()
				if not flag3 then
					return
				end
				local now = os.clock()
				if now - n14 < n12 then
					return
				end
				n14 = now

				task.spawn(function()
					fn14()
					task.wait(0.05)
					fn13()
				end)
			end

			local function fn28(arg)
				local now = os.clock()
				if now - n15 < n13 then
					return
				end
				n15 = now

				for _, v14 in ipairs(arg) do
					pcall(v14)
				end
			end

			local function fn29(arg)
				if not (arg and arg.Parent) or type(getconnections) ~= "function" then
					return
				end

				pcall(function()
					for _, v14 in pairs(getconnections(arg.PromptButtonHoldEnded)) do
						if v14 and v14.Function then
							pcall(v14.Function)
						end
					end
				end)
			end

			local function fn30(arg, arg2, arg3, arg4, arg5)
				local prompt3 = type(arg) == "table" and arg.Prompt or arg
				local plotName = type(arg) == "table" and arg.PlotName or nil
				local slotName = type(arg) == "table" and arg.SlotName or nil
				if not prompt3 then
					return false, "no prompt"
				end

				if str2 == "Fix 1 (Wait Before Fire)" then
					task.wait(0.1)
				end

				local n16 = os.clock() - n6
				local n17 = 0

				if str2 == "Fix 2 (Longer Settle)" then
					n17 = 1.5
				end

				if n16 < n17 then
					task.wait(n17 - n16)
				end

				if not flag2 or not flag3 or arg2 ~= n5 then
					return false, "stopped"
				end
				local v14, v15 = fn19(prompt3)
				if not v14 or not v15 then
					return false, "no handlers"
				end
				local n18 = 1.3

				if flag6 then
					flag6 = false
					n18 = 2
				end

				if arg4 then
					pcall(arg4, n18)
				end

				if str2 == "Xen Hub Source v11" then
					if plotName and slotName then
						local function fn31()
							pcall(function()
								local reB096e1ca9c3a453b8b60268b235083 = game:GetService("ReplicatedStorage").Packages.Net["RE/b096e1ca-9c3a-453b-8b60-268b235083b9"]
								reB096e1ca9c3a453b8b60268b235083:FireServer(Workspace:GetServerTimeNow() + 53, "5c0bd012-dfb2-4bac-8f1a-e41f136e4744")
								reB096e1ca9c3a453b8b60268b235083:FireServer(Workspace:GetServerTimeNow() + 53, "6be28b5b-dbc3-4aab-aa0c-6ebcfa191f22")
							end)
						end

						local function fn32(arg6, arg7)
							pcall(function()
								game:GetService("ReplicatedStorage").Packages.Net["RE/5aa39ea1-0c65-4fcf-aff9-b18a7ef277c3"]:FireServer(Workspace:GetServerTimeNow() + 67, "c262398d-68e3-4499-8bea-99766bf11686", arg6, tonumber(arg7) or arg7)
								local v16
								v16:FireServer(Workspace:GetServerTimeNow() + 67, "579e6c26-5a80-407d-9488-0f84752e8f1f", arg6, tonumber(arg7) or arg7)
							end)
						end

						fn31()
						task.wait(1.3)
						fn32(plotName, slotName)
						return true, "fired xen hub source"
					end

					for _, v16 in ipairs(v14) do
						pcall(v16)
					end

					task.wait(1.3)

					for _, v16 in ipairs(v15) do
						pcall(v16)
					end

					return true, "fired fallback"
				end

				if str2 and string.find(str2, "v20") and localPlayer:GetAttribute("Stealing") == true then
					return false, "v20_radar"
				end

				if str2 and string.find(str2, "v21") then
					local now = os.clock()

					while not prompt3.Enabled and prompt3.Parent and os.clock() - now < 0.6 do
						task.wait(0.02)
					end
				end

				if os.clock() - n6 < 1.5 and str2 and (string.find(str2, "Smart Window") or string.find(str2, "v19") or string.find(str2, "v19")) then
					for _, v16 in ipairs(v14) do
						pcall(v16)
					end

					task.wait(n18)

					for _, v16 in ipairs(v15) do
						pcall(v16)
					end

					n6 = os.clock()
					return true, "fired (v14 protected window)"
				end

				local flag9 = str2 and string.find(str2, "v23")

				if flag9 then
					local v16 = globalCacheLockUntil
					flag9 = os.clock() < v16
				end

				if (isDebris or flag9) and str2 and string.find(str2, "v22") then
					for _, v16 in ipairs(v14) do
						pcall(v16)
					end

					task.wait(n18)

					for _, v16 in ipairs(v15) do
						pcall(v16)
					end

					fn29(prompt3)
					n6 = os.clock()
					return true, "fired (v22 debris cache hold)"
				end

				if str2 == "Fix 4 (FireProximityPrompt)" then
					if fireproximityprompt then
						fireproximityprompt(prompt3, 0)
						fireproximityprompt(prompt3, 1)
					end
				end

				for _, v16 in ipairs(v14) do
					pcall(v16)
				end

				local str3 = tostring(prompt3.ObjectText)
				local now = os.clock()

				while os.clock() - now < n18 do
					task.wait(0.05)
					if not flag2 or not flag3 or arg2 ~= n5 then
						fn29(prompt3)
						return false, "stopped"
					end

					if not arg5 and localPlayer:GetAttribute("Stealing") == true then
						for _, v16 in ipairs(v15) do
							pcall(v16)
						end

						fn29(prompt3)
						return false, "carrying"
					end

					if tostring(prompt3.ObjectText) ~= str3 then
						fn28(v15)
						fn27()
						fn29(prompt3)
						return false, "brainrot changed"
					end

					if not prompt3.Parent or not prompt3.Enabled or not arg3() then
						fn28(v15)
						fn27()
						fn29(prompt3)
						return false, "retargeted"
					end
				end

				local v16

				if str2 == "Default (Chilli Hub)" or str2 == "Fix 3 (Re-fetch Triggers)" then
					local v17
					v17, v16 = fn19(prompt3)
					v16 = v16 or v15
				else
					v16 = v15
				end

				for _, v17 in ipairs(v16) do
					pcall(v17)
				end

				fn29(prompt3)
				n6 = os.clock()
				return true, "fired"
			end

			local function fn31(arg, arg2, arg3)
				if not flag2 or not flag3 or arg2 ~= n5 then
					return false
				end

				if arg3 and localPlayer:GetAttribute("Stealing") ~= true then
					return false
				end
				local character_ = localPlayer.Character
				local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return false
				end

				if flag4 then
					local prompt3 = arg.Prompt
					if not prompt3 or not prompt3.Parent or not prompt3.Enabled or tostring(prompt3.ActionText) ~= str or fn7(prompt3) then
						return false
					end
					local position = arg.Position
					return not position or (humanoidRootPart.Position - position).Magnitude <= n3
				end

				if prompt2 and prompt2.Parent then
					return arg.Prompt == prompt2
				end
				local v14

				if str2 and (string.find(str2, "Mac Lib") or string.find(str2, "Original")) then
					local v15
					v15, v14 = fn17(humanoidRootPart)
				else
					local v15
					v15, v14 = fn18(humanoidRootPart)
				end

				if not v14 then
					return false
				end

				if v14.Prompt == arg.Prompt then
					return true
				end
				return v14.Distance >= (humanoidRootPart.Position - arg.Position).Magnitude - n
			end

			local function fn32(arg)
				local v14 = prompt
				local parent = prompt

				if v14 then
					parent = v14.Parent
				end

				if parent then
					local now = os.clock()

					while flag2 and flag3 and arg == n5 and os.clock() - now < 1 do
						if v14.Enabled and tostring(v14.ActionText) == str then
							return
						end
						task.wait(0.05)
					end
				else
					task.wait(0.2)
				end
			end

			local function fn33(arg)
				local flag9 = false

				while true do
					if flag2 and flag3 and arg == n5 then
						local flag10 = localPlayer:GetAttribute("Stealing") == true

						if not flag9 then
							if str2 and string.find(str2, "v19") then
								task.wait()
							else
								task.wait(0.1)
							end
						end

						local flag11 = not flag2 or not flag3 or arg ~= n5
						flag9 = false

						if not flag11 then
							if not (str2 and string.find(str2, "v20")) and localPlayer:GetAttribute("Stealing") == true then
								flag7 = true
								fn20()

								if flag5 then
									fn25("GET READY - carrying brainrot", "")
								end

								while flag2 and flag3 and arg == n5 and localPlayer:GetAttribute("Stealing") == true do
									if str2 and string.find(str2, "v19") then
										task.wait()
									else
										task.wait(0.05)
									end
								end

								if not (str2 and string.find(str2, "v19")) then
									fn32(arg)
								end

								flag7 = false

								if str2 and string.find(str2, "v19") then
									flag9 = true
								end
							else
								if not (str2 and string.find(str2, "v20")) then
									fn16(nil)
								end

								flag7 = false
								local character_ = localPlayer.Character
								character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

								if not character_ then
									fn20()
								else
									local v14, v15, v16

									if flag4 then
										v14, v15, v16 = fn18(character_)
									else
										v14, v15 = fn17(character_)
										v16 = nil
									end

									local v17 = fn12(character_, v14, v15, v16)
									fn15(v17)

									if not v17 then
										fn20()
									else
										prompt = v17.Prompt

										if not fn30(v17, arg, function()
											return fn31(v17, arg, false)
										end, fn21, false) then
											fn20()
										end
									end
								end
							end

							continue
						end
					end

					break
				end
			end

			fn13 = function()
				n5 += 1
				flag3 = true
				flag7 = false
				n7 = -math.huge
				fn26()
				task.spawn(fn33, n5)
			end
		end

		fn14 = function()
			flag3 = false
			flag7 = false
			n5 += 1
			fn20()
			fn16(nil)
			fn26()
		end

		local n12 = 0

		fn4(localPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
			if localPlayer:GetAttribute("Stealing") == true then
				n6 = os.clock()
				n12 += 1
				local v14 = n12

				task.spawn(function()
					task.wait(1.5)

					if flag3 and localPlayer:GetAttribute("Stealing") == true and n12 == v14 then
						fn14()
						task.wait(0.05)
						fn13()
					end
				end)
			else
				n12 += 1

				if not (os.clock() - n4 < 0.5) then
					local flag9 = false

					if RagdollController then
						local ok, result = pcall(function()
							return RagdollController.IsInRagdoll()
						end)

						if ok and result == true then
							flag9 = true
						end
					end

					if not flag9 then
						local character_ = localPlayer.Character
						character_ = character_ and character_:FindFirstChildOfClass("Humanoid")

						if character_ then
							local state = character_:GetState()

							if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll then
								flag9 = true
							end
						end
					end

					local flag10

					if not flag9 then
						local character_ = localPlayer.Character

						if character_ and character_:FindFirstChildOfClass("BallSocketConstraint", true) then
							flag10 = true
						else
							flag10 = flag9
						end
					else
						flag10 = flag9
					end

					if flag10 then
						flag6 = true
					end
				end
			end
		end))

		fn4(Workspace.ChildAdded:Connect(function(child)
			if child.Name == "Plots" then
				n7 = -math.huge
			end
		end))

		local plots = Workspace:FindFirstChild("Plots")

		if plots then
			fn4(plots.ChildAdded:Connect(function()
				n7 = -math.huge
			end))

			fn4(plots.ChildRemoved:Connect(function()
				n7 = -math.huge
			end))
		end

		local v14

		v14 = v12:CreateToggle({
			Name = "Auto Steal",
			Default = true,
			Callback = function(arg)
				str2 = "Auto Get Default"

				if arg then
					fn13()
				else
					fn14()
				end
			end,
		})

		local fn27

		fn27 = function()
			if v14 and v14.Get and v14:Get() ~= true then
				v14:Set(true, true)
			end
		end

		v12:CreateToggle({
			Name = "Steal Best Brainrot Only",
			Default = false,
			Quick = false,
			SubOf = v14,
			Callback = function(arg)
				flag4 = arg == true
			end,
		})

		do
			local tbl4 = {
				["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
				["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
				["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
			}

			local createSlider = nil
			local n13 = 1
			local str3 = "M/s"

			local function fn28(arg, arg2)
				if arg ~= nil then
					n13 = math.floor(tonumber(arg) or n13)
				end

				if arg2 ~= nil then
					str3 = tostring(arg2)
				elseif createSlider and createSlider.GetUnit then
					local unit = createSlider:GetUnit()

					if unit and unit ~= "" then
						str3 = tostring(unit)
					end
				end

				n2 = n13 * (tbl4[str3] or tbl4["M/s"]).Mult
				n7 = -math.huge
			end

			local function fn29(arg)
				str3 = arg
				local ms = tbl4[arg] or tbl4["M/s"]

				if createSlider and createSlider.SetRange then
					createSlider:SetRange(ms.Min, ms.Max)
					local min = createSlider:Get() or ms.Min
					local min2 = ms.Min
					local max = ms.Max
					local n14 = math.clamp(math.floor(min + 0.5), min2, max)

					if n14 ~= min then
						createSlider:Set(n14)
					else
						fn28(n14, arg)
					end
				else
					fn28(nil, arg)
				end
			end

			createSlider = v12.CreateSlider

			createSlider = createSlider(v12, {
				Name = "Auto Steal Min Value",
				Note = "Filters out Brainrots below this threshold. Tap arrow to change unit (K/s, M/s, B/s).",
				Min = 0,
				Max = 1000,
				Default = 0,
				AllowDecimals = false,
				Increment = 1,
				Unit = {
					Default = "M/s",
					Selector = true,
					Options = { "K/s", "M/s", "B/s" },
					ColorEnabled = true,
					Colors = { Number = Color3.fromRGB(255, 255, 255), Suffix = Color3.fromRGB(58, 255, 55) },
					Callback = function(arg)
						fn29(arg)
					end,
				},
				Quick = false,
				SubOf = v14,
				Callback = function(arg)
					fn28(arg, nil)
				end,
			})
		end

		v12:CreateSlider({
			Name = "Auto Steal Distance",
			Min = 10,
			Max = 200,
			Default = 58,
			AllowDecimals = false,
			Increment = 1,
			Unit = " studs",
			Quick = false,
			SubOf = v14,
			Callback = function(arg)
				n3 = math.clamp(tonumber(arg) or 20, 10, 200)
			end,
		})

		local fn28

		do
			local color = Color3.fromRGB(170, 255, 0)
			local color2 = Color3.fromRGB(240, 255, 210)
			local flag9 = false
			local attachment = nil
			local attachment2 = nil
			local beam = nil
			local v15 = nil
			local v16 = nil
			local n13 = -math.huge

			fn28 = function()
				pcall(function()
					if beam then
						beam:Destroy()
					end
				end)

				pcall(function()
					if attachment then
						attachment:Destroy()
					end
				end)

				pcall(function()
					if attachment2 then
						attachment2:Destroy()
					end
				end)

				beam = nil
				attachment = nil
				attachment2 = nil
				v15 = nil
				v16 = nil
			end

			local function fn29()
				local v17 = Workspace:FindFirstChild(localPlayer.Name)
				if not v17 or not v17:IsA("Model") then
					return nil
				end
				local humanoidRootPart = v17:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart and humanoidRootPart:IsA("BasePart") and humanoidRootPart.Parent == v17 then
					return humanoidRootPart
				end
				local hitbox = v17:FindFirstChild("__HITBOX") or v17:FindFirstChild("__hitbox") or v17:FindFirstChild("Hitbox") or v17:FindFirstChild("HitBox")
				if hitbox and hitbox:IsA("BasePart") then
					return hitbox
				end
				return nil
			end

			local function fn30(parent, parent2)
				fn28()
				if not (parent and parent2) then
					return
				end
				attachment = Instance.new("Attachment")
				attachment.Name = fn()
				attachment.Position = Vector3.new(0, 0.6, 0)
				attachment.Parent = parent
				attachment2 = Instance.new("Attachment")
				attachment2.Name = fn()
				attachment2.Position = Vector3.new(0, 2.6, 0)
				attachment2.Parent = parent2
				beam = Instance.new("Beam")
				beam.Name = fn()
				beam.Archivable = false
				beam.Attachment0 = attachment
				beam.Attachment1 = attachment2
				beam.Color = ColorSequence.new(color, color2)
				beam.CurveSize0 = 0
				beam.CurveSize1 = 0
				beam.FaceCamera = true
				beam.LightEmission = 1
				beam.Segments = 4
				beam.Texture = "rbxassetid://446111271"
				beam.TextureLength = 3
				beam.TextureMode = Enum.TextureMode.Wrap
				beam.TextureSpeed = 3
				local v17 = beam
				local numberSequence = NumberSequence.new
				local tbl4 = {}
				local v18 = NumberSequenceKeypoint.new(0, 0)
				local v19 = NumberSequenceKeypoint.new(0.85, 0)
				tbl4[1] = v18
				tbl4[2] = v19

				do
					local values = table.pack(NumberSequenceKeypoint.new(1, 0.25))
					table.move(values, 1, values.n, 3, tbl4)
				end

				v17.Transparency = numberSequence(tbl4)
				beam.Width0 = 0.34
				beam.Width1 = 0.7
				beam.ZOffset = 0.1
				obj[beam] = true
				beam.Parent = attachment
				v15 = parent
				v16 = parent2
			end

			local function fn31()
				if not (flag9 and flag3) then
					if beam then
						fn28()
					end

					return
				end

				local now = os.clock()
				if now - n13 < 0.1 then
					return
				end
				n13 = now
				local character_ = localPlayer.Character
				local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")
				local v17 = fn29(character_)
				if not (humanoidRootPart and v17) then
					fn28()
					return
				end
				local v18, v19, v20 = fn18(humanoidRootPart)
				local v21 = fn12(humanoidRootPart, v18, v19, v20)
				local spawn = v21 and fn10(v21.Prompt) or nil
				spawn = spawn and spawn.Spawn or nil
				if not spawn then
					fn28()
					return
				end
				local flag10 = v15 ~= v17 or v16 ~= spawn

				if not flag10 then
					flag10 = not (attachment and attachment.Parent)
				end

				if flag10 then
					fn30(v17, spawn)
				end
			end

			fn4(RunService.Heartbeat:Connect(function()
				if flag2 then
					fn31()
				end
			end))

			v12:CreateToggle({
				Name = "Target Beam",
				Note = "Draws a straight amber line to the Brainrot Auto Steal is targeting.",
				Default = true,
				Quick = false,
				SubOf = v14,
				Callback = function(arg)
					flag9 = arg == true

					if not flag9 then
						fn28()
					end
				end,
			})
		end

		local n13
		n13 = 140
		local n14
		n14 = 5
		local n15
		n15 = 0.5
		local color
		color = Color3.fromRGB(58, 255, 55)
		local n16
		n16 = 214
		local n17
		n17 = 40
		local n18
		n18 = 44
		local screenGui3
		screenGui3 = nil
		local v15
		v15 = nil
		local v16
		v16 = nil
		local tbl4
		tbl4 = {}
		local v17
		v17 = nil
		local v18
		v18 = nil
		local flag9, n19, n20, v19, flag10, n21, str3, fn29

		do
			local v20 = nil
			local v21 = nil
			local v22 = nil
			flag9 = false
			n19 = 5
			n20 = 1
			v19 = nil
			flag10 = false
			n21 = -math.huge
			local v23 = nil
			local n22 = -math.huge
			str3 = ""
			local gothamBold = Enum.Font.GothamBold

			pcall(function()
				gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
			end)

			local function fn30(arg)
				if typeof(gothamBold) == "Font" then
					arg.FontFace = gothamBold
				else
					arg.Font = Enum.Font.GothamBold
				end
			end

			local v24 = v2:CreateState({
				Name = "Base Target Panel Position",
				Default = {
					XOffset = 0,
					XScale = 0.78183454275131226,
					YScale = 0.022769367322325706,
					YOffset = 0,
				},
			})

			local function fn31()
				local v25 = v24:Get()
				if type(v25) == "table" and type(v25.XOffset) == "number" and type(v25.YOffset) == "number" then
					return UDim2.new(tonumber(v25.XScale) or 1, v25.XOffset, tonumber(v25.YScale) or 0.5, v25.YOffset)
				end
				return UDim2.new(1, -18, 0.5, 0)
			end

			local function fn32(arg)
				v24:Set({ XScale = arg.X.Scale, XOffset = arg.X.Offset, YScale = arg.Y.Scale, YOffset = arg.Y.Offset })
			end

			local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			local n23 = 0
			local v25 = nil

			local function fn33()
				if not v15 then
					return
				end
				local visible2 = n23 == 0 and not flag9

				if v20 then
					v20.Visible = visible2
					v20.Text = v25 and "no brainrot left in this base" or "no base nearby"
				end

				local n24 = flag9 and 0 or n23
				local n25

				if n24 > 0 then
					n25 = (n17 + 4) * n24 + 4
				else
					n25 = 0

					if visible2 then
						n25 = 26
					end
				end

				local n26 = n18 + n25
				if v21 == n26 then
					return
				end
				v21 = n26

				if v18 then
					if n25 > 0 then
						v18.Visible = true
					end

					TweenService:Create(v18, tweenInfo, { Size = UDim2.new(1, -20, 0, math.max(n25, 1)) }):Play()
				end

				local tween = TweenService:Create(v15, tweenInfo, { Size = UDim2.fromOffset(214, n26) })

				if n25 <= 0 and v18 then
					tween.Completed:Connect(function()
						if v18 and v21 == n26 then
							v18.Visible = false
						end
					end)
				end

				tween:Play()
			end

			fn29 = function()
				table.clear(tbl4)
				v15 = nil
				v16 = nil
				v17 = nil
				v18 = nil
				v20 = nil
				v21 = nil
				v22 = nil
				v19 = nil
				str3 = ""

				if screenGui3 then
					pcall(function()
						screenGui3:Destroy()
					end)

					screenGui3 = nil
				end
			end

			local function fn34(arg, arg2)
				local debris = Workspace:FindFirstChild("Debris")
				if not debris or arg2 == "" then
					return nil
				end
				local v26 = nil
				local v27 = nil

				for _, child in ipairs(debris:GetChildren()) do
					if child.Name == "FastOverheadTemplate" and child:IsA("BasePart") then
						local animalOverhead = child:FindFirstChild("AnimalOverhead")
						local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")

						if displayName and displayName:IsA("TextLabel") and displayName.Text == arg2 then
							local magnitude = (child.Position - arg.Position).Magnitude

							if not v26 or magnitude < v26 then
								v26 = magnitude
								v27 = animalOverhead
							end
						end
					end
				end

				if v27 and v26 and v26 <= 14 then
					return v27
				end
				return nil
			end

			local function fn35(arg, arg2, arg3)
				if not (arg and arg2) or arg3 == "" then
					return nil
				end
				local v26 = nil
				local v27 = nil

				for _, child in ipairs(arg:GetChildren()) do
					if child:IsA("Model") and child.Name == arg3 then
						local ok, result = pcall(function()
							return child:GetPivot()
						end)

						if ok then
							local magnitude = (result.Position - arg2.Position).Magnitude

							if not v26 or magnitude < v26 then
								v27 = child
								v26 = magnitude
							end
						end
					end
				end

				if v27 and v26 and v26 <= 14 then
					return v27
				end
				return nil
			end

			local str4 = ""

			local function fn36(arg, painted)
				if arg.Painted == painted then
					return
				end
				arg.Painted = painted
				local v26 = ipairs
				local tweens = arg.Tweens or {}

				for _, tween in v26(tweens) do
					pcall(function()
						tween:Cancel()
					end)
				end

				local tweens2 = {}
				local tween = TweenService:Create(arg.Accent, tweenInfo, { Size = UDim2.new(0, painted and 3 or 0, 1, -12) })
				local tween2 = TweenService:Create(arg.Stroke, tweenInfo, { Color = painted and color or Color3.fromRGB(255, 255, 255), Transparency = painted and 0.1 or 0.86 })
				local v27 = TweenService
				local create = v27.Create
				local row = arg.Row
				local tbl5 = { BackgroundTransparency = painted and 0.12 or 0.4 }
				local v28 = table.pack(create(v27, row, tweenInfo, tbl5))
				tweens2[1] = tween
				tweens2[2] = tween2

				do
					local values = table.pack(table.unpack(v28, 1, v28.n))
					table.move(values, 1, values.n, 3, tweens2)
				end

				arg.Tweens = tweens2

				for _, tween3 in ipairs(arg.Tweens) do
					tween3:Play()
				end
			end

			local function fn37()
				for _, v26 in ipairs(tbl4) do
					fn36(v26, prompt2 ~= nil and v26.Prompt == prompt2)
				end
			end

			local function fn38(layoutOrder)
				local textButton = Instance.new("TextButton")
				textButton.AutoButtonColor = false
				textButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
				textButton.BackgroundTransparency = 0.3
				textButton.BorderSizePixel = 0
				textButton.LayoutOrder = layoutOrder
				textButton.Size = UDim2.new(1, 0, 0, 40)
				textButton.Text = ""
				textButton.Parent = v16
				Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 9)
				local frame4 = Instance.new("Frame")
				frame4.AnchorPoint = Vector2.new(0, 0.5)
				frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				frame4.BorderSizePixel = 0
				frame4.Position = UDim2.new(0, 0, 0.5, 0)
				frame4.Size = UDim2.new(0, 0, 1, -12)
				frame4.ZIndex = 4
				frame4.Parent = textButton
				Instance.new("UICorner", frame4).CornerRadius = UDim.new(1, 0)
				local uiGradient = Instance.new("UIGradient")
				local new = ColorSequenceKeypoint.new
				local color2 = Color3.fromRGB
				uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 255, 55)), new(1, color2(20, 109, 0)) })
				uiGradient.Rotation = 90
				uiGradient.Parent = frame4
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Thickness = 1.3
				uiStroke.Parent = textButton
				local viewportFrame = Instance.new("ViewportFrame")
				viewportFrame.Ambient = Color3.fromRGB(190, 190, 200)
				viewportFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
				viewportFrame.BackgroundTransparency = 0.25
				viewportFrame.BorderSizePixel = 0
				viewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
				viewportFrame.LightDirection = Vector3.new(-0.4, -0.7, -0.6)
				viewportFrame.Position = UDim2.fromOffset(4, 3)
				viewportFrame.Size = UDim2.fromOffset(n17 - 6, n17 - 6)
				viewportFrame.Parent = textButton
				Instance.new("UICorner", viewportFrame).CornerRadius = UDim.new(0, 8)
				local camera = Instance.new("Camera")
				camera.Parent = viewportFrame
				viewportFrame.CurrentCamera = camera
				local frame5 = Instance.new("Frame")
				frame5.AnchorPoint = Vector2.new(1, 1)
				frame5.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
				frame5.BackgroundTransparency = 0.15
				frame5.BorderSizePixel = 0
				frame5.Position = UDim2.fromOffset(n17 - 3, n17 - 3)
				frame5.Size = UDim2.fromOffset(24, 13)
				frame5.ZIndex = 4
				frame5.Parent = textButton
				Instance.new("UICorner", frame5).CornerRadius = UDim.new(0, 5)
				local textLabel3 = Instance.new("TextLabel")
				textLabel3.BackgroundTransparency = 1
				textLabel3.Size = UDim2.fromScale(1, 1)
				textLabel3.Text = ""
				textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
				textLabel3.TextScaled = true
				textLabel3.ZIndex = 5
				fn30(textLabel3)
				textLabel3.Parent = frame5
				local uiStroke2 = Instance.new("UIStroke")
				uiStroke2.Color = Color3.fromRGB(0, 0, 0)
				uiStroke2.Thickness = 1.4
				uiStroke2.Transparency = 0.25
				uiStroke2.Parent = textLabel3
				local textLabel4 = Instance.new("TextLabel")
				textLabel4.BackgroundTransparency = 1
				textLabel4.Position = UDim2.fromOffset(n17 + 2, 5)
				textLabel4.Size = UDim2.new(1, -n17 - 10, 0, 13)
				textLabel4.Text = ""
				textLabel4.TextColor3 = Color3.fromRGB(238, 238, 242)
				textLabel4.TextScaled = true
				textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel4.TextXAlignment = Enum.TextXAlignment.Left
				fn30(textLabel4)
				textLabel4.Parent = textButton
				local v26 = chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle(textLabel4)
				local textLabel5 = Instance.new("TextLabel")
				textLabel5.BackgroundTransparency = 1
				textLabel5.Position = UDim2.fromOffset(n17 + 2, 20)
				textLabel5.Size = UDim2.fromOffset(62, 11)
				textLabel5.Text = ""
				textLabel5.TextColor3 = Color3.fromRGB(115, 255, 0)
				textLabel5.TextScaled = true
				textLabel5.TextXAlignment = Enum.TextXAlignment.Left
				fn30(textLabel5)
				textLabel5.Parent = textButton
				local textLabel6 = Instance.new("TextLabel")
				textLabel6.BackgroundTransparency = 1
				textLabel6.Position = UDim2.fromOffset(n17 + 66, 20)
				textLabel6.RichText = true
				textLabel6.Size = UDim2.fromOffset(62, 11)
				textLabel6.Text = ""
				textLabel6.TextScaled = true
				textLabel6.TextXAlignment = Enum.TextXAlignment.Left
				fn30(textLabel6)
				textLabel6.Parent = textButton
				local frame6 = Instance.new("Frame")
				frame6.AnchorPoint = Vector2.new(1, 0)
				frame6.BackgroundTransparency = 1
				frame6.Position = UDim2.new(1, -7, 0, 19)
				frame6.Size = UDim2.fromOffset(44, 12)
				frame6.Parent = textButton
				local uiListLayout = Instance.new("UIListLayout")
				uiListLayout.FillDirection = Enum.FillDirection.Horizontal
				uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				uiListLayout.Padding = UDim.new(0, 2)
				uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				uiListLayout.Parent = frame6

				local tbl5 = {
					Row = textButton,
					Accent = frame4,
					Stroke = uiStroke,
					Viewport = viewportFrame,
					Camera = camera,
					Rank = textLabel3,
					NameLabel = textLabel4,
					NameStyle = v26,
					ValueLabel = textLabel5,
					MutationLabel = textLabel6,
					TraitHolder = frame6,
					Prompt = nil,
					RowKey = nil,
					ModelKey = nil,
					Clone = nil,
					Track = nil,
					SourceTrack = nil,
					Painted = nil,
					Tweens = nil,
				}

				fn5(textButton, function()
					if not tbl5.Prompt then
						return
					end

					if prompt2 == tbl5.Prompt then
						prompt2 = nil
						str4 = ""
					else
						prompt2 = tbl5.Prompt
						str4 = tbl5.NameLabel.Text
						fn27()
					end

					str3 = ""
					fn37()
				end)

				return tbl5
			end

			local function fn39()
				if screenGui3 and screenGui3.Parent then
					return
				end
				screenGui3 = Instance.new("ScreenGui")
				screenGui3.Name = "ChilliAutoGetTargetPanel"
				screenGui3.DisplayOrder = 5
				screenGui3.IgnoreGuiInset = true
				screenGui3.ResetOnSpawn = false
				screenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				local parent = CoreGui

				if type(gethui) == "function" then
					local ok
					ok, parent = pcall(gethui)
					ok = ok and typeof(parent) == "Instance"
					local v26 = CoreGui

					if not ok then
						parent = v26
					end
				end

				screenGui3.Parent = parent
				local frame4 = Instance.new("Frame")
				frame4.Active = true
				frame4.AnchorPoint = Vector2.new(1, 0)
				frame4.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
				frame4.BackgroundTransparency = 0.18
				frame4.BorderSizePixel = 0
				frame4.Position = fn31()
				frame4.Size = UDim2.fromOffset(214, 44)
				frame4.ClipsDescendants = true
				frame4.Parent = screenGui3
				Instance.new("UICorner", frame4).CornerRadius = UDim.new(0, 14)
				v15 = frame4
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(255, 255, 255)
				uiStroke.Thickness = 1
				uiStroke.Transparency = 0.9
				uiStroke.Parent = frame4
				local uiScale = Instance.new("UIScale")
				uiScale.Parent = frame4

				local function fn40()
					local currentCamera = Workspace.CurrentCamera
					local viewportSize = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)

					if viewportSize.X < 1 then
						viewportSize = Vector2.new(1280, 720)
					end

					uiScale.Scale = math.clamp(viewportSize.X * 0.15 / n16, 0.7, 1.3) * n20
				end

				v19 = fn40
				fn40()
				local currentCamera = Workspace.CurrentCamera

				if currentCamera then
					fn4(currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn40))
				end

				local textButton = Instance.new("TextButton")
				textButton.Name = "Handle"
				textButton.Active = true
				textButton.AutoButtonColor = false
				textButton.BackgroundTransparency = 1
				textButton.BorderSizePixel = 0
				textButton.Position = UDim2.fromOffset(0, 0)
				textButton.Size = UDim2.new(1, 0, 0, 44)
				textButton.Text = ""
				textButton.ZIndex = 2
				textButton.Parent = frame4
				local fn41 = nil
				local flag11 = false
				local flag12 = nil
				local flag13 = false
				local vector2 = Vector2.new(0, 0)
				local vector22 = Vector2.new(0, 0)

				textButton.InputBegan:Connect(function(input)
					if flag11 or input.UserInputState ~= Enum.UserInputState.Begin then
						return
					end

					if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
						return
					end
					local vector23 = Vector2.new(input.Position.X, input.Position.Y)
					local absolutePosition = textButton.AbsolutePosition
					local absoluteSize = textButton.AbsoluteSize
					if vector23.X < absolutePosition.X or vector23.X > absolutePosition.X + absoluteSize.X or vector23.Y < absolutePosition.Y or vector23.Y > absolutePosition.Y + absoluteSize.Y then
						return
					end

					for _, child in ipairs(textButton:GetChildren()) do
						if child:IsA("GuiButton") and child.Visible then
							local absolutePosition2 = child.AbsolutePosition
							local absoluteSize2 = child.AbsoluteSize
							if vector23.X >= absolutePosition2.X and vector23.X <= absolutePosition2.X + absoluteSize2.X and vector23.Y >= absolutePosition2.Y and vector23.Y <= absolutePosition2.Y + absoluteSize2.Y then
								return
							end
						end
					end

					local absoluteSize2 = screenGui3.AbsoluteSize
					if absoluteSize2.X <= 0 or absoluteSize2.Y <= 0 then
						return
					end
					flag11 = true
					flag13 = false
					flag12 = input.UserInputType == Enum.UserInputType.Touch and input or nil
					vector2 = Vector2.new(input.Position.X, input.Position.Y)
					vector22 = Vector2.new(frame4.Position.X.Scale + frame4.Position.X.Offset / absoluteSize2.X, frame4.Position.Y.Scale + frame4.Position.Y.Offset / absoluteSize2.Y)
				end)

				fn4(UserInputService2.InputChanged:Connect(function(input)
					if not flag11 then
						return
					end

					if not (flag12 and input == flag12 or not flag12 and input.UserInputType == Enum.UserInputType.MouseMovement) or not v15 then
						return
					end
					local absoluteSize = screenGui3.AbsoluteSize
					if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
						return
					end
					local n24 = Vector2.new(input.Position.X, input.Position.Y) - vector2
					if not flag13 and n24.Magnitude < 6 then
						return
					end
					flag13 = true
					frame4.Position = UDim2.fromScale(math.clamp(vector22.X + n24.X / absoluteSize.X, math.min(math.max(frame4.AbsoluteSize.X / absoluteSize.X, 0), 0.998), 0.998), math.clamp(vector22.Y + n24.Y / absoluteSize.Y, 0, 0.98))
				end))

				fn4(UserInputService2.InputEnded:Connect(function(input)
					if not flag11 then
						return
					end

					if input.UserInputType == Enum.UserInputType.MouseButton1 or input == flag12 then
						flag11 = false
						flag12 = nil

						if flag13 then
							fn32(frame4.Position)
						elseif fn41 then
							fn41()
						end
					end
				end))

				local textLabel3 = Instance.new("TextLabel")
				textLabel3.BackgroundTransparency = 1
				textLabel3.Position = UDim2.fromOffset(32, 8)
				textLabel3.Size = UDim2.fromOffset(n16 - 102, 14)
				textLabel3.Text = "Base Targets"
				textLabel3.TextColor3 = Color3.fromRGB(240, 240, 244)
				textLabel3.TextScaled = true
				textLabel3.TextXAlignment = Enum.TextXAlignment.Left
				fn30(textLabel3)
				textLabel3.Parent = textButton
				local textLabel4 = Instance.new("TextLabel")
				textLabel4.BackgroundTransparency = 1
				textLabel4.Position = UDim2.fromOffset(32, 23)
				textLabel4.Size = UDim2.fromOffset(n16 - 102, 10)
				textLabel4.Text = "walk into a base"
				textLabel4.TextColor3 = Color3.fromRGB(140, 140, 150)
				textLabel4.TextScaled = true
				textLabel4.TextXAlignment = Enum.TextXAlignment.Left
				fn30(textLabel4)
				textLabel4.Parent = textButton
				v17 = textLabel4
				local textButton2 = Instance.new("TextButton")
				textButton2.AnchorPoint = Vector2.new(0, 0.5)
				textButton2.AutoButtonColor = false
				textButton2.BackgroundTransparency = 1
				textButton2.BorderSizePixel = 0
				textButton2.Position = UDim2.new(0, 8, 0, math.floor(n18 * 0.5))
				textButton2.Size = UDim2.fromOffset(20, 20)
				textButton2.Text = ""
				textButton2.ZIndex = 6
				textButton2.Parent = textButton
				local frame5 = Instance.new("Frame")
				frame5.AnchorPoint = Vector2.new(0.5, 0.5)
				frame5.BackgroundTransparency = 1
				frame5.BorderSizePixel = 0
				frame5.Position = UDim2.fromScale(0.5, 0.5)
				frame5.Size = UDim2.fromScale(0.62, 0.62)
				frame5.Parent = textButton2
				local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
				uiAspectRatioConstraint.AspectRatio = 1
				uiAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
				uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
				uiAspectRatioConstraint.Parent = frame5

				for _, v26 in ipairs({ { 0.335355, 45 }, { 0.664645, -45 } }) do
					local frame6 = Instance.new("Frame")
					frame6.AnchorPoint = Vector2.new(0.5, 0.5)
					frame6.BackgroundColor3 = Color3.fromRGB(58, 255, 55)
					frame6.BorderSizePixel = 0
					frame6.Position = UDim2.fromScale(v26[1], 0.535355)
					frame6.Rotation = v26[2]
					frame6.Size = UDim2.fromScale(0.6657, 0.2)
					frame6.Parent = frame5
				end

				v22 = frame5
				frame5.Rotation = flag9 and 180 or 0

				fn41 = function()
					flag9 = not flag9
					TweenService:Create(frame5, tweenInfo, { Rotation = flag9 and 180 or 0 }):Play()
					fn33()
				end

				fn5(textButton2, fn41)
				local textButton3 = Instance.new("TextButton")
				textButton3.AnchorPoint = Vector2.new(1, 0)
				textButton3.AutoButtonColor = false
				textButton3.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
				textButton3.BackgroundTransparency = 0.2
				textButton3.BorderSizePixel = 0
				textButton3.Position = UDim2.new(1, -10, 0, 8)
				textButton3.Size = UDim2.fromOffset(58, 20)
				textButton3.Text = ""
				textButton3.Parent = textButton
				Instance.new("UICorner", textButton3).CornerRadius = UDim.new(1, 0)
				local uiStroke2 = Instance.new("UIStroke")
				uiStroke2.Color = Color3.fromRGB(255, 255, 255)
				uiStroke2.Thickness = 1.2
				uiStroke2.Transparency = 0.78
				uiStroke2.Parent = textButton3
				local textLabel5 = Instance.new("TextLabel")
				textLabel5.BackgroundTransparency = 1
				textLabel5.Position = UDim2.fromOffset(9, 5)
				textLabel5.Size = UDim2.fromOffset(9, 10)
				textLabel5.Text = "X"
				textLabel5.TextColor3 = Color3.fromRGB(226, 226, 232)
				textLabel5.TextScaled = true
				fn30(textLabel5)
				textLabel5.Parent = textButton3
				local textLabel6 = Instance.new("TextLabel")
				textLabel6.BackgroundTransparency = 1
				textLabel6.Position = UDim2.fromOffset(21, 5)
				textLabel6.Size = UDim2.fromOffset(30, 10)
				textLabel6.Text = "Clear"
				textLabel6.TextColor3 = Color3.fromRGB(226, 226, 232)
				textLabel6.TextScaled = true
				textLabel6.TextXAlignment = Enum.TextXAlignment.Left
				fn30(textLabel6)
				textLabel6.Parent = textButton3

				local function fn42(arg)
					local color2 = arg and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(226, 226, 232)
					TweenService:Create(textButton3, tweenInfo, { BackgroundTransparency = arg and 0.05 or 0.2 }):Play()

					TweenService:Create(uiStroke2, tweenInfo, {
						Color = arg and Color3.fromRGB(255, 120, 120) or Color3.fromRGB(255, 255, 255),
						Transparency = arg and 0.25 or 0.78,
					}):Play()

					TweenService:Create(textLabel5, tweenInfo, { TextColor3 = color2 }):Play()
					TweenService:Create(textLabel6, tweenInfo, { TextColor3 = color2 }):Play()
				end

				textButton3.MouseEnter:Connect(function()
					fn42(true)
				end)

				textButton3.MouseLeave:Connect(function()
					fn42(false)
				end)

				fn5(textButton3, function()
					prompt2 = nil
					str4 = ""
					str3 = ""
					fn37()
				end)

				local frame6 = Instance.new("Frame")
				frame6.BackgroundTransparency = 1
				frame6.Position = UDim2.fromOffset(10, 40)
				frame6.Size = UDim2.new(1, -20, 0, (n17 + 4) * (n14 + 1))
				frame6.Parent = frame4
				local uiListLayout = Instance.new("UIListLayout")
				uiListLayout.FillDirection = Enum.FillDirection.Vertical
				uiListLayout.Padding = UDim.new(0, 4)
				uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				uiListLayout.Parent = frame6
				v16 = frame6
				v18 = frame6
				local textLabel7 = Instance.new("TextLabel")
				textLabel7.BackgroundTransparency = 1
				textLabel7.LayoutOrder = 99
				textLabel7.Size = UDim2.new(1, 0, 0, 22)
				textLabel7.Text = ""
				textLabel7.TextColor3 = Color3.fromRGB(140, 140, 150)
				textLabel7.TextScaled = true
				textLabel7.Visible = false
				fn30(textLabel7)
				textLabel7.Parent = frame6
				v20 = textLabel7
				table.clear(tbl4)

				for i_ = 1, n14 + 1 do
					tbl4[i_] = fn38(i_)
				end
			end

			local function fn40(arg, arg2, arg3, arg4, arg5)
				local modelKey = tostring(arg5) .. "|" .. arg4
				if arg.ModelKey == modelKey and arg.Clone and arg.Clone.Parent then
					return
				end

				for _, child in ipairs(arg.Viewport:GetChildren()) do
					if not child:IsA("Camera") then
						child:Destroy()
					end
				end

				arg.Clone = nil
				arg.Track = nil
				arg.SourceTrack = nil
				if arg4 == "" then
					arg.ModelKey = modelKey
					return
				end
				local v26 = fn35(arg2, arg3, arg4)
				if not v26 then
					arg.ModelKey = nil
					return
				end
				arg.ModelKey = modelKey

				local ok, clone = pcall(function()
					return v26:Clone()
				end)

				if not ok or not clone then
					arg.ModelKey = nil
					return
				end

				for _, descendant in ipairs(clone:GetDescendants()) do
					if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") or descendant:IsA("Sound") or descendant:IsA("Script") or descendant:IsA("LocalScript") then
						descendant:Destroy()
					end
				end

				local worldModel = Instance.new("WorldModel")
				worldModel.Parent = arg.Viewport
				clone.Parent = worldModel

				pcall(function()
					clone:PivotTo(CFrame.new())
				end…