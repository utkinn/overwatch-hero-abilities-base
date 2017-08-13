include("classes/OverwatchHero.lua")
include("classes/OverwatchAbility.lua")

util.AddNetworkString("allyChangedHero")
util.AddNetworkString("abilityCastRequest")
util.AddNetworkString("abilityCastSuccess")

hook.Add("PlayerSpawn", "setHero", function(player)
	OWAHeroManager.setPlayerHero(player, OWAHeroManager.HEROES[player:GetInfo("owa_hero")])
end)

--TODO: Shield

net.Receive("abilityCastRequest", function(_, player)
	--TODO: Permissions
	local heroName = player:GetNWString("hero")
	local hero = OWAHeroManager.HEROES[heroName]
	
	hero:getAbility(net.ReadUInt(3)):cast(player)
end)