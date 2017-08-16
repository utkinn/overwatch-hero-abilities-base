local CONTROLS_FILE = "OWAControls.txt"

if not file.Exists(CONTROLS_FILE, "DATA") then
	controls =
	{
		ability1 = nil,
		ability2 = nil,
		ultimate = nil
	}
else
	controls = util.JSONToTable(file.Read("tracerAbilitiesControls.txt"))
end

hook.Add("Think", "abilityKeyPressed", function()
	if LocalPlayer():IsTyping() then return end
	
	if controls.ability1 ~= nil then
		if input.IsKeyDown(controls.ability1) then
			net.Start("abilityCastRequest")
				net.WriteUInt(1, 3)
			net.SendToServer()
		end
	end
	
	if controls.ability2 ~= nil then
		if input.IsKeyDown(controls.ability2) then
			net.Start("abilityCastRequest")
				net.WriteUInt(2, 3)
			net.SendToServer()
		end
	end
	
	if controls.ultimate ~= nil then
		if input.IsKeyDown(controls.ultimate) then
			net.Start("ultimateCastRequest")
			net.SendToServer()
		end
	end
end)