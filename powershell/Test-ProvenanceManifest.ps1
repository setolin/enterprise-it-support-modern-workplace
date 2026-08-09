<##
.SYNOPSIS
    Verifies files against the SHA-256 provenance manifest.
.DESCRIPTION
    Recalculates hashes for manifest entries and reports Valid, Changed or
    Missing. It does not modify repository files.
.PARAMETER ManifestPath
    Manifest CSV path. Defaults to evidence/provenance-manifest.csv.
.EXAMPLE
    .\Test-ProvenanceManifest.ps1
.NOTES
    Author and project owner: Alex S Beirigo. Read-only controlled lab script.
##>
[CmdletBinding()]
param([string]$ManifestPath)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$projectRoot = (Split-Path -Parent $PSScriptRoot).TrimEnd('\')
if ([string]::IsNullOrWhiteSpace($ManifestPath)) { $ManifestPath = Join-Path $projectRoot 'evidence\provenance-manifest.csv' }
if (-not (Test-Path -LiteralPath $ManifestPath)) { throw "Manifest not found: $ManifestPath" }
$records = @(Import-Csv -LiteralPath $ManifestPath)
@($records | ForEach-Object {
    $filePath = Join-Path $projectRoot ($_.RelativePath.Replace('/','\'))
    $status = if (-not (Test-Path -LiteralPath $filePath)) { 'Missing' } elseif ((Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash -ne $_.SHA256) { 'Changed' } else { 'Valid' }
    [pscustomobject]@{ RelativePath=$_.RelativePath; Status=$status; ProjectOwner=$_.ProjectOwner }
})

