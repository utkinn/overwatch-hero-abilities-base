-- Shared console commands are changed on server when changed on cliend and the changer is admin.

function addSharedConcommand(command)
    cvars.AddChangeCallback(command:GetName(), function(_, oldValue, newValue)
        if LocalPlayer():IsAdmin() then
            net.Start('adminConVarChanged')
                net.WriteFloat(newValue)
            net.SendToServer()
        else
            MsgC(Color(255, 0, 0), language.GetPhrase('ui.settings.admin.denied')..'\n')
            command:SetString(oldValue)
        end
    end)
end
