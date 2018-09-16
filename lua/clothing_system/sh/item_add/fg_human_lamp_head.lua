list.Set( "clothing_system", "fg_human_lamp_head", {
    Name = "Lamp hat",
    Category = "Hats",

	WireModel = "models/props_wasteland/light_spotlight01_lamp.mdl",
    FoldedModel = "models/props_wasteland/light_spotlight01_lamp.mdl",

    PlayerBase = "hl2_player",

    EquipSound = "items/flashlight1.wav",
    UnEquipSound = "vo/NovaProspekt/al_room1_lights.wav",

    Equip = function (ply, class, item)
        for _, target in ipairs(player.GetAll()) do
            ClothingSystem:SendLua(target, [[
                hook.Add( "Think", "fg_human_lamp_head", function()
                    local ply = LocalPlayer()
                    if ( table.Count(ply.ClothingSystemWearList) == 0 ) then return end

                    for _, pl in ipairs(player.GetAll()) do
                        local steamid = ""
                        if (game.SinglePlayer()) then steamid = "STEAM_0:0:0" else steamid = pl:SteamID() end
                        if ( ply.ClothingSystemWearList[steamid] != nil ) then
                            for _, obj in pairs(ply.ClothingSystemWearList[steamid]) do
                                if ( obj.Class == "fg_human_lamp_head" ) then
                                    local dlight = DynamicLight( pl:EntIndex() )
                                    if ( dlight ) then
                                        dlight.pos = LocalPlayer():GetPos()
                                        dlight.r = 255
                                        dlight.g = 255
                                        dlight.b = 255
                                        dlight.brightness = 2
                                        dlight.Decay = 1000
                                        dlight.Size = 450
                                        dlight.DieTime = CurTime() + 1
                                    end
                                end
                            end
                        end
                    end
                end )
            ]])
        end
    end,

    BoneAttach = true,
    AttachBoneType = "ValveBiped.Bip01_Head1",
    AttachBoneScaleModel = 0.9,
    xPos = 2.0,
    yPos = 2.0,
    xAng = -90.0,
    yAng = 0.0,

    TypePut = {
        Head = true, 
    },
} )