local shouldShowHeroSelectScreen = false

function OWA_toggleHeroSelectScreen()
    if RealTime() < nextHeroSelectScreenToggleTime then return end

    shouldShowHeroSelectScreen = not shouldShowHeroSelectScreen
    nextHeroSelectScreenToggleTime = RealTime() + 0.25
    net.QuickMsg('OWA: Hero select menu entered/exited', shouldShowHeroSelectScreen)

    gui.EnableScreenClicker(shouldShowHeroSelectScreen)

end

hook.Add('DrawOverlay', 'Show Hero Select screen', function()
    if not shouldShowHeroSelectScreen then return end

    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 0, ScrW(), ScrH())

    surface.SetFont('overwatch60')
    surface.SetTextColor(255, 255, 255, 255)
    surface.SetTextPos(ScrW() * 0.05, ScrH() * 0.05)
    surface.DrawText('#owa.ui.settings.controls.selectHero')
end)

hook.Add('Think', 'Handle Hero Select screen clicks', function()
    if not shouldShowHeroSelectScreen or not input.WasMousePressed(MOUSE_LEFT) then return end

    -- TODO
end)
