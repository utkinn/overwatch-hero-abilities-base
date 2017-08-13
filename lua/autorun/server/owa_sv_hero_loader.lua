--Loading serverside files
for _, v in pairs(file.Find("overwatchHeroes/*/server", "LUA")) do
	include(v)
end

--AddCSLuaFile'ing clientside files
for _, v in pairs(file.Find("overwatchHeroes/*/client", "LUA")) do
	AddCSLuaFile(v)
end

--Including and AddCSLuaFile'ing shared files
for _, v in pairs(file.Find("overwatchHeroes/*/", "LUA")) do
	AddCSLuaFile(v)
	include(v)
end