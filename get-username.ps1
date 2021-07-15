# Initial setup


    $source = $null
    $Path = "C:\Temp\"

    # Get the inputer file information with input checking
    $source = Read-Host "Enter Excel file path and name"
    if (!$source) {
        write-host "No entry provided."
        Break 
    }
    if (-not(Test-Path $source)){
        Write-Host "Invalide file or path."
        $source=$null
        Break 
    }
    elseif ((get-item $source).psiscontainer) {
        Write-Host "Source must be a file."    
        $source = $null
        Break 
    }
    Write-Host "Passed error check."

    # Get the output file name and check if the file already exist
    $OutputFile = Read-Host "Enter the name of  the output file that will be in the $Path folder"
    Write-Host $source
    $OutputFileComplete = $Path+$OutputFile
    if (Test-Path -Path $OutputFileComplete) {
        write-host "File already exists."
        Break
        <# $FileExist = read-host "File already exists. Enter 'yes' to proceed (will overwrite existing file)"
         if ($FileExist -eq 'yes') { Continue }
        else { Break } #>
    }
    else {
        try {
            New-Item -ItemType "file" -Path $OutputFileComplete    
        }
        catch {
            Write-Host "An error creating the file has occurred."
            Break 
        }
        
    }

    # Extract the first and last name and run through Get-Aduser to get the username
    $NameList = Import-Excel $source
    foreach ($user in $NameList) {
        Write-Host $user
        $fname = $user.names.split(" ")[0]
        $lname = $user.names.split(" ")[1]
        $UserName = Get-ADuser -filter {GivenName -eq $fname -and Surname -eq $lname} | Select-Object -First 1
        Write-Host $UserName.name
        $NewLine = "{0}" -f $UserName.Name
        $NewLine | Add-Content -Path $OutputFileComplete
        # $UserNameList.Add($UserName.Name)
    }
