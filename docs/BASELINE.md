# Phase 0 Baseline — reverse-quantum-titan-mt5-113770

Status: **COMPLETED_WITH_LIMITATIONS**

## Summary

Phase 0 established a read-only baseline for the educational reverse-engineering
study of the compiled MT5 Expert Advisor `QTM.ex5`. The safety model, artifact
metadata, and environment report were produced and verified against evidence
collected on the host.

## Target Artifact

| Field | Value |
|---|---|
| Path | `C:\Users\BazikadeStore\AppData\Roaming\MetaQuotes\Terminal\1D9617E1A6A4352DBDC25D08FEC12BD2\MQL5\Experts\QTM.ex5` |
| Size | 168,726 bytes |
| SHA-256 | `257C789974EE6D1D896EC2D601C1E82BF24A1AB03A0B40C047FC94C803107295` |
| Classification | VERIFIED (re-checked before use every time it is touched) |

The EX5 file is treated as READ-ONLY for the entire engagement. A digest change
is a STOP condition.

## Environment

| Component | Status | Evidence |
|---|---|---|
| MT5 terminal `C:\Program Files\Alpari MT5_4\terminal64.exe` | EXISTS | image size 12,182,528 bytes; mtime 2026-09-30 17:37:16 |
| Data dir `...\Terminal\1D9617E1A6A4352DBDC25D08FEC12BD2` | EXISTS | `MQL5\Experts` contains only `QTM.ex5` |
| Workspace `D:\Projects\reverse-quantum-titan-mt5-113770` | READY | Git repo, branch `main`, first commit = this baseline |
| External drive `D:` | MOUNTED, writable | verified via workspace creation |
| MT5 running | NO | no `terminal64.exe` processes observed during Phase 0 |

Full detail: `artifacts/baseline/environment-report.md`.
Target metadata: `artifacts/baseline/target-file-metadata.json`.

## Limitations (carried forward)

1. **Account/server connection type UNKNOWN.** The MT5 terminal was not running
   and was not launched in Phase 0 (state-changing action deferred pending
   explicit user approval). Deferred to the planned read-only check in
   Phase 3/5. Evidence class: NOT TESTED.
2. **`binaries.metroforex.com` unreachable.** Connection reset / TLS chain
   verification errors observed. Cause UNKNOWN; recorded for later phases.
   Evidence class: NOT TESTED.
3. **RXA tooling not installed.** No tool-based observations in this phase;
   Phase 2 handles installation and validation.

## Safety

All rules are documented in `docs/SAFETY_MODEL.md`. Key invariants reaffirmed:

- Reference EX5 is read-only; SHA-256 pinned above.
- No live trading; demo/backtest contexts only, AutoTrading disabled for
  real-money accounts.
- No licensing or copy-protection bypass; no credential exposure.
- Evidence classes in use: VERIFIED / STRONGLY INFERRED / HYPOTHESIS /
  UNKNOWN / NOT TESTED.

## Next

Phase 1 — investigate the RXA repository (https://github.com/morluto/rea):
docs, capabilities, setup requirements. No target execution.
