# Limitations

Entropy-informed boundary conditions for the study of `QTM.ex5` in this workspace. Read alongside `SAFETY_MODEL.md`, `PHASE1_REA_FITNESS.md`, `GHIDRA_VALIDATION.md`, `artifacts\target\metadata.json`.

## Hard blockers for the intended Ghidra-based analysis

1. **No Ghidra loader for EX5 (VERIFIED).** Importing the verified `QTM.ex5` working copy into stock Ghidra 12.1.4 fails immediately: `No load spec found for import file: QTM.ex5`. Ghidra cannot even classify the container — no architecture/processor selection is possible, and per safety discipline we force-loaded nothing.
2. **EX5 is not native code.** MetaTrader 5 `.ex5` files are bytecode for MetaQuotes' internal VM (registration-protected, proprietary container). This is why generic loaders (ELF/PE/Mach-O/DOS/Dex/Java class family) all decline: the container contains no native image for Ghidra's processor modules to consume.
3. **No REA/MT5 provider either.** The REA upstream provider list (v6.7.0) contains no MT5/EX5 adapter — consistent with the Ghidra probe. There is no supported tooling path to disassemble/decompile this binary today.
4. **No source recovery claims.** We explicitly cannot (and do not) claim that `QTM.ex5`'s MQL5 source or its trading logic has been, or can be, recovered by any tooling used in this study. Every such claim, had it ever been made (even tentatively), must be treated as false.

## What this means for the project

- The feasibility question is **answered negatively for the tooling class tested**: analysis must wait for either (a) a MetaQuotes-owned loader/processor (proprietary, not in Ghidra), or (b) an officially supported, license-preserving path (e.g., procuring the `.mq5` source, which was out of scope here).
- All "pending" GHIDRA-tooling references in earlier working notes must be closed as **blocked**, not "will follow later automatically".

## In-scope-but-unverified items

- Ghidra **GUI** runtime (`ghidraRun.bat`) — not launched (headless validation only). Treat as unverified; a normal user double-launch may still be tested later, out of the read-only analysis scope.
- Any third-party EX5-adjacent tooling (e.g., unofficial decompilers) is **out of scope** for this project by safety policy and was not evaluated.

## Environment constraints observed

- GitHub/Adoptium TLS via PowerShell `curl.exe` requires `--ssl-no-revoke` on this host (schannel revocation check fails offline).
- Long-hanging downloads can exceed terminal tool timeouts → resume with `-C -` and add `--retry` options.
- The `Exa` websearch backend was returning HTTP 403 throughout the session → authoritative lookups must come from official REST endpoints (`api.github.com`, `api.adoptium.net`) or `raw.githubusercontent.com`.
