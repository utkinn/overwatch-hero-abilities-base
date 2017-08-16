print("OWA Client loader startup")

--Bare files
files, heroModuleDirs = file.Find("overwatchHeroes/*", "LUA")
print("files:")
PrintTable(files)
print("heroModuleDirs:")
PrintTable(heroModuleDirs)

if not table.Empty(files) then
	for _, heroFile in pairs(files) do
		include(heroFile)
		
		print("shared: included " .. heroFile)
	end
else
	print("No bare hero files found")
end

if not table.Empty(heroModuleDirs) then
	--Module folders
	for _, heroModuleDir in pairs(heroModuleDirs) do
		heroSharedFiles = file.Find(heroDir .. "/*.lua", "LUA")
		print("heroSharedFiles:")
		PrintTable(heroSharedFiles)
		
		for _, sharedFile in pairs(heroSharedFiles) do
			include(sharedFile)
			
			print("shared: included " .. sharedFile)
			
			for _, clientFile in pairs(file.Find(heroModuleDir .. "/client/*.lua", "LUA")) do
				include(clientFile)
				print("client: included " .. clientFile)
			end
		end
	end
else
	print("No hero module folders found")
end