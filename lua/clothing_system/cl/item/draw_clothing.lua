-- Отрисовка одежды
local function DrawClothing(owner)
    local ply = LocalPlayer() 
    local PlayerSteamID
    local OwnerSteamID
    
    if (!IsValid(ply) || !ply:IsPlayer()) then return end
    if (!IsValid(owner) || !owner:IsPlayer()) then return end

    if (game.SinglePlayer()) then
        PlayerSteamID = "STEAM_0:0:0"
        OwnerSteamID = "STEAM_0:0:0"
    else
        PlayerSteamID = ply:SteamID()
        OwnerSteamID = owner:SteamID()
    end

    -- Защита от двойной отрисовки
    if ( ply:ClothingSystemGetDrawing() ) then
        return
    end

    local NormalAct = {
        ACT_BUSY_LEAN_LEFT,
        ACT_BUSY_LEAN_LEFT_ENTRY,
        ACT_BUSY_LEAN_LEFT_EXIT,
        ACT_BUSY_LEAN_BACK,
        ACT_BUSY_LEAN_BACK_ENTRY,
        ACT_BUSY_LEAN_BACK_EXIT,
        ACT_BUSY_SIT_GROUND,
        ACT_BUSY_SIT_GROUND_ENTRY,
        ACT_BUSY_SIT_GROUND_EXIT,
        ACT_BUSY_SIT_CHAIR,
        ACT_BUSY_SIT_CHAIR_ENTRY,
        ACT_BUSY_SIT_CHAIR_EXIT,
    }

    -- Проверка на то, что владелец одежды является игроком, что он жив и существует на сервере
    if ( owner:GetMoveType() == MOVETYPE_NOCLIP ) then
        local fuckYou = true
        for i=1, #NormalAct do
            if (ply:GetSequence() == NormalAct[i]) then fuckYou = false end
        end
        if (fuckYou) then return end
    end
    if ( owner:GetMoveType() == MOVETYPE_OBSERVER ) then return end
    if ( !owner:IsPlayer() && !owner:Alive() && !IsValid(owner) ) then return end

    -- Проверка на наличие массива с информацией об одежде у локального игрока
    if ( !ply:ClothingSystemGetAllItem(OwnerSteamID) ) then return end

    -- Цикл по массиву с одеждой
    for k, outfit in ipairs( ply:ClothingSystemGetAllItem(OwnerSteamID) ) do
        if (!IsValid(outfit)) then return end
        if (outfit.SetPlayerModel) then return end
        if (outfit.Module) then return end

        local item = list.Get("clothing_system")[outfit.Class]
        if (item == nil) then return end
        
        if (OwnerSteamID == PlayerSteamID) then
            ply.ClothingSystemData['DrawOverlay'] = false
        end

        -- Выполняется, если тип связки - "BoneAttach"
        if ( outfit.parentType == "BoneAttach" ) then
            local Pos, Ang = owner:GetBonePosition(outfit.Bone)

            Ang:RotateAroundAxis(Ang:Up(), outfit.ReplaceItem.xAng || item.xAng || 0)
            Ang:RotateAroundAxis(Ang:Right(), outfit.ReplaceItem.yAng || item.yAng || 0)
            Ang:RotateAroundAxis(Ang:Forward(), outfit.ReplaceItem.zAng || item.zAng || 0)
            Pos = Pos-Ang:Right()*(outfit.ReplaceItem.xPos || item.xPos || 0)
            Pos = Pos-Ang:Up()*(outfit.ReplaceItem.yPos || item.yPos || 0)
            Pos = Pos-Ang:Forward()*(outfit.ReplaceItem.zPos || item.zPos || 0)
            outfit:SetRenderAngles(Ang)
            outfit:SetRenderOrigin(Pos)
            outfit:SetModelScale(outfit.ReplaceItem.AttachBoneScaleModel || item.AttachBoneScaleModel, 0)
            outfit:SetupBones()
            outfit:DrawModel()
            outfit:SetRenderOrigin()
	        outfit:SetRenderAngles()
        elseif ( outfit.parentType == "BonemergeSystem" ) then
            if ( !outfit:IsEffectActive(EF_BONEMERGE) ) then
                outfit:AddEffects(EF_BONEMERGE)
            elseif ( !IsValid(outfit:GetParent()) ) then
                outfit:SetParent(owner)
            end

            ply:ClothingSystemSetDrawing(true)
            outfit:DrawModel()
            ply:ClothingSystemSetDrawing(false)
        end
    end
end
hook.Add("PostPlayerDraw", "ClothingSystem.DrawClothing", DrawClothing)