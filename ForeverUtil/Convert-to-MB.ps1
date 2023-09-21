$input = [System.Convert]::toDouble($args[0])
$ret = $input / 1048576.0 
Write-Host ($ret) -NoNewline
Write-Host " MB"