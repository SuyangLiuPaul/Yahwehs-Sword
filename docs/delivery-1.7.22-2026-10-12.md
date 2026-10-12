# Sword 1.7.22 — Chinese Genesis display correction

## Scope

- Show the formal Chinese Genesis book name in user-visible book selection and reference navigation while retaining the legacy internal corpus key and saved-reading compatibility.
- Scripture text and approved listing copy are unchanged.
- Paired Words and Sword release; this document is the Sword delivery record.

## Source and checks

- Display repair PR #67, tested head `ec28250970c9634ef575b32438346b62d8c2db51`; PR CI run `38191323577` passed.
- Merged main commit `05e863e90e6dde3dee93837269dab0870bd5b08c`.
- Merged-main CI run `38192216566`, attempt 2, passed. The first attempt exposed one unrelated timing-sensitive permission-flow assertion in `test/update_check_tile_test.dart`; the focused test also passes locally.
- Focused book-display regression checks passed before merge.

## Version 1.7.22 delivery

- Version bump, exact-head CI, immutable tag, five GitHub builds, Apple, Google Play, Microsoft Store, and sequential Words-then-Sword website deployments: pending.
- Do not replace any live 1.7.21 package until the matching 1.7.22 package is validated and the store accepts the replacement.
- Preserve pending reviews, approved metadata/screenshots, all three release-note locales, package identity, signer, and existing release artifacts.

## Localized store notes

See `store-notes-1.7.22.json` and `microsoft-store-release-notes-1.7.22.json`.
