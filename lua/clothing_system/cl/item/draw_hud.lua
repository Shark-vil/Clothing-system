-- Проверка на существование элементов
local function AccessCheck(ply)
    -- Если нет хотя бы 1 элемента, возвращаем false
    -- Проверка на существование маски
    if ( !ply:Alive() ) then return false end
    if ( !ply.ClothingSystemPlayerIsSpawn ) then return false end
    if ( ply:IsDormant() ) then return false end
    if ( ply:GetMoveType() == MOVETYPE_NOCLIP || ply:GetMoveType() == MOVETYPE_OBSERVER ) then return false end
    if ( !IsValid(ply:GetActiveWeapon()) ) then return false end
    if ( ply:GetActiveWeapon():GetClass() == "gmod_camera" ) then return false end
    if ( ply.ClothingSystemData['GasMask'] == nil ) then return false end
  
    -- Не рисуем оверлей
    if ( !ply.ClothingSystemData['DrawOverlay'] ) then 
        ply.ClothingSystemData['GasMask'] = false
        ply.ClothingSystemData['PowerArmor'] = false
        ply.ClothingSystemData['DrawOverlay'] = true 
        return false
    end

    -- Если все элементы массива есть, возвращаем true
    return true
end

-- Отрисовка Draw элементов
local function RenderScreenspaceEffects()
    local ply = LocalPlayer()
    local PlayerSteamID

    if (game.SinglePlayer()) then
        PlayerSteamID = "STEAM_0:0:0"
    else
        PlayerSteamID = ply:SteamID()
    end

    -- Проверка целостности массива
    if ( !AccessCheck(ply) ) then return end

    -- Проверка на существование массива с одеждой
    if ( LocalPlayer().ClothingSystemWearList[PlayerSteamID] != nil ) then
        -- Цикл по всей одежде игрока
        for _, outfit in pairs( LocalPlayer().ClothingSystemWearList[PlayerSteamID] ) do
            if (!IsValid(outfit)) then return end

            if ( outfit.SteamID != PlayerSteamID ) then return end
            
            if ( outfit.GasMask ) then
                ply.ClothingSystemData['GasMask'] = true
            end

            if ( outfit.PowerArmor ) then
                ply.ClothingSystemData['PowerArmor'] = true
            end
        end
    end

    -- Рисуем оверлей, если на любой одежде есть маска
    if (ply.ClothingSystemData['GasMask'] && !ply.ClothingSystemData['PowerArmor'] && ply.ClothingSystemData['DrawOverlay']) then
        DrawMaterialOverlay("sprites/cls_hazmatoverlay", 1)
    elseif (ply.ClothingSystemData['GasMask'] && ply.ClothingSystemData['PowerArmor'] && ply.ClothingSystemData['DrawOverlay']) then
        if (ply:Health() >= 70) then
            DrawMaterialOverlay("sprites/power_visor3.png", 1)
        elseif (ply:Health() >= 40) then
            DrawMaterialOverlay("sprites/power_visor_brokezz1.png", 1)
        else
            DrawMaterialOverlay("sprites/power_visor_brokezz2.png", 1)
        end
    end
end
hook.Add("RenderScreenspaceEffects", "ClothingSystem.RenderScreenspaceEffects", RenderScreenspaceEffects)

-- Отрисовка surface элементов
local function HUDPaint()
    local ply = LocalPlayer()

     -- Проверка целостности массива
    if ( !AccessCheck(ply) ) then return end

    -- Если маска надета, выполняем
    if (ply.ClothingSystemData['GasMask'] && ply.ClothingSystemData['DrawOverlay']) then
        -- surface.SetFont( "Trebuchet24" )
        -- surface.SetTextColor( 255, 255, 255, 255 )
        -- surface.SetTextPos( 30, 30 )
        -- surface.DrawText( "Anti radiation - equip" )

        ply.ClothingSystemData['GasMask'] = false
    end
end
hook.Add( "HUDPaint", "ClothingSystem.HUDPaint", HUDPaint)