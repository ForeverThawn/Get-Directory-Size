#Import-Module C:\psScript\config\top_general\gsudo\gsudoModule
CLS
CMD /c "subst /D X:"
CMD /c "subst X: %HOMEDRIVE%\ForeverUtil\Temp"

$global:e = 2.7182818284590452353602874713527
$global:pi = 3.1415926535897932384626433832795
$global:forever = $env:HOMEDRIVE + '\ForeverUtil'

Function global:Calendar {
param(
    [DateTime] $start = [DateTime]::Today,
    [DateTime] $end = $start,
    $firstDayOfWeek,
    [int[]] $highlightDay,
    [string[]] $highlightDate = [DateTime]::Today.ToString('yyyy-MM-dd')
    )

## Determine the first day of the start and end months.
$start = New-Object DateTime $start.Year,$start.Month,1
$end = New-Object DateTime $end.Year,$end.Month,1

## Convert the highlighted dates into real dates.
[DateTime[]] $highlightDate = [DateTime[]] $highlightDate

## Retrieve the DateTimeFormat information so that the
## calendar can be manipulated.
$dateTimeFormat  = (Get-Culture).DateTimeFormat
if($firstDayOfWeek)
{
    $dateTimeFormat.FirstDayOfWeek = $firstDayOfWeek
}

$currentDay = $start

## Process the requested months.
while($start -le $end)
{
    ## Return to an earlier point in the function if the first day of the month
    ## is in the middle of the week.
    while($currentDay.DayOfWeek -ne $dateTimeFormat.FirstDayOfWeek)
    {
        $currentDay = $currentDay.AddDays(-1)
    }

    ## Prepare to store information about this date range.
    $currentWeek = New-Object PsObject
    $dayNames = @()
    $weeks = @()

    ## Continue processing dates until the function reaches the end of the month.
    ## The function continues until the week is completed with
    ## days from the next month.
    while(($currentDay -lt $start.AddMonths(1)) -or
        ($currentDay.DayOfWeek -ne $dateTimeFormat.FirstDayOfWeek))
    {
        ## Determine the day names to use to label the columns.
        $dayName = "{0:ddd}" -f $currentDay
        if($dayNames -notcontains $dayName)
        {
            $dayNames += $dayName
        }

        ## Pad the day number for display, highlighting if necessary.
        $displayDay = " {0,2} " -f $currentDay.Day

        ## Determine whether to highlight a specific date.
        if($highlightDate)
        {
            $compareDate = New-Object DateTime $currentDay.Year,
                $currentDay.Month,$currentDay.Day
            if($highlightDate -contains $compareDate)
            {
                $displayDay = "*" + ("{0,2}" -f $currentDay.Day) + "*"
            }
        }

        ## Otherwise, highlight as part of a date range.
        if($highlightDay -and ($highlightDay[0] -eq $currentDay.Day))
        {
            $displayDay = "[" + ("{0,2}" -f $currentDay.Day) + "]"
            $null,$highlightDay = $highlightDay
        }

        ## Add the day of the week and the day of the month as note properties.
        $currentWeek | Add-Member NoteProperty $dayName $displayDay

        ## Move to the next day of the month.
        $currentDay = $currentDay.AddDays(1)

        ## If the function reaches the next week, store the current week
        ## in the week list and continue.
        if($currentDay.DayOfWeek -eq $dateTimeFormat.FirstDayOfWeek)
        {
            $weeks += $currentWeek
            $currentWeek = New-Object PsObject
        }
    }

    ## Format the weeks as a table.
    $calendar = $weeks | Format-Table $dayNames -AutoSize | Out-String

    ## Add a centered header.
    $width = ($calendar.Split("`n") | Measure-Object -Maximum Length).Maximum
    $header = "{0:MMMM yyyy}" -f $start
    $padding = " " * (($width - $header.Length) / 2)
    $displayCalendar = " `n" + $padding + $header + "`n " + $calendar
    $displayCalendar.TrimEnd()

    ## Move to the next month.
    $start = $start.AddMonths(1)

}
}

function global:sqrt($sqrt_input)
{
    $sqrt_input = [int]::Parse($sqrt_input)
    return [math]::Sqrt($sqrt_input)
}
function global:To-Shutdown($timer)
{
    $timer = [int]::Parse($timer)
    shutdown /s /t $timer
}

Function global:fcopy{
    <#
    .SYNOPSIS
    Get hash from file(s)

    .DESCRIPTION
    Action:      'new' as default
        new     :  Copy file(s) (Remain file with same name uncopied)
        diff    :  Copy file(s) different from SIZE or DATE (Remain file with same name uncopied)
        update  :  Copy file(s) and cover the same-name file(s) with the newer one
        sync    :  Sync file(s) different from SIZE or DATE (Remain file with same name uncopied)
        force   :  Copy file(s) from source to destination completely

    Examples:
        > fcopy -Source "C:\abc" -Destination "D:\qwe" -Action diff
        > fcopy C:\abc D:\qwe diff

    .PARAMETER Source
    Source file or directory

    .PARAMETER Destination
    Destination directory

    .EXAMPLE

    > fcopy -Source "C:\abc" -Destination "D:\qwe"
    > fcopy C:\abc D:\qwe 

    #>
param(
    [string] $Source,
    [string] $Destination,
    [string] $Action = "new",
    [switch] $LowIO
    #[switch] $HideProcedure,
    #[switch] $NoConfirm
)
    if ($LowIO) {
        switch ($Action) {
            "new" { fcopy-binary.exe /cmd=noexist_only $Source /to=$Destination /low_io=TRUE }
            "diff" { fcopy-binary.exe /cmd=diff $Source /to=$Destination /low_io=TRUE }
            "update" { fcopy-binary.exe /cmd=update $Source /to=$Destination /low_io=TRUE }
            "force" { fcopy-binary.exe /cmd=force_copy $Source /to=$Destination /low_io=TRUE }
            "sync" { fcopy-binary.exe /cmd=sync $Source /to=$Destination /low_io=TRUE }
        }
    }
    else {
        switch ($Action) {
            "new" { fcopy-binary.exe /cmd=noexist_only $Source /to=$Destination }
            "diff" { fcopy-binary.exe /cmd=diff $Source /to=$Destination }
            "update" { fcopy-binary.exe /cmd=update $Source /to=$Destination }
            "force" { fcopy-binary.exe /cmd=force_copy $Source /to=$Destination }
            "sync" { fcopy-binary.exe /cmd=sync $Source /to=$Destination }
        }
    }
}

Function global:fmove{
    <#
    .SYNOPSIS
    Move file(s)

    .DESCRIPTION
    Action:      'move' as default
        move      :  Move file(s) (Remain file with same name unmoved)
        overwrite :  Move file(s) (Overwrite each files)

    Examples:
        > fmove -Source "C:\abc" -Destination "D:\qwe" -Action move
        > fmove C:\abc D:\qwe overwrite

    .PARAMETER Source
    Source file or directory

    .PARAMETER Destination
    Destination directory

    .EXAMPLE

    > fmove -Source "C:\abc" -Destination "D:\qwe" -Action move
    > fmove C:\abc D:\qwe overwrite

    #>
param(
    [string] $Source,
    [string] $Destination,
    [string] $Action = "move"
    #[switch] $HideProcedure,
    #[switch] $NoConfirm
)
    switch ($Action) {
        "move" { fcopy-binary.exe /cmd=move_noexist $Source /to=$Destination }
        "overwrite" { fcopy-binary.exe /cmd=move $Source /to=$Destination }
    }
}

Function global:Get-Hash {
    <#
    .SYNOPSIS
    Get hash from file(s)

    .DESCRIPTION
    Type :  xxh / xxh3 / md5 / sha1 / sha256 / sha512

    Examples:
        > Get-Hash -Type sha256 -Source "C:\"
        > Get-Hash sha256 .

    .PARAMETER Type
    xxh / xxh3 / md5 / sha1 / sha256 / sha512

    .PARAMETER Source
    Source file or directory

    .EXAMPLE

    > Get-Hash -Type sha256 -Source "C:\"
    > Get-Hash sha256 .

    #>
param(
    [string] $Type,
    [string] $Source,
    [switch] $IgnoreErrors
)
    if ($IgnoreErrors) {
        switch ($Type) {
            "xxh"  {hash.exe --xxh $Source --non_stop}
            "xxh3" {hash.exe --xxh3 $Source --non_stop}
            "md5" {hash.exe --md5 $Source --non_stop}
            "sha1" {hash.exe --sha1 $Source --non_stop}
            "sha256" {hash.exe --sha256 $Source --non_stop}
            "sha512" {hash.exe --sha512 $Source --non_stop}
        }
    }
    else {
        switch ($Type) {
            "xxh"  {hash.exe --xxh $Source }
            "xxh3" {hash.exe --xxh3 $Source}
            "md5" {hash.exe --md5 $Source}
            "sha1" {hash.exe --sha1 $Source}
            "sha256" {hash.exe --sha256 $Source}
            "sha512" {hash.exe --sha512 $Source}
        }
    }
}

Function global:Return-Format-Size-Assist {
param(
$byte_size
) 
    if ($byte_size -lt 1024) {
        return ('    {0}  B ' -f [double]$byte_size)
    }
    elseif (($byte_size -lt 0x100000) -and ($byte_size -gt 1024)) { 
        $byte_size /= 0x400  # KB
        return ('    {0:n2} KB ' -f $byte_size)
    }
    elseif (($byte_size -gt 0x100000) -and ($byte_size -lt 0x40000000)) {
        $byte_size /= 0x100000  # MB
        return ('    {0:n2} MB ' -f $byte_size)
    }
    elseif (($byte_size -gt 0x40000000) -and ($byte_size -lt 0x10000000000)) {
        $byte_size /= 0x40000000  # GB
        return ('    {0:n2} GB ' -f $byte_size)
    }
    elseif (($byte_size -gt 0x10000000000) -and ($byte_size -lt 0x3FFFFFFFFFFFC)) {
        $byte_size /= 0x10000000000  # TB
        return ('    {0:n2} TB ' -f $byte_size)
    }
    elseif (($byte_size -gt 0x3FFFFFFFFFFFC) -and ($byte_size -lt 0x1000000000000000)) {
        $byte_size /= 0x3FFFFFFFFFFFC  # PB
        return ('    {0:n2} PB ' -f $byte_size)
    }
}

Function global:Get-ChildItem-Details {
param(
[string] $dir_path
)

if ($dir_path -eq "") {
    $dir_path = Get-Location
}
    
Write-Host ""
Write-Host ("Directory  ") -NoNewline
Write-Host $dir_path -NoNewline -ForegroundColor DarkYellow
Write-Host (" >>")

$global:sum_length = 0

Get-ChildItem $dir_path |
Format-Table -Wrap -AutoSize -Property Mode, LastWriteTime,
   @{ Label = "Length"; alignment = "Right";
        Expression = {
                    if($_.PSIsContainer -eq $True) {
                        $dir_byte_size = (New-Object -com  Scripting.FileSystemObject).GetFolder( $_.FullName).Size
                        $global:sum_length += $dir_byte_size
                        Return-Format-Size-Assist($dir_byte_size)
                    }  
                    else {
                        $file_size = $_.Length
                        $global:sum_length += $file_size
                        Return-Format-Size-Assist($file_size)
                    }
        }
    }, Name;
    
$global:sum_length = Return-Format-Size-Assist($global:sum_length)
Write-Host "File(s) in total :" -NoNewline 
Write-Host $global:sum_length -ForegroundColor DarkYellow
$global:sum_length = 0
}

Function global:Add-PathEnvironmentVariable {
param ([string] $new_path)
    $buffer_path = [Environment]::GetEnvironmentVariable("Path", "User")
    $modified_path = $new_path + ";" + $buffer_path
    $buffer_path = [Environment]::SetEnvironmentVariable("Path", $modified_path, "User")
    Write-Host "System Environment Variable Modified" -ForegroundColor Green
}

Function global:Destruct-Portable-Settings {
param (
)

Remove-Item $forever -Recurse

}

Function global:Shut-Down-Immediately {
param (
)

terminator.exe -e off
}

Function global:Install-Module-From-Portable-Package {
    <#
    .SYNOPSIS
    Install Module from available portable packages

    .DESCRIPTION
    Examples:
        > install wechat
        > Install-Module-From-Portable-Package wechat

    .EXAMPLE

    > install wechat
    > Install-Module-From-Portable-Package wechat

    #>
param(
    [string] $packageName
)
    $packageFile = $forever + '\Module\' + $packageName + ".dll"
    $Installation = $forever + '\Module\' + $packageName + ".ps1 install"
    $installationLocation = $forever + '\Module'
    
    $basic_dir = Get-Location
    Write-Host "Installing Portable Module..." -ForegroundColor DarkCyan
    Set-Location $installationLocation
    powershell -Command $Installation
    Write-Host "Done!" -ForegroundColor DarkCyan
    Set-Location $basic_dir
}

Function global:Uninstall-Module-From-Portable-Package {
    <#
    .SYNOPSIS
    Uninstall Module from available portable packages

    .DESCRIPTION
    Examples:
        > uninstall wechat
        > Uninstall-Module-From-Portable-Package wechat

    .EXAMPLE

    > uninstall wechat
    > Uninstall-Module-From-Portable-Package wechat

    #>
param(
    [string] $packageName
)
    $packageFile = $forever + '\Module\' + $packageName + ".dll"
    $Installation = $forever + '\Module\' + $packageName + ".ps1 uninstall"
    $installationLocation = $forever + '\Module'
    
    $basic_dir = Get-Location
    Write-Host "Uninstalling Portable Module..." -ForegroundColor DarkCyan
    powershell -Command $Installation
    Write-Host "Done!" -ForegroundColor DarkCyan
    Set-Location $basic_dir
}


Set-Alias -Name "copy" -Value "fcopy" -Option AllScope -Scope global
Set-Alias -Name "move" -Value "fmove" -Option AllScope -Scope global
Set-Alias -Name "reset" -Value "Portable-Startup.ps1" -Option AllScope -Scope global
Set-Alias -Name "to-Hex" -Value "_Convert-to-Hex.ps1" -Option AllScope -Scope global
Set-Alias -Name "to-KB" -Value "_Convert-to-KB.ps1" -Option AllScope -Scope global
Set-Alias -Name "to-MB" -Value "_Convert-to-MB.ps1" -Option AllScope -Scope global
Set-Alias -Name "to-GB" -Value "_Convert-to-GB.ps1" -Option AllScope -Scope global
Set-Alias -Name "to-TB" -Value "_Convert-to-TB.ps1" -Option AllScope -Scope global
Set-Alias -Name "to-PB" -Value "_Convert-to-PB.ps1" -Option AllScope -Scope global
Set-Alias -Name "dirs" -Value "Get-ChildItem-Details" -Option AllScope -Scope global
Set-Alias -Name "Destruct" -Value "Destruct-Portable-Settings" -Option AllScope -Scope global
Set-Alias -Name "off" -Value "Shut-Down-Immediately" -Option AllScope -Scope global
Set-Alias -Name "install" -Value "Install-Module-From-Portable-Package" -Option AllScope -Scope global
Set-Alias -Name "uninstall" -Value "Uninstall-Module-From-Portable-Package" -Option AllScope -Scope global

Write-Host -ForegroundColor Black -Object (' ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('===========================================================================')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('                                                                           ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object (' ______                            _                                       ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('|  ____|                          ( )                                      ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('| |__ ___  _ __ _____   _____ _ __|/ ___                                   ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('|  __/ _ \|  __/ _ \ \ / / _ \  __| / __|                                  ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('| | | (_) | | |  __/\ V /  __/ |    \__ \                                  ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('|_|  \___/|_|  \___| \_/ \___|_|    |___/                                  ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('                                                                           ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('             _____                           _          _ _                ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('            |  __ \                         | |        | | |               ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('            | |__) |____      _____ _ __ ___| |__   ___| | |               ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('            |  ___/ _ \ \ /\ / / _ \  __/ __|  _ \ / _ \ | |               ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('            | |  | (_) \ V  V /  __/ |  \__ \ | | |  __/ | |               ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('            |_|   \___/ \_/\_/ \___|_|  |___/_| |_|\___|_|_|               ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('                                                                           ')
Write-Host -ForegroundColor Black -BackgroundColor DarkGray -Object ('===========================================================================')
Write-Host -ForegroundColor Cyan -Object ('                     Windows Powershell 5.1.19041.1237                     ')
Write-Host -ForegroundColor DarkYellow -Object ('                                                                           ')
Write-Host -ForegroundColor Red -Object ('Initiative Text Printed! Because this is the exact text! Haha!!')
Write-Host -ForegroundColor Yellow -Object ('PSVersion                      5.1.19041.1237')
Write-Host -ForegroundColor Yellow -Object ('PSEdition                      Desktop')
Write-Host -ForegroundColor Yellow -Object ('BuildVersion                   10.0.19041.1237')
Write-Host -ForegroundColor Yellow -Object ('CLRVersion                     4.0.30319.42000')
Write-Host -ForegroundColor Yellow -Object ('WSManStackVersion              3.0')
Write-Host -ForegroundColor Yellow -Object ('PSRemotingProtocolVersion      2.3')
Write-Host -ForegroundColor White -Object (" ")

Write-Host "Windows Powershell Forever Edition" -ForegroundColor DarkCyan
Write-Host 'Please run "Add-PathEnvironmentVariable $forever" to correct running environment' -ForegroundColor Yellow
Write-Host 'X drive attached as Temp folder in ' -ForegroundColor Yellow -NoNewline
Write-Host ($env:homedrive + "\ForeverUtil") -ForegroundColor Yellow
Write-Host ""
Set-Location X:\