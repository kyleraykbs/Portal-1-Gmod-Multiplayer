
// This is mainly for the benefit of Lua programmers, developers, and beta testers.
SWEP_BASES			= true
SWEP_BASES_VERSION	= 323
SWEP_BASES_AUTHOR	= "Andrew McWatters"

include( "sb_lua_functions.lua" )

for k, v in pairs( file.Find( "autorun/sb_*.lua", "LUA" ) ) do AddCSLuaFile( v ) end