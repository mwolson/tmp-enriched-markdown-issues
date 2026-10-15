# react-native-enriched-markdown issue repros

Minimal repros for
[react-native-enriched-markdown](https://github.com/software-mansion/enriched-markdown)
list rendering bugs found while building
[T3 Code](https://github.com/pingdotgg/t3code)'s mobile app.

Each case is a blank `create-expo-app --template blank@sdk-57` app (Expo 57,
React Native 0.86.3) with `react-native-enriched-markdown@1.1.1` and an
`App.js` that renders the failing Markdown. Both opt out of the code
highlighting and math downloads in `package.json`, since neither bug needs
them.

```bash
cd <case>
npm ci
./repro.sh android   # one running emulator or device
./repro.sh ios       # one booted Simulator, or IOS_SIMULATOR_UDID=<udid>
```

`repro.sh` builds a Release app, launches it, and saves
`screenshots/<platform>.png`. The bugs are visual, so compare that screenshot
with the case README.

## Open

- [`ordered-list-marker-width`](ordered-list-marker-width) (observed with
  1.1.1 on Android API 36 and iOS 26.5): ordered list markers wider than `99.`
  lose their leading digits on both platforms.
- [`android-mixed-nested-list-indent`](android-mixed-nested-list-indent)
  (observed with 1.1.1 on Android API 36): on Android, a nested list whose
  marker type differs from its parent's draws its markers over or far from its
  text. iOS renders the same Markdown correctly.
