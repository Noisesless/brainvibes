# index-project.ps1 — Index repository and ensure 3D Graph UI on port 9749
param(
    [string]$RepoPath = (Get-Location).Path,
    [string]$Mode = "full",
    [string]$CbmExe = ""
)

if (-not $CbmExe) {
    $cbmCmd = Get-Command "codebase-memory-mcp" -ErrorAction SilentlyContinue
    $CbmExe = if ($cbmCmd) { $cbmCmd.Source } else { "$env:LOCALAPPDATA\Programs\codebase-memory-mcp\codebase-memory-mcp.exe" }
}

$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   BRAINVIBES CODEBASE INDEXER          " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Target Repository : $RepoPath"
Write-Host "Index Mode        : $Mode"
Write-Host "-----------------------------------------"

# 1. Pastikan daemon & port 9749 aktif
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$daemonScript = Join-Path $scriptDir "ensure-cbm-daemon.ps1"
if (Test-Path $daemonScript) {
    & $daemonScript
} else {
    Start-Process -FilePath $CbmExe -ArgumentList "daemon","start" -WindowStyle Hidden
}

# 2. Jalankan proses indexing
Write-Host "[i] Mengindeks repositori AST Knowledge Graph..." -ForegroundColor Yellow
$indexArgs = @("cli", "--progress", "index_repository", "--repo-path", $RepoPath, "--mode", $Mode)
$process = Start-Process -FilePath $CbmExe -ArgumentList $indexArgs -NoNewWindow -PassThru -Wait

if ($process.ExitCode -eq 0) {
    Write-Host "[OK] Pengindeksan berhasil selesai!" -ForegroundColor Green
    Write-Host "[UI] Graph visualization tersedia di: http://localhost:9749/" -ForegroundColor Cyan
} else {
    Write-Warning "Pengindeksan selesai dengan exit code $($process.ExitCode)"
}

Write-Host "=========================================" -ForegroundColor Cyan
