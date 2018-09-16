-- Выполняется, если игрок выбрасывает вещь
local function drop(len, data)
    local ply = LocalPlayer()

    -- hook.Run( "ClothingSystem.Drop", class, player.GetBySteamID(steamid), ply)
    ply:ClothingSystemRemoveItem(data.class, data.steamid)
end
ClothingSystem.Tools.Network.AddNetwork("DropItem", drop)

-- Выполняется, если игрок отключается или умирает
local function DeadOrDisconnected(len, data)
    local ply = LocalPlayer()
    local PlayerSteamID

    if (game.SinglePlayer()) then
        PlayerSteamID = "STEAM_0:0:0"
    else
        PlayerSteamID = data.steamid
    end
    
    if (data.steamid == PlayerSteamID) then
        ply.ClothingSystemPlayerBase = ""
    end

    ply:ClothingSystemDeadItem(data.steamid)
end
ClothingSystem.Tools.Network.AddNetwork("DeadOrDisconnected", DeadOrDisconnected)