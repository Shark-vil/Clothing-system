-- Звук в воде
local function WaterSoundEffect()
    for _, ply in ipairs(player.GetAll()) do
        -- Проверка на доступность игрока
        if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end
        if (ply.ClothingSystemPlayerBase == nil) then return end -- Проверка на существования базы у игрока
        if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
        if (ply:WaterLevel() < 2) then return end -- Если игрок не погружён в воду полностью, ничего не делаем

        local items = ClothingSystem:PlayerGetItems(ply)

        if (items != nil && istable(items) && table.Count(items) != 0) then
            for _, v in pairs(items) do
                local item = list.Get("clothing_system")[v]
                if (item.PowerArmor) then
                    if (!ply:IsOnGround()) then
                        ply:SetVelocity(Vector(0, 0, -50))
                    end
                end
            end
        end
    end
end
hook.Add("Think", "ClothingSystem.PowerArmorWaterDown", WaterSoundEffect)

hook.Add("KeyPress", "ClothingSystem.PowerArmorWaterDown.KeyPress", function(ply, button)
    if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end
    if (ply.ClothingSystemPlayerBase == nil) then return end -- Проверка на существования базы у игрока
    if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
    if (ply:WaterLevel() < 2) then return end -- Если игрок не погружён в воду полностью, ничего не делаем

    local items = ClothingSystem:PlayerGetItems(ply)
    if (items != nil && istable(items) && table.Count(items) != 0) then
        for _, v in pairs(items) do
            if (list.Get("clothing_system")[v].PowerArmor) then
                if (button == IN_JUMP) then 
                    ply:Lock()
                end
            end
        end
    end
end)

hook.Add("KeyRelease", "ClothingSystem.PowerArmorWaterDown.KeyRelease", function(ply, button)
    if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then ply:UnLock() return end
    if (ply.ClothingSystemPlayerBase == nil) then return end -- Проверка на существования базы у игрока
    if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
    if (ply:WaterLevel() < 2) then ply:UnLock() return end -- Если игрок не погружён в воду полностью, ничего не делаем

    local items = ClothingSystem:PlayerGetItems(ply)
    if (items != nil && istable(items) && table.Count(items) != 0) then
        for _, v in pairs(items) do
            if (list.Get("clothing_system")[v].PowerArmor) then
                if (button == IN_JUMP) then 
                    ply:UnLock()
                end
            end
        end
    end
end)