function add(code, en, ru)
	if userLanguage == LANGUAGE.EN then
		language.Add(code, en)
	elseif userLanguage == LANGUAGE.RU then
		if ru then
			language.Add(code, ru)
		else
			language.Add(code, en)
		end
	end
end

add("owa.consoleHelp.owa_ui_permissions",
"Open the permission window.")

add("owa.consoleHelp.owa_ui_hero.invalid",
"Invalid hero!")

add("owa.ui.settings.category",
"Overwatch Abilities Settings")

--add(, )
add("owa.consoleHelp.owa_hud_halos_ally",
"Whether to draw ally halos.")

add("owa.consoleHelp.owa_hud_halos_enemy",
"Whether to draw enemy halos.")

add("owa.consoleHelp.owa_hero",
"Change your current hero.")

add("owa.ui.settings.admin",
"Admin Settings")

add("owa.ui.settings.admin.changePermissions",
"Change hero permissions")

add("owa.ui.settings.admin.denied",
"You need the admin privilegies to watch and change these settings.")

add("owa.ui.settings.hud.halo.ally",
"Ally halos")

add("owa.ui.settings.hud.halo.enemy",
"Enemy halos")

add("owa.ui.frame.permission.title",
"Permissions")

add("owa.ui.frame.permission.player",
"Player")

add("owa.ui.frame.permission.hero",
"Hero")