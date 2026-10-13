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

## 2026-10-13 00:22 Melbourne follow-up

- Sword Microsoft follow-up PR #75 passed full Flutter CI run `38253081262` and merged to `main` at the current release branch head. The updated guarded uploader uses the unique filename `yahwehs_sword-1.7.24.msix` while preserving the package identity and exact MSIX SHA.
- A single guarded staging attempt from exact build run `38226914550` / source SHA `fc2901cb807cb0c80ae35b707f6986dccca32a0c` still returned HTTP 409 on the existing submission metadata PUT (workflow `38254635890`). It did not upload a blob or commit the submission. A fresh read-only API check (`38254871517`) confirms the same submission `1152921505702101034` remains `PendingCommit` with only the prior `1.7.22.0` package marked `Uploaded`; the 1.7.24 package is not staged. Do not repeat the PUT or create a replacement draft without resolving Microsoft's conflict reason.
- Words delivery checkpoint PR #94 passed both CI jobs and merged to `main` at `0de1fd9f25cf1cc18b57e329ae7109c35b1a3e46`.
- Apple and Play states above have not changed: four Apple builds are processed but no new 1.7.24 App Store version is submitted; Play phone remains internal-only. Existing Apple reviews and Microsoft draft are preserved.


## 2026-10-14 Melbourne — 1.7.24 store submission checkpoint

This checkpoint supersedes the earlier processed-only Apple and draft-only Microsoft status. Existing immutable packages and v1.7.24 tags were reused; no runtime rebuild or website deployment was performed during this follow-up.

- **Apple public:** Words and Sword iOS/macOS are now **1.7.24 / 1070024, WAITING_FOR_REVIEW**, with automatic release (`AFTER_APPROVAL`). The owner explicitly authorized withdrawing Words Mac 1.7.17 and Sword iOS/Mac 1.7.22 to replace those three reviews with 1.7.24. Metadata, approved copy, screenshots and review contacts were backed up and preserved. Words iOS received a new 1.7.24 update using its processed matching build. Do not cancel or duplicate these latest submissions.
- **TestFlight:** all four matching 1070024 builds have completed export compliance and are assigned to the existing internal app groups and existing “Public beta — iPhone, iPad & Mac” groups. Read-only group/build checks confirm both latest builds in each internal group. Internal state is `IN_BETA_TESTING`; external state is `WAITING_FOR_BETA_REVIEW`, review `WAITING_FOR_REVIEW`, with automatic tester notification enabled. This is not external review approval.
- **Microsoft:** both products are publicly updated to **1.7.24.0 x64**. Fresh Partner Center overviews explicitly show latest product available and Start update enabled; Store presence package lists confirm the actual version. Words submission `1152921505702102644`, Sword submission `1152921505702101034`. Sword's previous API metadata PUT HTTP 409 was resolved via the normal visible Chrome package upload/validation/save/certification workflow on the existing submission. No duplicate drafts, API recommits or new uploads were made today.
- **Play internal:** Words phone `20003066`, Words Wear `20003067` on separate `wear:internal`, and Sword phone `2000027` remain latest 1.7.24. Both phone console release details explicitly show 1.7.24 available to internal testers, with no old bundle retained in the latest release.
- **Play Alpha:** Sword 1.7.24 / `2000027` was promoted from internal to the existing Alpha track (`4700361979404676484`, release 13), with genuine `en-GB`, `zh-CN`, `zh-TW` release notes. Quick checks finished and Publishing overview now explicitly says **Changes in review**. Words 1.7.24 / `20003066` is prepared on its existing Alpha track (`4700819854664007448`) with the same three note languages, but **not sent**: Google explicitly warns that submitting now cancels/restarts the review in progress since October 12 (including existing Data safety changes). The owner decision is pending; do not click Restart review without the requested confirmation. Preserve the prepared draft and existing review meanwhile.
- **Play production:** both dashboards currently show **12 opted-in testers for 9 continuous days**, requiring at least **12 testers for 14 continuous days**. Apply for production is disabled. Prior notes saying 14 required testers were incorrect. Neither app is public Play production yet; never invent qualification answers or bypass this gate.
- **Device investigation:** read-only package metadata on the connected Mi Pad shows Play-installed Sword 1.7.24 and Words 1.7.4. Words' console still lists older 1.6.32 as the served Alpha version while changes await review. The correct Words internal opt-in link is `https://play.google.com/apps/internaltest/4701597346876713171`; the selected owner tester list includes the owner's existing Google account. Device Play account confirmation is pending. Do not uninstall or sideload over the official Play package to hide a track/account problem.
- **Sword Apple delay:** the previously active 1.7.22 initial reviews were submitted October 12 at 14:46/14:47 Melbourne, and remained Waiting for Review. Historical entries show earlier submissions removed. The current review detail pages did not show a rejection or request for additional information. Apple's reason for the delay and approval date are not established. Latest 1.7.24 was requeued today under the owner's explicit instruction.

### Exact Apple identities and proof

- Words iOS build `12f45098-8c68-4903-b1a6-5972185c7385`, public version `24cb15c4-01bd-4bf2-b09a-7bfcbb3c93d2`, review `72db831d-efe2-4509-83f4-f36e4e4e2e8f`.
- Words Mac build `f2a5a538-d498-4bb5-a0a3-9545c54ee84f`, public version `c552ae02-bb7a-4f2c-bab6-2d4f0d673cf8`, review `ae9c4e7a-50c6-44a4-8f5a-ef1eabd5dc7a`.
- Sword iOS build `d232c63c-da34-4c85-b4c8-d45688031d94`, public version `8a98fd99-cbdd-4a16-9753-6f725fa087be`, review `b1db3f8e-a9cd-475d-aff8-33e4c3298603`.
- Sword Mac build `43fa553d-fa79-4273-953e-ce629d9e40a5`, public version `72448c5b-5a68-4695-9ef5-0b09627a8eb8`, review `639b5c7c-1573-4829-8947-a42c43c5b51f`.

Local evidence folder: `/Users/pliu0036/Downloads/Yahweh-Store-API-20261011/`. Files: `apple-final-1724-20261014.json`, `apple-beta-submitted-1724.json`, `apple-words-submitted-1724.json`, `apple-sword-submitted-1724.json`, `apple-words-1724-all-submitted-20261014.png`, `apple-sword-1724-all-submitted-20261014.png`, `ms-words-1724-live-20261014.txt`, `ms-sword-1724-live-20261014.txt`, `play-sword-1724-alpha-in-review.png`, and `play-words-1724-restart-review-confirmation.png`. Backups with contacts stay protected locally and are not committed.

### Reusable follow-up sequence

1. Read the newest checkpoint; compare exact app/platform/version/build/processing state before writing. Reuse VALID packages and existing tracks/submissions; never rebuild just to poll.
2. Apple: confirm actual encryption scope against the previous approved answer and source changes, complete compliance, assign existing groups and genuine beta notes, submit beta review once, then select the exact build on the public version. Use `reviewSubmissions` and `reviewSubmissionItems`, submit once, and read back `WAITING_FOR_REVIEW` plus the selected build and release type. Cancellation is asynchronous: only after explicit authorization, cancel the exact old review, wait until it is removed, preserve the same version metadata/screenshots, then replace and resubmit. Current scripts in the evidence folder are pinned to this delivery and must not be blindly rerun.
3. Play: verify separate phone/Wear AAB identities and codes. Promote an already accepted internal phone AAB to the existing Alpha track, fill all required locales (this console requires `en-GB`), preview the complete rollout and save. Inspect Publishing overview and wait for quick checks to finish. A track API `completed` value alone does not prove review approval. If the UI warns of cancelling/restarting an existing review, stop for the concrete owner decision.
4. Microsoft: when guarded API PUT fails 409 before upload, read the existing submission rather than creating a duplicate. If the owner authorized the visible fallback, use the same draft, upload the verified exact MSIX, wait for Uploaded/validation, save, inspect all three notes and immediate publication, submit once. Read Store presence actual package version and the publication banner before recording public availability.
5. Record changed states immediately, preserving owner edits and credentials. Stage only named documentation files. Review approval, beta availability and public production remain distinct.
