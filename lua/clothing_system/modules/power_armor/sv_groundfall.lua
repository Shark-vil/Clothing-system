local function dmg(ply, dmginfo)
    if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end -- Проверка на то, что игрок доступен для установки параметров
    if (ply.ClothingSystemPlayerBase == nil) then return end -- Проверка на существования базы у игрока
    if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился

    local items = ClothingSystem:PlayerGetItems(ply) -- Получение классов всей одежды игрока
    
    -- Проверка массива на пустоту
    if (!ClothingSystem:TableIsEmpty(items)) then
        -- Цикл по всем элементам массива
        for _, class in pairs(items) do
            local item = list.Get("clothing_system")[class] -- Получаем объект по классу

            -- Если есть параметр, выполняем
            if (item != nil && item.PowerArmor) then
                if (dmginfo:IsDamageType(DMG_FALL)) then
                    ply:ViewPunch( Angle( math.random(-20, 20), math.random(-20, 20), math.random(-20, 20) ) )
                    dmginfo:ScaleDamage(0)
                end
            end
        end
    end
end
ClothingSystem.Tools.Hooks.AddHook("EntityTakeDamage", dmg)