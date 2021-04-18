local DATA

local function ViewPockets(ply, data, class, Entity)    
    local Body = vgui.Create( "DFrame" )
    Body:SetSize( ScrW()/3, ScrH()/3 )
    Body:SetTitle( "" )
    Body:SetDraggable( true )
    Body:MakePopup()
    Body:Center()
    Body.Paint = function()
        draw.RoundedBox( 8, 0, 0, Body:GetWide(), Body:GetTall(), Color( 0, 0, 0, 150 ) )
        draw.DrawText(ClothingSystem.Language.vguiMenu_1_Title, "Trebuchet18", 10, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        if (!IsValid(Entity) || !IsValid(ply) || !ply:Alive()) then
            Body:Close()
            chat.AddText(ClothingSystem.Language.vguiMenu_Storage_EntityDestroyed.."!")
        end
    end

    local ClothList = vgui.Create( "DListView", Body )
    ClothList:Dock( FILL )
    ClothList:SetMultiSelect( false )
    ClothList:AddColumn(ClothingSystem.Language.vguiMenu_Storage_PocketsName)
    for name, weight in pairs(ClothingSystem:GetItem(class).Pockets) do
        ClothList:AddLine( name )
    end

    ClothList.Paint = function()
        draw.RoundedBox( 8, 0, 0, ClothList:GetWide(), ClothList:GetTall(), Color( 255, 255, 255, 130 ) )
    end
    ClothList.OnRowSelected = function( lst, index, line )
        local name = line:GetColumnText(1)
        local item = ClothingStorageSystem:GetItem(Entity:GetClass())
        if not item then
            item = ClothingStorageSystem:Add({
                ['class'] = Entity:GetClass(),
                ['weight'] = 1,
            })

            if not item then
                Body:Close()
                return
            end
        end

        local entitySaveClientside = {}
        if (item && item.clientSave != nil) then
            entitySaveClientside = item.clientSave(ply, Entity)
        end
        data['entitySaveClientside'] = entitySaveClientside
        data['pocket'] = name
        data['class'] = class
        data['entityName'] = Entity.PrintName

        if (Entity:IsWeapon()) then
            data['entityName'] = Entity:GetPrintName()
        else
            data['entityName'] = Entity.PrintName
        end

        ClothingSystem.Tools.Network.Send("SendToServer", "ClothingStorageSystem.SendToServerAddFile", data)
        Body:Close()
    end
end

local function MainMenu(ply, data)
    local PlayerSteamID = ply:ClothingSystemGetNormalSteamID()
    local Entity = ents.GetByIndex(data['entityID'])
    
    local Body = vgui.Create( "DFrame" )
    Body:SetSize( ScrW()/3, ScrH()/3 )
    Body:SetTitle( "" )
    Body:SetDraggable( true )
    Body:MakePopup()
    Body:Center()
    Body.Paint = function()
        draw.RoundedBox( 8, 0, 0, Body:GetWide(), Body:GetTall(), Color( 0, 0, 0, 150 ) )
        draw.DrawText(ClothingSystem.Language.vguiMenu_1_Title, "Trebuchet18", 10, 5, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        if (!IsValid(Entity) || !IsValid(ply) || !ply:Alive()) then
            Body:Close()
            chat.AddText(ClothingSystem.Language.vguiMenu_Storage_EntityDestroyed.."!")
        end
    end

    local ClothList = vgui.Create( "DListView", Body )
    ClothList:Dock( FILL )
    ClothList:SetMultiSelect( false )
    ClothList:AddColumn( ClothingSystem.Language.vguiMenu_1_Name )
    ClothList:AddColumn( ClothingSystem.Language.vguiMenu_1_Class )

    if (ply:ClothingSystemGetAllItem(PlayerSteamID)) then
        local pt = ply:ClothingSystemGetAllItem(PlayerSteamID)
        for _, v in ipairs(pt) do
            if ( v.SteamID == PlayerSteamID ) then
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
        ViewPockets(ply, data, class, Entity)
        Body:Close()
    end
end

ClothingSystem.Tools.Network.AddNetwork("ClothingStorageSystem.OpenAddItemMenu", function (len, data, ply)
    DATA = data

    MainMenu(LocalPlayer(), DATA)
end)