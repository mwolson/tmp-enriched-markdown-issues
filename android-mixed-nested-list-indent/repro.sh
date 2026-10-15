#!/usr/bin/env bash
# Builds this app in Release for one platform, launches it on the booted
# Android emulator or iOS Simulator, and saves a screenshot to
# screenshots/<platform>.png. The bug is visual, so compare that screenshot
# with the README rather than relying on the exit status.
#
#   npm ci
#   ./repro.sh android    # needs adb and one running emulator or device
#   ./repro.sh ios        # macOS only; needs one booted Simulator, or set
#                         # IOS_SIMULATOR_UDID to pick one

set -euo pipefail

platform=${1:-}
here=$(cd "$(dirname "$0")" && pwd)
cd "$here"

case "$platform" in
android | ios) ;;
*)
    echo "Usage: $0 android|ios" >&2
    exit 2
    ;;
esac
[[ -d node_modules ]] || { echo "Run npm ci first." >&2; exit 1; }
if [[ $platform == android ]]; then
    command -v adb >/dev/null || { echo "adb not found." >&2; exit 1; }
else
    command -v xcrun >/dev/null || { echo "xcrun not found." >&2; exit 1; }
    udid=${IOS_SIMULATOR_UDID:-}
    if [[ -z $udid ]]; then
        booted=$(xcrun simctl list devices booted | grep -oE '[0-9A-F-]{36}' || true)
        if [[ $(grep -c . <<<"$booted") != 1 ]]; then
            echo "Boot exactly one Simulator, or set IOS_SIMULATOR_UDID." >&2
            exit 1
        fi
        udid=$booted
    fi
fi

mkdir -p screenshots
npx expo prebuild --clean --platform "$platform"
if [[ $platform == android ]]; then
    npx expo run:android --variant release --no-bundler
    sleep 10
    adb exec-out screencap -p > screenshots/android.png
else
    # Build and launch directly: `expo run:ios` opens a development-client URL
    # whose "Open in" prompt would cover the screenshot.
    workspace=$(ls -d ios/*.xcworkspace)
    scheme=$(basename "$workspace" .xcworkspace)
    bundle_id=$(node -p 'require("./app.json").expo.ios.bundleIdentifier')
    xcodebuild -workspace "$workspace" -scheme "$scheme" -configuration Release \
        -destination "id=$udid" -derivedDataPath build/ios build
    xcrun simctl install "$udid" "build/ios/Build/Products/Release-iphonesimulator/$scheme.app"
    xcrun simctl launch "$udid" "$bundle_id"
    sleep 10
    xcrun simctl io "$udid" screenshot screenshots/ios.png
fi
echo "Saved screenshots/$platform.png"
