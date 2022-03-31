
TYPE_BLUE_PBODY = 1
TYPE_ORANGE_PBODY = 2

PORTAL_HEIGHT = 110
PORTAL_WIDTH = 68

local limitPickups = CreateConVar("portal_limitcarry", 0, {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE,FCVAR_REPLICATED}, "Whether to limit the Portalgun to pickup certain props from the Portal game.")
local cleanportals = CreateClientConVar("portal_cleanportals","1",true,false)
local hitentity = CreateClientConVar("portal_hitentity","0",true,false)
local hitprop = CreateClientConVar("portal_hitprop","0",true,false)
local allsurfaces = CreateClientConVar("portal_allsurfaces","0",true,false)
local location = CreateClientConVar("portal_location","1",true,false)
local snd_portal2 = CreateClientConVar("portal_sound","0",true,false)
local autoFSB = CreateClientConVar("portal_autoFSB","1",true,false)
local tryhard = CreateClientConVar("portal_tryhard","0",true,false)
local CarryAnim_P1 = CreateClientConVar("portal_carryanim_p1","0",true,false)

local ballSpeed, useInstant
if ( SERVER ) then
        AddCSLuaFile( "shared.lua" )
        SWEP.Weight                     = 4
        SWEP.AutoSwitchTo               = false
        SWEP.AutoSwitchFrom             = false
		ballSpeed = CreateConVar("portal_projectile_speed", 3500, {FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE}, "The speed that portal projectiles travel.")
		useInstant = CreateConVar("portal_instant", 0, {FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE}, "Make portals create instantly and don't use the projectile.")
end

if ( CLIENT ) then
		SWEP.PrintName          = "Portal Gun P-Body's"
        SWEP.Author             = "CnicK / Bobblehead / Matsilagi"
        SWEP.Contact            = "kaisd@mail.ru"
        SWEP.Purpose            = "Shoot Linked Portals"
        SWEP.ViewModelFOV       = "60"
        SWEP.Instructions       = ""
        SWEP.Slot = 0
        SWEP.Slotpos = 0
        SWEP.CSMuzzleFlashes    = false
       
        -- function SWEP:DrawWorldModel()
                -- if ( RENDERING_PORTAL or RENDERING_MIRROR or GetViewEntity() != LocalPlayer() ) then
                        -- self.Weapon:DrawModel()
                -- end
        -- end

end

SWEP.HoldType                   = "crossbow"

SWEP.EnableIdle				= false	

SWEP.AdminOnly = false
SWEP.HoldenProp			= false
SWEP.NextAllowedPickup	= 0
SWEP.UseReleased		= true
SWEP.PickupSound		= nil
local pickable 			= {
	'models/props/metal_box.mdl',
	'models/props/futbol.mdl',
	'models/props/sphere.mdl',
	'models/props/metal_box_fx_fizzler.mdl',
	'models/props/turret_01.mdl',
	'models/props/reflection_cube.mdl',
	'npc_turret_floor',
	'npc_manhack',
	'models/props/radio_reference.mdl',
	'models/props/security_camera.mdl',
	'models/props/security_camera_prop_reference.mdl',
	'models/props_bts/bts_chair.mdl',
	'models/props_bts/bts_clipboard.mdl',
	'models/props_underground/underground_weighted_cube.mdl',
	'models/XQM/panel360.mdl',
	'models/props_bts/glados_ball_reference.mdl'
}

SWEP.Category = "Aperture Science"

SWEP.Spawnable                  = true
SWEP.AdminSpawnable             = true

SWEP.ViewModel                  = "models/weapons/portalgun/c_portalgun_orange.mdl"
SWEP.WorldModel                 = "models/weapons/portalgun/w_portalgun.mdl"

SWEP.UseHands			= true

SWEP.ViewModelFlip              = false

SWEP.Drawammo = false
SWEP.DrawCrosshair = true

SWEP.Delay                      = .5

SWEP.Primary.ClipSize           = -1
SWEP.Primary.DefaultClip        = -1
SWEP.Primary.Automatic          = true
SWEP.Primary.Ammo                       = "none"

SWEP.Secondary.ClipSize         = -1
SWEP.Secondary.DefaultClip      = -1
SWEP.Secondary.Automatic        = true
SWEP.Secondary.Ammo                     = "none"

SWEP.HasOrangePortal = false
SWEP.HasBluePortal = false

SWEP.AnimPrefix		= "crossbow"

SWEP.Holster_Fire				= false;
SWEP.SoonestAttack	= 0

SWEP.LastAttackTime			= 0.0;
SWEP.viewPunch					= Angle( 0, 0, 0 );

SWEP.Primary.FastestDelay	= .17

SWEP.BobScale = 0
SWEP.SwayScale = 0

BobTime = 0
BobTimeLast = CurTime()

SwayAng = nil
SwayOldAng = Angle()
SwayDelta = Angle()

function SWEP:GetBulletSpread()

end

/*---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
---------------------------------------------------------*/
function SWEP:Initialize()
	
	if CLIENT then
		self.Weapon:SetNetworkedInt("LastPortal",0,true)
		self:SetWeaponHoldType( self.HoldType )


		-- Create a new table for every weapon instance
		self.VElements = table.FullCopy( VElements )
		self.WElements = table.FullCopy( WElements )
		
		-- init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				-- Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					-- we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					-- ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					-- however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		

	else
		
		self.Weapon:SetNetworkedInt("LastPortal",0,true)
        self:SetWeaponHoldType( self.HoldType )
       
	end
end

if SERVER then
	util.AddNetworkString( 'PORTALGUN_PICKUP_PROP' )

	hook.Add( 'AllowPlayerPickup PBODY', 'PortalPickup PBODY', function( ply, ent )
		if IsValid( ply:GetActiveWeapon() ) and IsValid( ent ) and ply:GetActiveWeapon():GetClass() == 'weapon_portalgun_PBODY' then --and (table.HasValue( pickable, ent:GetModel() ) or table.HasValue( pickable, ent:GetClass() )) then
			return false
		end
	end )
end

hook.Add("Think PBODY", "Portalgun Holding Item PBODY", function()
	for k,v in pairs(player.GetAll())do
		if v:KeyDown(IN_USE) then
			if v:GetActiveWeapon().NextAllowedPickup and v:GetActiveWeapon().NextAllowedPickup < CurTime() then
				if v:GetActiveWeapon().UseReleased then
					v:GetActiveWeapon().UseReleased = false
					if IsValid( v:GetActiveWeapon().HoldenProp ) then
						v:GetActiveWeapon():OnDroppedProp()
					end
				end
			end
		else
			v:GetActiveWeapon().UseReleased = true
		end
	end
end)

function SWEP:Think()

if !tryhard:GetBool() then 
				self.Holster_Fire	= true
		else
				self.Holster_Fire	= false
end
	
if autoFSB:GetBool() then
RunConsoleCommand("portal_texFSB", "2")
end
	
	-- -- HOLDING FUNC
	
	if SERVER then
		if IsValid(self.HoldenProp) and (!self.HoldenProp:IsPlayerHolding() or self.HoldenProp.Holder != self.Owner) then
			self:OnDroppedProp()
		elseif self.HoldenProp and not IsValid(self.HoldenProp) then
			self:OnDroppedProp()
		end
		if self.Owner:KeyDown( IN_USE ) and self.UseReleased then
			self.UseReleased = false
			if self.NextAllowedPickup < CurTime() and !IsValid(self.HoldenProp) then
			
				local ply = self.Owner
				self.NextAllowedPickup = CurTime() + 0.4
				local tr = util.TraceLine( { 
					start = ply:EyePos(),
					endpos = ply:EyePos() + ply:GetForward() * 150,
					filter = ply
				} )
					
				--PICKUP FUNC
				if IsValid( tr.Entity ) then
					if tr.Entity.isClone then tr.Entity = tr.Entity.daddyEnt end
					local entsize = ( tr.Entity:OBBMaxs() - tr.Entity:OBBMins() ):Length() / 2
					if entsize > 45 then return end
					if !IsValid( self.HoldenProp ) and tr.Entity:GetMoveType() != 2 then
						if !self:PickupProp( tr.Entity ) then
						end
					end
				end
				
				--PICKUP THROUGH PORTAL FUNC
				--TODO
				
			end
		end
	end

	if CLIENT and self.EnableIdle then return end
	if self.idledelay and CurTime() > self.idledelay then
		self.idledelay = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	local pOwner = self.Owner;

	if ( pOwner == NULL ) then
		return;
	end

	if ( !pOwner:KeyDown( IN_ATTACK ) and !pOwner:KeyDown( IN_ATTACK2 ) and self.SoonestAttack < CurTime() ) then
		if ( !self.Holster_Fire ) then
			self.Weapon:SetNextPrimaryFire( CurTime() - .5 );
			self.Weapon:SetNextSecondaryFire( CurTime() - .5 );
		end
	end
	

end

function SWEP:PickupProp( ent )
	if !limitPickups:GetBool() or ( table.HasValue( pickable, ent:GetModel() ) or table.HasValue( pickable, ent:GetClass() ) )then
		if self.Owner:GetGroundEntity() == ent then return false end
		
		--Take it from other players.
		if ent:IsPlayerHolding() and ent.Holder and ent.Holder:IsValid() then
			ent.Holder:GetActiveWeapon():OnDroppedProp()
		end
		
		self.HoldenProp = ent
		ent.Holder = self.Owner
		
		--Rotate it first
		local angOffset = hook.Call("GetPreferredCarryAngles",GAMEMODE,ent) 
		if angOffset then
			ent:SetAngles(self.Owner:EyeAngles() + angOffset)
		end
		
		--Pick it up.
		self.Owner:PickupObject(ent)
		
		self:SendWeaponAnim( ACT_VM_DEPLOY )
		
		if SERVER then
			net.Start( 'PORTALGUN_PICKUP_PROP' )
				net.WriteEntity( self )
				net.WriteEntity( ent )
			net.Send( self.Owner )
		end
		return true
	end
	return false
end

function SWEP:OnDroppedProp()

end


function SWEP:GetViewModelPosition( pos, ang )

        self.SwayScale  = self.RunSway
        self.BobScale   = self.RunBob

        return pos, ang
end

local function VectorAngle( vec1, vec2 ) -- Returns the angle between two vectors

        local costheta = vec1:Dot( vec2 ) / ( vec1:Length() *  vec2:Length() )
        local theta = math.acos( costheta )
       
        return math.deg( theta )
       
end

function SWEP:MakeTrace( start, off, normAng )
        local trace = {}
        trace.start = start
        trace.endpos = start + off
        trace.filter = { self.Owner }
        trace.mask = MASK_SOLID_BRUSHONLY
       
        local tr = util.TraceLine( trace )
       
        if !tr.Hit then
       
                local trace = {}
                local newpos = start + off
                trace.start = newpos
                trace.endpos = newpos + normAng:Forward() * -2
                trace.filter = { self.Owner }
                trace.mask = MASK_SOLID_BRUSHONLY
                local tr2 = util.TraceLine( trace )
               
                if !tr2.Hit then
               
                        local trace = {}
                        trace.start = start + off + normAng:Forward() * -2
                        trace.endpos = start + normAng:Forward() * -2
                        trace.filter = { self.Owner }
                        trace.mask = MASK_SOLID_BRUSHONLY
                        local tr3 = util.TraceLine( trace )
                       
                        if tr3.Hit then
                       
                                tr.Hit = true
                                tr.Fraction = 1 - tr3.Fraction
                               
                        end
                       
                end
               
        end
       
        return tr
end

function SWEP:IsPosionValid( pos, normal, minwallhits, dosecondcheck )

        local owner = self.Owner
       
        local noPortal = false
        local normAng = normal:Angle()
        local BetterPos = pos
       
        local elevationangle = VectorAngle( vector_up, normal )
       
        if elevationangle <= 15 or ( elevationangle >= 175 and elevationangle <= 185 )  then --If the degree of elevation is less than 15 degrees, use the players yaw to place the portal
       
                normAng.y = owner:EyeAngles().y + 180
               
        end
       
        local VHits = 0
        local HHits = 0
       
if !location:GetBool() then 
        local tr = self:MakeTrace( pos, normAng:Up() * -PORTAL_HEIGHT * 0, normAng )
       
        if tr.Hit then -- Down
       
                local length = tr.Fraction * -PORTAL_HEIGHT * 0
                BetterPos = BetterPos + normAng:Up() * ( length + ( PORTAL_HEIGHT * 0 ) )
                VHits = VHits + 1
       
        end
       
        local tr = self:MakeTrace( pos, normAng:Up() * PORTAL_HEIGHT * 0, normAng )
       
        if tr.Hit then -- Up
       
                local length = tr.Fraction * PORTAL_HEIGHT * 0
                BetterPos = BetterPos + normAng:Up() * ( length - ( PORTAL_HEIGHT * 0 ) )
                VHits = VHits + 1
       
        end
       
        local tr = self:MakeTrace( pos, normAng:Right() * -PORTAL_WIDTH * 0, normAng )
       
        if tr.Hit then -- Right
       
                local length = tr.Fraction * -PORTAL_WIDTH * 0
                BetterPos = BetterPos + normAng:Right() * ( length + ( PORTAL_WIDTH * 0 ) )
                HHits = HHits + 1
       
        end
       
        local tr = self:MakeTrace( pos, normAng:Right() * PORTAL_WIDTH * 0, normAng )
       
        if tr.Hit then -- Left
       
                local length = tr.Fraction * PORTAL_WIDTH * 0
                BetterPos = BetterPos + normAng:Right() * ( length - ( PORTAL_WIDTH * 0 ) )
                HHits = HHits + 1
       
        end
else
        local tr = self:MakeTrace( pos, normAng:Up() * -PORTAL_HEIGHT * 0.5, normAng )
       
        if tr.Hit then -- Down
       
                local length = tr.Fraction * -PORTAL_HEIGHT * 0.5
                BetterPos = BetterPos + normAng:Up() * ( length + ( PORTAL_HEIGHT * 0.533 ) )
                VHits = VHits + 1
       
        end
       
        local tr = self:MakeTrace( pos, normAng:Up() * PORTAL_HEIGHT * 0.5, normAng )
       
        if tr.Hit then -- Up
       
                local length = tr.Fraction * PORTAL_HEIGHT * 0.5
                BetterPos = BetterPos + normAng:Up() * ( length - ( PORTAL_HEIGHT * 0.52 ) )
                VHits = VHits + 1
       
        end
       
        local tr = self:MakeTrace( pos, normAng:Right() * -PORTAL_WIDTH * 0.5, normAng )
       
        if tr.Hit then -- Right
       
                local length = tr.Fraction * -PORTAL_WIDTH * 0.5
                BetterPos = BetterPos + normAng:Right() * ( length + ( PORTAL_WIDTH * 0.5 ) )
                HHits = HHits + 1
       
        end
       
        local tr = self:MakeTrace( pos, normAng:Right() * PORTAL_WIDTH * 0.5, normAng )
       
        if tr.Hit then -- Left
       
                local length = tr.Fraction * PORTAL_WIDTH * 0.5
                BetterPos = BetterPos + normAng:Right() * ( length - ( PORTAL_WIDTH * 0.5 ) )
                HHits = HHits + 1
       
        end
end
       
        if dosecondcheck then
       
                return self:IsPosionValid( BetterPos, normal, 2, false )
               
        elseif ( HHits >= minwallhits or VHits >= minwallhits ) then
       
                return false, false
               
        else
       
                return BetterPos, normAng
       
        end


end

function SWEP:ShootBall(type,startpos,endpos,dir)
	local ball = ents.Create("projectile_portal_ball_pbody")
	local origin = startpos -Vector(0,0,10) +self.Owner:GetRight()*8 -- +dir*100
	
	ball:SetPos(origin)
	ball:SetAngles(dir:Angle())
	ball:SetEffects(type)
	ball:SetGun(self)
	ball:Spawn()
	ball:Activate()
	ball:SetOwner(self.Owner)
	
if !useInstant:GetBool() then 
			speed = ballSpeed:GetInt()
		else
			speed = 75 * 2500 
end
	
	local phy = ball:GetPhysicsObject()
	if phy:IsValid() then phy:ApplyForceCenter((endpos-origin):GetNormal() * speed) end
	
	return ball
end

function SWEP:ShootPortal( type )

	self:SetNextPrimaryFire( CurTime() + self.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Delay )

	local weapon = self.Weapon
	local owner = self.Owner

	local OrangePortalEnt_PBODY = owner:GetNWEntity( "Portal:Orange_PBODY", nil )
	local BluePortalEnt_PBODY = owner:GetNWEntity( "Portal:Blue_PBODY", nil )
   
	local EntToUse = type == TYPE_BLUE_PBODY and BluePortalEnt_PBODY or OrangePortalEnt_PBODY
	local OtherEnt = type == TYPE_BLUE_PBODY and OrangePortalEnt_PBODY or BluePortalEnt_PBODY
   
	local tr = {}
	tr.start = owner:GetShootPos()
	tr.endpos = owner:GetShootPos() + ( owner:GetAimVector() * 2048 * 1000 )
   
	tr.filter = { owner, EntToUse, EntToUse.Sides }
 
if !hitprop:GetBool() then 
				for k,v in pairs(ents.FindByClass( "prop_physics" )) do
			table.insert( tr.filter, v )
	end
		else
				for k,v in pairs(ents.FindByClass( "prop_physics" )) do
			
	end
end 
   
	for k,v in pairs( ents.FindByClass( "npc_turret_floor" ) ) do
			table.insert( tr.filter, v )
	end
   
	tr.mask = MASK_SHOT
   
	local trace = util.TraceLine( tr )
   
	if IsFirstTimePredicted() and owner:IsValid() then --Predict that motha' fucka'
			
		if SERVER then
			--shoot a ball.

			local ball = self:ShootBall(type,tr.start,tr.endpos,trace.Normal)
			
if !hitentity:GetBool() then 
			HitSelection = ( trace.Hit and trace.HitWorld )
		else
			HitSelection = ( trace.Hit or trace.HitWorld )
end
			
			if HitSelection then
			
if !useInstant:GetBool() then 
			hitDelay_Instant = ((trace.Fraction * 2048 * 1000))/ballSpeed:GetInt()
		else
			hitDelay_Instant = 0
end

if !allsurfaces:GetBool() then 
			All_Surfaces = ( !trace.HitNoDraw and !trace.HitSky and ( trace.MatType != MAT_METAL and trace.MatType != MAT_GLASS or ( trace.MatType == MAT_CONCRETE or trace.MatType == MAT_DIRT ) ) )
		else
			All_Surfaces = 0
end

hitDelay = ((trace.Fraction * 2048 * 1000))/ballSpeed:GetInt()

				local validpos, validnormang = self:IsPosionValid( trace.HitPos, trace.HitNormal, 2, true )
			   
					  timer.Simple( hitDelay, function()
							if ball and ball:IsValid() then 
								ball:Remove()

							end
						end )
			   
				if All_Surfaces and validpos and validnormang then
					  --Wait until our ball lands, if it's enabled.
					  
					  timer.Simple( hitDelay_Instant, function()
							if ball and ball:IsValid() then 
								local OrangePortalEnt_PBODY = owner:GetNWEntity( "Portal:Orange_PBODY", nil )
								local BluePortalEnt_PBODY = owner:GetNWEntity( "Portal:Blue_PBODY", nil )
							   
								local EntToUse = type == TYPE_BLUE_PBODY and BluePortalEnt_PBODY or OrangePortalEnt_PBODY
								local OtherEnt = type == TYPE_BLUE_PBODY and OrangePortalEnt_PBODY or BluePortalEnt_PBODY
								if !IsValid( EntToUse ) then
							   
										local Portal = ents.Create( "prop_portal_pbody" )
										Portal:SetPos( validpos )
										Portal:SetAngles( validnormang )
										Portal:Spawn()
										Portal:Activate()
										Portal:SetMoveType( MOVETYPE_NONE )
										Portal:SetActivatedState(true)
										Portal:SetType( type )
										Portal:SuccessEffect()
									   
										if type == TYPE_BLUE_PBODY then
									   
												owner:SetNWEntity( "Portal:Blue_PBODY", Portal )
												Portal:SetNetworkedBool("blue_PBODY",true,true)
											   
										else
									   
												owner:SetNWEntity( "Portal:Orange_PBODY", Portal )
												Portal:SetNetworkedBool("blue_PBODY",false,true)
											   
										end
									   
										EntToUse = Portal
									   
										if IsValid( OtherEnt ) then
									   
												EntToUse:LinkPortals( OtherEnt )
											   
										end
									   
								else
							   
										EntToUse:MoveToNewPos( validpos, validnormang )
										EntToUse:SuccessEffect()
									   
								end
							end
						end )
			   

				else						


					  timer.Simple( hitDelay_Instant, function()
							if ball and ball:IsValid() then 
						local ang = trace.HitNormal:Angle()
			   
						ang:RotateAroundAxis( ang:Right(), -90 )
						ang:RotateAroundAxis( ang:Forward(), 0 )
						ang:RotateAroundAxis( ang:Up(), 90 )
						local ent = ents.Create( "info_particle_system" )
						ent:SetPos( trace.HitPos + trace.HitNormal * 0.1 )
						ent:SetAngles( ang )
						--TODO: Different fail effects.
	if type == TYPE_BLUE_PBODY then
if GetConVarNumber("portal_color_PBODY_1") >=14 then
	ent:SetKeyValue( "effect_name", "portal_gray_badsurface")
elseif GetConVarNumber("portal_color_PBODY_1") >=13 then
	ent:SetKeyValue( "effect_name", "portal_gray_badsurface")
elseif GetConVarNumber("portal_color_PBODY_1") >=12 then
	ent:SetKeyValue( "effect_name", "portal_gray_badsurface")
elseif GetConVarNumber("portal_color_PBODY_1") >=11 then
	ent:SetKeyValue( "effect_name", "portal_2_badsurface_pbody")
elseif GetConVarNumber("portal_color_PBODY_1") >=10 then
	ent:SetKeyValue( "effect_name", "portal_2_badsurface_pink_green")
elseif GetConVarNumber("portal_color_PBODY_1") >=9 then
	ent:SetKeyValue( "effect_name", "portal_2_badsurface_pink_green")
elseif GetConVarNumber("portal_color_PBODY_1") >=8 then
	ent:SetKeyValue( "effect_name", "portal_2_badsurface_atlas")
elseif GetConVarNumber("portal_color_PBODY_1") >=7 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface")
elseif GetConVarNumber("portal_color_PBODY_1") >=6 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface_atlas")
elseif GetConVarNumber("portal_color_PBODY_1") >=5 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface_pink_green")
elseif GetConVarNumber("portal_color_PBODY_1") >=4 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface_pink_green")
elseif GetConVarNumber("portal_color_PBODY_1") >=3 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface_pink_green")
elseif GetConVarNumber("portal_color_PBODY_1") >=2 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface_pbody")
elseif GetConVarNumber("portal_color_PBODY_1") >=1 then
	ent:SetKeyValue( "effect_name", "portal_2_badsurface")
else
	ent:SetKeyValue( "effect_name", "portal_2_badsurface_pbody")
end
		elseif type == TYPE_ORANGE_PBODY then
if GetConVarNumber("portal_color_PBODY_2") >=14 then
	ent:SetKeyValue( "effect_name", "portal_gray_badsurface")
elseif GetConVarNumber("portal_color_PBODY_2") >=13 then
	ent:SetKeyValue( "effect_name", "portal_gray_badsurface")
elseif GetConVarNumber("portal_color_PBODY_2") >=12 then
	ent:SetKeyValue( "effect_name", "portal_gray_badsurface")
elseif GetConVarNumber("portal_color_PBODY_2") >=11 then
	ent:SetKeyValue( "effect_name", "portal_2_badsurface_pbody")
elseif GetConVarNumber("portal_color_PBODY_2") >=10 then
	ent:SetKeyValue( "effect_name", "portal_2_badsurface_pink_green")
elseif GetConVarNumber("portal_color_PBODY_2") >=9 then
	ent:SetKeyValue( "effect_name", "portal_2_badsurface_pink_green")
elseif GetConVarNumber("portal_color_PBODY_2") >=8 then
	ent:SetKeyValue( "effect_name", "portal_2_badsurface_atlas")
elseif GetConVarNumber("portal_color_PBODY_2") >=7 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface")
elseif GetConVarNumber("portal_color_PBODY_2") >=6 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface_atlas")
elseif GetConVarNumber("portal_color_PBODY_2") >=5 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface_pink_green")
elseif GetConVarNumber("portal_color_PBODY_2") >=4 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface_pink_green")
elseif GetConVarNumber("portal_color_PBODY_2") >=3 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface_pink_green")
elseif GetConVarNumber("portal_color_PBODY_2") >=2 then
	ent:SetKeyValue( "effect_name", "portal_1_badsurface_pbody")
elseif GetConVarNumber("portal_color_PBODY_2") >=1 then
	ent:SetKeyValue( "effect_name", "portal_2_badsurface")
else
	ent:SetKeyValue( "effect_name", "portal_2_badsurface_pbody")
end
	end
						ent:SetKeyValue( "start_active", "1")
						ent:Spawn()
						ent:Activate()
						timer.Simple( 5, function()
							if IsValid( ent ) then
								ent:Remove()
							end 
						end )
						
if !snd_portal2:GetBool() then 
			ent:EmitSound( "weapons/portalgun/portal_invalid_surface3.wav")
		else
			ent:EmitSound( "weapons/portalgun/portal2/portal_invalid_surface"..math.random(1,4)..".wav")
end
							end
						end )
   
				end
			   
				   
			end
		   
		end
	end
   
end


function SWEP:PrimaryAttack()

        self:ShootPortal( TYPE_BLUE_PBODY )
		self.Weapon:SetNetworkedInt("LastPortal",1)
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
if !snd_portal2:GetBool() then 
			self.Weapon:EmitSound( "weapons/portalgun/portalgun_shoot_blue1.wav", 70, 100, .7, CHAN_WEAPON )
		else
			self.Weapon:EmitSound( "weapons/portalgun/portal2/portalgun_shoot_blue"..math.random(1,3)..".wav", 70, 100, .7, CHAN_WEAPON )
end
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:IdleStuff()

	if ( !self:CanPrimaryAttack() ) then return end

	self.LastAttackTime = CurTime();
	self.SoonestAttack = CurTime() + self.Primary.FastestDelay;

	local pOwner = self.Owner;

	local pPlayer = self.Owner;
	if (!pPlayer) then
		return;
	end

	local iBulletsToFire = 0;
	local fireRate = self.Delay;

	self.Weapon:SetNextPrimaryFire( CurTime() + fireRate );
	self.Weapon:SetNextSecondaryFire( CurTime() + fireRate );

	if ( !pPlayer:IsNPC() ) then
		self:AddViewKick();
	end
	
end

function SWEP:SecondaryAttack()

        self:ShootPortal( TYPE_ORANGE_PBODY )
		self.Weapon:SetNetworkedInt("LastPortal",2)
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
if !snd_portal2:GetBool() then 
			self.Weapon:EmitSound( "weapons/portalgun/portalgun_shoot_red1.wav", 70, 100, .7, CHAN_WEAPON )
		else
			self.Weapon:EmitSound( "weapons/portalgun/portal2/portalgun_shoot_red"..math.random(1,3)..".wav", 70, 100, .7, CHAN_WEAPON )
end
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:IdleStuff()
	if ( !self:CanSecondaryAttack() ) then return end

	self.LastAttackTime = CurTime();
	self.SoonestAttack = CurTime() + self.Primary.FastestDelay;

	local pOwner = self.Owner;

	local pPlayer = self.Owner;
	if (!pPlayer) then
		return;
	end

	local iBulletsToFire = 0;
	local fireRate = self.Delay;

	self.Weapon:SetNextPrimaryFire( CurTime() + fireRate );
	self.Weapon:SetNextSecondaryFire( CurTime() + fireRate );

	if ( !pPlayer:IsNPC() ) then
		self:AddViewKick();
	end
	
end

function SWEP:CleanPortals()

        local blueportal_PBODY = self.Owner:GetNWEntity( "Portal:Blue_PBODY" )
        local orangeportal_PBODY = self.Owner:GetNWEntity( "Portal:Orange_PBODY" )
        local cleaned = false
       
        for k,v in ipairs( ents.FindByClass( "prop_portal_pbody" ) ) do
       
                if v == blueportal_PBODY or v == orangeportal_PBODY and v.CleanMeUp then
               
                        if SERVER then
                            v:CleanMeUp()
                        end
                       
                        cleaned = true
                       
                end
               
        end
       
        if cleaned then

            self.Weapon:SendWeaponAnim( ACT_VM_FIZZLE )
			self.Weapon:SetNetworkedInt("LastPortal",0)
if !snd_portal2:GetBool() then 
			self.Weapon:EmitSound( "weapons/portalgun/portal_fizzle2.wav", 45, 100, .5, CHAN_WEAPON )
		else
			self.Weapon:EmitSound( "weapons/portalgun/portal2/portal_fizzle2.wav", 45, 100, .5, CHAN_WEAPON )
end
			self:IdleStuff()
        
		end
       
end

function SWEP:Reload()

if !cleanportals:GetBool() then return end

        self:CleanPortals()
		self:IdleStuff()
        return

end

function SWEP:OnRestore()
	self.Weapon:SendWeaponAnim( ACT_VM_DEPLOY )
end

/*---------------------------------------------------------
   Name: IdleStuff
   Desc: Helpers for the Idle function.
---------------------------------------------------------*/
function SWEP:IdleStuff()
	if self.EnableIdle then return end
	self.idledelay = CurTime() +self:SequenceDuration()

timer.Create( "Hold", 0.005, 1, function()
	if not self.HoldenProp then return end
if CarryAnim_P1:GetBool() then 
	self:SendWeaponAnim(ACT_VM_FIDGET)
		else
	self:SendWeaponAnim(ACT_VM_RELEASE)
end
	
	if SERVER then
		self.Owner:DropObject()
	end
	self.HoldenProp.Holder = nil
	self.HoldenProp = nil
	if SERVER then
		net.Start( 'PORTALGUN_PICKUP_PROP' )
			net.WriteEntity( self )
			net.WriteEntity( NULL )
		net.Send( self.Owner )
	end
end)
	
end

function SWEP:CheckExisting()
	if blueportal_PBODY != nil && blueportal_PBODY != nil then return end
	for _,v in pairs(ents.FindByClass("prop_portal_pbody")) do
		local own = v.Ownr
		if v != nil && own == self.Owner then
			if v.type == TYPE_BLUE_PBODY && self.blueportal_PBODY == nil then
				self.blueportal_PBODY = v
			elseif v.type == TYPE_ORANGE_PBODY && self.orangeportal_PBODY == nil then
				self.orangeportal_PBODY = v
			end
		end
	end
end

function SWEP:AddViewKick()

	local pPlayer  = self.Owner;

	if ( pPlayer == NULL ) then
		return;
	end

	self.viewPunch = Angle( 0, 0, 0 );

	self.viewPunch.x = math.Rand( 0.25, 0.5 );
	self.viewPunch.y = math.Rand( -.6, .6 );
	self.viewPunch.z = 0.0;

	pPlayer:ViewPunch( self.viewPunch );

end

function SWEP:Holster( wep )

if !tryhard:GetBool() then 
				self.Holster_Fire	= true
		else
				self.Holster_Fire	= false
end

	return true

end

function SWEP:Deploy()

        self.Weapon:SendWeaponAnim( ACT_VM_DEPLOY )
		self:CheckExisting() 
		self:IdleStuff()
        return true

end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end


function SWEP:IdleStuff()
	if self.EnableIdle then return end
	self.idledelay = CurTime() +self:SequenceDuration()

timer.Create( "Hold", 0.005, 1, function()
	if not self.HoldenProp then return end
if CarryAnim_P1:GetBool() then 
	self:SendWeaponAnim(ACT_VM_FIDGET)
		else
	self:SendWeaponAnim(ACT_VM_RELEASE)
end
	if SERVER then
		self.Owner:DropObject()
	end
	self.HoldenProp.Holder = nil
	self.HoldenProp = nil
	if SERVER then
		net.Start( 'PORTALGUN_PICKUP_PROP' )
			net.WriteEntity( self )
			net.WriteEntity( NULL )
		net.Send( self.Owner )
	end
end)
	
end

function SWEP:CheckExisting()
	if blueportal_PBODY != nil && blueportal_PBODY != nil then return end
	for _,v in pairs(ents.FindByClass("prop_portal_pbody")) do
		local own = v.Ownr
		if v != nil && own == self.Owner then
			if v.type == TYPE_BLUE_PBODY && self.blueportal_PBODY == nil then
				self.blueportal_PBODY = v
			elseif v.type == TYPE_ORANGE_PBODY && self.orangeportal_PBODY == nil then
				self.orangeportal_PBODY = v
			end
		end
	end
end