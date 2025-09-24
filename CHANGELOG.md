# Release Notes

## [Unreleased]

## [v2.3.0] - 2025-09-24

- Updated values in ssf.txt. 38.06% checked. (1113 of 2924)
- Added CHANGELOG.md

## [v2.2.0] - 2025-04-10

- Updated values in ssf.txt. 35.26% checked. (1032 of 2927)

## [v2.1.0] - 2025-01-16

- Updated values in ssf.txt. 5.88% checked. (172 of 2923)
- Fixed "Black out screen during startup" and "Mute audio during startup" settings not saving. [Issue #12](https://github.com/Jakobud/skipstartupframes/issues/12)
- Fixed plugin not working with games that have an "\_" in the ROMname. [Issue #14](https://github.com/Jakobud/skipstartupframes/issues/14)

## [v2.0.0] - 2024-12-15

- Added optional format to support soft reset (F3) frame numbers. [Discussion #9](https://github.com/Jakobud/skipstartupframes/discussions/9)
- Added Plugin Options Menu lines for `Use alternate frames for a soft reset` and `Soft reset frames`. [Commit ecc9dad](https://github.com/Jakobud/skipstartupframes/commit/ecc9dad7519e5e0d361639a2ac53495132a9256f)
- Added ssf_custom.txt for saving/customizing frame numbers. [Discussion #10](https://github.com/Jakobud/skipstartupframes/discussions/10)
- Massive code refactoring, split into modular files. [Commit ee55040](https://github.com/Jakobud/skipstartupframes/commit/ee55040c1d171145b83f443fe9993a28982a4c8b)
- Updated values in ssf.txt
- Fixed debug and debug slow motion toggling. [Issue #8](https://github.com/Jakobud/skipstartupframes/issues/8)

## [v1.3.0] - 2024-11-20

- Added Plugin Option Menu item to adjust frames for current game. [Feature suggested in BYOAC forums thread](https://forum.arcadecontrols.com/index.php/topic,169017.msg1775271.html#msg1775271)
- Added Plugin Options Menu Close when ESCAPE is pressed. [Commit 6ae6452](https://github.com/Jakobud/skipstartupframes/commit/6ae64521b8bd34ad3834f533f587e6e179360c81)
- Set ssf.txt to save when exiting a game or exiting MAME. [Commit cf341d6](https://github.com/Jakobud/skipstartupframes/commit/cf341d6dce55d833542c802e82656a85e83431bb)
- Added preservation of frame target for current game when restarting (F3) a game. [Commit cf341d6](https://github.com/Jakobud/skipstartupframes/commit/cf341d6dce55d833542c802e82656a85e83431bb)
- Ensure that frameTarget is always set to zero for non-existent or negative pre-existing values. [Commit 3f50fa5](https://github.com/Jakobud/skipstartupframes/commit/3f50fa50592dcd6cdcb00d5fd40e75a1f5cccd05)
- Updated values in ssf.txt
- Value from ssf.txt is loaded anytime a game is started or reset. [Issue #3](https://github.com/Jakobud/skipstartupframes/issues/3)
- Fixed alphabetical order of ssf.txt. [Commit eeddef5](https://github.com/Jakobud/skipstartupframes/commit/eeddef510d2664427369df1a45b7e51db524395f)

## [v1.2.0] - 2024-11-20

- Updated values in ssf.txt

## [v1.1.0] - 2024-11-13

- Improved screen blackout to apply to all screens for multi-screen games. [Commit f9b7b62](https://github.com/Jakobud/skipstartupframes/commit/f9b7b623d5883190c5487305bd0ccb10a0d4dbe2)
- Fixed issue with wrong screen device tag causing a crash. [Issue reported in BYOAC forums thread](https://forum.arcadecontrols.com/index.php/topic,169017.msg1775223.html#msg1775223)

## [v1.0.0] - 2024-11-12

- First release.

[unreleased]: https://github.com/Jakobud/skipstartupframes/compare/v2.3.0...develop
[v2.3.0]: https://github.com/Jakobud/skipstartupframes/releases/tag/v2.3.0
[v2.2.0]: https://github.com/Jakobud/skipstartupframes/releases/tag/v2.2.0
[v2.1.0]: https://github.com/Jakobud/skipstartupframes/releases/tag/v2.1.0
[v2.0.0]: https://github.com/Jakobud/skipstartupframes/releases/tag/v2.0.0
[v1.3.0]: https://github.com/Jakobud/skipstartupframes/releases/tag/v1.3.0
[v1.2.0]: https://github.com/Jakobud/skipstartupframes/releases/tag/v1.2.0
[v1.1.0]: https://github.com/Jakobud/skipstartupframes/releases/tag/v1.1.0
[v1.0.0]: https://github.com/Jakobud/skipstartupframes/releases/tag/v1.0.0
