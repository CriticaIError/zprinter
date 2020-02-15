zPrint.wizard[ 4 ] = { loadContent = function( parent )
    local selected = "PrinterSettings"
    local time = CurTime()
    local tim = 1
    
    parent.PaintOver = function( slf, w, h )
        local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
        zPrint:addText( "Customize Settings", "Montserrat", 24, 15, 160, Color( 200, 50, 80, 150 * alpha ), 0 )
        zPrint:roundedBox( 0, 7, 180, 505, 305, Color( 21, 22, 27, 150 * alpha ) )
        zPrint:roundedBox( 0, 515, 180, 2, 305 * alpha, Color( 21, 22, 27, 150 * alpha ) )
    end

    local scroll = vgui.Create( "DScrollPanel", parent )
	scroll:SetSize( 504, 280 )
	scroll:SetPos( 15, 195 )
	scroll.Paint = function()
	end
    scroll:hideBar()

    scroll.List = function()
		local i = 0
		for setting, value in pairs( zPrint.plugins[ selected ] ) do
			local settings = ""
			if zPrint.Language[ selected ] then
				settings = zPrint.Language[ selected ][ setting ] or setting
			end
            
            local hoverVal = 0
            
            local settingName = vgui.Create( "DPanel", scroll )
            settingName:SetText( "" )
            settingName:SetSize( scroll:GetWide(), 40 )
            settingName:SetPos( 0, i * 35 )
            settingName.Paint = function( slf, w, h )
                if slf:IsHovered() then
                    hoverVal = Lerp( 0.05, hoverVal, 1 )
                else
                    hoverVal = Lerp( 0.05, hoverVal, 0 )
                end
                zPrint:addText( settings, "Montserrat", 16, 5, 15, Color( 163, 163, 163, 150 ), TEXT_ALIGN_LEFT )
                zPrint:roundedBox( 0, 0, 0, w, 30, Color( 5, 5, 5, 75 + 50 * hoverVal ) )
            end

            if setting == "sound" then
                local valueMod = vgui.Create( "zprinter_dcombobox", scroll )
                valueMod:SetPos( 320 , i * 35 + 3 )
                valueMod:SetSize( 165, 25 )
                valueMod:ChooseOption( value )
                valueMod.OnSelect = function( index, text, data )
					net.Start( "zPrint.changeSetting" )
						net.WriteTable( { plugin = selected, setting = setting, value = valueMod:GetSelected() } )
					net.SendToServer()
                end 
            elseif ( setting == "color" ) then        
                local valueMod = vgui.Create( "zprinter_color", scroll )
                valueMod:SetPos( 320 , i * 35 + 3 )
                valueMod:SetSize( 165, 25 )
                valueMod.valor = value
            elseif ( setting == "category" ) then
                local valueMod = vgui.Create( "zprinter_category", scroll )
                valueMod:SetPos( 320 , i * 35 + 3 )
                valueMod:SetSize( 165, 25 )
                valueMod:ChooseOption( value )
                valueMod.OnSelect = function( index, text, data )
					net.Start( "zPrint.changeSetting" )
						net.WriteTable( { plugin = selected, setting = setting, value = valueMod:GetSelected() } )
					net.SendToServer()
                end 
            elseif isnumber( value ) then
                local valueMod = vgui.Create( "zprinters_wang", scroll )
                valueMod:SetSize( 65, 25 )
			    valueMod:SetPos( 420 , i * 35 + 3 )
                valueMod:SetNumeric( true )
                valueMod:SetValue( value )
				valueMod.OnValueChanged = function()
					net.Start( "zPrint.changeSetting" )
						net.WriteTable( { plugin = selected, setting = setting, value = valueMod:GetValue() } )
					net.SendToServer()
				end
            else
                local valueMod = vgui.Create( "zprinters_textinput", scroll )
                valueMod:SetSize( 165, 25 )
                valueMod:SetPos( 320, i * 35 + 3 )
                valueMod:SetValue( value )
                valueMod.OnEnter = function()
					net.Start( "zPrint.changeSetting" )
						net.WriteTable( { plugin = selected, setting = setting, value = valueMod:GetValue() } )
					net.SendToServer()
				end
            end


			i = i + 1
		end
	end
    scroll.List()
end }