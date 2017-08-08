include("classes/OverwatchAbility.lua")
require("OWAHeroManager")

OverwatchHero = {}
OverwatchHero.__index = OverwatchHero

setmetatable(OverwatchHero, {__call = function(name, description, abilities, ultimate)
	return setmetatable(
	{
		name = name or "Mister X",
		description = description or "Poor villain of indefiniteness",
		abilities = abilities or {}
		ultimate = ultimate
		
		table.insert(OWAHeroManager.HEROES, name)
	}, OverwatchHero)
end})