if LocalPlayer():GetNWString("hero") ~= "none" and LocalPlayer():GetNWString("hero") ~= nil and LocalPlayer():GetNWString("hero") ~= "" then
	local abilityMaterials = HEROES[LocalPlayer():GetNWString("hero")].abilityMaterials
	local ability1Material = Material(abilityMaterials[1])
	local ability2Material = Material(abilityMaterials[2])
	local ultimateMaterial = Material(HEROES[LocalPlayer():GetNWString("hero")].ultimateMaterial)
	
	TRANSPARENCY = 100
	
	hook.Add("HUDPaint", "DrawOWAHUD", function()
		draw.RoundedBox(4, ScrW() * 0.65, ScrH() * 0.9, ScrW() * 0.2,  ScrH() * 0.1, Color(0, 0, 0, TRANSPARENCY))
		surface.SetMaterial(ability1Material)
		surface.SetDrawColor(LocalPlayer():GetNWInt("Cooldown; hero:" .. hero.name .. " ability:" .. HEROES[LocalPlayer():GetNWString("hero")].ability[1].name)
			and Color(255, 100, 100, TRANSPARENCY) or Color(255, 255, 255, TRANSPARENCY))
		surface.DrawTexturedRect(ScrW() * 0.67, ScrH() * 0.92, ScrW() * 0.05,  ScrH() * 0.05)
		
		surface.SetMaterial(ability2Material)
		surface.SetDrawColor(LocalPlayer():GetNWInt("Cooldown; hero:" .. hero.name .. " ability:" .. HEROES[LocalPlayer():GetNWString("hero")].ability[2].name)
			and Color(255, 100, 100, TRANSPARENCY) or Color(255, 255, 255, TRANSPARENCY))
		surface.DrawTexturedRect(ScrW() * 0.69, ScrH() * 0.92, ScrW() * 0.05,  ScrH() * 0.05)
		
		surface.SetMaterial(ultimateMaterial)
		surface.SetDrawColor(Color(255, 255, 255, TRANSPARENCY))
		surface.DrawTexturedRect(ScrW() * 0.71, ScrH() * 0.92, ScrW() * 0.05,  ScrH() * 0.05)
	end)
end