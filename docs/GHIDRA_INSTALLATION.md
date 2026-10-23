# Ghidra 12.1.4 — Per-User Installation (Windows, No Admin)

This document records exactly how Ghidra 12.1.4 was installed on this machine, per-user, without administrator rights.

## Prerequisites

Ghidra 12.1.4 requires a 64-bit JDK 21. Using the system JDK 17 (`C:\Program Files\Eclipse Adoptium\jdk-17.0.20.8-hotspot\`) is insufficient.

### JDK 21 (Temurin) install steps

1. Asset used (official Adoptium GitHub release):
   - Package: `OpenJDK21U-jdk_x64_windows_hotspot_21.0.12.1_1.zip`
   - SHA-256: verified against Adoptium checksum before extraction.
2. Download with `curl.exe --ssl-no-revoke -L -o <zip> <official-adoptium-url>`.
3. Extracted to: `C:\Users\BazikadeStore\AppData\Local\Programs\jdk-21.0.12.1+1\`
4. Runtime verification:
   - `%LOCALAPPDATA%\Programs\jdk-21.0.12.1+1\bin\java.exe -version`
   - Output: `openjdk version "21.0.12.1" 2026-08-18 LTS` (Temurin-21.0.12.1+1, 64-Bit Server VM)
5. No machine-wide environment variables were changed; `JAVA_HOME` is set only inside the launcher script / shell sessions.

### Ghidra 12.1.4 install steps

1. Official release asset (GitHub, `NationalSecurityAgency/ghidra`, tag `Ghidra_12.1.4_build`, published 2026-09-21):
   - `ghidra_12.1.4_PUBLIC_20260921.zip`
   - Size: `569,649,598` bytes
   - Official SHA-256: `ddac49f903da9d5bac833e5cc79395098b9c33cfd3279be5f31bd00387d2d4db`
2. Download quirks encountered (PowerShell 5.1 / schannel):
   - Plain `curl.exe` fails with TLS exit code `35` / `CRYPT_E_REVOCATION_OFFLINE (0x80092013)` → must add `--ssl-no-revoke`.
   - Large transfer can be interrupted by the terminal tool timeout → resume from a partial file with `curl.exe -L --ssl-no-revoke -C -`.
   - Connection stalls → `--retry 8 --retry-all-errors --retry-delay 15 --connect-timeout 60`.
3. Extraction target (per-user, no admin):
   - `%LOCALAPPDATA%\Programs\Ghidra\` → yields `...\Ghidra\ghidra_12.1.4_PUBLIC\`
4. Final integrity check (independent of any download tool): `Get-FileHash` must match the official digest above.
5. Layout note (validated on 12.1.4): `ghidraRun.bat` is at the installation root; `support\analyzeHeadless.bat` is under `support\`.

## Launcher

`scripts\launch-ghidra.ps1` re-creates the per-user launcher:

```powershell
# GUI
powershell -ExecutionPolicy Bypass -File scripts\launch-ghidra.ps1

# Headless analyzer (example)
powershell -ExecutionPolicy Bypass -File scripts\launch-ghidra.ps1 -AnalyzeHeadless <project_loc> <project_name> -import <file>
```

It validates both paths (Ghidra root `ghidraRun.bat` and JDK 21 `java.exe`), sets `JAVA_HOME` for the child process, and propagates the exit code. Verification performed end-to-end with `-AnalyzeHeadless ... -process` (reached GhidraLauncher, expected argument-error exit 1 due to missing `-process` specifier argument).

## Cleanup / disk notes

The download (570 MB zip) stays in the temp dir as a hash-verified staging artifact; delete it after the migration is fully verified to reclaim disk space.
