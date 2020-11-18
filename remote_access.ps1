$target = read-host -Prompt 'Input target name'
if ($target) {
    Write-Host "Checking if $target is online."
    if($?){
        Test-NetConnection -ComputerName $target
    }
    else {
        Write-Host "$target appears to be offline."   
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
Write-Host "Esablishing remote connection"
if($?)
{
    enter-pssession $target
}
else {
    Write-Host "Remote connection failed"
    exit
}
<#write-host "Cleaning up"
if($?)
{
    Invoke-Command -ComputerName $target -ScriptBlock {set-service WinRM -startupType Disabled; stop-service WinRM}
}
else {
    Write-Host "Cleanup failed"
} #>