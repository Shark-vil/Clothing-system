ClothingSystem.Tools.Hooks.AddHook("ClothingSystem.PlayerSay", function( ply, text, team )
    local command, object, item, class, finalTable, bodygroups, data, tr, BlackListWeapons, steamid

    command = "/storage"
    if ( string.Left(string.lower(text), string.len(command)) == string.lower(command) ) then
        if (game.SinglePlayer()) then steamid = "single_player" else steamid = ply:SteamID64() end
        data = file.Read("clothing_system/pockets/"..steamid..".dat", "DATA")
        
        if (data == nil) then
            data = {}
        else
            data = util.JSONToTable(data)
        end

        local items = ClothingSystem:PlayerGetItems(ply)
 
        if ( !ClothingSystem:TableIsEmpty(items) ) then
            for _, class in pairs(items) do
                if (data[class] == nil) then
                    local _item = list.Get("clothing_system")[class]
                    if (_item.Pockets != nil) then
                        data[class] = {}
                        for k, v in pairs(_item.Pockets) do
                            data[class][k] = {}
                            data[class][k]['weight'] = v
                            data[class][k]['items'] = {}
                        end
                    end
                end
            end
            file.Write("clothing_system/pockets/"..steamid..".dat", util.TableToJSON(data, true))
        else
            ply:AddText(ClothingSystem.Language.vguiMenu_Storage_noClothes)
            return ""
        end
        
        ClothingSystem.Tools.Network.Send("send", "ClothingStorageSystem.OpenStorageMenu", data, nil, ply)
        return ""
    end
    
    command = "/storadd"
	if ( string.Left(string.lower(text), string.len(command)) == string.lower(command) ) then
        tr = ClothingStorageSystem:GetTrace(ply)
        
        if (IsValid(tr.Entity)) then
            object = tr.Entity
            class = object:GetClass()
            item = ClothingStorageSystem:GetItem(class)
            if (item != false) then
                finalTable = {}
                finalTable['entityID'] = object:EntIndex()
                finalTable['entityClass'] = class
                finalTable['entityValue'] = CurTime() * math.random(10, 100)

                ClothingStorageSystem:AddProtect(ply, finalTable)
                
                ClothingSystem.Tools.Network.Send("send", "ClothingStorageSystem.OpenAddItemMenu", finalTable, nil, ply)
            else
                ply:SendLua([[
                    chat.AddText("]]..ClothingSystem.Language.vguiMenu_Storage_notPickUp..[[.")
                ]])
            end
        else
            ply:SendLua([[
                chat.AddText("]]..ClothingSystem.Language.vguiMenu_Storage_notPickUp..[[.")
            ]])
        end

        return ""
    end
    
    command = "/storwep"
	if ( string.Left(string.lower(text), string.len(command)) == string.lower(command) ) then
        if (IsValid(ply) && ply:Alive() && IsValid(ply:GetActiveWeapon())) then
            object = ply:GetActiveWeapon()
            class = object:GetClass()
            item = ClothingStorageSystem:GetItem(class)
            if (item != false) then
                finalTable = {}
                finalTable['entityID'] = object:EntIndex()
                finalTable['entityClass'] = class
                finalTable['entityValue'] = CurTime() * math.random(10, 100)

                ClothingStorageSystem:AddProtect(ply, finalTable)
                
                ClothingSystem.Tools.Network.Send("send", "ClothingStorageSystem.OpenAddItemMenu", finalTable, nil, ply)
            else
                ply:SendLua([[
                    chat.AddText("]]..ClothingSystem.Language.vguiMenu_Storage_notPickUp..[[.")
                ]])
            end
        else
            ply:SendLua([[
                chat.AddText("]]..ClothingSystem.Language.vguiMenu_Storage_notPickUp..[[.")
            ]])
        end

        return ""
	end
end)