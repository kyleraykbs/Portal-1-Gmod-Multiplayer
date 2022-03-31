local function PortalMenuSettings( pnl )

	pnl:AddControl( "CheckBox", { Label = "Old Carrying Animation", Command = "portal_carryanim_p1" } )
	pnl:AddControl( "CheckBox", { Label = "Change the sound effect of the Portal Gun", Command = "portal_sound" } )
	pnl:AddControl( "CheckBox", { Label = "Enable Arms", Command = "portal_arm" } )
	
	pnl:ControlHelp( "Details of the reticle" ):DockMargin( 16, 16, 16, 4 )
	pnl:AddControl( "Slider", { Label = "Type Crosshair", Type = "Integer", Command = "portal_crosshair", Min = "0", Max = "2" } )
	pnl:AddControl( "CheckBox", { Label = "Presence System", Command = "portal_crosshair_system" } )

	pnl:ControlHelp( "Portals details" ):DockMargin( 16, 16, 16, 4 )
	pnl:AddControl( "CheckBox", { Label = "Enable Lights", Command = "portal_dynamic_light" } )
	pnl:AddControl( "CheckBox", { Label = "Enable Render", Command = "portal_render" } )
	
	pnl:ControlHelp( "When you shoot a portals" ):DockMargin( 16, 16, 16, 4 )
	pnl:AddControl( "Slider", { Label = "Projectile Speed", Type = "Integer", Command = "portal_projectile_speed", Min = "100", Max = "10000" } )
	pnl:AddControl( "CheckBox", { Label = "Enable Projectile Ball", Command = "portal_projectile_ball" } )
	pnl:AddControl( "CheckBox", { Label = "Instant Shoot", Command = "portal_instant" } )
	pnl:AddControl( "ListBox", { Label = "Upgrade", Options = list.Get( "list_portalonly" ) } )
	pnl:AddControl( "CheckBox", { Label = "Portals Cleanings", Command = "portal_cleanportals" } )
	pnl:AddControl( "CheckBox", { Label = "Shoot Faster", Command = "portal_tryhard" } )
	
	pnl:ControlHelp( "Other Parameters" ):DockMargin( 16, 16, 16, 4 )
	pnl:AddControl( "Slider", { Label = "Velocity on the Ceiling", Type = "Integer", Command = "portal_velocity_roof", Min = "0", Max = "1000" } )
	pnl:AddControl( "CheckBox", { Label = "Enable Prototype of the Portals", Command = "portal_prototype" } )
	pnl:AddControl( "CheckBox", { Label = "Sides Fixed", Command = "portal_sides_fix" } )
	pnl:AddControl( "CheckBox", { Label = "Hit on Entity", Command = "portal_hitentity" } )
	pnl:AddControl( "CheckBox", { Label = "Hit on Props", Command = "portal_hitprop" } )
	pnl:AddControl( "CheckBox", { Label = "Pull on All Surfaces", Command = "portal_allsurfaces" } )
	pnl:AddControl( "CheckBox", { Label = "Location of the Portals", Command = "portal_location" } )
	pnl:AddControl( "CheckBox", { Label = "Upside Down Portals on the Ceiling", Command = "portal_upside_down" } )
	
	pnl:ControlHelp( "In Multiplayer" ):DockMargin( 16, 16, 16, 4 )
	pnl:AddControl( "ListBox", { Label = "Render View", Options = list.Get( "list_portaltexFSB" ) } )
	pnl:AddControl( "CheckBox", { Label = "Render Automatic", Command = "portal_autoFSB" } )

	pnl:ControlHelp( "Surmounted Console" ):DockMargin( 16, 16, 16, 4 )	
	pnl:AddControl( "Button", { Label = "Portal Style", Command = "portal_sound 0; portal_crosshair_system 0; portal_projectile_speed 3500; portal_instant 0; portal_tryhard 0; portal_carryanim_p1 1" } )
	pnl:AddControl( "Button", { Label = "Portal 2 Style", Command = "portal_sound 1; portal_crosshair_system 1; portal_projectile_speed 10000; portal_instant 1; portal_tryhard 1; portal_carryanim_p1 0" } )
	
end

local function PortalsColorableMenuSettings( pnl )

pnl:AddControl( "Header", { Description = "Portal Gun Chell's" } )
pnl:ControlHelp( "First Portals" ):DockMargin( 16, 16, 16, 4 )
pnl:AddControl( "Slider", { Label = "Color", Type = "Integer", Command = "portal_color_1", Min = "0", Max = "14" } )
pnl:AddControl( "Slider", { Label = "Saturation", Type = "Integer", Command = "portal_color_saturation_1", Min = "0", Max = "2" } )
pnl:AddControl( "Slider", { Label = "Contraste", Type = "Integer", Command = "portal_color_contraste_1", Min = "0", Max = "2" } )

pnl:ControlHelp( "Second Portals" ):DockMargin( 16, 16, 16, 4 )
pnl:AddControl( "Slider", { Label = "Color", Type = "Integer", Command = "portal_color_2", Min = "0", Max = "14" } )
pnl:AddControl( "Slider", { Label = "Saturation", Type = "Integer", Command = "portal_color_saturation_2", Min = "0", Max = "2" } )
pnl:AddControl( "Slider", { Label = "Contraste", Type = "Integer", Command = "portal_color_contraste_2", Min = "0", Max = "2" } )

pnl:AddControl( "Button", { Label = "Restart", Command = "portal_color_1 7; portal_color_2 1; portal_color_saturation_1 0; portal_color_contraste_1 1; portal_color_saturation_2 0; portal_color_contraste_2 1;", Text = "Restart" } )

pnl:AddControl( "Header", { Description = "Portal Gun Atlas's" } )
pnl:ControlHelp( "First Portals" ):DockMargin( 16, 16, 16, 4 )
pnl:AddControl( "Slider", { Label = "Color", Type = "Integer", Command = "portal_color_ATLAS_1", Min = "0", Max = "14" } )
pnl:AddControl( "Slider", { Label = "Saturation", Type = "Integer", Command = "portal_color_ATLAS_saturation_1", Min = "0", Max = "2" } )
pnl:AddControl( "Slider", { Label = "Contraste", Type = "Integer", Command = "portal_color_ATLAS_contraste_1", Min = "0", Max = "2" } )

pnl:ControlHelp( "Second Portals" ):DockMargin( 16, 16, 16, 4 )
pnl:AddControl( "Slider", { Label = "Color", Type = "Integer", Command = "portal_color_ATLAS_2", Min = "0", Max = "14" } )
pnl:AddControl( "Slider", { Label = "Saturation", Type = "Integer", Command = "portal_color_ATLAS_saturation_2", Min = "0", Max = "2" } )
pnl:AddControl( "Slider", { Label = "Contraste", Type = "Integer", Command = "portal_color_ATLAS_contraste_2", Min = "0", Max = "2" } )

pnl:AddControl( "Button", { Label = "Restart", Command = "portal_color_ATLAS_1 6; portal_color_ATLAS_2 8; portal_color_ATLAS_saturation_1 1; portal_color_ATLAS_contraste_1 1; portal_color_ATLAS_saturation_2 0; portal_color_ATLAS_contraste_2 0;", Text = "Restart" } )

pnl:AddControl( "Header", { Description = "Portal Gun P-Body's" } )
pnl:ControlHelp( "First Portals" ):DockMargin( 16, 16, 16, 4 )
pnl:AddControl( "Slider", { Label = "Color", Type = "Integer", Command = "portal_color_PBODY_1", Min = "0", Max = "14" } )
pnl:AddControl( "Slider", { Label = "Saturation", Type = "Integer", Command = "portal_color_PBODY_saturation_1", Min = "0", Max = "2" } )
pnl:AddControl( "Slider", { Label = "Contraste", Type = "Integer", Command = "portal_color_PBODY_contraste_1", Min = "0", Max = "2" } )

pnl:ControlHelp( "Second Portals" ):DockMargin( 16, 16, 16, 4 )
pnl:AddControl( "Slider", { Label = "Color", Type = "Integer", Command = "portal_color_PBODY_2", Min = "0", Max = "14" } )
pnl:AddControl( "Slider", { Label = "Saturation", Type = "Integer", Command = "portal_color_PBODY_saturation_2", Min = "0", Max = "2" } )
pnl:AddControl( "Slider", { Label = "Contraste", Type = "Integer", Command = "portal_color_PBODY_contraste_2", Min = "0", Max = "2" } )

pnl:AddControl( "Button", { Label = "Restart", Command = "portal_color_PBODY_1 2; portal_color_PBODY_2 0; portal_color_PBODY_saturation_1 1; portal_color_PBODY_contraste_1 1; portal_color_PBODY_saturation_2 0; portal_color_PBODY_contraste_2 0;", Text = "Restart" } )


end

hook.Add( "PopulateToolMenu", "PortalMenus", function()

	spawnmenu.AddToolMenuOption( "Options", "Portal", "Settings", "Settings", "", "", PortalMenuSettings )
	spawnmenu.AddToolMenuOption( "Options", "Portal", "Portals Colorable", "Portals Colorable", "", "", PortalsColorableMenuSettings )

end )

list.Set( "list_portalonly", "Two Portal Connect", { portal_portalonly = "0" } )
list.Set( "list_portalonly", "One Portal (Blue)", { portal_portalonly = "1" } )
list.Set( "list_portalonly", "One Portal (Orange)", { portal_portalonly = "2" } )

list.Set( "list_portaltexFSB", "Chell", { portal_texFSB = "0" } )
list.Set( "list_portaltexFSB", "Atlas", { portal_texFSB = "1" } )
list.Set( "list_portaltexFSB", "P-Body", { portal_texFSB = "2" } )