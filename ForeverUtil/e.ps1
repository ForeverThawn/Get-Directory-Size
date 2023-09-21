if ($args -ne $None) {
    $pipeway = '"' + $args + '"'
    Write-Host -ForegroundColor DarkCyan -Object ('START-EXPLORER at "') -NoNewline
    Write-Host -ForegroundColor DarkYellow -Object ($args) -NoNewline
    Write-Host -ForegroundColor DarkCyan -Object ('"')
    Start-Process explorer.exe -ArgumentList ($pipeway)
}
else {
    $pipeway = Get-Location
    Write-Host -ForegroundColor DarkCyan -Object ('START-EXPLORER at Current Location "') -NoNewline
    Write-Host -ForegroundColor DarkMagenta -Object ($pipeway) -NoNewline
    Write-Host -ForegroundColor DarkCyan -Object ('"')
    Start-Process explorer.exe -ArgumentList ($pipeway)
}