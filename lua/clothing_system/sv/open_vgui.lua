ClothingSystem.Tools.Hooks.AddHook("ClothingSystem.PlayerSay", function(ply, text, team)
    local command = "/equipment"

    if ( command == string.sub(text, 1, string.len(command)) ) then
        ply:ConCommand("open_clothing_menu")
        return ""
	end
end)