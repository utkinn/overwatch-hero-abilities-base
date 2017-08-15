function signal(signalName, player)
	net.Start(signalName)
	if SERVER then
		net.Send(player)
	elseif CLIENT then
		net.SendToServer()
	end
end

--TODO: Add flag to client
conVarFlags = SERVER and {FCVAR_ARCHIVE, FCVAR_REPLICATED} or FCVAR_USERINFO

adminConVars = 
{
	--CreateConVar("tracer_blink_adminonly", 0, flags, "Allow blinking to admins only."),
}