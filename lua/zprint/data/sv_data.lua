if CLIENT then return end


function zPrint:addPrinter( pname, params, ent_cmd )
	params = params or {}
	ent_cmd = ent_cmd

	local ENT = {}
	ENT.Type = "anim"
	ENT.Base = "zbase"
	ENT.PrintName = pname
	ENT.Spawnable = false
	ENT.AdminSpawnable = false
	ENT.data = params
	scripted_ents.Register( ENT, ent_cmd )
	return ent_cmd
end


function zPrint.changeSetting( plugin, setting, value )
    zPrint.plugins[ plugin ][ setting ] = value
    file.Write( "zprint/settings/" .. string.lower( string.Replace( plugin, " ", "_" ) ) .. ".txt", util.TableToJSON( zPrint.plugins[ plugin ] ) )
    for k, v in pairs( player.GetAll() ) do
        if v:IsSuperAdmin() then
            zPrint.syncPlugins( v, plugin )
        end
    end
end

net.Receive( "zPrint.changeSetting", function( len, ply )
    if !ply:IsSuperAdmin() then return end
    local data = net.ReadTable()
    zPrint.changeSetting( data.plugin, data.setting, data.value )
end )

function zPrint:registerPlugin( name, settings )
    zPrint.plugins[ name ] = settings
    local fileLoc = "zprint/settings/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt"

    if !file.Exists( fileLoc, "DATA" ) then
        file.Write( fileLoc, util.TableToJSON( settings ) )
    else
        plugins = zPrint.plugins[ name ] || {}
        local newPlugins = util.JSONToTable( file.Read( fileLoc ) ) || {}

        for k, v in pairs( plugins ) do
            for a, b in pairs( newPlugins ) do
                if k == a then
                    plugins[ k ] = nil
                end
            end
        end

        table.Merge( newPlugins, plugins )
        file.Write( fileLoc, util.TableToJSON( newPlugins ) )
        zPrint.plugins[ name ] = util.JSONToTable( file.Read( fileLoc ) )
    end
end

function zPrint:registerPrinter( name, settings )
    local fileLoc = "zprint/printers/" .. string.lower( string.Replace( name, " ", "_" ) ) .. ".txt"
    zPrint.printers[ name ] = settings
    if !file.Exists( fileLoc, "DATA" ) then
        file.Write( fileLoc, util.TableToJSON( settings ) )
    else
        local data = {}
        data = util.JSONToTable( file.Read( fileLoc ) )
        table.Merge( data, zPrint.printers[ name ] )
        file.Write( fileLoc, util.TableToJSON( data ) )
        zPrint.printers[ name ] = util.JSONToTable( file.Read( fileLoc ) )
    end

    for k, v in pairs( player.GetAll() ) do
        zPrint.syncPrinters( v, "Printers" )
    end
    --[[
    for k, v in pairs( player.GetAll() ) do
        -- Current Printer Information Stored In zPrint
        zPrint:addPrinter( v.name, {
            model = v.model,
            name = v.name
        }, v.cmd )
    end
    ]]
end

function zPrint.removePrinter( id )
    local fileLoc = "zprint/printers/printers.txt"
    local data = util.JSONToTable( file.Read( fileLoc ) )
    if table.HasValue( data, data[ id ] ) then
        data[ id ] = nil
        file.Write( fileLoc, util.TableToJSON( data ) )
        zPrint.printers[ "Printers" ] = util.JSONToTable( file.Read( fileLoc ) )

        for k, v in pairs( player.GetAll() ) do
            zPrint.syncPrinters( v, "Printers" )
        end
    end
end

function zPrint.syncPlugins( ply, plugin )
    if plugin then
        net.Start( "zPrint.syncSettings" )
            net.WriteString( plugin )
            net.WriteTable( zPrint.plugins[ plugin ] )
        net.Send( ply )
    else
        for k, v in pairs( zPrint.plugins ) do
            net.Start( "zPrint.syncSettings" )
                net.WriteString( k )
                net.WriteTable( v )
            net.Send( ply )
        end
    end
end

function zPrint.syncPrinters( ply, plugin )
    if plugin then
        net.Start( "zPrint.syncPrinters" )
            net.WriteString( plugin )
            net.WriteTable( zPrint.printers[ plugin ] )
        net.Send( ply )
    else
        for k, v in pairs( zPrint.printers ) do
            net.Start( "zPrint.syncPrinters" )
                net.WriteString( k )
                net.WriteTable( v )
            net.Send( ply )
        end
    end
end

hook.Add( "PlayerInitialSpawn", "zPrint.syncSystem", function( ply )
    zPrint.syncPlugins( ply )
    zPrint.syncPrinters( ply )

    if SG && ply:IsSuperAdmin() then
        net.Start( "SG.SendGroups" )
            net.WriteTable( SG.Save.CurrentGroups )
        net.Send( ply )
    end
end )

function zPrint.createFolders()
    file.CreateDir( "zprint/settings/ " )
    file.CreateDir( "zprint/printers/" )
end

zPrint.createFolders()