zPrint.wizard[ 3 ] = { loadContent = function( parent )
    local time = CurTime()
    local tim = 1
    
    zPrint.aMode[ zPrint.plugins[ "Other" ].adminMode ].addFunction( parent );

    parent.PaintOver = function( slf, w, h )
        local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
        zPrint:addText( "Customize Groups", "Montserrat", 24, 15, 160, Color( 200, 50, 80, 150 * alpha ), 0 )
        zPrint:addText( "Configure the usergroups that will be able to purchase the printer.", "Montserrat", 17, 15, 198, Color( 163, 163, 163, 150 ), 0 )
        zPrint:roundedBox( 0, 7, 180, 505, 305, Color( 21, 22, 27, 150 * alpha ) )
        zPrint:roundedBox( 0, 515, 180, 2, 305 * alpha, Color( 21, 22, 27, 150 * alpha ) )
    end

end }