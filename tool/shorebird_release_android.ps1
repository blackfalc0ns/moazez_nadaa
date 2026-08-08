param(
    [ValidateSet("aab", "apk")]
    [string]$Artifact = "aab",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$driveRoot = [System.IO.Path]::GetPathRoot($projectRoot)
$env:PUB_CACHE = Join-Path $driveRoot "flutter_pub_cache"
New-Item -ItemType Directory -Force -Path $env:PUB_CACHE | Out-Null

Push-Location $projectRoot
try {
    $flutterInfo = flutter --version --machine | ConvertFrom-Json
    $flutterVersion = $flutterInfo.frameworkVersion

    $gradleWrapper = Join-Path $projectRoot "android\gradlew.bat"
    if (Test-Path $gradleWrapper) {
        & $gradleWrapper --stop
    }

    flutter clean
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    flutter pub get
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    $shorebirdArgs = @(
        "release",
        "android",
        "--artifact", $Artifact,
        "--flutter-version", $flutterVersion
    )
    if ($DryRun) { $shorebirdArgs += "--dry-run" }

    Write-Host "Building Shorebird Android release with Flutter $flutterVersion"
    shorebird @shorebirdArgs
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
finally {
    Pop-Location
}
