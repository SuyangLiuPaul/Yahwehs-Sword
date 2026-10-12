# Sword 1.7.21 — web and APK delivery

Owner authorized latest source, dev/prod websites and APK delivery on October 11. Prepared from latest main plus Chinese Genesis display-name changes in locale-aware views; some legacy-key-driven UI still shows the old spelling. This release does not replace, cancel or re-upload the submitted 1.7.17 store packages.

## Included

- Improve offline sermon download recovery and status
- Refine reading, Settings and search layouts across screen sizes
- Correct the Chinese Genesis spelling in locale-aware labels

## Delivery gates

- Source PR [63](https://github.com/SuyangLiuPaul/Yahwehs-Sword/pull/63) merged. Matching-head CI 38139155972 and merged-main CI 38139999702 succeeded (6186 passed / 16 skipped).
- Canonical web deployment complete; all 2 sites serve 1.7.21. Each of seven live resources matches its captured build bytes and SHA-256.
- Signed direct Android APK 1.7.21 published; embedded version, certificate and GitHub digest verified. Phone versionCode 1070021.
- Existing store reviews and Google production qualification remain separate.

## Verification limits

Source/CI and browser checks do not prove physical-device sermon download recovery. Sword has no Words song, AI, Watch or car feature; those physical media limits belong to Words. Preserve existing audio, download records, signing and archives. Chinese Genesis aliases remain accepted; scripture text is unchanged. This is not a UI-wide rename: the 1.7.21 `translateBookName` compatibility function maps displayed `创世记` back to the frozen key `创世纪`, and some headers/selectors show that legacy spelling. The owner reports seeing it in both the Microsoft Store 1.7.21 install and the web version, confirming this is shared display logic rather than a Store-only packaging issue. Do not describe the correction as complete across all screens.

## Genesis compatibility repair

Initial release CI caught obsolete display expectations and a real daily-verse lookup regression: frozen bundle keys retain the old Genesis spelling. Book comparisons now use canonical identity in reference jumps, daily verses and reading/search previews, preserving bundled text and saved keys. Traditional testament grouping accepts the corrected spelling and retains old aliases. However, 1.7.21 did not separate display strings from lookup keys everywhere: `translateBookName` deliberately returns `创世纪` for compatibility, and some UI still renders that value. Uniformly showing `创世记` requires a later source change and screen verification in both apps; the immutable 1.7.21 store packages cannot be changed in place.

## Final website / APK checkpoint

- Immutable v1.7.21 source: `065d97767ca78584037a99c37976c7ea5b51fc3c`. Merged source main: `c2d5765dcffa1f6833fb9eb2ecf02651cb832777`. Tested tag and merge have identical trees.
- Public downloads: https://github.com/SuyangLiuPaul/Yahwehs-Sword/releases/tag/v1.7.21
- Phone release certificate SHA-256: `05e9472033a022e1fad3f8171fa9a1c08ccc36608389835827edb693b46d4344`.
- Live websites: https://seeksparks-dev.netlify.app, https://sword.yahwehword.com.
- Full live proof: `/Users/pliu0036/Downloads/Yahweh-Store-API-20261011/web-sites-1.7.21-paired-full-verification.json` (checked 2026-10-11T12:58:51.301833+00:00). All eight paired sites / 56 resource checks passed.
- APK proof: `/Users/pliu0036/Downloads/Yahweh-Store-API-20261011/github-apks-1721-Sword-verification.json`; retained packages in `apk-1.7.21/` beside it.
- Browser checks: Settings Basic / Advanced expanded and collapsed; actual prod version 1.7.21. Words mobile fresh-load layout also checked. Screenshots retained beside the proof files.
- These are website and GitHub direct-download deliveries. Existing Apple, Google Play and Microsoft Store 1.7.17 submissions were not changed by this task. Store monitoring remains separate.
- Canonical Sword deployment regenerated its bundled changelog from actual git history; this generated history is retained with the final records.

## Apple API upload checkpoint — 2026-10-12

- Uploaded Sword iOS and macOS 1.7.21 / build 1070021 to App Store Connect with the existing API key and Xcode cloud-managed Apple Distribution signing. Both builds are `VALID` in App Store Connect.
- macOS package is universal arm64 + x86_64 and has minimum macOS 12.0, as previously authorized. The isolated Flutter 3.44.2 SDK worktree needed a local Xcode 27 `lipo -verify_arch` compatibility patch; application source and installed SDK were not changed.
- Delivery UUIDs and package SHA-256 values: `/Users/pliu0036/Downloads/Yahweh-Store-API-20261011/apple-1.7.21-upload-proof.json`.
- Upload/validation logs and signed packages are retained under `/Volumes/YahwehRelease1713/Store-1.7.21/Apple/`. No new App Store review was submitted; pending 1.7.17 reviews remain untouched.
- Repeatable steps and existing credential locations (no key material): `/Users/pliu0036/Downloads/Yahweh-Store-API-20261011/apple-api-upload-playbook.md`.

## Store API readiness checkpoint — 2026-10-12

- Read-only Play API preflight 38184030673 succeeded: credentials verified; internal/alpha tracks still contain completed 1.7.17 code 2000021; no 1.7.21 upload. Retained 1.7.21 phone AAB reports code 1070021, below the highest existing code 2000021, so it cannot be uploaded. The Play build code must be corrected above the existing maximum and rebuilt with the same package/signing identity. Existing Play upload workflow also uses outdated 1.7.17 release notes; prepare accurate Sword-specific localized notes before creating a draft.
- Microsoft API preflight verified access and no pending draft before upload. Verified v1.7.21 MSIX was uploaded through the create-only API as draft 1152921505702099459 (source 065d97767ca78584037a99c37976c7ea5b51fc3c; SHA-256 1dc55b0a5e7915ed0365f9bf98ac2bfc524ae8c7bf44e555aa7b3a025cd36001). Partner Center read-back is PendingCommit / package PendingUpload. Certification was not submitted; publication is not claimed. Run 38184160647.
- Backup before this checkpoint: `/Users/pliu0036/Downloads/Yahweh-Store-API-20261011/store-api-1721-checkpoint-20261012-102654/`.


## Google Play / Microsoft Store checkpoint — 2026-10-12 11:51 Melbourne

- Microsoft Sword submission `1152921505702099459` was committed via the guarded API workflow `38188399251`. Exact staged package remains 1.7.21.0 x64, SHA-256 `1dc55b0a5e7915ed0365f9bf98ac2bfc524ae8c7bf44e555aa7b3a025cd36001`; release-note locales `en-us`, `zh-hans`, `zh-hant` verified; API returned `CommitStarted`, automatic publication enabled. This is submitted/processing, not a claim of public publication.
- Sword Play 1.7.21 is available on the existing internal track. Successful workflow `38187507703` uploaded version code `2000023` (SHA-256 `d9ba56f4e319744d7348a61bfc6a5d59d6749c0b5327df1a6fc662857b3eb8c2`); the signed-in Play Console releases overview visibly showed internal release 1.7.21 serving. Existing alpha 1.7.17 remains unchanged.
- Sword Play Console still shows Production inactive, with 12 testers continuously opted in for 7 days of the required 14 and Production access disabled. Do not claim a public production release or bypass qualification.
- Store API preflight `38188508548` did not reach read-only store checks: the repository's legacy guard test expects a literal draft-only parameter that the current guarded uploader no longer uses. No Play/Microsoft mutation occurred in that preflight.
- File-level backup before this checkpoint: `/Users/pliu0036/Downloads/Yahweh-Store-API-20261011/store-api-1721-final-checkpoint-20261012-115100/delivery-sword-1.7.21.md`.
