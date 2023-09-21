$input = [System.Convert]::toDouble($args[0])
$ret = $input / 1099511627776.0 
Write-Host ($ret) -NoNewline
Write-Host " TB"