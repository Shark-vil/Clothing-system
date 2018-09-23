AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" ) 
 
include('shared.lua')
 
function ENT:Initialize()
	local min, max = self:GetModelBounds()
	
	if (self.CustomCollision) then
		self.PhysCollide = CreatePhysCollideBox( min, max )
		self:SetCollisionBounds( min, max )
	end

	if (self.CustomCollision) then
		self:PhysicsInitBox( min, max )
		self:EnableCustomCollisions( true )
	else
		self:PhysicsInit( SOLID_VPHYSICS )  
		self:SetMoveType( MOVETYPE_VPHYSICS ) 
	end

	self:SetSolid( SOLID_VPHYSICS ) 
	self:PhysWake()
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 