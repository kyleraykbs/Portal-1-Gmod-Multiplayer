
include('shared.lua')


SWEP.PrintName			= "#HL2_Grenade"		// 'Nice' Weapon name (Shown on HUD)
SWEP.Slot				= 4						// Slot in the weapon selection menu
SWEP.SlotPos			= 0						// Position in the slot
SWEP.DrawAmmo			= true					// Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= true 					// Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= false					// Should draw the weapon info box
SWEP.BounceWeaponIcon   = false					// Should the weapon icon bounce?

// Override this in your SWEP to set the icon in the weapon selection

killicon.AddFont( "sent_grenade_frag", "HL2MPTypeDeath", "4", Color( 255, 80, 0, 255 ) )

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
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( "k", "WeaponIcons_lua", x + wide/2, y + tall*0.03, Color( 255, 235, 25, 255 ), TEXT_ALIGN_CENTER )
	draw.SimpleText( "k", "WeaponIconsSelected_lua", x + wide/2, y + tall*0.03, Color( 255, 235, 25, 255 ), TEXT_ALIGN_CENTER )
	
	// try to fool them into thinking they're playing a Tony Hawks game	
end