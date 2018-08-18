local nextHeroSelectScreenToggleTime = 0
local heroSelectScreen = nil

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
    local y = ScrH() * 0.15

    local function attachHeroListItem(hero)
        print('hey')
        local item = vgui.Create('DButton', root)
        item:SetFont('OWA Futura 24')
        item:SetText(hero.name or 'Unknown')

        item:SetPos(ScrW() * 0.15, y)

        local X_SIZE, Y_SIZE = ScrW() * 0.2, ScrH() * 0.07
        item:SetSize(X_SIZE, Y_SIZE)

        -- TODO

        y = y + Y_SIZE
    end

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
        heroSelectScreen = nil
    end
    nextHeroSelectScreenToggleTime = RealTime() + 0.25
end
