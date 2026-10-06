# Sword1.7.12 delivery — 6 October 2026

## Verified source and scope

- Owner authorized paired release, Words then Sword. Sword1.7.12 includes admin announcements/feedback/channel update integration and readable wrapping pane titles for English, Simplified and Traditional Chinese, including enlarged text. No audio/watch/car/Firebase account features are claimed for Sword.
- PR35: https://github.com/SuyangLiuPaul/Yahwehs-Sword/pull/35 merged. Tested source `1d83f03d3da733540c55bce623cb0853dee9437d`, main merge `027ba83ff6980d338402fc4bdc7cc8656c39d887`.
- Exact-head CI37434302657 successful:6,089 passed,16 skips, analyzer clean. Earlier f6a81f1 failed3 changelog assertions; full canonical history regenerated, checks retained.
- Visible version1.7.12; Apple build1070012. Frozen Bible text and stable IDs/routes preserved.

## Local native packages verified, not uploaded

- iOS archive/export in `/Users/pliu0036/Downloads/Yahweh-Release-1711/Sword-iOS-1.7.12.xcarchive` and `Sword-iOS-1.7.12-export/Yahweh’s Sword.ipa`. Actual exported distribution IPA1.7.12/1070012, iOS15 minimum, strict signing valid, get-task-allow=false. SHA256 `09d4b30e8c8ef15e1343dd6a26683e21f150474883b53d5c6d686a4248c7622c`.
- Mac archive/export `Sword-Mac-1.7.12.xcarchive` and `Sword-Mac-1.7.12-export/Yahweh’s Sword.pkg` in the same evidence folder.1.7.12/1070012, minimummacOS10.15, arm64+x86_64, strict app signing and installer signature valid. SHA256 `e07b84b927d8987024ae873a91fa37ab8f84853df14bb90728dd714722c14fdb`.
- Verification: `sword-distribution-1712-verification.json`. No duplicate archive required.

## Channel status at20:18Melbourne

No Sword1.7.12 tag, GitHub installer, website deployment or store upload yet. Canonical GitHub dry-run at the tested source succeeded. Wait for Words web deployment, then tag exactly this source once and trigger the missing Play/MSIX workflows once; validate artifacts before store upload. Existing older public/beta reviews must not be removed. Never use an unsigned GitHub IPA as a store package.

Google Data Safety7actual types are saved as queued changes, not submitted/public: optionalName/Email/ApproxLocation/OtherUGC for feedback; default aggregateAppInteractions for functionality+analytics; automaticCrash/Diagnostics for functionality+analytics. No UID/account/search-sync claim. Apple privacy7types published accurately: optional feedbackName/Email/CoarseLocation/CustomerSupport linked; anonymousProductInteraction functionality+analytics unlinked; Crash/OtherDiagnostics unlinked, all nontracking. Approved descriptions/screenshots and pending public reviews preserved. Proofs `google-sword-data-safety-1712-queued.png` and `apple-sword-privacy-1712-published.png`.

## Release gates

1. GitHub immutable1.7.12 tag and all5native workflows; actual6installable assets/digests/signatures.
2. Google correctPHONEbundle to existing internal/Alpha tracks; independently monotonic versionCode; preserve tester lists/qualification and old pending review.
3. Latest validatedMicrosoftMSIX, correct identity/publisher/SHA,3localized notes, approved assets, automatic publication.
4. Signed iOS/Mac uploads accepted/processed; accurate standard encryption/FranceNo; existing internal/Public groups and automatic notification. Preserve all existing reviews.
5. Two web deployments via canonical `--no-bump --include-prod` after Words; actual live full fingerprints.
6. Admin channel registry only reflects genuinely available versions; latest internal/beta is not public production.
7. Final storage cleanup only after latest upload/validation gates and no active build/upload; retain signing/packages/archives/dSYMs/T7images and personal files.

Owner unrelated dirty `macos/Runner.xcodeproj/project.pbxproj` SHA256 `06a794e396afda48e413fd5d82f4c9978985c7a012d0aef9af0ba9fadaf3ed04` preserved. Stage only named docs. Source tags must remain immutable. Physical AndroidAuto/Watch/car audible routing remain open in Words. Automationwords-sword remains paused at10hourinterval. Do not work on yahwehdehua.

## October6 follow-up: immutable tag and upload started

Owner reiterated all-platform latest delivery. Immutable v1.7.12 now points to the tested source1d83f03d3da733540c55bce623cb0853dee9437d. Five tag workflows started once: Windows37443858673, Linux37443858712, iOS37443858756, macOS37443858810, Android37443861114. PlayAAB37443891768 and MicrosoftMSIX37443896050 dispatched once at the same tag. Linux succeeded at the first check; remaining workflows were active. Do not duplicate builds.

Verified local iOS and Mac1070012 packages were imported into Transporter and Deliver clicked once each. Both uploads are active; delivery/processing/group assignments are not yet confirmed. Preserve pending reviews and do not duplicate uploads. Web deploy must remain sequential after Words; Words China upload is currently stalled at the main.dart.js upload and has no confirmed failure/ready result.

Words Home compact groups are a separate next-release source PR44, not part of either immutable1.7.12 package. No newer tag is claimed.

## October6 21:00 Melbourne verified delivery checkpoint

All seven tag build jobs succeeded at immutable1d83f03d3da733540c55bce623cb0853dee9437d. GitHub v1.7.12 is public with six named installable assets and saved professional notes; remote SHA256 digests recorded, downloaded Android APK digest matched and apksigner verification passed with JDK17. Evidence sword-github-1712-verification.json and sword-github-apk-1712-verification.json.

Google PHONE1.7.12/2000016 bundle accepted and published once to existing internal track4701487655638464702 release8 at21:00, visibly Available to internal testers. All3note languages and tester access preserved. This is internal distribution, not public production. Evidence google-sword-internal-1712-published.png and sword-play-1712-verification.json. Alpha1.7.12 preparation is active; no new Alpha review/publication claimed yet.

Microsoft verified1.7.12.0 x64 package uploaded, validated and submitted once as submission9/1152921505702054468. All3localized What's-new notes saved; approved descriptions, screenshots, markets, audience and automatic publication preserved. Portal explicitly In certification / Step2Pre-processing. Prior published1.7.8.0 remains current public until certification and publishing finish. Proof microsoft-sword-1712-submitted.png and sword-msix-1712-verification.json. Never cancel or duplicate this submission.

Both signed Apple packages visibly DELIVERED: iOS20:54 and Mac20:59,1.7.12/1070012. All four paired Words/Sword latest packages accepted by Transporter. iOS finished processing there, Mac now processed in App Store Connect; accurate standard encryption outside AppleOS and FranceNo saved. Existing internal Sword group with1owner assigned, prepared genuine bilingual notes saved, Public beta group submission initiated. Confirm explicit Waiting for Review before claiming external review. No re-upload or old-review cancellation. Evidence apple-all-four-1712-delivered.png and sword-apple-transporter-1712-delivered.json.

Admin Sword registry saved and reloaded: GitHub/APK/Mac-download/Windows-download/Linux-download1.7.12; Web1.7.8; Microsoft public1.7.8; Google/iOS/MacStore public latest blank where unverified. Three genuine notes saved. No force/minimum changes. Proof admin-sword-1712-persisted.png.

Words compact Home PR44 passed exact-head CI37444177551 at4e2ca63694340860f0361e3bf8a17553aa9f5f55 and merged e495fea3c82378e90b0bb559182710f6f1aaef61. This runtime change is after immutable1.7.12 and requires a new version; no new tag/package claims. Words China main.dart.js upload remains blocked in Netlify; Sword web waits for the Words canonical wrapper to end, preserving sequential deployment. Final storage cleanup remains gated.

## Subsequent verified Apple/Google checkpoint

Sword Mac12/1070012 buildde2d63c2-2b6e-4d09-9068-9983f9a17943 explicitly Waiting for Review in App Store Connect. Existing internalSword1owner and Public beta assigned; standard encryption outsideAppleOS/FranceNo saved; automatic tester notification selected and genuine notes saved. Proof apple-sword-mac-1712-external-submitted.png. iOS ASC Build Uploads still Processing; its explicit Date Created20:59 supersedes the earlier provisional association of Transporter delivery times. Both native12 packages DELIVERED; no duplicate upload.

Google Alpha12/2000016 selected from accepted existing library,3language notes saved,100%rollout saved and sent together with accurate DataSafety. Publishing overview explicitly Changes in review, quick checks running; no pending review cancelled. Proof google-sword-alpha-1712-submitted.png. Internalrelease8 remains Available; public production qualification remains unmet.

## Final native1.7.12 Apple checkpoint

Sword iOS build5e4f701b-4f9f-40a5-ac62-cde172b9669a now explicitly Waiting for Review, with existing internalSword1owner and Public beta assigned, genuine current notes and automatic notification. Both newSword1070012 builds processed and compliance saved; all four paired1.7.12 external beta submissions Waiting for Review. Do not duplicate. Proof apple-sword-ios-1712-external-submitted.png; Apple notes apple-sword-test-notes-1712.json.

Fresh Distribution page explicitly shows Sword initial/public iOS1.7.8/build1070009 Waiting for Review and Mac1.6.329 Waiting for Review, automatic release selected. No rejection visible and no review altered. Latest12 public selection must wait until these reviews finish; changing pending builds would require removal from review. Proof apple-sword-public-reviews-preserved-1712.png.

## October6 21:52 Melbourne — both Sword websites verified1.7.12

Canonical no-bump/prod web build ran only after all six Words sites passed full live fingerprint checks. Sword dev completed; the prod upload client remained active while production still8, so only that known client was stopped, preserving its server deploy. A normal official CLI retry of the exact same built directory then completed production. No source/runtime/version rebuild or old-review cancellation.

Both https://seeksparks-dev.netlify.app and https://sword.yahwehword.com now serve1.7.12/1070012, full main.dart.js10,333,991bytes SHA256257bf82e5610959d186d61793682f35656dc13e1abba3b752d6b735c343ef54c and bootstrapf1b8a7993f91c929acd640e5faa00e210928e7003a4ec6b5289f6e2f2b39b889 match the local canonical bundle. Evidence sword-web-1712-full-verification.json and paired-all-eight-web-1712-verification.json. Actual built Sword browser page inspected and captured in sword-web-1712-live.png. All8pairedsites now12; no public store-review completion is inferred.

Admin Sword Web12 and genuine notes in3languages saved after verification; persistence verified by reload and Sword re-selection (admin-sword-web-1712-persisted.png). Public Google/iOS/MacStore rows remain unverified/blank; Microsoft8 public remains until submitted12 certification/publishing finishes. GitHub rows12 available. All4Applelatestexternal betas WaitingforReview and native Google/MS statuses above preserved. Home compact groups are separate next-version Words source, not12. Sword ownerPBX hash06a794e396afda48e413fd5d82f4c9978985c7a012d0aef9af0ba9fadaf3ed04 unchanged. Do not work on yahwehdehua.


## October6 22:00 Melbourne — Microsoft1.7.12 published and final cache cleanup

Fresh authorized visible Partner Center reload confirms Sword Submission9/1152921505702054468 PUBLISHED: Congrats your product is now updated, latest product available, Store presence Submission9, Start update enabled. This supersedes earlier certification checkpoints. Validated immutable1.7.12.0 package identity/source/hash preserved; no duplicate submission. Screenshot microsoft-sword-1712-published.png in /Users/pliu0036/Downloads/Yahweh-Release-1711. Admin Microsoft latest12 saved after publication; Web/GitHub12 remain verified. Apple/Google review/test qualification gates remain separate.

All8pairedwebsites verified12 by full live main/bootstrap bytes; admin Web12 persisted for both. After confirming no active build/upload, T7 available, no cache file open, no signing/package/archive/dSYM/symlink in selected cache paths, removed only3regenerable project test_cache directories and Gradle8.11.1/9.3.1 transforms. Net reclaimed6.842GiB, free36.014GiB immediately after; per-file hashes/inventory storage-final-1712-cleanup.json and gradle-*-transforms-removed-1712.sha256.tsv retained locally. No new archive transfer; existing /Volumes/T7/Yahweh-Release-Backups-20261002 and sparseimages, latest packages, all signed archives/dSYMs/source/signing/owner/personal data preserved. Sword owner PBX SHA unchanged. This completes the1.7.12 upload-gated cache pass, not remaining public-review follow-up. Automation remains paused; do not delete/resume without completing/reconciling follow-up.

Home compact groups merged after immutable12, still need a new paired version/package; no newer tag claimed. Physical Watch/Wear/vehicle audio/call recovery and actual AndroidAuto remain unverified. Do not work on yahwehdehua.

