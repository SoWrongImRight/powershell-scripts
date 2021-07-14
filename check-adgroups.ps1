$username = read-host -Prompt "Please enter the username you will be checking for group memebership"
$user = Get-ADuser $username
Write-Host $user.SamAccountName
[String[]] $_GroupList = @()
$_GroupList = Read-Host -Prompt "Enter the AD Groups to check, in quotes, separated by commas"
$_GroupList = $_GroupList.Split(',')
$_GroupList = $_GroupList.Trim('"')

foreach ($group in $_GroupList) { $members = Get-ADGroupMember $group -Recursive | select -ExpandProperty Name;
    if ($members -notcontains $user.SamAccountName) {
        write-host "not in group $group"} else {
            Write-Host "user is in group $group"
        } }