net.Receive('OWA: Suicide', function(_, ply)
    ply:Kill()
end)

net.Receive('OWA: Hero select menu entered/exited', function(_, ply)
    local inMenu = net.Read()
    if inMenu then
        ply:Lock()
    else
        ply:UnLock()
    end
end)
