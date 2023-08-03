
SWEP.Base = "quake"
SWEP.Spawnable = true

SWEP.Category = "Quake"
SWEP.PrintName = "Nail Gun"
SWEP.Slot = 2

SWEP.ViewModel = "models/weapons/w_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"

SWEP.FiringSound = ")weapons/smg1/smg1_fire1.wav"
SWEP.FiringDelay = 0.15
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.DefaultClip = 10

SWEP.ActivePos = Vector( 0, 12, -16 )
SWEP.ActiveAng = Angle( 0, 0, 0 )
SWEP.ViewModelFOV = 90

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return false end
	if self:Ammo1() < 1 then return false end
	self:GetOwner():RemoveAmmo( 1, self:GetPrimaryAmmoType() )
	
	self:SetFireDelay( CurTime() + self.FiringDelay )
	self:EmitSound( self.FiringSound, 120, 100, 1, CHAN_STATIC )

	for i=1, 1 do
		local dir = self:GetOwner():EyeAngles()

		if SERVER then
			local proj = ents.Create("quake_proj_nail")
			proj:SetPos( self:GetOwner():EyePos() + (self:GetOwner():EyeAngles():Up() * -4) + (self:GetOwner():EyeAngles():Forward() * -4) )
			proj:SetAngles( dir )
			proj:SetOwner( self:GetOwner() )
			proj:Spawn()
		end
	end
end