local DATA

function ItemOptions(ply, data, clothClass, itemClass, index, pocket)
    local ply = LocalPlayer()
    local Px, Py = 10, 40
    local Sx, Sy = ScrW()/3-10, 50
    local PxAdd = 0
    local fov = 50
    local mn, mx
    local size = 0
    
    local Body = vgui.Create( "DFrame" )
    Body:SetSize( ScrW()/2.5, ScrH()/2.2 )
    Body:SetTitle( "" )
    Body:SetDraggable( true )
    Body:MakePopup()
    Body:Center()
    Body.Close = function()
        Body:Remove()
        ViewItems(ply, data, clothClass, pocket)
    end
    Body.Paint = function()
        draw.RoundedBox( 8, 0, 0, Body:GetWide(), Body:GetTall(), Color( 0, 0, 0, 150 ) )
        draw.DrawText(ClothingSystem.Language.vguiMenu_2_Title, "Trebuchet18", 10, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        draw.RoundedBox( 8, ScrW()/6+30, Py, 250, 200, Color( 255, 255, 255, 100 ) )

        if (!IsValid(ply) || !ply:Alive()) then
            Body:Remove()
        end
    end

    local ClothingModel = vgui.Create( "DModelPanel", Body )
    ClothingModel:SetPos( ScrW()/6+30, Py )
    ClothingModel:SetSize( 250, 200 )
    ClothingModel:SetFOV(fov)
    ClothingModel:SetModel( data[clothClass][pocket]['items'][index][itemClass]['model'] )
    ClothingModel:SetLookAt( ClothingModel.Entity:GetPos() )
    if (data[clothClass][pocket]['items'][index][itemClass]['skin'] != nil) then
        ClothingModel.Entity:SetSkin(data[clothClass][pocket]['items'][index][itemClass]['skin'])
    end
    if (data[clothClass][pocket]['items'][index][itemClass]['bodygroups'] != nil) then
        for k, v in pairs(data[clothClass][pocket]['items'][index][itemClass]['bodygroups']) do
            ClothingModel.Entity:SetBodygroup(k, v)
        end
    end
    mn, mx = ClothingModel.Entity:GetRenderBounds()
    size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
    size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
    size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
    ClothingModel:SetFOV( fov )
    ClothingModel:SetCamPos( Vector( size, size, size ) )
    ClothingModel:SetLookAt( ( mn + mx ) * 0.5 )
    
    local ClothingModelFov = vgui.Create( "DNumSlider", Body )
    ClothingModelFov:SetPos( ScrW()/6-80, 200+25 )		
    ClothingModelFov:SetSize( ScrW()/6+130, 15 )		
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
    Button:SetText( ClothingSystem.Language.vguiMenu_2_Drop )
    Button:SetPos( Px, Py+PxAdd )
    Button:SetSize( ScrW()/6, 25 )
    Button.DoClick = function ()
        local finalData = {}
        finalData['clothClass'] = clothClass
        finalData['pocket'] = pocket
        finalData['index'] = index
        finalData['usetype'] = "drop"
        finalData['type'] = data[clothClass][pocket]['items'][index][itemClass]['type']

        ClothingSystem.Tools.Network.Send("SendToServer", "ClothingStorageSystem.EntitySpawner", finalData)
        Body:Remove()
    end

    PxAdd=PxAdd+25
    local Button = vgui.Create( "DButton", Body )
    Button:SetText( ClothingSystem.Language.vguiMenu_Storage_ItemUse )
    Button:SetPos( Px, Py+PxAdd )
    Button:SetSize( ScrW()/6, 25 )
    Button.DoClick = function ()
        local finalData = {}
        finalData['clothClass'] = clothClass
        finalData['pocket'] = pocket
        finalData['index'] = index
        finalData['usetype'] = "use"
        finalData['type'] = data[clothClass][pocket]['items'][index][itemClass]['type']

        ClothingSystem.Tools.Network.Send("SendToServer", "ClothingStorageSystem.EntitySpawner", finalData)
        Body:Remove()
    end
end

function ViewItems(ply, data, class, pocket)
    local PlayerSteamID = ply:ClothingSystemGetNormalSteamID()
    
    local Body = vgui.Create( "DFrame" )
    Body:SetSize( ScrW()/3, ScrH()/3 )
    Body:SetTitle( "" )
    Body:SetDraggable( true )
    Body:MakePopup()
    Body:Center()
    Body.Close = function()
        Body:Remove()
        ViewPockets(ply, data, class)
    end
    Body.Paint = function()
        draw.RoundedBox( 8, 0, 0, Body:GetWide(), Body:GetTall(), Color( 0, 0, 0, 150 ) )
        draw.DrawText(ClothingSystem.Language.vguiMenu_1_Title, "Trebuchet18", 10, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        if (!IsValid(ply) || !ply:Alive()) then
            Body:Remove()
        end
    end

    local ClothList = vgui.Create( "DListView", Body )
    ClothList:Dock( FILL )
    ClothList:SetMultiSelect( false )
    ClothList:AddColumn( "№" )
    ClothList:AddColumn( ClothingSystem.Language.vguiMenu_Storage_List_Object )
    ClothList:AddColumn( ClothingSystem.Language.vguiMenu_Storage_List_Weight )
    ClothList:AddColumn( ClothingSystem.Language.vguiMenu_Storage_List_Class )
    ClothList:AddColumn( ClothingSystem.Language.vguiMenu_Storage_List_Type )

    local maxIndex = table.Count(data[class][pocket]['items'])
    if (maxIndex != 0) then
        maxIndex = maxIndex -1 
        for i = 0, maxIndex do
            for class, array in pairs(data[class][pocket]['items'][i]) do
                if (!isbool(ClothingStorageSystem:GetItem(class)) && ClothingStorageSystem:GetItem(class) != false) then
                    local weight = ClothingStorageSystem:GetItem(class).weight
                    ClothList:AddLine(i, array['name'], weight, class, array['type'])
                end
            end
        end
    end

    ClothList.Paint = function()
        draw.RoundedBox( 8, 0, 0, ClothList:GetWide(), ClothList:GetTall(), Color( 255, 255, 255, 130 ) )
    end
    ClothList.OnRowSelected = function( lst, index, line )
        ItemOptions(ply, data, class, line:GetColumnText(4), line:GetColumnText(1), pocket)
        Body:Remove()
    end
end

function ViewPockets(ply, data, class)
    local PlayerSteamID = ply:ClothingSystemGetNormalSteamID()
    
    local Body = vgui.Create( "DFrame" )
    Body:SetSize( ScrW()/3, ScrH()/3 )
    Body:SetTitle( "" )
    Body:SetDraggable( true )
    Body:MakePopup()
    Body:Center()
    Body.Close = function()
        Body:Remove()
        MainMenu(ply, data)
    end
    Body.Paint = function()
        draw.RoundedBox( 8, 0, 0, Body:GetWide(), Body:GetTall(), Color( 0, 0, 0, 150 ) )
        draw.DrawText(ClothingSystem.Language.vguiMenu_1_Title, "Trebuchet18", 10, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        if (!IsValid(ply) || !ply:Alive()) then
            Body:Remove()
        end
    end

    local ClothList = vgui.Create( "DListView", Body )
    ClothList:Dock( FILL )
    ClothList:SetMultiSelect( false )
    ClothList:AddColumn( ClothingSystem.Language.vguiMenu_Storage_List )

    for k, v in pairs(ClothingSystem:GetItem(class).Pockets) do
        ClothList:AddLine(k)
    end

    ClothList.Paint = function()
        draw.RoundedBox( 8, 0, 0, ClothList:GetWide(), ClothList:GetTall(), Color( 255, 255, 255, 130 ) )
    end
    ClothList.OnRowSelected = function( lst, index, line )
        local pocket = line:GetColumnText(1)
        ViewItems(ply, data, class, pocket)
        Body:Remove()
    end
end

function MainMenu(ply, data)
    local PlayerSteamID = ply:ClothingSystemGetNormalSteamID()
    
    local Body = vgui.Create( "DFrame" )
    Body:SetSize( ScrW()/3, ScrH()/3 )
    Body:SetTitle( "" )
    Body:SetDraggable( true )
    Body:MakePopup()
    Body:Center()
    Body.Paint = function()
        draw.RoundedBox( 8, 0, 0, Body:GetWide(), Body:GetTall(), Color( 0, 0, 0, 150 ) )
        draw.DrawText(ClothingSystem.Language.vguiMenu_1_Title, "Trebuchet18", 10, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        if (!IsValid(ply) || !ply:Alive()) then
            Body:Remove()
        end
    end

    local ClothList = vgui.Create( "DListView", Body )
    ClothList:Dock( FILL )
    ClothList:SetMultiSelect( false )
    ClothList:AddColumn( ClothingSystem.Language.vguiMenu_Storage_Clothing )
    ClothList:AddColumn( ClothingSystem.Language.vguiMenu_1_Class )

    if (ply:ClothingSystemGetAllItem(PlayerSteamID)) then
        local pt = ply:ClothingSystemGetAllItem(PlayerSteamID)
        for _, v in ipairs(pt) do
            if ( v.SteamID == PlayerSteamID && data[v.Class] != nil) then
                if (list.Get("clothing_system")[v.Class].Pockets != nil) then
                    ClothList:AddLine( list.Get("clothing_system")[v.Class].Name, v.Class )
                end
            end
        end
    end
    ClothList.Paint = function()
        draw.RoundedBox( 8, 0, 0, ClothList:GetWide(), ClothList:GetTall(), Color( 255, 255, 255, 130 ) )
    end
    ClothList.OnRowSelected = function( lst, index, line )
        local class = line:GetColumnText(2)
        ViewPockets(ply, data, class)
        Body:Remove()
    end
end

ClothingSystem.Tools.Network.AddNetwork("ClothingStorageSystem.OpenStorageMenu", function (len, data, ply)
    DATA = data

    MainMenu(LocalPlayer(), DATA)
end)