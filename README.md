# Bambu Lab G-codes

Optimized custom G-codes for Bambu Lab printers, ready to paste into Bambu Studio.

## Printers

| Printer | Customized G-codes |
|---------|--------------------|
| [A1](a1/) | [Machine start](a1/machine-start/) |
| [A1 Mini](a1-mini/) | [Machine start](a1-mini/machine-start/) |

## Repository layout

```
<printer>/
├── README.md                     printer-specific notes
└── <gcode-field>/                one folder per Bambu Studio G-code field
    ├── README.md                 notes, variants and changelog for this field
    ├── <field>-v<version>[-<variant>].gcode
    └── stock/
        ├── README.md             source of the original files
        └── <field>-stock-<bambu-date>.gcode
```

- **One folder per G-code field**, named after the field in Bambu Studio: `machine-start`, `machine-end`, `printing-by-object`, `layer-change`, `timelapse`, `change-filament`, `pause`, `template-custom`. A folder exists only for fields that are customized.
- **Every release is its own file.** Old versions stay in the folder and are never overwritten. The file name follows [Semantic Versioning](https://semver.org/) and matches the version in the file header.
- **Variants** carry a suffix, e.g. `machine-start-v1.0.0-vibration-comp.gcode`. The file without a suffix is the default variant.
- **`stock/`** holds Bambu Lab's original G-code for comparison, named after the date in Bambu's header.

## Installation

1. In Bambu Studio, open the printer settings (edit icon next to the printer) and switch to the **Machine G-code** tab.
2. Open the G-code file for your printer, copy its full content and replace the content of the matching field.
3. Save the printer profile as a user preset, so a Bambu Studio update does not reset it.

## Credits

The start routines are based on the A1 Mini start routine by Cameron Condry, Cascade Media LLC:
[github.com/cameroncondry/a1-mini-gcode](https://github.com/cameroncondry/a1-mini-gcode).
The stock G-code is taken from Bambu Lab's [BambuStudio](https://github.com/bambulab/BambuStudio) profiles.

## Disclaimer

Custom G-code moves the printer outside Bambu Lab's tested defaults. Watch the first print with a new routine and use it at your own risk.
