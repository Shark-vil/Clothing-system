local ignore_attacker = {
    "npc_rollermine",
    "npc_headcrab",
    "npc_headcrab_black",
    "npc_headcrab_fast",
    "npc_zombie",
    "npc_zombie_torso",
    "npc_zombine",
    "npc_poisonzombie",
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

hook.Add("PlayerShouldTakeDamage", "ClothingSystemModule.EntityTakeDamage", function(ply, enemy)
    if (IsValid(ply) && ply:IsPlayer() && ply:Alive() && enemy:IsPlayer() || enemy:IsNPC()) then
        if (table.HasValue(ignore_attacker, enemy:GetClass())) then return false end
        if (ply.ClothingSystemPlayerBase != nil) then
            if (ply.ClothingSystemPlayerIsSpawn) then
                local items = ClothingSystem:PlayerGetItems(ply)
                if (!ClothingSystem:TableIsEmpty(items)) then
                    for _, class in pairs(items) do
                        local item = list.Get("clothing_system")[class]
                        if (IsValid(enemy) && item.PowerArmor) then
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

hook.Add("EntityTakeDamage", "ClothingSystemModule.EntityTakeDamage", function(target, dmginfo)
    local enemy = dmginfo:GetAttacker()
    
    if (IsValid(enemy) && IsValid(target) && enemy:IsPlayer()) then
        if (enemy:Alive()) then
            if (enemy.ClothingSystemPlayerBase != nil) then
                if (enemy.ClothingSystemPlayerIsSpawn) then
                    local items = ClothingSystem:PlayerGetItems(enemy)
                    if (!ClothingSystem:TableIsEmpty(items)) then
                        for _, class in pairs(items) do
                            local item = ClothingSystem:GetItem(class)
                            if (item.PowerArmor) then
                                if (IsValid(enemy:GetActiveWeapon())) then
                                    local weapon = enemy:GetActiveWeapon()
    
                                    if (table.HasValue(controversial_weapons, weapon:GetClass())) then
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