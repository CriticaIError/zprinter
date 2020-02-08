--[[
    gPrinters Icons Management System
    This is a very very simple system to manage icons instead of creating alot of them always... We just create them once and they will be used everywhere around the script.
]]

function zPrint:registerIcon( name, mat )
    local icon = {}
    icon[ name .. "Icon" ] = Material( mat, "smooth noclamp" )
    table.Merge( zPrint.Icons, icon )
end

zPrint:registerIcon( "circleCheck", "materials/gprinters/circle_check_32.png" )
zPrint:registerIcon( "circleClean", "materials/gprinters/circle_clean_32.png" )
zPrint:registerIcon( "prohibited", "materials/gprinters/prohibited_32.png" )
zPrint:registerIcon( "right", "materials/gprinters/right_32_alt.png" )
zPrint:registerIcon( "crafts", "materials/gprinters/crafts_128.png" )
zPrint:registerIcon( "close", "materials/gprinters/circle_32.png" )
zPrint:registerIcon( "weapon", "materials/gprinters/weapon_128.png" )
zPrint:registerIcon( "penguin", "materials/gprinters/penguin_256.png" )

function zPrint:getIcon( name )
    return zPrint.Icons[ name ]
end