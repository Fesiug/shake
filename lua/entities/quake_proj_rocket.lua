AddCSLuaFile()

ENT.Base = "quake_proj"

ENT.MaxLifetime = 7
ENT.Velocity = 1000
ENT.HullSize = 4

ENT.Model = "models/weapons/w_missile_launch.mdl"

local dev = false

local bias = Vector( 0, 0, 64 )
local function Explosion(origin, attacker, inflictor, radius, info)
	local dettest = ents.FindInSphere(origin, radius)
	local dmg_m = info.dmin
	local dmg_a = info.dmax
	local ran_m = info.rmin
	local ran_a = info.rmax

	for i, ent in pairs(dettest) do
		if !IsValid(ent) then continue end
		if !ent:IsPlayer() then continue end
		--if ent:Health() > 0 then
			local entpos = (ent:GetPos() + ent:OBBCenter())
			local asdsa = origin:Distance( entpos ) --math.max( origin:Distance( ent:GetPos() + ent:OBBCenter() ) - vector_origin:Distance( ent:OBBCenter() ) - 8, 0 )

			local dmg = DamageInfo()
			dmg:SetDamage( dmg_a )
			dmg:SetDamageType(DMG_BLAST + DMG_PREVENT_PHYSICS_FORCE)
			dmg:SetDamagePosition(origin)
			if IsValid(attacker) then dmg:SetAttacker(attacker) end
			if IsValid(inflictor) then dmg:SetInflictor(inflictor) end

			local XD = 1
			local min, max = ran_m, ran_a
			local range = asdsa
			if range < min then
				XD = 0
			else
				XD = math.Clamp((range - min) / (max - min), 0, 1)
			end
			dmg:SetDamage( Lerp(XD, dmg_a, dmg_m) )
			if ent:IsPlayer() and (attacker == ent) and !ent:IsOnGround() then
				dmg:ScaleDamage( 0.5 )
			end
			--dmg:SetDamageForce(	(entpos - origin):GetNormalized() * Lerp(1-XD, 0, info.dmgvelocity) )
				--debugoverlay.Line(entpos, origin, 3)
				--print(ent, dmg:GetDamage(), range)

			if dev then
				debugoverlay.Cross( entpos, 16, 1, color_white, true )
				debugoverlay.EntityTextAtPosition( entpos, 0, math.Round(dmg:GetDamage()) .. " damage | " .. math.Round((1-XD)*100) .. "% range", 1, color_white )
			end

			ent:TakeDamageInfo(dmg)
			if !ent:IsPlayer() and IsValid(ent:GetPhysicsObject()) then
				ent:GetPhysicsObject():SetVelocity( (entpos - origin):GetNormalized() * Lerp(1-XD, 0, info.physvelocity or info.velocity) )
			else
				local extra = !ent:IsOnGround() and 2 or 1
				ent:SetVelocity( (entpos - origin + bias):GetNormalized() * info.velocity * extra )
			end
		--end
	end

end

function ENT:P_HitEntity( tr )
	return self:P_Hit( tr )
end

local rocketinfo = { dmin = 24, dmax = 64, rmin = 48, rmax = 75, physvelocity = 100, velocity = 250, dmgvelocity = 55 }
function ENT:P_Hit( tr )
	if SERVER then
		Explosion( self:GetPos(), self:GetOwner(), self, 90, rocketinfo )
		if dev then
			debugoverlay.Sphere( self:GetPos(), 90, 1, Color( 255, 255, 255, 0 ), false )
			debugoverlay.Sphere( self:GetPos(), rocketinfo.rmax, 1, Color( 0, 255, 0, 0 ), false )
			debugoverlay.Sphere( self:GetPos(), rocketinfo.rmin, 1, Color( 255, 0, 0, 0 ), false )
		end

		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetFlags( 0x4+0x80 )
		self:EmitSound("weapons/explode3.wav", 120, 100, 1, CHAN_STATIC)
		util.Effect( "Explosion", effectdata )

		self:Remove()
	end
end