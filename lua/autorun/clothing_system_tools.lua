AddCSLuaFile()
if SERVER then
    util.AddNetworkString("Tools.NetWork.ClothingSystem.ToServer")
    util.AddNetworkString("Tools.NetWork.ClothingSystem.ToClient")
    util.AddNetworkString("Tools.NetWork.ClothingSystem.ToClientInitialKey")
end

ClothingSystem = ClothingSystem || {}
local CLOTHING_SYSTEM_PRIVATE_KEY = ""

if SERVER then
    for i2 = 1, math.random(10, 15) do
        if (math.random(0, 1) == 1) then
            CLOTHING_SYSTEM_PRIVATE_KEY = CLOTHING_SYSTEM_PRIVATE_KEY..string.char(math.random(65, 90))
        else
            CLOTHING_SYSTEM_PRIVATE_KEY = CLOTHING_SYSTEM_PRIVATE_KEY..tostring(math.random(0, 1000))
        end
    end

    local function SendPrivateKey( ply )
        net.Start("Tools.NetWork.ClothingSystem.ToClientInitialKey")
        net.WriteString(CLOTHING_SYSTEM_PRIVATE_KEY)
        net.Send(ply)
    end
    hook.Add( "PlayerInitialSpawn", "CLOTHING_SYSTEM_SEND_PRIVATE_KEY", SendPrivateKey )
else
    net.Receive("Tools.NetWork.ClothingSystem.ToClientInitialKey", function()
        CLOTHING_SYSTEM_PRIVATE_KEY = net.ReadString()
    end)
end

if SERVER then
    hook.Add( "PlayerSay", "HOOK.ClothingSystem.PlayerSay.id."..CurTime(), function( ply, text, team )
        if (ply.ClothingSystemPlayerIsSpawn) then
            local info = hook.Run("ClothingSystem.PlayerSay", ply, text, team)
            if (info != nil && isstring(info)) then
                return info
            end
        end
    end)
end

ClothingSystem.PrivateKeys = ClothingSystem.PrivateKeys || {}
ClothingSystem.Tools = ClothingSystem.Tools || {}
ClothingSystem.Tools.Hooks = ClothingSystem.Tools.Hooks || {}

ClothingSystem.Tools.Hooks.AddHook = function(hookName, func)
    local id = tostring(func)
    local len = string.len(id)
    local _, start = string.find( id, "function: " )
    id = string.sub(id, start+1, len)

    hook.Add(hookName, "ClothingSystem."..hookName.."."..id, func)
end

ClothingSystem.Tools.Hooks.Call = function(hookName, gamemodeTable, ...)
    hook.Call(hookName, gamemodeTable, ...)
end

ClothingSystem.Tools.Hooks.Run = function(hookName)
    local hooksArray = hook.GetTable()

    for k, v in pairs(hooksArray) do
        if (k == hookName) then
            for index, func in pairs(v) do
                if (string.find(index, "ClothingSystem."..hookName..".")) then
                    hook.Run(hookName, index)
                end
            end
        end
    end
end

ClothingSystem.Tools.Network = ClothingSystem.Tools.Network || {}
ClothingSystem.Tools.Network.SavedNetworkFunctions = ClothingSystem.Tools.Network.SavedNetworkFunctions || {}
ClothingSystem.Tools.Network.Protected = ClothingSystem.Tools.Network.Protected || {}

ClothingSystem.Tools.Network.Call = function(identifier, len, array, player, receiver)
    if (CLOTHING_SYSTEM_PRIVATE_KEY == nil) then return end
    
    if (ClothingSystem.Tools.Network.SavedNetworkFunctions["ClothingSystem."..identifier] != nil) then
        if (receiver != nil) then
            ClothingSystem.Tools.Network.SavedNetworkFunctions["ClothingSystem."..identifier](len, array, player, receiver)
        else
            ClothingSystem.Tools.Network.SavedNetworkFunctions["ClothingSystem."..identifier](len, array, player)
        end
    end
end

ClothingSystem.Tools.Network.AddNetwork = function(identifier, func)
    -- if (ClothingSystem.Tools.Network.SavedNetworkFunctions["ClothingSystem."..identifier] == nil) then
        ClothingSystem.Tools.Network.SavedNetworkFunctions["ClothingSystem."..identifier] = func
    -- end
end

ClothingSystem.Tools.Network.Send = function(netType, identifier, array, sender, receiver)
    if (!sender) then
        sender = NULL
    end
    if (!receiver) then
        receiver = NULL
    end
    if (array == nil || !istable(array)) then
        array = {}
    end

    if SERVER then
        if (string.lower(netType) == "broadcast") then
            net.Start("Tools.NetWork.ClothingSystem.ToClient")
                net.WriteString("broadcast")
                net.WriteString(identifier)
                net.WriteTable(array)
                net.WriteEntity(sender)
            net.Broadcast()

            return true
        elseif (string.lower(netType) == "send" && receiver != nil && receiver != NULL && receiver:IsPlayer()) then
            net.Start("Tools.NetWork.ClothingSystem.ToClient")
                net.WriteString("send")
                net.WriteString(identifier)
                net.WriteTable(array)
                net.WriteEntity(sender)
            net.Send(receiver)

            return true
        elseif (string.lower(netType) == "sendomit" && receiver != nil) then
            local newTablePlayers = {}
            local netTable = false
            if (istable(receiver)) then
                local max = table.Count(receiver)
                for i = 1, max do
                    if (isentity(receiver[max]) && receiver[max] != NULL && receiver[max]:IsPlayer()) then                        
                        table.insert(newTablePlayers, receiver[max])
                    end
                end
                netTable = true
            elseif (!isentity(receiver) || receiver == NULL || !receiver:IsPlayer()) then
                return false
            end
            net.Start("Tools.NetWork.ClothingSystem.ToClient")
                net.WriteString("sendomit")
                net.WriteString(identifier)
                net.WriteTable(array)
                net.WriteEntity(sender)
            if (netTable) then
                net.SendOmit(newTablePlayers)
            else
                net.SendOmit(receiver)
            end

            return true
        elseif (string.lower(netType) == "sendpas" && receiver != nil && isvector(receiver)) then
            net.Start("Tools.NetWork.ClothingSystem.ToClient")
                net.WriteString("sendpas")
                net.WriteString(identifier)
                net.WriteTable(array)
                net.WriteEntity(sender)
            net.SendPAS(receiver)

            return true
        elseif (string.lower(netType) == "sendpvs" && receiver != nil && isvector(receiver)) then
            net.Start("Tools.NetWork.ClothingSystem.ToClient")
                net.WriteString("sendpvs")
                net.WriteString(identifier)
                net.WriteTable(array)
                net.WriteEntity(sender)
            net.SendPVS(receiver)

            return true
        else
            return false
        end
    else
        local steamid
        if (string.lower(netType) == "sendtoserver") then
            net.Start("Tools.NetWork.ClothingSystem.ToServer")
                net.WriteString("sendtoserver")
                net.WriteString(identifier)
                net.WriteTable(array)
                net.WriteString(CLOTHING_SYSTEM_PRIVATE_KEY)
            net.SendToServer()

            return true
        else
            return false
        end
    end
end


if SERVER then
    if (ClothingSystem.Config.NetworkPtotectSystem) then
        ClothingSystem.Tools.Hooks.AddHook("PlayerDisconnected", function(ply)
            ClothingSystem.Tools.Network.Protected[ply:SteamID()] = nil
        end)
    end

    net.Receive("Tools.NetWork.ClothingSystem.ToServer", function(len, sender)
        local netType = net.ReadString()
        local identifier = net.ReadString()
        local array = net.ReadTable()
        local secretkey = net.ReadString()

        if (secretkey != CLOTHING_SYSTEM_PRIVATE_KEY) then
            sender:Kick("[ClothingSystem][Protected]: Invalid secret key.")
        end

        if (ClothingSystem.Config.NetworkPtotectSystem) then
            local SpamQueryDetected = 5
            local WarningQuery = SpamQueryDetected + 5
            local BanQuery = WarningQuery + 5
            local CoolDownAdd = 0.2
            if (identifier == "SpawnEntity") then
                CoolDownAdd = 0.5
            end
            local SenderSteamID = sender:SteamID()
            local userCell = ClothingSystem.Tools.Network.Protected[SenderSteamID] || {}

            if (table.Count(userCell) == 0) then
                userCell.Query = 0
                userCell.CoolDown = CurTime() + CoolDownAdd
            elseif (userCell.CoolDown > CurTime()) then
                userCell.Query = userCell.Query + 1
                userCell.CoolDown = CurTime() + CoolDownAdd

                if (userCell.Query >= SpamQueryDetected) then
                    for k, v in ipairs(player.GetAll()) do
                        if (v:IsAdmin() || v:IsSuperAdmin()) then
                            v:SendLua([[
                                chat.AddText(Color(255, 216, 23), "[ClothingSystem][Protected]: Clogging requests for a network channel.")
                            ]])
                            v:SendLua([[
                                chat.AddText(Color(255, 0, 0), "[ClothingSystem][Protected]: The reason for the detection, the player: ]]..sender:Nick()..[[")
                            ]])
                        end
                    end
                end

                if (userCell.Query >= WarningQuery) then
                    sender:SendLua([[
                        chat.AddText(Color(255, 216, 23), "[ClothingSystem][Protected]: Do not clog the network channel with frequent requests!")
                    ]])
                    sender:SendLua([[
                        chat.AddText(Color(255, 216, 23), "[ClothingSystem][Protected]: Repeat this action a little later.")
                    ]])
                    return
                end

                if (ClothingSystem.Config.NetworkPtotectSystemBannedSpam) then
                    if (userCell.Query >= BanQuery) then
                        sender:Kick("[ClothingSystem][Protected]: Network channel spam.")
                        return
                    end
                end

            elseif (userCell.CoolDown < CurTime()) then
                if (userCell.Query > 0) then
                    userCell.Query = 0
                end
                userCell.CoolDown = CurTime() + CoolDownAdd
            end

            ClothingSystem.Tools.Network.Protected[SenderSteamID] = userCell
        end

        -- if (ClothingSystem.Config.NetworkPtotectSystem) then
        --     if (secretkey == nil || secretkey != CLOTHING_SYSTEM_PRIVATE_KEY) then return end
        -- end
        if (netType == nil || identifier == nil || array == nil) then return end
        
        if (netType == "sendtoserver") then
            ClothingSystem.Tools.Network.Call(identifier, len, array, sender)
        end
    end)
else
    net.Receive("Tools.NetWork.ClothingSystem.ToClient", function(len)
        local netType = net.ReadString()
        local identifier = net.ReadString()
        local array = net.ReadTable()
        local sender = net.ReadEntity()
        if (!sender:IsPlayer()) then
            sender = NULL
        end

        if (netType == "broadcast") then
            ClothingSystem.Tools.Network.Call(identifier, len, array, sender, LocalPlayer())
        elseif (netType == "send") then
            ClothingSystem.Tools.Network.Call(identifier, len, array, sender, LocalPlayer())
        elseif (netType == "sendomit") then
            ClothingSystem.Tools.Network.Call(identifier, len, array, sender, LocalPlayer())
        elseif (netType == "sendpas") then
            ClothingSystem.Tools.Network.Call(identifier, len, array, sender, LocalPlayer())
        elseif (netType == "sendpvs") then
            ClothingSystem.Tools.Network.Call(identifier, len, array, sender, LocalPlayer())
        end
    end)
end