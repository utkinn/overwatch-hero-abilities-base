util.AddNetworkString("allyChangedHero")
util.AddNetworkString("abilityCastRequest")
util.AddNetworkString("abilityCastSuccess")
util.AddNetworkString("openPermissionsMenu")
util.AddNetworkString("ultimateCastRequest")
util.AddNetworkString("adminConVarChanged")

-- local newHero =
-- {
	-- name = infoTable.name or "Mister X",
	-- description = infoTable.description or "Poor villain of indefiniteness",
	-- abilities = infoTable.abilities or {},
	-- ultimate = infoTable.ultimate,
	-- health = infoTable.health or 100,
	-- armor = infoTable.armor or 0,
	-- shield = infoTable.shield or 0,
	-- speed = infoTable.speed or 100,
	-- weapons = infoTable.weapons or {},
	-- customSettings = infoTable.customSettings or {},
	-- abilityMaterials = abilityMaterials or {},
	-- ultimateMaterial = ultimateMaterial or Material("OWAMaterialError.jpeg")
-- }

--(Re)sets player hero parameters.
function setPlayerHero(player, hero)
	player:SetNWString("hero", hero.name)
	if hero.name == "none" then return end
	
	if GetConVar("owa_hero_customization_affects_health"):GetBool() then
		player:SetMaxHealth(hero.health or 100)
		player:SetHealth(hero.health or 100)
	end
	if GetConVar("owa_hero_customization_affects_armor"):GetBool() then
		player:SetArmor(hero.armor or 0)
	end
	if GetConVar("owa_hero_customization_affects_shield"):GetBool() then
		player:SetNWInt("shield", hero.shield or 0)
	else
		player:SetNWInt("shield", 0)
	end
	if hero.speed ~= nil and GetConVar("owa_hero_customization_affects_speed"):GetBool() then
		player:SetWalkSpeed(hero.speed * 2)
		player:SetRunSpeed(hero.speed * 4)
	end
	
	if hero.weapons ~= nil and GetConVar("owa_hero_customization_affects_weapons"):GetBool()then
		for _, weapon in pairs(hero.weapons) do
			player:Give(weapon)
		end
	end
	
	--Notifying teammates about hero change
	for _, broadcastTarget in pairs(team.GetPlayers(player:Team())) do
		net.Start("allyChangedHero")
			net.WriteString(player:Nick())
			net.WriteString(hero.name)
		net.Send(broadcastTarget)
	end
end

function abilitySucceeded(ply, id)
	local hero = HEROES[ply:GetNWString("hero")]
	local cooldownNWIntKey = "cooldown "..id
	local cooldownTimerKey = "cooldown "..id.." "..ply:UserID()
	local cooldown = hero.abilities[id].cooldown
	
	ply:SetNWInt(cooldownNWIntKey, cooldown)
	
	if DEBUG then PrintTable(hero) end
	
	timer.Create(cooldownTimerKey, 1, cooldown - 1, function()	--Creating a cooldown countdown timer
		ply:SetNWInt(cooldownNWIntKey, ply:GetNWInt(cooldownNWIntKey) - 1)
	end)
	
	timer.Simple(cooldown, function()	--Removing cooldown flag
		ply:SetNWInt(cooldownNWIntKey, 0)
	end)
end

hook.Add("PlayerSpawn", "setHero", function(player)
	local heroToSet = HEROES[player:GetInfo("owa_hero")]
	if heroToSet ~= nil then
		setPlayerHero(player, heroToSet)
	else
		player:SetNWString("hero", "none")
	end
end)

hook.Add("PlayerHurt", "decreaseShield", function(victim, attacker, healthRemaining, damageTaken)
	if HEROES[victim:GetNWString("hero")].shield then
		if victim:GetNWInt("shield") > 0 then	--Checking if victim has a shield charge
			victim:SetHealth(victim:Health() + damageTaken)	--Restoring damage
			victim:SetNWInt("shield", victim:GetNWInt("shield") - damageTaken)
			if victim:GetNWInt("shield") < 0 then	--Passing damage with broken shield
				victim:SetHealth(victim:Health() - victim:GetNWInt("shield"))
				victim:SetNWInt("shield", 0)
			end
		end
		timer.Simple(3, function()
			timer.Create("restoreShield:" .. victim:Nick(), 0.1, 0, function()
				local newValue = victim:GetNWInt("shield") + 3
				
				if newValue > HEROES[victim:GetNWString("hero")].shield then
					newValue = HEROES[victim:GetNWString("hero")].shield
					timer.Remove("restoreShield:" .. victim:Nick())
				end
				
				victim:SetNWInt("shield", newValue)
			end)
		end)
	end
end)

net.Receive("abilityCastRequest", function(_, owa_ply)
	--Anti-conflict workaround:
	--For some reason "normal" method was conflicting with TFA VOX.
	if owa_ply:GetNWString("hero") == "none" then return end
	local ability = net.ReadUInt(3)
	local cooldownNWIntKey = "cooldown "..ability
	if owa_ply:GetNWInt(cooldownNWIntKey) <= 0 or DEBUG then
		--							player	hero								ability
		hook.Run("AbilityCasted", owa_ply, HEROES[owa_ply:GetNWString("hero")], ability)
	else
		dbgLog("Ability "..ability.name.." on cooldown("..owa_ply:GetNWInt(cooldownNWIntKey).."), denying.")
	end
end)

net.Receive("ultimateCastRequest", function(_, player)
	local heroName = player:GetNWString("hero")
	if heroName == "none" then return end
	local hero = HEROES[heroName]
	
	if player:GetNWInt("ultimateCharge") >= hero.ultimate.pointsRequired then
		local success = hero.ultimate:cast(player)
		
		if success then
			player:SetNWInt("ultimateCharge", 0)
		end
	end
end)