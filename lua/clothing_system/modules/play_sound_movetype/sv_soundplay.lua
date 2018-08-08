-- Звук в воде
local function WaterSoundEffect()
    for _, ply in ipairs(player.GetAll()) do
        -- Проверка на доступность игрока
        if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end

        -- Проверка на нажатие WASD & Space
        if (ply:KeyDown(IN_FORWARD) || ply:KeyDown(IN_BACK) || ply:KeyDown(IN_MOVELEFT) || ply:KeyDown(IN_MOVERIGHT) || ply:KeyDown(IN_JUMP)) then
            if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
            if (ply.ClothingSystemPlaysoundData == nil) then return end -- Проверка на наличие массива со звуками
            if (ply:WaterLevel() < 2) then return end -- Если игрок не погружён в воду полностью, ничего не делаем
            -- Проверка на кулдаун проигрывания звука
            if (ply.ClothingSystemPlaysoundData['isWaterSwiming']) then
                if (ply.ClothingSystemPlaysoundData['isWaterSwiming'] > CurTime()) then return end
            end

            -- Если игрок погружён в воду на половину
            if (ply:WaterLevel() == 2) then
                -- Проверка на существования ячейки со звуком
                if (ply.ClothingSystemPlaysoundData['AboveWaterSound']) then
                    -- Проверяем тип переменной: массив, или строка
                    if (istable(ply.ClothingSystemPlaysoundData['AboveWaterSound'][1])) then
                        local ln = table.Count(ply.ClothingSystemPlaysoundData['AboveWaterSound'][1]) -- Число элементов массива
                        local p = ply.ClothingSystemPlaysoundData['AboveWaterSound'][1][math.random(1, ln)] -- Вылавливание рандомного элемента массива
                        ply:EmitSound(p) -- Проигрыванеи звука
                        -- Если игрок бежит
                        if (ply:KeyDown(IN_SPEED)) then
                            ply.ClothingSystemPlaysoundData['isWaterSwiming'] = (SoundDuration(p)/2) + CurTime() -- Устанавливаем урезанный кулдаун
                        else
                            ply.ClothingSystemPlaysoundData['isWaterSwiming'] = SoundDuration(p) + CurTime() -- Устанавливаем кулдаун по продолжительности звука
                        end
                    else
                        ply:EmitSound(ply.ClothingSystemPlaysoundData['AboveWaterSound'][1]) -- Проигрыванеи звука
                        -- Если игрок бежит
                        if (ply:KeyDown(IN_SPEED)) then
                            ply.ClothingSystemPlaysoundData['isWaterSwiming'] = (SoundDuration(ply.ClothingSystemPlaysoundData['AboveWaterSound'][1])/2) + CurTime() -- Устанавливаем урезанный кулдаун
                        else
                            ply.ClothingSystemPlaysoundData['isWaterSwiming'] = SoundDuration(ply.ClothingSystemPlaysoundData['AboveWaterSound'][1]) + CurTime() -- Устанавливаем кулдаун по продолжительности звука
                        end
                    end
                end
            -- Если игрок погружён в воду полностью
            elseif( ply:WaterLevel() == 3) then
                -- Проверка на существования ячейки со звуком
                if (ply.ClothingSystemPlaysoundData['UnderWaterSound']) then
                    -- Проверяем тип переменной: массив, или строка
                    if (istable(ply.ClothingSystemPlaysoundData['UnderWaterSound'][1])) then
                        local ln = table.Count(ply.ClothingSystemPlaysoundData['UnderWaterSound'][1]) -- Число элементов массива
                        local p = ply.ClothingSystemPlaysoundData['UnderWaterSound'][1][math.random(1, ln)] -- Вылавливание рандомного элемента массива
                        ply:EmitSound(p) -- Проигрыванеи звука
                        -- Если игрок бежит
                        if (ply:KeyDown(IN_SPEED)) then
                            ply.ClothingSystemPlaysoundData['isWaterSwiming'] = (SoundDuration(p)/2) + CurTime() -- Устанавливаем урезанный кулдаун
                        else
                            ply.ClothingSystemPlaysoundData['isWaterSwiming'] = SoundDuration(p) + CurTime() -- Устанавливаем кулдаун по продолжительности звука
                        end
                    else
                        ply:EmitSound(ply.ClothingSystemPlaysoundData['UnderWaterSound'][1]) -- Проигрыванеи звука
                        -- Если игрок бежит
                        if (ply:KeyDown(IN_SPEED)) then
                            ply.ClothingSystemPlaysoundData['isWaterSwiming'] = (SoundDuration(ply.ClothingSystemPlaysoundData['UnderWaterSound'][1])/2) + CurTime() -- Устанавливаем урезанный кулдаун
                        else
                            ply.ClothingSystemPlaysoundData['isWaterSwiming'] = SoundDuration(ply.ClothingSystemPlaysoundData['UnderWaterSound'][1]) + CurTime() -- Устанавливаем кулдаун по продолжительности звука
                        end
                    end
                end
            end
        end
    end
end
hook.Add("Think", "ClothingSystem.WaterSoundEffect", WaterSoundEffect)

-- Звук удара об землю
local function PlayDmgFall(ply, dmginfo)
    if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end -- Проверка на доступность игрока
    if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
    if (ply.ClothingSystemPlaysoundData == nil) then return end -- Проверка на существование массива со звуками

    -- Проверка на существование массива со звуком, и на то, что урон был нанесён от падения
    if (ply.ClothingSystemPlaysoundData['PowerLandingSound'] && dmginfo:IsDamageType(DMG_FALL)) then
        -- Проверяем тип переменной: массив, или строка
        if (istable(ply.ClothingSystemPlaysoundData['PowerLandingSound'][1])) then
            local ln = table.Count(ply.ClothingSystemPlaysoundData['PowerLandingSound'][1]) -- Число элементов массива
            local p = ply.ClothingSystemPlaysoundData['PowerLandingSound'][1][math.random(1, ln)] -- Вылавливание рандомного элемента массива
            ply:EmitSound(p) -- Проигрыванеи звука
        else
            ply:EmitSound(ply.ClothingSystemPlaysoundData['PowerLandingSound'][1]) -- Проигрыванеи звука
        end
    end
end
hook.Add("EntityTakeDamage","ClothingSystemModule.PlaySoundTakeDamageFALL", PlayDmgFall)

-- Звук прыжка и касания
local function PlayJump()
    -- Цикл по всем игрокам на сервере
    for _, ply in ipairs(player.GetAll()) do
        if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end -- Проверка на доступность игрока

        if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
        if (ply.ClothingSystemPlaysoundData == nil) then return end -- Проверка на существование массива со звуками
        -- Выполняем, если игрок находится на земле, а не в воде
        if (ply:WaterLevel() > 0) then 
            -- Если переменная TRUE, устанавливаем FALSE
            if (ply.ClothingSystemPlaysoundData['isLanding']) then
                ply.ClothingSystemPlaysoundData['isLanding'] = false  
            end
            return 
        end

        -- Проверка на то, что игрок на земле
        if (ply:IsOnGround()) then 
            -- Проверка на существование ячейки с BOOL значением
            if (ply.ClothingSystemPlaysoundData['isLanding']) then
                -- Выполняем, если переменная больше, чем время работы Linux
                if (ply.ClothingSystemPlaysoundData['isLandingCheck'] > CurTime()) then
                    -- Проверка на существование ячейки со звуком
                    if (ply.ClothingSystemPlaysoundData['LandingSound']) then
                        -- Проверяем тип переменной: массив, или строка
                        if (istable(ply.ClothingSystemPlaysoundData['LandingSound'][1])) then
                            local ln = table.Count(ply.ClothingSystemPlaysoundData['LandingSound'][1]) -- Число элементов массива
                            local p = ply.ClothingSystemPlaysoundData['LandingSound'][1][math.random(1, ln)] -- Вылавливание рандомного элемента массива
                            ply:EmitSound(p) -- Проигрыванеи звука
                        else
                            ply:EmitSound(ply.ClothingSystemPlaysoundData['LandingSound'][1]) -- Проигрыванеи звука
                        end
                    end
                end
                ply.ClothingSystemPlaysoundData['isLanding'] = false
            end
            -- Выполняем, если игрок в NOCLIP или OBSERVER
            if (ply:GetMoveType() == MOVETYPE_NOCLIP || ply:GetMoveType() == MOVETYPE_OBSERVER) then
                -- Отключаем проигрывание звуков приземления по выходу из NOCLIP и OBSERVER
                ply.ClothingSystemPlaysoundData['isJumping'] = true
            else
                -- Если переменная TRUE, ставим FALSE
                if (ply.ClothingSystemPlaysoundData['isJumping']) then
                    ply.ClothingSystemPlaysoundData['isJumping'] = false  
                end
            end
            return
        end
        if (!ply:KeyDown(IN_JUMP)) then return end -- Проверка на то, что игрок прыгнул
        if (ply.ClothingSystemPlaysoundData['isJumping']) then return end -- Если isJumping = true, не выполняем скрипт

        -- Проверка на существование ячейки со звуком
        if (ply.ClothingSystemPlaysoundData['JumpSound']) then
            -- Проверяем тип переменной: массив, или строка
            if (istable(ply.ClothingSystemPlaysoundData['JumpSound'][1])) then
                local ln = table.Count(ply.ClothingSystemPlaysoundData['JumpSound'][1]) -- Число элементов массива
                local p = ply.ClothingSystemPlaysoundData['JumpSound'][1][math.random(1, ln)] -- Вылавливание рандомного элемента массива
                ply:EmitSound(p) -- Проигрыванеи звука
            else
                ply:EmitSound(ply.ClothingSystemPlaysoundData['JumpSound'][1]) -- Проигрыванеи звука
            end

            ply.ClothingSystemPlaysoundData['isJumping'] = true

            if (ply.ClothingSystemPlaysoundData['LandingSound']) then
                ply.ClothingSystemPlaysoundData['isLanding'] = true -- Активация звука приземления (касания)
                ply.ClothingSystemPlaysoundData['isLandingCheck'] = CurTime() + 1.5 -- Если игрок летит дольше, чем 1.5 сек, тогда не проигрываем звук приземления (касания)
            end
        end
    end
end
hook.Add("Think", "ClothingSystem.PlayJump", PlayJump)

-- Звук дыхания через маску
local function GasMask()
    for _, ply in pairs(player.GetAll()) do
        if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end -- Проверка на доступность игрока
        if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
        if (ply.ClothingSystemPlaysoundData == nil) then return end -- Проверка на существование массива со звуками
        if (!ply.ClothingSystemPlaysoundData['isGasMaskCurTime']) then return end
        if (ply.ClothingSystemPlaysoundData['isGasMaskCurTime'] > CurTime()) then return end
        if (!ply.ClothingSystemPlaysoundData['BreathSoundInGasMask']) then return end

        local p
        if (istable(ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'][1])) then
            local ln = table.Count(ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'][1]) -- Число элементов массива
            p = ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'][1][math.random(1, ln)] -- Вылавливание рандомного элемента массива
            ply:EmitSound(p) -- Проигрыванеи звука
        else
            p = ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'][1]
            ply:EmitSound(p) -- Проигрыванеи звука
        end
        
        ply.ClothingSystemPlaysoundData['isGasMaskCurTime'] = CurTime() + SoundDuration(p)
    end
end
hook.Add("Think", "ClothingSystem.GasMaskSound", GasMask)

-- Звуки при ходьбе и беге
local function PlayFootstep( ply )
    if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end -- Проверка на доступность игрока
    
    if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
    if (ply.ClothingSystemPlaysoundData == nil) then return end -- Проверка на существование массива со звуками

    -- Проверка на существование ячейки со звуком, и на то, что игрок бежит
    if (ply:KeyDown(IN_SPEED) && ply.ClothingSystemPlaysoundData['RunSound']) then
        -- Проверяем тип переменной: массив, или строка
        if (istable(ply.ClothingSystemPlaysoundData['RunSound'][1])) then
            local ln = table.Count(ply.ClothingSystemPlaysoundData['RunSound'][1]) -- Число элементов массива
            local p = ply.ClothingSystemPlaysoundData['RunSound'][1][math.random(1, ln)] -- Вылавливание рандомного элемента массива
            ply:EmitSound(p) -- Проигрыванеи звука
        else
            ply:EmitSound(ply.ClothingSystemPlaysoundData['RunSound'][1]) -- Проигрыванеи звука
        end

        return true
    elseif (ply:KeyDown(IN_WALK) && ply.ClothingSystemPlaysoundData['WalkSound']) then -- Проверка на существование ячейки со звуком, и на то, что игрок идёт
        -- Проверяем тип переменной: массив, или строка
        if (istable(ply.ClothingSystemPlaysoundData['WalkSound'][1])) then
            local ln = table.Count(ply.ClothingSystemPlaysoundData['WalkSound'][1]) -- Число элементов массива
            local p = ply.ClothingSystemPlaysoundData['WalkSound'][1][math.random(1, ln)] -- Вылавливание рандомного элемента массива
            ply:EmitSound(p) -- Проигрыванеи звука
        else
            ply:EmitSound(ply.ClothingSystemPlaysoundData['WalkSound'][1]) -- Проигрыванеи звука
        end

        return true
    elseif (ply.ClothingSystemPlaysoundData['WalkSound']) then -- Проверка на существование ячейки массива
        if (istable(ply.ClothingSystemPlaysoundData['WalkSound'][1])) then
            -- Проверяем тип переменной: массив, или строка
            local ln = table.Count(ply.ClothingSystemPlaysoundData['WalkSound'][1]) -- Число элементов массива
            local p = ply.ClothingSystemPlaysoundData['WalkSound'][1][math.random(1, ln)] -- Вылавливание рандомного элемента массива
            ply:EmitSound(p) -- Проигрыванеи звука
        else
            ply:EmitSound(ply.ClothingSystemPlaysoundData['RunSound'][1]) -- Проигрыванеи звука
        end

        return true
    end
end
hook.Add("PlayerFootstep", "ClothingSystem.PlayerFootstep", PlayFootstep)