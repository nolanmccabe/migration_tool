$migratedDataLocation = "$PSScriptRoot\MigratedData"
$usmtLocation = "$PSScriptRoot\USMT\amd64"

#Prompts for destination user
Write-Host "User State Migration Tool for RUSD Teacher Account" -ForegroundColor Yellow
Write-Host "This script will migrate all configuration files, documents, keys, and settings to a destination user" -ForegroundColor Yellow
Write-Host "`n"
$destinationUser = Read-Host -Prompt "Please enter DESTINATION username (e.g. mccabeno)"

#Asks for confirmation, no spellcheck available
Write-Host "Export RUSD\Teacher data to RUSD\'$destinationUser'?"
$scriptConfirmation = Read-Host -Prompt "Please confirm: [Y]es or [N]o"
if ($scriptConfirmation -eq 'N' -or $scriptConfirmation -eq "No" ) {
    Read-Host -Prompt "Press any key to successfully exit script"
    exit
}elseif ($scriptConfirmation -eq 'Y' -or $scriptConfirmation -eq 'Yes') {
    Write-Host "`n"
    Write-Host "Testing Path..."
    Write-Host "`n"
    #Tests if teacher profile exists in root directory
    $pathExists = Test-Path -Path "C:\Users\teacher"
    
    #If file path exists, runs scanstate and exports to MigratedData folder in script directory
    if ($pathExists -eq $true) {
        Write-Host "RUSD Teacher account exists. Migrating RUSD\Teacher data over to external device..."
        $scanStateExe = $usmtLocation + '\scanstate.exe'
        $scanStateArguments = @($migratedDataLocation,'/o','/ue:*\*','/ui:teacher',"/i:$usmtLocation\miguser.xml","/i:$usmtLocation\migapp.xml",'/c')
        Start-Process -FilePath $scanStateExe -ArgumentList $scanStateArguments -Wait -NoNewWindow
        
        #Runs loadstate
        Write-Host "Importing data from external device to RUSD\$destinationUser ..."
        $loadStateExe = $usmtLocation + '\loadstate.exe'
        $loadStateArguments = @($migratedDataLocation,"/mu:rusd\teacher:rusd\$destinationUser","/i:$usmtLocation\miguser.xml","/i:$usmtLocation\migapp.xml",'/c')
        Start-Process -FilePath $loadStateExe -ArgumentList $loadStateArguments -Wait -NoNewWindow
        Read-Host -Prompt "Transfer complete: Exiting Script. Press any key to exit"
        exit

    }else {
        Write-Host "Please make sure you are on a device that contains a RUSD Teacher account"
        Read-Host -Prompt "Source user does not exit: Exiting script. Press any key to exit"
        exit
    }
}else {
    Read-Host -Prompt "Incorrect syntax: Exiting script. Press any key to exit"
    exit
}