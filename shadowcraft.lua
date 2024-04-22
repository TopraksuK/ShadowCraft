-- [Objects] --

local service = {}

service = {
    install = function(url)
        local manifestContentRequest = http.get(url .. "manifest.lua")
        local manifestContent = manifestContentRequest.readAll()
        manifestContentRequest.close()

        if not manifestContent then
            printError("Could not connect to the URL website and fetch manifest.")
            return nil
        end

        fs.makeDir("/tempInstall/")

        local tempManifestFile = fs.open("/tempInstall/manifest.lua", "w")
        tempManifestFile.write(manifestContent)
        tempManifestFile.close()

        local tempManifest = require("/tempInstall/manifest")

        local installationDirectory = tempManifest.directory

        if fs.exists(installationDirectory) then
            local installedManifest = require(installationDirectory .. "manifest")

            if tempManifest.version == installedManifest.version then
                print(string.format("\n%s is installed and up to date.", installedManifest.name))
                fs.delete("/tempInstall/")
                return true
            else
                print(string.format("\nA new release for %s is found.\nVersion: %s > %s\nWould you like to install it? (y/n)", installedManifest.name, installedManifest.version, tempManifest.version))
                local answer = service.getAnswer()

                if not answer then
                    fs.delete("/tempInstall/")
                    return true
                end

                fs.delete(tempManifest.directory)
            end
        else
            print(string.format("\n%s is going to be installed.\nVersion: %s\nWould you like to install it? (y/n)", tempManifest.name, tempManifest.version))
            local answer = service.getAnswer()

            if not answer then
                fs.delete("/tempInstall/")
                return true
            end
        end
        
        fs.delete(installationDirectory)

        for i, content in pairs(tempManifest.files) do
            local download = http.get(url .. content[1]).readAll()
            local installation = fs.open(tempManifest.directory .. content[2] .. content[1], "w")
            installation.write(download)
            installation.close()
        end

        fs.delete("/tempInstall/")

        service.printFancy("green",string.format("\n%s %s successfully installed.", tempManifest.name, tempManifest.version))
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

if fs.getDir(shell.getRunningProgram()) ~= "/lib/shadowcraft/manifest" then
    service.install("https://github.com/TopraksuK/shadowcraft/releases/latest/download/")
end

if fs.exists("/lib/shadowcraft/manifest.lua") then
    service.printManifest(require("/lib/shadowcraft/manifest"))
end

return service