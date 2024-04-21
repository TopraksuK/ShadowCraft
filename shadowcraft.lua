local service = {}

service = {
    manifest = {
        name = "ShadowCraft",
        version = "v1.0.0",
    },

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

    printManifest = function()
        service.printFancy("green", "ShadowCraft loaded.")
        service.printFancy("green", string.format("Version: %s", service.manifest.version))
    end,
}

return service