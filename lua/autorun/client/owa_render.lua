HALO_ALLY_COLOR = Color(0, 145, 255)
HALO_ENEMY_COLOR = Color(255, 0, 0)

hook.Add("PreDrawHalos", "allyHalos", function()
	halo.Add(team.GetPlayers(LocalPlayer():Team()), HALO_ALLY_COLOR, 5, 5, 2)
end)