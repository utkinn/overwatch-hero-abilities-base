include 'owa_shared_console_commands.lua'
include 'claf.lua'

-- Admins' convars change handling
for _, command in pairs(adminConVars) do
    addSharedConcommand(command)
end

-- owa_castAbility is a console command tha takes 1 parameter: ability ID.
-- Casts ability with the specified ID.
concommand.Add('owa_castAbility', function(player, _, args)
    net.QuickMsg('abilityCastRequest', args[1])
end)
