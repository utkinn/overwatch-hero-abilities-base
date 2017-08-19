function removeSpaces(str)
	return str:Trim():Replace(" ", "_")
end

function signal(signalName, player)
	net.Start(signalName)
	if SERVER then
		net.Send(player)
	elseif CLIENT then
		net.SendToServer()
	end
end

--TODO: Add flag to client
conVarFlags = SERVER and {FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_USERINFO

adminConVars =
{
	CreateConVar("owa_hero_customization_affects_health", 1, flags, language.GetPhrase("owa.consoleHelp.heroPlayerProperties.health"))
	CreateConVar("owa_hero_customization_affects_armor", 1, flags, language.GetPhrase("owa.consoleHelp.heroPlayerProperties.armor"))
	CreateConVar("owa_hero_customization_affects_shield", 1, flags, language.GetPhrase("owa.consoleHelp.heroPlayerProperties.shield"))
	CreateConVar("owa_hero_customization_affects_speed", 1, flags, language.GetPhrase("owa.consoleHelp.heroPlayerProperties.speed"))
	CreateConVar("owa_hero_customization_affects_weapons", 1, flags, language.GetPhrase("owa.consoleHelp.heroPlayerProperties.weapons"))
}

--TODO: Hero customization
for _, hero in pairs(HEROES) do
	table.insert(adminConVars, CreateConVar("owa_hero." .. removeSpaces(hero.name) .. ".adminsOnly", 0, flags, language.GetPhrase("owa.consoleHelp.owa_hero_adminOnly.1") .. hero.name .. language.GetPhrase("owa.consoleHelp.owa_hero_adminOnly.2")))
	for _, ability in pairs(hero.abilities) do
		table.insert(adminConVars, CreateConVar("owa_hero_customization." .. removeSpaces(hero.name) .. ".ability." .. removeSpaces(ability.name) .. ".cooldown", ability.cooldown, flags, "Change the cooldown of the " .. hero:getName() .. "'s \"" .. ability.name .. "\" ability."))
	end
	for _, customSetting in pairs(hero.customSettings) do
		table.insert(adminConVars, CreateConVar("owa_hero_customisation." .. removeSpaces(hero:getName()) .. "." .. customSetting.convar, customSetting.default, flags, customSetting.help))
	end
	table.insert(adminConVars, CreateConVar("owa_hero_customization." .. removeSpaces(hero:getName()) .. ".ultimate.mult", 1, flags, "The charge speed multiplier of ultimate ability \"" .. ultimate.name .. "\"."))
end

function OverwatchHero(infoTable)
	HEROES[infoTable.name or "Mister X"] = infoTable
end