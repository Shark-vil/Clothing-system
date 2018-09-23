local playerMeta = FindMetaTable("Player")

-- Определение типа костей и базы одежды
function playerMeta:ClothingSystemConstruct(BoneType, type)
    if (!IsValid(self) || !self:IsPlayer()) then return end

    self.ClothingSystemBoneType = BoneType -- Кости
    self.ClothingSystemPlayerBase = type -- База

    -- Массив с одеждой
    if (self.ClothingSystemWearList == nil) then
        self.ClothingSystemWearList = {}
    end

    -- Проверка на спавн
    if (self.ClothingSystemPlayerIsSpawn == nil) then
        self.ClothingSystemPlayerIsSpawn = true
    end

    if (self.ClothingSystemPlayerSteamID64 == nil) then
        if (game.SinglePlayer()) then
            self.ClothingSystemPlayerSteamID64 = "STEAM_0:0:0"
        else
            self.ClothingSystemPlayerSteamID64 = self:SteamID64()
        end
    end

    if (self.ClothingSystemPlayerSteamID == nil) then
        if (game.SinglePlayer()) then
            self.ClothingSystemPlayerSteamID = "STEAM_0:0:0"
        else
            self.ClothingSystemPlayerSteamID = self:SteamID()
        end
    end

    -- Для хранения данных
    self.ClothingSystemData = {}

    self.ClothingSystemData['GasMask'] = false
    self.ClothingSystemData['ActiveOverlay'] = false
end

function playerMeta:ClothingSystemGetNormalSteamID64()
    if (!IsValid(self) || !self:IsPlayer() || !self.ClothingSystemPlayerIsSpawn) then return end

    return self.ClothingSystemPlayerSteamID64
end

function playerMeta:ClothingSystemGetNormalSteamID()
    if (!IsValid(self) || !self:IsPlayer() || !self.ClothingSystemPlayerIsSpawn) then return end

    return self.ClothingSystemPlayerSteamID
end


-- Проверка доступных костей
function playerMeta:ClothingSystemCheckBone(class, TypePut, insertData)    
    if (!IsValid(self) || !self:IsPlayer()) then return end
    if ( !isstring(class) ) then error("Invalid type value - class!") end

    if ( ClothingSystem:GetItem(class).Accessory || ClothingSystem:GetItem(class).Module) then 
        local items = ClothingSystem:PlayerGetItems(self)

        if ( !ClothingSystem:TableIsEmpty(items) && insertData) then
            if ( table.HasValue(items, class) ) then
                return false
            end
        end

        return true 
    end

    local check_item = TypePut

    if ( check_item == nil || !istable(check_item) ) then
        error("ClothingSystem: "..class.." - table is nil value!")
        return
    elseif ( table.Count(check_item) == 0 ) then
        error("ClothingSystem: "..class.." - table = 0 parametrs!")
        return
    end

    for k, v in pairs(TypePut) do
        for _k, _v in pairs(self.ClothingSystemBoneType) do
            if ( k == _k && v == true ) then 
                if ( _v == true ) then
                    return false
                end
            end
        end
    end

    return true
end

-- Закрываем кости
function playerMeta:ClothingSystemSetBone(class, TypePut)   
    if (!IsValid(self) || !self:IsPlayer()) then return end
    if ( !isstring(class) ) then error("Invalid type value - class!") end

    if ( ClothingSystem:GetItem(class).Accessory ) then return end

    for k, v in pairs(TypePut) do
        for _k, _v in pairs(self.ClothingSystemBoneType) do
            if ( k == _k && _v == false ) then 
                self.ClothingSystemBoneType[_k] = true
            end
        end
    end
end

-- Открываем кости
function playerMeta:ClothingSystemLetBone(class, TypePut)   
    if (!IsValid(self) || !self:IsPlayer()) then return end
    if ( !isstring(class) ) then error("Invalid type value - class!") end

    if ( ClothingSystem:GetItem(class).Accessory ) then return end
    if ( ClothingSystem:GetItem(class).Module) then return end
    
    for k, v in pairs(TypePut) do
        for _k, _v in pairs(self.ClothingSystemBoneType) do
            if ( k == _k && _v == true ) then 
                self.ClothingSystemBoneType[_k] = false
            end
        end
    end
end

-- Возвращаем кости
function playerMeta:ClothingSystemGetBones()   
    if (!IsValid(self) || !self:IsPlayer()) then return end

    return self.ClothingSystemBoneType
end

function playerMeta:ClothingSystemCloseBoneAll()   
    if (!IsValid(self) || !self:IsPlayer()) then return end

    for k, v in pairs(self.ClothingSystemBoneType) do
        self.ClothingSystemBoneType[k] = true
    end
end

function playerMeta:ClothingSystemOpenBoneAll()   
    if (!IsValid(self) || !self:IsPlayer()) then return end

    for k, v in pairs(self.ClothingSystemBoneType) do
        self.ClothingSystemBoneType[k] = false
    end
end

-- Ищем item
function playerMeta:ClothingSystemSearchItem(class, steamid)
    if CLIENT then
        if (!IsValid(self) || !self:IsPlayer()) then return end
        if ( !isstring(class) ) then error("Invalid type value - class!") end
        if ( !isstring(steamid) ) then error("Invalid type value - steamid!") end
        -- if ( !player.GetBySteamID(steamid) ) then error("User don't is valid!") end
        if ( ClothingSystem:TableIsEmpty(self.ClothingSystemWearList[steamid]) ) then return end

        for _, v in ipairs(self.ClothingSystemWearList[steamid]) do
            if ( v.Class == class ) then
                return v
            end
        end

        return false
    else
        error("This method is designed to work only on the client side!")
    end
end

-- Получаем полный список
function playerMeta:ClothingSystemGetAllItem(steamid)
    if CLIENT then
        if (!IsValid(self) || !self:IsPlayer()) then return end

        if ( self.ClothingSystemWearList ) then
            if ( table.Count(self.ClothingSystemWearList) == 0 ) then
                return false
            end
            if ( steamid ) then
                if ( self.ClothingSystemWearList[steamid] ) then
                    if ( table.Count(self.ClothingSystemWearList[steamid]) == 0 ) then
                        return false
                    end

                    return self.ClothingSystemWearList[steamid]
                end
            end

            return self.ClothingSystemWearList
        end

        return false
    else
        error("This method is designed to work only on the client side!")
    end
end

-- Удаляем item
function playerMeta:ClothingSystemRemoveItem(class, steamid)
    if CLIENT then
        if (!IsValid(self) || !self:IsPlayer()) then return end

        if ( self.ClothingSystemWearList == nil ) then return end
        if ( self.ClothingSystemWearList[steamid] == nil ) then return end
        
        local GenerateNormalArray = {}
        local index = 1
        local status = false
        local overlay = false

        for k, v in pairs(self.ClothingSystemWearList[steamid]) do
            if (v.SteamID == steamid && v.Class == class) then
                v:Remove()
                status = true
            else
                GenerateNormalArray[index] = v
                index = index + 1
            end
        end

        self.ClothingSystemWearList[steamid] = GenerateNormalArray

        if (steamid == self:ClothingSystemGetNormalSteamID()) then
            self.ClothingSystemData['ActiveOverlay'] = false
            for _, v in pairs(self.ClothingSystemWearList[steamid]) do
                if (v.Overlay) then
                    self.ClothingSystemData['ActiveOverlay'] = v.Overlay
                    break
                end
            end
        end
        
        return status
    else
        error("This method is designed to work only on the client side!")
    end
end

-- Удаляем все item игрока
function playerMeta:ClothingSystemDeadItem(steamid)
    if CLIENT then
        if (!IsValid(self) || !self:IsPlayer()) then return end
        if ( !isstring(steamid) ) then error("Invalid type value - steamid!") end
        -- if ( !player.GetBySteamID(steamid) ) then return end
        if ( self.ClothingSystemWearList == nil ) then return end
        if ( self.ClothingSystemWearList[steamid] == nil ) then return end

        local index = 1

        for k, v in ipairs(self.ClothingSystemWearList[steamid]) do
            if (v.SteamID == steamid) then
                v:Remove()
            end
        end

        self.ClothingSystemWearList[steamid] = {}
    else
        error("This method is designed to work only on the client side!")
    end
end

-- Добавляем item игрока
function playerMeta:ClothingSystemAddItem(item, steamid)
    if CLIENT then
        if (!IsValid(self) || !self:IsPlayer()) then return end
        if (self.ClothingSystemWearList == nil) then self.ClothingSystemWearList = {} end
        if (self.ClothingSystemWearList[steamid] == nil) then self.ClothingSystemWearList[steamid] = {} end
    
        -- table.insert(self.ClothingSystemWearList, item)
        local v = table.Count(self.ClothingSystemWearList[steamid])

        if (v == 0) then
            self.ClothingSystemWearList[steamid][1] = item
        else
            for i=1, v+1 do
                if ( i == v+1 ) then
                    self.ClothingSystemWearList[steamid][i] = item
                    break
                elseif ( self.ClothingSystemWearList[steamid][i] == nil ) then
                    self.ClothingSystemWearList[steamid][i] = item
                    break
                end
            end
        end
    else
        error("This method is designed to work only on the client side!")
    end
end

-- Дропаем item
function playerMeta:ClothingSystemDropItem(class)
    if CLIENT then
        if (!IsValid(self) || !self:IsPlayer()) then return end
        if ( !isstring(class) ) then error("Invalid type value - class!") end
        local steamid

        if (game.SinglePlayer()) then
            steamid = "STEAM_0:0:0"
        else
            steamid = self:SteamID()
        end

        if ( !self:ClothingSystemRemoveItem(class, steamid)) then return end

        ClothingSystem.Tools.Network.Send("SendToServer", "DropItem", {class = class})
    else
        error("This method is designed to work only on the client side!")
    end
end

-- Напечатать текст в чат
function playerMeta:AddText(text)
    if (!IsValid(self) || !self:IsPlayer()) then return end
    if ( !isstring(text) ) then error("Invalid type value - text!") end

    if SERVER then
        self:SendLua([[chat.AddText("]]..text..[[")]])
    else
        chat.AddText(text)
    end
end

-- Отрисовка (Ахуенный костыль, без него сервер крашится.)
function playerMeta:ClothingSystemGetDrawing()
    if CLIENT then
        if (!IsValid(self) || !self:IsPlayer()) then return end

        if ( self.scm_Draw == nil ) then
            self.scm_Draw = false
        end

        return self.scm_Draw
    else
        error("This method is designed to work only on the client side!")
    end
end

-- Отрисовка (Ахуенный костыль, без него сервер крашится.)
function playerMeta:ClothingSystemSetDrawing(bool)
    if CLIENT then
        if (!IsValid(self) || !self:IsPlayer()) then return end
        
        if ( bool == true or bool == false ) then 
            self.scm_Draw = bool
        else
            error("This method can only have a type - < Boolean >!")
        end
    else
        error("This method is designed to work only on the client side!")
    end
end

function playerMeta:ClothingSystemSetCustomHands()
    if SERVER then
        local simplemodel = player_manager.TranslateToPlayerModelName( self:GetModel() )
        local info = player_manager.TranslatePlayerHands( simplemodel )
        if info then
            local hands = self:GetHands()
            hands:SetModel( info.model )
            hands:SetSkin( info.skin )
            hands:SetBodyGroups( info.body )
        end
    else
        error("This method is designed to work only on the server side!")
    end
end