ClothingSystem.Tools.Hooks.AddHook("Clothing.Dev.Drop", function(ply, class, removeItem)
    if (ply == nil) then return end
    if (class == nil) then return end
    if (removeItem == nil) then removeItem = false end

    local items = ClothingSystem:PlayerGetItems(ply, true)

    local ReplaceItem = ClothingSystem:CheckReplace(class, ply)
    local OpenBones = {}
    
    local item = list.Get("clothing_system")[class]
    if (item == nil) then return end

    if (ReplaceItem && ReplaceItem.TypePut) then
        OpenBones = ReplaceItem.TypePut
    elseif (item.TypePut) then
        OpenBones = item.TypePut
    elseif (item.Accessory) then
        OpenBones = {}
    end

    if ( table.Count(items) != 0 ) then
        if ( table.HasValue(items, class) ) then
            ClothingSystem:PlayerRemoveItem(ply, class)
            if (!item.SetPlayerModel) then
                ply:ClothingSystemLetBone(class, OpenBones)
            end
            if (removeItem) then
                hook.Run("ClothingSystemSpawnItem", ply, class)
            end

            ClothingSystem.Tools.Network.Send("Broadcast", "DropItem", {class = class, steamid = ply:SteamID()})
        end
    end
end)

ClothingSystem.Tools.Hooks.AddHook("Clothing.Dev.Equip", function(ply, class, insertData)
    if (ply == nil || !IsValid(ply)) then return end
    if (class == nil) then return end
    if (insertData == nil) then insertData = false end

    local item = list.Get("clothing_system")[class]
    if (item == nil) then return end

    if ( item.Equip ) then
        item.Equip(ply, class)
    end

    ClothingSystem:WearParts(class, ply, nil, "broadcast", insertData)
end)