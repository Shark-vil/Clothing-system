AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" ) 
 
include('shared.lua')
 
function ENT:Initialize()
	local min, max = self:GetModelBounds()
	self.PhysCollide = CreatePhysCollideBox( min, max )
	self:SetCollisionBounds( min, max )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	self:PhysicsInit( SOLID_VPHYSICS )  
	self:SetMoveType( MOVETYPE_VPHYSICS ) 
	self:SetSolid( SOLID_VPHYSICS ) 

	self:PhysicsInitBox( min, max )
	self:PhysWake()

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 