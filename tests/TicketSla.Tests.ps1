Describe 'Ticket dataset and SLA report' {
    BeforeAll {
        $ticketPath = Join-Path $PSScriptRoot '..\tickets\tickets.json'
        $scriptPath = Join-Path $PSScriptRoot '..\powershell\Measure-TicketSla.ps1'
    }

    It 'contains ten complete fictional support cases' {
        $tickets = Get-Content -LiteralPath $ticketPath -Raw | ConvertFrom-Json
        $tickets.Count | Should Be 10
        (@($tickets | Where-Object { $_.labStatus -eq 'Simulated' }).Count) | Should Be 10
    }

    It 'includes required troubleshooting fields for every ticket' {
        $tickets = Get-Content -LiteralPath $ticketPath -Raw | ConvertFrom-Json
        $missing = @($tickets | Where-Object { [string]::IsNullOrWhiteSpace($_.diagnosis) -or [string]::IsNullOrWhiteSpace($_.rootCause) -or [string]::IsNullOrWhiteSpace($_.kbArticle) })
        $missing.Count | Should Be 0
    }

    It 'calculates the simulated SLA report' {
        $result = @(& $scriptPath)
        $result.Count | Should Be 10
        (@($result | Where-Object { $_.WithinScenarioTarget -eq $true }).Count) | Should Be 10
        (@($result | Where-Object { $_.EvaluationType -eq 'Scenario input; not measured performance' }).Count) | Should Be 10
    }

    It 'links every ticket to an existing knowledge article' {
        $tickets = Get-Content -LiteralPath $ticketPath -Raw | ConvertFrom-Json
        $kbRoot = Join-Path $PSScriptRoot '..\knowledge-base'
        $missing = @($tickets | Where-Object {
            $kbId = $_.kbArticle
            -not (Get-ChildItem -LiteralPath $kbRoot -Filter "$kbId*.md" -File)
        })
        $missing.Count | Should Be 0
    }

    It 'labels ticket timing as scenario input rather than measured performance' {
        $raw = Get-Content -LiteralPath $ticketPath -Raw
        ($raw -notmatch 'measuredMinutes') | Should Be $true
        ($raw -match 'scenarioElapsedMinutes') | Should Be $true
    }
}
