--Enables/disables the debug output.
DEBUG = true

HEROES = {}

function OverwatchHero(infoTable)
	HEROES[infoTable.name or "Mister X"] = infoTable
end