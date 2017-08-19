function binder(form, text, onChange, initValue)
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
	
	spawnmenu.AddToolMenuOption("Utilities", "#owa.ui.heroSettings.category", "OWAHero:" .. (hero.name or "Unknown"), hero.name or "Unknown", nil, nil, function(form)
		if LocalPlayer():IsAdmin() then
			for _, ability in pairs(hero.abilities) do
				form:NumberWang(ability.name .. ": cooldown", "owa_hero_customization." .. removeSpaces(hero.name) .. ".ability." .. removeSpaces(ability.name) .. ".cooldown", 0, 100)
			end
			if hero.customSettings ~= nil then
				for _, customSetting in pairs(hero.customSettings) do
					form:NumSlider(customSetting.name, "owa_hero_customisation." .. removeSpaces(hero.name) .. "." .. customSetting.convar, customSetting.minValue, customSetting.maxValue)
					if customSetting.help then
						form:Help(customSetting.help)
					end
				end
			end
			if hero.ultimate then
				form:Help(hero.ultimate.name .. ": charge multiplier")
				form:NumberWang("", "owa_hero_customization." .. removeSpaces(hero.name) .. ".ultimate.mult", 0, 100)
			end
		else
			form:Help("#ui.settings.admin.denied")
		end
	end) 
end

hook.Add("PopulateToolMenu", "populateAbilityBaseMenu", function()
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
		form:CheckBox("#owa.ui.settings.auto_suicide", "owa_suicide_on_hero_change")
	end)
	
	addOWASettingsPage("#owa.controls", "Controls", function(form)
		ability1Binder = binder(form, language.GetPhrase("owa.ui.settings.controls.castAbility") .. " 1", function(num)
			updateKeyBinding("ability1", num)
		end, controls.ability1)
		ability2Binder = binder(form, language.GetPhrase("owa.ui.settings.controls.castAbility") .. " 2", function(num)
			updateKeyBinding("ability2", num)
		end, controls.ability2)
		ultimateBinder = binder(form, "#owa.ui.settings.controls.castUltimate", function(num)
			updateKeyBinding("ultimate", num)
		end, controls.ultimate)
	end)
	
	for heroName, _ in pairs(HEROES) do
		addOWAHeroSettingsPage(heroName)
	end
end)

net.Receive("allyChangedHero", function()
	chat.AddText(Color(181, 150, 70), net.ReadString() .. language.GetPhrase("owa.ui.chat.allyChangedHero.1") .. net.ReadString() .. ".")
end)