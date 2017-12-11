include("customlib.lua")

local CONTROLS_FILE = "OWAControls.txt"

if not file.Exists(CONTROLS_FILE, "DATA") then
    OWAControls = {
        ability1 = nil,
        ability2 = nil,
        ultimate = nil,
        showHeroSelectScreen = nil
    }
else
    OWAControls = util.JSONToTable(file.Read(CONTROLS_FILE))
end

function OWAUpdateKeyBinding(control, num)
    OWAControls = {}
    
    if FileIsEmpty(CONTROLS_FILE) then
        local fileContents = file.Read(CONTROLS_FILE)
        OWAControls = util.JSONToTable(fileContents)
    end
    
    OWAControls[control] = num
    file.Write(CONTROLS_FILE, util.TableToJSON(OWAControls))
end

hook.Add("Think", "OWAAbilityKeyPressed", function()
    if LocalPlayer():IsTyping() then return end
    
    if OWAControls.ability1 ~= nil then
        if input.IsKeyDown(OWAControls.ability1) then
            DebugLog("abilityCastRequest 1")
            net.Start("abilityCastRequest")
                net.WriteUInt(1, 3)
            net.SendToServer()
        end
    end
    
    if OWAControls.ability2 ~= nil then
        if input.IsKeyDown(OWAControls.ability2) then
            DebugLog("abilityCastRequest 2")
            net.Start("abilityCastRequest")
                net.WriteUInt(2, 3)
            net.SendToServer()
        end
    end
    
    if OWAControls.ultimate ~= nil then
        if input.IsKeyDown(OWAControls.ultimate) then
            DebugLog("ultimateRequest")
            Signal("ultimateCastRequest")
        end
    end
    
    if OWAControls.showHeroSelectScreen ~= nil then
        if input.WasKeyReleased(OWAControls.showHeroSelectScreen) then
            DebugLog("showHeroSelectScreen")
            AddOWAHeroSettingsPage()
        end
    end
end)

hook.Add("Move", "OWAAbilityKeyPressed_move", function()
    if LocalPlayer():IsTyping() then return end
    
    if OWAControls.showHeroSelectScreen ~= nil then
        if input.WasKeyTyped(OWAControls.showHeroSelectScreen) then
            DebugLog("showHeroSelectScreen")
            AddOWAHeroSettingsPage()
        end
    end
end)