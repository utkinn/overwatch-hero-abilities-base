concomand.add("owa_ui_permissions", function(player)
	if player:IsAdmin() then
		--Open permissions window
	end
end, nil, language.GetPhrase("owa.consoleHelp.owa_ui_permissions") )

CreateClientConVar("owa_hud_halos_ally", 1, true, false, language.GetPhrase("owa.consoleHelp.owa_hud_halos_ally"))
CreateClientConVar("owa_hud_halos_enemy", 1, true, false, language.GetPhrase("owa.consoleHelp.owa_hud_halos_enemy"))
CreateClientConVar("owa_hero", "none", true, true, language.GetPhrase("owa.consoleHelp.owa_hero"))
cvars.AddChangeCallback("owa_hero", function(conVar, oldHeroName, newHeroName)
	local validHero = false

	for _, hero in pairs(OWAHeroManager.HEROES) do
		if newHeroName == hero:getName() then validHero = true end
	end
	
	if not validHero then
		conVar:SetString(oldHeroName)
		MsgC(Color(255, 0, 0), language.GetPhrase("owa.consoleHelp.owa_ui_hero.invalid"))
	end
end, "validateHeroChangeInput")