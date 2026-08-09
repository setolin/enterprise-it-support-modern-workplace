<##
.SYNOPSIS
    Simulates safe identity lifecycle operations using fictional local data.

.DESCRIPTION
    Models onboarding, internal moves, offboarding and reporting without calling
    Microsoft Graph, Entra ID or any external service. The script writes a local
    JSON state file and an audit log. It never stores passwords or tokens.

.PARAMETER Action
    One of Onboard, Move, Offboard or Report.

.PARAMETER UserId
    Fictional user ID from the input CSV.

.PARAMETER Department
    Target department for Move or the department for a new Onboard record.

.PARAMETER AccessProfile
    Target access profile for Move or the profile for a new Onboard record.

.PARAMETER InputPath
    Path to the fictional user CSV.

.PARAMETER StatePath
    Path to the local JSON state file.

.PARAMETER LogPath
    Path to the audit log.

.EXAMPLE
    .\Invoke-IdentityLifecycleSimulation.ps1 -Action Report

.EXAMPLE
    .\Invoke-IdentityLifecycleSimulation.ps1 -Action Move -UserId alex.jones -Department 'Data & Analytics' -AccessProfile Data-Analyst -WhatIf

.NOTES
    Prerequisite: Windows PowerShell 5.1 or PowerShell 7. No cloud module is
    required. All identities and results are fictional lab data.
    Author and project owner: Alex S Beirigo.
##>
[CmdletBinding(SupportsShouldProcess)]
param(
    [ValidateSet('Onboard','Move','Offboard','Report')]
    [string]$Action = 'Report',
    [ValidatePattern('^[a-z0-9]+(\.[a-z0-9-]+)+$')]
    [string]$UserId,
    [string]$Department,
    [ValidatePattern('^[A-Za-z0-9-]+$')]
    [string]$AccessProfile,
    [string]$InputPath,
    [string]$StatePath,
    [string]$LogPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($InputPath)) { $InputPath = Join-Path $projectRoot 'data\fictional-users.csv' }
if ([string]::IsNullOrWhiteSpace($StatePath)) { $StatePath = Join-Path $projectRoot 'evidence\identity-state.json' }
if ([string]::IsNullOrWhiteSpace($LogPath)) { $LogPath = Join-Path $projectRoot 'evidence\identity-audit.log' }

function Write-AuditLog {
    param([string]$Message)
    $timestamp = (Get-Date).ToUniversalTime().ToString('o')
    $parent = Split-Path -Parent $LogPath
    if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    Add-Content -LiteralPath $LogPath -Value "$timestamp`t$Message"
}

function Read-State {
    if (Test-Path -LiteralPath $StatePath) {
        $raw = Get-Content -LiteralPath $StatePath -Raw
        if ([string]::IsNullOrWhiteSpace($raw)) { return @{} }
        return ($raw | ConvertFrom-Json -AsHashtable)
    }
    return @{}
}

if (-not (Test-Path -LiteralPath $InputPath)) { throw "Input file not found: $InputPath" }
$users = @(Import-Csv -LiteralPath $InputPath)
$state = Read-State

if ($Action -eq 'Report') {
    $users | Select-Object UserId,DisplayName,Department,Role,EmploymentStatus,AccessProfile | Format-Table -AutoSize
    Write-AuditLog 'Report generated from fictional user data.'
    return
}

if ([string]::IsNullOrWhiteSpace($UserId)) { throw 'UserId is required for this action.' }
$user = $users | Where-Object UserId -eq $UserId | Select-Object -First 1
if (-not $user) { throw "UserId not found in fictional input: $UserId" }

$before = [ordered]@{
    UserId = $user.UserId
    Department = $user.Department
    AccessProfile = $user.AccessProfile
    EmploymentStatus = $user.EmploymentStatus
}
$after = [ordered]@{} + $before

switch ($Action) {
    'Onboard' {
        $after.EmploymentStatus = 'Active'
        if ($Department) { $after.Department = $Department }
        if ($AccessProfile) { $after.AccessProfile = $AccessProfile }
    }
    'Move' {
        if ([string]::IsNullOrWhiteSpace($Department) -or [string]::IsNullOrWhiteSpace($AccessProfile)) { throw 'Move requires Department and AccessProfile.' }
        $after.Department = $Department
        $after.AccessProfile = $AccessProfile
    }
    'Offboard' {
        $after.EmploymentStatus = 'Disabled'
    }
}

$change = [ordered]@{ Timestamp = (Get-Date).ToUniversalTime().ToString('o'); Action = $Action; Before = $before; After = $after }
if ($WhatIfPreference) {
    Write-AuditLog "WHATIF $Action for $UserId"
    $change | ConvertTo-Json -Depth 5
    return
}

if (-not $PSCmdlet.ShouldProcess($UserId, $Action)) { return }
$state[$UserId] = $after
$stateParent = Split-Path -Parent $StatePath
if (-not (Test-Path -LiteralPath $stateParent)) { New-Item -ItemType Directory -Path $stateParent -Force | Out-Null }
$state | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $StatePath -Encoding UTF8
Write-AuditLog "$Action completed for $UserId"
$change | ConvertTo-Json -Depth 5
