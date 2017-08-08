module("OWAHeroManager", package.seeall)

OWAHeroManager.HEROES = {}

function OWAHeroManager.getHeroByName(name)
	for _, hero in pairs(OWAHeroManager.HEROES) do
		if hero:getName() == name then
			return hero
		end
	end
end
-- function OWAHeroManager.getHeroeslist()
	-- return 
-- end