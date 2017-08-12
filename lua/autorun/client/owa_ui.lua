require("OWAHeroManager")
require("OWAPermissionManager")

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
	
	addOWASettingsPage("#owa.ui.settings.interface", "Interface", function(form)
		languageComboBox = form:ComboBox("#owa.ui.settings.interface.language", "owa_ui_language")
		combobox:AddChoice("English", "en")
		combobox:AddChoice("Русский", "ru")
	end)
	
	addOWASettingsPage("#hero", "Hero", function(form)
		heroComboBox = form:ComboBox("#hero", "owa_hero")
		for _, hero in pairs(OWAHeroManager.HEROES)
			heroComboBox:AddChoice(hero:getName())
		end
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
playersList:AddColumn("#player")
for _, player in pairs(player.GetAll()) do
	playersList:AddLine(player:Nick())
end
function playersList:OnRowsSelected(index, row)
	--permissionEditor_selection_player = player.GetAll()[index]
	--TODO
end

heroList = vgui.Create("DListView", permissionEditor)
heroList:Dock(LEFT)
heroList:SetMultiSelect(false)
heroList:AddColumn("#hero")
for _, hero in pairs(OWAHeroManager.HEROES) do
	playersList:AddLine(hero.name)
end
function playersList:OnRowsSelected(index, row)
	permissionEditor_selection_hero = OWAHeroManager.HEROES[index]
	--TODO
end

selectionMode = vgui.Create("DComboBox", permissionEditor)
selectionMode:Dock(TOP)
selectionMode:AddChoice("All")
selectionMode:AddChoice("Player")
selectionMode:AddChoice("Hero")
selectionMode:AddChoice("Player & Hero")
selectionMode:ChooseOptionID(1)
function selectionMode:OnSelect(index, value)
	managementPanel:Clear()
	if index == 1 then
		local disableButton = vgui.Create("DButton")
		restrictAllHeroesButton:SetText("#owa.ui.frame.permission.all.disable")
		restrictAllHeroesButton.DoClick = function()
			OWAPermissionManager.setHeroPermission(player.GetAll(), OWAHeroManager.HEROES, false)
		end
		
		local disableButton = vgui.Create("DButton")
		restrictAllHeroesButton:SetText("#owa.ui.frame.permission.all.enable")
		restrictAllHeroesButton.DoClick = function()
			OWAPermissionManager.setHeroPermission(player.GetAll(), OWAHeroManager.HEROES, true)
		end
	elseif index == 2 then	--Mode: Player
		local restrictAllHeroesButton = vgui.Create("DButton")
		restrictAllHeroesButton:SetText("#owa.ui.frame.permission.player.restrictAllHeroes")
		restrictAllHeroesButton.DoClick = function()
			OWAPermissionManager.setHeroPermission(Player(playersList:GetSelectedLine()), OWAHeroManager.HEROES, false)
		end
		
		local allowAllHeroesButton = vgui.Create("DButton")
		allowAllHeroesButton:SetText("#owa.ui.frame.permission.player.allowAllHeroes")
		restrictAllHeroesButton.DoClick = function()
			OWAPermissionManager.setHeroPermission(Player(playersList:GetSelectedLine()), OWAHeroManager.HEROES, true)
		end
	elseif index == 3 then	--Mode: Hero
		local restrictToAllPlayersButton = vgui.Create("DButton")
		restrictToAllPlayersButton:SetText("#owa.ui.frame.permission.hero.restrictToAllPlayers")
		restrictToAllPlayersButton.DoClick = function()
			for _, vPlayer in pairs(player.GetAll()) do
				if not vPlayer:IsAdmin() then
					OWAPermissionManager.setHeroPermission(vPlayer, OWAHeroManager.HEROES[playersList:GetSelectedLine()], false)
				end
			end
		end
		
		local allowToAllPlayersButton = vgui.Create("DButton")
		restrictToAllPlayersButton:SetText("#owa.ui.frame.permission.hero.allowToAllPlayers")
		restrictToAllPlayersButton.DoClick = function()
			for _, vPlayer in pairs(player.GetAll()) do
				if not vPlayer:IsAdmin() then
					OWAPermissionManager.setHeroPermission(vPlayer, OWAHeroManager.HEROES[playersList:GetSelectedLine()], true)
				end
			end
		end
	elseif mode == 4 then	--Mode: Player & HEROES
		
	end
end

managementPanel = vgui.Create("DPanel", permissionEditor)
managementPanel:Dock(RIGHT)
