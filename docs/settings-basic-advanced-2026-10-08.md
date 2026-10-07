# Basic and Advanced web Settings — 2026-10-08

Owner authorized paired dev/prod WEBSITE deployment and GitHub/documentation updates. No version bump, release tag, native build, store submission or admin database mutation.

Web Settings defaults to Basic: account, interface language, font/menu size, light/dark/system theme, reading mode, update check and diagnosis ID. Advanced expands on demand: detailed appearance, copy formats, projection, reading tools/cache, notification preferences, import/export; Words also contains Home layout and AI configuration. Sword has no AI or companion settings introduced by this change.

The original control widgets and handlers are retained. Original section links auto-expand Advanced when needed, including later changes to the initial section. A simple disclosure avoids animated height estimation that previously destabilized Settings scrolling. Native Settings keeps its original order through kIsWeb gating; installed packages are untouched.

Both changed Settings files passed Flutter 3.44.2 static analysis. Deployment and browser verification results will be appended after completion. About/CN official badge layout from the prior mobile pass is included in Words. Portal mobile CSS remains separately committed locally, pending explicit portal deployment.

Evidence/log folder: /Users/pliu0036/Downloads/Yahweh-Settings-Tiers-20261008/.

## October8 — Basic/Advanced web Settings delivered

Web Settings now defaults to Basic, with expandable Advanced for detailed appearance, reading/copy tools, notifications and maintenance/import/export. About remains a compact summary. Version stays 1.7.15; native/store binaries and tags are unchanged. No AI, media or companion capabilities were added to Sword.

PR42 source 4d683d28803c5621ecffe5569a8d906122c82110 passed exact-head CI37687027309 and merged e41678bd7de0e0460711a59c2ced06328b9df479. Earlier c94fbf66 failed because AppMotion was undefined in Sword; the explicit scroll duration repair and final source both passed subsequent full CI.

Canonical no-bump build completed and dev published. The stopped concurrent production upload made the wrapper return nonzero; an official CLI retry of the SAME built directory then published production successfully (deploy6ac6beece73590792485ec4b). Full byte/SHA256 verification across both Sword hosts and sword.yahwehword.com, including startup manifests, matched the canonical build. All ten paired website/domain endpoints matched their respective international/China/Sword builds. The live dev page was visually checked at 390x844 in simplified Chinese: Basic rendered without overflow and Advanced toggled from collapsed to detailed controls. Evidence/logs/screenshots: /Users/pliu0036/Downloads/Yahweh-Settings-Tiers-20261008/. No account/database/security mutation; primary owner PBX override preserved.

