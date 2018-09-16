-- Звук в воде
local function WaterSoundEffect()
    for _, ply in ipairs(player.GetAll()) do
        if (!IsValid(ply) || !ply:IsPlayer() || !ply:Alive()) then return end
        if (ply:GetMoveType() == MOVETYPE_NOCLIP) then return end
        if (ply.ClothingSystemPlayerBase == nil) then return end -- Проверка на существования базы у игрока
        if (!ply.ClothingSystemPlayerIsSpawn) then return end -- Проверка на то, что игрок заспавнился
        if (ply.ClothingSystemData['itemIsPowerArmor'] != nil && isbool(ply.ClothingSystemData['itemIsPowerArmor']) && ply.ClothingSystemData['itemIsPowerArmor'] == false) then
            if (ply:GetMoveType() == MOVETYPE_FLYGRAVITY) then
                ply:SetMoveType(MOVETYPE_WALK)
                ply.ClothingSystemData['itemIsPowerArmor'] = nil
            end
        end

        if (ply.ClothingSystemWearList != nil && #ply.ClothingSystemWearList != 0) then
            for _, v in pairs(ply.ClothingSystemWearList) do
                local item = list.Get("clothing_system")[v]
                if (item != nil && item.PowerArmor) then
                    if (ply:WaterLevel() < 2 && ply:IsOnGround()) then 
                        if (ply:GetMoveType() == MOVETYPE_FLYGRAVITY) then
                            ply:SetMoveType(MOVETYPE_WALK)
                        end
                        return 
                    elseif (ply:WaterLevel() >= 2 && !ply:IsOnGround()) then 
                        ply:SetVelocity(Vector(0, 0, -50))
                        if (ply:GetMoveType() != MOVETYPE_FLYGRAVITY) then
                            ply:SetMoveType(MOVETYPE_FLYGRAVITY)
                        end
                    else
                        if (ply:GetMoveType() == MOVETYPE_FLYGRAVITY) then
                            ply:SetMoveType(MOVETYPE_WALK)
                        end
                        return
                    end
                    if (ply.ClothingSystemData['itemIsPowerArmor'] == nil) then
                        ply.ClothingSystemData['itemIsPowerArmor'] = true
                    end
                    return
                end
            end

            ply.ClothingSystemData['itemIsPowerArmor'] = false
        end
    end
end
timer.Create("ClothingSystem.Module.PowerArmor.sv_water.WaterSoundEffect", 0.1, 0, WaterSoundEffect)
-- ClothingSystem.Tools.Hooks.AddHook("Think", WaterSoundEffect)