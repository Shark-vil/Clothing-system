-- Вызывается, когда игрок выбрасывает вещь.
local function drop(len, data, ply)
    local ReplaceItem = ClothingSystem:CheckReplace(class, ply)
    local ReplcaeBone

    -- if (ReplaceItem && ReplaceItem.TypePut) then
    --     ReplcaeBone = ReplaceItem.TypePut
    -- else
    --     ReplcaeBone = ClothingSystem:GetItem(class).TypePut
    -- end

    local item = list.Get("clothing_system")[data.class]
    if (item == nil) then return end

    if (ReplaceItem && ReplaceItem.TypePut) then
        ReplcaeBone = ReplaceItem.TypePut
    elseif (item.TypePut) then
        ReplcaeBone = item.TypePut
    elseif (item.Accessory) then
        ReplcaeBone = {}
    end

    ClothingSystem:PlayerRemoveItem(ply, data.class)
    if (!item.SetPlayerModel) then
        ply:ClothingSystemLetBone(data.class, ReplcaeBone)
    end

    hook.Run("ClothingSystemSpawnItem", ply, data.class)
    -- ClothingSystem.Tools.Hooks.Call("ClothingSystemSpawnItem", nil, ply, data.class)

    ClothingSystem.Tools.Network.Send("Broadcast", "DropItem", {class = data.class, steamid = ply:SteamID()})
end
ClothingSystem.Tools.Network.AddNetwork("DropItem", drop)

-- Вызывается, когда игрок выбрасывает вещь через команды в чате
ClothingSystem.Tools.Hooks.AddHook("ClothingSystem.PlayerSay", function( ply, text, team )
    local command = "/itemdrop"
    if ( command == string.sub(text, 1, string.len(command)) ) then
        local class = string.sub( text, string.len(command)+1 )
        class = string.gsub(class, "%s+", "")
        local items = ClothingSystem:PlayerGetItems(ply)

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
                hook.Run("ClothingSystemSpawnItem", ply, class)

                ClothingSystem.Tools.Network.Send("Broadcast", "DropItem", {class = class, steamid = ply:SteamID()})
            end
        end

        return ""
    end
    
    command = "/lastdrop"
    if ( command == string.sub(text, 1, string.len(command)) ) then
        local items = ClothingSystem:PlayerGetItems(ply)

        if (#items == 0) then return "" end
        local class = items[#items]

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
                hook.Run("ClothingSystemSpawnItem", ply, class)

                ClothingSystem.Tools.Network.Send("Broadcast", "DropItem", {class = class, steamid = ply:SteamID()})
            end
        end

        return ""
	end
end)