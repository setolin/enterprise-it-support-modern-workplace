Describe 'Authorship and provenance controls' {
    BeforeAll {
        $projectRoot = Join-Path $PSScriptRoot '..'
        $authorPath = Join-Path $projectRoot 'AUTHORSHIP.md'
        $newManifestPath = Join-Path $projectRoot 'powershell\New-ProvenanceManifest.ps1'
        $testManifestPath = Join-Path $projectRoot 'powershell\Test-ProvenanceManifest.ps1'
    }

    It 'identifies Alex S Beirigo and states the AI-assistance boundary' {
        $content = Get-Content -LiteralPath $authorPath -Raw
        ($content -match 'Alex S Beirigo' -and $content -match 'AI-assisted') | Should Be $true
    }

    It 'does not claim that a hash alone proves authorship' {
        $content = Get-Content -LiteralPath $authorPath -Raw
        ($content -match 'not independent proof') | Should Be $true
    }

    It 'provides manifest creation and verification scripts' {
        (Test-Path $newManifestPath) | Should Be $true
        (Test-Path $testManifestPath) | Should Be $true
    }
}

