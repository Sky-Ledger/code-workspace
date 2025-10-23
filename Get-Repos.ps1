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
    .OUTPUTS
    [bool] True if git is available; otherwise false.
    #>
  [CmdletBinding()]
  [OutputType([bool])]
  param()

  try {
    $null = Get-Command git -ErrorAction Stop
    Write-Verbose 'Git command found and available'
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

function Show-RepoMessage {
  <#
    .SYNOPSIS
    Emits repository cloning messages using host-agnostic cmdlets.
    .DESCRIPTION
    Replaces Write-Host with structured output levels to satisfy analyzer rule
    PSAvoidUsingWriteHost. Styles: Info (default), Success, Warning, Error.
    .PARAMETER Message
    The text to emit.
    .PARAMETER Style
    One of Info, Success, Warning, Error.
  #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string]$Message,
    [ValidateSet('Info', 'Success', 'Warning', 'Error', 'Verbose')][string]$Style = 'Info'
  )
  switch ($Style) {
    'Success' { Write-Output "✅ $Message" }
    'Warning' { Write-Warning "⚠️ $Message" }
    'Error' { Write-Error "❌ $Message" }
    'Verbose' { Write-Verbose "$Message" }
    default { Write-Output "$Message" }
  }
}

#############################
# MAIN LOGIC
#############################

Show-RepoMessage -Message 'Starting repository cloning process...' -Style Verbose

# Validate input parameters
if (-not $Repositories -or $Repositories.Count -eq 0) {
  Show-RepoMessage -Message 'No repositories specified.' -Style Warning
  return
}

Show-RepoMessage -Message "Processing $($Repositories.Count) repositories" -Style Verbose

# Validate Git is available
if (-not (Test-GitAvailability)) {
  return
}

# Target parent directory: parent of script directory
$parentDirectory = Split-Path -Parent $PSScriptRoot
Show-RepoMessage -Message "Target directory: $parentDirectory" -Style Verbose

if (-not (Test-Path -LiteralPath $parentDirectory)) {
  throw "Parent directory does not exist: $parentDirectory"
}

Set-Location -LiteralPath $parentDirectory
Show-RepoMessage -Message "Changed to directory: $((Get-Location).Path)" -Style Verbose

# Process each repository
$processedCount = 0
$skippedCount = 0
$clonedCount = 0
$errorCount = 0

foreach ($repo in $Repositories) {
  $processedCount++
  Show-RepoMessage -Message "Processing repository $processedCount of $($Repositories.Count): $repo" -Style Verbose

  $repoName = Get-RepoFolderName -Url $repo

  if (Test-Path -LiteralPath $repoName -PathType Container) {
    Show-RepoMessage -Message "Skip: $repoName (already exists)" -Style Warning
    Show-RepoMessage -Message "Repository folder already exists: $repoName" -Style Verbose
    $skippedCount++
    continue
  }

  Show-RepoMessage -Message "Cloning $repo -> $repoName" -Style Info

  try {
    $gitOutput = git clone $repo 2>&1
    if ($LASTEXITCODE -eq 0) {
      Show-RepoMessage -Message "Successfully cloned: $repoName" -Style Success
      Show-RepoMessage -Message "Git clone successful for: $repo" -Style Verbose
      $clonedCount++
    }
    else {
      Show-RepoMessage -Message "Failed to clone repository: $repo. Git output: $gitOutput" -Style Error
      $errorCount++
    }
  }
  catch {
    Show-RepoMessage -Message "Error cloning repository $repo`: $($_.Exception.Message)" -Style Error
    $errorCount++
  }
}

# Summary
Show-RepoMessage -Message 'Summary:' -Style Info
Show-RepoMessage -Message "Processed: $processedCount repositories" -Style Info
Show-RepoMessage -Message "Cloned: $clonedCount repositories" -Style Success
if ($skippedCount -gt 0) {
  Show-RepoMessage -Message "Skipped: $skippedCount repositories" -Style Warning
}
if ($errorCount -gt 0) {
  Show-RepoMessage -Message "Errors: $errorCount repositories" -Style Error
}

if ($errorCount -eq 0) {
  Show-RepoMessage -Message 'Done successfully!' -Style Success
}
else {
  Show-RepoMessage -Message "Completed with $errorCount error(s). Please review the output above." -Style Warning
}

Show-RepoMessage -Message 'Repository cloning process completed' -Style Verbose
