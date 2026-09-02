# cbm-hook.ps1 — Antigravity IDE Lifecycle Hook for codebase-memory daemon
# Ensures port 9749 is alive, returns valid JSON to stdout

$cbmExe = "C:\Users\GBC_PC\AppData\Local\Programs\codebase-memory-mcp\codebase-memory-mcp.exe"
$port = 9749

$isConnected = $false
$client = New-Object System.Net.Sockets.TcpClient
try {
    $ar = $client.BeginConnect("127.0.0.1", $port, $null, $null)
    if ($ar.AsyncWaitHandle.WaitOne(100, $false) -and $client.Connected) {
        $client.EndConnect($ar)
        $isConnected = $true
    }
} catch {
    $isConnected = $false
} finally {
    $client.Close()
}

if (-not $isConnected -and (Test-Path $cbmExe)) {
    try {
        Start-Process -FilePath $cbmExe -ArgumentList "daemon","start" -WindowStyle Hidden
    } catch {}
}

# Output valid JSON contract for Antigravity hook
Write-Output "{}"
