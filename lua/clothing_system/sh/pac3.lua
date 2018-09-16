if (ClothingSystem.Config.PAC3_FixChangePlayermodel) then
    local convar = GetConVar("pac_modifier_model")

    if (convar != nil) then
        if CLIENT then
            RunConsoleCommand("pac_modifier_model", 0)
        else
            convar:SetInt(0)
        end
    end
end