include 'claf.lua'

local function validateHeroChange(oldHeroName, newHeroName)
    local validHero = Any(HEROES, function(hero) return hero.name == newHeroName end)

    if newHeroName == 'none' then validHero = true end

    if not validHero then
        GetConVar('owa_hero'):SetString(oldHeroName)
        MsgC(Color(255, 0, 0), language.GetPhrase('owa.consoleHelp.owa_ui_hero.invalid'))
    elseif oldHeroName ~= newHeroName then
        if GetConVar('owa_suicide_on_hero_change'):GetBool() and LocalPlayer():Alive() then
            RunConsoleCommand('kill')
        else
            chat.AddText('#owa.ui.chat.respawnRequired')
        end
    end
end

CreateClientConVar('owa_hud_halos_ally', 1, true, false, language.GetPhrase('owa.consoleHelp.owa_hud_halos_ally'))

CreateClientConVar('owa_hud_halos_enemy', 1, true, false, language.GetPhrase('owa.consoleHelp.owa_hud_halos_enemy'))

CreateClientConVar('owa_hero', 'none', true, true, language.GetPhrase('owa.consoleHelp.owa_hero'))
cvars.AddChangeCallback('owa_hero', function(_, oldHeroName, newHeroName)
    validateHeroChange(oldHeroName, newHeroName)
end, 'Validate hero change input')

CreateClientConVar('owa_suicide_on_hero_change', 0, true, true,
    language.GetPhrase('owa.consoleHelp.owa_suicide_on_hero_change'))

CreateClientConVar('owa_hero_callouts', '0', true, true, "Play heroes' callouts on ability usages.")

CreateClientConVar('owa_ui_language', 'en', true, false, language.GetPhrase('owa.consoleHelp.owa_ui_language'))
cvars.AddChangeCallback('owa_ui_language', function(conVar, oldLanguage, newLanguage)
    if table.HasValue(OWA_supportedLanguages, newLanguage) then return end

    MsgC(Color(255, 0, 0), 'Invalid language.')
    MsgN()
    conVar:SetString(oldLanguage)
end, 'Validate UI language change')
