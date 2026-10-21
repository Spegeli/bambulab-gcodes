# A1 – Machine start G-code

Faster, safer and quieter drop-in replacement for Bambu Lab's A1 start G-code. It is a port of the A1 Mini routine 1.4.2 by Cameron Condry.

## Files

| File | Version | Variant | Based on stock | Description |
|------|---------|---------|----------------|-------------|
| [machine-start-v1.0.0.gcode](machine-start-v1.0.0.gcode) | 1.0.0 | default | [20260513](stock/machine-start-stock-20260513.gcode) | Vibration compensation disabled |

Bambu Lab's original start G-codes, from the first to the current version, are in the [`stock/`](stock/) folder.

## What v1.0.0 changes compared to stock 20260513

This section describes the latest version only. For older versions, see the [changelog](#changelog).

- **Preheat without waiting**: nozzle to 140 °C, bed to first-layer temperature +5 °C for heat soak (max 100 °C).
- **Safe axis recovery**: guarded Z moves with low motor current before homing.
- **Vibration compensation disabled**: skips the resonance tune and belt tension check before each print, so there is no HMS belt warning. Remove the leading `;` in that section to enable it again.
- **Nozzle cleaning**: fan blast, seven gentle taps, two brush passes in opposite directions, final wipe with fan blast.
- **Flow calibration and bed leveling** still follow the flags set in Bambu Studio.
- **Clog detection stays on** after the start routine (stock turns it off). Comment out `G392 S1` under "final staging" to match stock.
- **Textured PEI plate**: Z offset -0.02 mm.

## A1-specific

The A1 port keeps these A1-only steps from stock, which the A1 Mini routine does not have:

- Filament push with low extruder current before Z homing (`M109 S25 H140`, `M17 E0.3`).
- `G2814 Z0.32` Z reference before the calibration line.
- `M900 S` / `M900 C` / `M900 R`: save, clear and restore pressure advance around the calibration line.
- `G29.4` as the last command.

## Changelog

### 1.0.0 – 2026-10-19

#### ✨ New Features

- Added A1 port of the A1 Mini start routine 1.4.2, based on Bambu stock 20260513.
