include("classes/OverwatchHero.lua")
include("classes/OverwatchAbility.lua")

util.AddNetworkString("allyChangedHero")
util.AddNetworkString("abilityCastRequest")
util.AddNetworkString("abilityCastSuccess")
util.AddNetworkString("openPermissionsMenu")

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
	timer.Create("restoreShieldDelay:" .. victim:Nick(), 3, 0, function()
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
	--TODO: Permissions
	local heroName = player:GetNWString("hero")
	local hero = OWAHeroManager.HEROES[heroName]
	
	hero:getAbility(net.ReadUInt(3)):cast(player)
end)