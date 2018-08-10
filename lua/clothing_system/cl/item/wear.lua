-- Экипировка одежды
local function wear()
    local class = net.ReadString()
    local steamid = net.ReadString()
    local ReplaceItem = net.ReadTable()
    local owner
    local ply = LocalPlayer()
    local parentType
    local Bone

    -- Получаем массив значений текущего item
    local item = ClothingSystem:GetItem(class)

    if (game.SinglePlayer()) then
        owner = LocalPlayer()
    else
        owner = player.GetBySteamID(steamid)
    end

    -- Проверка на существование пользователя в мире
    if (!game.SinglePlayer()) then
        if ( !IsValid(owner) ) then return end
    end

    -- Установка типа спаривания
    if (!item.Module) then
        if ( item.BoneAttach ) then
            if (table.Count(ReplaceItem) != 0 && ReplaceItem.AttachBoneType) then
                Bone = owner:LookupBone(ReplaceItem.AttachBoneType)
            else
                Bone = owner:LookupBone(item.AttachBoneType)
            end

            if ( !Bone ) then
                owner:AddText("WARNING: No bone was found for attachment!")
            end
            parentType = "BoneAttach"
        elseif ( item.BonemergeSystem ) then
            parentType = "BonemergeSystem"
        end
    end

    -- Создание локального пропа
    local outfit
    if (!item.Module && !item.SetPlayerModel) then
        outfit = ClientsideModel( item.WireModel, RENDERGROUP_OPAQUE )
        outfit.Class = class
        outfit.SteamID = steamid
        outfit.parentType = parentType
        outfit.Bone = Bone || 0
        outfit.Module = false
        outfit.SetPlayerModel = false
        outfit.xAng = item.xAng || 0
        outfit.yAng = item.yAng || 0
        outfit.zAng = item.zAng || 0
        outfit.xPos = item.xPos || 0
        outfit.yPos = item.yPos || 0
        outfit.zPos = item.zPos || 0
        outfit.AttachBoneScaleModel = item.AttachBoneScaleModel || 1
        if ( item.Skin ) then
            if (table.Count(ReplaceItem) != 0 && ReplaceItem.Skin) then
                outfit:SetSkin(ReplaceItem.Skin)
            else
                outfit:SetSkin(item.Skin)
            end
        end
        if ( item.Bodygroup ) then
            if (table.Count(ReplaceItem) != 0 && ReplaceItem.Bodygroup) then
                outfit:SetBodygroup(ReplaceItem.Bodygroup[1], ReplaceItem.Bodygroup[2])
            else
                outfit:SetBodygroup(item.Bodygroup[1], item.Bodygroup[2])
            end
        end
        if ( item.Bodygroups ) then
            if (table.Count(ReplaceItem) != 0 && ReplaceItem.Bodygroup) then
                outfit:SetBodygroups(ReplaceItem.Bodygroups)
            else
                outfit:SetBodygroups(item.Bodygroups)
            end
        end
        outfit:SetPos( owner:GetPos() )
        if (table.Count(ReplaceItem) != 0 && ReplaceItem.WireModel) then
            outfit:SetModel( ReplaceItem.WireModel )
        else
            outfit:SetModel( item.WireModel )
        end
        outfit.ReplaceItem = ReplaceItem
        outfit:SetOwner(owner)
        outfit:SetParent(owner)
        outfit:SetNoDraw(true)
    elseif (item.SetPlayerModel) then
        outfit = ClientsideModel( item.WireModel, RENDERGROUP_OPAQUE )
        outfit.Class = class
        outfit.SteamID = steamid
        outfit.Module = false
        outfit.SetPlayerModel = true
        outfit:SetOwner(owner)
        outfit:SetParent(owner)
        outfit:SetNoDraw(true)
    elseif (item.Module)then
        outfit = ClientsideModel( item.WireModel, RENDERGROUP_OPAQUE )
        outfit.Class = class
        outfit.SteamID = steamid
        outfit.Module = true
        outfit.SetPlayerModel = false
        outfit:SetOwner(owner)
        outfit:SetParent(owner)
        outfit:SetNoDraw(true)
    end

    if ( item.GasMask ) then
        outfit.GasMask = true
    end
    if ( item.PowerArmor ) then
        outfit.PowerArmor = true
    end

    -- Добавление пропа во временный массив
    ply:ClothingSystemAddItem(outfit, steamid)

    outfit = nil

    hook.Run( "ClothingSystem.Wear", class, owner)
end
net.Receive("ClothingSystem.WearEveryone", wear)