module("OWAPermissionManager", package.seeall)

function OWAPermissionManager:setHeroPermission(player, hero, allow)
	if istable(player) then
		if istable(hero) then
			for _, vPlayer in pairs(player) do
				for _, vHero in pairs(hero) do
					--TODO
				end
			end
		else
			for _, vPlayer in pairs(player) do
				--TODO
			end
		end
	else
		if istable(hero) then
			for _, vHero in pairs(hero) do
				--TODO
			end
		else
			--TODO
		end
	end
end