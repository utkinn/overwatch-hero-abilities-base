concomand.add("owa_ui_permissions", function(player)
	if player:IsAdmin() then
		--Open permissions window
	end
end, nil, language.GetPhrase("owa.consoleHelp.owa_ui_permissions") )

CreateClientConVar("owa_hud_halos_ally", 1, true, false, language.GetPhrase("owa.consoleHelp.owa_hud_halos_ally"))
CreateClientConVar("owa_hud_halos_enemy", 1, true, false, language.GetPhrase("owa.consoleHelp.owa_hud_halos_enemy"))
CreateClientConVar("owa_hero", "none", true, true, language.GetPhrase("owa.consoleHelp.owa_hero"))
CreateClientConVar("owa_suicide_on_hero_change", "none", true, true, language.GetPhrase("owa.consoleHelp.owa_suicide_on_hero_change"))
cvars.AddChangeCallback("owa_hero", function(conVar, oldHeroName, newHeroName)
	if oldHeroName ~= newHeroName then
		if GetConVar("owa_suicide_on_hero_change"):GetBool() and LocalPlayer():Alive() then
			LocalPlayer:Kill()
		else
			chat.AddText("#owa.ui.chat.respawnRequired")
		end
	end

	local validHero = false

	for _, hero in pairs(OWAHeroManager.HEROES) do
		if newHeroName == hero:getName() then validHero = true end
	end
	
	if not validHero then
		conVar:SetString(oldHeroName)
		MsgC(Color(255, 0, 0), language.GetPhrase("owa.consoleHelp.owa_ui_hero.invalid"))
	end
end, "validateHeroChangeInput")

concommand.Add("owa_castAbility", function(player, _, args)
	net.Start("abilityCastRequest")
	net.WriteUInt(args[1], 3)
	net.SendToServer()
end)

CreateClientConVar("owa_ui_language", "en", true, false, language.GetPhrase("owa.consoleHelp.owa_ui_language"))
cvars.AddChangeCallback("owa_ui_language", function(conVar, oldLanguage, newLanguage)
	if newLanguage ~= "en" and newLanguage ~= "ru" then
		MsgC(Color( 255, 0, 0 ), "Invalid language.\n")
		conVar:SetString(oldLanguage)
	end
end, "validateUILanguageChange")