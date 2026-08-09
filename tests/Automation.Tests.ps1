Describe 'Support automation safety' {
    BeforeAll { $scriptRoot = Join-Path $PSScriptRoot '..\powershell' }

    It 'provides the four diagnostic scripts' {
        @('Get-EndpointInventory.ps1','Test-NetworkDiagnostics.ps1','Get-ServiceHealthReport.ps1','Get-DiskSpaceReport.ps1') | ForEach-Object {
            (Test-Path (Join-Path $scriptRoot $_)) | Should Be $true
        }
    }

    It 'does not contain state-changing service commands' {
        $content = Get-Content -LiteralPath (Join-Path $scriptRoot 'Get-ServiceHealthReport.ps1') -Raw
        ($content -notmatch '(?i)Start-Service|Stop-Service|Set-Service') | Should Be $true
    }

    It 'documents read-only or diagnostic behaviour' {
        $files = Get-ChildItem -LiteralPath $scriptRoot -Filter '*.ps1'
        foreach ($file in $files) {
            $content = Get-Content -LiteralPath $file.FullName -Raw
            (($content -match '(?i)read-only|ReadOnly|diagnostic') -or ($file.Name -eq 'Invoke-IdentityLifecycleSimulation.ps1')) | Should Be $true
        }
    }

    It 'returns the requested service name when a service is unavailable' {
        $result = @(& (Join-Path $scriptRoot 'Get-ServiceHealthReport.ps1') -ServiceName 'NCR-Service-Does-Not-Exist')
        $result.Count | Should Be 1
        $result[0].Name | Should Be 'NCR-Service-Does-Not-Exist'
        $result[0].Result | Should Be 'Review'
    }

    It 'produces endpoint inventory through CIM or the documented fallback' {
        $output = Join-Path $TestDrive 'inventory.csv'
        $result = @(& (Join-Path $scriptRoot 'Get-EndpointInventory.ps1') -OutputPath $output)
        ($result.Count -gt 0) | Should Be $true
        (Test-Path $output) | Should Be $true
        ([string]::IsNullOrWhiteSpace($result[0].CollectionSource)) | Should Be $false
    }

    It 'produces a disk report through CIM or the documented fallback' {
        $output = Join-Path $TestDrive 'disk.csv'
        $result = @(& (Join-Path $scriptRoot 'Get-DiskSpaceReport.ps1') -OutputPath $output)
        ($result.Count -gt 0) | Should Be $true
        (Test-Path $output) | Should Be $true
    }
}
