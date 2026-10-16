--- hackmanhub deober v1.2
-- ob MoonSecV3

--- https://discord.gg/cuwKyeuCVR

--- script from hackmanhub users

local v0 = game:GetService("RunService");
local v1 = game:GetService("Teams");
local v2 = game:GetService("Players");
local v3 = workspace.CurrentCamera;
local v4 = game:GetService("UserInputService");
local v5 = game:GetService("TweenService");
local v6 = 0.1;
local v7 = Instance.new("NumberValue");
v7.Value = 0.1;
local v9 = false;
local v10 = 500;
local v11 = false;
local v12 = false;
local v13 = false;
local v14 = 500;
local v15 = {};
local v16 = false;
local v17 = false;
local v18 = nil;
local v19 = false;
local v20 = false;
local v21 = Drawing.new("Circle");
v21.Visible = false;
v21.Color = Color3.fromRGB(255, 255, 255);
v21.Thickness = 1;
v21.Filled = false;
v21.Transparency = 1;
v21.Radius = 100;
v21.Position = Vector2.new(v3.ViewportSize.X / 2 , v3.ViewportSize.Y / 2 );
v3:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	v21.Position = Vector2.new(v3.ViewportSize.X / 2 , v3.ViewportSize.Y / 2 );
end);
local v29 = Vector2.new;
local v30 = {
	esp_cache = {}
};
local v31 = {
	box = {
		color = Color3.fromRGB(255, 255, 255),
		border_size_pixel = 1
	},
	tracer = {
		color = Color3.fromRGB(255, 255, 255),
		thickness = 1
	},
	distance_text = {
		size = 14,
		color = Color3.fromRGB(255, 255, 255)
	},
	chams = {
		team_check = true
	}
};
local function v32()
	local v111 = {};
	for v187, v188 in ipairs(workspace.Players:GetChildren()) do
		for v202, v203 in ipairs(v188:GetChildren()) do
			if v203:IsA("Model") then
				table.insert(v111, v203);
			end
		end
	end
	return v111;
end
local function v33(v112)
	local v113 = v2.LocalPlayer.Team;
	local v114 = v112:FindFirstChildWhichIsA("Folder") and v112:FindFirstChildWhichIsA("Folder"):FindFirstChildOfClass("MeshPart") ;
	if  not v114 then
		return false;
	end
	local v115 = v114.BrickColor.Name;
	if ((v115 == "Black") and (v113.Name == "Phantoms")) then
		return false;
	elseif ((v115 ~= "Black") and (v113.Name == "Ghosts")) then
		return false;
	end
	return true;
end
local function v34(v116)
	if  not v30.esp_cache[v116] then
		v30.esp_cache[v116] = {
			box_square = Drawing.new("Square"),
			box_outline = Drawing.new("Square"),
			box_inline = Drawing.new("Square"),
			tracer_line = Drawing.new("Line"),
			distance_label = Drawing.new("Text"),
			name_label = Drawing.new("Text")
		};
	end
end
local function v35(v117)
	if v30.esp_cache[v117] then
		for v223, v224 in pairs(v30.esp_cache[v117]) do
			v224:Remove();
		end
		v30.esp_cache[v117] = nil;
	end
end
local function v36(v118, v119)
	for v189, v190 in v118:GetChildren() do
		if v190:IsA("BasePart") then
			local v225 = v190:FindFirstChildOfClass("SpecialMesh");
			if (v225 and (v225.MeshId == "rbxassetid://4049240078")) then
				return v190;
			end
		end
	end
	return nil;
end
local function v37(v120, v121)
	for v191, v192 in v120:GetChildren() do
		if v192:IsA("BasePart") then
			local v226 = v192:FindFirstChildOfClass("SpecialMesh");
			if (v226 and (v226.MeshId == "rbxassetid://6179256256")) then
				return v192;
			end
		end
	end
	return nil;
end
local function v38(v122)
	if  not v122 then
		return;
	end
	local v123 = v122:FindFirstChildWhichIsA("Folder"):FindFirstChildOfClass("MeshPart");
	if  not v123 then
		return;
	end
	if (v123.BrickColor == BrickColor.new("Black")) then
		return v1.Phantoms == v2.LocalPlayer.Team , v1.Phantoms;
	end
	return v1.Ghosts == v2.LocalPlayer.Team , v1.Ghosts;
end
local function v39()
	local v124 = nil;
	local v125 = math.huge;
	local v126 = Vector2.new(v3.ViewportSize.X / 2 , v3.ViewportSize.Y / 2 );
	for v193, v194 in ipairs(v32()) do
		if v194:IsDescendantOf(workspace.Ignore.DeadBody) then
			continue;
		end
		local v195, v193 = v38(v194);
		if (v31.chams.team_check and v195) then
			continue;
		end
		local v196 = v37(v194, "Head");
		if v196 then
			local v227 = Ray.new(v3.CFrame.Position, (v196.Position - v3.CFrame.Position).unit * 1000 );
			local v228, v229 = v3:WorldToViewportPoint(v196.Position);
			if v229 then
				local v255 = Vector2.new(v228.X, v228.Y);
				local v256 = (v255 - v126).Magnitude;
				local v257 = (v196.Position - v3.CFrame.Position).Magnitude;
				if (v9 and (v257 > v10)) then
					continue;
				end
				if v19 then
					if (v256 <= v21.Radius) then
						if (v257 <= 30) then
							v124 = v196;
							break;
						end
						if (v256 < v125) then
							v124 = v196;
							v125 = v256;
						end
					end
				else
					if (v257 <= 30) then
						v124 = v196;
						break;
					end
					if (v256 < v125) then
						v124 = v196;
						v125 = v256;
					end
				end
			end
		end
	end
	return v124;
end
local v40 = nil;
local function v41()
	if  not v6 then
		return;
	end
	if v17 then
		if ( not v18 or  not v18:IsDescendantOf(workspace.Players)) then
			if v20 then
				v18 = v39();
				if  not v18 then
					v17 = false;
					return;
				end
			else
				v17 = false;
				return;
			end
		end
		local v206, v207 = v3:WorldToViewportPoint(v18.Position);
		if v207 then
			local v245 = v4:GetMouseLocation();
			local v246 = Vector2.new(v206.X, v206.Y);
			local v247 = v246 - v245 ;
			local v248 = v247.Magnitude;
			if (v248 > 1) then
				local v261 = v247 * v7.Value ;
				mousemoverel(v261.X, v261.Y);
			end
		end
	end
end
local function v42(v127)
	local v128 = TweenInfo.new(0.4, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
	local v129 = v5:Create(v7, v128, {
		Value = v127
	});
	v129:Play();
end
local function v43(v130)
	if (v130:IsA("BasePart") or v130:IsA("UnionOperation") or v130:IsA("MeshPart")) then
		v15[v130] = {
			material = v130.Material,
			reflectance = v130.Reflectance,
			cast_shadow = v130.CastShadow,
			texture_id = (v130:FindFirstChild("TextureId") and v130.TextureId) or nil
		};
	end
end
local function v44()
	local v131 = workspace:FindFirstChild("Map");
	if  not v131 then
		return;
	end
	local v132 = v131:GetDescendants();
	for v197, v198 in ipairs(v132) do
		v43(v198);
		if (v198:IsA("BasePart") or v198:IsA("UnionOperation") or v198:IsA("MeshPart")) then
			v198.Material = Enum.Material.SmoothPlastic;
			v198.Reflectance = 0;
			v198.CastShadow = false;
			if (v198:IsA("MeshPart") and v198:FindFirstChild("TextureId")) then
				v198.TextureId = "";
			end
		end
	end
	v16 = true;
end
local function v45()
	local v133 = workspace:FindFirstChild("Map");
	if  not v133 then
		return;
	end
	local v134 = v133:GetDescendants();
	for v199, v200 in ipairs(v134) do
		if v15[v200] then
			v200.Material = v15[v200].material;
			v200.Reflectance = v15[v200].reflectance;
			v200.CastShadow = v15[v200].cast_shadow;
			if (v200:IsA("MeshPart") and v200:FindFirstChild("TextureId")) then
				v200.TextureId = v15[v200].texture_id or "" ;
			end
		end
	end
	v16 = false;
end
local function v46(v135)
	if v12 then
		local v209 = Ray.new(v3.CFrame.Position, (v135.Position - v3.CFrame.Position).unit * 1000 );
		local v210, v211 = workspace:FindPartOnRay(v209, v2.LocalPlayer.Character, false, true);
		return v210 == v135 ;
	else
		return true;
	end
end
local function v47(v136)
	if v11 then
		local v212 = Ray.new(v3.CFrame.Position, (v136.Position - v3.CFrame.Position).unit * 1000 );
		local v213, v214 = workspace:FindPartOnRay(v212, v2.LocalPlayer.Character, false, true);
		return v213 == v136 ;
	else
		return true;
	end
end
local v48 = loadstring(game:HttpGet("https://you.whimper.xyz/sources/nox/data/phui.lua"));
getgenv().jump_height_value = 30;
local v50 = v48({
	rounding = false,
	theme = "lime",
	smoothDragging = false
});
v50.autoDisableToggles = true;
local v52 = v50.newWindow({
	text = "Phantom Forces | NoxHub - Premium Roblox Scripts",
	resize = false,
	size = Vector2.new(550, 376)
});
local v53 = v52:addMenu({
	text = "Main"
});
local v54 = v53:addSection({
	text = "Aimbot",
	side = "left",
	showMinButton = false
});
local v55 = v54:addToggle({
	text = "Enabled",
	state = false
});
local v56 = v54:addToggle({
	text = "Wall Check",
	state = false
});
local v57 = v54:addToggle({
	text = "Auto Target Switch",
	state = false
});
local v58 = v54:addToggle({
	text = "Use Max Distance",
	state = false
});
local v59 = v54:addSlider({
	text = "Max Distance",
	min = 50,
	max = 1000,
	default = 500,
	float = false,
	step = 10
});
v57:bindToEvent("onToggle", function(v137)
	v20 = v137;
end);
v58:bindToEvent("onToggle", function(v138)
	v9 = v138;
end);
v59:bindToEvent("onNewValue", function(v139)
	v10 = v139;
end);
v55:bindToEvent("onToggle", function(v140)
	is_aimbot_enabled = v140;
	if is_aimbot_enabled then
		input_began_connection = v4.InputBegan:Connect(function(v240)
			if (v240.UserInputType == Enum.UserInputType.MouseButton2) then
				v17 = true;
				v18 = v39();
			end
		end);
		input_ended_connection = v4.InputEnded:Connect(function(v241)
			if (v241.UserInputType == Enum.UserInputType.MouseButton2) then
				v17 = false;
				v18 = nil;
			end
		end);
		render_stepped_connection = v0.RenderStepped:Connect(function()
			if (v17 and v18) then
				if v56:getState() then
					if v46(v18) then
						v41();
					end
				else
					v41();
				end
			end
		end);
	else
		v17 = false;
		v18 = nil;
		if input_began_connection then
			input_began_connection:Disconnect();
		end
		if input_ended_connection then
			input_ended_connection:Disconnect();
		end
		if render_stepped_connection then
			render_stepped_connection:Disconnect();
		end
	end
end);
local v60 = v54:addSlider({
	text = "Strength",
	min = 0.1,
	max = 1.5,
	default = 0.1,
	float = true,
	step = 0.1
});
local v61 = v54:addLabel({
	text = "* Values above 1 will be shaky!"
});
local v62 = v53:addSection({
	text = "ESP",
	side = "right",
	showMinButton = false
});
local v63 = v62:addToggle({
	text = "Enabled",
	state = false
});
local v64 = v62:addToggle({
	text = "Box",
	state = false
});
local v65 = v62:addToggle({
	text = "Tracer",
	state = false
});
local v66 = v62:addToggle({
	text = "Head Dot",
	state = false
});
local v67 = v62:addToggle({
	text = "Distance",
	state = false
});
local v68 = v62:addToggle({
	text = "Name",
	state = false
});
local v69 = v62:addToggle({
	text = "Wall Check",
	state = false
});
local v70 = v62:addToggle({
	text = "Use Max Distance",
	state = false
});
local v71 = v62:addColorPicker({
	text = "Box Color",
	color = Color3.fromRGB(255, 255, 255)
});
local v72 = v62:addColorPicker({
	text = "Tracer Color",
	color = Color3.fromRGB(255, 255, 255)
});
local v73 = v62:addColorPicker({
	text = "Distance Color",
	color = Color3.fromRGB(255, 255, 255)
});
local v74 = v62:addColorPicker({
	text = "Head Dot Color",
	color = Color3.fromRGB(255, 255, 255)
});
local v75 = v62:addColorPicker({
	text = "Name Color",
	color = Color3.fromRGB(255, 255, 255)
});
local v76 = v62:addSlider({
	text = "Max Distance",
	min = 50,
	max = 1000,
	default = 500,
	float = false,
	step = 10
});
local v77 = v53:addSection({
	text = "FOV",
	side = "left",
	showMinButton = false
});
local v78 = v77:addToggle({
	text = "Show FOV Circle",
	state = false
});
local v79 = v77:addToggle({
	text = "Limit ESP To FOV",
	state = false
});
local v80 = v77:addSlider({
	text = "FOV Radius",
	min = 50,
	max = 300,
	default = 100,
	float = false,
	step = 1
});
local v81 = v52:addMenu({
	text = "Player"
});
local v82 = v81:addSection({
	text = "LocalPlayer Mods",
	side = "left"
});
local v83 = v82:addSlider({
	text = "WalkSpeed",
	min = 0,
	max = 0.17,
	default = 0,
	float = true,
	step = 0.01
});
local v84 = v82:addSlider({
	text = "JumpPower",
	min = 30,
	max = 100,
	default = 50,
	float = true,
	step = 1
});
local v85 = v81:addSection({
	text = "Fun Mods"
});
local v86 = v85:addToggle({
	text = "Jump Delay Bypass",
	state = false
});
local v87 = v52:addMenu({
	text = "Misc"
});
local v88 = v87:addSection({
	text = "Misc Mods",
	side = "left"
});
local v89 = v87:addSection({
	text = "Safety",
	side = "right"
});
local v90 = v89:addToggle({
	text = "Anti Votekick",
	state = false
});
local v91 = v88:addToggle({
	text = "Toggle Textures",
	state = false
});
local v92 = v52:addMenu({
	text = "Configs"
});
local v93 = v92:addSection({
	text = "Configuration",
	side = "left"
});
local v94 = v93:addButton({
	text = "Save Config"
});
local v95 = v93:addButton({
	text = "Load Config"
});
local function v96()
	v6 = 0.1;
	v7.Value = 0.1;
	v11 = false;
	v16 = false;
	v19 = false;
	v20 = false;
	v21.Radius = 100;
	v31 = {
		box = {
			color = Color3.fromRGB(255, 255, 255),
			border_size_pixel = 1
		},
		tracer = {
			color = Color3.fromRGB(255, 255, 255),
			thickness = 1
		},
		distance_text = {
			size = 14,
			color = Color3.fromRGB(255, 255, 255)
		},
		name = {
			color = Color3.fromRGB(255, 255, 255)
		},
		head_dot = {
			color = Color3.fromRGB(255, 255, 255)
		},
		chams = {
			team_check = true
		}
	};
	v60:setValue(v6);
	v69:setState(v11);
	v78:setState(v19);
	v80:setValue(v21.Radius);
	v71:setColor(v31.box.color);
	v72:setColor(v31.tracer.color);
	v73:setColor(v31.distance_text.color);
	v75:setColor(v31.name.color);
	v74:setColor(v31.head_dot.color);
	if v55 then
		v55:setState(false);
	end
	if v57 then
		v57:setState(false);
	end
	if v56 then
		v56:setState(false);
	end
	if v63 then
		v63:setState(false);
	end
	if v64 then
		v64:setState(false);
	end
	if v65 then
		v65:setState(false);
	end
	if v66 then
		v66:setState(false);
	end
	if v67 then
		v67:setState(false);
	end
	if v68 then
		v68:setState(false);
	end
	if v69 then
		v69:setState(false);
	end
	if v83 then
		v83:setValue(0);
	end
	if v84 then
		v84:setValue(30);
	end
	if v86 then
		v86:setState(false);
	end
	if v91 then
		v91:setState(false);
	end
	if v90 then
		v90:setState(false);
	end
	for v201 in pairs(v30.esp_cache) do
		v35(v201);
	end
	v45();
	print("Settings reset to default.");
end
local function v97()
	local v143 = {
		easing_strength = v6,
		tween_sensitivity = v7.Value,
		is_visibility_check_enabled = v11,
		is_optimized = v16,
		is_fov_enabled = v19,
		is_auto_target_switch_enabled = v20,
		fov_circle_radius = v21.Radius,
		is_max_distance_enabled = v9,
		max_lock_on_distance = v10,
		esp_use_fov = v79:getState(),
		is_esp_max_distance_enabled = v13,
		esp_max_distance = v14,
		features = {
			box = {
				color = {
					v71:getColor().r,
					v71:getColor().g,
					v71:getColor().b
				},
				border_size_pixel = v31.box.border_size_pixel
			},
			tracer = {
				color = {
					v72:getColor().r,
					v72:getColor().g,
					v72:getColor().b
				},
				thickness = v31.tracer.thickness
			},
			distance_text = {
				color = {
					v73:getColor().r,
					v73:getColor().g,
					v73:getColor().b
				},
				size = v31.distance_text.size
			},
			name = {
				color = {
					v75:getColor().r,
					v75:getColor().g,
					v75:getColor().b
				}
			},
			head_dot = {
				color = {
					v74:getColor().r,
					v74:getColor().g,
					v74:getColor().b
				}
			},
			chams = {
				team_check = v31.chams.team_check
			}
		},
		aimbot = {
			is_aimbot_enabled = (v55 and v55:getState()) or false ,
			is_auto_target_switch_enabled = (v57 and v57:getState()) or false ,
			wall_check_enabled = (v56 and v56:getState()) or false
		},
		esp = {
			esp_enabled = (v63 and v63:getState()) or false ,
			box_enabled = (v64 and v64:getState()) or false ,
			tracer_enabled = (v65 and v65:getState()) or false ,
			head_dot_enabled = (v66 and v66:getState()) or false ,
			distance_enabled = (v67 and v67:getState()) or false ,
			name_enabled = (v68 and v68:getState()) or false ,
			visibility_enabled = (v69 and v69:getState()) or false
		},
		player = {
			walk_speed = (v83 and v83:getValue()) or 0 ,
			jump_height = (v84 and v84:getValue()) or 30 ,
			jump_delay_bypass = (v86 and v86:getState()) or false
		},
		misc = {
			texture_enabled = (v91 and v91:getState()) or false ,
			votekick_rejoiner = (v90 and v90:getState()) or false
		}
	};
	local v144 = game:GetService("HttpService"):JSONEncode(v143);
	local v145 = "NoxHub";
	local v146 = v145   .. "/Phantom" ;
	if  not isfolder(v145) then
		makefolder(v145);
	end
	writefile(v146, v144);
	print("Config saved successfully!");
end
local function v98()
	v96();
	local v147 = "NoxHub";
	local v148 = v147   .. "/Phantom" ;
	if isfile(v148) then
		local v215 = readfile(v148);
		local v216 = game:GetService("HttpService"):JSONDecode(v215);
		v6 = v216.easing_strength;
		v7.Value = v216.tween_sensitivity;
		v11 = v216.is_visibility_check_enabled or false ;
		v16 = v216.is_optimized or false ;
		v19 = v216.is_fov_enabled or false ;
		v20 = v216.is_auto_target_switch_enabled or false ;
		v21.Radius = v216.fov_circle_radius or 100 ;
		v9 = v216.is_max_distance_enabled or false ;
		v10 = v216.max_lock_on_distance or 500 ;
		v13 = v216.is_esp_max_distance_enabled or false ;
		v14 = v216.esp_max_distance or 500 ;
		v58:setState(v9);
		v59:setValue(v10);
		v70:setState(v13);
		v76:setValue(v14);
		if (v216.esp_use_fov ~= nil) then
			v79:setState(v216.esp_use_fov);
		end
		if v216.features then
			v31 = {
				box = {
					color = Color3.new(unpack(v216.features.box.color or {
						1,
						1,
						1
					} )),
					border_size_pixel = v216.features.box.border_size_pixel or 1
				},
				tracer = {
					color = Color3.new(unpack(v216.features.tracer.color or {
						1,
						1,
						1
					} )),
					thickness = v216.features.tracer.thickness or 1
				},
				distance_text = {
					color = Color3.new(unpack(v216.features.distance_text.color or {
						1,
						1,
						1
					} )),
					size = v216.features.distance_text.size or 14
				},
				name = {
					color = Color3.new(unpack(v216.features.name.color or {
						1,
						1,
						1
					} ))
				},
				head_dot = {
					color = Color3.new(unpack(v216.features.head_dot.color or {
						1,
						1,
						1
					} ))
				},
				chams = {
					team_check = v216.features.chams.team_check or true
				}
			};
		else
			v31 = {
				box = {
					color = Color3.fromRGB(255, 255, 255),
					border_size_pixel = 1
				},
				tracer = {
					color = Color3.fromRGB(255, 255, 255),
					thickness = 1
				},
				distance_text = {
					size = 14,
					color = Color3.fromRGB(255, 255, 255)
				},
				name = {
					color = Color3.fromRGB(255, 255, 255)
				},
				head_dot = {
					color = Color3.fromRGB(255, 255, 255)
				},
				chams = {
					team_check = true
				}
			};
		end
		v60:setValue(v6);
		v69:setState(v11);
		v78:setState(v19);
		v80:setValue(v21.Radius);
		v71:setColor(v31.box.color);
		v72:setColor(v31.tracer.color);
		v73:setColor(v31.distance_text.color);
		v75:setColor(v31.name.color);
		v74:setColor(v31.head_dot.color);
		if v216.aimbot then
			if v55 then
				v55:setState(v216.aimbot.is_aimbot_enabled or false );
			end
			if v57 then
				v57:setState(v216.aimbot.is_auto_target_switch_enabled or false );
			end
			if v56 then
				v56:setState(v216.aimbot.wall_check_enabled or false );
			end
		end
		if v216.esp then
			if v63 then
				v63:setState(v216.esp.esp_enabled or false );
			end
			if v64 then
				v64:setState(v216.esp.box_enabled or false );
			end
			if v65 then
				v65:setState(v216.esp.tracer_enabled or false );
			end
			if v66 then
				v66:setState(v216.esp.head_dot_enabled or false );
			end
			if v67 then
				v67:setState(v216.esp.distance_enabled or false );
			end
			if v68 then
				v68:setState(v216.esp.name_enabled or false );
			end
			if v69 then
				v69:setState(v216.esp.visibility_enabled or false );
			end
		end
		if v216.player then
			if v83 then
				v83:setValue(v216.player.walk_speed or 0 );
			end
			if v84 then
				v84:setValue(v216.player.jump_height or 30 );
			end
			if v86 then
				v86:setState(v216.player.jump_delay_bypass or false );
			end
		end
		if v216.misc then
			if v91 then
				v91:setState(v216.misc.texture_enabled or false );
			end
			if v90 then
				v90:setState(v216.misc.votekick_rejoiner or false );
			end
		end
		print("Config loaded successfully!");
	else
		print("No config file found!");
	end
end
local v99 = v83:getValue();
local v100 = v84:getValue();
local function v101()
	local v149;
	repeat
		v149 = workspace:FindFirstChild("Ignore") and workspace:FindFirstChild("Ignore"):FindFirstChildWhichIsA("Model") ;
		task.wait();
	until v149
	return v149;
end
v83:bindToEvent("onNewValue", function(v150)
	v99 = v150;
end);
v84:bindToEvent("onNewValue", function(v151)
	getgenv().jump_height_value = v151;
end);
v60:bindToEvent("onNewValue", function(v153)
	v6 = v153;
	v42(v153);
end);
v70:bindToEvent("onToggle", function(v154)
	v13 = v154;
end);
v76:bindToEvent("onNewValue", function(v155)
	v14 = v155;
end);
v69:bindToEvent("onToggle", function(v156)
	v11 = v156;
end);
v56:bindToEvent("onToggle", function(v157)
	v12 = v157;
end);
v78:bindToEvent("onToggle", function(v158)
	v19 = v158;
	v21.Visible = v158;
end);
v80:bindToEvent("onNewValue", function(v160)
	v21.Radius = v160;
end);
v94:bindToEvent("onClick", v97);
v95:bindToEvent("onClick", v98);
local v102 = 0;
local v103 = 0.8681;
local v104 = v2.LocalPlayer;
local function v105()
	local v162 = game:GetService("TeleportService");
	local v163 = game.PlaceId;
	v104:Kick("You have been vote-kicked. Rejoining a different server...");
	v162:Teleport(v163);
end
local function v106()
	local v164 = v104.PlayerGui:WaitForChild("ChatScreenGui");
	local v165 = v164.Main:WaitForChild("DisplayVoteKick");
	v165:GetPropertyChangedSignal("Visible"):Connect(function()
		if (v165.Visible and v90:getState()) then
			local v242 = v165.TextTitle.Text;
			local v243 = {};
			for v249 in v242:gmatch("%S+") do
				table.insert(v243, v249);
			end
			if (v243[2] == v104.Name) then
				v105();
			end
		end
	end);
end
v4.InputBegan:Connect(function(v166, v167)
	if v167 then
		return;
	end
	if (v166.KeyCode == Enum.KeyCode.Space) then
		local v221 = tick();
		if (((v221 - v102) < v103) and v86:getState()) then
			local v250 = v101():FindFirstChildOfClass("Humanoid");
			if v250 then
				v250.Jump = true;
			end
		end
		v102 = v221;
	end
end);
v63:bindToEvent("onToggle", function(v168)
	if v168 then
		esp_loop = v0.RenderStepped:Connect(function()
			for v251, v252 in ipairs(v32()) do
				if v33(v252) then
					v34(v252);
				end
			end
			for v253, v254 in pairs(v30.esp_cache) do
				if v253 then
					local v263 = v36(v253, "Torso");
					local v264 = v37(v253, "Head");
					if (v263 and v264) then
						local v265, v266 = v3:WorldToViewportPoint(v263.Position);
						if v266 then
							local v267 = (v264.Position - v3.CFrame.Position).Magnitude;
							local v268 = Vector2.new(v265.X, v265.Y);
							local v269 = Vector2.new(v3.ViewportSize.X / 2 , v3.ViewportSize.Y / 2 );
							local v270 = (v268 - v269).Magnitude;
							if (v13 and (v267 > v14)) then
								v35(v253);
								continue;
							end
							if ( not v79:getState() or (v270 <= v21.Radius)) then
								local v271 = v264:FindFirstChildOfClass("BillboardGui");
								local v272 = v271 and v271:FindFirstChildOfClass("TextLabel") ;
								if ( not v271 or  not v272) then
									v35(v253);
									continue;
								end
								local v273 = ((1000 / (v3.CFrame.Position - v263.Position).Magnitude) * 80) / v3.FieldOfView ;
								local v274 = v29(math.round(3 * v273 ), math.round(4 * v273 ));
								local v275 = (v47(v264) and v71:getColor()) or Color3.fromRGB(255, 0, 0) ;
								if v64:getState() then
									local v276 = v29(v265.X - (v274.X / 2) , v265.Y - (v274.Y / 2) );
									local v277 = v274;
									v254.box_square.Visible = true;
									v254.box_square.Color = v275;
									v254.box_square.Thickness = 1;
									v254.box_square.Position = v276;
									v254.box_square.Size = v277;
									v254.box_square.Filled = false;
									v254.box_outline.Visible = true;
									v254.box_outline.Color = Color3.fromRGB(0, 0, 0);
									v254.box_outline.Thickness = 1;
									v254.box_outline.Position = v29(v276.X - 1 , v276.Y - 1 );
									v254.box_outline.Size = v29(v277.X + 2 , v277.Y + 2 );
									v254.box_outline.Filled = false;
								else
									v254.box_square.Visible = false;
									v254.box_outline.Visible = false;
								end
								if v65:getState() then
									v254.tracer_line.Visible = true;
									v254.tracer_line.Color = v72:getColor();
									v254.tracer_line.Thickness = v31.tracer.thickness;
									v254.tracer_line.From = v29(v3.ViewportSize.X / 2 , v3.ViewportSize.Y);
									v254.tracer_line.To = v29(v265.X, v265.Y);
								else
									v254.tracer_line.Visible = false;
								end
								if v68:getState() then
									v254.name_label.Visible = true;
									v254.name_label.Text = v272.Text;
									v254.name_label.Size = v31.distance_text.size;
									v254.name_label.Color = v75:getColor();
									v254.name_label.Center = true;
									v254.name_label.Outline = true;
									v254.name_label.Position = v29(v254.box_square.Position.X + (v254.box_square.Size.X / 2) , v254.box_square.Position.Y - 30 );
								else
									v254.name_label.Visible = false;
								end
								if v67:getState() then
									local v309 = math.floor((v3.CFrame.Position - v263.Position).Magnitude);
									v254.distance_label.Visible = true;
									v254.distance_label.Text = tostring(v309)   .. " studs" ;
									v254.distance_label.Size = v31.distance_text.size;
									v254.distance_label.Color = v73:getColor();
									v254.distance_label.Center = true;
									v254.distance_label.Outline = true;
									v254.distance_label.Position = v29(v254.box_square.Position.X + (v254.box_square.Size.X / 2) , v254.box_square.Position.Y - 15 );
								else
									v254.distance_label.Visible = false;
								end
								if v66:getState() then
									if  not v254.head_dot then
										v254.head_dot = Drawing.new("Circle");
									end
									local v319, v320 = v3:WorldToViewportPoint(v264.Position);
									if v320 then
										v254.head_dot.Visible = true;
										v254.head_dot.Color = v74:getColor();
										v254.head_dot.Thickness = 1;
										v254.head_dot.Filled = true;
										v254.head_dot.Transparency = 1;
										v254.head_dot.Radius = v274.Y / 20 ;
										v254.head_dot.Position = Vector2.new(v319.X, v319.Y);
									else
										v254.head_dot.Visible = false;
									end
								elseif v254.head_dot then
									v254.head_dot.Visible = false;
								end
							else
								v35(v253);
							end
						else
							v35(v253);
						end
					else
						v35(v253);
					end
				else
					v35(v253);
				end
			end
		end);
	elseif esp_loop then
		esp_loop:Disconnect();
		for v260 in pairs(v30.esp_cache) do
			v35(v260);
		end
	end
end);
v90:bindToEvent("onToggle", function(v169)
	if v169 then
		v106();
	end
end);
v71:bindToEvent("onColorChanged", function(v170)
	v31.box.color = v170;
end);
v72:bindToEvent("onColorChanged", function(v172)
	v31.tracer.color = v172;
end);
v73:bindToEvent("onColorChanged", function(v174)
	v31.distance_text.color = v174;
end);
v75:bindToEvent("onColorChanged", function(v176)
	v31.name_color = v176;
end);
v74:bindToEvent("onColorChanged", function(v178)
	v31.head_dot_color = v178;
end);
v84:bindToEvent("onNewValue", function(v180)
	v100 = v180;
end);
v91:bindToEvent("onToggle", function(v181)
	if v181 then
		v44();
	else
		v45();
	end
end);
v4.InputBegan:Connect(function(v182, v183)
	if (v183 or  not v52) then
		return;
	end
	if (v182.KeyCode == Enum.KeyCode.F4) then
		v52:minimize();
	end
end);
local function v107(v184)
	return (tonumber(v184) ~= nil) or (v184 == "inf") ;
end
local v108 = game:GetService("RunService").Heartbeat;
local v109 = true;
while v109 do
	local v185 = v101();
	local v186 = v185 and v185:FindFirstChildWhichIsA("Humanoid") ;
	if v186 then
		v186.JumpPower = v100;
		v186:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			v186.JumpPower = v100;
		end);
		while v185 and v186 and v186.Parent and v109  do
			if (v186.MoveDirection.Magnitude > 0) then
				if (v99 and v107(v99)) then
					v185:TranslateBy(v186.MoveDirection * tonumber(v99) );
				else
					v185:TranslateBy(v186.MoveDirection);
				end
			end
			if  not v185.Parent then
				break;
			end
			v108:Wait();
		end
	end
end