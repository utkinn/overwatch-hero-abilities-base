concommand.Add("owa_ui_permissions", function(player)
	net.Start("openPermissionsMenu")
	net.Send(player)
end, nil, "Open a hero permissions menu.")