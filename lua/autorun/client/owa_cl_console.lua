--Admins' convars change handling
for _, command in pairs(adminConVars) do
	cvars.AddChangeCallback(command:GetName(), function(conVar, oldValue, newValue)
		if LocalPlayer():IsAdmin() then
			net.Start("adminConVarChanged")
				net.WriteFloat(newValue)
			net.SendToServer()
		else
			MsgC(Color(255, 0, 0), language.GetPhrase("ui.settings.admin.denied") .. "\n")
			command:SetString(oldValue)
		end
	end)
end)

concommand.Add("owa_ui_permissions", function(player)
	if player:IsAdmin() then
		showPermissionsMenu()
	end
end, nil, language.GetPhrase("owa.consoleHelp.owa_ui_permissions"))

CreateClientConVar("owa_hud_halos_ally", 1, true, false, language.GetPhrase("owa.consoleHelp.owa_hud_halos_ally"))
CreateClientConVar("owa_hud_halos_enemy", 1, true, false, language.GetPhrase("owa.consoleHelp.owa_hud_halos_enemy"))
CreateClientConVar("owa_hero", "none", true, true, language.GetPhrase("owa.consoleHelp.owa_hero"))
CreateClientConVar("owa_suicide_on_hero_change", 0, true, true, language.GetPhrase("owa.consoleHelp.owa_suicide_on_hero_change"))
CreateClientConVar("owa_hero_callouts", "0", true, true, "Play heroes' callouts on ability usages.")
cvars.AddChangeCallback("owa_hero", function(conVar, oldHeroName, newHeroName)
	local validHero = false

	for _, hero in pairs(HEROES) do
		if newHeroName == hero.name then validHero = true end
	end
	
	if newHeroName == "none" then validHero = true end
	
	if not validHero then
		GetConVar("owa_hero"):SetString(oldHeroName)
		MsgC(Color(255, 0, 0), language.GetPhrase("owa.consoleHelp.owa_ui_hero.invalid"))
	elseif oldHeroName ~= newHeroName then
		if GetConVar("owa_suicide_on_hero_change"):GetBool() and LocalPlayer():Alive() then
			LocalPlayer:Kill()
		else
			chat.AddText("#owa.ui.chat.respawnRequired")
		end
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