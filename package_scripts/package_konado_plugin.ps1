# Konado Plugin Packaging Script (PowerShell)
# Uses 7-Zip to compress addons/konado directory into versioned ZIP file

# Configuration parameters
$PluginName = "konado"                 # Plugin directory name (must match name in addons)
$ProjectRoot = $PSScriptRoot           # Script directory as project root
$AddonsPath = "$ProjectRoot\addons"    # Path to addons directory
$OutputDir = "$ProjectRoot\exports"    # Output directory for packages
$7zPath = "7z"                         # 7-Zip command (must be in PATH)

# Verify plugin directory exists
if (-not (Test-Path "$AddonsPath\$PluginName")) {
    Write-Error "Plugin directory '$PluginName' not found! Verify path: $AddonsPath\$PluginName"
    exit 1
}

# Create output directory
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

# Get version number
$VersionFile = "$AddonsPath\$PluginName\version_num.txt"
if (Test-Path $VersionFile) {
    $Version = Get-Content $VersionFile
    Write-Host "Version: $Version"
} else {
    Write-Warning "version_num.txt not found, using default: $Version"
    exit 1
}

# Generate package filename
$Timestamp = Get-Date -Format "yyyyMMdd-HHmm"
$ZipName = "${PluginName}_v${Version}_${Timestamp}.zip"
$ZipPath = "$OutputDir\$ZipName"

# Execute compression with 7-Zip
try {
    # Switch to addons directory for proper path structure
    Push-Location $AddonsPath

    # 7-Zip parameters:
    # a         Add files to archive
    # -tzip     Set archive type to ZIP
    # -r        Recurse subdirectories
    # -mx=9     Maximum compression level
    & $7zPath a -tzip $ZipPath "$PluginName\*" -r -mx=9

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Success! Package created: $ZipPath" -ForegroundColor Green
        Write-Host "File size:" (Get-Item $ZipPath).Length "bytes"
    } else {
        throw "7-Zip returned error code: $LASTEXITCODE"
    }
} catch {
    Write-Error "Compression failed: $_"
    exit 1
} finally {
    Pop-Location
}