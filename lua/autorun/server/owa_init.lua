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

hook.Add("PlayerSpawn", "setHero", function(player)
	local heroToSet = OWAHeroManager.HEROES[player:GetInfo("owa_hero")]
	if heroToSet ~= nil then
		OWAHeroManager.setPlayerHero(player, heroToSet)
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
			if newValue > OWAHeroManager.HEROES[victim:GetNWString("hero")]:getShield() then
				newValue = OWAHeroManager.HEROES[victim:GetNWString("hero")]:getShield()
				timer.Remove("restoreShield:" .. victim:Nick())
			end
			
			victim:SetNWInt("shield", newValue)
		end)
	end)
end)

net.Receive("abilityCastRequest", function(_, player)
	local heroName = player:GetNWString("hero")
	local hero = OWAHeroManager.HEROES[heroName]
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
	local hero = OWAHeroManager.HEROES[heroName]
	
	if player:GetNWInt("ultimateCharge") == hero.ultimate.pointsRequired then
		local success = hero.ultimate:cast(player)
		
		if success then
			player:SetNWInt("ultimateCharge", 0)
		end
	end
end)