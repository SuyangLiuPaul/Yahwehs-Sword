# Sword 1.7.24 — paired Genesis display correction

## Source correction

- Corrected the localized display name for Genesis across reading, search, study, saved references, export/share, projection, and verse-note labels. Traditional and Simplified Chinese now use the formal localized name.
- Kept legacy corpus names, saved IDs, lookup aliases, and Scripture text unchanged. Regression tests cover display labels and persisted identities.
- Merged source PR [#72](https://github.com/SuyangLiuPaul/Yahwehs-Sword/pull/72) at `3ceaa523`; exact source CI run `38217746210` passed, including the full Flutter test job.
- The same PR fixes the Play release-note loader to accept the repository's three-locale map as well as API-style records, with required-language validation and regression tests. Guard tests passed locally (22). The pre-existing owner edit in `assets/changelog.json` was not included.

## 1.7.24 preparation

- Paired release branch is being prepared from merged main. Visible version target: **1.7.24**; Apple build target **1070024**. Play phone code remains workflow-allocated and must be validated against the current Play API before upload.
- Localized Play and Microsoft release notes are prepared in `store-notes-1.7.24.json` and `microsoft-store-release-notes-1.7.24.json`.
- The in-app changelog asset has been regenerated for 1.7.24 from the merged commit history; CI caught and rejected the stale 1.7.23 asset before merge.
- **No 1.7.24 tag, package build, website deployment, or store upload is claimed yet.** Before each upload, read current store state and preserve active reviews/drafts. Upload, processing, review, and public availability are separate states.

## Verification limits

- Static analysis and the paired display, saved-reference, projection and verse-note regression suites passed in the source PR. Store package validation and live screens for the 1.7.24 build remain pending.
- Genesis data keys and original Scripture content are intentionally unchanged.

## 2026-10-13 00:00 Melbourne delivery checkpoint (supersedes the earlier pending-package note)

- Immutable `v1.7.24` remains unchanged. The GitHub release carries the 1.7.24 Android APK, Windows EXE/ZIP, macOS ZIP, Linux archive, and unsigned iOS CI artifact; these are direct-download assets, not store uploads. Previously verified web deployments remain on 1.7.24.
- Apple App Store Connect accepted and processed all four paired 1.7.24/1070024 builds as `VALID`; both Mac builds target minimum macOS 12. Sword iOS build `d232c63c-da34-4c85-b4c8-d45688031d94`, Mac build `43fa553d-fa79-4273-953e-ce629d9e40a5`. Its iOS package SHA-256 is `a266328b8f6d109e88fb1be3907efe6858ce593e43bb5710a7073b81fd9bcb86`; Mac package SHA-256 is `dc4489ed63a740f70c22b2bae4aaea95092195ee446cf8ce5a1c87f885d1aefb`. Paired build states/evidence are in `/Users/pliu0036/Downloads/Yahweh-Store-API-20261011/apple-1724-processing.json`. This is package processing only; no new 1.7.24 App Store version was submitted. The existing Sword 1.7.22 iOS/macOS initial public reviews remain pending and were not removed.
- Google Play run `38224359377`, source SHA `fc2901cb807cb0c80ae35b707f6986dccca32a0c`, uploaded signed phone AAB code `2000027`, SHA-256 `5eee463b1642f10ab17570828fac95c0521b4c6700d5edf7946538b72824a065`, to the existing `internal` track as `completed`. Read-only API run `38251903748` confirmed that internal track state. It is available to internal testers only; production remains empty and subject to the real tester qualification gate.
- Microsoft Store MSIX exact SHA-256 `a142b871f746ca6d1429843edeffd33b37182e38bf152afc808bdf298702f0a7`, version `1.7.24.0` x64, came from build run `38226914550`. Existing submission `1152921505702101034` reads `PendingCommit` and contains the previous uploaded 1.7.22 package. Guarded update attempt `38251852939` returned HTTP 409 on the draft PUT and did not upload or commit the new package. PR #74 merged the exact-draft safety workflow; PR #75 changes the 1.7.24 upload filename to avoid colliding with the old package. At this checkpoint PR #75 CI is still running. Do not claim package staging or submission until Microsoft storage is read back and its SHA matches.
- Paired Words status: its four Apple builds are also `VALID`; Google phone/Wear codes `20003066` and `20003067` are available on separate `internal` and `wear:internal` tracks; its Microsoft workflow returned `CommitStarted` for the existing draft and still needs certification/publication readback.

No App Store review was canceled, no duplicate Store submission was created, and no immutable package was rebuilt. Internal availability, review, certification, approval, and public release remain distinct.
