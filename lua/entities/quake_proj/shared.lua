AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.MaxLifetime = 5
ENT.Velocity = 1000
ENT.HullSize = 1

function ENT:Initialize()
	-- print( tostring(self) .. " initialized" )

	self.Life = CurTime() + self.MaxLifetime
	self:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
	self:SetModel(self.Model)
end

function ENT:Think()
	if self.Life <= CurTime() then
		if SERVER then
			self:Remove()
		end
	else
		local size = self.HullSize
		local tr = util.TraceHull( {
			start = self:GetPos(),
			endpos = self:GetPos() + ( self:GetAngles():Forward() * self.Velocity * engine.TickInterval() ),
			filter = self,
			mins = Vector( -size, -size, -size ),
			maxs = Vector( size, size, size ),
			mask = MASK_SHOT_HULL,
			filter = self:GetOwner()
		} )

		if SERVER then
			self:SetPos( tr.HitPos )
		end
		if IsValid(tr.Entity) then
			self:P_HitEntity( tr )
		elseif tr.Hit then
			self:P_Hit( tr )
		end

		self:NextThink( CurTime() )
		if CLIENT then self:SetNextClientThink( CurTime() ) end
		return true
	end
end

function ENT:Draw()
	self:DrawModel()
	return true 
end

function ENT:P_HitEntity( tr )
	if SERVER then
		local d = DamageInfo()
		d:SetDamage( 10 )
		d:SetAttacker( self:GetOwner() )
		d:SetDamageType( DMG_BULLET ) 
		d:SetDamagePosition( self:GetPos() )

		tr.Entity:TakeDamageInfo( d )
		self:Remove()
	end
end

function ENT:P_Hit( tr )
	if SERVER then
		self:Remove()
	end
end