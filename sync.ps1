# sync.ps1 — Brainvibes Auto-Sync Script
# Jalankan script ini untuk menyinkronkan file master dari drive D ke folder global AI di drive C.

$ErrorActionPreference = "Stop"

# Tentukan path sumber dan target
$SourceDir = $PSScriptRoot
$GeminiTargetDir = Join-Path $env:USERPROFILE ".gemini"
$KnowledgeTargetDir = Join-Path $GeminiTargetDir "antigravity-ide\knowledge"
$OpencodeTargetDir = Join-Path $env:USERPROFILE ".config\opencode"
$OpencodeBrainvibesDir = Join-Path $OpencodeTargetDir "brainvibes"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   BRAINVIBES AUTO-SYNC SYSTEM           " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Sumber (Master) : $SourceDir"
Write-Host "Target (Gemini) : $GeminiTargetDir"
Write-Host "Target (Opencode): $OpencodeTargetDir"
Write-Host "-----------------------------------------"

# Pastikan folder target ada
if (!(Test-Path $GeminiTargetDir)) {
    New-Item -ItemType Directory -Force -Path $GeminiTargetDir | Out-Null
    Write-Host "[+] Membuat folder target: $GeminiTargetDir" -ForegroundColor Green
}

if (!(Test-Path $KnowledgeTargetDir)) {
    New-Item -ItemType Directory -Force -Path $KnowledgeTargetDir | Out-Null
    Write-Host "[+] Membuat folder target knowledge: $KnowledgeTargetDir" -ForegroundColor Green
}

if (!(Test-Path $OpencodeBrainvibesDir)) {
    New-Item -ItemType Directory -Force -Path $OpencodeBrainvibesDir | Out-Null
    Write-Host "[+] Membuat folder target opencode brainvibes: $OpencodeBrainvibesDir" -ForegroundColor Green
}

# 1. Salin berkas-berkas inti di root ke .gemini
$CoreFiles = @("gemini.md", "prd-template.md", "design-system.md", "AGENTS.md", "user-prefs.md")
foreach ($File in $CoreFiles) {
    $SrcFile = Join-Path $SourceDir $File
    $DstFile = Join-Path $GeminiTargetDir $File
    if (Test-Path $SrcFile) {
        Copy-Item -Path $SrcFile -Destination $DstFile -Force
        Write-Host "[OK] Menyalin $File -> $DstFile" -ForegroundColor Gray
    } else {
        Write-Warning "File tidak ditemukan di sumber: $SrcFile"
    }
}

# 2. Salin folder config secara rekursif ke .gemini
$SrcConfig = Join-Path $SourceDir "config"
$DstConfig = Join-Path $GeminiTargetDir "config"
if (Test-Path $SrcConfig) {
    Write-Host "[i] Menyalin folder config secara rekursif..." -ForegroundColor Yellow
    robocopy $SrcConfig $DstConfig /E /XO /NJH /NJS /NDL /NC /NS /NP | Out-Null
    Write-Host "[OK] Folder config tersinkronisasi." -ForegroundColor Green
}

# 3. Salin folder knowledge secara rekursif ke .gemini
$SrcKnowledge = Join-Path $SourceDir "knowledge"
if (Test-Path $SrcKnowledge) {
    Write-Host "[i] Menyalin folder knowledge secara rekursif..." -ForegroundColor Yellow
    robocopy $SrcKnowledge $KnowledgeTargetDir /E /XO /NJH /NJS /NDL /NC /NS /NP | Out-Null
    Write-Host "[OK] Folder knowledge tersinkronisasi." -ForegroundColor Green
}

# 4. Salin file inti ke .config\opencode\brainvibes\
$OpencodeCoreFiles = @("gemini.md", "gemini-execution.md", "gemini-templates.md", "prd-template.md", "design-system.md", "AGENTS.md", "user-prefs.md", "WORKFLOW_SIMULATIONS.md", "yasei-cli.ps1")
foreach ($File in $OpencodeCoreFiles) {
    $SrcFile = Join-Path $SourceDir $File
    $DstFile = Join-Path $OpencodeBrainvibesDir $File
    if (Test-Path $SrcFile) {
        Copy-Item -Path $SrcFile -Destination $DstFile -Force
        Write-Host "[OK] Menyalin $File -> $DstFile" -ForegroundColor Gray
    }
}

# 5. Salin AGENTS.md ke .config\opencode\brainvibes-AGENTS.md
$SrcAgents = Join-Path $SourceDir "AGENTS.md"
$DstAgents = Join-Path $OpencodeTargetDir "brainvibes-AGENTS.md"
if (Test-Path $SrcAgents) {
    Copy-Item -Path $SrcAgents -Destination $DstAgents -Force
    Write-Host "[OK] Menyalin AGENTS.md -> $DstAgents" -ForegroundColor Gray
}

# 6. Salin .docs ke .config\opencode\brainvibes\.docs
$SrcDocs = Join-Path $SourceDir ".docs"
$DstDocs = Join-Path $OpencodeBrainvibesDir ".docs"
if (Test-Path $SrcDocs) {
    Write-Host "[i] Menyalin folder .docs..." -ForegroundColor Yellow
    robocopy $SrcDocs $DstDocs /E /XO /NJH /NJS /NDL /NC /NS /NP | Out-Null
    Write-Host "[OK] Folder .docs tersinkronisasi." -ForegroundColor Green
}

# 7. Salin file sekunder ke .config\opencode\brainvibes\
$SecondaryFiles = @(".gitignore", "LICENSE", "sync.ps1", "README.md")
foreach ($File in $SecondaryFiles) {
    $SrcFile = Join-Path $SourceDir $File
    $DstFile = Join-Path $OpencodeBrainvibesDir $File
    if (Test-Path $SrcFile) {
        Copy-Item -Path $SrcFile -Destination $DstFile -Force
        Write-Host "[OK] Menyalin $File -> $DstFile" -ForegroundColor Gray
    }
}

# 8. Merge mcpConfig dari mcp_config.json ke settings.json (untuk Gemini)
$McpConfigSrc = Join-Path $SourceDir "config\mcp_config.json"
$SettingsFile = Join-Path $GeminiTargetDir "settings.json"

if ((Test-Path $McpConfigSrc) -and (Test-Path $SettingsFile)) {
    Write-Host "[i] Merging MCP config ke settings.json..." -ForegroundColor Yellow
    try {
        $mcpConfig = Get-Content $McpConfigSrc -Raw | ConvertFrom-Json
        $settings = Get-Content $SettingsFile -Raw | ConvertFrom-Json

        # Cek apakah menggunakan format baru (mcp) atau lama (mcpServers)
        if ($mcpConfig.PSObject.Properties.Name -contains "mcp") {
            # Format baru - gunakan key "mcp"
            if ($settings.PSObject.Properties.Name -notcontains "mcp") {
                Add-Member -InputObject $settings -MemberType NoteProperty -Name "mcp" -Value ([PSCustomObject]@{})
            }
            foreach ($server in $mcpConfig.mcp.PSObject.Properties) {
                Add-Member -InputObject $settings.mcp -MemberType NoteProperty -Name $server.Name -Value $server.Value -Force
            }
            Write-Host "[OK] MCP servers (format baru) berhasil di-merge ke settings.json" -ForegroundColor Green
        } elseif ($mcpConfig.PSObject.Properties.Name -contains "mcpServers") {
            # Format lama - gunakan key "mcpServers"
            if ($settings.PSObject.Properties.Name -notcontains "mcpServers") {
                Add-Member -InputObject $settings -MemberType NoteProperty -Name "mcpServers" -Value ([PSCustomObject]@{})
            }
            foreach ($server in $mcpConfig.mcpServers.PSObject.Properties) {
                Add-Member -InputObject $settings.mcpServers -MemberType NoteProperty -Name $server.Name -Value $server.Value -Force
            }
            Write-Host "[OK] MCP servers (format lama) berhasil di-merge ke settings.json" -ForegroundColor Green
        }

        $settings | ConvertTo-Json -Depth 10 | Set-Content $SettingsFile -Encoding UTF8
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

# 9. Handover.md Archive Cleanup (Auto-cleanup > 30 days)
Write-Host ""
Write-Host "[STEP 9] Handover.md Archive Cleanup" -ForegroundColor Yellow
$archiveDir = Join-Path $SourceDir ".archive"
if (Test-Path $archiveDir) {
    $oldArchives = Get-ChildItem $archiveDir -Filter "handover-*.md" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) }
    if ($oldArchives) {
        Write-Host "  Found $($oldArchives.Count) archives > 30 days"
        foreach ($archive in $oldArchives) {
            Remove-Item $archive.FullName -Force
            Write-Host "  Removed: $($archive.Name)" -ForegroundColor Gray
        }
        Write-Host "  ✅ Old archives cleaned" -ForegroundColor Green
    } else {
        Write-Host "  ✅ No old archives to clean" -ForegroundColor Gray
    }
} else {
    Write-Host "  ℹ️  No .archive folder found (skip)" -ForegroundColor Gray
}
