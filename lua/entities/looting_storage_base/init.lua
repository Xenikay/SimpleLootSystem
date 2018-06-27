AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel( self.lootModel )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetNWBool( "isLoot", true )
	self:SetNWInt( "timeToLoot", self.timeToLoot )
	self:SetNWInt( "nextSearch", 0 )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Loot( ply )
    self:SetNWInt( "nextSearch", CurTime() + self.cooldownTime )
	local chc, minChc, maxChc = 0
	local lootChc = {}
	local lootClass = ""
	for k, v in pairs ( self.lootList ) do
		lootChc[k] = { min = chc+1, max = chc + v }
		chc = chc + v
	end
	local rNumber = math.random( 1, chc )
	for k, v in pairs ( lootChc ) do
		if ( rNumber >= v.min and rNumber <= v.max ) then
			lootClass = k
		end
	end
	if ( lootClass ~= "nothing" ) then
		local loot = ents.Create( lootClass )
		if ( loot ~= NULL ) then
		loot:SetPos( self:GetPos() + ( self:GetAngles():Forward() * self.lootPos.forward ) + ( self:GetAngles():Right() * self.lootPos.right ) + ( self:GetAngles():Up() * self.lootPos.up ) )
		loot:SetAngles( self:GetAngles() )
		loot:Spawn()
		end
	end
end

function ENT:Use( activator, caller )
    return
end
 
function ENT:Think()
end










