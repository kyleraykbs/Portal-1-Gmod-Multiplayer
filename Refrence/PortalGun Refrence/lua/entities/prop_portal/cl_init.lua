include( "shared.lua" )

local dlightenabled = CreateClientConVar("portal_dynamic_light", "0", true) --Pretty laggy, default it to off
-- local lightteleport = CreateClientConVar("portal_light_teleport", "0", true)
local bordersenabled = CreateClientConVar("portal_borders", "1", true)
local renderportals = CreateClientConVar("portal_render", 1, true) --Some people can't handle portals at all.
local texFSBportals = CreateClientConVar("portal_texFSB", 0, true)

local portal_1_color = CreateClientConVar("portal_color_1", 7, true)
local portal_1_contraste = CreateClientConVar("portal_color_contraste_1", 1, true)
local portal_1_saturation = CreateClientConVar("portal_color_saturation_1", 0, true)

local portal_2_color = CreateClientConVar("portal_color_2", 1, true)
local portal_2_contraste = CreateClientConVar("portal_color_contraste_2", 1, true)
local portal_2_saturation = CreateClientConVar("portal_color_saturation_2", 0, true)

local texFSB = render.GetSuperFPTex() -- I'm really not sure if I should even be using these D:
local texFSB2 = render.GetSuperFPTex2()

 -- Make our own material to use, so we aren't messing with other effects.
local PortalMaterial = CreateMaterial(
                "PortalMaterial",
                "UnlitGeneric",
                -- "GMODScreenspace",
                {
                        [ '$basetexture' ] = texFSB,
                        [ '$model' ] = "1",
                        -- [ '$basetexturetransform' ] = "center .5 .5 scale 1 1 rotate 0 translate 0 0",
                        [ '$alphatest' ] = "0",
						[ '$PortalMaskTexture' ] = "models/portals/portal-mask-dx8",
                        [ '$additive' ] = "0",
                        [ '$translucent' ] = "0",
                        [ '$ignorez' ] = "0"
                }
        )
		
if CLIENT then
	game.AddParticles("particles/portal_projectile.pcf")
	game.AddParticles("particles/portals.pcf")
	game.AddParticles("particles/portals_reverse.pcf")
	game.AddParticles("particles/portal_projectile_atlas.pcf")
	game.AddParticles("particles/portals_atlas.pcf")
	game.AddParticles("particles/portals_atlas_reverse.pcf")
	game.AddParticles("particles/portal_projectile_pbody.pcf")
	game.AddParticles("particles/portals_pbody.pcf")
	game.AddParticles("particles/portals_pbody_reverse.pcf")
	
	game.AddParticles("particles/portal_projectile_pink_green.pcf")
	game.AddParticles("particles/portals_pink_green.pcf")
	game.AddParticles("particles/portals_pink_green_reverse.pcf")
end

// rendergroup
ENT.RenderGroup = RENDERGROUP_BOTH

/*------------------------------------
        Initialize()
------------------------------------*/
function ENT:Initialize( )

        self:SetRenderBounds( self:OBBMins()*20, self:OBBMaxs()*20 )
       
        self.openpercent = 0
		self.openpercent_bordermat = 0.8
        self.openpercent_material = 0
		
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		
		if self:OnFloor() then
			self:SetRenderOrigin( self:GetPos() - Vector(0,0,20))
		else
			self:SetRenderOrigin( self:GetPos() )
		end
		
		-- self:SetRenderClipPlaneEnabled( true )
		-- self:SetRenderClipPlane( self:GetForward(), 5 )
       
end

usermessage.Hook("Portal:Moved", function(umsg)
        local ent = umsg:ReadEntity()
		local pos = umsg:ReadVector()
		local ang = umsg:ReadAngle()
        if ent and ent:IsValid() and ent.openpercent_bordermat then
                ent.openpercent_bordermat = 0.8
				
				ent:SetAngles(ang)
				if ent:OnFloor() then
					ent:SetRenderOrigin( pos - Vector(0,0,20) )
				else
					ent:SetRenderOrigin(pos)
				end
				-- ent:SetRenderClipPlane( ent:GetForward(), 5 )
        end
		
        if ent and ent:IsValid() and ent.openpercent then
                ent.openpercent = 0
				
				ent:SetAngles(ang)
				if ent:OnFloor() then
					ent:SetRenderOrigin( pos - Vector(0,0,20) )
				else
					ent:SetRenderOrigin(pos)
				end
				-- ent:SetRenderClipPlane( ent:GetForward(), 5 )
        end
		
        if ent and ent:IsValid() and ent.openpercent_material then
                ent.openpercent_material = 0
				
				ent:SetAngles(ang)
				if ent:OnFloor() then
					ent:SetRenderOrigin( pos - Vector(0,0,20) )
				else
					ent:SetRenderOrigin(pos)
				end
				-- ent:SetRenderClipPlane( ent:GetForward(), 5 )
        end
		
end)

--I think this is from sassilization..
local function IsInFront( posA, posB, normal )

        local Vec1 = ( posB - posA ):GetNormalized()

        return ( normal:Dot( Vec1 ) < 0 )
		-- return true

end

function ENT:Think()

        if self:GetNWBool("Potal:Activated",false) == false then return end
		self.openpercent = math.Approach( self.openpercent, 1, FrameTime() * 3.4 * ( 0.75 + self.openpercent - 0.49 ) )
		self.openpercent_bordermat = math.Approach( self.openpercent_bordermat, 0, FrameTime() * 1.5 )
        self.openpercent_material = math.Approach( self.openpercent_material, 1, FrameTime() * 0.75 )
		
        if dlightenabled:GetBool() == false then return end
       
        local portaltype = self:GetNWInt("Potal:PortalType",TYPE_BLUE)

if GetConVarNumber("portal_color_1") >=14 then
			glowcolor = Color(50,50,50,255)
		elseif GetConVarNumber("portal_color_1") >=13 then
			glowcolor = Color(200,200,200,255)
		elseif GetConVarNumber("portal_color_1") >=12 then
			glowcolor = Color(255,255,255,255)			
		elseif GetConVarNumber("portal_color_1") >=11 then
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(171,117,145,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(199,89,146,255)
			else		
			glowcolor = Color(255,32,150,255)
		end
			
		elseif GetConVarNumber("portal_color_1") >=10 then
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(171,117,171,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(198,89,199,255)
			else		
			glowcolor = Color(250,32,255,255)
		end
			
		elseif GetConVarNumber("portal_color_1") >=9 then
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(156,137,183,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(153,113,207,255)
			else		
			glowcolor = Color(145,64,255,255)
		end
			
		elseif GetConVarNumber("portal_color_1") >=8 then
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(117,124,171,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(89,104,199,255)
			else		
			glowcolor = Color(0,32,255,255)
		end
			
		elseif GetConVarNumber("portal_color_1") >=7 then
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(137,150,183,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(113,139,207,255)
			else		
			glowcolor = Color( 0, 80, 255, 255 )
		end
			
		elseif GetConVarNumber("portal_color_1") >=6 then
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(117,171,171,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(89,198,198,255)
			else		
			glowcolor = Color(32,250,255,255)
		end
			
		elseif GetConVarNumber("portal_color_1") >=5 then
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(114,164,143,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(87,195,145,255)
			else		
			glowcolor = Color(32,250,150,255)
		end
			
		elseif GetConVarNumber("portal_color_1") >=4 then
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(114,164,114,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(87,195,87,255)
			else		
			glowcolor = Color(32,250,32,255)
		end
			
		elseif GetConVarNumber("portal_color_1") >=3 then
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(132,156,94,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(139,188,62,255)
			else		
			glowcolor = Color(150,250,0,255)
		end
			
		elseif GetConVarNumber("portal_color_1") >=2 then
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(171,171,117,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(199,198,89,255)
			else		
			glowcolor = Color(255,250,32,255)
		end
			
		elseif GetConVarNumber("portal_color_1") >=1 then
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(171,144,117,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(199,143,83,255)
			else		
			glowcolor = Color( 255, 107, 0, 255 )
		end
		
		else
		
			if GetConVarNumber("portal_color_saturation_1") >=2 then
			glowcolor = Color(171,117,117,255)
			elseif GetConVarNumber("portal_color_saturation_1") >=1 then
			glowcolor = Color(199,89,89,255)
			else 
			glowcolor = Color(255,16,16,255)
			
		end
	end
	
if GetConVarNumber("portal_color_contraste_1") >=2 then	
brightness = 7
elseif GetConVarNumber("portal_color_contraste_1") >=1 then
brightness = 5
else
brightness = 3
end	

        if portaltype == TYPE_ORANGE then
if GetConVarNumber("portal_color_2") >=14 then
			glowcolor = Color(50,50,50,255)
		elseif GetConVarNumber("portal_color_2") >=13 then
			glowcolor = Color(200,200,200,255)
		elseif GetConVarNumber("portal_color_2") >=12 then
			glowcolor = Color(255,255,255,255)			
		elseif GetConVarNumber("portal_color_2") >=11 then
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(171,117,145,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(199,89,146,255)
			else		
			glowcolor = Color(255,32,150,255)
		end
			
		elseif GetConVarNumber("portal_color_2") >=10 then
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(171,117,171,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(198,89,199,255)
			else		
			glowcolor = Color(250,32,255,255)
		end
			
		elseif GetConVarNumber("portal_color_2") >=9 then
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(156,137,183,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(153,113,207,255)
			else		
			glowcolor = Color(145,64,255,255)
		end
			
		elseif GetConVarNumber("portal_color_2") >=8 then
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(117,124,171,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(89,104,199,255)
			else		
			glowcolor = Color(0,32,255,255)
		end
			
		elseif GetConVarNumber("portal_color_2") >=7 then
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(137,150,183,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(113,139,207,255)
			else		
			glowcolor = Color( 0, 80, 255, 255 )
		end
			
		elseif GetConVarNumber("portal_color_2") >=6 then
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(117,171,171,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(89,198,198,255)
			else		
			glowcolor = Color(32,250,255,255)
		end
			
		elseif GetConVarNumber("portal_color_2") >=5 then
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(114,164,143,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(87,195,145,255)
			else		
			glowcolor = Color(32,250,150,255)
		end
			
		elseif GetConVarNumber("portal_color_2") >=4 then
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(114,164,114,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(87,195,87,255)
			else		
			glowcolor = Color(32,250,32,255)
		end
			
		elseif GetConVarNumber("portal_color_2") >=3 then
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(132,156,94,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(139,188,62,255)
			else		
			glowcolor = Color(150,250,0,255)
		end
			
		elseif GetConVarNumber("portal_color_2") >=2 then
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(171,171,117,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(199,198,89,255)
			else		
			glowcolor = Color(255,250,32,255)
		end
			
		elseif GetConVarNumber("portal_color_2") >=1 then
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(171,144,117,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(199,143,83,255)
			else		
			glowcolor = Color( 255, 107, 0, 255 )
		end
		
		else
		
			if GetConVarNumber("portal_color_saturation_2") >=2 then
			glowcolor = Color(171,117,117,255)
			elseif GetConVarNumber("portal_color_saturation_2") >=1 then
			glowcolor = Color(199,89,89,255)
			else 
			glowcolor = Color(255,16,16,255)
			
		end
	end
	
if GetConVarNumber("portal_color_contraste_2") >=2 then	
brightness = 7
elseif GetConVarNumber("portal_color_contraste_2") >=1 then
brightness = 5
else
brightness = 3
end	
	
        end
       
        --[[if lightteleport:GetBool() then
       
                local portal = self:GetNWEntity( "Potal:Other", nil )
       
                if IsValid( portal ) then

                        glowvec = render.GetLightColor( portal:GetPos() ) * 255
                        glowcolor = Color( glowvec.x, glowvec.y, glowvec.z )
                       
                end
                       
        end]]
       -- if AvgFPS() > 60 then
        local dlight = DynamicLight( self:EntIndex() )
        if dlight then
			local col = glowcolor
			dlight.Pos = self:GetRenderOrigin() + self:GetAngles():Forward()
			dlight.r = col.r
			dlight.g = col.g
			dlight.b = col.b
			dlight.brightness = brightness
			dlight.Decay = 9999
			dlight.Size = 50
			dlight.DieTime = CurTime() + .9
			dlight.Style = 5
        end
		
	   -- end
end

				--Draw colored overlay.
color_red = Material("models/portals/color/portalstaticoverlay_red", "PortalRefract")
color_red_light = Material("models/portals/color/light/portalstaticoverlay_red", "PortalRefract")
color_red_dark = Material("models/portals/color/dark/portalstaticoverlay_red", "PortalRefract")
color_red_saturation = Material("models/portals/color/saturation/portalstaticoverlay_red", "PortalRefract")
color_red_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_red", "PortalRefract")
color_red_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_red", "PortalRefract")
color_red_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_red", "PortalRefract")
color_red_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_red", "PortalRefract")
color_red_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_red", "PortalRefract")

color_orange = Material("models/portals/color/portalstaticoverlay_orange", "PortalRefract")
color_orange_light = Material("models/portals/color/light/portalstaticoverlay_orange", "PortalRefract")
color_orange_dark = Material("models/portals/color/dark/portalstaticoverlay_orange", "PortalRefract")
color_orange_saturation = Material("models/portals/color/saturation/portalstaticoverlay_orange", "PortalRefract")
color_orange_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_orange", "PortalRefract")
color_orange_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_orange", "PortalRefract")
color_orange_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_orange", "PortalRefract")
color_orange_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_orange", "PortalRefract")
color_orange_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_orange", "PortalRefract")

color_yellow = Material("models/portals/color/portalstaticoverlay_yellow", "PortalRefract")
color_yellow_light = Material("models/portals/color/light/portalstaticoverlay_yellow", "PortalRefract")
color_yellow_dark = Material("models/portals/color/dark/portalstaticoverlay_yellow", "PortalRefract")
color_yellow_saturation = Material("models/portals/color/saturation/portalstaticoverlay_yellow", "PortalRefract")
color_yellow_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_yellow", "PortalRefract")
color_yellow_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_yellow", "PortalRefract")
color_yellow_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_yellow", "PortalRefract")
color_yellow_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_yellow", "PortalRefract")
color_yellow_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_yellow", "PortalRefract")

color_green1 = Material("models/portals/color/portalstaticoverlay_green1", "PortalRefract")
color_green1_light = Material("models/portals/color/light/portalstaticoverlay_green1", "PortalRefract")
color_green1_dark = Material("models/portals/color/dark/portalstaticoverlay_green1", "PortalRefract")
color_green1_saturation = Material("models/portals/color/saturation/portalstaticoverlay_green1", "PortalRefract")
color_green1_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_green1", "PortalRefract")
color_green1_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_green1", "PortalRefract")
color_green1_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_green1", "PortalRefract")
color_green1_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_green1", "PortalRefract")
color_green1_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_green1", "PortalRefract")

color_green = Material("models/portals/color/portalstaticoverlay_green", "PortalRefract")
color_green_light = Material("models/portals/color/light/portalstaticoverlay_green", "PortalRefract")
color_green_dark = Material("models/portals/color/dark/portalstaticoverlay_green", "PortalRefract")
color_green_saturation = Material("models/portals/color/saturation/portalstaticoverlay_green", "PortalRefract")
color_green_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_green", "PortalRefract")
color_green_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_green", "PortalRefract")
color_green_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_green", "PortalRefract")
color_green_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_green", "PortalRefract")
color_green_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_green", "PortalRefract")

color_green2 = Material("models/portals/color/portalstaticoverlay_green2", "PortalRefract")
color_green2_light = Material("models/portals/color/light/portalstaticoverlay_green2", "PortalRefract")
color_green2_dark = Material("models/portals/color/dark/portalstaticoverlay_green2", "PortalRefract")
color_green2_saturation = Material("models/portals/color/saturation/portalstaticoverlay_green2", "PortalRefract")
color_green2_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_green2", "PortalRefract")
color_green2_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_green2", "PortalRefract")
color_green2_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_green2", "PortalRefract")
color_green2_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_green2", "PortalRefract")
color_green2_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_green2", "PortalRefract")

color_blue_light = Material("models/portals/color/portalstaticoverlay_blue_light", "PortalRefract")
color_blue_light_light = Material("models/portals/color/light/portalstaticoverlay_blue_light", "PortalRefract")
color_blue_light_dark = Material("models/portals/color/dark/portalstaticoverlay_blue_light", "PortalRefract")
color_blue_light_saturation = Material("models/portals/color/saturation/portalstaticoverlay_blue_light", "PortalRefract")
color_blue_light_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_blue_light", "PortalRefract")
color_blue_light_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_blue_light", "PortalRefract")
color_blue_light_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_blue_light", "PortalRefract")
color_blue_light_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_blue_light", "PortalRefract")
color_blue_light_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_blue_light", "PortalRefract")

color_blue = Material("models/portals/color/portalstaticoverlay_blue", "PortalRefract")
color_light_blue = Material("models/portals/color/light/portalstaticoverlay_blue", "PortalRefract")
color_dark_blue = Material("models/portals/color/dark/portalstaticoverlay_blue", "PortalRefract")
color_blue_saturation = Material("models/portals/color/saturation/portalstaticoverlay_blue", "PortalRefract")
color_blue_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_blue", "PortalRefract")
color_blue_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_blue", "PortalRefract")
color_blue_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_blue", "PortalRefract")
color_blue_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_blue", "PortalRefract")
color_blue_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_blue", "PortalRefract")

color_blue_dark = Material("models/portals/color/portalstaticoverlay_blue_dark", "PortalRefract")
color_blue_dark_light = Material("models/portals/color/light/portalstaticoverlay_blue_dark", "PortalRefract")
color_blue_dark_dark = Material("models/portals/color/dark/portalstaticoverlay_blue_dark", "PortalRefract")
color_blue_dark_saturation = Material("models/portals/color/saturation/portalstaticoverlay_blue_dark", "PortalRefract")
color_blue_dark_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_blue_dark", "PortalRefract")
color_blue_dark_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_blue_dark", "PortalRefract")
color_blue_dark_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_blue_dark", "PortalRefract")
color_blue_dark_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_blue_dark", "PortalRefract")
color_blue_dark_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_blue_dark", "PortalRefract")


color_purple = Material("models/portals/color/portalstaticoverlay_purple", "PortalRefract")
color_purple_light = Material("models/portals/color/light/portalstaticoverlay_purple", "PortalRefract")
color_purple_dark = Material("models/portals/color/dark/portalstaticoverlay_purple", "PortalRefract")
color_purple_saturation = Material("models/portals/color/saturation/portalstaticoverlay_purple", "PortalRefract")
color_purple_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_purple", "PortalRefract")
color_purple_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_purple", "PortalRefract")
color_purple_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_purple", "PortalRefract")
color_purple_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_purple", "PortalRefract")
color_purple_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_purple", "PortalRefract")

color_pink = Material("models/portals/color/portalstaticoverlay_pink", "PortalRefract")
color_pink_light = Material("models/portals/color/light/portalstaticoverlay_pink", "PortalRefract")
color_pink_dark = Material("models/portals/color/dark/portalstaticoverlay_pink", "PortalRefract")
color_pink_saturation = Material("models/portals/color/saturation/portalstaticoverlay_pink", "PortalRefract")
color_pink_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_pink", "PortalRefract")
color_pink_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_pink", "PortalRefract")
color_pink_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_pink", "PortalRefract")
color_pink_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_pink", "PortalRefract")
color_pink_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_pink", "PortalRefract")

color_pink2 = Material("models/portals/color/portalstaticoverlay_pink2", "PortalRefract")
color_pink2_light = Material("models/portals/color/light/portalstaticoverlay_pink2", "PortalRefract")
color_pink2_dark = Material("models/portals/color/dark/portalstaticoverlay_pink2", "PortalRefract")
color_pink2_saturation = Material("models/portals/color/saturation/portalstaticoverlay_pink2", "PortalRefract")
color_pink2_saturation_light = Material("models/portals/color/saturation_light/portalstaticoverlay_pink2", "PortalRefract")
color_pink2_saturation_dark = Material("models/portals/color/saturation_dark/portalstaticoverlay_pink2", "PortalRefract")
color_pink2_saturation_low = Material("models/portals/color/saturation_low/portalstaticoverlay_pink2", "PortalRefract")
color_pink2_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_pink2", "PortalRefract")
color_pink2_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_pink2", "PortalRefract")

color_gray1 = Material("models/portals/color/portalstaticoverlay_gray1", "PortalRefract")
color_gray = Material("models/portals/color/portalstaticoverlay_gray", "PortalRefract")
color_gray2 = Material("models/portals/color/portalstaticoverlay_gray2", "PortalRefract")

two_color_red = Material("models/portals/color_(2)/portalstaticoverlay_red", "PortalRefract")
two_color_red_light = Material("models/portals/color_(2)/light/portalstaticoverlay_red", "PortalRefract")
two_color_red_dark = Material("models/portals/color_(2)/dark/portalstaticoverlay_red", "PortalRefract")
two_color_red_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_red", "PortalRefract")
two_color_red_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_red", "PortalRefract")
two_color_red_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_red", "PortalRefract")
two_color_red_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_red", "PortalRefract")
two_color_red_saturation_low_light = Material("models/portals/color/saturation_low_light/portalstaticoverlay_red", "PortalRefract")
two_color_red_saturation_low_dark = Material("models/portals/color/saturation_low_dark/portalstaticoverlay_red", "PortalRefract")

two_color_orange = Material("models/portals/color_(2)/portalstaticoverlay_orange", "PortalRefract")
two_color_orange_light = Material("models/portals/color_(2)/light/portalstaticoverlay_orange", "PortalRefract")
two_color_orange_dark = Material("models/portals/color_(2)/dark/portalstaticoverlay_orange", "PortalRefract")
two_color_orange_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_orange", "PortalRefract")
two_color_orange_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_orange", "PortalRefract")
two_color_orange_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_orange", "PortalRefract")
two_color_orange_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_orange", "PortalRefract")
two_color_orange_saturation_low_light = Material("models/portals/color_(2)/saturation_low_light/portalstaticoverlay_orange", "PortalRefract")
two_color_orange_saturation_low_dark = Material("models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_orange", "PortalRefract")

two_color_yellow = Material("models/portals/color_(2)/portalstaticoverlay_yellow", "PortalRefract")
two_color_yellow_light = Material("models/portals/color_(2)/light/portalstaticoverlay_yellow", "PortalRefract")
two_color_yellow_dark = Material("models/portals/color_(2)/dark/portalstaticoverlay_yellow", "PortalRefract")
two_color_yellow_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_yellow", "PortalRefract")
two_color_yellow_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_yellow", "PortalRefract")
two_color_yellow_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_yellow", "PortalRefract")
two_color_yellow_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_yellow", "PortalRefract")
two_color_yellow_saturation_low_light = Material("models/portals/color_(2)/saturation_low_light/portalstaticoverlay_yellow", "PortalRefract")
two_color_yellow_saturation_low_dark = Material("models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_yellow", "PortalRefract")

two_color_green1 = Material("models/portals/color_(2)/portalstaticoverlay_green1", "PortalRefract")
two_color_green1_light = Material("models/portals/color_(2)/light/portalstaticoverlay_green1", "PortalRefract")
two_color_green1_dark = Material("models/portals/color_(2)/dark/portalstaticoverlay_green1", "PortalRefract")
two_color_green1_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_green1", "PortalRefract")
two_color_green1_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_green1", "PortalRefract")
two_color_green1_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_green1", "PortalRefract")
two_color_green1_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_green1", "PortalRefract")
two_color_green1_saturation_low_light = Material("models/portals/color_(2)/saturation_low_light/portalstaticoverlay_green1", "PortalRefract")
two_color_green1_saturation_low_dark = Material("models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_green1", "PortalRefract")

two_color_green = Material("models/portals/color_(2)/portalstaticoverlay_green", "PortalRefract")
two_color_green_light = Material("models/portals/color_(2)/light/portalstaticoverlay_green", "PortalRefract")
two_color_green_dark = Material("models/portals/color_(2)/dark/portalstaticoverlay_green", "PortalRefract")
two_color_green_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_green", "PortalRefract")
two_color_green_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_green", "PortalRefract")
two_color_green_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_green", "PortalRefract")
two_color_green_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_green", "PortalRefract")
two_color_green_saturation_low_light = Material("models/portals/color_(2)/saturation_low_light/portalstaticoverlay_green", "PortalRefract")
two_color_green_saturation_low_dark = Material("models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_green", "PortalRefract")

two_color_green2 = Material("models/portals/color_(2)/portalstaticoverlay_green2", "PortalRefract")
two_color_green2_light = Material("models/portals/color_(2)/light/portalstaticoverlay_green2", "PortalRefract")
two_color_green2_dark = Material("models/portals/color_(2)/dark/portalstaticoverlay_green2", "PortalRefract")
two_color_green2_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_green2", "PortalRefract")
two_color_green2_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_green2", "PortalRefract")
two_color_green2_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_green2", "PortalRefract")
two_color_green2_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_green2", "PortalRefract")
two_color_green2_saturation_low_light = Material("models/portals/color_(2)/saturation_low_light/portalstaticoverlay_green2", "PortalRefract")
two_color_green2_saturation_low_dark = Material("models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_green2", "PortalRefract")

two_color_blue_light = Material("models/portals/color_(2)/portalstaticoverlay_blue_light", "PortalRefract")
two_color_blue_light_light = Material("models/portals/color_(2)/light/portalstaticoverlay_blue_light", "PortalRefract")
two_color_blue_light_dark = Material("models/portals/color_(2)/dark/portalstaticoverlay_blue_light", "PortalRefract")
two_color_blue_light_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_blue_light", "PortalRefract")
two_color_blue_light_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_blue_light", "PortalRefract")
two_color_blue_light_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_blue_light", "PortalRefract")
two_color_blue_light_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_blue_light", "PortalRefract")
two_color_blue_light_saturation_low_light = Material("models/portals/color_(2)/saturation_low_light/portalstaticoverlay_blue_light", "PortalRefract")
two_color_blue_light_saturation_low_dark = Material("models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_blue_light", "PortalRefract")

two_color_blue = Material("models/portals/color_(2)/portalstaticoverlay_blue", "PortalRefract")
two_color_light_blue = Material("models/portals/color_(2)/light/portalstaticoverlay_blue", "PortalRefract")
two_color_dark_blue = Material("models/portals/color_(2)/dark/portalstaticoverlay_blue", "PortalRefract")
two_color_blue_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_blue", "PortalRefract")
two_color_blue_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_blue", "PortalRefract")
two_color_blue_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_blue", "PortalRefract")
two_color_blue_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_blue", "PortalRefract")
two_color_blue_saturation_low_light = Material("models/portals/color_(2)/saturation_low_light/portalstaticoverlay_blue", "PortalRefract")
two_color_blue_saturation_low_dark = Material("models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_blue", "PortalRefract")

two_color_blue_dark = Material("models/portals/color_(2)/portalstaticoverlay_blue_dark", "PortalRefract")
two_color_blue_dark_light = Material("models/portals/color_(2)/light/portalstaticoverlay_blue_dark", "PortalRefract")
two_color_blue_dark_dark = Material("models/portals/color_(2)/dark/portalstaticoverlay_blue_dark", "PortalRefract")
two_color_blue_dark_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_blue_dark", "PortalRefract")
two_color_blue_dark_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_blue_dark", "PortalRefract")
two_color_blue_dark_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_blue_dark", "PortalRefract")
two_color_blue_dark_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_blue_dark", "PortalRefract")
two_color_blue_dark_saturation_low_light = Material("models/portals/color_(2)/saturation_low_light/portalstaticoverlay_blue_dark", "PortalRefract")
two_color_blue_dark_saturation_low_dark = Material("models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_blue_dark", "PortalRefract")


two_color_purple = Material("models/portals/color_(2)/portalstaticoverlay_purple", "PortalRefract")
two_color_purple_light = Material("models/portals/color_(2)/light/portalstaticoverlay_purple", "PortalRefract")
two_color_purple_dark = Material("models/portals/color_(2)/dark/portalstaticoverlay_purple", "PortalRefract")
two_color_purple_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_purple", "PortalRefract")
two_color_purple_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_purple", "PortalRefract")
two_color_purple_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_purple", "PortalRefract")
two_color_purple_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_purple", "PortalRefract")
two_color_purple_saturation_low_light = Material("models/portals/color_(2)/saturation_low_light/portalstaticoverlay_purple", "PortalRefract")
two_color_purple_saturation_low_dark = Material("models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_purple", "PortalRefract")

two_color_pink = Material("models/portals/color_(2)/portalstaticoverlay_pink", "PortalRefract")
two_color_pink_light = Material("models/portals/color_(2)/light/portalstaticoverlay_pink", "PortalRefract")
two_color_pink_dark = Material("models/portals/color_(2)/dark/portalstaticoverlay_pink", "PortalRefract")
two_color_pink_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_pink", "PortalRefract")
two_color_pink_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_pink", "PortalRefract")
two_color_pink_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_pink", "PortalRefract")
two_color_pink_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_pink", "PortalRefract")
two_color_pink_saturation_low_light = Material("models/portals/color_(2)/saturation_low_light/portalstaticoverlay_pink", "PortalRefract")
two_color_pink_saturation_low_dark = Material("models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_pink", "PortalRefract")

two_color_pink2 = Material("models/portals/color_(2)/portalstaticoverlay_pink2", "PortalRefract")
two_color_pink2_light = Material("models/portals/color_(2)/light/portalstaticoverlay_pink2", "PortalRefract")
two_color_pink2_dark = Material("models/portals/color_(2)/dark/portalstaticoverlay_pink2", "PortalRefract")
two_color_pink2_saturation = Material("models/portals/color_(2)/saturation/portalstaticoverlay_pink2", "PortalRefract")
two_color_pink2_saturation_light = Material("models/portals/color_(2)/saturation_light/portalstaticoverlay_pink2", "PortalRefract")
two_color_pink2_saturation_dark = Material("models/portals/color_(2)/saturation_dark/portalstaticoverlay_pink2", "PortalRefract")
two_color_pink2_saturation_low = Material("models/portals/color_(2)/saturation_low/portalstaticoverlay_pink2", "PortalRefract")
two_color_pink2_saturation_low_light = Material("models/portals/color_(2)/saturation_low_light/portalstaticoverlay_pink2", "PortalRefract")
two_color_pink2_saturation_low_dark = Material("models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_pink2", "PortalRefract")

two_color_gray1 = Material("models/portals/color_(2)/portalstaticoverlay_gray1", "PortalRefract")
two_color_gray = Material("models/portals/color_(2)/portalstaticoverlay_gray", "PortalRefract")
two_color_gray2 = Material("models/portals/color_(2)/portalstaticoverlay_gray2", "PortalRefract")

-- Portals Color Normal (Border)

-- Portals (1)
portals_red = surface.GetTextureID( "models/portals/color/portalstaticoverlay_red" )
portals_red_light = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_red" )
portals_red_dark = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_red" )
portals_red_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_red" )
portals_red_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_red" )
portals_red_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_red" )
portals_red_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_red" )
portals_red_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_red" )
portals_red_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_red" )

portals_orange = surface.GetTextureID( "models/portals/color/portalstaticoverlay_orange" )
portals_orange_light = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_orange" )
portals_orange_dark = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_orange" )
portals_orange_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_orange" )
portals_orange_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_orange" )
portals_orange_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_orange" )
portals_orange_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_orange" )
portals_orange_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_orange" )
portals_orange_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_orange" )

portals_yellow = surface.GetTextureID( "models/portals/color/portalstaticoverlay_yellow" )
portals_yellow_light = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_yellow" )
portals_yellow_dark = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_yellow" )
portals_yellow_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_yellow" )
portals_yellow_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_yellow" )
portals_yellow_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_yellow" )
portals_yellow_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_yellow" )
portals_yellow_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_yellow" )
portals_yellow_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_yellow" )

portals_green1 = surface.GetTextureID( "models/portals/color/portalstaticoverlay_green1" )
portals_green1_light = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_green1" )
portals_green1_dark = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_green1" )
portals_green1_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_green1" )
portals_green1_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_green1" )
portals_green1_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_green1" )
portals_green1_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_green1" )
portals_green1_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_green1" )
portals_green1_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_green1" )

portals_green = surface.GetTextureID( "models/portals/color/portalstaticoverlay_green" )
portals_green_light = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_green" )
portals_green_dark = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_green" )
portals_green_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_green" )
portals_green_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_green" )
portals_green_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_green" )
portals_green_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_green" )
portals_green_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_green" )
portals_green_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_green" )

portals_green2 = surface.GetTextureID( "models/portals/color/portalstaticoverlay_green2" )
portals_green2_light = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_green2" )
portals_green2_dark = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_green2" )
portals_green2_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_green2" )
portals_green2_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_green2" )
portals_green2_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_green2" )
portals_green2_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_green2" )
portals_green2_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_green2" )
portals_green2_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_green2" )

portals_blue_light = surface.GetTextureID( "models/portals/color/portalstaticoverlay_blue_light" )
portals_blue_light_light = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_blue_light" )
portals_blue_light_dark = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_blue_light" )
portals_blue_light_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_blue_light" )
portals_blue_light_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_blue_light" )
portals_blue_light_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_blue_light" )
portals_blue_light_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_blue_light" )
portals_blue_light_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_blue_light" )
portals_blue_light_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_blue_light" )

portals_blue = surface.GetTextureID( "models/portals/color/portalstaticoverlay_blue" )
portals_light_blue = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_blue" )
portals_dark_blue = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_blue" )
portals_blue_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_blue" )
portals_blue_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_blue" )
portals_blue_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_blue" )
portals_blue_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_blue" )
portals_blue_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_blue" )
portals_blue_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_blue" )

portals_blue_dark = surface.GetTextureID( "models/portals/color/portalstaticoverlay_blue_dark" )
portals_blue_dark_light = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_blue_dark" )
portals_blue_dark_dark = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_blue_dark" )
portals_blue_dark_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_blue_dark" )
portals_blue_dark_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_blue_dark" )
portals_blue_dark_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_blue_dark" )
portals_blue_dark_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_blue_dark" )
portals_blue_dark_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_blue_dark" )
portals_blue_dark_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_blue_dark" )


portals_purple = surface.GetTextureID( "models/portals/color/portalstaticoverlay_purple" )
portals_purple_light = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_purple" )
portals_purple_dark = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_purple" )
portals_purple_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_purple" )
portals_purple_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_purple" )
portals_purple_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_purple" )
portals_purple_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_purple" )
portals_purple_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_purple" )
portals_purple_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_purple" )

portals_pink = surface.GetTextureID( "models/portals/color/portalstaticoverlay_pink" )
portals_pink_light = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_pink" )
portals_pink_dark = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_pink" )
portals_pink_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_pink" )
portals_pink_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_pink" )
portals_pink_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_pink" )
portals_pink_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_pink" )
portals_pink_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_pink" )
portals_pink_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_pink" )

portals_pink2 = surface.GetTextureID( "models/portals/color/portalstaticoverlay_pink2" )
portals_pink2_light = surface.GetTextureID( "models/portals/color/light/portalstaticoverlay_pink2" )
portals_pink2_dark = surface.GetTextureID( "models/portals/color/dark/portalstaticoverlay_pink2" )
portals_pink2_saturation = surface.GetTextureID( "models/portals/color/saturation/portalstaticoverlay_pink2" )
portals_pink2_saturation_light = surface.GetTextureID( "models/portals/color/saturation_light/portalstaticoverlay_pink2" )
portals_pink2_saturation_dark = surface.GetTextureID( "models/portals/color/saturation_dark/portalstaticoverlay_pink2" )
portals_pink2_saturation_low = surface.GetTextureID( "models/portals/color/saturation_low/portalstaticoverlay_pink2" )
portals_pink2_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_pink2" )
portals_pink2_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_pink2" )

portals_gray1 = surface.GetTextureID( "models/portals/color/portalstaticoverlay_gray1" )
portals_gray = surface.GetTextureID( "models/portals/color/portalstaticoverlay_gray" )
portals_gray2 = surface.GetTextureID( "models/portals/color/portalstaticoverlay_gray2" )

-- Portals (2)

two_portals_red = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_red" )
two_portals_red_light = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_red" )
two_portals_red_dark = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_red" )
two_portals_red_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_red" )
two_portals_red_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_red" )
two_portals_red_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_red" )
two_portals_red_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_red" )
two_portals_red_saturation_low_light = surface.GetTextureID( "models/portals/color/saturation_low_light/portalstaticoverlay_red" )
two_portals_red_saturation_low_dark = surface.GetTextureID( "models/portals/color/saturation_low_dark/portalstaticoverlay_red" )

two_portals_orange = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_orange" )
two_portals_orange_light = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_orange" )
two_portals_orange_dark = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_orange" )
two_portals_orange_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_orange" )
two_portals_orange_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_orange" )
two_portals_orange_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_orange" )
two_portals_orange_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_orange" )
two_portals_orange_saturation_low_light = surface.GetTextureID( "models/portals/color_(2)/saturation_low_light/portalstaticoverlay_orange" )
two_portals_orange_saturation_low_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_orange" )

two_portals_yellow = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_yellow" )
two_portals_yellow_light = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_yellow" )
two_portals_yellow_dark = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_yellow" )
two_portals_yellow_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_yellow" )
two_portals_yellow_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_yellow" )
two_portals_yellow_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_yellow" )
two_portals_yellow_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_yellow" )
two_portals_yellow_saturation_low_light = surface.GetTextureID( "models/portals/color_(2)/saturation_low_light/portalstaticoverlay_yellow" )
two_portals_yellow_saturation_low_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_yellow" )

two_portals_green1 = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_green1" )
two_portals_green1_light = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_green1" )
two_portals_green1_dark = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_green1" )
two_portals_green1_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_green1" )
two_portals_green1_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_green1" )
two_portals_green1_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_green1" )
two_portals_green1_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_green1" )
two_portals_green1_saturation_low_light = surface.GetTextureID( "models/portals/color_(2)/saturation_low_light/portalstaticoverlay_green1" )
two_portals_green1_saturation_low_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_green1" )

two_portals_green = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_green" )
two_portals_green_light = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_green" )
two_portals_green_dark = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_green" )
two_portals_green_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_green" )
two_portals_green_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_green" )
two_portals_green_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_green" )
two_portals_green_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_green" )
two_portals_green_saturation_low_light = surface.GetTextureID( "models/portals/color_(2)/saturation_low_light/portalstaticoverlay_green" )
two_portals_green_saturation_low_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_green" )

two_portals_green2 = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_green2" )
two_portals_green2_light = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_green2" )
two_portals_green2_dark = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_green2" )
two_portals_green2_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_green2" )
two_portals_green2_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_green2" )
two_portals_green2_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_green2" )
two_portals_green2_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_green2" )
two_portals_green2_saturation_low_light = surface.GetTextureID( "models/portals/color_(2)/saturation_low_light/portalstaticoverlay_green2" )
two_portals_green2_saturation_low_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_green2" )

two_portals_blue_light = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_blue_light" )
two_portals_blue_light_light = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_blue_light" )
two_portals_blue_light_dark = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_blue_light" )
two_portals_blue_light_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_blue_light" )
two_portals_blue_light_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_blue_light" )
two_portals_blue_light_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_blue_light" )
two_portals_blue_light_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_blue_light" )
two_portals_blue_light_saturation_low_light = surface.GetTextureID( "models/portals/color_(2)/saturation_low_light/portalstaticoverlay_blue_light" )
two_portals_blue_light_saturation_low_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_blue_light" )

two_portals_blue = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_blue" )
two_portals_light_blue = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_blue" )
two_portals_dark_blue = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_blue" )
two_portals_blue_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_blue" )
two_portals_blue_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_blue" )
two_portals_blue_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_blue" )
two_portals_blue_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_blue" )
two_portals_blue_saturation_low_light = surface.GetTextureID( "models/portals/color_(2)/saturation_low_light/portalstaticoverlay_blue" )
two_portals_blue_saturation_low_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_blue" )

two_portals_blue_dark = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_blue_dark" )
two_portals_blue_dark_light = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_blue_dark" )
two_portals_blue_dark_dark = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_blue_dark" )
two_portals_blue_dark_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_blue_dark" )
two_portals_blue_dark_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_blue_dark" )
two_portals_blue_dark_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_blue_dark" )
two_portals_blue_dark_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_blue_dark" )
two_portals_blue_dark_saturation_low_light = surface.GetTextureID( "models/portals/color_(2)/saturation_low_light/portalstaticoverlay_blue_dark" )
two_portals_blue_dark_saturation_low_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_blue_dark" )


two_portals_purple = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_purple" )
two_portals_purple_light = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_purple" )
two_portals_purple_dark = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_purple" )
two_portals_purple_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_purple" )
two_portals_purple_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_purple" )
two_portals_purple_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_purple" )
two_portals_purple_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_purple" )
two_portals_purple_saturation_low_light = surface.GetTextureID( "models/portals/color_(2)/saturation_low_light/portalstaticoverlay_purple" )
two_portals_purple_saturation_low_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_purple" )

two_portals_pink = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_pink" )
two_portals_pink_light = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_pink" )
two_portals_pink_dark = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_pink" )
two_portals_pink_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_pink" )
two_portals_pink_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_pink" )
two_portals_pink_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_pink" )
two_portals_pink_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_pink" )
two_portals_pink_saturation_low_light = surface.GetTextureID( "models/portals/color_(2)/saturation_low_light/portalstaticoverlay_pink" )
two_portals_pink_saturation_low_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_pink" )

two_portals_pink2 = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_pink2" )
two_portals_pink2_light = surface.GetTextureID( "models/portals/color_(2)/light/portalstaticoverlay_pink2" )
two_portals_pink2_dark = surface.GetTextureID( "models/portals/color_(2)/dark/portalstaticoverlay_pink2" )
two_portals_pink2_saturation = surface.GetTextureID( "models/portals/color_(2)/saturation/portalstaticoverlay_pink2" )
two_portals_pink2_saturation_light = surface.GetTextureID( "models/portals/color_(2)/saturation_light/portalstaticoverlay_pink2" )
two_portals_pink2_saturation_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_dark/portalstaticoverlay_pink2" )
two_portals_pink2_saturation_low = surface.GetTextureID( "models/portals/color_(2)/saturation_low/portalstaticoverlay_pink2" )
two_portals_pink2_saturation_low_light = surface.GetTextureID( "models/portals/color_(2)/saturation_low_light/portalstaticoverlay_pink2" )
two_portals_pink2_saturation_low_dark = surface.GetTextureID( "models/portals/color_(2)/saturation_low_dark/portalstaticoverlay_pink2" )

two_portals_gray1 = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_gray1" )
two_portals_gray = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_gray" )
two_portals_gray2 = surface.GetTextureID( "models/portals/color_(2)/portalstaticoverlay_gray2" )

function ENT:DrawPortalEffects( portaltype )

        local ang = self:GetAngles()
       
        local res = 0.1
       
        local percentopen = 1
       
        local width = ( percentopen ) * 65
        local height = ( percentopen ) * 112
		
       
        ang:RotateAroundAxis( ang:Right(), -90 )
        ang:RotateAroundAxis( ang:Up(), 90 )
       
        local origin = self:GetRenderOrigin() + ( self:GetForward() * 0.1 ) - ( self:GetUp() * height / -2 ) - ( self:GetRight() * width / -2 )
       
        cam.Start3D2D( origin, ang, res )
       
                surface.SetDrawColor( 255, 255, 255, 255 )
 
color_red:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_red_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_orange:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_orange_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_yellow:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_yellow_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_green1:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green1_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_green:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_green2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_green2_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_blue_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_light_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_light_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_dark_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_blue_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_blue_dark_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))


color_purple:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_purple_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_pink:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_pink2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_pink2_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

color_gray1:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_gray:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
color_gray2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_red:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_red_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_orange:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_orange_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_yellow:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_yellow_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_green1:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green1_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_green:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_green2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_green2_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_blue_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_light_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_light_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_dark_blue:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_blue_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_blue_dark_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))


two_color_purple:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_purple_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_pink:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_pink2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation_low:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation_low_light:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_pink2_saturation_low_dark:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))

two_color_gray1:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_gray:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
two_color_gray2:SetFloat("$PortalOpenAmount", 1-math.min(self.openpercent_bordermat))
 
                if ( RENDERING_PORTAL or !self:GetNWBool( "Potal:Linked", false ) or !self:GetNWBool( "Potal:Activated", false )) then
     
color_red:SetFloat("$PortalStatic", 1)
color_red_light:SetFloat("$PortalStatic", 1)
color_red_dark:SetFloat("$PortalStatic", 1)
color_red_saturation:SetFloat("$PortalStatic", 1)
color_red_saturation_light:SetFloat("$PortalStatic", 1)
color_red_saturation_dark:SetFloat("$PortalStatic", 1)
color_red_saturation_low:SetFloat("$PortalStatic", 1)
color_red_saturation_low_light:SetFloat("$PortalStatic", 1)
color_red_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_orange:SetFloat("$PortalStatic", 1)
color_orange_light:SetFloat("$PortalStatic", 1)
color_orange_dark:SetFloat("$PortalStatic", 1)
color_orange_saturation:SetFloat("$PortalStatic", 1)
color_orange_saturation_light:SetFloat("$PortalStatic", 1)
color_orange_saturation_dark:SetFloat("$PortalStatic", 1)
color_orange_saturation_low:SetFloat("$PortalStatic", 1)
color_orange_saturation_low_light:SetFloat("$PortalStatic", 1)
color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_yellow:SetFloat("$PortalStatic", 1)
color_yellow_light:SetFloat("$PortalStatic", 1)
color_yellow_dark:SetFloat("$PortalStatic", 1)
color_yellow_saturation:SetFloat("$PortalStatic", 1)
color_yellow_saturation_light:SetFloat("$PortalStatic", 1)
color_yellow_saturation_dark:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green1:SetFloat("$PortalStatic", 1)
color_green1_light:SetFloat("$PortalStatic", 1)
color_green1_dark:SetFloat("$PortalStatic", 1)
color_green1_saturation:SetFloat("$PortalStatic", 1)
color_green1_saturation_light:SetFloat("$PortalStatic", 1)
color_green1_saturation_dark:SetFloat("$PortalStatic", 1)
color_green1_saturation_low:SetFloat("$PortalStatic", 1)
color_green1_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green:SetFloat("$PortalStatic", 1)
color_green_light:SetFloat("$PortalStatic", 1)
color_green_dark:SetFloat("$PortalStatic", 1)
color_green_saturation:SetFloat("$PortalStatic", 1)
color_green_saturation_light:SetFloat("$PortalStatic", 1)
color_green_saturation_dark:SetFloat("$PortalStatic", 1)
color_green_saturation_low:SetFloat("$PortalStatic", 1)
color_green_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green2:SetFloat("$PortalStatic", 1)
color_green2_light:SetFloat("$PortalStatic", 1)
color_green2_dark:SetFloat("$PortalStatic", 1)
color_green2_saturation:SetFloat("$PortalStatic", 1)
color_green2_saturation_light:SetFloat("$PortalStatic", 1)
color_green2_saturation_dark:SetFloat("$PortalStatic", 1)
color_green2_saturation_low:SetFloat("$PortalStatic", 1)
color_green2_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue_light:SetFloat("$PortalStatic", 1)
color_blue_light_light:SetFloat("$PortalStatic", 1)
color_blue_light_dark:SetFloat("$PortalStatic", 1)
color_blue_light_saturation:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue:SetFloat("$PortalStatic", 1)
color_light_blue:SetFloat("$PortalStatic", 1)
color_dark_blue:SetFloat("$PortalStatic", 1)
color_blue_saturation:SetFloat("$PortalStatic", 1)
color_blue_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_light:SetFloat("$PortalStatic", 1)
color_blue_dark_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1)


color_purple:SetFloat("$PortalStatic", 1)
color_purple_light:SetFloat("$PortalStatic", 1)
color_purple_dark:SetFloat("$PortalStatic", 1)
color_purple_saturation:SetFloat("$PortalStatic", 1)
color_purple_saturation_light:SetFloat("$PortalStatic", 1)
color_purple_saturation_dark:SetFloat("$PortalStatic", 1)
color_purple_saturation_low:SetFloat("$PortalStatic", 1)
color_purple_saturation_low_light:SetFloat("$PortalStatic", 1)
color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_pink:SetFloat("$PortalStatic", 1)
color_pink_light:SetFloat("$PortalStatic", 1)
color_pink_dark:SetFloat("$PortalStatic", 1)
color_pink_saturation:SetFloat("$PortalStatic", 1)
color_pink_saturation_light:SetFloat("$PortalStatic", 1)
color_pink_saturation_dark:SetFloat("$PortalStatic", 1)
color_pink_saturation_low:SetFloat("$PortalStatic", 1)
color_pink_saturation_low_light:SetFloat("$PortalStatic", 1)
color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_pink2:SetFloat("$PortalStatic", 1)
color_pink2_light:SetFloat("$PortalStatic", 1)
color_pink2_dark:SetFloat("$PortalStatic", 1)
color_pink2_saturation:SetFloat("$PortalStatic", 1)
color_pink2_saturation_light:SetFloat("$PortalStatic", 1)
color_pink2_saturation_dark:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_gray1:SetFloat("$PortalStatic", 1)
color_gray:SetFloat("$PortalStatic", 1)
color_gray2:SetFloat("$PortalStatic", 1)

two_color_red:SetFloat("$PortalStatic", 1)
two_color_red_light:SetFloat("$PortalStatic", 1)
two_color_red_dark:SetFloat("$PortalStatic", 1)
two_color_red_saturation:SetFloat("$PortalStatic", 1)
two_color_red_saturation_light:SetFloat("$PortalStatic", 1)
two_color_red_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_orange:SetFloat("$PortalStatic", 1)
two_color_orange_light:SetFloat("$PortalStatic", 1)
two_color_orange_dark:SetFloat("$PortalStatic", 1)
two_color_orange_saturation:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_light:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_yellow:SetFloat("$PortalStatic", 1)
two_color_yellow_light:SetFloat("$PortalStatic", 1)
two_color_yellow_dark:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_light:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green1:SetFloat("$PortalStatic", 1)
two_color_green1_light:SetFloat("$PortalStatic", 1)
two_color_green1_dark:SetFloat("$PortalStatic", 1)
two_color_green1_saturation:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green:SetFloat("$PortalStatic", 1)
two_color_green_light:SetFloat("$PortalStatic", 1)
two_color_green_dark:SetFloat("$PortalStatic", 1)
two_color_green_saturation:SetFloat("$PortalStatic", 1)
two_color_green_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green2:SetFloat("$PortalStatic", 1)
two_color_green2_light:SetFloat("$PortalStatic", 1)
two_color_green2_dark:SetFloat("$PortalStatic", 1)
two_color_green2_saturation:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_dark:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue:SetFloat("$PortalStatic", 1)
two_color_light_blue:SetFloat("$PortalStatic", 1)
two_color_dark_blue:SetFloat("$PortalStatic", 1)
two_color_blue_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1)


two_color_purple:SetFloat("$PortalStatic", 1)
two_color_purple_light:SetFloat("$PortalStatic", 1)
two_color_purple_dark:SetFloat("$PortalStatic", 1)
two_color_purple_saturation:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_light:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_pink:SetFloat("$PortalStatic", 1)
two_color_pink_light:SetFloat("$PortalStatic", 1)
two_color_pink_dark:SetFloat("$PortalStatic", 1)
two_color_pink_saturation:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_light:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_pink2:SetFloat("$PortalStatic", 1)
two_color_pink2_light:SetFloat("$PortalStatic", 1)
two_color_pink2_dark:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_light:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_gray1:SetFloat("$PortalStatic", 1)
two_color_gray:SetFloat("$PortalStatic", 1)
two_color_gray2:SetFloat("$PortalStatic", 1)

			   
                        if portaltype == TYPE_BLUE then
						if GetConVarNumber("portal_color_1") >=14 then
                                        surface.SetTexture( portals_gray2 )
								elseif GetConVarNumber("portal_color_1") >=13 then
                                        surface.SetTexture( portals_gray )
								elseif GetConVarNumber("portal_color_1") >=12 then
                                        surface.SetTexture( portals_gray1 )
								elseif GetConVarNumber("portal_color_1") >=11 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation_light )
									else surface.SetTexture( portals_pink2_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation )
									else surface.SetTexture( portals_pink2 ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation_dark )
									else surface.SetTexture( portals_pink2_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=10 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation_light )
									else surface.SetTexture( portals_pink_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation )
									else surface.SetTexture( portals_pink ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation_dark )
									else surface.SetTexture( portals_pink_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=9 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation_light )
									else surface.SetTexture( portals_purple_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation )
									else surface.SetTexture( portals_purple ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation_dark )
									else surface.SetTexture( portals_purple_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=8 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_light )
									else surface.SetTexture( portals_blue_dark_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation )
									else surface.SetTexture( portals_blue_dark ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_dark )
									else surface.SetTexture( portals_blue_dark_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=7 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation_light )
									else surface.SetTexture( portals_light_blue ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation )
									else surface.SetTexture( portals_blue ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation_dark )
									else surface.SetTexture( portals_dark_blue ) end
							end
								elseif GetConVarNumber("portal_color_1") >=6 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_light )
									else surface.SetTexture( portals_blue_light_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation )
									else surface.SetTexture( portals_blue_light ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_dark )
									else surface.SetTexture( portals_blue_light_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=5 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation_light )
									else surface.SetTexture( portals_green2_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation )
									else surface.SetTexture( portals_green2 ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation_dark )
									else surface.SetTexture( portals_green2_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=4 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation_light )
									else surface.SetTexture( portals_green_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation )
									else surface.SetTexture( portals_green ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation_dark )
									else surface.SetTexture( portals_green_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=3 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation_light )
									else surface.SetTexture( portals_green1_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation )
									else surface.SetTexture( portals_green1 ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation_dark )
									else surface.SetTexture( portals_green1_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=2 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation_light )
									else surface.SetTexture( portals_yellow_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation )
									else surface.SetTexture( portals_yellow ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation_dark )
									else surface.SetTexture( portals_yellow_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=1 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation_light )
									else surface.SetTexture( portals_orange_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation )
									else surface.SetTexture( portals_orange ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation_dark )
									else surface.SetTexture( portals_orange_dark ) end
							end
								else
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation_light )
									else surface.SetTexture( portals_red_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation )
									else surface.SetTexture( portals_red ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation_dark )
									else surface.SetTexture( portals_red_dark ) end
							end
				end
								
                        elseif portaltype == TYPE_ORANGE then
						
						if GetConVarNumber("portal_color_2") >=14 then
                                        surface.SetTexture( portals_gray2 )
								elseif GetConVarNumber("portal_color_2") >=13 then
                                        surface.SetTexture( portals_gray )
								elseif GetConVarNumber("portal_color_2") >=12 then
                                        surface.SetTexture( portals_gray1 )
								elseif GetConVarNumber("portal_color_2") >=11 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_pink2_saturation_light )
									else surface.SetTexture( portals_pink2_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_pink2_saturation )
									else surface.SetTexture( portals_pink2 ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_pink2_saturation_dark )
									else surface.SetTexture( portals_pink2_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=10 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_pink_saturation_light )
									else surface.SetTexture( portals_pink_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_pink_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_pink_saturation )
									else surface.SetTexture( portals_pink ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_pink_saturation_dark )
									else surface.SetTexture( portals_pink_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=9 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_purple_saturation_light )
									else surface.SetTexture( portals_purple_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_purple_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_purple_saturation )
									else surface.SetTexture( portals_purple ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_purple_saturation_dark )
									else surface.SetTexture( portals_purple_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=8 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_light )
									else surface.SetTexture( portals_blue_dark_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation )
									else surface.SetTexture( portals_blue_dark ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_dark )
									else surface.SetTexture( portals_blue_dark_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=7 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_saturation_light )
									else surface.SetTexture( portals_light_blue ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_saturation )
									else surface.SetTexture( portals_blue ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_saturation_dark )
									else surface.SetTexture( portals_dark_blue ) end
							end
								elseif GetConVarNumber("portal_color_2") >=6 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_light )
									else surface.SetTexture( portals_blue_light_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_light_saturation )
									else surface.SetTexture( portals_blue_light ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_dark )
									else surface.SetTexture( portals_blue_light_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=5 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_green2_saturation_light )
									else surface.SetTexture( portals_green2_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_green2_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_green2_saturation )
									else surface.SetTexture( portals_green2 ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_green2_saturation_dark )
									else surface.SetTexture( portals_green2_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=4 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_green_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_green_saturation_light )
									else surface.SetTexture( portals_green_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_green_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_green_saturation )
									else surface.SetTexture( portals_green ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_green_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_green_saturation_dark )
									else surface.SetTexture( portals_green_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=3 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_green1_saturation_light )
									else surface.SetTexture( portals_green1_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_green1_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_green1_saturation )
									else surface.SetTexture( portals_green1 ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_green1_saturation_dark )
									else surface.SetTexture( portals_green1_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=2 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_yellow_saturation_light )
									else surface.SetTexture( portals_yellow_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_yellow_saturation )
									else surface.SetTexture( portals_yellow ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_yellow_saturation_dark )
									else surface.SetTexture( portals_yellow_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=1 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_orange_saturation_light )
									else surface.SetTexture( portals_orange_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_orange_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_orange_saturation )
									else surface.SetTexture( portals_orange ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_orange_saturation_dark )
									else surface.SetTexture( portals_orange_dark ) end
							end
								else
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_red_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_red_saturation_light )
									else surface.SetTexture( portals_red_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_red_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_red_saturation )
									else surface.SetTexture( portals_red ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( portals_red_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( portals_red_saturation_dark )
									else surface.SetTexture( portals_red_dark ) end
							end
				end

						end
                       
                        surface.DrawTexturedRect( 0, 0, width / res , height / res )
                       
                end
				
                if bordersenabled:GetBool() == true then                    
                        if portaltype == TYPE_BLUE then
						   if ( self:GetNWBool( "Potal:Linked", false ) or !self:GetNWBool( "Potal:Activated", false )) then

						if GetConVarNumber("portal_color_1") >=14 then
                                        surface.SetTexture( portals_gray2 )
								elseif GetConVarNumber("portal_color_1") >=13 then
                                        surface.SetTexture( portals_gray )
								elseif GetConVarNumber("portal_color_1") >=12 then
                                        surface.SetTexture( portals_gray1 )
								elseif GetConVarNumber("portal_color_1") >=11 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation_light )
									else surface.SetTexture( portals_pink2_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation )
									else surface.SetTexture( portals_pink2 ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink2_saturation_dark )
									else surface.SetTexture( portals_pink2_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=10 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation_light )
									else surface.SetTexture( portals_pink_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation )
									else surface.SetTexture( portals_pink ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_pink_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_pink_saturation_dark )
									else surface.SetTexture( portals_pink_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=9 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation_light )
									else surface.SetTexture( portals_purple_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation )
									else surface.SetTexture( portals_purple ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_purple_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_purple_saturation_dark )
									else surface.SetTexture( portals_purple_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=8 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_light )
									else surface.SetTexture( portals_blue_dark_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation )
									else surface.SetTexture( portals_blue_dark ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_dark_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_dark_saturation_dark )
									else surface.SetTexture( portals_blue_dark_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=7 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation_light )
									else surface.SetTexture( portals_light_blue ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation )
									else surface.SetTexture( portals_blue ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_saturation_dark )
									else surface.SetTexture( portals_dark_blue ) end
							end
								elseif GetConVarNumber("portal_color_1") >=6 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_light )
									else surface.SetTexture( portals_blue_light_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation )
									else surface.SetTexture( portals_blue_light ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_blue_light_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_blue_light_saturation_dark )
									else surface.SetTexture( portals_blue_light_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=5 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation_light )
									else surface.SetTexture( portals_green2_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation )
									else surface.SetTexture( portals_green2 ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green2_saturation_dark )
									else surface.SetTexture( portals_green2_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=4 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation_light )
									else surface.SetTexture( portals_green_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation )
									else surface.SetTexture( portals_green ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green_saturation_dark )
									else surface.SetTexture( portals_green_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=3 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation_light )
									else surface.SetTexture( portals_green1_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation )
									else surface.SetTexture( portals_green1 ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_green1_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_green1_saturation_dark )
									else surface.SetTexture( portals_green1_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=2 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation_light )
									else surface.SetTexture( portals_yellow_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation )
									else surface.SetTexture( portals_yellow ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_yellow_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_yellow_saturation_dark )
									else surface.SetTexture( portals_yellow_dark ) end
							end
								elseif GetConVarNumber("portal_color_1") >=1 then
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation_light )
									else surface.SetTexture( portals_orange_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation )
									else surface.SetTexture( portals_orange ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_orange_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_orange_saturation_dark )
									else surface.SetTexture( portals_orange_dark ) end
							end
								else
							if GetConVarNumber("portal_color_contraste_1") >=2 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation_light )
									else surface.SetTexture( portals_red_light ) end
							elseif GetConVarNumber("portal_color_contraste_1") >=1 then 
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation )
									else surface.SetTexture( portals_red ) end
							else
									if GetConVarNumber("portal_color_saturation_1") >=2 then 
										surface.SetTexture( portals_red_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_1") >=1 then 
											surface.SetTexture( portals_red_saturation_dark )
									else surface.SetTexture( portals_red_dark ) end
							end
				end

                    end
                               
                                surface.DrawTexturedRect( 0, 0, width / res , height / res )
                               
                        elseif portaltype == TYPE_ORANGE then
                             if ( self:GetNWBool( "Potal:Linked", false ) or !self:GetNWBool( "Potal:Activated", false )) then

						if GetConVarNumber("portal_color_2") >=14 then
                                        surface.SetTexture( two_portals_gray2 )
								elseif GetConVarNumber("portal_color_2") >=13 then
                                        surface.SetTexture( two_portals_gray )
								elseif GetConVarNumber("portal_color_2") >=12 then
                                        surface.SetTexture( two_portals_gray1 )
								elseif GetConVarNumber("portal_color_2") >=11 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink2_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink2_saturation_light )
									else surface.SetTexture( two_portals_pink2_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink2_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink2_saturation )
									else surface.SetTexture( two_portals_pink2 ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink2_saturation_dark )
									else surface.SetTexture( two_portals_pink2_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=10 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink_saturation_light )
									else surface.SetTexture( two_portals_pink_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink_saturation )
									else surface.SetTexture( two_portals_pink ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_pink_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_pink_saturation_dark )
									else surface.SetTexture( two_portals_pink_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=9 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_purple_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_purple_saturation_light )
									else surface.SetTexture( two_portals_purple_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_purple_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_purple_saturation )
									else surface.SetTexture( two_portals_purple ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_purple_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_purple_saturation_dark )
									else surface.SetTexture( two_portals_purple_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=8 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_dark_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_dark_saturation_light )
									else surface.SetTexture( two_portals_blue_dark_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_dark_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_dark_saturation )
									else surface.SetTexture( two_portals_blue_dark ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_dark_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_dark_saturation_dark )
									else surface.SetTexture( two_portals_blue_dark_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=7 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_saturation_light )
									else surface.SetTexture( two_portals_light_blue ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_saturation )
									else surface.SetTexture( two_portals_blue ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_saturation_dark )
									else surface.SetTexture( two_portals_dark_blue ) end
							end
								elseif GetConVarNumber("portal_color_2") >=6 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_light_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_light_saturation_light )
									else surface.SetTexture( two_portals_blue_light_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_light_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_light_saturation )
									else surface.SetTexture( two_portals_blue_light ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_blue_light_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_blue_light_saturation_dark )
									else surface.SetTexture( two_portals_blue_light_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=5 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green2_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green2_saturation_light )
									else surface.SetTexture( two_portals_green2_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green2_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green2_saturation )
									else surface.SetTexture( two_portals_green2 ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green2_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green2_saturation_dark )
									else surface.SetTexture( two_portals_green2_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=4 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green_saturation_light )
									else surface.SetTexture( two_portals_green_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green_saturation )
									else surface.SetTexture( two_portals_green ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green_saturation_dark )
									else surface.SetTexture( two_portals_green_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=3 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green1_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green1_saturation_light )
									else surface.SetTexture( two_portals_green1_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green1_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green1_saturation )
									else surface.SetTexture( two_portals_green1 ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_green1_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_green1_saturation_dark )
									else surface.SetTexture( two_portals_green1_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=2 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_yellow_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_yellow_saturation_light )
									else surface.SetTexture( two_portals_yellow_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_yellow_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_yellow_saturation )
									else surface.SetTexture( two_portals_yellow ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_yellow_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_yellow_saturation_dark )
									else surface.SetTexture( two_portals_yellow_dark ) end
							end
								elseif GetConVarNumber("portal_color_2") >=1 then
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_orange_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_orange_saturation_light )
									else surface.SetTexture( two_portals_orange_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_orange_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_orange_saturation )
									else surface.SetTexture( two_portals_orange ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_orange_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_orange_saturation_dark )
									else surface.SetTexture( two_portals_orange_dark ) end
							end
								else
							if GetConVarNumber("portal_color_contraste_2") >=2 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_red_saturation_low_light )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_red_saturation_light )
									else surface.SetTexture( two_portals_red_light ) end
							elseif GetConVarNumber("portal_color_contraste_2") >=1 then 
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_red_saturation_low )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_red_saturation )
									else surface.SetTexture( two_portals_red ) end
							else
									if GetConVarNumber("portal_color_saturation_2") >=2 then 
										surface.SetTexture( two_portals_red_saturation_low_dark )
									elseif GetConVarNumber("portal_color_saturation_2") >=1 then 
											surface.SetTexture( two_portals_red_saturation_dark )
									else surface.SetTexture( two_portals_red_dark ) end
							end
				end

                             end
                                surface.DrawTexturedRect( 0, 0, width / res , height / res )
                               
                        end
                       
                end
               
        cam.End3D2D()
       
end

function ENT:Draw()
	self:SetModelScale( self.openpercent,0 )
	self:DrawModel()
	self:SetColor(Color(255,255,255,0))
	
end
function ENT:DrawPortal()
	local viewent = GetViewEntity()
	local pos = ( IsValid( viewent ) and viewent != LocalPlayer() ) and GetViewEntity():GetPos() or EyePos()

	if IsInFront( pos, self:GetRenderOrigin(), self:GetForward() ) and self:GetNWBool("Potal:Activated",false) then
		
		render.ClearStencil() -- Make sure the stencil buffer is all zeroes before we begin
		render.SetStencilEnable( true )
		
			cam.Start3D2D(self:GetRenderOrigin(),self:GetAngles(),1)
				
				render.SetStencilWriteMask(3)
				render.SetStencilTestMask(3)
				render.SetStencilFailOperation( STENCILOPERATION_KEEP )
				render.SetStencilZFailOperation( STENCILOPERATION_KEEP )  -- Don't change anything if the pixel is occoludded (so we don't see things thru walls)
				render.SetStencilPassOperation( STENCILOPERATION_REPLACE ) -- Replace the value of the buffer's pixel with the reference value
				render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS) -- Always replace regardless of whatever is in the stencil buffer currently

				render.SetStencilReferenceValue( 1 )
			   
				local percentopen = self.openpercent
				self:SetModelScale( percentopen,0 )
				self:DrawModel()
				
				render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
				
				--Draw portal.
				local portaltype = self:GetNWInt( "Potal:PortalType",TYPE_BLUE )
				if renderportals:GetBool() then
				local ToRT = portaltype == TYPE_BLUE and texFSB or texFSB2
				local no_RT = Material ("effects/tvscreen_noise002a")
				if GetConVarNumber("portal_texFSB") >=2 then
					PortalMaterial:SetTexture( "$basetexture", ToRT )
					render.SetMaterial( no_RT )
					render.DrawScreenQuad()
	
				elseif GetConVarNumber("portal_texFSB") >=1 then
					PortalMaterial:SetTexture( "$basetexture", ToRT )
					render.SetMaterial( no_RT )
					render.DrawScreenQuad()
					
				else
					PortalMaterial:SetTexture( "$basetexture", ToRT )
					render.SetMaterial( PortalMaterial )
					render.DrawScreenQuad()

				end
				end
				
				--Draw colored overlay.

				if portaltype == TYPE_ORANGE then

				end
				local other = self:GetNWEntity("Potal:Other")
				if other and other:IsValid() and other.openpercent_material then
					if renderportals:GetBool() then
					
color_red:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_red_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_orange:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_yellow:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_green1:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_green:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_green2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_blue_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_light_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_dark_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_blue_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))


color_purple:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_pink:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_pink2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

color_gray1:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_gray:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
color_gray2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_red:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_red_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_orange:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_yellow:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_green1:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_green:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_green2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_blue_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_light_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_dark_blue:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_blue_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))


two_color_purple:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_pink:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_pink2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation_low:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))

two_color_gray1:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_gray:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
two_color_gray2:SetFloat("$PortalStatic", 1-math.min(other.openpercent_material))
					
					else
					
color_red:SetFloat("$PortalStatic", 1)
color_red_light:SetFloat("$PortalStatic", 1)
color_red_dark:SetFloat("$PortalStatic", 1)
color_red_saturation:SetFloat("$PortalStatic", 1)
color_red_saturation_light:SetFloat("$PortalStatic", 1)
color_red_saturation_dark:SetFloat("$PortalStatic", 1)
color_red_saturation_low:SetFloat("$PortalStatic", 1)
color_red_saturation_low_light:SetFloat("$PortalStatic", 1)
color_red_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_orange:SetFloat("$PortalStatic", 1)
color_orange_light:SetFloat("$PortalStatic", 1)
color_orange_dark:SetFloat("$PortalStatic", 1)
color_orange_saturation:SetFloat("$PortalStatic", 1)
color_orange_saturation_light:SetFloat("$PortalStatic", 1)
color_orange_saturation_dark:SetFloat("$PortalStatic", 1)
color_orange_saturation_low:SetFloat("$PortalStatic", 1)
color_orange_saturation_low_light:SetFloat("$PortalStatic", 1)
color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_yellow:SetFloat("$PortalStatic", 1)
color_yellow_light:SetFloat("$PortalStatic", 1)
color_yellow_dark:SetFloat("$PortalStatic", 1)
color_yellow_saturation:SetFloat("$PortalStatic", 1)
color_yellow_saturation_light:SetFloat("$PortalStatic", 1)
color_yellow_saturation_dark:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1)
color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green1:SetFloat("$PortalStatic", 1)
color_green1_light:SetFloat("$PortalStatic", 1)
color_green1_dark:SetFloat("$PortalStatic", 1)
color_green1_saturation:SetFloat("$PortalStatic", 1)
color_green1_saturation_light:SetFloat("$PortalStatic", 1)
color_green1_saturation_dark:SetFloat("$PortalStatic", 1)
color_green1_saturation_low:SetFloat("$PortalStatic", 1)
color_green1_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green:SetFloat("$PortalStatic", 1)
color_green_light:SetFloat("$PortalStatic", 1)
color_green_dark:SetFloat("$PortalStatic", 1)
color_green_saturation:SetFloat("$PortalStatic", 1)
color_green_saturation_light:SetFloat("$PortalStatic", 1)
color_green_saturation_dark:SetFloat("$PortalStatic", 1)
color_green_saturation_low:SetFloat("$PortalStatic", 1)
color_green_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_green2:SetFloat("$PortalStatic", 1)
color_green2_light:SetFloat("$PortalStatic", 1)
color_green2_dark:SetFloat("$PortalStatic", 1)
color_green2_saturation:SetFloat("$PortalStatic", 1)
color_green2_saturation_light:SetFloat("$PortalStatic", 1)
color_green2_saturation_dark:SetFloat("$PortalStatic", 1)
color_green2_saturation_low:SetFloat("$PortalStatic", 1)
color_green2_saturation_low_light:SetFloat("$PortalStatic", 1)
color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue_light:SetFloat("$PortalStatic", 1)
color_blue_light_light:SetFloat("$PortalStatic", 1)
color_blue_light_dark:SetFloat("$PortalStatic", 1)
color_blue_light_saturation:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue:SetFloat("$PortalStatic", 1)
color_light_blue:SetFloat("$PortalStatic", 1)
color_dark_blue:SetFloat("$PortalStatic", 1)
color_blue_saturation:SetFloat("$PortalStatic", 1)
color_blue_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_blue_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_light:SetFloat("$PortalStatic", 1)
color_blue_dark_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1)
color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1)


color_purple:SetFloat("$PortalStatic", 1)
color_purple_light:SetFloat("$PortalStatic", 1)
color_purple_dark:SetFloat("$PortalStatic", 1)
color_purple_saturation:SetFloat("$PortalStatic", 1)
color_purple_saturation_light:SetFloat("$PortalStatic", 1)
color_purple_saturation_dark:SetFloat("$PortalStatic", 1)
color_purple_saturation_low:SetFloat("$PortalStatic", 1)
color_purple_saturation_low_light:SetFloat("$PortalStatic", 1)
color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_pink:SetFloat("$PortalStatic", 1)
color_pink_light:SetFloat("$PortalStatic", 1)
color_pink_dark:SetFloat("$PortalStatic", 1)
color_pink_saturation:SetFloat("$PortalStatic", 1)
color_pink_saturation_light:SetFloat("$PortalStatic", 1)
color_pink_saturation_dark:SetFloat("$PortalStatic", 1)
color_pink_saturation_low:SetFloat("$PortalStatic", 1)
color_pink_saturation_low_light:SetFloat("$PortalStatic", 1)
color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_pink2:SetFloat("$PortalStatic", 1)
color_pink2_light:SetFloat("$PortalStatic", 1)
color_pink2_dark:SetFloat("$PortalStatic", 1)
color_pink2_saturation:SetFloat("$PortalStatic", 1)
color_pink2_saturation_light:SetFloat("$PortalStatic", 1)
color_pink2_saturation_dark:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1)
color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1)

color_gray1:SetFloat("$PortalStatic", 1)
color_gray:SetFloat("$PortalStatic", 1)
color_gray2:SetFloat("$PortalStatic", 1)

two_color_red:SetFloat("$PortalStatic", 1)
two_color_red_light:SetFloat("$PortalStatic", 1)
two_color_red_dark:SetFloat("$PortalStatic", 1)
two_color_red_saturation:SetFloat("$PortalStatic", 1)
two_color_red_saturation_light:SetFloat("$PortalStatic", 1)
two_color_red_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_red_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_orange:SetFloat("$PortalStatic", 1)
two_color_orange_light:SetFloat("$PortalStatic", 1)
two_color_orange_dark:SetFloat("$PortalStatic", 1)
two_color_orange_saturation:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_light:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_orange_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_yellow:SetFloat("$PortalStatic", 1)
two_color_yellow_light:SetFloat("$PortalStatic", 1)
two_color_yellow_dark:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_light:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_yellow_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green1:SetFloat("$PortalStatic", 1)
two_color_green1_light:SetFloat("$PortalStatic", 1)
two_color_green1_dark:SetFloat("$PortalStatic", 1)
two_color_green1_saturation:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green1_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green:SetFloat("$PortalStatic", 1)
two_color_green_light:SetFloat("$PortalStatic", 1)
two_color_green_dark:SetFloat("$PortalStatic", 1)
two_color_green_saturation:SetFloat("$PortalStatic", 1)
two_color_green_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_green2:SetFloat("$PortalStatic", 1)
two_color_green2_light:SetFloat("$PortalStatic", 1)
two_color_green2_dark:SetFloat("$PortalStatic", 1)
two_color_green2_saturation:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_light:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_green2_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_dark:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_light_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue:SetFloat("$PortalStatic", 1)
two_color_light_blue:SetFloat("$PortalStatic", 1)
two_color_dark_blue:SetFloat("$PortalStatic", 1)
two_color_blue_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_blue_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_blue_dark_saturation_low_dark:SetFloat("$PortalStatic", 1)


two_color_purple:SetFloat("$PortalStatic", 1)
two_color_purple_light:SetFloat("$PortalStatic", 1)
two_color_purple_dark:SetFloat("$PortalStatic", 1)
two_color_purple_saturation:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_light:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_purple_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_pink:SetFloat("$PortalStatic", 1)
two_color_pink_light:SetFloat("$PortalStatic", 1)
two_color_pink_dark:SetFloat("$PortalStatic", 1)
two_color_pink_saturation:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_light:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_pink_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_pink2:SetFloat("$PortalStatic", 1)
two_color_pink2_light:SetFloat("$PortalStatic", 1)
two_color_pink2_dark:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_light:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_dark:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low_light:SetFloat("$PortalStatic", 1)
two_color_pink2_saturation_low_dark:SetFloat("$PortalStatic", 1)

two_color_gray1:SetFloat("$PortalStatic", 1)
two_color_gray:SetFloat("$PortalStatic", 1)
two_color_gray2:SetFloat("$PortalStatic", 1)
						
					end
				end
			
			cam.End3D2D()
		
		render.SetStencilEnable( false )
		
		self:DrawPortalEffects( portaltype )
	end
end
hook.Add("PostDrawOpaqueRenderables","DrawPortals", function()
	for k,v in pairs(ents.FindByClass("prop_portal"))do
		v:DrawPortal()
	end
end)

function ENT:RenderPortal( origin, angles)
	if renderportals:GetBool() then
		local portal = self:GetNWEntity( "Potal:Other", nil )
		if IsValid( portal ) and self:GetNWBool( "Potal:Linked", false ) and self:GetNWBool( "Potal:Activated", false ) then
   
			local portaltype = self:GetNWInt( "Potal:PortalType", TYPE_BLUE )
		   
			local normal = self:GetForward()
			local distance = normal:Dot( self:GetRenderOrigin() )
		   
			othernormal = portal:GetForward()
			otherdistance = othernormal:Dot( portal:GetRenderOrigin() )
		   
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
		   
			// convert to angles
			angles = math.VectorAngles( forward, up )
		   
			local LocalOrigin = self:WorldToLocal( origin )
			local LocalAngles = self:WorldToLocalAngles( angles )
		   
			// repair
			if self:OnFloor() and not portal:OnFloor() then
				LocalOrigin.x = LocalOrigin.x + 20
			end
			
-- Fixed ViewRender Portals
			
			if portal:OnFloor() and  self:IsHorizontal() then
				LocalOrigin.x = LocalOrigin.x - 20
			end
			
			LocalOrigin.y = -LocalOrigin.y
			LocalAngles.y = -LocalAngles.y
			LocalAngles.r = -LocalAngles.r
		   
			view = {}
			view.x = 0
			view.y = 0
			view.w = ScrW()
			view.h = ScrH()
			view.origin = portal:LocalToWorld( LocalOrigin )
			view.angles = portal:LocalToWorldAngles( LocalAngles )
			view.drawhud = false
			view.drawviewmodel = false
			
			local oldrt = render.GetRenderTarget()
		   
			local ToRT = portaltype == TYPE_BLUE and texFSB or texFSB2
		   
			render.SetRenderTarget( ToRT )
				render.PushCustomClipPlane( othernormal, otherdistance )
				local b = render.EnableClipping(true)
					render.Clear( 0, 0, 0, 255 )
					render.ClearDepth()
					render.ClearStencil()
					
					portal:SetNoDraw( true )
						RENDERING_PORTAL = self
							render.RenderView( view )
							render.UpdateScreenEffectTexture()
						RENDERING_PORTAL = false
					portal:SetNoDraw( false )
					
				render.PopCustomClipPlane()
				render.EnableClipping(b)
			render.SetRenderTarget( oldrt ) 
		end
	end
end


/*------------------------------------
        ShouldDrawLocalPlayer()
------------------------------------*/
--Draw yourself into the portal.. YES YOU CAN SEE YOURSELF! (Bug? Can't see your weapons)
hook.Add( "ShouldDrawLocalPlayer", "Portal.ShouldDrawLocalPlayer", function()
		local ply = LocalPlayer()
		local portal = ply.InPortal
        if RENDERING_PORTAL then
			return true
        -- elseif IsValid(portal) then
			-- local pos,ang = portal:GetPortalPosOffsets(portal:GetOther(),ply), portal:GetPortalAngleOffsets(portal:GetOther(),ply)
			-- pos.z = pos.z - 64
			
			-- ply:SetRenderOrigin(pos)
			-- ply:SetRenderAngles(ang)
			-- return true
			
		end
end )
hook.Add( 'PostDrawEffects', 'PortalSimulation_PlayerRenderFix', function()
	cam.Start3D( EyePos(), EyeAngles() )
	cam.End3D()
end)

hook.Add( "RenderScene", "Portal.RenderScene", function( Origin, Angles )
	// render each portal
				if GetConVarNumber("portal_texFSB") >=2 then
	for k, v in ipairs( ents.FindByClass( "prop_portal_pbody" ) ) do
		local viewent = GetViewEntity()
		local pos = ( IsValid( viewent ) and viewent != LocalPlayer() ) and GetViewEntity():GetPos() or Origin
		if IsInFront( Origin, v:GetRenderOrigin(), v:GetForward() ) then --if the player is in front of the portal, then render it..
			// call into it to render
			v:RenderPortal( Origin, Angles )
		end
	end
				elseif GetConVarNumber("portal_texFSB") >=1 then
	for k, v in ipairs( ents.FindByClass( "prop_portal_atlas" ) ) do
		local viewent = GetViewEntity()
		local pos = ( IsValid( viewent ) and viewent != LocalPlayer() ) and GetViewEntity():GetPos() or Origin
		if IsInFront( Origin, v:GetRenderOrigin(), v:GetForward() ) then --if the player is in front of the portal, then render it..
			// call into it to render
			v:RenderPortal( Origin, Angles )
		end
	end
				else
	for k, v in ipairs( ents.FindByClass( "prop_portal" ) ) do
		local viewent = GetViewEntity()
		local pos = ( IsValid( viewent ) and viewent != LocalPlayer() ) and GetViewEntity():GetPos() or Origin
		if IsInFront( Origin, v:GetRenderOrigin(), v:GetForward() ) then --if the player is in front of the portal, then render it..
			// call into it to render
			v:RenderPortal( Origin, Angles )
		end
	end
				end
	
end )

CreateClientConVar("portal_debugmonitor", 0, false, false)
hook.Add( "HUDPaint", "Portal.BlueMonitor", function( w,h )
	if GetConVarNumber("portal_debugmonitor") == 1 and GetConVarNumber("sv_cheats") == 1 then
		// render each portal
		for k, v in ipairs( ents.FindByClass( "prop_portal" ) ) do
		  // debug monitor
			if view and v:GetNWInt("Potal:PortalType", TYPE_BLUE) == TYPE_BLUE then
				
				surface.DrawLine(ScrW()/2-10,ScrH()/2,ScrW()/2+10,ScrH()/2)
				surface.DrawLine(ScrW()/2,ScrH()/2-10,ScrW()/2,ScrH()/2+10)
				
				local b = render.EnableClipping(true)
				render.PushCustomClipPlane( othernormal, otherdistance )
					view.w = 500
					view.h = 280
					RENDERING_PORTAL = true
						render.RenderView( view )
					RENDERING_PORTAL = false
				render.PopCustomClipPlane( )
				render.EnableClipping(b)
			end

		end
	end
end )

/*------------------------------------
        GetMotionBlurValues()
------------------------------------*/
hook.Add( "GetMotionBlurValues", "Portal.GetMotionBlurValues", function( x, y, fwd, spin )
        if RENDERING_PORTAL then
                return 0, 0, 0, 0
        end
end )

hook.Add( "PostProcessPermitted", "Portal.PostProcessPermitted", function( element )
        if element == "bloom" and RENDERING_PORTAL then
                return false
        end
end )

usermessage.Hook( "Portal:ObjectInPortal", function(umsg)
        local portal = umsg:ReadEntity()
        local ent = umsg:ReadEntity()
        if IsValid( ent ) and IsValid( portal ) then
			ent.InPortal = portal
			
			-- if ent:IsPlayer() then
				-- portal:SetupPlayerClone(ent)
			-- end
			
			ent:SetRenderClipPlaneEnabled( true )
			ent:SetGroundEntity( portal )
		end
end )

usermessage.Hook( "Portal:ObjectLeftPortal", function(umsg)
        local ent = umsg:ReadEntity()
        if IsValid( ent ) then
			-- if ent:IsPlayer() and IsValid(ent.PortalClone) then
				-- ent.PortalClone:Remove()
			-- end
			ent.InPortal = false
			ent:SetRenderClipPlaneEnabled(false)
        end
end )

hook.Add( "RenderScreenspaceEffects", "Portal.RenderScreenspaceEffects", function()
        for k,v in pairs( ents.GetAll() ) do
                if IsValid( v.InPortal ) then
                        --local plane = Plane(v.InPortal:GetForward(),v.InPortal:GetPos())
                       
                        local normal = v.InPortal:GetForward()
                        local distance = normal:Dot( v.InPortal:GetRenderOrigin() )
                       
						v:SetRenderClipPlaneEnabled(true)
                        v:SetRenderClipPlane( normal, distance )
                end
        end
		
end )

/*------------------------------------
        VectorAngles()
------------------------------------*/
function math.VectorAngles( forward, up )

        local angles = Angle( 0, 0, 0 )

        local left = up:Cross( forward )
        left:Normalize()
       
        local xydist = math.sqrt( forward.x * forward.x + forward.y * forward.y )
       
        // enough here to get angles?
        if( xydist > 0.001 ) then
       
                angles.y = math.deg( math.atan2( forward.y, forward.x ) )
                angles.p = math.deg( math.atan2( -forward.z, xydist ) )
                angles.r = math.deg( math.atan2( left.z, ( left.y * forward.x ) - ( left.x * forward.y ) ) )

        else
       
                angles.y = math.deg( math.atan2( -left.x, left.y ) )
                angles.p = math.deg( math.atan2( -forward.z, xydist ) )
                angles.r = 0
       
        end


        return angles
       
end

--red = in blue = out
usermessage.Hook("DebugOverlay_LineTrace", function(umsg)
	local p1,p2,b = umsg:ReadVector(),umsg:ReadVector(),umsg:ReadBool()
	local col
	if b then col = Color(255,0,0,255) else col = Color(0,0,255,255) end
	debugoverlay.Line(p1,p2,5, col)
end)
usermessage.Hook("DebugOverlay_Cross", function(umsg)
	local point = umsg:ReadVector()
	local b = umsg:ReadBool()
	if b then 
		b = Color(0,255,0)
	else 
		b = Color(255,0,0) 
	end
	debugoverlay.Cross(point,5, 5, b,true)
end)

hook.Add("Think", "Reset Camera Roll", function()
	if not LocalPlayer():InVehicle() then
		local a = LocalPlayer():EyeAngles()
		if a.r != 0 then
			a.r = math.ApproachAngle(a.r, 0, FrameTime()*160)
			LocalPlayer():SetEyeAngles(a)
		end
	end
end) 

-- local fps = {30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30,30}
-- function AvgFPS()
	-- table.remove(fps,1)
	-- table.insert(fps,1/FrameTime())
	-- local avg = 0
	-- for i=1,#fps do
		-- avg = avg+fps[i]
	-- end
	-- return avg/#fps
-- end
-- hook.Add("Tick","Calc AVG FPS",AvgFPS)

-- hook.Add("HUDPaint","PrintVelocity", function() 
	
	-- draw.SimpleText(LocalPlayer():GetVelocity():__tostring(),"DermaLarge",100,100,Color(100,255,100),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)

-- end)