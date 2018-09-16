-- Проверка на существование элементов
local function AccessCheck(ply)
    if ( !ply:Alive() ) then return false end
    if ( !ply.ClothingSystemPlayerIsSpawn ) then return false end
    if ( ply:IsDormant() ) then return false end
    if ( ply:GetMoveType() == MOVETYPE_NOCLIP || ply:GetMoveType() == MOVETYPE_OBSERVER ) then return false end
    if (IsValid(ply:GetActiveWeapon())) then
        if ( ply:GetActiveWeapon():GetClass() == "gmod_camera" ) then return false end
    end
    if ( !ply.ClothingSystemData['ActiveOverlay'] ) then return end

    return true
end

-- Отрисовка Draw элементов
local function RenderScreenspaceEffects()
    if (GetConVar("clothing_system_draw_overlay"):GetInt() == 0) then return end
    if (!ClothingSystem.Config.DrawOverlay) then return end
    local ply = LocalPlayer()
    local health = ply:Health()
    local PlayerSteamID

    if (game.SinglePlayer()) then
        PlayerSteamID = "STEAM_0:0:0"
    else
        PlayerSteamID = ply:SteamID()
    end

    -- Проверка целостности массива
    if ( !AccessCheck(ply) ) then return end


    for _, v in ipairs(ply.ClothingSystemData['ActiveOverlay']) do
        if (health >= v[2]) then
            DrawMaterialOverlay(v[1], 1)
            break
        end
    end
end
ClothingSystem.Tools.Hooks.AddHook("RenderScreenspaceEffects", RenderScreenspaceEffects)