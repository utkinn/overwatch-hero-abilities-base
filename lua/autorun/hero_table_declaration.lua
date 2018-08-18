OWA_HEROES = {}

function OverwatchHero(infoTable)
    if OWA_HEROES ~= nil then
        OWA_HEROES[infoTable.name or "Mister X"] = infoTable
    else
        hook.Add("PreGamemodeLoaded", "addHero", function()
            OWA_HEROES[infoTable.name or "Mister X"] = infoTable
        end)
    end
end

hook.Run('OWA: Add hero')
