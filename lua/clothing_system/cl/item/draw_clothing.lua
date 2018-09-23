-- Отрисовка одежды

local function DrawClothing(owner)    
    if (!IsValid(LocalPlayer())) then return end
    if (!IsValid(owner) || !owner:IsPlayer() || !owner:Alive()) then return end
    if (owner:IsDormant() || LocalPlayer():IsDormant()) then return end
    if (LocalPlayer():GetPos():Distance(owner:GetPos()) > 2000) then 
        return 
    elseif (LocalPlayer():GetPos():Distance(owner:GetPos()) > 500) then
        if (!LocalPlayer():IsLineOfSightClear(owner:GetPos())) then 
            return 
        end
    end

    -- Защита от двойной отрисовки
    if ( LocalPlayer().clothingsystem_scm_Draw ) then
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

        if (outfit.ChangeModelDamage) then
            local health = outfit:GetOwner():Health()
            local isChange = false
            for _, v in ipairs(outfit.ChangeModelDamage) do
                if (health <= v[2]) then
                    outfit:SetModel(v[1])
                    isChange = true
                    break
                end
            end

            if (!isChange && outfit:GetModel() != outfit.WireModel) then
                outfit:SetModel(outfit.WireModel)
            end
        end

        -- Выполняется, если тип связки - "BoneAttach"
        if ( outfit.parentType == "BoneAttach" ) then
            local Pos, Ang = owner:GetBonePosition(outfit.Bone)

            if (outfit.Developing) then
                local construct = list.Get('clothing_system')[outfit.Class]
                Ang:RotateAroundAxis(Ang:Up(), outfit.ReplaceItem.xAng || construct.xAng || 0)
                Ang:RotateAroundAxis(Ang:Right(), outfit.ReplaceItem.yAng || construct.yAng || 0)
                Ang:RotateAroundAxis(Ang:Forward(), outfit.ReplaceItem.zAng || construct.zAng || 0)
                Pos = Pos-Ang:Right()*(outfit.ReplaceItem.xPos || construct.xPos || 0)
                Pos = Pos-Ang:Up()*(outfit.ReplaceItem.yPos || construct.yPos || 0)
                Pos = Pos-Ang:Forward()*(outfit.ReplaceItem.zPos || construct.zPos || 0)
                outfit:SetModelScale(outfit.ReplaceItem.ScaleModel || construct.ScaleModel || 1, 0)
            else
                Ang:RotateAroundAxis(Ang:Up(), outfit.ReplaceItem.xAng || outfit.xAng || 0)
                Ang:RotateAroundAxis(Ang:Right(), outfit.ReplaceItem.yAng || outfit.yAng || 0)
                Ang:RotateAroundAxis(Ang:Forward(), outfit.ReplaceItem.zAng || outfit.zAng || 0)
                Pos = Pos-Ang:Right()*(outfit.ReplaceItem.xPos || outfit.xPos || 0)
                Pos = Pos-Ang:Up()*(outfit.ReplaceItem.yPos || outfit.yPos || 0)
                Pos = Pos-Ang:Forward()*(outfit.ReplaceItem.zPos || outfit.zPos || 0)
                outfit:SetModelScale(outfit.ReplaceItem.ScaleModel || outfit.ScaleModel || 1, 0)
            end

            outfit:SetRenderAngles(Ang)
            outfit:SetRenderOrigin(Pos)
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

            LocalPlayer().clothingsystem_scm_Draw = true
            outfit:DrawModel()
            LocalPlayer().clothingsystem_scm_Draw = false
        end
    end
end
ClothingSystem.Tools.Hooks.AddHook("PostPlayerDraw", DrawClothing)