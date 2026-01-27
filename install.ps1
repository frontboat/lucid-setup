$ErrorActionPreference = "Stop"

$AppName = if ($args[0]) { $args[0] } else { "lucid-quickstart" }
$CleanupDir = $null
$LogFile = [System.IO.Path]::GetTempFileName()

function Write-Color {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color -NoNewline
}

function Cleanup {
    # Kill any child processes
    Get-Process | Where-Object { $_.Parent.Id -eq $PID } | Stop-Process -Force -ErrorAction SilentlyContinue

    if ($CleanupDir -and (Test-Path $CleanupDir)) {
        Write-Host ""
        Write-Color "X" "Red"
        Write-Host " Installation failed, cleaning up..."
        Remove-Item -Recurse -Force $CleanupDir -ErrorAction SilentlyContinue
    }
    Remove-Item -Force $LogFile -ErrorAction SilentlyContinue
}

# Register cleanup on exit
$null = Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action { Cleanup }
trap { Cleanup; break }

# Validate app name
if ($AppName -notmatch '^[a-zA-Z0-9_-]+$') {
    Write-Color "X" "Red"
    Write-Host " Invalid app name. Use only letters, numbers, hyphens, underscores."
    exit 1
}

# Check if directory already exists
if (Test-Path $AppName) {
    Write-Color "X" "Red"
    Write-Host " Directory $AppName already exists"
    exit 1
}

Write-Host ""
Write-Host "  Lucid Agents" -ForegroundColor Cyan
Write-Host "  Bun + Hono Starter" -ForegroundColor DarkGray
Write-Host ""

# Check for bun
if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Color "X" "Red"
    Write-Host " bun is not installed"
    Write-Host "  Install it from " -NoNewline
    Write-Color "https://bun.sh" "Cyan"
    Write-Host ""
    exit 1
}

# Create basic Bun + Hono template
Write-Host "Creating Bun + Hono app..." -ForegroundColor DarkGray
try {
    $output = & bun create hono@latest $AppName --template bun --pm bun --install 2>&1
    $output | Out-File $LogFile
    if ($LASTEXITCODE -ne 0) { throw "bun create failed" }
} catch {
    Write-Color "X" "Red"
    Write-Host " Failed to create app"
    Get-Content $LogFile
    exit 1
}
$CleanupDir = $AppName
Write-Color "+" "Green"
Write-Host " Created $AppName"

# Add Lucid Agents packages
Write-Host "Adding Lucid Agents packages..." -ForegroundColor DarkGray
Push-Location $AppName
try {
    $packages = @(
        "@lucid-agents/a2a",
        "@lucid-agents/analytics",
        "@lucid-agents/ap2",
        "@lucid-agents/api-sdk",
        "@lucid-agents/cli",
        "@lucid-agents/core",
        "@lucid-agents/express",
        "@lucid-agents/hono",
        "@lucid-agents/http",
        "@lucid-agents/identity",
        "@lucid-agents/payments",
        "@lucid-agents/scheduler",
        "@lucid-agents/tanstack",
        "@lucid-agents/types",
        "@lucid-agents/wallet"
    )
    $output = & bun add @packages 2>&1
    $output | Out-File $LogFile
    if ($LASTEXITCODE -ne 0) { throw "bun add failed" }
} catch {
    Write-Color "X" "Red"
    Write-Host " Failed to add packages"
    Get-Content $LogFile
    Pop-Location
    exit 1
}
Pop-Location
Write-Color "+" "Green"
Write-Host " Added 15 packages"

# Success - don't clean up the directory
$CleanupDir = $null

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host " To start:"
Write-Host ""
Write-Host "  cd " -ForegroundColor DarkGray -NoNewline
Write-Host $AppName
Write-Host "  bun " -ForegroundColor DarkGray -NoNewline
Write-Host "dev"
Write-Host ""
Write-Host "Using Claude Code? Add the Daydreams skills:" -ForegroundColor DarkGray
Write-Host "  /plugin marketplace add daydreamsai/skills-market" -ForegroundColor Cyan
Write-Host "  /plugin install lucid-agents-sdk@daydreams-skills" -ForegroundColor Cyan
Write-Host ""

# Clean up log file on success
Remove-Item -Force $LogFile -ErrorAction SilentlyContinue
