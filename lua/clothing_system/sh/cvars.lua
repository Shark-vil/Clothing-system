-- SH

-- SV
if SERVER then
    CreateConVar( "clothing_system_gasmask_sound_effect", 1, FCVAR_ARCHIVE, "Enables or disables the gas mask sound effect (1/0)")
end

-- CL
if CLIENT then
    CreateConVar( "clothing_system_draw_overlay", 1, FCVAR_ARCHIVE, "Enables or disables the overlay (1/0)")
end