AddCSLuaFile()
ClothingSystem = ClothingSystem || {}
ClothingSystem.Config = {}

-- Server --
if SERVER then
    ClothingSystem.Config.NetworkPtotectSystem = true
    ClothingSystem.Config.NetworkPtotectSystemBannedSpam = false
    ClothingSystem.Config.LogOn = false
    ClothingSystem.Config.EnhancedPMSelector_FixChangePlayermodel = true
end

-- Client --
if CLIENT then
    ClothingSystem.Config.DrawOverlay = true
end

-- Shared --
ClothingSystem.Config.Modules = true
ClothingSystem.Config.PAC3_FixChangePlayermodel = true
