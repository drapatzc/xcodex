# Release Notes — Xcode Developer Toolbox Light

---

## Version 1.0.1 — 2026-04-15

### Bug Fixes

- **Build (compile only) fixed for macOS** — An incorrect `isMacOSDevice` guard in `actionBuildDebug()` was unconditionally blocking macOS builds, even though `xcodebuild build` with `-destination 'platform=macOS'` works correctly. The guard has been removed. "Build" is now available for iOS Simulator, iPadOS Simulator, and macOS (My Mac) alike.

- **Duplicate DerivedData directory for macOS fixed** — Two `xcodebuild -showBuildSettings` calls in `SchemeSelector.swift` (bundle ID reading and `detectSchemePlatforms()`) were missing the `-derivedDataPath` flag. On macOS, `xcodebuild` internally resolves packages when querying build settings and writes to the default DerivedData location — this does not occur with the iOS Simulator. Both calls now include `-derivedDataPath '\(toolboxProductBuildPath)'`.

- **Bug fix: "Uninstall app & fresh test"** — If no `.app` file is found in the product-specific build folder, the tool now asks whether the app should be built right away. Confirming starts `actionBuildAndRunSimulator()` directly. Previously only an error message was shown with no further action.

### UI & UX

- **Consistent action headers for shortcut dialogs** — `printActionHeader()` is now used consistently for all global keyboard shortcut dialogs: configuration (`K`), language (`L`), scheme (`S`), and device (`D`). All these dialogs now show the same structured title/description block as regular menu actions.

- **`[A]` workflow: fewer key presses** — When switching the working directory (`A`), scheme selection is now embedded without a trailing `waitForKeyPress()`. The flow proceeds directly to device selection.

- **`selectBuildScheme()` with new parameters** — The function now accepts `showHeader: Bool` and `suppressFinalWait: Bool` for clean embedding in higher-level workflows.

### Build & App Path Display

- **Build path shown after a successful build** — After every successful build, the tool now shows which folder the app was placed in (`printBuiltAppInfo()`). Affected actions: "Build", "Build & Run", "Quick Reset & Build", and "Full Reset & Build".

- **App path shown on launch** — When launching the app directly, the full path of the started `.app` file is printed.

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
