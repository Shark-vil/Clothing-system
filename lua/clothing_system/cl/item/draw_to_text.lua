-- Отрисовка Text Box над item
local function drawName()
    local index = net.ReadFloat()
    local class = net.ReadString()

    -- Выполняем цикл по всем энтити на карте
    for _, item in ipairs(ents.GetAll()) do
        -- Если индекс энтити совпадает с тем что
        -- мы передавали, устанавливаем ему класс для item
        if ( item:EntIndex() == index ) then
            item.Class = class
        end
    end
end
net.Receive("ClothingSystem.ItemFolderDrawToText", drawName)