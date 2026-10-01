# sync.ps1 — Brainvibes Auto-Sync Script
# Jalankan script ini untuk menyinkronkan file master dari drive D ke folder global AI di drive C.

$ErrorActionPreference = "Stop"

# Tentukan path sumber dan target
$SourceDir = $PSScriptRoot
$GeminiTargetDir = Join-Path $env:USERPROFILE ".gemini"
$KnowledgeTargetDir = Join-Path $GeminiTargetDir "antigravity-ide\knowledge"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   BRAINVIBES AUTO-SYNC SYSTEM           " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Sumber (Master) : $SourceDir"
Write-Host "Target (Gemini) : $GeminiTargetDir"
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



# 1. Salin berkas-berkas inti di root ke .gemini
$CoreFiles = @("gemini.md", "gemini-execution.md", "gemini-templates.md", "prd-template.md", "design-system.md", "AGENTS.md", "user-prefs.md")
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

# Pastikan GEMINI.md (UPPERCASE) tersedia
$DstGeminiUpper = Join-Path $GeminiTargetDir "GEMINI.md"
$DstGeminiLower = Join-Path $GeminiTargetDir "gemini.md"
if (Test-Path $DstGeminiLower) {
    try {
        Copy-Item -Path $DstGeminiLower -Destination $DstGeminiUpper -Force -ErrorAction Stop
    } catch {
        # File system case-insensitive (Windows NTFS) menganggap kedua file sama
    }
    Write-Host "[OK] Sinkronisasi alias GEMINI.md" -ForegroundColor Gray
}

# 1B. Salin berkas-berkas inti ke folder lokal Antigravity IDE & CLI jika ada
$IdeTargetDirs = @(
    (Join-Path $GeminiTargetDir "antigravity-ide"),
    (Join-Path $GeminiTargetDir "antigravity-cli")
)
foreach ($IdeDir in $IdeTargetDirs) {
    if (Test-Path $IdeDir) {
        foreach ($File in $CoreFiles) {
            $SrcFile = Join-Path $SourceDir $File
            $DstFile = Join-Path $IdeDir $File
            if (Test-Path $SrcFile) {
                Copy-Item -Path $SrcFile -Destination $DstFile -Force
                Write-Host "[OK] Sync IDE Local: $File -> $DstFile" -ForegroundColor Gray
            }
        }
        $McpSrc = Join-Path $SourceDir "config\mcp_config.json"
        if (Test-Path $McpSrc) {
            Copy-Item -Path $McpSrc -Destination (Join-Path $IdeDir "mcp_config.json") -Force
            Write-Host "[OK] Sync IDE Local: mcp_config.json -> $IdeDir\mcp_config.json" -ForegroundColor Gray
        }
    }
}

# 1C. Salin rules (anti-bloat-code dll) ke folder global rules & .agents/rules
$RulesTargetDir = Join-Path $GeminiTargetDir "config\rules"
$AgentsRulesTargetDir = Join-Path $GeminiTargetDir ".agents\rules"
if (!(Test-Path $RulesTargetDir)) { New-Item -ItemType Directory -Force -Path $RulesTargetDir | Out-Null }
if (!(Test-Path $AgentsRulesTargetDir)) { New-Item -ItemType Directory -Force -Path $AgentsRulesTargetDir | Out-Null }

$SrcRules = Join-Path $SourceDir "config\rules"
if (Test-Path $SrcRules) {
    Copy-Item -Path (Join-Path $SrcRules "*") -Destination $RulesTargetDir -Force -Recurse
    Write-Host "[OK] Sync Global Rules: config\rules -> $RulesTargetDir" -ForegroundColor Gray
}
$SrcAgentsRules = Join-Path $SourceDir ".agents\rules"
if (Test-Path $SrcAgentsRules) {
    Copy-Item -Path (Join-Path $SrcAgentsRules "*") -Destination $RulesTargetDir -Force -Recurse
    Copy-Item -Path (Join-Path $SrcAgentsRules "*") -Destination $AgentsRulesTargetDir -Force -Recurse
    Write-Host "[OK] Sync Workspace Rules: .agents\rules -> $RulesTargetDir & $AgentsRulesTargetDir" -ForegroundColor Gray
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
            # Sync: tambah/update server dari sumber
            foreach ($server in $mcpConfig.mcp.PSObject.Properties) {
                Add-Member -InputObject $settings.mcp -MemberType NoteProperty -Name $server.Name -Value $server.Value -Force
            }
            # Sync: hapus server yang tidak ada di sumber (true sync, bukan merge-only)
            $sourceNames = @($mcpConfig.mcp.PSObject.Properties.Name)
            $existingNames = @($settings.mcp.PSObject.Properties.Name)
            foreach ($existing in $existingNames) {
                if ($existing -notin $sourceNames) {
                    $settings.mcp.PSObject.Properties.Remove($existing)
                    Write-Host "  [REMOVED] MCP server '$existing' (tidak ada di mcp_config.json)" -ForegroundColor DarkYellow
                }
            }
            # Bersihkan blok format lama 'mcpServers' jika format baru 'mcp' aktif
            if ($settings.PSObject.Properties.Name -contains "mcpServers") {
                $settings.PSObject.Properties.Remove("mcpServers")
                Write-Host "  [CLEANED] Blok lama 'mcpServers' dibersihkan dari settings.json" -ForegroundColor Green
            }
            Write-Host "[OK] MCP servers (format baru) berhasil di-sync ke settings.json" -ForegroundColor Green
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

# 10. Codebase Memory Daemon & UI Auto-Start (Port 9749)
Write-Host ""
Write-Host "[STEP 10] codebase-memory-mcp Daemon & UI Server" -ForegroundColor Yellow
$ensureScript = Join-Path $SourceDir "scripts\ensure-cbm-daemon.ps1"
if (Test-Path $ensureScript) {
    & $ensureScript
} else {
    $cbmCmd = Get-Command "codebase-memory-mcp" -ErrorAction SilentlyContinue
    $cbmExe = if ($cbmCmd) { $cbmCmd.Source } else { "$env:LOCALAPPDATA\Programs\codebase-memory-mcp\codebase-memory-mcp.exe" }
    if (Test-Path $cbmExe) {
        Start-Process -FilePath $cbmExe -ArgumentList "daemon","start" -WindowStyle Hidden
        Write-Host "[+] codebase-memory-mcp daemon started on port 9749" -ForegroundColor Green
    }
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
        Write-Host "  [OK] Old archives cleaned" -ForegroundColor Green
    } else {
        Write-Host "  [OK] No old archives to clean" -ForegroundColor Gray
    }
} else {
    Write-Host "  [INFO] No .archive folder found (skip)" -ForegroundColor Gray
}



