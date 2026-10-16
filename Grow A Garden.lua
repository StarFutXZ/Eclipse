repeat
	task.wait()
until game:IsLoaded()

local tbl

tbl = {
	IsDetected = false,
	_unpack = function(arg, arg2, arg3)
		arg2 = arg2 or 1
		local n = arg3 or #arg
		if n < arg2 then
			return
		end
		return arg[arg2], tbl._unpack(arg, arg2 + 1, n)
	end,
	_pcall = function(arg, ...)
		local tbl2 = { ... }

		local ok, result = pcall(function()
			return arg(tbl._unpack(tbl2))
		end)

		if not ok then
			return false, result
		end
		return true, result
	end,
}

local function fn()
	return true
end

local v_, v_2 = tbl._pcall(debug.info, fn, "f")

if not v_ or v_2 ~= fn then
	tbl.IsDetected = true
	LPH_CRASH()
end

local v_3, v_4 = tbl._pcall(debug.info, 2, "f")

if not v_3 or v_4 ~= pcall then
	tbl.IsDetected = true
	LPH_CRASH()
end

local v_5 = (cloneref or function(arg)
	return arg
end)(game:GetService("RunService"))

if v_5:IsStudio() then
	tbl.IsDetected = true
	LPH_CRASH()
end

if v_5:IsServer() then
	tbl.IsDetected = true
	LPH_CRASH()
end

if tbl.IsDetected then
	return
end

loadstring([[ 
  function LPH_NO_VIRTUALIZE(f) return f end;
  function LPH_JIT_MAX(f) return f end;
  function LPH_JIT(f) return f end;

  function LPH_ENCNUM(n, ...) return n end;
  function LPH_ENCSTR(s, ...) return s end;
  function LPH_ENCFUNC(f, ...) return f end;
  function LPH_ENCBUF(b, ...) return b end;

  function LPH_ATTRIBUTES(...) end;
  function LPH_REWRITE(expr, ...) return expr end;
  function LPH_STACKALLOC(size, zeroOrOne) return {} end;
  function LPH_PRECHECK(...) end;

  function VM(...) end;
  function PRESET(...) end;
  function ENCRYPT(...) end;
  function OPTIMIZE(...) end;
  function ERROR_HANDLING(...) end;
  function TRANSFORM(...) end;
  NONE, OPAL, ONYX = 0, 1, 2;
  FAST, SECURE = 0, 1;
  CONTROL_FLOW, EXTRACT, INLINE, UNROLL, NO_UPVALUES, level = 0, 0, 0, 0, 0, 0;
]])()

local function fn2()
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local UserInputService = game:GetService("UserInputService")
	local GuiService = game:GetService("GuiService")
	local virtualInputManager = Instance.new("VirtualInputManager")
	local RunService = game:GetService("RunService")
	local Lighting = game:GetService("Lighting")
	game:GetService("VirtualUser")
	local HttpService = game:GetService("HttpService")
	game:GetService("CollectionService")
	local TeleportService = game:GetService("TeleportService")
	local CoreGui = game:GetService("CoreGui")
	local MarketplaceService = game:GetService("MarketplaceService")
	local localPlayer = Players.LocalPlayer
	local playerGui = localPlayer:WaitForChild("PlayerGui")
	local heartbeat = RunService.Heartbeat
	local gameEvents = ReplicatedStorage:WaitForChild("GameEvents")

	local tbl2 = {
		Enabled = { IsSelling = false },
		Module = {},
		Connections = {},
		Cached = {
			Team = "",
			PetMutations = {},
			ServerList = { Data = {}, Timestamp = 0 },
			Image = {},
			ClearEmptyList = {},
			LastFired = {},
			VIPServer = {},
			JSON = {},
			Count = { WalkSpeed = 0, NoClip = 0 },
			SellPrevent = {},
			HideTree = {},
			HideFruit = {},
			ESP = {},
			Cached_Decompiled = {},
		},
		Stored = {
			Pet_Switcher = {
				["Egg Reduction Time"] = false,
				["Hatching Egg"] = false,
				["Selling Pet"] = false,
				["Place Egg"] = false,
				["Pick Place Active"] = false,
				["Stop Switch"] = false,
				["Is Switching"] = false,
				["Switch Lock"] = false,
				["Last Switch Time"] = 0,
				["Current Operation"] = nil,
			},
			PetCooldown = {},
			PetProgressing = {},
			Planted = {},
			Data = {},
			Killed = {},
		},
	}

	local module = tbl2.Module
	local cached = tbl2.Cached
	local stored = tbl2.Stored
	local enabled = tbl2.Enabled

	local function fn3(arg, arg2)
		local StarterGui = game:GetService("StarterGui")
		local name = localPlayer.Name

		if name == "fanoffgteev999" or name == "KXbMrzy" or name == "blacjacqv" or name == "asudhasuohdasuo" or name == "asuhdpas9gudhas9h" then
			StarterGui:SetCore("SendNotification", { Title = arg2 or "", Text = arg, Icon = "rbxassetid://0", Duration = 5 })
		end
	end

	local function fn4(arg)
		local ok, result = pcall(function()
			return (load or loadstring)(game:HttpGet(arg))()
		end)

		if ok then
			return result
		end
	end

	local function fn5(arg)
		if cached.JSON[arg] then
			return cached.JSON[arg]
		end

		local ok, result = pcall(function()
			return game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Main/refs/heads/main/Data%20Game/Grow%20A%20Garden/" .. arg)
		end)

		if ok then
			local data = HttpService:JSONDecode(result)
			cached.JSON[arg] = data
			return data
		end
	end

	local fn6 = fireproximityprompt or function(arg)
		if arg:IsA("ProximityPrompt") then
			arg.KeyboardKeyCode = Enum.KeyCode.C
			arg.HoldDuration = 0
			virtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
			task.wait()
			virtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
		end
	end

	local fn7 = require or function()
	end

	local fn8 = isfile or function()
	end

	local fn9 = isfolder or function()
	end

	local fn10 = makefolder or function()
	end

	local fn11 = queue_on_teleport or queueonteleport or function()
	end

	local str = identifyexecutor() or getnameexecutor() or ""

	local tbl3 = {
		SHX = fn4("https://raw.githubusercontent.com/AhmadV99/Main/refs/heads/main/Library/Lib_5.5.0.lua"),
		Funcs = (loadstring or load)("local a={}do function a:Toggle(b,c,d,e,f,g,h)c=c or\"\"d=d or\"\"e=e or false;f=f or false;g=g or function()end;h=h or\"\"return b:AddToggle({Title=c,Content=d,Default=e,Callback=g,Saver=f,Warnings=h})end;function a:Button(b,c,d,g,e)c=c or\"\"d=d or\"\"g=g or function()end;e=e or\"\"return b:AddButton({Title=c,Content=d,Callback=g,Warnings=e})end;function a:Dropdown(b,c,d,h,i,e,f,g)c=c or\"\"d=d or\"\"h=h or false;i=i or{}e=e or{}f=f or false;g=g or function()end;return b:AddDropdown({Title=c,Content=d,Multi=h,Options=i,Default=e,Callback=g,Saver=f})end;function a:Textbox(b,c,d,e,f,g)c=c or\"\"d=d or\"\"e=e or\"\"f=f or false;g=g or function()end;return b:AddInput({Title=c,Content=d,Default=e,Callback=g,Saver=f})end;function a:Slider(b,c,d,j,k,l,e,m,f,g)c=c or\"\"d=d or\"\"l=l or 0.1;j=j or 0.1;k=k or 1;e=e or 0;f=f or false;m=m or false;g=g or function()end;return b:AddSlider({Title=c,Content=d,Increment=l,Min=j,Max=k,Default=e,AutoUpdate=m,Callback=g,Saver=f})end end;return a")(),
	}

	local shx = tbl3.SHX
	local funcs = tbl3.Funcs

	task.spawn(function()
		if not fn9(shx.FolderPath .. "/PetTeams") then
			fn10(shx.FolderPath .. "/PetTeams")
		end
	end)

	local function fn12()
		local tbl4

		tbl4 = {
			API = {
				Variant = { "Normal", 1000, 1 },
				{ "Silver", -1, 5 },
				{ "Gold", 10, 20 },
				{ "Rainbow", 1, 50 },
				{ "Diamond", -1, 50 },
				{ "Jelly", -1, 50 },
				Craft = fn5("Crafting%20Table.json"),
				Data = fn5("Data.json"),
			},
			Variant = { "Normal", "Gold", "Rainbow", "Silver", "Diamond", "Jelly" },
			ListGears = {
				"Watering Can",
				"Trowel",
				"Recall Wrench",
				"Basic Sprinkler",
				"Firework",
				"Advanced Sprinkler",
				"Medium Treat",
				"Medium Toy",
				"Star Caller",
				"Night Staff",
				"Godly Sprinkler",
				"Chocolate Sprinkler",
				"Nectar Staff",
				"Pollen Radar",
				"Master Sprinkler",
				"Cleaning Spray",
				"Favorite Tool",
				"Harvest Tool",
				"Friendship Pot",
				"Level Up Lollipop",
				"Lightning Rod",
				"Berry Blusher Sprinkler",
				"Flower Froster Sprinkler",
				"Spice Spritzer Sprinkler",
				"Stalk Sprout Sprinkler",
				"Sweet Soaker Sprinkler",
				"Tropical Mist Sprinkler",
				"Reclaimer",
				"Small Toy",
				"Small Treat",
			},
			BoostStats = {
				PASSIVE_BOOST = { BaseValue = 1, Amount = { Small = 0.1, Medium = 0.2, Large = 0.3 } },
				PET_XP_BOOST = { BaseValue = 1, Amount = { Small = 0.5, Medium = 2, Smith = 5 } },
				SIZE_MODIFICATION = { BaseValue = 1, Amount = { Small = 10, Medium = 30 } },
			},
			GetMagnitude = function(arg)
				if typeof(arg) == "CFrame" then
					return localPlayer:DistanceFromCharacter(arg.Position)
				end

				if typeof(arg) == "Vector3" then
					return localPlayer:DistanceFromCharacter(arg)
				end
			end,
			GetTo = function(arg)
				local cframe = typeof(arg) == "Vector3" and CFrame.new(arg) or arg
				local character = localPlayer and localPlayer.Character
				character = character and character.PrimaryPart

				if character and not enabled.IsSelling then
					character.CFrame = cframe
				end
			end,
			MoveTo = function(arg)
				(localPlayer and localPlayer.Character):MoveTo(arg)
			end,
			GetOwnerFarm = function(arg)
				local farm = workspace:FindFirstChild("Farm")
				if not farm then
					return
				end

				for _, child in ipairs(farm:GetChildren()) do
					local important = child:FindFirstChild("Important")
					if not important then
						continue
					end
					local data = important:FindFirstChild("Data")
					if not data then
						continue
					end
					local owner = data:FindFirstChild("Owner")
					if not owner then
						continue
					end

					if owner and owner.Value == arg then
						return child
					end
				end

				return nil
			end,
			GetFarmPath = function(arg)
				local v_6 = tbl4.GetOwnerFarm(localPlayer.Name)
				if not v_6 then
					return
				end
				local important = v_6:FindFirstChild("Important")
				if not important then
					return
				end
				return important:FindFirstChild(arg)
			end,
			Webhook = function(arg, arg2)
				local request_ = request or syn and syn.request or http and http.request or fluxus and fluxus.request or http_request
				if not request_ then
					return
				end

				request_({
					Url = arg,
					Body = HttpService:JSONEncode(arg2),
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
				})
			end,
			IsAlive = function(arg)
				local humanoid = arg:FindFirstChild("Humanoid")
				return humanoid and humanoid.Health > 0
			end,
			GetImageURL = function(arg)
				if cached.Image[arg] then
					return cached.Image[arg]
				end
				local str2 = tostring(arg):gsub("rbxassetid://", "")

				local ok, result = pcall(function()
					return game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds=" .. str2 .. "&size=420x420&format=Png&isCircular=false")
				end)

				if not ok then
					return nil
				end
				local data = HttpService:JSONDecode(result)
				local data2 = data and data.data and data.data[1]
				data2 = data2 and data2.imageUrl or nil

				if data2 then
					cached.Image[arg] = data2
				end

				return data2
			end,
			FireDelay = function(arg, arg2, arg3)
				local now = tick()

				if not cached.LastFired[arg3] or now - cached.LastFired[arg3] >= arg then
					cached.LastFired[arg3] = now
					task.spawn(arg2)
				end
			end,
			FruitFilter = function(arg, arg2)
				local tbl5 = arg[1] or {}
				local tbl6 = arg[2] or {}
				local tbl7 = arg[3] or {}
				local attribute = arg2:FindFirstChild("Item_String") and arg2.Item_String.Value or arg2:GetAttribute("f") or arg2.Name:gsub("%b[]", ""):gsub("^%s*(.-)%s*$", "%1")
				local value = arg2:FindFirstChild("Variant") and arg2.Variant.Value
				local flag = #tbl5 > 1 and not table.find(tbl5, "None")
				local flag2 = #tbl6 > 1 and not table.find(tbl6, "None")
				local flag3 = #tbl7 > 1 and not table.find(tbl7, "None")
				if flag and not table.find(tbl5, attribute) then
					return false
				end

				if flag2 then
					local flag4 = false

					for i = 1, #tbl6 do
						if arg2:GetAttribute(tbl6[i]) then
							flag4 = true
							break
						end
					end

					if not flag4 then
						return false
					end
				end

				if flag3 and value ~= nil and not table.find(tbl7, value) then
					return false
				end
				return flag or flag2 or flag3
			end,
			PetFilter = function(arg, arg2)
				local tbl5 = arg[1] or {}
				local flag = #tbl5 > 1 and not table.find(tbl5, "None")

				if flag then
					local flag2 = false

					for i = 1, #tbl5 do
						if arg2:GetAttribute(tbl5[i]) then
							flag2 = true
							break
						end
					end

					if not flag2 then
						return false
					end
				end

				return flag
			end,
			ClickUI = function(selectedObject)
				selectedObject.Selectable = true
				GuiService.AutoSelectGuiEnabled = false
				GuiService.GuiNavigationEnabled = true

				if selectedObject and selectedObject:IsDescendantOf(game) then
					GuiService.SelectedObject = selectedObject
					task.wait()

					if GuiService.SelectedObject == selectedObject then
						virtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
						virtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
					end

					task.wait()
				end

				GuiService.AutoSelectGuiEnabled = true
				GuiService.GuiNavigationEnabled = false
				GuiService.SelectedObject = nil
			end,
			FormatNumber = function(arg)
				return tostring(arg):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
			end,
			FormatNumer1 = function(arg)
				local tbl5 = {
					"CENT",
					"VIG",
					"NOV",
					"OCT",
					"SEP",
					"SXD",
					"QUI",
					"QUA",
					"TR",
					"DU",
					"UN",
					"DE",
					"NO",
					"OC",
					"SP",
					"SX",
					"QI",
					"QA",
					"T",
					"B",
					"M",
					"K",
				}

				if arg < 1000 then
					return tostring(arg)
				end
				local n = math.floor(math.floor(math.log10(arg)) / 3)

				if #tbl5 < n then
					n = #tbl5
				end

				return string.format("%.2f%s", arg / 10 ^ (n * 3), tbl5[n])
			end,
		}

		local tbl5 = {
			"",
			"K",
			"M",
			"B",
			"T",
			"Qd",
			"Qn",
			"Sx",
			"Sp",
			"O",
			"N",
			"De",
			"Ud",
			"Dd",
			"TdD",
			"QdD",
			"QnD",
			"SxD",
			"SpD",
			"OcD",
			"NvD",
		}

		local function fn13()
			local tbl6 = {}

			for i, v_6 in ipairs(tbl5) do
				tbl6[v_6:lower()] = 10 ^ ((i - 1) * 3)
			end

			return tbl6
		end

		local v_6 = fn13()

		tbl4.CorrectNumber = function(arg)
			if arg == nil then
				return 0
			end
			local match, v_7 = tostring(arg):gsub(",", ""):gsub("¢", ""):gsub("%s+", ""):lower():match("^([%d%.]+)(.*)$")
			local num = tonumber(match)
			if not num then
				return 0
			end

			if v_7 ~= "" then
				local v_8 = v_6[v_7]

				if v_8 then
					num *= v_8
				end
			end

			return num
		end

		tbl4.CountDictionary = function(arg)
			local n = 0

			for k in arg, nil, nil do
				n += 1
			end

			return n
		end

		local function fn14()
			return {
				Cached_Purchases = {},
				GetListProduct = function(arg)
					local tbl6 = {}

					for k in pairs(cached[arg]) do
						tbl6[#tbl6 + 1] = k
					end

					return tbl6
				end,
				GetIdProduct = function(arg, arg2)
					return cached[arg2][arg]
				end,
			}
		end

		tbl4.Market_Product = fn14()

		local function fn15()
			local tbl6 = {}

			return {
				Set = function(arg, arg2, arg3)
					tbl6[arg2] = os.clock() + arg3
				end,
				Expired = function(arg, arg2)
					local flag = not tbl6[arg2]
					local flag2

					if flag then
						flag2 = flag
					else
						local v_7 = tbl6[arg2]
						flag2 = os.clock() >= v_7
					end

					return flag2
				end,
			}
		end

		tbl4.CustomDelay = fn15()

		local function fn16()
			local str2 = shx.FolderPath .. "/PetTeams"

			return {
				SetSaveJSON = function(arg, arg2)
					local json = HttpService:JSONEncode(arg2)

					if json then
						pcall(writefile, str2 .. "/" .. arg .. ".json", json)
					end
				end,
				GetListFile = function()
					local tbl6 = { "None" }
					local tbl7 = listfiles(str2) or {}

					for _, v_7 in tbl7, nil, nil do
						local str3 = v_7:gsub("[\\/]", "/"):gsub("^/?SpeedHubX/PetTeams/?", ""):gsub("%.json", "")
						table.insert(tbl6, str3)
					end

					return tbl6
				end,
				ReadPetTeam = function(arg)
					local ok, result = pcall(readfile, str2 .. "/" .. arg .. ".json")
					if ok then
						return (HttpService:JSONDecode(result))
					end
				end,
				DeleteFile = function(arg)
					if pcall(delfile, str2 .. "/" .. arg .. ".json") then
						return true
					end
					return false
				end,
			}
		end

		tbl4.PetTeams = fn16()

		tbl4.CheckEggToHatch = function(arg)
			local flag = arg or false
			local Objects_Physical = tbl4.GetFarmPath("Objects_Physical")
			if not Objects_Physical then
				return
			end

			if flag then
				for _, child in ipairs(Objects_Physical:GetChildren()) do
					if child.Name == "PetEgg" and child:IsA("Model") then
						local attribute = child:GetAttribute("TimeToHatch")
						if attribute and attribute > 0 then
							return false
						end
					end
				end

				return true
			end

			for _, child in ipairs(Objects_Physical:GetChildren()) do
				if child.Name == "PetEgg" and child:IsA("Model") then
					local attribute = child:GetAttribute("TimeToHatch")
					if attribute and attribute == 0 then
						return true
					end
				end
			end

			return false
		end

		tbl4.CheckPets = function(arg)
			for _, child in pairs(workspace.PetsPhysical:GetChildren()) do
				local name = localPlayer.Name
				if child:GetAttribute("OWNER") ~= name then
					continue
				end

				if type(arg) == "table" then
					if table.find(arg, child:GetAttribute("UUID")) then
						return true
					end
					continue
				end

				if child:GetAttribute("UUID") == arg then
					return true
				end
			end

			return false
		end

		tbl4.IsPrivateServer = function()
			if cached.VIPServer.VIPServer1 then
				return true
			end

			local ok, result = pcall(function()
				return game:GetService("RobloxReplicatedStorage").GetServerType:InvokeServer()
			end)

			if ok and result == "VIPServer" then
				cached.VIPServer.VIPServer1 = true
				return true
			end
			return false
		end

		local function fn17()
			local tbl6

			tbl6 = {
				EquipTool = function(arg)
					local character = localPlayer and localPlayer.Character
					character = character and character:FindFirstChild("Humanoid")
					local backpack = localPlayer and localPlayer:FindFirstChild("Backpack")
					backpack = backpack and backpack:FindFirstChild(arg)

					if backpack then
						character:EquipTool(backpack)
					end
				end,
				EquipTool_Find = function(arg, arg2)
					local character = localPlayer and localPlayer.Character
					character = character and character:FindFirstChild("Humanoid")

					for _, child in ipairs(localPlayer.Backpack:GetChildren()) do
						local pos = child:IsA("Tool") and child.Name:find(arg)
						local flag

						if pos then
							flag = not arg2 or child:GetAttribute("b") == "j"
						else
							flag = pos
						end

						if flag then
							character:EquipTool(child)
							break
						end
					end
				end,
				GetTypeEnum = {
					a = "Seed Pack",
					L = "Leaf Blower",
					e = "Night Staff",
					f = "Harvest Tool",
					g = "Pollen Radar",
					h = "Favorite Tool",
					i = "Lightning Rod",
					u = "Food",
					k = "Star Caller",
					s = "SprayBottle",
					y = "Pet Pouch",
					n = "Seed",
					m = "FriendshipPot",
					F = "Fairy Caller",
					b = "Trowel",
					c = "PetEgg",
					d = "Sprinkler",
					t = "Tranquil Radar",
					G = "Luminous Wand",
					O = "Grow All",
					M = "Maple Leaf Kite",
					w = "Packaged Seed",
					K = "Firefly Jar",
					D = "Fairy Summoner",
					H = "Fairy Net",
					z = "PetBoost",
					N = "Steal",
					J = "Fairy Jar",
					j = "Holdable",
					E = "Fairy Power Extender",
					l = "Pet",
					A = "PetShard",
					v = "Trading Ticket",
					B = "Event Lantern",
					C = "Glimmering Radar",
					q = "Recall Wrench",
					o = "Watering Can",
					x = "Fertilizer",
					p = "Nectar Staff",
					r = "CosmeticCrate",
				},
				IsEquipped = function(arg, arg2)
					local character = localPlayer and localPlayer.Character
					if not character then
						return
					end

					for _, child in ipairs(character:GetChildren()) do
						if child:IsA("Tool") and not child:GetAttribute("d") then
							local v_7 = tbl6.GetTypeEnum[child:GetAttribute("b")]

							if not arg2 or v_7 == arg2 then
								local attribute = v_7 == "PetEgg" and child:GetAttribute("h") or child:GetAttribute("f") or child.Name:gsub("%b[]", ""):gsub("^%s*(.-)%s*$", "%1")
								if not arg or type(arg) == "table" and table.find(arg, attribute) or attribute == arg then
									return child
								end
							end
						end
					end

					return nil
				end,
				GetItem = function(arg, arg2)
					local character = localPlayer and localPlayer.Character

					if character then
						character:FindFirstChild("Humanoid")
					end

					for _, child in ipairs(localPlayer.Backpack:GetChildren()) do
						if child:IsA("Tool") and not child:GetAttribute("d") then
							local str2 = tbl6.GetTypeEnum[child:GetAttribute("b")] or nil

							if arg2 == "SprayBottle" and child:GetAttribute("l") then
								str2 = "SprayBottle"
							end

							arg = arg == "Smith Hammer of Harvest" and "Smith Hammer Harvest" or arg

							if not str2 or str2 == arg2 then
								if (str2 == "PetShard" and child:GetAttribute("u") or str2 == "PetBoost" and child.Name:gsub(" x%d+", ""):gsub("%[.+%]", ""):gsub(" Pet ", " ") or str2 == "SprayBottle" and child:GetAttribute("l") or str2 == "PetEgg" and child:GetAttribute("h") or child:GetAttribute("f") or child.Name:gsub(" x%d+$", ""):gsub("%b[]", ""):gsub("^%s*(.-)%s*$", "%1")) == arg then
									return child
								end
							end
						end
					end
				end,
				Equip = function(arg, arg2, arg3)
					local v_7 = arg3 or nil
					local character = localPlayer and localPlayer.Character
					character = character and character:FindFirstChild("Humanoid")

					for _, child in ipairs(localPlayer.Backpack:GetChildren()) do
						if child:IsA("Tool") and (v_7 or not child:GetAttribute("d")) then
							local v_8 = tbl6.GetTypeEnum[child:GetAttribute("b")]

							if not arg2 or v_8 == arg2 then
								local attribute = v_8 == "PetEgg" and child:GetAttribute("h") or child:GetAttribute("f") or child.Name:gsub("%b[]", ""):gsub("^%s*(.-)%s*$", "%1")
								local flag = not arg

								if not flag then
									flag = type(arg) == "table" and table.find(arg, attribute) or attribute == arg
								end

								if flag then
									character:EquipTool(child)
									return child
								end
							end
						end
					end
				end,
				CurrentTool = function(arg)
					local character = localPlayer and localPlayer.Character
					local backpack = localPlayer:FindFirstChild("Backpack")

					local function fn18(arg2, arg3)
						for _, child in pairs(arg2:GetChildren()) do
							if child:IsA("Tool") and (arg3 == "Seed" and child:GetAttribute("Seed") or child:GetAttribute("ITEM_TYPE") == arg3) then
								return child
							end
						end
					end

					return fn18(character, arg) or fn18(backpack, arg)
				end,
				EquipEgg = function(arg)
					local character = localPlayer and localPlayer.Character

					for _, child in pairs(localPlayer.Backpack:GetChildren()) do
						if child:IsA("Tool") and child:GetAttribute("h") == arg then
							character.Humanoid:EquipTool(child)
						end
					end
				end,
				FindHoldable = function(arg)
					local tbl7 = {}

					for _, v_7 in localPlayer.Character:GetChildren() do
						if v_7:IsA("Tool") and v_7:GetAttribute("b") == "j" and tbl4.Calculator.StipFlavourText(v_7.Name) == arg then
							table.insert(tbl7, v_7)
						end
					end

					for _, v_7 in localPlayer.Backpack:GetChildren() do
						if v_7:IsA("Tool") and v_7:GetAttribute("b") == "j" and tbl4.Calculator.StipFlavourText(v_7.Name) == arg then
							table.insert(tbl7, v_7)
						end
					end

					return tbl7
				end,
				GetCountFruit = function(arg)
					return tbl4.CountDictionary(tbl6.FindHoldable(arg))
				end,
				GetUnlockedCapGarden = function()
					local gardenCoinShopUi = playerGui:FindFirstChild("GardenCoinShop_UI")
					gardenCoinShopUi = gardenCoinShopUi and gardenCoinShopUi:FindFirstChild("Plant Inventory Capacity", true)
					gardenCoinShopUi = gardenCoinShopUi and gardenCoinShopUi:FindFirstChild("Description_Text", true)
					if not gardenCoinShopUi then
						return 0
					end
					return (tonumber(gardenCoinShopUi.Text:match("%((%d+)%s*/%s*%d+%)")) or 0) * 10
				end,
				IsMaxInventory = function()
					return (localPlayer:GetAttribute("Holdable_Backpack") or 0) >= 200 + (tbl6.GetUnlockedCapGarden() or 0)
				end,
				GetAllTool = function()
					local tbl7 = {}

					for _, child in ipairs(localPlayer.Backpack:GetChildren()) do
						if child:IsA("Tool") then
							table.insert(tbl7, child)
						end
					end

					for _, child in ipairs(localPlayer.Character:GetChildren()) do
						if child:IsA("Tool") then
							table.insert(tbl7, child)
						end
					end

					return tbl7
				end,
				GetSeedName = function(arg)
					for _, v_7 in tbl6.GetAllTool(), nil, nil do
						if not v_7:IsA("Tool") then
							continue
						end
						local attribute = v_7:GetAttribute("b")
						if attribute and attribute ~= "n" then
							continue
						end
						local attribute2 = v_7:GetAttribute("f")
						if not attribute2 then
							continue
						end
						local attribute3 = v_7:GetAttribute("Seed")
						if attribute3 and attribute3 == arg or attribute2 and attribute2 == arg then
							return v_7
						end
					end
				end,
			}

			return tbl6
		end

		tbl4.ToolFunction = fn17()

		local function fn18()
			return {
				GetPlantList = function(arg, arg2, arg3)
					local flag = arg3 or false

					for _, child in ipairs(arg:GetChildren()) do
						local function fn19(arg4, arg5)
							if flag or arg5 and arg5.Enabled then
								arg2[#arg2 + 1] = arg4
							end
						end

						local fruits = child:FindFirstChild("Fruits")

						if fruits then
							for _, child2 in ipairs(fruits:GetChildren()) do
								local proximityPrompt = child2:FindFirstChildWhichIsA("ProximityPrompt", true)

								if proximityPrompt then
									fn19(child2, proximityPrompt)
								end
							end
						end

						local proximityPrompt = child:FindFirstChildWhichIsA("ProximityPrompt", true)

						if proximityPrompt then
							fn19(child, proximityPrompt)
						end
					end

					return arg2
				end,
				GetPlantList1 = function(arg, arg2, arg3, arg4)
					local flag = arg4 or false

					for _, child in ipairs(arg:GetChildren()) do
						local function fn19(arg5)
							if arg5 and (flag or not arg5:GetAttribute("Favorited")) then
								arg2[#arg2 + 1] = arg5
							end
						end

						if arg3 then
							local fruits = child:FindFirstChild("Fruits")

							if fruits then
								for _, child2 in ipairs(fruits:GetChildren()) do
									fn19(child2)
								end
							end
						else
							fn19(child)
						end
					end

					return arg2
				end,
				GetPositionPlant = function(arg)
					local Plants_Physical = tbl4.GetFarmPath("Plants_Physical")

					for _, child in pairs(Plants_Physical:GetChildren()) do
						if child:IsA("Model") and table.find(arg, child.Name) then
							return child:GetPivot().Position
						end
					end
				end,
				GetCountPlant = function(arg)
					local Plants_Physical = tbl4.GetFarmPath("Plants_Physical")
					local n = 0

					for _, child in ipairs(Plants_Physical:GetChildren()) do
						if child:IsA("Model") and table.find(arg, child.Name) then
							local fruits = child:FindFirstChild("Fruits")

							if fruits then
								for _, child2 in ipairs(fruits:GetChildren()) do
									if child2 then
										n += 1
									end
								end
							end

							if child then
								n += 1
							end
						end
					end

					return n
				end,
			}
		end

		tbl4.Collection = fn18()

		local function fn19()
			local tbl6

			tbl6 = {
				Sell = function()
					local character = localPlayer and localPlayer.Character
					if not character then
						return
					end
					local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					if not humanoidRootPart then
						return
					end
					local cFrame = humanoidRootPart.CFrame
					humanoidRootPart.CFrame = CFrame.new(36.5854721, 2.76619363, 0.426784277, 0, 0, -1, 0, 1, 0, 1, 0, 0)
					task.wait(0.3)
					gameEvents.Sell_Item:FireServer()
					task.wait(0.3)
					humanoidRootPart.CFrame = cFrame
				end,
				CallSell = function(arg)
					local tbl7 = {}
					local tbl8 = {}

					for _, child in ipairs(localPlayer.Backpack:GetChildren()) do
						if not (arg and not enabled[arg]) then
							if child:IsA("Tool") and child:GetAttribute("b") == "j" and not child:GetAttribute("d") then
								local v_7 = tbl4.FruitFilter({
									enabled["Prevent Sell Fruits"],
									enabled["Prevent Sell Mutation"],
									enabled["Prevent Sell Variant"],
								}, child)

								if enabled["Enable Prevent Mode"] and not v_7 then
									table.insert(tbl7, child)
								elseif not enabled["Enable Prevent Mode"] then
									table.insert(tbl7, child)
								end
							end

							continue
						end

						break
					end

					for _, v_7 in localPlayer.Character:GetChildren() do
						if v_7:IsA("Tool") then
							v_7.Parent = localPlayer.Backpack
						end
					end

					for _, v_7 in ipairs(tbl7) do
						if not (arg and not enabled[arg]) then
							for _, v_8 in v_7:QueryDescendants("BasePart") do
								v_8:Destroy()
							end

							v_7.Parent = localPlayer.Character
							table.insert(tbl8, v_7)
							continue
						end

						break
					end

					if #tbl8 > 0 then
						tbl6.Sell()
					end
				end,
			}

			return tbl6
		end

		tbl4.SellFunction = fn19()

		local function fn20()
			local tbl6

			tbl6 = {
				StipFlavourText = function(arg)
					if arg and arg ~= "" then
						return arg:gsub("%b[]", ""):gsub("^%s*(.-)%s*$", "%1")
					end
					return nil
				end,
				GetFruitData = function(arg)
					local v_7 = tbl4.API.Data.Fruits[tbl6.StipFlavourText(arg)]
					if v_7 then
						return v_7
					end
					return nil
				end,
				GetMutations = function()
					return tbl4.API.Data.Mutations
				end,
				CalculatorMutation = function(arg)
					local n = 1

					for _, v_7 in tbl6.GetMutations() do
						if arg:GetAttribute(v_7.Name) then
							n += v_7.ValueMulti - 1
						end
					end

					return (math.max(1, n))
				end,
				CalculatorVariant = function(arg)
					for _, v_7 in tbl4.API.Variant, nil, nil do
						if v_7[1] == arg then
							return v_7[3]
						end
					end

					return 0
				end,
				CalculatorFruit = function(arg)
					local itemString = arg:FindFirstChild("Item_String")
					local variant = arg:FindFirstChild("Variant")
					local weight = arg:FindFirstChild("Weight")
					if not variant or not weight then
						return 0
					end
					local v_7 = tbl6.GetFruitData(itemString and itemString.Value or tbl6.StipFlavourText(arg.Name))
					if not v_7 then
						return 0
					end
					local v_8 = v_7[2]
					local v_9 = v_7[1]
					if not v_8 or not v_9 then
						return 0
					end
					local v_10 = tbl6.CalculatorVariant(variant.Value)
					local n = v_8 * tbl6.CalculatorMutation(arg) * v_10
					local n2 = weight.Value / v_9
					local n3 = n2 < 0.95 and 0.95 or n2
					local n4 = n * n3 * n3
					return n4 + 0.5 - (n4 + 0.5) % 1
				end,
				CalculateWeight = function(arg, arg2)
					return arg + arg * 0.1 * arg2
				end,
				CurrentWeight = function(arg, arg2)
					local n = math.min(arg2, 100)
					return (tbl6.CalculateWeight(arg, n))
				end,
			}

			return tbl6
		end

		tbl4.Calculator = fn20()

		local function fn21()
			return {
				GetShopList = function(arg)
					local tbl6 = { "None" }
					local v_7 = playerGui:FindFirstChild(arg)
					if not v_7 then
						return tbl6
					end
					local scrollingFrame = v_7:FindFirstChild("Frame") and v_7.Frame:FindFirstChild("ScrollingFrame")
					if not scrollingFrame then
						return tbl6
					end

					for _, child in pairs(scrollingFrame:GetChildren()) do
						if child:IsA("Frame") and not child.Name:find("Padding") then
							table.insert(tbl6, child.Name)
						end
					end

					return tbl6
				end,
				GetStockGeneric = function(arg, arg2, arg3, arg4)
					local flag = arg4 or false
					local currencyUI = playerGui:FindFirstChild("CurrencyUI")
					currencyUI = currencyUI and currencyUI:FindFirstChild("CurrencyHolder")
					local sheckles = currencyUI and currencyUI:FindFirstChild("Sheckles")
					sheckles = sheckles and sheckles:FindFirstChild("val", true)
					local gardenCoinCurrencyUi = playerGui:FindFirstChild("GardenCoinCurrency_UI")
					gardenCoinCurrencyUi = gardenCoinCurrencyUi and gardenCoinCurrencyUi:FindFirstChild("Frame")

					if gardenCoinCurrencyUi then
						gardenCoinCurrencyUi:FindFirstChild("TextLabel1")
					end

					currencyUI = currencyUI and currencyUI:FindFirstChild("GardenCoins")
					currencyUI = currencyUI and currencyUI:FindFirstChild("val", true)
					flag = flag and currencyUI and currencyUI.Value or sheckles and sheckles.Value or 0
					local n = 0
					local name = nil

					for _, child in pairs(arg:GetChildren()) do
						local isFrame = child:IsA("Frame")

						if isFrame then
							local flag2 = arg3 == "no"

							if flag2 then
								isFrame = flag2
							else
								isFrame = type(arg3) == "table" and table.find(arg3, child.Name)
							end

							isFrame = isFrame or child.Name == arg3
						end

						if isFrame then
							local mainFrame = child:FindFirstChild("Main_Frame")
							local inStock = child:FindFirstChild("Frame") and child.Frame:FindFirstChild("Sheckles_Buy") and child.Frame.Sheckles_Buy:FindFirstChild("In_Stock")

							if mainFrame and inStock and inStock.Visible then
								local costText = inStock:FindFirstChild("Cost_Text")
								costText:FindFirstChild("TEXT")
								costText = costText and tbl4.CorrectNumber(costText.Text)

								if costText and flag >= costText then
									if arg2 == "Best" then
										if flag >= costText and costText > n then
											name = child.Name
											n = costText
										end

										continue
									end

									return child.Name
								end
							end
						end
					end

					return name
				end,
				GetListCosmetic = function()
					local tbl6 = {}
					local cosmeticShopUi = playerGui:FindFirstChild("CosmeticShop_UI")
					local topSegment = cosmeticShopUi:FindFirstChild("TopSegment", true)
					local bottomSegment = cosmeticShopUi:FindFirstChild("BottomSegment", true)

					for _, v_7 in { topSegment, bottomSegment }, nil, nil do
						for _, v_8 in v_7:GetChildren() do
							if v_8:IsA("Frame") then
								table.insert(tbl6, v_8.Name)
							end
						end
					end

					return tbl6
				end,
				GetStockCosmetic = function()
					local cosmeticShopUi = playerGui:FindFirstChild("CosmeticShop_UI")
					local topSegment = cosmeticShopUi:FindFirstChild("TopSegment", true)
					local bottomSegment = cosmeticShopUi:FindFirstChild("BottomSegment", true)
					local tbl6 = {}

					for _, v_7 in { topSegment, bottomSegment }, nil, nil do
						for _, v_8 in v_7:GetChildren() do
							if v_8:IsA("Frame") then
								local stockText = v_8:FindFirstChild("STOCK_TEXT", true)

								if (tonumber(stockText and stockText.Text:match("%d+")) or 0) ~= 0 then
									table.insert(tbl6, { Name = v_8.Name, Type = v_7.Name })
								end
							end
						end
					end

					return tbl6
				end,
			}
		end

		tbl4.Shop = fn21()

		local function fn22()
			return {
				CreateESP = function(parent, arg)
					if not parent or not arg then
						return
					end

					if parent:FindFirstChild("ESP") then
						return
					end
					cached.ESP[parent] = arg
					local isModel = parent:IsA("Model")
					local primaryPart

					if isModel then
						primaryPart = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
					else
						primaryPart = isModel
					end

					primaryPart = primaryPart or parent
					if not primaryPart then
						return
					end
					local folder = Instance.new("Folder")
					folder.Name = "ESP"
					folder.Parent = parent
					local boxHandleAdornment = Instance.new("BoxHandleAdornment")
					boxHandleAdornment.Name = "ESP"
					boxHandleAdornment.Size = Vector3.new(1, 0, 1)
					boxHandleAdornment.Transparency = 1
					boxHandleAdornment.AlwaysOnTop = false
					boxHandleAdornment.ZIndex = 0
					boxHandleAdornment.Adornee = primaryPart
					boxHandleAdornment.Parent = folder
					local billboardGui = Instance.new("BillboardGui")
					billboardGui.Adornee = primaryPart
					billboardGui.Size = UDim2.new(0, 100, 0, 150)
					billboardGui.StudsOffset = Vector3.new(0, 1, 0)
					billboardGui.AlwaysOnTop = true
					billboardGui.Parent = boxHandleAdornment
					billboardGui.Enabled = arg.Enabled or true
					local textLabel = Instance.new("TextLabel")
					textLabel.BackgroundTransparency = 1
					textLabel.Position = UDim2.new(0, 0, 0, -50)
					textLabel.Size = UDim2.new(0, 100, 0, 100)
					textLabel.TextSize = 10
					textLabel.TextColor3 = arg.Color or Color3.fromRGB(255, 255, 0)
					textLabel.TextStrokeTransparency = 0
					textLabel.TextYAlignment = Enum.TextYAlignment.Bottom
					textLabel.RichText = true
					textLabel.Text = arg.Text or ""
					textLabel.ZIndex = 15
					textLabel.Parent = billboardGui

					if arg.Highlight and arg.Highlight.Enabled then
						local highlight = Instance.new("Highlight")
						highlight.Name = "ESPHighlight"
						highlight.FillColor = arg.Highlight.Color or Color3.fromRGB(255, 255, 255)
						highlight.OutlineColor = arg.Highlight.Color or Color3.fromRGB(255, 255, 255)
						highlight.FillTransparency = 0.5
						highlight.OutlineTransparency = 0
						highlight.Adornee = parent
						highlight.Parent = folder
					end
				end,
				Removes = function(arg)
					if not arg then
						return
					end

					task.spawn(function()
						local esp = arg:FindFirstChild("ESP")
						if not esp then
							return
						end
						local espHighlight = esp:FindFirstChild("ESPHighlight")

						if espHighlight then
							espHighlight:Destroy()
						end

						if esp then
							esp:Destroy()
						end
					end)
				end,
			}
		end

		tbl4.ESP = fn22()

		local function fn23()
			local tbl6

			tbl6 = {
				GetData = function()
					local ok, result = pcall(fn7, ReplicatedStorage.Modules.DataService)
					if ok then
						return result:GetData()
					end
					return nil
				end,
				GetPet_Data = function(arg)
					local petsData = tbl6.GetData()
					if not petsData then
						return
					end
					petsData = petsData and petsData.PetsData
					return (petsData and petsData.PetInventory.Data)[arg]
				end,
				GetPet_BoostData = function(arg)
					local v_7 = tbl6.GetPet_Data(arg)
					return v_7 and v_7.PetData and v_7.PetData.Boosts or nil
				end,
				GetLevel = function(arg)
					local v_7 = tbl6.GetPet_Data(arg)
					if not v_7 then
						return
					end
					return v_7 and v_7.PetData and v_7.PetData.Level
				end,
				GetSaved_Data = function()
					local saveSlots = tbl6.GetData()
					saveSlots = saveSlots and saveSlots.SaveSlots
					return saveSlots and saveSlots.AllSlots[saveSlots.SelectedSlot].SavedObjects
				end,
				GetBeeData = function()
					local v_7 = tbl6.GetData()
					return (v_7 and v_7.BeeEventData).BeeInventoryData
				end,
			}

			return tbl6
		end

		tbl4.DataClient = fn23()

		local function fn24()
			local tbl6

			tbl6 = {
				GetBoothActive = function()
					local dataAsync = require(ReplicatedStorage.Modules.ReplicationReciever).new("Booths"):GetDataAsync()
					local booths = dataAsync and dataAsync.Booths or {}
					local tbl7 = {}

					for _, v_7 in booths, nil, nil do
						if v_7 and v_7.Owner and v_7.Owner ~= "Player_" .. localPlayer.UserId then
							table.insert(tbl7, v_7.Owner)
						end
					end

					return tbl7
				end,
				GetBoothInventory = function(arg)
					local data = require(ReplicatedStorage.Modules.ReplicationReciever).new("Booths"):GetData()
					local tbl7 = {}

					for _, v_7 in tbl6.GetBoothActive(), nil, nil do
						local players = data and data.Players and data.Players[v_7]
						players = players and players.Items
						if arg and v_7 == "Player_" .. arg then
							return players
						end
						table.insert(tbl7, { Owner = v_7, Items = players })
					end

					return tbl7
				end,
				GetPriceItem = function(arg, arg2)
					local dataAsync = require(ReplicatedStorage.Modules.ReplicationReciever).new("Booths"):GetDataAsync()

					for _, v_7 in tbl6.GetBoothActive(), nil, nil do
						if arg and arg ~= v_7 then
							continue
						end
						local players = dataAsync and dataAsync.Players and dataAsync.Players[v_7]
						players = players and players.Listings

						for _, v_8 in players, nil, nil do
							if v_8 and v_8.ItemId == arg2 then
								return v_8.Price
							end
						end
					end

					return nil
				end,
				GetListingId = function(arg, arg2)
					local dataAsync = require(ReplicatedStorage.Modules.ReplicationReciever).new("Booths"):GetDataAsync()

					for _, v_7 in tbl6.GetBoothActive(), nil, nil do
						if arg and arg ~= v_7 then
							continue
						end
						local players = dataAsync and dataAsync.Players and dataAsync.Players[v_7]
						local listings = players and players.Listings

						for k, v_8 in listings, nil, nil do
							v_8 = v_8 and v_8.ItemId == arg2
							if v_8 then
								return k
							end
						end
					end

					return nil
				end,
			}

			return tbl6
		end

		tbl4.Booth_Client = fn24()

		local function fn25()
			if localPlayer:GetAttribute("Holdable_Client_Initialized") then
				return
			end
			localPlayer:SetAttribute("Holdable_Client_Initialized", true)
			local backpack = localPlayer:WaitForChild("Backpack")
			local connection = nil
			local connection2 = nil

			local function fn26(arg)
				return arg:IsA("Tool") and arg:GetAttribute("b") == "j"
			end

			local function fn27()
				local n = 0
				local tbl6 = {}

				task.spawn(function()
					local v_7 = tbl4.ToolFunction.GetAllTool()

					for _, v_8 in ipairs(v_7) do
						if fn26(v_8) and not tbl6[v_8] then
							tbl6[v_8] = true
							n += 1
						end
					end

					localPlayer:SetAttribute("Holdable_Backpack", n)
				end)
			end

			backpack.ChildAdded:Connect(fn27)
			backpack.ChildRemoved:Connect(fn27)

			local function fn28(character)
				if connection then
					connection:Disconnect()
					connection = nil
				end

				if connection2 then
					connection2:Disconnect()
					connection2 = nil
				end

				connection = character.ChildAdded:Connect(fn27)
				connection2 = character.ChildRemoved:Connect(fn27)
				fn27()
			end

			if localPlayer.Character then
				fn28(localPlayer.Character)
			else
				localPlayer:SetAttribute("Holdable_Backpack", 0)
			end

			localPlayer.CharacterAdded:Connect(fn28)
			fn27()
		end

		tbl4.Holdable_Client = fn25()

		local function fn26()
			local tbl6

			tbl6 = {
				Create_AttributePet = function(arg, arg2, arg3)
					for _, child in pairs(workspace.PetsPhysical:GetChildren()) do
						local name = localPlayer.Name

						if child:GetAttribute("OWNER") == name and child:GetAttribute("UUID") == arg2 then
							child:SetAttribute(arg, arg3)
						end
					end
				end,
				WebhookMutation = function(arg, arg2)
					local v_7 = tbl4.API.Data.PetMutationsCode[arg]
					local selectWhitelistMutationsPets = enabled["Select Whitelist Mutations Pets"]
					if not (table.find(selectWhitelistMutationsPets, "All") or table.find(selectWhitelistMutationsPets, v_7)) then
						return
					end
					local webhook = tbl4.Webhook
					local webhookUrl = enabled["Webhook URL"]
					local tbl7 = { content = enabled["Allow Ping On Ping Message/ID"] and enabled["Ping Message/ID"] or "" }
					local embeds = {}
					local tbl8 = { title = "**Speed Hub X | Grow A Garden**", type = "rich", color = tonumber("0xfa0c0c") }
					local fields = {}
					local tbl9 = { name = "** -> Profile : ** \n", value = "> Username : || " .. localPlayer.Name .. " ||", inline = false }

					local tbl10 = {
						name = "** -> Mutation Result : ** \n",
						value = "> Pet Name: ``" .. arg2 .. "``" .. "\n> Mutation Name: ``" .. (tostring(v_7) or "N/A") .. "``",
						inline = false,
					}

					fields[1] = tbl9
					fields[2] = tbl10
					tbl8.fields = fields
					tbl8.thumbnail = { url = tbl4.GetImageURL(tbl4.API.Data.Pets[arg2].Icon) or "" }
					embeds[1] = tbl8
					tbl7.embeds = embeds
					webhook(webhookUrl, tbl7)
				end,
				WebhookHatch = function(arg, arg2)
					local selectWhitelistPets = enabled["Select Whitelist Pets"]
					if not (table.find(selectWhitelistPets, "All") or table.find(selectWhitelistPets, arg2)) then
						return
					end
					local n = tonumber(enabled["Weights Threshold    "]) or 0
					local selectThresholdMode = enabled["Select Threshold Mode    "]
					local v_7 = tbl4.Calculator.CurrentWeight(arg.BaseWeight or 1, arg.Level or 1)
					local str2 = v_7 > 9 and "Titanic"
					local str3

					if str2 then
						str3 = str2
					else
						str3 = v_7 >= 6 and v_7 <= 9 and "Semi Titanic"
					end

					str3 = str3 or v_7 > 3 and "Huge" or "Small"

					if n == 0 or v_7 and (selectThresholdMode == "Above" and v_7 > n or v_7 < n) then
						local webhook = tbl4.Webhook
						local webhookUrl = enabled["Webhook URL"]
						local tbl7 = { content = enabled["Allow Ping On Ping Message/ID"] and enabled["Ping Message/ID"] or "" }
						local embeds = {}
						local tbl8 = { title = "**Speed Hub X | Grow A Garden**", type = "rich", color = tonumber("0xfa0c0c") }
						local fields = {}

						local tbl9 = {
							name = "** -> Profile : ** \n",
							value = "> Username : || " .. localPlayer.Name .. " ||",
							inline = false,
						}

						local tbl10 = {
							name = "** -> Hatched : ** \n",
							value = "> Pet Name: ``" .. arg2 .. "``" .. "\n> Hatched From: ``" .. (arg.HatchedFrom or "N/A") .. "``" .. "\n> Weight: ``" .. (tostring(math.floor(v_7) == v_7 and v_7 or ("%.2f"):format(v_7)) .. " KG" or "N/A") .. "``" .. "\n> Weight Status: ``" .. str3 .. "``" .. "\n> Hunger: ``" .. tostring(arg.Hunger or "N/A") .. "``",
							inline = false,
						}

						fields[1] = tbl9
						fields[2] = tbl10
						tbl8.fields = fields
						tbl8.thumbnail = { url = tbl4.GetImageURL(tbl4.API.Data.Pets[arg2].Icon) or "" }
						embeds[1] = tbl8
						tbl7.embeds = embeds
						webhook(webhookUrl, tbl7)
					end
				end,
				EggClient = function(arg)
					if not enabled["Webhook Egg Once Ready"] then
						return
					end

					pcall(function()
						local v_7 = tbl4.DataClient.GetSaved_Data()
						local v_8

						while true do
							task.wait()
							v_8 = v_7[arg]
							if not (type(v_8) == "table" or shx.Unloaded or not enabled["Webhook Egg Once Ready"]) then
								continue
							end
							break
						end

						local data = v_8.Data
						local type_ = data.Type or "N/A"
						local baseWeight = data.BaseWeight or 1
						local eggName = data.EggName or "N/A"
						local selectWhitelistPets = enabled["Select Whitelist Pets "]

						if not (selectWhitelistPets and #selectWhitelistPets > 1) then
							selectWhitelistPets = { "", "All" }
						end

						local selectWhitelistEggs = enabled["Select Whitelist Eggs"]

						if not (selectWhitelistEggs and #selectWhitelistEggs > 1) then
							selectWhitelistEggs = { "", "All" }
						end

						if not (table.find(selectWhitelistPets, "All") or table.find(selectWhitelistPets, type_)) then
							return
						end

						if not (table.find(selectWhitelistEggs, "All") or table.find(selectWhitelistEggs, eggName)) then
							return
						end
						local n = tonumber(enabled["Weights Pet Threshold"]) or 0
						local selectThresholdMode = enabled["Select Threshold Mode      "]
						local v_9 = tbl4.Calculator.CurrentWeight(baseWeight, 1)
						local str2 = v_9 > 9 and "Titanic"

						if not str2 then
							str2 = v_9 >= 6 and v_9 <= 9 and "Semi Titanic"
						end

						str2 = str2 or v_9 > 3 and "Huge" or "Small"

						if n == 0 or v_9 and (selectThresholdMode == "Above" and v_9 > n or v_9 < n) then
							local webhook = tbl4.Webhook
							local webhookUrl = enabled["Webhook URL"]
							local tbl7 = { content = enabled["Allow Ping On Ping Message/ID"] and enabled["Ping Message/ID"] or "" }
							local embeds = {}
							local tbl8 = { title = "**Speed Hub X | Grow A Garden**", type = "rich", color = tonumber("0xfa0c0c") }
							local fields = {}

							local tbl9 = {
								name = "** -> Profile : ** \n",
								value = "> Username : || " .. localPlayer.Name .. " ||",
								inline = false,
							}

							local tbl10 = {
								name = "** -> Egg Result : ** \n",
								value = "> Egg: ``" .. eggName .. "``" .. "\n> Pet: ``" .. type_ .. "``" .. "\n> Weight: ``" .. (tostring(math.floor(v_9) == v_9 and v_9 or ("%.2f"):format(v_9)) .. " KG" or "N/A") .. "``" .. "\n> Weight Status: ``" .. str2 .. "``",
								inline = false,
							}

							fields[1] = tbl9
							fields[2] = tbl10
							tbl8.fields = fields
							tbl8.thumbnail = { url = tbl4.GetImageURL(tbl4.API.Data.Pets[type_].Icon) or "" }
							embeds[1] = tbl8
							tbl7.embeds = embeds
							webhook(webhookUrl, tbl7)
						end
					end)
				end,
				LogClient = function(...)
					local tbl7 = { ... }
					local v_7 = tbl7[2]

					if tbl7[1] == "UpdateData" then
						if v_7 == "ActivePetsService_Replicator" then
							local tbl8 = tbl7[3]
							local v_8 = ipairs
							tbl8 = tbl8 or {}

							for _, v_9 in v_8(tbl8) do
								local v_10 = v_9[1]
								local v_11 = v_9[2]

								pcall(function()
									if string.find(v_10, localPlayer.Name) and string.find(v_10, "PetInventory") then
										local petType = v_11.PetType
										local petData = v_11.PetData
										if type(petType) ~= "string" or type(petData) ~= "table" then
											return
										end

										if enabled["Webhook Mutations Machine"] and petData.MutationType then
											task.spawn(tbl6.WebhookMutation, petData.MutationType, petType)
										end

										if enabled["Webhook Hatch Eggs"] then
											task.spawn(tbl6.WebhookHatch, petData, petType)
										end
									end
								end)
							end
						end

						if v_7 == localPlayer.Name .. "_DataServiceProfile" then
							local tbl8 = tbl7[3]
							local v_8 = ipairs
							tbl8 = tbl8 or {}

							for _, v_9 in v_8(tbl8) do
								local data = stored.Data
								local v_10 = v_9[2]
								local parts = v_9[1]:split("/")

								for i = 1, #parts do
									local v_11 = parts[i]

									if v_11 ~= "ROOT" then
										if v_11 ~= "PetsData" then
											if not data[v_11] then
												data[v_11] = {}
											end

											if i == #parts then
												if type(v_10) == "table" then
													for k, v_12 in v_10, nil, nil do
														data[v_11][k] = v_12
													end
												else
													data[v_11] = v_10
												end
											end

											data = data[v_11]
										end
									end
								end

								local petInventory = stored.Data.PetInventory

								if type(petInventory) == "table" and next(petInventory) then
									for k, v_11 in pairs(petInventory.Data) do
										local hunger = v_11.PetData and v_11.PetData.Hunger

										if hunger then
											task.spawn(tbl6.Create_AttributePet, "Hunger", k, hunger)
										end
									end
								end
							end
						end
					end
				end,
			}

			local connection = nil

			connection = gameEvents.DataStream.OnClientEvent:Connect(function(...)
				if shx.Unloaded then
					connection:Disconnect()
					connection = nil
					return
				end

				task.spawn(tbl6.LogClient, ...)
			end)

			local connection2 = nil

			connection2 = gameEvents.EggReadyToHatch_RE.OnClientEvent:Connect(function(arg, arg2)
				if shx.Unloaded then
					connection2:Disconnect()
					connection2 = nil
					return
				end

				task.spawn(tbl6.EggClient, arg2)
			end)

			local connection3 = nil

			connection3 = gameEvents.PetCooldownsUpdated.OnClientEvent:Connect(function(arg, arg2)
				if shx.Unloaded then
					connection3:Disconnect()
					connection3 = nil
					return
				end

				if type(arg) ~= "string" or type(arg2) ~= "table" then
					return
				end
				stored.PetCooldown[arg] = arg2
			end)

			return tbl6
		end

		tbl4.DataStream = fn26()

		local function fn27()
			return {
				Connections = function(arg, arg2)
					local v_7 = nil

					return (arg:Connect(function(...)
						if shx.Unloaded then
							if v_7 then
								v_7:Disconnect()
							end

							return
						end

						local ok, result = pcall(arg2, ...)

						if not ok then
							fn3(result, "")
						end
					end))
				end,
				StartLoop = function(arg, arg2)
					while not shx.Unloaded do
						if enabled[arg] then
							local ok, result = pcall(arg2)

							if not ok then
								fn3(result, arg)
							end
						end

						task.wait()
					end
				end,
				Fallback = function(arg, arg2, arg3, arg4)
					local str2 = arg4 or ""
					if not arg2 or not arg3 then
						return
					end
					cached.Count[arg2] = (cached.Count[arg2] or 0) + (arg ~= nil and 1 or 0)
					local v_7 = enabled[arg2]

					if cached.Count[arg2] > 1 then
						if str2 == "TextBox" and v_7 or str2 ~= "TextBox" and not v_7 then
							task.spawn(arg3)
						end
					end
				end,
			}
		end

		tbl4.Utils = fn27()

		local function fn28()
			local tbl6

			tbl6 = {
				Called = false,
				_Cache = { Server = {} },
				_LastRequest = 0,
				Handler_Cursor = function()
					local fn29 = writefile or function()
					end

					local fn30 = readfile or function()
						return ""
					end

					local fn31 = fn8 or function()
						return false
					end

					local placeId = game.PlaceId

					if fn9 and not fn9("Speed Hub X Server System") then
						pcall(fn10, "Speed Hub X Server System")
					end

					local str2 = "Speed Hub X Server System" .. "/Cached_Server_" .. placeId .. ".json"
					local str3 = "Speed Hub X Server System" .. "/Cursor_" .. placeId .. ".txt"
					local now = os.time()
					local lastRequest = tbl6._LastRequest
					if tick() - lastRequest < 2 then
						return tbl6._Cache
					end
					tbl6._LastRequest = tick()

					if fn31(str2) then
						local ok, cache = pcall(function()
							return HttpService:JSONDecode(fn30(str2))
						end)

						if ok and cache then
							if now - (cache.Cached_Time or 0) < 80 then
								tbl6._Cache = cache
								return cache
							end
						end
					end

					local v_7 = fn31(str3) and fn30(str3) or nil
					local str4 = ("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100") .. (v_7 and "&cursor=" .. v_7 or "")

					local ok, result = pcall(function()
						return game:HttpGet(str4)
					end)

					if not ok or not result then
						return tbl6._Cache
					end
					local data = HttpService:JSONDecode(result)
					pcall(fn29, str3, data.nextPageCursor or "")
					local cache = { Cached_Time = now, Server = data.data or {} }
					pcall(fn29, str2, HttpService:JSONEncode(cache))
					tbl6._Cache = cache
					return cache
				end,
				Handler_Server = function(arg)
					local jobId = game.JobId
					local v_7 = tbl6.Handler_Cursor()
					local tbl7 = {}
					if not v_7 or not v_7.Server then
						return tbl7
					end
					arg = arg or false

					for _, v_8 in ipairs(v_7.Server) do
						local id = v_8.id

						if id and id ~= jobId then
							local playing = v_8.playing or 0
							local maxPlayers = v_8.maxPlayers or 0

							if playing < maxPlayers then
								if arg then
									if playing >= maxPlayers * 0.7 and playing < maxPlayers then
										tbl7[#tbl7 + 1] = v_8
									end
								else
									tbl7[#tbl7 + 1] = v_8
								end
							end
						end
					end

					return tbl7
				end,
				Hop = function(arg)
					local v_7 = tbl6.Handler_Server(arg)

					if #v_7 > 0 then
						local v_8 = v_7[math.random(1, #v_7)]
						if not v_8 or not v_8.id then
							return
						end
						TeleportService:TeleportToPlaceInstance(game.PlaceId, v_8.id)
						tbl6.Called = true
					end
				end,
			}

			TeleportService.TeleportInitFailed:Connect(function(arg)
				if arg ~= localPlayer then
					return
				end

				if not tbl6.Called then
					return
				end
				tbl6.Called = false
				tbl6.Hop()
			end)

			return tbl6
		end

		tbl4.Server_Hop = fn28()
		return tbl4
	end

	module.Modules = fn12()
	local handlers = {}
	local modules = module.Modules
	local utils = modules.Utils
	local customDelay = modules.CustomDelay
	local toolFunction = modules.ToolFunction
	local collection = modules.Collection
	local sellFunction = modules.SellFunction
	local calculator = modules.Calculator
	local shop = modules.Shop
	local esp = modules.ESP
	local petTeams = modules.PetTeams

	shx.OnUnloaded:Connect(function()
		local esp2 = cached.ESP

		if esp2 and next(esp2) then
			for k in esp2, nil, nil do
				modules.ESP.Removes(k)
			end
		end
	end)

	handlers.Managers = {}
	local managers = handlers.Managers

	managers.GetSeedList = function(arg, arg2)
		local tbl4 = { "None" }

		for k in modules.API.Data.Fruits, nil, nil do
			if not (arg2 and not k:find(arg2)) then
				table.insert(tbl4, k)
			end
		end

		return tbl4
	end

	managers.GetListSeedPack = function()
		return {
			"All",
			"Night Seed Pack",
			"Festive Container",
			"Rainbow Exotic Flower Seed Pack",
			"Rare Gift",
			"Zenith Seed Pack",
			"Rainbow Exotic Culinarian Chest",
			"Rainbow Exotic Crafters Seed Pack",
			"Rainbow Exotic Enchanted Seed Pack",
			"Gourmet Seed Pack",
			"Normal Seed Pack",
			"Flower Seed Pack",
			"Silver Divine Seed Pack",
			"Exotic Hive Seed Pack",
			"Rainbow Exotic Sprout Seed Pack",
			"Rainbow Exotic Hive Seed Pack",
			"Exotic Gardener Seed Pack",
			"Hive Seed Pack",
			"Silver Common Seed Pack",
			"Silver Rare Seed Pack",
			"Exotic Kitsune Chest",
			"Exotic Zen Seed Pack",
			"Honey Hive Seed Pack",
			"Rainbow Exotic Easter Seed Pack",
			"Exotic Easter Seed Pack",
			"Exotic Santa's Surprise Present",
			"Easter Seed Pack",
			"Rainbow Exotic Enchanted Chest",
			"Admin Pack",
			"Exotic Enchanted Seed Pack",
			"Premium Night Seed Pack",
			"Rainbow Exotic Kitsune Chest",
			"Exotic Zenith Seed Pack",
			"Rainbow Gift",
			"Gold Gift",
			"Elemental Container",
			"Safari Seed Pack",
			"Mythical Gift",
			"Culinarian Chest",
			"Kitsune Chest",
			"Exotic Season 4 Seed Pack",
			"Rainbow Exotic Nutty Chest",
			"Rainbow Exotic Holiday Seed Pack",
			"Exotic Flower Seed Pack",
			"Bad Present",
			"Exotic Holiday Seed Pack",
			"Basic Seed Pack",
			"Exotic Nutty Chest",
			"Prime Seed Pack",
			"Exotic Summer Seed Pack",
			"Rainbow Exotic Santa's Surprise Present",
			"Rainbow Exotic Season 4 Seed Pack",
			"Rainbow Exotic Gourmet Seed Pack",
			"Halloween Gear Box",
			"Enchanted Chest",
			"Sprout Seed Pack",
			"Christmas Present",
			"Normal Present",
			"Silver Legendary Seed Pack",
			"Rare Present",
			"Rainbow Exotic Buttercup Chest",
			"Rainbow Exotic Skyroot Chest",
			"Exotic Buttercup Chest",
			"Exotic Ancient Seed Pack",
			"Rainbow Buttercup Chest",
			"Rainbow Basic Seed Pack",
			"Silver Mythical Seed Pack",
			"Silver Uncommon Seed Pack",
			"Rainbow Premium Seed Pack",
			"Artisan Container",
			"Zen Seed Pack",
			"Exotic Gem Chest",
			"Nutty Chest",
			"Rainbow Exotic Gem Chest",
			"Season 4 Seed Pack",
			"Gem Chest",
			"Rainbow Exotic Safari Seed Pack",
			"Exotic Crafters Seed Pack",
			"Exotic Safari Seed Pack",
			"Special Exotic Spooky Chest",
			"Common Gift",
			"Santa's Surprise Present",
			"Exotic Season 5 Seed Pack",
			"Exotic Spooky Chest",
			"Rainbow Exotic Fall Seed Pack",
			"Holiday Seed Pack",
			"Rainbow Exotic Season 5 Seed Pack",
			"Exotic Seed Pack",
			"Ancient Seed Pack",
			"Season 5 Seed Pack",
			"Silver Fall Seed Pack",
			"Rainbow Exotic Zen Seed Pack",
			"Rainbow Exotic Prime Seed Pack",
			"Exotic Enchanted Chest",
			"Exotic Culinarian Chest",
			"Enchanted Seed Pack",
			"Exotic Fall Seed Pack",
			"Rainbow Exotic Zenith Seed Pack",
			"Fall Seed Pack",
			"Summer Seed Pack",
			"Exotic Sprout Seed Pack",
			"Rainbow Gardener Seed Pack",
			"Crafters Seed Pack",
			"Rainbow Exotic Ancient Seed Pack",
			"Silver Prismatic Seed Pack",
			"Exotic Skyroot Chest",
			"Skyroot Chest",
			"Premium Seed Pack",
			"Gardener Seed Pack",
			"Buttercup Chest",
			"Spooky Chest",
			"Exotic Prime Seed Pack",
			"Exotic Gourmet Seed Pack",
			"Rainbow Exotic Summer Seed Pack",
		}
	end

	managers.GetMutationList = function(arg, arg2)
		local flag = arg2 or false
		local tbl4 = {}

		for k in modules.API.Data.Mutations, nil, nil do
			if not flag or flag ~= k then
				table.insert(tbl4, k)
			end
		end

		return tbl4
	end

	managers.GetSprinklerList = function()
		local tbl4 = {}

		for _, child in pairs(ReplicatedStorage.ObjectModels:GetChildren()) do
			if child:IsA("Model") and child.Name:find("Sprinkler") then
				table.insert(tbl4, child.Name)
			end
		end

		return tbl4
	end

	managers.GetPetFromUUID = function(arg, arg2)
		local ok, result = pcall(require, ReplicatedStorage.Modules.DataService)

		if ok and result then
			local data = result:GetData()

			if data and data.PetsData then
				local v_6 = data.PetsData.PetInventory.Data[arg2]
				if v_6 and v_6.PetType then
					return v_6.PetType
				end
			end
		end

		local petType = arg2 and playerGui:FindFirstChild(arg2, true)
		petType = petType and petType:FindFirstChild("PET_TYPE", true)
		if petType and petType:IsA("TextLabel") then
			return petType.Text
		end
	end

	managers.GetPetsList = function()
		local tbl4 = {}
		local petsPhysical = workspace:FindFirstChild("PetsPhysical")
		if not petsPhysical then
			return
		end

		for _, child in pairs(petsPhysical:GetChildren()) do
			local name = localPlayer.Name

			if child:GetAttribute("OWNER") == name and child:FindFirstChildWhichIsA("Model") then
				local attribute = child:GetAttribute("UUID")
				local petFromUUID = managers:GetPetFromUUID(attribute)

				if petFromUUID then
					table.insert(tbl4, petFromUUID .. " " .. attribute)
				end
			end
		end

		return tbl4
	end

	managers.GetPlayerList = function()
		local tbl4 = {}

		for _, v_6 in Players:GetPlayers(), nil, nil do
			if v_6 ~= localPlayer then
				table.insert(tbl4, v_6.Name)
			end
		end

		return tbl4
	end

	managers.GetPetsLists = function()
		local tbl4 = {}

		for k in pairs(modules.API.Data.Pets) do
			table.insert(tbl4, k)
		end

		return tbl4
	end

	managers.GetCrateList = function()
		local tbl4 = {}
		local crateModels = ReplicatedStorage:FindFirstChild("CrateModels", true)
		if not crateModels then
			return tbl4
		end

		for _, child in pairs(crateModels:GetChildren()) do
			if child:IsA("Model") then
				table.insert(tbl4, child.Name)
			end
		end

		return tbl4
	end

	managers.GetItemCrateList = function()
		local tbl4 = {}

		for _, crate in pairs(modules.API.Data.Crates) do
			table.insert(tbl4, crate)
		end

		return tbl4
	end

	managers.GetEggList = function(arg, arg2)
		local flag = arg2 or false
		local tbl4 = {}

		if flag then
			tbl4 = { "All" }
		end

		for _, child in pairs(ReplicatedStorage.Assets.Models.EggModels:GetChildren()) do
			table.insert(tbl4, child.Name)
		end

		return tbl4
	end

	managers.GetGoodPositions = function()
		local Plant_Locations = modules.GetFarmPath("Plant_Locations")
		if not Plant_Locations then
			return
		end
		local children = Plant_Locations:GetChildren()
		if #children == 0 then
			return
		end
		local tbl4 = {}

		for _, child in ipairs(children) do
			local n = math.floor(child.Size.X / 4)
			local n2 = math.floor(child.Size.Z / 4)

			for i = -n, n do
				for i2 = -n2, n2 do
					local vector_ = Vector3.new(i * 2, 0, i2 * 2)
					local v_6 = child.CFrame:PointToWorldSpace(vector_)
					table.insert(tbl4, v_6)
				end
			end
		end

		return tbl4
	end

	managers.GetRandomPlant = function()
		local Plant_Locations = modules.GetFarmPath("Plant_Locations")
		if not Plant_Locations then
			return
		end
		local children = Plant_Locations:GetChildren()
		local v_6 = children[math.random(1, #children)]
		local create = vector.create
		local x = v_6.Size.X
		local n = (math.random() - 0.5) * x
		local y = v_6.Size.Y
		local n2 = (math.random() - 0.5) * y
		local z = v_6.Size.Z
		local v_7 = create(n, n2, (math.random() - 0.5) * z)
		return v_6.CFrame:PointToWorldSpace(v_7)
	end

	managers.GetPetTime = function(arg, arg2)
		local v_6 = stored.PetCooldown[arg2]

		if v_6 then
			local tbl4 = {}
			local tbl5 = {}
			local tbl6 = {}

			for _, v_7 in pairs(v_6) do
				local time = v_7.Time
				local passive = v_7.Passive
				table.insert(tbl5, time)
				table.insert(tbl6, passive)

				if time <= 0 then
					table.insert(tbl4, "READY")
				elseif time >= 60 then
					table.insert(tbl4, ("%d:%02dm"):format(math.floor(time / 60), time % 60))
				else
					table.insert(tbl4, ("%ds"):format(time))
				end
			end

			return { Result = table.concat(tbl4, " | "), Time = tbl5, Passive = tbl6 }
		end
	end

	managers.GetPetPosition = function(arg, arg2, arg3)
		local flag = arg3 or false
		local tbl4 = {}
		local petsPhysical = workspace:FindFirstChild("PetsPhysical")
		if not petsPhysical then
			return tbl4
		end

		for _, child in ipairs(petsPhysical:GetChildren()) do
			local name = localPlayer.Name

			if child:GetAttribute("OWNER") == name then
				local attribute = child:GetAttribute("UUID")

				if attribute then
					local petFromUUID = managers:GetPetFromUUID(attribute)

					if petFromUUID and table.find(arg2, petFromUUID .. " " .. attribute) then
						local flag2

						if not flag then
							flag2 = true
						else
							local petTime = managers:GetPetTime(attribute)
							flag2 = petTime and petTime.Result and petTime.Result:find("READY")
						end

						if flag2 then
							tbl4[#tbl4 + 1] = { CFrame = child.CFrame }
						end
					end
				end
			end
		end

		return tbl4
	end

	managers.IsWeather = function()
		for k, v_6 in workspace:GetAttributes() do
			if v_6 == true and k ~= "AllowFakePurchase" and k ~= "AllWeather" then
				return true
			end
		end

		return false
	end

	managers.GetMutationName = function(arg, arg2)
		for k in modules.API.Data.Mutations, nil, nil do
			if arg2:GetAttribute(k) then
				return k
			end
		end

		return "None"
	end

	managers.GetMutationName_T = function(arg, arg2)
		local tbl4 = {}

		for k in modules.API.Data.Mutations, nil, nil do
			if arg2:GetAttribute(k) then
				table.insert(tbl4, k)
			end
		end

		return #tbl4 > 0 and table.concat(tbl4, ", ") or "None"
	end

	managers.FormatMutation = function(arg, arg2)
		if not arg2 or arg2 == "None" then
			return ""
		end
		local flag = type(arg2) == "table" and arg2 or string.split(arg2, ", ")
		local tbl4 = {}
		local insert = table.insert
		local mutations = modules.API.Data.Mutations

		for _, v_6 in ipairs(flag) do
			local color = mutations[v_6]
			color = color and color.Color
			local color2 = color and Color3.fromRGB(color.r, color.g, color.b) or Color3.new(1, 1, 1)
			insert(tbl4, ("<font color=\"rgb(%d,%d,%d)\">%s</font>"):format(math.floor(color2.R * 255), math.floor(color2.G * 255), math.floor(color2.B * 255), v_6))
		end

		return table.concat(tbl4, ", ")
	end

	managers.FormatVariant = function(arg, arg2, arg3)
		if not arg2 then
			return "<font color=\"rgb(255,255,255)\">None</font>"
		end
		local value = arg2.Value
		local str2

		if value == "Gold" then
			str2 = "rgb(255,215,0)"
		elseif value == "Rainbow" then
			local n = math.floor(arg3.R * 255)
			local n2 = math.floor(arg3.G * 255)
			local n3 = math.floor(arg3.B * 255)
			str2 = ("rgb(%d,%d,%d)"):format(n, n2, n3)
		else
			str2 = "rgb(255,255,255)"
		end

		return ("<font color=\"%s\">%s</font>"):format(str2, value)
	end

	managers.GetSpinnerClosest = function()
		local rollCrateUi = playerGui:FindFirstChild("RollCrate_UI")
		if not (rollCrateUi and rollCrateUi.Enabled) then
			return
		end
		local frame = rollCrateUi:FindFirstChild("Frame")
		if not frame then
			return
		end
		local section = frame:FindFirstChild("Section")
		section = section and section:FindFirstChild("Spinner")
		local arrow = frame:FindFirstChild("Arrow")
		if not (section and arrow) then
			return
		end
		local x = arrow.AbsolutePosition.X
		local huge = math.huge
		local v_6 = nil

		for i = 1, #section:GetChildren() do
			local v_7 = section:GetChildren()[i]

			if v_7:IsA("Frame") then
				local n = math.abs(v_7.AbsolutePosition.X - x)

				if n < huge then
					huge = n
					v_6 = v_7
				end
			end
		end

		return v_6
	end

	managers.DecimalNumberFormat = function(arg, arg2)
		return math.floor(arg2) == arg2 and arg2 or ("%.2f"):format(arg2)
	end

	managers.GetCraftTable = function(arg, arg2)
		local tbl4 = { "None" }

		for k, v_6 in modules.API.Craft, nil, nil do
			if v_6.MachineTypes and v_6.MachineTypes[1] == arg2 then
				table.insert(tbl4, k)
			end
		end

		return tbl4
	end

	managers.ProgressCraft = function(arg, arg2, arg3, arg4, arg5, arg6)
		local craftingProximityPrompt = arg4:FindFirstChild("CraftingProximityPrompt", true)

		if craftingProximityPrompt and craftingProximityPrompt.ActionText == "Skip" then
			local flag

			if enabled["Auto Switch File "] then
				flag = managers:FireFile(enabled["Select File (For Speed Up)"], "Delay To Switch   ")
			elseif enabled["Auto Switch Loadouts "] then
				flag = managers:FireSlotLoadout(enabled["Select Slot (For Speed Up)"], "Delay To Switch ")
			else
				flag = true
			end

			if flag then
				return
			end
		end

		if craftingProximityPrompt.ActionText == "Claim" then
			local flag

			if enabled["Auto Switch File "] then
				flag = managers:FireFile(enabled["Select File (For Claim Craft)"], "Delay To Switch   ")
			elseif enabled["Auto Switch Loadouts "] then
				flag = managers:FireSlotLoadout(enabled["Select Slot (For Claim Craft)"], "Delay To Switch ")
			else
				flag = true
			end

			if flag then
				gameEvents.CraftingGlobalObjectService:FireServer("Claim", arg4, arg3, 1)
				task.wait(1)
				return
			end
		end

		for k, v_6 in arg5.Inputs, nil, nil do
			if enabled[arg2] then
				if craftingProximityPrompt.ActionText == "Select Recipe" then
					gameEvents.CraftingGlobalObjectService:FireServer("SetRecipe", arg4, arg3, arg6)
					task.wait(1)
				end

				local v_7 = toolFunction.GetItem(v_6.ItemData.ItemName, v_6.ItemType)

				if v_7 then
					local flag

					if enabled["Auto Switch File "] then
						flag = managers:FireFile(enabled["Select File (For Crafting)"], "Delay To Switch   ")
					elseif enabled["Auto Switch Loadouts "] then
						flag = managers:FireSlotLoadout(enabled["Select Slot (For Crafting)"], "Delay To Switch ")
					else
						flag = true
					end

					if flag then
						gameEvents.CraftingGlobalObjectService:FireServer("InputItem", arg4, arg3, k, { ItemType = v_6.ItemType, ItemData = { UUID = v_7:GetAttribute("c") } })
						task.wait(1.5)
						gameEvents.CraftingGlobalObjectService:FireServer("Craft", arg4, arg3)
					end
				end

				continue
			end

			break
		end
	end

	managers.GetPetMutationName = function(arg, arg2)
		for _, v_6 in modules.API.Data.PetMutations, nil, nil do
			if arg2:find(v_6, 1, true) then
				return v_6
			end
		end

		return nil
	end

	managers.CleanMutation_Pet = function(arg, arg2)
		if not ({
			["Rainbow Bacon Pig"] = true,
			["Corrupted Kodama"] = true,
			["Rainbow Kodama"] = true,
			["Rainbow Cardinal"] = true,
			["Rainbow Chinchilla"] = true,
			Crocodile = true,
			Rhino = true,
			["Silver Monkey"] = true,
			Giraffe = true,
			["Rainbow Griffin"] = true,
			["Corrupted Kitsune"] = true,
			["Rainbow Maneki-neko"] = true,
			["Silver Dragonfly"] = true,
			["Rainbow Mizuchi"] = true,
			["Golden Bee"] = true,
			["Rainbow Pachycephalosaurus"] = true,
			["Rainbow Giraffe"] = true,
			["Rainbow Stag Beetle"] = true,
			["Rainbow Farmer Chipmunk"] = true,
			["Rainbow Elk"] = true,
			["Rainbow Blue Jay"] = true,
			Oxpecker = true,
			["Rainbow Shroomie"] = true,
			["Rainbow Hydra"] = true,
			["Rainbow Oxpecker"] = true,
			["Rainbow Hotdog Daschund"] = true,
			["Rainbow Fortune Squirrel"] = true,
			["Rainbow Idol Chipmunk"] = true,
			["Rainbow Dilophosaurus"] = true,
			["Lemon Lion"] = true,
			["Rainbow Elephant"] = true,
			["Rainbow Zebra"] = true,
			["Rainbow Rhino"] = true,
			["GIANT Silver Dragonfly"] = true,
			["Rainbow Corrupted Kitsune"] = true,
			["Rainbow Ankylosaurus"] = true,
			["Glimmering Sprite"] = true,
			["Rainbow Mandrake"] = true,
			["Luminous Sprite"] = true,
			Lion = true,
			["Rainbow Phoenix"] = true,
			["Golden Lab"] = true,
			["Rainbow Lobster Thermidor"] = true,
			["Rainbow Parasaurolophus"] = true,
			["Rainbow Spinosaurus"] = true,
			["Golden Goose"] = true,
			["Rainbow Iguanodon"] = true,
		})[arg2] then
			local petMutationName = managers:GetPetMutationName(arg2)

			if petMutationName then
				arg2 = arg2:gsub(petMutationName, "", 1):gsub("^%s", "")
			end
		end

		return arg2
	end

	managers.ListBoostItem = function()
		local tbl4 = {}
		local petBoosts = ReplicatedStorage:FindFirstChild("PetBoosts", true)

		for _, v_6 in petBoosts:GetChildren() do
			if v_6:IsA("Model") then
				table.insert(tbl4, v_6.Name)
			end
		end

		return tbl4
	end

	managers.IsPlacedMax = function()
		local Objects_Physical = modules.GetFarmPath("Objects_Physical")
		if not Objects_Physical then
			return
		end
		local n = 0

		for _, child in ipairs(Objects_Physical:GetChildren()) do
			if child:IsA("Model") and child.Name == "PetEgg" then
				n += 1
			end
		end

		return n >= enabled["Place Egg Max"]
	end

	managers.IsSwitchingActive = function()
		return stored.Pet_Switcher["Switch Lock"] or stored.Pet_Switcher["Is Switching"]
	end

	managers.IsOperationBlocked = function()
		return stored.Pet_Switcher["Hatching Egg"] or stored.Pet_Switcher["Selling Pet"] or stored.Pet_Switcher["Place Egg"] or stored.Pet_Switcher["Stop Switch"] or stored.Pet_Switcher["Pick Place Active"] or managers:IsSwitchingActive()
	end

	managers.CanSwitch = function()
		if managers:IsSwitchingActive() then
			return false
		end
		return not (stored.Pet_Switcher["Hatching Egg"] or stored.Pet_Switcher["Selling Pet"] or stored.Pet_Switcher["Place Egg"] or stored.Pet_Switcher["Pick Place Active"])
	end

	managers.SlotLoadout = function(arg, arg2)
		if not arg2 or arg2 == "None" or arg2 == "" then
			return false
		end
		local n = arg2 == "3" and 2
		local n2

		if n then
			n2 = n
		else
			n2 = arg2 == "2" and 3
		end

		n2 = n2 or arg2 == "4" and 4 or arg2 == "5" and 5 or arg2 == "6" and 6 or 1
		local activePetUI = playerGui:FindFirstChild("ActivePetUI")
		if not activePetUI then
			return false
		end
		local buttonHolder = activePetUI:FindFirstChild("ButtonHolder", true)
		if not buttonHolder then
			return false
		end
		local v_6 = buttonHolder:FindFirstChild("PET_LOADOUT_" .. n2)
		if not v_6 then
			return false
		end
		return v_6.BackgroundColor3 == Color3.fromRGB(36, 227, 36)
	end

	managers.SetLoadout = function(arg, arg2)
		if not arg2 or arg2 == "None" or arg2 == "" then
			return false
		end
		local n = arg2 == "3" and 2 or arg2 == "2" and 3 or arg2 == "4" and 4 or arg2 == "5" and 5
		local n2

		if n then
			n2 = n
		else
			n2 = arg2 == "6" and 6
		end

		local n3 = n2 or 1

		return (pcall(function()
			gameEvents.PetsService:FireServer("SwapPetLoadout", n3)
		end))
	end

	managers.FireSlotLoadout = function(arg, loadout, arg2)
		if not loadout or loadout == "None" or loadout == "" then
			return false
		end

		if managers:SlotLoadout(loadout) then
			return true
		end
		task.wait(tonumber(enabled[arg2]) or 1)

		if stored.Pet_Switcher["Switch Lock"] then
			local n = 0

			while stored.Pet_Switcher["Switch Lock"] and n < 15 do
				task.wait(0.5)
				n += 0.5
			end

			if stored.Pet_Switcher["Switch Lock"] then
				return false
			end
		end

		stored.Pet_Switcher["Switch Lock"] = true
		stored.Pet_Switcher["Is Switching"] = true
		stored.Pet_Switcher["Current Operation"] = "Loadout: " .. loadout
		local n = 0
		local n2 = 0
		local flag

		while true do
			local flag2 = not enabled["Auto Switch Loadouts"] and not enabled["Auto Switch Loadouts "]

			if flag2 then
				flag2 = not (enabled["Auto Mutations Pets"] and enabled["Allows Switch Loadouts"])
			end

			flag = false

			if not flag2 then
				if not shx.Unloaded then
					managers:SetLoadout(loadout)
					task.wait(0.4)

					if managers:SlotLoadout(loadout) then
						flag = true
						break
					else
						n += 0.4
						n2 += 1
						if not (n >= 12 or n2 >= 30) then
							continue
						end
					end
				end
			end

			break
		end

		stored.Pet_Switcher["Switch Lock"] = false
		stored.Pet_Switcher["Is Switching"] = false
		stored.Pet_Switcher["Current Operation"] = nil

		if flag then
			stored.Pet_Switcher["Last Switch Time"] = tick()
			task.wait(1.5)
		end

		return flag
	end

	managers.SetFile = function(arg, team)
		if team == nil or team == "" or team == "None" then
			return false
		end
		local v_6 = petTeams.ReadPetTeam(team)
		if not v_6 then
			return false
		end
		local tbl4 = {}

		if #v_6 > 0 then
			local petsPhysical = workspace:FindFirstChild("PetsPhysical")

			if petsPhysical then
				for _, child in ipairs(petsPhysical:GetChildren()) do
					local name = localPlayer.Name

					if child:GetAttribute("OWNER") == name then
						pcall(function()
							gameEvents.PetsService:FireServer("UnequipPet", child:GetAttribute("UUID"))
						end)
					end
				end
			end

			task.wait(0.8)

			for _, v_7 in ipairs(v_6) do
				if pcall(function()
					gameEvents.PetsService:FireServer("EquipPet", v_7, localPlayer.Character.HumanoidRootPart.CFrame)
				end) then
					table.insert(tbl4, v_7)
				end
			end

			local n = 0

			while #tbl4 > 0 and n < 35 do
				for i = #tbl4, 1, -1 do
					if modules.CheckPets(tbl4[i]) == true then
						table.remove(tbl4, i)
					end
				end

				if #tbl4 > 0 then
					task.wait(0.15)
					n += 0.15
				end
			end

			if #tbl4 == 0 then
				cached.Team = team
				shx:SetNotification({ "Speed Hub X", "", "Successfully Equipped " .. team, 5, 0.5 })
				return true
			end

			cached.Team = nil

			shx:SetNotification({
				"Speed Hub X",
				"",
				"Failed to equip team " .. team .. ". " .. #tbl4 .. " pets missing.",
				5,
				0.5,
			})

			return false
		end

		return false
	end

	managers.FireFile = function(arg, file, arg2)
		if not file or file == "" or file == "None" then
			return false
		end

		if cached.Team == file then
			return true
		end
		task.wait(tonumber(enabled[arg2]) or 1)

		if stored.Pet_Switcher["Switch Lock"] then
			local n = 0

			while stored.Pet_Switcher["Switch Lock"] and n < 15 do
				task.wait(0.5)
				n += 0.5
			end

			if stored.Pet_Switcher["Switch Lock"] then
				return false
			end
		end

		stored.Pet_Switcher["Switch Lock"] = true
		stored.Pet_Switcher["Is Switching"] = true
		stored.Pet_Switcher["Current Operation"] = "File: " .. file
		local flag = false
		local n = 0

		while true do
			if not (not enabled["Auto Switch File"] and not enabled["Auto Switch File "]) then
				if not shx.Unloaded then
					flag = managers:SetFile(file)

					if not flag then
						task.wait(1)
						n += 1
						if not (n >= 12) then
							continue
						end
					end
				end
			end

			break
		end

		stored.Pet_Switcher["Switch Lock"] = false
		stored.Pet_Switcher["Is Switching"] = false
		stored.Pet_Switcher["Current Operation"] = nil

		if flag then
			stored.Pet_Switcher["Last Switch Time"] = tick()
			task.wait(1.5)
		end

		return flag
	end

	local function fn13()
		managers.CheckEgg = function(arg, arg2)
			if not (str:find("Solara") or str:find("Xeno")) then
				local v_6 = modules.DataClient.GetSaved_Data()
				if not v_6 or not v_6[arg2] then
					return true
				end
				local v_7 = v_6[arg2]
				if not v_7 or not v_7.Data then
					return true
				end
				local data = v_7.Data
				local type_ = data.Type or "N/A"
				local baseWeight = data.BaseWeight or 1
				local choosePets = enabled["Choose Pets "]

				if #choosePets > 1 and not table.find(choosePets, "None") then
					if enabled["Select Filter Mode"] == "Blacklist" then
						if table.find(choosePets, type_) then
							return false
						end
					elseif not table.find(choosePets, type_) then
						return false
					end
				end

				local n = tonumber(enabled["Weights Pet Threshold "]) or 0
				local selectThresholdMode = enabled["Select Threshold Mode       "]
				local v_8 = modules.Calculator.CurrentWeight(baseWeight, 1)
				return n == 0 or v_8 and selectThresholdMode == "Above" and v_8 > n or selectThresholdMode ~= "Above" and v_8 < n
			end

			return true
		end
	end

	fn13()

	managers.GetCountPlacedEggs = function()
		local Objects_Physical = modules.GetFarmPath("Objects_Physical")
		if not Objects_Physical then
			return false
		end
		local n = 0

		for _, child in ipairs(Objects_Physical:GetChildren()) do
			if child:IsA("Model") and child.Name == "PetEgg" then
				n += 1
			end
		end

		return n
	end

	managers.GetRequiredEvent = function()
		local easter2026 = workspace:FindFirstChild("Easter2026", true)
		easter2026 = easter2026 and easter2026:FindFirstChild("TurnIn")
		easter2026 = easter2026 and easter2026:FindFirstChild("RequestSign")
		easter2026 = easter2026 and easter2026:FindFirstChild("SurfaceGui", true)
		if not easter2026 then
			return
		end
		local infoLabel = easter2026:FindFirstChild("InfoLabel")
		local nameLabel = easter2026:FindFirstChild("NameLabel")
		local tbl4 = { Normal = true, Gold = true, Rainbow = true, Silver = true }
		infoLabel = infoLabel and infoLabel.Text
		local num = nil
		local v_6 = nil
		local v_7 = nil

		if infoLabel then
			local tbl5 = {}

			for match in string.gmatch(infoLabel, "([^,]+)") do
				tbl5[#tbl5 + 1] = match:gsub("^%s+", ""):gsub("%s+$", "")
			end

			num = nil

			if tbl5[1] then
				num = tonumber(tbl5[1]:match("([%d%.%-]+)"))
			end

			v_6 = nil
			v_7 = nil

			for i = 2, #tbl5 do
				local v_8 = tbl5[i]

				if tbl4[v_8] then
					v_6 = v_8
				else
					v_7 = v_8
				end
			end
		end

		return nameLabel and nameLabel.Text or nil, num, v_6, v_7
	end

	managers.GetCurrentChoc = function()
		local chocCoinCurrencyUi = playerGui:FindFirstChild("ChocCoinCurrency_UI")
		chocCoinCurrencyUi = chocCoinCurrencyUi and chocCoinCurrencyUi:FindFirstChild("Frame")
		chocCoinCurrencyUi = chocCoinCurrencyUi and chocCoinCurrencyUi:FindFirstChild("val", true)
		return chocCoinCurrencyUi and chocCoinCurrencyUi.Value or 0
	end

	managers.GetCurrentToken = function()
		local tradeTokenCurrencyUi = playerGui:FindFirstChild("TradeTokenCurrency_UI")
		local tradeTokens = tradeTokenCurrencyUi and tradeTokenCurrencyUi:FindFirstChild("TradeTokens")
		tradeTokens = tradeTokens and tradeTokens:FindFirstChild("TextLabel1")
		tradeTokens = tradeTokens and tradeTokens:FindFirstChild("val", true)
		return tradeTokens and tradeTokens.Value or 0
	end

	managers.GetCurrentHoney = function()
		local honeyCoinCurrencyUi = playerGui:FindFirstChild("HoneyCoinCurrency_UI")
		honeyCoinCurrencyUi = honeyCoinCurrencyUi and honeyCoinCurrencyUi:FindFirstChild("val", true)
		return honeyCoinCurrencyUi and honeyCoinCurrencyUi.Value or 0
	end

	managers.GetCurrentJelly = function()
		local royalJellyCurrencyUi = playerGui:FindFirstChild("RoyalJellyCurrency_UI")
		royalJellyCurrencyUi = royalJellyCurrencyUi and royalJellyCurrencyUi:FindFirstChild("val", true)
		return royalJellyCurrencyUi and royalJellyCurrencyUi.Value or 0
	end

	managers.GetStackOwner = function()
		local candyPackaging = workspace:FindFirstChild("CandyPackaging", true)
		candyPackaging = candyPackaging and candyPackaging:FindFirstChild("Stacks")

		for _, child in pairs(candyPackaging:GetChildren()) do
			local sign = child:FindFirstChild("Sign")
			sign = sign and sign:FindFirstChild("Billboard")
			sign = sign and sign:FindFirstChild("SurfaceGui")
			local textLabel = sign and sign:FindFirstChild("Frame") and sign.Frame:FindFirstChild("TextLabel")
			if textLabel and textLabel.Text == localPlayer.Name then
				return child
			end
		end

		return nil
	end

	managers.GetPlantTrait = function(arg, arg2)
		local v_6 = fn7(ReplicatedStorage.Modules.PlantTraitsData)
		if not v_6 then
			return
		end
		return v_6[arg2]
	end

	local managers2 = handlers.Managers

	handlers.LoadLibrary = function()
		local v_6 = shx:CreateWindow({
			Title = "Speed Hub X | Version 5.5.3 | discord.gg/speedhubx",
			Description = "",
			["Tab Width"] = 130,
			SaveSystem = { Enable = true, File = "Grow a Garden" },
			Key = "KZgN0t5pK6hBaqVLAMLg27aqXNDb8v",
			Key1 = "c9RkyXAjNpJc9u1fexvw1cbxYTWvMy",
			Key2 = "Xp8712WzbaRn8EtrLnXk8gDdzQB8jF",
			Key3 = "wixUQtibEtmkTQ7WpSFGq4YfBuqJQy",
			Key4 = "KbSf6UWZ6vndbgp8Vh9EHdM0dU8DFf",
			Key5 = "mP3tTRKYwhNKLkpFCdVuj922xqTgJp",
			Key6 = "heMGEmHXFUaiTaStAihwTfwgSJguUwQQxdE",
			Key7 = "khEXYXSHSJpDabFqudKJWEWbEyzXYgLmgTF",
			Key8 = "MLGkWCxxHaqhumMpSmpvJMuiUEpeqUAYvxN",
		})

		local tbl4 = {
			Home = v_6:CreateTab({ Name = "Home", Icon = "rbxassetid://10734942198" }),
			Main = v_6:CreateTab({ Name = "Main", Icon = "rbxassetid://10723407389" }),
			Automatically = v_6:CreateTab({ Name = "Automatically", Icon = "rbxassetid://10734923549" }),
			Inventory = v_6:CreateTab({ Name = "Inventory", Icon = "rbxassetid://10709769841" }),
			Shop = v_6:CreateTab({ Name = "Shop", Icon = "rbxassetid://10734952273" }),
			TradingMarket = v_6:CreateTab({ Name = "Trading Market", Icon = "rbxassetid://82291850711895" }),
			Webhook = v_6:CreateTab({ Name = "Webhook", Icon = "rbxassetid://17320556264" }),
			Miscellaneous = v_6:CreateTab({ Name = "Misc", Icon = "rbxassetid://11447063791" }),
			Settings = v_6:CreateTab({ Name = "Settings", Icon = "rbxassetid://10734950309" }),
		}

		funcs:Button(tbl4.Home:AddSection("Discord", true), "Discord Invite", "Copy invite link", function()
			setclipboard("https://discord.gg/speedhubx")
		end)

		local LocalPlayer = tbl4.Home:AddSection("LocalPlayer")

		funcs:Textbox(LocalPlayer, "Set Speed", "", false, true, function(arg)
			enabled["Set Speed"] = tonumber(arg) or 20
		end)

		funcs:Toggle(LocalPlayer, "Enable Walkspeed", "", false, true, function(arg)
			enabled["Enable Walkspeed"] = arg

			task.spawn(function()
				utils.Fallback(arg, "Enable Walkspeed", function()
					local character = localPlayer and localPlayer.Character
					character = character and character:FindFirstChild("Humanoid")

					if character then
						character.WalkSpeed = 16
					end
				end)
			end)
		end)

		funcs:Toggle(LocalPlayer, "No Clip", "", false, true, function(arg)
			enabled["No Clip"] = arg

			utils.Fallback(arg, "No Clip", function()
				local character = localPlayer and localPlayer.Character

				for _, child in pairs(character:GetChildren()) do
					if child:IsA("BasePart") then
						child.CanCollide = true
					end
				end
			end)
		end)

		funcs:Toggle(LocalPlayer, "Infinite Jump", "", false, true, function(arg)
			enabled["Infinite Jump"] = arg

			utils.Connections(UserInputService.JumpRequest, function()
				local character = localPlayer and localPlayer.Character
				character = character and character:FindFirstChild("Humanoid")

				if character and enabled["Infinite Jump"] then
					character:ChangeState("Jumping")
				end
			end)
		end)

		local v_7 = tbl4.Main:AddSection("Automation Plants")

		funcs:Dropdown(v_7, "Select Seeds", "", true, managers2:GetSeedList(), { "" }, true, function(arg)
			enabled["Select Seeds"] = arg
		end)

		funcs:Dropdown(v_7, "Select Position", "", false, { "Good Position", "Random", "Player Position" }, { "" }, true, function(arg)
			enabled["Select Position"] = arg
		end)

		funcs:Textbox(v_7, "Delay To Plants", "", "0", true, function(arg)
			enabled["Delay To Plants"] = tonumber(arg)
		end)

		funcs:Toggle(v_7, "Auto Plants Seed", "", false, true, function(arg)
			enabled["Auto Plants Seed"] = arg
		end)

		funcs:Toggle(v_7, "Auto Plants All Seeds", "", false, true, function(arg)
			enabled["Auto Plants All Seeds"] = arg
		end)

		local v_8 = tbl4.Main:AddSection("Automation Collection")
		v_8:AddSeperator({ " - [ Config ] - " })

		funcs:Toggle(v_8, "Stop Collect If Weather Is Here", "", false, true, function(arg)
			enabled["Stop Collect If Weather Is Here"] = arg
		end)

		funcs:Toggle(v_8, "Instant Collect", "It will lag/freeze if you have too many plants, but the lag/freeze will stop after 5 seconds.", false, true, function(arg)
			enabled["Instant Collect"] = arg
		end)

		funcs:Toggle(v_8, "Stop Collect If Backpack Is Full Max", "", false, true, function(arg)
			enabled["Stop Collect If Backpack Is Full Max"] = arg
		end)

		funcs:Toggle(v_8, "Disable Collect Prompt", "Prevention Accident Collect", false, true, function(arg)
			enabled["Disable Collect Prompt"] = arg

			task.spawn(pcall, function()
				if not arg then
					return
				end

				for _, v_9 in modules.GetFarmPath("Plants_Physical"):QueryDescendants("ProximityPrompt") do
					if v_9:GetAttribute("Backup_MaxDist") == nil then
						v_9:SetAttribute("Backup_MaxDist", v_9.MaxActivationDistance)
					end

					if arg then
						v_9.MaxActivationDistance = 0
					end
				end
			end)

			utils.Fallback(arg, "Disable Collect Prompt", function()
				for _, v_9 in modules.GetFarmPath("Plants_Physical"):QueryDescendants("ProximityPrompt") do
					local attribute = v_9:GetAttribute("Backup_MaxDist")

					if attribute then
						v_9.MaxActivationDistance = attribute
					end
				end
			end)
		end)

		funcs:Textbox(v_8, "Delay To Collect", "", "0", true, function(arg)
			enabled["Delay To Collect"] = tonumber(arg)
		end)

		v_8:AddSeperator({ " - [ Collect Whitelist Fruit ] - " })

		funcs:Dropdown(v_8, "Select Whitelist Fruit", "", true, managers2:GetSeedList(), { "" }, true, function(arg)
			enabled["Select Whitelist Fruit"] = arg
		end)

		funcs:Toggle(v_8, "Auto Collect Whitelisted Fruits", "", false, true, function(arg)
			enabled["Auto Collect Whitelisted Fruits"] = arg
		end)

		v_8:AddSeperator({ " - [ Collect Whitelist Mutation ] - " })

		funcs:Dropdown(v_8, "Select Whitelist Mutations", "", true, managers2:GetMutationList(), { "" }, true, function(arg)
			enabled["Select Whitelist Mutations"] = arg
		end)

		funcs:Toggle(v_8, "Auto Collect Whitelisted Mutations", "", false, true, function(arg)
			enabled["Auto Collect Whitelisted Mutations"] = arg
		end)

		v_8:AddSeperator({ " - [ Collect Whitelist ] - " })

		funcs:Dropdown(v_8, "Select Whitelist Fruits", "", true, managers2:GetSeedList(), { "" }, true, function(arg)
			enabled["Select Whitelist Fruits"] = arg
		end)

		funcs:Dropdown(v_8, "Select Whitelist Mutation", "", true, managers2:GetMutationList(), { "" }, true, function(arg)
			enabled["Select Whitelist Mutation"] = arg
		end)

		funcs:Dropdown(v_8, "Select Whitelist Variant", "", true, modules.Variant, { "" }, true, function(arg)
			enabled["Select Whitelist Variant"] = arg
		end)

		funcs:Dropdown(v_8, "Whitelist Weight Mode", "", false, { "Above", "Below" }, { "" }, true, function(arg)
			enabled["Whitelist Weight Mode"] = arg
		end)

		funcs:Textbox(v_8, "Whitelist Weight", "If you don't use this, Just Input `0`", "0", true, function(arg)
			enabled["Whitelist Weight"] = tonumber(arg)
		end)

		funcs:Toggle(v_8, "Auto Collect Fruits ", "", false, true, function(arg)
			enabled["Auto Collect Fruits (Whitelist)"] = arg
		end)

		v_8:AddSeperator({ " - [ Collect Blacklist ] - " })

		funcs:Dropdown(v_8, "Select Blacklist Fruits", "", true, managers2:GetSeedList(), { "" }, true, function(arg)
			enabled["Select Blacklist Fruits"] = arg
		end)

		funcs:Dropdown(v_8, "Select Blacklist Mutation", "", true, managers2:GetMutationList(), { "" }, true, function(arg)
			enabled["Select Blacklist Mutation"] = arg
		end)

		funcs:Dropdown(v_8, "Select Blacklist Variant", "", true, modules.Variant, { "" }, true, function(arg)
			enabled["Select Blacklist Variant"] = arg
		end)

		funcs:Dropdown(v_8, "Blacklist Weight Mode", "", false, { "Above", "Below" }, { "" }, true, function(arg)
			enabled["Blacklist Weight Mode"] = arg
		end)

		funcs:Textbox(v_8, "Blacklist Weight", "If you don't use this, Just Input `0`", "0", true, function(arg)
			enabled["Blacklist Weight"] = tonumber(arg)
		end)

		funcs:Toggle(v_8, "Auto Collect Fruits", "", false, true, function(arg)
			enabled["Auto Collect Fruits (Blacklist)"] = arg
		end)

		v_8:AddSeperator({ " - [ Other ] - " })

		funcs:Toggle(v_8, "Auto Collect All Fruits", "", false, true, function(arg)
			enabled["Auto Collect All Fruits"] = arg
		end)

		local v_9 = tbl4.Main:AddSection("Automation Sprinkler")

		funcs:Dropdown(v_9, "Select Sprinkler", "", true, managers2:GetSprinklerList(), { "" }, true, function(arg)
			enabled["Select Sprinkler"] = arg
		end)

		funcs:Dropdown(v_9, "Select Plants ", "", true, managers2:GetSeedList(), { "" }, true, function(arg)
			enabled["Select Plants Sprinkler"] = arg
		end)

		funcs:Dropdown(v_9, "Select Position ", "", false, { "Selected Plant", "Random", "Player Position" }, { "" }, true, function(arg)
			enabled["Select Position1"] = arg
		end)

		funcs:Textbox(v_9, "Delay To Sprinkler", "", "0", true, function(arg)
			enabled["Delay To Sprinkler"] = arg
		end)

		funcs:Toggle(v_9, "Auto Sprinkler", "", false, true, function(arg)
			enabled["Auto Sprinkler"] = arg
		end)

		local v_10 = tbl4.Main:AddSection("Automation Eggs / Crate")

		funcs:Dropdown(v_10, "Select Eggs", "", true, managers2:GetEggList(), { "" }, true, function(arg)
			enabled["Select Eggs"] = arg
		end)

		funcs:Dropdown(v_10, "Select Position  ", "", false, { "Good Position", "Random", "Player Position" }, { "" }, true, function(arg)
			enabled["Select Position  "] = arg
		end)

		funcs:Textbox(v_10, "Delay To Place Eggs", "", "0", true, function(arg)
			enabled["Delay To Place Eggs"] = tonumber(arg)
		end)

		funcs:Textbox(v_10, "Place Egg Max", "", "3", true, function(arg)
			enabled["Place Egg Max"] = tonumber(arg)
		end)

		funcs:Toggle(v_10, "Allow Placing If No Egg in Garden", "This means if your garden doesn’t have any eggs, it will place egg. If there is already an egg, it will stop.", false, true, function(arg)
			enabled["Allow Placing If No Egg in Garden"] = arg
		end)

		funcs:Toggle(v_10, "Auto Place Eggs", "", false, true, function(arg)
			enabled["Auto Place Eggs"] = arg
		end)

		v_10:AddSeperator({ " - [ Hatch Eggs ] - " })

		funcs:Dropdown(v_10, "Select Eggs ", "", true, managers2:GetEggList(true), { "" }, true, function(arg)
			enabled["Select Eggs "] = arg
		end)

		funcs:Textbox(v_10, "Delay To Hatch", "", "0", true, function(arg)
			enabled["Delay To Hatch"] = tonumber(arg)
		end)

		funcs:Toggle(v_10, "All Eggs Ready Only", "Auto Hatch Egg will only work when all of your eggs are ready. If even one egg isn’t ready, Auto Hatch Egg won’t work", false, true, function(arg)
			enabled["All Eggs Ready Only"] = arg
		end)

		if not (str:find("Solara") or str:find("Xeno")) then
			funcs:Dropdown(v_10, "Select Filter Mode", "", false, { "Whitelist", "Blacklist" }, { "" }, true, function(arg)
				enabled["Select Filter Mode"] = arg
			end)

			local function fn14()
				local tbl5 = { "None" }

				for _, v_11 in managers2:GetPetsLists() do
					table.insert(tbl5, v_11)
				end

				return tbl5
			end

			funcs:Dropdown(v_10, "Choose Pets ", "", true, fn14(), { "" }, true, function(arg)
				enabled["Choose Pets "] = arg
			end)

			funcs:Dropdown(v_10, "Select Threshold Mode       ", "", false, { "Above", "Below" }, { "" }, true, function(arg)
				enabled["Select Threshold Mode       "] = arg
			end)

			funcs:Textbox(v_10, "Weights Pet Threshold ", "if you don't want use this, just input '0' ", "0", true, function(arg)
				enabled["Weights Pet Threshold "] = arg
			end)
		end

		funcs:Toggle(v_10, "Auto Hatch Eggs", "", false, true, function(arg)
			enabled["Auto Hatch Eggs"] = arg
		end)

		v_10:AddSeperator({ " - [ Crate ] - " })

		funcs:Dropdown(v_10, "Select Crate", "", true, managers2:GetCrateList(), { "" }, true, function(arg)
			enabled["Select Crate"] = arg
		end)

		funcs:Textbox(v_10, "Delay To Place Crate", "", "0", true, function(arg)
			enabled["Delay To Place Crate"] = arg
		end)

		funcs:Toggle(v_10, "Auto Place Crate", "", false, true, function(arg)
			enabled["Auto Place Crate"] = arg
		end)

		local v_11 = tbl4.Main:AddSection("Automation Sell")
		v_11:AddSeperator({ " - [ Config ] - " })

		funcs:Textbox(v_11, "Delay To Sell Inventory", "", "0", true, function(arg)
			enabled["Delay To Sell Inventory"] = arg
		end)

		funcs:Toggle(v_11, "Allow Sell If Backpack Is Max", "", false, true, function(arg)
			enabled["Allow Sell If Backpack Is Max"] = arg
		end)

		v_11:AddSeperator({ " - [ Seller ] - " })

		funcs:Dropdown(v_11, "Prevent Sell Fruits", "", true, managers2:GetSeedList(), { "" }, true, function(arg)
			enabled["Prevent Sell Fruits"] = arg
		end)

		funcs:Dropdown(v_11, "Prevent Sell Mutation", "", true, managers2:GetMutationList(), { "" }, true, function(arg)
			enabled["Prevent Sell Mutation"] = arg
		end)

		funcs:Dropdown(v_11, "Prevent Sell Variant", "", true, modules.Variant, { "" }, true, function(arg)
			enabled["Prevent Sell Variant"] = arg
		end)

		funcs:Toggle(v_11, "Enable Prevent Mode", "", false, true, function(arg)
			enabled["Enable Prevent Mode"] = arg
		end)

		funcs:Toggle(v_11, "Auto Sell", "", false, true, function(arg)
			enabled["Auto Sell"] = arg
		end)

		funcs:Button(v_11, "Sell", "", function()
			sellFunction.CallSell()
		end)

		v_11:AddSeperator({ " - [ Sell Pets ] - " })

		funcs:Dropdown(v_11, "Sell Pets", "", true, managers2:GetPetsLists(), { "" }, true, function(arg)
			enabled["Sell Pets"] = arg
		end)

		funcs:Dropdown(v_11, "Anti-Sell Pets", "", true, managers2:GetPetsLists(), { "" }, true, function(arg)
			enabled["Anti-Sell Pets"] = arg
		end)

		funcs:Dropdown(v_11, "Select Threshold Mode  ", "", false, { "Above", "Below", "Don't Sell Above", "Don't Sell Below" }, { "" }, true, function(arg)
			enabled["Select Threshold Mode  "] = arg
		end)

		funcs:Textbox(v_11, "Weights Threshold  ", "if you don't want use this, just input '0' ", "0", true, function(arg)
			enabled["Weights Threshold  "] = arg
		end)

		funcs:Textbox(v_11, "Age Threshold  ", "if you don't want use this, just input '0' ", "0", true, function(arg)
			enabled["Age Threshold  "] = arg
		end)

		funcs:Textbox(v_11, "Delay to Sell Pets", "", "0", true, function(arg)
			enabled["Delay to Sell Pets"] = arg
		end)

		funcs:Dropdown(v_11, "Select Sell Version", "", false, { "V1", "V2" }, { "" }, true, function(arg)
			enabled["Select Sell Version"] = arg
		end)

		funcs:Toggle(v_11, "Auto Sell Pets", "", false, true, function(arg)
			enabled["Auto Sell Pets"] = arg
		end)

		funcs:Button(v_11, "Sell Held Pets", "", function()
			local tool = localPlayer.Character:FindFirstChildWhichIsA("Tool")

			if tool and tool:GetAttribute("b") == "l" and not tool:GetAttribute("d") then
				gameEvents.SellPet_RE:FireServer(tool)
			end
		end)

		funcs:Button(v_11, "Sell All Pets", "", function()
			local character = localPlayer.Character
			if not character then
				return
			end

			if managers2:IsSwitchingActive() then
				return
			end
			local selectSellVersion = enabled["Select Sell Version"] or "V1"
			local v_12 = toolFunction.GetAllTool()
			local tbl5 = {}

			for _, v_13 in ipairs(v_12) do
				if v_13:IsA("Tool") and v_13:GetAttribute("PetType") == "Pet" and not v_13:GetAttribute("d") then
					table.insert(tbl5, v_13)
				end
			end

			if #tbl5 == 0 then
				shx:SetNotification({ "Speed Hub X", "", "No pets to sell!", 5, 0.5 })
				return
			end
			shx:SetNotification({ "Speed Hub X", "", "Selling " .. #tbl5 .. " pets...", 5, 0.5 })
			local n = 0

			for _, v_13 in ipairs(tbl5) do
				task.wait(tonumber(enabled["Delay to Sell Pets"]) or 0.1)

				if selectSellVersion == "V2" then
					gameEvents.SellPetShopSelected:FireServer(v_13)
					n += 1
				else
					while true do
						task.wait()
						character.Humanoid:EquipTool(v_13)
						if not (character:FindFirstChild(v_13.Name) or not v_13.Parent) then
							continue
						end
						break
					end

					local v_14 = character:FindFirstChild(v_13.Name)

					if v_14 and v_14:GetAttribute("PetType") == "Pet" and not v_14:GetAttribute("d") then
						gameEvents.SellPet_RE:FireServer(v_14)
						…