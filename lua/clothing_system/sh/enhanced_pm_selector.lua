local function spawn()
	if (ClothingSystem.Config.EnhancedPMSelector_FixChangePlayermodel) then
        local convar = GetConVar("sv_playermodel_selector_force")
    
        if (convar != nil) then
            if CLIENT then
                RunConsoleCommand("sv_playermodel_selector_force", 0)
            else
                convar:SetInt(0)
            end
        end
    end
end
ClothingSystem.Tools.Hooks.AddHook("PlayerInitialSpawn", spawn)