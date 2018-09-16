local ignore_attacker = {
    "npc_rollermine",
    "npc_headcrab",
    "npc_headcrab_black",
    "npc_headcrab_fast",
    "npc_zombie",
    "npc_zombie_torso",
    "npc_zombine",
    "npc_poisonzombie",
    "npc_fastzombie",
    "npc_fastzombie_torso",
    "npc_manhack",
}

local controversial_weapons = {
    "weapon_stunstick",
    "weapon_crowbar",
    "weapon_fists",
    "tfa_nmrih_bat",
    "tfa_nmrih_bcd",
    "tfa_nmrih_cleaver",
    "tfa_nmrih_crowbar",
    "tfa_nmrih_etool",
    "tfa_nmrih_fireaxe",
    "tfa_nmrih_fists",
    "tfa_nmrih_fubar",
    "tfa_nmrih_hatchet",
    "tfa_nmrih_kknife",
    "tfa_nmrih_lpipe",
    "tfa_nmrih_machete",
    "tfa_nmrih_pickaxe",
    "tfa_nmrih_sledge",
    "tfa_nmrih_spade",
    "tfa_nmrih_wrench",
    "tfa_l4d2_kfkat",
    "tfa_l4d2_oren",
    "tfa_l4d2_talaxe",
    "tfa_ins2_kabar",
    "tfa_ins2_gurkha",
    "tfa_xiandagger",
    "weapon_rubyrose_scythe",
    "weapon_dawnnope_sword",
    "m9k_damascus",
    "m9k_fists",
    "m9k_knife",
    "m9k_machete",
}

ClothingSystem.Tools.Hooks.AddHook("PlayerShouldTakeDamage", function(ply, enemy)
    if (IsValid(ply) && ply:IsPlayer() && ply:Alive() && enemy:IsPlayer() || enemy:IsNPC()) then
        if (ply.ClothingSystemPlayerBase != nil) then
            if (ply.ClothingSystemPlayerIsSpawn) then
                if (#ply.ClothingSystemWearList != 0) then
                    for _, class in pairs(ply.ClothingSystemWearList) do
                        local item = list.Get('clothing_system')[class]
                        if (IsValid(enemy) && item != nil && item.PowerArmor) then
                            if (enemy:IsNPC()) then
                                if (table.HasValue(ignore_attacker, enemy:GetClass())) then return false end
                            end
                            if (IsValid(enemy:GetActiveWeapon())) then
                                local weapon = enemy:GetActiveWeapon()

                                if (table.HasValue(controversial_weapons, weapon:GetClass())) then
                                    return false
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

ClothingSystem.Tools.Hooks.AddHook("EntityTakeDamage", function(target, dmginfo)
    local enemy = dmginfo:GetAttacker()

    if (IsValid(target) && target:IsPlayer() && target:Alive()) then
        if (target.ClothingSystemPlayerBase != nil) then
            if (target.ClothingSystemPlayerIsSpawn) then
                if (#target.ClothingSystemWearList != 0) then
                    for _, class in pairs(target.ClothingSystemWearList) do
                        local item = list.Get('clothing_system')[class]
                        if (item != nil && item.PowerArmor) then
                            if (dmginfo:IsDamageType(DMG_RADIATION) || dmginfo:IsDamageType(DMG_ACID) || dmginfo:IsDamageType(DMG_POISON)) then
                                dmginfo:ScaleDamage(0)
                            end
                        end
                    end
                end
            end
        end
    elseif (IsValid(enemy) && IsValid(target) && enemy:IsPlayer()) then
        if (enemy:Alive()) then
            if (enemy.ClothingSystemPlayerBase != nil) then
                if (enemy.ClothingSystemPlayerIsSpawn) then
                    if (#enemy.ClothingSystemWearList != 0) then
                        for _, class in pairs(enemy.ClothingSystemWearList) do
                            local item = list.Get('clothing_system')[class]
                            if (item != nil && item.PowerArmor) then
                                if (IsValid(enemy:GetActiveWeapon())) then
                                    local weapon = enemy:GetActiveWeapon()
    
                                    if (table.HasValue(controversial_weapons, weapon:GetClass())) then
                                        dmginfo:ScaleDamage( dmginfo:GetDamage() + (dmginfo:GetDamage()/2) )
                                        dmginfo:SetDamageForce( Vector(dmginfo:GetDamageForce().x*2, dmginfo:GetDamageForce().y*2, dmginfo:GetDamageForce().z*2) )
                                    elseif (dmginfo:GetDamageType() == DMG_CLUB) then
                                        dmginfo:ScaleDamage( dmginfo:GetDamage() + (dmginfo:GetDamage()/2) )
                                        dmginfo:SetDamageForce( Vector(dmginfo:GetDamageForce().x*2, dmginfo:GetDamageForce().y*2, dmginfo:GetDamageForce().z*2) )
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)