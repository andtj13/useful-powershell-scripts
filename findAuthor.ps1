# Edit the variable to search different directories.
$directory = "C:\"

$shell = New-Object -ComObject Shell.Application
$folder = $shell.Namespace($directory)

Write-Host "File Name" -ForegroundColor Cyan
Write-Host "Author" -ForegroundColor Cyan
Write-Host "----------------------------------"

foreach ($item in $folder.Items()) {
	if (-Not $item.IsFolder) {
		$fileName = $item.Name
		Write-Host "${fileName}" -ForegroundColor Cyan
		for ($i = 0; $i -lt 266; $i++) {
			$propertyName = $folder.GetDetailsOf($null, $i)
			$propertyValue = $folder.GetDetailsOf($item, $i)
			
			Write-Host "${propertyName}: ${propertyValue}"
		}
	}
}
