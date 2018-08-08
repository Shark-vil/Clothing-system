-- Открыть меню управления одеждой
local function OpenVgui(ply)
    local list = ClothingSystem:PlayerGetItems(ply)

    net.Start("ClothingSystem.VGUI")
        net.WriteTable(list)
    net.Send(ply)
end
concommand.Add("open_clothing_menu", OpenVgui)

hook.Add( "PlayerSay", "ClothingSystem.OpenVgui", function( ply, text, team )
    local command = "/equipment"

    if ( command == string.sub(text, 1, string.len(command)) ) then
        local list = ClothingSystem:PlayerGetItems(ply)

        net.Start("ClothingSystem.VGUI")
            net.WriteTable(list)
        net.Send(ply)
        return ""
	end
end)