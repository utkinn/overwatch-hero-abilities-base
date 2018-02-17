function removeSpaces(str)
    return str:Trim():Replace(" ", "_")
end

function isFriendly(player, ent)
    if ent:IsPlayer() then
        if player:Team() == ent:Team() then return true end
    elseif hitEnt:IsNPC() then
        local disposition = ent:Disposition(player)
        if disposition == D_LI or disposition == D_NU then return true end
    end
    return false
end

function debugLog(textOrPredicate, textOrFunctionWhenTrue, textOrFunctionWhenFalse)
    if OWA_DEBUG then
        if isstring(textOrPredicate) then
            print("[OWA Debug "..debug.traceback().."] "..textOrPredicate)
        elseif isbool(textOrPredicate) then
            if isstring(textOrFunctionWhenTrue) then
                print("[OWA Debug "..debug.traceback().."] "..textOrFunctionWhenTrue)
            elseif isfunction(textOrFunctionWhenTrue) then
                textOrFunctionWhenTrue()
            else
                print("[OWA Debug "..debug.traceback().."] bad argument #2 ("..type(textOrFunctionWhenTrue).." got, string or function expected)")
            end

            if isstring(textOrFunctionWhenFalse) then
                print("[OWA Debug "..debug.traceback().."] "..textOrFunctionWhenFalse)
            elseif isfunction(textOrFunctionWhenFalse) then
                textOrFunctionWhenFalse()
            else
                print("[OWA Debug "..debug.traceback().."] bad argument #3 ("..type(textOrFunctionWhenFalse).." got, string or function expected)")
            end
        else
            print("[OWA Debug "..debug.traceback().."] bad argument #1 ("..type(textOrPredicate).." got, string or bool expected)")
        end
    end
end

function fileIsEmpty(filePath)
    local fileContents = file.Read(filePath)
    return fileContents == "" or fileContents == nil
end

function coerceAtLeast(minValue, actualValue)
    if actualValue < minValue then
        return minValue
    else
        return actualValue
    end
end
