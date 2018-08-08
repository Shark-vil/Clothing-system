-- Вызывается при каждом спавне
local function PlayerSpawn(ply)
    if (ply:SteamID() == "BOT") then return end
    
    local tm = 4

    if (ply.ClothingSystemPlayerIsSpawn) then
        tm = 0
    end
    
    timer.Simple(tm, function()
        if (!ply.ClothingSystemPlayerIsSpawn) then
            ply:AddText("The clothing system is loaded.")

            -- Обновление типа костей и массивов игрока
            ClothingSystem:UpdateBoneType(ply)

            -- Цикл по всем игрокам
            for _, player in ipairs(player.GetAll()) do
                -- Проверка на то, что игрок не является нашим игроком
                if ( player != ply ) then
                    -- Получаем всю одежду игрока
                    local items = ClothingSystem:PlayerGetItems(player)

                    -- Проверка на то, что массив не пустой
                    if ( !ClothingSystem:TableIsEmpty(items) ) then
                        for _, class in pairs(items) do
                            ClothingSystem:WearPartsInitialSpawn(class, player, ply, "send", false)
                        end
                    end
                end
            end
        else
            ClothingSystem:UpdateBoneType(ply)
        end

        timer.Simple(tm, function()
            if (ply:Alive()) then
                -- Получаем всю одежду игрока
                local items = ClothingSystem:PlayerGetItems(ply)

                -- Выполняем, если массив не пустой
                if ( !ClothingSystem:TableIsEmpty(items) ) then
                    for _, class in pairs(items) do
                        -- Проверяем, есть ли элемент в списке одежды сервера
                        if ( !ClothingSystem:GetItem(class) ) then return end

                        -- Проверяем, есть ли функция экипировки
                        if ( ClothingSystem:GetItem(class).Equip ) then
                            -- Если есть, вызываем
                            ClothingSystem:GetItem(class).Equip(ply, class)
                        end

                        -- Рисуем одежду игрока на каждом клиенте, включая самого игрока
                        ClothingSystem:WearParts(class, ply, nil, "broadcast", false)
                    end
                end
            end
        end)
    end)
end
hook.Add("PlayerSpawn", "ClothingSystem.PlayerSpawn", PlayerSpawn)