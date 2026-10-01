#!/usr/bin/env bats
# Behavior tests for bin/devclean
#
# Every test runs against a fake HOME in a temp folder, with xcrun, brew,
# pgrep and defaults replaced by stubs, so nothing real is touched.

load test_helper

setup() {
  setup_temp_dir
  DEVCLEAN="${DOTFILES_DIR}/bin/devclean"

  export HOME="${TEST_TEMP_DIR}/home"
  export DEVCLEAN_PROJECT_DIRS="${HOME}/Workspace"
  export DEVCLEAN_APPLICATIONS_DIRS="${HOME}/Applications"
  export STUB_LOG="${TEST_TEMP_DIR}/stubs.log"
  PROJECTS="${DEVCLEAN_PROJECT_DIRS}"
  mkdir -p "${PROJECTS}"
  touch "${STUB_LOG}"

  STUBS="${TEST_TEMP_DIR}/stubs"
  mkdir -p "${STUBS}"
  export PATH="${STUBS}:${PATH}"

  stub xcrun <<< 'echo "xcrun $*" >> "$STUB_LOG"'
  stub brew <<< 'echo "brew $*" >> "$STUB_LOG"'
  stub pgrep <<< 'exit 1'
  stub defaults <<< 'exit 1'
  stub xcode-select <<< 'exit 1'
}

teardown() {
  teardown_temp_dir
}

# Replaces a command with a script read from stdin
stub() {
  { echo '#!/bin/bash'; cat; } > "${STUBS}/$1"
  chmod +x "${STUBS}/$1"
}

# Creates a folder with a file in it, so it has a size
fill() {
  mkdir -p "$1"
  echo "data" > "$1/file"
}

# Creates a build folder with the output xcodebuild leaves behind
fill_xcode_build() {
  fill "$1/App.build"
  mkdir -p "$1/XCBuildData"
}

# Creates a fake Xcode app: make_xcode <path> <version> <build>
make_xcode() {
  mkdir -p "$1/Contents"
  printf '<?xml version="1.0" encoding="UTF-8"?>\n<plist version="1.0"><dict><key>%s</key><string>%s</string></dict></plist>\n' \
    CFBundleShortVersionString "$2" > "$1/Contents/Info.plist"
  printf '<?xml version="1.0" encoding="UTF-8"?>\n<plist version="1.0"><dict><key>%s</key><string>%s</string></dict></plist>\n' \
    ProductBuildVersion "$3" > "$1/Contents/version.plist"
}

# Makes xcrun report two runtimes: iOS 27.0 used today with two simulators,
# and iOS 17.5 last used in 2020 with none.
stub_runtimes() {
  cat > "${TEST_TEMP_DIR}/runtimes.json" <<EOF
{
  "RECENT-RUNTIME": {
    "build": "24A434", "version": "27.0", "sizeBytes": 8589934592,
    "runtimeIdentifier": "com.apple.CoreSimulator.SimRuntime.iOS-27-0",
    "lastUsedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  },
  "OLD-RUNTIME": {
    "build": "21F79", "version": "17.5", "sizeBytes": 7516192768,
    "runtimeIdentifier": "com.apple.CoreSimulator.SimRuntime.iOS-17-5",
    "lastUsedAt": "2020-01-01T00:00:00Z"
  }
}
EOF
  cat > "${TEST_TEMP_DIR}/devices.json" <<'EOF'
{ "devices": { "com.apple.CoreSimulator.SimRuntime.iOS-27-0": [ { "name": "iPhone" }, { "name": "iPad" } ] } }
EOF
  stub xcrun <<'EOF'
echo "xcrun $*" >> "$STUB_LOG"
case "$*" in
  "simctl runtime list -j") cat "$TEST_TEMP_DIR/runtimes.json" ;;
  "simctl list devices -j") cat "$TEST_TEMP_DIR/devices.json" ;;
esac
EOF
}

DERIVED_DATA_PATH="Library/Developer/Xcode/DerivedData"

# =============================================================================
# Options
# =============================================================================

@test "devclean --help explains usage" {
  run "$DEVCLEAN" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: devclean"* ]] || false
}

@test "devclean rejects unknown options" {
  run "$DEVCLEAN" --nope
  [ "$status" -ne 0 ]
  [[ "$output" == *"Unknown option: --nope"* ]] || false
}

@test "devclean rejects unknown --skip items" {
  run "$DEVCLEAN" --skip derived-data,nope
  [ "$status" -ne 0 ]
  [[ "$output" == *"Unknown item 'nope'"* ]] || false
}

# =============================================================================
# Reporting
# =============================================================================

@test "devclean reports without deleting by default" {
  fill "${HOME}/${DERIVED_DATA_PATH}/CompilationCache.noindex"
  fill "${HOME}/Library/Caches/org.swift.swiftpm/repositories"

  run "$DEVCLEAN"
  [ "$status" -eq 0 ]
  [[ "$output" == *"derived-data"* ]] || false
  [[ "$output" == *"swiftpm-cache"* ]] || false
  [[ "$output" == *"Nothing deleted"* ]] || false
  [ -d "${HOME}/${DERIVED_DATA_PATH}" ]
  [ -d "${HOME}/Library/Caches/org.swift.swiftpm" ]
}

@test "devclean says so when there is nothing to clean" {
  run "$DEVCLEAN"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Nothing to clean"* ]] || false
}

@test "devclean lists every item and where it looks, even when empty" {
  run "$DEVCLEAN"
  [ "$status" -eq 0 ]
  for id in derived-data simulators device-installs swiftpm-cache swiftpm-builds \
            xcode-builds gradle-builds npm-cache homebrew tool-caches; do
    [[ "$output" == *"$id"* ]] || false
  done
  [[ "$output" == *"~/Library/Developer/Xcode/DerivedData"* ]] || false
  [[ "$output" == *"~/Library/Caches/org.swift.swiftpm"* ]] || false
  [[ "$(grep -c ' none$' <<< "$output")" -ge 10 ]] || false
}

@test "devclean shows which project folders it searches" {
  export DEVCLEAN_PROJECT_DIRS="${HOME}/Workspace:${HOME}/Missing"

  run "$DEVCLEAN"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Project folders: ~/Workspace (not found: ~/Missing)"* ]] || false
}

@test "devclean says when no project folder exists" {
  run "$DEVCLEAN" --projects "${HOME}/Nope"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Project folders: none found (looked for ~/Nope)"* ]] || false
  [[ "$output" == *"--projects"* ]] || false
}

@test "devclean skips items with --skip in the report too" {
  run "$DEVCLEAN" --skip homebrew
  [ "$status" -eq 0 ]
  [[ "$output" != *"homebrew"* ]] || false
}

@test "devclean expands ~ in DEVCLEAN_PROJECT_DIRS" {
  export DEVCLEAN_PROJECT_DIRS='~/Workspace'
  touch "${PROJECTS}/Package.swift"
  fill "${PROJECTS}/.build"

  run "$DEVCLEAN"
  [ "$status" -eq 0 ]
  [[ "$output" == *"swiftpm-builds"* ]] || false
}

@test "devclean --projects overrides the project folders" {
  mkdir -p "${HOME}/Code"
  touch "${HOME}/Code/Package.swift"
  fill "${HOME}/Code/.build"

  run "$DEVCLEAN" --projects "${HOME}/Code"
  [ "$status" -eq 0 ]
  [[ "$output" == *"SwiftPM .build folders (1)"* ]] || false
}

# =============================================================================
# Deleting
# =============================================================================

@test "devclean --run --yes deletes caches" {
  fill "${HOME}/${DERIVED_DATA_PATH}/CompilationCache.noindex"
  fill "${HOME}/Library/Containers/com.apple.CoreDevice.CoreDeviceService/Data/Library/Caches/AppInstallationBinaryDeltas"
  fill "${HOME}/Library/Caches/org.swift.swiftpm"
  fill "${HOME}/.npm/_cacache"
  fill "${HOME}/Library/Caches/CocoaPods"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [[ "$output" == *"Done. Free space:"* ]] || false
  [ ! -e "${HOME}/${DERIVED_DATA_PATH}" ]
  [ ! -e "${HOME}/Library/Containers/com.apple.CoreDevice.CoreDeviceService/Data/Library/Caches/AppInstallationBinaryDeltas" ]
  [ ! -e "${HOME}/Library/Caches/org.swift.swiftpm" ]
  [ ! -e "${HOME}/.npm/_cacache" ]
  [ ! -e "${HOME}/Library/Caches/CocoaPods" ]
  [ -d "${HOME}/.npm" ]
}

@test "devclean --run refuses to delete without a terminal or --yes" {
  fill "${HOME}/${DERIVED_DATA_PATH}"

  run bash -c "'$DEVCLEAN' --run < /dev/null"
  [ "$status" -ne 0 ]
  [[ "$output" == *"--yes"* ]] || false
  [ -d "${HOME}/${DERIVED_DATA_PATH}" ]
}

@test "devclean --run refuses while Xcode is running" {
  stub pgrep <<< '[ "$2" = "Xcode" ]'
  fill "${HOME}/${DERIVED_DATA_PATH}"

  run "$DEVCLEAN" --run --yes
  [ "$status" -ne 0 ]
  [[ "$output" == *"Quit Xcode"* ]] || false
  [ -d "${HOME}/${DERIVED_DATA_PATH}" ]
}

@test "devclean --skip leaves items alone" {
  fill "${HOME}/${DERIVED_DATA_PATH}"
  fill "${HOME}/Library/Caches/org.swift.swiftpm"

  run "$DEVCLEAN" --run --yes --skip derived-data
  [ "$status" -eq 0 ]
  [ -d "${HOME}/${DERIVED_DATA_PATH}" ]
  [ ! -e "${HOME}/Library/Caches/org.swift.swiftpm" ]
}

# =============================================================================
# Build folders
# =============================================================================

@test "devclean only deletes .build folders next to a Package.swift" {
  mkdir -p "${PROJECTS}/App/Packages/Core"
  touch "${PROJECTS}/App/Packages/Core/Package.swift"
  fill "${PROJECTS}/App/Packages/Core/.build"
  fill "${PROJECTS}/Other/.build"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ ! -e "${PROJECTS}/App/Packages/Core/.build" ]
  [ -d "${PROJECTS}/Other/.build" ]
}

@test "devclean only deletes build folders next to a Gradle file" {
  mkdir -p "${PROJECTS}/android/app"
  touch "${PROJECTS}/android/app/build.gradle.kts"
  fill "${PROJECTS}/android/app/build"
  fill "${PROJECTS}/website/build"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ ! -e "${PROJECTS}/android/app/build" ]
  [ -d "${PROJECTS}/website/build" ]
}

@test "devclean deletes Xcode build folders next to a project or package" {
  mkdir -p "${PROJECTS}/App/App.xcodeproj" "${PROJECTS}/App/Packages/Domain"
  fill_xcode_build "${PROJECTS}/App/build"
  touch "${PROJECTS}/App/Packages/Domain/Package.swift"
  fill "${PROJECTS}/App/Packages/Domain/build/Debug-iphoneos"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [[ "$output" == *"Xcode build folders (2)"* ]] || false
  [ ! -e "${PROJECTS}/App/build" ]
  [ ! -e "${PROJECTS}/App/Packages/Domain/build" ]
  [ -d "${PROJECTS}/App/App.xcodeproj" ]
}

@test "devclean keeps build folders next to a package that hold no Xcode output" {
  mkdir -p "${PROJECTS}/Worksheets"
  touch "${PROJECTS}/Worksheets/Package.swift"
  mkdir -p "${PROJECTS}/Worksheets/build"
  echo "pdf" > "${PROJECTS}/Worksheets/build/worksheet.pdf"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ -f "${PROJECTS}/Worksheets/build/worksheet.pdf" ]
}

@test "devclean keeps Xcode output that isn't next to a project or package" {
  fill_xcode_build "${PROJECTS}/Loose/build"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ -d "${PROJECTS}/Loose/build/XCBuildData" ]
}

@test "devclean counts a build folder next to both Gradle and Xcode files once" {
  mkdir -p "${PROJECTS}/Multiplatform"
  touch "${PROJECTS}/Multiplatform/build.gradle.kts" "${PROJECTS}/Multiplatform/Package.swift"
  fill_xcode_build "${PROJECTS}/Multiplatform/build"

  run "$DEVCLEAN"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Gradle build folders (1)"* ]] || false
  [[ "$output" != *"Xcode build folders (1)"* ]] || false
}

@test "devclean keeps build folders tracked in git" {
  mkdir -p "${PROJECTS}/Tracked"
  touch "${PROJECTS}/Tracked/Package.swift"
  fill "${PROJECTS}/Tracked/.build"
  git -C "${PROJECTS}/Tracked" init -q
  git -C "${PROJECTS}/Tracked" add -f .build/file

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ -f "${PROJECTS}/Tracked/.build/file" ]
}

@test "devclean handles folder names with spaces" {
  mkdir -p "${PROJECTS}/My App"
  touch "${PROJECTS}/My App/Package.swift"
  fill "${PROJECTS}/My App/.build"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ ! -e "${PROJECTS}/My App/.build" ]
  [ -f "${PROJECTS}/My App/Package.swift" ]
}

@test "devclean does not follow symlinked build folders" {
  fill "${TEST_TEMP_DIR}/outside"
  mkdir -p "${PROJECTS}/Linked"
  touch "${PROJECTS}/Linked/Package.swift"
  ln -s "${TEST_TEMP_DIR}/outside" "${PROJECTS}/Linked/.build"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ -f "${TEST_TEMP_DIR}/outside/file" ]
}

# =============================================================================
# Xcode and tools
# =============================================================================

@test "devclean uses a custom DerivedData folder inside the home folder" {
  fill "${HOME}/Custom/DerivedData"
  stub defaults <<< "echo '${HOME}/Custom/DerivedData'"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ ! -e "${HOME}/Custom/DerivedData" ]
}

@test "devclean ignores a custom DerivedData folder outside the home folder" {
  fill "${TEST_TEMP_DIR}/elsewhere/DerivedData"
  stub defaults <<< "echo '${TEST_TEMP_DIR}/elsewhere/DerivedData'"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ -f "${TEST_TEMP_DIR}/elsewhere/DerivedData/file" ]
}

@test "devclean deletes unavailable simulators through simctl" {
  stub xcrun <<'EOF'
echo "xcrun $*" >> "$STUB_LOG"
if [ "$1 $2 $3" = "simctl list devices" ]; then
  echo "-- Unavailable: com.apple.CoreSimulator.SimRuntime.iOS-26-2 --"
  echo "    iPad Pro (M5) (F3062B90-F7DB-4DBF-A21D-9AF6BC6EC06D) (Shutdown) (unavailable, runtime profile not found)"
fi
EOF
  fill "${HOME}/Library/Developer/CoreSimulator/Devices/F3062B90-F7DB-4DBF-A21D-9AF6BC6EC06D"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [[ "$output" == *"Simulators without a runtime (1)"* ]] || false
  grep -q "xcrun simctl delete unavailable" "$STUB_LOG"
}

@test "devclean reports and runs Homebrew cleanup" {
  stub brew <<'EOF'
echo "brew $*" >> "$STUB_LOG"
case "$*" in
  *--dry-run*) echo "==> This operation would free approximately 1.5GB of disk space." ;;
esac
EOF

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [[ "$output" == *"1.5 GB"* ]] || false
  grep -qx "brew cleanup --prune=all" "$STUB_LOG"
}

# =============================================================================
# Xcodes and simulator runtimes (listed, never deleted)
# =============================================================================

@test "devclean lists installed Xcodes and marks the selected one" {
  make_xcode "${HOME}/Applications/Xcode.app" 27.0 27A266a
  make_xcode "${HOME}/Applications/Xcode-27.1.app" 27.1 27A9269
  stub xcode-select <<< "echo '${HOME}/Applications/Xcode.app/Contents/Developer'"

  run "$DEVCLEAN"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Xcode 27.0 (27A266a)"* ]] || false
  [[ "$output" == *"Xcode 27.1 (27A9269)"* ]] || false
  [[ "$(grep -c 'selected' <<< "$output")" -eq 1 ]] || false
  [[ "$(grep 'Xcode 27.0' <<< "$output")" == *"selected"* ]] || false
  [[ "$output" == *"Each Xcode keeps its own compilation cache"* ]] || false
}

@test "devclean only mentions the compilation cache with more than one Xcode" {
  make_xcode "${HOME}/Applications/Xcode.app" 27.0 27A266a

  run "$DEVCLEAN"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Xcode 27.0 (27A266a)"* ]] || false
  [[ "$output" != *"Each Xcode keeps its own compilation cache"* ]] || false
}

@test "devclean lists simulator runtimes and flags unused ones" {
  stub_runtimes

  run "$DEVCLEAN"
  [ "$status" -eq 0 ]
  [[ "$output" == *"iOS 27.0 (24A434)"*"8.0 GB"*"used $(date -u +%Y-%m-%d), 2 simulators"* ]] || false
  [[ "$output" == *"iOS 17.5 (21F79)"*"used 2020-01-01, 0 simulators"* ]] || false
  [[ "$output" == *"no simulators. Remove with: xcrun simctl runtime delete OLD-RUNTIME"* ]] || false
  [[ "$output" != *"delete RECENT-RUNTIME"* ]] || false
}

@test "devclean says when no runtime looks unused" {
  stub_runtimes
  cat > "${TEST_TEMP_DIR}/runtimes.json" <<JSON
{ "RECENT-RUNTIME": { "build": "24A434", "version": "27.0", "sizeBytes": 1024,
  "runtimeIdentifier": "com.apple.CoreSimulator.SimRuntime.iOS-27-0",
  "lastUsedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)" } }
JSON

  run "$DEVCLEAN"
  [ "$status" -eq 0 ]
  [[ "$output" == *"None look unused"* ]] || false
}

@test "devclean never deletes Xcodes or runtimes" {
  make_xcode "${HOME}/Applications/Xcode.app" 27.0 27A266a
  make_xcode "${HOME}/Applications/Xcode-27.1.app" 27.1 27A9269
  stub_runtimes
  fill "${HOME}/${DERIVED_DATA_PATH}"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ -d "${HOME}/Applications/Xcode.app" ]
  [ -d "${HOME}/Applications/Xcode-27.1.app" ]
  [ -z "$(grep "runtime delete" "$STUB_LOG")" ]
  [[ "$output" != *"Xcode versions"* ]] || false
}

# =============================================================================
# Safety regressions
# =============================================================================

@test "devclean never deletes through a symlinked parent folder that leads outside home" {
  fill "${TEST_TEMP_DIR}/outside-caches/org.swift.swiftpm"
  mkdir -p "${HOME}/Library"
  ln -s "${TEST_TEMP_DIR}/outside-caches" "${HOME}/Library/Caches"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ -f "${TEST_TEMP_DIR}/outside-caches/org.swift.swiftpm/file" ]
}

@test "devclean ignores a custom DerivedData path that climbs out of home with .." {
  fill "${TEST_TEMP_DIR}/victim/DerivedData"
  stub defaults <<< "echo '${HOME}/../victim/DerivedData'"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ -f "${TEST_TEMP_DIR}/victim/DerivedData/file" ]
}

@test "devclean leaves a DerivedData folder that is itself a symlink alone" {
  fill "${TEST_TEMP_DIR}/external/DerivedData"
  mkdir -p "${HOME}/Library/Developer/Xcode"
  ln -s "${TEST_TEMP_DIR}/external/DerivedData" "${HOME}/${DERIVED_DATA_PATH}"

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [ -L "${HOME}/${DERIVED_DATA_PATH}" ]
  [ -f "${TEST_TEMP_DIR}/external/DerivedData/file" ]
}

@test "devclean skips project folders that lead outside home" {
  mkdir -p "${TEST_TEMP_DIR}/external-code/App"
  touch "${TEST_TEMP_DIR}/external-code/App/Package.swift"
  fill "${TEST_TEMP_DIR}/external-code/App/.build"
  ln -s "${TEST_TEMP_DIR}/external-code" "${HOME}/Code"

  run "$DEVCLEAN" --run --yes --projects "${HOME}/Code"
  [ "$status" -eq 0 ]
  [[ "$output" == *"outside your home folder, skipped: ~/Code"* ]] || false
  [ -f "${TEST_TEMP_DIR}/external-code/App/.build/file" ]
}

@test "devclean checks each path again right before deleting it" {
  fill "${HOME}/Library/Developer/CoreSimulator/Devices/F3062B90-F7DB-4DBF-A21D-9AF6BC6EC06D"
  fill "${HOME}/Library/Caches/org.swift.swiftpm"
  # Deleting simulators runs before the SwiftPM cache. Use that moment to swap
  # ~/Library/Caches for a symlink to a folder outside home.
  stub xcrun <<'STUB'
case "$*" in
  "simctl list devices unavailable")
    echo "    Old (F3062B90-F7DB-4DBF-A21D-9AF6BC6EC06D) (Shutdown) (unavailable, runtime profile not found)"
    ;;
  "simctl delete unavailable")
    mv "$HOME/Library/Caches" "$TEST_TEMP_DIR/moved-caches"
    ln -s "$TEST_TEMP_DIR/moved-caches" "$HOME/Library/Caches"
    ;;
esac
STUB

  run "$DEVCLEAN" --run --yes
  [ "$status" -eq 0 ]
  [[ "$output" == *"changed since the scan"* ]] || false
  [ -f "${TEST_TEMP_DIR}/moved-caches/org.swift.swiftpm/file" ]
}
