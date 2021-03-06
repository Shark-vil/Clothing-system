-- Система гашения урона
local function dmg(ply, dmginfo)
    if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end -- Проверка на то, что игрок доступен для установки параметров
    if (ply.ClothingSystemPlayerBase == nil) then return end -- Проверка на существования базы у игрока
    if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился

    local items = ClothingSystem:PlayerGetItems(ply) -- Получение классов всей одежды игрока
    local NewScale = 1 -- Параметр получения урона
    
    -- Проверка массива на пустоту
    if (items != nil && istable(items) && table.Count(items) != 0) then
        -- Цикл по всем элементам массива
        for _, class in pairs(items) do
            local item = list.Get("clothing_system")[class] -- Получаем объект по классу

            if (item != nil && item.PowerArmor) then
                if (dmginfo:IsDamageType(DMG_FALL)) then
                    ply:ViewPunch( Angle( math.random(-20, 20), math.random(-20, 20), math.random(-20, 20) ) )
                    dmginfo:ScaleDamage(0)
                    return
                end
            end

            if (item.TakesDamagePercent && istable(item.TakesDamagePercent) && table.Count(item.TakesDamagePercent) != 0) then
                if (list.Get("clothing_system")[class].Damage != nil) then
                    list.Get("clothing_system")[class].Damage(ply, class, hitgroup, dmginfo)
                end

                -- Цикл по всем элементам массива
                for DamageType, value in pairs(item.TakesDamagePercent) do
                    -- Если есть маска, выполняем
                    if (item.GasMask) then
                        if (dmginfo:IsDamageType(DMG_RADIATION)) then
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
                            dmginfo:ScaleDamage(0)
                            return
                        end
                    end

                    if(dmginfo:IsDamageType(DamageType))then
                        NewScale = NewScale*value
                    end

                    if (ply:ClothingSystemGetBones().Head != nil && isbool(ply:ClothingSystemGetBones().Head) && ply:ClothingSystemGetBones().Head == true) then
                        -- Если урон был типа DMG_BULLET или DMG_BUCKSHOT, выполняем
                        if (dmginfo:IsDamageType(DMG_BULLET) || dmginfo:IsDamageType(DMG_BUCKSHOT) && DamageType == DMG_BULLET || DamageType == DMG_AIRBOAT || DamageType == 1073741824) then
                            -- Если попали в голову, выполняем
                            if (hitgroup == HITGROUP_HEAD) then
                                local rnd = math.random(1, 100) -- Рандомное число от 1 до 100
                                -- Если rnd меньше или равно 2, выполняем
                                if( rnd <= 2 )then
                                    ply:EmitSound("clothing_system/cs_ricochet_"..tostring(math.random(1,2))..".wav",70,100) -- Проигрывание звука рикошета
                                    ply:ViewPunch(Angle(math.random(-10,10),math.random(-10,10),0)) -- Тряска камеры
                                    NewScale = NewScale*.0001 -- Гасим дамаг
                                else
                                    ply:EmitSound("Drywall.ImpactHard") --Звук попадания по шлему(голове)
                                end
                            end
                        end
                    end
                end
            end
        end

        dmginfo:ScaleDamage(NewScale) -- Применение урона на игрока
    end
end
ClothingSystem.Tools.Hooks.AddHook("EntityTakeDamage", dmg)