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
    local besttraceangle = Angle(0, 0, 0)
    
    local function RunTest(pos, isvertical, isleftorright, isforwardorbackward)
        local BestTraceBetter = false

        if (isforwardorbackward) then
            local trbackwards = util.TraceLine({
                start = pos,
                endpos = pos + (Vector(-1,0,0) * 9999999), -- backwards
                filter = portal,
                mask = MASK_SOLID_BRUSHONLY
            })

            if (trbackwards.Hit) then
                if (besttrace == nil or besttrace.Fraction > trbackwards.Fraction) then
                    besttrace = trbackwards
                    BestTraceBetter = true
                end
            end
            
            local trforwards = util.TraceLine({
                start = pos,
                endpos = pos + (Vector(1,0,0) * 9999999), -- forwards
                filter = portal,
                mask = MASK_SOLID_BRUSHONLY
            })

            if (trforwards.Hit) then
                if (besttrace == nil or besttrace.Fraction > trforwards.Fraction) then
                    besttrace = trforwards
                    BestTraceBetter = true
                end
            end
        end

        if (isleftorright) then
            local trleft = util.TraceLine({
                start = pos,
                endpos = pos + (Vector(0,-1,0) * 9999999), -- left
                filter = portal,
                mask = MASK_SOLID_BRUSHONLY
            })

            if (trleft.Hit) then
                if (besttrace == nil or besttrace.Fraction > trleft.Fraction) then
                    besttrace = trleft
                    BestTraceBetter = true
                end
            end

            local trright = util.TraceLine({
                start = pos,
                endpos = pos + (Vector(0,1,0) * 9999999), -- right
                filter = portal,
                mask = MASK_SOLID_BRUSHONLY
            })
            
            if (trright.Hit) then
                if (besttrace == nil or besttrace.Fraction > trright.Fraction) then
                    besttrace = trright
                    BestTraceBetter = true
                end
            end
        end

        if (isvertical) then
            local trup = util.TraceLine({
                start = pos,
                endpos = pos + (Vector(0,0,1) * 9999999), -- up
                filter = portal,
                mask = MASK_SOLID_BRUSHONLY
            })

            if (trup.Hit) then
                if (besttrace == nil or besttrace.Fraction > trup.Fraction) then
                    besttrace = trup
                    BestTraceBetter = true
                end
            end

            local trdown = util.TraceLine({
                start = pos,
                endpos = pos + (Vector(0,0,-1) * 9999999), -- down
                filter = portal,
                mask = MASK_SOLID_BRUSHONLY
            })

            if (trdown.Hit) then
                if (besttrace == nil or besttrace.Fraction > trdown.Fraction) then
                    besttrace = trdown
                    BestTraceBetter = true
                end
            end
        end

        return BestTraceBetter
    end

    local besttracestartpoint = Vector(0, 0, 0)
    local amt = 1
    
    if (RunTest(portal:GetPos() + Vector(0, 0, amt), true, false, false) == true) then
        print("up")
        besttracestartpoint = portal:GetPos() + Vector(0, 0, amt)
    end
    if (RunTest(portal:GetPos() + Vector(0, 0, -amt), true, false, false) == true) then
        print("down")
        besttracestartpoint = portal:GetPos() + Vector(0, 0, -amt)
    end
    if (RunTest(portal:GetPos() + Vector(amt, 0, 0), false, false, true) == true) then
        print("left")
        besttracestartpoint = portal:GetPos() + Vector(amt, 0, 0)
    end
    if (RunTest(portal:GetPos() + Vector(-amt, 0, 0), false, false, true) == true) then
        print("right")
        besttracestartpoint = portal:GetPos() + Vector(-amt, 0, 0)
    end
    if (RunTest(portal:GetPos() + Vector(0, amt, 0), false, true, false) == true) then
        print("forward")
        besttracestartpoint = portal:GetPos() + Vector(0, amt, 0)
    end
    if (RunTest(portal:GetPos() + Vector(0, -amt, 0), false, true, false) == true) then
        print("backwards")
        besttracestartpoint = portal:GetPos() + Vector(0, -amt, 0)
    end

    -- draw a debug box for all the positions we tested
    debugoverlay.Box(portal:GetPos() + Vector(0, 0, amt), Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(255, 255, 0, 255), true)
    debugoverlay.Box(portal:GetPos() + Vector(0, 0, -amt), Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(255, 255, 0, 255), true)
    debugoverlay.Box(portal:GetPos() + Vector(amt, 0, 0), Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(255, 255, 0, 255), true)
    debugoverlay.Box(portal:GetPos() + Vector(-amt, 0, 0), Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(255, 255, 0, 255), true)
    debugoverlay.Box(portal:GetPos() + Vector(0, amt, 0), Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(255, 255, 0, 255), true)
    debugoverlay.Box(portal:GetPos() + Vector(0, -amt, 0), Vector(-2, -2, -2), Vector(2, 2, 2), 5, Color(255, 255, 0, 255), true)



    tr = besttrace
    -- if we hit something
    if (tr ~= nil) then
        -- draw a line from the portal to the hit position
        debugoverlay.Line(besttracestartpoint, tr.HitPos, 5, Color(0, 255, 0, 255), true)
        -- draw a red box at the hit position
        -- debugoverlay.Box(tr.HitPos, Vector(-5, -5, -5), Vector(5, 5, 5), 5, Color(255, 0, 0, 255), true)
        print("tr.HitPos: " .. tr.HitPos[1])
        -- if the hit entity is a brush
        if (tr.Entity:IsWorld()) then
            -- print the Distance of the besttracestartpoint and the hit position
            print("Distance: " .. tostring(besttracestartpoint:Distance(tr.HitPos)))
            -- draw a line from the hit position to the normal of the hit entity
            debugoverlay.Line(tr.HitPos, tr.HitPos + (tr.HitNormal:Angle():Forward() * 90), 5, Color(255, 0, 255, 255), true)
            -- return the hit position and the angle
            return {angle = tr.HitNormal:Angle(), pos = tr.HitPos, normal = tr.HitNormal, distance = besttracestartpoint:Distance(tr.HitPos)}
        end
    end
    return nil
end

local function SetPortalPos(portal, pos, ang)
    portal:SetPos(pos)
    portal:SetAngles(CorrectPortalAng(ang)) 
    local brush = GetPortalBrush(portal)
    local pushamt = 10
    if (brush ~= nil) then
        print("brushangle:" .. tostring(brush.angle))
        print("brush.pos:" .. tostring(brush.pos))
        portal:SetPos(brush.pos + (CorrectPortalAng(portal:GetAngles()):Forward() * -pushamt))
        if (brush.angle.p == 0) then
            portal:SetAngles(CorrectPortalAng(brush.angle))
            portal:SetPos(brush.pos + brush.angle:Forward() * pushamt)
        end
    else
        print("ERROR!: brush is nil")
        portal:SetPos(portal:GetPos() + (CorrectPortalAng(portal:GetAngles()):Forward() * -pushamt))
    end
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
            -- Remove the portal
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