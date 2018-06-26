include 'owa_utils.lua'

--Enables/disables the debug output.
OWA_DEBUG = true

local conVarFlags = Either(SERVER, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, FCVAR_USERINFO)

adminConVars = {
    CreateConVar("owa_hero_customization_affects_health", 1, flags, "Does selected hero affects players' health?"),
    CreateConVar("owa_hero_customization_affects_armor", 1, flags, "Does selected hero affects players' armor?"),
    CreateConVar("owa_hero_customization_affects_shield", 1, flags, "Does selected hero affects players' shield?"),
    CreateConVar("owa_hero_customization_affects_speed", 1, flags, "Does selected hero affects players' speed?"),
    CreateConVar("owa_hero_customization_affects_weapons", 1, flags, "Does selected hero affects players' weapons?")
}

--TODO: Hero customization
for _, hero in pairs(HEROES) do
    table.insert(adminConVars, CreateConVar(
        "owa_hero."..removeSpaces(hero.name)..".adminsOnly",
        0,
        flags,
        "Restrict "..hero.name.." for regular players."
    ))

    for _, ability in pairs(hero.abilities) do
        table.insert(adminConVars, CreateConVar(
            "owa_hero_customization."
               ..removeSpaces(hero.name)
               ..".ability."
               ..removeSpaces(ability.name)
               ..".cooldown",
            ability.cooldown,
            flags,
            "Change the cooldown of the "..hero.name.."'s \""..ability.name.."\" ability."
        ))
    end

    if hero.customSettings ~= nil then
        for _, customSetting in pairs(hero.customSettings) do
            table.insert(adminConVars, CreateConVar(
                "owa_hero_customisation."..removeSpaces(hero.name).."."..customSetting.convar,
                customSetting.default,
                flags,
                customSetting.help
            ))
        end
    end

    table.insert(adminConVars, CreateConVar(
        "owa_hero_customization."..removeSpaces(hero.name)..".ultimate.mult",
        1,
        flags,
        "The charge speed multiplier of ultimate ability \""..hero.ultimate.name.."\"."
    ))
end
