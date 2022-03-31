

// Variables that are used on both client and server

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/c_smg1.mdl"
SWEP.WorldModel		= "models/weapons/w_smg1.mdl"
SWEP.AnimPrefix		= "smg2"
SWEP.HoldType		= "smg"
SWEP.UseHands			= true

SWEP.Spawnable			= true
SWEP.Category			= "Half-Life 2"

SWEP.EnableIdle			= false

// Note: This is how it should have worked. The base weapon would set the category
// then all of the children would have inherited that.
// But a lot of SWEPS have based themselves on this base (probably not on purpose)
// So the category name is now defined in all of the child SWEPS.

SWEP.m_bFiresUnderwater	= false;
SWEP.m_fFireDuration	= 0.0;
SWEP.m_nShotsFired		= 0;

SWEP.AdminSpawnable		= false

SWEP.Primary.Reload			= Sound( "Weapon_SMG1.Reload" )
SWEP.Primary.ReloadNPC		= Sound( "Weapon_SMG1.NPC_Reload" )
SWEP.Primary.Empty			= Sound( "Weapon_SMG1.Empty" )
SWEP.Primary.Sound			= Sound( "Weapon_SMG1.Single" )
SWEP.Primary.SoundNPC		= Sound( "Weapon_SMG1.NPC_Single" )
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 1
SWEP.Primary.NumAmmo		= SWEP.Primary.NumShots
SWEP.Primary.Cone			= VECTOR_CONE_5DEGREES
SWEP.Primary.ClipSize		= 45				// Size of a clip
SWEP.Primary.Delay			= 0.07
SWEP.Primary.DefaultClip	= 45				// Default number of bullets in a clip
SWEP.Primary.Automatic		= true				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.Tracer			= 2
SWEP.Primary.TracerName		= "Tracer"

SWEP.Secondary.Empty		= SWEP.Primary.Empty
SWEP.Secondary.Sound		= Sound( "Weapon_SMG1.Double" )
SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.Delay		= 0.5
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= true				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "SMG1_Grenade"
SWEP.Secondary.AmmoType		= "sent_grenade_ar2"


/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()

	if ( SERVER ) then
		self:SetNPCMinBurst( 2 )
		self:SetNPCMaxBurst( 5 )
		self:SetNPCFireRate( self.Primary.Delay )
	end

	self:SetWeaponHoldType( self.HoldType )
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	// Only the player fires this way so we can cast
	local pPlayer = self.Owner;
	if (!pPlayer) then
		return;
	end

	// Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end

	if ( self.Weapon:Clip1() <= 0 && self.Primary.ClipSize > -1 ) then
		if ( self:Ammo1() > 0 ) then
			self.Weapon:EmitSound( self.Primary.Empty );
			self:Reload();
		else
			self.Weapon:EmitSound( self.Primary.Empty );
			self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay );
			self:IdleStuff()
		end

		return;
	end

	if ( self.m_bIsUnderwater && !self.m_bFiresUnderwater ) then
		self.Weapon:EmitSound( self.Primary.Empty );
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 );

		return;
	end

	// Abort here to handle burst and auto fire modes
	if ( (self.Primary.ClipSize > -1 && self.Weapon:Clip1() == 0) || ( self.Primary.ClipSize <= -1 && !pPlayer:GetAmmoCount(self.Primary.Ammo) ) ) then
		return;
	end

	pPlayer:MuzzleFlash();

	// To make the firing framerate independent, we may have to fire more than one bullet here on low-framerate systems,
	// especially if the weapon we're firing has a really fast rate of fire.
	local iBulletsToFire = 0;
	local fireRate = self.Primary.Delay;

	// MUST call sound before removing a round from the clip of a CHLMachineGun
	if ( !pPlayer:IsNPC() ) then
		self.Weapon:EmitSound(self.Primary.Sound);
	else
		self.Weapon:EmitSound(self.Primary.SoundNPC);
	end
	self.Weapon:SetNextPrimaryFire( CurTime() + fireRate );
	iBulletsToFire = iBulletsToFire + self.Primary.NumShots;

	// Make sure we don't fire more than the amount in the clip, if this weapon uses clips
	if ( self.Primary.ClipSize > -1 ) then
		if ( iBulletsToFire > self.Weapon:Clip1() ) then
			iBulletsToFire = self.Weapon:Clip1();
		end
		self:TakePrimaryAmmo( self.Primary.NumAmmo );
	end

	self:ShootBullet( self.Primary.Damage, iBulletsToFire, self.Primary.Cone );
	self.m_nShotsFired = self.m_nShotsFired + 1

	//Factor in the view kick
	if ( !pPlayer:IsNPC() ) then
		self:AddViewKick();
	end

	if ( self.m_nShotsFired < 2 ) then
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    elseif ( self.m_nShotsFired < 3 ) then
	self.Weapon:SendWeaponAnim( ACT_VM_RECOIL1 )
	elseif ( self.m_nShotsFired < 4 ) then
    self.Weapon:SendWeaponAnim( ACT_VM_RECOIL1 )
	else
    self.Weapon:SendWeaponAnim( ACT_VM_RECOIL3 )
	end

	pPlayer:SetAnimation( PLAYER_ATTACK1 );
	
	self:IdleStuff()

end


//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
function SWEP:DoMachineGunKick( pPlayer, dampEasy, maxVerticleKickAngle, fireDurationTime, slideLimitTime )

	local	KICK_MIN_X			= 0.2	//Degrees
	local	KICK_MIN_Y			= 0.2	//Degrees
	local	KICK_MIN_Z			= 0.1	//Degrees

	local vecScratch = Angle( 0, 0, 0 );

	//Find how far into our accuracy degradation we are
	local duration;
	if ( fireDurationTime > slideLimitTime ) then
		duration	= slideLimitTime
	else
		duration	= fireDurationTime;
	end
	local kickPerc = duration / slideLimitTime;

	// do this to get a hard discontinuity, clear out anything under 10 degrees punch
	pPlayer:ViewPunchReset( 10 );

	//Apply this to the view angles as well
	vecScratch.pitch = -( KICK_MIN_X + ( maxVerticleKickAngle * kickPerc ) );
	vecScratch.yaw = -( KICK_MIN_Y + ( maxVerticleKickAngle * kickPerc ) ) / 3;
	vecScratch.roll = KICK_MIN_Z + ( maxVerticleKickAngle * kickPerc ) / 8;

	//Wibble left and right
	if ( math.random( -1, 1 ) >= 0 ) then
		vecScratch.yaw = vecScratch.yaw * -1;
	end

	//Wobble up and down
	if ( math.random( -1, 1 ) >= 0 ) then
		vecScratch.roll = vecScratch.roll * -1;
	end

	//Clip this to our desired min/max
	// vecScratch = UTIL_ClipPunchAngleOffset( vecScratch, vec3_angle, Angle( 24.0, 3.0, 1.0 ) );

	//Add it to the view punch
	// NOTE: 0.5 is just tuned to match the old effect before the punch became simulated
	pPlayer:ViewPunch( vecScratch * 0.5 );

end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	// Only the player fires this way so we can cast
	local pPlayer = self.Owner;

	if ( pPlayer == NULL ) then
		return;
	end

	// Make sure we can shoot first
	if ( !self:CanSecondaryAttack() ) then return end

	//Must have ammo
	if ( ( pPlayer:GetAmmoCount( self.Secondary.Ammo ) <= 0 ) || ( ( pPlayer:WaterLevel() == 3 ) && !self.m_bFiresUnderwater ) ) then
		
		self.Weapon:EmitSound( self.Secondary.Empty );
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay );
		return;
	end

	// MUST call sound before removing a round from the clip of a CMachineGun
	self.Weapon:EmitSound( self.Secondary.Sound );

	local vecSrc = pPlayer:GetShootPos();
	local Forward = self.Owner:EyeAngles():Forward()
	local Right = self.Owner:EyeAngles():Right()
	local Up = self.Owner:EyeAngles():Up()
	
	local	vecThrow;
	// Don't autoaim on grenade tosses
	vecThrow = pPlayer:GetAimVector()* 1000.0;

if ( !CLIENT ) then
	//Create the grenade
	local pGrenade = ents.Create( self.Secondary.AmmoType );
	pGrenade:SetPos( self.Owner:GetShootPos() + Forward * 0 + Right * 0 + Up * 0 );
	pGrenade:SetOwner( pPlayer );

	pGrenade:Spawn()
	pGrenade:GetPhysicsObject():SetVelocity( Forward* 1220.0 );
	pGrenade:GetPhysicsObject():AddAngleVelocity( Vector( -400, 400, 0 ) );
	pGrenade:SetOwner( self.Owner );
end

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK );

	// player "shoot" animation
	pPlayer:SetAnimation( PLAYER_ATTACK1 );


	// Decrease ammo
	pPlayer:RemoveAmmo( 1, self.Secondary.Ammo );

	// Can shoot again immediately
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 );

	// Can blow up after a short delay (so have time to release mouse button)
	self.Weapon:SetNextSecondaryFire( CurTime() + 1.0 );
	
	self:IdleStuff()

end

/*---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
---------------------------------------------------------*/
function SWEP:Reload()

	local fRet;
	local fCacheTime = self.Secondary.Delay;

	self.m_fFireDuration = 0.0;

	fRet = self.Weapon:DefaultReload( ACT_VM_RELOAD );
	if ( fRet ) then
		// Undo whatever the reload process has done to our secondary
		// attack timer. We allow you to interrupt reloading to fire
		// a grenade.
		self.Weapon:SetNextSecondaryFire( CurTime() + fCacheTime );

		if ( !self.Owner:IsNPC() ) then
			self.Weapon:EmitSound( self.Primary.Reload );
		else
			self.Weapon:EmitSound( self.Primary.ReloadNPC );
		end

		self:IdleStuff()
		
		self.m_nShotsFired = 0
		
	end

	return fRet;

end


//-----------------------------------------------------------------------------
// Purpose:
//-----------------------------------------------------------------------------
function SWEP:AddViewKick()

	local	EASY_DAMPEN			= 0.5
	local	MAX_VERTICAL_KICK	= 1.0	//Degrees
	local	SLIDE_LIMIT			= 2.0	//Seconds

	//Get the view kick
	local pPlayer = self.Owner;

	if ( pPlayer == NULL ) then
		return;
	end

	self:DoMachineGunKick( pPlayer, EASY_DAMPEN, MAX_VERTICAL_KICK, self.m_fFireDuration, SLIDE_LIMIT );

end

/*---------------------------------------------------------
   Name: SWEP:PreThink( )
   Desc: Called before every frame
---------------------------------------------------------*/
function SWEP:PreThink()
end


/*---------------------------------------------------------
   Name: SWEP:Think( )
   Desc: Called every frame
---------------------------------------------------------*/
function SWEP:Think()

	if CLIENT and self.EnableIdle then return end
	if self.idledelay and CurTime() > self.idledelay then
		self.idledelay = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	local pPlayer = self.Owner;

	if ( !pPlayer ) then
		return;
	end

	self:PreThink();

	if ( pPlayer:WaterLevel() >= 3 ) then
		self.m_bIsUnderwater = true;
	else
		self.m_bIsUnderwater = false;
	end

	if ( pPlayer:KeyDown( IN_ATTACK ) ) then
		self.m_fFireDuration = self.m_fFireDuration + FrameTime();
	elseif ( !pPlayer:KeyDown( IN_ATTACK ) ) then
		self.m_fFireDuration = 0.0;
		self.m_nShotsFired   = 0
	end

end


/*---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
---------------------------------------------------------*/


/*---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootBullet( damage, num_bullets, aimcone )

	// Only the player fires this way so we can cast
	local pPlayer = self.Owner;

	if ( !pPlayer ) then
		return;
	end

	local pHL2MPPlayer = pPlayer;

		// Fire the bullets
	local info = {};
	info.Num = num_bullets;
	info.Src = pHL2MPPlayer:GetShootPos();
	info.Dir = pPlayer:GetAimVector();
	info.Spread = aimcone;
	info.Damage = damage;
	info.Tracer = self.Primary.Tracer;
	info.TracerName = self.Primary.TracerName;

	info.Owner = self.Owner
	info.Weapon = self.Weapon

	info.ShootCallback = self.ShootCallback;

	info.Callback = function( attacker, trace, dmginfo )
		return info:ShootCallback( attacker, trace, dmginfo );
	end

	pPlayer:FireBullets( info );

end


/*---------------------------------------------------------
   Name: SWEP:ShootCallback( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:ShootCallback( attacker, trace, dmginfo )
end


/*---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack( )
   Desc: Helper function for checking for no ammo
---------------------------------------------------------*/
function SWEP:CanPrimaryAttack()
	return true
end


/*---------------------------------------------------------
   Name: SWEP:CanSecondaryAttack( )
   Desc: Helper function for checking for no ammo
---------------------------------------------------------*/
function SWEP:CanSecondaryAttack()
	return true
end


/*---------------------------------------------------------
   Name: SetDeploySpeed
   Desc: Sets the weapon deploy speed.
		 This value needs to match on client and server.
---------------------------------------------------------*/
function SWEP:SetDeploySpeed( speed )

	self.m_WeaponDeploySpeed = tonumber( speed / GetConVarNumber( "phys_timescale" ) )

	self.Weapon:SetNextPrimaryFire( CurTime() + speed )
	self.Weapon:SetNextSecondaryFire( CurTime() + speed )

end

/*---------------------------------------------------------
   Name: IdleStuff
   Desc: Helpers for the Idle function.
---------------------------------------------------------*/
function SWEP:IdleStuff()
	if self.EnableIdle then return end
	self.idledelay = CurTime() +self:SequenceDuration()
end

/*---------------------------------------------------------
   Name: CalcViewModelView
   Desc: Overwrites the default GMod v_model system.
---------------------------------------------------------*/
