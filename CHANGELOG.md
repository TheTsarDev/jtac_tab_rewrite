# Changelog

All notable changes to **JTAC Tab Re-Write** are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).  
Version numbering: `MAJOR.MINOR.PATCH`

---

## [1.1.0] — 2026-07-26 · Stability Update

> Major script reliability pass. Resolves every issue listed under **Known Issues** in v1.0.2–1.0.5.

### Fixed

#### Return to Base (RTB)
- Transport asset array was never assigned (`_arr - array` discarded the result), breaking RTB cleanup for helos
- RTB now re-enables AI, clears `casDirect` attack state, and sets proper altitude before departure (500 m fixed-wing / 150 m rotary)
- Added a **10-minute RTB timeout** so assets despawn even if they cannot reach the spawn point
- Escort groups are now tracked and cleaned up when the transport RTBs

#### Rotary CAS — IP/BP Freeze
- Removed broken waypoint statement that referenced out-of-scope variables (`setFormDir` in a string)
- Rotary assets now enter a **LOITER hold** at IP/BP on arrival
- Attack script holds position while JTAC selects AT/AP rockets; `_isAlive` / `_isAborted` are properly initialized

#### Transport — GO Button & Insert Wait
- Replaced deprecated `BIS_fnc_MP` with `remoteExec` to the JTAC operator
- **GO** is now a CBA scroll-wheel action (consistent with CAS controls)
- Fixed infinite wait: `waitForLoad` default was `true`, causing the mission to hang until timeout
- Added a **10-minute load timeout** with automatic departure if GO is never pressed
- Operator receives a hint when the bird is on station: *"Transport on station — scroll wheel: GO"*

#### Smoke Target Confirmation
- Removed generic `SmokeShell` counting that double-counted colored smokes (green registering as green **and** purple)
- Each smoke object is classified **once** by exact `typeOf`
- Added `isKindOf` fallback for modded smokes (e.g. `SmokeShellGreen`, `SmokeShellPurple`)

#### Fixed-Wing DIRECT Gun Runs
- Fixed inverted laser target check (`count < 0` → `count > 0`)
- Rewrote approach using **ASL positioning** with a **150 m minimum AGL** floor during the pass
- Approach distance clamped to 500 m minimum; altitude scales with range (cap 800 m)
- Added approach timeout, post-attack climb-out, and damage re-enable after the run

#### General Script Fixes
- Undefined `_mrkTgt` in rotary/plane attack scripts (marker name vs. position mismatch)
- `break_pass` referenced `_isAlive` / `_isAborted` before they were defined — hit confirmation could silently skip
- Respawn logic now writes back to global CAS/TRANS arrays instead of modifying a discarded local copy
- Destruction cleanup correctly updates `TOG_jtac_CAS_Plane_arr`, `TOG_jtac_CAS_Heli_arr`, and `TOG_jtac_Trans_Heli_arr`

### Changed
- Transport insert wait uses safer defaults and abort-aware departure timing
- DIRECT attack pass speed reduced slightly (500 → 400 km/h equivalent) for safer terrain clearance

### Resolved Known Issues

| Issue (pre-1.1.0) | Status |
|---|---|
| RTB feature broken | **Fixed** |
| Rotary freezes at IP/BP | **Fixed** |
| Transport sits without GO / RTB option | **Fixed** |
| Green smoke registers as Green and Purple | **Fixed** |
| FW crashes into ground on DIRECT runs | **Fixed** |
| Custom airframe compatibility | *Partial — test your airframes* |

---

## [2.0.0] — Unreleased · Roadmap

Planned features for the next major release:

| Feature | Status |
|---|---|
| Updated GUI | Planned |
| Button click sounds | Planned |
| CTAB integration for messaging | Planned |
| Laser target marking | Planned |
| IR Strobe target marking | Planned |
| Full airframe integration | Planned |
| Updated pilot/crew uniforms | Planned |
| BDA (Bomb Damage Assessment) | Planned |
| Aircraft check-in | Planned |
| Aircraft racetrack / loiter patterns | Planned |
| ISR integration | Planned |
| UAV support | Planned |
| Active tracking of friendlies/enemies near JTAC | Planned |
| Configurable TOT, TOS, and attack altitude | Planned |
| Fallen Angel auto-report (SERE script tie-in) | Planned |

---

## [1.0.5] — 2023-10-22

### Added
- High-resolution Dell Latitude 7220 tablet GUI
- GUI button click sounds
- Main screen layout prep (5-function hub)
- Sounds folder and server key

### Changed
- GUI reworked for smoother button interaction
- CBU replaces GBU airburst for fixed-wing **CARPET** option

### Known Issues
- All issues from v1.0.2 remained open *(resolved in v1.1.0)*

---

## [1.0.2] — 2023-11-07

### Fixed
- Various script errors in the transport system
- 3CB faction airframe classnames
- Callsign assignment script

### Changed
- TAB sound file pathway added *(sounds folder not yet on Git at release)*
- GUI label **Transport** renamed to **TRANS**

### Known Issues *(all resolved in v1.1.0)*
- Transport insert: bird sits ~2 minutes with no GO / RTB option
- RTB feature broken
- Not all custom airframes compatible
- Rotary freezes at IP/BP
- Green smoke double-registers (mod smoke conflict)
- Fixed-wing DIRECT runs sometimes impact terrain

---

## [1.0.1] — 2023-11-07

### Added
- Initial GitHub upload
- All changes to date included *(documentation incomplete at release)*

---

## Links

- [Original Mod by Sushi](https://steamcommunity.com/sharedfiles/filedetails/?id=1455591286)
- [Workshop Release](https://steamcommunity.com/sharedfiles/filedetails/?id=3075802725)
