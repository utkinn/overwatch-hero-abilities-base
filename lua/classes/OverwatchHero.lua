include("classes/OverwatchAbility.lua")
require("OWAHeroManager")

OverwatchHero = {}
OverwatchHero.__index = OverwatchHero

setmetatable(OverwatchHero, {__call = function(infoTable)
	return setmetatable(
	{
		name = infoTable.name or "Mister X",
		description = infoTable.description or "Poor villain of indefiniteness",
		abilities = infoTable.abilities or {},
		ultimate = infoTable.ultimate,
		health = infoTable.health or 100,
		armor = infoTable.armor or 0,
		shield = infoTable.shield or 0,
		speed = infoTable.speed or 100,
		weapons = infoTable.weapons or {}
	}, OverwatchHero)
	
	table.insert(OWAHeroManager.HEROES, name)
end})

function OverwatchHero:getName()
	return self.name
end

function OverwatchHero:setName(name)
	self.name = name
end

function OverwatchHero:getHealth()
	return self.health
end

function OverwatchHero:getArmor()
	return self.armor
end

function OverwatchHero:getShield()
	return self.shield
end

function OverwatchHero:getSpeed()
	return self.speed
end

function OverwatchHero:getAbility(index)
	return self.abilities[index]
end

function OverwatchHero:setAbility(index, ability)
	self.abilities[index] = ability
end