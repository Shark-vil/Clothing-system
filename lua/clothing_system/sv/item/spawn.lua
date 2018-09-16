-- Спавнит энтити по вызову из cl/spawn_menu.lua
local function SpawnMenuItem(len, data, sender)
    if (ClothingSystem:GetItem(data.class).AdminOnly) then
        if (!sender:IsAdmin() && !sender:IsSuperAdmin()) then return end
    end

    ClothingSystem:ItemSpawn(data.class, sender, true)
end
ClothingSystem.Tools.Network.AddNetwork("SpawnEntity", SpawnMenuItem)

-- Хук спавна для вызовов на стороне сервера
local function SpawnItemHook(ply, class)
    if ( !IsValid(ply) && !ply:Alive() && class == nil ) then return end
    
    ClothingSystem:ItemSpawn(class, ply, false)
end
ClothingSystem.Tools.Hooks.AddHook("ClothingSystemSpawnItem", SpawnItemHook)

--[=[
-- Спавнит энтити по вызову из cl/spawn_menu.lua
local function SpawnMenuItem(len, data, sender)
    if (ClothingSystem:GetItem(data.class).AdminOnly) then
        if (!sender:IsAdmin() && !sender:IsSuperAdmin()) then return end
    end

    if (!util.IsValidModel(list.Get('clothing_system')[data.class].WireModel)) then return end

    ClothingSystem:ItemSpawn(data.class, sender, true)
end
ClothingSystem.Tools.Network.AddNetwork("SpawnEntity", SpawnMenuItem)

-- Хук спавна для вызовов на стороне сервера
local function SpawnItemHook(ply, class)
    if ( !IsValid(ply) && !ply:Alive() && class == nil ) then return end

    if (!util.IsValidModel(list.Get('clothing_system')[class].WireModel)) then return end
    
    ClothingSystem:ItemSpawn(class, ply, false)
end
ClothingSystem.Tools.Hooks.AddHook("ClothingSystemSpawnItem", SpawnItemHook)
]=]