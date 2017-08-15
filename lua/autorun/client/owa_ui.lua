require("OWAHeroManager")
require("OWAPermissionManager")

function addOWASettingsPage(name, class, DFormBuild)
	spawnmenu.AddToolMenuOption("Utilities", "#owa.ui.settings.category", "OWA" .. class, name, nil, nil, DFormBuild) 
end

function addOWAHeroSettingsPage(name, hero)
	spawnmenu.AddToolMenuOption("Utilities", "#owa.ui.heroSettings.category", "OWAHero:" .. hero:getName(), hero:getName(), nil, nil, function(form)
		--TODO: Hero customization
		for _, ability in pairs(hero.abilities) do
			form:NumberWang(ability.name .. ": cooldown", "owa_hero_customization:" .. hero:getName() .. ".ability:" .. ability.name .. ".cooldown", 0, 100)
		end
		for _, customSetting in pairs(hero.customSettings) do
			form:NumSlider(customSetting.name, "owa_hero_customisation:" .. hero:getName() .. "." .. customSetting.convar, customSetting.minValue, customSetting.maxValue)
			if customSetting.help then
				form:Help(customSetting.help)
			end
		end
		if hero.ultimate then
			form:NumberWang(ability.name .. ": charge multiplier", "owa_hero_customization:" .. hero:getName() .. ".ultimate.mult", 0, 100)
		end
	end) 
end

hook.Add("PopulateToolMenu", "populateAbilityBaseMenu", function()
	-- addOWASettingsPage("#owa.ui.settings.admin", "AdminSettings", function(form)
		-- if LocalPlayer():IsAdmin() then
			-- form:Button("#owa.ui.settings.admin.changePermissions", "owa_ui_permissions")
		-- else
			-- form:Help("#owa.ui.settings.admin.denied")
		-- end
	-- end)
	
	addOWASettingsPage("HUD", "HUD", function(form)
		form:CheckBox("#owa.ui.settings.hud.halo.ally", "owa_hud_halos_ally")
		form:CheckBox("#owa.ui.settings.hud.halo.enemy", "owa_hud_halos_ally")
	end)
	
	addOWASettingsPage("#owa.ui.settings.interface", "Interface", function(form)
		languageComboBox = form:ComboBox("#owa.ui.settings.interface.language", "owa_ui_language")
		combobox:AddChoice("English", "en")
		combobox:AddChoice("Русский", "ru")
	end)
	
	addOWASettingsPage("#hero", "hero", function(form)
		heroComboBox = form:ComboBox("#hero", "owa_hero")
		for _, hero in pairs(OWAHeroManager.HEROES) do
			heroComboBox:AddChoice(hero:getName())
		end
	end)
end)

net.Receive("allyChangedHero", function()
	chat.AddText(Color(181, 150, 70), net.ReadString() .. "#owa.ui.chat.allyChangedHero.1" .. net.ReadString() .. ".")
end)