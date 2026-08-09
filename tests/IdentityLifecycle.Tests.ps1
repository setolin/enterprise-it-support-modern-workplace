Describe 'Identity lifecycle simulation' {
    BeforeAll {
        $scriptPath = Join-Path $PSScriptRoot '..\powershell\Invoke-IdentityLifecycleSimulation.ps1'
        $inputPath = Join-Path $PSScriptRoot '..\data\fictional-users.csv'
    }

    It 'contains fictional users with unique IDs' {
        $users = @(Import-Csv -LiteralPath $inputPath)
        ($users.Count -gt 0) | Should Be $true
        @($users.UserId | Sort-Object -Unique).Count | Should Be $users.Count
    }

    It 'validates a move without writing state in WhatIf mode' {
        $result = & $scriptPath -Action Move -UserId alex.jones -Department 'Data & Analytics' -AccessProfile Data-Analyst -WhatIf
        (($result -join "`n") -match 'Data-Analyst') | Should Be $true
    }

    It 'rejects an unknown user' {
        $failed = $false
        try { & $scriptPath -Action Offboard -UserId unknown.user -WhatIf } catch { $failed = $true }
        $failed | Should Be $true
    }
}
