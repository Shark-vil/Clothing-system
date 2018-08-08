print("[ClothingSystem] Init module - Storage System: (SV) sv_chat_commands.lua")

hook.Add( "PlayerSay", "ClothingStorageSystem.ChatCommands", function( ply, text, team )
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
            ply:AddText("You do not have any clothing!")
            return ""
        end
        
        net.Start("ClothingStorageSystem.OpenStorageMenu")
        net.WriteTable(data)
        net.Send(ply)
        return ""
    end
    
    command = "/storadd"
	if ( string.Left(string.lower(text), string.len(command)) == string.lower(command) ) then
        -- tr = util.TraceLine( util.GetPlayerTrace(ply) )
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
                
                net.Start("ClothingStorageSystem.OpenAddItemMenu")
                net.WriteTable(finalTable)
                net.Send(ply)
            else
                ply:SendLua([[
                    chat.AddText("You can not pick up this object.")
                ]])
            end
        else
            ply:SendLua([[
                chat.AddText("You can not pick up this object.")
            ]])
        end

        return ""
    end
    
    command = "/storwep"
	if ( string.Left(string.lower(text), string.len(command)) == string.lower(command) ) then
        BlackListWeapons = {
            "weapon_physgun",
        }
        
        if (IsValid(ply) && ply:Alive() && IsValid(ply:GetActiveWeapon()) && !table.HasValue(BlackListWeapons, ply:GetActiveWeapon():GetClass())) then
            object = ply:GetActiveWeapon()
            class = object:GetClass()
            item = ClothingStorageSystem:GetItem(class)
            if (item != false) then
                finalTable = {}
                finalTable['entityID'] = object:EntIndex()
                finalTable['entityClass'] = class
                finalTable['entityValue'] = CurTime() * math.random(10, 100)

                ClothingStorageSystem:AddProtect(ply, finalTable)
                
                net.Start("ClothingStorageSystem.OpenAddItemMenu")
                net.WriteTable(finalTable)
                net.Send(ply)
            else
                ply:SendLua([[
                    chat.AddText("You can not pick up this object.")
                ]])
            end
        else
            ply:SendLua([[
                chat.AddText("You can not pick up this object.")
            ]])
        end

        return ""
	end
end)