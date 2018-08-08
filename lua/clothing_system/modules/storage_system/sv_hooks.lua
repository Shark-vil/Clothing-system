print("[ClothingSystem] Init module - Storage System: (SV) sv_hooks.lua")

hook.Add( "ClothingSystem.Drop", "ClothingStorageSystem.DropSaveData", function(ply, item, item_class)
    if (!IsValid(ply) || !ply:Alive()) then return end

    local steamid
    if (game.SinglePlayer()) then
        steamid = "single_player"
    else
        steamid = ply:SteamID64()
    end

    local _file = file.Read("clothing_system/pockets/"..steamid..".dat", "DATA")

    if (_file != nil) then
        _file = util.JSONToTable(_file)
        if (_file[item_class] != nil) then
            item["saveArray"]['StorageSystemSave'] = _file[item_class]

            _file[item_class] = nil
            file.Write("clothing_system/pockets/"..steamid..".dat", util.TableToJSON(_file, true))
        end
    end
end)

hook.Add("ClothingSystem.Wear", "ClothingStorageSystem.WearData", function(class, ply, tbl)
    if (tbl['StorageSystemSave'] != nil) then
        if (tbl['StorageSystemSave'] != nil) then
            local steamid
            if (game.SinglePlayer()) then
                steamid = "single_player"
            else
                steamid = ply:SteamID64()
            end

            local _file = file.Read("clothing_system/pockets/"..steamid..".dat", "DATA")

            if (_file != nil) then
                _file = util.JSONToTable(_file)
                _file[class] = tbl['StorageSystemSave']
                file.Write("clothing_system/pockets/"..steamid..".dat", util.TableToJSON(_file, true))
            else
                _file = {}
                _file[class] = tbl['StorageSystemSave']
                file.Write("clothing_system/pockets/"..steamid..".dat", util.TableToJSON(_file, true))
            end
        end
    end
end)

hook.Add("PlayerDeath", "ClothingStorageSystem.PlayerDeathSaveData", function(ply, inflictor, attacker)
    if (!IsValid(ply) || !ply:Alive()) then return end

    local steamid
    if (game.SinglePlayer()) then
        steamid = "single_player"
    else
        steamid = ply:SteamID64()
    end

    file.Write("clothing_system/pockets/"..steamid..".dat", "[]")
end)