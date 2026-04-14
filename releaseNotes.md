# Release Notes — Xcode Developer Toolbox Light

---

## Version 1.0.0 — 2026-04-14

### Initial Release

- **Initial version with Clean & Cache, Dependencies, Build & Run, Simulator, Test, Misc, Xcode**

Xcode Developer Toolbox Light is a lightweight, keyboard-driven CLI app for iOS and macOS developers. It delivers the most important build, clean, and simulator functions in a compact split-pane menu with no external dependencies.

### User Interface

- **Split-pane menu** — Navigate with arrow keys: left pane selects the category, right pane selects the action. Press Enter to execute.

- **Dynamic pane height** — The pane height automatically adjusts to the category with the most entries — all items are always visible.

- **Header shortcuts** — Quick access to frequently used settings via keyboard shortcuts: `S` scheme, `D` device, `K` configuration, `B` bundle ID, `L` language, `A` working directory.

- **Quit behaviour** — Only uppercase `Q` exits the app. Lowercase `q` is ignored.

### Build & Run

- **Build speed flags applied** — All build calls use up to four parameters (`-parallelizeTargets`, `COMPILER_INDEX_STORE_ENABLE=NO`, `ONLY_ACTIVE_ARCH=YES`, and in Debug mode additionally `DEBUG_INFORMATION_FORMAT=dwarf` and `SWIFT_COMPILATION_MODE=incremental`) to noticeably reduce build times.

- **`-derivedDataPath` set consistently** — All xcodebuild calls redirect build artefacts to the product-specific folder (`DerivedData/{product}`) — including resolve steps.

- **Actions:** Build, Build & Run (Simulator / macOS), Quick Reset & Build, Full Reset & Build.

### Clean & Cache

- **Targeted deletion** — Only the product-specific DerivedData folder (`DerivedData/{product}`) is ever deleted automatically — never the full DerivedData directory. Exception: deliberate clean actions with explicit user confirmation.

- **Actions:** xcodebuild clean, delete toolbox build, DerivedData, ModuleCache, simulator cache, Xcode caches, caches without SPM, caches including package managers.

### Dependencies

- **SPM — Show Dependencies** — Shows the currently resolved SPM dependencies from `Package.resolved` or the package graph.

- **CocoaPods — Show Dependencies** — Parses `Podfile.lock` and displays all installed pods with name and version in a consistent format.

- **Carthage — Show Dependencies** — Parses `Cartfile.resolved` and displays all installed frameworks with name, version, and source URL in a consistent format.

- **Resolve** — Resolves all detected package dependencies (SPM, CocoaPods, Carthage).

### Tests

- **Unit, UI, and all tests** with the same speed flags as build actions (`COMPILER_INDEX_STORE_ENABLE=NO`, `ONLY_ACTIVE_ARCH=YES`, `SWIFT_COMPILATION_MODE=incremental`).

- **Parallel testing** — `-parallel-testing-enabled YES` on request.

### Simulator

- Launch app, relaunch app, restart / stop / reset simulator.
- Screenshot and video recording (→ Desktop).
- Toggle Dark / Light mode.

### Misc

- **Tools & Versions** — Shows the installed versions of Xcode, Swift, CocoaPods, Carthage, SwiftLint, and SwiftFormat, plus the active Xcode path.
- **File Metrics** — Analyses all `.swift` files and shows per file: total lines, code lines, function count, risk operations, and complexity. Paginate with `Z` / `W` for more than 25 files.
- **Project Metrics** — Aggregated overall overview: lines, classes, structs, enums, functions, control flow, dangerous operations, maximum line length, and averages.

### Working Directory & Settings

- **Working directory selection** — File browser for selecting `.xcworkspace` and `.xcodeproj` files. After switching: optional cache cleanup, dependency resolution, scheme/device selection.

- **Persistent settings** — Scheme, device, configuration, bundle ID, and language are saved.

### Localisation

- **DE and EN** fully localised.

### Bug Fixes

- **Duplicate DerivedData directory fixed** — All `xcodebuild -resolvePackageDependencies` calls previously omitted the `-derivedDataPath` flag. This caused Xcode to create a second default DerivedData directory alongside the product-specific folder. All six affected locations have been corrected.

---
