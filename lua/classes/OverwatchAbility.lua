OverwatchAbility = {}
OverwatchAbility.__index = OverwatchAbility

setmetatable(OverwatchAbility, {__call = function(name, description, cast, cooldown)
	return setmetatable(
	{
		name = name or "Blank ability",
		description = description or "No description.",
		cast = cast or function() end,
		cooldown = cooldown or 10
	}, OverwatchAbility)
end})