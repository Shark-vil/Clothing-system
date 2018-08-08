list.Set( "clothing_system", "fg_testing_class_pony", {
    Name = "Test Pony",
    Category = "Test",

    WireModel = "models/props/cs_assault/BarrelWarning.mdl",
    FoldedModel = "models/props_c17/SuitCase_Passenger_Physics.mdl",

    PlayerBase = "pony",

    BoneAttach = true,
    AttachBoneType = "LrigScull",
    AttachBoneScaleModel = 1,
    xPos = 0,
    yPos = 0,
    zPos = 0,
    xAng = 0,
    yAng = 0,
    zAng = 0,

    BonemergeSystem = false,
    TypePut = {
        Head = true, 
    },
} )

list.Set( "clothing_system", "fg_testing_class_human", {
    Name = "Test Human",
    Category = "Test",
    PowerArmor = true,
    SetPlayerModel = true,

    WireModel = "models/kuma96/powerarmor_t51/resized/powerarmor_t51_mini_pm.mdl",
    FoldedModel = "models/props_c17/SuitCase_Passenger_Physics.mdl",

    PlayerBase = "hl2_player",

    Skin = 0,

    EquipSound = "clothing_system/power_armor/enter.mp3", 
    UnEquipSound = "clothing_system/power_armor/exit.mp3",
    WalkSound = {
        "clothing_system/power_armor/walk_2.mp3",
        "clothing_system/power_armor/walk_3.mp3",
        "clothing_system/power_armor/walk_4.mp3",
        "clothing_system/power_armor/walk_5.mp3",
        "clothing_system/power_armor/walk_6.mp3",
        "clothing_system/power_armor/walk_7.mp3",
        "clothing_system/power_armor/walk_8.mp3",
    },
    JumpSound = {
        "clothing_system/power_armor/jump_up_1.mp3",
        "clothing_system/power_armor/jump_up_2.mp3",
    },
    LandingSound = {
        "clothing_system/power_armor/jump_down_1.mp3",
        "clothing_system/power_armor/jump_down_2.mp3",
    },
    PowerLandingSound = "clothing_system/power_armor/jump_down_1.mp3",
    UnderWaterSound = {
        "clothing_system/power_armor/water_walk_1.mp3",
        "clothing_system/power_armor/water_walk_2.mp3",
        "clothing_system/power_armor/water_walk_3.mp3",
        "clothing_system/power_armor/water_walk_4.mp3",
        "clothing_system/power_armor/water_walk_5.mp3",
        "clothing_system/power_armor/water_walk_6.mp3",
    },
 
    TakeDamageSystem = true, 
    GasMask = true,
    TakesDamagePercent = {
        [DMG_BULLET]=.2,
        [DMG_SLASH]=.0, 
        [DMG_BURN]=.6,
        [DMG_BLAST]=.7,
        [DMG_CLUB]=.0, 
        [DMG_ENERGYBEAM]=.8, 
        [DMG_AIRBOAT]=.7, 
        [DMG_BUCKSHOT]=.0, 
        [DMG_SHOCK]=.0,
        [DMG_CRUSH]=.3,
        [DMG_DISSOLVE]=.0,
        [DMG_BLAST_SURFACE]=.0,
    },

    Pockets = {
        ['Отсек для хранения'] = 10,
    },

    Spawn = function(item)
        item["saveArray"]["AddArmor"] = 100
    end,

    Think = function(ply, class)
        if (ply:Health() > 60) then
            ply:SetBodyGroups("000000000000")
        elseif (ply:Health() > 50) then
            ply:SetBodyGroups("000001000000")
        elseif (ply:Health() > 40) then
            ply:SetBodyGroups("000001100000")
        elseif (ply:Health() > 30) then
            ply:SetBodyGroups("000001110000")
        elseif (ply:Health() > 20) then
            ply:SetBodyGroups("000001111000")
        elseif (ply:Health() > 15) then
            ply:SetBodyGroups("000001111100")
        elseif (ply:Health() > 10) then
            ply:SetBodyGroups("000001111110")
        elseif (ply:Health() > 5) then
            ply:SetBodyGroups("000011111110")
        end
    end,
    
    Damage =  function(ply)
        if (ply:Health() == 60 || ply:Health() == 55) then
            ply:EmitSound("physics/metal/metal_box_break"..math.random(2, 4)..".wav")
        elseif (ply:Health() == 50 || ply:Health() == 45) then
            ply:EmitSound("physics/metal/metal_box_break"..math.random(2, 4)..".wav")
        elseif (ply:Health() == 40 || ply:Health() == 35) then
            ply:EmitSound("physics/metal/metal_box_break"..math.random(2, 4)..".wav")
        elseif (ply:Health() == 30 || ply:Health() == 25) then
            ply:EmitSound("physics/metal/metal_box_break"..math.random(2, 4)..".wav")
        elseif (ply:Health() == 20) then
            ply:EmitSound("physics/metal/metal_box_break"..math.random(2, 4)..".wav")
        elseif (ply:Health() == 15) then
            ply:EmitSound("physics/metal/metal_box_break"..math.random(2, 4)..".wav")
        elseif (ply:Health() == 10) then
            ply:EmitSound("physics/metal/metal_box_break"..math.random(2, 4)..".wav")
        elseif (ply:Health() == 5) then
            ply:EmitSound("physics/metal/metal_box_break"..math.random(2, 4)..".wav")
        end
    end,

    Equip = function (ply, class, item)
        local AddArmor
        local DataSaves = {}

        if (item) then
            AddArmor = item["saveArray"]["AddArmor"] || 0
        else
            if (ClothingSystem:GetSvData(ply, class, 'Armor')) then
                AddArmor = ClothingSystem:GetSvData(ply, class, 'Armor')
            else
                AddArmor = 0
            end
        end

        if ( (ply:Armor()+AddArmor) <= 100 ) then
            ply:SetArmor(ply:Armor()+AddArmor)
        else
            ply:SetArmor(100)
        end

        DataSaves['Armor'] = AddArmor
        DataSaves['NormalWalk'] = ply:GetWalkSpeed()
        DataSaves['NormalRun'] = ply:GetRunSpeed()
        DataSaves['NewWalk'] = DataSaves['NormalWalk']/2
        DataSaves['NewRun'] = DataSaves['NormalRun']/2

        ply:SetWalkSpeed(DataSaves['NewWalk'])
        ply:SetRunSpeed(DataSaves['NewRun'])

        ClothingSystem:SaveSvData(ply, class, DataSaves)
    end,

    Disconnected = function(ply, class)
        local RemoveArmor = 100
        local DataSaves = {}

        if ( (ply:Armor()-RemoveArmor) <= 0 ) then
            RemoveArmor = ply:Armor()
        end

        ClothingSystem:SaveSvData(ply, class, {['Armor'] = RemoveArmor})
    end,

    Drop = function (ply, class, item)
        local RemoveArmor = 100

        if ( (ply:Armor()-RemoveArmor) >= 0 ) then
            ply:SetArmor(ply:Armor()-RemoveArmor)
        else
            RemoveArmor = ply:Armor()
            ply:SetArmor(0)
        end

        ClothingSystem:SaveSvData(ply, class, {['Armor'] = 0})

        item["saveArray"]["AddArmor"] = RemoveArmor

        ply:SetWalkSpeed(ClothingSystem:GetSvData(ply, class, 'NormalWalk'))
        ply:SetRunSpeed(ClothingSystem:GetSvData(ply, class, 'NormalRun'))
    end,

    Death = function(ply, class)
        ply:SetWalkSpeed(ClothingSystem:GetSvData(ply, class, 'NormalWalk'))
        ply:SetRunSpeed(ClothingSystem:GetSvData(ply, class, 'NormalRun'))
    end,
} )

-- list.Set( "clothing_system", "fg_testing_class_pony", {
--     Name = "Test Pony",
--     Category = "Test",

-- 	WireModel = "models/props/cs_assault/BarrelWarning.mdl",
--     FoldedModel = "models/props_c17/SuitCase_Passenger_Physics.mdl",

--     PlayerBase = "pony",

--     BoneAttach = true,
--     AttachBoneType = "LrigScull",
--     AttachBoneScaleModel = 1,
--     xPos = 0,
--     yPos = 0,
--     zPos = 0,
--     xAng = 0,
--     yAng = 0,
--     zAng = 0,

--     BonemergeSystem = false,
--     TypePut = {
--         Head = true, 
--     },
-- } )

-- list.Set( "clothing_system", "fg_testing_class_human", {
--     Name = "Test Human",
--     Category = "Test",

-- 	WireModel = "models/props/cs_assault/BarrelWarning.mdl",
--     FoldedModel = "models/props_c17/SuitCase_Passenger_Physics.mdl",

--     PlayerBase = "hl2_player",

--     BoneAttach = true,
--     AttachBoneType = "ValveBiped.Bip01_Pelvis",
--     AttachBoneScaleModel = 1,
--     xPos = 0,
--     yPos = 0,
--     zPos = 0,
--     xAng = 0,
--     yAng = 0,
--     zAng = 0,

--     BonemergeSystem = false,
--     TypePut = {
--         Head = true, 
--     },
-- } )