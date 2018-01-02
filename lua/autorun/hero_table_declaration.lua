HEROES = {}

function OverwatchHero(infoTable)
    if HEROES ~= nil then
        HEROES[infoTable.name or "Mister X"] = infoTable
    else
        hook.Add("PreGamemodeLoaded", "addHero", function()
            HEROES[infoTable.name or "Mister X"] = infoTable
        end)
    end
end

hook.Run('OWAInitialized')
