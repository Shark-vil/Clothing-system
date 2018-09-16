local function loadDataWear()
    for _, ply in pairs(player.GetAll()) do
        ClothingSystem:UpdateBoneType(ply)
        
        if (ply:Alive()) then
            local items = ClothingSystem:PlayerGetItems(ply)
            for _, class in pairs(items) do
                if ( !ClothingSystem:GetItem(class) ) then return end

                ClothingSystem:WearParts(class, ply, nil, "broadcast", false)
            end
        end
    end
end
ClothingSystem.Tools.Hooks.AddHook("PostCleanupMap", loadDataWear)