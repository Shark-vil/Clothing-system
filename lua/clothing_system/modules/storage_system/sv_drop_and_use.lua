print("[ClothingSystem] Init module - Storage System: (SV) sv_drop_and_use.lua")

net.Receive("ClothingStorageSystem.EntitySpawner", function(len, ply)
    local data = net.ReadTable()
    local steamid

    if (game.SinglePlayer()) then
        steamid = "single_player"
    else
        steamid = ply:SteamID64()
    end

    local getitem = file.Read("clothing_system/pockets/"..steamid..".dat", "DATA")
    getitem = util.JSONToTable(getitem)

    local class = table.GetFirstKey(getitem[data['clothClass']][data['pocket']]['items'][data['index']])
    local table = getitem[data['clothClass']][data['pocket']]['items'][data['index']]

    local tr = ClothingStorageSystem:GetTrace(ply)

    if (tr != nil) then
        local entity = ents.Create( class )
        if ( !IsValid( entity ) ) then return end
        entity:SetModel( table[class]['model'] )
        entity:SetSkin( table[class]['skin'] )
        if (data['usetype'] == "drop") then
            entity:SetPos( tr.HitPos )
        elseif (data['usetype'] == "use") then
            entity:SetPos( Vector(math.random(-10000, 10000), math.random(-10000, 10000), math.random(-1000000, -100000)) )
        end
        for k, v in pairs(table[class]['bodygroups']) do
            entity:SetBodygroup(k, v)
        end
        entity:Spawn()
        ClothingStorageSystem:GetItem(class).spawn(ply, table[class]['serverside'], entity)
        local phys = entity:GetPhysicsObject()
        if ( phys:IsValid() ) then
            phys:Wake()
        end
        
        if (data['usetype'] == "use") then
            entity:Use(ply, entity, USE_ON, 1)
            if (list.Get("clothing_storage_system")[class].Use != nil && isbool(list.Get("clothing_storage_system")[class].Use)) then
                if (list.Get("clothing_storage_system")[class].Use == true) then
                    list.Get("clothing_storage_system")[class].Use(ply, entity)
                end
            end
        end

        getitem[data['clothClass']][data['pocket']]['items'][data['index']] = nil
        if (ClothingStorageSystem:GetItem(class).weight != nil) then
            getitem[data['clothClass']][data['pocket']]['weight'] = getitem[data['clothClass']][data['pocket']]['weight'] + ClothingStorageSystem:GetItem(class).weight
        end
        file.Write("clothing_system/pockets/"..steamid..".dat", util.TableToJSON(getitem, true))
    end
end)