hook.Add( "PopulateClothingSystem", "AddEntityContent", function( pnlContent, tree, node )

	local Categorised = {}

	-- Add this list into the tormoil
	local Clothing = list.Get( "clothing_system" )
	if Clothing then
		for k, v in pairs( Clothing ) do

			v.Category = v.Category or "Other"
			Categorised[ v.Category ] = Categorised[ v.Category ] or {}
			v.ClassName = k
			v.PrintName = v.Name
			v.AdminOnly = v.AdminOnly || false
			table.insert( Categorised[ v.Category ], v )

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
				
				spawnmenu.CreateContentIcon( "clothing_system", self.PropPanel, {
					nicename	= ent.PrintName or ent.ClassName,
					spawnname	= ent.ClassName,
					material	= "entities/clothing_system/"..ent.ClassName..".png",
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


spawnmenu.AddContentType( "clothing_system", function( container, obj )
	if !obj.material then return end
	if !obj.nicename then return end
	if !obj.spawnname then return end

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
		net.Start("ClothingSystem.SpawnEntity")
			net.WriteString( obj.spawnname )
		net.SendToServer()
		-- hook.Call("ClothingSystemSpawnEntity", nil, base.Class, ply)

		surface.PlaySound( "ui/buttonclickrelease.wav" )
	end
	icon.OpenMenu = function( icon )

		local menu = DermaMenu()
			menu:AddOption( "Copy to Clipboard", function() SetClipboardText( obj.spawnname ) end )
		menu:Open()

	end
	
	if IsValid( container ) then
		container:Add( icon )
	end

	return icon
end )

net.Receive("ClothingSystem.PlayerSpawnEntity.DrawTextToClient", function()
	local item_index = net.ReadFloat()
	local item_class = net.ReadString()

	timer.Simple(0.2, function()
		for _, item in ipairs(ents.GetAll()) do
			if ( item:EntIndex() == item_index ) then
				item.Class = item_class
			end
		end
	end)
end)