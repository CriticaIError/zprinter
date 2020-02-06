hook.Add( "PlayerSay", "zPrint.chatCommand", function( ply, text )
    if ( text == "o" ) then
        ply:ConCommand( "zPrint.openMenu" )
    end
end )