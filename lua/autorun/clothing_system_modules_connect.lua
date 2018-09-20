ClothingSystem = ClothingSystem || {}

file.CreateDir("clothing_system")
file.CreateDir("clothing_system/log")
include("clothing_system_load_author_banner.lua")
include("clothing_system_tools.lua")
include("clothing_system_cfg.lua")
include("clothing_system_language.lua")
include("clothing_system_storage_meta.lua")
include("clothing_system_updates.lua")

local prefix = 'clothing_system'
local shared = {
    'sh/enhanced_pm_selector.lua',
    'sh/pac3.lua',
    'sh/cvars.lua',
    'sh/lua_metatable.lua',
    'sh/player_metatable.lua',
    'sh/base_add/base.lua',
    'sh/item_add/fg_human_lamp_head.lua',
    'sh/item_add/fg_hats.lua',
    'sh/item_add/fg_fallout_backpack.lua',
    'sh/item_add/fg_items_testing.lua',
    'sh/item_add/life_jacket.lua',
    'sh/replace_base/replace_test.lua',
    'sh/sound_effects/include.lua',
}
local client = {
    'cl/update_list.lua',
    'cl/construct_data.lua',
    'cl/spawn_menu.lua',
    'cl/item/draw_clothing.lua',
    'cl/item/draw_to_text.lua',
    'cl/item/drop.lua',
    'cl/item/wear.lua',
    'cl/item/draw_hud.lua',
    'cl/cleanup_rebuild.lua',
    'cl/vgui/clothing_menu.lua',
    'cl/sendlua.lua',
}
local server = {
    'sv/player_spawn.lua',
    'sv/item/drop.lua',
    'sv/item/spawn.lua',
    'sv/network.lua',
    'sv/open_vgui.lua',
    'sv/player_death_or_disconnected.lua',
    'sv/cleanup_rebuild.lua',
}

local function _AddCSLuaFile(file)
    if SERVER then
        AddCSLuaFile(file)
    end
end

local function _include(file, type)
    if type == "sv" then if SERVER then include(file) end end
    if type == "cl" then if CLIENT then include(file) end end
    if type == "sh" then include(file) end
end

local function fWrite(f, t)
    file.Write(f, t)
end

local function init_modules()
    local _, dirs = file.Find("clothing_system/modules/*", "LUA")

    for id, dir in pairs(dirs) do
        local files = file.Find("clothing_system/modules/"..dir.."/*", "LUA")
        local checkModule = {author = "None", name = "None", v = "None", enabled = true}

        if ( file.Exists("clothing_system/modules/"..dir.."/readme.lua", "LUA") ) then
            checkModule = include("clothing_system/modules/"..dir.."/readme.lua")
        end

        local addmodule = true

        if (checkModule != nil && istable(checkModule) && checkModule.enabled != nil && checkModule.enabled == false) then
            addmodule = false
        end

        if (addmodule) then
            if (SERVER) then
                local buildInfo = checkModule
                buildInfo.path =  "clothing_system/modules/"..dir
                MsgN("")
                MsgN("[==========================================================]")
                MsgN("[>>>>>>>>>>>>>>>>>>>>>>>>> Module <<<<<<<<<<<<<<<<<<<<<<<<<]")
                MsgN("[ClothingSystem][ModuleInfo] Init module - "..buildInfo.name)
                MsgN("[ClothingSystem][ModuleInfo] Author - "..buildInfo.author)
                MsgN("[ClothingSystem][ModuleInfo] Version - "..buildInfo.v)
                MsgN("[ClothingSystem][ModuleInfo] Path - "..buildInfo.path)
                MsgN("[__________________________________________________________]")
                MsgN("[>>>>>>>>>>>>>>>>>>>>>>>>> Script <<<<<<<<<<<<<<<<<<<<<<<<<]")
                fWrite("clothing_system/module_list/"..dir..".txt", util.TableToJSON(buildInfo, true))
                buildInfo = nil
            end

            for _, file in pairs(files) do
                local simple_track = "clothing_system/modules/"..dir.."/"..file

                if (string.sub(file, 1, 3) == "sh_") then
                    if SERVER then MsgN("[ClothingSystem][ModuleAdd] "..checkModule.name..": (SH) "..file) end
                    _AddCSLuaFile(simple_track)
                    _include(simple_track, "sh")
                elseif (string.sub(file, 1, 3) == "sv_") then
                    if SERVER then MsgN("[ClothingSystem][ModuleAdd] "..checkModule.name..": (SV) "..file) end
                    _AddCSLuaFile(simple_track)
                    _include(simple_track, "sv")
                elseif (string.sub(file, 1, 3) == "cl_") then
                    if SERVER then MsgN("[ClothingSystem][ModuleAdd] "..checkModule.name..": (CL) "..file) end
                    _AddCSLuaFile(simple_track)
                    _include(simple_track, "cl")
                end
            end
            if SERVER then MsgN("[==========================================================]") end
        end
    end
end

local function init_core()        
    if (file.IsDir("clothing_system/module_list/", "DATA")) then
        local files = file.Find("clothing_system/module_list/*", "DATA")
        
        if (table.Count(files) != 0) then
            for _, v in pairs(files) do
                if SERVER then
                    file.Delete("clothing_system/module_list/"..v)
                end
            end
        end
    end

    for _, sh in pairs(shared) do
        _AddCSLuaFile(prefix.."/"..sh)
        _include(prefix.."/"..sh, "sh")
    end
    for _, sv in pairs(server) do
        _AddCSLuaFile(prefix.."/"..sv)
        _include(prefix.."/"..sv, "sv")
    end
    for _, cl in pairs(client) do
        _AddCSLuaFile(prefix.."/"..cl)
        _include(prefix.."/"..cl, "cl")
    end

    if (ClothingSystem.Config.Modules) then
        init_modules()
    end
end

init_core()