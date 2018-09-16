-- Вызывается, когда игрок выбрасывает вещь.
local function drop(len, data, ply)
    local ReplaceItem = ClothingSystem:CheckReplace(class, ply)
    local ReplcaeBone

    -- if (ReplaceItem && ReplaceItem.TypePut) then
    --     ReplcaeBone = ReplaceItem.TypePut
    -- else
    --     ReplcaeBone = ClothingSystem:GetItem(class).TypePut
    -- end

    if (ReplaceItem && ReplaceItem.TypePut) then
        ReplcaeBone = ReplaceItem.TypePut
    elseif (ClothingSystem:GetItem(data.class).TypePut) then
        ReplcaeBone = ClothingSystem:GetItem(data.class).TypePut
    elseif (ClothingSystem:GetItem(data.class).Accessory) then
        ReplcaeBone = {}
    end

    ClothingSystem:PlayerRemoveItem(ply, data.class)
    if (!ClothingSystem:GetItem(data.class).SetPlayerModel) then
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
        local list = ClothingSystem:PlayerGetItems(ply)

        local ReplaceItem = ClothingSystem:CheckReplace(class, ply)
        local OpenBones = {}

        if (ReplaceItem && ReplaceItem.TypePut) then
            OpenBones = ReplaceItem.TypePut
        elseif (ClothingSystem:GetItem(class).TypePut) then
            OpenBones = ClothingSystem:GetItem(class).TypePut
        elseif (ClothingSystem:GetItem(class).Accessory) then
            OpenBones = {}
        end

        if ( table.Count(list) != 0 ) then
            if ( table.HasValue(list, class) ) then
                ClothingSystem:PlayerRemoveItem(ply, class)
                if (!ClothingSystem:GetItem(class).SetPlayerModel) then
                    ply:ClothingSystemLetBone(class, OpenBones)
                end
                hook.Run("ClothingSystemSpawnItem", ply, class)

                ClothingSystem.Tools.Network.Send("Broadcast", "DropItem", {class = class, steamid = ply:SteamID()})
            end
        end

        return ""
	end
end)