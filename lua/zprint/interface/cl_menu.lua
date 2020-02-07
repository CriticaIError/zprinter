-- Menu Setup
------------------------------------------------------------------
--Icons

--Colors
local closeColor = Color( 255, 255, 255, 75 )
------------------------------------------------------------------

concommand.Add( "zPrint.openMenu", function()
    zPrint.openMenu()
end )

function zPrint.openMenu()
    if zprintMenu && zprintMenu:IsValid() then
        zprintMenu:Remove()
        zprintMenu = nil
    end

    zprintMenu = vgui.Create( "zPrint.createMenu" )
    zprintMenu:SetSize( 1200, 600 )
    zprintMenu:SetTitle( "" )
    zprintMenu:Center()
    zprintMenu:MakePopup()
    zprintMenu:Install()
end

local PANEL = {}
function PANEL:Init()
    self:SetTitle( "" )
    self:ShowCloseButton( false )
    self.currentTab = ""
    self.tabContent = vgui.Create( "DPanel", self )
    self.tabContent:SetPos( 303, 63 )
    self.tabContent:SetSize( 886, 494 )
    self.tabContent:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
    self.startTime = SysTime()
    self.start = CurTime()
    self.hover = 0
    self.size = 0
    mode = "Admin Mode"
    zPrint.tabs[ 8 ].loadPanels( self.tabContent )
end

function PANEL:Paint()
    self.time = 1
    Derma_DrawBackgroundBlur( self, self.startTime )
    alpha = Lerp( math.Clamp( ( CurTime( ) - self.start ) / self.time, 0, 1 ), 0, 1 )
    zPrint:roundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 32, 34, 39, 255 ) )
    zPrint:roundedBox( 0, 2, 2, 50, self:GetTall() - 4, Color( 21, 22, 27, 150 * alpha ) )
    zPrint:addText( "Z", "bfhud", 30, 60, 20, Color( 200, 50, 80, 150 * alpha ), 0 )
    zPrint:addText( "Printer", "bfhud", 30, 75, 20, Color( 200, 200, 200, 150 * alpha ), 0 )
    zPrint:addText( "The most configurable and easy printers system ever made.", "Montserrat", 15, 60, 40, Color( 200, 200, 200, 150 * alpha ), 0 )
    --
    zPrint:addText( "Last Update:", "Montserrat", 15, self:GetWide() - 125, 28, Color( 255, 255, 255, 150 * alpha ), 0 )
    zPrint:addText( "Never", "Montserrat", 15, self:GetWide() - 10, 28, Color( 255, 255, 255, 150 * alpha ), 2 )
    --
    zPrint:addText( "Time:", "Montserrat", 15, self:GetWide() - 125, 16, Color( 255, 255, 255, 150 * alpha ), 0 )
    zPrint:addText( os.date( "%H:%M" , os.time() ), "Montserrat", 15, self:GetWide() - 10, 16, Color( 255, 255, 255, 150 * alpha ), 2 )
    --
    zPrint:addText( "Online", "Montserrat", 15, self:GetWide() - 10, 40, Color( 125, 255, 125, 150 * alpha ), 2 )
    zPrint:addText( "Auto Updater:", "Montserrat", 15, self:GetWide() - 125, 40, Color( 255, 255, 255, 150 * alpha ), 0 )
    zPrint:roundedBox( 0, 52, 50, ( self:GetWide() - 52 ) * alpha, 2, Color( 21, 22, 27, 150 ) )
    zPrint:roundedBox( 0, 52, self:GetTall() - 25, self:GetWide() - 52, 25, Color( 21, 22, 27, 150 * alpha ) )

    zPrint:addText( "You're currently using: ", "Montserrat", 18, 60, self:GetTall() - 13, Color( 200, 200, 200, 150 * alpha ), 0 )
    zPrint:addText( zPrint.plugins[ "Other" ].adminMode, "Montserrat", 18, 210, self:GetTall() - 13, Color( 255, 50, 80, 150 * alpha ), 0 )

    zPrint:roundedBox( 0, 60, 60, 60, 2, Color( 21, 22, 27, 150 * alpha ) )
    zPrint:roundedBox( 0, 230, 60, 60, 2, Color( 21, 22, 27, 150 * alpha ) )
    zPrint:roundedBox( 0, 60, 205, 230, 2, Color( 21, 22, 27, 150 * alpha ) )
    zPrint:addText( "Addon Setup", "Montserrat", 18, 175, 60, Color( 255, 50, 80, 150 * alpha ), 1 )

    zPrint:roundedBox( 0, 60, 235, 45, 2, Color( 21, 22, 27, 150 * alpha ) )
    zPrint:roundedBox( 0, 245, 235, 45, 2, Color( 21, 22, 27, 150 * alpha ) )
    zPrint:roundedBox( 0, 60, 475, 230, 2, Color( 21, 22, 27, 150 * alpha ) )
    zPrint:addText( "Attachment Setup", "Montserrat", 18, 175, 235, Color( 255, 50, 80, 150 * alpha ), 1 )

    zPrint:roundedBox( 0, 300, 60, 2, 500 * alpha, Color( 21, 22, 27, 150 ) )
    zPrint:roundedBox( 0, 302, 60, 888 * alpha, 2, Color( 21, 22, 27, 150 ) )
    zPrint:roundedBox( 0, 1190, 60, 2, 500 * alpha, Color( 21, 22, 27, 150 ) )
    zPrint:roundedBox( 0, 302, 558, 888 * alpha, 2, Color( 21, 22, 27, 150 ) )
end

function PANEL:Install()
    local close = vgui.Create( "DButton", zprintMenu )
    close:SetPos( 0, zprintMenu:GetTall() - 30 )
    close:SetSize( 32, 32 )
    close:SetText( "" )
    close.Paint = function( slf, w, h )
        zPrint:updateColors( slf, closeColor )
        zPrint:drawPicture( 0, 0, 32, 32, zPrint:getIcon( "closeIcon" ), closeColor )
    end

    close.DoClick = function()
        if zprintMenu && zprintMenu:IsValid() then
            zprintMenu:Remove()
            zprintMenu = nil
        end
        zPrint.openMenu()
    end

    self.category = vgui.Create( "DPanelList", zprintMenu )
    self.category:SetPos( 75, 75 )
    self.category:SetSize( 200, zprintMenu:GetTall() )
    self.category:SetSpacing( 1 )
    self.category:EnableVerticalScrollbar( true )
    self.category:EnableHorizontal( true )

    self.attachments = vgui.Create( "DPanelList", zprintMenu )
    self.attachments:SetPos( 75, 250 )
    self.attachments:SetSize( 200, zprintMenu:GetTall() )
    self.attachments:SetSpacing( 1 )
    self.attachments:EnableVerticalScrollbar( true )
    self.attachments:EnableHorizontal( true )

    for k, v in pairs( zPrint.Categories ) do
        if v.attachment == true then continue end
        local hover = 0
        local button =  vgui.Create( "DButton", zprintMenu )
        button:SetSize( 230, 30 )
        button:SetText( "" )
        button.tab = nil
        button.Paint = function( slf, w, h )
            zPrint:roundedBox( 0, 0, 0, w, h, Color( 21, 22, 27, 150 * alpha ) )
            zPrint:addText( v.name, "Montserrat", 16, 100 + 5 * hover, h / 2, Color( 163, 163, 163, 150 * alpha ), 1 )

            if ( mode == v.name ) then
                zPrint:drawPicture(  7 * hover, 0, 32, 32, zPrint:getIcon( "rightIcon" ), Color( 200, 50, 80, 150 ) )
                hover = 1
            else
                zPrint:drawPicture(  7 * hover, 0, 32, 32, zPrint:getIcon( "rightIcon" ), Color( 163, 163, 163, 150 ) )
            end

            if slf:IsHovered() then
                hover = Lerp( 0.1, hover, 1 )
            else
                hover = Lerp( 0.1, hover, 0 )
            end
        end

        button.DoClick = function()
            mode = v.name
            surface.PlaySound( "buttons/lightswitch2.wav" )
            for _, panel in pairs ( self.tabContent:GetChildren() ) do
                panel:Remove()
            end
            zPrint.tabs[ v.id ].loadPanels( self.tabContent )
        end

        self.category:AddItem( button )
    end
    for k, v in pairs( zPrint.Categories ) do
        -->Attachments 
        if v.attachment == false then continue end
        local hover = 0
        local button =  vgui.Create( "DButton", zprintMenu )
        button:SetSize( 230, 30 )
        button:SetText( "" )
        button.tab = nil
        button.Paint = function( slf, w, h )
            zPrint:roundedBox( 0, 0, 0, w, h, Color( 21, 22, 27, 150 * alpha ) )
            zPrint:addText( v.name .. " Attachment", "Montserrat", 16, 100 + 5 * hover, h / 2, Color( 163, 163, 163, 150 * alpha ), 1 )

            zPrint:roundedBox( 0, w - 58, h - 27, 25, 25, Color( 21, 22, 27, 150 * alpha ) )
            
            if ( zPrint.plugins[ "Attachment" ][ v.name ] == true ) then
                zPrint:drawPicture(  w - 62, 0, 32, 32, zPrint:getIcon( "closeIcon" ), Color( 80, 200, 50, 50 * alpha ) )
            else
                zPrint:drawPicture(  w - 62, 0, 32, 32, zPrint:getIcon( "closeIcon" ), Color( 200, 50, 80, 50 * alpha ) )
            end

            if ( mode == v.name ) then
                zPrint:drawPicture(  7 * hover, 0, 32, 32, zPrint:getIcon( "rightIcon" ), Color( 200, 50, 80, 150 ) )
                hover = 1
            else
                zPrint:drawPicture(  7 * hover, 0, 32, 32, zPrint:getIcon( "rightIcon" ), Color( 163, 163, 163, 150 ) )
            end

            if slf:IsHovered() then
                hover = Lerp( 0.1, hover, 1 )
            else
                hover = Lerp( 0.1, hover, 0 )
            end
        end

        button.DoClick = function()
            mode = v.name
            surface.PlaySound( "buttons/lightswitch2.wav" )
            for _, panel in pairs ( self.tabContent:GetChildren() ) do
                panel:Remove()
            end
            zPrint.tabs[ v.id ].loadPanels( self.tabContent )
        end

        self.attachments:AddItem( button )
    end
end

vgui.Register( "zPrint.createMenu", PANEL, "DFrame" )