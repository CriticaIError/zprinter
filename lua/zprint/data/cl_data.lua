net.Receive( "zPrint.syncSettings", function()
    local settings = net.ReadString()
    zPrint.plugins[ settings ] = net.ReadTable()
end )
