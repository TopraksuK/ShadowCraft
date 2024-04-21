-- [Objects] --

local service = {}

service = {
    manifest = {
        name = "ShadowCraft",
        version = "v1.0.2",
        directory = "/shadowcraft/"
    },

    install = function(args)

    end,

    getDate = function()
        return os.date("%d/%m/%Y %T")
    end,

    getWirelessModem = function()
        service.printFancy("yellow", "Searching for Wireless Modem...")

        local WirelessModem = peripheral.find("modem", function(name, modem) return modem.isWireless() end)

        if WirelessModem then
            service.printFancy("green", "Wireless Modem found.")
        else
            error("Wireless Modem not found.", 0)
        end
    end,

    getWiredModem = function()
        service.printFancy("yellow", "Searching for Wired Network...")

        local WiredModem = peripheral.find("modem", function(name, modem) return not modem.isWireless() end)

        if WiredModem then
            service.printFancy("green", "Wired Modem found.")
        else
            error("Wired Modem not found.", 0)
        end
    end,

    getAnswer = function()
        local answer
        repeat
            answer = read()
            answer = string.lower(answer)
            if answer ~= "y" and answer ~= "n" then
                error("Invalid answer. (y/n)", 0)
            end
        until answer == "y" or answer == "n"
        
        return answer    
    end,

    checkInstallation = function(dir)
        if fs.exists(dir) then
            print("Installation directory exists.")
        else
            print("Installation directory does not exists.")
        end
    end,

    printFancy = function(color, string)
        term.setTextColor(colors[color])
        print(string)
        term.setTextColor(colors.white)
    end,

    printData = function(data, nest)
        nest = nest == nil and 0 or nest

        if type(data) == "table" then
            for name, subData in pairs(data) do
                local tab = ""
                for i = 1, nest do
                    tab = tab .. "\t"
                end

                print(string.format("%s%s : %s", tab, name, subData))

                if type(subData) == "table" then
                    nest = nest + 1
                    service.printData(subData, nest)
                end
            end
        end
    end,

    printManifest = function(manifest)
        service.printFancy("green", string.format("%s loaded.", manifest.name))
        service.printFancy("green", string.format("Version: %s", manifest.version))
    end,
}

-- [Setup] --

service.printManifest(service.manifest)

return service