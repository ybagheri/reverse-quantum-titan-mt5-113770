# Environment Report — Phase 0 Baseline

Recorded: 2026-10-21 (UTC). All facts below are VERIFIED via PowerShell observation on the host, unless marked otherwise.

## Host System
- OS: Microsoft Windows 10 Pro, version 10.0.26300 (VERIFIED: `Get-CimInstance Win32_OperatingSystem`).
- PowerShell: 5.1.26100.9711 (VERIFIED: `$PSVersionTable.PSVersion`).
- Node.js: v24.21.0 (VERIFIED: `node --version`).
- npm: 11.19.0 (VERIFIED: `npm --version`).
- Python: 3.12.9 (VERIFIED: `python --version`).
- Git: 2.43.0.windows.1 (VERIFIED: `git --version`).
- Privileges: current user is NOT an administrator (VERIFIED: administrator token check).
- Processes: no MetaTrader / terminal64.exe processes were running at check time (VERIFIED: process scan).

## Target Artifact
- Full path: `C:\Users\BazikadeStore\AppData\Roaming\MetaQuotes\Terminal\1D9617E1A6A4352DBDC25D08FEC12BD2\MQL5\Experts\QTM.ex5`
  (USER-CONFIRMED; filename is exactly `QTM.ex5`.)
- Size: 168,726 bytes (VERIFIED).
- SHA-256: `257c789974ee6d1d896ec2d601c1e82bf24a1ab03a0b40c047fc94c803107295` (VERIFIED: `Get-FileHash -Algorithm SHA256`).
- Pinned digest agreement: MATCH. Stop condition = any future hash mismatch (see `docs/SAFETY_MODEL.md`).
- Attributes: Archive; readonly flag = false (VERIFIED).
- Version info: none embedded (FileVersionInfo fields all null) — recorded as an absence, NOT a placeholder (VERIFIED via `Get-Item().VersionInfo`).
- Source path (stated earlier): `C:\Users\BazikadeStore\Downloads\original_setup_files.exe` — deleted after extraction.

## MetaTrader Terminal
- Terminal executable: `C:\Program Files\Alpari MT5_4\terminal64.exe` — EXISTS (VERIFIED), size = 121,825,288 bytes, mtime = 2026-09-30 17:37:16.
- Terminal data directory: `C:\Users\BazikadeStore\AppData\Roaming\MetaQuotes\Terminal\1D9617E1A6A4352DBDC25D08FEC12BD2` — EXISTS (VERIFIED).
- `MQL5\Experts` contents: only `QTM.ex5` (VERIFIED: directory listing).
- External drive `D:` mounted and writable (VERIFIED: workspace creation).

## Workspace
- `D:\Projects\reverse-quantum-titan-mt5-113770` — Git repository, branch `main`, zero commits at report time.
- Companion behavioral repo (for comparison): `github.com/lokitrip-hop/QTM-Ult-EA` (HISTORICAL-REFERENCE).
- Project tracker: linear.app activity `113770|2026-10-21|Initialize reverse-quantum-titan-mt5-113770` (HISTORICAL-REFERENCE).

## Limitations / Open Items at Phase 0 Close
1. MT5 terminal is not running; therefore the account's trade-server connection type (demo vs live) was NOT observed. Per safety model, live trading is DISABLED by default; no MT5 launch was performed during Phase 0.
2. REA tooling is not yet installed (installs in Phase 2). No REA-based observations exist yet.
3. `binaries.metroforex.com` endpoint unreachability was observed (connection reset, TLS chain zero verification errors) — recorded as UNKNOWN cause for later phases.
