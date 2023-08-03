
SWEP.Base = "quake"
SWEP.Spawnable = true

SWEP.Category = "Quake"
SWEP.PrintName = "Rocket Launcher"
SWEP.Slot = 3

SWEP.ViewModel = "models/weapons/w_rocket_launcher.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.FiringSound = ")weapons/rpg/rocketfire1.wav"
SWEP.FiringDelay = 1
SWEP.Primary.Ammo = "RPG_Round"
SWEP.Primary.DefaultClip = 1

SWEP.ActivePos = Vector( -1, -12, -16 )
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
			local proj = ents.Create("quake_proj_rocket")
			proj:SetPos( self:GetOwner():EyePos() + (self:GetOwner():EyeAngles():Up() * -4) + (self:GetOwner():EyeAngles():Forward() * -4) )
			proj:SetAngles( dir )
			proj:SetOwner( self:GetOwner() )
			proj:Spawn()
		end
	end
end