local function drop(ply, item_class, tbl, item)
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
end
ClothingSystem.Tools.Hooks.AddHook("ClothingSystem.Drop", drop)

local function wear(ply, class, tbl, entity)
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
end
ClothingSystem.Tools.Hooks.AddHook("ClothingSystem.Wear", wear)

local function PlayerDeath(ply, inflictor, attacker)
    if (!IsValid(ply) || !ply:Alive()) then return end

    local steamid
    if (game.SinglePlayer()) then
        steamid = "single_player"
    else
        steamid = ply:SteamID64()
    end

    file.Write("clothing_system/pockets/"..steamid..".dat", "[]")
end
ClothingSystem.Tools.Hooks.AddHook("PlayerDeath", PlayerDeath)