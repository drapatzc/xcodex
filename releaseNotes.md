# Release Notes — Xcode Developer Toolbox Light

---

## Version 1.0.5 — 2026-04-26

### Project

- **Group "Project Manager" renamed to "Project"; new select command** — The command group is now consistently named "Project". New entry action `actionProjectSelect()`: selects a JSON configuration file and saves it persistently — all subsequent commands (Initialise, Update, Delete, Info) then operate on this saved configuration without requiring a new file selection. Legacy schema `{ "repositories": [...] }` is automatically migrated. Safety check prevents deletion of system directories. Menu visibility controlled via `canShowProjectFileSelected`.

### Help Overlay

- **Context-sensitive help overlay** — New file `HelpOverlay.swift` (322 lines): an embedded overlay shows an individual help text for each menu item — accessible via `[H]` in the split-pane menu. The text is scrollable (↑/↓) and word-wrapped. `getHelpEntry(categoryName:itemLabel:)` returns the matching `HelpEntry` for the current selection.

### Security & Stability

- **Phase 1: Security and stability** — System-wide hardening across multiple files:
  - `shellQuote()` applied consistently to all shell arguments containing user paths (prevents shell injection)
  - `operationAborted` in `AppContext.swift` made thread-safe via `NSLock`
  - `try? process.run()` replaced with `do/try/catch` with logging (no more silent failures)
  - Tool availability checked before `pod install`, `carthage`, `xcrun`, and `python3`
  - Path traversal validation added to `fullRepoPath()`
  - Encoding fallbacks for non-UTF-8 output

### Localisation

- **New command group "Localisation"** — New file `LocalizationActions.swift` (606 lines) with multiple actions:
  - **Show available languages** — Combines `*.lproj` folders and `*.xcstrings` files (JSON parsing), deduplicates, and displays all detected language codes.
  - **Missing localisations** — Compares keys across `.strings` and `.xcstrings` files, lists keys missing in at least one language (structural gaps).
  - Additional localisation analysis and consistency actions.

### Project Configuration

- **Project configuration expanded** — `ConfigurationInspectActions.swift` (1240+ lines): the submenu now covers all Xcode project tabs: `[1] General`, `[2] Signing & Capabilities`, `[3] Resource Tags`, `[4] Info`, `[5] Build Settings`, `[6] Build Phases`, `[7] Build Rules`, `[8] Entitlements`, `[9] xcconfig files`, `[10] Privacy Manifest`, `[11] StoreKit configuration`. New action `actionProjectStructure()` displays the complete project directory structure with colour-coded depth representation.

### Automated Tests

- **New category "Automated Tests"** — New file `AutomatedTestsActions.swift` (1501 lines): automated test runner with configurable repeat intervals (1 min – 24 h – unlimited). Supports schemes and test plans (`@testplan:` prefix). Live screen with boot-phase display and log file writing. macOS notification after each run. Prerequisite check (project, scheme, device) before starting.

### Binary Analysis

- **New and revised actions** — `BinaryAnalysisActions.swift` (449+ lines): `actionBinaryLinkedFrameworks`, `actionBinaryArchitectures`, `actionBinarySegmentSizes`, `actionBinaryExportedSymbols`, `actionBinaryLargestSymbols`, `actionBinaryLoadCommands`, `actionBinaryMinIosVersion`, `actionBinaryShowEntitlements`. The app binary is selected automatically from the build directory; a selection prompt appears if multiple candidates are found.

### Developer Info

- **New category "Developer Info"** — New files: `DeveloperInfoActions.swift` (641 lines), `DeveloperInfoModels.swift` (112 lines), `DeveloperInfoParsers.swift` (720 lines), `DeveloperInfoService.swift` (198 lines). Ten actions:
  - **Overview** — Compact summary from cache; `[W]` refreshes on demand.
  - **Apple Releases**, **Xcode Releases**, **iOS/iPadOS Releases**, **macOS Releases**, **Swift Releases**, **Swift Evolution**, **Apple Developer News**, **Security Updates**, **SwiftUI & Frameworks**.

### App Store & Distribution

- **New command group "App Store & Distribution"** — New file `AppStoreActions.swift` (2,619 lines): complete release workflow for iOS/iPadOS and macOS, integrated into the split-pane main menu.
  - **Release overview** — Traffic-light status (✓/⚠/✗) for all relevant parameters: working directory, scheme, bundle ID, device, configuration, Apple ID, and team ID. Automatic platform detection (iOS family / macOS / unknown).
  - **Manage app parameters** — Persistent storage of Apple ID, team ID, and preferred directories for archives, IPAs, and DMGs in `~/.toolboxlight_appstore.json`. Sensitive credentials (app-specific password, API key) stored exclusively in the macOS Keychain.
  - **Delivery** — Fully automated one-step workflow (only when platform is known): create archive → export/upload — no further user input after confirmation.
  - **Release checks** — Pre-flight checks: signing configuration, deployment target, frameworks, build settings.
  - **Release notes from Git** — Generates release notes automatically from the Git log of the current branch.
  - **Show App Store files** — Lists existing archives (`.xcarchive`), IPA exports, and DMG builds from the configured directories.
  - **Platform-specific steps:**
    - *iOS/iPadOS:* Create archive (`xcodebuild archive`), export IPA, upload to TestFlight / App Store (`xcrun altool`).
    - *macOS:* Create archive, macOS export (`.pkg`), upload, create DMG, notarise (`xcrun notarytool`), staple & verify notarisation.

### Menu & UX

- **Menu layout revised** — `MainMenu.swift`: new categories (Localisation, Automated Tests, Binary Analysis, Developer Info, Project Configuration, App Store & Distribution) integrated into the split-pane menu. Hotkey bar updated. Separator lines and section headers added for better readability.

### Instruments — Bugfixes & Corrections

- **Parser bug fixed** — Template detection via `xcrun xctrace list templates` checked for a leading quote character (`hasPrefix("\"")`) which Xcode 15 no longer outputs — the template list was always empty. Parser corrected: all non-empty lines without the `==` prefix are now accepted as templates. Template names corrected: `"Energy Log"` → `"Power Profiler"`, `"Core Data"` → `"Data Persistence"`. After a successful recording the `.trace` file opens automatically in Instruments.app (`open -a Instruments`). Template menu converted to `item()` and `printMenuItemBack()`.

### Crash & Symbole — Revisions

- **Header shown only once when "Symbolicate all"** — `performSymbolication()` called `printActionHeader()` on every report. New parameter `skipHeader: Bool = false` suppresses the header for subsequent reports; when using "All" it appears once at the top, followed by numbered separator lines (`── 1/N — filename ─────`). Empty state shows only `[S]` and `[X]` (no `[0]`). Menu with entries: navigation bar (`↑↓ navigate  ←→ first/last  ↵ symbolicate  A all`) and buttons via `printMenuItemKey`/`printMenuItemBack`. Cursor left/right jumps ±16 entries (`pageSize`).

### Provisioning Profiles — Revisions

- **Device display matches certificate format** — Bullet points (`•`) with consistent indent, no numbering. Known devices show name, model and OS version; unknown devices show the full UDID (not truncated). `"App ID"` and `"UUID"` replaced with `locStr("prov_profiles_header_appid")` and `locStr("prov_profiles_details_uuid")`. Variables cleaned up: `ind` → `indent`, `knownDev` → `knownDevices`, `deviceMap` instead of `device`.

### Bug Fixes — Tests

- **Retry failing tests** — After a failed test run, the test runner now offers to re-run only the failed tests — no need to restart the entire suite.

- **Bug fix: UI tests running during unit test action** — UI tests were incorrectly also triggered by the "Run Unit Tests" action. The action and automated test repeat loop have been corrected.

### Infrastructure

- **Code signing and notarisation for macOS distribution** — Full build infrastructure for signed and notarised macOS binaries. The Toolbox can now be distributed as an official, GateKeeper-compliant macOS package.

### Security & Stability — Additions

- **Shell injection: all 22 affected files** — Systematic audit and cleanup of all shell calls across the project; `shellQuote()` is now applied consistently in all 22 files. No attack vector via paths containing special characters.

- **Shell.swift hardened** — `malloc`/`free` buffer replaced with a type-safe `[UInt8]` buffer (no force-unwrap); all `FileHandle` instances closed via `defer` (no resource leak).

- **Defensive parsing** — `lipo` and `xcodebuild` output is now parsed defensively; unexpected formats no longer cause crashes.

### Architecture

- **Service extraction complete** — CLI calls fully moved out of menu classes into dedicated services: `ArchiveService` (from `MenuArchiveManager`), `CacheService` and `DependencyResolverService` (from `MenuDirectory`), and all remaining direct shell calls in menus also relocated. Menus no longer contain any business logic.

- **`resolveDetectedPackageManagers`** — New centralised function for detecting and resolving package managers. CLI bypass in menu removed; exit codes now checked consistently.

- **State mutation** — State mutation extracted from `MenuDirectory` into the action layer (`actionApplyProjectSelection`); menus now only read state, never write it directly.

- **Menu localisation** — Hard-coded category names in `MainMenu` replaced with `locStr()` calls.

### Stability & Performance

- **Hard timeouts for long-running operations** — `runBuildLive` / `runXcodebuildLiveFormatted`: 30-minute timeout; `pod install`: 10 minutes; `carthage bootstrap` / `update`: 30 minutes. All remaining `pod`/`carthage` callers also given timeouts. No more infinitely hanging processes.

- **Exit code from `runXcodebuildLiveFormatted`** — Returns the exit code directly instead of storing it in a global `lastXcodebuildExitCode` variable.

- **`currentTimeline` Null Object Pattern** — No more optional chaining; timeline is always initialised.

- **`runShellLivePipe` improved** — Output chunks collected in an array instead of string concatenation; more efficient memory use for long outputs.

- **Spinner thread safeguarded** — `[weak self]` capture and `deinit` safety net against retain cycles.

### Code Quality

- **Variable and function names cleaned up** — Short variable names replaced with descriptive ones; regex patterns documented; WHY comments added for non-obvious logic.

- **Magic numbers** — Spinner constants replaced with named values.

- **`firstAvailableScheme`** — Duplicated `xcodebuild -list` logic replaced with a shared function.

- **Coverage tree** — `build`/`Build` directories excluded from project and coverage tree.

---

## Version 1.0.14 — 2026-04-22

### Clean & Cache

- **New DerivedData browser** — New file `MenuDerivedDataDetails.swift` (209 lines): interactive browser for all DerivedData subdirectories with size display (cached via `du -sh`) and targeted deletion. New entry "Delete DerivedData selectively" in the "Clean & Cache" category of the split-pane menu.

- **Extended cache browser "Show all caches"** — New file `MenuCacheBrowser.swift` (395 lines): navigable browser `menuShowAllCaches()` for all Xcode caches with size display and targeted deletion. The "Show all caches" entry in "Clean & Cache" now opens the full browser. Sizes are cached; deletion with immediate cache invalidation.

### Build & Run

- **Show build settings** — New action `actionShowBuildSettings()` in the "Build & Run" category: displays all resolved build settings for the selected scheme via `xcodebuild -showBuildSettings`. Useful for diagnosing configuration issues and unexpected xcconfig values.

- **Dependencies moved into "Build & Run"** — The "Dependencies" menu item has been moved from its own category into "Build & Run", where it fits naturally in the build workflow.

### Simulator — new control actions

- **New "Control" category** — Twelve new simulator control actions, visible only in simulator mode:
  - **Test push notification** (`actionTestPushNotification`) — 9 predefined APNs payload templates (Simple, Structured, No Sound, Critical, Silent, Badge Only, With Reply Action, Yes/No Action, Custom)
  - **Set permissions** (`actionSetSimulatorPermissions`) — Privacy services (camera, photos, microphone, location, etc.) via `xcrun simctl privacy` grant / revoke / reset
  - **Add media** (`actionAddMedia`) — Add photos or videos to the simulator's gallery via `xcrun simctl addmedia`
  - **Open deep link** (`actionOpenDeepLink`) — Open a URL or Universal Link in the simulator via `xcrun simctl openurl`
  - **Mock status bar** (`actionMockStatusBar`) — Set a simulated status bar state
  - **Reset status bar** (`actionResetStatusBar`) — Restore the status bar to its default state
  - **Set location** (`actionSetLocation`) — Choose a GPS location from a city list or enter coordinates manually
  - **Clear keychain** (`actionClearKeychain`) — Reset the simulator's keychain
  - **Open app data folder** (`actionOpenAppDataFolder`) — Open the app container directly in Finder
  - Screenshot, video recording, Dark/Light Mode (existing actions, now grouped under "Control")

- **Simulator category extended** — Three new management actions: show all simulators, stop all simulators, clean up unavailable simulators.

### Website & Documentation

- **Website updates** — Corrections to title and product name in `website2/` (HTML, CSS, JS) regarding "XCode vs. Apple" naming conventions.

- **README files updated** — `README.md`, `README_DE.md`, `README_EN.md`, `README_DE.txt`, `README_EN.txt` with updated descriptions.

### Miscellaneous

- **Debug mode: less noise** — `Shell.swift`: certain diagnostic outputs are now only printed in debug builds.

---

## Version 1.0.3 — 2026-04-21

### Physical Devices

- **New feature: Deploy apps to physical devices** — The tool now supports building, installing, and launching apps directly on physical devices (iPhones, iPads). New files: `PhysicalDeviceActions.swift` (~470 lines) encapsulates all physical device actions; `DeviceTarget.swift` defines the new `DeviceTarget` type that unifies simulators and physical devices; `PhysicalDevice.swift` detects and manages connected devices; `PhysicalDeviceSelector.swift` provides a keyboard-driven device selection dialog. The existing `DeviceSelector.swift` has been extended to list physical devices alongside simulators. `MainMenu.swift` (split-pane) was updated to support physical device targets. New settings in `Preferences.swift` allow persisting the last selected physical device. The dashboard displays the active device (simulator or physical) in a unified format.

### Bugfixes

- **Bugfix: Dark mode menu — rendering error fixed** — `isDarkMode()` in `MainMenu.swift` now reads the system appearance via `UserDefaults.standard` instead of a shell call (`defaults read -g AppleInterfaceStyle`). The split-pane menu was rendered incorrectly in dark mode because the shell call occasionally failed inside raw mode.

- **Bugfix: macOS app — device selection skipped during working-directory change** — `MenuDirectory.swift` previously always called `selectDevice()` even when the device had already been auto-set to "My Mac" (macOS-only apps). The guard `!isMacOSDevice` fixes this. Additionally: the section label in `PhysicalDeviceSelector.swift` was corrected to use the proper localisation key `L("device")`.

### UX & Tests

- **UX: Unified menu colour — `boldBlue` instead of `boldMagenta`** — All menu item numbers and action shortcuts in `PhysicalDeviceActions.swift`, `SimulatorActions.swift`, and `DependencyActions.swift` (SPM/CocoaPods/Carthage menus) have been changed from `Color.boldMagenta` to `Color.boldBlue`, consistent with the app-wide colour scheme.

- **UX: Emoji arguments removed from `printSubSectionTitle()`** — `printSubSectionTitle()` is now called without an emoji argument in `ActionProjectManager.swift`, `PackageManagerSync.swift`, and further files. Results in cleaner, more consistent section headings.

- **Tests: Unit/UI tests on physical devices** — `ensureTestDeviceIsSimulator()` replaced by `ensureTestDeviceIsValid()`. Unit tests, UI tests, and "Run all test plans" now also run on physical devices (iPhones, iPads) — no longer restricted to simulators.

- **Tests: `IDE_TESTING_DEVICE_SUPPORT_DIAGNOSTICS=NO` added to speed flags** — Reduces diagnostic data collection when testing on physical devices, speeding up test start.

- **Tests: Show executed command (`printExecutedCommand()`)** — New helper function in `TestActions.swift` that prints the xcodebuild command before it runs, formatted across multiple lines (breaks at flag boundaries, similar to Xcode build logs). Called from `runTestsLiveParsed()` and physical device actions (install app, launch app).

- **Tests: Configuration and signing errors shown in test output** — `runTestsLive()` now detects signing, provisioning, missing development team, and capability errors from the xcodebuild output and displays them in the test report. Previously, `: error:` lines in `.xcodeproj` paths were silently ignored.

- **Tests: Key press after abort** — `postTestInteractionLoop()` now waits for a key press after an `operationAborted` cancel before returning to the menu. Prevents an immediate, unnoticed jump back.

- **Tests: xcresult supplement also after Ctrl+C (physical devices)** — `supplementTestDataFromXCResult()` is now also called after an `operationAborted` user cancel. Background: the user aborts because the toolbox hangs at a password prompt even though the tests have already finished — xcresult is the authoritative result source.

### Simulator

- **Simulator safety: `isSimulatorBooted()` — state check before simulator actions** — New helper `isSimulatorBooted(udid:)` queries `xcrun simctl list devices` to verify the selected simulator is in "Booted" state. Called before Screenshot, Video Recording, and Dark/Light Mode: if the simulator is not running, a clear error message is shown immediately — instead of silent failures and false success feedback. New localisation key `simulator_not_running_error` added in DE and EN.

- **Simulator safety: no more infinite hangs** — `actionRestartCurrentSimulator()` now waits for the simulator to fully boot via `xcrun simctl bootstatus -b` after `xcrun simctl boot` — consistent with the existing `bootDevice()` logic. `bootDevice()` itself: the `bootstatus` wait now uses `runShellLive()` instead of `runShell()`, so Ctrl+C cleanly aborts a hanging simulator.

- **Bugfix: `timeout` command (Linux-only) not available on macOS** — `bootDevice()`, `actionRestartCurrentSimulator()`, and all reset/stop functions used the `timeout` command, which does not exist on macOS. This caused "command not found" errors and `simctl` commands silently not executing — while still showing false success feedback. `timeout` has been replaced with `runShellLive()`; Ctrl+C cleanly aborts all affected simulator commands.

- **Bugfix: Video recording — `try?` replaced with proper error handling** — `actionStartVideoRecording()` used `try? videoProcess.run()`. If the simulator was not running, `readLine()` still blocked waiting for input, and "Recording saved" was falsely displayed afterwards. `run()` is now called with proper error handling; a start failure immediately aborts the action.

---

## Version 1.0.2 — 2026-04-19

### Project Manager, Persistent Raw Mode & Header Caching

- **New feature: Project Manager** — New "🔧 Project Manager" category in the split-pane main menu with three actions: `Initialize project` (clones repositories from a JSON configuration into a purely temporary directory), `Update project` (discards local changes and re-pulls), and `Delete project` (removes repositories and the state entry). Full logic in `ActionProjectManager.swift` (~1000 lines). Read-only against the remote — no commits, no pushes. State is persisted per JSON configuration in `.toolbox-project-state.json`. Entries are shown/hidden dynamically via `canShowProjectInit` / `canShowProjectUpdateOrDelete`.

- **Submodule support in the Project Manager** — The Project Manager now supports Git submodules and subtrees in cloned repositories. The optional JSON field `submodule_branch_strategy` controls how submodules are handled when switching branches or commits: `"follow_parent"` (default) switches all submodules to the same branch as the main repository, `"pinned"` leaves submodules at their Git-pinned commit, and an explicit branch name switches all submodules to exactly that branch. The switch is performed via `git submodule foreach --recursive`; if a branch does not exist in a submodule, it stays on its pinned commit (no abort). The "Show project info" action has been extended with a new "Submodules / Subtrees" section that explains all three strategies.

- **Persistent raw mode** — `enterRawMode()` / `exitRawMode()` in `RawInput.swift` enable raw mode (ICANON/ECHO off) once when the main menu starts, instead of per keystroke. Fixes the known issue where arrow keys briefly appeared as `^[[A` on screen because canonical mode was re-enabled between two `readRawKey()` calls. `runAction()` temporarily leaves raw mode during actions (so prompts work normally) and restores it afterwards with a flushed keyboard buffer.

- **Clean terminal cleanup on exit** — `atexit` handler and signal handlers for `SIGINT`, `SIGTERM`, `SIGHUP`, and `SIGQUIT` restore the original `termios` state and bring the cursor back — even when the tool is terminated via Ctrl+C or an external kill.

- **Git branch cached** — The expensive `git branch --show-current` call is no longer executed per rendered frame but only once (`cachedGitBranch()`). After actions, `invalidateHeaderCaches()` discards the cache.

- **AppleInterfaceStyle cached** — `defaults read -g AppleInterfaceStyle` is only executed on first render; the result is stored in `cachedDarkMode`.

- **Categories only rebuilt after actions** — `buildCategories()` no longer runs on every keystroke but only after actions. Saves dozens of `L()`/`Lf()` lookups and string interpolations per key press.

- **Device name & OS in simulator status messages** — `bootDevice()` and `installAndLaunchApp()` now also accept `deviceName`/`deviceOS`; messages now show concrete text like "Starting iPhone 17 Pro — iOS 26.1" instead of a generic "Starting simulator".

- **Stable ESC sequence handling in FileBrowser** — Arrow keys are now read via `VTIME=1` (100 ms timeout per follow-up byte) instead of `fcntl(O_NONBLOCK)`. Prevents occasionally ignored or misinterpreted arrow key sequences.

- **Split-pane left column wider** — Left category column widened from 15 to 18 characters (right column correspondingly 67 → 64), so longer category labels fit without truncation.

### Build & Test Output

- **Report Navigator style** — Build and test output is now presented in Report Navigator style (like Xcode). Structured, readable formatting with phase grouping.

- **XcodeBuildFormatter: structured build output** — Build output is grouped by phases (Compile, Link, Copy, Sign, etc.) and shows meaningful file names when copying resources (CopySwiftLibs, LinkAssetCatalog corrected).

- **Build formatter: target in phase headers** — `showTargetForPhase()` and `extractTargetFromPhaseLine()` now display the build target in relevant phase headers. `printStep()` uses `▸` instead of `→` for clearer visual separation.

- **Timeline with 3 states** — The build timeline now clearly distinguishes: ✅ Success, ⚠️ Technical Failure, ❌ Real Failures. Visual differentiation instead of simple success/failure.

### Tests

- **3-state test result classification** — Previously the tool only distinguished between "passed" and "failed". From now on three states are clearly separated:

  - ✅ **Success** — All tests passed, no technical error.
  - ⚠️ **Technical Failure** — `xcodebuild` reported `** TEST FAILED **`, but no actual test case failed (e.g. empty test target, missing test plan configuration, compiler error). The result is highlighted in yellow; a hint text explains the difference from real test failures.
  - ❌ **Real Failures** — At least one test case actually failed. Red border as before.

- **`TestRunOutcome` enum** — New enum with three cases: `.success`, `.technicalFailure`, and `.realFailures`. The `outcome` property on `TestRunData` derives the state from the set flags and counters.

- **`testFailed` flag in `TestRunData`** — New `Bool` field: set when `xcodebuild` outputs `** TEST FAILED **` — regardless of whether real test cases failed.

- **`printTestResultBox()` and `printTestSummary()` reworked** — Both functions now use a `switch data.outcome` instead of a simple `if/else`. Technical failures get their own yellow box with a hint message.

- **Live parsing: `runTestsLive()` detects `** TEST FAILED **`** — The live parser now sets `data.testFailed` when `xcodebuild` emits this marker.

- **`parseTestData()` updated** — The static parse function also sets the new `testFailed` flag correctly.

- **New test menu options** — Two new actions in the test menu: "Compile for testing" (without running tests) and "Run tests (no build)" (using pre-built app). `confirmAction()` before unit, UI, and all tests.

### Input & Interaction

- **[x] as unified back key** — No Enter needed anymore. [x] works consistently in: `waitForKeyPress()`, `DeviceSelector`, `SimulatorActions`. Significantly simplifies interaction.

- **confirmAction() responds immediately** — Confirms directly on j/J/y/Y without delay. Faster workflows.

- **Simulator loops: [+] without Enter** — For additional simulator iterations. More intuitive control flow.

- **readRawChar() and readDeviceSelection(max:)** — New input functions for improved control.

- **Live SPM package list during resolution** — While `xcodebuild -resolvePackageDependencies` runs, all packages are updated with live status indicators (○ pending / ⠋ loading / ✓ done / ✗ failed). ActivitySpinner shows the package name during Fetch/Clone. SPM dependency list uses new `printDepRow()` format (`◆ Name ─── version`).

- **`actionCancelled` flag and "Cancelled" message** — After declining a `confirmAction()` prompt, `waitForKeyPress()` returns immediately. A unified cancellation message is shown.

- **ActivitySpinner for cache and DerivedData operations** — `printStep()` replaced by ActivitySpinner. `printCtrlCHint()` now appears before the operation. `xcodebuild clean` uses `runXcodebuildLiveFormatted`.

- **`readDeviceSelection()` switched to `readLine()`** — Raw mode no longer needed.

- **New color `Color.boldDarkPurple`** — For [RETURN] hints in input prompts. New localization keys: `spm_resolve_retry`, `start_build_run_confirm`, `action_cancelled`.

### Hotkeys in the Split-Pane Menu

- **Hotkey bar (digits 1–9)** — A new hotkey bar is shown below the split-pane. Nine frequently used actions can be triggered directly by pressing a digit key, without navigating the cursor to a category or entry first:
  - `1` — Delete Toolbox Build
  - `2` — Delete caches without SPM
  - `3` — Build & Run (Simulator or native macOS)
  - `4` — Quick Reset & Build (DerivedData → Build → Launch)
  - `5` — Full Reset & Build (all caches → Build → Launch)
  - `6` — Relaunch app (Simulator mode only)
  - `7` — Run Unit Tests
  - `8` — Initialize project (only if no project is set up yet)
  - `9` — Update project (only if a project has already been initialized)

- **`autoConfirmHotkey` flag** — Actions triggered by a hotkey that would normally show a confirmation prompt (`confirmAction()`) are silently confirmed. The flag is reset after the action completes, so normal menu navigation is unaffected.

### Bug Fixes

- **Darkmode display issue in main menu fixed** — `MainMenu.swift` had a display issue in dark mode; colour values corrected.

- **CocoaPods dependency display corrected** — Fixed an issue in `DependencyActions.swift` causing incorrect output in the dependencies view.

- **Parameterised Swift Testing tests** — `runTestsLive()` and `parseTestData()` now recognise parameterised Swift Testing tests without quotes (e.g. `◇ Test decode_succeeds(input: TestInput(...)) passed after 0.001 seconds.`). Previously silently ignored — counters remained empty.

### Dependencies

- **CocoaPods: Live install/update list** — `runPodsInstallWithLiveList()`: `pod install` and `pod update` show all pods with live status indicators. New action: show Podfile.lock.

- **Carthage: Live update list and new actions** — `runCarthageWithLiveList()` shows all frameworks with live status during `carthage update`/`bootstrap`. New actions: show Cartfile.resolved, Bootstrap, update frameworks.

- **Thread-safe spinner** — `var spinnerRunning` replaced with a `SpinnerFlag` reference type; fixes Swift Sendable warning on thread closure capture.

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
