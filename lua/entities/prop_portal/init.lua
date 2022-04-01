AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

print(ENT)

local function CorrectPortalAng(ang)
    -- add 90 degrees to the angle
    ang = ang + Angle(90, 0, 0)

    return ang
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

local function SetPortalPos(portal, pos, ang)
    portal:SetPos(pos)
    portal:SetAngles(ang)
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
    print( self:GetPos() )
    print( self:GetAngles() )
    self.IsActive = false
    self.LinkedPartner = nil
    self.Portal = nil
    for k, v in pairs(self:GetKeyValues()) do
        print(k, v)
    end
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
            
            SetPortalPos(self.Portal, self:GetPos(), CorrectPortalAng(self:GetAngles()))
            
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