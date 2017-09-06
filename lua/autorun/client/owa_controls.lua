local CONTROLS_FILE = "OWAControls.txt"

if not file.Exists(CONTROLS_FILE, "DATA") then
	OWAControls =
	{
		ability1 = nil,
		ability2 = nil,
		ultimate = nil
	}
else
	OWAControls = util.JSONToTable(file.Read(CONTROLS_FILE))
end

function owa_binder(form, text, onChange, initValue)
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

function owa_updateKeyBinding(control, num)
	local fileContents = file.Read(CONTROLS_FILE)
	if fileContents ~= "" and fileContents ~= nil then
		OWAControls = util.JSONToTable(fileContents)
	else
		OWAControls = {}
	end
	OWAControls[control] = num
	file.Write(CONTROLS_FILE, util.TableToJSON(OWAControls))
end

hook.Add("Think", "owa_abilityKeyPressed", function()
	if LocalPlayer():IsTyping() then return end
	
	if OWAControls.ability1 ~= nil then
		if input.IsKeyDown(OWAControls.ability1) then
			dbgLog("abilityCastRequest 1")
			net.Start("abilityCastRequest")
				net.WriteUInt(1, 3)
			net.SendToServer()
		end
	end
	
	if OWAControls.ability2 ~= nil then
		if input.IsKeyDown(OWAControls.ability2) then
			dbgLog("abilityCastRequest 2")
			net.Start("abilityCastRequest")
				net.WriteUInt(2, 3)
			net.SendToServer()
		end
	end
	
	if OWAControls.ultimate ~= nil then
		if input.IsKeyDown(OWAControls.ultimate) then
			dbgLog("ultimateRequest")
			signal("ultimateCastRequest")
		end
	end
end)