module("OWAHeroManager", package.seeall)

-- function OWAHeroManager.getHeroByName(name)
	-- for _, hero in pairs(OWAHeroManager.HEROES) do
		-- if hero:getName() == name then
			-- return hero
		-- end
	-- end
-- end

function OWAHeroManager.setPlayerHero(player, hero)
	if hero:getName() == "none" then return end
	player:SetNWString("hero", hero:getName())
	
	player:SetMaxHealth(hero:getHealth())
	player:SetHealth(hero:getHealth())
	player:SetMaxArmor(hero:getArmor())
	player:SetArmor(hero:getArmor())
	player:SetNWInt("shield", hero:getShield())
	player:SetWalkSpeed(hero:getSpeed())
	player:SetRunSpeed(hero:getSpeed() * 2)
	
	for _, weapon in pairs(hero:getWeapons()) do
		player:Give(weapon)
	end
	
	for _, broadcastTarget in pairs(team.GetPlayers(player:Team())) do
		net.Start("allyChangedHero")
			net.WriteString(player:Nick())
			net.WriteString(hero:getName())
		net.Send(broadcastTarget)
	end
end