list.Set( "clothing_system", "life_jacket_water", {
    Name = "Life jacket", -- Название
    Category = "Vest", -- Категория

	WireModel = "models/equipmentpack/lifejacket.mdl", -- Модель одежды
    FoldedModel = "models/equipmentpack/lifejacket.mdl", -- Модель Entity
    Skin = 0,

    PlayerBase = "hl2_player", -- База для одежды

    EquipSound = "clothing_system/cs_equip.wav", -- Звук при надевании
    UnEquipSound = "clothing_system/cs_unequip.wav", -- Звук при снятии

    BoneAttach = true,
    Bone = "ValveBiped.Bip01_Spine2",
    ScaleModel = 1,
    xPos = 0,
    yPos = -13,
    zPos = -3,
    xAng = 170,
    yAng = 0,
    zAng = 90,

    Think = function (ply, class)
        if ( ply:WaterLevel() > 1 ) then
            ply:SetVelocity(Vector(0, 0, 100)) 
        end
    end,

    TypePut = {
        Chest = true, -- Грудь
        BodyCenter = true, -- Тело
        Stomach = true, -- Живот
    },
} )