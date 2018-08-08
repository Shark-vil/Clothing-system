local function dmg(ply, hitgroup, dmginfo)
    if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end -- Проверка на то, что игрок доступен для установки параметров
    if (ply.ClothingSystemPlayerBase == nil) then return end -- Проверка на существования базы у игрока
    if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился

    local items = ClothingSystem:PlayerGetItems(ply) -- Получение классов всей одежды игрока
    local NewScale = 1 -- Параметр получения урона
    
    -- Проверка массива на пустоту
    if (!ClothingSystem:TableIsEmpty(items)) then
        -- Цикл по всем элементам массива
        for _, class in pairs(items) do
            local item = list.Get("clothing_system")[class] -- Получаем объект по классу
            -- Если есть параметр, выполняем
            if (item.TakeDamageSystem) then
                -- Проверка на существование массива с параметрами дамага
                if (item.TakesDamagePercent && istable(item.TakesDamagePercent) && table.Count(item.TakesDamagePercent) != 0) then
                    -- Цикл по всем элементам массива
                    for DamageType, value in pairs (item.TakesDamagePercent) do
                        -- Если есть маска, выполняем
                        if (item.GasMask) then
                            -- Если дамаг типа DMG_RADIATION, выполняем
                            if (dmginfo:IsDamageType(DMG_RADIATION) || dmginfo:IsDamageType(DMG_ACID)) then
                                if (ply.ClothingSystemPlaysoundData != nil) then
                                    if (ply.ClothingSystemPlaysoundData['RadiationSound']) then
                                        if (istable(ply.ClothingSystemPlaysoundData['RadiationSound'][1])) then
                                            local ln = table.Count(ply.ClothingSystemPlaysoundData['RadiationSound'][1]) -- Число элементов массива
                                            local p = ply.ClothingSystemPlaysoundData['RadiationSound'][1][math.random(1, ln)] -- Вылавливание рандомного элемента массива
                                            ply:EmitSound(p, 75, 100, 1, CHAN_AUTO ) -- Проигрыванеи звука
                                        else
                                            ply:EmitSound(ply.ClothingSystemPlaysoundData['RadiationSound'][1], 75, 100, 0.5, CHAN_AUTO ) -- Проигрыванеи звука
                                        end
                                    end
                                end            
                                NewScale = 0 -- Гасим дамаг
                                dmginfo:ScaleDamage(NewScale)
                            end
                        end
                    end
                end
            end
        end
    end
end
hook.Add("ScalePlayerDamage", "ClothingSystemModule.EntityTakeDamageGasMask", dmg)