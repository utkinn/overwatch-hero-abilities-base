OverwatchUltimate = OverwatchAbility
OverwatchUltimate.__index = OverwatchUltimate

setmetatable(OverwatchUltimate, {__call = function(name, description, cast, pointsRequired)
	return setmetatable(
	{
		name = name or "Blank ultimate ability",
		description = description or "No description.",
		cast = cast or function() end,
		pointsRequired = pointsRequired or 1000
	}, OverwatchUltimate)
end})

function OverwatchUltimate:setCastSound(sound)
	self.castSound = sound
end