<#!
Get-DependencyRepos.ps1
Purpose: Clone dependency Git repositories beside the current workspace folder if missing.
Usage:
    .\Get-DependencyRepos.ps1
Parameters: N/A
Notes:
    - Existing folders (same base name) are skipped.
    - Assumes `git` is available on PATH.
#>

[CmdletBinding()]
param(
    [string[]] $Repositories
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

#############################
# VARIABLES
#############################
$repositories = @(
    'https://github.com/Sky-Ledger/bicep-management-groups.git'
    'https://github.com/Sky-Ledger/powershell-script-analyzer.git'
)
if (-not $repositories -or $repositories.Count -eq 0) { Write-Warning 'No repositories specified.'; return }

#############################
# FUNCTIONS
#############################
function Get-RepoFolderName {
    [CmdletBinding()] param([Parameter(Mandatory)][string] $Url)
    # Strip trailing .git then take last path segment
    $clean = $Url -replace '\.git$', ''
    return [IO.Path]::GetFileName($clean)
}

#############################
# LOGIC
#############################
# Target parent directory: parent of script directory
$parentDirectory = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $parentDirectory

foreach ($repo in $repositories) {
    $repoName = Get-RepoFolderName -Url $repo
    if (Test-Path -LiteralPath $repoName) {
        Write-Host "Skip: $repoName (already exists)" -ForegroundColor Yellow
        continue
    }
    Write-Host "Cloning $repo -> $repoName" -ForegroundColor Cyan
    git clone $repo 2>&1 | Write-Host
}

Write-Host 'Done.' -ForegroundColor Green
