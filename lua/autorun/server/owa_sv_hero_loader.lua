print("OWA Server loader startup")

--Bare files
files, heroModuleDirs = file.Find("overwatchHeroes/*", "LUA")
print("files:")
PrintTable(files)
print("heroModuleDirs:")
PrintTable(heroModuleDirs)

if not table.Empty(files) then
	for _, heroFile in pairs(files) do
		AddCSLuaFile(heroFile)
		include(heroFile)
		
		print("shared: included " .. heroFile)
		print("shared: AddCSLuaFile'd " .. heroFile)
	end
else
	print("No bare hero files found")
end

if not table.Empty(heroModuleDirs) then
	--Module folders
	for _, heroModuleDir in pairs(heroModuleDirs) do
		heroSharedFiles = file.Find(heroModuleDir .. "/*.lua", "LUA")
		print("heroSharedFiles:")
		PrintTable(heroSharedFiles)
		
		if not table.Empty(heroSharedFiles) then
			for _, sharedFile in pairs(heroSharedFiles) do
				AddCSLuaFile(sharedFile)
				include(sharedFile)
				
				print("shared: included " .. sharedFile)
				print("shared: AddCSLuaFile'd " .. sharedFile)
				
				for _, serverFile in pairs(file.Find(heroModuleDir .. "/server/*.lua", "LUA")) do
					include(serverFile)
					print("server: included " .. serverFile)
				end
				for _, clientFile in pairs(file.Find(heroModuleDir .. "/client/*.lua", "LUA")) do
					AddCSLuaFile(serverFile)
					print("client: AddCSLuaFile'd " .. serverFile)
				end
			end
		else
			print(heroModuleDir .. ": no shared files")
		end
	end
else
	print("No hero module folders found")
end