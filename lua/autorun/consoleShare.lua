include("heroTableDeclaration.lua")
AddCSLuaFile("heroTableDeclaration.lua")

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
	--CreateConVar("tracer_blink_adminonly", 0, flags, "Allow blinking to admins only."),
	
}

--TODO: Hero customization
for _, hero in pairs(HEROES) do
	for _, ability in pairs(hero.abilities) do
		table.insert(adminConVars, CreateConVar("owa_hero_customisation:" .. hero:getName() .. ".ability:" .. ability.name .. ".cooldown", ability.cooldown, flags, "Change the cooldown of the " .. hero:getName() .. "'s \"" .. ability.name .. "\" ability."))
	end
	for _, customSetting in pairs(hero.customSettings) do
		table.insert(adminConVars, CreateConVar("owa_hero_customisation:" .. hero:getName() .. "." .. customSetting.convar, customSetting.default, flags, customSetting.help))
	end
	table.insert(adminConVars, CreateConVar("owa_hero_customization:" .. hero:getName() .. ".ultimate.mult", 1, flags, "The charge speed multiplier of ultimate ability \"" .. ultimate.name .. "\"."))
end