-- Decorative Functions Only

local F = {}
F[ "Montserrat" ] = "Montserrat"
F[ "bfhud" ] = "bfhud"

--> This is not a very good idea, but i just like to design as fast as possible, will probably change after seeing which of them i will use.
--> This will be only used to create the menu, after i assign all sizes i'll make a better function, if you still see this message after u buy this, create a ticket.

for a, b in pairs( F ) do
    for k = 0, 100 do
        surface.CreateFont( a .. k, {
            font = b,
            size = k,
            weight = 550,
            antialias = true,
            shadow = true
        })
    end
end

function zPrint:updateColors( dbutton, color )
    if dbutton:IsHovered() then
        color.a = 100
    elseif ( dbutton:IsDown() ) then
        color.a = 255
    else
        color.a = 50
    end
end

function zPrint:roundedBox( rad, x, y, w, h, col )
    draw.RoundedBox( rad, x, y, w, h, col )
end

function zPrint:drawBorder( x, y, w, h, color )
    surface.SetDrawColor( color )
    surface.DrawOutlinedRect( x, y, w, h )
end

function zPrint:drawPicture( x, y, w, h, icon, col )
    surface.SetMaterial( icon )
    surface.SetDrawColor( col )
    surface.DrawTexturedRect( x, y, w, h )
end

function zPrint:addText( text, font, size, x, y, color, align )
    draw.SimpleText( text, font .. size, x, y, color, align, 1 )
end

function zPrint:drawLine( startx, starty, endx, endy, color )
    surface.SetDrawColor( color.r, color.g, color.b, color.a )
    surface.DrawLine( startx, starty, endx, endy )
end

function zPrint:RotatedBox( x, y, w, h, ang, color )
    draw.NoTexture()
    surface.SetDrawColor( color or color_white )
    surface.DrawTexturedRectRotated( x, y, w, h, ang )
end

-- Only as parent
local P0 = {}
function P0:Init()
    self:GetVBar():SetSize( 10 )
    self:GetVBar().Paint = function() draw.RoundedBox( 0, 0, 0, self:GetVBar():GetWide(), self:GetVBar():GetTall(), Color( 255, 255, 255, 10 ) ) end
    self:GetVBar().btnGrip.Paint = function() draw.RoundedBox( 0, 0, 1, self:GetVBar().btnGrip:GetWide(), self:GetVBar().btnGrip:GetTall() - 2, Color( 255, 255, 255, 10 ) ) end
    self:GetVBar().btnUp.Paint = function() draw.RoundedBox( 0, 0, 0, self:GetVBar().btnUp:GetWide(), self:GetVBar().btnUp:GetTall(), Color( 255, 255, 255, 10 ) ) end
    self:GetVBar().btnDown.Paint = function() draw.RoundedBox( 0, 0, 0, self:GetVBar().btnDown:GetWide(), self:GetVBar().btnDown:GetTall(), Color( 255, 255, 255, 10 ) ) end
end
vgui.Register( "zPrint.Parent", P0, "DScrollPanel" )

local metaPanel = FindMetaTable( "Panel" )
function metaPanel:hideBar()
    self.VBar.btnDown.Paint = function( slf )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
    end
    self.VBar.btnUp.Paint = function(slf)
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
    end
    self.VBar.btnGrip.Paint = function( slf )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
    end
    self.VBar.Paint = function( slf )
    end
end

function metaPanel:scrollPanel()
    self.VBar.btnDown.Paint = function( slf )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 100 )
        surface.DrawRect( 5, 1, slf:GetWide() - 4, slf:GetTall() - 4 )
    end
    self.VBar.btnUp.Paint = function(slf)
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 100 )
        surface.DrawRect( 5, 1, slf:GetWide() - 4, slf:GetTall() - 4 )
    end
    self.VBar.btnGrip.Paint = function( slf )
        surface.SetDrawColor( 0, 0, 0, 0 )
        surface.DrawRect( 0, 0, slf:GetWide(), slf:GetTall() )
        surface.SetDrawColor( 0, 0, 0, 100 )
        surface.DrawRect( 5, 1, slf:GetWide() - 4, slf:GetTall() - 4 )
    end
    self.VBar.Paint = function( slf )
    end
end

local P3 = {}
function P3:Init()
    self:SetValue( self:GetValue() || "" )
    self:SetSize( 340, 20 )
    self:SetCursor( "beam" )
    self:SetFont( "Montserrat17" )
    self:SetCursorColor( Color( 163, 163, 163, 150 ) )
end

function P3:Paint( w, h )
    surface.SetDrawColor( Color( 5, 5, 5, 50 ) )
    surface.DrawRect( 0, 0, w, h )
    self:DrawTextEntryText( Color( 171, 171, 171 ), Color( 163, 163, 163, 150 ), Color( 163, 163, 163, 150 ) )

    if ( self:HasFocus() ) then
        surface.SetDrawColor( Color( 163, 163, 163, 15 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
end
vgui.Register( "zprinters_textinput", P3, "DTextEntry" )

local P8 = {}
function P8:Init()
    self:SetSize( 60, 20 )
    self:SetMin( 0 )
    self:SetMax( 100 )
    self:SetDecimals( 0 )
end

function P8:Paint( w, h )
    surface.SetDrawColor( Color( 5, 5, 5, 100 ) )
    surface.DrawRect( 0, 0, w, h )
    surface.SetFont( "Montserrat16" )
    self:DrawTextEntryText( Color( 171, 171, 171 ), Color( 163, 163, 163, 150 ), Color( 163, 163, 163, 150 ) )

    if ( self:HasFocus() ) then
        surface.SetDrawColor( Color( 163, 163, 163, 50 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
end

vgui.Register( "zprinters_wang", P8, "DNumberWang" )

local P7 = {}
function P7:Init()
    self:SetSize( 140, 20 )
    self:SetText( "Select Category" )
    for k, v in pairs( DarkRP.getCategories()[ "entities" ] ) do
        self:AddChoice( v.name )
    end
end

function P7:Paint( w, h )
    zPrint:roundedBox( 0, 0, 0, w, h, Color( 5, 5, 5, 50 ) )
end
vgui.Register( "zprinters_category", P7, "DComboBox" )


local P4 = {}
function P4:Init()
    self:SetSize( 140, 20 )
    self:SetText( "" )
    self.valor = Vector( 163, 163, 163 )
    self.plugins = ""
end

function P4:DoClick()
    local colorpicker = vgui.Create( "DFrame" )
    colorpicker:SetSize( 267, 230 )
    colorpicker:Center()
    colorpicker:SetTitle( "" )
    colorpicker:MakePopup()
    colorpicker:SetDraggable( false )
    colorpicker:ShowCloseButton( false )

    colorpicker.Paint = function( slf, w, h )
        zPrint:roundedBox( 0, 0, 0, slf:GetWide(), slf:GetTall(), Color( 32, 34, 39, 255 ) )
        zPrint:roundedBox( 0, 1, 25, slf:GetWide() - 2, 1, Color( 21, 22, 27, 150 ) )
        zPrint:roundedBox( 0, 1, slf:GetTall() - 45, slf:GetWide() - 2, 1, Color( 21, 22, 27, 150 ) )
        zPrint:addText( "Color Selection Menu", "Montserrat", 14, w / 2, 15, Color( 163, 163, 163, 175 ), 1 )
    end

    local Mixer = vgui.Create( "DColorMixer", colorpicker )
    Mixer:SetSize( 255, 150 )
    Mixer:SetPos( 5, 30 )
    Mixer:SetPalette( false )
    Mixer:SetAlphaBar( false )
    Mixer:SetWangs( true )

    local cbtn = vgui.Create( "DButton", colorpicker )
    cbtn:SetSize( 257, 32 )
    cbtn:SetPos( 5, colorpicker:GetTall() - 35 )
    cbtn:SetText ( "" )
    cbtn.Paint = function( slf, w, h )
        if slf:IsHovered() then
            zPrint:roundedBox( 0, 0, 0, w, h, Color( 5, 5, 5, 150 ) )
        else
            zPrint:roundedBox( 0, 0, 0, w, h, Color( 5, 5, 5, 50 ) )
        end
        zPrint:addText( "Choose Color", "Montserrat", 14, w / 2, h / 2, Color( 163, 163, 163, 175 ), 1 )
    end

    cbtn.DoClick = function()
        if self && self:IsValid() then
            self.valor = Vector( Mixer:GetColor().r, Mixer:GetColor().g, Mixer:GetColor().b )
            colorpicker:Remove()
        else
            colorpicker:Remove()
        end
    end
end

function P4:Paint( w, h )
    zPrint:roundedBox( 0, 0, 0, w, 30, Color( 5, 5, 5, 50 ) )
    zPrint:addText( math.Round( self.valor.r ) .. " " .. math.Round( self.valor.g ) .. " " .. math.Round( self.valor.b ), "Montserrat", 14, w / 2, h / 2, Color( self.valor.r, self.valor.g, self.valor.b, 175 ), 1 )
end
vgui.Register( "zprinter_color", P4, "DButton" )