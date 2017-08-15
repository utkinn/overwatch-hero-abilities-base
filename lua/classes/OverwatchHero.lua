include("classes/OverwatchAbility.lua")
require("OWAHeroManager")

OverwatchHero = {}
OverwatchHero.__index = OverwatchHero

setmetatable(OverwatchHero,
{
	__call = function(infoTable)
		local newHero =
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
		}
	
		OWAHeroManager.HEROES[name] = newHero
		
		local link = {link = infoTable.name or "Mister X"}
		
		return setmetatable(link, OverwatchHero)
	end
})

function OverwatchHero:getName()
	return OWAHeroManager.HEROES[self.link].name
end

function OverwatchHero:getHealth()
	return OWAHeroManager.HEROES[self.link].health
end

function OverwatchHero:getArmor()
	return OWAHeroManager.HEROES[self.link].armor
end

function OverwatchHero:getShield()
	return OWAHeroManager.HEROES[self.link].shield
end

function OverwatchHero:getSpeed()
	return OWAHeroManager.HEROES[self.link].speed
end

function OverwatchHero:getAbility(index)
	return OWAHeroManager.HEROES[self.link].abilities[index]
end

function OverwatchHero:setAbility(index, ability)
	--TODO: Add ability parameter check
	OWAHeroManager.HEROES[self.link].abilities[index] = ability
end