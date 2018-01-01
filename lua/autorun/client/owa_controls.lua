include('utils.lua')
include('client/constants.lua')

local function createBlankControlsTable()
    OWAControls = {
        ability1 = nil,
        ability2 = nil,
        ultimate = nil,
        showHeroSelectScreen = nil
    }
end

local function loadControlsFromFile()
    OWAControls = util.JSONToTable(file.Read(OWA_CONTROLS_FILE))
end

local function handleControlKeyPress(control, callback)
    local keyCode = OWAControls[control]
    if keyCode == nil or not input.IsKeyDown(keyCode) then return end
    callback()
end

if not file.Exists(OWA_CONTROLS_FILE, 'DATA') then
    createBlankControlsTable()
else
    loadControlsFromFile()
end

hook.Add('Think', 'OWA Ability key pressed', function()
    if LocalPlayer():IsTyping() then return end

    handleControlKeyPress('ability1', function()
        debugLog('abilityCastRequest 1')
        net.Start('abilityCastRequest')
            net.WriteUInt(1, 3)
        net.SendToServer()
    end)

    handleControlKeyPress('ability2', function()
        debugLog('abilityCastRequest 2')
        net.Start('abilityCastRequest')
            net.WriteUInt(2, 3)
        net.SendToServer()
    end)

    handleControlKeyPress('ultimate', function()
        debugLog('ultimateRequest')
        signal('ultimateCastRequest')
    end)

    -- TODO: Choose working one

    -- 1
    handleControlKeyPress('showHeroSelectScreen', function()
        debugLog('showHeroSelectScreen')
        OWA_toggleHeroSelectScreen()
    end)

    -- 2
    -- if OWAControls. ~= nil then
    --     if input.WasKeyReleased(OWAControls.showHeroSelectScreen) then
    --         debugLog('showHeroSelectScreen')
    --         addOWAHeroSettingsPage()
    --     end
    -- end
end)

-- 3
-- hook.Add('Move', 'OWAAbilityKeyPressed_move', function()
--     if LocalPlayer():IsTyping() then return end
--
--     if OWAControls.showHeroSelectScreen ~= nil then
--         if input.WasKeyTyped(OWAControls.showHeroSelectScreen) then
--             debugLog('showHeroSelectScreen')
--             addOWAHeroSettingsPage()
--         end
--     end
-- end)
