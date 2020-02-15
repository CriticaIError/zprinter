zPrint.wizard[ 2 ] = { loadContent = function( parent )
    local time = CurTime()
    local tim = 1
    local jobs = vgui.Create( "DPanelList", parent )
    jobs:SetPos( 14, 215 )
    jobs:SetSize( 601, 250 )
    jobs:SetSpacing( 1 )
    jobs:EnableVerticalScrollbar( true )
    jobs:EnableHorizontal( true )

    for k, v in pairs( RPExtraTeams ) do
        local hover = 0
        local button =  vgui.Create( "DButton", parent )
        button:SetSize( 300, 35 )
        button:SetText( "" )
        button.tab = nil
        button.Paint = function( slf, w, h )
            local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
            if !table.HasValue( zJob, k ) then
                zPrint:addText( v.name, "Montserrat", 18, 25 + 5 * hover, 15, Color( 200, 50, 80, 50 * hover + 50 * alpha ), 0 )
                zPrint:addText( "This job is not selected.", "Montserrat", 15, 25 + 5 * hover, 30, Color( 163, 163, 163, 50 * alpha ), 0 )
                zPrint:drawPicture(  -5 + 5 * hover, 0, 32, 32, zPrint:getIcon( "prohibitedIcon" ), Color( 200, 50, 80, 50 * alpha ) )
            else
                zPrint:addText( v.name, "Montserrat", 18, 25 + 5 * hover, 15, Color( 80, 255, 80, 50 * hover + 50 * alpha ), 0 )
                zPrint:addText( "This job is selected.", "Montserrat", 14, 25 + 5 * hover, 30, Color( 163, 163, 163, 50 * alpha ), 0 )
                zPrint:drawPicture(  - 5 + 5 * hover, 0, 32, 32, zPrint:getIcon( "circleCheckIcon" ), Color( 80, 255, 80, 50 * alpha ) )
            end

            if slf:IsHovered() then
                hover = Lerp( 0.1, hover, 1 )
            else
                hover = Lerp( 0.1, hover, 0 )
            end
        end

        button.DoClick = function()
            if table.HasValue( zJob, k ) then
                table.RemoveByValue( zJob, k )
            else
                table.insert( zJob, k )
            end
        end
        jobs:AddItem( button )
    end

    parent.PaintOver = function( slf, w, h )
        local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
        zPrint:addText( "Customize Jobs", "Montserrat", 24, 15, 160, Color( 200, 50, 80, 150 * alpha ), 0 )
        zPrint:addText( "Configure the jobs that will be able to purchase the printer.", "Montserrat", 17, 15, 198, Color( 163, 163, 163, 150 ), 0 )
        zPrint:roundedBox( 0, 7, 180, 505, 305, Color( 21, 22, 27, 150 * alpha ) )
        zPrint:roundedBox( 0, 515, 180, 2, 305 * alpha, Color( 21, 22, 27, 150 * alpha ) )
    end
end }