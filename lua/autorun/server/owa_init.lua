include("classes/OverwatchHero.lua")
include("classes/OverwatchAbility.lua")
include("classes/OverwatchUltimate.lua")

AddCSLuaFile("classes/OverwatchHero.lua")
AddCSLuaFile("classes/OverwatchAbility.lua")
AddCSLuaFile("classes/OverwatchUltimate.lua")

util.AddNetworkString("allyChangedHero")
util.AddNetworkString("abilityCastRequest")
util.AddNetworkString("abilityCastSuccess")
util.AddNetworkString("openPermissionsMenu")
util.AddNetworkString("ultimateCastRequest")

function setPlayerHero(player, hero)
	if hero.name == "none" then return end
	player:SetNWString("hero", hero.name)
	
	player:SetMaxHealth(hero.health)
	player:SetHealth(hero.health)
	player:SetArmor(hero.armor)
	player:SetNWInt("shield", hero.shield)
	player:SetWalkSpeed(hero.speed)
	player:SetRunSpeed(hero.speed * 2)
	
	for _, weapon in pairs(hero.weapons) do
		player:Give(weapon)
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
	if victim:GetNWInt("shield") ~= 0 then	--Checking if victim has a shield charge
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
			if newValue > HEROES[victim:GetNWString("hero")]:getShield() then
				newValue = HEROES[victim:GetNWString("hero")]:getShield()
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
	
	if player:GetNWInt("ultimateCharge") == hero.ultimate.pointsRequired then
		local success = hero.ultimate:cast(player)
		
		if success then
			player:SetNWInt("ultimateCharge", 0)
		end
	end
end)