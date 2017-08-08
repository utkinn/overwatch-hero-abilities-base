require("OWAHeroManager")

function addOWASettingsPage(name, class, DFormBuild)
	spawnmenu.AddToolMenuOption("Utilities", "Overwatch Abilities", class, name, nil, nil, DFormBuild) 
end

hook.Add("PopulateToolMenu", "populateAbilityBaseMenu", function()
	addOWASettingsPage("Admin Settings", "OWAAdminSettings", function(form)
		if LocalPlayer():IsAdmin() then
			form:Button("Change hero permissions", "owa_ui_permissions")
			form:CheckBox("Ally halos", "owa_hud_halos_ally")
			form:CheckBox("Enemy halos", "owa_hud_halos_ally")
		else
			form:Help("You need the admin privilegies to watch and change these settings.")
		end
	end)
end)

permissionEditor_selection_player = nil
permissionEditor_selection_hero = nil

permissionEditor = vgui.Create("DFrame")
permissionEditor:Center()
permissionEditor:SetSize(100, 1000)
permissionEditor:SetTitle("Permissions")
permissionEditor:SetDraggable(true)

playersList = vgui.Create("DListView", permissionEditor)
playersList:Dock(LEFT)
playersList:SetMultiSelect(false)
playersList:AddColumn("Player")
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
heroList:AddColumn("Hero")
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