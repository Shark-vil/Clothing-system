local function MainMenu()
    local clothesMenu = include("clothing_system/cl/vgui/vgui_clothes_list.lua")

    local Page = 1
    local left = 25
    local bottom = 50
    local sizeH = 2
    local sizeW = ScrW() - (25*2)
    local division3 = sizeW/3
    local indentation = division3-40
    local BittonListPage = {}
    
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

        for k, v in pairs(BittonListPage) do
            if (v.page == Page) then
                if (!v:IsVisible()) then
                    v:SetVisible(true)
                end
            else
                if (v:IsVisible()) then
                    v:SetVisible(false)
                end
            end
        end
    end
    Body.OnMouseReleased = function(pnl, key)
        local mx, my = gui.MousePos()

        if (mx >= left+30 && mx <= (left+30)+(indentation) && my <= bottom && my >= bottom-30) then
            if (key == 107) then
                Page = 1
            end
        elseif (mx >= left+60+indentation && mx <= (left+60+indentation*2) && my <= bottom && my >= bottom-30) then
            if (key == 107) then
                Page = 2
            end
        elseif (mx >= left+90+indentation*2 && mx <= (left+90+indentation*3) && my <= bottom && my >= bottom-30) then
            if (key == 107) then
                Page = 3
            end
        end
    end
    Body.OnKeyCodeReleased = function(pnl, key)
        if ( key == 67 || key == 70 ) then
            Body:Close()
        end

        if (key == 14 || key == 91) then
            if (Page == 1) then 
                Page = 2 
            elseif (Page == 2) then 
                Page = 3 
            elseif (Page == 3) then 
                Page = 1 
            end 
        end

        if (key == 11 || key == 89) then
            if (Page == 3) then
                 Page = 2 
            elseif (Page == 2) then 
                Page = 1 
            elseif (Page == 1) then 
                Page = 3 
            end 
        end
    end

    local TableMenu = vgui.Create( "DSprite", Body )
    TableMenu:SetPos( 0, 0 )
    TableMenu:SetSize( ScrW(), ScrH() )
    TableMenu.Paint = function(w, h)
        if (Page == 1) then
            surface.SetDrawColor( 255, 255, 255, 230 ) -- Начальный цвет
            surface.DrawRect( left, bottom, 30+sizeH, sizeH ) -- Начало нижней полоски
            surface.DrawRect( left+30+indentation, bottom, sizeW-left-indentation-sizeH, sizeH ) -- Конец нижней полоски

            surface.DrawRect( left, bottom, sizeH, 10 ) -- Нижняя полоска, дизайнерский bottom слева
            surface.DrawRect( left+sizeW, bottom, sizeH, 10 ) -- Нижняя полоска, дизайнерский bottom справа
            
            -- Первый блок
            surface.DrawRect( left+30, bottom-30, indentation, sizeH ) -- Верхняя полоса
            surface.DrawRect( left+30, bottom-30, sizeH, 30 ) -- Левая полоска
            surface.DrawRect( left+30+indentation, bottom-30, sizeH, 30 ) -- Правая полоска

            -- Второй блок
            surface.SetDrawColor( 160, 160, 160, 230 ) -- Начальный цвет
            surface.DrawRect( left+60+indentation, bottom-30, indentation, sizeH ) -- Верхняя полоса
            surface.DrawRect( left+60+indentation, bottom-30, sizeH, 30 ) -- Левая полоска
            surface.DrawRect( left+60+indentation*2, bottom-30, sizeH, 30 ) -- Правая полоска

            -- Третий блок
            surface.DrawRect( left+90+indentation*2, bottom-30, indentation, sizeH )
            surface.DrawRect( left+90+indentation*2, bottom-30, sizeH, 30 ) -- Левая полоска
            surface.DrawRect( left+90+indentation*3, bottom-30, sizeH, 30 ) -- Правая полоска
        end

        if (Page == 2) then
            surface.SetDrawColor( 255, 255, 255, 230 ) -- Начальный цвет
            surface.DrawRect( left, bottom, 60+indentation+sizeH, sizeH ) -- Начало нижней полоски
            surface.DrawRect( left+60+indentation*2, bottom, sizeW-indentation*2-58, sizeH ) -- Конец нижней полоски

            surface.DrawRect( left, bottom, sizeH, 10 ) -- Нижняя полоска, дизайнерский bottom слева
            surface.DrawRect( left+sizeW, bottom, sizeH, 10 ) -- Нижняя полоска, дизайнерский bottom справа
            
            -- Первый блок
            surface.SetDrawColor( 160, 160, 160, 230 ) -- Начальный цвет
            surface.DrawRect( left+30, bottom-30, indentation, sizeH ) -- Верхняя полоса
            surface.DrawRect( left+30, bottom-30, sizeH, 30 ) -- Левая полоска
            surface.DrawRect( left+30+indentation, bottom-30, sizeH, 30 ) -- Правая полоска

            -- Второй блок
            surface.SetDrawColor( 255, 255, 255, 230 ) -- Начальный цвет
            surface.DrawRect( left+60+indentation, bottom-30, indentation, sizeH ) -- Верхняя полоса
            surface.DrawRect( left+60+indentation, bottom-30, sizeH, 30 ) -- Левая полоска
            surface.DrawRect( left+60+indentation*2, bottom-30, sizeH, 30 ) -- Правая полоска

            -- Третий блок
            surface.SetDrawColor( 160, 160, 160, 230 ) -- Начальный цвет
            surface.DrawRect( left+90+indentation*2, bottom-30, indentation, sizeH )
            surface.DrawRect( left+90+indentation*2, bottom-30, sizeH, 30 ) -- Левая полоска
            surface.DrawRect( left+90+indentation*3, bottom-30, sizeH, 30 ) -- Правая полоска
        end

        if (Page == 3) then
            surface.SetDrawColor( 255, 255, 255, 230 ) -- Начальный цвет
            surface.DrawRect( left, bottom, 90+indentation*2+sizeH, sizeH ) -- Начало нижней полоски
            surface.DrawRect( left+90+indentation*3, bottom, sizeW-indentation*3-90, sizeH ) -- Конец нижней полоски

            surface.DrawRect( left, bottom, sizeH, 10 ) -- Нижняя полоска, дизайнерский bottom слева
            surface.DrawRect( left+sizeW, bottom, sizeH, 10 ) -- Нижняя полоска, дизайнерский bottom справа
            
            -- Первый блок
            surface.SetDrawColor( 160, 160, 160, 230 ) -- Начальный цвет
            surface.DrawRect( left+30, bottom-30, indentation, sizeH ) -- Верхняя полоса
            surface.DrawRect( left+30, bottom-30, sizeH, 30 ) -- Левая полоска
            surface.DrawRect( left+30+indentation, bottom-30, sizeH, 30 ) -- Правая полоска

            -- Второй блок
            surface.DrawRect( left+60+indentation, bottom-30, indentation, sizeH ) -- Верхняя полоса
            surface.DrawRect( left+60+indentation, bottom-30, sizeH, 30 ) -- Левая полоска
            surface.DrawRect( left+60+indentation*2, bottom-30, sizeH, 30 ) -- Правая полоска

            -- Третий блок
            surface.SetDrawColor( 255, 255, 255, 230 ) -- Начальный цвет
            surface.DrawRect( left+90+indentation*2, bottom-30, indentation, sizeH )
            surface.DrawRect( left+90+indentation*2, bottom-30, sizeH, 30 ) -- Левая полоска
            surface.DrawRect( left+90+indentation*3, bottom-30, sizeH, 30 ) -- Правая полоска
        end
    end

    local text = "CLOTHES"
    local TextMenu = vgui.Create( "DLabel", TableMenu )
    TextMenu:SetPos( (left+30+indentation/2)-(string.len(text)*5.2), 0 )
    TextMenu:SetSize( 300, bottom+25 )
    TextMenu:SetWrap( true )
    TextMenu:SetFont( "GModNotify" )
    TextMenu:SetText( text )
    TextMenu.Think = function()
        if (Page == 1) then
            TextMenu:SetColor(Color(255, 255, 255, 230))
        else
            TextMenu:SetColor(Color(160, 160, 160, 230))
        end
    end

    local text = "INVENTORY"
    local TextMenu = vgui.Create( "DLabel", TableMenu )
    TextMenu:SetPos( (left+60+indentation*1.53)-(string.len(text)*5.2), 0 )
    TextMenu:SetSize( 300, bottom+25 )
    TextMenu:SetWrap( true )
    TextMenu:SetFont( "GModNotify" )
    TextMenu:SetText( text )
    TextMenu.Think = function()
        if (Page == 2) then
            TextMenu:SetColor(Color(255, 255, 255, 230))
        else
            TextMenu:SetColor(Color(160, 160, 160, 230))
        end
    end

    local text = "CREATE CLOTHES"
    local TextMenu = vgui.Create( "DLabel", TableMenu )
    TextMenu:SetPos( (left+90+indentation*2.53)-(string.len(text)*5.2), 0 )
    TextMenu:SetSize( 300, bottom+25 )
    TextMenu:SetWrap( true )
    TextMenu:SetFont( "GModNotify" )
    TextMenu:SetText( text )
    TextMenu.Think = function()
        if (Page == 3) then
            TextMenu:SetColor(Color(255, 255, 255, 230))
        else
            TextMenu:SetColor(Color(160, 160, 160, 230))
        end
    end

    --[[
        Page 1
    ]]
    local BtnPage = vgui.Create( "DButton", Body ) 
    BtnPage:SetText( "" )			
    BtnPage:SetPos( 25, 100 )				
    BtnPage:SetSize( indentation+30, 60 )
    BtnPage.page = 1
    BtnPage.Paint = function(w, h)
        local x, y = gui.MousePos()
        surface.SetFont( "Trebuchet24" )
        
        if (x >= 25 && x <= (indentation+30+25) && y >= 100 && y <= 100+60) then
            surface.SetTextColor( 255, 255, 255, 255 )
            surface.SetDrawColor( 255, 255, 255, 255 )
        else
            surface.SetTextColor( 255, 255, 255, 200 )
            surface.SetDrawColor( 255, 255, 255, 200 )
        end

        surface.SetMaterial( Material("clothing_system/shield.png") )
        surface.DrawTexturedRect( 0, 0, 50, 50 )

        surface.SetTextPos( 70, 10 )
        surface.DrawText( "Clothing" )

        surface.SetFont( "Trebuchet18" )
        surface.SetTextPos( 72, 30 )
        surface.DrawText( "View a list of clothes" )
    end
    BtnPage.DoClick = function()		
        clothesMenu()
        Body:Close()
    end
    table.insert(BittonListPage, BtnPage)

    --[[
        Page 2
    ]]
    local BtnPage = vgui.Create( "DButton", Body ) 
    BtnPage:SetText( "" )			
    BtnPage:SetPos( 25, 100 )				
    BtnPage:SetSize( indentation+30, 60 )
    BtnPage.page = 2
    BtnPage.Paint = function(w, h)
        local x, y = gui.MousePos()
        surface.SetFont( "Trebuchet24" )
        
        if (x >= 25 && x <= (indentation+30+25) && y >= 100 && y <= 100+60) then
            surface.SetTextColor( 255, 255, 255, 255 )
            surface.SetDrawColor( 255, 255, 255, 255 )
        else
            surface.SetTextColor( 255, 255, 255, 200 )
            surface.SetDrawColor( 255, 255, 255, 200 )
        end

        surface.SetMaterial( Material("clothing_system/dress.png") )
        surface.DrawTexturedRect( 0, 0, 50, 50 )

        surface.SetTextPos( 70, 10 )
        surface.DrawText( "Inventory" )

        surface.SetFont( "Trebuchet18" )
        surface.SetTextPos( 72, 30 )
        surface.DrawText( "Open inventory" )
    end
    BtnPage.DoClick = function()		
        RunConsoleCommand("say", "/storage")
        Body:Close()
    end
    table.insert(BittonListPage, BtnPage)

    --[[
        Page 3
    ]]
    local BtnPage = vgui.Create( "DButton", Body ) 
    BtnPage:SetText( "" )			
    BtnPage:SetPos( 25, 100 )				
    BtnPage:SetSize( indentation+30, 60 )
    BtnPage.page = 3
    BtnPage.Paint = function(w, h)
        local x, y = gui.MousePos()
        surface.SetFont( "Trebuchet24" )
        
        if (x >= 25 && x <= (indentation+30+25) && y >= 100 && y <= 100+60) then
            surface.SetTextColor( 255, 255, 255, 255 )
            surface.SetDrawColor( 255, 255, 255, 255 )
        else
            surface.SetTextColor( 255, 255, 255, 200 )
            surface.SetDrawColor( 255, 255, 255, 200 )
        end

        surface.SetMaterial( Material("clothing_system/gear.png") )
        surface.DrawTexturedRect( 0, 0, 50, 50 )

        surface.SetTextPos( 70, 10 )
        surface.DrawText( "Create your own clothes" )

        surface.SetFont( "Trebuchet18" )
        surface.SetTextPos( 72, 30 )
        surface.DrawText( "The function is currently in development." )
    end
    table.insert(BittonListPage, BtnPage)
end
concommand.Add("open_new_clothing_menu", MainMenu)

return MainMenu