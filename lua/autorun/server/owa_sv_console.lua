for _, command in pairs(adminConVars) do
	cvars.AddChangeCallback(command:GetName(), function(conVar, oldValue, newValue)
		net.Start("adminConVarChanged")
			net.WriteFloat(newValue)
		net.Broadcast()
	end)
end