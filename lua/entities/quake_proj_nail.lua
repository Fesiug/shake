AddCSLuaFile()

ENT.Base = "quake_proj"

ENT.MaxLifetime = 3
ENT.Velocity = 1000
ENT.HullSize = 1

ENT.Model = "models/weapons/flare.mdl"

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