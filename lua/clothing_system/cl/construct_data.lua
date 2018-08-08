-- Установка базовых элементов при загрузке и спавне
local function construct()
    local bones = net.ReadTable()
    local type = net.ReadString()
    local ply = LocalPlayer()

    ply:ClothingSystemConstruct(bones, type)
end
net.Receive("ClothingSystem.ConstructData", construct)