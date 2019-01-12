ClothingSystem.Tools.Network.AddNetwork("ClothingStorageSystem.EntitySpawner", function (len, data, ply)
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
        if (data['type'] == "weapon" && data['usetype'] == "use") then
            list.Get("clothing_storage_system")[class].giveAmmo(ply, table[class]['serverside'], class, true)
        else
            local entity = ents.Create( class )
            if ( !IsValid( entity ) ) then return end
            entity:SetModel( table[class]['model'] )
            entity:SetSkin( table[class]['skin'] )
            entity:SetPos( tr.HitPos )
            entity.ammo = -1
            entity.clip1 = -1
            entity.clip2 = -1
            for k, v in pairs(table[class]['bodygroups']) do
                entity:SetBodygroup(k, v)
            end
            if (data['usetype'] == "drop" && data['type'] == "weapon") then
                entity.ammo = table[class]['serverside']['ammo']
                entity.clip1 = table[class]['serverside']['clip1']
                entity.clip2 = table[class]['serverside']['clip2']
            end
            entity:Spawn()
            local phys = entity:GetPhysicsObject()
            if ( phys:IsValid() ) then
                phys:Wake()
            end

            ClothingStorageSystem:GetItem(class).spawn(ply, table[class]['serverside'], entity)

            if (data['usetype'] == "use") then
                entity:Use(ply, entity, USE_ON, 1)
            else
                entity:SetOwner(ply)
                if (engine.ActiveGamemode() != "darkrp" && data['type'] != "weapon") then
                    undo.Create( tostring(entity:GetClass()) )
                        undo.AddEntity( entity )
                        undo.SetPlayer( ply )
                    undo.Finish()
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

local function PlayerCanPickupWeapon(ply, weapon)
    if (weapon.ammo != nil) then
        if (weapon.ammo != -1) then
            local ammo2 = 0
            local clip1 = 0
            local clip2 = 0
            if (ply:HasWeapon(weapon:GetClass())) then
                local gun = ply:GetWeapon(weapon:GetClass())
                ammo2 = ply:GetAmmoCount(gun:GetPrimaryAmmoType())
                clip1 = gun:Clip1()
                clip2 = gun:Clip2()
            end
            -- GetConVar("sv_manualweaponpickup"):SetInt(0)
            return ClothingStorageSystem:WeaponPickup(ply, weapon:GetClass(), weapon.ammo+ammo2, weapon.clip1, weapon.clip2, clip1, clip2)
        end
    end
end
ClothingSystem.Tools.Hooks.AddHook("PlayerCanPickupWeapon", PlayerCanPickupWeapon)