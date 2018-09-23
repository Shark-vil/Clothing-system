local function clothesMenu()
    local MainMenu = include("clothing_system/cl/vgui/vgui_main.lua")

    local PlayerSteamID = LocalPlayer():ClothingSystemGetNormalSteamID()
    local data = LocalPlayer():ClothingSystemGetAllItem(PlayerSteamID)

    local Body = vgui.Create( "DFrame" )
    Body:SetTitle("")
    Body:SetPos( 0, 0 )
    Body:SetSize( ScrW(), ScrH() )
    Body:SetDraggable( false )
    Body:MakePopup()
    Body:ShowCloseButton(false)
    Body.Paint = function(w,h)
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetMaterial( Material("clothing_system/background.png") )
        surface.DrawTexturedRect( 0, 0, ScrW(), ScrH())

        PlayerSteamID = LocalPlayer():ClothingSystemGetNormalSteamID()
        data = LocalPlayer():ClothingSystemGetAllItem(PlayerSteamID)

        if (!data) then
            surface.SetFont( "Trebuchet24" )
            surface.SetTextColor( 255, 255, 255, 255 )
            surface.SetTextPos( ScrW()/2-100, ScrH()/2-50 )
            surface.DrawText( "You do not have clothes" )
        end

        surface.SetFont( "Trebuchet18" )
        surface.SetTextColor( 255, 255, 255, 255 )
        surface.SetTextPos( 20, 5 )
        surface.DrawText( "< Press \"TAB\" to return" )
    end
    Body.OnKeyCodeReleased = function(pnl, key)
        if ( key == 67 || key == 70 ) then
            MainMenu()
            Body:Close()
        end
    end

    local DScrollPanel = vgui.Create( "DScrollPanel", Body )
    DScrollPanel:Dock( FILL )

    if (!data) then return end
    for _, v in ipairs(data) do
        if ( v.SteamID != PlayerSteamID ) then return end

        local userLine = DScrollPanel:Add( "DPanel" )
        userLine:SetSize( ScrW(), 100 )
        userLine.Paint = function(w,h)
            surface.SetDrawColor( 255, 255, 255, 230 ) 
            surface.DrawRect( 0, 0, ScrW(), 2 )
        end
        userLine:Dock( TOP )

        local ClothingModel = vgui.Create( "DModelPanel", userLine )
        ClothingModel:SetPos( 0, 0 )
        ClothingModel:SetSize( 100, 100 )
        ClothingModel:SetFOV(50)
        ClothingModel:SetModel( ClothingSystem:GetItem(v.Class).WireModel )
        ClothingModel:SetLookAt( ClothingModel.Entity:GetPos() )
        if (ClothingSystem:GetItem(v.Class).Skin != nil) then
            ClothingModel.Entity:SetSkin(ClothingSystem:GetItem(v.Class).Skin)
        end
        if (ClothingSystem:GetItem(v.Class).Bodygroup != nil) then
            ClothingModel.Entity:SetBodygroup(ClothingSystem:GetItem(v.Class).Bodygroup[1], ClothingSystem:GetItem(v.Class).Bodygroup[2])
        end
        if (ClothingSystem:GetItem(v.Class).Bodygroups != nil) then
            ClothingModel.Entity:SetBodygroups(ClothingSystem:GetItem(v.Class).Bodygroups)
        end
        mn, mx = ClothingModel.Entity:GetRenderBounds()
        local size = 0
        size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
        size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
        size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
        ClothingModel:SetCamPos( Vector( size, size, size ) )
        ClothingModel:SetLookAt( ( mn + mx ) * 0.5 )
        ClothingModel:Dock( LEFT )

        if ( ScrW() >= 1024 ) then
            local Name = vgui.Create( "DLabel", userLine )
            Name:SetPos( 110, 64/2-5 )
            Name:SetSize( ScrW()/2-220, 64/2+5 )
            Name:SetFont( "Trebuchet24" )
            Name:SetText( "Name: " .. ClothingSystem:GetItem(v.Class).Name )

            local Class = vgui.Create( "DLabel", userLine )
            Class:SetPos( ScrW()/2-100, 64/2-5 )
            Class:SetSize( ScrW()/2-230, 64/2+5 )
            Class:SetFont( "Trebuchet24" )
            Class:SetText( "Class: " .. v.Class )
        else
            local Name = vgui.Create( "DLabel", userLine )
            Name:SetPos( 110, 64/2-5 )
            Name:SetSize( ScrW()/2, 64/2+5 )
            Name:SetFont( "Trebuchet24" )
            Name:SetText( "Name: " .. ClothingSystem:GetItem(v.Class).Name )
        end

        local Click = vgui.Create("DButton", userLine)
        Click:SetSize(ScrW(), 100)
        Click:SetPos(0, 0)
        Click:SetText("")

        local Drop = vgui.Create("DButton", userLine)
        Drop:SetSize(250, 60)
        Drop:SetPos(ScrW()-300, 20)
        Drop:SetText("")
        Drop.Paint = function() 
            surface.SetFont( "Trebuchet24" )
            surface.SetTextColor( 255, 255, 255, 255 )
            surface.SetTextPos( 250/2-20, 15 )
            surface.DrawText( "Drop" )

            if (Drop:IsHovered()) then
                draw.RoundedBox(0, 0, 0, ScrW(), 100, Color(56, 180, 242, 200) )
            else
                draw.RoundedBox(0, 0, 0, ScrW(), 100, Color(56, 180, 242, 50) )
            end
        end
        Drop.DoClick = function()
            LocalPlayer():ClothingSystemDropItem(v.Class)
            userLine:Remove()
        end

        Click.Paint = function() 
            if (Click:IsHovered() || Drop:IsHovered()) then
                draw.RoundedBox(0, 0, 0, ScrW(), 100, Color(0, 0, 0, 50) )
            end
        end
    end
end

return clothesMenu