-- Меню действий

local function VGUI_Set(class)
    local ply = LocalPlayer()
    local Px, Py = 10, 40
    local Sx, Sy = ScrW()/3-10, 50
    local PxAdd = 0
    local fov = 50
    local mn, mx
    local size = 0
    
    local Body = vgui.Create( "DFrame" )
    Body:SetSize( ScrW()/2, ScrH()/2 )
    Body:SetTitle( "" )
    Body:SetDraggable( true )
    Body:MakePopup()
    Body:Center()
    Body.Close = function()
        Body:Remove()
        RunConsoleCommand("open_clothing_menu")
    end
    Body.Paint = function()
        draw.RoundedBox( 8, 0, 0, Body:GetWide(), Body:GetTall(), Color( 0, 0, 0, 150 ) )
        draw.DrawText("Actions", "Trebuchet18", 10, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        
        draw.RoundedBox( 8, ScrW()/4+30, Py, 250, 200, Color( 255, 255, 255, 100 ) )
    end

    
    local ClothingModel = vgui.Create( "DModelPanel", Body )
    ClothingModel:SetPos( ScrW()/4+30, Py )
    ClothingModel:SetSize( 250, 200 )
    ClothingModel:SetFOV(fov)
    ClothingModel:SetModel( ClothingSystem:GetItem(class).WireModel )
    ClothingModel:SetLookAt( ClothingModel.Entity:GetPos() )
    if (ClothingSystem:GetItem(class).Skin != nil) then
        ClothingModel.Entity:SetSkin(ClothingSystem:GetItem(class).Skin)
    end
    if (ClothingSystem:GetItem(class).Bodygroup != nil) then
        ClothingModel.Entity:SetBodygroup(ClothingSystem:GetItem(class).Bodygroup[1], ClothingSystem:GetItem(class).Bodygroup[2])
    end
    mn, mx = ClothingModel.Entity:GetRenderBounds()
    size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
    size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
    size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
    ClothingModel:SetFOV( fov )
    ClothingModel:SetCamPos( Vector( size, size, size ) )
    ClothingModel:SetLookAt( ( mn + mx ) * 0.5 )
    
    local ClothingModelFov = vgui.Create( "DNumSlider", Body )
    ClothingModelFov:SetPos( ScrW()/4-100, 200+25 )		
    ClothingModelFov:SetSize( ScrW()/4+30, 15 )		
    ClothingModelFov:SetMin( 0 )			
    ClothingModelFov:SetMax( 100 )		
    ClothingModelFov:SetDecimals( 0 )		
    ClothingModelFov:SetValue(fov)
    ClothingModelFov.Think = function()
        if ( ClothingModelFov:IsEditing() ) then
            size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
            size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
            size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
            
            fov = ClothingModelFov:GetValue()

            ClothingModel:SetFOV( fov )
            ClothingModel:SetCamPos( Vector( size, size, size ) )
            ClothingModel:SetLookAt( ( mn + mx ) * 0.5 )
        end
    end
    ClothingModelFov.Paint = function()
        draw.RoundedBox( 8, ScrW()/10, 0, ClothingModelFov:GetWide(), ClothingModelFov:GetTall(), Color( 0, 0, 230, 160 ) )
    end

    local Button = vgui.Create( "DButton", Body )
    Button:SetText( "Drop" )
    Button:SetPos( Px, Py+PxAdd )
    Button:SetSize( ScrW()/4, 50 )
    Button.DoClick = function ()
        ply:ClothingSystemDropItem(class)
        Body:Remove()
        timer.Simple(0 , function()
            timer.Simple(0 , function()
                timer.Simple(0 , function()
                    RunConsoleCommand("open_clothing_menu")
                end)
            end)
        end)
    end

    PxAdd=PxAdd+50
    local Button = vgui.Create( "DButton", Body )
    Button:SetText( "View inventory" )
    Button:SetPos( Px, Py+PxAdd )
    Button:SetSize( ScrW()/4, 50 )
    Button.DoClick = function ()
        RunConsoleCommand("say", "/storage")
        Body:Remove()
    end

    PxAdd=PxAdd+50
    local Button = vgui.Create( "DButton", Body )
    Button:SetText( "Wear of clothes" )
    Button:SetPos( Px, Py+PxAdd )
    Button:SetSize( ScrW()/4, 50 )
    Button.DoClick = function ()
        ply:AddText("Function in development.")
    end
end

local function VGUI()
    local ItemList = net.ReadTable()
    local ply = LocalPlayer()
    local PlayerSteamID = ply:ClothingSystemGetNormalSteamID()
    
    local Body = vgui.Create( "DFrame" )
    Body:SetSize( ScrW()/3, ScrH()/3 )
    Body:SetTitle( "" )
    Body:SetDraggable( true )
    Body:MakePopup()
    Body:Center()
    Body.Paint = function()
        draw.RoundedBox( 8, 0, 0, Body:GetWide(), Body:GetTall(), Color( 0, 0, 0, 150 ) )
        draw.DrawText("Your clothes", "Trebuchet18", 10, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
    end

    local ClothList = vgui.Create( "DListView", Body )
    ClothList:Dock( FILL )
    ClothList:SetMultiSelect( false )
    ClothList:AddColumn( "Class" )
    ClothList:AddColumn( "Name" )

    if (ply:ClothingSystemGetAllItem(PlayerSteamID)) then
        local pt = ply:ClothingSystemGetAllItem(PlayerSteamID)
        for _, v in ipairs(pt) do
            if ( v.SteamID == PlayerSteamID ) then
                ClothList:AddLine( v.Class, ClothingSystem:GetItem(v.Class).Name )
            end
        end
    end
    ClothList.Paint = function()
        draw.RoundedBox( 8, 0, 0, ClothList:GetWide(), ClothList:GetTall(), Color( 255, 255, 255, 130 ) )
    end
    ClothList.OnRowSelected = function( lst, index, pnl )
        Body:Close()

        -- Меню действий с отправкой в него индекса выбранного объекта
        VGUI_Set(pnl:GetColumnText(1))
    end
end
net.Receive("ClothingSystem.VGUI", VGUI)

concommand.Add("clothing_menu", function()
    RunConsoleCommand("open_clothing_menu")
end)