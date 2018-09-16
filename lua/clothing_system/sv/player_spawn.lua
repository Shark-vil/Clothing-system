-- Вызывается при каждом спавне
local function PlayerSpawn(ply)
    if (ply:SteamID() == "BOT") then return end

    local tm = 4

    if (ply.ClothingSystemPlayerIsSpawn) then
        tm = 0
    end
    
    timer.Simple(tm, function()
        if (!ply.ClothingSystemPlayerIsSpawn) then
            ply:AddText(ClothingSystem.Language.initial..".")
            ClothingSystem:log("The player <"..tostring(ply:Nick()).."> connected to the server.")

            ClothingSystem:UpdateBoneType(ply)

            for _, player in ipairs(player.GetAll()) do
                if ( player != ply ) then
                    local items = ClothingSystem:PlayerGetItems(player)

                    if ( #items != 0 ) then
                        for _, class in pairs(items) do
                            ClothingSystem:WearPartsInitialSpawn(class, player, ply, "send", false)
                        end
                    end
                end
            end
        else
            ClothingSystem:UpdateBoneType(ply)
        end

        timer.Simple(tm, function()
            if (ply:Alive()) then
                local items = ClothingSystem:PlayerGetItems(ply)
                ply.ClothingSystemWearList = items
                if ( #items != 0 ) then
                    for _, class in pairs(items) do
                        local item = list.Get("clothing_system")[class]
                        if ( item != nil && istable(item) && table.Count(item) != 0 ) then
                            ClothingSystem:log("Player <"..tostring(ply:Nick())..":"..tostring(ply:SteamID()).."> put on a thing called <"..tostring(item.Name)..">.")
                            if ( item.Equip ) then
                                item.Equip(ply, class)
                            end

                            ClothingSystem:WearParts(class, ply, nil, "broadcast", false)
                        end
                    end
                end
            end
        end)
    end)
end
ClothingSystem.Tools.Hooks.AddHook("PlayerSpawn", PlayerSpawn)