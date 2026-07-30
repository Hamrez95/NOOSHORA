param(
  [ValidateSet('all','storefront','api','admin')]
  [string]$Component = 'all'
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot

function Assert-Command([string]$Name) {
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Required command '$Name' is not installed or not available in PATH."
  }
}

function Start-Terminal([string]$Title, [string]$WorkingDirectory, [string]$Command) {
  Write-Host "Starting $Title..." -ForegroundColor Green
  Start-Process powershell -WorkingDirectory $WorkingDirectory -ArgumentList @(
    '-NoExit',
    '-Command',
    "`$Host.UI.RawUI.WindowTitle='$Title'; $Command"
  )
}

if ($Component -in @('all','storefront')) {
  Assert-Command 'node'
  Assert-Command 'npm'
  $Path = Join-Path $Root 'apps/storefront'
  Start-Terminal 'NOOSHORA Storefront' $Path 'npm install; npm run dev'
}

if ($Component -in @('all','api')) {
  Assert-Command 'dotnet'
  $Path = Join-Path $Root 'services/api'
  Start-Terminal 'NOOSHORA API' $Path 'dotnet watch run'
}

if ($Component -in @('all','admin')) {
  Assert-Command 'flutter'
  $Path = Join-Path $Root 'apps/admin'
  if (-not (Test-Path (Join-Path $Path 'android'))) {
    Push-Location $Path
    try {
      flutter create --platforms=android,web --project-name nooshora_admin .
    }
    finally {
      Pop-Location
    }
  }
  Start-Terminal 'NOOSHORA Admin' $Path 'flutter pub get; flutter run -d chrome'
}

Write-Host 'NOOSHORA development processes have been launched.' -ForegroundColor Cyan
