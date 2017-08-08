require("OWAHeroManager")

LANGUAGE = {EN = "en", RU = "ru")

userLanguage = LANGUAGE.EN

function addOWASettingsPage(name, class, DFormBuild)
	spawnmenu.AddToolMenuOption("Utilities", "#owa.ui.settings.category", "OWA"..class, name, nil, nil, DFormBuild) 
end

hook.Add("PopulateToolMenu", "populateAbilityBaseMenu", function()
	addOWASettingsPage("#owa.ui.settings.admin", "AdminSettings", function(form)
		if LocalPlayer():IsAdmin() then
			form:Button("#owa.ui.settings.admin.changePermissions", "owa_ui_permissions")
		else
			form:Help("#owa.ui.settings.admin.denied")
		end
	end)
	
	addOWASettingsPage("HUD", "HUD", function(form)
		form:CheckBox("#owa.ui.settings.hud.halo.ally", "owa_hud_halos_ally")
		form:CheckBox("#owa.ui.settings.hud.halo.enemy", "owa_hud_halos_ally")
	end)
	
	addOWASettingsPage("Inteface", "Interface", function(form)
		languageComboBox = form:ComboBox("#owa.ui.settings.interface.language", "owa_ui_language")
		combobox:AddChoice("English", "en")
		combobox:AddChoice("Русский", "ru")
	end)
end)

permissionEditor_selection_player = nil
permissionEditor_selection_hero = nil

permissionEditor = vgui.Create("DFrame")
permissionEditor:Center()
permissionEditor:SetSize(100, 1000)
permissionEditor:SetTitle("#owa.ui.frame.permission.title")
permissionEditor:SetDraggable(true)

playersList = vgui.Create("DListView", permissionEditor)
playersList:Dock(LEFT)
playersList:SetMultiSelect(false)
playersList:AddColumn("#owa.ui.frame.permission.player")
for _, player in pairs(player.GetAll()) do
	playersList:AddLine(player:Nick())
end
function playersList:OnRowsSelected(index, row)
	permissionEditor_selection_player = player.GetAll()[index]
	--TODO
end

heroList = vgui.Create("DListView", permissionEditor)
heroList:Dock(LEFT)
heroList:SetMultiSelect(false)
heroList:AddColumn("#owa.ui.frame.permission.hero")
for _, hero in pairs(OWAHeroManager.HEROES) do
	playersList:AddLine(hero.name)
end
function playersList:OnRowsSelected(index, row)
	permissionEditor_selection_player = OWAHeroManager.HEROES[index]
	--TODO
end

managementPanel = vgui.Create("DPanel", permissionEditor)
managementPanel:Dock(RIGHT)
--TODO