-- [Objects] --

local service = {}

service = {
    getDate = function()
        return os.date("%d/%m/%Y %T")
    end,

    getMonitor = function()
        service.printFancy("yellow","\nSearching for a Monitor...")

        local monitor = peripheral.find("monitor")
        local width, height = monitor.GetSize()

        if monitor then
            service.printFancy("green", "Monitor found.")
            print(string.format("Monitor Size: %sx%s", width, height))
        else
            printError("Monitor not found.")
        end

        return monitor
    end,

    getWirelessModem = function()
        service.printFancy("yellow", "\nSearching for Wireless Modem...")

        local WirelessModem = peripheral.find("modem", function(name, modem) return modem.isWireless() end)

        if WirelessModem then
            service.printFancy("green", "Wireless Modem found.")
        else
            printError("Wireless Modem not found.")
        end

        return WirelessModem
    end,

    getWiredModem = function()
        service.printFancy("yellow", "\nSearching for Wired Network...")

        local WiredModem = peripheral.find("modem", function(name, modem) return not modem.isWireless() end)

        if WiredModem then
            service.printFancy("green", "Wired Modem found.")
        else
            printError("Wired Modem not found.", 0)
        end

        return WiredModem
    end,

    getAnswer = function()
        local answer
        repeat
            answer = read()
            answer = string.lower(answer)
            if answer ~= "y" and answer ~= "n" then
                printError("Invalid answer. (y/n)")
            end
        until answer == "y" or answer == "n"
        
        return answer == "y" and true or false
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
        service.printFancy("green", string.format("\n%s loaded.", manifest.name))
        service.printFancy("green", string.format("Version: %s", manifest.version))
    end,
}

-- [Setup] --

return service