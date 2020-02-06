group_table = {}
zPrint.aMode[ "xAdmin System" ] = {
    displayName = "xAdmin System",
    displayColor = Color( 0, 163, 255 ),
    addFunction = function( panel )
    end,
    rankTable = function() return group_table end,
    enableFunction = function()
        if xAdmin && xAdmin.Groups then
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