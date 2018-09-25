-- timer.Create("ClothingSystem.CheckBaseReupload", 10, 0, function ()
--     local players = player.GetAll()
--     for i = 1, #players do
--         if (IsValid(players[i]) && players[i]:Alive()) then

--             local list = ClothingSystem:GetBase()

-- 			for type, _ in pairs(list) do
-- 				for key, value in pairs(list[type]) do
-- 					if ( list[type].NiceModel ) then
--                         if ( table.HasValue(value, players[i]:GetModel()) ) then
--                             ClothingSystem.Tools.Network.Send("Broadcast", "DeadOrDisconnected", {steamid = players[i]:SteamID()})
--                             table.Empty(players[i].ClothingSystemWearList['items'])

--                             ply:ClothingSystemConstruct(list[type].BoneType, type)
--                             ClothingSystem.Tools.Network.Send("Send", "ConstructData", {bones = list[type].BoneType, type = type}, nil, players[i])
-- 							return
-- 						end
-- 					end
-- 				end
--             end
            
--         end
--     end
-- end)