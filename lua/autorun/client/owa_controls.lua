include 'claf.lua'
include 'owa_utils.lua'
include 'owa_constants.lua'

local function createBlankControlsTable()
    OWA_controls = {
        ability1 = nil,
        ability2 = nil,
        ultimate = nil,
        showHeroSelectScreen = nil
    }
end

local function loadControlsFromFile()
    OWA_controls = util.JSONToTable(file.Read(OWA_CONTROLS_FILE))
end

local function handleControlKeyPress(control, callback)
    local keyCode = OWA_controls[control]
    if keyCode == nil or not input.IsKeyDown(keyCode) then return end
    callback()
end

if file.Exists(OWA_CONTROLS_FILE, 'DATA') then
    loadControlsFromFile()
else
    createBlankControlsTable()
end

hook.Add('Think', 'OWA Ability key pressed', function()
    if LocalPlayer():IsTyping() then return end

    handleControlKeyPress('ability1', function()
        debugLog 'abilityCastRequest 1'
        net.QuickMsg('abilityCastRequest', 1)
    end)

    handleControlKeyPress('ability2', function()
        debugLog 'abilityCastRequest 2'
        net.QuickMsg('abilityCastRequest', 2)
    end)

    handleControlKeyPress('ultimate', function()
        debugLog 'ultimateRequest'
        Signal 'ultimateCastRequest'
    end)

    -- TODO: Choose working one

    -- 1
    handleControlKeyPress('showHeroSelectScreen', function()
        debugLog 'showHeroSelectScreen'
        OWA_toggleHeroSelectScreen()
    end)

    -- 2
    -- if OWA_controls.ultimate ~= nil then
    --     if input.WasKeyReleased(OWA_controls.showHeroSelectScreen) then
    --         debugLog('showHeroSelectScreen')
    --         addOWAHeroSettingsPage()
    --     end
    -- end
end)

-- 3
-- hook.Add('Move', 'OWAAbilityKeyPressed_move', function()
--     if LocalPlayer():IsTyping() then return end
--
--     if OWA_controls.showHeroSelectScreen ~= nil then
--         if input.WasKeyTyped(OWA_controls.showHeroSelectScreen) then
--             debugLog('showHeroSelectScreen')
--             addOWAHeroSettingsPage()
--         end
--     end
-- end)
