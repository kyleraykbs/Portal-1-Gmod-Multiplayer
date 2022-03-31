ENT.Sound				= {}
ENT.Sound.Blip			= "Grenade.Blip"
ENT.Sound.Blip_5		= "weapons/tick1_5.wav"
ENT.Sound.Explode		= "BaseGrenade.Explode"

ENT.Trail				= {}
ENT.Trail.Color			= Color( 255, 0, 0, 255 )
ENT.Trail.Material		= "sprites/bluelaser1.vmt"
ENT.Trail.StartWidth	= 8.0
ENT.Trail.EndWidth		= 1.0
ENT.Trail.LifeTime		= 0.5

// Nice helper function, this does all the work.

/*---------------------------------------------------------
   Name: DoExplodeEffect
---------------------------------------------------------*/
function ENT:DoExplodeEffect()

	local info = EffectData();
	info:SetEntity( self.Entity );
	info:SetOrigin( self.Entity:GetPos() );

	util.Effect( "Explosion", info );

end

/*---------------------------------------------------------
   Name: OnExplode
   Desc: The grenade has just exploded.
---------------------------------------------------------*/
function ENT:OnExplode( pTrace )

	local Pos1 = pTrace.HitPos + pTrace.HitNormal
	local Pos2 = pTrace.HitPos - pTrace.HitNormal

 	util.Decal( "Scorch", Pos1, Pos2 );

end

/*---------------------------------------------------------
   Name: OnInitialize
---------------------------------------------------------*/
function ENT:OnInitialize()
	
	self.env_sprite = ents.Create("env_sprite")
	self.env_sprite:SetPos( self:GetPos())
	self.env_sprite:SetAngles( self:GetAngles() )
	self.env_sprite:SetOwner( self.Owner )
	self.env_sprite:SetKeyValue( "scale", "0.2" )
	self.env_sprite:SetKeyValue( "model", "sprites/redglow1.vmt" )
	self.env_sprite:SetKeyValue( "framerate", "30" )
	self.env_sprite:SetKeyValue( "rendermode", "9" )
	self.env_sprite:SetKeyValue( "spawnflags", "1" )
	self.env_sprite:SetParent(self)
	local env_sprite_name = "env_sprite" .. self.env_sprite:EntIndex()
	self.env_sprite:SetName( env_sprite_name )
	self.env_sprite:Spawn()
	self.env_sprite:Activate()

end

/*---------------------------------------------------------
   Name: StartTouch
---------------------------------------------------------*/
function ENT:StartTouch( entity )
end

/*---------------------------------------------------------
   Name: EndTouch
---------------------------------------------------------*/
function ENT:EndTouch( entity )
end

/*---------------------------------------------------------
   Name: Touch
---------------------------------------------------------*/
function ENT:Touch( entity )
end

/*---------------------------------------------------------
   Name: OnThink
---------------------------------------------------------*/
function ENT:OnThink()

	if IsValid (self.env_sprite) then
	end
	if !IsValid (self.env_sprite) then
	self:Remove()
	end

end

function ENT:OnRemove()
	if IsValid (self.env_sprite) then
	self.env_sprite:Remove()
	end
end