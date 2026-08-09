<##
.SYNOPSIS
    Reports free space on fixed Windows disks.
.DESCRIPTION
    Read-only disk check. A drive is marked Review below the threshold.
.PARAMETER MinimumFreePercent
    Review threshold, default 15 percent.
.PARAMETER OutputPath
    Optional CSV destination.
.EXAMPLE
    .\Get-DiskSpaceReport.ps1 -MinimumFreePercent 20
.NOTES
    Author and project owner: Alex S Beirigo. Read-only controlled lab script.
##>
[CmdletBinding()]
param(
    [ValidateRange(1,99)][int]$MinimumFreePercent = 15,
    [string]$OutputPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
try {
    try {
        $drives = @(Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction Stop | ForEach-Object { [pscustomobject]@{DeviceID=$_.DeviceID;Size=$_.Size;FreeSpace=$_.FreeSpace;Source='CIM'} })
    } catch {
        $drives = @([System.IO.DriveInfo]::GetDrives() | Where-Object { $_.DriveType -eq 'Fixed' -and $_.IsReady } | ForEach-Object { [pscustomobject]@{DeviceID=$_.Name;Size=$_.TotalSize;FreeSpace=$_.AvailableFreeSpace;Source='.NET fallback'} })
    }
    $result = @($drives | ForEach-Object {
        $free = if ($_.Size -gt 0) { [math]::Round(($_.FreeSpace / $_.Size) * 100, 1) } else { 0 }
        [pscustomobject]@{ CheckedUtc=(Get-Date).ToUniversalTime().ToString('o'); Drive=$_.DeviceID; FreePercent=$free; MinimumFreePercent=$MinimumFreePercent; Result=if ($free -ge $MinimumFreePercent) {'Pass'} else {'Review'}; CollectionSource=$_.Source }
    })
    if ($OutputPath) {
        $parent = Split-Path -Parent $OutputPath
        if ($parent -and -not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        $result | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
    }
    $result
} catch { throw "Disk space report failed: $($_.Exception.Message)" }
