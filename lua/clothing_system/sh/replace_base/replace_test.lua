list.Add( "clothing_system_replace", {
    Class = "fg_pony_stripy_hat",
    WireModel = "models/props/cs_assault/BarrelWarning.mdl",
    ReplaceToBase = "hl2_player",
    AttachBoneType = "ValveBiped.Bip01_Head1",
    AttachBoneScaleModel = 0.3,
    xPos = -3.0,
    yPos = -2.0,
    xAng = 50.0,
    yAng = -90.0,
    Bodygroup = {0, 0},
    Skin = 0,
    TypePut = {
        Head = true,
    },
} )

list.Add( "clothing_system_replace", {
    Class = "fg_human_lamp_head",
    ReplaceToModel = {
        "models/player/police.mdl",
        "models/player/police_fem.mdl",
    },
    AttachBoneScaleModel = 0.9,
    xPos = 2.0,
    yPos = 2.0,
    zPos = -2.2,
    xAng = -90.0,
    yAng = 0.0,
} )

-- list.Add( "clothing_system_replace", {
--     Class = "fg_helmet_cvc",
--     ReplaceToModel = {
--         'models/ppm/player_default_base_new.mdl',
--         'models/ppm/player_default_base_new_nj.mdl',
--     },
--     AttachBoneType = "LrigScull",
--     AttachBoneScaleModel = 0.9,
--     xPos = 2.0,
--     yPos = 2.0,
--     zPos = -2.2,
--     xAng = -90.0,
--     yAng = 0.0,
-- } )