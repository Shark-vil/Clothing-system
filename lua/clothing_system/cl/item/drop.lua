-- Выполняется, если игрок выбрасывает вещь
local function drop()
    local class = net.ReadString()
    local steamid = net.ReadString()
    local ply = LocalPlayer()

    hook.Run( "ClothingSystem.Drop", class, player.GetBySteamID(steamid), ply)
    ply:ClothingSystemRemoveItem(class, steamid)
end
net.Receive("ClothingSystem.DropItem", drop)

-- Выполняется, если игрок отключается или умирает
local function DeadOrDisconnected()
    local steamid = net.ReadString()
    local ply = LocalPlayer()
    local PlayerSteamID

    if (game.SinglePlayer()) then
        PlayerSteamID = "STEAM_0:0:0"
    else
        PlayerSteamID = steamid
    end
    
    if (steamid == PlayerSteamID) then
        ply.ClothingSystemPlayerBase = ""
    end

    ply:ClothingSystemDeadItem(steamid)
end
net.Receive("ClothingSystem.DeadOrDisconnected", DeadOrDisconnected)