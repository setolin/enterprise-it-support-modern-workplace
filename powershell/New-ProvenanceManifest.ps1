<##
.SYNOPSIS
    Creates a SHA-256 integrity manifest for the portfolio repository.
.DESCRIPTION
    Hashes versioned project artefacts and records the project owner. The
    manifest proves file integrity after generation; it is not independent
    proof that a named person authored every line.
.PARAMETER OutputPath
    CSV destination. Defaults to evidence/provenance-manifest.csv.
.EXAMPLE
    .\New-ProvenanceManifest.ps1
.NOTES
    Author and project owner: Alex S Beirigo. Read-only except for the manifest.
##>
[CmdletBinding(SupportsShouldProcess)]
param([string]$OutputPath)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$projectRoot = (Split-Path -Parent $PSScriptRoot).TrimEnd('\')
if ([string]::IsNullOrWhiteSpace($OutputPath)) { $OutputPath = Join-Path $projectRoot 'evidence\provenance-manifest.csv' }
$resolvedOutput = [System.IO.Path]::GetFullPath($OutputPath)
$files = Get-ChildItem -LiteralPath $projectRoot -Recurse -File | Where-Object {
    $_.FullName -ne $resolvedOutput -and $_.FullName -notmatch '[\\/]\.git[\\/]'
} | Sort-Object FullName
$generatedUtc = (Get-Date).ToUniversalTime().ToString('o')
$manifest = @($files | ForEach-Object {
    [pscustomobject]@{
        RelativePath = $_.FullName.Substring($projectRoot.Length + 1).Replace('\','/')
        SHA256 = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
        ProjectOwner = 'Alex S Beirigo'
        GeneratedUtc = $generatedUtc
    }
})
if ($PSCmdlet.ShouldProcess($resolvedOutput, 'Write provenance manifest')) {
    $manifest | Export-Csv -LiteralPath $resolvedOutput -NoTypeInformation -Encoding UTF8
}
$manifest

