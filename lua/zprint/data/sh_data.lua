-- Data File

function zPrint.addLanguage( cfg, variable, translation )
    zPrint.Language[ cfg ] = zPrint.Language[ cfg ] || {}
    zPrint.Language[ cfg ][ variable ] = translation
end

if SERVER then
    timer.Simple( 1 , function()
        local cfg = {}
        cfg.adminMode = ""
        zPrint:registerPlugin( "Other", cfg )

        local attchs = {}
        attchs.Speed = true
        attchs.Antenna = true
        attchs.Cooler = true
        attchs.Armour = true
        attchs.CPU = false
        attchs.Security = true
        attchs.Sound = false
        zPrint:registerPlugin( "Attachment", attchs )

        local tab = {}
        tab.Sound = true
        tab.Command = "zprinter"
        zPrint:registerPlugin( "Tab", tab )

        local settings = {}
        settings.adminNotify = true
        settings.displayBorders = true
        settings.showSparks = true
        settings.pickupNotification = true
        settings.pickupNote = "You've collected $%i"
        settings.waterDestroy = true
        settings.cpNotification = true
        settings.ownerNote = "Your printer has been found, be careful!"
        settings.destroyNotify = true
        settings.destroyMsg = "Your printer has exploded!"
        settings.overheatMsg = true
        settings.overheatM = "Your printer is overheating!"
        settings.Collisions = true
        settings.setwantedwhenfound = true
        settings.notifyOwner = true
        settings.secureMsg = "%s is trying to steal your money"
        settings.stealerMsg = "The printer is secured, you can destroy the protection in order to retrieve the money"
        zPrint:registerPlugin( "General", settings )

        local p = {}
        p.name = "Printers Name"
        p.health = 100
        p.amount = 10
        p.time = 10
        p.maxhold = 10
        p.f4order = 10
        p.sound = ""
        p.category = ""
        p.removalreward = 10
        p.secondarygroup = 10
        p.overheatchance = 10
        p.color = 10
        p.level = 10
        p.f4price = 1000
        p.f4amount = 1
        zPrint:registerPlugin( "PrinterSettings", p )

        local printers = {}
        zPrint:registerPlugin( "Printers", printers )
    end )
else
    zPrint.addLanguage( "Other", "adminMode", "Select the admin mode you will use zPrint configurations." )
    zPrint.addLanguage( "General", "adminNotify", "Notify the owner about the command when he/she initial spawns." )
	zPrint.addLanguage( "General", "displayBorders", "Display printers custom borders?" )
	zPrint.addLanguage( "General", "showSparks", "Show printers sparks while printing?" )
	zPrint.addLanguage( "General", "pickupNotification", "Enable money withdrawal notification?" )
	zPrint.addLanguage( "General", "pickupNote", "Printer withdrawal notification." )
	zPrint.addLanguage( "General", "waterDestroy", "Destroy printers under water?" )
    zPrint.addLanguage( "General", "cpNotification", "Enable notification when found by police?" )
	zPrint.addLanguage( "General", "ownerNote", "Printer owner message when found." )
	zPrint.addLanguage( "General", "Collisions", "Disable printer collisions with humans?" )
	zPrint.addLanguage( "General", "destroyNotify", "Notify when the printer is destroyed?" )
	zPrint.addLanguage( "General", "destroyMsg", "Notification when the printer is destroyed." )
	zPrint.addLanguage( "General", "setwantedwhenfound", "Set the owner of the printer wanted when the printer is found." )
	zPrint.addLanguage( "General", "notifyOwner", "Notify the owner when someone's try to steal money." )
	zPrint.addLanguage( "General", "secureMsg", "Printer's message when it's secured." )
	zPrint.addLanguage( "General", "stealerMsg", "Message to the stealer if printer is secured." )
	zPrint.addLanguage( "General", "overheatMsg", "Notify if the printer is overheating?" )
    zPrint.addLanguage( "General", "overheatM", "Overheat message." )
    
    zPrint.addLanguage( "PrinterSettings", "name", "Printers Name" )
    zPrint.addLanguage( "PrinterSettings", "health", "Printers Health" )
    zPrint.addLanguage( "PrinterSettings", "amount", "Printers Print Amount" )
    zPrint.addLanguage( "PrinterSettings", "time", "Printer Printing Time" )
    zPrint.addLanguage( "PrinterSettings", "maxhold", "Printers Max Amount Of Money" )
    zPrint.addLanguage( "PrinterSettings", "f4order", "Printers F4 Order" )
    zPrint.addLanguage( "PrinterSettings", "sound", "Printers Sound" )
    zPrint.addLanguage( "PrinterSettings", "category", "Printers Category" )
    zPrint.addLanguage( "PrinterSettings", "removalreward", "Printers Removal Reward ( 0 to disable )" )
    zPrint.addLanguage( "PrinterSettings", "secondarygroup", "Printers Secondary Usergroup ( Donation System )" )
    zPrint.addLanguage( "PrinterSettings", "overheatchance", "Printers Overheat Chance ( 0 to disable )" )
    zPrint.addLanguage( "PrinterSettings", "color", "Printers Color" )
    zPrint.addLanguage( "PrinterSettings", "level", "Printers Level ( 0 to disable )" )
    zPrint.addLanguage( "PrinterSettings", "f4price", "Printers F4 Price" )
    zPrint.addLanguage( "PrinterSettings", "f4amount", "Printers F4 Amount" )
end