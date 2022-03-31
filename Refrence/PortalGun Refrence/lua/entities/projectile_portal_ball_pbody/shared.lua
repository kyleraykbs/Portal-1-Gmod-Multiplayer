AddCSLuaFile("shared.lua")

if CLIENT then
	game.AddParticles("particles/cleansers.pcf")
end

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Portal Ball"
ENT.Author = "Mahalis"
ENT.Spawnable = false
ENT.AdminSpawnable = false

		useInstant = CreateConVar("portal_instant", 0, {FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE}, "Make portals create instantly and don't use the projectile.")
		ballEnable = CreateConVar("portal_projectile_ball","1",true,false)

function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetModel("models/hunter/misc/sphere025x025.mdl")
	self.Entity:PhysicsInitSphere(1,"Metal")
	local phy = self.Entity:GetPhysicsObject()
	if phy:IsValid() then
		phy:EnableGravity(false)
		phy:EnableDrag(false)
		phy:EnableCollisions(false)
	end
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Entity:DrawShadow(false)
	self:SetNoDraw(false)
	timer.Simple(.01,function() if self:IsValid() then self:SetNoDraw(true) end end)
	

end

function ENT:SetEffects(type)
	self:SetNWInt("Kind", type)

if ballEnable:GetBool() then 
if !useInstant:GetBool() then 

	if type == TYPE_BLUE_PBODY then
if GetConVarNumber("portal_color_PBODY_1") >=14 then
	ParticleEffectAttach("portal_gray_projectile_ball",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=13 then
	ParticleEffectAttach("portal_gray_projectile_ball",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=12 then
	ParticleEffectAttach("portal_gray_projectile_ball",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=11 then
	ParticleEffectAttach("portal_2_projectile_ball_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=10 then
	ParticleEffectAttach("portal_2_projectile_ball_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=9 then
	ParticleEffectAttach("portal_2_projectile_ball_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=8 then
	ParticleEffectAttach("portal_2_projectile_ball_atlas",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=7 then
	ParticleEffectAttach("portal_1_projectile_ball",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=6 then
	ParticleEffectAttach("portal_1_projectile_ball_atlas",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=5 then
	ParticleEffectAttach("portal_1_projectile_ball_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=4 then
	ParticleEffectAttach("portal_1_projectile_ball_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=3 then
	ParticleEffectAttach("portal_1_projectile_ball_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=2 then
	ParticleEffectAttach("portal_1_projectile_ball_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=1 then
	ParticleEffectAttach("portal_2_projectile_ball",PATTACH_ABSORIGIN_FOLLOW,self,1)
else
	ParticleEffectAttach("portal_2_projectile_ball_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
end
		elseif type == TYPE_ORANGE_PBODY then
if GetConVarNumber("portal_color_PBODY_2") >=14 then
	ParticleEffectAttach("portal_gray_projectile_ball",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=13 then
	ParticleEffectAttach("portal_gray_projectile_ball",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=12 then
	ParticleEffectAttach("portal_gray_projectile_ball",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=11 then
	ParticleEffectAttach("portal_2_projectile_ball_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=10 then
	ParticleEffectAttach("portal_2_projectile_ball_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=9 then
	ParticleEffectAttach("portal_2_projectile_ball_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=8 then
	ParticleEffectAttach("portal_2_projectile_ball_atlas",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=7 then
	ParticleEffectAttach("portal_1_projectile_ball",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=6 then
	ParticleEffectAttach("portal_1_projectile_ball_atlas",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=5 then
	ParticleEffectAttach("portal_1_projectile_ball_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=4 then
	ParticleEffectAttach("portal_1_projectile_ball_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=3 then
	ParticleEffectAttach("portal_1_projectile_ball_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=2 then
	ParticleEffectAttach("portal_1_projectile_ball_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=1 then
	ParticleEffectAttach("portal_2_projectile_ball",PATTACH_ABSORIGIN_FOLLOW,self,1)
else
	ParticleEffectAttach("portal_2_projectile_ball_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
end
	end

end
	
	if type == TYPE_BLUE_PBODY then
if GetConVarNumber("portal_color_PBODY_1") >=14 then
	ParticleEffectAttach("portal_gray_projectile_fiber",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=13 then
	ParticleEffectAttach("portal_gray_projectile_fiber",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=12 then
	ParticleEffectAttach("portal_gray_projectile_fiber",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=11 then
	ParticleEffectAttach("portal_2_projectile_fiber_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=10 then
	ParticleEffectAttach("portal_2_projectile_fiber_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=9 then
	ParticleEffectAttach("portal_2_projectile_fiber_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=8 then
	ParticleEffectAttach("portal_2_projectile_fiber_atlas",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=7 then
	ParticleEffectAttach("portal_1_projectile_fiber",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=6 then
	ParticleEffectAttach("portal_1_projectile_fiber_atlas",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=5 then
	ParticleEffectAttach("portal_1_projectile_fiber_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=4 then
	ParticleEffectAttach("portal_1_projectile_fiber_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=3 then
	ParticleEffectAttach("portal_1_projectile_fiber_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=2 then
	ParticleEffectAttach("portal_1_projectile_fiber_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_1") >=1 then
	ParticleEffectAttach("portal_2_projectile_fiber",PATTACH_ABSORIGIN_FOLLOW,self,1)
else
	ParticleEffectAttach("portal_2_projectile_fiber_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
end
		elseif type == TYPE_ORANGE_PBODY then
if GetConVarNumber("portal_color_PBODY_2") >=14 then
	ParticleEffectAttach("portal_gray_projectile_fiber",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=13 then
	ParticleEffectAttach("portal_gray_projectile_fiber",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=12 then
	ParticleEffectAttach("portal_gray_projectile_fiber",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=11 then
	ParticleEffectAttach("portal_2_projectile_fiber_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=10 then
	ParticleEffectAttach("portal_2_projectile_fiber_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=9 then
	ParticleEffectAttach("portal_2_projectile_fiber_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=8 then
	ParticleEffectAttach("portal_2_projectile_fiber_atlas",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=7 then
	ParticleEffectAttach("portal_1_projectile_fiber",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=6 then
	ParticleEffectAttach("portal_1_projectile_fiber_atlas",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=5 then
	ParticleEffectAttach("portal_1_projectile_fiber_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=4 then
	ParticleEffectAttach("portal_1_projectile_fiber_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=3 then
	ParticleEffectAttach("portal_1_projectile_fiber_pink_green",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=2 then
	ParticleEffectAttach("portal_1_projectile_fiber_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
elseif GetConVarNumber("portal_color_PBODY_2") >=1 then
	ParticleEffectAttach("portal_2_projectile_fiber",PATTACH_ABSORIGIN_FOLLOW,self,1)
else
	ParticleEffectAttach("portal_2_projectile_fiber_pbody",PATTACH_ABSORIGIN_FOLLOW,self,1)
end
	end
	end
end

function ENT:GetKind(kind)
	return self:GetNWInt("Kind", TYPE_BLUE_PBODY)
end
function ENT:SetGun(ent)
	self.gun = ent
end
function ENT:GetGun()
	return self.gun
end

function ENT:PhysicsCollide(data,phy)
	-- self.Entity:Remove()
	-- print("Create Portal!")
end


function ENT:Draw()

end
