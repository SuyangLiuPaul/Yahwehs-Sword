# Sword 1.7.21 — web and APK delivery

Owner authorized latest source, dev/prod websites and APK delivery on October 11. Prepared from latest main plus the local Chinese Genesis display correction. This release does not replace, cancel or re-upload the submitted 1.7.17 store packages.

## Included

- Improve offline sermon download recovery and status
- Refine reading, Settings and search layouts across screen sizes
- Correct the Chinese Genesis book display name

## Delivery gates

- Source PR [63](https://github.com/SuyangLiuPaul/Yahwehs-Sword/pull/63) merged. Matching-head CI 38139155972 and merged-main CI 38139999702 succeeded (6186 passed / 16 skipped).
- Canonical web deployment complete; all 2 sites serve 1.7.21. Each of seven live resources matches its captured build bytes and SHA-256.
- Signed direct Android APK 1.7.21 published; embedded version, certificate and GitHub digest verified. Phone versionCode 1070021.
- Existing store reviews and Google production qualification remain separate.

## Verification limits

Source/CI and browser checks do not prove physical-device sermon download recovery. Sword has no Words song, AI, Watch or car feature; those physical media limits belong to Words. Preserve existing audio, download records, signing and archives. Chinese Genesis aliases remain accepted; scripture text is unchanged.

## Genesis compatibility repair

Initial release CI caught obsolete display expectations and a real daily-verse lookup regression: frozen bundle keys retain the old Genesis spelling. Book comparisons now use canonical identity in reference jumps, daily verses and reading/search previews, preserving bundled text and saved keys. Traditional testament grouping accepts the corrected spelling and retains old aliases.

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
