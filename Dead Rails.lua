--[[
    Dead Rails | Modular UI Framework
    made by @ronzy.exe on discord
    yeah join our discord server: https://discord.gg/76tHHGBrfz

    Base modular para organizar as funcionalidades desejadas.
    Compatibilidade e funcionalidades dependem do ambiente de execução.
]]

local DeadRails = {
    Name = "Dead Rails",
    Version = "0.1.0",
    Modules = {},
    Connections = {},
    Config = {
        Visuals = {},
        Player = {},
        Movement = {},
        Healing = {},
        Lighting = {},
        Utility = {},
    },
    Unloaded = false,
}

local function RegisterModule(name, callback)
    assert(type(name) == "string", "Module name must be a string")
    assert(type(callback) == "function", "Module callback must be a function")

    DeadRails.Modules[name] = callback
end

function DeadRails:RunModule(name, ...)
    if self.Unloaded then
        return false, "Framework unloaded"
    end

    local callback = self.Modules[name]
    if not callback then
        return false, "Module not found: " .. tostring(name)
    end

    local success, result = pcall(callback, ...)
    if not success then
        warn(("[DeadRails] %s failed: %s"):format(name, tostring(result)))
        return false, result
    end

    return true, result
end

function DeadRails:AddConnection(connection)
    if connection then
        table.insert(self.Connections, connection)
    end

    return connection
end

function DeadRails:Unload()
    if self.Unloaded then
        return
    end

    self.Unloaded = true

    for _, connection in ipairs(self.Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    table.clear(self.Connections)
    table.clear(self.Modules)

    print("[DeadRails] Framework unloaded.")
end

-- Module registration example:
RegisterModule("Status", function()
    return {
        Name = DeadRails.Name,
        Version = DeadRails.Version,
        Loaded = not DeadRails.Unloaded,
    }
end)

local success, status = DeadRails:RunModule("Status")

if success then
    print(("[DeadRails] %s v%s initialized.")
        :format(status.Name, status.Version))
end

return DeadRails