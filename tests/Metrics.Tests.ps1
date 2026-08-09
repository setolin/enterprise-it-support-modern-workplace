Describe 'Lab metrics report' {
    BeforeAll {
        $scriptPath = Join-Path $PSScriptRoot '..\powershell\New-LabMetricsReport.ps1'
        $projectRoot = Join-Path $PSScriptRoot '..'
    }

    It 'reports ten fictional support cases' {
        $result = & $scriptPath
        $result.FictionalSupportCases | Should Be 10
        $result.ReproducibleScenarioCount | Should Be 10
    }

    It 'states the lab-only claims boundary' {
        $result = & $scriptPath
        ($result.ClaimsBoundary -match 'not measured performance') | Should Be $true
    }

    It 'does not write output when paths are omitted' {
        $temporaryPath = Join-Path $PSScriptRoot 'temporary-metrics-output.json'
        if (Test-Path $temporaryPath) { Remove-Item -LiteralPath $temporaryPath -Force }
        $result = & $scriptPath
        (Test-Path $temporaryPath) | Should Be $false
    }
}
