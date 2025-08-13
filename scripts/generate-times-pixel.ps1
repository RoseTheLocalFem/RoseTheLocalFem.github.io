<#
.SYNOPSIS
  Generate pixel-style Times New Roman webfonts (WOFF/WOFF2) for this site.

.DESCRIPTION
  Uses FontForge (headless) + optional potrace (if configured in FontForge) to autotrace
  and export four faces as WOFF/WOFF2 for assets/fonts/TimesPixel-*. The CSS is already
  wired to use these when present. Pixel Mode is ON by default on the site.

.NOTES
  Licensing: Do NOT commit proprietary fonts. If you use system Times New Roman, ensure
  your usage complies with its license (generally not permitted for web embedding).
  Prefer open fonts like Liberation Serif or TeX Gyre Termes. This script supports both.

.PARAMETER SourceDir
  Folder containing source TTFs. If omitted and -UseSystemTimes is set, tries Windows fonts.

.PARAMETER UseSystemTimes
  Attempt to locate Times New Roman on this Windows machine (personal/local use only).

.PARAMETER OutDir
  Output folder for generated WOFF/WOFF2. Default: assets/fonts

.EXAMPLE
  # Using open fonts in ./vendor-fonts (LiberationSerif-*.ttf)
  ./scripts/generate-times-pixel.ps1 -SourceDir ./vendor-fonts

.EXAMPLE
  # Attempt system Times New Roman (local use). Do not commit outputs.
  ./scripts/generate-times-pixel.ps1 -UseSystemTimes
#>

param(
  [string]$SourceDir = "",
  [switch]$UseSystemTimes,
  [string]$OutDir = "assets/fonts"
)

function Fail($msg){ Write-Error $msg; exit 1 }

# Ensure FontForge is available
$ff = "fontforge"
try {
  $null = & $ff -version 2>$null
} catch {
  Fail "FontForge not found. Install it and ensure 'fontforge' is on PATH."
}

# Resolve source font files
$fonts = @{
  Regular = $null; Italic = $null; Bold = $null; BoldItalic = $null
}

function TryAssignFromDir($dir){
  $map = @{
    Regular = @("LiberationSerif-Regular.ttf", "Times New Roman.ttf", "times.ttf")
    Italic  = @("LiberationSerif-Italic.ttf",  "Times New Roman Italic.ttf", "timesi.ttf")
    Bold    = @("LiberationSerif-Bold.ttf",    "Times New Roman Bold.ttf",   "timesbd.ttf")
    BoldItalic=@("LiberationSerif-BoldItalic.ttf","Times New Roman Bold Italic.ttf","timesbi.ttf")
  }
  foreach($style in $map.Keys){
    foreach($name in $map[$style]){
      $candidate = Join-Path $dir $name
      if(Test-Path $candidate){ $fonts[$style] = (Resolve-Path $candidate).Path; break }
    }
  }
}

if($SourceDir){
  if(!(Test-Path $SourceDir)){ Fail "SourceDir not found: $SourceDir" }
  TryAssignFromDir $SourceDir
} elseif($UseSystemTimes){
  $winFonts = "$env:WINDIR\Fonts"
  if(!(Test-Path $winFonts)){ Fail "Windows Fonts folder not found at $winFonts" }
  # Try exact names first
  TryAssignFromDir $winFonts
  # Fallback: search for Times New Roman TTFs
  if(-not $fonts["Regular"]) {
    $tnr = Get-ChildItem $winFonts -Filter "*Times*New*Roman*.ttf" -Recurse -ErrorAction SilentlyContinue
    foreach($f in $tnr){ if($f.Name -match "(?i)regular|roman|times\.ttf$") { $fonts["Regular"] = $f.FullName; break } }
    foreach($f in $tnr){ if($f.Name -match "(?i)italic|timesi\.ttf$")     { $fonts["Italic"]  = $f.FullName; break } }
    foreach($f in $tnr){ if($f.Name -match "(?i)bold(?!.*italic)|timesbd\.ttf$") { $fonts["Bold"] = $f.FullName; break } }
    foreach($f in $tnr){ if($f.Name -match "(?i)bold.*italic|timesbi\.ttf$") { $fonts["BoldItalic"] = $f.FullName; break } }
  }
} else {
  Fail "Provide -SourceDir with open fonts (e.g., Liberation Serif) or -UseSystemTimes for local-only generation."
}

# Report resolved files
Write-Host "Resolved sources:" -ForegroundColor Cyan
foreach($k in $fonts.Keys){
  $val = $fonts[$k]
  if(-not $val){ $val = "MISSING" }
  Write-Host ("{0,-11}: {1}" -f $k, $val)
}

# Ensure output dir
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$scriptPath = Join-Path $PSScriptRoot "generate-times-pixel.py"
if(!(Test-Path $scriptPath)){ Fail "Missing script: $scriptPath" }

$pairs = @(
  @{ Style = "Regular";     Src = $fonts["Regular"];     Out = (Join-Path $OutDir "TimesPixel-Regular") }
  @{ Style = "Italic";      Src = $fonts["Italic"];      Out = (Join-Path $OutDir "TimesPixel-Italic") }
  @{ Style = "Bold";        Src = $fonts["Bold"];        Out = (Join-Path $OutDir "TimesPixel-Bold") }
  @{ Style = "BoldItalic";  Src = $fonts["BoldItalic"];  Out = (Join-Path $OutDir "TimesPixel-BoldItalic") }
)

$familyName = "TimesPixelLocal"

foreach($p in $pairs){
  if(-not $p.Src){ Write-Warning "Skipping $($p.Style) (source not found)"; continue }
  Write-Host "Generating $($p.Style)..." -ForegroundColor Green
  & $ff -lang=py -script $scriptPath -- `
    --in "$($p.Src)" --outBase "$($p.Out)" --family "$familyName" --style "$($p.Style)" |
    Write-Output
}

Write-Host "Done. Generated files (if any) are under $OutDir" -ForegroundColor Cyan
