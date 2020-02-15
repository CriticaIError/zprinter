zPrint.wizard[ 1 ] = { loadContent = function( parent )
    local time = CurTime()
    local tim = 1

    local disabled = vgui.Create( "DPanelList", parent )
    disabled:SetPos( 14, 215 )
    disabled:SetSize( 225, parent:GetTall() )
    disabled:SetSpacing( 1 )
    disabled:EnableVerticalScrollbar( true )
    disabled:EnableHorizontal( true )

    local enabled = vgui.Create( "DPanelList", parent )
    enabled:SetPos( 265, 215 )
    enabled:SetSize( 225, parent:GetTall() )
    enabled:SetSpacing( 1 )
    enabled:EnableVerticalScrollbar( true )
    enabled:EnableHorizontal( true )

    for k, v in pairs( zPrint.Categories ) do
        if v.attachment == false then continue end
        if ( zPrint.plugins[ "Attachment" ][ v.name ] == false ) then continue end
        local hover = 0
        local button =  vgui.Create( "DButton", parent )
        button:SetSize( 225, 35 )
        button:SetText( "" )
        button.tab = nil
        button.Paint = function( slf, w, h )
            local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
            if !table.HasValue( zAttachment, v.name ) then
                zPrint:addText( v.name .. " Attachment", "Montserrat", 18, 25 + 5 * hover, 15, Color( 200, 50, 80, 50 * hover + 50 * alpha ), 0 )
                zPrint:addText( v.desc, "Montserrat", 14, 25 + 5 * hover, 30, Color( 163, 163, 163, 50 * alpha ), 0 )
                zPrint:drawPicture(  -5 + 5 * hover, 0, 32, 32, zPrint:getIcon( "rightIcon" ), Color( 200, 50, 80, 50 * alpha ) )
            else
                zPrint:addText( v.name .. " Attachment", "Montserrat", 18, 25 + 5 * hover, 15, Color( 80, 255, 80, 50 * hover + 50 * alpha ), 0 )
                zPrint:addText( v.desc, "Montserrat", 14, 25 + 5 * hover, 30, Color( 163, 163, 163, 50 * alpha ), 0 )
                zPrint:drawPicture(  - 5 + 5 * hover, 0, 32, 32, zPrint:getIcon( "rightIcon" ), Color( 80, 255, 80, 50 * alpha ) )
            end

            if slf:IsHovered() then
                hover = Lerp( 0.1, hover, 1 )
            else
                hover = Lerp( 0.1, hover, 0 )
            end

            if ( zPrint.plugins[ "Attachment" ][ v.name ] == true ) then
                slf:SetCursor( "hand" )
            else
                slf:SetCursor( "no" )
            end
        end

        if table.HasValue( zAttachment, v.name ) then
            table.RemoveByValue( zAttachment, v.name )
            table.insert( zAttachment, v.name )
            enabled:AddItem( button )
            continue
        end

        button.DoClick = function()
            if ( zPrint.plugins[ "Attachment" ][ v.name ] == true ) then
                if table.HasValue( zAttachment, v.name ) then
                    table.RemoveByValue( zAttachment, v.name )
                    disabled:AddItem( button )
                else
                    table.insert( zAttachment, v.name )
                    enabled:AddItem( button )
                end
            end
        end
        disabled:AddItem( button )
    end
    
    parent.PaintOver = function( slf, w, h )
        local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
        zPrint:addText( "Choose available attachments:", "Montserrat", 24, 15, 160, Color( 200, 50, 80, 150 * alpha ), 0 )
        zPrint:roundedBox( 0, 7, 180, 250, 30, Color( 21, 22, 27, 150 * alpha ) )
        zPrint:roundedBox( 0, 7, 213, 250, 272, Color( 21, 22, 27, 150 * alpha ) )
        zPrint:roundedBox( 0, 262, 180, 250, 30, Color( 21, 22, 27, 150 * alpha ) )
        zPrint:roundedBox( 0, 262, 213, 250, 272, Color( 21, 22, 27, 150 * alpha ) )
        --zPrint:roundedBox( 0, 10, 175, ( w - 20 ) * alpha, 2, Color( 21, 22, 27, 150 * alpha ) )
        zPrint:roundedBox( 0, 515, 180, 2, 305 * alpha, Color( 21, 22, 27, 150 * alpha ) )

        zPrint:addText( "Disabled Attachments", "Montserrat", 16, 132, 195, Color( 163, 163, 163, 50 * alpha ), 1 )
        zPrint:addText( "Enabled Attachments", "Montserrat", 16, 385, 195, Color( 163, 163, 163, 50 * alpha ), 1 )
    end
end }