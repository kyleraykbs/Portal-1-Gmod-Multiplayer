print("===========================================================")
print("                 PORTAL 1 MULTIPLAYER VR")
print("                 PORTAL 1 MULTIPLAYER VR")
print("                 PORTAL 1 MULTIPLAYER VR")
print("                 PORTAL 1 MULTIPLAYER VR")
print("===========================================================")

hook.Add( "Tick", "Portal1MultiplayerTick", function()
	for _, ent in ipairs( ents.FindByClass( "prop_physics" ) ) do
        -- if the modelname is models/props/metal_box.mdl
        if ent:GetModel() == "models/props/metal_box.mdl" or "models/props_bts/glados_ball_reference.mdl" then
            ent:GetPhysicsObject():SetMass( 35 ) -- maximum mass you can have while still being able to move it
        end
     end
end )