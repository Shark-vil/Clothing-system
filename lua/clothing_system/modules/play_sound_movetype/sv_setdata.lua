local function stopsound(ply, str)
    if (istable(ply.ClothingSystemPlaysoundData[str][1])) then
        local ln = table.Count(ply.ClothingSystemPlaysoundData[str][1]) 
        ply:StopSound( ply.ClothingSystemPlaysoundData[str][1][math.random(1, ln)] )
    else
        ply:StopSound( ply.ClothingSystemPlaysoundData[str][1] )
    end
end

local function set(ply, class, item)
    if (item.WalkSound && ply.ClothingSystemPlaysoundData['WalkSound'] == nil) then
        ply.ClothingSystemPlaysoundData['WalkSound'] = { item.WalkSound, class }
    end
    if (item.RunSound && ply.ClothingSystemPlaysoundData['RunSound'] == nil) then
        ply.ClothingSystemPlaysoundData['RunSound'] = { item.RunSound, class }
    end
    if (item.JumpSound && ply.ClothingSystemPlaysoundData['JumpSound'] == nil) then
        ply.ClothingSystemPlaysoundData['JumpSound'] = { item.JumpSound, class }
    end
    if (item.LandingSound && ply.ClothingSystemPlaysoundData['LandingSound'] == nil) then
        ply.ClothingSystemPlaysoundData['LandingSound'] = { item.LandingSound, class }
    end
    if (item.PowerLandingSound && ply.ClothingSystemPlaysoundData['PowerLandingSound'] == nil) then
        ply.ClothingSystemPlaysoundData['PowerLandingSound'] = { item.PowerLandingSound, class }
    end
    if (item.UnderWaterSound && ply.ClothingSystemPlaysoundData['UnderWaterSound'] == nil) then
        ply.ClothingSystemPlaysoundData['UnderWaterSound'] = { item.UnderWaterSound, class }
    end
    if (item.AboveWaterSound && ply.ClothingSystemPlaysoundData['AboveWaterSound'] == nil) then
        ply.ClothingSystemPlaysoundData['AboveWaterSound'] = { item.AboveWaterSound, class }
    end
    if (item.DamageSoundList && ply.ClothingSystemPlaysoundData['DamageSoundList'] == nil) then
        ply.ClothingSystemPlaysoundData['DamageSoundList'] = { item.DamageSoundList, class }
    end
    if (item.RadiationSound && ply.ClothingSystemPlaysoundData['RadiationSound'] == nil) then
        ply.ClothingSystemPlaysoundData['RadiationSound'] = { item.RadiationSound, class }
    end
    if (item.BreathSoundInGasMask && item.GasMask && ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'] == nil) then
        ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'] = { item.BreathSoundInGasMask, class }
    elseif (!item.BreathSoundInGasMask && item.GasMask && ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'] == nil) then
        ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'] = { "clothsys_gasmask_2", class }
    end
end

local function unset(ply, class, item)
    if (item.WalkSound && ply.ClothingSystemPlaysoundData['WalkSound'] && ply.ClothingSystemPlaysoundData['WalkSound'][2] == class) then
        stopsound(ply, 'WalkSound')
        ply.ClothingSystemPlaysoundData['WalkSound'] = nil
    end
    if (item.RunSound && ply.ClothingSystemPlaysoundData['RunSound'] && ply.ClothingSystemPlaysoundData['RunSound'][2] == class) then
        stopsound(ply, 'RunSound')
        ply.ClothingSystemPlaysoundData['RunSound'] = nil
    end
    if (item.JumpSound && ply.ClothingSystemPlaysoundData['JumpSound'] && ply.ClothingSystemPlaysoundData['JumpSound'][2] == class) then
        stopsound(ply, 'JumpSound')
        ply.ClothingSystemPlaysoundData['JumpSound'] = nil
    end
    if (item.LandingSound && ply.ClothingSystemPlaysoundData['LandingSound'] && ply.ClothingSystemPlaysoundData['LandingSound'][2] == class) then
        stopsound(ply, 'LandingSound')
        ply.ClothingSystemPlaysoundData['LandingSound'] = nil
    end
    if (item.PowerLandingSound && ply.ClothingSystemPlaysoundData['PowerLandingSound'] && ply.ClothingSystemPlaysoundData['PowerLandingSound'][2] == class) then
        stopsound(ply, 'PowerLandingSound') 
        ply.ClothingSystemPlaysoundData['PowerLandingSound'] = nil
    end
    if (item.UnderWaterSound && ply.ClothingSystemPlaysoundData['UnderWaterSound'] && ply.ClothingSystemPlaysoundData['UnderWaterSound'][2] == class) then
        stopsound(ply, 'UnderWaterSound') 
        ply.ClothingSystemPlaysoundData['UnderWaterSound'] = nil
    end
    if (item.AboveWaterSound && ply.ClothingSystemPlaysoundData['AboveWaterSound'] && ply.ClothingSystemPlaysoundData['AboveWaterSound'][2] == class) then
        stopsound(ply, 'AboveWaterSound') 
        ply.ClothingSystemPlaysoundData['AboveWaterSound'] = nil
    end
    if (item.DamageSoundList && ply.ClothingSystemPlaysoundData['DamageSoundList'] && ply.ClothingSystemPlaysoundData['DamageSoundList'][2] == class) then
        stopsound(ply, 'DamageSoundList') 
        ply.ClothingSystemPlaysoundData['DamageSoundList'] = nil
    end
    if (item.BreathSoundInGasMask && ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'] && ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'][2] == class) then
        stopsound(ply, 'BreathSoundInGasMask') 
        ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'] = nil
    end
    if (item.RadiationSound && ply.ClothingSystemPlaysoundData['RadiationSound'] && ply.ClothingSystemPlaysoundData['RadiationSound'][2] == class) then
        stopsound(ply, 'RadiationSound') 
        ply.ClothingSystemPlaysoundData['RadiationSound'] = nil
    end
end

-- Вызов хука, срабатывающего при выбрасывании предмета
hook.Add("ClothingSystem.Drop", "SetBaseSound", function(class, owner)
    local item = ClothingSystem:GetItem(class) -- Получение массива с параметрами одежды
    local ply = owner -- Получение игрока по steamid

    -- Проверка на существование игрока
    if (!IsValid(ply) || !ply:IsPlayer()) then return end

    -- Если массива не существует, устанавливаем пустой массив
    ply.ClothingSystemPlaysoundData = ply.ClothingSystemPlaysoundData || {}

    unset(ply, class, item)

    local items = ClothingSystem:PlayerGetItems(owner)

    if ( !ClothingSystem:TableIsEmpty(items) ) then
        local max = #items
        local itm = max
        for i=1, max do
            local _object = ClothingSystem:GetItem(items[itm])
            set(ply, items[itm], _object)
            itm = itm - 1
        end
    end
end)

-- Вызов хука, срабатывающего при экипировании одежды
hook.Add("ClothingSystem.Wear", "SetBaseSound", function(class, owner)
    local item = ClothingSystem:GetItem(class) -- Получение массива с параметрами одежды
    local ply = owner -- Получение игрока по steamid

     -- Проверка на существование игрока
    if (!IsValid(ply) || !ply:IsPlayer()) then return end

    -- Если массива не существует, устанавливаем пустой массив
    ply.ClothingSystemPlaysoundData = ply.ClothingSystemPlaysoundData || {}

    -- Параметр проверки касания игрока с землёй
    ply.ClothingSystemPlaysoundData['isLandingCheck'] = 0
    ply.ClothingSystemPlaysoundData['isDamageCurTime'] = 0
    ply.ClothingSystemPlaysoundData['isGasMaskCurTime'] = 0

    set(ply, class, item)
end)

local function PlayerDeathReset(ply)
    if (!IsValid(ply) || !ply:IsPlayer()) then return end

    if (ply.ClothingSystemPlaysoundData) then
        ply.ClothingSystemPlaysoundData['WalkSound'] = nil
        ply.ClothingSystemPlaysoundData['RunSound'] = nil
        ply.ClothingSystemPlaysoundData['JumpSound'] = nil
        ply.ClothingSystemPlaysoundData['LandingSound'] = nil
        ply.ClothingSystemPlaysoundData['PowerLandingSound'] = nil
        ply.ClothingSystemPlaysoundData['UnderWaterSound'] = nil
        ply.ClothingSystemPlaysoundData['AboveWaterSound'] = nil
        ply.ClothingSystemPlaysoundData['BreathSoundInGasMask'] = nil
        ply.ClothingSystemPlaysoundData['DamageSoundList'] = nil
        ply.ClothingSystemPlaysoundData['RadiationSound'] = nil
    end
end
hook.Add( "PlayerDeath", "ClothingSystem.PlayerDeathReset.SoundEffectModule", PlayerDeathReset )