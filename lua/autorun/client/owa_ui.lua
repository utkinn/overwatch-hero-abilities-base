local showHeroSelectScreen = false

local function createOverwatchFont(size)
	surface.CreateFont('overwatch'..size, {
		font = 'BigNoodleTooOblique',
		size = size
	})
end

createOverwatchFont(60)

function owa_binder(form, text, onChange, initValue)
	local label = vgui.Create("DLabel")
	label:SetText(text)

	local binder = vgui.Create("DBinder")
	binder:SetSize(200, 50)
	if initValue ~= nil then binder:SetValue(initValue) end
	
	function binder:SetSelectedNumber(num)
		self.m_iSelectedNumber = num -- Preserve original functionality
		onChange(num)
	end
	
	form:AddItem(label, binder)
	return binder
end

function addOWASettingsPage(name, class, DFormBuild)
	spawnmenu.AddToolMenuOption("Utilities", "#owa.ui.settings.category", "OWA" .. class, name, nil, nil, DFormBuild) 
end

function addOWAHeroSettingsPage(heroName)
	local hero = HEROES[heroName]
	
	spawnmenu.AddToolMenuOption("Utilities", "#owa.ui.heroSettings.category", "OWAHero:" .. (heroName or "Unknown"), heroName or "Unknown", nil, nil, function(form)
		if not LocalPlayer():IsAdmin() then
			form:Help("#owa.ui.settings.admin.denied")
			return
		end
		form:CheckBox("#owa.ui.settings.hero.adminOnly", "owa_hero." .. removeSpaces(heroName) .. ".adminsOnly")
		for _, ability in pairs(hero.abilities) do
			form:Help(ability.name .. language.GetPhrase("owa.ui.settings.hero.cooldown"))
			form:NumberWang("", "owa_hero_customization." .. removeSpaces(heroName) .. ".ability." .. removeSpaces(ability.name) .. ".cooldown", 0, 100)
		end
		if hero.customSettings ~= nil then
			for _, customSetting in pairs(hero.customSettings) do
				form:NumSlider(customSetting.name, "owa_hero_customization." .. removeSpaces(heroName) .. "." .. customSetting.convar, customSetting.minValue, customSetting.maxValue)
				if customSetting.help then
					form:Help(customSetting.help)
				end
			end
		end
		if hero.ultimate then
			form:Help(hero.ultimate.name .. language.GetPhrase("owa.ui.settings.hero.ultimateChargeMultiplier"))
			form:NumberWang("", "owa_hero_customization." .. removeSpaces(heroName) .. ".ultimate.mult", 0, 100)
		end
	end) 
end

hook.Add("PopulateToolMenu", "populateAbilityBaseMenu", function()
	addOWASettingsPage("#owa.ui.settings.admin", "Admin", function(form)
		form:Help("#owa.ui.settings.admin.heroPlayerProperties")
		form:CheckBox("#owa.ui.settings.admin.heroPlayerProperties.health", "owa_hero_customization_affects_health")
		form:CheckBox("#owa.ui.settings.admin.heroPlayerProperties.armor", "owa_hero_customization_affects_armor")
		form:CheckBox("#owa.ui.settings.admin.heroPlayerProperties.shield", "owa_hero_customization_affects_shield")
		form:CheckBox("#owa.ui.settings.admin.heroPlayerProperties.speed", "owa_hero_customization_affects_speed")
		form:CheckBox("#owa.ui.settings.admin.heroPlayerProperties.weapons", "owa_hero_customization_affects_weapons")
	end)

	addOWASettingsPage("HUD", "HUD", function(form)
		form:CheckBox("#owa.ui.settings.hud.halo.ally", "owa_hud_halos_ally")
		form:CheckBox("#owa.ui.settings.hud.halo.enemy", "owa_hud_halos_ally")
	end)
	
	addOWASettingsPage("#owa.ui.settings.interface", "Interface", function(form)
		languageComboBox = form:ComboBox("#owa.ui.settings.interface.language", "owa_ui_language")
		languageComboBox:AddChoice("English", "en")
		languageComboBox:AddChoice("Русский", "ru")
	end)
	
	addOWASettingsPage("#owa.hero", "Hero", function(form)
		heroComboBox = form:ComboBox("#owa.hero", "owa_hero")
		heroComboBox:AddChoice("none")
		for _, hero in pairs(HEROES) do
			heroComboBox:AddChoice(hero.name)
		end
		-- local hero = HEROES[heroComboBox:GetSelected()]
		-- if hero ~= nil then
			-- form:Help(hero.description)
			-- for id, ability in pairs(hero.abilities) do
				-- form:ControlHelp(language.GetPhrase("owa.ui.settings.controls.castAbility").." #"..id..": "..ability.name)
				-- form:Help(ability.description)
			-- end
			-- form:ControlHelp(language.GetPhrase("owa.ui.settings.controls.castUltimate")..": "..hero.ultimate.name)
			-- form:Help(hero.ultimate.description)
		-- end
		form:CheckBox("#owa.ui.settings.auto_suicide", "owa_suicide_on_hero_change")
	end)
	
	addOWASettingsPage("#owa.controls", "Controls", function(form)
		ability1Binder = owa_binder(form, language.GetPhrase("owa.ui.settings.controls.castAbility") .. " 1", function(num)
			owa_updateKeyBinding("ability1", num)
		end, OWAControls.ability1)
		
		ability2Binder = owa_binder(form, language.GetPhrase("owa.ui.settings.controls.castAbility") .. " 2", function(num)
			owa_updateKeyBinding("ability2", num)
		end, OWAControls.ability2)
		
		ultimateBinder = owa_binder(form, "#owa.ui.settings.controls.castUltimate", function(num)
			owa_updateKeyBinding("ultimate", num)
		end, OWAControls.ultimate)
		
		showHeroSelectScreenBinder = owa_binder(form, "#owa.ui.settings.controls.showHeroSelectScreen", function(num)
			owa_updateKeyBinding("showHeroSelectScreen", num)
		end, OWAControls.showHeroSelectScreen)
	end)
	
	for heroName, _ in pairs(HEROES) do
		addOWAHeroSettingsPage(heroName)
	end
end)

hook.Add('DrawOverlay', 'showHeroSelectScreen', function()
	if not showHeroSelectScreen then return end

	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(0, 0, ScrW(), ScrH())
	
	surface.SetFont('overwatch60')
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(ScrW() * 0.05, ScrH() * 0.05)
	surface.DrawText('#ui.settings.controls.selectHero')
end)

function owa_ui_toggleHeroSelectScreen()
	showHeroSelectScreen = not showHeroSelectScreen
end

net.Receive("allyChangedHero", function()
	chat.AddText(Color(181, 150, 70), net.ReadString() .. language.GetPhrase("owa.ui.chat.allyChangedHero.1") .. net.ReadString() .. ".")
end)