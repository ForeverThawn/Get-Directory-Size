$path = [Environment]::GetEnvironmentVariable("Path", "User")
$new_path = $args + ";" + $path
$path = [Environment]::SetEnvironmentVariable("Path", $new_path, "User")
Write-Host "System Environment Variable Modified" -ForegroundColor Green