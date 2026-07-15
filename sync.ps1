# sync.ps1 — Brainvibes Auto-Sync Script
# Jalankan script ini untuk menyinkronkan file master dari drive D ke folder global AI di drive C.

$ErrorActionPreference = "Stop"

# Tentukan path sumber dan target
$SourceDir = $PSScriptRoot
$TargetDir = Join-Path $env:USERPROFILE ".gemini"
$KnowledgeTargetDir = Join-Path $TargetDir "antigravity-ide\knowledge"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   BRAINVIBES AUTO-SYNC SYSTEM           " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Sumber (Master) : $SourceDir"
Write-Host "Target (Global) : $TargetDir"
Write-Host "-----------------------------------------"

# Pastikan folder target ada
if (!(Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
    Write-Host "[+] Membuat folder target: $TargetDir" -ForegroundColor Green
}

if (!(Test-Path $KnowledgeTargetDir)) {
    New-Item -ItemType Directory -Force -Path $KnowledgeTargetDir | Out-Null
    Write-Host "[+] Membuat folder target knowledge: $KnowledgeTargetDir" -ForegroundColor Green
}

# 1. Salin berkas-berkas inti di root
$CoreFiles = @("gemini.md", "prd-template.md", "design-system.md", "AGENTS.md", "user-prefs.md")
foreach ($File in $CoreFiles) {
    $SrcFile = Join-Path $SourceDir $File
    $DstFile = Join-Path $TargetDir $File
    if (Test-Path $SrcFile) {
        Copy-Item -Path $SrcFile -Destination $DstFile -Force
        Write-Host "[OK] Menyalin $File -> $DstFile" -ForegroundColor Gray
    } else {
        Write-Warning "File tidak ditemukan di sumber: $SrcFile"
    }
}

# 2. Salin folder config secara rekursif
$SrcConfig = Join-Path $SourceDir "config"
$DstConfig = Join-Path $TargetDir "config"
if (Test-Path $SrcConfig) {
    Write-Host "[i] Menyalin folder config secara rekursif..." -ForegroundColor Yellow
    # Menggunakan robocopy untuk performa dan keamanan overwrite
    robocopy $SrcConfig $DstConfig /E /XO /NJH /NJS /NDL /NC /NS /NP | Out-Null
    Write-Host "[OK] Folder config tersinkronisasi." -ForegroundColor Green
}

# 3. Salin folder knowledge secara rekursif
$SrcKnowledge = Join-Path $SourceDir "knowledge"
if (Test-Path $SrcKnowledge) {
    Write-Host "[i] Menyalin folder knowledge secara rekursif..." -ForegroundColor Yellow
    robocopy $SrcKnowledge $KnowledgeTargetDir /E /XO /NJH /NJS /NDL /NC /NS /NP | Out-Null
    Write-Host "[OK] Folder knowledge tersinkronisasi." -ForegroundColor Green
}

# 4. Merge mcpServers dari mcp_config.json ke settings.json
$McpConfigSrc = Join-Path $SourceDir "config\mcp_config.json"
$SettingsFile  = Join-Path $TargetDir "settings.json"

if ((Test-Path $McpConfigSrc) -and (Test-Path $SettingsFile)) {
    Write-Host "[i] Merging MCP servers ke settings.json..." -ForegroundColor Yellow
    try {
        $mcpConfig   = Get-Content $McpConfigSrc -Raw | ConvertFrom-Json
        $settings    = Get-Content $SettingsFile  -Raw | ConvertFrom-Json

        # Pastikan property mcpServers ada di settings
        if ($settings.PSObject.Properties.Name -notcontains "mcpServers") {
            Add-Member -InputObject $settings -MemberType NoteProperty -Name "mcpServers" -Value ([PSCustomObject]@{})
        }

        # Copy setiap server dari mcp_config ke settings
        foreach ($server in $mcpConfig.mcpServers.PSObject.Properties) {
            Add-Member -InputObject $settings.mcpServers -MemberType NoteProperty -Name $server.Name -Value $server.Value -Force
        }

        $settings | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding UTF8
        Write-Host "[OK] MCP servers berhasil di-merge ke settings.json" -ForegroundColor Green
    } catch {
        Write-Warning "Gagal merge MCP config: $_"
    }
} elseif (-not (Test-Path $McpConfigSrc)) {
    Write-Warning "mcp_config.json tidak ditemukan di sumber: $McpConfigSrc"
} else {
    Write-Warning "settings.json tidak ditemukan di target: $SettingsFile"
}

Write-Host "-----------------------------------------"
Write-Host "[SUKSES] Sinkronisasi master Brainvibes selesai!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
