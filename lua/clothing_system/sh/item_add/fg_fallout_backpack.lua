list.Set( "clothing_system", "fg_fallout_backpack", {
    Name = "Backpack",
    Category = "Backpacks",

	WireModel = "models/fallout 3/campish_pack.mdl",
    FoldedModel = "models/fallout 3/campish_pack.mdl",

    PlayerBase = "hl2_player",

    BoneAttach = true,
    AttachBoneType = "ValveBiped.Bip01_Spine1",
    AttachBoneScaleModel = 1,
    xPos = 3,
    yPos = 10,
    zPos = -5,
    xAng = -90,
    yAng = 0,
    zAng = -90,

    Pockets = {
        ['Main compartment'] = 100,
    },

    TypePut = {
        Spine = true, 
    },
} )

list.Set( "clothing_system", "fg_fallout_backpack_pony_mini", {
    Name = "Mini pony backpack",
    Category = "Backpacks",

	WireModel = "models/equipmentpack/brit-backpack1.mdl",
    FoldedModel = "models/equipmentpack/brit-backpack1.mdl",

    PlayerBase = "pony",

    BoneAttach = true,
    AttachBoneType = "lrigspine1",
    AttachBoneScaleModel = 1,
    xPos = -4,
    yPos = 0,
    zPos = -3,
    xAng = 90,
    yAng = 0,
    zAng = 0,

    Pockets = {
        ['Main compartment'] = 50,
    },

    TypePut = {
        RightSide = true, 
    },
} )