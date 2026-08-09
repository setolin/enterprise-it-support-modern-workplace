<##
.SYNOPSIS
    Collects a minimal Windows endpoint health report.

.DESCRIPTION
    Checks operating system details, system drive free space, selected service
    states, basic network reachability and recent system error count. The script
    is read-only and does not change policy, services or network settings.

.PARAMETER ComputerName
    Computer to inspect. Defaults to the local computer.

.PARAMETER OutputPath
    Optional JSON output path. If omitted, objects are returned to the pipeline.

.PARAMETER ConnectivityTarget
    Hostname used for a basic TCP 443 reachability check.

.EXAMPLE
    .\Get-EndpointHealthReport.ps1

.EXAMPLE
    .\Get-EndpointHealthReport.ps1 -ConnectivityTarget 'www.microsoft.com' -OutputPath .\health.json

.NOTES
    Prerequisite: Windows PowerShell 5.1 or PowerShell 7. The report contains
    diagnostic metadata only. Review and redact before sharing externally.
    Author and project owner: Alex S Beirigo.
##>
[CmdletBinding()]
param(
    [string]$ComputerName = 'localhost',
    [string]$OutputPath,
    [ValidateNotNullOrEmpty()]
    [string]$ConnectivityTarget = 'www.microsoft.com'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-SafeServiceStatus {
    param([string]$Name)
    try {
        $service = Get-Service -ComputerName $ComputerName -Name $Name -ErrorAction Stop
        return [pscustomobject]@{ Name = $Name; Status = [string]$service.Status; Check = 'Pass' }
    } catch {
        return [pscustomobject]@{ Name = $Name; Status = 'Unavailable'; Check = 'Review' }
    }
}

try {
    $isLocal = $ComputerName -in @('.', 'localhost', [Environment]::MachineName)
    $osCaption = 'Unavailable'
    $buildNumber = 'Unavailable'
    $freePercent = 0
    $systemCheck = 'Unavailable'
    try {
        $os = if ($isLocal) { Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop } else { Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName -ErrorAction Stop }
        $systemDrive = $os.SystemDrive
        $disk = if ($isLocal) { Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$systemDrive'" -ErrorAction Stop } else { Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $ComputerName -Filter "DeviceID='$systemDrive'" -ErrorAction Stop }
        $freePercent = if ($disk.Size -gt 0) { [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1) } else { 0 }
        $osCaption = $os.Caption
        $buildNumber = $os.BuildNumber
        $systemCheck = 'Pass'
    } catch {
        $systemCheck = 'Unavailable'
    }
    $network = Test-NetConnection -ComputerName $ConnectivityTarget -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue
    $errorCount = 0
    $eventCheck = 'Pass'
    try {
        $eventQuery = @{ LogName = 'System'; Level = 2; StartTime = (Get-Date).AddHours(-24) }
        $errorCount = if ($isLocal) { @(Get-WinEvent -FilterHashtable $eventQuery -MaxEvents 100 -ErrorAction Stop).Count } else { @(Get-WinEvent -ComputerName $ComputerName -FilterHashtable $eventQuery -MaxEvents 100 -ErrorAction Stop).Count }
    } catch {
        $errorCount = $null
        $eventCheck = 'Unavailable'
    }
    $services = @('WinDefend','MpsSvc','wuauserv') | ForEach-Object { Get-SafeServiceStatus -Name $_ }
    $mandatoryServicesHealthy = @($services | Where-Object { $_.Name -in @('WinDefend','MpsSvc') -and $_.Status -eq 'Running' }).Count -eq 2
    $health = if ($freePercent -ge 15 -and $network -and $mandatoryServicesHealthy) { 'Healthy' } else { 'Review' }
    $report = [pscustomobject]@{
        GeneratedUtc = (Get-Date).ToUniversalTime().ToString('o')
        ComputerName = $ComputerName
        OperatingSystem = $osCaption
        Build = $buildNumber
        SystemDriveFreePercent = $freePercent
        SystemInventoryCheck = $systemCheck
        Connectivity443 = [bool]$network
        SystemErrorsLast24Hours = $errorCount
        SystemEventCheck = $eventCheck
        Services = $services
        OverallHealth = $health
        CollectionMode = 'ReadOnly local diagnostic'
    }
    if ($OutputPath) {
        $parent = Split-Path -Parent $OutputPath
        if ($parent -and -not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        $report | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $OutputPath -Encoding UTF8
    }
    $report
} catch {
    throw "Endpoint health collection failed: $($_.Exception.Message)"
}
