local nextHeroSelectScreenToggleTime = 0
local heroSelectScreen = nil
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

local function attachHeroList(root)
    local y = ScrH() * 0.2

    local function attachItem(text, clickHandler, picture, picColor)
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

        y = y + Y_SIZE + ScrH() * 0.002
    end

    local function attachHeroListItem(hero)
        local name = hero.name or 'Unknown'
        attachItem(name, function()
            GetConVar('owa_hero'):SetString(name)
            root:Close()
        end, hero.portrait or UNKNOWN_HERO_ICON, Color(255, 255, 255, 220))
    end

    attachItem('None', function()
        GetConVar('owa_hero'):SetString('none')
        root:Close()
    end, NONE_HERO_ICON, Color(255, 50, 50, 220))

    for _, v in pairs(OWA_HEROES) do
        attachHeroListItem(v)
    end
end

local function createHeroSelectScreen()
    local root = createRoot()

    attachSelectHeroLabel(root)
    attachHeroList(root)

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
