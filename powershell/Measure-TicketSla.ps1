<##
.SYNOPSIS
    Reports simulated ticket SLA performance from tickets.json.

.DESCRIPTION
    Reads fictional ticket records, compares measured handling time to the
    simulated resolution target and writes an optional CSV report. It does not
    connect to a service desk, change ticket data or claim production performance.
    This is a read-only diagnostic report.

.PARAMETER InputPath
    Path to the JSON ticket dataset.

.PARAMETER OutputPath
    Optional CSV output path.

.EXAMPLE
    .\Measure-TicketSla.ps1

.NOTES
    Prerequisite: Windows PowerShell 5.1 or PowerShell 7.
    Author and project owner: Alex S Beirigo.
##>
[CmdletBinding()]
param(
    [string]$InputPath,
    [string]$OutputPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($InputPath)) { $InputPath = Join-Path $projectRoot 'tickets\tickets.json' }
if (-not (Test-Path -LiteralPath $InputPath)) { throw "Ticket input not found: $InputPath" }
$tickets = Get-Content -LiteralPath $InputPath -Raw | ConvertFrom-Json
$report = @($tickets | ForEach-Object {
    [pscustomobject]@{
        Id = $_.id
        Priority = $_.priority
        Type = $_.type
        Queue = $_.queue
        ScenarioElapsedMinutes = [int]$_.scenarioElapsedMinutes
        TargetMinutes = [int]$_.slaTargetMinutes
        WithinScenarioTarget = ([int]$_.scenarioElapsedMinutes -le [int]$_.slaTargetMinutes)
        EvaluationType = 'Scenario input; not measured performance'
        LabStatus = $_.labStatus
    }
})
if ($OutputPath) {
    $parent = Split-Path -Parent $OutputPath
    if ($parent -and -not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    $report | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
}
$report
