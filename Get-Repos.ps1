<#
.SYNOPSIS
    Clones dependency Git repositories beside the current workspace folder if missing.

.DESCRIPTION
    This script clones a list of Git repositories to the parent directory of the script location.
    Existing folders with the same base name are automatically skipped to avoid conflicts.
    The script provides colored output, progress tracking, and comprehensive error handling.

.PARAMETER Repositories
    Array of Git repository URLs to clone. If not specified, uses a default list of 
    Sky-Ledger project repositories.

.EXAMPLE
    .\Get-Repos.ps1
    
    Clones the default Sky-Ledger repositories to the parent directory.

.EXAMPLE
    .\Get-Repos.ps1 -Repositories @("https://github.com/microsoft/PowerShell.git", "https://github.com/PowerShell/PowerShell-Docs.git")
    
    Clones the specified repositories instead of the default ones.

.EXAMPLE
    .\Get-Repos.ps1 -Verbose
    
    Clones repositories with detailed verbose output for troubleshooting and monitoring.

.NOTES
    - Existing folders (same base name) are automatically skipped
    - Requires 'git' to be available on PATH
    - Repositories are cloned to the parent directory of the script location
    - Script provides summary statistics after completion
    - Uses comprehensive error handling for robust operation

.LINK
    https://github.com/Sky-Ledger/code-workspace
#>
[CmdletBinding()]
param(    
    [string[]] $Repositories = @(
        'https://github.com/Sky-Ledger/bicep-management-groups.git'
        'https://github.com/Sky-Ledger/powershell-script-analyzer.git'
    )
)

Set-StrictMode -Version 3.0
$ErrorActionPreference = 'Stop'

#############################
# FUNCTIONS
#############################

function Test-GitAvailability {
    <#
    .SYNOPSIS
    Checks if Git is available in the system PATH.
    #>
    [CmdletBinding()]
    param()
    
    try {
        $null = Get-Command git -ErrorAction Stop
        Write-Verbose "Git command found and available"
        return $true
    }
    catch {
        Write-Error "Git is not available in PATH. Please install Git and ensure it's accessible."
        return $false
    }
}

function Get-RepoFolderName {
    <#
    .SYNOPSIS
    Extracts the repository folder name from a Git URL.
    
    .PARAMETER Url
    The Git repository URL to extract the folder name from.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Url
    )
    
    # Strip trailing .git then take last path segment
    $clean = $Url -replace '\.git$', ''
    return [IO.Path]::GetFileName($clean)
}

#############################
# MAIN LOGIC
#############################

Write-Verbose "Starting repository cloning process..."
    
# Validate input parameters
if (-not $Repositories -or $Repositories.Count -eq 0) {
    Write-Warning 'No repositories specified.'
    return
}
    
Write-Verbose "Processing $($Repositories.Count) repositories"
    
# Validate Git is available
if (-not (Test-GitAvailability)) {
    return
}
    
# Target parent directory: parent of script directory
$parentDirectory = Split-Path -Parent $PSScriptRoot
Write-Verbose "Target directory: $parentDirectory"
    
if (-not (Test-Path -LiteralPath $parentDirectory)) {
    throw "Parent directory does not exist: $parentDirectory"
}
    
Set-Location -LiteralPath $parentDirectory
Write-Verbose "Changed to directory: $((Get-Location).Path)"
    
# Process each repository
$processedCount = 0
$skippedCount = 0
$clonedCount = 0
$errorCount = 0
    
foreach ($repo in $Repositories) {
    $processedCount++
    Write-Verbose "Processing repository $processedCount of $($Repositories.Count): $repo"
        
    $repoName = Get-RepoFolderName -Url $repo
        
    if (Test-Path -LiteralPath $repoName -PathType Container) {
        Write-Host "Skip: $repoName (already exists)" -ForegroundColor Yellow
        Write-Verbose "Repository folder already exists: $repoName"
        $skippedCount++
        continue
    }
        
    Write-Host "Cloning $repo -> $repoName" -ForegroundColor Cyan
        
    try {
        $gitOutput = git clone $repo 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Successfully cloned: $repoName" -ForegroundColor Green
            Write-Verbose "Git clone successful for: $repo"
            $clonedCount++
        }
        else {
            Write-Error "Failed to clone repository: $repo. Git output: $gitOutput"
            $errorCount++
        }
    }
    catch {
        Write-Error "Error cloning repository $repo`: $($_.Exception.Message)"
        $errorCount++
    }
}
    
# Summary
Write-Host "`nSummary:" -ForegroundColor Magenta
Write-Host "  Processed: $processedCount repositories" -ForegroundColor White
Write-Host "  Cloned: $clonedCount repositories" -ForegroundColor Green
if ($skippedCount -gt 0) {
    Write-Host "  Skipped: $skippedCount repositories" -ForegroundColor Yellow
}
if ($errorCount -gt 0) {
    Write-Host "  Errors: $errorCount repositories" -ForegroundColor Red
}
    
if ($errorCount -eq 0) {
    Write-Host "`n✅ Done successfully!" -ForegroundColor Green
}
else {
    Write-Warning "⚠️ Completed with $errorCount error(s). Please review the output above."
}
    
Write-Verbose "Repository cloning process completed"
