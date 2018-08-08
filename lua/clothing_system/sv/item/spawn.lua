-- Спавнит энтити по вызову из cl/spawn_menu.lua
local function SpawnMenuItem(len, ply)
    local class = net.ReadString()

    if (ClothingSystem:GetItem(class).AdminOnly) then
        if (!ply:IsAdmin() && !ply:IsSuperAdmin()) then return end
    end

    ClothingSystem:ItemSpawn(class, ply, true)
end
net.Receive("ClothingSystem.SpawnEntity", SpawnMenuItem)

-- Хук спавна для вызовов на стороне сервера
local function SpawnItemHook(ply, class)
    if ( !IsValid(ply) && !ply:Alive() && class == nil ) then return end
    
    ClothingSystem:ItemSpawn(class, ply, false)
end
hook.Add("ClothingSystemSpawnItem", "SpawnItem", SpawnItemHook)