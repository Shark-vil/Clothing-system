ClothingSystem.Tools.Network.AddNetwork("ClothingStorageSystem.SendToServerAddFile", function (len, data, ply)
    local DATA = data
    if ( ClothingStorageSystem:CheckProtect(ply, DATA) ) then
        local steamid
        local _weight
        local Entity = ents.GetByIndex(DATA['entityID'])
        if (!IsValid(Entity)) then
            ply:SendLua([[
                chat.AddText("]]..ClothingSystem.Language.vguiMenu_Storage_EntityDestroyed..[[!")
            ]])
            return
        end
        local item = ClothingStorageSystem:GetItem(Entity:GetClass())
        local entitySaveServerside = {}
        if (item.serverSave != nil) then
            entitySaveServerside = item.serverSave(ply, Entity)
        end
        DATA['entityModel'] = Entity:GetModel()
        DATA['entitySaveServerside'] = entitySaveServerside
        DATA['entityBodygroupsActive'] = {}
        local bodygroups = Entity:GetBodyGroups()
        for k, v in ipairs(bodygroups) do
            DATA['entityBodygroupsActive'][v.id] = Entity:GetBodygroup(v.id)
        end
        DATA['entitySkinActive'] = Entity:GetSkin()

        if (Entity:IsWeapon()) then
            DATA['type'] = "weapon"
        elseif (Entity:IsVehicle()) then
            DATA['type'] = "vehicle"
        elseif (Entity:IsNPC()) then
            DATA['type'] = "npc"
        else
            DATA['type'] = "entity"
        end

        if (!file.IsDir("clothing_system/pockets", "DATA")) then
            file.CreateDir("clothing_system/pockets")
        end
        if (game.SinglePlayer()) then
            steamid = "single_player"
        else
            steamid = ply:SteamID64()
        end

        local _file = file.Read("clothing_system/pockets/"..steamid..".dat", "DATA")

        if (_file != nil) then
            _file = util.JSONToTable(_file)
            if (_file[DATA['class']] == nil) then
                _file[DATA['class']] = {}
            end
            for k, v in pairs(list.Get("clothing_system")[DATA['class']].Pockets) do
                if (k == DATA['pocket']) then
                    if (_file[DATA['class']][DATA['pocket']] == nil) then
                        _file[DATA['class']][DATA['pocket']] = {}
                        _file[DATA['class']][DATA['pocket']]['weight'] = v
                        _file[DATA['class']][DATA['pocket']]['items'] = {}
                        _file[DATA['class']][DATA['pocket']]['items'][0] = {}
                        _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']] = {}
                        _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['bodygroups'] = DATA['entityBodygroupsActive']
                        _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['skin'] = DATA['entitySkinActive']
                        _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['model'] = DATA['entityModel']
                        _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['serverside'] = DATA['entitySaveServerside']
                        _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['clientside'] = DATA['entitySaveClientside']
                        _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['type'] = DATA['type']
                        _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['name'] = DATA['entityName']
                    else
                        local index = 0
                        if (table.Count(_file[DATA['class']][DATA['pocket']]['items']) != 0) then
                            index = #_file[DATA['class']][DATA['pocket']]['items'] + 1
                        end
                        _file[DATA['class']][DATA['pocket']]['items'][index] = {}
                        _file[DATA['class']][DATA['pocket']]['items'][index][DATA['entityClass']] = {}
                        _file[DATA['class']][DATA['pocket']]['items'][index][DATA['entityClass']]['bodygroups'] = DATA['entityBodygroupsActive']
                        _file[DATA['class']][DATA['pocket']]['items'][index][DATA['entityClass']]['skin'] = DATA['entitySkinActive']
                        _file[DATA['class']][DATA['pocket']]['items'][index][DATA['entityClass']]['model'] = DATA['entityModel']
                        _file[DATA['class']][DATA['pocket']]['items'][index][DATA['entityClass']]['serverside'] = DATA['entitySaveServerside']
                        _file[DATA['class']][DATA['pocket']]['items'][index][DATA['entityClass']]['clientside'] = DATA['entitySaveClientside']
                        _file[DATA['class']][DATA['pocket']]['items'][index][DATA['entityClass']]['type'] = DATA['type']
                        _file[DATA['class']][DATA['pocket']]['items'][index][DATA['entityClass']]['name'] = DATA['entityName']
                    end
                elseif (_file[DATA['class']][k] == nil) then
                    _file[DATA['class']][k] = {}
                    _file[DATA['class']][k] = {}
                    _file[DATA['class']][k]['weight'] = v
                    _file[DATA['class']][k]['items'] = {}
                end
            end

            _weight = item.weight || 0

            if (_file[DATA['class']][DATA['pocket']]['weight'] < _weight) then
                ply:SendLua([[
                    chat.AddText("]]..ClothingSystem.Language.vguiMenu_Storage_noFreeSlot..[[!")
                ]])
                return
            else
                _file[DATA['class']][DATA['pocket']]['weight'] = _file[DATA['class']][DATA['pocket']]['weight'] - _weight
            end
            file.Write("clothing_system/pockets/"..steamid..".dat", util.TableToJSON(_file, true))
            Entity:Remove()
        else
            _file = {}
            _file[DATA['class']] = {}
            for k, v in pairs(list.Get("clothing_system")[DATA['class']].Pockets) do
                if (k == DATA['pocket']) then
                    _file[DATA['class']][DATA['pocket']] = {}
                    _file[DATA['class']][DATA['pocket']]['weight'] = v
                    _file[DATA['class']][DATA['pocket']]['items'] = {}
                    _file[DATA['class']][DATA['pocket']]['items'][0] = {}
                    _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']] = {}
                    _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['bodygroups'] = DATA['entityBodygroupsActive']
                    _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['skin'] = DATA['entitySkinActive']
                    _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['model'] = DATA['entityModel']
                    _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['serverside'] = DATA['entitySaveServerside']
                    _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['clientside'] = DATA['entitySaveClientside']
                    _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['type'] = DATA['type']
                    _file[DATA['class']][DATA['pocket']]['items'][0][DATA['entityClass']]['name'] = DATA['entityName']
                else
                    _file[DATA['class']][k] = {}
                    _file[DATA['class']][k] = {}
                    _file[DATA['class']][k]['weight'] = v
                    _file[DATA['class']][k]['items'] = {}
                end
            end

            _weight = item.weight || 0
            print(_file[DATA['class']][DATA['pocket']]['weight'])
            print(_weight)
            if (_file[DATA['class']][DATA['pocket']]['weight'] < _weight) then
                ply:SendLua([[
                    chat.AddText("]]..ClothingSystem.Language.vguiMenu_Storage_noFreeSlot..[[!")
                ]])
                return
            else
                _file[DATA['class']][DATA['pocket']]['weight'] = _file[DATA['class']][DATA['pocket']]['weight'] - _weight
            end
            file.Write("clothing_system/pockets/"..steamid..".dat", util.TableToJSON(_file, true))
            Entity:Remove()
        end
    else
        for _, user in ipairs(player.GetAll()) do
            if (user:IsAdmin() || user:IsSuperAdmin()) then
                if (ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] < 2) then
                    user:SendLua([[
                        chat.AddText(Color(255, 0, 0), "[ClothingSystem][Protected]: The reason for the detection, the player: ]]..ply:Nick()..[[")
                    ]])
                    user:SendLua([[
                        chat.AddText(Color(255, 0, 0), "[ClothingSystem][Protected]: Attempts to violate: ]]..ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()]..[[/2")
                    ]])
                    user:SendLua([[
                        chat.AddText(Color(0, 255, 0), "[ClothingSystem][Protected]: >>> STEAMID: ]]..ply:SteamID()..[[ <<<")
                    ]])
                    user:SendLua([[
                        chat.AddText(Color(255, 216, 23), "[ClothingSystem][Protected]: Attempt to change no parameters!")
                    ]])
                else
                    user:SendLua([[
                        chat.AddText(Color(255, 0, 0), "[ClothingSystem][Protected]: The player ']]..ply:Nick()..[[' was kicked from the server.")
                    ]])
                    user:SendLua([[
                        chat.AddText(Color(255, 216, 23), "[ClothingSystem][Protected]: a series of attempts to change the NET parameters!")
                    ]])
                end
            end
        end
    end
end)