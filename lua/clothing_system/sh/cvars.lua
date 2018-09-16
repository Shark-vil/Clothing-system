-- SH
CreateConVar( "clothing_system_language", "en", FCVAR_ARCHIVE, "Change the language of the addon.")

if ( GetConVar("clothing_system_language"):GetString() == "ru" ) then ClothingSystem.Language = rus_pack else ClothingSystem.Language = eng_pack end

-- SV
if SERVER then

end

-- CL
if CLIENT then
    CreateConVar( "clothing_system_draw_overlay", 1, FCVAR_ARCHIVE, "Enables or disables the overlay (1/0)")
end