$input = [System.Convert]::toInt64($args[0])
$ret = '{0:X}' -f $input
Write-Host $ret