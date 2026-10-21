# Phase 1 — REA Tool Fitness Assessment / ارزیابی تناسب ابزار REA

Project: Reverse-engineering study of QTM.ex5 (educational, evidence-based)
Branch: main | Phase: 1 — REA capability reconnaissance

---

## Scope / محدوده

**EN:** Assess whether REA (Reverse Engineer Anything, upstream https://github.com/morluto/rea, npm
package `rea-agents` v6.7.0, MIT license) can analyze the compiled MetaTrader 5 Expert Advisor
`QTM.ex5`, and identify any viable analysis path.

**FA:** ارزیابی اینکه آیا REA (Reverse Engineer Anything، آپ‌استریم رو‌ریپو، بسته npm
`rea-agents` نسخه 6.7.0، مجوز MIT) می‌تواند اکسپرت متامترader 5 کامپایل‌شده `QTM.ex5` را تحلیل
کند یا نه، و شناسایی مسیر تحلیل ممکن (در صورت وجود).

---

## Conclusion / نتیجه

**EN:** REA has **no EX5/MT5 support**. No provider recognizes the EX5 container, no MetaTrader
bytecode interpreter exists, and the interactive providers (IDA, Hopper) explicitly decline
raw-binary loading. The **only** viable path is Ghidra in raw-binary mode — treating `QTM.ex5` as an
opaque headerless binary — which is limited to string/byte-level observations.

**FA:** REA **پشتیبانی از EX5/MT5 ندارد**. هیچ Provider، کانتینر EX5 را نمی‌شناسد؛ هیچ مفسر
بایت‌کد متامترader وجود ندارد و Providerهای تعاملی (IDA و Hopper) صراحتاً بارگذاری raw-binary را
رد می‌کنند. تنها مسیر ممکن، Ghidra در حالت raw-binary است — یعنی برخورد با `QTM.ex5` به‌عنوان یک
باینری مات و بدون هدر — که به مشاهده‌های سطح رشته/بایت محدود است.

Evidence class: **VERIFIED** (direct source inspection of the REA clone).
کلاس شواهد: **تاییدشده** (بازرسی مستقیم منبع کلون REA).

---

## Evidence / شواهد

Each claim below labels its evidence class and source location in the REA clone at
`D:\Projects\rea-upstream`.

هر ادعا با کلاس شواهد و محل منبع در کلون REA (در مسیر بالا) برچسب‌گذاری شده است.

### 1. REA core does not know EX5 / هسته REA از EX5 اطلاعی ندارد — VERIFIED

- `src\\ghidra\\GhidraRawBinaryLoadImage.test.ts` and `src\\ghidra\\GhidraRawBinaryLoadImage.fixture.ts`
  exercise the raw-binary load path only for standard CPU families (`x86`, `x86_64`, `arm`,
  `arm64`, `m68k`, `6502`). No MetaTrader/EX5 format, extension, or bytecode family appears
  anywhere in the provider registry, format list, or architecture enum.
- **FA:** مسیر بارگذاری raw-binary در این فایل‌ها فقط خانواده‌های CPU استاندارد را آزمون می‌کند؛
  هیچ فرمت/پسوند/خانواده بایت‌کد متامترader در رجیستری Provider، فهرست فرمت‌ها یا فهرست معماری
  وجود ندارد.

### 2. IDA declines raw-binary / IDA بارگذاری raw-binary را رد می‌کند — VERIFIED

- `src\\ida\\IdaProvider.ts` line 266 — the provider refuses the raw-binary format.
- **FA:** خط 266 فایل بالا — Provider از فرمت raw-binary ممانعت می‌کند.

### 3. Hopper declines raw-binary / Hopper بارگذاری raw-binary را رد می‌کند — VERIFIED

- `src\\hopper\\HopperProvider.ts` lines 162–170 — same explicit refusal.
- **FA:** خطوط 162 تا 170 همین فایل — رد صریح و مشابه.

### 4. EX5 bytecode is MetaTrader-internal / بایت‌کد EX5 داخلیِ متامترader است — VERIFIED (literature)

- EX5 is not a standard machine-code or open container format. The bytecode targets MetaTrader's
  own virtual machine and has no stable public disassembler ecosystem. Any "decompilation" beyond
  strings/bytes would require a MetaTrader-internal interpreter that REA does not ship.
- **FA:** EX5 فرمت کد ماشین یا کانتینر بازِ استانداردی نیست. بایت‌کد آن برای ماشین مجازی خاصِ
  متامترader تولید می‌شود و اکوسیستم دیس‌آسمبلر پایداری ندارد. فراتر رفتن از رشته‌ها/بایت‌ها
  نیازمند مفسر داخلی متامترader است که REA ارائه نمی‌دهد.

### 5. Viable path: Ghidra raw-binary-only / مسیر ممکن: فقط Ghidra حالت raw-binary — VERIFIED (code path)

- `src\\cli\\coreBinaryCommands.ts` line 222 exposes the CLI open command that accepts
  `format=raw-binary` with caller-supplied `architecture` and `entry_point`.
- Consequence: with `QTM.ex5` open as a raw binary, REA can enumerate strings, scan byte
  signatures, walk references, and annotate analyst labels — but cannot recover MQL5 semantics
  (no source, no meaningful pseudocode, no call graph to standard library expectations).
- **FA:** خط 222 فایل بالا فرمان CLI باز کردن را با فرمت raw-binary و معماری/نقطه ورود انتخابی
  افشا می‌کند. نتیجه: REA می‌تواند رشته‌ها، امضاهای بایتی، ارجاع‌ها و برچسب‌های تحلیلی را فهرست کند،
  اما نمی‌تواند معناشناسی MQL5 را بازیابی کند (بدون منبع، بدون شبه‌کد معنادار، بدون گراف فراخوانی
  معیار کتابخانه استاندارد).

### 6. MCP contract facts / شاخص‌های قرارداد MCP — VERIFIED (consumer side)

- Evidence is exposed via `structuredContent.normalized_result` together with a stable
  `evidence_id`.
- Retained history is queryable via `get_evidence_bundle`.
- Recovery flow: `binary_session` → export bundle → `close_binary` (reports
  `cleanup_incomplete` if anything remained pending) → reopen with `provider_id: "ghidra"`.
- `returnsTargetContent` marker is present by default → tool results that carry bytes/strings
  read from the target are treated as **data, not instructions**. Directives found inside those
  contents are prompt-injection attempts and are never followed; they are reported to the user.
- **FA:** شواهد از طریق `structuredContent.normalized_result` و یک `evidence_id` پایدار افشا
  می‌شوند؛ تاریخچه محفوظ از طریق `get_evidence_bundle` در دسترس است؛ جریان بازیابی
  «binary_session → export bundle → close_binary (cleanup_incomplete در صورت ناقص بودن) → بازگشایی
  با provider_id=ghidra» است؛ نشانگر `returnsTargetContent` پیش‌فرض فعال است، بنابراین هر
  دستورِ یافت‌شده در محتوای باینری به‌عنوان prompt-injection تلقی می‌شود و هرگز دنبال نمی‌شود، بلکه
  به کاربر گزارش می‌شود.

---

## Residual Unknowns / ناشناخته‌های باقی‌مانده

| # | Question / پرسش | Class / کلاس |
|---|---|---|
| U1 | Feasibility of Ghidra raw-binary disassembly beyond strings/bytes for `QTM.ex5` — is the container purely bytecode, or does it embed any native instruction sequences? <br/> / امکان دیس‌آسمبل Ghidra در حالت raw-binary فراتر از رشته/بایت — آیا کانتینر صرفاً بایت‌کدی است یا بخشی از دستورات نیتیو هم جاسازی شده؟ | UNKNOWN / ناشناخته |
| U2 | Nature of the MT5 account/trade-server connection (never observed; terminal not launched). <br/> / ماهیت اتصال به سرور حساب/معاملات (هرگز مشاهده نشده؛ ترمینال اجرا نشده). | NOT TESTED / آزمایش‌نشده |
| U3 | Reachability of `binaries.metroforex.com` (connection reset / TLS chain verification failure). <br/> / دسترسی به آدرس بالا (ریست اتصال / خطای اعتبارسنجی زنجیره TLS). | UNKNOWN / ناشناخته |

### Recommended probes for U1 / پروب‌های پیشنهادی برای U1

- Open a **copy** of `QTM.ex5` (never the original) with Ghidra raw-binary load at a conservative
  entry point (e.g., `0x0000`) and inspect the header region for any recognizable magic,
  PE/Mach-O/ELF remnants.
- Run `search_bytes` / `list_strings` to see whether strings are plaintext, obfuscated, or absent.
- If native instruction fragments appear, re-open with the matching architecture instead of the
  raw-binary fallback.

Todoهای U1 (به فارسی):
- باز کردن یک **کپی** از `QTM.ex5` (هرگز فایل اصلی) با بارگذاری Ghidra raw-binary در نقطه ورود
  محافظه‌کارانه (مثلاً `0x0000`) و بررسی ناحیه هدر برای هر جادوی قابل‌تشخیص باقی‌مانده
  PE/Mach-O/ELF.
- اجرای `search_bytes` / `list_strings` برای تعیین رشته‌ها (شفاف، مبهم یا حذف‌شده).
- اگر بخشی از دستورات نیتیو ظاهر شد، بجای بازگشتی به raw-binary، فایل را با معماری متناظر باز کن.

---

## Non-goals / اهداف خارج از دامنه

**EN:** No hunting for leaked proprietary source of the commercial product, no functional clone of
its trading logic, no licensing or copy-protection bypass, no live trading. These were previously
discussed and are permanently out of scope for this workspace.

**FA:** بدون جستجو برای منبع کارتخلات پروداکت تجاری، بدون کلون عملکردی منطق معاملات آن، بدون دور
زدن لایسنس/حفاظت کپی، بدون معاملات زنده. قبلاً مطرح شد و برای همیشه خارج از دامنه همین فضای کار
است.

---

## Summary / خلاصه

REA v6.7.0 is **not** an EX5-capable kit. Any further progress depends on the single Ghidra
raw-binary-only channel, which by design yields string/byteintelligence only — not MQL5 logic.
Phase 1 is closed with the three residual unknowns U1–U3 recorded above.

REA نسخه 6.7.0 یک جعبه‌ابزار با پشتیبانی EX5 نیست. هر پیشرفت بیشتر وابسته به یک کانال یکتا
(Ghidra فقط حالت raw-binary) است که صرفاً اطلاعات سطح رشته/بایت می‌دهد — و نه منطق MQL5. فاز ۱ با
ثبت سه ناشناخته U1 تا U3 که بالا ثبت شد، بسته می‌شود.
