
zPrint.tabs[ 0 ] = { loadPanels = function( parent )
    local time = CurTime()
    local tim = 1
    local selected = "General"
	local scrollPanel = vgui.Create( "zPrint.Parent", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )
    scrollPanel.Paint = function( slf, w, h )
        local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
        zPrint:addText( "Boolean Settings", "Montserrat", 24, 15, 15, Color( 200, 50, 80, 150 ), 0 )
        zPrint:addText( "Other Settings", "Montserrat", 24, 525, 15, Color( 200, 50, 80, 150 ), 0 )
        zPrint:roundedBox( 0, 10, 30, 505 * alpha, 2, Color( 5, 5, 5, 75 ) )

        zPrint:roundedBox( 0, 505 - 505 * alpha + 10, 425, 505 * alpha, 2, Color( 5, 5, 5, 75 ) )

        zPrint:roundedBox( 0, 525, 30, 355 * alpha, 2, Color( 5, 5, 5, 75 ) )
        zPrint:roundedBox( 0, 355 - 355 * alpha + 525, 425, 355 * alpha, 2, Color( 5, 5, 5, 75 ) )

        zPrint:roundedBox( 0, 525, 370, 355, 50, Color( 5, 5, 5, 75 ) )
        zPrint:addText( "Saving Settings", "Montserrat", 22, 530, 385, Color( 200, 50, 80, 150 ), 0 )
        zPrint:addText( "You must press {ENTER} in order to save settings.", "Montserrat", 16, 530, 402, Color( 163, 163, 163, 150 ), 0 )
    end
    scrollPanel:SetAlpha( 0 )
    scrollPanel:AlphaTo( 255, 0.5, 0 )
    local scroll = vgui.Create( "DScrollPanel", scrollPanel )
	scroll:SetSize( 515, 390 )
	scroll:SetPos( 0, 40 )
	scroll.Paint = function()
	end
    scroll:hideBar()

    local othercfg = vgui.Create( "DScrollPanel", scrollPanel )
	othercfg:SetSize( 365, 385 )
	othercfg:SetPos( 515, 40 )
	othercfg.Paint = function()
	end

    othercfg:hideBar()

	scroll.List = function()
		local i = 0
		for setting, value in pairs( zPrint.plugins[ selected ] ) do
            if !isbool( value ) then continue end
			local settings = ""
			if zPrint.Language[ selected ] then
				settings = zPrint.Language[ selected ][ setting ] or setting
			end
            
            local hoverVal = 0
			local settingName = vgui.Create( "DButton", scroll )
			settingName:SetFont( "Montserrat20" )
			settingName:SetText( "" )
			settingName:SetSize( scroll:GetWide(), 40 )
			settingName:SetPos( 10, i * 35 )
			settingName.Paint = function( slf, w, h )
                if slf:IsHovered() then
                    slf:SetCursor( "hand" )
                    hoverVal = Lerp( 0.05, hoverVal, 1 )
                else
                    slf:SetCursor( "arrow" )
                    hoverVal = Lerp( 0.05, hoverVal, 0 )
                end
				zPrint:addText( settings, "Montserrat", 16, 5, 15, Color( 163, 163, 163, 150 ), TEXT_ALIGN_LEFT )
				zPrint:roundedBox( 0, 0, 0, w, 30, Color( 5, 5, 5, 75 + 50 * hoverVal ) )

                if value == true then
                    zPrint:addText( "Active", "Montserrat", 16, w - 45, 15, Color( 50, 200, 80, 150 ), 2 )
                    zPrint:drawPicture( w - 45, 0, 32, 32, zPrint:getIcon( "closeIcon" ), Color( 50, 200, 80, 150 ) )
                else
                    zPrint:addText( "Inactive", "Montserrat", 16, w - 45, 15, Color( 200, 50, 80, 150 ), 2 )
                    zPrint:drawPicture( w - 45, 0, 32, 32, zPrint:getIcon( "closeIcon" ), Color( 200, 50, 80, 150 ) )
                end
			end

            settingName.DoClick = function()
                print( value )
                net.Start( "zPrint.changeSetting" )
                    net.WriteTable( { plugin = selected, setting = setting, value = !value } )
                net.SendToServer()
                value = !value
            end
			i = i + 1
		end
	end

    othercfg.List = function()
        local i = 0
        for setting, value in pairs( zPrint.plugins[ selected ] ) do
            if isbool( value ) then continue end
			local settings = ""
			if zPrint.Language[ selected ] then
				settings = zPrint.Language[ selected ][ setting ] or setting
			end
            
            local hoverVal = 0
			local settingName = vgui.Create( "DPanel", othercfg )
			settingName:SetText( "" )
			settingName:SetSize( othercfg:GetWide(), 60 )
			settingName:SetPos( 10, i * 55 )
			settingName.Paint = function( slf, w, h )
                if slf:IsHovered() then
                    hoverVal = Lerp( 0.05, hoverVal, 1 )
                else
                    hoverVal = Lerp( 0.05, hoverVal, 0 )
                end
				zPrint:addText( settings, "Montserrat", 16, 5, 15, Color( 163, 163, 163, 150 ), TEXT_ALIGN_LEFT )
				zPrint:roundedBox( 0, 0, 0, w, 54, Color( 5, 5, 5, 75 + 50 * hoverVal ) )
			end

            if isstring( value ) then
                local valueMod = vgui.Create( "zprinters_textinput", othercfg )
                valueMod:SetPos( 15, -2 + i * 55 + 30 )
                valueMod:SetSize( 345, 20 )
                valueMod:SetValue( value )
                valueMod:SetNumeric( false )
                valueMod.OnEnter = function()
                    net.Start( "zPrint.changeSetting" )
                        net.WriteTable( { plugin = selected, setting = setting, value = valueMod:GetValue() } )
                    net.SendToServer()
                end
            end

			i = i + 1
		end
    end
    othercfg.List()
    scroll.List()
end }