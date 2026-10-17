warn("--- [RON] EXECUTING SCRIPT ---")
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", { Title = "RON", Text = "Script iniciado, cargando UI...", Duration = 6 }) end)
--[[
  RON CD-1  |  Team CHX
  Version 1.0.5
  Tabs: Main, Info, Visuals, Player, Automation, Anticheat, Antis, Archives, Stairwell, Alerts, Misc, Fun, Keybinds, Configs
  Ransomity is real
]]
print("[RON] Loading Services")
-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ============================================================================================
-- Idioma (English por defecto), deteccion de juego y auto ejecucion al teletransportar
-- ============================================================================================
if not game:IsLoaded() then game.Loaded:Wait() end
R4N_KeyTab = {}
R4N_LANG = "en"
pcall(function()
    if isfile and readfile and isfile("RON_Lang.txt") then
        local l = readfile("RON_Lang.txt"):gsub("%s+", "")
        if l == "es" or l == "ru" or l == "en" then R4N_LANG = l end
    end
end)

do
    local genv = (getgenv and getgenv()) or _G
    local isDoors = game.PlaceId == 6516141723 or game.PlaceId == 6839171747 or game.GameId == 2440500124
    if not isDoors then
        -- ejecucion automatica tras teletransportarte a otro juego: no hacer nada
        if genv.R4N_AUTOEXEC then genv.R4N_AUTOEXEC = nil return end
        local msgs = {
            en = "This script is only for DOORS. Join DOORS and execute it correctly.",
            es = "Este script es solo para Doors, entra a doors y ejecútalo correctamente",
            ru = "Этот скрипт только для DOORS. Зайдите в DOORS и запустите его правильно.",
        }
        pcall(function() LocalPlayer:Kick(msgs[R4N_LANG] or msgs.en) end)
        return
    end
    genv.R4N_AUTOEXEC = nil
end

-- Auto ejecutar al teletransportar: vuelve a ejecutar el MISMO codigo que ejecutaste (sin link).
-- El codigo ejecutado se lee de la propia cadena del script y se guarda en RON_Cache.lua; si el ejecutor
-- no lo expone, se usa la copia guardada de una ejecucion anterior.
R4N_SRC = nil
pcall(function()
    local info = debug.getinfo and debug.getinfo(1, "S")
    local s = info and info.source
    if type(s) == "string" and #s > 20000 and s:sub(1, 1) ~= "@" and s:sub(1, 1) ~= "=" then R4N_SRC = s end
end)
R4N_AE_STATUS = "off"
function R4N_QueueAutoExec()
    pcall(function()
        local CACHE = "RON_Cache.lua"
        local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
        if not (isfile and readfile and isfile("RON_AutoExec.json")) then return end
        local d = HttpService:JSONDecode(readfile("RON_AutoExec.json"))
        if type(d) ~= "table" or not d.on then R4N_AE_STATUS = "off" return end
        if not qot then R4N_AE_STATUS = "noqueue" return end
        local loader
        if R4N_SRC then
            if writefile then pcall(writefile, CACHE, R4N_SRC) end
            if isfile(CACHE) then
                loader = "loadstring(readfile(" .. string.format("%q", CACHE) .. "))()"
            elseif #R4N_SRC < 2000000 then
                loader = "loadstring(" .. string.format("%q", R4N_SRC) .. ")()"
            end
            R4N_AE_STATUS = loader and "ok" or "nosource"
        elseif isfile(CACHE) then
            loader = "loadstring(readfile(" .. string.format("%q", CACHE) .. "))()"
            R4N_AE_STATUS = "cache"
        else
            for _, f in ipairs({ "RON-HUB-FINAL.lua", "RON-HUB.lua", "RON.lua" }) do
                if isfile(f) then
                    loader = "loadstring(readfile(" .. string.format("%q", f) .. "))()"
                    break
                end
            end
            R4N_AE_STATUS = loader and "file" or "nosource"
        end
        if not loader then return end
        local genv = (getgenv and getgenv()) or _G
        if genv.R4N_QUEUED then return end
        genv.R4N_QUEUED = true
        qot("local g=(getgenv and getgenv()) or _G;g.R4N_QUEUED=nil;"
            .. "local okf,f=pcall(readfile,\"RON_AutoExec.json\");if okf and f and not f:find('\"on\":true',1,true) then return end;"
            .. "g.R4N_AUTOEXEC=true;if not game:IsLoaded() then game.Loaded:Wait() end;task.wait(1);" .. loader)
    end)
end
R4N_QueueAutoExec()


math.randomseed(os.time())

print("[RON] Services Loaded")
print("[RON] Loading Icon")
----------------------------------------------------
-- ICON LOADER (fixed)
-- El ID 107740382639133 suele ser un DECAL. assetdelivery devuelve XML
-- para decals (no un PNG), por eso no cargaba. Aqui resolvemos el ID real
-- de la imagen y validamos que lo descargado sea un PNG de verdad.
----------------------------------------------------
local ICON_ID = 107740382639133
local ICON_FILE = "RON_Icon.png"
local FALLBACK_ICON = "shield" -- icono lucide, siempre funciona

local function IsPng(data)
    return type(data) == "string" and #data > 8 and data:sub(2, 4) == "PNG"
end

local function ResolveImageId(id)
    -- Si es un Decal, saca el ID de la textura real
    local ok, result = pcall(function()
        local obj = game:GetObjects("rbxassetid://" .. id)[1]
        if obj then
            local tex = obj.Texture or obj.Image or obj.ColorMapContent
            if tex then
                return tostring(tex):match("id=(%d+)") or tostring(tex):match("(%d+)$")
            end
        end
    end)
    if ok and result then
        return result
    end
    return tostring(id)
end

local function GetIconAsset()
    local canFile = isfile and writefile and readfile and getcustomasset

    -- 1) Usar archivo cacheado si es un PNG valido
    if canFile and isfile(ICON_FILE) then
        local ok, data = pcall(readfile, ICON_FILE)
        if ok and IsPng(data) then
            local ok2, asset = pcall(getcustomasset, ICON_FILE)
            if ok2 and asset then
                return asset
            end
        elseif delfile then
            pcall(delfile, ICON_FILE) -- archivo corrupto de intentos anteriores
        end
    end

    -- 2) Resolver ID real y descargar
    local imageId = ResolveImageId(ICON_ID)

    if canFile then
        local ok, data = pcall(function()
            return game:HttpGet("https://assetdelivery.roblox.com/v1/asset/?id=" .. imageId)
        end)
        if ok and IsPng(data) then
            pcall(writefile, ICON_FILE, data)
            local ok2, asset = pcall(getcustomasset, ICON_FILE)
            if ok2 and asset then
                return asset
            end
        end
    end

    -- 3) Usar el ID de imagen resuelto directamente
    if imageId and imageId ~= tostring(ICON_ID) then
        return "rbxassetid://" .. imageId
    end

    -- 4) Fallback seguro (icono lucide de WindUI)
    return FALLBACK_ICON
end

local IconAsset = FALLBACK_ICON
pcall(function()
    -- Solo usa el PNG ya cacheado (instantaneo). Nunca espera a la red.
    if isfile and readfile and getcustomasset and isfile(ICON_FILE) then
        local data = readfile(ICON_FILE)
        if IsPng(data) then
            local asset = getcustomasset(ICON_FILE)
            if asset then IconAsset = asset end
        end
    end
end)
-- Descarga/cachea el icono en segundo plano para la proxima ejecucion
task.spawn(function() pcall(GetIconAsset) end)

print("[RON] Icon loaded")
print("[RON] Loading Execution Count")
----------------------------------------------------
-- EXECUTION COUNTER
----------------------------------------------------
local ExecCountFile = "RON_ExecCount.txt"
local executionCount = 1

if isfile and readfile and writefile then
    if isfile(ExecCountFile) then
        local ok, raw = pcall(readfile, ExecCountFile)
        local current = ok and tonumber(raw)
        if current then
            executionCount = current + 1
        end
    end
    pcall(writefile, ExecCountFile, tostring(executionCount))
end

-- Identify Executor
local currentExecutor = "Unknown Executor"
if identifyexecutor then
    currentExecutor = identifyexecutor()
elseif getexecutorname then
    currentExecutor = getexecutorname()
end

print("[RON] Execution Count loaded")
print("[RON] Loading WindUI")
----------------------------------------------------
-- LOAD WINDUI (con pcall)
----------------------------------------------------
local WindUI, Window = (function()
    local env = (getgenv and getgenv()) or _G

    -- Stubs para ejecutores (sobre todo moviles) que no traen estas funciones.
    -- WindUI las llama al cargar y daba "attempt to call a nil value".
    local permanent = {
        isfolder  = function() return false end,
        makefolder = function() end,
        cloneref  = function(o) return o end,
        gethui    = function() return game:GetService("CoreGui") end,
    }
    local temporary = {
        isfile    = function() return false end,
        readfile  = function() return "" end,
        writefile = function() end,
        listfiles = function() return {} end,
        delfile   = function() end,
        delfolder = function() end,
    }
    local addedTemp = {}
    for name, fn in pairs(permanent) do
        if type(env[name]) ~= "function" then pcall(function() env[name] = fn end) end
    end
    for name, fn in pairs(temporary) do
        if type(env[name]) ~= "function" then
            local ok = pcall(function() env[name] = fn end)
            if ok then addedTemp[#addedTemp + 1] = name end
        end
    end

    local function notify(msg)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "RON", Text = msg, Duration = 8
            })
        end)
    end

    local sources = {
        "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
        "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
        "https://github.com/Footagesus/WindUI/releases/download/1.6.41/main.lua",
    }

    local function withTimeout(seconds, fn)
        local done, result = false, nil
        task.spawn(function()
            local ok, r = pcall(fn)
            if ok then result = r end
            done = true
        end)
        local t0 = os.clock()
        while not done and os.clock() - t0 < seconds do task.wait(0.1) end
        if not done then warn("[RON] Timeout esperando WindUI") end
        return result
    end

    local function tryLoadRaw(url)
        local okGet, src = pcall(function() return game:HttpGet(url) end)
        if not okGet or type(src) ~= "string" or #src < 1000 then
            warn("[RON] HttpGet fallo: " .. url .. " -> " .. tostring(src))
            return nil
        end
        local fn, cerr = loadstring(src)
        if type(fn) ~= "function" then
            warn("[RON] loadstring fallo: " .. url .. " -> " .. tostring(cerr))
            return nil
        end
        local okRun, lib = pcall(fn)
        if not okRun or type(lib) ~= "table" or type(lib.CreateWindow) ~= "function" then
            warn("[RON] WindUI invalido: " .. url .. " -> " .. tostring(lib))
            return nil
        end
        return lib
    end

    local function makeWindow(lib, icon, full)
        local cfg = {
            Title = "RON CD-1",
            Icon = icon,
            Author = "Team CHX",
            Folder = "RON_Configs",
            Size = UDim2.fromOffset(580, 460),
            Theme = "Dark",
        }
        if full then
            cfg.Transparent = true
            cfg.SideBarWidth = 170
            cfg.HasOutline = true
        end
        return pcall(function() return lib:CreateWindow(cfg) end)
    end

    local lib, win
    for _, url in ipairs(sources) do
        local candidate = withTimeout(25, function() return tryLoadRaw(url) end)
        if candidate then
            -- Intenta con la config completa, luego con otro icono, luego minima
            local ok, w = makeWindow(candidate, IconAsset, true)
            if not ok then
                warn("[RON] CreateWindow fallo (config completa): " .. tostring(w))
                ok, w = makeWindow(candidate, FALLBACK_ICON, true)
            end
            if not ok then
                warn("[RON] CreateWindow fallo (icono fallback): " .. tostring(w))
                ok, w = makeWindow(candidate, FALLBACK_ICON, false)
            end
            if ok and w then
                lib, win = candidate, w
                break
            end
            warn("[RON] CreateWindow fallo (config minima): " .. tostring(w))
        end
    end

    for _, name in ipairs(addedTemp) do
        pcall(function() env[name] = nil end)
    end

    if not lib or not win then
        warn("[RON] No se pudo cargar WindUI desde ninguna fuente")
        notify("No se pudo cargar la UI. Revisa tu internet/ejecutor y reintenta.")
        return nil, nil
    end
    return lib, win
end)()

if not WindUI or not Window then
    return
end

-- Traduccion de la interfaz: se traducen los titulos (English es el idioma por defecto)
R4N_I18N = {
    es = {
        ["Auto Doors (beta)"] = "Auto Doors (beta)",
        ["Apply Recommended Setup"] = "Aplicar Configuración Recomendada",
        ["Show Auto Doors Status"] = "Mostrar Estado de Auto Doors",
        ["Auto Doors Settings"] = "Ajustes de Auto Doors",
        ["Auto Doors"] = "Auto Doors",
        ["What's New"] = "Lo nuevo",
        ["Profile"] = "Perfil",
        ["Apply Profile"] = "Aplicar Perfil",
        ["Force Unstuck Now"] = "Desatascar Ahora",
        ["Reset Statistics"] = "Reiniciar Estadísticas",
        ["Keep Searching For Keys"] = "Seguir Buscando Llaves",
        ["Force Open Fallback"] = "Apertura Forzada de Respaldo",
        ["Auto Doors Timing"] = "Tiempos de Auto Doors",
        ["Max Retries Per Target"] = "Reintentos Máximos por Objetivo",
        ["Loot Order"] = "Orden de Botín",
        ["Auto Doors Safety"] = "Seguridad de Auto Doors",
        ["Anti-Stuck Watchdog"] = "Vigilante Anti-Atasco",
        ["Stuck Timeout (seconds)"] = "Tiempo de Atasco (segundos)",
        ["Max Hide Time (seconds)"] = "Tiempo Máx. Escondido (segundos)",
        ["Stop After (minutes, 0 = never)"] = "Parar Tras (minutos, 0 = nunca)",
        ["Stop Below Health % (0 = off)"] = "Parar con Vida Bajo % (0 = off)",
        ["Auto Doors Display"] = "Pantalla de Auto Doors",
        ["Auto Doors Notifications"] = "Notificaciones de Auto Doors",
        ["Status HUD"] = "HUD de Estado",
        ["Open Doors"] = "Abrir Puertas",
        ["Grab Gold & Stardust"] = "Agarrar Oro y Polvo Estelar",
        ["Loot Drawers"] = "Lootear Cajones",
        ["Loot Chests & Lockers"] = "Lootear Cofres y Casilleros",
        ["Grab Keys & Unlock Doors"] = "Agarrar Llaves y Abrir Puertas",
        ["Grab Items"] = "Agarrar Items",
        ["Avoid Entities (Auto Hide)"] = "Evitar Entidades (Esconderse Solo)",
        ["Solve Puzzles (Library, Breakers, Anchors)"] = "Resolver Puzzles (Biblioteca, Fusibles, Anclas)",
        ["Skip Seek"] = "Saltar Seek",
        ["Action Delay (ms)"] = "Retraso entre Acciones (ms)",
        ["Max Time Per Room (seconds)"] = "Tiempo Máx. por Sala (segundos)",
        ["Stop At Room (0 = never)"] = "Parar en la Sala (0 = nunca)",
        ["SPD Button"] = "Botón SPD",
        ["ACM Button"] = "Botón ACM",
        ["About RON CD-1"] = "Acerca de RON CD-1",
        ["Alerts"] = "Alertas",
        ["Alma"] = "Alma",
        ["Anomaly ESP"] = "ESP de Anomalías",
        ["Anomaly Notification"] = "Notificación de Anomalías",
        ["Anti"] = "Anti",
        ["Anti Closet Trash"] = "Anti Basura de Armario",
        ["Anti Lag"] = "Anti Lag",
        ["Anti Lag Level"] = "Nivel de Anti Lag",
        ["Anti Noise"] = "Anti Noise",
        ["Anti Ransom"] = "Anti Ransom",
        ["Anticheat"] = "Anticheat",
        ["Anticheat Bypass"] = "Bypass del Anticheat",
        ["Anticheat Manipulator"] = "Manipulador de Anticheat",
        ["Antis"] = "Antis",
        ["Archives"] = "Archives",
        ["Audio"] = "Audio",
        ["Auto Alma Minigame"] = "Auto Minijuego de Alma",
        ["Auto Breaker Box"] = "Auto Caja de Fusibles",
        ["Auto Breaker Room"] = "Auto Sala de Fusibles",
        ["Auto Bring Dropped Items"] = "Auto Traer Items Tirados",
        ["Auto Closet"] = "Auto Armario",
        ["Auto Closet Ignore List"] = "Lista de Ignorados del Auto Armario",
        ["Auto Complete Cringle"] = "Auto Completar Cringle",
        ["Auto Complete Dam Seek"] = "Auto Completar Dam Seek",
        ["Auto Complete Honcho (experimental)"] = "Auto Completar Honcho (experimental)",
        ["Auto Deposit"] = "Auto Depositar",
        ["Auto Heartbeat Minigame"] = "Auto Minijuego del Latido",
        ["Auto Hotel"] = "Auto Hotel",
        ["Auto Interact"] = "Auto Interactuar",
        ["Auto Interact Ignore List"] = "Lista de Ignorados del Auto Interactuar",
        ["Auto Interact Ignored Items"] = "Items Ignorados del Auto Interactuar",
        ["Auto Interact: why is it skipping?"] = "Auto Interactuar: ¿por qué se salta algo?",
        ["Auto Library"] = "Auto Biblioteca",
        ["Auto Performance"] = "Auto Rendimiento",
        ["Auto Position Spoof"] = "Auto Position Spoof",
        ["Auto Rooms"] = "Auto Rooms",
        ["Auto Scrap Drops"] = "Auto Chatarra de Drops",
        ["Auto Solve Anchors"] = "Auto Resolver Anclas",
        ["Auto Split Rooms"] = "Auto Dividir Salas",
        ["Auto Start On Move"] = "Iniciar Auto al Moverse",
        ["Auto Stop At End Of Game"] = "Auto Parar al Final del Juego",
        ["Auto Stop At Room"] = "Auto Parar en Sala",
        ["Auto Tp Next Door"] = "Auto TP a la Siguiente Puerta",
        ["Auto Unlock Padlock"] = "Auto Abrir Candado",
        ["Auto-enable ESP for this Mode"] = "Activar ESP Automático para este Modo",
        ["Automation"] = "Automatización",
        ["Bring Dropped Items"] = "Traer Items Tirados",
        ["Bug Out Creak (needs 5+ carts)"] = "Bug a Creak (requiere 5+ carritos)",
        ["Bypass"] = "Bypass",
        ["Bypass Alma"] = "Bypass de Alma",
        ["Bypass Combos"] = "Combos de Bypass",
        ["Bypass Drones"] = "Bypass de Drones",
        ["Bypass Electric Water"] = "Bypass de Agua Eléctrica",
        ["Bypass Figure"] = "Bypass de Figure",
        ["Bypass Scribbles"] = "Bypass de Scribbles",
        ["Bypass Seek"] = "Bypass de Seek",
        ["Bypasses"] = "Bypasses",
        ["Camera"] = "Cámara",
        ["Chase Paths"] = "Rutas de Persecución",
        ["Clear All"] = "Limpiar Todo",
        ["Clear All Entities"] = "Limpiar Todas las Entidades",
        ["Clear All Items"] = "Limpiar Todos los Items",
        ["Clear Debug Log"] = "Limpiar Registro de Debug",
        ["Closet & Anchors"] = "Armario y Anclas",
        ["Coming soon"] = "Próximamente",
        ["Config Selector"] = "Selector de Configs",
        ["Configs"] = "Configs",
        ["Cooldown per Entity (seconds)"] = "Enfriamiento por Entidad (segundos)",
        ["Copy Character Info"] = "Copiar Info del Personaje",
        ["Copy Debug Log"] = "Copiar Registro de Debug",
        ["Copy Game Info"] = "Copiar Info del Juego",
        ["Copy Nearby Objects (30 studs)"] = "Copiar Objetos Cercanos (30 studs)",
        ["Correct Box ESP"] = "ESP de Cajas Correctas",
        ["Creak"] = "Creak",
        ["Creak Aggression Text"] = "Texto de Agresión de Creak",
        ["Creak Text Range"] = "Rango del Texto de Creak",
        ["Create New Config"] = "Crear Nueva Config",
        ["Crouch Spoof"] = "Spoof de Agacharse",
        ["Crushers & Meld"] = "Crushers y Meld",
        ["Custom FOV"] = "FOV Personalizado",
        ["Custom Icon ID (optional)"] = "ID de Icono Personalizado (opcional)",
        ["Custom Sound ID (optional)"] = "ID de Sonido Personalizado (opcional)",
        ["Death"] = "Muerte",
        ["Debug"] = "Debug",
        ["Debug Mode"] = "Modo Debug",
        ["Debug Overlay"] = "Overlay de Debug",
        ["Debug Tools"] = "Herramientas de Debug",
        ["Delete Crushers"] = "Eliminar Crushers",
        ["Delete Figure"] = "Eliminar Figure",
        ["Delete Seek Trigger"] = "Eliminar Trigger de Seek",
        ["Detected at load: "] = "Detectado al cargar: ",
        ["Disable Crushers"] = "Desactivar Crushers",
        ["Disable Glitch Jumpscare"] = "Desactivar Jumpscare de Glitch",
        ["Disable Hide Vignette"] = "Desactivar Viñeta al Esconderse",
        ["Disable Idle Kick"] = "Desactivar Kick por Inactividad",
        ["Disable Timothy Jumpscare"] = "Desactivar Jumpscare de Timothy",
        ["Disable Void Jumpscare"] = "Desactivar Jumpscare de Void",
        ["Display"] = "Pantalla",
        ["Distance Unit"] = "Unidad de Distancia",
        ["Door Reach"] = "Alcance de Puertas",
        ["Doors"] = "Puertas",
        ["Dropped Items Counter"] = "Contador de Items Tirados",
        ["Duration (seconds)"] = "Duración (segundos)",
        ["ESP Performance"] = "Rendimiento del ESP",
        ["ESP Performance Mode"] = "Modo de Rendimiento del ESP",
        ["ESP Refresh Rate"] = "Frecuencia de Actualización del ESP",
        ["ESP Summary"] = "Resumen del ESP",
        ["ESP fixes"] = "Arreglos del ESP",
        ["Effects"] = "Efectos",
        ["Enable All ESP for Current Mode"] = "Activar Todo el ESP del Modo Actual",
        ["Enable Jump"] = "Activar Salto",
        ["Enable Slide"] = "Activar Deslizamiento",
        ["Entities"] = "Entidades",
        ["Entities to show"] = "Entidades a mostrar",
        ["Entities with distance limit"] = "Entidades con Límite de Distancia",
        ["Entity Despawn"] = "Desaparición de Entidades",
        ["Entity Distance Limit"] = "Límite de Distancia de Entidades",
        ["Entity Filter"] = "Filtro de Entidades",
        ["Entity Notifier"] = "Notificador de Entidades",
        ["Environment"] = "Entorno",
        ["Error"] = "Error",
        ["Exit Closet"] = "Salir del Armario",
        ["Exploits / Anti"] = "Exploits / Anti",
        ["FLY Button"] = "Botón FLY",
        ["Farming"] = "Farmeo",
        ["Field of View"] = "Campo de Visión",
        ["Figure Godmode"] = "Godmode contra Figure",
        ["Fill Opacity (%)"] = "Opacidad de Relleno (%)",
        ["Floating Buttons"] = "Botones Flotantes",
        ["Floor bypass"] = "Bypass de Piso",
        ["Floors"] = "Pisos",
        ["Fly"] = "Volar",
        ["Fly & Noclip"] = "Volar y Noclip",
        ["Fly Speed"] = "Velocidad de Vuelo",
        ["Force Gamemode"] = "Forzar Modo de Juego",
        ["Forget-Me-Not"] = "Forget-Me-Not",
        ["Forget-Me-Not Skipper"] = "Saltar Forget-Me-Not",
        ["Fullbright"] = "Fullbright",
        ["Fullbright Ambient (%)"] = "Ambiente de Fullbright (%)",
        ["Fullbright Brightness"] = "Brillo de Fullbright",
        ["Game Mode"] = "Modo de Juego",
        ["Generate 12-Char Share Code"] = "Generar Código de 12 Caracteres",
        ["Get Current Floor"] = "Obtener Piso Actual",
        ["Get Current Room"] = "Obtener Sala Actual",
        ["Good to know"] = "Bueno saber",
        ["Grab All Items (real pickup)"] = "Agarrar Todos los Items (real)",
        ["Guess Library Code"] = "Adivinar Código de la Biblioteca",
        ["Hide Looted Containers"] = "Ocultar Contenedores Saqueados",
        ["Hiding Spot Transparency (%)"] = "Transparencia de Escondites (%)",
        ["Honcho"] = "Honcho",
        ["Hotel"] = "Hotel",
        ["How Meld removal works"] = "Cómo funciona quitar Meld",
        ["Hub"] = "Hub",
        ["Ignore A-60"] = "Ignorar A-60",
        ["Ignore Entities"] = "Ignorar Entidades",
        ["Ignore List"] = "Lista de Ignorados",
        ["Ignore all items"] = "Ignorar todos los items",
        ["Ignore everything"] = "Ignorar todo",
        ["Ignore no items"] = "No ignorar items",
        ["Ignore nothing"] = "No ignorar nada",
        ["Ignored Items"] = "Items Ignorados",
        ["Import Code"] = "Importar Código",
        ["Import Config from Code"] = "Importar Config desde Código",
        ["Infinite Items"] = "Items Infinitos",
        ["Infinite Items List"] = "Lista de Items Infinitos",
        ["Infinite Jump"] = "Salto Infinito",
        ["Infinite Revives"] = "Revivires Infinitos",
        ["Info"] = "Info",
        ["Instant Proximity Prompt"] = "Prompts Instantáneos",
        ["Interaction"] = "Interacción",
        ["Interval (seconds)"] = "Intervalo (segundos)",
        ["Item Filter"] = "Filtro de Items",
        ["Items"] = "Items",
        ["Items to notify"] = "Items a notificar",
        ["Items to show"] = "Items a mostrar",
        ["Jump"] = "Salto",
        ["Jump Power"] = "Fuerza de Salto",
        ["Keybinds"] = "Teclas",
        ["Knob Farm"] = "Farmeo de Perillas",
        ["Ladder Softlock Fix"] = "Arreglo de Bloqueo en Escaleras",
        ["Library"] = "Biblioteca",
        ["Lighting"] = "Iluminación",
        ["Live Session"] = "Sesión en Vivo",
        ["Load Selected Config"] = "Cargar Config Seleccionada",
        ["Main"] = "Principal",
        ["Manipulation Method"] = "Método de Manipulación",
        ["Max Distance"] = "Distancia Máxima",
        ["Max ESP Objects"] = "Máx. Objetos del ESP",
        ["Meld"] = "Meld",
        ["Mines & Rooms"] = "Mines y Rooms",
        ["Misc"] = "Varios",
        ["Mobile Buttons"] = "Botones Móviles",
        ["Mode Presets"] = "Preajustes de Modo",
        ["Movement"] = "Movimiento",
        ["Movement & Anticheat Manipulator"] = "Movimiento y Manipulador de Anticheat",
        ["Movement Diagnostics"] = "Diagnóstico de Movimiento",
        ["New Config Name"] = "Nombre de la Nueva Config",
        ["No Scribbles Damage"] = "Sin Daño de Scribbles",
        ["Noclip"] = "Noclip",
        ["Noise TV & Carts"] = "TV de Noise y Carritos",
        ["Noise TV Breaker"] = "Rompedor de TV de Noise",
        ["Notification Settings"] = "Ajustes de Notificaciones",
        ["Notification Style"] = "Estilo de Notificación",
        ["Notify Despawn"] = "Avisar Desaparición",
        ["Notify Haste Time"] = "Avisar Tiempo de Haste",
        ["Notify Items"] = "Avisar Items",
        ["Notify Library Code"] = "Avisar Código de Biblioteca",
        ["Notify Oxygen Level"] = "Avisar Nivel de Oxígeno",
        ["Notify Ransom"] = "Avisar Ransom",
        ["Notify Teller On My Ticket"] = "Avisar Teller en Mi Ticket",
        ["Notify Unlisted Items"] = "Avisar Items sin Lista",
        ["Notify all items"] = "Avisar todos los items",
        ["Notify me about"] = "Avisarme sobre",
        ["Notify nothing"] = "No avisar nada",
        ["Notify only essentials"] = "Avisar solo lo esencial",
        ["Open / Close Hub"] = "Abrir / Cerrar Hub",
        ["Open all Cubby Doors"] = "Abrir todas las Puertas de Cubby",
        ["Orbit Distance"] = "Distancia de Órbita",
        ["Orbit Dropped Items"] = "Orbitar Items Tirados",
        ["Orbit Height"] = "Altura de Órbita",
        ["Orbit Speed"] = "Velocidad de Órbita",
        ["Overwrite Selected Config"] = "Sobrescribir Config Seleccionada",
        ["Path Style"] = "Estilo de Ruta",
        ["Pathfind Timeout"] = "Tiempo Límite de Ruta",
        ["Per-category tracers"] = "Trazadores por Categoría",
        ["Performance"] = "Rendimiento",
        ["Play Again"] = "Jugar de Nuevo",
        ["Play Sound"] = "Reproducir Sonido",
        ["Player"] = "Jugador",
        ["Player Information"] = "Información del Jugador",
        ["Player Name Type"] = "Tipo de Nombre del Jugador",
        ["Please collect some gold to earn knobs."] = "Recoge algo de oro para ganar perillas.",
        ["Position Spoof"] = "Position Spoof",
        ["Preset"] = "Preajuste",
        ["Print ESP Summary"] = "Imprimir Resumen del ESP",
        ["Prompt Clip"] = "Prompt a Través de Paredes",
        ["Prompt Reach Multiplier"] = "Multiplicador de Alcance de Prompts",
        ["Prompt Tools"] = "Herramientas de Prompts",
        ["Prompts"] = "Prompts",
        ["RON"] = "RON",
        ["RON CD-1"] = "RON CD-1",
        ["Re-detect Game Mode"] = "Re-detectar Modo de Juego",
        ["Refresh Config List"] = "Actualizar Lista de Configs",
        ["Remove"] = "Quitar",
        ["Remove Acceleration"] = "Quitar Aceleración",
        ["Remove Basement Gate"] = "Quitar Reja del Sótano",
        ["Remove Camera Bobbing"] = "Quitar Balanceo de Cámara",
        ["Remove Camera Shake"] = "Quitar Temblor de Cámara",
        ["Remove Closet Delay"] = "Quitar Espera del Armario",
        ["Remove Fog"] = "Quitar Niebla",
        ["Remove Footstep Sounds"] = "Quitar Sonido de Pasos",
        ["Remove Interacting Sounds"] = "Quitar Sonidos de Interacción",
        ["Remove Jammin Music"] = "Quitar Música de Jammin",
        ["Remove Meld (keep ropes & doors)"] = "Quitar Meld (conserva cuerdas y puertas)",
        ["Remove Meld Walls & Data"] = "Quitar Paredes y Datos de Meld",
        ["Remove Paintings Door"] = "Quitar Puerta de Cuadros",
        ["Remove Skeleton Door"] = "Quitar Puerta de Esqueleto",
        ["Reset"] = "Reiniciar",
        ["Reset Character"] = "Reiniciar Personaje",
        ["Restore Prompts"] = "Restaurar Prompts",
        ["Restore default ignored items"] = "Restaurar items ignorados por defecto",
        ["Return to Lobby"] = "Volver al Lobby",
        ["Revive"] = "Revivir",
        ["Room Process Time"] = "Tiempo de Proceso de Sala",
        ["Run"] = "Correr",
        ["Save New Config"] = "Guardar Nueva Config",
        ["Scan Rooms for Entities"] = "Escanear Salas en Busca de Entidades",
        ["Scrap"] = "Chatarra",
        ["Scribbles"] = "Scribbles",
        ["Script Information"] = "Información del Script",
        ["Select All"] = "Seleccionar Todo",
        ["Select All Entities"] = "Seleccionar Todas las Entidades",
        ["Select All Items"] = "Seleccionar Todos los Items",
        ["Select Recommended"] = "Seleccionar Recomendados",
        ["Select Saved Config"] = "Seleccionar Config Guardada",
        ["Session"] = "Sesión",
        ["Share Code"] = "Código para Compartir",
        ["Short Code Sharing (12 Chars)"] = "Compartir con Código Corto (12 caracteres)",
        ["Show Buttons"] = "Mostrar Botones",
        ["Show Distance"] = "Mostrar Distancia",
        ["Show Eyestalk Path"] = "Mostrar Ruta de Eyestalk",
        ["Show Names"] = "Mostrar Nombres",
        ["Show Path"] = "Mostrar Ruta",
        ["Show Seek Path"] = "Mostrar Ruta de Seek",
        ["Infinite Crucifix"] = "Crucifijo Infinito",
        ["Remove Cutscenes"] = "Quitar Cinemáticas",
        ["Disable Entity Jumpscares"] = "Desactivar Jumpscares de Entidades",
        ["Disable Firedamp Effect"] = "Desactivar Efecto de Firedamp",
        ["Extras"] = "Extras",
        ["Show Speedrun Timer"] = "Mostrar Temporizador de Speedrun",
        ["Show Splits"] = "Mostrar Splits",
        ["Show Tips"] = "Mostrar Consejos",
        ["Show Unlisted Entities"] = "Mostrar Entidades sin Lista",
        ["Show Unlisted Items"] = "Mostrar Items sin Lista",
        ["Skip Seek (Hotel)"] = "Saltar Seek (Hotel)",
        ["Skip Seek (Mines)"] = "Saltar Seek (Mines)",
        ["Slide"] = "Deslizar",
        ["Slide Speed"] = "Velocidad de Deslizamiento",
        ["Sounds"] = "Sonidos",
        ["Spectate Entity"] = "Espectar Entidad",
        ["Spectate Mode"] = "Modo Espectador",
        ["Speed"] = "Velocidad",
        ["Speed Boost"] = "Impulso de Velocidad",
        ["Speed Hack"] = "Speed Hack",
        ["Speed Hack Value"] = "Valor del Speed Hack",
        ["Speed Method"] = "Método de Velocidad",
        ["Speedrun Timer"] = "Temporizador de Speedrun",
        ["Spoof Footsteps"] = "Spoof de Pasos",
        ["Stairwell"] = "Stairwell",
        ["Stairwell Extra ESP"] = "ESP Extra del Stairwell",
        ["Start / Pause / Resume"] = "Iniciar / Pausar / Reanudar",
        ["Start Knob Farm"] = "Iniciar Farmeo de Perillas",
        ["Stop (finish run)"] = "Parar (terminar partida)",
        ["Stop Meld Growth"] = "Detener Crecimiento de Meld",
        ["Stop On Death"] = "Parar al Morir",
        ["Stop Time / Anti Stampede"] = "Detener Tiempo / Anti Stampede",
        ["Successfully disabled the anticheat."] = "Anticheat desactivado correctamente.",
        ["TP All Drops to Nearest Grinder"] = "TP de Todos los Drops al Grinder Más Cercano",
        ["TP Carts To Me"] = "TP de Carritos a Mí",
        ["TP to Depot (Scrapper)"] = "TP al Depot (Scrapper)",
        ["TP to Emergency Exit"] = "TP a la Salida de Emergencia",
        ["TP to Fire Alarm"] = "TP a la Alarma de Incendios",
        ["TP to Shopping Cart"] = "TP al Carrito de Compras",
        ["TP to Trash and Drop It"] = "TP a la Basura y Soltarlo",
        ["Teleports"] = "Teletransportes",
        ["Teller"] = "Teller",
        ["Teller Number ESP"] = "ESP de Número de Teller",
        ["Test Notification"] = "Probar Notificación",
        ["Text Font"] = "Fuente del Texto",
        ["Text Size"] = "Tamaño del Texto",
        ["The anticheat has been re-enabled."] = "El anticheat se reactivó.",
        ["Third Person"] = "Tercera Persona",
        ["Third Person X Offset"] = "Desplazamiento X de Tercera Persona",
        ["Third Person Y Offset"] = "Desplazamiento Y de Tercera Persona",
        ["Third Person Z Offset"] = "Desplazamiento Z de Tercera Persona",
        ["Time Shower"] = "Time Shower",
        ["Timer Background (%)"] = "Fondo del Temporizador (%)",
        ["Timer Position"] = "Posición del Temporizador",
        ["Timer Size (%)"] = "Tamaño del Temporizador (%)",
        ["Timer: Reset"] = "Temporizador: Reiniciar",
        ["Timer: Start / Pause"] = "Temporizador: Iniciar / Pausar",
        ["Timer: Stop"] = "Temporizador: Parar",
        ["Tp Next Door"] = "TP a la Siguiente Puerta",
        ["Tracer Origin"] = "Origen de Trazadores",
        ["Tracer Thickness"] = "Grosor de Trazadores",
        ["Tracers"] = "Trazadores",
        ["Transparent Hiding Spots"] = "Escondites Transparentes",
        ["Unlock Distance"] = "Distancia de Desbloqueo",
        ["User Profile"] = "Perfil de Usuario",
        ["Verbose Logging"] = "Registro Detallado",
        ["Viewmodel"] = "Viewmodel",
        ["Viewmodel Offset"] = "Desplazamiento del Viewmodel",
        ["Visuals"] = "Visuales",
        ["Void"] = "Void",
        ["Void Guard"] = "Guardia de Void",
        ["Volume (%)"] = "Volumen (%)",
        ["What it does"] = "Qué hace",
        ["Where to find things"] = "Dónde encontrar cosas",
        ["X Offset"] = "Desplazamiento X",
        ["Y Offset"] = "Desplazamiento Y",
        ["You must be in Room 0 to use this."] = "Debes estar en la Sala 0 para usar esto.",
        ["You must have gold to do this."] = "Debes tener oro para hacer esto.",
        ["Z Offset"] = "Desplazamiento Z",
        ["Auto Steer Minecart"] = "Auto Dirigir Vagoneta",
        ["Manage Configs"] = "Administrar Configs",
        ["Rename To"] = "Renombrar a",
        ["Rename Selected Config"] = "Renombrar Config Seleccionada",
        ["Duplicate Selected Config"] = "Duplicar Config Seleccionada",
        ["Delete Selected Config"] = "Eliminar Config Seleccionada",
        ["Set Selected As Auto-Load"] = "Poner Seleccionada como Auto-Carga",
        ["Clear Auto-Load"] = "Quitar Auto-Carga",
        ["Load Scope"] = "Qué Cargar",
        ["Share / Import"] = "Compartir / Importar",
        ["Share Selected Config"] = "Compartir Config Seleccionada",
        ["Share Current Settings"] = "Compartir Ajustes Actuales",
        ["Upload Selected (Online Short Code)"] = "Subir Seleccionada (Código Corto Online)",
        ["Upload Current (Online Short Code)"] = "Subir Actuales (Código Corto Online)",
        ["Generated Code"] = "Código Generado",
        ["Import & Apply"] = "Importar y Aplicar",
        ["Import & Save As New"] = "Importar y Guardar como Nueva",
        ["Save Imported As"] = "Guardar Importada Como",
        ["Import From Clipboard (Apply)"] = "Importar del Portapapeles (Aplicar)",
        ["Language"] = "Idioma",
        ["Auto Execute"] = "Auto Ejecución",
        ["Auto Execute On Teleport"] = "Auto Ejecutar al Teletransportar",
        ["Loader (URL or file)"] = "Loader (URL o archivo)",
        ["Auto Doors Bot"] = "Bot de Auto Doors",
        ["Use Bot Speed"] = "Usar Velocidad del Bot",
        ["Bot Speed"] = "Velocidad del Bot",
        ["Bot Moves The Camera"] = "El Bot Mueve la Cámara",
        ["Camera Turn Speed"] = "Velocidad de Giro de Cámara",
        ["Bot Can Jump"] = "El Bot Puede Saltar",
        ["Bot Can Crouch"] = "El Bot Puede Agacharse",
        ["Hide Early (seconds)"] = "Esconderse con Antelación (segundos)",
        ["Use Ladders"] = "Usar Escaleras",
        ["Knob Farm Mode"] = "Modo Farmeo de Perillas",
        ["Teleport Fallback (last resort)"] = "Teletransporte de Respaldo (último recurso)",
        ["Strong Position Spoof"] = "Position Spoof Fuerte",
        ["Ladder Safe Mode"] = "Modo Seguro de Escaleras",
        ["Knob Farm Auto Start"] = "Inicio Automático del Farmeo de Perillas",
        ["Fun"] = "Diversión",
        ["Rainbow ESP"] = "ESP Arcoíris",
        ["Rainbow Speed"] = "Velocidad del Arcoíris",
        ["Transform"] = "Transformación",
        ["Transform Into"] = "Transformarte en",
        ["Transform Active"] = "Transformación Activa",
        ["Transform Size"] = "Tamaño de la Transformación",
        ["Transform Height Offset"] = "Altura de la Transformación",
        ["Force Third Person While Transformed"] = "Forzar Tercera Persona al Transformarte",
        ["Hide My Character"] = "Ocultar Mi Personaje",
        ["Play Model Animations"] = "Reproducir Animaciones del Modelo",
        ["Rescan Models"] = "Reescanear Modelos",
        ["Revert Transformation"] = "Revertir Transformación",
        ["Smart Performance"] = "Rendimiento Inteligente",
        ["FPS Guard"] = "Guardia de FPS",
        ["Smart Performance Info"] = "Info de Rendimiento Inteligente",
        ["Performance"] = "Rendimiento",
    },
    ru = {
        ["Auto Doors (beta)"] = "Авто двери (бета)",
        ["Apply Recommended Setup"] = "Применить рекомендуемые настройки",
        ["Show Auto Doors Status"] = "Показать статус Авто дверей",
        ["Auto Doors Settings"] = "Настройки Авто дверей",
        ["Auto Doors"] = "Авто двери",
        ["What's New"] = "Что нового",
        ["Profile"] = "Профиль",
        ["Apply Profile"] = "Применить профиль",
        ["Force Unstuck Now"] = "Исправить зависание",
        ["Reset Statistics"] = "Сбросить статистику",
        ["Keep Searching For Keys"] = "Продолжать поиск ключей",
        ["Force Open Fallback"] = "Принудительное открытие",
        ["Auto Doors Timing"] = "Тайминги Авто дверей",
        ["Max Retries Per Target"] = "Макс. повторов на цель",
        ["Loot Order"] = "Порядок сбора",
        ["Auto Doors Safety"] = "Безопасность Авто дверей",
        ["Anti-Stuck Watchdog"] = "Защита от зависаний",
        ["Stuck Timeout (seconds)"] = "Таймаут зависания (сек)",
        ["Max Hide Time (seconds)"] = "Макс. время укрытия (сек)",
        ["Stop After (minutes, 0 = never)"] = "Стоп через (мин, 0 = никогда)",
        ["Stop Below Health % (0 = off)"] = "Стоп при здоровье ниже % (0 = выкл)",
        ["Auto Doors Display"] = "Отображение Авто дверей",
        ["Auto Doors Notifications"] = "Уведомления Авто дверей",
        ["Status HUD"] = "HUD статуса",
        ["Open Doors"] = "Открывать двери",
        ["Grab Gold & Stardust"] = "Брать золото и звёздную пыль",
        ["Loot Drawers"] = "Обыскивать ящики",
        ["Loot Chests & Lockers"] = "Обыскивать сундуки и шкафчики",
        ["Grab Keys & Unlock Doors"] = "Брать ключи и открывать двери",
        ["Grab Items"] = "Брать предметы",
        ["Avoid Entities (Auto Hide)"] = "Избегать сущностей (авто укрытие)",
        ["Solve Puzzles (Library, Breakers, Anchors)"] = "Решать головоломки (библиотека, щитки, якоря)",
        ["Skip Seek"] = "Пропускать Seek",
        ["Action Delay (ms)"] = "Задержка между действиями (мс)",
        ["Max Time Per Room (seconds)"] = "Макс. время на комнату (сек)",
        ["Stop At Room (0 = never)"] = "Остановиться в комнате (0 = никогда)",
        ["SPD Button"] = "Кнопка SPD",
        ["ACM Button"] = "Кнопка ACM",
        ["About RON CD-1"] = "О RON CD-1",
        ["Alerts"] = "Оповещения",
        ["Alma"] = "Альма",
        ["Anomaly ESP"] = "ESP аномалий",
        ["Anomaly Notification"] = "Уведомление об аномалиях",
        ["Anti"] = "Анти",
        ["Anti Closet Trash"] = "Анти мусор из шкафа",
        ["Anti Lag"] = "Анти-лаг",
        ["Anti Lag Level"] = "Уровень анти-лага",
        ["Anti Noise"] = "Анти Noise",
        ["Anti Ransom"] = "Анти Ransom",
        ["Anticheat"] = "Античит",
        ["Anticheat Bypass"] = "Обход античита",
        ["Anticheat Manipulator"] = "Манипулятор античита",
        ["Antis"] = "Анти",
        ["Archives"] = "Archives",
        ["Audio"] = "Звук",
        ["Auto Alma Minigame"] = "Авто мини-игра Альмы",
        ["Auto Breaker Box"] = "Авто щиток",
        ["Auto Breaker Room"] = "Авто комната щитков",
        ["Auto Bring Dropped Items"] = "Авто принос выброшенных предметов",
        ["Auto Closet"] = "Авто шкаф",
        ["Auto Closet Ignore List"] = "Список игнорирования авто шкафа",
        ["Auto Complete Cringle"] = "Авто выполнение Cringle",
        ["Auto Complete Dam Seek"] = "Авто выполнение Dam Seek",
        ["Auto Complete Honcho (experimental)"] = "Авто выполнение Honcho (эксперимент.)",
        ["Auto Deposit"] = "Авто депозит",
        ["Auto Heartbeat Minigame"] = "Авто мини-игра сердцебиения",
        ["Auto Hotel"] = "Авто отель",
        ["Auto Interact"] = "Авто взаимодействие",
        ["Auto Interact Ignore List"] = "Список игнорирования авто взаимодействия",
        ["Auto Interact Ignored Items"] = "Игнорируемые предметы авто взаимодействия",
        ["Auto Interact: why is it skipping?"] = "Авто взаимодействие: почему пропускает?",
        ["Auto Library"] = "Авто библиотека",
        ["Auto Performance"] = "Авто производительность",
        ["Auto Position Spoof"] = "Авто подмена позиции",
        ["Auto Rooms"] = "Авто Rooms",
        ["Auto Scrap Drops"] = "Авто лом из дропа",
        ["Auto Solve Anchors"] = "Авто решение якорей",
        ["Auto Split Rooms"] = "Авто разделение комнат",
        ["Auto Start On Move"] = "Авто старт при движении",
        ["Auto Stop At End Of Game"] = "Авто стоп в конце игры",
        ["Auto Stop At Room"] = "Авто стоп в комнате",
        ["Auto Tp Next Door"] = "Авто ТП к следующей двери",
        ["Auto Unlock Padlock"] = "Авто открытие замка",
        ["Auto-enable ESP for this Mode"] = "Авто включение ESP для этого режима",
        ["Automation"] = "Автоматизация",
        ["Bring Dropped Items"] = "Принести выброшенные предметы",
        ["Bug Out Creak (needs 5+ carts)"] = "Баг Creak (нужно 5+ тележек)",
        ["Bypass"] = "Обход",
        ["Bypass Alma"] = "Обход Альмы",
        ["Bypass Combos"] = "Комбо обходов",
        ["Bypass Drones"] = "Обход дронов",
        ["Bypass Electric Water"] = "Обход электрической воды",
        ["Bypass Figure"] = "Обход Figure",
        ["Bypass Scribbles"] = "Обход Scribbles",
        ["Bypass Seek"] = "Обход Seek",
        ["Bypasses"] = "Обходы",
        ["Camera"] = "Камера",
        ["Chase Paths"] = "Пути погони",
        ["Clear All"] = "Очистить всё",
        ["Clear All Entities"] = "Очистить все сущности",
        ["Clear All Items"] = "Очистить все предметы",
        ["Clear Debug Log"] = "Очистить журнал отладки",
        ["Closet & Anchors"] = "Шкаф и якоря",
        ["Coming soon"] = "Скоро",
        ["Config Selector"] = "Выбор конфигурации",
        ["Configs"] = "Конфиги",
        ["Cooldown per Entity (seconds)"] = "Перезарядка на сущность (сек)",
        ["Copy Character Info"] = "Копировать инфо персонажа",
        ["Copy Debug Log"] = "Копировать журнал отладки",
        ["Copy Game Info"] = "Копировать инфо игры",
        ["Copy Nearby Objects (30 studs)"] = "Копировать ближние объекты (30 studs)",
        ["Correct Box ESP"] = "ESP правильных коробок",
        ["Creak"] = "Creak",
        ["Creak Aggression Text"] = "Текст агрессии Creak",
        ["Creak Text Range"] = "Дальность текста Creak",
        ["Create New Config"] = "Создать новый конфиг",
        ["Crouch Spoof"] = "Подмена приседания",
        ["Crushers & Meld"] = "Crushers и Meld",
        ["Custom FOV"] = "Свой FOV",
        ["Custom Icon ID (optional)"] = "Свой ID иконки (необязательно)",
        ["Custom Sound ID (optional)"] = "Свой ID звука (необязательно)",
        ["Death"] = "Смерть",
        ["Debug"] = "Отладка",
        ["Debug Mode"] = "Режим отладки",
        ["Debug Overlay"] = "Оверлей отладки",
        ["Debug Tools"] = "Инструменты отладки",
        ["Delete Crushers"] = "Удалить Crushers",
        ["Delete Figure"] = "Удалить Figure",
        ["Delete Seek Trigger"] = "Удалить триггер Seek",
        ["Detected at load: "] = "Определено при загрузке: ",
        ["Disable Crushers"] = "Отключить Crushers",
        ["Disable Glitch Jumpscare"] = "Отключить скример Glitch",
        ["Disable Hide Vignette"] = "Отключить виньетку укрытия",
        ["Disable Idle Kick"] = "Отключить кик за AFK",
        ["Disable Timothy Jumpscare"] = "Отключить скример Timothy",
        ["Disable Void Jumpscare"] = "Отключить скример Void",
        ["Display"] = "Отображение",
        ["Distance Unit"] = "Единица расстояния",
        ["Door Reach"] = "Дальность дверей",
        ["Doors"] = "Двери",
        ["Dropped Items Counter"] = "Счётчик выброшенных предметов",
        ["Duration (seconds)"] = "Длительность (сек)",
        ["ESP Performance"] = "Производительность ESP",
        ["ESP Performance Mode"] = "Режим производительности ESP",
        ["ESP Refresh Rate"] = "Частота обновления ESP",
        ["ESP Summary"] = "Сводка ESP",
        ["ESP fixes"] = "Исправления ESP",
        ["Effects"] = "Эффекты",
        ["Enable All ESP for Current Mode"] = "Включить весь ESP текущего режима",
        ["Enable Jump"] = "Включить прыжок",
        ["Enable Slide"] = "Включить скольжение",
        ["Entities"] = "Сущности",
        ["Entities to show"] = "Сущности для показа",
        ["Entities with distance limit"] = "Сущности с ограничением дистанции",
        ["Entity Despawn"] = "Исчезновение сущностей",
        ["Entity Distance Limit"] = "Лимит дистанции сущностей",
        ["Entity Filter"] = "Фильтр сущностей",
        ["Entity Notifier"] = "Уведомления о сущностях",
        ["Environment"] = "Окружение",
        ["Error"] = "Ошибка",
        ["Exit Closet"] = "Выйти из шкафа",
        ["Exploits / Anti"] = "Эксплойты / Анти",
        ["FLY Button"] = "Кнопка FLY",
        ["Farming"] = "Фарм",
        ["Field of View"] = "Поле зрения",
        ["Figure Godmode"] = "Годмод против Figure",
        ["Fill Opacity (%)"] = "Непрозрачность заливки (%)",
        ["Floating Buttons"] = "Плавающие кнопки",
        ["Floor bypass"] = "Обход этажа",
        ["Floors"] = "Этажи",
        ["Fly"] = "Полёт",
        ["Fly & Noclip"] = "Полёт и Noclip",
        ["Fly Speed"] = "Скорость полёта",
        ["Force Gamemode"] = "Принудительный режим игры",
        ["Forget-Me-Not"] = "Forget-Me-Not",
        ["Forget-Me-Not Skipper"] = "Пропуск Forget-Me-Not",
        ["Fullbright"] = "Полная яркость",
        ["Fullbright Ambient (%)"] = "Окружающий свет Fullbright (%)",
        ["Fullbright Brightness"] = "Яркость Fullbright",
        ["Game Mode"] = "Режим игры",
        ["Generate 12-Char Share Code"] = "Создать 12-символьный код",
        ["Get Current Floor"] = "Получить текущий этаж",
        ["Get Current Room"] = "Получить текущую комнату",
        ["Good to know"] = "Полезно знать",
        ["Grab All Items (real pickup)"] = "Взять все предметы (реально)",
        ["Guess Library Code"] = "Подбор кода библиотеки",
        ["Hide Looted Containers"] = "Скрывать обысканные контейнеры",
        ["Hiding Spot Transparency (%)"] = "Прозрачность укрытий (%)",
        ["Honcho"] = "Honcho",
        ["Hotel"] = "Отель",
        ["How Meld removal works"] = "Как работает удаление Meld",
        ["Hub"] = "Хаб",
        ["Ignore A-60"] = "Игнорировать A-60",
        ["Ignore Entities"] = "Игнорировать сущности",
        ["Ignore List"] = "Список игнорирования",
        ["Ignore all items"] = "Игнорировать все предметы",
        ["Ignore everything"] = "Игнорировать всё",
        ["Ignore no items"] = "Не игнорировать предметы",
        ["Ignore nothing"] = "Ничего не игнорировать",
        ["Ignored Items"] = "Игнорируемые предметы",
        ["Import Code"] = "Импорт кода",
        ["Import Config from Code"] = "Импорт конфига из кода",
        ["Infinite Items"] = "Бесконечные предметы",
        ["Infinite Items List"] = "Список бесконечных предметов",
        ["Infinite Jump"] = "Бесконечный прыжок",
        ["Infinite Revives"] = "Бесконечные возрождения",
        ["Info"] = "Инфо",
        ["Instant Proximity Prompt"] = "Мгновенные подсказки",
        ["Interaction"] = "Взаимодействие",
        ["Interval (seconds)"] = "Интервал (сек)",
        ["Item Filter"] = "Фильтр предметов",
        ["Items"] = "Предметы",
        ["Items to notify"] = "Предметы для уведомления",
        ["Items to show"] = "Предметы для показа",
        ["Jump"] = "Прыжок",
        ["Jump Power"] = "Сила прыжка",
        ["Keybinds"] = "Клавиши",
        ["Knob Farm"] = "Фарм ручек",
        ["Ladder Softlock Fix"] = "Исправление зависания на лестнице",
        ["Library"] = "Библиотека",
        ["Lighting"] = "Освещение",
        ["Live Session"] = "Текущая сессия",
        ["Load Selected Config"] = "Загрузить выбранный конфиг",
        ["Main"] = "Главная",
        ["Manipulation Method"] = "Метод манипуляции",
        ["Max Distance"] = "Макс. дистанция",
        ["Max ESP Objects"] = "Макс. объектов ESP",
        ["Meld"] = "Meld",
        ["Mines & Rooms"] = "Mines и Rooms",
        ["Misc"] = "Разное",
        ["Mobile Buttons"] = "Мобильные кнопки",
        ["Mode Presets"] = "Пресеты режимов",
        ["Movement"] = "Движение",
        ["Movement & Anticheat Manipulator"] = "Движение и манипулятор античита",
        ["Movement Diagnostics"] = "Диагностика движения",
        ["New Config Name"] = "Имя нового конфига",
        ["No Scribbles Damage"] = "Без урона от Scribbles",
        ["Noclip"] = "Noclip",
        ["Noise TV & Carts"] = "ТВ Noise и тележки",
        ["Noise TV Breaker"] = "Ломатель ТВ Noise",
        ["Notification Settings"] = "Настройки уведомлений",
        ["Notification Style"] = "Стиль уведомлений",
        ["Notify Despawn"] = "Уведомлять об исчезновении",
        ["Notify Haste Time"] = "Уведомлять о времени Haste",
        ["Notify Items"] = "Уведомлять о предметах",
        ["Notify Library Code"] = "Уведомлять о коде библиотеки",
        ["Notify Oxygen Level"] = "Уведомлять об уровне кислорода",
        ["Notify Ransom"] = "Уведомлять о Ransom",
        ["Notify Teller On My Ticket"] = "Уведомлять о Teller на моём билете",
        ["Notify Unlisted Items"] = "Уведомлять о предметах вне списка",
        ["Notify all items"] = "Уведомлять обо всех предметах",
        ["Notify me about"] = "Уведомлять меня о",
        ["Notify nothing"] = "Ничего не уведомлять",
        ["Notify only essentials"] = "Только важные",
        ["Open / Close Hub"] = "Открыть / закрыть хаб",
        ["Open all Cubby Doors"] = "Открыть все дверцы Cubby",
        ["Orbit Distance"] = "Дистанция орбиты",
        ["Orbit Dropped Items"] = "Орбита выброшенных предметов",
        ["Orbit Height"] = "Высота орбиты",
        ["Orbit Speed"] = "Скорость орбиты",
        ["Overwrite Selected Config"] = "Перезаписать выбранный конфиг",
        ["Path Style"] = "Стиль пути",
        ["Pathfind Timeout"] = "Тайм-аут поиска пути",
        ["Per-category tracers"] = "Трейсеры по категориям",
        ["Performance"] = "Производительность",
        ["Play Again"] = "Играть снова",
        ["Play Sound"] = "Проиграть звук",
        ["Player"] = "Игрок",
        ["Player Information"] = "Информация об игроке",
        ["Player Name Type"] = "Тип имени игрока",
        ["Please collect some gold to earn knobs."] = "Соберите немного золота, чтобы получить ручки.",
        ["Position Spoof"] = "Подмена позиции",
        ["Preset"] = "Пресет",
        ["Print ESP Summary"] = "Вывести сводку ESP",
        ["Prompt Clip"] = "Подсказки сквозь стены",
        ["Prompt Reach Multiplier"] = "Множитель дальности подсказок",
        ["Prompt Tools"] = "Инструменты подсказок",
        ["Prompts"] = "Подсказки",
        ["RON"] = "RON",
        ["RON CD-1"] = "RON CD-1",
        ["Re-detect Game Mode"] = "Определить режим заново",
        ["Refresh Config List"] = "Обновить список конфигов",
        ["Remove"] = "Убрать",
        ["Remove Acceleration"] = "Убрать ускорение",
        ["Remove Basement Gate"] = "Убрать ворота подвала",
        ["Remove Camera Bobbing"] = "Убрать качание камеры",
        ["Remove Camera Shake"] = "Убрать тряску камеры",
        ["Remove Closet Delay"] = "Убрать задержку шкафа",
        ["Remove Fog"] = "Убрать туман",
        ["Remove Footstep Sounds"] = "Убрать звук шагов",
        ["Remove Interacting Sounds"] = "Убрать звуки взаимодействия",
        ["Remove Jammin Music"] = "Убрать музыку Jammin",
        ["Remove Meld (keep ropes & doors)"] = "Убрать Meld (оставить верёвки и двери)",
        ["Remove Meld Walls & Data"] = "Убрать стены и данные Meld",
        ["Remove Paintings Door"] = "Убрать дверь с картинами",
        ["Remove Skeleton Door"] = "Убрать дверь со скелетом",
        ["Reset"] = "Сброс",
        ["Reset Character"] = "Сбросить персонажа",
        ["Restore Prompts"] = "Восстановить подсказки",
        ["Restore default ignored items"] = "Восстановить игнорируемые по умолчанию",
        ["Return to Lobby"] = "Вернуться в лобби",
        ["Revive"] = "Возродиться",
        ["Room Process Time"] = "Время обработки комнаты",
        ["Run"] = "Бег",
        ["Save New Config"] = "Сохранить новый конфиг",
        ["Scan Rooms for Entities"] = "Сканировать комнаты на сущности",
        ["Scrap"] = "Лом",
        ["Scribbles"] = "Scribbles",
        ["Script Information"] = "Информация о скрипте",
        ["Select All"] = "Выбрать всё",
        ["Select All Entities"] = "Выбрать все сущности",
        ["Select All Items"] = "Выбрать все предметы",
        ["Select Recommended"] = "Выбрать рекомендуемые",
        ["Select Saved Config"] = "Выбрать сохранённый конфиг",
        ["Session"] = "Сессия",
        ["Share Code"] = "Код для обмена",
        ["Short Code Sharing (12 Chars)"] = "Обмен коротким кодом (12 символов)",
        ["Show Buttons"] = "Показать кнопки",
        ["Show Distance"] = "Показывать дистанцию",
        ["Show Eyestalk Path"] = "Показать путь Eyestalk",
        ["Show Names"] = "Показывать имена",
        ["Show Path"] = "Показать путь",
        ["Show Seek Path"] = "Показать путь Seek",
        ["Infinite Crucifix"] = "Бесконечное распятие",
        ["Remove Cutscenes"] = "Убрать катсцены",
        ["Disable Entity Jumpscares"] = "Отключить скримеры сущностей",
        ["Disable Firedamp Effect"] = "Отключить эффект Firedamp",
        ["Extras"] = "Дополнительно",
        ["Show Speedrun Timer"] = "Показать таймер спидрана",
        ["Show Splits"] = "Показать сплиты",
        ["Show Tips"] = "Показать советы",
        ["Show Unlisted Entities"] = "Показать сущности вне списка",
        ["Show Unlisted Items"] = "Показать предметы вне списка",
        ["Skip Seek (Hotel)"] = "Пропустить Seek (Отель)",
        ["Skip Seek (Mines)"] = "Пропустить Seek (Шахты)",
        ["Slide"] = "Скольжение",
        ["Slide Speed"] = "Скорость скольжения",
        ["Sounds"] = "Звуки",
        ["Spectate Entity"] = "Наблюдать за сущностью",
        ["Spectate Mode"] = "Режим наблюдения",
        ["Speed"] = "Скорость",
        ["Speed Boost"] = "Ускорение",
        ["Speed Hack"] = "Спидхак",
        ["Speed Hack Value"] = "Значение спидхака",
        ["Speed Method"] = "Метод скорости",
        ["Speedrun Timer"] = "Таймер спидрана",
        ["Spoof Footsteps"] = "Подмена шагов",
        ["Stairwell"] = "Stairwell",
        ["Stairwell Extra ESP"] = "Доп. ESP Stairwell",
        ["Start / Pause / Resume"] = "Старт / Пауза / Продолжить",
        ["Start Knob Farm"] = "Запустить фарм ручек",
        ["Stop (finish run)"] = "Стоп (закончить забег)",
        ["Stop Meld Growth"] = "Остановить рост Meld",
        ["Stop On Death"] = "Стоп при смерти",
        ["Stop Time / Anti Stampede"] = "Остановка времени / Анти Stampede",
        ["Successfully disabled the anticheat."] = "Античит успешно отключён.",
        ["TP All Drops to Nearest Grinder"] = "ТП всех дропов к ближайшему измельчителю",
        ["TP Carts To Me"] = "ТП тележек ко мне",
        ["TP to Depot (Scrapper)"] = "ТП к Depot (Scrapper)",
        ["TP to Emergency Exit"] = "ТП к аварийному выходу",
        ["TP to Fire Alarm"] = "ТП к пожарной тревоге",
        ["TP to Shopping Cart"] = "ТП к тележке",
        ["TP to Trash and Drop It"] = "ТП к мусору и выбросить",
        ["Teleports"] = "Телепорты",
        ["Teller"] = "Teller",
        ["Teller Number ESP"] = "ESP номера Teller",
        ["Test Notification"] = "Проверить уведомление",
        ["Text Font"] = "Шрифт текста",
        ["Text Size"] = "Размер текста",
        ["The anticheat has been re-enabled."] = "Античит снова включён.",
        ["Third Person"] = "Третье лицо",
        ["Third Person X Offset"] = "Смещение X третьего лица",
        ["Third Person Y Offset"] = "Смещение Y третьего лица",
        ["Third Person Z Offset"] = "Смещение Z третьего лица",
        ["Time Shower"] = "Time Shower",
        ["Timer Background (%)"] = "Фон таймера (%)",
        ["Timer Position"] = "Позиция таймера",
        ["Timer Size (%)"] = "Размер таймера (%)",
        ["Timer: Reset"] = "Таймер: сброс",
        ["Timer: Start / Pause"] = "Таймер: старт / пауза",
        ["Timer: Stop"] = "Таймер: стоп",
        ["Tp Next Door"] = "ТП к следующей двери",
        ["Tracer Origin"] = "Начало трейсеров",
        ["Tracer Thickness"] = "Толщина трейсеров",
        ["Tracers"] = "Трейсеры",
        ["Transparent Hiding Spots"] = "Прозрачные укрытия",
        ["Unlock Distance"] = "Дистанция открытия",
        ["User Profile"] = "Профиль пользователя",
        ["Verbose Logging"] = "Подробный журнал",
        ["Viewmodel"] = "Вьюмодель",
        ["Viewmodel Offset"] = "Смещение вьюмодели",
        ["Visuals"] = "Визуалы",
        ["Void"] = "Void",
        ["Void Guard"] = "Защита от Void",
        ["Volume (%)"] = "Громкость (%)",
        ["What it does"] = "Что это делает",
        ["Where to find things"] = "Где что найти",
        ["X Offset"] = "Смещение X",
        ["Y Offset"] = "Смещение Y",
        ["You must be in Room 0 to use this."] = "Для этого нужно быть в комнате 0.",
        ["You must have gold to do this."] = "Для этого нужно золото.",
        ["Z Offset"] = "Смещение Z",
        ["Auto Steer Minecart"] = "Авто управление вагонеткой",
        ["Manage Configs"] = "Управление конфигами",
        ["Rename To"] = "Переименовать в",
        ["Rename Selected Config"] = "Переименовать выбранный конфиг",
        ["Duplicate Selected Config"] = "Дублировать выбранный конфиг",
        ["Delete Selected Config"] = "Удалить выбранный конфиг",
        ["Set Selected As Auto-Load"] = "Автозагрузка выбранного",
        ["Clear Auto-Load"] = "Отключить автозагрузку",
        ["Load Scope"] = "Что загружать",
        ["Share / Import"] = "Поделиться / Импорт",
        ["Share Selected Config"] = "Поделиться выбранным конфигом",
        ["Share Current Settings"] = "Поделиться текущими настройками",
        ["Upload Selected (Online Short Code)"] = "Загрузить выбранный (короткий онлайн-код)",
        ["Upload Current (Online Short Code)"] = "Загрузить текущие (короткий онлайн-код)",
        ["Generated Code"] = "Созданный код",
        ["Import & Apply"] = "Импорт и применение",
        ["Import & Save As New"] = "Импорт и сохранение как новый",
        ["Save Imported As"] = "Сохранить импорт как",
        ["Import From Clipboard (Apply)"] = "Импорт из буфера (применить)",
        ["Language"] = "Язык",
        ["Auto Execute"] = "Автозапуск",
        ["Auto Execute On Teleport"] = "Автозапуск при телепорте",
        ["Loader (URL or file)"] = "Загрузчик (URL или файл)",
        ["Auto Doors Bot"] = "Бот Авто дверей",
        ["Use Bot Speed"] = "Скорость бота",
        ["Bot Speed"] = "Скорость бота (значение)",
        ["Bot Moves The Camera"] = "Бот двигает камеру",
        ["Camera Turn Speed"] = "Скорость поворота камеры",
        ["Bot Can Jump"] = "Бот может прыгать",
        ["Bot Can Crouch"] = "Бот может приседать",
        ["Hide Early (seconds)"] = "Прятаться заранее (секунды)",
        ["Use Ladders"] = "Использовать лестницы",
        ["Knob Farm Mode"] = "Режим фарма ручек",
        ["Teleport Fallback (last resort)"] = "Телепорт как крайняя мера",
        ["Strong Position Spoof"] = "Сильная подмена позиции",
        ["Ladder Safe Mode"] = "Безопасный режим лестниц",
        ["Knob Farm Auto Start"] = "Автозапуск фарма ручек",
        ["Fun"] = "Веселье",
        ["Rainbow ESP"] = "Радужный ESP",
        ["Rainbow Speed"] = "Скорость радуги",
        ["Transform"] = "Превращение",
        ["Transform Into"] = "Превратиться в",
        ["Transform Active"] = "Превращение активно",
        ["Transform Size"] = "Размер превращения",
        ["Transform Height Offset"] = "Высота превращения",
        ["Force Third Person While Transformed"] = "Третье лицо при превращении",
        ["Hide My Character"] = "Скрыть моего персонажа",
        ["Play Model Animations"] = "Анимации модели",
        ["Rescan Models"] = "Пересканировать модели",
        ["Revert Transformation"] = "Отменить превращение",
        ["Smart Performance"] = "Умная производительность",
        ["FPS Guard"] = "Защита по FPS",
        ["Smart Performance Info"] = "Инфо об умной производительности",
        ["Performance"] = "Производительность",
    },
}
do
    local dict = R4N_LANG ~= "en" and R4N_I18N[R4N_LANG]
    if dict then
        local function tr(cfg)
            if type(cfg) == "table" and type(cfg.Title) == "string" then
                local t = dict[cfg.Title]
                if t then cfg.Title = t end
            end
        end
        local METHODS = { "Section", "Button", "Toggle", "Slider", "Dropdown", "Input", "Keybind", "Colorpicker", "ColorPicker", "Paragraph" }
        local origTab = Window.Tab
        Window.Tab = function(self, cfg, ...)
            tr(cfg)
            local tab = origTab(self, cfg, ...)
            if type(tab) == "table" then
                for _, m in ipairs(METHODS) do
                    local f = tab[m]
                    if type(f) == "function" then
                        tab[m] = function(s, c, ...) tr(c) return f(s, c, ...) end
                    end
                end
            end
            return tab
        end
    end
end

-- Tabs (orden fijo)
local MainTab       = Window:Tab({ Title = "Main",       Icon = "house" })
local InfoTab       = Window:Tab({ Title = "Info",       Icon = "info" })
local VisualsTab    = Window:Tab({ Title = "Visuals",    Icon = "eye" })
local PlayerTab     = Window:Tab({ Title = "Player",     Icon = "user" })
local AutomationTab = Window:Tab({ Title = "Automation", Icon = "zap" })
local AntiCheatTab  = Window:Tab({ Title = "Anticheat", Icon = "shield" })
local AntisTab      = Window:Tab({ Title = "Antis",      Icon = "ban" })
ArchivesTab  = Window:Tab({ Title = "Archives",  Icon = "archive" }) -- global a proposito (limite de locales)
StairwellTab = Window:Tab({ Title = "Stairwell", Icon = "layers" })  -- global a proposito (limite de locales)
local AlertsTab     = Window:Tab({ Title = "Alerts",     Icon = "bell" })
local MiscTab       = Window:Tab({ Title = "Misc",       Icon = "ellipsis" })
FunTab = Window:Tab({ Title = "Fun", Icon = "smile" }) -- global a proposito (limite de locales)
local KeybindsTab   = Window:Tab({ Title = "Keybinds",   Icon = "keyboard" })
local ConfigsTab    = Window:Tab({ Title = "Configs",    Icon = "settings" })

-- Tabs sin funciones todavia: un aviso para que no queden en blanco
for _, t in ipairs({}) do
    t:Paragraph({ Title = "Coming soon", Desc = "This tab has no features yet." })
end

print("[RON] WindUI loaded")
print("[RON] Loading Info Tab")
----------------------------------------------------
-- INFO TAB
----------------------------------------------------
InfoTab:Section({ Title = "Player Information" })

-- rbxthumb funciona siempre, sin depender de GetUserThumbnailAsync
local avatarUrl = string.format(
    "rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150",
    LocalPlayer.UserId
)

InfoTab:Paragraph({
    Title = "User Profile",
    Desc = string.format(
        "Username: %s\nDisplay Name: %s\nUser ID: %d\nExecutor: %s\nExecutions: %d",
        LocalPlayer.Name,
        LocalPlayer.DisplayName,
        LocalPlayer.UserId,
        currentExecutor,
        executionCount
    ),
    Image = avatarUrl,
    ImageSize = 48
})

InfoTab:Section({ Title = "Live Session" })
local sessionPara = InfoTab:Paragraph({ Title = "Session", Desc = "Reading game data..." })
task.spawn(function()
    local RunSvc = game:GetService("RunService")
    local frames, last = 0, os.clock()
    RunSvc.RenderStepped:Connect(function() frames = frames + 1 end)
    local started = os.clock()
    while true do
        task.wait(1)
        local now = os.clock()
        local fps = math.floor(frames / math.max(now - last, 0.001) + 0.5)
        frames, last = 0, now
        local floorName, room, ping, playersN = "Lobby", "-", "?", #game:GetService("Players"):GetPlayers()
        pcall(function()
            local gd = game:GetService("ReplicatedStorage"):FindFirstChild("GameData")
            local f = gd and gd:FindFirstChild("Floor")
            if f then floorName = tostring(f.Value) end
        end)
        pcall(function() room = tostring(LocalPlayer:GetAttribute("CurrentRoom") or "-") end)
        pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. " ms" end)
        local mins = math.floor((now - started) / 60)
        local txt = string.format(
            "Floor: %s\nCurrent Room: %s\nPlayers: %d\nFPS: %d\nPing: %s\nTime with the script: %d min",
            floorName, room, playersN, fps, ping, mins
        )
        pcall(function() sessionPara:SetDesc(txt) end)
    end
end)

InfoTab:Section({ Title = "Script Information" })

InfoTab:Paragraph({
    Title = "About RON CD-1",
    Desc = "A specialized DOORS script developed by Team CHX (Created by 2 developers).\nVersion: 1.0.5"
})

InfoTab:Paragraph({
    Title = "Where to find things",
    Desc = "Visuals: ESP, chase paths (Seek / Eyestalk) and lighting.\n"
        .. "Player: movement, speed, jump, fly, noclip.\n"
        .. "Automation: Auto Doors bot, Auto Interact (with ignore list), library code, minecart, Dam Seek, Cringle. Stairwell and Archives tabs.\n"
        .. "Anticheat: position / crouch spoof (strong spoof), ladder safe mode and manipulation.\n"
        .. "Antis: entity bypasses and the Seek / Figure combos.\n"
        .. "Alerts: entity, item, library code and Ransom notifications.\n"
        .. "Misc: revive and utilities.\n"
        .. "Fun: turn into Seek, Honcho or Figure (only you see it).\n"
        .. "Keybinds: every key and floating button can be rebound.\n"
        .. "Configs: save and load your setup."
})

InfoTab:Paragraph({
    Title = "Good to know",
    Desc = "Features marked experimental may fail on some floors: check the console if something does not respond.\n"
        .. "On mobile, the floating buttons can be shown or hidden from the Keybinds tab.\n"
        .. "Changing game mode while playing reconfigures the script and adds the new options at the bottom of Visuals."
})

print("[RON] Info tab loaded")
print("[RON] Loading ESP")
print("[RON] Loading Item ESP (0/4)")
----------------------------------------------------
-- VISUALS / ESP
----------------------------------------------------
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
-- Nombres oficiales de items (fuente: DOORS Wiki - Category:Items / Item Skins)
local ITEM_NAMES = {
    "Alarm Clock", "Aloe", "Bandage", "Bandage Pack", "Battery", "Battery Pack", "Boxing Gloves", "Buddy", "Bulklight",
    "Bread", "Candle", "Candy", "Trick or Treat Bag", "Compass", "Crucifix", "Disc", "Donut", "Fih Flakes", "Flare", "Flashlight", "Glowstick",
    "Gold Gun", "Green Herb", "Gween Soda", "Holy Hand Grenade", "Honcho Mug", "Mug", "Lunch Box", "Waiting Ticket", "Paper Cup", "Fih Food", "Pack of Gween Soda", "Honey Pot", "Iron Key",
    "Knockback Stick", "Lantern", "Laser Pointer", "Leftovers", "Lighter", "Lockpicks", "Lotus",
    "Moonlight Candle", "Moonlight Float", "Multitool", "NVCS-3000", "Paper Plane",
    "Pizza", "Pocket Mirror", "Rift Jar", "Shakelight", "Shears", "Skeleton Key", "Smoothie", "Spotlight",
    "Starlight Bottle", "Starlight Jug", "Starlight Vial", "Straplight", "Tip Jar", "Vitamins",
    -- Items sacados del Explorer (Dex) que antes no se reconocian
    "Big Bomb", "Bomb", "Cheese", "Knockbomb", "Nanner", "Nanner Peel", "Rift Candle", "Rift Smoothie",
    "Snake Box", "Stop Sign", -- "Verity"
    -- Items nuevos (Dex): JerryCan, BrokenMonitor, DinkyLamp, BottleCrate, CoinRoll, PeachCobbler, Briefcase, ObjectScanner, LargeScrew
    "Fuel Can", "Broken Monitor", "Broken Lamp", "Bottle Crate", "Coin Roll", "Peach Cobbler", "Briefcase", "Scanner", "Large Screw",
    "Abraham's Hat", -- el nombre interno (Dex) se pone en PENDING_DEX_NAMES.AbrahamHat (mas abajo)
}

local function Norm(s)
    return (tostring(s):lower():gsub("[^%w]", ""))
end

local ITEM_LOOKUP = {}
for _, name in ipairs(ITEM_NAMES) do
    ITEM_LOOKUP[Norm(name)] = name
end
-- Alias: nombres internos que difieren del nombre de la wiki
ITEM_LOOKUP["bandage"] = "Bandage"
ITEM_LOOKUP["bandages"] = "Bandage"
ITEM_LOOKUP["lockpick"] = "Lockpicks"
ITEM_LOOKUP["vitamin"] = "Vitamins"
ITEM_LOOKUP["holygrenade"] = "Holy Hand Grenade"
ITEM_LOOKUP["bandagepack"] = "Bandage Pack"
ITEM_LOOKUP["glowsticks"] = "Glowstick"
ITEM_LOOKUP["straplights"] = "Straplight"
ITEM_LOOKUP["bulklights"] = "Bulklight"
ITEM_LOOKUP["crucifixwall"] = "Crucifix" -- Crucifix incrustado en la pared (nombre interno real)
ITEM_LOOKUP["treatbag"] = "Trick or Treat Bag"
ITEM_LOOKUP["candybag"] = "Trick or Treat Bag"
ITEM_LOOKUP["trickortreat"] = "Trick or Treat Bag"

-- Items con ESP propio (no entran al filtro de items normales)
ITEM_LOOKUP["glitchfragment"] = "Glitch Fragment"
ITEM_LOOKUP["glitchcube"] = "Glitch Fragment" -- nombre interno real (GlitchCube) -> se muestra como Glitch Fragment, con su propio ESP
ITEM_LOOKUP["lotuspetal"] = "Lotus Petal"
-- El MODULO del Scanner tiene su propio ESP ("Scanner Module"). Su nombre del Dex todavia no se conoce:
-- cuando lo tengas, ponlo en PENDING_DEX_NAMES (justo abajo) y se marcara solo.
-- Ojo: "Scanner" (ObjectScanner) es el item normal y va al ESP Items.
ITEM_LOOKUP["scannermodule"] = "Scanner Module"
ITEM_LOOKUP["modulescanner"] = "Scanner Module"
do
    local PENDING_DEX_NAMES = {
        ScannerModule = "Drive", -- <<< nombre del Dex del modulo del Scanner (ej. "ScannerModuleItem")
        AbrahamHat = "AbrahamHat",    -- <<< nombre del Dex del Abraham's Hat
    }
    if PENDING_DEX_NAMES.ScannerModule ~= "" then ITEM_LOOKUP[Norm(PENDING_DEX_NAMES.ScannerModule)] = "Scanner Module" end
    if PENDING_DEX_NAMES.AbrahamHat ~= "" then ITEM_LOOKUP[Norm(PENDING_DEX_NAMES.AbrahamHat)] = "Abraham's Hat" end
end
local SPECIAL_CATS = { ["Glitch Fragment"] = "glitch", ["Lotus Petal"] = "lotus", ["Scanner Module"] = "scanner", ["Stardust"] = "stardust" }
ITEM_LOOKUP["batterypack"] = "Battery Pack"
ITEM_LOOKUP["jerrycan"] = "Fuel Can"
ITEM_LOOKUP["dinkylamp"] = "Broken Lamp"
ITEM_LOOKUP["objectscanner"] = "Scanner"
ITEM_LOOKUP["gweensodapack"] = "Pack of Gween Soda"
ITEM_LOOKUP["stardustpickup"] = "Stardust" -- por si llega como item: se redirige abajo (ver SPECIAL_CATS)

-- Alias de nombres internos reales (sacados del Explorer / Dex)
local INTERNAL_ALIASES = {
    AlarmClock = "Alarm Clock", AloeVera = "Aloe", BandagePack = "Bandage Pack", BatteryPack = "Battery Pack",
    BigBomb = "Big Bomb", Bomb = "Bomb", BoxingGloves = "Boxing Gloves", Bread = "Bread", Bulklight = "Bulklight",
    Candle = "Candle", Cheese = "Cheese", Compass = "Compass", Crucifix = "Crucifix", Donut = "Donut",
    Flashlight = "Flashlight", Glowsticks = "Glowstick", GoldGun = "Gold Gun", GoldBlaster = "Gold Gun",
    GweenSoda = "Gween Soda", GweenSodaPack = "Pack of Gween Soda", HolyGrenade = "Holy Hand Grenade", KnockbackStick = "Knockback Stick",
    Knockbomb = "Knockbomb", Lantern = "Lantern", LaserPointer = "Laser Pointer", Lighter = "Lighter",
    Lockpick = "Lockpicks", Multitool = "Multitool", Nanner = "Nanner", NannerPeel = "Nanner Peel",
    Pizza = "Pizza", PocketMirror = "Pocket Mirror", RiftCandle = "Rift Candle", RiftJar = "Rift Jar",
    RiftSmoothie = "Rift Smoothie", Shakelight = "Shakelight", Shears = "Shears", SkeletonKey = "Skeleton Key",
    Smoothie = "Smoothie", SnakeBox = "Snake Box", StarBottle = "Starlight Bottle", StarJug = "Starlight Jug",
    StarVial = "Starlight Vial", StopSign = "Stop Sign", Straplight = "Straplight", TipJar = "Tip Jar",
    Vitamins = "Vitamins",
    -- Items nuevos: nombre interno (Dex) -> nombre que se muestra
    JerryCan = "Fuel Can", BrokenMonitor = "Broken Monitor", DinkyLamp = "Broken Lamp", BottleCrate = "Bottle Crate",
    CoinRoll = "Coin Roll", PeachCobbler = "Peach Cobbler", Briefcase = "Briefcase", ObjectScanner = "Scanner",
    LargeScrew = "Large Screw",
}
for k, v in pairs(INTERNAL_ALIASES) do ITEM_LOOKUP[Norm(k)] = v end

-- Resuelve el nombre canonico de un item a partir de varios textos candidatos
-- (nombre del modelo, ObjectText del prompt, etc). Evita nombres raros/parciales.
local function ResolveItem(candidates)
    for _, cand in ipairs(candidates) do
        if type(cand) == "string" and cand ~= "" then
            local n = Norm(cand)
            if ITEM_LOOKUP[n] then return ITEM_LOOKUP[n] end
        end
    end
    for _, cand in ipairs(candidates) do
        if type(cand) == "string" and #cand >= 4 then
            local n = Norm(cand)
            local best, bestLen
            for k, name in pairs(ITEM_LOOKUP) do
                if #k >= 6 and n:find(k, 1, true) then
                    if not bestLen or #k > bestLen then best, bestLen = name, #k end
                end
            end
            if best then return best end
        end
    end
end

-- Nombres internos (instancias en Workspace.CurrentRooms)
local KEY_NAMES = {
    KeyObtain = "Key",
    ElectricalKeyObtain = "Electrical Room Key",
    FuseObtain = "Fuse",
}
local OBJECTIVE_NAMES = {
    LeverForGate = "Lever",
    -- TimerLever vive directo en CurrentRooms > [sala] > TimerLever (NO dentro de Assets).
    -- El escaneo recorre todo Workspace, asi que se detecta por nombre sin importar la ruta.
    TimerLever = "Timer Lever",
    LiveHintBook = "Library Book",
    LiveBreakerPolePickup = "Breaker Pole",
    -- Stairwell: Workspace.CurrentRooms.[sala].Assets.Switches.StairwellFireAlarm (hay varias carpetas Switches;
    -- se detecta por nombre en todas, sin importar en cual este)
    StairwellFireAlarm = "Fire Alarm Lever",
    ["Sally's Toy"] = "Sally's Toy",
    SallysToy = "Sally's Toy",
    SallyToy = "Sally's Toy",
    -- Dam Seek: Workspace.CurrentRooms.100._DamHandler.Flood#.Pumps.WaterPump (# = 1, 2 o 3)
    WaterPump = "Water Pump",
}
local STARDUST_NAMES = { Stardust = "Stardust", StardustPickup = "Stardust" }

print("[RON] Item ESP loaded (1/4)")
print("[RON] Loading Entity ESP (1/4)")
-- Entidades: { nombre, modos donde aparece ("*" = todos), tokens de nombre interno (normalizados) }
-- Fuentes: DOORS Wiki (Entities, The Great Outdoors Update, The Archives Update, The Stairwell)
local ENTITY_DEFS = {
    -- All Floors
    { "Rush", "*", { "rushmoving", "rush" } },
    { "Ambush", "*", { "ambushmoving", "ambush" } },
    { "Eyes", "*", { "eyes" } },
    { "Halt", "*", { "halt" } },
    { "Jeff", "*", { "jeffthekiller", "jeff" } },
    { "Jeff the Killer", "*", { "jeffthekiller" } },
    { "Snare", "*", { "snare" } },
    { "Glitch", "*", {} },
    { "Glitched Rush", "*", {} },
    { "Glitched Ambush", "*", {} },
    -- Main Floors
    { "Seek", "Hotel Mines", { "seekmoving", "seekrig", "seek" } },
    { "Figure", "Hotel Mines", { "figureragdoll", "figurerig", "figure" } },
    { "Timothy", "Hotel Mines", { "timothy" } },
    { "Void", "Hotel Mines", { "void" } },
    { "Bob", "Hotel Mines", { "bob" } },
    { "El Goblino", "Hotel Mines", { "elgoblino", "goblino" } },
    { "Dread", "Hotel Mines", { "dread" } },
    -- The Mines
    { "Grumble", "Mines", { "grumble" } },
    { "Queen Grumble", "Mines", { "queengrumble" } },
    { "Giggle", "Hotel Mines", { "giggle" } },
    { "Gloombat", "Hotel Mines", { "gloombat" } },
    { "Firedamp", "Hotel Mines", { "firedamp" } },
    -- The Backdoor
    { "Blitz", "Hotel Mines Backdoor", { "backdoorrush", "blitz" } },
    { "Lookman", "Hotel Mines Backdoor", { "backdoorlookman", "lookman" } },
    { "Haste", "Hotel Backdoor", { "haste" } },
    -- The Outdoors
    { "Groundskeeper", "Outdoors", { "groundskeeper", "thegroundskeeper" } },
    { "Caw", "Outdoors", { "caw" } },
    { "Monument", "Outdoors", { "monument" } },
    { "Surge", "Outdoors", { "surge" } },
    { "Mandrake", "Outdoors", { "mandrake" } },
    { "Eyestalk", "Outdoors", { "eyestalk" } },
    { "Bramble", "Outdoors", { "bramble" } },
    { "Grampy", "Outdoors", { "grampy" } },
    { "World Lotus", "Outdoors", { "worldlotus", "theworldlotus" } },
    -- The Archives (A-60 / A-90 / A-120; Bash y Scribbles son sus nombres internos nuevos)
    { "Honcho", "Archives", { "honcho" } },
    { "Drone", "Archives", { "drone" } },
    { "Forget-Me-Nots", "Archives", { "forgetmenot", "forgetmenots" } },
    { "Teller", "Archives", { "teller" } },
    { "Alma", "Archives", { "alma" } },
    { "Portrait", "Archives", { "portrait" } },
    { "A-60", "Archives", { "a60", "bash", "bashmoving", "bashrig", "bashmodel", "bashentity" } },
    { "A-120", "Archives", { "a120", "scribbles" } },
    { "Discoloration", "Archives", { "discoloration" } },
    { "Currents", "Archives", { "currents" } },
    -- The Stairwell
    { "Creak", "Stairwell", { "creak" } },
    { "Noise", "*", { "noisemodel", "noise" } },
    { "Noise TV", "*", { "tvstand" } },
    { "Stem", "Stairwell", { "stem", "stemmoving", "stemrig", "stemmodel", "stementity", "stemsentity", "stems" } },
    { "Meld", "Stairwell", { "meld" } },
    { "Cobbler", "Stairwell", { "cobbler" } },
    { "Hijack", "Stairwell", { "hijack" } },
    { "Crusher", "Stairwell", { "crusher" } },
}

local ENTITY_LIST, ENTITY_MODES, ENTITY_TOKENS = {}, {}, {}
for _, d in ipairs(ENTITY_DEFS) do
    ENTITY_LIST[#ENTITY_LIST + 1] = d[1]
    local set = {}
    for m in d[2]:gmatch("%S+") do set[m] = true end
    ENTITY_MODES[d[1]] = set
    for _, tok in ipairs(d[3]) do ENTITY_TOKENS[#ENTITY_TOKENS + 1] = { tok, d[1] } end
end
table.sort(ENTITY_TOKENS, function(a, b) return #a[1] > #b[1] end) -- mas largo primero (eyestalk antes que eyes)

-- Tokens demasiado genericos para buscarlos dentro de los cuartos (decoracion)
local STRICT_SKIP = {
    portrait = true, monument = true, currents = true, bob = true, jack = true,
    void = true, dupe = true, jeff = true, timothy = true, eyes = true,
}

-- Entidades del Glitch Fragment (client-side). Nombres oficiales de la wiki.
local GLITCH_TOKENS = {
    { "RNIUSHCg",  "Glitched Rush" },
    { "AR0xMBUSH", "Glitched Ambush" },
}

-- Nombres internos confirmados en scripts publicos de DOORS
local ENTITY_EXACT = {
    RushMoving = "Rush", AmbushMoving = "Ambush", BackdoorRush = "Blitz", BackdoorLookman = "Lookman",
    Lookman = "Lookman", Eyes = "Eyes", Halt = "Halt",
    JeffTheKiller = "Jeff", A60 = "A-60", A120 = "A-120", Bash = "A-60", Scribbles = "A-120", Snare = "Snare",
}

-- Entidades sin ESP (inutil marcarlas): Ransom (A-90), Jack, Shadow, Screech (y Glitched Screech).
-- Nunca se registran, ni siquiera con "Show Unlisted Entities".
local EXCLUDED_EXACT = { jack = true, ransom = true, a90 = true, shadow = true, screech = true }
local function IsExcludedEntity(name)
    local n = Norm(name)
    if EXCLUDED_EXACT[n] then return true end
    if n:find("screech", 1, true) or n:find("ransom", 1, true) then return true end
    if n:find("shadow", 1, true) then return true end
    return name:find("SCJVEREECH", 1, true) ~= nil -- Glitched Screech (nombre interno)
end

STRICT_SKIP.__stem = { -- variantes de nombre de Stem (no es un local nuevo: el script esta cerca del limite de locales)
    stem = true, stems = true, stemsentity = true, stemmoving = true, stemrig = true, stemmodel = true, stementity = true, stemragdoll = true,
    stemmonster = true, stemchase = true, stemmover = true, stemclient = true, stemfake = true, stemreal = true,
}
-- strict = true: solo coincidencia exacta (para modelos dentro de los cuartos)
-- allowSkip = true: permite tokens de STRICT_SKIP (Timothy, Bob, Jeff, Void...). Solo se usa
-- para modelos con Humanoid/AnimationController, asi la decoracion no se marca.
-- strict = false: prefijo para nombres largos, exacto para nombres de 4 letras o menos
local function EntityLabel(name, strict, allowSkip)
    if IsExcludedEntity(name) then return nil end
    if ENTITY_EXACT[name] then return ENTITY_EXACT[name] end
    for _, g in ipairs(GLITCH_TOKENS) do
        if name:find(g[1], 1, true) then return g[2] end
    end
    local n = Norm(name)
    -- "GlitchFragment" es un item, no una entidad
    if not strict and n:sub(1, 6) == "glitch" and not n:find("fragment", 1, true) then
        if n:find("ambush", 1, true) then return "Glitched Ambush" end
        if n:find("rush", 1, true) then return "Glitched Rush" end
        return nil -- el "Glitch" generico (efectos del Glitch Fragment) aparecia sin parar: ya no se marca
    end
    -- Stem: el nombre exacto no basta (fuera de tu mano usa variantes: StemRig, StemMoving, StemModel...)
    if STRICT_SKIP.__stem[n] and (allowSkip or not strict) then return "Stem" end
    local nb = n -- nombre sin sufijo (BashMoving -> bash)
    for _, suf in ipairs({ "moving", "model", "entity", "rig" }) do
        if #nb > #suf and nb:sub(-#suf) == suf then nb = nb:sub(1, #nb - #suf) break end
    end
    for _, t in ipairs(ENTITY_TOKENS) do
        local tok = t[1]
        if strict then
            if n == tok and (allowSkip or not STRICT_SKIP[tok]) then return t[2] end
        elseif #tok <= 4 then
            if n == tok or nb == tok then return t[2] end
        elseif n:sub(1, #tok) == tok then
            return t[2]
        end
    end
end

print("[RON] Loaded Entity ESP (2/4)")
print("[RON] Loading Entity Name Cache (2/4)")
-- PERF: cache de funciones de nombres. En Outdoors se crean miles de modelos con nombres repetidos
-- (arboles, rocas...) y antes cada uno recorria ~100 tokens con gsub. Ahora cada nombre se calcula UNA vez.
do
    local rawNorm, rawExcl, rawLabel = Norm, IsExcludedEntity, EntityLabel
    local normC, normN = {}, 0
    Norm = function(x)
        if type(x) ~= "string" then return rawNorm(x) end
        local v = normC[x]
        if v == nil then
            if normN > 8000 then normC, normN = {}, 0 end
            v = rawNorm(x)
            normC[x] = v
            normN = normN + 1
        end
        return v
    end
    local exC, exN = {}, 0
    IsExcludedEntity = function(name)
        local v = exC[name]
        if v == nil then
            if exN > 8000 then exC, exN = {}, 0 end
            v = rawExcl(name) and true or false
            exC[name] = v
            exN = exN + 1
        end
        return v
    end
    local lbC, lbN = { {}, {}, {}, {} }, 0
    EntityLabel = function(name, strict, allowSkip)
        local c = lbC[(strict and 1 or 0) + (allowSkip and 2 or 0) + 1]
        local v = c[name]
        if v == nil then
            if lbN > 8000 then lbC, lbN = { {}, {}, {}, {} }, 0; c = lbC[(strict and 1 or 0) + (allowSkip and 2 or 0) + 1] end
            v = rawLabel(name, strict, allowSkip) or false
            c[name] = v
            lbN = lbN + 1
        end
        return v or nil
    end
end

print("[RON] Loaded Entity Name Cache (3/4)")
print("[RON] Loading ESP Config (3/4)")
local GOLD_NAMES = { GoldPile = "Gold" }
local HIDE_NAMES = { Wardrobe = "Closet", Bed = "Bed", Toolshed = "Tool Shed", Locker = "Locker" }

local MAX_HIGHLIGHTS = 26 -- 1.0.5: Roblox solo dibuja ~31 Highlights a la vez; lo que pase del limite se oculta (ya no se dibujan cajas)

local Cfg = {
    MaxDistance = 400,
    MaxObjects = 70, -- tope de objetos dibujados a la vez (los mas cercanos); evita lag en mapas grandes
    TextSize = 22,
    Font = "Oswald",
    PlayerNames = "Display Name",
    ShowName = true,
    ShowDistance = true,
    Unit = "Meters",
    FillTransparency = 0.75,
    OutlineTransparency = 0,
    TracerOrigin = "Bottom",
    TracerThickness = 1.5,
    UnlistedItems = true,
    ItemFilter = {},
    UnlistedEntities = false, -- desconocidos apagado: evita marcar cosas que no son entidades
    EntityFilter = {},
    Debug = false,
    DebugVerbose = false,
    Overlay = false,
    HideLooted = true,
    AutoPreset = false,
    RoomEntities = true,
    Categories = {
        doors      = { Enabled = false, Color = Color3.fromHex("#00eaff") },
        gold       = { Enabled = false, Color = Color3.fromHex("#ffe400") },
        keys       = { Enabled = false, Color = Color3.fromHex("#12ff00") },
        wardrobes  = { Enabled = false, Color = Color3.fromHex("#007000") },
        chests     = { Enabled = false, Color = Color3.fromHex("#ffe400") },
        items      = { Enabled = false, Color = Color3.fromHex("#fc00ff") },
        objectives = { Enabled = false, Color = Color3.fromHex("#12ff00") },
        stardust   = { Enabled = false, Color = Color3.fromHex("#ff7800") },
        entities   = { Enabled = false, Color = Color3.fromHex("#ff0000") },
        dupe       = { Enabled = false, Color = Color3.fromHex("#ff0000") },
        drawers    = { Enabled = false, Color = Color3.fromHex("#d9a066") },
        lockers    = { Enabled = false, Color = Color3.fromHex("#8fa8ff") },
        interactables = { Enabled = false, Color = Color3.fromHex("#7fffd4") },
        glitch     = { Enabled = false, Color = Color3.fromHex("#8100a6") },
        lotus      = { Enabled = false, Color = Color3.fromHex("#ff6ff7") },
        scanner    = { Enabled = false, Color = Color3.fromHex("#a145ff") },
        stairs     = { Enabled = false, Color = Color3.fromHex("#ff5fa2") },
        exit       = { Enabled = false, Color = Color3.fromHex("#93ff85") },
        cart       = { Enabled = false, Color = Color3.fromHex("#6d77ff") },
        players    = { Enabled = false, Color = Color3.fromHex("#3b82f6") },
    }
}

print("[RON] Loaded ESP Config (4/4)")
print("[RON] Fully Loaded ESP")
print("[RON] Loading Tracers")
-- Tracer por categoria (apagado por defecto)
for _, c in pairs(Cfg.Categories) do c.Tracer = false end

print("[RON] Loaded Tracers")
print("[RON] Loading ESP Fonts")
-- Fuentes disponibles para el texto del ESP
local FONT_LIST = { "Oswald", "Roboto Sans", "Nunito", "Gotham Bold", "Ubuntu", "Source Sans", "Code" }
local FONT_MAP = {
    ["Oswald"] = Enum.Font.Oswald,
    ["Roboto Sans"] = Enum.Font.Roboto,
    ["Nunito"] = Enum.Font.Nunito,
    ["Gotham Bold"] = Enum.Font.GothamBold,
    ["Ubuntu"] = Enum.Font.Ubuntu,
    ["Source Sans"] = Enum.Font.SourceSansBold,
    ["Code"] = Enum.Font.Code,
}

for _, name in ipairs(ITEM_NAMES) do
    Cfg.ItemFilter[name] = true
end
for _, name in ipairs(ENTITY_LIST) do
    Cfg.EntityFilter[name] = true
end

print("[RON] Loaded ESP Fonts")
print("[RON] Loading Debug Logger")
-- Debug logger: imprime/guarda nombres reales que el script no reconoce
local DebugLog, DebugSeen = {}, {}
local function Dbg(kind, inst, extra)
    if not Cfg.Debug then return end
    local key = kind .. ":" .. inst.Name
    if DebugSeen[key] then return end
    DebugSeen[key] = true
    local okName, full = pcall(function() return inst:GetFullName() end)
    local line = string.format("[%s] %s | %s%s", kind, inst.Name, okName and full or "?", extra and (" | " .. extra) or "")
    DebugLog[#DebugLog + 1] = line
    print("[RON DEBUG] " .. line)
end

print("[RON] Loaded Debug Logger")
print("[RON] Loading Render Containers")
----------------------------------------------------
-- Contenedores de render
----------------------------------------------------
local Gui = Instance.new("ScreenGui")
Gui.Name = "RON_ESP_Lines"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999

local Holder = Instance.new("Folder")
Holder.Name = "RON_ESP"

local okParent = pcall(function()
    local parent = (gethui and gethui()) or game:GetService("CoreGui")
    Gui.Parent = parent
    Holder.Parent = parent
end)
if not okParent then
    Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    Holder.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local Tracked = {}

print("[RON] Loaded Render Containers")
print("[RON] Loading Gamemodes")
----------------------------------------------------
-- MODO DE JUEGO
-- Se detecta UNA vez al cargar y solo se activan los ESP/funciones de ese modo.
-- Si el modo cambia mas tarde, se vuelve a configurar solo.
----------------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Setters = {}
local Mode = { Name = "Unknown", Raw = "" }
local ModeParagraph -- se crea en la pestana Main

-- Categorias de ESP que existen en cada modo
local MODE_CATS = {
    Hotel     = { "doors", "dupe", "gold", "keys", "wardrobes", "chests", "objectives", "stardust", "entities", "items", "drawers", "glitch" },
    Mines     = { "doors", "gold", "keys", "wardrobes", "chests", "objectives", "stardust", "entities", "items", "drawers", "lockers", "glitch" },
    Backdoor  = { "doors", "objectives", "stardust", "entities", "items", "drawers", "glitch" },
    Outdoors  = { "doors", "gold", "keys", "stardust", "entities", "items", "glitch", "lotus", "stardust", "interactables" },
    Archives  = { "doors", "stardust", "entities", "items", "drawers", "interactables", "glitch" },
    Stairwell = { "doors", "stardust", "entities", "items", "interactables", "glitch", "objectives", "exit", "cart" },
    Rooms     = { "doors", "stardust", "entities", "items", "wardrobes", "lockers", "glitch" },
    -- Lobby: no hay partida, solo jugadores
    Lobby     = {},
    -- Modo no detectado: solo lo basico y seguro (sin Dupe ni extras)
    Unknown   = { "doors", "gold", "keys", "wardrobes", "chests", "objectives", "entities", "items", "drawers", "lockers" },
}
MODE_CATS.Fools = MODE_CATS.Hotel
do
    local seen = {}
    for _, list in pairs(MODE_CATS) do
        if not seen[list] then
            seen[list] = true
            list[#list + 1] = "players"
            if list ~= MODE_CATS.Lobby then list[#list + 1] = "scanner" end
        end
    end
    -- ESP Stairs & Ladders: solo existe en The Mines
    MODE_CATS.Mines[#MODE_CATS.Mines + 1] = "stairs"
end
-- Test Mode: TODAS las categorias de ESP y TODAS las entidades a la vez (para probar facil)
do
    local all = {}
    for id in pairs(Cfg.Categories) do all[#all + 1] = id end
    table.sort(all)
    MODE_CATS.Test = all
end
Mode.All = function() return Mode.Name == "Unknown" or Mode.Name == "Test" end

-- Fools comparte entidades con Hotel; Rooms comparte A-60/A-120 con Archives
for _, n in ipairs({ "A-60", "A-120" }) do
    if ENTITY_MODES[n] then ENTITY_MODES[n]["Rooms"] = true end
end
local function EntityModeKey()
    return Mode.Name == "Fools" and "Hotel" or Mode.Name
end
local function CurrentEntityList()
    local out, key = {}, EntityModeKey()
    for _, d in ipairs(ENTITY_DEFS) do
        local set = ENTITY_MODES[d[1]]
        if Mode.All() or set["*"] or set[key] then out[#out + 1] = d[1] end
    end
    return out
end

local MODE_EXACT = {
    hotel = "Hotel", fools = "Fools", mines = "Mines", backdoor = "Backdoor", outdoors = "Outdoors",
    garden = "Outdoors", archives = "Archives", stairwell = "Stairwell", rooms = "Rooms",
}
local MODE_RULES = {
    { "backdoor", "Backdoor" }, { "stair", "Stairwell" }, { "archive", "Archives" },
    { "outdoor", "Outdoors" }, { "garden", "Outdoors" }, { "mine", "Mines" },
    { "hotel", "Hotel" }, { "fool", "Fools" },
}

local Active = {} -- categorias activas para el modo actual
local Rescan, OnModeApplied, PurgeInactive, ApplyPreset

local function SetActive(modeName)
    local new = {}
    for _, id in ipairs(MODE_CATS[modeName] or MODE_CATS.Unknown) do new[id] = true end
    Active = new
end

-- Force Gamemode: "Auto" = detectar solo; cualquier otro valor fuerza ese modo
local Force = { Name = "Auto" }

-- Lobby de DOORS: es un place aparte del juego y ahi GameData.Floor vale "Hotel" por defecto,
-- por eso antes se detectaba como Hotel. Main_Game destruye MainUI.LobbyFrame al entrar a una
-- partida, asi que si LobbyFrame sigue ahi (fuera del place del juego) tambien es el lobby.
local LOBBY_PLACE_ID = 6516141723
local GAME_PLACE_ID = 6839171747
local function IsLobby()
    if game.PlaceId == LOBBY_PLACE_ID then return true end
    if game.PlaceId ~= GAME_PLACE_ID then
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        local mu = pg and pg:FindFirstChild("MainUI")
        if mu and mu:FindFirstChild("LobbyFrame") then return true end
    end
    return false
end

local function ReadModeRaw()
    local raw, strings = {}, {}
    local gd = ReplicatedStorage:FindFirstChild("GameData")
    if gd then
        for _, c in ipairs(gd:GetChildren()) do
            if c:IsA("ValueBase") then
                local ok, v = pcall(function() return c.Value end)
                if ok and v ~= nil and typeof(v) ~= "Instance" then
                    raw[#raw + 1] = c.Name .. "=" .. tostring(v)
                    if type(v) == "string" then strings[#strings + 1] = v:lower() end
                end
            end
        end
        for k, v in pairs(gd:GetAttributes()) do
            raw[#raw + 1] = k .. "=" .. tostring(v)
            if type(v) == "string" then strings[#strings + 1] = v:lower() end
        end
    end
    Mode.Raw = table.concat(raw, "; ")

    -- 1) valor exacto (Floor = "Hotel", "Mines"...)
    for _, s in ipairs(strings) do
        if MODE_EXACT[s] then return MODE_EXACT[s] end
    end
    -- 2) coincidencia parcial
    local text = table.concat(strings, " ")
    for _, r in ipairs(MODE_RULES) do
        if text:find(r[1], 1, true) then return r[2] end
    end
    -- 3) respaldo: cuartos con nombre tipo "C-048" = Archives
    local rooms = Workspace:FindFirstChild("CurrentRooms")
    if rooms then
        for _, r in ipairs(rooms:GetChildren()) do
            if r.Name:match("^%a%-%d+$") then return "Archives" end
        end
    end
    return "Unknown"
end

local function ReadMode()
    local okR, name = pcall(ReadModeRaw) -- tambien actualiza Mode.Raw
    if Force.Name ~= "Auto" then return Force.Name end
    local okL, lobby = pcall(IsLobby)
    if okL and lobby then return "Lobby" end
    return okR and name or "Unknown"
end

local function WaitForMode(timeout)
    local t0 = os.clock()
    while true do
        local ok, name = pcall(ReadMode)
        if ok and name ~= "Unknown" then return name end
        if os.clock() - t0 >= timeout then return "Unknown" end
        task.wait(0.5)
    end
end

local function ApplyMode(name)
    Mode.Name = name
    SetActive(name)
    print("[RON] Game mode: " .. name .. " (" .. Mode.Raw .. ")")
    if PurgeInactive then PurgeInactive() end
    if OnModeApplied then pcall(OnModeApplied) end
    if Cfg.AutoPreset and ApplyPreset then pcall(ApplyPreset, name) end
    if Rescan then Rescan() end
    local forced = Force.Name ~= "Auto"
    pcall(function()
        WindUI:Notify({ Title = "Game Mode", Content = (forced and "Forced: " or "Detected: ") .. name .. ". Only its ESP options are loaded.", Duration = 4 })
    end)
    if ModeParagraph then
        pcall(function() ModeParagraph:SetTitle((forced and "Forced: " or "Detected: ") .. name) end)
    end
end

local function WatchMode()
    local name = ReadMode()
    if name ~= Mode.Name and (name ~= "Unknown" or Force.Name == "Unknown") then ApplyMode(name) end
end

-- Espera al modo ANTES de escanear nada
Mode.Name = WaitForMode(12)
SetActive(Mode.Name)
print("[RON] Game mode: " .. Mode.Name .. " (" .. Mode.Raw .. ")")

local Overlay = Instance.new("TextLabel")
Overlay.Name = "RON_Overlay"
Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
Overlay.BackgroundTransparency = 0.45
Overlay.BorderSizePixel = 0
Overlay.TextColor3 = Color3.fromRGB(230, 230, 230)
Overlay.Font = Enum.Font.Code
Overlay.TextSize = 13
Overlay.TextXAlignment = Enum.TextXAlignment.Left
Overlay.TextYAlignment = Enum.TextYAlignment.Top
Overlay.TextWrapped = true
Overlay.Size = UDim2.fromOffset(300, 10)
Overlay.AutomaticSize = Enum.AutomaticSize.Y
Overlay.Position = UDim2.fromOffset(8, 70)
Overlay.Visible = false

Overlay.Parent = Gui

local function UpdateOverlay()
    Overlay.Visible = Cfg.Overlay
    if not Cfg.Overlay then return end
    local counts, total, shown = {}, 0, 0
    for _, e in pairs(Tracked) do
        counts[e.Cat] = (counts[e.Cat] or 0) + 1
        total = total + 1
        if e.Shown then shown = shown + 1 end
    end
    local list = {}
    for k, n in pairs(counts) do list[#list + 1] = k .. "=" .. n end
    table.sort(list)
    Overlay.Text = string.format(
        "RON DEBUG\nMode: %s\nRoom: %s\nTracked: %d (shown %d)\n%s\nGameData: %s",
        Mode.Name, tostring(LocalPlayer:GetAttribute("CurrentRoom")), total, shown,
        #list > 0 and table.concat(list, ", ") or "-", Mode.Raw ~= "" and Mode.Raw or "-"
    )
end
local function GetPart(inst)
    if inst:IsA("BasePart") then return inst end
    if inst:IsA("Model") then
        return inst.PrimaryPart or inst:FindFirstChildWhichIsA("BasePart", true)
    end
end

print("[RON] Loaded Gamemodes")
print("[RON] Loading Visual Instances")
-- PERF: las instancias visuales (Highlight, caja, billboard, linea) se crean SOLO cuando un objeto
-- se va a dibujar y se liberan cuando lleva unos segundos oculto. Antes se creaban 5 instancias por
-- cada objeto detectado aunque el ESP estuviera apagado.
Mode.Free = function(e)
    local hl, box, bb, line = e.HL, e.Box, e.BB, e.Line
    e.HL, e.Box, e.BB, e.TL, e.Line = nil, nil, nil, nil, nil
    e.Col, e.Fill, e.Out, e.Text, e.TS, e.TF, e.BoxT, e.HidSince = nil, nil, nil, nil, nil, nil, nil, nil
    if hl then pcall(hl.Destroy, hl) end
    if box then pcall(box.Destroy, box) end
    if bb then pcall(bb.Destroy, bb) end
    if line then pcall(line.Destroy, line) end
end

Mode.Build = function(e)
    if e.HL then return end
    local hl = Instance.new("Highlight")
    hl.Name = "R4N_ESP"
    hl.Adornee = e.Inst                                   -- 1.0.5: forma real del objeto (como el ESP del Main)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency = Cfg.FillTransparency or 0.75
    hl.OutlineTransparency = Cfg.OutlineTransparency or 0
    hl.Enabled = false
    hl.Parent = Holder

    -- Respaldo cuando Highlight no se ve (partes invisibles) o se pasa del limite
    local box = I