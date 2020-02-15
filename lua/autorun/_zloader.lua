--[[
    zPrinters Version 1.0.0
    Models by ZeroChain
    Code by Zoey
]]

zPrint = zPrint || {}
zPrint.aMode = zPrint.aMode || {}
zPrint.printers = zPrint.printers || {}
zPrint.plugins = zPrint.plugins || {}
zPrint.tabs = zPrint.tabs || {}
zPrint.Language = zPrint.Language || {}
zPrint.cfg = zPrint.cfg || {}
zPrint.Icons = zPrint.Icons || {}
zPrint.wizard = zPrint.wizard || {}

local variables = {
    "syncSettings",
    "syncPrinters",
    "changeSetting"
}

if SERVER then
    resource.AddSingleFile( "resource/fonts/Montserrat-Regular.ttf" )
    resource.AddWorkshop( "1785499383" )

    local files, directories = file.Find( "zprint/*", "LUA" )
    for i, folder in pairs( directories ) do
        local files, directories = file.Find( "zprint/" .. folder .. "/*", "LUA" )
        for i, f in pairs( files ) do
            if string.StartWith( f, "sh_" ) || string.StartWith( f, "cfg_" ) then
                include( "zprint/" .. folder .. "/" .. f )
                AddCSLuaFile( "zprint/" .. folder .. "/" .. f )
            elseif string.StartWith( f, "sv_" ) then
                include( "zprint/" .. folder .. "/" .. f )
            elseif string.StartWith( f, "cl_" ) then
                AddCSLuaFile( "zprint/" .. folder .. "/" .. f )
            end
        end
    end

    for k, v in pairs( variables ) do
        util.AddNetworkString( "zPrint." .. v )
    end
else
    local files, directories = file.Find( "zprint/*", "LUA" )
    for i, folder in pairs( directories ) do
        local files, directories = file.Find( "zprint/" .. folder .. "/*", "LUA" )
        for i, f in pairs( files ) do
            if string.StartWith( f, "sh_" ) || string.StartWith( f, "cfg_" ) then
                include( "zprint/" .. folder .. "/" .. f )
            elseif string.StartWith( f, "cl_" ) then
                include( "zprint/" .. folder .. "/" .. f )
            end
        end
    end

    steamworks.FileInfo( 1785499383, function( result )
        steamworks.Download( result.fileid, true, function( name )
            game.MountGMA( name )
        end )
    end )
end

util.PrecacheModel( "models/zerochain/props_zprinter/zpr_printer.mdl" )