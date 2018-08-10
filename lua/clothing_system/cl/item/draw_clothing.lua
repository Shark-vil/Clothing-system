-- Отрисовка одежды

local function DrawClothing(owner)    
    if (!IsValid(LocalPlayer())) then return end
    if (!IsValid(owner) || !owner:IsPlayer() || !owner:Alive()) then return end
    if (owner:IsDormant() || LocalPlayer():IsDormant()) then return end
    if (LocalPlayer():GetPos():Distance(owner:GetPos()) >= 2000) then 
        return 
    elseif (LocalPlayer():GetPos():Distance(owner:GetPos()) >= 500) then
        if (!LocalPlayer():IsLineOfSightClear(owner:GetPos())) then 
            return 
        end
    end

    -- Защита от двойной отрисовки
    if ( LocalPlayer():ClothingSystemGetDrawing() ) then
        return
    end

    if ( owner:GetMoveType() == MOVETYPE_OBSERVER ) then return end
    
    -- Проверка на наличие массива с информацией об одежде у локального игрока
    local steamid

    if (game.SinglePlayer()) then
        steamid = "STEAM_0:0:0"
    else
        steamid = owner:SteamID()
    end

    if (LocalPlayer().ClothingSystemWearList == nil || LocalPlayer().ClothingSystemWearList[steamid] == nil) then return end

    -- Цикл по массиву с одеждой
    for k, outfit in pairs( LocalPlayer().ClothingSystemWearList[steamid] ) do
        if (!IsValid(outfit)) then return end
        if (outfit.SetPlayerModel) then return end
        if (outfit.Module) then return end
        
        if (steamid == LocalPlayer():SteamID()) then
            LocalPlayer().ClothingSystemData['DrawOverlay'] = false
        end

        -- Выполняется, если тип связки - "BoneAttach"
        if ( outfit.parentType == "BoneAttach" ) then
            local Pos, Ang = owner:GetBonePosition(outfit.Bone)

            Ang:RotateAroundAxis(Ang:Up(), outfit.ReplaceItem.xAng || outfit.xAng || 0)
            Ang:RotateAroundAxis(Ang:Right(), outfit.ReplaceItem.yAng || outfit.yAng || 0)
            Ang:RotateAroundAxis(Ang:Forward(), outfit.ReplaceItem.zAng || outfit.zAng || 0)
            Pos = Pos-Ang:Right()*(outfit.ReplaceItem.xPos || outfit.xPos || 0)
            Pos = Pos-Ang:Up()*(outfit.ReplaceItem.yPos || outfit.yPos || 0)
            Pos = Pos-Ang:Forward()*(outfit.ReplaceItem.zPos || outfit.zPos || 0)
            outfit:SetRenderAngles(Ang)
            outfit:SetRenderOrigin(Pos)
            outfit:SetModelScale(outfit.ReplaceItem.AttachBoneScaleModel || outfit.AttachBoneScaleModel || 1, 0)
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

            LocalPlayer():ClothingSystemSetDrawing(true)
            outfit:DrawModel()
            LocalPlayer():ClothingSystemSetDrawing(false)
        end
    end
end
hook.Add("PostPlayerDraw", "ClothingSystem.DrawClothing", DrawClothing)