zPrint.tabs[ 8 ] = { loadPanels = function( parent )
    
	local scrollPanel = vgui.Create( "zPrint.Parent", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )
    scrollPanel:SetAlpha( 0 )
    scrollPanel:AlphaTo( 255, 0.5, 0 )
    local panel = vgui.Create( "DPanel", scrollPanel )
    panel:SetSize( scrollPanel:GetWide(), scrollPanel:GetTall() )
	panel:SetPos( 0, 0 )
	panel.Paint = function( slf, w, h )
	end

    scrollPanel.Paint = function( slf, w, h )
        zPrint:roundedBox( 0, 0, 0, w, h, Color( 255, 34, 39, 0 ) )
        zPrint:roundedBox( 0, 7, 5, w - 15, 100, Color( 21, 22, 27, 150 ) )
        zPrint:addText( "Welcome to zPrinter Panel", "Montserrat", 24, 90, 40, Color( 200, 50, 80, 150 ), 0 )
        zPrint:addText( "Remember that in order to make it work and configure it properly, you must choose an admin mode.", "Montserrat", 19, 90, 58, Color( 163, 163, 163, 150 ), 0 )
    end

    local aModes = vgui.Create( "DPanelList", panel )
    aModes:SetPos( 7, 106 )
    aModes:SetSize( panel:GetWide(), 385 )
    aModes:SetSpacing( 1 )
    aModes:EnableVerticalScrollbar( true )
    aModes:EnableHorizontal( true )
    aModes:hideBar()

    for k, v in pairs( zPrint.aMode || {} ) do
        local hover = 0
        local admin_button = vgui.Create( "DButton", scrollPanel )
        admin_button:SetSize( 217, 385 )
        admin_button:SetText( "" )
        admin_button.Paint = function( slf, w, h )
            if v.enableFunction() then
                zPrint:roundedBox( 0, 0, 0, w, h, Color( 21, 22, 27, 150 + 25 * hover ) )
                zPrint:addText( v.displayName, "Montserrat", 24, w / 2, 20, Color( v.displayColor.r, v.displayColor.g, v.displayColor.b, 50 + 50 * hover ), 1 )
                zPrint:roundedBox( 0, 0, 2, w * hover, 1, Color( v.displayColor.r, v.displayColor.g, v.displayColor.b, 50 + 50 * hover ) )
                zPrint:roundedBox( 0, w - w * hover, h - 2, w * hover, 1, Color( v.displayColor.r, v.displayColor.g, v.displayColor.b, 50 + 50 * hover ) )
                zPrint:drawPicture(  w / 2 - 128, h / 2 - 128, 256, 256, zPrint:getIcon( "penguinIcon" ), Color( v.displayColor.r, v.displayColor.g, v.displayColor.b, 2 + 50 * hover ) )
            
            else
                zPrint:roundedBox( 0, 0, 0, w, h, Color( 21, 22, 27, 150 ) )
                zPrint:addText( v.displayName, "Montserrat", 24, w / 2, 20, Color( 72, 72, 72, 50 ), 1 )
                zPrint:addText( "This Admin Mode is not installed", "Montserrat", 16, w / 2, 45, Color( 72, 72, 72, 50 ), 1 )
                zPrint:drawPicture(  w / 2 - 128, h / 2 - 128, 256, 256, zPrint:getIcon( "penguinIcon" ), Color( 72, 72, 72, 50  ) )
            end
            
            if slf:IsHovered() || ( v.displayName == zPrint.plugins[ "Other" ].adminMode ) then
                hover = Lerp( 0.05, hover, 1 )
            else
                hover = Lerp( 0.1, hover, 0 )
            end
        end
        admin_button.DoClick = function()
            for setting, value in pairs( zPrint.plugins[ "Other" ] ) do
				net.Start( "zPrint.changeSetting" )
					net.WriteTable( { plugin = "Other", setting = "adminMode", value = v.displayName } )
				net.SendToServer()
			end
        end
        if !v.enableFunction() then
			admin_button:SetEnabled( false )
			admin_button:SetCursor( "no" )
		end
        aModes:AddItem( admin_button )
    end
end }