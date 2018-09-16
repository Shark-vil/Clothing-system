ClothingStorageSystem = ClothingStorageSystem || {}

if SERVER then
    ClothingStorageSystemProtectArray = ClothingStorageSystemProtectArray || {}
end

local META = {}
-- local AddItems = {}

META.Add = function(self, array)
    local _class = array['class'] || nil
    local _weight = array['weight'] || 0
    local _spawn = array['spawn'] || function(ply, array, ent)end
    local _serverSave = array['server'] || function(ply, ent) return {} end
    local _clientSave = array['client'] || function(ply, ent) return {} end
    local _giveAmmo = array['giveAmmo'] || function(ply, class) return {} end
    local _isWeapon = array['weapon'] || false

    if (_class != nil) then
        if (_isWeapon) then
            -- _spawn = function(ply, array, ent)
            --     ClothingStorageSystem:WeaponGive(ply, array, ent)
            -- end
            _giveAmmo = function(ply, array, ent, stat)
                ClothingStorageSystem:WeaponGive(ply, array, ent, stat)
            end
            _serverSave = function(ply, ent)
                return ClothingStorageSystem:WeaponSave(ply, ent)
            end
        end

        list.Set( "clothing_storage_system", _class, {
            weight = _weight,
            spawn = _spawn,
            serverSave = _serverSave,
            clientSave = _clientSave,
            giveAmmo = _giveAmmo,
        } )

        -- AddItems[_class] = {
        --     ['weight'] = _weight,
        --     ['spawn'] = _spawn,
        --     ['serverSave'] = _serverSave,
        --     ['clientSave'] = _clientSave,
        -- }
    end
end

-- hook.Add( "InitPostEntity", "ClothingStorageSystem.AddModules", function()

-- end)

META.GetItem = function(self, class)
    if ( class ) then
        if ( list.Get("clothing_storage_system")[class] ) then
            return list.Get("clothing_storage_system")[class]
        else
            return false
        end
    end

    return list.Get("clothing_storage_system")
end

META.GetTrace = function (self, ply)
    local trace = {}
    trace.start = ply:EyePos()
    trace.endpos = trace.start + ply:GetAimVector() * 85
    trace.filter = ply
    local tr = util.TraceLine(trace)

    if (IsValid(ply) && ply:Alive()) then
        return tr
    else
        return nil
    end
end

if SERVER then
    META.AddProtect = function (self, ply, finalTable)
        ClothingStorageSystemProtectArray.playerDetected = ClothingStorageSystemProtectArray.playerDetected or {}
        ClothingStorageSystemProtectArray.playerDetected[ply:SteamID()] = finalTable
        return true
    end
    META.CheckProtect = function (self, ply, finalTable)
        ClothingStorageSystemProtectArray.playerDetected = ClothingStorageSystemProtectArray.playerDetected or {}
        ClothingStorageSystemProtectArray.playerDetectedCheaters = ClothingStorageSystemProtectArray.playerDetectedCheaters or {}
        if (ClothingStorageSystemProtectArray.playerDetected[ply:SteamID()] != nil) then
            if (ClothingStorageSystemProtectArray.playerDetected[ply:SteamID()]['entityValue'] == finalTable['entityValue'] &&
            ClothingStorageSystemProtectArray.playerDetected[ply:SteamID()]['entityID'] == finalTable['entityID'] &&
            ClothingStorageSystemProtectArray.playerDetected[ply:SteamID()]['entityClass'] == finalTable['entityClass']) then
                ClothingStorageSystemProtectArray.playerDetected[ply:SteamID()] = nil
                ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] = nil
                return true
            else
                ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] = ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] or 0
                ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] = ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] + 1
                if (ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] > 1) then
                    ClothingStorageSystemProtectArray.playerDetected[ply:SteamID()] = nil
                    ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] = nil
                    if (game.SinglePlayer()) then
                        ply:ConCommand("disconnect")
                    else
                        ply:Kick("[ClothingSystem][Protected] - Detected net cheat.")
                    end
                end
                return false
            end
        else
            ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] = ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] or 0
            ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] = ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] + 1
            if (ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] > 1) then
                ClothingStorageSystemProtectArray.playerDetected[ply:SteamID()] = nil
                ClothingStorageSystemProtectArray.playerDetectedCheaters[ply:SteamID()] = nil
                if (game.SinglePlayer()) then
                    ply:ConCommand("disconnect")
                else
                    ply:Kick("[ClothingSystem][Protected] - Detected net cheat.")
                end
            end
            return false
        end

        return false
    end
    META.WeaponSave = function (self, ply, weapon)
        local ammo = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
        local clip1 = weapon:Clip1()
        local clip2 = weapon:Clip1()

        local wep = ply:GetWeapon(weapon:GetClass())

        if (IsValid(wep) && wep == weapon) then
            ply:SetAmmo( 0, weapon:GetPrimaryAmmoType())
            weapon:SetClip1(0)
            weapon:SetClip2(0)
        end

        for k, v in ipairs(ply:GetWeapons()) do
            if (v != weapon) then
                ply:SelectWeapon(v:GetClass())
                break
            end
        end
        
        return {
            ['ammo'] = ammo,
            ['clip1'] = clip1,
            ['clip2'] = clip2,
        }
    end
    META.WeaponPickup = function (self, ply, class, ammo, clip1, clip2, oldclip1, oldclip2)
        timer.Simple(0.2, function()
            if (!IsValid(ply) || !ply:Alive()) then return end
            local weapon = ply:GetWeapon(class)
            local ammoType = weapon:GetPrimaryAmmoType()

            if (oldclip1 <= 0) then
                weapon:SetClip1(clip1)
                ply:SetAmmo( (ammo), ammoType)
            else
                ply:SetAmmo( (ammo+clip1), ammoType)
            end
            weapon:SetClip2(oldclip2+clip2)
        end)
        -- GetConVar("sv_manualweaponpickup"):SetInt(1)
        return true
    end
    META.WeaponGive = function (self, ply, array, weapon, stat)
        if (stat) then
            local isWeapon = false
            local ammo = 0
            local clip1 = 0
            local clip2 = 0
            local ammoType = nil
            local gun = NULL

            for k, v in pairs(ply:GetWeapons()) do
                if (v:GetClass() == weapon) then
                    ammo = ply:GetAmmoCount(v:GetPrimaryAmmoType())
                    clip1 = v:Clip1()
                    clip2 = v:Clip2()
                    isWeapon  = true
                end
            end
        
            if (!isWeapon) then
                gun = ply:Give(weapon, true)
            end

            timer.Simple(0.1, function()
                if (!IsValid(ply) || !ply:Alive()) then return end
                gun = ply:GetWeapon(weapon)
                ammoType = gun:GetPrimaryAmmoType()

                if (clip1 <= 0) then
                    gun:SetClip1(array['clip1'])
                    ply:SetAmmo( (array['ammo']+ammo), ammoType)
                else
                    ply:SetAmmo( (array['ammo']+ammo+array['clip1']), ammoType)
                end
                gun:SetClip2(array['clip2']+clip2)
                ply:SelectWeapon(weapon)
            end)
            return true
        else
            weapon:SetClip1(array['clip1'])
            weapon:SetClip2(array['clip2'])
            return true
        end

        return false
    end
else

end


META.__index = META
setmetatable(ClothingStorageSystem, META)

include("itemsadd.lua")