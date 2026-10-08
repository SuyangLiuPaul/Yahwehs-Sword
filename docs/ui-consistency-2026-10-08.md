# UI consistency maintenance — 2026-10-08

## Scope

Owner requested minor typography, icon and alignment corrections in both apps,
with local commits and GitHub push only. This is source maintenance after 1.7.16:
no version bump, moved tag, store submission or website deployment.

## Findings and corrections

- Material defaults made update and Advanced tiles smaller than adjacent Settings
  controls, especially under Sword's compact workbench theme. Utility cards now
  share Settings title/body/secondary roles, selected font, theme accent and
  24–32 px icons. Dense research panes retain their intended information density.
- All text roles in both light and dark root themes inherit the selected family
  and CJK fallback; previously only three roles explicitly did so.
- Update cards now have one horizontal inset, removing Words' double inset and
  Sword's edge-hugging icon. Diagnosis cards have clear separation from adjacent
  cards and wrapping action buttons with 48 px minimum targets.
- Diagnosis identifiers use selectable monospace text with a readable minimum;
  reporting, copying, resetting and update-channel behavior are unchanged.

## Audit coverage and limits

The page-source inventory covers 41 `Sword` page files, with shared themes,
font/icon declarations and responsive test coverage inspected. Metadata, chart
labels, scripture text and compact workbench chrome intentionally have distinct
roles rather than a single fixed size. Source inventory is not a claim that every
route/data state was individually screenshot-tested or that every native device
has been inspected.

Existing responsive suites cover Home/workbench-related pages, Settings, About,
Library, reading statistics, search, evidence, study and reference pages (the
exact page list is in `test/responsive_all_pages_smoke_test.dart` and
`test/responsive_overflow_smoke_test.dart`). New utility tests cover English,
Simplified and Traditional Chinese, light/dark themes, 320/390/768/1280 widths
and 1.5x text scaling, plus root font inheritance. Local Chrome Settings previews
were inspected at desktop and phone widths. No production setting was changed.

Evidence and logs: `/Users/pliu0036/Downloads/Yahweh-UI-Consistency-20261008/`.

## Validation

Both Flutter analyses: no issues. Focused responsive/utility suites: Words 150,
Sword 152 passed before the final identifier styling adjustment. Words complete suite: 4,104 passed / 36 skipped before final identifier styling;
Sword final complete suite: 6,143 passed / 10 skipped. Sword final focused font
ratchet/utility/diagnosis: 24 passed. Words final focused responsive/utility/update suite: 151 passed.

## Page-source inventory

These are source inspection entries, not individual screenshot approvals.

- `lib/pages/about_page.dart`
- `lib/pages/atlas_page.dart`
- `lib/pages/bible_principles_page.dart`
- `lib/pages/bible_timeline_page.dart`
- `lib/pages/bible_trivia_page.dart`
- `lib/pages/books_page.dart`
- `lib/pages/changelog_page.dart`
- `lib/pages/chronology_page.dart`
- `lib/pages/command_search_page.dart`
- `lib/pages/evidence_detail_page.dart`
- `lib/pages/evidence_page.dart`
- `lib/pages/family_tree_page.dart`
- `lib/pages/hebrew_kings_page.dart`
- `lib/pages/help_page.dart`
- `lib/pages/highlights_page.dart`
- `lib/pages/illustrations_page.dart`
- `lib/pages/jesus_teachings_page.dart`
- `lib/pages/lexicon_page.dart`
- `lib/pages/library_page.dart`
- `lib/pages/loading_page.dart`
- `lib/pages/map_viewer_page.dart`
- `lib/pages/modern_concordance_page.dart`
- `lib/pages/naves_page.dart`
- `lib/pages/passion_wheel_page.dart`
- `lib/pages/phrasing_page.dart`
- `lib/pages/profile_edit_page.dart`
- `lib/pages/profiles_page.dart`
- `lib/pages/projection_page.dart`
- `lib/pages/radial_chronology_page.dart`
- `lib/pages/sermon_detail_page.dart`
- `lib/pages/sermons_page.dart`
- `lib/pages/settings_page.dart`
- `lib/pages/stats_page.dart`
- `lib/pages/strip_chronology_page.dart`
- `lib/pages/strongs_entry_page.dart`
- `lib/pages/study_principles_page.dart`
- `lib/pages/study_promises_page.dart`
- `lib/pages/study_testaments_page.dart`
- `lib/pages/wheel_sheets.dart`
- `lib/pages/word_list_page.dart`
- `lib/pages/workbench_page.dart`

## Owner-authorized dev/prod rollout — 2026-10-08

The owner subsequently requested dev/prod deployment of this maintenance patch. Sword source `a7db6f768d1cadc4fcfa5df9587b3bb5080af0ad` now serves on dev and prod; version remains 1.7.16. The canonical no-bump release wrapper was used with a temporary serialized CLI wrapper to avoid competing slow uploads. Dev deploy: `6ac70219066351542a3b8b63`; prod: `6ac70349f314894daea991e9`.

Full SHA-256 checks of main.dart.js, flutter_bootstrap.js and version.json matched both sites' built files. Main SHA-256: `604aaadbc0d2e869982cb5c316c71556c15730f9acefede6d1218b481e032b1a`. Startup manifest checks passed (201155 bytes, seven font families). Live Settings was visually inspected on dev and prod at desktop width, and prod at 390 px phone width; icons/insets aligned and diagnostic actions wrapped without overflow.

Evidence: `/Users/pliu0036/Downloads/Yahweh-UI-Consistency-20261008/web-live-verification.json`, deployment log and live screenshots. All nine checked website/domain endpoints matched their respective Words international, Words China or Sword builds. Canonically generated changelog was retained in evidence and only its backed-up source file restored after build/deploy. Unrelated owner PBX edits were preserved. No tag/version/native/store change or remote CI/main merge is claimed for this maintenance branch.
