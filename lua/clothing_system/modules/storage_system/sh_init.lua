print("[ClothingSystem] Init module - Storage System: (SH) sh_init.lua")

--[[
hook.Add( "InitPostEntity", "ClothingStorageSystem.AddModules", function()
    ClothingStorageSystem:Add({
        ['class'] = "sent_ball",
        ['weight'] = 5,
        ['server'] = function(ply, ent)
            return {
                ['size'] = ent:GetBallSize(),
                ['color'] = ent:GetBallColor(),
            }
        end,
        ['client'] = function(ply, ent)
            return {}
        end,
        ['spawn'] = function(ply, array, ent)
            ent:SetBallColor(array['color'])
            ent:SetBallSize(array['size'])
        end,
    })

    ClothingStorageSystem:Add({
        ['class'] = "weapon_357",
        ['weight'] = 3,
        ['weapon'] = true,
    })
end)
]]

list.Set( "clothing_storage_system", "sent_ball", {
    weight = 5,
    spawn = function(ply, array, ent)
        ent:SetBallColor(array['color'])
        ent:SetBallSize(array['size'])
    end,
    serverSave = function(ply, ent)
        return {
            ['size'] = ent:GetBallSize(),
            ['color'] = ent:GetBallColor(),
        }
    end,
    clientSave = function(ply, ent)
        return {}
    end,
} )

list.Set( "clothing_storage_system", "weapon_357", {
    weight = 3,
    spawn = function(ply, array, ent)
        ClothingStorageSystem:WeaponGive(ply, array, ent)
    end,
    serverSave = function(ply, ent)
        return ClothingStorageSystem:WeaponSave(ply, ent)
    end,
    clientSave = function(ply, ent)
        return {}
    end,
} )