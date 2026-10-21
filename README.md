<h1 align="center">Bambu Lab G-codes</h1>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-AGPL--3.0-blue" alt="License: AGPL-3.0"></a>
  <a href="#%EF%B8%8F-printers"><img src="https://img.shields.io/badge/printers-A1%20%7C%20A1%20Mini-green" alt="Printers: A1, A1 Mini"></a>
</p>

Optimized custom G-codes for **Bambu Lab** printers, ready to paste into [Bambu Studio](https://bambulab.com/en/download/studio): faster, safer and quieter start routines, with Bambu's original G-code kept next to them for comparison.

> [!CAUTION]
> **Custom G-code controls your printer directly.** These files are modified versions of Bambu Lab's G-code. They are tested on real printers, but you use them at your own risk — read [Safety and liability](#%EF%B8%8F-safety-and-liability) before your first print.

---

## 🖨️ Printers

| Printer | Customized G-codes |
|---------|--------------------|
| [A1](a1/) | [Machine start](a1/machine-start/) |
| [A1 Mini](a1-mini/) | [Machine start](a1-mini/machine-start/) |

---

## 🗂️ Repository layout

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
- **`stock/`** holds every original G-code Bambu Lab has published for that field, named after the date in Bambu's header.

---

## 📦 Installation

1. In Bambu Studio, open the printer settings (edit icon next to the printer) and switch to the **Machine G-code** tab.
2. Open the G-code file for your printer, copy its full content and replace the content of the matching field.
3. Save the printer profile as a user preset, so a Bambu Studio update does not reset it.
4. Watch the first print from start to finish (see [Safety and liability](#%EF%B8%8F-safety-and-liability)).

To go back to stock, paste the newest file from the field's `stock/` folder, or select Bambu's system preset again.

---

## ⚠️ Safety and liability

The G-codes in this repository are **modified versions** of Bambu Lab's original G-code. Each release is tested on the maintainer's own printers before it is published. That testing cannot cover every printer, firmware version, nozzle, build plate, filament and slicer setting, so a routine that works here can still behave differently on your machine.

**You use these G-codes entirely at your own risk.** By pasting them into your slicer, you accept that:

- **You are responsible for what your printer does.** Read the file before you use it, check that it is meant for your printer model, and watch the first print from start to finish, ready to stop the printer.
- **Things can go wrong.** Faulty or unsuitable G-code can crash the nozzle into the bed, scratch or damage the build plate, wear the wiper or brush, clog or damage the hotend, ruin prints and waste filament. Parts of a start routine run outside the normal print area with soft endstops turned off.
- **No warranty, no liability.** The G-codes are provided "as is", without any warranty. To the extent permitted by applicable law, the maintainer and contributors are not liable for any damage to your printer, its parts or accessories, for failed prints, lost material or time, or for any other direct or indirect damage arising from their use. See sections 15 and 16 of the [license](LICENSE).
- **Bambu Lab support cannot help.** Problems caused by custom G-code are not Bambu Lab's to fix. Switch back to the stock G-code before you contact Bambu Lab support, and report problems with these files in the [issue tracker](https://github.com/Spegeli/bambulab-gcodes/issues) instead.

If you are unsure about any of this, keep using Bambu's stock G-code.

---

## 🙏 Credits

- The start routines are based on the A1 Mini start routine by Cameron Condry, Cascade Media LLC: [github.com/cameroncondry/a1-mini-gcode](https://github.com/cameroncondry/a1-mini-gcode).
- The stock G-code comes from Bambu Lab's [BambuStudio](https://github.com/bambulab/BambuStudio) profiles.

---

## ⚖️ Disclaimer

- **Not a Bambu Lab product.** This is an independent community project. Bambu Lab does not develop, endorse or support it, and Bambu Lab's support cannot help with it — use the [GitHub issue tracker](https://github.com/Spegeli/bambulab-gcodes/issues) instead.
- **Trademarks.** Bambu Lab, Bambu Studio and the names of Bambu Lab's printers are trademarks of their owner. They appear here only to name the printers and the slicer these G-codes are made for.
- **Use at your own risk.** The G-codes are provided as is, without warranty, under the AGPL-3.0 — see [Safety and liability](#%EF%B8%8F-safety-and-liability).

---

## 📜 License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)** — see the [LICENSE](LICENSE) file for details.

The G-codes are derived from Bambu Lab's G-code in [BambuStudio](https://github.com/bambulab/BambuStudio), which is licensed under the AGPL-3.0, and the unmodified originals in the `stock/` folders remain Bambu Lab's work under that license. If you share a modified version of these G-codes, it must stay under the AGPL-3.0 as well. The license does not cover Bambu Lab's name and trademarks (see [Disclaimer](#%EF%B8%8F-disclaimer)).
