surface.CreateFont('OWA', {
    font = 'BigNoodleTooOblique',
    size = 64
})

hook.Add('Think', 'updateHero', function()
    heroName = LocalPlayer():GetNWString('hero')
end)
    -- local materials = OWA_HEROES[LocalPlayer():GetNWString('hero')].materials
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

local TRANSPARENCY = 150

local function getCooldownNWIntKey(id)
    return 'cooldown '..id
end

local function isAbilityCoolingDown(id)
    return LocalPlayer():GetNWInt(getCooldownNWIntKey(id)) ~= 0
end

local function drawCooldownCountdown(id, x, y)
    local text = LocalPlayer():GetNWInt(getCooldownNWIntKey(id))
    draw.DrawText(text, 'OWA', x, y)
end

local function setDrawingColor(id)
    local drawColor

    if isAbilityCoolingDown(id) then
        drawColor = Color(255, 50, 50, TRANSPARENCY)
    else
        drawColor = Color(255, 255, 255, TRANSPARENCY)
    end

    surface.SetDrawColor(drawColor)
end

local function drawAbilityIcon(id, hero, x, y, width, heigth, cooldownTextX, cooldownTextY)
    local material = hero.materials.abilities[id]
    local iconMaterialIsValid = material and not isnumber(material) and hero.abilities[id]

    if not iconMaterialIsValid then return end

    surface.SetMaterial(material)
    setDrawingColor(id)
    if isAbilityCoolingDown(id) then
        drawCooldownCountdown(id, cooldownTextX, cooldownTextY)
    end
    surface.DrawTexturedRect(x, y, width, heigth)
end

hook.Add('HUDPaint', 'Draw OWA abilities HUD', function()
    if LocalPlayer():GetNWString('hero') == 'none' or heroName == '' then return end

    draw.RoundedBox(8, ScrW() * 0.62, ScrH() * 0.9, ScrW() * 0.2,  ScrH() * 0.09, Color(0, 0, 0, TRANSPARENCY))

    local hero = OWA_HEROES[LocalPlayer():GetNWString('hero')]
    local materials = hero.materials

    drawAbilityIcon(1, hero, ScrW() * 0.63, ScrH() * 0.92, ScrW() * 0.03,  ScrH() * 0.05, ScrW() * 0.64, ScrH() * 0.92)
    drawAbilityIcon(2, hero, ScrW() * 0.67, ScrH() * 0.92, ScrW() * 0.03,  ScrH() * 0.05, ScrW() * 0.67, ScrH() * 0.92)

    -- TODO: Refactor
    if materials.ultimate and not isnumber(materials.ultimate) and hero.ultimate then
        surface.SetMaterial(materials.ultimate)
        surface.SetDrawColor(Color(255, 255, 255, TRANSPARENCY))
        surface.DrawTexturedRect(ScrW() * 0.67, ScrH() * 0.92, ScrW() * 0.03,  ScrH() * 0.05)
    end
end)

hook.Add('HUDPaint', 'DrawShield', function()
    --TODO
end)
