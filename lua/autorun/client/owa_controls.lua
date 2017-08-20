local CONTROLS_FILE = "OWAControls.txt"

if not file.Exists(CONTROLS_FILE, "DATA") then
	controls =
	{
		ability1 = nil,
		ability2 = nil,
		ultimate = nil
	}
else
	controls = util.JSONToTable(file.Read(CONTROLS_FILE))
end

function binder(form, text, onChange, initValue)
	local label = vgui.Create("DLabel")
	label:SetText(text)

	local binder = vgui.Create("DBinder")
	binder:SetSize(200, 50)
	if initValue ~= nil then binder:SetValue(initValue) end
	
	function binder:SetSelectedNumber(num)
		self.m_iSelectedNumber = num -- Preserve original functionality
		onChange(num)
	end
	
	form:AddItem(label, binder)
	return binder
end

function updateKeyBinding(control, num)
	local fileContents = file.Read(CONTROLS_FILE)
	if fileContents ~= "" and fileContents ~= nil then
		controls = util.JSONToTable(fileContents)
	else
		controls = {}
	end
	controls[control] = num
	file.Write(CONTROLS_FILE, util.TableToJSON(controls))
end

hook.Add("Think", "abilityKeyPressed", function()
	if LocalPlayer():IsTyping() then return end
	
	if controls.ability1 ~= nil then
		if input.IsKeyDown(controls.ability1) then
			print("abilityCastRequest 1")
			net.Start("abilityCastRequest")
				net.WriteUInt(1, 3)
			net.SendToServer()
		end
	end
	
	if controls.ability2 ~= nil then
		if input.IsKeyDown(controls.ability2) then
			print("abilityCastRequest 2")
			net.Start("abilityCastRequest")
				net.WriteUInt(2, 3)
			net.SendToServer()
		end
	end
	
	if controls.ultimate ~= nil then
		if input.IsKeyDown(controls.ultimate) then
			print("ultimateRequest")
			signal("ultimateCastRequest")
		end
	end
end)