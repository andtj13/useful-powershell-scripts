function Start-LoggingTime {
    
    $StartTime = Get-Date
    
    # Store the task name and start time in a global variable
    $global:LoggedTime = New-Object PSObject -Property @{
        TaskName = $TaskName
        StartTime = $StartTime
		Category = $Category
    }
}

function Stop-LoggingTime {
    if (-not $global:LoggedTime) {
        Write-Error "No task is currently being tracked."
        return
    }
    
    $EndTime = Get-Date
    $Duration = New-TimeSpan -Start $global:LoggedTime.StartTime -End $EndTime
	$Minutes = [math]::Round($Duration.TotalMinutes, 2)
	$Date = $global:LoggedTime.StartTime.ToString("dd-MM-yyyy")
    
    $Record = New-Object PSObject -Property @{
        Category = $global:LoggedTime.Category
        TaskName = $global:LoggedTime.TaskName
        StartTime = $global:LoggedTime.StartTime
        Endtime = $EndTime
        Duration = $Duration
		Minutes = $Minutes
		Date = $Date
    }
    
    $Record | Export-Csv -Path "Work Log.csv" -Append -NoTypeInformation
	
	Write-Host $TaskName, $Duration
    
    # Clear the global variable
    $global:LoggedTime = $null
}

$Category = Read-Host "Enter the category"
$TaskName = Read-Host "Enter the task name"

Start-LoggingTime -TaskName $TaskName

Write-Host "-> Press enter to stop logging time for work activity"
Read-Host

Stop-LoggingTime
