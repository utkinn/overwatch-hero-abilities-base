local nextHeroSelectScreenToggleTime = 0
local heroSelectScreen = nil
-- local heroInfoPanel = nil
local NONE_HERO_ICON = Material('none.png', 'noclamp smooth')
local UNKNOWN_HERO_ICON = Material('unknown.png', 'noclamp smooth')

local function createRoot()
    local root = vgui.Create('DFrame')
    root:SetTitle('')
    root:SetPos(0, 0)
    root:SetSize(ScrW(), ScrH())
    root:SetDraggable(false)
    root:SetSizable(false)

    function root:Paint(width, height)
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(0, 0, width, height)
    end

    return root
end

local function attachSelectHeroLabel(root)
    local selectHeroLabel = vgui.Create('DLabel', root)
    selectHeroLabel:SetText('')
    selectHeroLabel:SetSize(700, 500)

    function selectHeroLabel:Paint(width, height)
        surface.SetFont('OWA BigNoodleToo 128')
        surface.SetTextColor(255, 255, 255, 255)
        surface.SetTextPos(width * 0.05, height * 0.05)
        surface.DrawText('#owa.ui.settings.controls.selectHero')
    end
end

local function attachHeroList(root, info)
    local y = ScrH() * 0.2

    local function attachItem(hero)
        local text, clickHandler, picture, picColor
        if hero == nil then
            text = 'None'
            clickHandler = function()
                GetConVar('owa_hero'):SetString('none')
                root:Close()
            end
            picture = NONE_HERO_ICON
            picColor = Color(255, 50, 50, 220)
        else
            text = hero.name or 'Unknown'
            clickHandler = function()
                GetConVar('owa_hero'):SetString(name)
                root:Close()
            end
            picture = hero.materials.portrait or UNKNOWN_HERO_ICON
            picColor = Color(255, 255, 255, 220)
        end

        local item = vgui.Create('DButton', root)
        -- item:SetFont('OWA Futura 24')
        item:SetText('')

        item:SetPos(ScrW() * 0.05, y)

        local X_SIZE, Y_SIZE = ScrW() * 0.2, ScrH() * 0.06
        item:SetSize(X_SIZE, Y_SIZE)

        function item:Paint(width, height)
            surface.SetDrawColor(0, 0, 0, 220)
            surface.DrawRect(0, 0, width, height)

            surface.SetDrawColor(200, 200, 200, 220)
            surface.DrawOutlinedRect(0, 0, width, height)

            draw.DrawText(text, 'OWA Futura 24', width / 2, height / 2 - ScrH() * 0.011, Color(255, 255, 255, 220),
                          TEXT_ALIGN_CENTER)

            surface.SetDrawColor(picColor)
            surface.SetMaterial(picture)
            surface.DrawTexturedRect(ScrH() * 0.005, ScrH() * 0.005, ScrH() * 0.05, ScrH() * 0.05)
        end

        item.DoClick = clickHandler

        function item:OnCursorEntered()
            info:showHeroData(hero)
        end

        function item:OnCursorExited()
            info:SetVisible(false)
        end

        y = y + Y_SIZE + ScrH() * 0.002
    end

    attachItem()

    for _, v in pairs(OWA_HEROES) do
        attachItem(v)
    end
end

local function attachHeroInfo(root)
    local info = vgui.Create('DPanel', root)
    info:SetPos(ScrW() * 0.3, ScrH() * 0.2)
    info:SetSize(ScrW() * 0.5, ScrH() * 0.7)

    function info:Paint(width, height) end

    local heroNameLabel = vgui.Create('DLabel', info)
    heroNameLabel:SetText('')
    heroNameLabel:SetFont('OWA BigNoodleToo 64')
    heroNameLabel:SetTextColor(Color(255, 255, 255, 255))
    heroNameLabel:SetPos(0, 0)
    heroNameLabel:SetSize(700, 500)
    heroNameLabel:SetContentAlignment(7)
    -- function heroNameLabel:Paint(width, height)
    --     surface.SetTextColor(255, 255, 255, 255)
    --     surface.SetTextPos(width * 0.0, height * 0.0)
    --     surface.DrawText('Tracer')
    -- end

    local sketch = vgui.Create('DPanel', info)
    sketch:SetPos(0, 75)
    sketch:SetSize(200, 400)
    function sketch:Paint(width, height)
        if self.material == nil then return end
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(self.material)
        surface.DrawTexturedRect(0, 0, width, height)
    end

    local description = vgui.Create('DLabel', info)
    description:SetText('')
    description:SetFont('OWA Futura 24')
    description:SetPos(200, 75)
    description:SetSize(800, 1500)
    description:SetWrap(true)
    description:SetContentAlignment(7)

    function info:showHeroData(hero)
        if hero == nil then return end
        heroNameLabel:SetText(hero.name)
        sketch.material = hero.materials.sketch

        local descriptionText = hero.description..'\n\n\n'
        for _, ability in pairs(hero.abilities) do
            descriptionText = descriptionText..'Ability "'..ability.name..'"\n\n'..ability.description..'\n\n'
        end
        descriptionText = descriptionText
                              ..'Ultimate Ability "'..hero.ultimate.name
                              ..'"\n\n'..hero.ultimate.description
        description:SetText(descriptionText)

        self:SetVisible(true)
    end

    return info
end

local function createHeroSelectScreen()
    local root = createRoot()

    attachSelectHeroLabel(root)
    local info = attachHeroInfo(root)
    attachHeroList(root, info)

    return root
end

function OWA_toggleHeroSelectScreen()
    if RealTime() < nextHeroSelectScreenToggleTime then return end

    if not IsValid(heroSelectScreen) then
        heroSelectScreen = createHeroSelectScreen()
        heroSelectScreen:MakePopup()
    else
        heroSelectScreen:Close()
    end
    nextHeroSelectScreenToggleTime = RealTime() + 0.25
end
