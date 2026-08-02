# JTAC Tab - Advanced Support Module Re-Write

**Version 1.6.4** · Remastered for Arma 3 · Server & client mod

Remastered to carry on the work by **LifeReapr**. Original mod by **Sushi** - thank you for building this foundation years ago.

---

## Overview

JTAC Tab is an advanced Joint Terminal Attack Controller system for Arma 3. Request close air support from fixed- and rotary-wing aircraft, run rotary transport missions with optional escort, and control the fight from a tablet interface that mirrors real-world CAS and TRANS procedures - within the limits of the Arma 3 engine.

As JTAC, you select IP/BP (Initial Point / Battle Position), mark friendly positions, set abort codes, choose munitions, and confirm targets before aircraft engage.

---

## Features

| Category | Capability |
|---|---|
| **Interface** | JTAC tablet via scroll-wheel action (requires UAV Terminal) |
| **CAS - Fixed-Wing** | GBU, CBU/CARPET, DIRECT gun runs |
| **CAS - Rotary** | AT/AP rockets (JTAC-timed release), gun runs |
| **Target Marking** | Laser, smoke, IR strobe / chemlight (day/night aware) |
| **Smoke Logic** | Pilots detect smoke color; JTAC must confirm before engagement |
| **Transport** | Rotary insert/extract with optional armed escort |
| **Abort** | Operator-defined abort codes for active missions |
| **Tracking** | Live markers on requested assets |
| **Mission Maker** | Eden modules - place, sync, and play |

### Full feature list

- JTAC tablet (UAV Terminal required in inventory)
- IP/BP selection on map
- Friendly troop position markers
- Abort codes for in-flight CAS cancellation
- Fixed- and rotary-wing CAS
- Munition selection: GBU, CBU, GAU, AGM, APK
- Target marking: laser, smoke, IR strobe
- Smoke color confirmation by JTAC operator
- Rotary hover at BP; operator chooses munition type and time of engagement
- Rotary transport requests
- Armed escort when enemies are in the area
- Day/night marking system (smoke vs. chemlight vs. flare)
- Live tracking of requested units
- Realistic radio request templates (AI limitations apply)
- Eden modules: JTAC Enable, CAS (FW), CAS (RW), Transport
- JTAC operator field manual (PDF)

---

## Eden Editor Setup

Place and **sync** these modules on the map:

```
[JTAC] Enable          ← required; sync all other modules to this
[CAS] Fixed-wing
[CAS] Rotary-wings
[TRANSPORT] Rotary-wings
```

**Player requirement:** UAV Terminal (`B_UavTerminal`, `O_UavTerminal`, or `I_UavTerminal`) in inventory to access the tablet action.

---

## Getting Started

### Dependencies

| Requirement | Notes |
|---|---|
| **Arma 3** | Latest stable recommended |
| **CBA_A3** | Required addon ([Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)) |
| **PBO tools** | PBO Manager, Mikero's Tools, or BIS Arma 3 Tools for packing |

### Installation

1. Clone or download this repository.
2. Pack `tog_jtac` into a `.pbo`.
3. Place the PBO in your mod folder or server `@mod` directory.
4. **Multiplayer:** install on server **and** all clients; add the provided `.bikey` to the server keys folder.

---

## What's New in 1.6.3

Dedicated server scroll-wheel fix — smoke confirm, hit/pass confirm, and heli AT/AP selection now run on the JTAC client and sync back to the server.

See [CHANGELOG.md](CHANGELOG.md) for full details. Includes all v1.6.0–1.6.2 fixes.

---

## Known Limitations

- Custom/third-party airframes may need testing - class-specific weapon and door configs vary
- AI behavior remains subject to Arma 3 engine limits
- v2.0.0 features (GUI overhaul, CTAB, ISR, UAVs) are on the roadmap - see changelog

**Found a bug?** Open an issue with your RPT log and steps to reproduce.

---

## Development Team

- **TsarDev**

This mod is under active development. Report issues and errors - patience appreciated while v2.0.0 is in progress.

---

## Acknowledgments

- [Original Mod by Sushi](https://steamcommunity.com/sharedfiles/filedetails/?id=1455591286)
- [Workshop Release](https://steamcommunity.com/sharedfiles/filedetails/?id=3075802725)
