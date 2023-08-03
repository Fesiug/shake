
SWEP.Base = "weapon_base"
SWEP.Spawnable = false
SWEP.Category = "Quake"
SWEP.PrintName = "quake weapon base"

SWEP.ViewModel = "models/w_shot_m3super90.mdl"
SWEP.WorldModel = "models/w_shot_m3super90.mdl"

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true

SWEP.DeployTime = 0.25
SWEP.FiringDelay = 0.5

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "DeployTime" )
	self:NetworkVar( "Float", 1, "FireDelay" )
end

SWEP.BobScale = 0
SWEP.SwayScale = 0
function SWEP:CanPrimaryAttack()
	if self:GetDeployTime() > CurTime() then return false end
	if self:GetFireDelay() > CurTime() then return false end
	return true
end
function SWEP:PrimaryAttack()
	return false
end
function SWEP:SecondaryAttack()
	return false
end

function SWEP:Deploy()
	self:SetDeployTime( CurTime() + self.DeployTime )
	return true
end

function SWEP:GetViewModelPosition( pos, ang )
	local p_add = Vector()
	local a_add = Angle()

	local opos = Vector()
	local oang = Angle()

	do -- active pos
		if self.ActivePos then opos:Add(self.ActivePos) end
		if self.ActiveAng then oang:Add(self.ActiveAng) end
	end
	do -- deploy
		local dep = math.TimeFraction( self:GetDeployTime()-self.DeployTime, self:GetDeployTime(), CurTime() )
		dep = 1-math.Clamp(dep, 0, 1)
		
		local apos = Vector( 0, dep*3, dep*3 )
		local aang = Angle( dep*-33, 0, 0 )
		
		opos:Add( apos )
		oang:Add( aang )
	end
	do -- firing
		local dep = math.TimeFraction( self:GetFireDelay()-self.FiringDelay, self:GetFireDelay(), CurTime() )
		dep = 1-math.Clamp(dep, 0, 1)
		
		local apos = Vector( 0, math.sin(dep*math.pi)*-4, 0 )
		local aang = Angle( math.sin(dep*math.pi)*4, 0, 0 )
		
		opos:Add( apos )
		oang:Add( aang )
	end
	do -- bobbing
		local speed = math.Clamp( LocalPlayer():GetVelocity():Length2D() / 500, 0, 1)
		local apos = Vector( speed * math.sin( CurTime() * math.pi * 2 ) * 1, 0, -speed * math.abs( math.sin( (CurTime() + 0.25) * math.pi * 2 ) ) * 1 )
		local aang = Angle( 0, 0, 0 )
		
		opos:Add( apos )
		oang:Add( aang )
	end

	ang:RotateAroundAxis( ang:Right(),		oang.x )
	ang:RotateAroundAxis( ang:Up(),			oang.y )
	ang:RotateAroundAxis( ang:Forward(),		oang.z )

	pos:Add( ang:Right() *				opos.x )
	pos:Add( ang:Forward() *				opos.y )
	pos:Add( ang:Up() *					opos.z )

	return pos, ang
end

function SWEP:PreDrawViewModel()
	
end