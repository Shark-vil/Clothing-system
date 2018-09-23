-- Таймер регенерации
local function regeneration()
    -- Производим цикл по всем игрокам каждые 2 секунды
    for _, ply in ipairs(player.GetAll()) do
        if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end -- Проверка на то, что игрок доступен для установки параметров
        if (ply.ClothingSystemPlayerBase == nil) then return end -- Проверка на существования базы у игрока
        if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
        
        -- Проверка массива на пустоту
        if (#ply.ClothingSystemWearList != 0) then
            -- Цикл по всем элементам массива
            for _, class in pairs(ply.ClothingSystemWearList) do
                local item = list.Get("clothing_system")[class] -- Получаем массив одежды по классу
                
                -- Выполняем, если параметр регенерации присутствует
                if (item != nil && item.RegenerationHealth != nil && isnumber(item.RegenerationHealth) ) then
                    local hp = ply:Health() + item.RegenerationHealth

                    -- Прибавляем HP до тех пор, пока не будет достигнут максимальный лимит HP у игрока
                    if ( ply:GetMaxHealth() >= hp ) then
                        ply:SetHealth(hp)
                    end
                end
            end
        end
    end
end
timer.Create("ClothingSystem.RegenerationSystem", 2, 0, regeneration)