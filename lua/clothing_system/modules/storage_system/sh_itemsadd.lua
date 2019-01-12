-- hook.Add("StorageSystem.Add", "Storage.FG.AddCustomItems", function()
ClothingStorageSystem:Add({
    ['class'] = "item_healthkit",
    ['weight'] = 5,
})

ClothingStorageSystem:Add({
    ['class'] = "item_healthvial",
    ['weight'] = 3,
})

ClothingStorageSystem:Add({
    ['class'] = "item_battery",
    ['weight'] = 3,
})

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

ClothingStorageSystem:Add({
    ['class'] = "weapon_ar2",
    ['weight'] = 6,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_bugbait",
    ['weight'] = 1,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_crossbow",
    ['weight'] = 6,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_crowbar",
    ['weight'] = 2,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_frag",
    ['weight'] = 1,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_physcannon",
    ['weight'] = 4,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_pistol",
    ['weight'] = 3,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_rpg",
    ['weight'] = 10,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_shotgun",
    ['weight'] = 6,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_slam",
    ['weight'] = 1,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_smg1",
    ['weight'] = 4,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_stunstick",
    ['weight'] = 2,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "gmod_camera",
    ['weight'] = 2,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_medkit",
    ['weight'] = 2,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "weapon_physgun",
    ['weight'] = 4,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "gmod_tool",
    ['weight'] = 2,
    ['weapon'] = true,
})

ClothingStorageSystem:Add({
    ['class'] = "guitar",
    ['weight'] = 7,
    ['weapon'] = true,
})
-- end)