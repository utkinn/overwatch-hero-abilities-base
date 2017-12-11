surface.CreateFont("OWA", {
    font = "BigNoodleTooOblique",
    size = 64
})

hook.Add("Think", "updateHero", function()
    heroName = LocalPlayer():GetNWString("hero")
end)
    -- local materials = HEROES[LocalPlayer():GetNWString("hero")].materials
    -- PrintTable(materials)
    -- if materials.abilities[1] then
        -- ability1Material = Material(materials.abilities[1])
    -- end
    -- if materials.abilities[2] then
        -- ability2Material = Material(materials.abilities[2])
    -- end
    -- if materials.ultimate then
        -- ultimateMaterial = Material(materials.ultimate)
    -- end
    
TRANSPARENCY = 150

local function getCooldownNWIntKey(id)
    return "cooldown "..id
end

hook.Add("HUDPaint", "DrawOWAAbilitiesHUD", function()
    if LocalPlayer():GetNWString("hero") ~= "none" and heroName ~= "" then
        draw.RoundedBox(8, ScrW() * 0.62, ScrH() * 0.9, ScrW() * 0.2,  ScrH() * 0.09, Color(0, 0, 0, TRANSPARENCY))
        
        local hero = HEROES[LocalPlayer():GetNWString("hero")]
        local materials = hero.materials
        
        if materials.abilities[1] and not isnumber(materials.abilities[1]) and hero.abilities[1] then
            surface.SetMaterial(materials.abilities[1])
            local drawColor
            if LocalPlayer():GetNWInt(getCooldownNWIntKey(1)) ~= 0 then
                drawColor = Color(255, 50, 50, TRANSPARENCY)
                draw.DrawText(LocalPlayer():GetNWInt(getCooldownNWIntKey(1)), "OWA", ScrW() * 0.64, ScrH() * 0.92)
            else
                drawColor = Color(255, 255, 255, TRANSPARENCY)
            end
            surface.SetDrawColor(drawColor)
            surface.DrawTexturedRect(ScrW() * 0.63, ScrH() * 0.92, ScrW() * 0.03,  ScrH() * 0.05)
        end
        
        if materials.abilities[2] and not isnumber(materials.abilities[2]) and hero.abilities[2] then
            surface.SetMaterial(materials.abilities[2])
            local drawColor
            if LocalPlayer():GetNWInt(getCooldownNWIntKey(2)) ~= 0 then
                drawColor = Color(255, 50, 50, TRANSPARENCY)
                draw.DrawText(LocalPlayer():GetNWInt(getCooldownNWIntKey(2)), "OWA", ScrW() * 0.67, ScrH() * 0.92)
            else
                drawColor = Color(255, 255, 255, TRANSPARENCY)
            end
            surface.SetDrawColor(drawColor)
            surface.DrawTexturedRect(ScrW() * 0.67, ScrH() * 0.92, ScrW() * 0.03,  ScrH() * 0.05)
        end
        
        if materials.ultimate and not isnumber(materials.ultimate) and hero.ultimate then
            surface.SetMaterial(materials.ultimate)
            surface.SetDrawColor(Color(255, 255, 255, TRANSPARENCY))
            surface.DrawTexturedRect(ScrW() * 0.67, ScrH() * 0.92, ScrW() * 0.03,  ScrH() * 0.05)
        end
    end
end)

hook.Add("HUDPaint", "DrawShield", function()
    
end)