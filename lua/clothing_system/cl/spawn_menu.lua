local function IsAdminOnly(Clothing)
	if (Clothing.OnlySteamID != nil && (istable(Clothing.OnlySteamID) || isstring(Clothing.OnlySteamID))) then
		if (istable(Clothing.OnlySteamID)) then
			if (table.Count(Clothing.OnlySteamID) != 0) then
				return true
			end
		elseif (isstring(Clothing.OnlySteamID)) then
			if (string.len(Clothing.OnlySteamID) != 0) then
				return true
			end
		end
	elseif (Clothing.OnlyAdmin != nil && isbool(Clothing.OnlyAdmin)) then
		if (Clothing.OnlyAdmin) then
			return true
		end
	elseif (Clothing.GroupDress != nil && (istable(Clothing.GroupDress) || isstring(Clothing.GroupDress))) then
		if (istable(Clothing.GroupDress)) then
			if (table.Count(Clothing.GroupDress) != 0) then
				return true
			end
		elseif (isstring(Clothing.GroupDress)) then
			if (string.len(Clothing.GroupDress) != 0) then
				return true
			end
		end
	end

	return false
end

ClothingSystem.Tools.Hooks.AddHook("PopulateClothingSystem", function( pnlContent, tree, node )

	local Categorised = {}

	-- Add this list into the tormoil
	local Clothing = list.Get( "clothing_system" )
	if Clothing then	
		for k, v in pairs( Clothing ) do
	
			v.Category = v.Category or "Other"
			Categorised[ v.Category ] = Categorised[ v.Category ] or {}
			v.ClassName = k
			v.PrintName = v.Name
			v.AdminOnly = IsAdminOnly(v)
			table.insert( Categorised[ v.Category ], v )

			-- print("ADD = ".. v.Name .." , "..tostring(IsAdminOnly(v)))
		end
	end
	--
	-- Add a tree node for each category
	--
	for CategoryName, v in SortedPairs( Categorised ) do

		-- Add a node to the tree
		local node = tree:AddNode( CategoryName, "icon16/bricks.png" )
		
			-- When we click on the node - populate it using this function
		node.DoPopulate = function( self )
			
			-- If we've already populated it - forget it.
			if self.PropPanel then return end
			
			-- Create the container panel
			self.PropPanel = vgui.Create( "ContentContainer", pnlContent )
			self.PropPanel:SetVisible( false )
			self.PropPanel:SetTriggerSpawnlistChange( false )
			
			for k, ent in SortedPairsByMemberValue( v, "PrintName" ) do
				local img = ""

				if (file.Exists("materials/entities/clothing_system/"..ent.ClassName..".png", "GAME")) then
					img = "entities/clothing_system/"..ent.ClassName..".png"
				elseif (file.Exists("materials/entities/clothing_system/"..ent.ClassName..".jpg", "GAME")) then
					img = "entities/clothing_system/"..ent.ClassName..".jpg"
				end
				
				spawnmenu.CreateContentIcon( "clothing_system", self.PropPanel, {
					nicename	= ent.PrintName or ent.ClassName,
					spawnname	= ent.ClassName,
					material	= img,
					admin		= ent.AdminOnly
				} )
				
			end
			
		end
		
		-- If we click on the node populate it and switch to it.
		node.DoClick = function( self )
			
			self:DoPopulate()
			pnlContent:SwitchPanel( self.PropPanel )
			
		end

	end
end )

spawnmenu.AddCreationTab( "Clothing", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:CallPopulateHook( "PopulateClothingSystem" )
	return ctrl

end, "icon16/user_suit.png", 50 )

-- local isAddedItems = false
-- ClothingSystem.Tools.Hooks.AddHook( "SpawnMenuOpen", function()
-- 	if (isAddedItems) then return end
	spawnmenu.AddContentType( "clothing_system", function( container, obj )
		-- if !obj.material then return end
		-- if !obj.nicename then return end
		-- if !obj.spawnname then return end
		
		obj.spawnname = obj.spawnname || "_None_"
		obj.nicename = obj.nicename || "_None_"
		obj.material = obj.material || ""

		local icon = vgui.Create( "ContentIcon", container )
		icon:SetContentType( "clothing_system" )
		icon:SetSpawnName( obj.spawnname )
		icon:SetName( obj.nicename )
		icon:SetMaterial( obj.material )
		icon:SetAdminOnly( obj.admin )
		icon:SetColor( Color( 0, 0, 0, 255 ) )
		icon.DoClick = function()
			if (obj.admin) then
				if (!LocalPlayer():IsAdmin() && !LocalPlayer():IsSuperAdmin()) then return end
			end

			local list = list.Get("clothing_system")[obj.spawnname]
			if (list == nil) then 
				return
			elseif (list.WireModel == nil || !util.IsValidModel(list.WireModel)) then
                return
            end
			
			ClothingSystem.Tools.Network.Send("SendToServer", "SpawnEntity", {class = obj.spawnname})
			surface.PlaySound( "ui/buttonclickrelease.wav" )
		end
		icon.OpenMenu = function( icon )

			local menu = DermaMenu()
				menu:AddOption( ClothingSystem.Language.spawnMenuCopy, function() SetClipboardText( obj.spawnname ) end )
			menu:Open()

		end
		
		if IsValid( container ) then
			container:Add( icon )
		end

		return icon
	end )

-- 	isAddedItems = true
-- end )