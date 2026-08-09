<##
.SYNOPSIS
    Checks the state of selected Windows services.
.DESCRIPTION
    Performs a read-only service status check and returns Pass or Review for
    each service. It does not start, stop or reconfigure services.
.PARAMETER ServiceName
    One or more service names.
.PARAMETER OutputPath
    Optional CSV destination.
.EXAMPLE
    .\Get-ServiceHealthReport.ps1 -ServiceName WinDefend,MpsSvc,wuauserv
.NOTES
    Author and project owner: Alex S Beirigo. Read-only controlled lab script.
##>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string[]]$ServiceName,
    [string]$OutputPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$result = @($ServiceName | ForEach-Object {
    $requestedName = $_
    try {
        $service = Get-Service -Name $requestedName -ErrorAction Stop
        [pscustomobject]@{ CheckedUtc=(Get-Date).ToUniversalTime().ToString('o'); Name=$requestedName; Status=[string]$service.Status; Result=if ($service.Status -eq 'Running') {'Pass'} else {'Review'} }
    } catch {
        [pscustomobject]@{ CheckedUtc=(Get-Date).ToUniversalTime().ToString('o'); Name=$requestedName; Status='Unavailable'; Result='Review' }
    }
})
if ($OutputPath) {
    $parent = Split-Path -Parent $OutputPath
    if ($parent -and -not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    $result | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
}
$result
