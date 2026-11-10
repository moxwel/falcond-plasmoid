# Falcond Status Checker Plasmoid

A simple KDE Plasma 6 panel widget that shows whether the [falcond](https://git.pika-os.com/general-packages/falcond) gaming daemon is stopped, running or has a game active.

It polls `systemctl is-active falcond` and the `ACTIVE_PROFILE` line of falcond's status file (`/tmp/falcond_status`), and shows one of three states:

| State | Icon color |
|---|---|
| Service stopped | Gray |
| Service running, no game detected | White |
| Service running, game profile active | Green, the tooltip names the profile |

> This is a learning project to help me learn more about KDE Plasma development, so I welcome any feedback or suggestions.

## Install

### Manual

```sh
./install.sh
```

Then right-click your panel > *Add or Manage Widgets...* > search for **Falcond Status Checker** and drag it onto the panel.

To use it in the system tray instead, open the tray's settings > *Entries* and set **Falcond Status Checker** to *Always shown* or *Shown when relevant*. With *Shown when relevant* the icon only appears while a game profile is active.

Re-run `./install.sh` after editing any file; it rebuilds the package, upgrades it and reloads plasmashell in one step.

To uninstall:

```sh
./install.sh remove
```

## Build

```sh
./build.sh
```

Writes `build/falcond.plasmoid`.

> [!TIP]
> Bump `Version` in `metadata.json` before each release, otherwise Plasma does not offer the update.

## Settings

- **Icons:** one for each state. All default to `input-gamepad-symbolic`.
- **Tint:** under each icon, tint it with a color of your choice, or turn the tint off to keep the icon as it is.
- **Show icon:** always (default), while Falcond is running, or only while a game is active. The widget leaves the panel when the condition is not met.
- **Check every:** seconds between status checks, 5 by default.

## Requirements

- Plasma 6 (developed and tested against 6.7.5)
- falcond installed as a systemd service named `falcond`
- `kpackagetool6` (ships with KDE Frameworks 6)
- `gettext` to compile translations in `translate/` (`install.sh`, `build.sh`)
- `zip` (`install.sh`, `build.sh`)

## AI usage disclosure

I want to provide transparency and honesty about the use of AI in this project.

This project has been developed with the assistance of AI tools. AI was used to generate code snippets and documentation.

**ALL AI-generated content** has been **manually reviewed** and **edited by me (moxwel)**, to ensure code accuracy, readability, and quality with my personal standard coding practices.

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).
