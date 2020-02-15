local attachIcony = Material( "materials/gprinters/circle_check_32.png", "smooth noclamp" )
local attachIconn = Material( "materials/gprinters/prohibited_32.png", "smooth noclamp" )

zPrint.aMode[ "ULX System" ] = {
    displayName = "ULX System",
    displayColor = Color( 255, 50, 80 ),
    addFunction = function( panel )
        local time = CurTime()
        local tim = 1
        local jobs = vgui.Create( "DPanelList", workPanel )
        jobs:SetPos( 14, 215 )
        jobs:SetSize( 601, 250 )
        jobs:SetSpacing( 1 )
        jobs:EnableVerticalScrollbar( true )
        jobs:EnableHorizontal( true )

        for k, v in pairs( xgui.data.groups ) do
            if ( v == "operator" or v == "noaccess" ) then continue end
            local hover = 0
            local button =  vgui.Create( "DButton", workPanel )
            button:SetSize( 300, 35 )
            button:SetText( "" )
            button.tab = nil
            button.Paint = function( slf, w, h )
                local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
                if !table.HasValue( zGroup, v ) then
                    --zPrint:roundedBox( 0, 0, 0, w, h, Color( 255, 50, 80, 150 * alpha ) )
                    zPrint:addText( v, "Montserrat", 18, 25 + 5 * hover, 15, Color( 200, 50, 80, 50 * hover + 50 * alpha ), 0 )
                    zPrint:addText( "This group is not selected.", "Montserrat", 15, 25 + 5 * hover, 30, Color( 163, 163, 163, 50 * alpha ), 0 )
                    zPrint:drawPicture(  -5 + 5 * hover, 0, 32, 32, attachIconn, Color( 200, 50, 80, 50 * alpha ) )
                else
                    --zPrint:roundedBox( 0, 0, h - 1, w, 1, Color( 80, 255, 50, 55 * alpha ) )
                    zPrint:addText( v, "Montserrat", 18, 25 + 5 * hover, 15, Color( 80, 255, 80, 50 * hover + 50 * alpha ), 0 )
                    zPrint:addText( "This group is selected.", "Montserrat", 14, 25 + 5 * hover, 30, Color( 163, 163, 163, 50 * alpha ), 0 )
                    zPrint:drawPicture(  - 5 + 5 * hover, 0, 32, 32, attachIcony, Color( 80, 255, 80, 50 * alpha ) )
                end

                if slf:IsHovered() then
                    hover = Lerp( 0.1, hover, 1 )
                else
                    hover = Lerp( 0.1, hover, 0 )
                end
            end

            button.DoClick = function()
                if table.HasValue( zGroup, v ) then
                    table.RemoveByValue( zGroup, v )
                else
                    table.insert( zGroup, v )
                end
            end
            jobs:AddItem( button )
        end
    end,
    rankTable = function() return zGroup end,
    enableFunction = function()
        if xgui then
            return true
        end
        return false
    end,
    editFunction = function( panel, ranks )
    end,
    rankFunction = function( ply )
        return ply:GetUserGroup()
    end
}