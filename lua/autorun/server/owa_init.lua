AddCSLuaFile('owa_utils.lua')
AddCSLuaFile('owa_shared_console_commands.lua')
AddCSLuaFile('owa_constants.lua')

-- local newHero =
-- {
    -- name = infoTable.name or 'Mister X',
    -- description = infoTable.description or 'Poor villain of indefiniteness',
    -- abilities = infoTable.abilities or {},
    -- ultimate = infoTable.ultimate,
    -- health = infoTable.health or 100,
    -- armor = infoTable.armor or 0,
    -- shield = infoTable.shield or 0,
    -- speed = infoTable.speed or 100,
    -- weapons = infoTable.weapons or {},
    -- customSettings = infoTable.customSettings or {},
    -- abilityMaterials = abilityMaterials or {},
    -- ultimateMaterial = ultimateMaterial or Material('OWAMaterialError.jpeg')
-- }

local function notifyTeammatesAboutHeroChange(ply, hero)
    --Notifying teammates about hero change
    local plyTeammates = team.GetPlayers(ply:Team())

    for _, broadcastTarget in pairs(plyTeammates) do
        net.Start('allyChangedHero')
            net.WriteString(ply:Nick())
            net.WriteString(hero.name)
        net.Send(broadcastTarget)
    end
end

--(Re)sets ply hero parameters.
local function setPlayerHero(ply, hero)
    ply:SetNWString('hero', hero.name)
    if hero.name == 'none' then return end

    if GetConVar('owa_hero_customization_affects_health'):GetBool() then
        ply:SetMaxHealth(hero.health or 100)
        ply:SetHealth(hero.health or 100)
    end

    if GetConVar('owa_hero_customization_affects_armor'):GetBool() then
        ply:SetArmor(hero.armor or 0)
    end

    if GetConVar('owa_hero_customization_affects_shield'):GetBool() then
        ply:SetNWInt('shield', hero.shield or 0)
    else
        ply:SetNWInt('shield', 0)
    end

    if hero.speed ~= nil and GetConVar('owa_hero_customization_affects_speed'):GetBool() then
        ply:SetWalkSpeed(hero.speed * 2)
        ply:SetRunSpeed(hero.speed * 4)
    end

    if hero.weapons ~= nil and GetConVar('owa_hero_customization_affects_weapons'):GetBool() then
        for _, weapon in pairs(hero.weapons) do
            ply:Give(weapon)
        end
    end

    notifyTeammatesAboutHeroChange(ply, hero)
end

local function hasShield(ent)
    return ent:GetNWInt('shield') > 0
end

local function runShieldRestore(victim)
    timer.Simple(3, function()
        timer.Create('restoreShield:'..victim:Nick(), 0.1, 0, function()
            local newValue = victim:GetNWInt('shield') + 3
            local maxValue = OWA_HEROES[victim:GetNWString('hero')].shield

            if newValue >= maxValue then
                newValue = maxValue
                timer.Remove('restoreShield:'..victim:Nick())
            end

            victim:SetNWInt('shield', newValue)
        end)
    end)
end

local function hurtShield(victim, damageData)
    local damageToPlayer = damageData:GetDamage() - victim:GetNWInt('shield')
    local damageToShield = damageData:GetDamage() - damageToPlayer

    victim:SetNWInt('shield', victim:GetNWInt('shield') - damageToShield)
    damageData:SubtractDamage(damageToShield)

    runShieldRestore(victim)
end

function abilitySucceeded(ply, id)
    local hero = OWA_HEROES[ply:GetNWString('hero')]
    local cooldownNWIntKey = 'cooldown '..id
    local cooldownTimerKey = 'cooldown '..id..' '..ply:UserID()
    local cooldown = hero.abilities[id].cooldown

    ply:SetNWInt(cooldownNWIntKey, cooldown)

    if DEBUG then PrintTable(hero) end

    timer.Create(cooldownTimerKey, 1, cooldown - 1, function()    --Creating a cooldown countdown timer
        ply:SetNWInt(cooldownNWIntKey, ply:GetNWInt(cooldownNWIntKey) - 1)
    end)

    timer.Simple(cooldown, function()    --Removing cooldown flag
        ply:SetNWInt(cooldownNWIntKey, 0)
    end)
end

hook.Add('PlayerSpawn', 'setHero', function(ply)
    local heroToSet = OWA_HEROES[ply:GetInfo('owa_hero')]
    if heroToSet ~= nil then
        setPlayerHero(ply, heroToSet)
    else
        ply:SetNWString('hero', 'none')
    end
end)

hook.Add('EntityTakeDamage', 'decreaseShield', function(target, damageData)
    if hasShield(target) then hurtShield(target, damageData) end
end)

net.Receive('abilityCastRequest', function(_, ply)
    --Anti-conflict workaround:
    --For some reason 'normal' method was conflicting with TFA VOX.
    if ply:GetNWString('hero') == 'none' then return end

    local ability = net.Read()
    local cooldownNWIntKey = 'cooldown '..ability
    local hero = OWA_HEROES[ply:GetNWString('hero')]

    if ply:GetNWInt(cooldownNWIntKey) <= 0 or DEBUG then
        hook.Run('AbilityCasted', ply, hero, ability)
    else
        debugLog('Ability '..ability.name..' on cooldown('..ply:GetNWInt(cooldownNWIntKey)..'), denying.')
    end
end)

net.Receive('ultimateCastRequest', function(_, ply)
    local heroName = ply:GetNWString('hero')
    if heroName == 'none' then return end
    local hero = OWA_HEROES[heroName]

    if ply:GetNWInt('ultimateCharge') >= hero.ultimate.pointsRequired then
        local success = hero.ultimate:cast(ply)

        if success then
            ply:SetNWInt('ultimateCharge', 0)
        end
    end
end)
