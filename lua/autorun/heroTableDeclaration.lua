--Enables/disables the debug output.
DEBUG = true

HEROES = {}

function OverwatchHero(infoTable)
    if HEROES ~= nil then
        HEROES[infoTable.name or "Mister X"] = infoTable
    else
        hook.Add("PreGamemodeLoaded", "addHero_genji", function()
            HEROES[infoTable.name or "Mister X"] = infoTable
        end)
    end
end