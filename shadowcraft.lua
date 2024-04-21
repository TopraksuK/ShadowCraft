-- [Objects] --

local service = {}

service = {
    manifest = {
        name = "ShadowCraft",
        fileName = "shadowcraft.lua",
        version = "v1.1.0",
        directory = "/lib/"
    },

    install = function(url, dir)
        local tempFolder = fs.makeDir("/tempInstall/")

        local content = http.get(url).readAll()

        if not content then
            printError("Could not connect to the URL website.")
            return nil
        end

        local file = fs.open("/tempInstall/temp.lua", "w")
        file.write(content)
        file.close()

        local fileManifest = require(file).manifest

        local installed = fs.exists(dir)

        if installed then
            local installedManifest = require(dir).manifest

            if installedManifest.version == fileManifest.version then
                print(string.format("%s is installed and up to date.", installedManifest.Name))
                return true
            else
                print(string.format("A new release for %s is found.\nVersion: %s>%s\nWould you like to install it? (y/n)", installedManifest.Name, installedManifest.version, fileManifest.version))
                local answer = service.getAnswer()

                if not answer then
                    return true
                end
            end
        else
            print(string.format("%s is going to be installed.\nVersion: %s\nWould you like to install it? (y/n)", fileManifest.Name, fileManifest.version))
            local answer = service.getAnswer()

            if not answer then
                return true
            end
        end
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
            printError("Wireless Modem not found.")
        end
    end,

    getWiredModem = function()
        service.printFancy("yellow", "Searching for Wired Network...")

        local WiredModem = peripheral.find("modem", function(name, modem) return not modem.isWireless() end)

        if WiredModem then
            service.printFancy("green", "Wired Modem found.")
        else
            printError("Wired Modem not found.", 0)
        end
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

    checkInstallation = function(dir)
        if fs.exists(dir) then
            print("Installation directory exists.")
            return true
        else
            print("Installation directory does not exists.")
            return false
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
        service.printFancy("green", string.format("\n%s loaded.", manifest.name))
        service.printFancy("green", string.format("Version: %s", manifest.version))
    end,
}

-- [Setup] --

service.printManifest(service.manifest)
service.install("https://github.com/TopraksuK/shadowcraft/releases/latest/download/shadowcraft.lua", service.manifest.directory .. service.manifest.fileName)

return service