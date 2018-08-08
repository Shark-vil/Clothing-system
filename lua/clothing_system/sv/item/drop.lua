-- Вызывается, когда игрок выбрасывает вещь.
local function drop(len, ply)
    local class = net.ReadString()
    local ReplaceItem = ClothingSystem:CheckReplace(class, ply)
    local ReplcaeBone

    -- if (ReplaceItem && ReplaceItem.TypePut) then
    --     ReplcaeBone = ReplaceItem.TypePut
    -- else
    --     ReplcaeBone = ClothingSystem:GetItem(class).TypePut
    -- end

    if (ReplaceItem && ReplaceItem.TypePut) then
        ReplcaeBone = ReplaceItem.TypePut
    elseif (ClothingSystem:GetItem(class).TypePut) then
        ReplcaeBone = ClothingSystem:GetItem(class).TypePut
    elseif (ClothingSystem:GetItem(class).Accessory) then
        ReplcaeBone = {}
    end

    ClothingSystem:PlayerRemoveItem(ply, class)
    if (!ClothingSystem:GetItem(class).SetPlayerModel) then
        ply:ClothingSystemLetBone(class, ReplcaeBone)
    end
    hook.Call("ClothingSystemSpawnItem", nil, ply, class)
    hook.Run( "ClothingSystem.Drop", class, player.GetBySteamID(ply:SteamID()))

    net.Start("ClothingSystem.DropItem")
        net.WriteString(class)
        net.WriteString(ply:SteamID())
    net.Broadcast()
end
net.Receive("ClothingSystem.DropItem", drop)

-- Вызывается, когда игрок выбрасывает вещь через команды в чате
hook.Add( "PlayerSay", "ClothingSystem.SayDrop", function( ply, text, team )
    local command = "/itemdrop"
    local ReplaceItem = ClothingSystem:CheckReplace(class, ply)
    local ReplcaeBone

    if (ReplaceItem && ReplaceItem.TypePut) then
        ReplcaeBone = ReplaceItem.TypePut
    elseif (ClothingSystem:GetItem(class).TypePut) then
        ReplcaeBone = ClothingSystem:GetItem(class).TypePut
    elseif (ClothingSystem:GetItem(class).Accessory) then
        ReplcaeBone = {}
    end

    if ( command == string.sub(text, 1, string.len(command)) ) then
        local class = string.sub( text, string.len(command)+1 )
        class = string.gsub(class, "%s+", "")
        local list = ClothingSystem:PlayerGetItems(ply)

        if ( table.Count(list) != 0 ) then
            if ( table.HasValue(list, class) ) then
                ClothingSystem:PlayerRemoveItem(ply, class)
                if (!ClothingSystem:GetItem(class).SetPlayerModel) then
                    ply:ClothingSystemLetBone(class, ReplcaeBone)
                end
                hook.Call("ClothingSystemSpawnItem", nil, ply, class)
                hook.Run( "ClothingSystem.Drop", class, player.GetBySteamID(ply:SteamID()))

                net.Start("ClothingSystem.DropItem")
                    net.WriteString(class)
                    net.WriteString(ply:SteamID())
                net.Broadcast()
            end
        end

        return ""
	end
end)


concommand.Add("debug_clothing", function(ply, command, args)
    if (ply:IsSuperAdmin() || ply:IsAdmin()) then
        for _, p in ipairs(player.GetAll()) do
            p.ClothingSystemWearList = {}
            p:SendLua([[
                LocalPlayer().ClothingSystemWearList = {}
            ]])
            p.ClothingSystemPlayerIsSpawn = true
            
            p:SendLua([[
                LocalPlayer().ClothingSystemPlayerIsSpawn = true
            ]])
        end
    end
end)