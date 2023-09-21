$input = [System.Convert]::toDouble($args[0])
$ret = $input / 1073741824.0 
Write-Host ($ret) -NoNewline
Write-Host " GB"