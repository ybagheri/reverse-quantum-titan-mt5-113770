# Safety Model

Project: Reverse-engineering study of QTM.ex5 (educational, evidence-based)
Branch: main | Phase: 0 — Workspace and Safety Baseline

## Hard Rules (non-negotiable)

1. The file `C:\Users\BazikadeStore\AppData\Roaming\MetaQuotes\Terminal\1D9617E1A6A4352DBDC25D08FEC12BD2\MQL5\Experts\QTM.ex5`
   is READ- ONLY. We never modify, rename, overwrite, move, or "repair" it.
   - Its identity is pinned by SHA-256:
     257c789974ee6d1d896ec2d601c1e82bf24a1ab03a0b40c047fc94c803107295
   - Any operation on or around this file must re-verify the digest first; if it
     changes, STOP and reassess (the reference object is no longer what we study).
2. No live trading. No intermediary steps that could place real orders. Any
   educational implementation (Phase 7) is written with live trading DISABLED
   by default, behind an explicit opt-in constant, and is never run against a
   live account.
3. No licensing/copy-protection bypass. If the EA carries a protection layer,
   we document its presence/behavior evidence-neutral; we do not strip, patch,
   or circumvent it.
4. No credential exposure. Authentication strings, account numbers, and server
   details, if encountered transiently, are redacted in documents and never
   quoted in full.
5. Everything we write is evidence-classified:
   - VERIFIED: direct observation on an artifact.
   - STRONGLY INFERRED: multiple converging, independent observations.
   - HYPOTHESIS: single or weak signal, explicitly labeled as such.
   - UNKNOWN: nothing established.
   - NOT TESTED: not attempted in this session.
   No claim is written to any document without one of these labels.

## Scope of permitted operations

- Hashing, metadata reading, copying the .ex5 into an isolated analysis dir.
- Static/dynamic analysis via REA tools on a COPY, not the reference file.
- Running the EA only inside a terminal, only on demo/backtest contexts, with
  AutoTrading never enabled on a real-money account.
- Log/config inspection read-only.

## Out of scope (always)

- Distributing or facilitating unlicensed use of QTM.ex5.
- Any monetized or deployed trading system derived from it.
- Contacting MetaQuotes/licensing servers to circumvent entitlements.

## Stop conditions

- SHA-256 of reference file changes from the pinned value.
- Any tool attempts to write into the terminal data directory.
- Evidence cannot support a conclusion after multiple independent checks.

(No risk of violating the above is acceptable. Questions → re-check, never
assume.)
