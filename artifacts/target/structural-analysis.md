# QTM.ex5 — Structural Analysis (read-only, 2026-10-23)

Static structure reading of the verified working copy (`artifacts\target\working-copy\QTM.ex5`, SHA-256 `257C7899...07295`, 168,726 B). No modification, no unpacking, no forcing.

## Container header (VERIFIED)

| Offset | Bytes | Note |
|---|---|---|
| 0x00–0x03 | `45 58 35 02` | ASCII magic `"EX5"` + container variant byte `0x02` |
| 0x04–0x0F | `71 00 56 18 58 04 E0 00 00 00 01 00` | uninterpreted header fields (lengths/ids — semantics not documented publicly) |

Trailer (last 16 B): `12 41 4C 37 8B 38 72 FA 41 89 90 BF 27 28 2B 5C` — likely hash/checksum tail; not interpreted.

## Entropy profile (VERIFIED)

- Window: 4,096 B × 42 segments.
- Average Shannon entropy: **7.936 bits/byte**.
- Exactly **one** block below 7.5: segment at offset `0` (7.39) — the header/directory zone.
- Everything else ≈ 7.94–7.97 (near-maximal): body is compressed/encoded — consistent with MQL5 VM bytecode in a packed container.

## String census (VERIFIED)

- ASCII strings ≥6 chars: 9,532 matches, of which **0** contain keywords (no dll/URLs/license/version markers) → matches random bytes inside compressed payload, not a plaintext string table.
- UTF-16LE strings: **2 unique plaintext literals** in cleartext:
  1. `Click here to contact the author.` — a UI string
  2. `https://www.mql5.com/en/users/weredeu` — the EA author's MQL5.com profile link

## Consequences

- `Ghidra 12.1.4` correctly refuses the container (`No load spec found` — see `GHIDRA_VALIDATION.md`): the header is a MetaQuotes-custom magic that no public loader knows, and the ≥7.9-entropy body cannot be disassembled without MetaQuotes' internal decompression/VM format.
- The only cleartext artifacts (author contact URL) support the legitimate route of obtaining the strategy source directly from its author, rather than binary decompilation.

## Out of scope (per SAFETY_MODEL)

- Building or using unofficial "ex5 decompiler" tools, bypassing compile-time protection, or any modification of the file.
