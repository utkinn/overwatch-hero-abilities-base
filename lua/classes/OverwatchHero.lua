include("classes/OverwatchAbility.lua")

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
			weapons = infoTable.weapons or {},
			customSettings = infoTable.customSettings
		}
	
		HEROES[name] = newHero
		
		local link = {link = infoTable.name or "Mister X"}
		
		return setmetatable(link, OverwatchHero)
	end
})

function OverwatchHero:getName()
	return HEROES[self.link].name
end

function OverwatchHero:getHealth()
	return HEROES[self.link].health
end

function OverwatchHero:getArmor()
	return HEROES[self.link].armor
end

function OverwatchHero:getShield()
	return HEROES[self.link].shield
end

function OverwatchHero:getSpeed()
	return HEROES[self.link].speed
end

function OverwatchHero:getAbility(index)
	return HEROES[self.link].abilities[index]
end

function OverwatchHero:getAllAbilities()
	return HEROES[self.link].abilities
end

function OverwatchHero:setAbility(index, ability)
	--TODO: Add ability parameter check
	HEROES[self.link].abilities[index] = ability
end

function OverwatchHero:addCustomSetting(name, convar, help, default, minValue, maxValue)
	--TODO: Boolean
	HEROES[self.link].customSettings[name] = {convar = convar, help = help, default = default, minValue = minValue, maxValue = maxValue}
end

function OverwatchHero:getCustomSetting(name)
	--TODO: Boolean
	return HEROES[self.link].customSettings[name]
end