
SWEP.Base = "quake"
SWEP.Spawnable = true

SWEP.Category = "Quake"
SWEP.PrintName = "Super Nail Gun"
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/w_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/w_mach_m249para.mdl"

SWEP.FiringSound = ")weapons/m249/m249-1.wav"
SWEP.FiringDelay = 0.075
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.DefaultClip = 20

SWEP.ActivePos = Vector( 0, 10, -16 )
SWEP.ActiveAng = Angle( 0, 0, 0 )
SWEP.ViewModelFOV = 90

function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "DeployTime" )
	self:NetworkVar( "Float", 1, "FireDelay" )

	self:NetworkVar( "Bool", 0, "AltFire" )
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return false end
	if self:Ammo1() < 1 then return false end
	self:GetOwner():RemoveAmmo( 1, self:GetPrimaryAmmoType() )
	
	self:SetFireDelay( CurTime() + self.FiringDelay )
	self:EmitSound( self.FiringSound, 120, 100, 1, CHAN_STATIC )

	for i=1, 1 do
		local dir = self:GetOwner():EyeAngles()

		if SERVER then
			local pos = self:GetOwner():EyePos() + (self:GetOwner():EyeAngles():Up() * -4) + (self:GetOwner():EyeAngles():Forward() * -4) + (self:GetOwner():EyeAngles():Right() * (self:GetAltFire() and -2 or 2))
			self:SetAltFire( !self:GetAltFire() )
			-- local tr = util.TraceLine( {
			-- 	startpos = pos,
			-- 	endpos = self:GetOwner():EyePos() + (self:GetOwner():EyeAngles():Forward() * 200),
			-- 	mask = MASK_SHOT_HULL,
			-- 	filter = self:GetOwner(),
			-- 	ignoreworld = false
			-- } )
			-- print(tr.Entity)
			-- debugoverlay.Cross( tr.HitPos, 16, 3, color_white, true)
			-- debugoverlay.Axis( self:GetOwner():EyePos(), tr.Normal:Angle(), 16, 3, true )

			local proj = ents.Create("quake_proj_nail")
			proj:SetPos( pos )
			proj:SetAngles( dir )
			proj:SetOwner( self:GetOwner() )
			proj:Spawn()
		end
	end
end