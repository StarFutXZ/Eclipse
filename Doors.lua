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
        ["Entity Distance Limit"] = "Ли
... (662 KB restante(s))