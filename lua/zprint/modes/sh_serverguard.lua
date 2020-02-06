group_table = {}
zPrint.aMode[ "Serverguard System" ] = {
    displayName = "Serverguard System",
    displayColor = Color( 0, 255, 163 ),
    addFunction = function( panel )
    end,
    rankTable = function() return group_table end,
    enableFunction = function()
        if serverguard and serverguard.ranks then
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