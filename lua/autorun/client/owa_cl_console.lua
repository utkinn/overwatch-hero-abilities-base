include('client/owa_shared_console_commands.lua')

--Admins' convars change handling
for _, command in pairs(adminConVars) do
    addSharedConcommand(command)
end

concommand.Add('owa_castAbility', function(player, _, args)
    net.Start('abilityCastRequest')
        net.WriteUInt(args[1], 3)
    net.SendToServer()
end)
