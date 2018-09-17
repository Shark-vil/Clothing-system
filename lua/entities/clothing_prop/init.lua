AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" ) 
 
include('shared.lua')
 
function ENT:Initialize()
	local min, max = self:GetModelBounds()
	self:PhysicsInit( SOLID_VPHYSICS )  
	self:SetMoveType( MOVETYPE_VPHYSICS ) 
	self:SetSolid( SOLID_VPHYSICS ) 

	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	
	if (self.CustomCollision) then
		self.PhysCollide = CreatePhysCollideBox( min, max )
		self:SetCollisionBounds( min, max )
	end

	if (self.CustomCollision) then
		self:PhysicsInitBox( min, max )
	end

	self:PhysWake()

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 