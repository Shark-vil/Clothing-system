local timer_name = "ClothingSysten.Addon.Version.Check"

timer.Create(timer_name, 1, 0, function()
    local ply = LocalPlayer()
    if (!IsValid(ply)) then return end

    local version = ClothingSystem.AddonVersion
    local version_list = {}
    local path = "clothing_system/v.dat"

    if ( file.Exists(path, "DATA") ) then
        version_list = util.JSONToTable( file.Read(path, "DATA") ) 
    else
        file.Write(path, "{}")
    end

    if ( !table.HasValue(version_list, version) ) then
        local this_w = ScrW() - 100
        local this_h = ScrH() - 100

        local Body = vgui.Create( "DFrame" )
        Body:SetSize( this_w, this_h )
        Body:SetTitle( "List of updates [build - v"..version.."]" )
        Body:SetVisible( true )
        Body:SetDraggable( true )
        Body:ShowCloseButton( true )
        Body:Center()
        Body:MakePopup()

        local CloseButton = vgui.Create("DButton", Body)
        CloseButton:SetSize( 150, 50 )
        CloseButton:SetPos( (this_w/2 - 10 - 50), (this_h - 65) )
        CloseButton:SetText( "Close / Закрыть" )
        CloseButton.DoClick = function()
            Body:Close()
        end

        local html = vgui.Create( "DHTML", Body )
        html:SetHTML(ClothingSystem.VersionDescription)
        html:SetMultiline(true)
        html:SetPos( 5, 25 )
        html:SetSize( this_w - 10, this_h - 100 )

        table.insert(version_list, version)
        timer.Simple(0, function () 
            file.Write( path, util.TableToJSON(version_list) ) 
        end)
    end

    timer.Remove(timer_name)
end)