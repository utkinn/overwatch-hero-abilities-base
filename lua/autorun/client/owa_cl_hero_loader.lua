print("owa_cl_hero_loader")

--Loading clientside files
for _, v in pairs(file.Find("overwatchHeroes/*/client", "LUA")) do
	include(v)
end

--Loading shared files
for _, v in pairs(file.Find("overwatchHeroes/*/", "LUA")) do
	include(v)
end