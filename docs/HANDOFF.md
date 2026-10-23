# HANDOFF — reverse-quantum-titan-mt5-113770

- **Last updated:** 2026-10-23 — added `artifacts\target\structural-analysis.md` (EX5 header magic `EX5\x02`, entropy ≈7.94/8 body, 2 cleartext UTF-16 literals incl. author MQL5 profile URL `https://www.mql5.com/en/users/weredeu`). Full/direct MQL5-source disassembly remains infeasible via legitimate tooling; the extracted author link is the concrete contact route for requesting the `.mq5` source. No other phases changed.

## Project

Educational, read-only binary-analysis feasibility study of MetaTrader 5 Expert Advisor `QTM.ex5` using Ghidra 12.1.4. Strict discipline: no force-loading, no modified target, no claims of recovered source or trading logic. Target EX5 and the MT5 terminal install (`C:\Program Files\Alpari MT5_4\`) remain untouched.

## Current phase: Phase 8 (dynamic sandbox analysis) — planning complete, awaiting VM setup
- Plan: `PHASE8_DYNAMIC_PLAN.md` (demo-only, isolated VM; host is Windows Home ⇒ VirtualBox required; install = one user admin step).

## Verified facts (do not re-derive)

- **Target (VERIFIED):** `C:\Users\BazikadeStore\AppData\Roaming\MetaQuotes\Terminal\1D9617E1A6A4352DBDC25D08FEC12BD2\MQL5\Experts\QTM.ex5`
  - SHA-256: `257C789974EE6D1D896EC2D601C1E82BF24A1AB03A0B40C047FC94C803107295`, 168,726 B, mtime 2026-10-21 18:57:58 (local)
- **JDK 21 (VERIFIED):** Temurin `21.0.12.1+1` at `%LOCALAPPDATA%\Programs\jdk-21.0.12.1+1\`; `java.exe -version` runtime-verified. JDK 17 at `C:\Program Files\Eclipse Adoptium\jdk-17.0.20.8-hotspot\` untouched (insufficient for Ghidra 12.1.4).
- **Ghidra 12.1.4 (VERIFIED):** zip `ghidra_12.1.4_PUBLIC_20260921.zip`, 569,649,598 B, SHA-256 `DDAC49F903DA9D5BAC833E5CC79395098B9C33CFD3279BE5F31BD00387D2D4DB` (matches official GitHub release digest), installed per-user at `%LOCALAPPDATA%\Programs\Ghidra\ghidra_12.1.4_PUBLIC\`. No admin required.
- **Launcher (VERIFIED):** `scripts\launch-ghidra.ps1` — sets `JAVA_HOME`, validates paths, runs `ghidraRun.bat` / `analyzeHeadless.bat`. Note: in Ghidra 12.1.4, `ghidraRun.bat` is at the install root, NOT under `support\`.
- **Phase 5 validation:** `analyzeHeadless` full real run passed (startup, project creation, import attempt). GUI = NOT TESTED (headless only).
- **Phase 6 EX5 probe (VERIFIED, read-only):** headless import of the verified working copy → `No load spec found for import file: QTM.ex5`. Stock Ghidra 12.1.4 cannot identify or load MetaTrader EX5; no processor was forced. See `artifacts\target\metadata.json`, `docs\GHIDRA_VALIDATION.md`, `docs\LIMITATIONS.md`.

## Work state

- ✅ Phase 0–1: baseline docs, REA fitness assessment (commits `e51602c`, `f4778df`)
- ✅ Phase 2: Ghidra 12.1.4 release selection (official GitHub asset; TLS on GitHub needs `curl --ssl-no-revoke` on this machine)
- ✅ Phase 3: per-user JDK 21 install, hash + runtime verified
- ✅ Phase 4: Ghidra per-user install (hash-verified) + launcher script
- ✅ Phase 5: headless validation (real run)
- ✅ Phase 6: EX5 feasibility probe — no native Ghidra loader for EX5
- ✅ Phase 7: documentation — `GHIDRA_INSTALLATION.md`, `GHIDRA_VALIDATION.md`, `LIMITATIONS.md`, this handoff
- 🟡 Phase 8: dynamic sandbox analysis — plan committed; blocked only on VirtualBox install (user admin step)
- 🗄️ 570 MB zip retained at `C:\Users\BazikadeStore\AppData\Local\Temp\opencode\ghidra_12.1.4_PUBLIC_20260921.zip` (hash-verified; delete to reclaim disk)

## Environment notes

- Workspace repo: `D:\Projects\reverse-quantum-titan-mt5-113770` — NOT a git repo (kept out of version control by design).
- `origin` = `git@github.com:ybagheri/reverse-quantum-titan-mt5-113770.git`; local `main` upstream `[gone]` (remote branch deleted previously).
- Exa websearch is down (HTTP 403) — do not retry; use api.github.com / api.adoptium.net.
- REA upstream clone: `D:\Projects\rea-upstream` (v6.7.0, NEVER commit it). REA has no MT5/EX5 support.
- Windows PowerShell 5.1, non-admin; shell cwd = `C:\Users\BazikadeStore\Documents\Default Project` (use absolute paths).

## Bottom line (feasibility)

Stock Ghidra 12.1.4 runs correctly on this machine but **cannot parse MetaTrader EX5 files**: the EX5 format is MetaQuotes-internal VM bytecode, and no loader/processor exists in Ghidra (or REA) for it. Any further analysis would require MetaQuotes-internal knowledge and is out of scope for this read-only educational study. Nothing in the target binary was modified.
