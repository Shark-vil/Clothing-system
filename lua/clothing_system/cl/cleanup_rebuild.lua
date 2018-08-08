local function loadDataWear()
    local ply = LocalPlayer()

    ply.ClothingSystemWearList = {}
end
hook.Add("PreCleanupMap", "ClothingSystem.loadDataWear", loadDataWear)