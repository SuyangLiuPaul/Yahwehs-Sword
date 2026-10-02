# Paired 1.7.5 release preparation — 2 October 2026

Both apps use visible version **1.7.5**. Build/version codes remain specific to each
platform and increase from its last accepted delivery. Existing tags and pending
store reviews remain unchanged. This record is preparation, not store publication.

## Update prompts

- Google Play: official flexible in-app update API, current installed package,
  account and track eligibility; download progress and explicit restart; no APK fallback.
- iOS / Mac App Store: public Apple lookup for this app, platform and locale country;
  only a newer public version produces a prompt, with a corresponding store link.
- Microsoft Store: asynchronous StoreContext package-update query, with store link.
  No GitHub installer in a Store package. Windows runner compiled and packaged the integration successfully
  (Words preflight 36979332124; Sword preflight 36979335268). The final
  release must use the final tested tag, not an older preflight artifact.
- Direct APK / EXE: retain the existing corresponding GitHub asset/update flow.
- Web: visible refresh prompt from deployed version metadata, preserving local data.
- Prompt labels and actions cover English, Simplified Chinese and Traditional Chinese.

## Delivery gates

Flutter analysis passed for both complete workspaces before version stamping.
No new tag or store delivery is claimed by this document. Merge only after matching
current-head CI, compile Windows integration before publishing, and retain the
existing initial Apple reviews and Words Microsoft certification. After acceptance,
check the actual signed packages and every applicable track/version before upload.
