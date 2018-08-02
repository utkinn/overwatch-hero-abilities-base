include 'claf.lua'
include 'owa_utils.lua'
include 'owa_constants.lua'

local function createBlankControlsTable()
    return {
        ability1 = nil,
        ability2 = nil,
        ultimate = nil,
        showHeroSelectScreen = nil
    }
end

local function loadControlsFromFile()
    return util.JSONToTable(file.Read(OWA_CONTROLS_FILE))
end

local function handleControlKeyPress(control, callback)
    local keyCode = OWA_controls[control]
    if keyCode == nil or not input.IsKeyDown(keyCode) then return end
    callback()
end

if file.Exists(OWA_CONTROLS_FILE, 'DATA') then
    OWA_controls = loadControlsFromFile()
else
    OWA_controls = createBlankControlsTable()
end

hook.Add('Think', 'OWA Ability key pressed', function()
    if LocalPlayer():IsTyping() then return end

    handleControlKeyPress('ability1', function()
        net.QuickMsg('abilityCastRequest', 1)
    end)

    handleControlKeyPress('ability2', function()
        net.QuickMsg('abilityCastRequest', 2)
    end)

    handleControlKeyPress('ultimate', function()
        Signal 'ultimateCastRequest'
    end)

    handleControlKeyPress('showHeroSelectScreen', function()
        OWA_toggleHeroSelectScreen()
    end)
end)
