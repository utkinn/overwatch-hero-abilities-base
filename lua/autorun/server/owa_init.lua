include("classes/OverwatchHero.lua")
include("classes/OverwatchAbility.lua")

util.AddNetworkString("allyChangedHero")

hook.Add("PlayerSpawn", "setHero", function(player)
	local newHero = OWAHeroManager.getHeroByName(player:GetInfo("owa_newHero"))
	
	player:SetMaxHealth(newHero:getHealth())
	player:SetHealth(newHero:getHealth())
	player:SetMaxArmor(newHero:getArmor())
	player:SetArmor(newHero:getArmor())
	player:SetNWInt("shield", newHero:getShield())
	player:SetWalkSpeed(newHero:getSpeed())
	player:SetRunSpeed(newHero:getSpeed() * 2)
	
	for _, v in pairs(newHero:getWeapons()) do
		ply:Give(v)
	end
	
	for _, v in pairs(team.GetPlayers(player:Team())) do
		net.Start("allyChangedHero")
			net.WriteString(player:Nick())
			net.WriteString(newHero:getName())
		net.Send(v)
	end
end)