# Ghidra 12.1.4 per-user launcher (no admin required).
# Installs used by this script:
#   Ghidra:  %LOCALAPPDATA%\Programs\Ghidra\ghidra_12.1.4_PUBLIC
#   JDK 21:  %LOCALAPPDATA%\Programs\jdk-21.0.12.1+1 (Temurin 21.0.12.1+1, hash-verified)
# Usage: powershell -ExecutionPolicy Bypass -File scripts\launch-ghidra.ps1
#        powershell -ExecutionPolicy Bypass -File scripts\launch-ghidra.ps1 -AnalyzeHeadless <project_loc> <project_name> [-Import <paths...>]

param(
    [switch]$AnalyzeHeadless,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$GhidraArgs
)

$ErrorActionPreference = 'Stop'

$ghidraHome = Join-Path $env:LOCALAPPDATA 'Programs\Ghidra\ghidra_12.1.4_PUBLIC'
$javaHome   = Join-Path $env:LOCALAPPDATA 'Programs\jdk-21.0.12.1+1'

# Validated layout: ghidraRun.bat at installation root; analyzeHeadless.bat under support\
if (-not (Test-Path -LiteralPath (Join-Path $ghidraHome 'ghidraRun.bat'))) {
    throw "Ghidra not found at: $ghidraHome"
}
if (-not (Test-Path -LiteralPath (Join-Path $javaHome 'bin\java.exe'))) {
    throw "JDK 21 runtime not found at: $javaHome"
}

$env:JAVA_HOME = $javaHome

if ($AnalyzeHeadless) {
    & (Join-Path $ghidraHome 'support\analyzeHeadless.bat') @GhidraArgs
    exit $LASTEXITCODE
}

& (Join-Path $ghidraHome 'ghidraRun.bat')
