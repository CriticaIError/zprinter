--:: File Variables
local redColor = Color( 200, 50, 80, 150 )
local whiteColor = Color( 163, 163, 163, 150 )
--:::::::::::::::::::::::::
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
    function zPrint:registerPrinter( slf, panel )
        local printer = zPrint.plugins[ "PrinterSettings" ]
        zPrinter = {
            [ printer.name ] = {
                name = printer.name,
                health = printer.health,
                amount = printer.amount,
                time = printer.time,
                maxhold = printer.maxhold,
                f4order = printer.f4order,
                sound = printer.sound,
                category = printer.category,
                removalreward = printer.removalreward,
                secondarygroup = printer.secondarygroup,
                overheatchance = printer.overheatchance,
                color = printer.color,
                level = printer.level,
                f4price = printer.f4price,
                f4amount = printer.f4amount,
                groups = zGroup,
                attachments = zAttachment,
                jobs = zJob
            }
        }

        -- We already have the table with all the required information:
        if zPrint:formValidation( zPrinter ) then
            zPrint:notifyCreation( "Warning", "Please complete the entire form.", panel, "materials/gprinters/prohibited_32.png", Color( 200, 50, 80, 255 ) )
            slf.cooldown = CurTime() + 3
            return
        end
        
    end
    function zPrint:checkDatabase( printer )
        for k, v in pairs( printer || {} ) do
            for key, value in pairs( zPrint.printers || {} ) do
                for _, i in pairs( zPrint.printers[ "Printers" ][ value ] || value ) do
                    if ( v.cmd == i.cmd ) then
                        print( "hola" )
                        return true
                    end
                end
            end
        end
        return false
    end
    
    function zPrint:formValidation( printer )
        if printer.health == nil then
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
    
    zPrinter = {
        [ "Default Printer" ] = {
            name = "Printers Name",
            health = 100,
            amount = 10,
            time = 10,
            maxhold = 10,
            f4order = 10,
            sound = "",
            category = "",
            removalreward = 10,
            secondarygrouname = 10,
            overheatchance = 10,
            color = 10,
            level = 10,
            f4price = 1000,
            f4amount = 1,
            zGroup = {},
            zAttachment = {},
            zJob = {}
        }
    }

    zGroup = {}
    zAttachment = {}
    zJob = {}

    local steps = 0
    local defaultTime = CurTime()
	local scrollPanel = vgui.Create( "zPrint.Parent", parent )
	scrollPanel:SetSize( parent:GetWide(), parent:GetTall() )
    scrollPanel:SetAlpha( 0 )
    scrollPanel:AlphaTo( 255, 0.5, 0 )
    scrollPanel.Paint = function( slf, w, h )
        local alpha = Lerp( math.Clamp( ( CurTime( ) - defaultTime ), 0, 1 ), 0, 1 )
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


        zPrint:addText( "Model Registration", "Montserrat", 20, 555, 195, Color( 163, 163, 163, stepcolor[ 0 ] ), 0 )
        zPrint:addText( "Choose the default model or use your own.", "Montserrat", 18, 575, 210, Color( 163, 163, 163, stepcolor[ 0 ] ), 0 )


        zPrint:addText( "Printer Attachments", "Montserrat", 20, 555, 250, Color( 163, 163, 163, stepcolor[ 1 ] ), 0 )
        zPrint:addText( "Select available attachments for the printer.", "Montserrat", 18, 555 + 20 * stephover[ 1 ], 265, Color( 163, 163, 163, stepcolor[ 1 ] ), 0 )

        zPrint:addText( "Printer Jobs", "Montserrat", 20, 555, 305, Color( 163, 163, 163, stepcolor[ 2 ] ), 0 )
        zPrint:addText( "Select jobs that will be able to purchase this.", "Montserrat", 18, 555 + 20 * stephover[ 2 ], 320, Color( 163, 163, 163, stepcolor[ 2 ] ), 0 )

        zPrint:addText( "Printer Groups", "Montserrat", 20, 555, 360, Color( 163, 163, 163, stepcolor[ 3 ] ), 0 )
        zPrint:addText( "Select custom printer groups.", "Montserrat", 18, 555 + 20 * stephover[ 3 ], 375, Color( 163, 163, 163, stepcolor[ 3 ] ), 0 )

        zPrint:addText( "Printer Final Configurations", "Montserrat", 20, 555, 415, Color( 163, 163, 163, stepcolor[ 4 ] ), 0 )
        zPrint:addText( "Configurations for the printer.", "Montserrat", 18, 555 + 20 * stephover[ 4 ], 430, Color( 163, 163, 163, stepcolor[ 4 ] ), 0 )
    end

    local coreTab = vgui.Create( 'DPanel', scrollPanel )
    coreTab:SetPos( 0, 0 )
    coreTab:SetSize( scrollPanel:GetWide(), scrollPanel:GetTall() )
    coreTab.Paint = function( slf, w, h )
        local alpha = Lerp( math.Clamp( ( CurTime( ) - defaultTime ), 0, 1 ), 0, 1 )
        
        zPrint:roundedBox( 0, 7, 40, w - 18, 100, Color( 21, 22, 27, 150 ) )
        zPrint:addText( "zPrint Registration", "Montserrat", 24, 105, 75, Color( 200, 50, 80, 150 ), 0 )
        zPrint:addText( "Before starting the registration progress you must choose a model, remember to copy it in the box below, ", "Montserrat", 19, 105, 93, Color( 163, 163, 163, 150 ), 0 )
        zPrint:addText( "it will display something if it's correct, otherwise it will be empty.", "Montserrat", 19, 105, 110, Color( 163, 163, 163, 150 ), 0 )

        zPrint:drawPicture( -5, 25, 128, 128, zPrint:getIcon( "craftsIcon" ), Color( 163, 163, 163, 50 * alpha ) )
        zPrint:roundedBox( 0, 530, 180, 10, 270, Color( 21, 22, 27, 150 * alpha  ) )
        zPrint:roundedBox( 0, 545, 180, 330, 270, Color( 21, 22, 27, 150 * alpha  ) )
        zPrint:roundedBox( 0, 545, 142, 330, 36, Color( 21, 22, 27, 150 * alpha  ) )
        zPrint:roundedBox( 0, 7, 142, 536, 36, Color( 21, 22, 27, 150 * alpha  ) )

        local n = 5
        for i = 0,n do
            if steps >= i then
                stephover[ i ] = Lerp( 0.1, stephover[ i ], 1 )
            else
                stephover[ i ] = Lerp( 0.1, stephover[ i ], 0 )
            end
        end

        stephover[0] = Lerp( 0.1, stephover[0], 1 )
        zPrint:roundedBox( 0, 532, 182, 6, 5 * stephover[0], Color( 255,50,80, 25 * stephover[0] ) )
        zPrint:drawPicture( 519, 180, 32, 32, zPrint:getIcon( "circleCleanIcon" ), Color( 21, 22, 27, 255 ) )
        zPrint:drawPicture( 523, 184, 24, 24, zPrint:getIcon( "circleCheckIcon" ), Color( 255,50,80, 25 * stephover[0] ) )
   
        zPrint:roundedBox( 4, 532, 206, 6, 40 * stephover[1], Color( 255,50,80, 25 * stephover[1] ) )
        zPrint:drawPicture( 519, 240, 32, 32, zPrint:getIcon( "circleCleanIcon" ), Color( 21, 22, 27, 255 ) )
        zPrint:drawPicture( 523, 244, 24, 24, zPrint:getIcon( "circleCheckIcon" ), Color( 255,50,80, 25 * stephover[1] ) )

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
        if steps <= 3 then
            steps = steps + 1
            zPrint:modifyContent( steps, scrollPanel )
        else
            if CurTime() < ( slf.cooldown or 0 ) then return end
            zPrint:registerPrinter( slf, scrollPanel )
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

    zPrint.wizard[ tabIndex ].loadContent( workPanel )
end