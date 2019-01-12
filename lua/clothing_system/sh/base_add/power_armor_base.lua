list.Set( "clothing_system_base", "fallout_power_armor", {
    Name = "Power Armor",
    Category = "Power Armor",

    PowerArmor = true,
    SetPlayerModel = true,
	WireModel = "models/player/combine_soldier.mdl",
    FoldedModel = "models/player/combine_soldier.mdl",

    CustomCollision = true,

    PlayerBase = "hl2_player",

    Overlay = {
        {"sprites/power_visor3.png", 70},
        {"sprites/power_visor_brokezz1.png", 40},
        {"sprites/power_visor_brokezz2.png", 0},
    },

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
    PowerLandingSound = "clothing_system/power_armor/power_armor_fall.mp3",
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
        [DMG_BULLET]=.1,
        [DMG_SLASH]=.3,
        [DMG_BURN]=.5,
        [DMG_BLAST]=.6,
        [DMG_CLUB]=.0,
        [DMG_ENERGYBEAM]=.7,
        [DMG_AIRBOAT]=.6,
        [DMG_BUCKSHOT]=.0,
        [DMG_SHOCK]=.0,
        [DMG_CRUSH]=.3,
        [DMG_DISSOLVE]=.0,
        [DMG_BLAST_SURFACE]=.0,
    },

    SetMaxArmor = 100,

    Spawn = function(item)
        local info = list.Get("clothing_system")[item.Class]
        if (info == nil) then info = list.Get("clothing_system_base")["fallout_power_armor"] end

        item["saveArray"]["AddArmor"] = info.SetMaxArmor
    end,

    Equip = function (ply, class, item)
        local AddArmor
        local DataSaves = {}

        if (IsValid(item)) then
            AddArmor = item["saveArray"]["AddArmor"] || 0
        else
            if (ClothingSystem:GetSvData(ply, class, 'Armor')) then
                AddArmor = ClothingSystem:GetSvData(ply, class, 'Armor')
            else
                AddArmor = 0
            end
        end

        local info = list.Get("clothing_system")[item.Class]
        if (info == nil) then info = list.Get("clothing_system_base")["fallout_power_armor"] end
        if ( (ply:Armor()+AddArmor) <= info.SetMaxArmor ) then
            ply:SetArmor(ply:Armor()+AddArmor)
        else
            ply:SetArmor(info.SetMaxArmor)
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
        local info = list.Get("clothing_system")[item.Class]
        if (info == nil) then info = list.Get("clothing_system_base")["fallout_power_armor"] end
        local RemoveArmor = info.SetMaxArmor
        local DataSaves = {}

        if ( (ply:Armor()-RemoveArmor) <= 0 ) then
            RemoveArmor = ply:Armor()
        end

        ClothingSystem:SaveSvData(ply, class, {['Armor'] = RemoveArmor})
    end,

    Drop = function (ply, class, item)
        local info = list.Get("clothing_system")[item.Class]
        if (info == nil) then info = list.Get("clothing_system_base")["fallout_power_armor"] end
        local RemoveArmor = info.SetMaxArmor

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