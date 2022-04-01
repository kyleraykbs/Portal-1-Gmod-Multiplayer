AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

print(ENT)

local function CorrectPortalAng(ang)
    -- add 90 degrees to the angle
    ang = ang + Angle(90, 0, 0)

    return ang
end

local function ConvertForwardVector(vec)
    -- flip up and forward
    vec = Vector(vec.x, vec.z, vec.y)

    return vec
end

local function FindAndSetLinkedPartner(prop_portal)
    if (!prop_portal.LinkedPartner or !prop_portal.LinkedPartner:IsValid() or !prop_portal.LinkedPartner.IsActive or !prop_portal.LinkedPartner.Portal:IsValid()) then
        print("No previously linked partner found... finding one now")

        -- go through every portal in the map 
        for _, portal in pairs(ents.FindByClass("prop_portal")) do
            if (portal ~= prop_portal) then
                -- if the portal is linked to the current portal
                if ( portal.LinkedPartner == nil and portal.IsActive) then
                    print("Found linked partner!")

                    -- set the current portal's linked partner to the portal we found
                    prop_portal.LinkedPartner = portal

                    -- set the portal we found's linked partner to the current portal
                    portal.LinkedPartner = prop_portal

                    return portal
                end
            end
        end
    else
        return prop_portal.LinkedPartner
    end
end

local function GetPortalBrush(portal)
    -- trace a line up down left and right from the portal then find the closest hit
    local besttrace = nil
    
    local function RunTest(pos)
        local trbackwards = util.TraceLine({
            start = pos,
            endpos = portal:GetAngles():Forward() * -999999, -- backwards
            filter = portal,
            mask = MASK_SOLID_BRUSHONLY
        })

        if (trbackwards.Hit) then
            besttrace = trbackwards
        end
        
        local trforwards = util.TraceLine({
            start = pos,
            endpos = portal:GetAngles():Forward() * 999999, -- forwards
            filter = portal,
            mask = MASK_SOLID_BRUSHONLY
        })

        if (trforwards.Hit) then
            if (besttrace == nil or besttrace.Fraction > trforwards.Fraction) then
                besttrace = trforwards
            end
        end

        local trleft = util.TraceLine({
            start = pos,
            endpos = portal:GetAngles():Right() * -999999, -- left
            filter = portal,
            mask = MASK_SOLID_BRUSHONLY
        })

        if (trleft.Hit) then
            if (besttrace == nil or besttrace.Fraction > trleft.Fraction) then
                besttrace = trleft
            end
        end

        local trright = util.TraceLine({
            start = pos,
            endpos = portal:GetAngles():Right() * 999999, -- right
            filter = portal,
            mask = MASK_SOLID_BRUSHONLY
        })
        
        if (trright.Hit) then
            if (besttrace == nil or besttrace.Fraction > trright.Fraction) then
                besttrace = trright
            end
        end

        local trup = util.TraceLine({
            start = pos,
            endpos = portal:GetAngles():Up() * -999999, -- up
            filter = portal,
            mask = MASK_SOLID_BRUSHONLY
        })

        if (trup.Hit) then
            if (besttrace == nil or besttrace.Fraction > trup.Fraction) then
                besttrace = trup
            end
        end

        local trdown = util.TraceLine({
            start = pos,
            endpos = portal:GetAngles():Up() * 999999, -- down
            filter = portal,
            mask = MASK_SOLID_BRUSHONLY
        })

        if (trdown.Hit) then
            if (besttrace == nil or besttrace.Fraction > trdown.Fraction) then
                besttrace = trdown
            end
        end

    end

    local amt = 10
    RunTest(portal:GetPos() + Vector(0, 0, amt))
    RunTest(portal:GetPos() + Vector(0, 0, -amt))
    RunTest(portal:GetPos() + Vector(amt, 0, 0))
    RunTest(portal:GetPos() + Vector(-amt, 0, 0))
    RunTest(portal:GetPos() + Vector(0, amt, 0))
    RunTest(portal:GetPos() + Vector(0, -amt, 0))



    tr = besttrace
    -- if we hit something
    if (tr ~= nil) then
        -- draw a line from the portal to the hit position
        debugoverlay.Line(portal:GetPos(), tr.HitPos, 5, Color(255, 255, 0, 255), true)
        -- draw a red box at the hit position
        debugoverlay.Box(tr.HitPos, Vector(-5, -5, -5), Vector(5, 5, 5), 5, Color(255, 0, 0, 255), true)
        print("tr.HitPos: " .. tr.HitPos[1])
        -- if the hit entity is a brush
        if (tr.Entity:IsWorld()) then
            -- print the vertexes of the brush
            print("Brush verts:")
            -- return the hit entity
            return tr.Entity
        end
    end
end

local function SetPortalPos(portal, pos, ang)
    portal:SetAngles(CorrectPortalAng(ang))
    portal:SetPos(pos + CorrectPortalAng(portal:GetAngles()):Forward() * 0)
    GetPortalBrush(portal)
end

local function SpawnPortal() 
    Portal = ents.Create("seamless_portal")
    Portal:Spawn()
    Portal:SetExitSize(Vector(1, 0.6, 1))

    return Portal
end

local function UpdatePortalLinkState(Portal)
    FindAndSetLinkedPartner(Portal)
    if Portal.LinkedPartner ~= nil then

        -- link the portal
        Portal.Portal:LinkPortal(Portal.LinkedPartner.Portal)

    end
end


local function RemovePortal(Portal)
    Portal.IsActive = false
    if !Portal.Portal then
        print("Portal not found")
        return
    else
        if Portal.Portal and Portal.Portal:IsValid() then
            Portal.Portal:Remove()
        end
    end
    local PreviousPartner = Portal.LinkedPartner
    Portal.LinkedPartner = nil
    if PreviousPartner ~= nil and PreviousPartner:IsValid() then
        PreviousPartner.LinkedPartner = nil
        UpdatePortalLinkState(PreviousPartner)
    end
end

function ENT:Initialize( )
    print( "___Portal Initialize___" )

    self.IsActive = false
    self.LinkedPartner = nil
    self.Portal = nil

    -- stop the portal from rendering
    self:SetRenderMode( RENDERMODE_NONE )
    -- stop the portal from casting shadows
    self:DrawShadow( false )

    self:SetSolid( SOLID_NONE )

    print( "________________________" )
end

function ENT:AcceptInput( inputname, activator, caller, data )
    print( "___Portal AcceptInput___" )
    print( inputname )
    print( activator )
    print( caller )
    print( data )
    print( "________________________" )

    -- SET ACTIVATED STATE ----------------------

    if (inputname == "SetActivatedState") then
        -- create portal
        if (data == "1") then
            -- Create A Actual Portal
            if !self.Portal or !self.Portal:IsValid() then
                self.Portal = SpawnPortal()
            end
            
            SetPortalPos(self.Portal, self:GetPos(), self:GetAngles())
            
            print ("__ Linking Portal __")
            self.IsActive = true
            FindAndSetLinkedPartner(self)

            print(self)
            print(self.Portal)

            if self.LinkedPartner ~= nil then

                -- link the portal
                self.Portal:LinkPortal(self.LinkedPartner.Portal)

            end
        end

        -- remove portal
        if (data == "0") then
            -- Remove A Actual Portal
            RemovePortal(self)
        end
    end

    ------------------------------------------------

    -- FIZZLE --------------------------------------

    if (inputname == "Fizzle") then
        -- Remove A Actual Portal
        RemovePortal(self)
    end

    ------------------------------------------------
end