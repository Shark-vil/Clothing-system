net.Receive("ClothingSystem.SendLua.BigCode", function()
    local code = net.ReadString()
    RunString(code, "ClothingSystem.SendLua.BigCode", true)
end)