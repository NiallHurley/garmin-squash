# Squash Lite Maintainer Notes

Last updated: 2026-03-01

## Current release state

- Latest local tag: `v4.4.4` on commit `1be805f`.
- Branch: `Lite`.

## What changed in v4.4.4

- Activity type logic now prefers:
  - `SPORT_RACKET + SUB_SPORT_SQUASH` when runtime supports it.
  - Generic fallback when not supported or session creation fails.
- Tennis fallback was removed in follow-up local edits.
- Added FIT debug field `SessionType`:
  - `1` = squash path used
  - `3` = generic fallback used
- Round-screen/Fenix time clipping in the main view was reduced.
- VS Code tasks were updated for more reliable simulator launch/run.

## Important publishing note

For Connect IQ Store updates, the app must be signed with the exact same private key
as previous published versions.

- If upload says `Signature check has failed`, the wrong key is being used.
- `manifest.xml` app ID must also match the existing app listing for updates.

## Build commands

Build PRG for simulator/device testing:

```bash
"/Users/nhur/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-8.4.1-2026-02-03-e9f77eeaa/bin/monkeyc" -o "/Users/nhur/code/squashlite/garmin-squash/bin/garminsquash.prg" -f "/Users/nhur/code/squashlite/garmin-squash/monkey.jungle" -y "/Users/nhur/code/squashlite/garmin-squash/developer_key" -d fenix6pro_sim -w
```

Build store package (`.iq`) for upload:

```bash
"/Users/nhur/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-8.4.1-2026-02-03-e9f77eeaa/bin/monkeyc" -e -r -o "/Users/nhur/code/squashlite/garmin-squash/bin/garminsquash-v4.4.4.iq" -f "/Users/nhur/code/squashlite/garmin-squash/monkey.jungle" -y "/ABS/PATH/TO/ORIGINAL_PUBLISHING_KEY" -w
```

Validate the `.iq` package contains a manifest:

```bash
unzip -l "/Users/nhur/code/squashlite/garmin-squash/bin/garminsquash-v4.4.4.iq"
```

## Known cleanup warnings (non-blocking)

- `resources/menus/menu.xml`: menu labels should use `label="..."` attribute.
- Launcher icon mismatch warnings on some devices (`30x22` source scaled to `40x40`).

