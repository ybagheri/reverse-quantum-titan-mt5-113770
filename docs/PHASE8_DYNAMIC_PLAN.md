# Phase 8 — Dynamic Behavior Analysis (Sandbox, Demo-Only)

Goal: find out what `QTM.ex5` **actually does at runtime** (network, files, processes, trading behavior) — without decompiling, disassembling, or modifying the binary. This is the only legitimate path that yields real behavioral knowledge given the static-analysis wall documented in `LIMITATIONS.md` and `structural-analysis.md`.

## Non-negotiable boundaries

1. **Demo account only.** No live-money account is ever involved.
2. **Everything runs inside an isolated VM**, never directly on the host, and never on the production MT5 install at `C:\Program Files\Alpari MT5_4\`.
3. The EX5 is executed **as-is**, the way any licensed user would load it — no patching, no unpacking, no loader bypass.
4. Observation is **external** (behavior-level): network, filesystem, processes, logs. Not binary-internal.

## Environment requirement (host verified 2026-10-23)

- Host OS edition is `CoreSingleLanguage` (Windows Home): **Hyper-V and Windows Sandbox are unavailable**.
- `VBoxManage` is **not installed** at the default path.
- ➜ Required: **Oracle VirtualBox** (free, official: https://www.virtualbox.org/wiki/Downloads) — installation is the one step that needs the user's admin consent. Alternative: a disposable cloud Windows VM (paid) also satisfies isolation.

## Sub-phases

### 8.1 — VM baseline
- Install VirtualBox → create Win10/11 VM (2 vCPU / 4 GB RAM is enough for MT5).
- Inside VM: install a fresh MT5 terminal (demo broker or MetaQuotes demo server).
- Take a **clean snapshot** before the EA is ever copied in ("pre-EA snapshot").

### 8.2 — Instrumentation (before launching the EA)
- Networking: run `Get-NetTCPConnection` / `netstat -bno` inside the VM, or a lightweight capture (e.g., built-in `pktmon`) to record DNS/TCP connections the terminal makes while the EA runs.
- Processes/files: Sysinternals **ProcMon** + **Process Explorer** (officially from https://learn.microsoft.com/sysinternals) filtered to the MT5 process-tree.
- Filesystem: watch writes under `...\MetaQuotes\Terminal\<instance>\` — especially `logs\`, `MQL5\Logs\`, `config\`.

### 8.3 — EA execution (demo only)
- Copy the verified `QTM.ex5` into the VM's `MQL5\Experts\`, attach to a demo chart.
- Record: startup messages in `Experts` journal, all input parameters it exposes (visible UI — no binary reading), any dialogs/URLs it opens.
- Let it run long enough to open/close at least a few demo trades; journal timestamps captured.

### 8.4 — Evidence & teardown
- Consolidate findings into `DYNAMIC_ANALYSIS_FINDINGS.md` (network endpoints touched, files written, resources used, trading cadence).
- Host-level: also log VM process CPU/mem curves (`Get-Process` on the VBox process) for resource-footprint evidence.
- Afterward: **revert the VM to the pre-EA snapshot** and delete captured credentials/logs from the host.

## What this phase does NOT do
- No decompilation/disassembly of the EX5 (see `LIMITATIONS.md`).
- No contact with any live-money account.
- No changes to the production MT5 installation on the host.

## Immediate next action (user step)
Install VirtualBox (admin, one-time), then say the word — sub-phase 8.1 setup begins.
