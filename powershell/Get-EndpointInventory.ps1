<##
.SYNOPSIS
    Collects a minimal Windows endpoint inventory.
.DESCRIPTION
    Reads operating system, computer system and logical disk metadata. It is
    read-only and produces no credentials or file contents.
.PARAMETER OutputPath
    Optional CSV destination.
.EXAMPLE
    .\Get-EndpointInventory.ps1 -OutputPath .\inventory.csv
.NOTES
    Windows PowerShell 5.1 or PowerShell 7. Local lab use.
    Author and project owner: Alex S Beirigo.
##>
[CmdletBinding()]
param([string]$OutputPath)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
try {
    $collectionSource = 'CIM'
    try {
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        $cs = Get-CimInstance Win32_ComputerSystem -ErrorAction Stop
        $disks = @(Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction Stop | ForEach-Object {
            [pscustomobject]@{ DeviceID=$_.DeviceID; Size=$_.Size; FreeSpace=$_.FreeSpace }
        })
        $computerName = $cs.Name
        $manufacturer = $cs.Manufacturer
        $model = $cs.Model
        $operatingSystem = $os.Caption
        $build = $os.BuildNumber
    } catch {
        $collectionSource = '.NET fallback; CIM unavailable'
        $disks = @([System.IO.DriveInfo]::GetDrives() | Where-Object { $_.DriveType -eq 'Fixed' -and $_.IsReady } | ForEach-Object {
            [pscustomobject]@{ DeviceID=$_.Name; Size=$_.TotalSize; FreeSpace=$_.AvailableFreeSpace }
        })
        $computerName = [Environment]::MachineName
        $manufacturer = 'Unavailable'
        $model = 'Unavailable'
        $operatingSystem = [Environment]::OSVersion.VersionString
        $build = [Environment]::OSVersion.Version.Build
    }
    $inventory = @($disks | ForEach-Object {
        [pscustomobject]@{
            CollectedUtc = (Get-Date).ToUniversalTime().ToString('o')
            ComputerName = $computerName
            Manufacturer = $manufacturer
            Model = $model
            OperatingSystem = $operatingSystem
            Build = $build
            Drive = $_.DeviceID
            SizeGB = [math]::Round($_.Size / 1GB, 2)
            FreeGB = [math]::Round($_.FreeSpace / 1GB, 2)
            CollectionSource = $collectionSource
        }
    })
    if ($OutputPath) {
        $parent = Split-Path -Parent $OutputPath
        if ($parent -and -not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        $inventory | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
    }
    $inventory
} catch { throw "Endpoint inventory failed: $($_.Exception.Message)" }
