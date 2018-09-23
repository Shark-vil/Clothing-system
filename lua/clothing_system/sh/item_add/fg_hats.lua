list.Set( "clothing_system", "drumpfhat", {
    Developing = true,
    Name = "Donald Trump hat",
    Category = "Hats",

	WireModel = "models/noble/drumpf/drumpfhat.mdl",
    FoldedModel = "models/noble/drumpf/drumpfhat.mdl",

    PlayerBase = "hl2_player",

    EquipSound = {
        "clothing_system/hat/1.wav",
        "clothing_system/hat/2.wav",
        "clothing_system/hat/3.wav",
        "clothing_system/hat/4.wav",
    },

    UnEquipSound = {
        "clothing_system/hat/1.wav",
        "clothing_system/hat/2.wav",
        "clothing_system/hat/3.wav",
        "clothing_system/hat/4.wav",
    },

    Equip = function (ply, class, item)
        ply:EmitSound("MAKE_AMERICA_GREAT_AGAIN")
    end,

    BoneAttach = true,
    Bone = "ValveBiped.Bip01_Head1",
    ScaleModel = 1.05,
    xPos = 0,
    yPos = -4,
    zPos = -1.2,
    xAng = -65,
    yAng = 0,
    zAng = -90,

    TypePut = {
        Head = true, 
    },
} )

sound.Add( {
	name = "MAKE_AMERICA_GREAT_AGAIN",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = "clothing_system/vapemaga.wav"
} )