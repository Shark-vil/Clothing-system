-- Удаление одежды, если игрок умирает
local function Death(ply)
    local items = ClothingSystem:PlayerGetItems(ply)

    if ( !ClothingSystem:TableIsEmpty(items) ) then
        for _, class in pairs(items) do
            local itm = ClothingSystem:GetItem(class)

            if ( itm != nil && !isbool(itm) && itm != false ) then
                if (itm.Death != nil) then
                    itm.Death(ply, class)
                end
            end
        end
    end

    ClothingSystem:PlayerReplaceItems(ply, {
        ['items'] = {},
        ['other'] = {},
    })

    ply.ClothingSystemPlayerBase = ""

    ClothingSystem.Tools.Network.Send("Broadcast", "DeadOrDisconnected", {steamid = ply:SteamID()})
end
ClothingSystem.Tools.Hooks.AddHook("PlayerDeath", Death)

local function Disconnected(ply)
    local playerSaveInfo = ply
    local steamid = playerSaveInfo:SteamID()
    local items = ClothingSystem:PlayerGetItems(playerSaveInfo)

    if ( !ClothingSystem:TableIsEmpty(items) ) then
        for _, class in pairs(items) do
            local itm = ClothingSystem:GetItem(class)

            if (itm.Disconnected) then
                itm.Disconnected(playerSaveInfo, class)
            end
        end
    end

    ClothingSystem.Tools.Network.Send("Broadcast", "DeadOrDisconnected", {steamid = steamid})
end
ClothingSystem.Tools.Hooks.AddHook("PlayerDisconnected", Disconnected)