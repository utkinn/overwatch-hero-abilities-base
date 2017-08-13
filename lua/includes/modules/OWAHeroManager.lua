module("OWAHeroManager", package.seeall)

OWAHeroManager.HEROES = {}

function OWAHeroManager.getHeroByName(name)
	for _, hero in pairs(OWAHeroManager.HEROES) do
		if hero:getName() == name then
			return hero
		end
	end
end

function OWAHeroManager.setPlayerHero(player, hero)
	player:SetNWString("hero", hero:getName())
	
	player:SetMaxHealth(hero:getHealth())
	player:SetHealth(hero:getHealth())
	player:SetMaxArmor(hero:getArmor())
	player:SetArmor(hero:getArmor())
	player:SetNWInt("shield", hero:getShield())
	player:SetWalkSpeed(hero:getSpeed())
	player:SetRunSpeed(hero:getSpeed() * 2)
	
	for _, v in pairs(hero:getWeapons()) do
		player:Give(v)
	end
	
	for _, v in pairs(team.GetPlayers(player:Team())) do
		net.Start("allyChangedHero")
			net.WriteString(player:Nick())
			net.WriteString(hero:getName())
		net.Send(v)
	end
end