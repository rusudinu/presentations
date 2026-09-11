# Verified facts (checked September 2026) — use these, they override the old decks

Current versions to cite if you cite any:
- **Flutter 3.47.x** (3.47.0 shipped 12 Aug 2026; 3.44 was the Google I/O 2026 release), **Dart 3.13**
  (primary constructors, `final`/`var` no longer allowed on non-declaring parameters). Dot shorthands
  are stable since Dart 3.10. Macros were cancelled in January 2025; codegen stays on `build_runner`.
- Flutter 3.47 moved Material and Cupertino into the standalone `material_ui` / `cupertino_ui`
  packages (`dart fix --apply --code=migrate_design_widgets`); `package:flutter/material.dart` still
  works and `flutter create` still uses it, but the in-SDK libraries are scheduled for deprecation in
  the November 2026 stable. Material 3 Expressive is not in the SDK.
- **Kotlin 2.4.20** (Sep 2026); Compose Multiplatform 1.12 (Aug 2026, web target still beta)
- **Go 1.27** (Aug 2026: generic methods, `encoding/json/v2`); Green Tea GC default since Go 1.26
- **TinyGo 0.42** (Sep 2026: `recover` works for runtime panics, Go 1.27, ESP32-C6 chip support)
- Android 17 (API 37, June 2026). Google Play requires target API 36 for new apps and updates since
  31 Aug 2026 and 16 KB page-size support for apps targeting API 35+. Android Studio 2026.1, AGP 9.4.
- iOS 27 / Xcode 27 ship mid-September 2026. The App Store has required the iOS 26 SDK since
  28 April 2026 and requires the iOS 27 SDK from April 2027. Xcode 27 raises Flutter's minimum to iOS 15.
- React Native 0.87; Expo SDK 57. The legacy RN architecture was removed in 0.82 (Oct 2025).

Rendering / compilation:
- Flutter's renderer is **Impeller**. iOS is Impeller-only (no Skia switch). Android runs Impeller by
  default on API 29+ with Vulkan and falls back to the legacy OpenGL renderer below that; an opt-out
  flag is still documented on Android. Impeller is the desktop default since Flutter 3.47. Flutter web
  still renders with Skia (CanvasKit). Do not present Skia as the mobile renderer.
- Dart: **JIT in debug (hot reload), AOT-compiled to native machine code for release.** Both are true;
  do not present JIT vs AOT as a language-level dichotomy.

React Native:
- The **new architecture (JSI + Fabric, bridgeless) is the default since RN 0.76 (Oct 2024)**. The old
  serialized JSON "bridge" is gone — do not describe RN as "bridging over JSON".
- **App Center and hosted CodePush were retired by Microsoft on 31 March 2025** (a self-hosted
  `code-push-server` remains). OTA JS updates still exist; the mainstream successor is **Expo EAS
  Update** (`expo-updates`).

Kotlin Multiplatform:
- **Stable since 1 Nov 2023.** **Compose Multiplatform for iOS stable since May 2025** (CMP 1.8.0).
- Production users incl. **McDonald's, Netflix, Forbes**. Mechanism: shared Kotlin module compiled
  natively per platform (Kotlin/Native on iOS); `expect`/`actual` for platform-specific pieces.

Hardware numbers (2026-typical):
- Flagship phone (Pixel 11 Pro, Galaxy S26 Ultra, iPhone 18 Pro): **12–16 GB RAM** on Android
  (Apple publishes no RAM figure), 256 GB base storage, 120 Hz screens, ~5 W peak SoC draw. Mid-range
  phones have 8 GB RAM and 120 Hz too.
- ESP32 (original): **520 KB SRAM**, ~4 MB flash on WROOM-32-class modules, milliwatt budgets.
- **TinyGo:** TinyGo 0.42 drives the original Xtensa ESP32 (interrupts, ADC, flash XIP) and `espradio`
  gives it Wi-Fi, but it has no Bluetooth without an HCI co-processor.
  Recommend **ESP32-C3 (RISC-V) or ESP32-S3 (Xtensa LX7)**: Wi-Fi via the `espradio` package since
  TinyGo 0.41 (April 2026) and Bluetooth via `espradio` since TinyGo 0.42 (September 2026); or the
  **Raspberry Pi Pico (RP2040/RP2350)**, which is first-tier. ESP32-C6 has chip support since 0.42 but
  no radio in `espradio` yet. Chip numbers: ESP32-C3 400 KB SRAM, ESP32-S3 512 KB, ESP32-C6 512 KB
  with Wi-Fi 6 and 802.15.4, RP2350 520 KB at 150 MHz.

Web / PWA:
- Still true: limited sensor access, no reliable background execution (no background sync on iOS),
  WebKit-only engine on iOS caps performance.
- Apple's Feb 2024 move to disable EU home-screen web apps was **reversed** — PWAs work in the EU.
  iOS 26 opens home-screen sites as web apps by default. Safari 18.4 added Declarative Web Push.

Frames & performance:
- The "16 ms budget" is only true at 60 Hz. **Most 2026 phones run 90–120 Hz → an 8.3 ms budget
  at 120 Hz.** State it as "one frame budget = 1/refresh rate", not a fixed 16 ms.
- **Bitcode was removed by Apple in Xcode 14 (2022).** Never recommend it.
- O(N²) is **quadratic**, not "exponential".

Flutter framework correctness (frequently wrong in the old decks):
- Flutter does **not** rebuild the whole widget tree each frame — only dirty subtrees rebuild.
  Element reuse is decided by `runtimeType` then `key`.
- `StatelessWidget` does **not** "build once" — it rebuilds whenever its parent rebuilds or a
  dependency changes. It just holds no mutable state of its own.
- Isolates: **no shared mutable memory, so no data races** — but logical/ordering races are still
  possible. Do not claim "race conditions: impossible".
- Isolate count is not capped at core count; `Isolate.spawn`/`compute` schedule onto the OS.

Firebase Auth:
- **Email-enumeration protection is on by default since late 2023**: you get `invalid-credential`,
  not `user-not-found` / `wrong-password`. Never teach UX that reveals whether an account exists.
- A rule like `allow create: if request.auth != null` lets any signed-in user write under someone
  else's uid — it must compare `request.auth.uid == userId`.
- Never show passwords stored in Firestore, even as a bad example screenshot.

Packages (use current names):
- `google_generative_ai` is deprecated → **`firebase_ai`** (Firebase AI Logic) for Gemini from
  Flutter. Current models: `gemini-3.8-flash` (latest), `gemini-3.5-flash`, `gemini-3.5-flash-lite`;
  the Gemini 2.5 family shuts down in October 2026, so never cite `gemini-2.5-*`. "Vertex AI" is now
  "Agent Platform". App Check is enforced automatically for AI Logic from 2 November 2026.
- Firebase Studio is being shut down (no new workspaces since June 2026, off in March 2027): never
  recommend it. Dynamic Links shut down in August 2025 (use App Links / Universal Links, `app_links`;
  `uni_links` is discontinued). Data Connect is now SQL Connect. Remote Config is usage-priced since
  September 2026 (free up to 100k fetches a day). Cloud Storage needs the Blaze plan.
- `google_sign_in` 7 replaced `signIn()` with `GoogleSignIn.instance.initialize()` then
  `authenticate()`; scopes and tokens come from `authorizationClient`.
- Riverpod 3: one `Notifier` (no AutoDispose variants), plain `Ref`, `StateProvider` and
  `StateNotifierProvider` live in `legacy.dart`. `flutter_bloc` 9, `bloc_test` 10, `go_router` 18,
  `dio` 5, `freezed` 4 (needs `sealed`/`abstract` on the class), `drift` 2.35. `isar` and `hive` are
  stalled since 2023/2022; `hive_ce` is the maintained fork. `shared_preferences` steers new code to
  `SharedPreferencesAsync` / `SharedPreferencesWithCache`.
- `Color.withOpacity` is deprecated since Flutter 3.27: use `withValues(alpha: ...)`.
- `integration_test` comes from the SDK (`sdk: flutter`), not from pub.
- On-device AI: TensorFlow Lite is **LiteRT** (docs at developers.google.com/edge/litert, v2.2 with the
  CompiledModel API; `tflite_flutter` wraps it). LiteRT-LM runs LLMs on device; MediaPipe LLM Inference
  is maintenance-only. Gemini Nano is reached through the ML Kit GenAI APIs (Beta, Android only).
  Apple's Foundation Models framework is iOS 26+. Gemma 4 (E2B/E4B on phones) is the current Gemma.
- MCP: the current spec revision is 2026-07-28 (stateless, no `initialize` handshake, no session
  header, sampling and roots deprecated). Official Dart package: `dart_mcp` (labs.dart.dev).
- OAuth 2.1 is still an IETF draft (PKCE mandatory); do not call it a standard.
- Google Play: personal accounts created after 13 Nov 2023 need a closed test with **12 testers for
  14 continuous days** (not 20). Play fee is a one-time 25 USD; Apple Developer Program 99 USD a year.
  TestFlight: 100 internal and 10,000 external testers, builds expire after 90 days.
- Anthropic models are the Claude 5 family (Fable 5.1, Opus 5, Sonnet 5, Haiku 4.5). Claude Code docs
  live at code.claude.com. Gemini CLI, OpenAI Codex CLI and the GitHub Copilot coding agent exist.
- Analytics/Crashlytics from Flutter are **`firebase_analytics` / `firebase_crashlytics`** with Dart
  APIs — never Android/Java `Bundle`/`getInstance(this)` code in a Flutter course.
- HTTP: `http` or `dio`; JSON codegen: `json_serializable` + `build_runner`.

HTTP semantics:
- **Safe** = does not modify state (GET, HEAD, OPTIONS). **Idempotent** = repeating has the same
  effect (GET, HEAD, PUT, DELETE). PUT/DELETE are idempotent but NOT safe. Do not conflate them.

Bluetooth Low Energy (checked against the tinygo.org/x/bluetooth support matrix, Sep 2026):
- Peripheral role on device: Nordic nRF52 (SoftDevice; nRF51 is peripheral-only), Pico W (CYW43439 over
  HCI) and **ESP32-C3 / ESP32-S3 via `espradio` (TinyGo 0.42)**. The original Xtensa ESP32 needs an HCI
  co-processor (NINA firmware). Bluetooth Core 6.3 is the current spec (May 2026).
- Host side: Linux (BlueZ) and Windows (WinRT) can scan **and advertise**; **macOS (CoreBluetooth) is
  central-only**, so a Mac cannot act as the lab peripheral.
- Phone side: `flutter_blue_plus`. Android 12+ needs `BLUETOOTH_SCAN` (with `neverForLocation`) and
  `BLUETOOTH_CONNECT` at runtime; iOS needs `NSBluetoothAlwaysUsageDescription`.
