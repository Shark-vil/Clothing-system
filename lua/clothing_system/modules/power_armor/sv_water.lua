-- Звук в воде
local function WaterSoundEffect()
    for _, ply in ipairs(player.GetAll()) do
        -- Проверка на доступность игрока
        if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end
        if (ply.ClothingSystemPlayerBase == nil) then return end -- Проверка на существования базы у игрока
        if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
        
        local items = ClothingSystem:PlayerGetItems(ply)

        if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
        if (ply:WaterLevel() < 2) then return end -- Если игрок не погружён в воду полностью, ничего не делаем
        if (!ClothingSystem:TableIsEmpty(items)) then
            for _, v in ipairs(items) do
                local item = list.Get("clothing_system")[v] -- Получаем массив одежды по классу
                if (item.PowerArmor) then
                    if (ply:KeyDown(IN_JUMP)) then 
                        ply:SetMoveType(MOVETYPE_FLY)
                    elseif (ply:KeyDown(IN_FORWARD) || ply:KeyDown(IN_BACK) || ply:KeyDown(IN_MOVELEFT) || ply:KeyDown(IN_MOVERIGHT)) then
                        if (ply:GetMoveType() == MOVETYPE_FLY) then
                            ply:SetMoveType(MOVETYPE_WALK)
                        end
                    end

                    if (!ply:IsOnGround()) then
                        ply:SetVelocity(Vector(0, 0, -50))
                    end
                end
            end
        end
    end
end
hook.Add("Think", "ClothingSystem.PowerArmorWaterDown", WaterSoundEffect)