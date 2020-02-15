zPrint.wizard[ 0 ] = { loadContent = function( parent )
    local time = CurTime()
    local tim = 1
    local model = vgui.Create( "DModelPanel", parent )
    model:SetPos( 135, 260 )
    model:SetSize( 242, 242 )
    model:SetLookAt( Vector( 0, 0, 0 ) )
    model:SetFOV( 35 )
    model:SetModel( "models/zerochain/props_zprinter/zpr_printer.mdl" )
    model:GetEntity():SetSkin( 1 )
    model:SetAlpha( 0 )
    model:AlphaTo( 255, 1, 0 )
    valueMod = vgui.Create( "zprinters_textinput", parent )
    valueMod:SetPos( 15, 215 )
    valueMod:SetSize( 485, 20 )
    valueMod:SetValue( "models/zerochain/props_zprinter/zpr_printer.mdl" )
    valueMod:SetNumeric( false )
    valueMod.OnEnter = function( slf )
        if util.IsValidModel( slf:GetValue() ) then
            model:SetModel( slf:GetValue())
            model:SetVisible( true )
            status = true
        else
            model:SetVisible( false )
            status = true
        end
    end

    parent.PaintOver = function( slf, w, h )
        local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
        zPrint:addText( "Choose Entity Model", "Montserrat", 24, 15, 160, Color( 200, 50, 80, 150 * alpha ), 0 )
        zPrint:addText( "Insert the model path below { press enter to confirm }", "Montserrat", 20, 15, 198, Color( 163, 163, 163, 150 ), 0 )
        zPrint:roundedBox( 0, 7, 255, 500, 230, Color( 21, 22, 27, 150 * alpha ) )
        zPrint:roundedBox( 0, 7, 180, 500, 70, Color( 21, 22, 27, 150 * alpha ) )
        zPrint:roundedBox( 0, 515, 180, 2, 305 * alpha, Color( 21, 22, 27, 150 * alpha ) )
    end
end }