local function loadDataWear()
    local ply = LocalPlayer()

    ply.ClothingSystemWearList = {}
end
ClothingSystem.Tools.Hooks.AddHook("PreCleanupMap", loadDataWear)

-- timer.Create("GOG", 1, 0, function()
-- for i = 1, 3 do
--     -- ClothingSystem.Tools.Network.Send("SendToServer", "SpawnEntity", {class = "fallout_power_armor_x03_1"})
--     net.Start("sendtoserver")
--     net.WriteTable({class = "fallout_power_armor_x03_1"})
--     net.SendToServer()
--     net.Start("Tools.NetWork.ClothingSystem.ToServer")
--         net.WriteString("sendtoserver")
--         net.WriteString(identifier)
--         net.WriteTable(array)
--         net.WriteString(CreatingStartingMachineKey)
--     net.SendToServer()
-- end
-- end)
-- timer.Remove("GOG")