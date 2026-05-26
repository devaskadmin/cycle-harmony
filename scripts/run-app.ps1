param(
    [ValidateSet('auto', 'windows', 'android', 'web', 'ios', 'macos', 'linux')]
    [string]$Target = 'auto',

    [string]$DeviceId,

    [switch]$Setup,

    [switch]$Clean
)

$ErrorActionPreference = 'Stop'

function Write-Info {
    param([string]$Message)
    Write-Host "[cycle-harmony] $Message"
}

function Invoke-Flutter {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    & flutter @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "flutter $($Arguments -join ' ') failed with exit code $LASTEXITCODE"
    }
}

function Get-FlutterDevices {
    try {
        $json = & flutter devices --machine 2>$null | Out-String
        if ([string]::IsNullOrWhiteSpace($json)) {
            return @()
        }

        $devices = $json | ConvertFrom-Json
    }
    catch {
        Write-Info 'Device discovery failed; falling back to a browser target.'
        return @()
    }

    if ($devices -isnot [System.Array]) {
        return @($devices)
    }

    return @($devices)
}

function Select-Device {
    param(
        [object[]]$Devices,
        [string]$Target,
        [string]$DeviceId
    )

    if ($DeviceId) {
        return $Devices | Where-Object { $_.id -eq $DeviceId } | Select-Object -First 1
    }

    switch ($Target) {
        'windows' {
            return $Devices | Where-Object { $_.id -eq 'windows' -or $_.platformType -eq 'desktop' -or $_.name -match 'Windows' } | Select-Object -First 1
        }
        'android' {
            return $Devices | Where-Object { $_.platformType -eq 'android' -or $_.category -eq 'mobile' -or $_.name -match 'Android' } | Select-Object -First 1
        }
        'web' {
            return $Devices | Where-Object { $_.platformType -eq 'web' -or $_.category -eq 'web' -or $_.name -match 'Chrome|Edge' } | Select-Object -First 1
        }
        'ios' {
            return $Devices | Where-Object { $_.platformType -eq 'ios' -or $_.name -match 'iPhone|iPad' } | Select-Object -First 1
        }
        'macos' {
            return $Devices | Where-Object { $_.platformType -eq 'macos' -or $_.name -match 'macOS' } | Select-Object -First 1
        }
        'linux' {
            return $Devices | Where-Object { $_.platformType -eq 'linux' -or $_.name -match 'Linux' } | Select-Object -First 1
        }
        default {
            $device = $Devices | Where-Object { $_.id -eq 'windows' -or $_.platformType -eq 'desktop' } | Select-Object -First 1
            if ($device) { return $device }

            $device = $Devices | Where-Object { $_.platformType -eq 'android' -or $_.category -eq 'mobile' } | Select-Object -First 1
            if ($device) { return $device }

            $device = $Devices | Where-Object { $_.platformType -eq 'web' -or $_.category -eq 'web' } | Select-Object -First 1
            if ($device) { return $device }

            return $Devices | Select-Object -First 1
        }
    }
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectRoot = Resolve-Path (Join-Path $scriptRoot '..')
Set-Location $projectRoot

if (-not (Test-Path (Join-Path $projectRoot 'pubspec.yaml'))) {
    throw "This script must be run from inside a Flutter project folder. pubspec.yaml was not found at $projectRoot."
}

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    throw 'Flutter is not available on PATH. Install Flutter and restart PowerShell.'
}

if ($Setup) {
    Write-Info 'Running initial setup...'
    Invoke-Flutter -Arguments @('pub', 'get')
}
elseif (-not (Test-Path (Join-Path $projectRoot '.dart_tool/package_config.json'))) {
    Write-Info 'Project is not fully set up yet. Restoring packages...'
    Invoke-Flutter -Arguments @('pub', 'get')
}

if ($Clean) {
    Write-Info 'Cleaning project...'
    Invoke-Flutter -Arguments @('clean')
    Invoke-Flutter -Arguments @('pub', 'get')
}

if ($DeviceId) {
    $selectedDevice = [pscustomobject]@{
        id   = $DeviceId
        name = $DeviceId
    }
}
elseif ($Target -eq 'web') {
    $selectedDevice = [pscustomobject]@{
        id   = 'chrome'
        name = 'Chrome'
    }
}
else {
    $devices = Get-FlutterDevices
    $selectedDevice = Select-Device -Devices $devices -Target $Target -DeviceId $DeviceId
}

if (-not $selectedDevice) {
    throw "No Flutter device was found for target '$Target'. Start an emulator, connect a device, or pass -DeviceId."
}

Write-Info ("Launching on {0} ({1})" -f $selectedDevice.name, $selectedDevice.id)
Invoke-Flutter -Arguments @('run', '-d', $selectedDevice.id)
