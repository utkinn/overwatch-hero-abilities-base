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

function setPlayerHero(player, hero)
	if hero.name == "none" then return end
	player:SetNWString("hero", hero.name)
	
	if GetConVar("owa_hero_customization_affects_health"):GetBool() then
		player:SetMaxHealth(hero.health or 100)
		player:SetHealth(hero.health or 100)
	end
	if GetConVar("owa_hero_customization_affects_armor"):GetBool() then
		player:SetArmor(hero.armor or 0)
	end
	if GetConVar("owa_hero_customization_affects_shield"):GetBool() then
		player:SetNWInt("shield", hero.shield or 0)
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
	
	for _, broadcastTarget in pairs(team.GetPlayers(player:Team())) do
		net.Start("allyChangedHero")
			net.WriteString(player:Nick())
			net.WriteString(hero.name)
		net.Send(broadcastTarget)
	end
end

hook.Add("PlayerSpawn", "setHero", function(player)
	local heroToSet = HEROES[player:GetInfo("owa_hero")]
	if heroToSet ~= nil then
		setPlayerHero(player, heroToSet)
	end
end)

hook.Add("PlayerHurt", "decreaseShield", function(victim, attacker, healthRemaining, damageTaken)
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
end)

net.Receive("abilityCastRequest", function(_, player)
	local heroName = player:GetNWString("hero")
	local hero = HEROES[heroName]
	local ability = net.ReadUInt(3)
	local cooldownNWIntKey = "Cooldown; hero:" .. hero.name .. " ability:" .. ability
	
	if not player:GetNWInt(cooldownNWIntKey) then	--If an ability isn't cooling down
		local success = hero.ability[ability]:cast(player)	--Casting the ability and getting the success result
	
		if success then	--If a cast is successful
			player:SetNWInt(cooldownNWIntKey, hero.cooldown)	--Putting the ability to cooldown
		
			timer.Create("Cooldown; player:" .. player:UserID() .. " hero:" .. hero.name .. " ability:" .. ability, 1, hero.cooldown - 1, function()	--Creating a cooldown countdown timer
				player:SetNWInt(cooldownNWIntKey, player:GetNWInt(cooldownNWIntKey) - 1)
			end)
			
			timer.Simple(hero.cooldown, function()	--Removing cooldown flag
				player:SetNWInt(cooldownNWIntKey, 0)
			end)
		end
	end
end)

net.Receive("ultimateCastRequest", function(_, player)
	local heroName = player:GetNWString("hero")
	local hero = HEROES[heroName]
	
	if player:GetNWInt("ultimateCharge") >= hero.ultimate.pointsRequired then
		local success = hero.ultimate:cast(player)
		
		if success then
			player:SetNWInt("ultimateCharge", 0)
		end
	end
end)