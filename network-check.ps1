Clear-Host

function Write-Log {
    param(
        [switch]$NoNewline,
        [string]$Message
    )
    $now = Get-Date -UFormat '+%Y-%m-%d %H:%M:%S'
    if ($NoNewline) {
        Write-Host $("[{0}] {1}" -f $now, $Message) -NoNewline
    } else {
        Write-Host $("[{0}] {1}" -f $now, $Message)
    }
}

function NetworkOffline() {
    return !(Test-Connection "www.google.de" -Count 1 -Quiet)
}

function RestartNetwork() {
    Write-Log -Message "Restarting network adapter... " -NoNewline
    Restart-NetAdapter -Name "Ethernet"
    Write-Host "OK" -ForegroundColor Green
}

function Main() {
    Write-Log -Message "Starting regular network healthcheck"
    while($true) {
        Write-Log "Checking network... " -NoNewline
        if (NetworkOffline) {
            Write-Host "OFFLINE" -ForegroundColor Red
            RestartNetwork
        } else {
            Write-Host "ONLINE" -ForegroundColor Green
        }
        Start-Sleep -Seconds 120
    }
}

Main