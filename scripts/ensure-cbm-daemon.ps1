# ensure-cbm-daemon.ps1 — Ensure codebase-memory daemon is running on port 9749
param(
    [int]$Port = 9749,
    [string]$CbmExe = ""
)

if (-not $CbmExe) {
    $cmd = Get-Command "codebase-memory-mcp" -ErrorAction SilentlyContinue
    if ($cmd) {
        $CbmExe = $cmd.Source
    } else {
        $CbmExe = "$env:LOCALAPPDATA\Programs\codebase-memory-mcp\codebase-memory-mcp.exe"
    }
}

function Test-PortListening {
    param([string]$Server = "127.0.0.1", [int]$Port = 9749, [int]$TimeoutMs = 150)
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $ar = $client.BeginConnect($Server, $Port, $null, $null)
        $connected = $ar.AsyncWaitHandle.WaitOne($TimeoutMs, $false)
        if ($connected -and $client.Connected) {
            $client.EndConnect($ar)
            return $true
        }
        return $false
    } catch {
        return $false
    } finally {
        $client.Close()
    }
}

if (-not (Test-PortListening -Port $Port)) {
    if (Test-Path $CbmExe) {
        Start-Process -FilePath $CbmExe -ArgumentList "daemon","start" -WindowStyle Hidden
        Write-Host "[+] codebase-memory-mcp daemon started on port $Port" -ForegroundColor Green
    } else {
        Write-Warning "codebase-memory-mcp.exe not found at $CbmExe"
    }
} else {
    Write-Host "[OK] codebase-memory-mcp daemon already running on port $Port" -ForegroundColor DarkGray
}
