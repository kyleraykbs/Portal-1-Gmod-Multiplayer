print("===========================================================")
print("                 PORTAL 1 MULTIPLAYER VR")
print("                 PORTAL 1 MULTIPLAYER VR")
print("                 PORTAL 1 MULTIPLAYER VR")
print("                 PORTAL 1 MULTIPLAYER VR")
print("===========================================================")

local function CorrectPortalAng(ang)
    -- add 90 degrees to the angle
    ang = ang + Angle(90, 0, 0)

    return ang
end

hook.Add( "Tick", "Portal1MultiplayerTick", function()
	for _, ent in ipairs( ents.FindByClass( "prop_physics" ) ) do

        local within = false
        -- if its within 100 units of any seamless_portal
        for _, portal in ipairs( ents.FindByClass( "seamless_portal" ) ) do
            if portal:GetPos():Distance( ent:GetPos() ) < 120 then
                within = true
            end
        end

        if (within) then
            -- if ent.vertpoints does not exist
            if (ent.vertpoints == nil) then
                print("NO VERTS... GETTING VERTS")
                local physobj = ent:GetPhysicsObject()
                -- get the mesh
                local physmesh = physobj:GetMesh()
                -- itterate over everything in the mesh
                local vertices = {}
                for _, vert in ipairs( physmesh ) do
                    local addvert = true
                    -- if it isnt within 1 unit of any other vert
                    for _, vert2 in ipairs( vertices ) do
                        if (vert.pos:Distance( vert2 ) < 5) then
                            addvert = false
                        end
                    end
                    -- add the vert to the table
                    if (addvert) then
                        table.insert( vertices, vert.pos )
                    end
                end

                local function optimizevertz(vertices)
                    local maxverts = 100
                    local tolarance = 10
                    if (table.Count( vertices ) > maxverts) then
                        print("OPTIMIZING VERTS")
                        -- remove every other vert
                        for i = 1, table.Count( vertices ), 2 do
                            table.remove( vertices, i )
                        end
                    end

                    if (table.Count( vertices ) > maxverts + tolarance) then
                        local vertices = optimizevertz( vertices )
                    end

                    return vertices
                end
                 
                -- vertices = optimizevertz( vertices )

                -- set the vertices to the ent
                ent.vertpoints = vertices
                print(#ent.vertpoints)
            else

                local nearestportal = nil
                local nearestportalpos = 99999999999
                for _, portal in ipairs( ents.FindByClass( "seamless_portal" ) ) do
                    if portal:GetPos():Distance( ent:GetPos() ) < nearestportalpos then
                        nearestportal = portal
                        nearestportalpos = portal:GetPos():Distance( ent:GetPos() )
                    end
                end
                local nearestportallinkedportal = nearestportal:ExitPortal()

                -- draw a line from the ent to the nearest portal
                -- debugoverlay.Line( ent:GetPos(), nearestportal:GetPos(), 0, Color( 255, 255, 0, 255 ), true )

                local function MirrorPos(pos)
                    -- get the forward vector of the middle of the ent and the middle of the portal then convert it to angles
                    local fwd = pos - nearestportal:GetPos()
                    -- get the length of the line
                    local len = fwd:Length()
                    fwd:Normalize()
                    fwd = fwd:Angle()
                    -- fwd = fwd:Forward() * -1
                    -- fwd = fwd:Angle()

                    -- draw a line from the ent to the forward vector
                    debugoverlay.Line( nearestportal:GetPos(), nearestportal:GetPos() + fwd:Forward() * len, 0, Color( 0, 0, 255, 255 ), true )

                    local correctedang = nearestportallinkedportal:GetAngles() - nearestportal:GetAngles()
                    local correctedfwd = fwd + correctedang

                    debugoverlay.Line( nearestportallinkedportal:GetPos(), nearestportallinkedportal:GetPos() + (correctedfwd:Forward() * len), 0, Color( 0, 0, 255, 255 ), true )

                    local mirroredpos = nearestportallinkedportal:GetPos() + (correctedfwd:Forward() * len)
                    


                    return mirroredpos
                end

                -- if the ent has vertpoints
                -- itterate over the vertices
                local HitPortal = false
                for _, vert in ipairs( ent.vertpoints ) do
                    -- apply the rotation of the ent to the vert
                    local rotatedvert = ent:LocalToWorld( vert )
                    local localrotatedvert = rotatedvert - ent:GetPos()

                    debugoverlay.Box(rotatedvert, Vector(-1,-1,-1), Vector(1,1,1), 0, Color(255,255,255))

                    local MirrorPos = MirrorPos(rotatedvert)


                    -- draw a line from the ent to the forward vector
                    debugoverlay.Line( rotatedvert, ent:GetPos(), 0, Color( 0, 255, 0, 255 ), true )

                    -- trace a line from the ent to the forward vector and dont hit anything but the portal
                    local tr = util.TraceLine( {
                        start = rotatedvert,
                        endpos = ent:GetPos(),
                        filter = function( ent ) return ( ent:GetClass() == "seamless_portal" ) end,
                        ignoreworld = true
                    } )

                    -- if it hit something
                    if (tr.Hit) then
                        debugoverlay.Box(MirrorPos, Vector(-1,-1,-1), Vector(1,1,1), 0, Color(255,0,255))

                        -- draw a box around the hit
                        debugoverlay.Box( tr.HitPos, Vector(-1,-1,-1), Vector(1,1,1), 0, Color(255,0,0) )

                        HitPortal = true
                    end
                end

                if (HitPortal) then
                    -- disable collision on the ent with the world
                    ent:GetPhysicsObject():Wake()
                    constraint.AdvBallsocket( ent, game.GetWorld(), 0, 0, Vector(0,0,0), Vector(0,0,0), 0, 0,  -180, -180, -180, 180, 180, 180,  0, 0, 1, 1, 1 )
                else
                    -- enable collision on the ent with the world
                    constraint.RemoveConstraints(ent, "AdvBallsocket")
                end
            end
        end

        -- if the modelname is models/props/metal_box.mdl
        if ent:GetModel() == "models/props/metal_box.mdl" or ent:GetModel() == "models/props_bts/glados_ball_reference.mdl" then
            ent:GetPhysicsObject():SetMass( 35 ) -- maximum mass you can have while still being able to move it
        end
    end

    -- itterate through all players
    for _, ply in ipairs( player.GetAll() ) do
        -- if their health is less then their max health
        if ply:Health() < ply:GetMaxHealth() then
            -- make a timer for 5 seconds to heal them
            timer.Simple( 5, function()
                -- if the player is still alive
                if IsValid( ply ) then
                    -- heal them
                    if ( ply:Health() < ply:GetMaxHealth() ) then
                        ply:SetHealth( ply:Health() + 1 )
                    end

                end
            end )
        end
    end
end )

-- add a playerspawn hook
hook.Add( "PlayerSpawn", "Portal1MultiplayerPlayerSpawn", function( ply )
    -- set their speed after 0.1 seconds
    timer.Simple( 0.1, function()
        -- if the player is still alive
        if IsValid( ply ) then
            ply:SetRunSpeed( 150 )
            ply:SetWalkSpeed( 150 )
            ply:SetJumpPower( 150 )
            ply:StripWeapons()
            ply:RemoveSuit()
        end
    end )
    
    MsgN( ply:Nick() .. " has spawned!" )
end )