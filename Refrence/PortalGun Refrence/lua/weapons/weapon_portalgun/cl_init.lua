include("shared.lua")

local reticle = CreateClientConVar("portal_crosshair","1",true,false)
local system = CreateClientConVar("portal_crosshair_system","1",true,false)
local portalonly = CreateClientConVar("portal_portalonly","0",true,false)
local allsurfaces = CreateClientConVar("portal_allsurfaces","0",true,false)
local snd_portal2 = CreateClientConVar("portal_sound","0",true,false)
local CarryAnim_P1 = CreateClientConVar("portal_carryanim_p1","0",true,false)
local drawArm = CreateClientConVar("portal_arm","0",true,false)

local VElements = {
	["BodyLight"] = { type = "Sprite", sprite = "sprites/portalgun_light", bone = "ValveBiped.Base", rel = "", pos = Vector(0.25, -5.45, 10.5), size = { x = 0.0165, y = 0.0165 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BodyLight1"] = { type = "Sprite", sprite = "sprites/portalgun_light", bone = "ValveBiped.Base", rel = "", pos = Vector(0.25, -5.45, 10.5), size = { x = 0.0165, y = 0.0165 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BodyLight2"] = { type = "Sprite", sprite = "sprites/portalgun_light", bone = "ValveBiped.Base", rel = "", pos = Vector(0.25, -5.45, 10.5), size = { x = 0.0165, y = 0.0165 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BodyLight3"] = { type = "Sprite", sprite = "sprites/portalgun_light", bone = "ValveBiped.Base", rel = "", pos = Vector(0.25, -5.45, 10.5), size = { x = 0.0165, y = 0.0165 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BodyLight4"] = { type = "Sprite", sprite = "sprites/portalgun_light", bone = "ValveBiped.Base", rel = "", pos = Vector(0.25, -5.45, 10.5), size = { x = 0.0165, y = 0.0165 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BodyLight5"] = { type = "Sprite", sprite = "sprites/portalgun_light", bone = "ValveBiped.Base", rel = "", pos = Vector(0.25, -5.45, 10.5), size = { x = 0.0165, y = 0.0165 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BeamPoint1"] = { type = "Sprite", sprite = "sprites/portalgun_effects", bone = "ValveBiped.Front_Cover", rel = "", pos = Vector(-0.101, -2.401, -3.1), size = { x = 0.035, y = 0.035 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BeamPoint2"] = { type = "Sprite", sprite = "sprites/portalgun_effects", bone = "ValveBiped.Front_Cover", rel = "", pos = Vector(-0.01, -2.391, -3.401), size = { x = 0.035, y = 0.035 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BeamPoint3"] = { type = "Sprite", sprite = "sprites/portalgun_effects", bone = "ValveBiped.Front_Cover", rel = "", pos = Vector(-0.03, -2.381, -3.701), size = { x = 0.035, y = 0.035 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BeamPoint4"] = { type = "Sprite", sprite = "sprites/portalgun_effects", bone = "ValveBiped.Front_Cover", rel = "", pos = Vector(-0.04, -2.36, -4), size = { x = 0.035, y = 0.035 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BeamPoint5"] = { type = "Sprite", sprite = "sprites/portalgun_effects", bone = "ValveBiped.Front_Cover", rel = "", pos = Vector(-0.051, -2.35, -4.301), size = { x = 0.035, y = 0.035 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["InsideEffects"] = { type = "Sprite", sprite = "sprites/portalgun_effects", bone = "ValveBiped.Front_Cover", rel = "", pos = Vector(0, -2.201, 0), size = { x = 0.035, y = 0.035 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
}

local WElements = {
	["BodyLight"] = { type = "Sprite", sprite = "sprites/portalgun_light", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7, 1.40, -4.801), size = { x = 0.03, y = 0.03 }, color = Color(255, 255, 255, 255), nocull = false, additive = fal, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BeamPoint1"] = { type = "Sprite", sprite = "sprites/portalgun_effects", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.647, 1.32, -2.596), size = { x = 0.04, y = 0.04 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BeamPoint2"] = { type = "Sprite", sprite = "sprites/portalgun_effects", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.744, 1.32, -2.754), size = { x = 0.04, y = 0.04 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BeamPoint3"] = { type = "Sprite", sprite = "sprites/portalgun_effects", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.845, 1.32, -2.915), size = { x = 0.04, y = 0.04 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["BeamPoint4"] = { type = "Sprite", sprite = "sprites/portalgun_effects", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(20.034, 1.161, -3.934), size = { x = 0.04, y = 0.04 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["InsideEffects"] = { type = "Sprite", sprite = "sprites/portalgun_effects", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.048, 1.32, -2.997), size = { x = 0.04, y = 0.04 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
}



local ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(0.0001, 0.0001, 0.0001), pos = Vector(-30, 0, 0), angle = Angle(0, 0, 0) }
}


local BobTime = 0
local BobTimeLast = CurTime()

local SwayAng = nil
local SwayOldAng = Angle()
local SwayDelta = Angle()

SWEP.DrawWeaponInfoBox	= false					// Should draw the weapon info box
SWEP.BounceWeaponIcon   = false					// Should the weapon icon bounce?

local tblFonts = { }
tblFonts["WeaponIcons_lua"] = {
	font = "HalfLife2",
	size = ScreenScale(50),
	weight = 550,
	symbol = false,
	antialias = true,
	additive = true
}

tblFonts["WeaponIconsSelected_lua"] = {
	font = "HalfLife2",
	size = ScreenScale(50),
	weight = 550,
	blursize = 7,
	scanlines = 3,
	symbol = false,
	antialias = true,
	additive = true
}

for k,v in SortedPairs( tblFonts ) do
	surface.CreateFont( k, tblFonts[k] );

	--print( "Added font '"..k.."'" );
end

/*---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------*/


function SWEP:Initialize()

	self.Weapon:SetNetworkedInt("LastPortal",0,true)
	self:SetWeaponHoldType( self.HoldType )


	// Create a new table for every weapon instance
	self.VElements = table.FullCopy( VElements )
	self.WElements = table.FullCopy( WElements )
	self.ViewModelBoneMods = table.FullCopy( ViewModelBoneMods )
	
	// init view model bone build function
	if IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
			
			// Init viewmodel visibility
			if (self.ShowViewModel == nil or self.ShowViewModel) then
				vm:SetColor(Color(255,255,255,255))
			else
				// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
				vm:SetColor(Color(255,255,255,1))
				// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
				// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
				vm:SetMaterial("Debug/hsv")			
			end
		end
	end
	

end

net.Receive( 'PORTALGUN_PICKUP_PROP', function()
	local self = net.ReadEntity()
	local ent = net.ReadEntity()
	
	if !IsValid( ent ) then
		--Drop it.
		if self.PickupSound then
			self.PickupSound:Stop()
			self.PickupSound2:Stop()
			self.PickupSoundStop = CreateSound( self, 'weapons/physcannon/portal2/hold_loop_stop.wav' )
if snd_portal2:GetBool() then 
self.PickupSoundStop:Play()
end
			self.PickupSound = nil
		end
		if self.ViewModelOverride then
			self.ViewModelOverride:Remove()
		end
	else
		--Pick it up.
		if !self.PickupSound and CLIENT then
		self.PickupSound = CreateSound( self, 'weapons/physcannon/hold_loop.wav' )
		self.PickupSound2 = CreateSound( self, 'weapons/physcannon/portal2/hold_loop.wav' )
if !snd_portal2:GetBool() then 
			self.PickupSound:Play()
		else
			self.PickupSound2:Play()
end
			self.PickupSound:ChangeVolume( 0.25, 0 )
			self.PickupSound2:ChangeVolume( 100, 0 )
		end
		
		-- self.ViewModelOverride = true
		
		self.ViewModelOverride = ClientsideModel(self.ViewModel,RENDERGROUP_OPAQUE)
		self.ViewModelOverride:SetPos(EyePos()-LocalPlayer():GetForward()*(self.ViewModelFOV/5))
		self.ViewModelOverride:SetAngles(EyeAngles())
		self.ViewModelOverride.AutomaticFrameAdvance = true
		self.ViewModelOverride.startCarry = false
		-- self.ViewModelOverride:SetParent(self.Owner)
		function self.ViewModelOverride.PreDraw(vm)
			vm:SetColor(Color(255,255,255))
			local oldorigin = EyePos() -- -EyeAngles():Forward()*10
			local pos, ang = self:CalcViewModelView(vm,oldorigin,EyeAngles(),vm:GetPos(),vm:GetAngles())
			return pos, ang
		end
		
	end
	
	self.HoldenProp = ent
end )


local GravityLight,GravityBeam = Material("sprites/grav_flare"),Material("sprites/grav_beam","unlitgeneric")
local GravitySprites = {
	{bone = "ValveBiped.Arm1_C", pos = Vector(-1.25 ,-0.10, 1.06), size = { x = 0.02, y = 0.02 }},
	{bone = "ValveBiped.Arm2_C", pos = Vector(0.10, 1.25, 1.00), size = { x = 0.02, y = 0.02 }},
	{bone = "ValveBiped.Arm3_C", pos = Vector(0.10, 1.25, 1.05), size = { x = 0.02, y = 0.02 }}
}
function SWEP:DrawPickupEffects(ent)
	
	//Draw the lights
	local lightOrigins = {}
	for k,v in pairs(GravitySprites) do
		local bone = ent:LookupBone(v.bone)

		if (!bone) then return end
		
		local pos, ang = Vector(0,0,0), Angle(0,0,0)
		local m = ent:GetBoneMatrix(bone)
		if (m) then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end
		
		if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
			ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
			ang.r = -ang.r // Fixes mirrored models
		end
			
		if (!pos) then continue end
		
		local col = Color(255, 255, 255, math.Rand(96,128))
		local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
		local _sin = math.abs( math.sin( CurTime() * ( 0.1 ) * math.Rand(1,3))); //math.sinwave( 25, 3, true )
		
		render.SetMaterial(GravityLight)
		render.DrawSprite(drawpos, v.size.x*128+_sin, v.size.y*128+_sin, col)
		
		lightOrigins[k] = drawpos
			
	end
	
	
	//Draw the beams and center sprite.
	local bone = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Front_Cover")) 
	local endpos,ang = bone:GetTranslation(),bone:GetAngles()
	local _sin = math.abs( math.sin( 1+CurTime( ) * 3 ) ) * 1
	endpos = endpos + ang:Up()*6 + ang:Right()*-1.8
	
	render.DrawSprite(endpos, 5+_sin, 5+_sin, col)
	
local dir = ( endpos - lightOrigins[1] );
local dir2 = ( endpos - lightOrigins[2] );
local dir3 = ( endpos - lightOrigins[3] );
local increment = dir:Length() / 2;
local increment2 = dir2:Length() / 2;
local increment3 = dir2:Length() / 2;
dir:Normalize()
dir2:Normalize()
dir3:Normalize()
 

render.SetMaterial( GravityBeam );

-- 1 Beam

render.StartBeam( 3 )

render.AddBeam(lightOrigins[1], 0.5, CurTime() + ( 1 / 10 ), Color( 255, 255, 255, 255 ))
 
local i;
for i = 1, 20 do
	local point = ( lightOrigins[1] + dir * ( i * increment ) ) + VectorRand() * math.random( 0.1, 1 );
 
	local tcoord = CurTime() + ( 20 / 50 ) * i;
 
	render.AddBeam(point, 2, tcoord, Color( 255, 255, 255, 255 ))
	
end

render.AddBeam(endpos, 0, CurTime() + ( 1 / 10 ), Color( 255, 255, 255, 255 ))

render.EndBeam()

-- 2 Beam

render.StartBeam( 3 )

render.AddBeam(lightOrigins[2], 0.5, CurTime() + ( 1 / 10 ), Color( 255, 255, 255, 255 ))
 
local i;
for i = 1, 20 do
	local point = ( lightOrigins[2] + dir2 * ( i * increment2 ) ) + VectorRand() * math.random( 0.1, 1 );
 
	local tcoord = CurTime() + ( 20 / 50 ) * i;
 
	render.AddBeam(point, 2, tcoord, Color( 255, 255, 255, 255 ))
	
end

render.AddBeam(endpos, 0, CurTime() + ( 1 / 10 ), Color( 255, 255, 255, 255 ))

render.EndBeam()

-- 3 Beam

-- render.StartBeam( 3 )

-- render.AddBeam(lightOrigins[3], 0.5, CurTime() + ( 1 / 10 ), Color( 255, 255, 255, 255 ))
 
-- local i;
-- for i = 1, 20 do
--	local point = ( lightOrigins[3] + dir3 * ( i * increment3 ) ) + VectorRand() * math.random( 0.1, 1 );
 
--	local tcoord = CurTime() + ( 20 / 50 ) * i;
 
--	render.AddBeam(point, 2, tcoord, Color( 255, 255, 255, 255 ))
	
-- end

-- render.AddBeam(endpos, 0, CurTime() + ( 1 / 10 ), Color( 255, 255, 255, 255 ))

-- render.EndBeam()

end

function SWEP:DoPickupAnimations(vm)
	-- local toIdle = vm:LookupSequence("carrying_to_idle")
	local toCarry, toCarryLength = vm:LookupSequence("carrying_to_idle")
	local carry, carryLength = vm:LookupSequence("idle_carrying")
	
	local toCarry_P1, toCarryLength_P1 = vm:LookupSequence("carrying_to_idle_p1")
	local carry_P1, carryLength_P1 = vm:LookupSequence("idle_carrying_p1")
	
if CarryAnim_P1:GetBool() then 
	if not vm.StartCarry then
		vm.StartCarry = CurTime() + (carryLength_P1/10)
		vm:SetSequence(toCarry_P1)
	elseif CurTime() > vm.StartCarry then
		vm:SetSequence(carry_P1)
	end
		else
	if not vm.StartCarry then
		vm.StartCarry = CurTime() + (toCarryLength/10)
		vm:SetSequence(toCarry)
	elseif CurTime() > vm.StartCarry then
		vm:SetSequence(carry)
	end
end
	
end

hook.Add("HUDPaint", "View model pickup override", function(vm)
	local weapon = LocalPlayer():GetActiveWeapon()
	if CLIENT and IsValid(weapon.ViewModelOverride) then
		cam.Start3D(EyePos(),EyeAngles(),weapon.ViewModelFOV+10)
			local pos,ang = weapon.ViewModelOverride:PreDraw()
			render.SetColorModulation(1,1,1,0)
			render.Model({pos=pos,angle=ang,model=weapon.ViewModel},weapon.ViewModelOverride)
			weapon:ViewModelDrawn(weapon.ViewModelOverride)
			weapon:DoPickupAnimations(weapon.ViewModelOverride)
			weapon:DrawPickupEffects(weapon.ViewModelOverride)
		cam.End3D()
	end
end)


local VGravityLight = Material("sprites/glow04_noz")

local VGravitySprites = {
	{bone = "ValveBiped.Arm1_A", pos = Vector(0, 0, 0), size = { x = 0.018, y = 0.018 }},
	{bone = "ValveBiped.Arm2_A", pos = Vector(0, 0, 0), size = { x = 0.018, y = 0.018 }},
	{bone = "ValveBiped.Arm3_A", pos = Vector(0, 0, 0.30), size = { x = 0.018, y = 0.018 }},
	{bone = "ValveBiped.Arm1_B", pos = Vector(0, 0, 0), size = { x = 0.018, y = 0.018 }},
	{bone = "ValveBiped.Arm2_B", pos = Vector(0, 0.20, -0.10), size = { x = 0.018, y = 0.018 }},
	{bone = "ValveBiped.Arm3_B", pos = Vector(-0.10, 0.30, -0.10), size = { x = 0.018, y = 0.018 }},	
}

local VWhiteLight = Material("sprites/glow04_noz")

local VWhiteSprites = {
	{bone = "ValveBiped.Base", pos = Vector(0.25, -5.45, 10.5), size = { x = 0.003, y = 0.003 }},	
	{bone = "ValveBiped.Base", pos = Vector(0.25, -5.45, 10.5), size = { x = 0.003, y = 0.003 }},	
}

function SWEP:ViewModelDrawn(vm)

	//Draw the lights
	local lightOrigins = {}
	for k,v in pairs(VGravitySprites) do
		local bone = vm:LookupBone(v.bone)

		if (!bone) then return end
		
		local pos, ang = Vector(0,0,0), Angle(0,0,0)
		local m = vm:GetBoneMatrix(bone)
		if (m) then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end
		
		if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
			vm == self.Owner:GetViewModel() and self.ViewModelFlip) then
			ang.r = -ang.r // Fixes mirrored models
		end
			
		if (!pos) then continue end
		
		local col = Color(255, 128, 0, math.Rand(10,24))
		local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
		local _sin = math.abs( math.sin( CurTime() * ( 0.1 ) * math.Rand(0.0075,0.05 )))

		render.SetMaterial(VGravityLight)
		render.DrawSprite(drawpos, v.size.x*128+_sin, v.size.y*128+_sin, col)
		end

	for k,v in pairs(VWhiteSprites) do
		local bone = vm:LookupBone(v.bone)

		if (!bone) then return end
		
		local pos, ang = Vector(0,0,0), Angle(0,0,0)
		local m = vm:GetBoneMatrix(bone)
		if (m) then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end
		
		if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
			vm == self.Owner:GetViewModel() and self.ViewModelFlip) then
			ang.r = -ang.r // Fixes mirrored models
		end
			
		if (!pos) then continue end
		
		local last =  self:GetNetworkedInt("LastPortal",0)
		local col = Color(255, 255, 255, 0)
		local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z

			if last == TYPE_BLUE then
					col = Color(255, 255, 255, 255)	
			elseif last == TYPE_ORANGE then
					col = Color(255, 255, 255, 255)
	end


		render.SetMaterial(VWhiteLight)
		render.DrawSprite(drawpos, v.size.x*128, v.size.y*128, col)
		end


		
	if (!self.VElements) then return end
	self:UpdateBonePositions(vm)


	for k, name in pairs( self.VElements ) do
		
		local v = name
		if (!v) then break end
		if (v.hide) then continue end
		
		local sprite = Material(v.sprite)
		
		if (!v.bone) then continue end
		
		local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
		
		if (!pos) then continue end
		
		if (v.type == "Sprite" and sprite) then
			local last =  self:GetNetworkedInt("LastPortal",0)
			local col = Color(0,0,0,0)
			if last == TYPE_BLUE then
		if GetConVarNumber("portal_color_1") >=14 then
			col = Color(25,25,25,255)
		elseif GetConVarNumber("portal_color_1") >=13 then
			col = Color(75,75,75,255)
		elseif GetConVarNumber("portal_color_1") >=12 then
			col = Color(255,255,255,255)
		elseif GetConVarNumber("portal_color_1") >=11 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(250,220,242,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,154,230,255)
			else
				col = Color(255,22,198,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(243,173,213,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,116,186,255)
			else
				col = Color(255,65,142,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(140,70,91,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(175,35,78,255)Color(175,35,78,255)
			else
				col = Color(209,0,62,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=10 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(250,220,249,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,154,255,255)
			else
				col = Color(255,22,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(243,173,242,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,116,255,255)
			else
				col = Color(252,65,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(139,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(174,35,175,255)
			else
				col = Color(205,0,205,255)
			end
		end		
		elseif GetConVarNumber("portal_color_1") >=9 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(244,220,250,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(238,154,255,255)
			else
				col = Color(216,22,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(217,173,243,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(194,116,255,255)
			else
				col = Color(150,65,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(95,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(84,35,175,255)
			else
				col = Color(73,0,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=8 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(220,225,250,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(153,172,255,255)
			else
				col = Color(20,63,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(173,183,243,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(116,133,255,255)
			else
				col = Color(64,83,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(70,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(35,35,175,255)
			else
				col = Color(0,0,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=7 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(220,246,250,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(153,243,255,255)
			else
				col = Color(20,229,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(173,222,243,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(116,202,255,255)
			else
				col = Color(64,160,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(70,98,140,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(35,91,175,255)
			else
				col = Color(0,86,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=6 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(220,249,250,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(153,255,255,255)
			else
				col = Color(20,255,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(173,242,243,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(116,255,255,255)
			else
				col = Color(64,255,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(70,139,140,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(35,174,175,255)
			else
				col = Color(0,209,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=5 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(220,250,244,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(156,255,239,255)
			else
				col = Color(26,255,219,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(173,243,237,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(116,255,231,255)
			else
				col = Color(64,255,188,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(70,140,111,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(35,175,117,255)
			else
				col = Color(0,209,122,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=4 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(225,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(174,255,145,255)
			else
				col = Color(68,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(169,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(128,255,79,255)
			else
				col = Color(85,255,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(70,140,70,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(35,175,35,255)
			else
				col = Color(0,209,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=3 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(246,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(244,255,145,255)
			else
				col = Color(230,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(228,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(233,255,79,255)
			else
				col = Color(199,255,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(116,140,70,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(127,175,35,255)
			else
				col = Color(136,209,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=2 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(249,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,255,145,255)
			else
				col = Color(255,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(237,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,255,79,255)
			else
				col = Color(255,247,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(140,136,70,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(175,167,35,255)
			else
				col = Color(209,199,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=1 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(249,247,217,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,248,145,255)
			else
				col = Color(255,239,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(238,205,142,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,195,79,255)
			else
				col = Color(255,160,32,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(140,98,70,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(175,91,35,255)
			else
				col = Color(209,86,0,255)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(249,217,217,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,145,145,255)
			else
				col = Color(255,0,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(238,148,142,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,89,79,255)
			else
				col = Color(255,44,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(140,70,70,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(175,35,35,255)
			else
				col = Color(209,0,0,255)
			end
		end
	end		
			elseif last == TYPE_ORANGE then
		if GetConVarNumber("portal_color_2") >=14 then
			col = Color(25,25,25,255)
		elseif GetConVarNumber("portal_color_2") >=13 then
			col = Color(75,75,75,255)
		elseif GetConVarNumber("portal_color_2") >=12 then
			col = Color(255,255,255,255)
		elseif GetConVarNumber("portal_color_2") >=11 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(250,220,242,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,154,230,255)
			else
				col = Color(255,22,198,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(243,173,213,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,116,186,255)
			else
				col = Color(255,65,142,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(140,70,91,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(175,35,78,255)Color(175,35,78,255)
			else
				col = Color(209,0,62,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=10 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(250,220,249,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,154,255,255)
			else
				col = Color(255,22,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(243,173,242,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,116,255,255)
			else
				col = Color(252,65,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(139,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(174,35,175,255)
			else
				col = Color(205,0,205,255)
			end
		end		
		elseif GetConVarNumber("portal_color_2") >=9 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(244,220,250,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(238,154,255,255)
			else
				col = Color(216,22,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(217,173,243,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(194,116,255,255)
			else
				col = Color(150,65,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(95,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(84,35,175,255)
			else
				col = Color(73,0,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=8 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(220,225,250,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(153,172,255,255)
			else
				col = Color(20,63,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(173,183,243,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(116,133,255,255)
			else
				col = Color(64,83,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(70,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(35,35,175,255)
			else
				col = Color(0,0,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=7 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(220,246,250,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(153,243,255,255)
			else
				col = Color(20,229,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(173,222,243,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(116,202,255,255)
			else
				col = Color(64,160,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(70,98,140,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(35,91,175,255)
			else
				col = Color(0,86,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=6 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(220,249,250,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(153,255,255,255)
			else
				col = Color(20,255,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(173,242,243,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(116,255,255,255)
			else
				col = Color(64,255,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(70,139,140,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(35,174,175,255)
			else
				col = Color(0,209,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=5 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(220,250,244,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(156,255,239,255)
			else
				col = Color(26,255,219,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(173,243,237,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(116,255,231,255)
			else
				col = Color(64,255,188,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(70,140,111,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(35,175,117,255)
			else
				col = Color(0,209,122,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=4 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(225,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(174,255,145,255)
			else
				col = Color(68,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(169,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(128,255,79,255)
			else
				col = Color(85,255,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(70,140,70,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(35,175,35,255)
			else
				col = Color(0,209,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=3 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(246,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(244,255,145,255)
			else
				col = Color(230,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(228,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(233,255,79,255)
			else
				col = Color(199,255,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(116,140,70,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(127,175,35,255)
			else
				col = Color(136,209,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=2 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(249,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,255,145,255)
			else
				col = Color(255,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(237,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,255,79,255)
			else
				col = Color(255,247,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(140,136,70,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(175,167,35,255)
			else
				col = Color(209,199,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=1 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(249,247,217,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,248,145,255)
			else
				col = Color(255,239,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(238,205,142,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,195,79,255)
			else
				col = Color(255,160,32,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(140,98,70,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(175,91,35,255)
			else
				col = Color(209,86,0,255)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(249,217,217,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,145,145,255)
			else
				col = Color(255,0,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(238,148,142,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,89,79,255)
			else
				col = Color(255,44,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(140,70,70,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(175,35,35,255)
			else
				col = Color(209,0,0,255)
			end
		end
	end
	end

			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			local _sin = math.abs( math.sin( CurTime( ) * 1 ) ) * .3; //math.sinwave( 25, 3, true )
			col.a = math.sin(CurTime()*math.pi)*((128-96)/2)+112
			render.SetMaterial(sprite)
			render.DrawSprite(drawpos, v.size.x*128.0, v.size.y*128.0, col)
			end
			
		end
		
	end

SWEP.wRenderOrder = nil
function SWEP:DrawWorldModel()
	
	if (self.ShowWorldModel == nil or self.ShowWorldModel) then
		self:DrawModel()
	end
	
	if (!self.WElements) then return end
	
	if (!self.wRenderOrder) then

		self.wRenderOrder = {}

		for k, v in pairs( self.WElements ) do
			if (v.type == "Model") then
				table.insert(self.wRenderOrder, 1, k)
			elseif (v.type == "Sprite" or v.type == "Quad") then
				table.insert(self.wRenderOrder, k)
			end
		end

	end
	
	if (IsValid(self.Owner)) then
		bone_ent = self.Owner
	else
		// when the weapon is dropped
		bone_ent = self
	end
	
	for k, name in pairs( self.wRenderOrder ) do
	
		local v = self.WElements[name]
		if (!v) then self.wRenderOrder = nil break end
		if (v.hide) then continue end
		
		local pos, ang
		
		if (v.bone) then
			pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
		else
			pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
		end
		
		if (!pos) then continue end
		
		local model = v.modelEnt
		local sprite = Material(v.sprite)
		
		if (v.type == "Model" and IsValid(model)) then

			model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)

			model:SetAngles(ang)
			//model:SetModelScale(v.size)
			local matrix = Matrix()
			matrix:Scale(v.size)
			model:EnableMatrix( "RenderMultiply", matrix )
			
			if (v.material == "") then
				model:SetMaterial("")
			elseif (model:GetMaterial() != v.material) then
				model:SetMaterial( v.material )
			end
			
			if (v.skin and v.skin != model:GetSkin()) then
				model:SetSkin(v.skin)
			end
			
			if (v.bodygroup) then
				for k, v in pairs( v.bodygroup ) do
					if (model:GetBodygroup(k) != v) then
						model:SetBodygroup(k, v)
					end
				end
			end
			
			if (v.surpresslightning) then
				render.SuppressEngineLighting(true)
			end
			
			render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
			render.SetBlend(v.color.a/255)
			model:DrawModel()
			render.SetBlend(1)
			render.SetColorModulation(1, 1, 1)
			
			if (v.surpresslightning) then
				render.SuppressEngineLighting(false)
			end
			
		elseif (v.type == "Sprite" and sprite) then
			
			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			local last =  self:GetNetworkedInt("LastPortal",0)
			local col = Color(0,0,0,0)
			
			if last == TYPE_BLUE then
		if GetConVarNumber("portal_color_1") >=14 then
			col = Color(25,25,25,255)
		elseif GetConVarNumber("portal_color_1") >=13 then
			col = Color(75,75,75,255)
		elseif GetConVarNumber("portal_color_1") >=12 then
			col = Color(255,255,255,255)
		elseif GetConVarNumber("portal_color_1") >=11 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(250,220,242,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,154,230,255)
			else
				col = Color(255,22,198,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(243,173,213,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,116,186,255)
			else
				col = Color(255,65,142,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(140,70,91,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(175,35,78,255)Color(175,35,78,255)
			else
				col = Color(209,0,62,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=10 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(250,220,249,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,154,255,255)
			else
				col = Color(255,22,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(243,173,242,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,116,255,255)
			else
				col = Color(252,65,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(139,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(174,35,175,255)
			else
				col = Color(205,0,205,255)
			end
		end		
		elseif GetConVarNumber("portal_color_1") >=9 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(244,220,250,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(238,154,255,255)
			else
				col = Color(216,22,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(217,173,243,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(194,116,255,255)
			else
				col = Color(150,65,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(95,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(84,35,175,255)
			else
				col = Color(73,0,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=8 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(220,225,250,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(153,172,255,255)
			else
				col = Color(20,63,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(173,183,243,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(116,133,255,255)
			else
				col = Color(64,83,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(70,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(35,35,175,255)
			else
				col = Color(0,0,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=7 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(220,246,250,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(153,243,255,255)
			else
				col = Color(20,229,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(173,222,243,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(116,202,255,255)
			else
				col = Color(64,160,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(70,98,140,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(35,91,175,255)
			else
				col = Color(0,86,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=6 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(220,249,250,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(153,255,255,255)
			else
				col = Color(20,255,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(173,242,243,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(116,255,255,255)
			else
				col = Color(64,255,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(70,139,140,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(35,174,175,255)
			else
				col = Color(0,209,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=5 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(220,250,244,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(156,255,239,255)
			else
				col = Color(26,255,219,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(173,243,237,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(116,255,231,255)
			else
				col = Color(64,255,188,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(70,140,111,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(35,175,117,255)
			else
				col = Color(0,209,122,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=4 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(225,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(174,255,145,255)
			else
				col = Color(68,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(169,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(128,255,79,255)
			else
				col = Color(85,255,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(70,140,70,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(35,175,35,255)
			else
				col = Color(0,209,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=3 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(246,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(244,255,145,255)
			else
				col = Color(230,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(228,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(233,255,79,255)
			else
				col = Color(199,255,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(116,140,70,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(127,175,35,255)
			else
				col = Color(136,209,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=2 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(249,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,255,145,255)
			else
				col = Color(255,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(237,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,255,79,255)
			else
				col = Color(255,247,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(140,136,70,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(175,167,35,255)
			else
				col = Color(209,199,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=1 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(249,247,217,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,248,145,255)
			else
				col = Color(255,239,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(238,205,142,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,195,79,255)
			else
				col = Color(255,160,32,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(140,98,70,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(175,91,35,255)
			else
				col = Color(209,86,0,255)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(249,217,217,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,145,145,255)
			else
				col = Color(255,0,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(238,148,142,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(255,89,79,255)
			else
				col = Color(255,44,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				col = Color(140,70,70,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				col = Color(175,35,35,255)
			else
				col = Color(209,0,0,255)
			end
		end
	end		
			elseif last == TYPE_ORANGE then
		if GetConVarNumber("portal_color_2") >=14 then
			col = Color(25,25,25,255)
		elseif GetConVarNumber("portal_color_2") >=13 then
			col = Color(75,75,75,255)
		elseif GetConVarNumber("portal_color_2") >=12 then
			col = Color(255,255,255,255)
		elseif GetConVarNumber("portal_color_2") >=11 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(250,220,242,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,154,230,255)
			else
				col = Color(255,22,198,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(243,173,213,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,116,186,255)
			else
				col = Color(255,65,142,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(140,70,91,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(175,35,78,255)Color(175,35,78,255)
			else
				col = Color(209,0,62,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=10 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(250,220,249,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,154,255,255)
			else
				col = Color(255,22,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(243,173,242,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,116,255,255)
			else
				col = Color(252,65,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(139,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(174,35,175,255)
			else
				col = Color(205,0,205,255)
			end
		end		
		elseif GetConVarNumber("portal_color_2") >=9 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(244,220,250,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(238,154,255,255)
			else
				col = Color(216,22,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(217,173,243,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(194,116,255,255)
			else
				col = Color(150,65,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(95,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(84,35,175,255)
			else
				col = Color(73,0,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=8 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(220,225,250,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(153,172,255,255)
			else
				col = Color(20,63,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(173,183,243,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(116,133,255,255)
			else
				col = Color(64,83,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(70,70,140,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(35,35,175,255)
			else
				col = Color(0,0,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=7 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(220,246,250,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(153,243,255,255)
			else
				col = Color(20,229,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(173,222,243,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(116,202,255,255)
			else
				col = Color(64,160,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(70,98,140,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(35,91,175,255)
			else
				col = Color(0,86,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=6 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(220,249,250,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(153,255,255,255)
			else
				col = Color(20,255,255,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(173,242,243,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(116,255,255,255)
			else
				col = Color(64,255,255,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(70,139,140,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(35,174,175,255)
			else
				col = Color(0,209,209,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=5 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(220,250,244,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(156,255,239,255)
			else
				col = Color(26,255,219,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(173,243,237,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(116,255,231,255)
			else
				col = Color(64,255,188,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(70,140,111,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(35,175,117,255)
			else
				col = Color(0,209,122,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=4 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(225,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(174,255,145,255)
			else
				col = Color(68,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(169,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(128,255,79,255)
			else
				col = Color(85,255,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(70,140,70,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(35,175,35,255)
			else
				col = Color(0,209,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=3 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(246,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(244,255,145,255)
			else
				col = Color(230,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(228,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(233,255,79,255)
			else
				col = Color(199,255,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(116,140,70,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(127,175,35,255)
			else
				col = Color(136,209,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=2 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(249,249,217,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,255,145,255)
			else
				col = Color(255,255,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(237,238,142,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,255,79,255)
			else
				col = Color(255,247,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(140,136,70,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(175,167,35,255)
			else
				col = Color(209,199,0,255)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=1 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(249,247,217,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,248,145,255)
			else
				col = Color(255,239,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(238,205,142,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,195,79,255)
			else
				col = Color(255,160,32,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(140,98,70,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(175,91,35,255)
			else
				col = Color(209,86,0,255)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(249,217,217,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,145,145,255)
			else
				col = Color(255,0,0,255)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(238,148,142,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(255,89,79,255)
			else
				col = Color(255,44,33,255)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				col = Color(140,70,70,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				col = Color(175,35,35,255)
			else
				col = Color(209,0,0,255)
			end
		end
	end
	end
			render.SetMaterial(sprite)
			for i=0, 1, .2 do --visible in daylight.
			render.DrawSprite(drawpos, v.size.x*128, v.size.y*128, col)
			end
			
		elseif (v.type == "Quad" and v.draw_func) then
			
			local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
			
			cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func( self )
			cam.End3D2D()
		end
			
	end
		
end

function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
	
	local bone, pos, ang
	if (tab.rel and tab.rel != "") then
		
		local v = basetab[tab.rel]
		
		if (!v) then return end
		
		// Technically, if there exists an element with the same name as a bone
		// you can get in an infinite loop. Let's just hope nobody's that stupid.
		pos, ang = self:GetBoneOrientation( basetab, v, ent )
		
		if (!pos) then return end
		
		pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
		ang:RotateAroundAxis(ang:Up(), v.angle.y)
		ang:RotateAroundAxis(ang:Right(), v.angle.p)
		ang:RotateAroundAxis(ang:Forward(), v.angle.r)
			
	else
	
		bone = ent:LookupBone(bone_override or tab.bone)

		if (!bone) then return end
		
		pos, ang = Vector(0,0,0), Angle(0,0,0)
		local m = ent:GetBoneMatrix(bone)
		if (m) then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end
		
		if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
			ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
			ang.r = -ang.r // Fixes mirrored models
		end
	
	end
	
	return pos, ang
end
local allbones
local hasGarryFixedBoneScalingYet = false

function SWEP:UpdateBonePositions(vm)
	
	if self.ViewModelBoneMods and not drawArm:GetBool() then
		
		if (!vm:GetBoneCount()) then return end
		
		// !! WORKAROUND !! //
		// We need to check all model names :/
		local loopthrough = self.ViewModelBoneMods
		if (!hasGarryFixedBoneScalingYet) then
			allbones = {}
			for i=0, vm:GetBoneCount() do
				local bonename = vm:GetBoneName(i)
				if (self.ViewModelBoneMods[bonename]) then 
					allbones[bonename] = self.ViewModelBoneMods[bonename]
				else
					allbones[bonename] = { 
						scale = Vector(1,1,1),
						pos = Vector(0,0,0),
						angle = Angle(0,0,0)
					}
				end
			end
			
			loopthrough = allbones
		end
		// !! ----------- !! //
		
		for k, v in pairs( loopthrough ) do
			local bone = vm:LookupBone(k)
			if (!bone) then continue end
			
			// !! WORKAROUND !! //
			local s = Vector(v.scale.x,v.scale.y,v.scale.z)
			local p = Vector(v.pos.x,v.pos.y,v.pos.z)
			local ms = Vector(1,1,1)
			if (!hasGarryFixedBoneScalingYet) then
				local cur = vm:GetBoneParent(bone)
				while(cur >= 0) do
					local pscale = loopthrough[vm:GetBoneName(cur)].scale
					ms = ms * pscale
					cur = vm:GetBoneParent(cur)
				end
			end
			
			s = s * ms
			// !! ----------- !! //
			
			if vm:GetManipulateBoneScale(bone) != s then
				vm:ManipulateBoneScale( bone, s )
			end
			if vm:GetManipulateBoneAngles(bone) != v.angle then
				vm:ManipulateBoneAngles( bone, v.angle )
			end
			if vm:GetManipulateBonePosition(bone) != p then
				vm:ManipulateBonePosition( bone, p )
			end
		end
	else
		self:ResetBonePositions(vm)
	end
	   
end
  
function SWEP:ResetBonePositions(vm)
	
	if (!vm:GetBoneCount()) then return end
	for i=0, vm:GetBoneCount() do
		vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
		vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
		vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
	end
	
end
function table.FullCopy( tab )

	if (!tab) then return nil end
	
	local res = {}
	for k, v in pairs( tab ) do
		if (type(v) == "table") then
			res[k] = table.FullCopy(v) // recursion ho!
		elseif (type(v) == "Vector") then
			res[k] = Vector(v.x, v.y, v.z)
		elseif (type(v) == "Angle") then
			res[k] = Angle(v.p, v.y, v.r)
		else
			res[k] = v
		end
	end
	
	return res
	
end


function SWEP:Holster()
	
	if IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
			if self.PickupSound then
				self.PickupSound:Stop()
				self.PickupSound = nil
			end
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

/*---------------------------------------------------------
   Name: CalcViewModelView
   Desc: Overwrites the default GMod v_model system.
---------------------------------------------------------*/


local sin, abs, pi, clamp, min = math.sin, math.abs, math.pi, math.Clamp, math.min
function SWEP:CalcViewModelView(ViewModel, oldPos, oldAng, pos, ang)

	local pPlayer = self.Owner

	local CT = CurTime() * 1.4
	local FT = FrameTime()

	local RunSpeed = pPlayer:GetRunSpeed()
	local Speed = clamp(pPlayer:GetVelocity():Length2D(), 0, RunSpeed)

	local BobCycleMultiplier = Speed / pPlayer:GetRunSpeed() / 1.5

	BobCycleMultiplier = (BobCycleMultiplier > 1 and min(1 + ((BobCycleMultiplier - 1) * 0.2), 9) or BobCycleMultiplier)
	BobTime = BobTime + (CT - BobTimeLast) * (Speed > 0 and (Speed / pPlayer:GetWalkSpeed()) or 0)
	BobTimeLast = CT
	local BobCycleX = sin(BobTime * 0.5 % 1 * pi * 2) * BobCycleMultiplier
	local BobCycleY = sin(BobTime % 1 * pi * 2) * BobCycleMultiplier

	oldPos = oldPos + oldAng:Right() * (BobCycleX * 1.5)
	oldPos = oldPos
	oldPos = oldPos + oldAng:Up() * BobCycleY/2 

	SwayAng = oldAng - SwayOldAng
	if abs(oldAng.y - SwayOldAng.y) > 180 then
		SwayAng.y = (360 - abs(oldAng.y - SwayOldAng.y)) * abs(oldAng.y - SwayOldAng.y) / (SwayOldAng.y - oldAng.y)
	else
		SwayAng.y = oldAng.y - SwayOldAng.y
	end
	SwayOldAng.p = oldAng.p
	SwayOldAng.y = oldAng.y
	SwayAng.p = math.Clamp(SwayAng.p, -5, 5)
	SwayAng.y = math.Clamp(SwayAng.y, -5, 5)
	SwayDelta = LerpAngle(clamp(FT * 50, -5, 0.05), SwayDelta, SwayAng)
	
	return oldPos + oldAng:Up() * SwayDelta.p + oldAng:Right() * SwayDelta.y + oldAng:Up() * oldAng.p / 90 * 2, oldAng
end


function SWEP:GetTracerOrigin()
	local viewm = ply:GetViewModel()
	local obj = viewm:LookupAttachment( "muzzle" )
	return vm:GetAttachment( obj )
end

local leftpos= {x=-2,y=-4}
local rightpos = {x=10,y=18}
local sizeLarge = {w=46,h=64}
local sizeSmall = {w=30,h=64}

c_Gray2 = Color(25,25,25,255)
c_Gray = Color(75,75,75,255)
c_Gray1 = Color(255,255,255,255)	

c_Pink2 = Color(255,65,142,120)
c_Pink = Color(252,65,255,120)
c_Purple = Color(150,65,255,120)
c_Blue_Dark = Color(64,83,255,120)
c_Blue = Color(64,160,255,120)
c_Blue_Light = Color(64,255,255,120)
c_Green2 = Color(64,255,188,120)
c_Green = Color(85,255,33,120)
c_Green1 = Color(199,255,33,120)
c_Yellow = Color(255,247,33,120)
c_Orange = Color(255,160,32,120)
c_Red = Color(255,44,33,120)

c_Pink2_Contraste_Light = Color(255,22,198,120)
c_Pink_Contraste_Light = Color(255,22,255,120)
c_Purple_Contraste_Light = Color(216,22,255,120)
c_Blue_Dark_Contraste_Light = Color(20,63,255,120)
c_Blue_Contraste_Light = Color(20,229,255,120)
c_Blue_Light_Contraste_Light = Color(20,255,255,120)
c_Green2_Contraste_Light = Color(26,255,219,120)
c_Green_Contraste_Light = Color(68,255,0,120)
c_Green1_Contraste_Light = Color(230,255,0,120)
c_Yellow_Contraste_Light = Color(255,255,0,120)
c_Orange_Contraste_Light = Color(255,239,0,120)
c_Red_Contraste_Light = Color(255,0,0,120)

c_Pink2_Contraste_Dark = Color(209,0,62,120)
c_Pink_Contraste_Dark = Color(205,0,205,120)
c_Purple_Contraste_Dark = Color(73,0,209,120)
c_Blue_Dark_Contraste_Dark = Color(0,0,209,120)
c_Blue_Contraste_Dark = Color(0,86,209,120)
c_Blue_Light_Contraste_Dark = Color(0,209,209,120)
c_Green2_Contraste_Dark = Color(0,209,122,120)
c_Green_Contraste_Dark = Color(0,209,0,120)
c_Green1_Contraste_Dark = Color(136,209,0,120)
c_Yellow_Contraste_Dark = Color(209,199,0,120)
c_Orange_Contraste_Dark = Color(209,86,0,120)
c_Red_Contraste_Dark = Color(209,0,0,120)

-- Saturation 1

c_Pink2_Saturation_1 = Color(255,116,186,120)
c_Pink_Saturation_1 = Color(255,116,255,120)
c_Purple_Saturation_1 = Color(194,116,255,120)
c_Blue_Dark_Saturation_1 = Color(116,133,255,120)
c_Blue_Saturation_1 = Color(116,202,255,120)
c_Blue_Light_Saturation_1 = Color(116,255,255,120)
c_Green2_Saturation_1 = Color(116,255,231,120)
c_Green_Saturation_1 = Color(128,255,79,120)
c_Green1_Saturation_1 = Color(233,255,79,120)
c_Yellow_Saturation_1 = Color(255,255,79,120)
c_Orange_Saturation_1 = Color(255,195,79,120)
c_Red_Saturation_1 = Color(255,89,79,120)

c_Pink2_Contraste_Light_Saturation_1 = Color(255,154,230,120)
c_Pink_Contraste_Light_Saturation_1 = Color(255,154,255,120)
c_Purple_Contraste_Light_Saturation_1 = Color(238,154,255,120)
c_Blue_Dark_Contraste_Light_Saturation_1 = Color(153,172,255,120)
c_Blue_Contraste_Light_Saturation_1 = Color(153,243,255,120)
c_Blue_Light_Contraste_Light_Saturation_1 = Color(153,255,255,120)
c_Green2_Contraste_Light_Saturation_1 = Color(156,255,239,120)
c_Green_Contraste_Light_Saturation_1 = Color(174,255,145,120)
c_Green1_Contraste_Light_Saturation_1 = Color(244,255,145,120)
c_Yellow_Contraste_Light_Saturation_1 = Color(255,255,145,120)
c_Orange_Contraste_Light_Saturation_1 = Color(255,248,145,120)
c_Red_Contraste_Light_Saturation_1 = Color(255,145,145,120)

c_Pink2_Contraste_Dark_Saturation_1 = Color(175,35,78,120)
c_Pink_Contraste_Dark_Saturation_1 = Color(174,35,175,120)
c_Purple_Contraste_Dark_Saturation_1 = Color(84,35,175,120)
c_Blue_Dark_Contraste_Dark_Saturation_1 = Color(35,35,175,120)
c_Blue_Contraste_Dark_Saturation_1 = Color(35,91,175,120)
c_Blue_Light_Contraste_Dark_Saturation_1 = Color(35,174,175,120)
c_Green2_Contraste_Dark_Saturation_1 = Color(35,175,117,120)
c_Green_Contraste_Dark_Saturation_1 = Color(35,175,35,120)
c_Green1_Contraste_Dark_Saturation_1 = Color(127,175,35,120)
c_Yellow_Contraste_Dark_Saturation_1 = Color(175,167,35,120)
c_Orange_Contraste_Dark_Saturation_1 = Color(175,91,35,120)
c_Red_Contraste_Dark_Saturation_1 = Color(175,35,35,120)

-- Saturation 2

c_Pink2_Saturation_2 = Color(243,173,213,120)
c_Pink_Saturation_2 = Color(243,173,242,120)
c_Purple_Saturation_2 = Color(217,173,243,120)
c_Blue_Dark_Saturation_2 = Color(173,183,243,120)
c_Blue_Saturation_2 = Color(173,222,243,120)
c_Blue_Light_Saturation_2 = Color(173,242,243,120)
c_Green2_Saturation_2 = Color(173,243,237,120)
c_Green_Saturation_2 = Color(169,238,142,120)
c_Green1_Saturation_2 = Color(228,238,142,120)
c_Yellow_Saturation_2 = Color(237,238,142,120)
c_Orange_Saturation_2 = Color(238,205,142,120)
c_Red_Saturation_2 = Color(238,148,142,120)

c_Pink2_Contraste_Light_Saturation_2 = Color(250,220,242,120)
c_Pink_Contraste_Light_Saturation_2 = Color(250,220,249,120)
c_Purple_Contraste_Light_Saturation_2 = Color(244,220,250,120)
c_Blue_Dark_Contraste_Light_Saturation_2 = Color(220,225,250,120)
c_Blue_Contraste_Light_Saturation_2 = Color(220,246,250,120)
c_Blue_Light_Contraste_Light_Saturation_2 = Color(220,249,250,120)
c_Green2_Contraste_Light_Saturation_2 = Color(220,250,244,120)
c_Green_Contraste_Light_Saturation_2 = Color(225,249,217,120)
c_Green1_Contraste_Light_Saturation_2 = Color(246,249,217,120)
c_Yellow_Contraste_Light_Saturation_2 = Color(249,249,217,120)
c_Orange_Contraste_Light_Saturation_2 = Color(249,247,217,120)
c_Red_Contraste_Light_Saturation_2 = Color(249,217,217,120)

c_Pink2_Contraste_Dark_Saturation_2 = Color(140,70,91,120)
c_Pink_Contraste_Dark_Saturation_2 = Color(139,70,140,120)
c_Purple_Contraste_Dark_Saturation_2 = Color(95,70,140,120)
c_Blue_Dark_Contraste_Dark_Saturation_2 = Color(70,70,140,120)
c_Blue_Contraste_Dark_Saturation_2 = Color(70,98,140,120)
c_Blue_Light_Contraste_Dark_Saturation_2 = Color(70,139,140,120)
c_Green2_Contraste_Dark_Saturation_2 = Color(70,140,111,120)
c_Green_Contraste_Dark_Saturation_2 = Color(70,140,70,120)
c_Green1_Contraste_Dark_Saturation_2 = Color(116,140,70,120)
c_Yellow_Contraste_Dark_Saturation_2 = Color(140,136,70,120)
c_Orange_Contraste_Dark_Saturation_2 = Color(140,98,70,120)
c_Red_Contraste_Dark_Saturation_2 = Color(140,70,70,120)

surface.CreateFont( "xhair", 
                    {
                    font    = "HL2Cross",
                    size    = ScreenScale(21),
                    weight  = 400,
                    antialias = true,
                    shadow = false
})

function SWEP:DrawHUD()
	if !reticle:GetBool() then return end

	local w = ScrW()
	local h = ScrH()
	local cX = (w / 2)-29
	local cY = (h / 2)-38
	local trd = {}
		trd.start = LocalPlayer():GetShootPos()
		trd.endpos = trd.start + LocalPlayer():GetAimVector() * 10000
		trd.mask = MASK_SOLID_BRUSHONLY
	local trc = util.TraceLine(trd)
	
	local validMat = trc.MatType != 77 and trc.MatType != 88 and trc.MatType != 89
	local validBlu = true
	local validRed = true
	local hEnt = LocalPlayer():GetEyeTrace().Entity
	if hEnt != nil && hEnt:IsValid() && hEnt:GetClass() == "prop_portal" then
		if hEnt:GetNWInt("Potal:PortalType",TYPE_BLUE) == TYPE_BLUE then
			validRed = false
		else
			validBlu = false
		end
	end

        local blueportal = self.Owner:GetNWEntity( "Portal:Blue" )
        local orangeportal = self.Owner:GetNWEntity( "Portal:Orange" )	
	
if !allsurfaces:GetBool() then
if system:GetBool() then 

if GetConVarNumber("portal_portalonly") >=2 then
Brack_left = "{"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					Brack_left = "["
                end
        end
elseif GetConVarNumber("portal_portalonly") >=1 then
Brack_left = "{"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					Brack_left = "["
                end
        end
else
Brack_left = "{"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					Brack_left = "["
                end
        end
end

else

if GetConVarNumber("portal_portalonly") >=2 then

	if (validMat && validRed) then
		Brack_left = "["
	else
		Brack_left = "{"
	end
elseif GetConVarNumber("portal_portalonly") >=1 then
	if (validMat && validBlu) then
		Brack_left = "["
	else
		Brack_left = "{"
	end
else
	if (validMat && validBlu) then
		Brack_left = "["
	else
		Brack_left = "{"
	end
	
end
	
end

else

if system:GetBool() then 

if GetConVarNumber("portal_portalonly") >=2 then
Brack_left = "{"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					Brack_left = "["
                end
        end
elseif GetConVarNumber("portal_portalonly") >=1 then
Brack_left = "{"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					Brack_left = "["
                end
        end
else
Brack_left = "{"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					Brack_left = "["
                end
        end
end

else

if GetConVarNumber("portal_portalonly") >=2 then

	if (validMat && validRed) then
		Brack_left = "["
	else
		Brack_left = "["
	end
elseif GetConVarNumber("portal_portalonly") >=1 then
	if (validMat && validBlu) then
		Brack_left = "["
	else
		Brack_left = "["
	end
else
	if (validMat && validBlu) then
		Brack_left = "["
	else
		Brack_left = "["
	end
	
end
	
end
end
	
if !allsurfaces:GetBool() then
if system:GetBool() then 

if GetConVarNumber("portal_portalonly") >=2 then
Brack_right = "}"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					Brack_right = "]"
                end
        end
elseif GetConVarNumber("portal_portalonly") >=1 then
Brack_right = "}"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					Brack_right = "]"
                end
        end
else
Brack_right = "}"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					Brack_right = "]"
                end
        end
end

else

if GetConVarNumber("portal_portalonly") >=2 then

	if (validMat && validRed) then
		Brack_right = "]"
	else
		Brack_right = "}"
	end
elseif GetConVarNumber("portal_portalonly") >=1 then
	if (validMat && validBlu) then
		Brack_right = "]"
	else
		Brack_right = "}"
	end
else
	if (validMat && validRed) then
		Brack_right = "]"
	else
		Brack_right = "}"
	end
	
end
	
end

else

if system:GetBool() then 

if GetConVarNumber("portal_portalonly") >=2 then
Brack_right = "}"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					Brack_right = "]"
                end
        end
elseif GetConVarNumber("portal_portalonly") >=1 then
Brack_right = "}"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					Brack_right = "]"
                end
        end
else
Brack_right = "}"
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					Brack_right = "]"
                end
        end
end

else

if GetConVarNumber("portal_portalonly") >=2 then

	if (validMat && validRed) then
		Brack_right = "]"
	else
		Brack_right = "]"
	end
elseif GetConVarNumber("portal_portalonly") >=1 then
	if (validMat && validBlu) then
		Brack_right = "]"
	else
		Brack_right = "]"
	end
else
	if (validMat && validRed) then
		Brack_right = "]"
	else
		Brack_right = "]"
	end
	
end
	
end
end

if GetConVarNumber("portal_crosshair") >=2 then

	local cX = (w / 2)
	local cY = (h / 2)
	cX_edit = ScreenScale(7)+1
	cX_edit_last = ScreenScale(5)
	
if GetConVarNumber("portal_portalonly") >=2 then
		if GetConVarNumber("portal_color_2") >=14 then
			draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Gray2,2,1)
		elseif GetConVarNumber("portal_color_2") >=13 then
			draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Gray,2,1)
		elseif GetConVarNumber("portal_color_2") >=12 then
			draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Gray1,2,1)
		elseif GetConVarNumber("portal_color_2") >=11 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=10 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Dark,2,1)
			end
		end		
		elseif GetConVarNumber("portal_color_2") >=9 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=8 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=7 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=6 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=5 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=4 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=3 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=2 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=1 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Dark,2,1)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red,2,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Dark,2,1)
			end
		end
	end	

		if GetConVarNumber("portal_color_2") >=14 then
			draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Gray2,0,1)
		elseif GetConVarNumber("portal_color_2") >=13 then
			draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Gray,0,1)
		elseif GetConVarNumber("portal_color_2") >=12 then
			draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Gray1,0,1)
		elseif GetConVarNumber("portal_color_2") >=11 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=10 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Dark,0,1)
			end
		end		
		elseif GetConVarNumber("portal_color_2") >=9 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=8 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=7 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=6 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=5 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=4 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=3 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=2 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=1 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Dark,0,1)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red,0,1)
			end
		else
			if GetConVarNumber("portal_color_contraste_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_contraste_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Dark,0,1)
			end
		end
	end	

elseif GetConVarNumber("portal_portalonly") >=1 then
		if GetConVarNumber("portal_color_1") >=14 then
			draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Gray2,2,1)
		elseif GetConVarNumber("portal_color_1") >=13 then
			draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Gray,2,1)
		elseif GetConVarNumber("portal_color_1") >=12 then
			draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Gray1,2,1)
		elseif GetConVarNumber("portal_color_1") >=11 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=10 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Dark,2,1)
			end
		end		
		elseif GetConVarNumber("portal_color_1") >=9 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=8 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=7 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=6 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=5 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=4 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=3 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=2 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=1 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Dark,2,1)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Dark,2,1)
			end
		end
	end	

		if GetConVarNumber("portal_color_1") >=14 then
			draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Gray2,0,1)
		elseif GetConVarNumber("portal_color_1") >=13 then
			draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Gray,0,1)
		elseif GetConVarNumber("portal_color_1") >=12 then
			draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Gray1,0,1)
		elseif GetConVarNumber("portal_color_1") >=11 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=10 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Dark,0,1)
			end
		end		
		elseif GetConVarNumber("portal_color_1") >=9 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=8 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=7 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=6 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=5 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=4 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=3 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=2 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=1 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Dark,0,1)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Dark,0,1)
			end
		end
	end	


else
		if GetConVarNumber("portal_color_1") >=14 then
			draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Gray2,2,1)
		elseif GetConVarNumber("portal_color_1") >=13 then
			draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Gray,2,1)
		elseif GetConVarNumber("portal_color_1") >=12 then
			draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Gray1,2,1)
		elseif GetConVarNumber("portal_color_1") >=11 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink2_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=10 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Pink_Contraste_Dark,2,1)
			end
		end		
		elseif GetConVarNumber("portal_color_1") >=9 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Purple_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=8 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Dark_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=7 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=6 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Blue_Light_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=5 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green2_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=4 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=3 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Green1_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=2 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Yellow_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=1 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Orange_Contraste_Dark,2,1)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(Brack_left,"xhair",cX-cX_edit,cY,c_Red_Contraste_Dark,2,1)
			end
		end
	end	

		if GetConVarNumber("portal_color_2") >=14 then
			draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Gray2,0,1)
		elseif GetConVarNumber("portal_color_2") >=13 then
			draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Gray,0,1)
		elseif GetConVarNumber("portal_color_2") >=12 then
			draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Gray1,0,1)
		elseif GetConVarNumber("portal_color_2") >=11 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink2_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=10 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Pink_Contraste_Dark,0,1)
			end
		end		
		elseif GetConVarNumber("portal_color_2") >=9 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Purple_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=8 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Dark_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=7 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=6 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Blue_Light_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=5 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green2_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=4 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=3 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Green1_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=2 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Yellow_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=1 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Orange_Contraste_Dark,0,1)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(Brack_right,"xhair",cX+cX_edit,cY,c_Red_Contraste_Dark,0,1)
			end
		end
	end	

if !system:GetBool() then 	
local lastPort = self:GetNetworkedInt("LastPortal",0)	

	if (lastPort == TYPE_BLUE) then
		lastPort_left = "["
	else
		lastPort_left = "{"
	end
	
	if (lastPort == TYPE_ORANGE) then
		lastPort_right = "]"
	else
		lastPort_right = "}"
	end
		if GetConVarNumber("portal_color_1") >=14 then
			draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Gray2,2,1)
		elseif GetConVarNumber("portal_color_1") >=13 then
			draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Gray,2,1)
		elseif GetConVarNumber("portal_color_1") >=12 then
			draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Gray1,2,1)
		elseif GetConVarNumber("portal_color_1") >=11 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink2_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink2_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink2_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink2_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink2_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink2,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink2_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink2_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink2_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=10 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Pink_Contraste_Dark,2,1)
			end
		end		
		elseif GetConVarNumber("portal_color_1") >=9 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Purple_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Purple_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Purple_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Purple_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Purple_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Purple,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Purple_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Purple_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Purple_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=8 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Dark_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Dark_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Dark_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Dark,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Dark_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Dark_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Dark_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=7 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=6 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Light_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Light_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Light_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Light,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Light_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Light_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Blue_Light_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=5 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green2_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green2_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green2_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green2_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green2_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green2,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green2_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green2_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green2_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=4 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=3 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green1_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green1_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green1_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green1_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green1_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green1,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green1_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green1_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Green1_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=2 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Yellow_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Yellow_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Yellow_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Yellow_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Yellow_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Yellow,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Yellow_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Yellow_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Yellow_Contraste_Dark,2,1)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=1 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Orange_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Orange_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Orange_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Orange_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Orange_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Orange,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Orange_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Orange_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Orange_Contraste_Dark,2,1)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Red_Contraste_Light_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Red_Contraste_Light_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Red_Contraste_Light,2,1)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Red_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Red_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Red,2,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Red_Contraste_Dark_Saturation_2,2,1)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Red_Contraste_Dark_Saturation_1,2,1)
			else
				draw.SimpleText(lastPort_left,"xhair",cX-cX_edit-cX_edit_last-1,cY,c_Red_Contraste_Dark,2,1)
			end
		end
	end	

		if GetConVarNumber("portal_color_2") >=14 then
			draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Gray2,0,1)
		elseif GetConVarNumber("portal_color_2") >=13 then
			draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Gray,0,1)
		elseif GetConVarNumber("portal_color_2") >=12 then
			draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Gray1,0,1)
		elseif GetConVarNumber("portal_color_2") >=11 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink2_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink2_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink2_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink2_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink2_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink2,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink2_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink2_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink2_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=10 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Pink_Contraste_Dark,0,1)
			end
		end		
		elseif GetConVarNumber("portal_color_2") >=9 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Purple_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Purple_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Purple_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Purple_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Purple_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Purple,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Purple_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Purple_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Purple_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=8 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Dark_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Dark_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Dark_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Dark,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Dark_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Dark_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Dark_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=7 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=6 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Light_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Light_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Light_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Light,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Light_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Light_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Blue_Light_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=5 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green2_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green2_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green2_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green2_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green2_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green2,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green2_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green2_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green2_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=4 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=3 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green1_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green1_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green1_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green1_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green1_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green1,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green1_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green1_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Green1_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=2 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Yellow_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Yellow_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Yellow_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Yellow_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Yellow_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Yellow,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Yellow_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Yellow_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Yellow_Contraste_Dark,0,1)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=1 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Orange_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Orange_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Orange_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Orange_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Orange_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Orange,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Orange_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Orange_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Orange_Contraste_Dark,0,1)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Red_Contraste_Light_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Red_Contraste_Light_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Red_Contraste_Light,0,1)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Red_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Red_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Red,0,1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Red_Contraste_Dark_Saturation_2,0,1)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Red_Contraste_Dark_Saturation_1,0,1)
			else
				draw.SimpleText(lastPort_right,"xhair",cX+cX_edit+cX_edit_last,cY,c_Red_Contraste_Dark,0,1)
			end
		end
	end	
end

end

elseif GetConVarNumber("portal_crosshair") >=1 then

if GetConVarNumber("portal_portalonly") >=2 then

if !allsurfaces:GetBool() then 

if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/leftEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
                end
        end

else

	if (validMat && validRed) then
		surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/leftEmpty.png"))
	end
	
end
		else
		
if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/leftEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
                end
        end

else

	if (validMat && validRed) then
		surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
	end
	
end

end

		if GetConVarNumber("portal_color_2") >=14 then
			surface.SetDrawColor(c_Gray2)
		elseif GetConVarNumber("portal_color_2") >=13 then
			surface.SetDrawColor(c_Gray)
		elseif GetConVarNumber("portal_color_2") >=12 then
			surface.SetDrawColor(c_Gray1)
		elseif GetConVarNumber("portal_color_2") >=11 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=10 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Saturation_1)
			else
				surface.SetDrawColor(c_Pink)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Dark)
			end
		end		
		elseif GetConVarNumber("portal_color_2") >=9 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Saturation_1)
			else
				surface.SetDrawColor(c_Purple)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=8 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=7 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Saturation_1)
			else
				surface.SetDrawColor(c_Blue)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=6 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=5 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Saturation_1)
			else
				surface.SetDrawColor(c_Green2)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=4 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Saturation_1)
			else
				surface.SetDrawColor(c_Green)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=3 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Saturation_1)
			else
				surface.SetDrawColor(c_Green1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=2 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=1 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Saturation_1)
			else
				surface.SetDrawColor(c_Orange)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Dark)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Saturation_1)
			else
				surface.SetDrawColor(c_Red)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Dark)
			end
		end
	end	
surface.DrawTexturedRect(cX+leftpos.x, cY+leftpos.y, sizeLarge.w, sizeLarge.h)
	
if !allsurfaces:GetBool() then 

if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/rightEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
                end
        end

else

	if (validMat && validRed) then
		surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/rightEmpty.png"))
	end
	
end
		else
		
if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/rightEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
                end
        end

else

	if (validMat && validRed) then
		surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
	end
	
end

end
	
		if GetConVarNumber("portal_color_2") >=14 then
			surface.SetDrawColor(c_Gray2)
		elseif GetConVarNumber("portal_color_2") >=13 then
			surface.SetDrawColor(c_Gray)
		elseif GetConVarNumber("portal_color_2") >=12 then
			surface.SetDrawColor(c_Gray1)
		elseif GetConVarNumber("portal_color_2") >=11 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=10 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Saturation_1)
			else
				surface.SetDrawColor(c_Pink)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Dark)
			end
		end		
		elseif GetConVarNumber("portal_color_2") >=9 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Saturation_1)
			else
				surface.SetDrawColor(c_Purple)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=8 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=7 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Saturation_1)
			else
				surface.SetDrawColor(c_Blue)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=6 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=5 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Saturation_1)
			else
				surface.SetDrawColor(c_Green2)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=4 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Saturation_1)
			else
				surface.SetDrawColor(c_Green)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=3 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Saturation_1)
			else
				surface.SetDrawColor(c_Green1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=2 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=1 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Saturation_1)
			else
				surface.SetDrawColor(c_Orange)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Dark)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Saturation_1)
			else
				surface.SetDrawColor(c_Red)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Dark)
			end
		end
	end
	surface.DrawTexturedRect(cX+rightpos.x, cY+rightpos.y, sizeLarge.w, sizeLarge.h)


elseif GetConVarNumber("portal_portalonly") >=1 then

if !allsurfaces:GetBool() then 

if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/leftEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
                end
        end

else

	if (validMat && validBlu) then
		surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/leftEmpty.png"))
	end
	
end
		else
		
if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/leftEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
                end
        end

else

	if (validMat && validBlu) then
		surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
	end
	
end

end

		if GetConVarNumber("portal_color_1") >=14 then
			surface.SetDrawColor(c_Gray2)
		elseif GetConVarNumber("portal_color_1") >=13 then
			surface.SetDrawColor(c_Gray)
		elseif GetConVarNumber("portal_color_1") >=12 then
			surface.SetDrawColor(c_Gray1)
		elseif GetConVarNumber("portal_color_1") >=11 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=10 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Saturation_1)
			else
				surface.SetDrawColor(c_Pink)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Dark)
			end
		end		
		elseif GetConVarNumber("portal_color_1") >=9 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Saturation_1)
			else
				surface.SetDrawColor(c_Purple)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=8 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=7 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Saturation_1)
			else
				surface.SetDrawColor(c_Blue)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=6 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=5 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Saturation_1)
			else
				surface.SetDrawColor(c_Green2)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=4 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Saturation_1)
			else
				surface.SetDrawColor(c_Green)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=3 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Saturation_1)
			else
				surface.SetDrawColor(c_Green1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=2 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=1 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Saturation_1)
			else
				surface.SetDrawColor(c_Orange)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Dark)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Saturation_1)
			else
				surface.SetDrawColor(c_Red)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Dark)
			end
		end
	end	
surface.DrawTexturedRect(cX+leftpos.x, cY+leftpos.y, sizeLarge.w, sizeLarge.h)
	
if !allsurfaces:GetBool() then 

if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/rightEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
                end
        end

else

	if (validMat && validBlu) then
		surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/rightEmpty.png"))
	end
	
end
		else
		
if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/rightEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
                end
        end

else

	if (validMat && validBlu) then
		surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
	end
	
end

end
	
		if GetConVarNumber("portal_color_1") >=14 then
			surface.SetDrawColor(c_Gray2)
		elseif GetConVarNumber("portal_color_1") >=13 then
			surface.SetDrawColor(c_Gray)
		elseif GetConVarNumber("portal_color_1") >=12 then
			surface.SetDrawColor(c_Gray1)
		elseif GetConVarNumber("portal_color_1") >=11 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=10 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Saturation_1)
			else
				surface.SetDrawColor(c_Pink)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Dark)
			end
		end		
		elseif GetConVarNumber("portal_color_1") >=9 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Saturation_1)
			else
				surface.SetDrawColor(c_Purple)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=8 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=7 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Saturation_1)
			else
				surface.SetDrawColor(c_Blue)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=6 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=5 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Saturation_1)
			else
				surface.SetDrawColor(c_Green2)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=4 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Saturation_1)
			else
				surface.SetDrawColor(c_Green)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=3 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Saturation_1)
			else
				surface.SetDrawColor(c_Green1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=2 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=1 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Saturation_1)
			else
				surface.SetDrawColor(c_Orange)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Dark)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Saturation_1)
			else
				surface.SetDrawColor(c_Red)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Dark)
			end
		end
	end
	surface.DrawTexturedRect(cX+rightpos.x, cY+rightpos.y, sizeLarge.w, sizeLarge.h)


else
	local drawmaterial

if !allsurfaces:GetBool() then 

if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/leftEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
                end
        end

else

	if (validMat && validBlu) then
		surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/leftEmpty.png"))
	end
	
end
		else
		
if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/leftEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == blueportal then
					surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
                end
        end

else

	if (validMat && validBlu) then
		surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/leftFull.png"))
	end
	
end

end

		if GetConVarNumber("portal_color_1") >=14 then
			surface.SetDrawColor(c_Gray2)
		elseif GetConVarNumber("portal_color_1") >=13 then
			surface.SetDrawColor(c_Gray)
		elseif GetConVarNumber("portal_color_1") >=12 then
			surface.SetDrawColor(c_Gray1)
		elseif GetConVarNumber("portal_color_1") >=11 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=10 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Saturation_1)
			else
				surface.SetDrawColor(c_Pink)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Dark)
			end
		end		
		elseif GetConVarNumber("portal_color_1") >=9 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Saturation_1)
			else
				surface.SetDrawColor(c_Purple)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=8 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=7 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Saturation_1)
			else
				surface.SetDrawColor(c_Blue)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=6 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=5 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Saturation_1)
			else
				surface.SetDrawColor(c_Green2)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=4 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Saturation_1)
			else
				surface.SetDrawColor(c_Green)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=3 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Saturation_1)
			else
				surface.SetDrawColor(c_Green1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=2 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=1 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Saturation_1)
			else
				surface.SetDrawColor(c_Orange)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Dark)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Saturation_1)
			else
				surface.SetDrawColor(c_Red)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Dark)
			end
		end
	end	
surface.DrawTexturedRect(cX+leftpos.x, cY+leftpos.y, sizeLarge.w, sizeLarge.h)
	
if !allsurfaces:GetBool() then 

if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/rightEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
                end
        end

else

	if (validMat && validRed) then
		surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/rightEmpty.png"))
	end
	
end
		else
		
if system:GetBool() then 

surface.SetMaterial( Material("vgui/portalgun/rightEmpty.png"))
        for k,v in ipairs( ents.FindByClass( "prop_portal" ) ) do
                if v == orangeportal then
					surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
                end
        end

else

	if (validMat && validRed) then
		surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
	else
		surface.SetMaterial( Material("vgui/portalgun/rightFull.png"))
	end
	
end

end
	
		if GetConVarNumber("portal_color_2") >=14 then
			surface.SetDrawColor(c_Gray2)
		elseif GetConVarNumber("portal_color_2") >=13 then
			surface.SetDrawColor(c_Gray)
		elseif GetConVarNumber("portal_color_2") >=12 then
			surface.SetDrawColor(c_Gray1)
		elseif GetConVarNumber("portal_color_2") >=11 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=10 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Saturation_1)
			else
				surface.SetDrawColor(c_Pink)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Dark)
			end
		end		
		elseif GetConVarNumber("portal_color_2") >=9 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Saturation_1)
			else
				surface.SetDrawColor(c_Purple)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=8 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=7 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Saturation_1)
			else
				surface.SetDrawColor(c_Blue)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=6 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=5 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Saturation_1)
			else
				surface.SetDrawColor(c_Green2)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=4 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Saturation_1)
			else
				surface.SetDrawColor(c_Green)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=3 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Saturation_1)
			else
				surface.SetDrawColor(c_Green1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=2 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=1 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Saturation_1)
			else
				surface.SetDrawColor(c_Orange)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Dark)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Saturation_1)
			else
				surface.SetDrawColor(c_Red)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Dark)
			end
		end
	end
	surface.DrawTexturedRect(cX+rightpos.x, cY+rightpos.y, sizeLarge.w, sizeLarge.h)

if !system:GetBool() then 	
	lastPort = self:GetNetworkedInt("LastPortal",0)
else
	lastPort = 0
end	
	surface.SetMaterial( Material("vgui/portalgun/lastFired.png"))
	
	if lastPort == TYPE_BLUE then
		if GetConVarNumber("portal_color_1") >=14 then
			surface.SetDrawColor(c_Gray2)
		elseif GetConVarNumber("portal_color_1") >=13 then
			surface.SetDrawColor(c_Gray)
		elseif GetConVarNumber("portal_color_1") >=12 then
			surface.SetDrawColor(c_Gray1)
		elseif GetConVarNumber("portal_color_1") >=11 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=10 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Saturation_1)
			else
				surface.SetDrawColor(c_Pink)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Dark)
			end
		end		
		elseif GetConVarNumber("portal_color_1") >=9 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Saturation_1)
			else
				surface.SetDrawColor(c_Purple)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=8 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=7 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Saturation_1)
			else
				surface.SetDrawColor(c_Blue)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=6 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=5 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Saturation_1)
			else
				surface.SetDrawColor(c_Green2)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=4 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Saturation_1)
			else
				surface.SetDrawColor(c_Green)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=3 then	
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Saturation_1)
			else
				surface.SetDrawColor(c_Green1)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=2 then		
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_1") >=1 then
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Saturation_1)
			else
				surface.SetDrawColor(c_Orange)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Dark)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_1") >=2 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_1") >=1 then
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Saturation_1)
			else
				surface.SetDrawColor(c_Red)
			end
		else
			if GetConVarNumber("portal_color_saturation_1") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Dark)
			end
		end
	end
	surface.DrawTexturedRect(cX+leftpos.x-20, cY+leftpos.y-(sizeSmall.h/2)+45, sizeSmall.w, sizeSmall.h)
	elseif lastPort == TYPE_ORANGE then
		if GetConVarNumber("portal_color_2") >=14 then
			surface.SetDrawColor(c_Gray2)
		elseif GetConVarNumber("portal_color_2") >=13 then
			surface.SetDrawColor(c_Gray)
		elseif GetConVarNumber("portal_color_2") >=12 then
			surface.SetDrawColor(c_Gray1)
		elseif GetConVarNumber("portal_color_2") >=11 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=10 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Saturation_1)
			else
				surface.SetDrawColor(c_Pink)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Pink_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Pink_Contraste_Dark)
			end
		end		
		elseif GetConVarNumber("portal_color_2") >=9 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Saturation_1)
			else
				surface.SetDrawColor(c_Purple)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Purple_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Purple_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=8 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Dark_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=7 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Saturation_1)
			else
				surface.SetDrawColor(c_Blue)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=6 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Blue_Light_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=5 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Saturation_1)
			else
				surface.SetDrawColor(c_Green2)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green2_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green2_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=4 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Saturation_1)
			else
				surface.SetDrawColor(c_Green)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=3 then	
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Saturation_1)
			else
				surface.SetDrawColor(c_Green1)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Green1_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Green1_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=2 then		
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Yellow_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Yellow_Contraste_Dark)
			end
		end
		elseif GetConVarNumber("portal_color_2") >=1 then
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Saturation_1)
			else
				surface.SetDrawColor(c_Orange)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Orange_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Orange_Contraste_Dark)
			end
		end
		else
		if GetConVarNumber("portal_color_contraste_2") >=2 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Light_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Light)
			end
		elseif GetConVarNumber("portal_color_contraste_2") >=1 then
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Saturation_1)
			else
				surface.SetDrawColor(c_Red)
			end
		else
			if GetConVarNumber("portal_color_saturation_2") >=2 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_2)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
				surface.SetDrawColor(c_Red_Contraste_Dark_Saturation_1)
			else
				surface.SetDrawColor(c_Red_Contraste_Dark)
			end
		end
	end	
	surface.DrawTexturedRect(cX+rightpos.x+38, cY+rightpos.y-(sizeSmall.h/2)+21, sizeSmall.w, sizeSmall.h)
	end
	
end
end
end


killicon.Add( "prop_portal", "hud/killicon_portals", Color( 255, 48, 0, 255 ) )

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( "C", "WeaponIcons_lua", x + wide/2, y + tall*0.03, Color( 255, 235, 25, 255 ), TEXT_ALIGN_CENTER )
	draw.SimpleText( "C", "WeaponIconsSelected_lua", x + wide/2, y + tall*0.03, Color( 255, 235, 25, 255 ), TEXT_ALIGN_CENTER )
	
	// try to fool them into thinking they're playing a Tony Hawks game	
end