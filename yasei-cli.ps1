#!/usr/bin/env pwsh
# ============================================================
# Yasei-2 CLI Coding Agent Subsistem
# Usage: yasei
# ============================================================

param(
    [string]$BaseUrl = "https://hinata.idihore.id/llm/v1/chat/completions",
    [string]$Model = "Yasei-2",
    [int]$MaxTokens = 16384,
    [switch]$ShowThinking
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Set lokasi project aktif
$projectDir = Get-Location
$userProfileDir = [System.Environment]::GetFolderPath('UserProfile')

# Validasi Path Traversal Protection
function Test-SafePath {
    param(
        [string]$Path
    )
    try {
        $joined = Join-Path $projectDir $Path
        $fullPath = [System.IO.Path]::GetFullPath($joined)
        $projectFullPath = [System.IO.Path]::GetFullPath($projectDir)
        return $fullPath.StartsWith($projectFullPath)
    }
    catch {
        return $false
    }
}

# Conversation History Pruning
function Invoke-HistoryPruning {
    param(
        [System.Collections.ArrayList]$History,
        [int]$MaxChars = 80000 # ~20.000 token
    )
    $totalChars = 0
    foreach ($msg in $History) {
        if ($msg.content) {
            $totalChars += $msg.content.Length
        }
    }

    if ($totalChars -gt $MaxChars) {
        Write-Host "  [CONTEXT] Memangkas riwayat percakapan lama agar menghemat kapasitas token..." -ForegroundColor DarkYellow
        while ($totalChars -gt $MaxChars -and $History.Count -gt 2) {
            $removedMsg = $History[1]
            if ($removedMsg.content) {
                $totalChars -= $removedMsg.content.Length
            }
            $History.RemoveAt(1)
        }
    }
}

# Membaca section dari berkas markdown berdasarkan nama section
function Get-MarkdownSection {
    param(
        [string]$FilePath,
        [string]$SectionPattern
    )
    if (-not (Test-Path $FilePath)) { return "" }
    $content = Get-Content $FilePath
    $sectionLines = @()
    $capture = $false
    
    foreach ($line in $content) {
        if ($line -match "^#+\s+(.+)$") {
            $headerTitle = $Matches[1].Trim()
            if ($headerTitle -match $SectionPattern) {
                $capture = $true
                $sectionLines += $line
                continue
            }
            elseif ($capture) {
                $capture = $false
                break
            }
        }
        if ($capture) {
            $sectionLines += $line
        }
    }
    return $sectionLines -join "`n"
}

# Memuat context on-demand dari gemini-templates.md dan gemini-execution.md
function Get-OnDemandContext {
    param(
        [string]$InputText
    )
    $extraContext = ""
    $templatesPath = Join-Path $userProfileDir ".gemini\gemini-templates.md"
    $executionPath = Join-Path $userProfileDir ".gemini\gemini-execution.md"

    # GAP-004: Deteksi Saklar Utama
    if ($InputText -match "^awal baru$|^buat proyek baru$") {
        $section = Get-MarkdownSection -FilePath $templatesPath -SectionPattern "2A.*awal baru"
        if ($section) { $extraContext += "`n### PROTOKOL WIZARD INTI (awal baru):`n$section" }
    }
    elseif ($InputText -match "^awal lanjut$") {
        $section = Get-MarkdownSection -FilePath $templatesPath -SectionPattern "2B.*awal lanjut"
        if ($section) { $extraContext += "`n### PROTOKOL STATE RESTORING (awal lanjut):`n$section" }
    }
    elseif ($InputText -match "^awal konversi$") {
        $section = Get-MarkdownSection -FilePath $templatesPath -SectionPattern "2C.*awal konversi"
        if ($section) { $extraContext += "`n### PROTOKOL RE-PLATFORMING (awal konversi):`n$section" }
    }
    elseif ($InputText -match "^baca error$|^error$|^debug$") {
        $section = Get-MarkdownSection -FilePath $templatesPath -SectionPattern "5.*YOLO"
        if ($section) { $extraContext += "`n### PROTOKOL DEBUGGING (baca error):`n$section" }
    }
    elseif ($InputText -match "^tambah fitur$") {
        $section = Get-MarkdownSection -FilePath $templatesPath -SectionPattern "2D.*tambah fitur"
        if ($section) { $extraContext += "`n### PROTOKOL INCREMENTAL FEATURE (tambah fitur):`n$section" }
    }

    # GAP-005: Deteksi coding task (on-demand loading dari gemini-execution.md)
    if ($InputText -match "buat|tambah|edit|fix|refactor|koding|css|form|middleware|auth|database|sql") {
        # Ambil panduan standard coding dan visual CSS
        $execRules = Get-MarkdownSection -FilePath $executionPath -SectionPattern "4.*Standard|Coding|CSS|Estetika"
        if ($execRules) {
            $extraContext += "`n### STANDAR EKSEKUSI KODE & ARSITEKTUR:`n$execRules"
        }
    }

    return $extraContext
}

# Parse user-prefs.md (INI parser sederhana)
function Get-UserPrefs {
    $prefsPath = Join-Path $userProfileDir ".gemini\user-prefs.md"
    $prefs = @{}
    if (Test-Path $prefsPath) {
        $content = Get-Content $prefsPath
        $currentSection = "GLOBAL"
        foreach ($line in $content) {
            $line = $line.Trim()
            if ($line -match "^\[(.+)\]") {
                $currentSection = $Matches[1].ToUpper()
            }
            elseif ($line -match "^([^=#]+)\s*=\s*([^#]+)") {
                $key = $Matches[1].Trim()
                $val = $Matches[2].Trim()
                $prefs["$currentSection`:$key"] = $val
            }
        }
    }
    return $prefs
}

# Load global brainvibes rules (gemini.md) jika ada
function Get-BrainvibesRules {
    $rulesPath = Join-Path $userProfileDir ".gemini\gemini.md"
    if (Test-Path $rulesPath) {
        return "`n### BRAINVIBES GLOBAL SYSTEM INSTRUCTIONS (gemini.md):`n" + (Get-Content $rulesPath -Raw)
    }
    return ""
}

# Ambil metadata & info project
$prefs = Get-UserPrefs
$userLanguage = if ($prefs["IDENTITY:user_language"]) { $prefs["IDENTITY:user_language"] } else { "id-ID" }
$antiSlop = if ($prefs["AI_BEHAVIOR:anti_slop_mode"]) { $prefs["AI_BEHAVIOR:anti_slop_mode"] } else { "HARD" }

# Load local context (app-context.md / prd.md) jika ada
$localContext = ""
$appContextPath = Join-Path $projectDir "app-context.md"
$prdPath = Join-Path $projectDir "prd.md"

if (Test-Path $appContextPath) {
    $localContext = "### Project App-Context:`n" + (Get-Content $appContextPath -Raw)
}
elseif (Test-Path $prdPath) {
    $localContext = "### Project PRD:`n" + (Get-Content $prdPath -Raw)
}

$brainvibesRules = Get-BrainvibesRules

# Scan list file di working directory (exclude node_modules, vendor, .git, .legacy)
function Get-ProjectFileList {
    $files = Get-ChildItem -Path $projectDir -Recurse -File | 
        Where-Object { 
            $_.FullName -notmatch "\\node_modules\\" -and 
            $_.FullName -notmatch "\\vendor\\" -and 
            $_.FullName -notmatch "\\\.git\\" -and
            $_.FullName -notmatch "\\\.legacy\\"
        }
    
    $fileList = @()
    foreach ($file in $files) {
        $relativePath = Resolve-Path -Path $file.FullName -Relative
        # Hapus prefix .\
        $relativePath = $relativePath.Substring(2)
        $fileList += "- $relativePath ($($file.Length) bytes)"
    }
    return $fileList -join "`n"
}

$projectFiles = Get-ProjectFileList

# --- Banner ---
function Write-Banner {
    Write-Host ""
    Write-Host "  =======================================================" -ForegroundColor Cyan
    Write-Host "  |             🧠 YASEI-2 AGENTIC CLI                  |" -ForegroundColor Cyan
    Write-Host "  |         Subsistem Coding & File Operations          |" -ForegroundColor Cyan
    Write-Host "  =======================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Direktori Aktif: $projectDir" -ForegroundColor DarkYellow
    Write-Host "  Preferensi User: Bahasa = $userLanguage | Anti-Slop = $antiSlop" -ForegroundColor DarkYellow
    Write-Host "  Ketik /help untuk list command." -ForegroundColor DarkGray
    Write-Host "  -------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host ""
}

# System Prompt untuk Agentic Coding Loop
$systemPrompt = @"
Anda adalah Yasei-2, asisten coding AI bertaraf profesional dan mandiri yang terintegrasi di terminal lokal.
Bahasa interaksi utama dengan pengguna: Indonesian (Bahasa Indonesia).
Bahasa penulisan kode/teknis: English (Bahasa Inggris).

Direktori proyek aktif saat ini adalah: $projectDir
Berikut adalah daftar berkas yang ada di direktori proyek saat ini:
$projectFiles

$localContext

$brainvibesRules

Sebagai agen coding, Anda memiliki kemampuan untuk berinteraksi langsung dengan berkas di sistem pengguna menggunakan protokol tag berikut. Gunakan tag ini persis seperti yang dijelaskan:

1. MEMBACA BERKAS:
   Keluarkan tag ini untuk membaca isi sebuah berkas:
   [READ_FILE:path/to/file.ext]
   Tunggu hingga sistem membalas dengan isi berkas tersebut sebelum Anda melanjutkan analisis atau menulis kode.

2. MENULIS / EDIT BERKAS:
   Keluarkan tag ini untuk menulis atau menimpa isi sebuah berkas baru atau yang sudah ada:
   [WRITE_FILE:path/to/file.ext]
   <tuliskan seluruh isi berkas di sini secara lengkap tanpa pemotongan>
   [END_WRITE]
   Sistem akan menulis berkas tersebut secara lokal dan mengembalikan status penulisan kepada Anda.

3. LIST FILE DARI SUBDIREKTORI:
   Keluarkan tag ini jika Anda ingin melihat file/folder di dalam folder tertentu:
   [LIST_DIR:path/to/directory]

ATURAN PENTING:
- JANGAN memotong kode dengan komentar seperti "// kode lainnya...". Selalu tulis kode secara lengkap saat menggunakan WRITE_FILE.
- WAJIB TULIS STATUS PROGRES: Anda dilarang memberikan respons kosong atau hanya berisi tag aksi saja. Setiap kali Anda memicu aksi (seperti [READ_FILE:...] atau [LIST_DIR:...]), Anda WAJIB menyertakan minimal 1-2 kalimat teks penjelasan biasa di luar tag tersebut untuk memberi tahu pengguna apa yang sedang Anda lakukan (contoh: "Saya akan membaca routes/web.php terlebih dahulu untuk memetakan rute autentikasi.").
- PROTOKOL SAKLAR "ANALISA KEAMANAN" / "SCAN KEAMANAN":
  Jika pengguna meminta "analisa keamanan" atau "scan keamanan", Anda harus:
  1. Lakukan Static Analysis (SAST) 6 Lapisan secara mendalam terhadap kode utama (routes, middleware, controllers, models).
  2. Gunakan tag [READ_FILE:path] untuk membaca file-file utama tersebut secara bergantian terlebih dahulu.
  3. Setelah selesai membaca, Anda WAJIB membuat/menulis laporan audit lengkap ke berkas ".docs/security-audit.md" menggunakan tag [WRITE_FILE:.docs/security-audit.md]...[END_WRITE].
  4. Laporan ".docs/security-audit.md" WAJIB menggunakan format berikut:
     # Security Audit -- [Nama Proyek]
     | Parameter | Nilai | (Tanggal, Stack, Scan Mode, Total File, Auditor)
     ## Ringkasan Temuan (Tabel Severity CRITICAL/HIGH/MEDIUM/INFO, Jumlah, Status)
     ## 🔴 CRITICAL -- Vulnerability Aktif (Harus Fix SEBELUM Deploy)
        ### [VULN-NNN] [Judul] (Klasifikasi OWASP, Lokasi Presisi File & Baris, Kode Rentan, Vektor Serangan, Proof of Concept, Rekomendasi Fix, Dependency Map, Status)
     ## 🟠 HIGH -- Risiko Signifikan (Format sama dengan CRITICAL)
     ## 🟡 MEDIUM -- Best Practice Violation (Lokasi, Kategori, Temuan, Rekomendasi, Status)
     ## ℹ️ INFO -- Saran Hardening (Daftar checklist saran + File target)
     ## Log Perbaikan (Tabel VULN-ID, Tanggal Fix, File Diubah, Verifikasi)
  5. Setelah berkas laporan berhasil ditulis ke disk, tampilkan ringkasan temuan dan rencana mitigasi ke konsol obrolan untuk memberi tahu pengguna.
- Hanya lakukan satu aksi per giliran (misalnya: jika membaca berkas, jangan langsung menulis berkas sebelum sistem mengembalikan isi berkas yang dibaca).
- Jika tugas selesai, sampaikan konfirmasi ringkas dan tanyakan langkah selanjutnya kepada pengguna.
- Patuhi aturan VISUAL GATE: Gunakan CSS token modern, jangan hardcode hex warna, gunakan pairing 2 font, dan terapkan grid 8pt.
"@

# Helper API Call dengan Retry Logic
function Send-ChatRequest {
    param(
        [array]$Messages,
        [string]$ApiUrl,
        [string]$ModelName,
        [int]$Tokens
    )

    $body = @{
        model      = $ModelName
        messages   = $Messages
        max_tokens = $Tokens
    } | ConvertTo-Json -Depth 10

    $maxRetries = 2
    $retryCount = 0
    $success = $false
    $response = $null

    while (-not $success -and $retryCount -le $maxRetries) {
        try {
            $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($body)
            $response = Invoke-RestMethod -Uri $ApiUrl -Method Post -ContentType "application/json; charset=utf-8" -Body $bodyBytes -TimeoutSec 180
            $success = $true
        }
        catch {
            $retryCount++
            if ($retryCount -le $maxRetries) {
                Write-Host "  [WARNING] Gagal menghubungi API ($($_.Exception.Message)). Mencoba ulang ($retryCount/$maxRetries) dalam 3 detik..." -ForegroundColor Yellow
                Start-Sleep -Seconds 3
            } else {
                Write-Host "  [ERROR] Gagal menghubungi API setelah $maxRetries kali percobaan: $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }

    return $response
}

# --- Main Runtime ---
Write-Banner

$conversationHistory = [System.Collections.ArrayList]::new()
$null = $conversationHistory.Add(@{ role = "system"; content = $systemPrompt })
$showThinkingMode = $ShowThinking.IsPresent

while ($true) {
    Write-Host "  Kamu" -ForegroundColor Green -NoNewline
    Write-Host " > " -ForegroundColor DarkGray -NoNewline
    $userInput = Read-Host

    if ([string]::IsNullOrWhiteSpace($userInput)) { continue }

    # --- Slash Commands ---
    $trimmed = $userInput.Trim()

    if ($trimmed -match "^/quit$|^/exit$|^/q$") {
        Write-Host "`n  Sampai jumpa!" -ForegroundColor Cyan
        return
    }
    if ($trimmed -eq "/clear") {
        $conversationHistory.Clear()
        $null = $conversationHistory.Add(@{ role = "system"; content = $systemPrompt })
        Write-Host "  [RESET] Percakapan direset." -ForegroundColor Yellow
        Write-Host ""
        continue
    }
    if ($trimmed -eq "/thinking") {
        $showThinkingMode = -not $showThinkingMode
        Write-Host "  [THINKING] Mode: $(if ($showThinkingMode) { 'ON' } else { 'OFF' })" -ForegroundColor Yellow
        Write-Host ""
        continue
    }
    if ($trimmed -eq "/files") {
        Write-Host "  --- Daftar Berkas Proyek Aktif ---" -ForegroundColor DarkYellow
        Write-Host (Get-ProjectFileList) -ForegroundColor White
        Write-Host ""
        continue
    }
    if ($trimmed -eq "/help") {
        Write-Banner
        continue
    }

    # --- Jalankan User Prompt ---
    # GAP-004 & GAP-005: Dapatkan konteks on-demand berdasarkan input
    $onDemandContext = Get-OnDemandContext -InputText $userInput
    if (-not [string]::IsNullOrWhiteSpace($onDemandContext)) {
        $null = $conversationHistory.Add(@{ role = "system"; content = $onDemandContext })
    }

    $null = $conversationHistory.Add(@{ role = "user"; content = $userInput })
    $keepThinking = $true

    while ($keepThinking) {
        # GAP-002: Pruning history sebelum API call
        Invoke-HistoryPruning -History $conversationHistory

        Write-Host "  [WAIT] Yasei-2 sedang memproses..." -ForegroundColor DarkGray

        $response = Send-ChatRequest -Messages $conversationHistory -ApiUrl $BaseUrl -ModelName $Model -Tokens $MaxTokens

        if ($null -eq $response) {
            $keepThinking = $false
            continue
        }

        $choice = $response.choices[0]
        $assistantContent = $choice.message.content
        $reasoningContent = $choice.message.reasoning_content
        $finishReason = $choice.finish_reason

        # Tampilkan thinking jika aktif
        if ($showThinkingMode -and (-not [string]::IsNullOrWhiteSpace($reasoningContent))) {
            Write-Host ""
            Write-Host "  +-- THINKING --------------------------------" -ForegroundColor DarkMagenta
            $reasoningContent -split "`n" | ForEach-Object {
                Write-Host "  | $_" -ForegroundColor DarkMagenta
            }
            Write-Host "  +--------------------------------------------" -ForegroundColor DarkMagenta
        }

        # Simpan response asisten ke history
        $null = $conversationHistory.Add(@{ role = "assistant"; content = $assistantContent })

        # Tampilkan teks penjelasan asisten (jika ada) sebelum memproses aksi
        if (-not [string]::IsNullOrWhiteSpace($assistantContent)) {
            $cleanContent = $assistantContent -replace "\[READ_FILE:[^\]]+\]", ""
            $cleanContent = $cleanContent -replace "(?s)\[WRITE_FILE:[^\]]+\].*?\[END_WRITE\]", ""
            $cleanContent = $cleanContent -replace "\[LIST_DIR:[^\]]+\]", ""
            if (-not [string]::IsNullOrWhiteSpace($cleanContent)) {
                Write-Host ""
                Write-Host "  Yasei-2" -ForegroundColor Cyan -NoNewline
                Write-Host " > " -ForegroundColor DarkGray -NoNewline
                Write-Host $cleanContent.Trim() -ForegroundColor White
            }
        }

        # --- Cek Aksi Agentic ---
        $actionDetected = $false

        # 1. READ_FILE detection: [READ_FILE:path]
        if ($assistantContent -match "\[READ_FILE:([^\]\s]+)\]") {
            $targetPath = $Matches[1]
            
            Write-Host ""
            Write-Host "  [AGENT ACTION] Membaca berkas: $targetPath" -ForegroundColor Yellow

            # GAP-001: Path Traversal Protection
            if (Test-SafePath -Path $targetPath) {
                $fullPath = Join-Path $projectDir $targetPath
                $fileData = ""
                if (Test-Path $fullPath) {
                    try {
                        $fileData = Get-Content $fullPath -Raw
                        Write-Host "  [SUCCESS] Berkas berhasil dibaca." -ForegroundColor Green
                        $systemFeedback = "BERKAS BERHASIL DIBACA (${targetPath}):`n`n$fileData"
                    }
                    catch {
                        Write-Host "  [ERROR] Gagal membaca berkas." -ForegroundColor Red
                        $systemFeedback = "ERROR: Gagal membaca berkas ${targetPath}. $($_.Exception.Message)"
                    }
                } else {
                    Write-Host "  [ERROR] Berkas tidak ditemukan." -ForegroundColor Red
                    $systemFeedback = "ERROR: Berkas ${targetPath} tidak ditemukan."
                }
            } else {
                Write-Host "  [SECURITY BLOCK] Deteksi Path Traversal! Akses ditolak." -ForegroundColor Red
                $systemFeedback = "ERROR: Path Traversal terdeteksi! Anda dilarang mengakses berkas di luar direktori proyek."
            }

            # Masukkan hasil pembacaan ke history dan loop request otomatis
            $null = $conversationHistory.Add(@{ role = "user"; content = $systemFeedback })
            $actionDetected = $true
        }

        # 2. WRITE_FILE detection: [WRITE_FILE:path] ... [END_WRITE] (Line-by-line parser)
        elseif ($assistantContent -match "\[WRITE_FILE:([^\]\s]+)\]") {
            $targetPath = $Matches[1]
            
            Write-Host ""
            Write-Host "  [AGENT ACTION] Menulis berkas: $targetPath" -ForegroundColor Yellow

            # GAP-001: Path Traversal Protection
            if (Test-SafePath -Path $targetPath) {
                # GAP-006: Ekstrak konten baris demi baris demi keandalan markdown block
                $lines = $assistantContent -split "`n"
                $fileContentLines = @()
                $captureContent = $false
                foreach ($line in $lines) {
                    $trimmedLine = $line.Trim()
                    if ($trimmedLine -match "\[WRITE_FILE:$([regex]::Escape($targetPath))\]") {
                        $captureContent = $true
                        continue
                    }
                    if ($trimmedLine -match "\[END_WRITE\]") {
                        $captureContent = $false
                        break
                    }
                    if ($captureContent) {
                        $fileContentLines += $line
                    }
                }
                $fileContent = $fileContentLines -join "`n"
                $fileContent = $fileContent.Trim()
                $fullPath = Join-Path $projectDir $targetPath

                try {
                    # Pastikan direktori target ada
                    $parentDir = Split-Path $fullPath
                    if (-not (Test-Path $parentDir)) {
                        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
                    }

                    [System.IO.File]::WriteAllText($fullPath, $fileContent, [System.Text.Encoding]::UTF8)
                    Write-Host "  [SUCCESS] Berkas berhasil ditulis." -ForegroundColor Green
                    $systemFeedback = "BERKAS BERHASIL DITULIS: Berkas ${targetPath} telah disimpan."
                }
                catch {
                    Write-Host "  [ERROR] Gagal menulis berkas." -ForegroundColor Red
                    $systemFeedback = "ERROR: Gagal menulis berkas ${targetPath}. $($_.Exception.Message)"
                }
            } else {
                Write-Host "  [SECURITY BLOCK] Deteksi Path Traversal! Akses ditolak." -ForegroundColor Red
                $systemFeedback = "ERROR: Path Traversal terdeteksi! Anda dilarang menulis berkas di luar direktori proyek."
            }

            # Masukkan feedback ke history dan trigger API call lagi
            $null = $conversationHistory.Add(@{ role = "user"; content = $systemFeedback })
            $actionDetected = $true
        }

        # 3. LIST_DIR detection: [LIST_DIR:path]
        elseif ($assistantContent -match "\[LIST_DIR:([^\]\s]+)\]") {
            $targetPath = $Matches[1]

            Write-Host ""
            Write-Host "  [AGENT ACTION] Listing direktori: $targetPath" -ForegroundColor Yellow

            # GAP-001: Path Traversal Protection
            if (Test-SafePath -Path $targetPath) {
                $fullPath = Join-Path $projectDir $targetPath
                if (Test-Path $fullPath) {
                    try {
                        $items = Get-ChildItem -Path $fullPath | Select-Object Name, Length, @{Name="Type";Expression={if($_.PSIsContainer){"Directory"}else{"File"}}}
                        $listStr = ""
                        foreach ($item in $items) {
                            $listStr += "- $($item.Name) ($($item.Type)) - $($item.Length) bytes`n"
                        }
                        Write-Host "  [SUCCESS] Listing berhasil." -ForegroundColor Green
                        $systemFeedback = "LISTING DIREKTORI ${targetPath}:`n`n$listStr"
                    }
                    catch {
                        Write-Host "  [ERROR] Gagal listing direktori." -ForegroundColor Red
                        $systemFeedback = "ERROR: Gagal melist direktori ${targetPath}. $($_.Exception.Message)"
                    }
                } else {
                    Write-Host "  [ERROR] Direktori tidak ditemukan." -ForegroundColor Red
                    $systemFeedback = "ERROR: Direktori ${targetPath} tidak ditemukan."
                }
            } else {
                Write-Host "  [SECURITY BLOCK] Deteksi Path Traversal! Akses ditolak." -ForegroundColor Red
                $systemFeedback = "ERROR: Path Traversal terdeteksi! Anda dilarang melist direktori di luar direktori proyek."
            }

            $null = $conversationHistory.Add(@{ role = "user"; content = $systemFeedback })
            $actionDetected = $true
        }

        # Jika ada aksi agentic, loop dilanjutkan secara otomatis tanpa minta input user
        if (-not $actionDetected) {
            # Jika respon benar-benar kosong dari content dan reasoning, beri tahu user
            if ([string]::IsNullOrWhiteSpace($assistantContent) -and [string]::IsNullOrWhiteSpace($reasoningContent)) {
                Write-Host ""
                Write-Host "  Yasei-2" -ForegroundColor Cyan -NoNewline
                Write-Host " > " -ForegroundColor DarkGray -NoNewline
                Write-Host "[Tidak ada respons tertulis dari model]" -ForegroundColor DarkYellow
            }
            
            if ($response.usage) {
                $used = $response.usage.total_tokens
                Write-Host ""
                Write-Host "  [TOKENS] Total token percakapan: $used" -ForegroundColor DarkGray
            }

            # Selesai berpikir, tunggu input user baru
            $keepThinking = $false
        }
    }

    Write-Host ""
    Write-Host "  -----------------------------------------" -ForegroundColor DarkGray
    Write-Host ""
}
