hook.Add("Think", "Clothing.System.Module.ThinkModule", function()
    for _, ply in ipairs(player.GetAll()) do
        if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end 
        if (ply.ClothingSystemPlayerBase == nil) then return end 
        if (!ply.ClothingSystemPlayerIsSpawn) then return end 

        local items = ClothingSystem:PlayerGetItems(ply)
        
        if (items != nil && istable(items) && table.Count(items) != 0) then
            for _, class in pairs(items) do
                if (list.Get("clothing_system")[class].Think != nil) then
                    list.Get("clothing_system")[class].Think(ply, class)
                end
            end
        end
    end
end)