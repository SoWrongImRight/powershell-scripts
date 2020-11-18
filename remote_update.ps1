$target = read-host -Prompt 'Input target name'
if ($target) {
    Write-Host "Checking if $target is online."
    if($?){
        Test-NetConnection -ComputerName $target
    }
    else {
        Write-Host "$target appears to be offline."   
    }
    write-host "Check if $target is part of the domain."
    try {
        [System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain()
        Write-Host "$target is on the domain."
    }
    catch {
        Write-Host "$targate is not on the domain."
    }
    Write-Host "Activating winrm.cmd"
    if($?)
    {
        psexec \\$target -s c:\windows\system32\winrm.cmd quickconfig -quiet 2>&1> $null
        Write-Host "Winrm.cmd activated"
    }
    else
    {
        Write-Host "Winrm.cmd failed"
    }
}
else {
    Write-Host "You did not enter a target name"
    Exit
}
Write-Host "Attempting to update group policy remotely on [$target]"
if($?)
{
        Invoke-GPUpdate -Computer $target
}
else {
    Write-Host "GPUpdate failed"
}
Write-Host "Disabling Winrm.cmd"
if($?)
{
    Invoke-Command -ComputerName $target -ScriptBlock {set-service WinRM -StartupType Disabled; Stop-Service WinRM}
}
else {
    Write-Host "Unable to deactivate Remote access"
}
<#
Write-Host "Entering PSSession"
if($?)
{
    enter-pssession $target
}
else
{
    Write-Host "Enter-PSSession  Failed"
}
#>