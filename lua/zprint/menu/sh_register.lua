
local pTable = {}
local pID = ""
local stephover = {}
local stepcolor = {}
for i = 0, 6 do
    stephover[ i ] = 0
    stepcolor[ i ] = 15
end

if SERVER then
    util.AddNetworkString( "zPrint.registerPrinters" )
    net.Receive( "zPrint.registerPrinters", function( len, ply )
        if !ply:IsSuperAdmin() then return end
        local printer = net.ReadTable()

        for k, v in pairs( printer || {} ) do
            for key, value in pairs( zPrint.printers || {} ) do
                for _, i in pairs( zPrint.printers[ "Printers" ][ value ] || value ) do
                    if ( v.cmd == i.cmd ) then
                        ply:ChatPrint( "Printer already exist in our database" )
                        return 
                    end
                end
            end
        end

        for k, v in pairs( printer || {} ) do
            zPrint:registerPrinter( "Printers", printer )
        end
    end )
end

if CLIENT then
    function zPrint:checkDatabase( printer )
        for k, v in pairs( printer || {} ) do
            for key, value in pairs( zPrint.printers || {} ) do
                for _, i in pairs( zPrint.printers[ "Printers" ][ value ] || value ) do
                    if ( v.cmd == i.cmd ) then
                        return false
                    end
                end
            end
        end
        return true    
    end
    
    function zPrint:formValidation( printer, id )
        local ent = printer[ id ]
        if ent.name == "" || ent.color == "" || ent.sound == "Choose your sound" || ent.sound == "" || ent.category == "Select Category" || ent.health == "" || ent.health == 0 || ent.amount == "" || ent.tiempo == "" || ent.holdamount == "" || ent.f4order == "" || ent.cpremovalval == "" || ent.policeremovalreward == "" || donation_rank == "" || ent.overheatchance == "" || ent.printer_level == "" then
            return true
        end
        return false
    end

    function zPrint:notifyCreation( title, msg, parent, img, color )
        local imgs = Material( img, "smooth noclamp" )
        local note = vgui.Create( "DPanel", parent )
        note:SetSize( 320, 30 )
        note:SetAlpha( 0 )
        note:AlphaTo( 255, 1, 0 )
        note:SetPos( 220, 145 )
        note.Paint = function( slf, w, h )
            zPrint:roundedBox( 6, 0, 0, w, h, Color( 5, 5, 5, 55 ) )
            zPrint:drawPicture(  0, 0, 32, 32, imgs, color )
            zPrint:addText( title, "Montserrat", 16, 30, 8, color, 0 )
            zPrint:addText( msg, "Montserrat", 16, 30, 20, Color( 163, 163, 163, 150 ), 0 )
        end

        timer.Simple( 1, function()
            if IsValid( note ) then
                note:AlphaTo( 0, 1, 0, function() if note && note:IsValid() then note:Remove() end end )
            end
        end )
    end
end

zPrint.tabs[ 9 ] = { loadPanels = function( parent )
  --------------------------------------------------------------------------------  
    table_jobs = {}
    attachments = {}
    group_table = {}
    local status = true
    local steps = 0
    local time = CurTime()
    local tim = 1
	local scrollPanel = vgui.Create( "zPrint.Parent", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )
    scrollPanel:SetAlpha( 0 )
    scrollPanel:AlphaTo( 255, 0.5, 0 )
    scrollPanel.Paint = function( slf, w, h )
        local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
        zPrint:addText( "Printer Registration", "Montserrat", 24, 15, 15, Color( 163, 163, 163, 150 ), 0 )
        zPrint:roundedBox( 0, 10, 30, ( w - 20 ) * alpha, 2, Color( 5, 5, 5, 75 ) )
        
        for i = 0, 5 do
            if steps >= i then
                stepcolor[ i ] = 50
            else
                stepcolor[ i ] = 25
            end
        end

        zPrint:addText( "Registration Progress", "Montserrat", 20, 555, 152, Color( 163, 163, 163, stepcolor[ 0 ] ), 0 )
        zPrint:addText( "Printers creation progress: " .. ( steps / 4 ) * 100 .. "%", "Montserrat", 16, 570, 168, Color( 163, 163, 163, stepcolor[ 0 ] ), 0 )

        if ( status == true ) then
            zPrint:addText( "Model Registration", "Montserrat", 20, 555, 195, Color( 163, 163, 163, stepcolor[ 0 ] ), 0 )
            zPrint:addText( "Choose the default model or use your own.", "Montserrat", 18, 575, 210, Color( 163, 163, 163, stepcolor[ 0 ] ), 0 )
        end

        zPrint:addText( "Printer Attachments", "Montserrat", 20, 555, 250, Color( 163, 163, 163, stepcolor[ 1 ] ), 0 )
        zPrint:addText( "Select available attachments for the printer.", "Montserrat", 18, 555 + 20 * stephover[ 1 ], 265, Color( 163, 163, 163, stepcolor[ 1 ] ), 0 )

        zPrint:addText( "Printer Jobs", "Montserrat", 20, 555, 305, Color( 163, 163, 163, stepcolor[ 2 ] ), 0 )
        zPrint:addText( "Select jobs that will be able to purchase this.", "Montserrat", 18, 555 + 20 * stephover[ 2 ], 320, Color( 163, 163, 163, stepcolor[ 2 ] ), 0 )

        zPrint:addText( "Printer Groups", "Montserrat", 20, 555, 360, Color( 163, 163, 163, stepcolor[ 3 ] ), 0 )
        zPrint:addText( "Select custom printer groups.", "Montserrat", 18, 555 + 20 * stephover[ 3 ], 375, Color( 163, 163, 163, stepcolor[ 3 ] ), 0 )

        zPrint:addText( "Printer Final Configurations", "Montserrat", 20, 555, 415, Color( 163, 163, 163, stepcolor[ 4 ] ), 0 )
        zPrint:addText( "Configurations for the printer.", "Montserrat", 18, 555 + 20 * stephover[ 4 ], 430, Color( 163, 163, 163, stepcolor[ 4 ] ), 0 )
    end


    local first = vgui.Create( 'DPanel', scrollPanel )
    first:SetPos( 0, 0 )
    first:SetSize( scrollPanel:GetWide(), scrollPanel:GetTall() )
    first.Paint = function( slf, w, h )
        local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
        
        zPrint:roundedBox( 0, 7, 40, w - 18, 100, Color( 21, 22, 27, 150 ) )
        zPrint:addText( "zPrint Registration", "Montserrat", 24, 105, 75, Color( 200, 50, 80, 150 ), 0 )
        zPrint:addText( "Before starting the registration progress you must choose a model, remember to copy it in the box below, ", "Montserrat", 19, 105, 93, Color( 163, 163, 163, 150 ), 0 )
        zPrint:addText( "it will display something if it's correct, otherwise it will be empty.", "Montserrat", 19, 105, 110, Color( 163, 163, 163, 150 ), 0 )


        zPrint:drawPicture( -5, 25, 128, 128, zPrint:getIcon( "craftsIcon" ), Color( 163, 163, 163, 50 * alpha ) )
        zPrint:roundedBox( 0, 530, 180, 10, 270, Color( 21, 22, 27, 150 * alpha  ) )
        zPrint:roundedBox( 0, 545, 180, 330, 270, Color( 21, 22, 27, 150 * alpha  ) )
        zPrint:roundedBox( 0, 545, 142, 330, 36, Color( 21, 22, 27, 150 * alpha  ) )
        zPrint:roundedBox( 0, 7, 142, 536, 36, Color( 21, 22, 27, 150 * alpha  ) )

        --[ Steps Setup ]
        local n = 5
        for i = 0,n do
            if steps >= i then
                stephover[ i ] = Lerp( 0.1, stephover[ i ], 1 )
            else
                stephover[ i ] = Lerp( 0.1, stephover[ i ], 0 )
            end
        end

        --------------------------------------------------------------------------------------------------------
        --[ Step 0 ] 
        stephover[0] = Lerp( 0.1, stephover[0], 1 )
        zPrint:roundedBox( 0, 532, 182, 6, 5 * stephover[0], Color( 255,50,80, 25 * stephover[0] ) )
        zPrint:drawPicture( 519, 180, 32, 32, zPrint:getIcon( "circleCleanIcon" ), Color( 21, 22, 27, 255 ) )
        zPrint:drawPicture( 523, 184, 24, 24, zPrint:getIcon( "circleCheckIcon" ), Color( 255,50,80, 25 * stephover[0] ) )
        --[ Step 1 ]        
        zPrint:roundedBox( 4, 532, 206, 6, 40 * stephover[1], Color( 255,50,80, 25 * stephover[1] ) )
        zPrint:drawPicture( 519, 240, 32, 32, zPrint:getIcon( "circleCleanIcon" ), Color( 21, 22, 27, 255 ) )
        zPrint:drawPicture( 523, 244, 24, 24, zPrint:getIcon( "circleCheckIcon" ), Color( 255,50,80, 25 * stephover[1] ) )
        --[ Step 2 ] 
        zPrint:roundedBox( 4, 532, 266, 6, 40 * stephover[2], Color( 255,50,80, 25 * stephover[2] ) )
        zPrint:drawPicture( 519, 300, 32, 32, zPrint:getIcon( "circleCleanIcon" ), Color( 21, 22, 27, 255 ) )
        zPrint:drawPicture( 523, 304, 24, 24, zPrint:getIcon( "circleCheckIcon" ), Color( 255,50,80, 25 * stephover[2] ) )

        zPrint:roundedBox( 4, 532, 326, 6, 40 * stephover[3], Color( 255,50,80, 25 * stephover[3] ) )
        zPrint:drawPicture( 519, 360, 32, 32, zPrint:getIcon( "circleCleanIcon" ), Color( 21, 22, 27, 255 ) )
        zPrint:drawPicture( 523, 364, 24, 24, zPrint:getIcon( "circleCheckIcon" ), Color( 255,50,80, 25 * stephover[3] ) )

        zPrint:roundedBox( 4, 532, 386, 6, 40 * stephover[4], Color( 255,50,80, 25 * stephover[4] ) )
        zPrint:roundedBox( 0, 532, 445, 6, 5 * stephover[5], Color( 255,50,80, 25 * stephover[5] ) )
        zPrint:drawPicture( 519, 420, 32, 32, zPrint:getIcon( "circleCleanIcon" ), Color( 21, 22, 27, 255 ) )
        zPrint:drawPicture( 523, 424, 24, 24, zPrint:getIcon( "circleCheckIcon" ), Color( 255,50,80, 25 * stephover[4] ) )
        
        ------------------------
    end

    zPrint:modifyContent( 0, scrollPanel )

    local phover = 0
    local previous = vgui.Create( "DButton", scrollPanel )
    previous:SetPos( 525, 455 )
    previous:SetSize( 170, 30 )
    previous:SetText( "" )
    previous.Paint = function( slf, w, h )
        if slf:IsHovered() then
            phover = Lerp( 0.1, phover, 1 )

            if ( steps <= 0 ) then
                slf:SetCursor( "no" )
                phover = 0
            else
                slf:SetCursor( "hand" )
            end
        else
            phover = Lerp( 0.1, phover, 0 )
        end
        if ( steps <= 0 ) then
            zPrint:roundedBox( 0, 0, 0, 500, 70, Color( 82, 82, 82, 15 ) )
        else
            zPrint:roundedBox( 0, 0, 0, 500, 70, Color( 5, 5, 5, 75 + 50 * phover  ) )
        end
        zPrint:addText( "Previous Step", "Montserrat", 16, w / 2, h / 2, Color( 163, 163, 163, 100 + 50 * phover ), 1 )
    end
    previous.DoClick = function()
        if steps == 4 then
            pTable[ pID ] = {
                cmd = string.lower( "z" .. string.Replace( name:GetValue(), " ", "_" ) ),
                name = name:GetValue(),
                health = health:GetValue(),
                sound = sound:GetValue(),
                category = category:GetValue(),
                amount = amount:GetValue(),
                tiempo = tiempo:GetValue(),
                holdamount = holdamount:GetValue(),
                f4order = f4order:GetValue(),
                cpremovalval = cpremovalval,
                policeremovalreward = policeremovalreward:GetValue(),
                donation_rank = donation_rank:GetValue(),
                overheatchance = overheatchance:GetValue(),
                printer_level = printer_level:GetValue(),
                color = pcolor.valor
            }

        end
        steps = steps - 1
        if steps < 0 then
            steps = 0
        end
        zPrint:modifyContent( steps, scrollPanel )
    end

    local nhover = 0
    local back = Color( 0, 0, 0 )
    local next = vgui.Create( "DButton", scrollPanel )
    next:SetPos( 705, 455 )
    next:SetSize( 170, 30 )
    next:SetText( "" )
    next.Paint = function( slf, w, h )
        if slf:IsHovered() then
            nhover = Lerp( 0.1, nhover, 1 )
        else
            nhover = Lerp( 0.1, nhover, 0 )
        end

        if ( steps <= 0 ) && IsValid( valueMod ) && !util.IsValidModel( valueMod:GetValue() ) then
            slf:SetCursor( "no" )
            back = Color( 82, 82, 82, 15 )
        else
            slf:SetCursor( "hand" )
            back = Color( 5, 5, 5, 75 + 50 * nhover)
        end

        zPrint:roundedBox( 0, 0, 0, 500, 70, back )
        if steps < 4 then
            zPrint:addText( "Next Step", "Montserrat", 16, w / 2, h / 2, Color( 163, 163, 163, 100 + 50 * nhover ), 1 )
        else
            zPrint:addText( "Create Money Printer", "Montserrat", 16, w / 2, h / 2, Color( 163, 163, 163, 100 + 50 * nhover ), 1 )
        end
    end
    next.DoClick = function( slf )
        if steps >= 4 then
            pTable[ pID ] = {
                cmd = string.lower( "z" .. string.Replace( name:GetValue(), " ", "_" ) ),
                name = name:GetValue(),
                health = health:GetValue(),
                sound = sound:GetValue(),
                category = category:GetValue(),
                amount = amount:GetValue(),
                tiempo = tiempo:GetValue(),
                holdamount = holdamount:GetValue(),
                f4order = f4order:GetValue(),
                cpremovalval = cpremovalval,
                policeremovalreward = policeremovalreward:GetValue(),
                donation_rank = donation_rank:GetValue(),
                overheatchance = overheatchance:GetValue(),
                printer_level = printer_level:GetValue(),
                color = pcolor.valor
            }


            if zPrint:formValidation( pTable, pID ) then
                zPrint:notifyCreation( "Warning", "Please complete the entire form.", scrollPanel, "materials/gprinters/prohibited_32.png", Color( 200, 50, 80, 255 ) )
                slf.cooldown = CurTime() + 3
                return
            end
            
            --> Verify if the printer exist in the database. 
            if zPrint:checkDatabase( pTable[ pID ] ) then
                zPrint:notifyCreation( "Warning", "Please verify that the printer doesn't exist.", scrollPanel, "materials/gprinters/prohibited_32.png", Color( 200, 50, 80, 255 ) )
                slf.cooldown = CurTime() + 3
                return
            end

            if !LocalPlayer():IsSuperAdmin() then
                zPrint:notifyCreation( "Warning", "You don't have enough privileges to create.", scrollPanel, "materials/gprinters/prohibited_32.png", Color( 200, 50, 80, 255 ) )
                slf.cooldown = CurTime() + 3
                return
            end

            zPrint:notifyCreation( "Success", "Printer Created Successfully.", scrollPanel, "materials/gprinters/circle_check_32.png", Color( 80, 200, 50, 150 ) )

            net.Start( "zPrint.registerPrinters" )
                net.WriteTable( pTable )
            net.SendToServer()
        end
        if steps <= 3 then
            steps = steps + 1
            zPrint:modifyContent( steps, scrollPanel )
        end
        
    end
end }


function zPrint:modifyContent( tabIndex, parent )
    if IsValid( workPanel ) then
        for _, panel in pairs ( workPanel:GetChildren() ) do
            panel:Remove()
        end
        workPanel:Remove()
    end
    
    workPanel = vgui.Create( "DPanel", parent )
    workPanel:SetPos( 0, 0 )
    workPanel:SetSize( 525, parent:GetTall() )
    workPanel.Paint = function()
    end

    if tabIndex <= 0 then
        local time = CurTime()
        local tim = 1
        local model = vgui.Create( "DModelPanel", workPanel )
        model:SetPos( 135, 260 )
        model:SetSize( 242, 242 )
        model:SetLookAt( Vector( 0, 0, 0 ) )
        model:SetFOV( 35 )
        model:SetModel( "models/zerochain/props_zprinter/zpr_printer.mdl" )
        model:GetEntity():SetSkin( 1 )
        model:SetAlpha( 0 )
        model:AlphaTo( 255, 1, 0 )
        valueMod = vgui.Create( "zprinters_textinput", workPanel )
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
                --status = false
                status = true
            end
        end
        
        pTable[ valueMod:GetValue() ] = {
            model = valueMod:GetValue()
        }
        pID = valueMod:GetValue()

        workPanel.PaintOver = function( slf, w, h )
            local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
            zPrint:addText( "Choose Entity Model", "Montserrat", 24, 15, 160, Color( 200, 50, 80, 150 * alpha ), 0 )
            zPrint:addText( "Insert the model path below { press enter to confirm }", "Montserrat", 20, 15, 198, Color( 163, 163, 163, 150 ), 0 )
            zPrint:roundedBox( 0, 7, 255, 500, 230, Color( 21, 22, 27, 150 * alpha ) )
            zPrint:roundedBox( 0, 7, 180, 500, 70, Color( 21, 22, 27, 150 * alpha ) )
            --zPrint:roundedBox( 0, 10, 175, ( w - 20 ) * alpha, 2, Color( 21, 22, 27, 150 * alpha ) )
            zPrint:roundedBox( 0, 515, 180, 2, 305 * alpha, Color( 21, 22, 27, 150 * alpha ) )
        end
    end
    
    if tabIndex == 1 then

        local time = CurTime()
        local tim = 1

        local disabled = vgui.Create( "DPanelList", workPanel )
        disabled:SetPos( 14, 215 )
        disabled:SetSize( 225, workPanel:GetTall() )
        disabled:SetSpacing( 1 )
        disabled:EnableVerticalScrollbar( true )
        disabled:EnableHorizontal( true )

        local enabled = vgui.Create( "DPanelList", workPanel )
        enabled:SetPos( 265, 215 )
        enabled:SetSize( 225, workPanel:GetTall() )
        enabled:SetSpacing( 1 )
        enabled:EnableVerticalScrollbar( true )
        enabled:EnableHorizontal( true )

        for k, v in pairs( zPrint.Categories ) do
            if v.attachment == false then continue end
            if ( zPrint.plugins[ "Attachment" ][ v.name ] == false ) then continue end
            local hover = 0
            local button =  vgui.Create( "DButton", workPanel )
            button:SetSize( 225, 35 )
            button:SetText( "" )
            button.tab = nil
            button.Paint = function( slf, w, h )
                local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
                

                if !table.HasValue( attachments, v.name ) then
                    --zPrint:roundedBox( 0, 0, 0, w, h, Color( 255, 50, 80, 150 * alpha ) )
                    zPrint:addText( v.name .. " Attachment", "Montserrat", 18, 25 + 5 * hover, 15, Color( 200, 50, 80, 50 * hover + 50 * alpha ), 0 )
                    zPrint:addText( v.desc, "Montserrat", 14, 25 + 5 * hover, 30, Color( 163, 163, 163, 50 * alpha ), 0 )
                    zPrint:drawPicture(  -5 + 5 * hover, 0, 32, 32, zPrint:getIcon( "rightIcon" ), Color( 200, 50, 80, 50 * alpha ) )
                else
                    --zPrint:roundedBox( 0, 0, h - 1, w, 1, Color( 80, 255, 50, 55 * alpha ) )
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

            if table.HasValue( attachments, v.name ) then
                table.RemoveByValue( attachments, v.name )
                table.insert( attachments, v.name )
                enabled:AddItem( button )
                continue
            end

            button.DoClick = function()
                if ( zPrint.plugins[ "Attachment" ][ v.name ] == true ) then
                    if table.HasValue( attachments, v.name ) then
                        table.RemoveByValue( attachments, v.name )
                        disabled:AddItem( button )
                    else
                        table.insert( attachments, v.name )
                        enabled:AddItem( button )
                    end
                end
            end
            disabled:AddItem( button )
        end
        
        workPanel.PaintOver = function( slf, w, h )
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
    end

    if tabIndex == 2 then
        local time = CurTime()
        local tim = 1
        local jobs = vgui.Create( "DPanelList", workPanel )
        jobs:SetPos( 14, 215 )
        jobs:SetSize( 601, 250 )
        jobs:SetSpacing( 1 )
        jobs:EnableVerticalScrollbar( true )
        jobs:EnableHorizontal( true )

        for k, v in pairs( RPExtraTeams ) do
            local hover = 0
            local button =  vgui.Create( "DButton", workPanel )
            button:SetSize( 300, 35 )
            button:SetText( "" )
            button.tab = nil
            button.Paint = function( slf, w, h )
                local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
                if !table.HasValue( table_jobs, k ) then
                    --zPrint:roundedBox( 0, 0, 0, w, h, Color( 255, 50, 80, 150 * alpha ) )
                    zPrint:addText( v.name, "Montserrat", 18, 25 + 5 * hover, 15, Color( 200, 50, 80, 50 * hover + 50 * alpha ), 0 )
                    zPrint:addText( "This job is not selected.", "Montserrat", 15, 25 + 5 * hover, 30, Color( 163, 163, 163, 50 * alpha ), 0 )
                    zPrint:drawPicture(  -5 + 5 * hover, 0, 32, 32, zPrint:getIcon( "prohibitedIcon" ), Color( 200, 50, 80, 50 * alpha ) )
                else
                    --zPrint:roundedBox( 0, 0, h - 1, w, 1, Color( 80, 255, 50, 55 * alpha ) )
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
                if table.HasValue( table_jobs, k ) then
                    table.RemoveByValue( table_jobs, k )
                else
                    table.insert( table_jobs, k )
                end
            end
            jobs:AddItem( button )
        end

        workPanel.PaintOver = function( slf, w, h )
            local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
            zPrint:addText( "Customize Jobs", "Montserrat", 24, 15, 160, Color( 200, 50, 80, 150 * alpha ), 0 )
            zPrint:addText( "Configure the jobs that will be able to purchase the printer.", "Montserrat", 17, 15, 198, Color( 163, 163, 163, 150 ), 0 )
            zPrint:roundedBox( 0, 7, 180, 505, 305, Color( 21, 22, 27, 150 * alpha ) )
            --zPrint:roundedBox( 0, 10, 175, ( w - 20 ) * alpha, 2, Color( 21, 22, 27, 150 * alpha ) )
            zPrint:roundedBox( 0, 515, 180, 2, 305 * alpha, Color( 21, 22, 27, 150 * alpha ) )
        end
    end

    if tabIndex == 3 then
        local time = CurTime()
        local tim = 1
        
        zPrint.aMode[ zPrint.plugins[ "Other" ].adminMode ].addFunction( workPanel );

        workPanel.PaintOver = function( slf, w, h )
            local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
            zPrint:addText( "Customize Groups", "Montserrat", 24, 15, 160, Color( 200, 50, 80, 150 * alpha ), 0 )
            zPrint:addText( "Configure the usergroups that will be able to purchase the printer.", "Montserrat", 17, 15, 198, Color( 163, 163, 163, 150 ), 0 )
            zPrint:roundedBox( 0, 7, 180, 505, 305, Color( 21, 22, 27, 150 * alpha ) )
            --zPrint:roundedBox( 0, 10, 175, ( w - 20 ) * alpha, 2, Color( 21, 22, 27, 150 * alpha ) )
            zPrint:roundedBox( 0, 515, 180, 2, 305 * alpha, Color( 21, 22, 27, 150 * alpha ) )
        end
    end
    if tabIndex == 4 then
        local time = CurTime()
        local tim = 1
        name = vgui.Create( "zprinters_textinput", workPanel )
        name:SetPos( 15, 205 )
        name:SetSize( 242.5, 20 )
        name:SetNumeric( false )
        name:SetValue( pTable[ pID ].name || "" )

        health = vgui.Create( "zprinters_textinput", workPanel )
        health:SetPos( 15, 245 )
        health:SetSize( 242.5, 20 )
        health:SetNumeric( true )

        sound = vgui.Create( "zprinters_textinput", workPanel )
        sound:SetPos( 15, 285 )
        sound:SetSize( 242.5, 20 )
        sound:SetNumeric( false )

        category = vgui.Create( "zprinters_category", workPanel )
        category:SetPos( 15, 325 )
        category:SetSize( 242.5, 20 )

        amount = vgui.Create( "zprinters_textinput", workPanel )
        amount:SetPos( 260, 205 )
        amount:SetSize( 242.5, 20 )
        amount:SetNumeric( true )

        tiempo = vgui.Create( "zprinters_textinput", workPanel )
        tiempo:SetPos( 260, 245 )
        tiempo:SetSize( 242.5, 20 )
        tiempo:SetNumeric( true )

        holdamount = vgui.Create( "zprinters_textinput", workPanel )
        holdamount:SetPos( 260, 285 )
        holdamount:SetSize( 242.5, 20 )
        holdamount:SetNumeric( true )

        f4order = vgui.Create( "zprinters_textinput", workPanel )
        f4order:SetPos( 260, 325 )
        f4order:SetSize( 242.5, 20 )
        f4order:SetNumeric( true )

        cpremovalval = cpremovalval || 0
        local hoverVal = 0
        local cpRemoval = vgui.Create( "DButton", workPanel )
        cpRemoval:SetFont( "Montserrat20" )
        cpRemoval:SetSize( 242.5, 20 )
        cpRemoval:SetText(  "" )
        cpRemoval:SetPos( 260, 365 )
        cpRemoval.Paint = function( slf, w, h )
            if slf:IsHovered() then
                slf:SetCursor( "hand" )
                hoverVal = Lerp( 0.05, hoverVal, 1 )
            else
                slf:SetCursor( "arrow" )
                hoverVal = Lerp( 0.05, hoverVal, 0 )
            end
            zPrint:roundedBox( 0, 0, 0, w, 30, Color( 5, 5, 5, 50 ) )

            if cpremovalval == 1 then
                zPrint:addText( "Active", "Montserrat", 16, w - 5, h / 2, Color( 50, 200, 80, 150 ), 2 )
            else
                zPrint:addText( "Inactive", "Montserrat", 16, w - 5, h / 2, Color( 200, 50, 80, 150 ), 2 )
            end
        end

        cpRemoval.DoClick = function()
            if ( cpremovalval == 1 ) then
                cpremovalval = 0
            else
                cpremovalval = 1
            end
        end

        policeremovalreward = vgui.Create( "zprinters_textinput", workPanel )
        policeremovalreward:SetPos( 15, 365 )
        policeremovalreward:SetSize( 242.5, 20 )
        policeremovalreward:SetNumeric( true )

        donation_rank = vgui.Create( "zprinters_textinput", workPanel )
        donation_rank:SetPos( 15, 415 )
        donation_rank:SetSize( 242.5, 20 )
        donation_rank:SetNumeric( true )

        overheatchance = vgui.Create( "zprinters_textinput", workPanel )
        overheatchance:SetPos( 260, 415 )
        overheatchance:SetSize( 242.5, 20 )
        overheatchance:SetNumeric( true )

        printer_level = vgui.Create( "zprinters_textinput", workPanel )
        printer_level:SetPos( 260, 455 )
        printer_level:SetSize( 242.5, 20 )
        printer_level:SetNumeric( true )

        pcolor = vgui.Create( "zprinter_color", workPanel )
        pcolor:SetPos( 15, 455 )
        pcolor:SetSize( 242.5, 20 )

        workPanel.PaintOver = function( slf, w, h )
            local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
            -->
            zPrint:addText( "Customize Information", "Montserrat", 24, 15, 160, Color( 200, 50, 80, 150 * alpha ), 0 )
            zPrint:roundedBox( 0, 7, 180, 505, 305, Color( 21, 22, 27, 150 * alpha ) )
            --zPrint:roundedBox( 0, 10, 175, ( w - 20 ) * alpha, 2, Color( 21, 22, 27, 150 * alpha ) )
            zPrint:roundedBox( 0, 515, 180, 2, 305 * alpha, Color( 21, 22, 27, 150 * alpha ) )
            
            zPrint:addText( "Printers Name", "Montserrat", 16, 15, 195, Color( 163, 163, 163, 50 * alpha ), 0 )
            zPrint:addText( "Printers Health", "Montserrat", 16, 15, 235, Color( 163, 163, 163, 50 * alpha ), 0 )
            zPrint:addText( "Printers Sound", "Montserrat", 16, 15, 275, Color( 163, 163, 163, 50 * alpha ), 0 )
            zPrint:addText( "Printer Category", "Montserrat", 16, 15, 315, Color( 163, 163, 163, 50 * alpha ), 0 )
            zPrint:addText( "Police Removal Reward", "Montserrat", 16, 15, 355, Color( 163, 163, 163, 50 * alpha ), 0 )
            zPrint:addText( "Secondary Donation Group", "Montserrat", 16, 15, 395, Color( 163, 163, 163, 50 * alpha ), 0 )
            zPrint:addText( "Leave blank if you don't own this addon.", "Montserrat", 14, 15, 408, Color( 200, 50, 80, 50 * alpha ), 0 )

            zPrint:addText( "Printers Color", "Montserrat", 16, 15, 445, Color( 163, 163, 163, 50 * alpha ), 0 )

            zPrint:addText( "Print Amount", "Montserrat", 16, 500, 195, Color( 163, 163, 163, 50 * alpha ), 2 )
            zPrint:addText( "Print Time", "Montserrat", 16, 500, 235, Color( 163, 163, 163, 50 * alpha ), 2 )
            zPrint:addText( "Printers Hold Amount", "Montserrat", 16, 500, 275, Color( 163, 163, 163, 50 * alpha ), 2 )
            zPrint:addText( "F4 Sort Order", "Montserrat", 16, 500, 315, Color( 163, 163, 163, 50 * alpha ), 2 )
            zPrint:addText( "Enable CP Removal?", "Montserrat", 16, 500, 355, Color( 163, 163, 163, 50 * alpha ), 2 )
            zPrint:addText( "Overheat Chance", "Montserrat", 16, 500, 395, Color( 163, 163, 163, 50 * alpha ), 2 )
            zPrint:addText( "X% of chance of overheating", "Montserrat", 14, 500, 408, Color( 200, 50, 80, 50 * alpha ), 2 )

            zPrint:addText( "Printers Level", "Montserrat", 16, 500, 445, Color( 163, 163, 163, 50 * alpha ), 2 )
        end
    end

    if tabIndex == 5 then
        local time = CurTime()
        local tim = 1
        

        workPanel.PaintOver = function( slf, w, h )
            local alpha = Lerp( math.Clamp( ( CurTime( ) - time ) / tim, 0, 1 ), 0, 1 )
            zPrint:addText( "Customize Groups", "Montserrat", 24, 15, 160, Color( 200, 50, 80, 150 * alpha ), 0 )
            zPrint:addText( "Configure the usergroups that will be able to purchase the printer.", "Montserrat", 17, 15, 198, Color( 163, 163, 163, 150 ), 0 )
            zPrint:roundedBox( 0, 7, 180, 505, 305, Color( 21, 22, 27, 150 * alpha ) )
            --zPrint:roundedBox( 0, 10, 175, ( w - 20 ) * alpha, 2, Color( 21, 22, 27, 150 * alpha ) )
            zPrint:roundedBox( 0, 515, 180, 2, 305 * alpha, Color( 21, 22, 27, 150 * alpha ) )
        end
    end
end