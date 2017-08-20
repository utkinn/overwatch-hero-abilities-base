phrases =
{
	["consoleHelp.owa_ui_hero.invalid"] = {"Invalid hero!", "Неверный герой!"},
	["ui.settings.category"] = {"Overwatch Abilities Settings: General", "Настройки Способностей Overwatch: Главные"},
	["consoleHelp.owa_hud_halos_ally"] = {"Whether to draw ally halos.", "Подсвечивать союзников."},
	["consoleHelp.owa_hud_halos_enemy"] = {"Whether to draw enemy halos.", "Подсвечивать врагов."},
	["consoleHelp.owa_suicide_on_hero_change"] = {"Automatically suicide on hero change.", "Автоматически возродиться при смене героя."},
	["consoleHelp.owa_hero"] = {"Change your current hero.", "Сменить героя."},
	["consoleHelp.owa_ui_language"] = {"Your addon interface language. Changing it will require reconnecting.", "Язык дополнения. Для изменения потребуется переподключение к серверу."},
	["ui.settings.admin"] = {"Admin Settings", "Настройки для администраторов"},
	["ui.settings.admin.denied"] = {"You need the admin privilegies to watch and change these settings.", "Вам нужно иметь права администратора для изменения этих настроек."},
	["ui.settings.hud.halo.ally"] = {"Ally halos", "Подсветка союзников"},
	["ui.settings.hud.halo.enemy"] = {"Enemy halos", "Подсветка врагов"},
	["ui.settings.auto_suicide"] = {"Suicide on change", "Возродиться при смене"},
	["ui.chat.respawnRequired"] = {"You will change your hero on next respawn.", "Вы смените героя при следующем возрождении."},
	["ui.chat.allyChangedHero.1"] = {" switched to "},
	["ui.chat.allyChangedHero.2"] = {" (was "},
	["player"] = {"Player", "Игрок"},
	["hero"] = {"Hero", "Герой"},
	["ui.settings.interface"] = {"Interface", "Интерфейс"},
	["ui.settings.interface.language"] = {"Language", "Язык"},
	["ui.heroSettings.category"] = {"Overwatch Abilities Settings: Heroes", "Настройки Способностей Overwatch: Герои"},
	["controls"] = {"Controls", "Управление"},
	--[[["consoleHelp.owa_hero_adminOnly.1"] = {"Restrict ", "Запретить играть за героя \""},
	["consoleHelp.owa_hero_adminOnly.2"] = {" for regular players.", "\" обычным игрокам."},--]]
	["ui.settings.admin.heroPlayerProperties"] = {"Selected hero affects...", "Выбранный герой влияет на..."},
	["ui.settings.admin.heroPlayerProperties.health"] = {"...health", "...здоровье"},
	["ui.settings.admin.heroPlayerProperties.armor"] = {"...armor", "...броню"},
	["ui.settings.admin.heroPlayerProperties.shield"] = {"...shield", "...щит"},
	["ui.settings.admin.heroPlayerProperties.speed"] = {"...movement speed", "...скорость передвижения"},
	["ui.settings.admin.heroPlayerProperties.weapons"] = {"...weapons", "...оружие"},
	--[[["consoleHelp.heroPlayerProperties.health"] = {"Does selected hero affects players' health?", "Влияет ли выбранный герой на здоровье?"},
	["consoleHelp.heroPlayerProperties.armor"] = {"Does selected hero affects players' armor?", "Влияет ли выбранный герой на броню?"},
	["consoleHelp.heroPlayerProperties.shield"] = {"Does selected hero affects players' shield?", "Влияет ли выбранный герой на щит?"},
	["consoleHelp.heroPlayerProperties.speed"] = {"Does selected hero affects players' movement speed?", "Влияет ли выбранный герой на скорость?"},
	["consoleHelp.heroPlayerProperties.weapons"] = {"Does selected hero affects players' speed?", "Влияет ли выбранный герой на оружия?"}--]]
	["ui.settings.controls.castAbility"] = {"Cast ability ", "Использовать способность "},
	["ui.settings.controls.castUltimate"] = {"Cast ultimate", "Использовать суперспособность"}
}

local userLanguage = GetConVar("owa_ui_language"):GetString()
for code, phrasesTable in pairs(phrases) do
	for _, vPhrase in pairs(phrasesTable) do
		if userLanguage == "en" then
			language.Add("owa." .. code, phrasesTable[1])
		elseif userLanguage == "ru" then
			language.Add("owa." .. code, phrasesTable[2] and phrasesTable[2] or phrasesTable[1])
		end
	end
end