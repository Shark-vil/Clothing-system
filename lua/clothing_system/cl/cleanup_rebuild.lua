local function loadDataWear()
    local ply = LocalPlayer()

    ply.ClothingSystemWearList = {}
end
ClothingSystem.Tools.Hooks.AddHook("PreCleanupMap", loadDataWear)