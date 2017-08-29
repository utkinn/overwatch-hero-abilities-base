--Custom library

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

function isFriendly(player, ent)
	if ent:IsPlayer() then
		if player:Team() == ent:Team() then return true end
	elseif hitEnt:IsNPC() then
		local disposition = ent:Disposition(player)
		if disposition == D_LI or disposition == D_NU then return true end
	end
	return false
end

function dbgLog(textOrPredicate, textOrFunctionWhenTrue, textOrFunctionWhenFalse)
	--local STACK_LEVEL = 3
	if DEBUG then
		if isstring(textOrPredicate) then
			print("[OWA Debug"..debug.traceback().."] "..textOrPredicate)
		elseif isbool(textOrPredicate) then
			if isstring(textOrFunctionWhenTrue) then
				print("[OWA Debug"..debug.traceback().."] "..textOrFunctionWhenTrue)
			elseif isfunction(textOrFunctionWhenTrue) then
				textOrFunctionWhenTrue()
			else
				print("[OWA Debug"..debug.traceback().."] bad argument #2 ("..type(textOrFunctionWhenTrue).." got, string or function expected)")
			end
			
			if isstring(textOrFunctionWhenFalse) then
				print("[OWA Debug"..debug.traceback().."] "..textOrFunctionWhenFalse)
			elseif isfunction(textOrFunctionWhenFalse) then
				textOrFunctionWhenFalse()
			else
				print("[OWA Debug"..debug.traceback().."] bad argument #3 ("..type(textOrFunctionWhenFalse).." got, string or function expected)")
			end
		else
			print("[OWA Debug"..debug.traceback().."] bad argument #1 ("..type(textOrPredicate).." got, string or bool expected)")
		end
	end
end

conVarFlags = SERVER and {FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_USERINFO

adminConVars =
{
	CreateConVar("owa_hero_customization_affects_health", 1, flags, "Does selected hero affects players' health?"),
	CreateConVar("owa_hero_customization_affects_armor", 1, flags, "Does selected hero affects players' armor?"),
	CreateConVar("owa_hero_customization_affects_shield", 1, flags, "Does selected hero affects players' shield?"),
	CreateConVar("owa_hero_customization_affects_speed", 1, flags, "Does selected hero affects players' speed?"),
	CreateConVar("owa_hero_customization_affects_weapons", 1, flags, "Does selected hero affects players' weapons?")
}

--TODO: Hero customization
for _, hero in pairs(HEROES) do
	table.insert(adminConVars, CreateConVar("owa_hero." .. removeSpaces(hero.name) .. ".adminsOnly", 0, flags, "Restrict " .. hero.name .. " for regular players."))
	for _, ability in pairs(hero.abilities) do
		table.insert(adminConVars, CreateConVar("owa_hero_customization." .. removeSpaces(hero.name) .. ".ability." .. removeSpaces(ability.name) .. ".cooldown", ability.cooldown, flags, "Change the cooldown of the " .. hero.name .. "'s \"" .. ability.name .. "\" ability."))
	end
	if hero.customSettings ~= nil then
		for _, customSetting in pairs(hero.customSettings) do
			table.insert(adminConVars, CreateConVar("owa_hero_customisation." .. removeSpaces(hero.name) .. "." .. customSetting.convar, customSetting.default, flags, customSetting.help))
		end
	end
	table.insert(adminConVars, CreateConVar("owa_hero_customization." .. removeSpaces(hero.name) .. ".ultimate.mult", 1, flags, "The charge speed multiplier of ultimate ability \"" .. hero.ultimate.name .. "\"."))
end