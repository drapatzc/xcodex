> **Note:** The same repository also contains **xdirx** — a keyboard-driven directory browser for the macOS terminal that helps you copy paths to the clipboard instantly and navigate the Finder with ease. [More details below.](#xdirx)

---

# Command-Line Tool xcodex

A cursor-driven CLI app for iOS and macOS developers.  
Not affiliated with Apple or Xcode.
Available in **German** and **English**.

---

## Why this tool?

As an Apple developer, you constantly switch between Xcode, the Terminal, and tools like `xcodebuild` or `simctl`. Every command has its own flags, its own syntax — and every time it costs you time to get back up to speed.

The Xcode Developer Toolbox addresses exactly that: no window switching, no flag lookups, no waiting on Xcode.

<img src="images/image01.png" alt="XCODEX Overview" width="800">

Once you try it, you won't want to start typical Xcode tasks any other way.

---

## How Xcode normally builds

Xcode writes all build artifacts into a shared DerivedData folder at `~/Library/Developer/Xcode/DerivedData/`. Compiled files, index data, logs, and temporary build products from all projects land there simultaneously. When a build runs, Xcode accesses exactly this folder — and every other parallel process does the same. This usually works fine, but when Xcode is indexing in the background, another build is running, or old remnants from a previous project are still lying around, silent conflicts can occur: builds fail for unclear reasons, caches get reused incorrectly, errors can't be reproduced. The classic remedy — "Clean Build Folder" — deletes everything and builds from scratch, but costs time and doesn't solve the actual cause.

<img src="images/image02.png" alt="Own DerivedData" width="800">

---

## What makes this tool special

### Own DerivedData — clean and isolated

The script builds into its own DerivedData folder — completely independent from Xcode. Both can run simultaneously without getting in each other's way. Every run starts in a fresh environment: no old remnants, no side effects. When something goes wrong, you know immediately: it comes from the current state — not from a cache from yesterday.

<img src="images/image03.png" alt="Own DerivedData" width="800">

---

### Branch & Commit — build and compare precisely

Check out any branch or commit, build locally, and launch — without touching your own development environment. Through parallel builds, different project states can be cleanly compared.

<img src="images/image04.png" alt="Branch & Commit" width="800">

The special part: not just iOS developers benefit from this.

- **Android developers** can check out and test the current iOS state at any time — without Xcode knowledge
- **QA and testers** don't have to wait for TestFlight — build and verify directly from source code
- **Designers** see changes immediately in context, on different iOS versions
- **Product Owners** can access the current state at any time and present spontaneously

---

### Further highlights

- **Multi-Simulator:** iOS 16, 17, 18 in sequence — same flags, reproducible, without the Xcode GUI
- **Granular cache control:** 10+ options (DerivedData, SPM, CocoaPods, Simulator cache …) with size display before deletion
- **Build Timeline:** ASCII diagram (Gantt / Block-Flow) after every build — instantly see which phase is slowing things down
- **Automated testing:** Configure tests on an interval (1 min – 24 h) — xcodex runs independently, displays results in three levels (✅ ⚠️ ❌) live, and sends a macOS notification; failed tests can be retried in isolation on a different simulator without rebuilding everything
- **Physical devices:** Auto-detect connected iOS/iPadOS devices via `devicectl`, install, launch, terminate, and follow logs live — all directly from the terminal, without opening Xcode
- **Simulator control:** Screenshot (PNG), MP4 recording, toggle Dark/Light Mode, simulate location, send push notifications, trigger deep links, set app permissions — without touching Xcode
- **App Store Connect & TestFlight:** Create archives, export IPA and upload to TestFlight (iOS) or create DMG, notarize, and submit to App Store Connect (macOS) — all as a seamless workflow without a browser
- **Package managers under one roof:** SPM, CocoaPods, Carthage — update all three, clear caches, display dependency graphs
- **Localization check:** Detect missing translation keys, duplicate keys, and inconsistent placeholders across all language files — without an external tool
- **Crash reports with symbolication:** Retrieve, symbolicate, and analyze recent crash logs directly in the terminal
- **Instruments integration:** Launch Instruments profiling directly from the menu
- **Provisioning profiles:** Overview of all installed profiles with expiry date and certificate status directly in the terminal
- **Project manager:** Save project selection and configuration persistently, update or reset on demand — settings persist across sessions
- **Apple developer info:** Xcode release notes, Swift Evolution proposals, Apple Developer news, and security updates accessible directly from the tool
- **Lean and self-contained:** 0 external dependencies, only 4 MB binary size — no Homebrew, no Node, no Ruby required
- **Persistence:** Scheme, device, bundle ID stay saved — next session starts in seconds

---

## Requirements for Android developers & non-iOS developers

### Mandatory — without this nothing works

**1. Mac with macOS Ventura 13 or newer**  
The script is macOS-only. No Windows, no Linux.

**2. Xcode (full version, from the App Store)**  
- App Store → "Xcode" → Install (~30 GB)
- Open once so Apple can install the components
- Afterwards Xcode can stay closed — the script takes over everything
- Run once in the terminal:

```bash
sudo xcode-select --switch /Applications/Xcode.app
```

**3. iOS Simulator Runtimes**  
Install older iOS versions in Xcode afterwards:  
Xcode → Settings → Platforms → download desired version

### Effort — one-time, not recurring

| Step | Time required |
|------|--------------|
| Install Xcode | 30–60 min (download-dependent) |
| Set up `xcode-select` | 1 min |
| Clone script + set alias | 2 min |
| Set up project (press A) | 3–5 min |
| **Total** | **~1 hour, one-time** |

Afterwards: next session starts in 10 seconds.

### Optional tools (only if the project needs them)

The script automatically detects if they're missing and shows a warning.

| Tool | For | Installation |
|------|-----|-------------|
| CocoaPods | If `Podfile` in project | `sudo gem install cocoapods` |
| Carthage | If `Cartfile` in project | `brew install carthage` |
| SwiftLint | Code quality | `brew install swiftlint` |

SPM is included in Xcode — no separate installation needed.

---

<a name="xdirx"></a>

## xdirx — Directory browser for the terminal

**xdirx** is a keyboard-driven directory browser for the macOS terminal. It lives in the same repository as **xcodex** and complements it perfectly in everyday developer work.

### What xdirx can do

With **xdirx** you navigate your file system using the arrow keys — no mouse, no Finder detours. A single keypress (Space) copies the current path to the clipboard immediately. Favourite directories can be saved as hotkey slots (1–9) and recalled at any time with one key.

| Feature | Description |
|---------|-------------|
| Path to clipboard | Space — instantly, without selecting |
| Hotkey slots 1–9 | Save favourite folders and recall with one key |
| Open in Finder | `f` — open the selected directory directly in Finder |
| Terminal window | `t` — open a new terminal window for the directory |
| Xcode projects | `.xcodeproj` / `.xcworkspace` are detected and opened directly in Xcode with `Return` |

### How xdirx supports you

When working with **xcodex**, Claude Code, or other AI assistants, you constantly need directory paths — for commands, configurations, or prompts. Instead of opening a terminal, navigating, typing `pwd`, selecting the output, and copying it, a single keypress in **xdirx** is all it takes. No window switching, no typing, no selecting.

---

## Installation of the command-line tools

### xcodex

#### 1. Clone repository

```bash
git clone https://github.com/drapatzc/xcodex.git ~/Developer/xcodex
```

#### 2. Set execution permissions

```bash
chmod +x ~/Developer/xcodex/xcodex
```

#### 3. Set up shell alias

**zsh**
```bash
echo 'alias xcodex="$HOME/Developer/xcodex/xcodex"' >> ~/.zshrc
source ~/.zshrc
```

**bash**
```bash
echo 'alias xcodex="$HOME/Developer/xcodex/xcodex"' >> ~/.bash_profile
source ~/.bash_profile
```

**fish**
```fish
alias xcodex="$HOME/Developer/xcodex/xcodex"
funcsave xcodex
```

#### 4. Update

```bash
cd ~/Developer/xcodex
git pull
```

#### 5. Launch from project root

```bash
cd YourXcodeProject
xcodex
```

---

### xdirx

The repository was already downloaded when cloning `xcodex`.

#### 1. Set execution permissions

```bash
chmod +x ~/Developer/xcodex/xdirx
```

#### 2. Set up shell alias

**zsh**
```bash
echo 'alias xdirx="$HOME/Developer/xcodex/xdirx"' >> ~/.zshrc
source ~/.zshrc
```

**bash**
```bash
echo 'alias xdirx="$HOME/Developer/xcodex/xdirx"' >> ~/.bash_profile
source ~/.bash_profile
```

**fish**
```fish
alias xdirx="$HOME/Developer/xcodex/xdirx"
funcsave xdirx
```

#### 3. Update

See xcodex.

#### 4. Launch from project root

```bash
cd YourXcodeProject
xdirx
```

---

## Using xcodex

The **xcodex** menu is split into two columns: categories on the left, actions on the right.

| Key | Action |
|-----|--------|
| `↑` `↓` | Switch entry in the active column |
| `←` `→` | Switch between category and action column |
| `Enter` | Execute highlighted command |
| `Q` | Quit app |
| `S` | Select scheme |
| `D` | Select device / simulator |
| `K` | Configuration (Debug / Release) |
| `B` | Set bundle ID |
| `L` | Switch language (DE / EN) |
| `A` | Select working directory |

Settings are persistently saved in `~/.xcode_toolbox_prefs.json`.

---

## Features of xcodex

### Clean & Cache

| Action | Description |
|--------|-------------|
| `xcodebuild clean` | Clean project via xcodebuild |
| Delete toolbox build | Delete only the app-specific DerivedData folder |
| Delete DerivedData | Delete the entire DerivedData folder |
| Delete module cache | Clean Xcode module cache |
| Delete simulator cache | Clear CoreSimulator caches |
| Delete Xcode caches | Clean internal Xcode caches |
| Delete caches (without SPM) | All caches except SPM in one step |
| Delete caches (with package manager) | All caches including detected package managers |

### Dependencies

| Action | Description |
|--------|-------------|
| Dependencies | Show resolved SPM dependencies |
| Resolve | Synchronize SPM, CocoaPods, and Carthage |

### Build & Run

| Action | Description |
|--------|-------------|
| Build | Compile app |
| Build & Run | Build and launch directly in simulator / on macOS |
| Quick Reset & Build | Delete app build folder → Build → Launch |
| Full Reset & Build | Delete all caches → Build → Launch |

### Simulator

| Action | Description |
|--------|-------------|
| Launch app | Launch last built app in simulator |
| Restart app | Restart app on selected simulator |
| Restart simulator | Restart running simulator |
| Stop simulator | Terminate running simulator |
| Reset simulator | Delete simulator data (Erase) |
| Screenshot | Take screenshot (→ Desktop) |
| Video recording | Start/stop screen recording (→ Desktop) |
| Dark/Light Mode | Toggle simulator appearance |

### Test

| Action | Description |
|--------|-------------|
| Run unit tests | Start unit tests with speed optimizations |
| Run UI tests | Start UI tests |
| Run all tests | Unit and UI tests together |
| Automated tests | Tests with configurable interval, live display, and macOS notifications |

### App Store

| Action | Description |
|--------|-------------|
| Create archive | Create iOS or macOS archive via xcodebuild |
| Export IPA | Export signed IPA for iOS distribution |
| Create DMG | Package macOS app as DMG |
| Notarize | Submit macOS DMG to Apple for notarization |
| Upload | Upload finished archive to App Store Connect |

### Miscellaneous

| Action | Description |
|--------|-------------|
| Tools & Versions | Show Xcode, Swift, CocoaPods, Carthage, SwiftLint, SwiftFormat versions |
| File metrics | Analyze all `.swift` files (lines, functions, risk) |
| Project metrics | Aggregated overall project overview |
| Provisioning profiles | Show installed profiles with expiry date and certificate status |
| Crash reports | Analyze and display recent crash logs with symbolication |

### Xcode

| Action | Description |
|--------|-------------|
| Close Xcode | Terminate Xcode process |
| Open project | Open current project in Xcode |

---

## Architecture & Source Code

The scripts (`toolbox` and `xcodex`) are publicly available on GitHub, along with reference apps for testing with various Xcode setups (SPM, CocoaPods, Carthage, with/without unit and UI tests). The actual source code is private — only the executable version is provided.

### Technical Details

| Property | Details |
|----------|---------|
| **Language** | Swift (Swift Package Manager) |
| **Platform** | macOS (Executable Target) |
| **UI** | Cursor-driven split-pane menu with ANSI colors |
| **Persistence** | JSON file at `~/.xcode_toolbox_prefs.json` |
| **Signal handling** | `Ctrl+C` safely aborts running operations |
| **Dependencies** | None external — only Foundation and Xcode Command Line Tools |
| **Build optimization** | `-parallelizeTargets`, `COMPILER_INDEX_STORE_ENABLE=NO`, `ONLY_ACTIVE_ARCH=YES`, in debug mode `SWIFT_COMPILATION_MODE=incremental` |

---

## Developer

I build software for the Apple ecosystem — native iOS and macOS apps, my own games, and developer tools.

### Portfolio

**[christiandrapatz.de](https://christiandrapatz.de)**

### AI Apps

**[betterlocale.com](https://betterlocale.com)**

- [BetterLocale Crash](https://betterlocale.com/en-crash/)
- [BetterLocale Code](https://betterlocale.com/en-code/)
- [BetterLocale Store](https://betterlocale.com/en-store/)
- [BetterLocale Doc](https://betterlocale.com/en-doc/)
- [BetterLocale MarkDown](https://betterlocale.com/en-markdown/)

### Games

**[atomiumgames.com](https://atomiumgames.com)**

- [crazy-monsters.com](https://crazy-monsters.com)
- [tower-arena.com](https://tower-arena.com)
- [strategy-war.com](https://strategy-war.com)
- [battle-alliance.com](https://battle-alliance.com)

### Apps

**[onetwoapps.de](https://www.onetwoapps.de)**

- [scanbox-app.de](https://scanbox-app.de)
- [meinhaushaltsbuch.app](https://meinhaushaltsbuch.app)

---

## Author

Christian Drapatz — [christiandrapatz.de](https://christiandrapatz.de) — 2026

## License

This project is not released under an open-source license.  
All rights reserved.
