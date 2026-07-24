<#
.SYNOPSIS
Session lifecycle hooks untuk OpenCode cross-memory.
Dipanggil oleh AI via MCP filesystem atau manual.
#>

param(
    [Parameter(Mandatory)]
    [ValidateSet('start', 'end', 'log-task', 'log-message')]
    [string]$Action,
    
    [Parameter(Mandatory)]
    [string]$ProjectSlug,
    
    [string]$Content = "",
    [string]$Role = "assistant",
    [string]$TaskName = ""
)

$memoryRoot = "G:\mymodel\opencode"
$projectPath = "$memoryRoot\projects\$ProjectSlug"
$timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ss+07:00"
$sessionFile = "$projectPath\session-$(Get-Date -Format 'yyyyMMdd-HHmmss').jsonl"

# Ensure project folder exists
if (-not (Test-Path $projectPath)) {
    New-Item -ItemType Directory -Path "$projectPath\logs" -Force | Out-Null
    New-Item -ItemType Directory -Path "$projectPath\scratch" -Force | Out-Null
    New-Item -ItemType Directory -Path "$projectPath\media" -Force | Out-Null
}

switch ($Action) {
    'start' {
        # Create new session file
        $entry = @{ type = "session_start"; timestamp = $timestamp; project = $ProjectSlug } | ConvertTo-Json -Compress
        $entry | Out-File $sessionFile -Encoding utf8 -Force
        
        # Update state.json
        $statePath = "$projectPath\state.json"
        if (Test-Path $statePath) {
            $state = Get-Content $statePath -Raw | ConvertFrom-Json
            $state.last_session = $timestamp
            $state.total_sessions = [int]$state.total_sessions + 1
            $state | ConvertTo-Json -Depth 5 | Out-File $statePath -Encoding utf8 -Force
        }
        
        Write-Output "[SESSION] Started for $ProjectSlug at $timestamp"
    }
    
    'end' {
        # Find latest session file and close it
        $latest = Get-ChildItem "$projectPath\session-*.jsonl" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($latest) {
            $entry = @{ type = "session_end"; timestamp = $timestamp } | ConvertTo-Json -Compress
            $entry | Add-Content $latest.FullName -Encoding utf8
        }
        
        # Update familiarity_level in state.json
        $statePath = "$projectPath\state.json"
        if (Test-Path $statePath) {
            $state = Get-Content $statePath -Raw | ConvertFrom-Json
            if ($state.persona -and $state.persona.PSObject.Properties['familiarity_level']) {
                # Increment via relationship, not persona directly
            }
            $state | ConvertTo-Json -Depth 5 | Out-File $statePath -Encoding utf8 -Force
        }
        
        Write-Output "[SESSION] Ended for $ProjectSlug at $timestamp"
    }
    
    'log-task' {
        $taskLog = "$projectPath\logs\task-log.jsonl"
        $entry = @{
            task = $TaskName
            status = "completed"
            timestamp = $timestamp
            details = $Content
        } | ConvertTo-Json -Compress
        $entry | Add-Content $taskLog -Encoding utf8
        
        Write-Output "[TASK] Logged: $TaskName"
    }
    
    'log-message' {
        $latest = Get-ChildItem "$projectPath\session-*.jsonl" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($latest) {
            $entry = @{ role = $Role; content = $Content; timestamp = $timestamp } | ConvertTo-Json -Compress
            $entry | Add-Content $latest.FullName -Encoding utf8
        }
    }
}
