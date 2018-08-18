OWA_HEROES = {}

function OverwatchHero(infoTable)
    local name = infoTable.name or "Mister X"
    print(name)
    local function add()
        OWA_HEROES[name] = infoTable
    end

    if OWA_HEROES ~= nil then
        add()
    else
        hook.Add("PreGamemodeLoaded", "AddHero_"..name, add)
    end
end

hook.Run('OWA: Add hero')
hook.Run('OWA: Heroes added')
