# Reference clock update 1.7.2 — 2026-10-01

## Verified delivery checkpoint — 2026-10-01

- Functional head `b95b147820da647d6a3ee8e4c0c15e6bf6a0b87e`; PR #17 merged to `86edc426d0c5dc5a03bd914bd7dd66d74cf1ac5a`. Updated branch CI `36836958720` passed 5,994 tests with 16 existing skips; main CI `36838523033` succeeded. Earlier failures below are preparation history, not current failures.
- Immutable [v1.7.2](https://github.com/SuyangLiuPaul/Yahwehs-Sword/releases/tag/v1.7.2): all five platform workflows succeeded and six assets are available. Unsigned GitHub IPA is not an installable App Store build.
- Both websites served the verified 1.7.2 version and matching bundle. Signed iOS and macOS build1070002 delivered and processed; compliance saved, internal group assigned, both external Public beta reviews submitted. Existing public App Store reviews are preserved and still pending.
- Google closed-test 1.7.2 / 2000009 submitted with three localized release notes. Production still needs genuine tester qualification. Microsoft submission4 remains in certification; [verified latest-package queue](microsoft-followup-1.7.2.md) replaces the older queue.
- [Ten genuine macOS screenshots](screenshots/2026-10-01/macos-1.7.2/README.md), original 1440×900 JPEGs with version/source/hash manifest. Older phone captures remain labelled with their actual versions.
- Older 1.7.0 and 1.7.1 native archives were backed up to T7 and all regular-file hashes verified before local removal. Latest signed archives, exports, dSYMs, source and original simulator data retained.

The owner requested replacing the existing Passion clock with the supplied complete diagram. See [content provenance and interaction checks](passion-reference-clock.md). The Passion timetable is now visible in both apps under its dignified localized name; principles stay hidden, Words history stays hidden and Sword’s established history remains visible. Existing routes remain unchanged; no Scripture or saved-data migration.

## Delivery gates

1. Canonical web wrapper bumps both apps to1.7.2 and deploys dev for real interaction review.
2. Source PR CI, analysis and independent review must pass before merge and immutable tag.
3. Production sites, five GitHub platform workflows, signed iOS/macOS uploads and separate Play/MSIX builds must each be verified and recorded. A version bump or prepared package does not mean publication.
4. Existing public Apple reviews and Microsoft certification stay preserved. Store follow-ups use the latest verified artifact when editing becomes available; the latest-package queue directs the Microsoft follow-up to1.7.2. Google production still requires real closed testing qualification.
5. Android Auto/Wear real capture remains gated by owner Google Play login to the dedicated emulator. Physical paired watch/car and Windows checks remain open; Sword has no car/watch companion.

## Verified previous delivery

1.7.1: Words7/Sword6 GitHub assets are available; all eight websites were version/bundle verified. All four signed Apple packages1070001 delivered and processed. Words iOS external beta is waiting for review; other beta group workflows will be recorded as completed. Do not mislabel1.7.1 as containing this new diagram.

## Storage

Additional cleanup reclaimed cache space and moved older compressed backups, byte-verified, to T7. Original path links preserve access while T7 is connected. Latest signed archives, exports, source and original simulator data remain local. Current free space is a measurement, not the sum of gross cache deletion figures.

The first PR CI attempts failed the image audit (both apps) and Sword font-size ratchet. These were repaired with image failure handling, original-size decode bounds and scaled Sword badge/clock labels. Focused regression checks cover translations, language switching at 320px, both 08:00 descriptions, source image checksum, unchanged Gospel time semantics and owner visibility policy. Full CI must pass the updated source before public delivery.

Full CI on 09cc0701 completed 5,993 tests plus 16 existing skips with one design-ratchet failure: a newly introduced radius on a small color-legend swatch. The swatch now has the flat square legend geometry, avoiding an off-scale chrome override. The ratchet itself is unchanged; current-head full CI remains required.
