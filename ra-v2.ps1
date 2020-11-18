$target=read-host -Prompt "Input target name"
if ($target){
    write-host "Checking if $target is online."
    if(!(test-netconnection -ComputerName $target)){
        Write-Host "$target is not online."
    }
    else {
        write-host "Verify WinRM is enabled on $target."
        $WinRMStatus = Get-Service -ComputerName $target -Name WinRM
        if ($WinRMStatus.status -ne 'Running'){
            write-host "Enabling WinRM service on $target."
            psexec \\$target -s c:\windows\system32\winrm.cmd quickconfig -quiet 2>&1> $null
        }
    }
    if(!(Invoke-Command -ComputerName $target -ScriptBlock {Test-ComputerSecureChannel})){
        Write-Host "$target is not part of the domain. Attempting to repair"
        try {
            Invoke-Command -ComputerName $target -ScriptBlock {Test-ComputerSecureChannel}
        }
        catch {
            Write-Host "Unable to repair trust relationship with $target."
        }
    }
    else {
        write-host "Running GPUpdate on $target."
        try{
            Invoke-GPUpdate -Computer $target -Force 
        }
        catch{
            Write-Host "GPUpdate failed on $target."
        }
    }
    Write-Host "Cleaning up and exiting.  Process will exit due to failure, this is not a bug it is a feature."
    Invoke-Command -ComputerName $target -ScriptBlock {Set-Service WinRM -StartupType Disabled;Stop-Service WinRM}
}