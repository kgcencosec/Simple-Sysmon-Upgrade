<#
simple-sysmon-upgrade.ps1
by Kyle Gustafson, Cencosec Security Consulting
This is a simple script to check which version of Sysmon is installed and if it is not the desired one, upgrade it (or really uninstall the one you don't want and install the one you do want).  
This works by checking a SHA-256 hash of the File and comparing it to the desired version. When you want to deploy a new version, get the file hash of the new version, and update the parameters accordingly.
This is a simple upgrade script and as such just uses hashes to determine if an upgrade (really a re-install) to the desired version is needed. It could also downgrade using the same logic. If this is not what you are looking for or you do not like this approach, then I encourage you to check out jokezone's Update Sysmon script here: https://github.com/jokezone/Update-Sysmon. I just wanted to get the job done in as reliable of a quick method as I could, and this was the result.
#>

###Variables###
#Set these according to your needs.

#Desired Sysmon File Hash, set this to the SHA256 hash of the Sysmon.exe that you need to install. The hash below is for the 64bit version of Sysmon 11.0 (I removed the 64 to work with some other scripts I use, you could easily add it back if needed.)
$desiredSysmonFileHash = '4B4FBC90DC093DB04DC55D1AE00A243459A335178D2D5ECD92508E8DA2D7DFDA'

#Current Sysmon Service Name
$sysmonService = 'sysmon'

#Specify the directory the Sysmon.exe file is located in.
$sysmonInstallerDir = 'C:\Path\to\installer'

#Specify the path to the desired. If you do not have one, check out this one from SwiftOnSecurity: https://github.com/SwiftOnSecurity/sysmon-config.
$sysmonConfig = 'C:\Path\to\config.file'

#Check if Sysmon is currently installed. Necessary for logic to work properly and if it is not installed, it will install because why else would you be running this?
If(!(Get-Service $sysmonService -ErrorAction SilentlyContinue)){
    Write-Host "Sysmon is not installed."
    Set-Location $sysmonInstallerDir
    Sysmon.exe /accepteula -i C:\winlog\conf\sysmonconfig.xml
    If(!(Get-Service $sysmonService -ErrorAction SilentlyContinue)){
        Write-Host "An error occurred during isntallation. Please investigate"
    }
    Else{
        Write-Host "Sysmon installed successfully."
    }
}

#Sysmon has been found, handle accordingly.
Else{
    Write-Host "Sysmon is installed."
    $currentSysmon = 'C:\Windows\Sysmon.exe' #if you do not install windows on the C drive, you will need to change this accordingly.
    $currentFileHash = Get-FileHash -Algorithm SHA256 $currentSysmon

    If ($currentFileHash.Hash -ne $desiredSysmonFileHash){
        Write-Host "Sysmon upgrade needed. Upgrading now."
        Stop-Service $sysmonService
        Set-Location 'C:\Windows' #if you do not install windows on the C drive, you will need to change this accordingly.
        Sysmon.exe -u force
        Set-Location $sysmonInstallerDir
        Sysmon.exe /accepteula -i $sysmonConfig
        If (Get-Service $sysmonService){
            Write-Host "Sysmon upgraded successfully."
        }
        Else{
            Write-Host "An error has occured during installation. Please investigate."
        }
    }
    Else {
        Write-Host "No upgrade needed."
    }
}