local Manifest = require("manifest")

local Service = {}

Service = {
    Check = function()
        if fs.exists(Manifest.Directory) then
            if fs.exists(Manifest.Directory.."manifest") == nil then 
                printError("The installation is corrupted. Would you like to reinstall? (y/n)")
                
                local Answer = Service.GetAnswer()
                if Answer == "y" then
                    fs.delete(Manifest.Directory)
                    Service.Install()
                elseif Answer == "n" then
                    print("Exiting installer.")
                    return nil
                end
            end
                
            local InstalledManifest = require(Manifest.Directory.."manifest")
    
            print(string.format("%s is already installed.\nCurrent Version: %s\n",Manifest.Name,InstalledManifest.Version))
    
            if InstalledManifest.Version ~= Manifest.Version then
                print(string.format("Therese is a newer version found for %s | %s, would you like to update? (y/n)",Manifest.Name,Manifest.Version))
                
                local Answer = Service.GetAnswer()
                if Answer == "y" then
                    fs.delete(Manifest.Directory)
                    Service.Install()
                elseif Answer == "n" then
                    print("\nUpdate declined. Sending killer UAVs to your house. Press any key to continue")
                end
            end 
            
            if fs.exists(Manifest.Directory) then
                print(string.format("Would you like to uninstall %s? (y/n)", Manifest.Name))
                
                local Answer = Service.GetAnswer()
                if Answer == "y" then
                    fs.delete(Manifest.Directory)
                    print(string.format("\n%s has been successfully uninstalled.", Manifest.Name))
                elseif Answer == "n" then
                    print("\nProgram terminated. Press any key to continue")        
                end
            end
        else
            print(string.format("Welcome to the %s installer.",Manifest.Name))
            print(string.format("\nWould you like to begin installation to %s? (y/n)",Manifest.Directory))
            
            local Answer = Service.GetAnswer()
            if Answer == "y" then
                Service.Install()
            elseif Answer == "n" then
                print("\nProgram terminated. Press any key to continue")
            end
        end
    end,
     
    Install = function()
        print(string.format("\nInstalling %s to %s",Manifest.Name,Manifest.Directory))
    
        fs.copy("/disk/",Manifest.Directory)
    
        fs.delete(Manifest.Directory.."installer.lua")
        
        print(string.format("\n%s has been sucessfully installed.\n",Manifest.Name))
    end,
    
    GetAnswer = function()
        local Answer
        repeat
            Answer = read()
            Answer = string.lower(Answer)
            if Answer ~= "y" and Answer ~= "n" then
                printError("Invalid answer. (y/n)")
            end
        until Answer == "y" or Answer == "n"
        
        return Answer    
    end
}

Service.Check()
