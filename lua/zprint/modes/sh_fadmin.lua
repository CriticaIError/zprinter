zPrint.aMode[ "FAdmin System" ] = {
    displayName = "FAdmin System",
    displayColor = Color( 255, 163, 0 ),
    addFunction = function( panel )
    end,
    rankTable = function() return group_table end,
    enableFunction = function()
        if FAdmin then
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