Describe 'Endpoint health artefacts' {
    BeforeAll {
        $scriptPath = Join-Path $PSScriptRoot '..\powershell\Get-EndpointHealthReport.ps1'
        $designPath = Join-Path $PSScriptRoot '..\documentation\endpoint-management-design.md'
    }

    It 'has comment-based help and a read-only collection mode' {
        $content = Get-Content -LiteralPath $scriptPath -Raw
        ($content -match '\.SYNOPSIS' -and $content -match 'ReadOnly local diagnostic') | Should Be $true
    }

    It 'documents the Intune licensing boundary' {
        $content = Get-Content -LiteralPath $designPath -Raw
        ($content -match 'licensing' -and $content -match 'not assumed') | Should Be $true
    }

    It 'does not contain credential collection commands' {
        $content = Get-Content -LiteralPath $scriptPath -Raw
        ($content -notmatch '(?i)ConvertTo-SecureString|Get-Credential|password|token') | Should Be $true
    }
}

