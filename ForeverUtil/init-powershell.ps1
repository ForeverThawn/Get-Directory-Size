$buffer_path = [Environment]::GetEnvironmentVariable("Path", "User")
$modified_path = $new_path + ";" + $args
$buffer_path = [Environment]::SetEnvironmentVariable("Path", $modified_path, "User")
Write-Host "System Environment Variable Modified" -ForegroundColor Green