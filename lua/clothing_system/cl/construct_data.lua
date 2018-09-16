-- Установка базовых элементов при загрузке и спавне
local function construct(len, data)
    LocalPlayer():ClothingSystemConstruct(data.bones, data.type)
end
ClothingSystem.Tools.Network.AddNetwork("ConstructData", construct)