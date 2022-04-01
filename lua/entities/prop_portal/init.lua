AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
include( "shared.lua" );

print(ENT)

local function CorrectPortalAng(ang)
    -- add 90 degrees to the angle
    ang = ang + Angle(90, 0, 0)

    return ang
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

local function RemovePortal(Portal)
    Portal:Remove()
end

function ENT:Initialize( )
    print( "___Portal Initialize___" )
    print( self:GetPos() )
    print( self:GetAngles() )
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

    -- SET ACTIVEATED STATE ----------------------
    if (inputname == "SetActivatedState") then
        -- create portal
        if (data == "1") then
            -- Create A Actual Portal
            if !self.Portal or !self.Portal:IsValid() then
                self.Portal = SpawnPortal()
            end

            SetPortalPos(self.Portal, self:GetPos(), CorrectPortalAng(self:GetAngles()))
        end

        -- remove portal
        if (data == "0") then
            -- Remove A Actual Portal
            if self.Portal or !self.Portal:IsValid() then
                RemovePortal(self.Portal)
            end
        end
    end
    ------------------------------------------------

    -- FIZZLE --------------------------------------

    if (inputname == "Fizzle") then
        -- Remove A Actual Portal
        if self.Portal or !self.Portal:IsValid() then
            RemovePortal(self.Portal)
        end
    end

    ------------------------------------------------
end