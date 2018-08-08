include('shared.lua')

local list = list.Get( "clothing_system" )

function ENT:Draw()
    self:DrawModel()
    
    if ( self:GetPos():Distance(LocalPlayer():GetPos()) <= 150 && self.Class != nil ) then
        local Name = list[self.Class].Name
        local _max = self:OBBMaxs()
        local Pos = self:GetPos() + Vector(0, 0, _max.z + 10)
        local Ang = LocalPlayer():GetAngles()

        Ang:RotateAroundAxis(Ang:Up(), -90)
        Ang:RotateAroundAxis(Ang:Right(), 0)
        Ang:RotateAroundAxis(Ang:Forward(), 90)

        local PressText = "Press \"E\" to wear"
        local lenStr = string.len( Name )
        local lenStr2 = string.len( PressText )
        local WidthRelize

        if ( lenStr2 > lenStr ) then
            WidthRelize = lenStr2
        else
            WidthRelize = lenStr
        end

        cam.Start3D2D(Pos, Ang, 0.15)
            draw.RoundedBox( 0, -WidthRelize*5.2, 0, WidthRelize*10.3, 60, Color( 34, 34, 34, 220))
            draw.SimpleTextOutlined( Name, "Trebuchet24", 0, 5, Color(255,255,255,255 ), 1, 0, 2, Color( 0, 0, 0 ) )
            draw.SimpleTextOutlined( PressText, "Trebuchet24", 0, 30, Color(255,255,255,255 ), 1, 0, 2, Color( 0, 0, 0 ) )
        cam.End3D2D()
    end
end