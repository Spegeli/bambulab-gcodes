# A1 Mini – Machine start G-code

Faster, safer and quieter drop-in replacement for Bambu Lab's A1 Mini start G-code. It is based on the A1 Mini routine 1.4.2 by Cameron Condry.

## Files

| File | Version | Variant | Description |
|------|---------|---------|-------------|
| [machine-start-v1.0.0.gcode](machine-start-v1.0.0.gcode) | 1.0.0 | default | Vibration compensation disabled |
| [stock/machine-start-stock-20260513.gcode](stock/machine-start-stock-20260513.gcode) | – | Bambu stock | Original Bambu Lab start G-code, date 20260513 |

## What differs from stock

- **Preheat without waiting**: nozzle to 140 °C, bed to first-layer temperature +5 °C for heat soak (max 80 °C).
- **Safe axis recovery**: guarded Z moves with low motor current before homing.
- **Vibration compensation disabled**: skips the resonance tune and belt tension check before each print, so there is no HMS belt warning. Remove the leading `;` in that section to enable it again.
- **Nozzle cleaning**: fan blast, seven gentle taps, two offset brush passes, final wipe with fan blast.
- **Flow calibration and bed leveling** still follow the flags set in Bambu Studio.
- **Clog detection stays on** after the start routine (stock turns it off). Comment out `G392 S1` under "final staging" to match stock.
- **Textured PEI plate**: Z offset -0.02 mm.

## Changelog

### 1.0.0 – 2026-10-19

#### ✨ New Features

- Added start routine based on the A1 Mini routine 1.4.2 and Bambu stock 20260513.
