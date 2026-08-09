<##
.SYNOPSIS
    Performs safe DNS and TCP connectivity checks.
.DESCRIPTION
    Tests name resolution and TCP connectivity for a supplied target. It does
    not change DNS, routes, firewall rules or adapter configuration.
.PARAMETER Target
    Hostname to test.
.PARAMETER Port
    TCP port to test. Defaults to 443.
.PARAMETER OutputPath
    Optional JSON destination.
.EXAMPLE
    .\Test-NetworkDiagnostics.ps1 -Target example.com
.NOTES
    A failed check is diagnostic evidence, not proof of root cause.
    Author and project owner: Alex S Beirigo.
##>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string]$Target,
    [ValidateRange(1,65535)][int]$Port = 443,
    [string]$OutputPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
try {
    $dns = $false
    $addresses = @()
    try { $addresses = @(Resolve-DnsName -Name $Target -ErrorAction Stop); $dns = $addresses.Count -gt 0 } catch { $dns = $false }
    $tcp = $false
    try { $tcp = [bool](Test-NetConnection -ComputerName $Target -Port $Port -InformationLevel Quiet -WarningAction SilentlyContinue) } catch { $tcp = $false }
    $result = [pscustomobject]@{
        TestedUtc = (Get-Date).ToUniversalTime().ToString('o')
        Target = $Target
        Port = $Port
        DnsResolution = $dns
        ResolvedAddressCount = $addresses.Count
        TcpReachable = $tcp
        Overall = if ($dns -and $tcp) { 'Pass' } else { 'Review' }
        CollectionMode = 'ReadOnly diagnostic'
    }
    if ($OutputPath) {
        $parent = Split-Path -Parent $OutputPath
        if ($parent -and -not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        $result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $OutputPath -Encoding UTF8
    }
    $result
} catch { throw "Network diagnostics failed: $($_.Exception.Message)" }
