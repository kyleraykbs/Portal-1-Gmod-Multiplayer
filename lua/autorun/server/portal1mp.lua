print("===========================================================")
print("                 PORTAL 1 MULTIPLAYER VR")
print("                 PORTAL 1 MULTIPLAYER VR")
print("                 PORTAL 1 MULTIPLAYER VR")
print("                 PORTAL 1 MULTIPLAYER VR")
print("===========================================================")

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
                -- set the vertices to the ent
                ent.vertpoints = vertices
                print(#ent.vertpoints)
            else
                -- if the ent has vertpoints
                -- itterate over the vertices
                for _, vert in ipairs( ent.vertpoints ) do
                    -- apply the rotation of the ent to the vert
                    local rotatedvert = ent:LocalToWorld( vert )
                    debugoverlay.Box(rotatedvert, Vector(-1,-1,-1), Vector(1,1,1), 0.1, Color(255,255,255))
                end
            end
        end

        -- if the modelname is models/props/metal_box.mdl
        if ent:GetModel() == "models/props/metal_box.mdl" or "models/props_bts/glados_ball_reference.mdl" then
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