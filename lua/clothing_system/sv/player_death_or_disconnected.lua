-- Удаление одежды, если игрок умирает
local function Death(ply)
    local items = ClothingSystem:PlayerGetItems(ply)

    if ( !ClothingSystem:TableIsEmpty(items) ) then
        for _, class in pairs(items) do
            local itm = ClothingSystem:GetItem(class)

            if (itm.Death) then
                itm.Death(ply, class)
            end
        end
    end

    ClothingSystem:PlayerReplaceItems(ply, {
        ['items'] = {},
        ['other'] = {},
    })

    ply.ClothingSystemPlayerBase = ""

    net.Start("ClothingSystem.DeadOrDisconnected")
        net.WriteString(ply:SteamID())
    net.Broadcast()
end
hook.Add( "PlayerDeath", "ClothingSystem.PlayerDeathReset", Death)

local function Disconnected(ply)
    local items = ClothingSystem:PlayerGetItems(ply)

    if ( !ClothingSystem:TableIsEmpty(items) ) then
        for _, class in pairs(items) do
            local itm = ClothingSystem:GetItem(class)

            if (itm.Disconnected) then
                itm.Disconnected(ply, class)
            end
        end
    end

    net.Start("ClothingSystem.DeadOrDisconnected")
        net.WriteString(ply:SteamID())
    net.Broadcast()
end
hook.Add( "PlayerDisconnected", "ClothingSystem.PlayerDisconnected", Disconnected)