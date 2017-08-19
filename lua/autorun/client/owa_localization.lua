phrases =
{
	consoleHelp =
	{
		hero = {"Change your current hero.", "Сменить героя."},
		hero_invalid = {"Invalid hero!", "Неверный герой!"},
		hud_halos_ally = {"Draw halos on allies.", "Подсвечивать союзников."},
		hud_halos_enemy = {"Draw halos on enemies.", "Подсвечивать врагов."},
		suicide_on_hero_change = {"Automatically suicide on hero change.", "Автоматически возродиться при смене героя."}
		ui_language = {"Your addon interface language. Changing it will require reconnecting.", "Язык дополнения. Для изменения потребуется переподключение к серверу."}
	}
	ui =
	{
		settings =
		{
			category = {"Overwatch Abilities Settings: General", "Настройки Способностей Overwatch: Главные"}
			admin =
			{
				list = {"Admin Settings", "Настройки для администраторов"}
				denied = {"You need the admin privilegies to watch and change these settings.", "Вам нужно иметь права администратора для изменения этих настроек."}
			}
			hud =
			{
				halo =
				{
					ally = {"Ally halos", "Подсветка союзников"},
					enemy = {"Enemy halos", "Подсветка врагов"}
				}
			}
			autoSuicide = {"Suicide on hero change", "Возродиться при смене героя"}
			interface =
			{
				list = {"Interface", "Интерфейс"},
				language = {"Language", "Язык"}
			}
			heroSettings = {"Overwatch Abilities Settings: Heroes", "Настройки Способностей Overwatch: Герои"}
			controls = {"Controls", "Управление"}
		}
		chat =
		{
			respawnRequired = {"You will change your hero on next respawn.", "Вы смените героя при следующем возрождении."}
			allyChangedHero = {{" switched to "}, {" (was "}}
		}
		player = {"Player", "Игрок"}
		hero = {"Hero", "Герой"}
	}
}

local userLanguage = GetConVar("owa_ui_language"):GetString()

previousKeysBefore = ""
previousKeys = ""

function inflateLanguageTable(langTable)
	for k, v in pairs(langTable) do
		if isstring(v[1]) then
			addPhrase(previousKeys .. "." .. k, v)
		else
			previousKeysBefore = previousKeys
			previousKeys = previousKeys .. "." .. k
			inflateLanguageTable(v)
			previousKeys = previousKeysBefore
		end
	end
end

function addPhrase(k, v)
	if userLanguage == "en" then
		language.Add("owa." .. k, v[1])
	elseif userLanguage == "ru" then
		language.Add("owa." .. k, v[2] and v[2] or v[1])
	end
end
