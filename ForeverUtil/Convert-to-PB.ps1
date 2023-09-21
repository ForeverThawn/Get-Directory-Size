$input = [System.Convert]::toDouble($args[0])
$ret = $input / 1125899906842624.0 
Write-Host ($ret) -NoNewline
Write-Host " PB"