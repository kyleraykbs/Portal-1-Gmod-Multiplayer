AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

ENT.Linked = nil
ENT.PortalType = TYPE_BLUE_ATLAS
ENT.Activated = false
ENT.KeyValues = {}

local upsidedown = CreateClientConVar("portal_upside_down","1",true,false)
local snd_portal2 = CreateClientConVar("portal_sound","0",true,false)
local sides_fix = CreateClientConVar("portal_sides_fix","0",true,false)
local portal_prototype = CreateClientConVar("portal_prototype","1",true,false)
local vel_roof_max = CreateConVar("portal_velocity_roof", 1000, {FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE})

sound.Add({
	name = "portal_loop", 
	channel = CHAN_STATIC, 
	volume = .8, 
	level = 64, 
	pitch = {100}, 
	sound = "weapons/portalgun/portal_ambient_loop1.wav"
})

sound.Add({
	name = "portal_loop2", 
	channel = CHAN_STATIC, 
	volume = .8, 
	level = 64, 
	pitch = {100}, 
	sound = "weapons/portalgun/portal2/portal_ambient_loop1.wav"
})

local hitprop = CreateClientConVar("portal_hitprop","0",true,false)

function ENT:SpawnFunction( ply, tr ) --unused.
	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "prop_portal_atlas" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()

	return ent
end

--I think this is from sassilization..
local function IsBehind( posA, posB, normal )

	local Vec1 = ( posB - posA ):GetNormalized()

	return ( normal:Dot( Vec1 ) < 0 )

end

function ENT:Initialize( )
if !portal_prototype:GetBool() then 
		self:SetModel( "models/blackops/portal_fix.mdl" )
		else
		self:SetModel( "models/blackops/portal_prototype_fix.mdl" )
end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetMoveType( MOVETYPE_NONE )
	self:PhysWake()
	self:DrawShadow(false)
	self:SetTrigger(true)
	self:SetNWBool("Potal:Activated",false)
	self:SetNWBool("Potal:Linked",false)
	self:SetNWInt("Potal:PortalType",self.PortalType)
	
	self.Sides = ents.Create( "prop_physics" )
if !sides_fix:GetBool() then 
	self.Sides:SetModel( "models/blackops/portal_sides.mdl" )
		else
	self.Sides:SetModel( "models/blackops/portal_sides_new.mdl" )
end
	self.Sides:SetPos( self:GetPos() + self:GetForward()*-0.1 )
	self.Sides:SetAngles( self:GetAngles() )
	self.Sides:Spawn()
	self.Sides:Activate()
	self.Sides:SetRenderMode( RENDERMODE_NONE )
	self.Sides:PhysicsInit(SOLID_VPHYSICS)
	self.Sides:SetSolid(SOLID_VPHYSICS)
	self.Sides:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	--self.Sides:SetMoveType( MOVETYPE_NONE ) --causes some weird shit to happen..
	self.Sides:DrawShadow(false)
	
	local phys = self.Sides:GetPhysicsObject()
	
	if IsValid( phys ) then
		phys:EnableMotion( false )
	end
	
	self:DeleteOnRemove(self.Sides)
	
	if self:OnFloor() then
		self:SetPos( self:GetPos() + Vector(0,0,20) )
	end
	
	if self:OnRoof() and (not self:IsHorizontal()) then

if upsidedown:GetBool() then 

self:SetAngles( self:GetAngles() + Angle(0,0,180) )

		else

self:SetAngles( self:GetAngles() + Angle(0,0,0) )

end 

	end

self.portal_loop = CreateSound(self,"portal_loop")
self.portal_loop2 = CreateSound(self,"portal_loop2")
	
if !snd_portal2:GetBool() then 
	self.portal_loop:Play()
		else
	self.portal_loop2:Play()
end
	
	for k,v in pairs(ents.FindInSphere(self:GetPos(),100))do
		if v == self then continue end
		if v == self.Sides then continue end
		if v:GetClass() != "prop_physics" and v:GetClass() != "npc_grenade_frag" then continue end
		local phys = v:GetPhysicsObject()
		if IsValid(phys) then
			-- print(v)
			phys:Wake()
			phys:ApplyForceCenter(Vector(0,0,10))
		end
	end
end


function ENT:BootPlayer()
	--Kick players out of this portal.
	for k,p in pairs(player.GetAll()) do 
		if p.InPortal and (p.InPortal:EntIndex() == self:EntIndex()) then
		
			p:SetPos(self:GetPos() + self:GetForward()*25 + self:GetUp()*-40)
			
			p.InPortal = false
			p.PortalClone:Remove()
			p.PortalClone = nil
			p:SetMoveType(MOVETYPE_WALK)
for _, v in pairs( player.GetAll() ) do
   v:ResetHull()
end
			umsg.Start( "Portal:ObjectLeftPortal" )
			umsg.Entity( p )
			umsg.End()
		end
	end
end

function ENT:CleanMeUp()
 
	self.portal_loop:Stop("portal_loop")
	self.portal_loop2:Stop("portal_loop2")
	
	self:BootPlayer()

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(),-90)
	ang:RotateAroundAxis(ang:Forward(),0)
	ang:RotateAroundAxis(ang:Up(),90)
	
	
	local pos = self:GetPos()
	if self:OnFloor() then
		pos = pos-Vector(0,0,20)
	end
	
	if self.PortalType == TYPE_BLUE_ATLAS then
if GetConVarNumber("portal_color_ATLAS_1") >=14 then
	ParticleEffect("portal_gray_close",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=13 then
	ParticleEffect("portal_gray_close",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=12 then
	ParticleEffect("portal_gray_close",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=11 then
	ParticleEffect("portal_2_close_pbody",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=10 then
	ParticleEffect("portal_2_close_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=9 then
	ParticleEffect("portal_2_close_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=8 then
	ParticleEffect("portal_2_close_atlas",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=7 then
	ParticleEffect("portal_1_close",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=6 then
	ParticleEffect("portal_1_close_atlas",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=5 then
	ParticleEffect("portal_1_close_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=4 then
	ParticleEffect("portal_1_close_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=3 then
	ParticleEffect("portal_1_close_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=2 then
	ParticleEffect("portal_1_close_pbody",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=1 then
	ParticleEffect("portal_2_close",pos,ang,self)
else
	ParticleEffect("portal_2_close_pbody",pos,ang,self)
end
		elseif self.PortalType == TYPE_ORANGE_ATLAS then
if GetConVarNumber("portal_color_ATLAS_2") >=14 then
	ParticleEffect("portal_gray_close",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=13 then
	ParticleEffect("portal_gray_close",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=12 then
	ParticleEffect("portal_gray_close",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=11 then
	ParticleEffect("portal_2_close_pbody",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=10 then
	ParticleEffect("portal_2_close_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=9 then
	ParticleEffect("portal_2_close_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=8 then
	ParticleEffect("portal_2_close_atlas",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=7 then
	ParticleEffect("portal_1_close",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=6 then
	ParticleEffect("portal_1_close_atlas",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=5 then
	ParticleEffect("portal_1_close_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=4 then
	ParticleEffect("portal_1_close_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=3 then
	ParticleEffect("portal_1_close_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=2 then
	ParticleEffect("portal_1_close_pbody",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=1 then
	ParticleEffect("portal_2_close",pos,ang,self)
else
	ParticleEffect("portal_2_close_pbody",pos,ang,self)
end
	end
	
if !snd_portal2:GetBool() then 
			self:EmitSound("weapons/portalgun/portal_close"..math.random(1,2)..".wav",70)
		else
			self:EmitSound("weapons/portalgun/portal2/portal_close"..math.random(1,2)..".wav",70)
end
	-- timer.Simple(5,function()
		-- if ent and ent:IsValid() then
			-- ent:Remove()
		-- end
	-- end)
	self:Remove()
end

function ENT:MoveToNewPos(pos,newang) --Called by the swep, used if a player already has a portal out.
	
	self:BootPlayer()
	if IsValid(self:GetOther()) then
		self:GetOther():BootPlayer()
	end
	
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(),-90)
	ang:RotateAroundAxis(ang:Forward(),0)
	ang:RotateAroundAxis(ang:Up(),90)
	
	self:SetAngles(newang)
	
	local effectpos = self:GetPos()
	if self:OnFloor() then
		effectpos = effectpos-Vector(0,0,20)
	end
	self.VacuumEffect:SetPos(effectpos)
	self.EdgeEffect:SetPos(effectpos)
	
	if self.PortalType == TYPE_BLUE_ATLAS then
if GetConVarNumber("portal_color_ATLAS_1") >=14 then
	ParticleEffect("portal_gray_close",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=13 then
	ParticleEffect("portal_gray_close",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=12 then
	ParticleEffect("portal_gray_close",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=11 then
	ParticleEffect("portal_2_close_pbody",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=10 then
	ParticleEffect("portal_2_close_pink_green",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=9 then
	ParticleEffect("portal_2_close_pink_green",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=8 then
	ParticleEffect("portal_2_close_atlas",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=7 then
	ParticleEffect("portal_1_close",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=6 then
	ParticleEffect("portal_1_close_atlas",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=5 then
	ParticleEffect("portal_1_close_pink_green",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=4 then
	ParticleEffect("portal_1_close_pink_green",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=3 then
	ParticleEffect("portal_1_close_pink_green",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=2 then
	ParticleEffect("portal_1_close_pbody",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_1") >=1 then
	ParticleEffect("portal_2_close",effectpos,ang,nil)
else
	ParticleEffect("portal_2_close_pbody",effectpos,ang,nil)
end
if !snd_portal2:GetBool() then 
			self:EmitSound("weapons/portalgun/portal_close"..math.random(1,2)..".wav",70)
		else
			self:EmitSound("weapons/portalgun/portal2/portal_close"..math.random(1,2)..".wav",70)
end
	elseif self.PortalType == TYPE_ORANGE_ATLAS then
if GetConVarNumber("portal_color_ATLAS_2") >=14 then
	ParticleEffect("portal_gray_close",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=13 then
	ParticleEffect("portal_gray_close",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=12 then
	ParticleEffect("portal_gray_close",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=11 then
	ParticleEffect("portal_2_close_pbody",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=10 then
	ParticleEffect("portal_2_close_pink_green",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=9 then
	ParticleEffect("portal_2_close_pink_green",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=8 then
	ParticleEffect("portal_2_close_atlas",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=7 then
	ParticleEffect("portal_1_close",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=6 then
	ParticleEffect("portal_1_close_atlas",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=5 then
	ParticleEffect("portal_1_close_pink_green",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=4 then
	ParticleEffect("portal_1_close_pink_green",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=3 then
	ParticleEffect("portal_1_close_pink_green",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=2 then
	ParticleEffect("portal_1_close_pbody",effectpos,ang,nil)
elseif GetConVarNumber("portal_color_ATLAS_2") >=1 then
	ParticleEffect("portal_2_close",effectpos,ang,nil)
else
	ParticleEffect("portal_2_close_pbody",effectpos,ang,nil)
end
if !snd_portal2:GetBool() then 
			self:EmitSound("weapons/portalgun/portal_close"..math.random(1,2)..".wav",70)
		else
			self:EmitSound("weapons/portalgun/portal2/portal_close"..math.random(1,2)..".wav",70)
end
	end
	
	self:SetPos( pos )
	
	if IsValid( self.Sides ) then
		self.Sides:SetPos(pos)
		self.Sides:SetAngles(newang)
	end
	
	if self:OnFloor() then
		pos.z = pos.z + 20
		self:SetPos( pos )
	end
	
	if self:OnRoof() and (not self:IsHorizontal()) then
		
if upsidedown:GetBool() then 

		newang.z = newang.z + 180

		else

		newang.z = newang.z + 0

end 
		
		self:SetAngles( newang )
	end
	
	
	
	umsg.Start("Portal:Moved" )
	umsg.Entity( self )
	umsg.Vector(pos)
	umsg.Angle(newang)
	umsg.End()
	
end


function ENT:SuccessEffect()

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(),-90)
	ang:RotateAroundAxis(ang:Forward(),0)
	ang:RotateAroundAxis(ang:Up(),90)
	
	local pos = self:GetPos()
	if self:OnFloor() then
		pos = pos-Vector(0,0,20)
	end

	if self.PortalType == TYPE_BLUE_ATLAS then
if GetConVarNumber("portal_color_ATLAS_1") >=14 then
	ParticleEffect("portal_gray_success",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=13 then
	ParticleEffect("portal_gray_success",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=12 then
	ParticleEffect("portal_gray_success",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=11 then
	ParticleEffect("portal_2_success_pbody",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=10 then
	ParticleEffect("portal_2_success_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=9 then
	ParticleEffect("portal_2_success_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=8 then
	ParticleEffect("portal_2_success_atlas",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=7 then
	ParticleEffect("portal_1_success",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=6 then
	ParticleEffect("portal_1_success_atlas",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=5 then
	ParticleEffect("portal_1_success_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=4 then
	ParticleEffect("portal_1_success_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=3 then
	ParticleEffect("portal_1_success_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=2 then
	ParticleEffect("portal_1_success_pbody",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_1") >=1 then
	ParticleEffect("portal_2_success",pos,ang,self)
else
	ParticleEffect("portal_2_success_pbody",pos,ang,self)
end
		elseif self.PortalType == TYPE_ORANGE_ATLAS then
if GetConVarNumber("portal_color_ATLAS_2") >=14 then
	ParticleEffect("portal_gray_success",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=13 then
	ParticleEffect("portal_gray_success",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=12 then
	ParticleEffect("portal_gray_success",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=11 then
	ParticleEffect("portal_2_success_pbody",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=10 then
	ParticleEffect("portal_2_success_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=9 then
	ParticleEffect("portal_2_success_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=8 then
	ParticleEffect("portal_2_success_atlas",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=7 then
	ParticleEffect("portal_1_success",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=6 then
	ParticleEffect("portal_1_success_atlas",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=5 then
	ParticleEffect("portal_1_success_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=4 then
	ParticleEffect("portal_1_success_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=3 then
	ParticleEffect("portal_1_success_pink_green",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=2 then
	ParticleEffect("portal_1_success_pbody",pos,ang,self)
elseif GetConVarNumber("portal_color_ATLAS_2") >=1 then
	ParticleEffect("portal_2_success",pos,ang,self)
else
	ParticleEffect("portal_2_success_pbody",pos,ang,self)
end
	end
	
	local int = math.random(1,2)
	
	if self.PortalType == TYPE_BLUE_ATLAS then
if !snd_portal2:GetBool() then 
			self:EmitSound("weapons/portalgun/portal_open1.wav",100 )
		else
			self:EmitSound("weapons/portalgun/portal2/portal_open1.wav",100 )
end
		elseif self.PortalType == TYPE_ORANGE_ATLAS then
		
if !snd_portal2:GetBool() then 
	if int==1 then int = 3 end
	self:EmitSound("weapons/portalgun/portal_open"..int..".wav",100 )
		else
	if int==1 then int = 3 end
	self:EmitSound("weapons/portalgun/portal2/portal_open"..int..".wav",100 )
	self:EmitSound("weapons/portalgun/portal2/portal_open_rock"..math.random(1,2)..".wav",75 )
end

	end
	
end


function ENT:LinkPortals( ent )
	self:SetNWBool("Potal:Linked",true)
	self:SetNWEntity("Potal:Other",ent)
	ent:SetNWBool("Potal:Linked",true)
	ent:SetNWEntity("Potal:Other",self)
end

function ENT:OnTakeDamage(dmginfo)
end

--Mahalis code
function ENT:CanPort(ent)
	local c = ent:GetClass()
	if ent:IsPlayer() or (ent != nil && ent:IsValid() && !ent.isClone && ent:GetPhysicsObject() && c != "noportal_pillar" && c != "prop_dynamic" && c != "rpg_missile" && string.sub(c,1,5) != "func_" && string.sub(c,1,9) != "prop_door") then
		return true
	else
		return false
	end
end

function ENT:MakeClone(ent)

	if self:GetNWBool("Potal:Linked",false) == false or self:GetNWBool("Potal:Activated",false) == false then return end	
	--if ent:GetClass() != "prop_physics" then return end
	
	local portal = self:GetNWEntity("Potal:Other")

	
	if ent.clone != nil then return end
	local clone = ents.Create("prop_physics")
	clone:SetSolid(SOLID_NONE)
	clone:SetPos(self:GetPortalPosOffsets(portal,ent))
	clone:SetAngles(self:GetPortalAngleOffsets(portal,ent))
	clone.isClone = true
	clone.daddyEnt = ent
	clone:SetModel(ent:GetModel())
	clone:Spawn()
	clone:SetSkin(ent:GetSkin())
	clone:SetMaterial(ent:GetMaterial())
	ent:DeleteOnRemove(clone)
	local phy = clone:GetPhysicsObject()
	if phy:IsValid() then
		phy:EnableCollisions(false)
		phy:EnableGravity(false)
		phy:EnableDrag(false)
	end
	ent.clone = clone
	
	umsg.Start("Portal:ObjectInPortal" )
		umsg.Entity( portal )
		umsg.Entity( clone )
	umsg.End()
	clone.InPortal = portal
end


function ENT:SyncClone(ent)
	local clone = ent.clone
	
	if self:GetNWBool("Potal:Linked",false) == false or self:GetNWBool("Potal:Activated",false) == false then return end	
	if clone == nil then return end
	
	local portal = self:GetNWEntity("Potal:Other")

	clone:SetPos(self:GetPortalPosOffsets(portal,ent))
	clone:SetAngles(self:GetPortalAngleOffsets(portal,ent))
end

function ENT:StartTouch(ent)
	--if ent:IsPlayer() then return end
	if ent:GetModel() == "models/blackops/portal_sides.mdl" then return end
	if ent:GetModel() == "models/blackops/portal_sides_new.mdl" then return end
	
if hitprop:GetBool() then 
if ent:GetModel() == "models/props_phx/construct/metal_plate1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate1_tri.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate1x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate1x2_tri.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate2x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate2x2_tri.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate2x4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate2x4_tri.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate4x4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate4x4_tri.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_tube.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_tubex2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_angle360.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_angle180.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_angle90.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate_curve360.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate_curve180.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate_curve.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate_curve360x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate_curve180x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_plate_curve2x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_dome360.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_dome180.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_dome90.mdl" then return end
if ent:GetModel() == "models/phxtended/tri1x1solid.mdl" then return end
if ent:GetModel() == "models/phxtended/tri1x1x1solid.mdl" then return end
if ent:GetModel() == "models/phxtended/tri1x1x2solid.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x1solid.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x1x1solid.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x1x2solid.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x2solid.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x2x1solid.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x2x2solid.mdl" then return end
if ent:GetModel() == "models/phxtended/trieq1x1x1solid.mdl" then return end
if ent:GetModel() == "models/phxtended/trieq1x1x2solid.mdl" then return end
if ent:GetModel() == "models/phxtended/trieq2x2x1solid.mdl" then return end
if ent:GetModel() == "models/phxtended/trieq2x2x2solid.mdl" then return end
if ent:GetModel() == "models/phxtended/bar1x.mdl" then return end
if ent:GetModel() == "models/phxtended/bar1x45a.mdl" then return end
if ent:GetModel() == "models/phxtended/bar1x45b.mdl" then return end
if ent:GetModel() == "models/phxtended/bar2x.mdl" then return end
if ent:GetModel() == "models/phxtended/bar2x45a.mdl" then return end
if ent:GetModel() == "models/phxtended/bar2x45b.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire1x1.mdl" then return end
if ent:GetModel() == "models/phxtended/cab1x1x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire1x1x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire1x2b.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire1x2.mdl" then return end
if ent:GetModel() == "models/phxtended/cab2x1x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire1x1x2b.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire1x1x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire2x2b.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire2x2.mdl" then return end
if ent:GetModel() == "models/phxtended/cab2x2x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire1x2x2b.mdl" then return end
if ent:GetModel() == "models/phxtended/cab2x2x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire2x2x2b.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire_angle360x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire_angle180x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire_angle90x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire_angle360x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire_angle180x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/metal_wire_angle90x2.mdl" then return end
if ent:GetModel() == "models/phxtended/tri1x1.mdl" then return end
if ent:GetModel() == "models/phxtended/tri1x1x1.mdl" then return end
if ent:GetModel() == "models/phxtended/tri1x1x2.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x1.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x1x1.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x1x2.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x2.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x2x1.mdl" then return end
if ent:GetModel() == "models/phxtended/tri2x2x2.mdl" then return end
if ent:GetModel() == "models/phxtended/trieq1x1x1.mdl" then return end
if ent:GetModel() == "models/phxtended/trieq1x1x2.mdl" then return end
if ent:GetModel() == "models/phxtended/trieq2x2x1.mdl" then return end
if ent:GetModel() == "models/phxtended/trieq2x2x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_plate1x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_plate1x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_plate2x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_plate2x4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_plate4x4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_angle360.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_angle180.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_angle90.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_curve360x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_curve180x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_curve90x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_curve360x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_curve180x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_curve90x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_dome360.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_dome180.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/glass/glass_dome90.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window1x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window1x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window2x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window2x4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window4x4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_angle360.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_angle180.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_angle90.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_curve360x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_curve180x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_curve90x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_curve360x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_curve180x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_curve90x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_dome360.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_dome180.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/windows/window_dome90.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_boardx1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_boardx2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_boardx4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_panel1x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_panel1x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_panel2x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_panel2x4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_panel4x4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_angle360.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_angle180.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_angle90.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_curve360x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_curve180x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_curve90x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_curve360x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_curve180x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_curve90x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_dome360.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_dome180.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_dome90.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire1x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire1x1x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire1x2b.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire1x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire1x1x2b.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire1x1x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire2x2b.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire2x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire1x2x2b.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire2x2x2b.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire_angle360x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire_angle180x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire_angle90x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire_angle360x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire_angle180x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/wood/wood_wire_angle90x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel1x1.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel1x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel1x3.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel1x4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel1x8.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel2x2.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel2x3.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel2x4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel2x8.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel3x3.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel4x4.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel4x8.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_panel8x8.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_angle_360.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_angle_90.mdl" then return end
if ent:GetModel() == "models/props_phx/construct/plastic/plastic_angle_180.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x025x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x05x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x075x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x125x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x150x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x1x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x2x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x3x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x4x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x5x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x6x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x7x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube025x8x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x05x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x05x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x075x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x105x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x1x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x1x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x2x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x2x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x3x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x3x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x4x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x4x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x5x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x5x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x6x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x6x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x7x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x7x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x8x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube05x8x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x075x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x075x075.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x1x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x1x075.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x1x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x2x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x2x075.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x2x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x3x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x3x075.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x3x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x4x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x4x075.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x5x075.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x6x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x6x075.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x7x075.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x8x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube075x8x075.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube125x125x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube150x150x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x150x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x1x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x1x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x1x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x2x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x2x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x2x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x3x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x3x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x4x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x4x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x4x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x5x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x6x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x6x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x6x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x7x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x8x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x8x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube1x8x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x1x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x2x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x2x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x2x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x2x2.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x3x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x4x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x4x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x4x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x6x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x6x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x6x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x8x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x8x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube2x8x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube3x3x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube3x3x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube3x4x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube3x6x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube3x8x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x4x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x4x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x4x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x4x2.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x4x4.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x6x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x6x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x6x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x6x2.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x6x4.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x6x6.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x8x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x8x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube4x8x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube6x6x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube6x6x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube6x6x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube6x6x2.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube6x6x6.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube6x8x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube6x8x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube6x8x2.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube8x8x025.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube8x8x05.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube8x8x1.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube8x8x2.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube8x8x4.mdl" then return end
if ent:GetModel() == "models/hunter/blocks/cube8x8x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x025.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x05.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x075.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x1.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x125.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x150.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x175.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x2.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x3.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x4.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x5.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x6.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x7.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate025x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x05.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x05_rounded.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x075.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x1.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x2.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x3.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x4.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x5.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x6.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x7.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate05x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x075.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x1.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x105.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x2.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x3.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x4.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x5.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x6.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x7.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate075x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate125.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate150.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate16x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate16x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate16x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate175.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x1.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x2.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x3.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x3x1trap.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x4.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x4x2trap.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x4x2trap1.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x5.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x6.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x7.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate1x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate2.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate24x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate24x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate2x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate2x2.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate2x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate2x3.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate2x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate2x4.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate2x5.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate2x6.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate2x7.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate2x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate3.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate32x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate3x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate3x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate3x3.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate3x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate3x4.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate3x5.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate3x6.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate3x7.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate3x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate4.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate4x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate4x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate4x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate4x4.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate4x5.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate4x6.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate4x7.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate4x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate5.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate5x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate5x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate5x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate5x5.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate5x6.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate5x7.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate5x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate6.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate6x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate6x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate6x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate6x6.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate6x7.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate6x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate7.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate7x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate7x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate7x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate7x7.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate7x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate8x16.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate8x24.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate8x32.mdl" then return end
if ent:GetModel() == "models/hunter/plates/plate8x8.mdl" then return end
if ent:GetModel() == "models/hunter/plates/platehole1x1.mdl" then return end
if ent:GetModel() == "models/hunter/plates/platehole1x2.mdl" then return end
if ent:GetModel() == "models/hunter/plates/platehole2x2.mdl" then return end
if ent:GetModel() == "models/hunter/plates/platehole3.mdl" then return end
if ent:GetModel() == "models/hunter/plates/tri1x1.mdl" then return end
if ent:GetModel() == "models/hunter/plates/tri2x1.mdl" then return end
if ent:GetModel() == "models/hunter/plates/tri3x1.mdl" then return end
if ent:GetModel() == "models/hunter/geometric/hex025x1.mdl" then return end
if ent:GetModel() == "models/hunter/geometric/hex05x1.mdl" then return end
if ent:GetModel() == "models/hunter/geometric/hex1x05.mdl" then return end
if ent:GetModel() == "models/hunter/geometric/hex1x1.mdl" then return end
if ent:GetModel() == "models/hunter/geometric/para1x1.mdl" then return end
if ent:GetModel() == "models/hunter/geometric/pent1x1.mdl" then return end
if ent:GetModel() == "models/hunter/geometric/tri1x1eq.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/025x025.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/025x025mirrored.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/05x05.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/05x05mirrored.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/05x05x05.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/075x075.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/075x075mirrored.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x05x05.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x05x1.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1mirrored.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1x1.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1x1carved.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1x1carved025.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1x2.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1x2carved.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1x2carved025.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1x3.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1x4.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1x4carved.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1x4carved025.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/1x1x5.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/2x1x1.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/2x1x1carved.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/2x1x2carved.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/2x2.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/2x2mirrored.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/2x2x1.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/2x2x1carved.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/2x2x2.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/2x2x2carved.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/2x2x4carved.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/3x2x2.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/3x3.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/3x3mirrored.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/3x3x2.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/4x4.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/4x4mirrored.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/5x5.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/6x6.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/7x7.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/8x8.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/trapezium.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/trapezium3x3x1.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/trapezium3x3x1a.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/trapezium3x3x1b.mdl" then return end
if ent:GetModel() == "models/hunter/triangles/trapezium3x3x1c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/circle2x2.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/circle2x2b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/circle2x2c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/circle2x2d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/circle4x4.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/circle4x4b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/circle4x4c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/circle4x4d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x1.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x1b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x1c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x1d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x2.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x2b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x2c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x2d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x3.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x3b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x3c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x3d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x4.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x4b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x4c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x4d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x5.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x5b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x5c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x5d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x6.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x6b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x6c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x6d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x8.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x8b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x8c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube1x1x8d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x+.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x025.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x025b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x025c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x025d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x05.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x05b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x05c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x05d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x1.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x16d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x1b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x1c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x1d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x2.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x2b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x2c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x2d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x4.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x4b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x4c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x4d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x8.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x8b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x8c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2x8d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2xt.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2xta.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube2x2xtb.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x2x2.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x025.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x025b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x025c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x025d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x05.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x05b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x05c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x05d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x1.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x16.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x16b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x16c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x16d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x1b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x1c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x1d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x1to2x2.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x2.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x2b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x2c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x2d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x2to2x2.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x3.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x3b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x3c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x3d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x4.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x4b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x4c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x4d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x5.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x5b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x5c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x5d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x6.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x6b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x6c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x6d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x8.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x8b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x8c.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tube4x4x8d.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebend1x1x90.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebend1x2x90.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebend1x2x90a.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebend1x2x90b.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebend2x2x90.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebend2x2x90outer.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebend2x2x90square.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebend4x4x90.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebendinsidesquare.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebendinsidesquare2.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebendoutsidesquare.mdl" then return end
if ent:GetModel() == "models/hunter/tubes/tubebendoutsidesquare2.mdl" then return end
if ent:GetModel() == "models/hunter/misc/cone1x05.mdl" then return end
if ent:GetModel() == "models/hunter/misc/cone1x1.mdl" then return end
if ent:GetModel() == "models/hunter/misc/cone2x05.mdl" then return end
if ent:GetModel() == "models/hunter/misc/cone2x1.mdl" then return end
if ent:GetModel() == "models/hunter/misc/cone2x2.mdl" then return end
if ent:GetModel() == "models/hunter/misc/cone4x1.mdl" then return end
if ent:GetModel() == "models/hunter/misc/cone4x2.mdl" then return end
if ent:GetModel() == "models/hunter/misc/cone4x2mirrored.mdl" then return end
if ent:GetModel() == "models/hunter/misc/lift2x2.mdl" then return end
if ent:GetModel() == "models/hunter/misc/platehole1x1a.mdl" then return end
if ent:GetModel() == "models/hunter/misc/platehole1x1b.mdl" then return end
if ent:GetModel() == "models/hunter/misc/platehole1x1c.mdl" then return end
if ent:GetModel() == "models/hunter/misc/platehole1x1d.mdl" then return end
if ent:GetModel() == "models/hunter/misc/platehole4x4.mdl" then return end
if ent:GetModel() == "models/hunter/misc/platehole4x4b.mdl" then return end
if ent:GetModel() == "models/hunter/misc/platehole4x4c.mdl" then return end
if ent:GetModel() == "models/hunter/misc/platehole4x4d.mdl" then return end
if ent:GetModel() == "models/hunter/misc/roundthing1.mdl" then return end
if ent:GetModel() == "models/hunter/misc/roundthing2.mdl" then return end
if ent:GetModel() == "models/hunter/misc/roundthing3.mdl" then return end
if ent:GetModel() == "models/hunter/misc/roundthing4.mdl" then return end
if ent:GetModel() == "models/hunter/misc/shell2x2.mdl" then return end
if ent:GetModel() == "models/hunter/misc/shell2x2a.mdl" then return end
if ent:GetModel() == "models/hunter/misc/shell2x2b.mdl" then return end
if ent:GetModel() == "models/hunter/misc/shell2x2c.mdl" then return end
if ent:GetModel() == "models/hunter/misc/shell2x2d.mdl" then return end
if ent:GetModel() == "models/hunter/misc/shell2x2e.mdl" then return end
if ent:GetModel() == "models/hunter/misc/shell2x2x45.mdl" then return end
if ent:GetModel() == "models/hunter/misc/sphere025x025.mdl" then return end
if ent:GetModel() == "models/hunter/misc/sphere075x075.mdl" then return end
if ent:GetModel() == "models/hunter/misc/sphere175x175.mdl" then return end
if ent:GetModel() == "models/hunter/misc/sphere1x1.mdl" then return end
if ent:GetModel() == "models/hunter/misc/sphere2x2.mdl" then return end
if ent:GetModel() == "models/hunter/misc/sphere375x375.mdl" then return end
if ent:GetModel() == "models/hunter/misc/squarecap1x1x1.mdl" then return end
if ent:GetModel() == "models/hunter/misc/squarecap2x1x1.mdl" then return end
if ent:GetModel() == "models/hunter/misc/squarecap2x1x2.mdl" then return end
if ent:GetModel() == "models/hunter/misc/squarecap2x2x2.mdl" then return end
if ent:GetModel() == "models/hunter/misc/stair1x1.mdl" then return end
if ent:GetModel() == "models/hunter/misc/stair1x1inside.mdl" then return end
if ent:GetModel() == "models/hunter/misc/stair1x1outside.mdl" then return end
end 
	
	if ent:GetClass() == "projectile_portal_ball" then ent:SetPos(Vector(-500,-500,-500)) return end
	if ent:GetClass() == "projectile_portal_ball_atlas" then ent:SetPos(Vector(-500,-500,-500)) return end
	if ent:GetClass() == "projectile_portal_ball_pbody" then ent:SetPos(Vector(-500,-500,-500)) return end
	if ent:GetClass() == "projectile_portal_ball_guest" then ent:SetPos(Vector(-500,-500,-500)) return end
	if ent:GetClass() == "projectile_portal_ball_unknown" then ent:SetPos(Vector(-500,-500,-500)) return end
	
	
	if self:GetNWBool("Potal:Linked",false) == false or self:GetNWBool("Potal:Activated",false) == false then return end
	
	--ent:SetNWEntity("ImInPortal",self)
	
	if ent.InPortal then return end
	
	
	if ent:IsPlayer() then
		
		if not self:PlayerWithinBounds(ent) then return end
		
		ent.JustEntered = true
		self:PlayerEnterPortal(ent)
		
		
	elseif self:CanPort(ent) then
	
	local phys = ent:GetPhysicsObject()

		constraint.AdvBallsocket( ent, game.GetWorld(), 0, 0, Vector(0,0,0), Vector(0,0,0), 0, 0,  -180, -180, -180, 180, 180, 180,  0, 0, 1, 1, 1 )
		self:MakeClone(ent)
	end
end

function ENT:Touch( ent )
	if ent.InPortal != self then self:StartTouch(ent) end
	--if ent:IsPlayer() then return end
	if !self:CanPort(ent) then return end
	
	if self:GetNWBool("Potal:Linked",false) == false or self:GetNWBool("Potal:Activated",false) == false then return end
	
	local portal = self:GetNWEntity("Potal:Other")
	
	if portal and portal:IsValid() then
		
		if ent:IsPlayer() then
			-- if ent.JustPorted then ent.InPortal = self return end
			--If the player isn't actually in the portal
			if not ent.InPortal then
				if not self:PlayerWithinBounds(ent) then return end
				ent.JustEntered = true
				self:PlayerEnterPortal(ent)
				
			else
				ent:SetGroundEntity( self )
				local eyepos = ent:EyePos()
				if !IsBehind( eyepos, self:GetPos(), self:GetForward() ) then --if the players eyes are behind the portal, we do the end touch shit we need anyway
					self:DoPort(ent) --end the touch
					ent.AlreadyPorted = true
				end
			end
		else
			self:SyncClone(ent)
			ent:SetGroundEntity( NULL )
		end
		
	end
end

function ENT:PlayerEnterPortal(ent)
	umsg.Start( "Portal:ObjectInPortal" )
		umsg.Entity( self )
		umsg.Entity( ent )
	umsg.End()
	ent.InPortal = self
	
	self:SetupPlayerClone(ent)
	
	ent:GetPhysicsObject():EnableDrag(true)
	
	local vel = ent:GetVelocity()
	ent:SetMoveType(MOVETYPE_NOCLIP)
	ent:SetGroundEntity( self )
	-- print("noclipping")

	if ent.JustEntered then
if !snd_portal2:GetBool() then 
			ent:EmitSound("player/portal_enter"..math.random(1,2)..".wav",80,100 + (30 * (ent:GetVelocity():Length() - 450)/1000))
		else
			ent:EmitSound("player/portal2/portal_enter"..math.random(1,2)..".wav",80,100 + (30 * (ent:GetVelocity():Length() - 450)/1000))
end
		ent.JustEntered = false
			
for _, v in pairs( player.GetAll() ) do
   v:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 72 ) )
end
	end
end

function ENT:SetupPlayerClone(ply)
	if not ply.PortalClone then
		local ed = ents.Create("PortalPlayerClone")
		ed:SetEnt(ply)
		ed:SetPortal(self)
		ed:SetModel(ply:GetModel())
		ed:Spawn()
		ply.PortalClone = ed
	else
		ply.PortalClone:SetPortal(self)
	end
	
end

function ENT:EndTouch(ent)
	if ent.AlreadyPorted then
		ent.AlreadyPorted = false
	else
		self:DoPort(ent)
	end
	
end

function ENT:DoPort(ent) --Shared so we can predict it.

	if !self:CanPort(ent) then return end
	if !ent or !ent:IsValid() then return end
	if SERVER then
		constraint.RemoveConstraints(ent, "AdvBallsocket")
	end
		
	if self:GetNWBool("Potal:Linked",false) == false or self:GetNWBool("Potal:Activated",false) == false then return end
	
	if SERVER then
		umsg.Start( "Portal:ObjectLeftPortal" )
		umsg.Entity( ent )
		umsg.End()
	end

	local portal = self:GetNWEntity("Potal:Other")
	
	--Mahalis code
	local vel = ent:GetVelocity()
	if !vel then return end
	-- vel = vel - 2*vel:Dot(self:GetAngles():Up())*self:GetAngles():Up()
	local nuVel = self:TransformOffset(vel,self:GetAngles(),portal:GetAngles()) * -1
	
	local phys = ent:GetPhysicsObject()
	
	if portal and portal:IsValid() and phys:IsValid() and ent.clone and ent.clone:IsValid() and !ent:IsPlayer() then
		if !IsBehind( ent:GetPos(), self:GetPos(), self:GetForward() ) then
			ent:SetPos(ent.clone:GetPos())
			ent:SetAngles(ent.clone:GetAngles())
			phys:SetVelocity(nuVel)
		end
		
		
		ent.InPortal = nil

		ent.clone:Remove()
		ent.clone = nil
	elseif ent:IsPlayer() then
		local eyepos = ent:EyePos()
		
		if !IsBehind( eyepos, self:GetPos(), self:GetForward() ) then
			local newPos = self:GetPortalPosOffsets(portal,ent)
			
			ent:SetHeadPos(newPos)
			
			if portal:OnFloor() and self:OnFloor() then --pop players out of floor portals.
				if nuVel:Length() < 340 then
					nuVel = portal:GetForward() * 340
				end
			elseif portal:OnFloor() then
				if nuVel:Length() < 350 then
					nuVel = portal:GetForward() * 350
				end
			elseif portal:OnRoof() and (not portal:IsHorizontal()) then -- fixed velocity length of roofs portals
				if nuVel:Length() > vel_roof_max:GetInt() then
					nuVel = portal:GetForward() * vel_roof_max:GetInt()
				end
			elseif (not portal:IsHorizontal()) and (not portal:OnRoof()) then --pop harder for diagonals.
				if nuVel:Length() < 300 then
					nuVel = portal:GetForward() * 300
				end
			end
			
			-- print("Velocity Length:", nuVel:Length())
			-- print("Old Velocity:", ent:GetVelocity())
			-- print("New Velocity:", nuVel)
			ent:SetLocalVelocity(nuVel)
			
			--local newang = math.VectorAngles(ent:GetForward(), ent:GetUp()) + Angle(0,180,0) + (portal:GetAngles() - self:GetAngles())
			local newang = self:GetPortalAngleOffsets(portal,ent)
			ent:SetEyeAngles(newang)
			
	
			ent.JustEntered = false
			ent.JustPorted = true
			portal:PlayerEnterPortal(ent)
		elseif ent.InPortal == self then
			ent.InPortal = nil
			
-- Fixed Portals Roofs
			
			ent:SetMoveType(MOVETYPE_FLY)
-- print("MOVETYPE_FLY")

timer.Create( "Walk", 0.05, 1, function()
ent:SetMoveType(MOVETYPE_WALK)
for _, v in pairs( player.GetAll() ) do
   v:ResetHull()
end
-- print("MOVETYPE_WALK")
end)
			
			
			if SERVER then
if !snd_portal2:GetBool() then 
			ent:EmitSound("player/portal_exit"..math.random(1,2)..".wav",80,100 + (30 * (nuVel:Length() - 450)/1000))
		else
			ent:EmitSound("player/portal2/portal_exit"..math.random(1,2)..".wav",80,100 + (30 * (nuVel:Length() - 450)/1000))
end
			end
			
			ent.PortalClone:Remove()
			ent.PortalClone = nil
			--print("Walking")
		end
	end
end

local function BulletHook(ent,bullet)
	if ent.FiredBullet then return end
	--Test if the bullet hits the portal.
	for k,inport in pairs(ents.FindByClass("prop_portal_atlas")) do --fix fake portal positions.
		if inport:OnFloor() then
			inport:SetPos(inport:GetPos()-Vector(0,0,20))
		end
	end
	
	for i=1, bullet.Num do
		local tr = util.QuickTrace(bullet.Src, bullet.Dir*10000, ent)
		
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "prop_portal_atlas" then
			local inport = tr.Entity
			
			if inport:GetNWBool("Potal:Linked",false) == false or inport:GetNWBool("Potal:Activated",false) == false then return end
			
			local outport = inport:GetNWEntity("Potal:Other")
			if !IsValid(outport) then return end
			
			--Create our new bullet and get the hit pos of the inportal.
			local newbullet = table.Copy(bullet)
			
			if inport:OnFloor() and outport:OnFloor() then
				outport:SetPos(outport:GetPos() + Vector(0,0,20))
			end
			
			local offset = inport:WorldToLocal(tr.HitPos + bullet.Dir*20)
			
			offset.x = -offset.x;
			offset.y = -offset.y;
			
			--Correct bullet angles.
			local ang = bullet.Dir
			ang = inport:TransformOffset(ang,inport:GetAngles(),outport:GetAngles()) * -1
			newbullet.Dir = ang
			
			--Transfer to new portal.
			newbullet.Src = outport:LocalToWorld( offset ) + ang*10
			
			
			 umsg.Start("DebugOverlay_LineTrace")
				 umsg.Vector(bullet.Src)
				 umsg.Vector(tr.HitPos)
				 umsg.Bool(true)
			 umsg.End()
			 local p1 = util.QuickTrace(newbullet.Src,ang*10000,{outport,inport})
			 umsg.Start("DebugOverlay_LineTrace")
				 umsg.Vector(newbullet.Src)
				 umsg.Vector(p1.HitPos)
				 umsg.Bool(false)
			 umsg.End()
			
			newbullet.Attacker = ent
			outport.FiredBullet = true --prevent infinite loop.
			outport:FireBullets(newbullet)		
			outport.FiredBullet = false
			
			if inport:OnFloor() and outport:OnFloor() then
				outport:SetPos(outport:GetPos() - Vector(0,0,20))
			end
			
		end
	end
	for k,inport in pairs(ents.FindByClass("prop_portal_atlas")) do
		if inport:OnFloor() then
			inport:SetPos(inport:GetPos()+Vector(0,0,20))
		end
	end
end
hook.Add("EntityFireBullets", "BulletPorting ATLAS", BulletHook)

function ENT:SetActivatedState(bool)
	self.Activated = bool
	self:SetNWBool("Potal:Activated",bool)
	
	local other = self:FindOpenPair()
	if other and other:IsValid() then
		self:LinkPortals(other)
	end
end

function ENT:FindOpenPair() --This is for singeplayer, it finds a portal that is of the same type.
	local portals = ents.FindByClass( "prop_portal_atlas" );
	local mycolor = self:GetNWInt("Potal:PortalType",nil)
	local othercolor
	for k, v in pairs( portals ) do
		othercolor = v:GetNWInt("Potal:PortalType",nil)
		if v:GetNWBool("Potal:Activated",false) == true and v != self and othercolor and mycolor and othercolor != mycolor then
			return v
		end
	end
	return nil
end

function ENT:AcceptInput(name) --Map inputs (Seems to work..)
 
	if (name == "Fizzle") then
		self.Activated = false
		self:SetNWBool("Potal:Activated",false)
		self:CleanMeUp()
	end 
	
	if (name == "SetActivatedState") then
		self:SetActivatedState(true)
	end
 
end

function ENT:KeyValue( key, value ) --Map keyvalues

	self.KeyValues[key] = value
	
	if key == "LinkageGroupID" then --I don't think this does jack shit, but it was on the valve wiki..
		self:SetNWInt("Potal:LinkageGroupID",value)
	end
	
	if key == "Activated" then --Set if it should start activated or not..
		self.Activated = tobool(value)
		self:SetNWBool("Potal:Activated",tobool(value))
	end
	
	if key == "PortalTwo" then --Sets the portal type
		self:SetType( value+1 )
	end
	
end

--Jintos code..
function math.VectorAngles( forward, up )

	local angles = Angle( 0, 0, 0 );

	local left = up:Cross( forward );
	left:Normalize();
	
	local xydist = math.sqrt( forward.x * forward.x + forward.y * forward.y );
	
	// enough here to get angles?
	if( xydist > 0.001 ) then
	
		angles.y = math.deg( math.atan2( forward.y, forward.x ) );
		angles.p = math.deg( math.atan2( -forward.z, xydist ) );
		angles.r = math.deg( math.atan2( left.z, ( left.y * forward.x ) - ( left.x * forward.y ) ) );

	else
	
		angles.y = math.deg( math.atan2( -left.x, left.y ) );
		angles.p = math.deg( math.atan2( -forward.z, xydist ) );
		angles.r = 0;
	
	end

	return angles;
	
end

hook.Add("SetupPlayerVisibility ATLAS", "Add portalPVS ATLAS", function(ply,ve)
	for k,self in pairs(ents.FindByClass("prop_portal_atlas"))do
		if not IsValid(self) then continue end
		local other = self:GetNWEntity("Potal:Other")
		if (not other) or (not IsValid(other)) then continue end
		local origin = ply:EyePos()
		local angles = ply:EyeAngles()
		
		local normal = self:GetForward()
		local distance = normal:Dot( self:GetPos() )

		// quick access
		local forward = angles:Forward()
		local up = angles:Up()

		// reflect origin
		local dot = origin:DotProduct( normal ) - distance
		origin = origin + ( -2 * dot ) * normal

		// reflect forward
		local dot = forward:DotProduct( normal )
		forward = forward + ( -2 * dot ) * normal

		// reflect up          
		local dot = up:DotProduct( normal )
		up = up + ( -2 * dot ) * normal
		
		local ViewOrigin = self:WorldToLocal( origin )
	   
		// repair
		ViewOrigin.y = -ViewOrigin.y
		
		ViewOrigin = other:LocalToWorld( ViewOrigin )
		-- if self:GetNWInt("Potal:PortalType") == TYPE_ORANGE_ATLAS then
			-- umsg.Start("DebugOverlay_Cross")
				-- umsg.Vector(ViewOrigin)
				-- umsg.Bool(true)
			-- umsg.End()
		-- end
		-- AddOriginToPVS(ViewOrigin)
		
		AddOriginToPVS(self:GetPos()+self:GetForward()*20)
	end
end)

concommand.Add("CreateParticles", function(p,c,a)
	local name = a[1]
	local ang = p:GetAngles()
	ang:RotateAroundAxis(p:GetRight(),90)
	ang:RotateAroundAxis(p:GetForward(),90)
	ParticleEffect(name,p:EyePos()+p:GetForward()*100,ang, (a[2] == 1 and self or nil))
end)

function ENT:OnRemove()
	for k,v in pairs(ents.GetAll())do
		if v.InPortal == self then
			umsg.Start( "Portal:ObjectLeftPortal" )
			umsg.Entity( ent )
			umsg.End()
			v.InPortal = false
		end
	end
end