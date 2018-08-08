AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "outputs.lua" )

function ENT:Initialize()
end

function ENT:KeyValue( key, value )
end

function ENT:OnRestore()
end

function ENT:AcceptInput( name, activator, ply, data )
	return false
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:Think()
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end
	
	local GetList = list.Get( "clothing_system" )

	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180

	local ent = ents.Create( ClassName )
	ent:SetCreator( ply ) 
	
	ent.DisableUse = false

	ent.Group = "clothing_system"
	ent.Class = "clothing_system"
	ent["saveArray"] = {}

	ent:SetModel( "models/props_c17/SuitCase_Passenger_Physics.mdl" )

	ent:SetPos( SpawnPos )
	ent:SetAngles( SpawnAng )
	ent:Spawn() 
	ent:Activate()

	ent:DropToFloor()

	return ent
end

function ENT:Use( activator, ply )
	-- Выполнять 1 раз после нажатия
	self:SetUseType( SIMPLE_USE )
	-- Переменная для проверок
	local check_item

	-- Определение точки спавна энтити
    local start = ply:EyePos()
    local endpos = start + ply:EyeAngles():Forward() * 100
    local filter = function( ent ) 
        if ( ent:GetClass() == "clothing_prop" ) then 
            return true 
        end 
    end

    local tr = util.TraceLine( {
        start = start,
        endpos = endpos,
        filter = filter,
	} )
	
	if ( tr.Entity != self ) then
		return
	end

	-- Класс
	-- Отправитель
	-- Принимающий (Если nil, принимающий и будет отправителем)
	-- Тип Network
	-- Добавлять объект в data (ВНИМАНИЕ! Если одежда уже имеется, то она добавится дважды!)
	-- Энтити для подгрузки клиентских скриптов
	if (!ClothingSystem:WearParts(self.Class, ply, nil, "broadcast", true, self)) then return end

	-- Удаление энтити
	self:Remove()
    return
end