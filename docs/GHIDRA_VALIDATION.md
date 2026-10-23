# Ghidra 12.1.4 — Validation Report

All commands were executed as the current (non-admin) user. Every fact below is from an actual observed run on 2026-10-23.

## 1. Runtime requirement check (VERIFIED)

- `analyzeHeadless.bat` and the launcher were run with `JAVA_HOME` pointed at the per-user Temurin JDK 21 (`%LOCALAPPDATA%\Programs\jdk-21.0.12.1+1`).
- Ghidra started successfully; no version complaint from the launcher (Ghidra 12.1.4 requires JDK 21; JDK 17 was not used).

## 2. Headless usage check

Command (no arguments):

```
scripts\launch-ghidra.ps1 -AnalyzeHeadless
```

Observed: printed full `analyzeHeadless` usage text (`<project_location> <project_name>`, `-import|-process`, `-preScript|-postScript`, etc.) and exited `-1` — expected for an argument-less invocation.

## 3. Real headless execution (end-to-end)

Command:

```
analyzeHeadless.bat <tempd>\ghidra-probe probeProj -import <qtm.ex5 working copy> -log <tempd>\ghidra-probe\probe.log
```

Observed key startup milestones (from stdout + retained log):

- `Using log config file ... Generic.log4j.xml`
- User preferences dir created: `%APPDATA%\ghidra\ghidra_12.1.4_PUBLIC\preferences`
- `Class search complete (1111 ms)` — 59 extension points, 0 fatal errors
- SSL context & SHA1PRNG initialized; file-user cache initialized with no stale state
- `Headless startup complete (4537 ms)`
- Script paths enumerated (59 GhidraFeatures/Processors, incl. Database Loaders, No-card processor sets)
- Project created: `probeProj.gpr` at target location
- Import phase logged and completed with its own diagnostic (see GitHubVALIDATION §4)

Conclusion: Ghidra's headless analyzer pipeline (JDK 21 → home dir init → security init → plugin/class search → project store → importer) is functional on this machine.

## 4. QTM.ex5 import probe (read-only mission-relevant check)

At the end of the same validated headless run, the target binary `QTM.ex5` (168,726 B, SHA-256 `257C789974EE6D1D896EC2D601C1E82BF24A1AB03A0B40C047FC94C803107295`) was submitted **with no force-loading options, no `-processor` argument, no custom loader plugins**.

Observed outcome (VERIFIED):

```
INFO  IMPORTING: file:///.../QTM.ex5
INFO  No load spec found for import file: QTM.ex5
ERROR The ProgramLoader could not successfully load file:///.../QTM.ex5
ERROR REPORT: Import failed for file: file:///.../QTM.ex5
```

Interpretation: stock Ghidra 12.1.4 has **no loader able to identify MetaTrader EX5** at all — it cannot even classify the file, so no partial/best-effort program was created. Nothing was loaded or written into the target file (probed against a verified byte-for-byte copy, confirmed by three-way hash equality: original ↔ staging copy ↔ repo working copy).

## 5. Launcher end-to-end check

`launch-ghidra.ps1 -AnalyzeHeadless ... -process` (without a specifier argument): launcher passed validation, set `JAVA_HOME`, started Ghidra (`ghidla.GhidraLauncher`), which raised the expected missing-argument error and propagated exit code 1. This proves the launcher path validation + invocation chain works.

## NOT TESTED / out of scope

- **Ghidra GUI** (`ghidraRun.bat` graphical startup) was not launched. Headless validation is authoritative for this project's purpose; treat the GUI as unverified here.
- Any modification of the EX5, the MT5 terminal install, or JVM/dotfile environment was out of scope and did not occur.
