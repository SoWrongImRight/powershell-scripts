# A script to check if a specified user belongs to a list of Active Directory Groups provided by the user.

# Get the username and then grab the ADUser object
$username = read-host -Prompt "Please enter the username you will be checking for group memebership"
$user = Get-ADuser $username
# Write-Host $user.SamAccountName - this was just for testing

# Create the array to be filled in with the names of the AD Groups.
[String[]] $_GroupList = @()
$_GroupList = Read-Host -Prompt "Enter the AD Groups to check, in quotes, separated by commas"
$_GroupList = $_GroupList.Split(',')
$_GroupList = $_GroupList.Trim('"')

# Check each AD Group's memeber to see if the user is in it and then output the results.
foreach ($group in $_GroupList) { $members = Get-ADGroupMember $group -Recursive | select -ExpandProperty Name;
    if ($members -notcontains $user.SamAccountName) {
        write-host "not in group $group"} else {
            Write-Host "user is in group $group"
        } }