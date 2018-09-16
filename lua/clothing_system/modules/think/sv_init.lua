local function main()
    for _, ply in ipairs(player.GetAll()) do
        if (ply.ClothingSystemPlayerBase == nil) then return end 
        if (!ply.ClothingSystemPlayerIsSpawn) then return end
        if (#ply.ClothingSystemWearList == 0) then return end
        
        local clothList = list.Get("clothing_system")
        for _, class in pairs(ply.ClothingSystemWearList) do
            if (clothList != nil && clothList[class] != nil && clothList[class].Think != nil) then
                clothList[class].Think(ply, class)
            end
        end
    end
end
-- hook.Add("Think", "ClothingSystem.Module.Think.sv_init.main", main)
timer.Create("ClothingSystem.Module.Think.sv_init.main", 0.1, 0, main)