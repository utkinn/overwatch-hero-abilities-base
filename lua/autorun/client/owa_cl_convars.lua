include 'claf.lua'

-- Function forward declarations
local setHeroCvarWithoutCallback, onSuccessfulHeroChange, revertHeroChange, addHeroChangeCallback

setHeroCvarWithoutCallback = function(value)
    cvars.RemoveChangeCallback('owa_hero', 'Validate hero change input')
    GetConVar('owa_hero'):SetString(value)
    addHeroChangeCallback()
end

onSuccessfulHeroChange = function()
    if GetConVar('owa_suicide_on_hero_change'):GetBool() and LocalPlayer():Alive() then
        Signal 'OWA: Suicide'
    else
        chat.AddText('#owa.ui.chat.respawnRequired')
    end
end

revertHeroChange = function(oldHeroName)
    setHeroCvarWithoutCallback(oldHeroName)  -- Reverting the change
    MsgC(Color(255, 0, 0), language.GetPhrase('owa.consoleHelp.owa_ui_hero.invalid')..'\n')
end

addHeroChangeCallback = function()
    cvars.AddChangeCallback('owa_hero', function(conVarName, oldHeroName, newHeroName)
        local isHeroValid = Any(HEROES, function(hero) return hero.name == newHeroName end) or newHeroName == 'none'

        if not isHeroValid then
            revertHeroChange(oldHeroName)
        elseif oldHeroName ~= newHeroName then  -- elseif hero was changed, suicide if enabled
            onSuccessfulHeroChange()
        end
    end, 'Validate hero change input')
end

local function validateLanguageChange(oldLanguage, newLanguage)
    -- Return if the new language is in "supported" list, keep going if not
    if OWA_supportedLanguages[newLanguage] then return end

    MsgC(Color(255, 0, 0), 'Invalid language.\n')
    GetConVar('owa_ui_language'):SetString(oldLanguage)  -- Reverting convar value
end

CreateClientConVar('owa_hud_halos_ally', 1, true, false, language.GetPhrase('owa.consoleHelp.owa_hud_halos_ally'))

CreateClientConVar('owa_hud_halos_enemy', 1, true, false, language.GetPhrase('owa.consoleHelp.owa_hud_halos_enemy'))

CreateClientConVar('owa_hero', 'none', true, true, language.GetPhrase('owa.consoleHelp.owa_hero'))
addHeroChangeCallback()

CreateClientConVar('owa_suicide_on_hero_change', 0, true, true,
                   language.GetPhrase('owa.consoleHelp.owa_suicide_on_hero_change'))

CreateClientConVar('owa_hero_callouts', '0', true, true, "Play heroes' callouts on ability usages.")

CreateClientConVar('owa_ui_language', 'en', true, false, language.GetPhrase('owa.consoleHelp.owa_ui_language'))
cvars.AddChangeCallback('owa_ui_language', function(_, oldLanguage, newLanguage)
    validateLanguageChange(oldLanguage, newLanguage)
end, 'Validate UI language change')
