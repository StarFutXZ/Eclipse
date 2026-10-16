
--[[
    DEAD RAILS | ITEM FINDER HUB
    Interface + pesquisa ECS
    Utilizar apenas em ambientes autorizados.
]]

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
if not player then
    return
end

local success, modules = pcall(function()
    return {
        world = require(RS.Shared.Universe.ECS.world),
        comps = require(RS.Shared.Universe.ECS.components),
        replicator = require(
            RS.Client.Universe.Replication.clientReplicator
        )
    }
end)

if not success then
    warn("[Dead Rails Hub] Não foi possível carregar os módulos.")
    return
end

local world = modules.world
local comps = modules.comps
local replicator = modules.replicator

-- Evita criar interfaces duplicadas
local playerGui = player:WaitForChild("PlayerGui")
local oldGui = playerGui:FindFirstChild("DeadRailsItemFinder")
if oldGui then
    oldGui:Destroy()
end

-- Interface
local gui = Instance.new("ScreenGui")
gui.Name = "DeadRailsItemFinder"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(360, 400)
main.Position = UDim2.new(0.5, -180, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(22, 24, 30)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(90, 110, 145)
stroke.Thickness = 1
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 45)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "DEAD RAILS | ITEM FINDER"
title.TextColor3 = Color3.fromRGB(235, 240, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 30)
close.Position = UDim2.new(1, -42, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(145, 55, 60)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = close

close.Activated:Connect(function()
    gui:Destroy()
end)

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -28, 0, 38)
searchBox.Position = UDim2.fromOffset(14, 55)
searchBox.BackgroundColor3 = Color3.fromRGB(35, 38, 47)
searchBox.PlaceholderText = "Nome do item (ex.: bond)"
searchBox.Text = "bond"
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.PlaceholderColor3 = Color3.fromRGB(155, 160, 175)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.ClearTextOnFocus = false
searchBox.Parent = main

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 6)
boxCorner.Parent = searchBox

local searchButton = Instance.new("TextButton")
searchButton.Size = UDim2.new(1, -28, 0, 36)
searchButton.Position = UDim2.fromOffset(14, 101)
searchButton.BackgroundColor3 = Color3.fromRGB(65, 100, 170)
searchButton.Text = "SEARCH ITEMS"
searchButton.TextColor3 = Color3.new(1, 1, 1)
searchButton.Font = Enum.Font.GothamBold
searchButton.TextSize = 13
searchButton.Parent = main

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = searchButton

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -28, 0, 26)
status.Position = UDim2.fromOffset(14, 143)
status.BackgroundTransparency = 1
status.Text = "Ready"
status.TextColor3 = Color3.fromRGB(160, 190, 220)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local results = Instance.new("ScrollingFrame")
results.Name = "Results"
results.Size = UDim2.new(1, -28, 1, -185)
results.Position = UDim2.fromOffset(14, 171)
results.BackgroundColor3 = Color3.fromRGB(29, 32, 40)
results.BorderSizePixel = 0
results.ScrollBarThickness = 5
results.CanvasSize = UDim2.new(0, 0, 0, 0)
results.AutomaticCanvasSize = Enum.AutomaticSize.Y
results.Parent = main

local resultsCorner = Instance.new("UICorner")
resultsCorner.CornerRadius = UDim.new(0, 6)
resultsCorner.Parent = results

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 5)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = results

local resultPadding = Instance.new("UIPadding")
resultPadding.PaddingTop = UDim.new(0, 7)
resultPadding.PaddingBottom = UDim.new(0, 7)
resultPadding.PaddingLeft = UDim.new(0, 7)
resultPadding.PaddingRight = UDim.new(0, 7)
resultPadding.Parent = results

local function clearResults()
    for _, child in ipairs(results:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function addResult(text, color)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -4, 0, 48)
    label.BackgroundColor3 = Color3.fromRGB(40, 44, 54)
    label.BorderSizePixel = 0
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(225, 230, 240)
    label.Font = Enum.Font.Code
    label.TextSize = 12
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = results

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = label

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = label
end

local searching = false

local function FindItem(name)
    if searching then
        return
    end

    name = name:match("^%s*(.-)%s*$")

    if name == "" then
        status.Text = "Introduz o nome de um item."
        return
    end

    searching = true
    searchButton.Text = "SEARCHING..."
    status.Text = "A procurar: " .. name
    clearResults()

    local ok, countOrError = pcall(function()
        local count = 0

        for id in world:query(comps.Storable, comps.ObjectId) do
            local objectId = world:get(id, comps.ObjectId)

            if objectId ~= nil
                and string.find(
                    string.lower(tostring(objectId)),
                    string.lower(name),
                    1,
                    true
                )
            then
                count += 1

                local entityOk, serverEntity = pcall(function()
                    return replicator:get_server_entity(id)
                end)

                addResult(string.format(
                    "Item: %s\nID: %s | Server: %s",
                    tostring(objectId),
                    tostring(id),
                    entityOk and tostring(serverEntity)
                        or "Unavailable"
                ))
            end
        end

        return count
    end)

    if ok then
        if countOrError == 0 then
            addResult("Nenhum item encontrado.", Color3.fromRGB(255, 130, 130))
        end

        status.Text = string.format(
            "Pesquisa concluída | Resultados: %d",
            countOrError
        )
    else
        status.Text = "Erro na pesquisa. Verifica os módulos."
        warn("[Dead Rails Item Finder] " .. tostring(countOrError))
    end

    searching = false
    searchButton.Text = "SEARCH ITEMS"
end

searchButton.Activated:Connect(function()
    FindItem(searchBox.Text)
end)

searchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        FindItem(searchBox.Text)
    end
end)

print("[Dead Rails Hub] Item Finder carregado.")
