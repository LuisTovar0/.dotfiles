# viking.ps1 - one-command launcher for OpenViking.
# Embeddings run on Voyage AI (API key in ov.conf or VOYAGE_API_KEY); the VLM
# uses the provider configured in ov.conf. Starts Ollama and pulls models only
# when local models are selected, then starts the OpenViking server in the
# foreground (Ctrl+C to stop).
$ErrorActionPreference = 'Stop'

$env:OPENVIKING_CONFIG_FILE = Join-Path $HOME '.openviking\ov.conf'
$OllamaApi  = 'http://127.0.0.1:11434'

# If ov.conf references VOYAGE_API_KEY, pick up the saved key even when this script
# runs in a session whose environment predates `setx VOYAGE_API_KEY ...`.
if (-not $env:VOYAGE_API_KEY) {
    $env:VOYAGE_API_KEY = [Environment]::GetEnvironmentVariable('VOYAGE_API_KEY', 'User')
}


# Start Ollama only when a configured model actually uses it.
$ServerConfig = Get-Content -LiteralPath $env:OPENVIKING_CONFIG_FILE -Raw | ConvertFrom-Json
$OllamaModels = @()
if ($ServerConfig.embedding.dense.provider -eq 'ollama') {
    $OllamaModels += $ServerConfig.embedding.dense.model
}
if ($ServerConfig.vlm.model -like 'ollama/*') {
    $OllamaModels += $ServerConfig.vlm.model.Substring(7)
}
if ($OllamaModels.Count -gt 0) {
    # Resolve the ollama binary from PATH, falling back to the default install dir.
    $Ollama = (Get-Command ollama -ErrorAction SilentlyContinue).Source
    if (-not $Ollama) {
        $fallback = Join-Path $env:LOCALAPPDATA 'Programs\Ollama\ollama.exe'
        if (Test-Path $fallback) { $Ollama = $fallback }
    }
    if (-not $Ollama) { Write-Error "Could not find 'ollama'. Install Ollama, then re-run."; exit 1 }

    function Test-Ollama {
        try { Invoke-RestMethod -Uri "$OllamaApi/api/tags" -TimeoutSec 3 | Out-Null; return $true }
        catch { return $false }
    }

    # 1. Ensure the Ollama daemon is up (start it if the desktop service isn't).
    if (-not (Test-Ollama)) {
        Write-Host '[viking] Starting Ollama daemon...' -ForegroundColor Cyan
        Start-Process -WindowStyle Hidden -FilePath $Ollama -ArgumentList 'serve' | Out-Null
        for ($i = 0; $i -lt 40 -and -not (Test-Ollama); $i++) { Start-Sleep -Milliseconds 500 }
        if (-not (Test-Ollama)) { Write-Error '[viking] Ollama did not become ready on :11434.'; exit 1 }
    }
    Write-Host '[viking] Ollama is running.' -ForegroundColor Green

    # 2. Ensure the VLM model is present (idempotent; pulls only what's missing).
    $installed = (& $Ollama list | Out-String)
    foreach ($m in $OllamaModels) {
        if ($installed -notmatch [regex]::Escape($m)) {
            Write-Host "[viking] Pulling $m (first run only)..." -ForegroundColor Cyan
            & $Ollama pull $m
        } else {
            Write-Host "[viking] Model present: $m" -ForegroundColor Green
        }
    }
} else {
    Write-Host '[viking] Models use remote APIs; Ollama is not needed.' -ForegroundColor Green
}

# 2.5. Clear a stale data-directory lock.
# openviking's process_lock only detects PID reuse on Linux (/proc/cmdline).
# On Windows, a killed run leaves .openviking.pid behind and the recycled PID
# can belong to any unrelated process, which makes the server abort with
# DataDirectoryLocked even though nothing is holding the directory.
$LockFile = $null
try {
    $Ws = (Get-Content -LiteralPath $env:OPENVIKING_CONFIG_FILE -Raw | ConvertFrom-Json).storage.workspace
    if ($Ws) { $LockFile = Join-Path $Ws '.openviking.pid' }
} catch { }

if ($LockFile -and (Test-Path -LiteralPath $LockFile)) {
    $LockPid = 0
    try { $LockPid = [int]((Get-Content -LiteralPath $LockFile -Raw).Trim()) } catch { }
    $Holder = if ($LockPid -gt 0) { Get-Process -Id $LockPid -ErrorAction SilentlyContinue } else { $null }
    $HolderName = if ($Holder) { $Holder.ProcessName } else { $null }
    $HolderIsViking = $HolderName -and ($HolderName -like 'openviking*' -or $HolderName -like 'python*' -or $HolderName -eq 'uv' -or $HolderName -eq 'uvx')

    if ($HolderIsViking) {
        # A real second instance: leave the lock so openviking reports it clearly.
        Write-Host "[viking] Data directory already in use by PID $LockPid ($HolderName)." -ForegroundColor Yellow
    } else {
        $Why = if ($Holder) { "PID $LockPid belongs to '$HolderName'" } else { "PID $LockPid is not running" }
        Write-Host "[viking] Removing stale data-dir lock ($Why)." -ForegroundColor Yellow
        Remove-Item -LiteralPath $LockFile -Force
    }
}

# 3. Run the OpenViking server (foreground; serves on 127.0.0.1:1933).
Write-Host '[viking] Starting OpenViking server on http://127.0.0.1:1933 ...' -ForegroundColor Cyan
& openviking-server
