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

# Create cross-memory structure on G: drive
$memoryRoot = "G:\mymodel\opencode"
$folders = @(
    "$memoryRoot\projects",
    "$memoryRoot\shared\error-solutions",
    "$memoryRoot\shared\stack-patterns",
    "$memoryRoot\shared\retrospectives",
    "$memoryRoot\cache"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
        Write-Host "[+] Membuat folder memory target: $folder" -ForegroundColor Green
    }
}

# Create memory index if not exists
$indexPath = "$memoryRoot\.memory-index.json"
if (-not (Test-Path $indexPath)) {
    @{
        version = "1.0.0"
        created = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss+07:00")
        last_updated = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss+07:00")
        projects = @()
        shared = @{
            error_solutions_count = 0
            stack_patterns_count = 0
            retrospectives_count = 0
        }
    } | ConvertTo-Json -Depth 5 | Out-File $indexPath -Encoding utf8
    Write-Host "[+] Membuat memory index di $indexPath" -ForegroundColor Green
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
        Write-Host "  [OK] Old archives cleaned" -ForegroundColor Green
    } else {
        Write-Host "  [OK] No old archives to clean" -ForegroundColor Gray
    }
} else {
    Write-Host "  [INFO] No .archive folder found (skip)" -ForegroundColor Gray
}

# 10. Sync Antigravity Knowledge (One-Way Bridge)
function Sync-AntigravityKnowledge {
    <#
    .SYNOPSIS
    One-way sync: Copy Antigravity IDE Knowledge Items → OpenCode shared/antigravity-bridge/
    NEVER writes to Antigravity IDE folders. Read-only bridge.
    #>
    $agKnowledgePath = "$env:USERPROFILE\.gemini\antigravity-ide\knowledge"
    $bridgePath = "G:\mymodel\opencode\shared\antigravity-bridge"
    
    if (-not (Test-Path $agKnowledgePath)) {
        Write-Output "[BRIDGE] Antigravity IDE knowledge not found. Skipping."
        return
    }
    
    # Ensure bridge folder exists
    if (-not (Test-Path $bridgePath)) {
        New-Item -ItemType Directory -Path $bridgePath -Force | Out-Null
    }
    
    # Scan Antigravity KI folders and merge artifacts into single MD per category
    $categories = @{
        "error-solutions"  = @()
        "vibes-stack-patterns" = @()
        "project-retrospectives" = @()
    }
    
    foreach ($kiFolder in (Get-ChildItem $agKnowledgePath -Directory)) {
        $artifactsPath = Join-Path $kiFolder.FullName "artifacts"
        if (Test-Path $artifactsPath) {
            foreach ($artifact in (Get-ChildItem $artifactsPath -Filter "*.md")) {
                $category = $kiFolder.Name
                if ($categories.ContainsKey($category)) {
                    $categories[$category] += $artifact.FullName
                }
            }
        }
    }
    
    # Write merged snapshots
    foreach ($cat in $categories.Keys) {
        $outFile = Join-Path $bridgePath "$cat.md"
        $content = "# Antigravity IDE Knowledge Bridge - $cat`n"
        $content += "# Auto-generated by sync.ps1 - DO NOT EDIT MANUALLY`n"
        $content += "# Last sync: $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ss+07:00')`n`n"
        
        foreach ($file in $categories[$cat]) {
            $content += "---`n## Source: $(Split-Path $file -Leaf)`n`n"
            $content += (Get-Content $file -Raw -ErrorAction SilentlyContinue)
            $content += "`n`n"
        }
        
        $content | Out-File $outFile -Encoding utf8 -Force
    }
    
    # Update knowledge index
    $indexPath = Join-Path (Split-Path $bridgePath) ".knowledge-index.json"
    @{
        version = "1.0.0"
        last_sync = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss+07:00")
        source = "antigravity-ide"
        source_path = $agKnowledgePath
        categories = @($categories.Keys)
        total_artifacts = ($categories.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
    } | ConvertTo-Json -Depth 3 | Out-File $indexPath -Encoding utf8 -Force
    
    Write-Output "[BRIDGE] Synced $($categories.Values.Count) categories from Antigravity IDE → $bridgePath"
}

Write-Host ""
Write-Host "[STEP 10] Sync Antigravity Knowledge (One-Way Bridge)" -ForegroundColor Yellow
Sync-AntigravityKnowledge

