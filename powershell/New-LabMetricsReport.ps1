<##
.SYNOPSIS
    Generates a repository-level lab metrics report.
.DESCRIPTION
    Counts reproducible artefacts and evaluates the fictional ticket SLA dataset.
    The report is descriptive only and makes no production or commercial claims.
.PARAMETER OutputPath
    Optional JSON report destination.
.PARAMETER CsvPath
    Optional CSV summary destination.
.EXAMPLE
    .\New-LabMetricsReport.ps1 -OutputPath .\reports\lab-metrics.json
.NOTES
    Windows PowerShell 5.1 or PowerShell 7. Read-only repository inspection.
    Author and project owner: Alex S Beirigo.
##>
[CmdletBinding()]
param([string]$OutputPath,[string]$CsvPath)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$ticketPath = Join-Path $projectRoot 'tickets\tickets.json'
$tickets = Get-Content -LiteralPath $ticketPath -Raw | ConvertFrom-Json
$ticketCount = @($tickets).Count
$withinTarget = @($tickets | Where-Object { [int]$_.scenarioElapsedMinutes -le [int]$_.slaTargetMinutes }).Count
$scriptCount = @(Get-ChildItem -LiteralPath $PSScriptRoot -Filter '*.ps1').Count
$testCount = @(Get-ChildItem -LiteralPath (Join-Path $projectRoot 'tests') -Filter '*.Tests.ps1').Count
$markdownCount = @(Get-ChildItem -LiteralPath $projectRoot -Recurse -Filter '*.md' -File).Count
$report = [pscustomobject]@{
    GeneratedUtc = (Get-Date).ToUniversalTime().ToString('o')
    Environment = 'Controlled local lab'
    FictionalSupportCases = $ticketCount
    FictionalCasesWithinScenarioTarget = $withinTarget
    ScenarioTargetRate = if ($ticketCount -gt 0) { [math]::Round(($withinTarget / $ticketCount) * 100, 1) } else { 0 }
    PowerShellScripts = $scriptCount
    PesterTestFiles = $testCount
    MarkdownDocuments = $markdownCount
    ReproducibleScenarioCount = $ticketCount
    ClaimsBoundary = 'Scenario timing is assigned test input, not measured performance; no production or commercial outcome claimed'
}
if ($OutputPath) { $report | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $OutputPath -Encoding UTF8 }
if ($CsvPath) { $report | Export-Csv -LiteralPath $CsvPath -NoTypeInformation -Encoding UTF8 }
$report
