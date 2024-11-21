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

function Is-ScreenLocked {
    $locked = Get-Process -Name LogonUI -ErrorAction SilentlyContinue
    return $locked -ne $null
}

function Run-Worklog {
	$Category = Read-Host "Enter the category"
	$TaskName = Read-Host "Enter the task name"

	Start-LoggingTime -TaskName $TaskName

	Write-Host "-> Press Enter to stop logging time for work activity"
	
	# if screen is locked, end task logging; otherwise end task logging if Enter is pressed.
	while ($true) {
    if (Is-ScreenLocked) {
		Write-Output "The screen is locked.  Ending task and logging."
		Stop-LoggingTime
		break
	} elseif ([console]::KeyAvailable -and [console]::ReadKey($true).Key -eq [consolekey]::Enter) {
		Stop-LoggingTime
		break
	}
	Start-Sleep -Seconds 1
	}
}

Run-Worklog
