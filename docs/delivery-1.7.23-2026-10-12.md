# Sword 1.7.23 — Genesis reader header correction

## Scope

- Display the formal localized Genesis name (`创世记` / `創世記`) in both full and compact reading headers, matching the book list and existing reference-navigation labels.
- Preserve the frozen corpus key (`创世纪` / `創世紀`) for data lookup, URLs, saved reading state and existing bundles. Scripture text and approved store descriptions/screenshots are unchanged.
- Paired Words and Sword release.

## Source and checks

- Header fix PR #70 merged to main as `092cddfe95bafabb15b23c2b97c60b6b041b921b`.
- PR CI run `38202500541` passed, including analyzer and full Flutter tests.
- Matching main CI run `38203406520` is pending at this checkpoint.
- Release version bump is prepared on `release/1.7.23-genesis-reader`; version `1.7.23+1070023`, not tagged or uploaded yet.

## Platform delivery

- Web dev/prod, GitHub platform packages, Apple iOS/macOS, Google Play phone/Wear, and Microsoft Store: pending 1.7.23 exact-head build and validation.
- Existing 1.7.22 submissions are still pending review and will be preserved until the matching 1.7.23 packages are uploaded and validated. No already published version is to be delisted.
- Google production eligibility remains a separate tester-qualification gate; internal/alpha availability must not be described as public production.

## Localized release notes

See `store-notes-1.7.23.json` and `microsoft-store-release-notes-1.7.23.json`.
