function add(code, en, ru)
	if userLanguage == "en" then
		language.Add(code, en)
	elseif userLanguage == "ru" then
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

add("owa.consoleHelp.owa_hud_halos_ally",
"Whether to draw ally halos.")

add("owa.consoleHelp.owa_hud_halos_enemy",
"Whether to draw enemy halos.")

add("owa.consoleHelp.owa_suicide_on_hero_change",
"Automatically suicide on hero change.")

add("owa.consoleHelp.owa_hero",
"Change your current hero.")

add("owa.consoleHelp.owa_ui_language",
"Your addon interface language. Changing it will require reconnecting.")

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

add("owa.ui.chat.respawnRequired",
"You will change your hero on next respawn.")

add("owa.ui.chat.allyChangedHero.1",
" switched to ")

add("owa.ui.chat.allyChangedHero.2",
" (was ")

add("player",
"Player")

add("hero",
"Hero")

add("owa.ui.settings.interface",
"Interface")

add("owa.ui.frame.permission.all.disable",
"Disable everything")

add("owa.ui.frame.permission.all.enable",
"Enable everything")

add("owa.ui.frame.permission.player.restrictAllHeroes",
"Restrict all heroes to player")

add("owa.ui.frame.permission.player.allowAllHeroes",
"Allow all heroes to player")

add("owa.ui.frame.permission.hero.restrictToAllPlayers",
"Restrict this hero to all players")

add("owa.ui.frame.permission.hero.allowToAllPlayers",
"Allow this hero to all players")