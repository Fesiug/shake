
SWEP.Base = "quake"
SWEP.Spawnable = true

SWEP.Category = "Quake"
SWEP.PrintName = "Shotgun"
SWEP.Slot = 1

SWEP.ViewModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"

SWEP.FiringSound = ")weapons/shotgun/shotgun_fire6.wav"
SWEP.FiringDelay = 0.5
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.DefaultClip = 4

SWEP.ActivePos = Vector( 0, 13, -16 )
SWEP.ActiveAng = Angle( 0, 0, 0 )
SWEP.ViewModelFOV = 90

local pellist = {
	[1] = { -1,	-1 },
	[2] = {  0,	-1 },
	[3] = {  1,	-1 },
	[4] = { -1,	 0 },
	[5] = {  0,	 0 },
	[6] = {  1,	 0 },
	[7] = { -1,	 1 },
	[8] = {  0,	 1 },
	[9] = {  1,	 1 },
}

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return false end
	if self:Ammo1() < 1 then return false end
	self:GetOwner():RemoveAmmo( 1, self:GetPrimaryAmmoType() )
	
	self:SetFireDelay( CurTime() + self.FiringDelay )
	self:EmitSound( self.FiringSound, 120, 100, 1, CHAN_STATIC )

	for i=1, #pellist do
		local dir = self:GetOwner():EyeAngles()
		dir:RotateAroundAxis( dir:Up(), pellist[i][1] )
		dir:RotateAroundAxis( dir:Right(), pellist[i][2] )

		local bullet = {
			Attacker = IsValid(self:GetOwner()) and self:GetOwner() or self,
			Damage = 4,
			Force = 1,
			Num = 1,
			Tracer = 1,
			Dir = dir:Forward(),
			Src = self:GetOwner():EyePos(),
			IgnoreEntity = self:GetOwner(),
		}

		self:FireBullets( bullet )
	end
end