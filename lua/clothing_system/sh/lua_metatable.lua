local logFileName = logFileName || "TIME="..os.date("%H.%M.%S@DATE=%d.%m.%Y", os.time())

if ( SERVER ) then
    if ( ClothingSystem.Config.LogOn && !file.Exists("clothing_system/log/"..logFileName..".txt", "DATA") ) then
        file.Write("clothing_system/log/"..logFileName..".txt", "> Clothing-System - Start Log <")
    end
end

local META = {    
    -- Обновление типа костей игрока и стандартных массивов
	UpdateBoneType = function(self, ply)
        if SERVER then
            if (!IsValid(ply) || !ply:IsPlayer()) then return end

            local list = ClothingSystem:GetBase()

			for type, _ in pairs(list) do
				for key, value in pairs(list[type]) do
					if ( list[type].NiceModel ) then
						if ( table.HasValue(value, ply:GetModel()) ) then
                            ply:ClothingSystemConstruct(list[type].BoneType, type)

                            ClothingSystem.Tools.Network.Send("Send", "ConstructData", {bones = list[type].BoneType, type = type}, nil, ply)
							return
						end
					end
				end
			end
				
            ply:ClothingSystemConstruct(list["hl2_player"].BoneType, "hl2_player")

            ClothingSystem.Tools.Network.Send("Send", "ConstructData", {bones = list["hl2_player"].BoneType, type = "hl2_player"}, nil, ply)
		end
    end,

    SendLua = function( self, ply, code )
        net.Start("ClothingSystem.SendLua.BigCode")
        net.WriteString(code)
        net.Send(ply)
    end,
    
    -- Dev log
    log = function( self, text )
        if ( SERVER ) then
            if ( ClothingSystem.Config.LogOn ) then
                local time = os.date("( %H:%M:%S ) " , os.time())

                file.Append("clothing_system/log/"..logFileName..".txt", "\n"..time..text)
            end
        end
    end,

    GetSvData = function(self, ply, class, data)
        local PlayerSteamID

        if (game.SinglePlayer()) then
            PlayerSteamID = "single_player"
        else
            PlayerSteamID = ply:SteamID64()
        end
        
        local dir = "clothing_system/save_data/"..PlayerSteamID
        local name = dir.."/"..class..".dat"

        if (file.Exists(name, "DATA")) then
            local tData = file.Read(name, "DATA")
            tData = util.JSONToTable(tData)

            for k, v in pairs(tData) do
                if (k == data) then
                    return v
                end
            end
        else
            return
        end
    end,

    SaveSvData = function(self, ply, class, data)
        local PlayerSteamID

        if (game.SinglePlayer()) then
            PlayerSteamID = "single_player"
        else
            PlayerSteamID = ply:SteamID64()
        end
        
        local dir = "clothing_system/save_data/"..PlayerSteamID
        local name = dir.."/"..class..".dat"

        if (!file.IsDir(dir, "DATA")) then
            file.CreateDir(dir)
        end

        if (!file.Exists(name, "DATA")) then
            file.CreateDir("clothing_system/save_data/"..PlayerSteamID)
            file.Write(name, util.TableToJSON({}))
        end

        local keys = {}
        local tData = file.Read(name, "DATA")
        tData = util.JSONToTable(tData)

        for k, v in pairs(data) do
            local fucking = true

            for kk, vv in pairs(tData) do
                if (k == kk) then
                    tData[kk] = v
                    fucking = false
                end
            end

            if (fucking) then
                tData[k] = v 
            end
        end

        file.Write(name, util.TableToJSON(tData, true))
    end,

    -- Получить массив с базой
	GetBase = function( self, class )
        if ( class ) then
            if ( list.Get("player_base_clothing_system")[class] ) then
                return list.Get("player_base_clothing_system")[class]
            else
                return false
            end
		end

		return list.Get("player_base_clothing_system")
    end,
    
    -- Получить массив с одеждой
    GetItem = function( self, class )
        if ( class ) then
            if ( list.Get("clothing_system")[class] ) then
                return list.Get("clothing_system")[class]
            else
                return false
            end
		end

		return list.Get("clothing_system")
    end,
    
    -- Удаление одежды с игрока
    PlayerRemoveItem = function( self, ply, data )
        if (!IsValid(ply) || !ply:IsPlayer()) then return end
        
        local steamid
        if (game.SinglePlayer()) then 
            steamid = "single_player"
        else
            steamid = ply:SteamID64()
        end

        local user_file = "clothing_system/cloth_players_data/"..steamid.."/"..ply.ClothingSystemPlayerBase..".dat"
        
        if ( !file.IsDir("clothing_system/cloth_players_data/"..steamid, "DATA") ) then
            file.CreateDir("clothing_system/cloth_players_data/"..steamid)
        end

        if ( file.Exists(user_file, "DATA") ) then
            local read = util.JSONToTable(file.Read(user_file, "DATA"))
            local edit = read

            if (ClothingSystem:GetItem(data).SetPlayerModel) then
                if (read['other']['playermodel'] != nil) then
                    ply:SetModel(read['other']['playermodel'])
                    ply:ClothingSystemSetCustomHands()
                    ply:ClothingSystemOpenBoneAll()
                    read['other']['playermodel'] = nil
                end
            end
            
            for k, v in pairs(read['items']) do
                if ( v == data ) then
                    ClothingSystem:log("Player <"..tostring(ply:Nick())..":"..tostring(ply:SteamID()).."> drop the item - "..tostring(v))
                    read['items'][k] = nil
                    break
                end
            end

            for k, v in pairs(ply.ClothingSystemWearList) do
                if (v == data) then
                    ply.ClothingSystemWearList[k] = nil
                    break
                end
            end

            file.Write(user_file, util.TableToJSON(edit, true))
        end
	end,

    -- Добавление одежды игроку
    PlayerAddItem = function( self, ply, data )
        if (!IsValid(ply) || !ply:IsPlayer()) then return end

        local steamid
        if (game.SinglePlayer()) then 
            steamid = "single_player"
        else
            steamid = ply:SteamID64()
        end
        
        local user_file = "clothing_system/cloth_players_data/"..steamid.."/"..ply.ClothingSystemPlayerBase..".dat"
        local read = {}
        
        if ( !file.IsDir("clothing_system/cloth_players_data/"..steamid, "DATA") ) then
            file.CreateDir("clothing_system/cloth_players_data/"..steamid)
        end

        if ( file.Exists(user_file, "DATA") ) then
            read = util.JSONToTable(file.Read(user_file, "DATA"))
            read['items'] = read['items'] || {}
            read['other'] = read['other'] || {}
            read['items'][#read['items']+1] = data
        else
            read['items'] = {}
            read['items'][0] = data
            read['other'] = {}
        end

        table.insert(ply.ClothingSystemWearList, data)

        file.Write(user_file, util.TableToJSON(read, true))
	end,

    -- Замена всего массива одежды игрока
    PlayerReplaceItems = function( self, ply, data )
        if (!IsValid(ply) || !ply:IsPlayer() || ply:SteamID() == "BOT") then return end
        
        local steamid
        if (game.SinglePlayer()) then 
            steamid = "single_player"
        else
            steamid = ply:SteamID64()
        end

        local user_file = "clothing_system/cloth_players_data/"..steamid.."/"..ply.ClothingSystemPlayerBase..".dat"
        
        if ( !file.IsDir("clothing_system/cloth_players_data/"..steamid, "DATA") ) then
            file.CreateDir("clothing_system/cloth_players_data/"..steamid)
        end

        if (file.Exists(user_file, "DATA")) then
            local readFileData = util.JSONToTable(file.Read(user_file, "DATA"))
            if (readFileData['other'] != nil && readFileData['other']['playermodel'] != nil) then
                ply:SetModel(readFileData['other']['playermodel'])
                ply:ClothingSystemOpenBoneAll()
            end
        end

        if (data != nil && istable(data) && data['items'] != nil) then
            ply.ClothingSystemWearList = data['items']
        else
            ply.ClothingSystemWearList = {}
        end

        file.Write(user_file, util.TableToJSON(data, true))
    end,
    
    -- Проверка на пустой массив и его тип
    TableIsEmpty = function(self, data)
        if ( !istable(data) ) then return true end
        if ( data == nil ) then return true end
        if ( table.Count(data) == 0 ) then return true end
        
        return false
    end,

    -- Получить одежду игрока
    PlayerGetItems = function(self, ply)
        if (!IsValid(ply) || !ply:IsPlayer() || ply:SteamID() == "BOT") then return end
        
        local steamid = ply:ClothingSystemGetNormalSteamID64()

        if (steamid == "STEAM_0:0:0") then
            steamid = "single_player"
        end

        local user_file = "clothing_system/cloth_players_data/"..steamid.."/"..ply.ClothingSystemPlayerBase..".dat"
        
        if ( !file.IsDir("clothing_system/cloth_players_data/"..steamid, "DATA") ) then
            file.CreateDir("clothing_system/cloth_players_data/"..steamid)
        end

        if ( file.Exists(user_file, "DATA") ) then
            local user_file = util.JSONToTable(file.Read(user_file, "DATA"))
            return user_file['items'] || {}
        else
            return {}
        end
    end,
    
    -- Спавн энтити с одеждой
    ItemSpawn = function(self, item_class, ply, spawn_menu)
        if SERVER then
            if (!IsValid(ply) || !ply:IsPlayer()) then return false end
            if (spawn_menu) then
                local cvar = GetConVar("sbox_maxsents")
                if (cvar) then
                    local max = 0
                    for _, v in ipairs(ents.GetAll()) do
                        if (v.OwnerID == ply:UserID() && v:GetClass() == "clothing_prop") then
                            max = max + 1
                        end
                    end

                    if (cvar:GetInt() <= max) then
                        return false
                    end
                end
            end

            local ray
        
            if ( ply:EyeAngles().x < 25 ) then
                ray = ply:EyeAngles():Forward() * 50
            else
                ray = (ply:EyeAngles():Forward() * 20) + (ply:EyeAngles():Up() * 20)
            end
            local start = ply:EyePos()
            local endpos = start + ray
            local filter = function( ent ) 
                if ( ent:GetClass() == "prop_physics" ) then 
                    return true 
                end 
            end
        
            local tr = util.TraceLine( {
                start = start,
                endpos = endpos,
                filter = filter,
            } )
        
            local SpawnPos = tr.HitPos + tr.HitNormal * 10
            local SpawnAng = ply:EyeAngles()
            SpawnAng.p = 0
            SpawnAng.y = SpawnAng.y + 180
        
            -- Получение списка одежды
            local list = list.Get( "clothing_system" )
        
            -- Спавним item для использования одежды
            local list = list[item_class]

            if (list.WireModel == nil || !util.IsValidModel(list.WireModel)) then
                return
            elseif (list.FoldedModel == nil || !util.IsValidModel(list.FoldedModel)) then
                list.FoldedModel = "models/props_c17/SuitCase_Passenger_Physics.mdl"
            end

            local item = ents.Create( "clothing_prop" )
            item.DisableUse = false
            item.Group = "clothing_system"
            item.Class = item_class
            item.OwnerID = ply:UserID()
            item["saveArray"] = {}
            item:SetModel( list.FoldedModel )
            if (list.Skin != nil && isnumber(list.Skin)) then
                item:SetSkin(list.Skin)
            end
            if (list.Bodygroup != nil && istable(list.Bodygroup)) then
                item:SetBodygroup(list.Bodygroup[1], list.Bodygroup[2])
            end
            if (list.Bodygroups != nil && istable(list.Bodygroups)) then
                item:SetBodygroups(list.Bodygroups)
            end
            if (list.CustomCollision) then
                item.CustomCollision = true
            end
            item:SetPos(SpawnPos)
            item:SetAngles(SpawnAng)
            item:Spawn()
            item:Activate()
            item:DropToFloor()

            if ( spawn_menu ) then
                ClothingSystem:log("Player <"..tostring(ply:Nick())..":"..tostring(ply:SteamID()).."> spawn item - "..tostring(item_class))
            end

            hook.Run( "ClothingSystem.ItemSpawn", ply, item_class, item["saveArray"], item)

            if (!spawn_menu) then
                hook.Run( "ClothingSystem.Drop", ply, item_class, item["saveArray"], item)
            end
        
            timer.Simple(0.2, function()
                ClothingSystem.Tools.Network.Send("Broadcast", "ItemFolderDrawToText", {index = item:EntIndex(), class = item_class})
            end)
        
            -- Добавляем его в undo лист
            if ( engine.ActiveGamemode() == "darkrp" ) then
                if ( spawn_menu ) then
                    undo.Create( "item" )
                        undo.AddEntity( item )
                        undo.SetPlayer( ply )
                    undo.Finish()
                end
            else
                undo.Create( "item" )
                    undo.AddEntity( item )
                    undo.SetPlayer( ply )
                undo.Finish()
            end
        
            item:EmitSound("AI_BaseNPC.BodyDrop_Heavy", 75, 100, 1, CHAN_AUTO )
            
            -- Проигрываем звук выбрасывания
            if ( !spawn_menu && list.UnEquipSound ) then
                if ( list.UnEquipSound && isstring(list.UnEquipSound) ) then
                    item:EmitSound(list.UnEquipSound)
                elseif ( list.UnEquipSound && istable(item.UnEquipSound) ) then
                    item:EmitSound(table.Random(list.UnEquipSound))
                end
            end

            if ( spawn_menu ) then
                if ( ClothingSystem:GetItem(item_class).Spawn ) then
                    ClothingSystem:GetItem(item_class).Spawn(item)
                end
            else
                if ( ClothingSystem:GetItem(item_class).Drop ) then
                    ClothingSystem:GetItem(item_class).Drop(ply, item_class, item)
                end
            end
        end
    end,

    CheckReplace = function(self, class, ply)
        for _, value in pairs(list.Get("clothing_system_replace")) do
            local CheckModel = value.ReplaceToModel
            local CheckType = value.ReplaceToBase

            if (value.Class == class) then
                if (isstring(CheckModel) && CheckModel == ply:GetModel()) then
                    return value
                end
                if (isstring(CheckType) && CheckType == ply.ClothingSystemPlayerBase) then
                    return value
                end
                if (istable(CheckModel)) then
                    for _, model in pairs(CheckModel) do
                        if (model == ply:GetModel()) then
                            return value
                        end
                    end
                end
                if (istable(CheckType)) then
                    for _, type in pairs(CheckType) do
                        if (type == ply.ClothingSystemPlayerBase) then
                            return value
                        end
                    end
                end
            end
        end

        return false
    end,

    WearPartsInitialSpawn = function(self, class, ply, sender, network, insertData)
        if (sender == nil) then sender = ply end
        
        if (!IsValid(ply) || !ply:IsPlayer()) then return end
        if (!IsValid(sender) || !sender:IsPlayer()) then return end
        if (!ply:Alive()) then return false end
        if (!sender:Alive()) then return false end

        network = string.lower( network )
        local ReplaceItem = ClothingSystem:CheckReplace(class, ply)
        local ReplcaeBone
        local check_item

        check_item = list.Get("clothing_system")[class].PlayerBase

        if (ReplaceItem) then
            check_item = ply.ClothingSystemPlayerBase
        end

        if (!istable(ReplaceItem)) then
            ReplaceItem = {}
        end

        ClothingSystem.Tools.Network.Send(network, "WearEveryone", {class = class,steamid = ply:SteamID(), ReplaceItem = ReplaceItem}, sender, ply)

        if (insertData) then
            ClothingSystem:PlayerAddItem(ply, class)
        end

        hook.Run( "ClothingSystem.InitAllowItems", class, ply )
    end,

    WearParts = function(self, class, ply, sender, network, insertData, entity)
        if (sender == nil) then sender = ply end

        if (!IsValid(ply) || !ply:IsPlayer()) then return false end
        if (!IsValid(sender) || !sender:IsPlayer()) then return false end

        local network = string.lower( network )

        if ( network != "broadcast" && network != "send" && network != "sendomit" && network != "sendpas" && network != "sendpvs" ) then
            error("ClothingSystem: "..network.." - Bad argument network!")
            return false
        end

        local item = list.Get("clothing_system")[class]

        local ReplaceItem = ClothingSystem:CheckReplace(class, ply)
        local ReplcaeBone

        -- Переменная для проверок
        local check_item

        -- Проверка на определение базы для энтити
        check_item = item.PlayerBase
        
        if (ReplaceItem) then
            check_item = ply.ClothingSystemPlayerBase
        end

        if ( !check_item || !isstring(check_item) ) then
            error("ClothingSystem: "..class.." - Bad argument PlayerBase!")
            return false
        elseif ( check_item != ply.ClothingSystemPlayerBase ) then
            ply:AddText(ClothingSystem.Language.unsuitableClothes.."!")
            return false
        end

        if ( item.OnlySteamID ) then
            local fuckYou = true
            
            if ( istable(item.OnlySteamID) ) then
                 for _, v in pairs(item.OnlySteamID) do
                    if (v == ply:SteamID() || v == ply:SteamID64()) then
                        fuckYou = false
                        break
                    end
                end
            elseif ( isstring(item.OnlySteamID) ) then
                if (item.OnlySteamID == ply:SteamID() || item.OnlySteamID == ply:SteamID64()) then
                    fuckYou = false
                end
            end

            if (fuckYou) then
                ply:AddText(ClothingSystem.Language.unsuitableClothesRank.."!")
                return false
            end
        elseif ( item.OnlyAdmin ) then
            if ( !ply:IsAdmin() && !ply:IsSuperAdmin() ) then
                ply:AddText(ClothingSystem.Language.adminOnly.."!")
                return false
            end
        elseif ( item.GroupDress ) then
            local fuckYou = true

            if (isstring(item.GroupDress)) then
                if ( ply:GetUserGroup() == item.GroupDress ) then
                    fuckYou = false
                end
            elseif (istable(item.GroupDress)) then
                for _, group in pairs(item.GroupDress) do
                    if ( ply:GetUserGroup() == group ) then
                        fuckYou = false
                        break
                    end
                end
            end

            if (fuckYou) then
                ply:AddText(ClothingSystem.Language.unsuitableClothesRank.."!")
                return false
            end
        end


        if (item.Checking != nil) then
            if (!item.Checking(ply, class)) then 
                ply:AddText(ClothingSystem.Language.unsuitableClothes.."!")
                return false 
            end
        end

        if (item.Module) then
            if ( !ply:ClothingSystemCheckBone(class, ReplcaeBone, insertData) ) then
                ply:AddText(ClothingSystem.Language.noFreeSlot.."!")
                return false
            end
            
            if ( item.Equip && entity && insertData) then
                item.Equip(ply, class, entity)
            elseif ( item.Equip && insertData) then
                item.Equip(ply, class, NULL)
            end
            if ( item.EquipSound ) then
                ply:EmitSound(item.EquipSound)
            end
        end

        
        if (!item.Module) then
            if (item.SetPlayerModel) then
                for k, v in pairs(ply:ClothingSystemGetBones()) do
                    if (v == true) then
                        ply:AddText(ClothingSystem.Language.noFreeSlot.."!")
                        return false
                    end
                end

                local steamid
                if (game.SinglePlayer()) then 
                    steamid = "single_player"
                else
                    steamid = ply:SteamID64()
                end

                local user_file = "clothing_system/cloth_players_data/"..steamid.."/"..ply.ClothingSystemPlayerBase..".dat"
                local read = {}

                if ( !file.IsDir("clothing_system/cloth_players_data/"..steamid, "DATA") ) then
                    file.CreateDir("clothing_system/cloth_players_data/"..steamid)
                end

                if ( file.Exists(user_file, "DATA") ) then
                    read = util.JSONToTable(file.Read(user_file, "DATA"))
                else
                    read['items'] = {}
                    read['other'] = {}
                end
                if (read['other']['playermodel'] == nil) then
                    read['other']['playermodel'] = ply:GetModel()
                end
                file.Write(user_file, util.TableToJSON(read, true))

                ply:SetModel(item.WireModel)
                if (item.Skin != nil) then
                    ply:SetSkin(item.Skin)
                end

                if (item.Bodygroup != nil) then
                    ply:SetBodygroup(item.Bodygroup[1], item.Bodygroup[2])
                end

                if (item.Bodygroups != nil) then
                    ply:SetBodygroup(item.Bodygroups)
                end
                ply:ClothingSystemSetCustomHands()

                ply:ClothingSystemCloseBoneAll()
            else
                if (ReplaceItem && ReplaceItem.TypePut != nil) then
                    ReplcaeBone = ReplaceItem.TypePut
                else
                    ReplcaeBone = item.TypePut
                end
            end
        end

        -- Проверка на наличие предопределённого типа привязки
        if (!item.Module) then
            if (!item.SetPlayerModel) then
                if ( !item.BoneAttach && !item.Bonemerge ) then
                    ply:AddText(ClothingSystem.Language.badArray.."!")
                    return false
                else
                    -- Проверка на доступность костей
                    if ( !ply:ClothingSystemCheckBone(class, ReplcaeBone, insertData) ) then
                        ply:AddText(ClothingSystem.Language.noFreeSlot.."!")
                        return false
                    end

                    -- Закрытие необходимых костей
                    ply:ClothingSystemSetBone(class, ReplcaeBone)
                end
            end
        end

        -- Пишем в чат название экипировки
        ply:AddText(ClothingSystem.Language.equip.. " - " .. item.Name .. ".")

        if ( item.Equip && entity && insertData ) then
            item.Equip(ply, class, entity)
        elseif ( item.Equip && insertData) then
            item.Equip(ply, class, NULL)
        end

        -- Отсылаем hook всем клиентам для создания энтити

        if (!istable(ReplaceItem)) then
            ReplaceItem = {}
        end

        ClothingSystem:log("Player <"..tostring(ply:Nick())..":"..tostring(ply:SteamID()).."> equip the item - "..tostring(class))
        ClothingSystem.Tools.Network.Send(network, "WearEveryone", {class = class,steamid = ply:SteamID(), ReplaceItem = ReplaceItem}, sender, ply)

        -- Добавляем item в data файл
        if (insertData) then
            ClothingSystem:PlayerAddItem(ply, class)
        end

        -- Проигрывание звука при надевании, если переменная определена
        if ( item.EquipSound && isstring(item.EquipSound) ) then
            ply:EmitSound(item.EquipSound)
        elseif ( item.EquipSound && istable(item.EquipSound) ) then
            ply:EmitSound(table.Random(item.EquipSound))
        end

        if (entity != nil) then
            hook.Run( "ClothingSystem.Wear", ply, class, entity['saveArray'], entity)
        else
            hook.Run( "ClothingSystem.Wear", ply, class, {}, NULL )
        end

        return true
    end,
}
META.__index = META

setmetatable( ClothingSystem, META )