
SWEP.Base = "quake"
SWEP.Spawnable = true

SWEP.Category = "Quake"
SWEP.PrintName = "Super Shotgun"
SWEP.Slot = 1

SWEP.ViewModel = "models/weapons/w_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.FiringSound = ")weapons/shotgun/shotgun_dbl_fire7.wav"
SWEP.FiringDelay = 0.5
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.DefaultClip = 8

SWEP.ActivePos = Vector( 0.15, 13, -16 )
SWEP.ActiveAng = Angle( 0, 0, 0 )
SWEP.ViewModelFOV = 90

local pellist = {
	[1] =	{ -4,	-2 },
	[2] =	{ -2,	-2 },
	[3] =	{  0,	-2 },
	[4] =	{  2,	-2 },
	[5] =	{  4,	-2 },
	[6] =	{ -4,	 0 },
	[7] =	{ -2,	 0 },
	[8] =	{  0,	 0 },
	[9] =	{  2,	 0 },
	[10] =	{  4,	 0 },
	[11] =	{ -4,	 2 },
	[12] =	{ -2,	 2 },
	[13] =	{  0,	 2 },
	[14] =	{  2,	 2 },
	[15] =	{  4,	 2 },
}

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return false end
	if self:Ammo1() < 2 then return false end
	self:GetOwner():RemoveAmmo( 2, self:GetPrimaryAmmoType() )
	
	self:SetFireDelay( CurTime() + self.FiringDelay )
	self:EmitSound( self.FiringSound, 120, 100, 1, CHAN_STATIC )

	for i=1, #pellist do
		local dir = self:GetOwner():EyeAngles()
		dir:RotateAroundAxis( dir:Up(), pellist[i][1] )
		dir:RotateAroundAxis( dir:Right(), pellist[i][2] )

		local bullet = {
			Attacker = IsValid(self:GetOwner()) and self:GetOwner() or self,
			Damage = 4,
			Force = 0,
			Num = 1,
			Tracer = 1,
			Dir = dir:Forward(),
			Src = self:GetOwner():EyePos(),
			IgnoreEntity = self:GetOwner(),
		}

		self:FireBullets( bullet )
	end
end