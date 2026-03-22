# Changelog

## 0.1.9+2 - 2026-03-22

### Added
- Added native Linux tray context menu support using `tray_manager` menu callbacks.
- Added Linux frameless floating-window hardening for desktop widget mode.

### Changed
- Migrated tray integration from `system_tray` to `tray_manager` across Linux/Windows plugin registrants.
- Updated Linux CMake to avoid `deprecated-declarations` warning escalation for tray plugin build.
- Improved timetable header date row responsiveness to avoid horizontal overflow.
- Improved close-to-tray behavior: only minimize when tray is initialized.
- Removed deprecated `synthetic-package` setting from l10n config.

### Fixed
- Fixed Linux tray menu not showing by wiring native tray menu item click events to app actions.
- Fixed Linux build break caused by deprecated appindicator API warning treated as error.
- Fixed timetable `RenderFlex overflow` in narrow layouts.

### Notes
- On some Wayland compositors, system-level window decoration policies may still apply partially.
- Current implementation applies additional GTK window hinting/CSS and X11 backend preference under Wayland for more consistent frameless behavior.
