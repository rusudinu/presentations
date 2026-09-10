# Application Development for Mobile Devices (ADMD)

Course brief. Every lecture and lab deck under `lectures/` and `labs/` in this folder is written from the
section below that names it, following `template/AUTHORING.md`. `make` here builds them all and publishes
the PDFs to `admd/` at the top of the repository. Paths below are relative to
`/Users/dinu/dev/upb/presentations/`. `SRC` and `LABSRC` refer to the previous course's pptx
generators (`mobile-and-embedded-computing/slides/`, removed from the tree after the port; see git
history). `EX` means `admd/examples/lib/` (the Flutter example project, grouped by lecture), and
`FACTS` means `template/FACTS.md` (verified technical facts, checked 2026).

## Course facts

| | |
|---|---|
| Program | Internet of Things Engineering, FILS, year III, semester I (autumn 2026) |
| Status | Optional, 4 ECTS, paired with Introduction to SAP |
| Format | 14 weeks. Lecture 2 h every week. Lab 2 h every second week, in even weeks (7 labs). There are 15 lecture decks for 14 slots: see the note under the lecture plan |
| Evaluation | Verification (V), no exam session |
| Grading (proposed, confirm before publishing) | Lab assignments 5 p (cumulative lab app, graded from the repo), practical lab test 4 p (Lab 7), participation 1 p. Pass with at least 5 of 10 |
| Instructor | Dinu-Ștefan Rusu, dinu_stefan.rusu@upb.ro, Microsoft Teams course channel, rusudinu.com. Ships Flutter apps professionally: 45+ apps, 400k installs |
| Stack | Flutter and Dart, Firebase, Go only where a tiny backend is needed |
| Repository | github.com/rusudinu/presentations for the shared material (slides in `admd/`, code examples in `admd/examples/`); each student keeps one course repository on GitHub for all labs |
| Metadata for `\course{}` | `Application Development for Mobile Devices`, `\date{Autumn 2026}` |

This course teaches how to build the app. Its sibling, Mobile and Embedded Computing (MEC, semester II), teaches what runs under the app: runtimes, concurrency, rendering cost, sync, RPC, and the embedded side. When a topic belongs to MEC, say so in one line and move on. Do not teach it here.

There is no semester project in this course. Students build one cumulative app across the labs (a todo app that grows into a networked, authenticated, state-managed app). The MEC project in semester II starts from that app.

## Lecture plan

Week numbers are lecture weeks. Labs run in even weeks.

| Week | Deck | Title | Source material |
|---|---|---|---|
| 1 | lecture01 | Orientation, Git, and how mobile apps are built | SRC/build-lecture1.js |
| 2 | lecture02 | Dart, null safety, and the Flutter toolchain | SRC/build-lecture2.js |
| 3 | lecture03 | Widgets and layout | SRC/build-lecture3.js, SRC/build-lecture4.js |
| 4 | lecture04 | Async Dart and agent-assisted coding | SRC/build-lecture3.js |
| 5 | lecture05 | Debugging and state management, part 1 | SRC/build-lecture4.js |
| 6 | lecture06 | State management, part 2: BLoC and Riverpod | EX/c4, new |
| 7 | lecture07 | Networking: HTTP, JSON, and code generation | SRC/build-lecture5.js |
| 8 | lecture08 | Firebase, packages, feature flags, REST and GraphQL | SRC/build-lecture5.js, SRC/build-lecture6.js |
| 9 | lecture09 | Observability and local storage | SRC/build-lecture6.js, new |
| 10 | lecture10 | Authentication, OAuth, and App Check | SRC/build-lecture7.js |
| 11 | lecture11 | Routing, permissions, and WebSockets | SRC/build-lecture8.js |
| 12 | lecture12 | AI in the app | SRC/build-lecture9.js |
| 13 | lecture13 | LLMs, RAG, and tool calling in the app | rag/, onia/, demos/, new |
| 14 | lecture14 | UI polish and testing | new |
| 15 | lecture15 | Release, distribution, and push notifications | new |

### Lecture 1: Orientation, Git, and how mobile apps are built

Port from SRC/build-lecture1.js the orientation, Git and GitHub, and the four build strategies. Leave out the device spectrum, resource budgets, the LLM-loading example, and the embedded slide: those open MEC Lecture 1.

- Orientation: who teaches, the 14 lectures (table from the plan above), the 7 labs, how grading works (table above), the one-repository rule, where to ask questions. One slide that says what ADMD covers and what MEC covers next semester.
- Git and GitHub: what Git is, hosting services, repositories and branches, the exact workflow with commands (clone, checkout -b, add, commit, push, pull request, review, merge, pull), what a good commit message is, what the CI pipeline does after merge. Students must create a GitHub account before Lab 1.
- Four ways to build a mobile app: native baseline (Swift/SwiftUI, Kotlin/Jetpack Compose), web and PWA, cross-platform in two flavors (React Native drives native widgets through JSI, Flutter draws every pixel with Impeller), Kotlin Multiplatform shares logic and keeps native UI. How to choose. Why this course uses Flutter, and its trade-offs.
- Close with what to install before Lab 1 (Flutter SDK, Android Studio or Xcode, an emulator) and the link to the shared repository.

### Lecture 2: Dart, null safety, and the Flutter toolchain

Port from SRC/build-lecture2.js. Leave out the compiler and interpreter section, the compilation spectrum, "is compiled code faster", and garbage collection internals: MEC Lecture 1 owns them. Keep one slide: Dart compiles two ways, JIT while developing (hot reload) and AOT for release, and why release builds cannot hot reload.

- Null safety: the billion-dollar mistake, the Dart operators (`?`, `!`, `??`, `?.`, `late`, `required`), what sound means, the escape hatches, Dart and Kotlin side by side.
- Dart you can write today: variables (var, final, const), functions and named parameters, classes, constructors, getters, collections and control flow, records and pattern matching in one slide each, async marked as "next lecture". Kotlin and Dart have the same shapes: one comparison slide.
- What Flutter is and what it draws, the widget catalog at a glance, the toolchain: install, `flutter doctor`, create, run, hot reload versus hot restart, the project structure of a new app.

### Lecture 3: Widgets and layout

Port the Flutter widgets section of SRC/build-lecture3.js and the "widgets are immutable blueprints" and "three trees" slides of SRC/build-lecture4.js at an introductory level. The cost analysis of the trees is MEC Lecture 13.

- Everything is a widget, composition over inheritance, StatelessWidget as configuration, StatefulWidget and setState, what actually rebuilds (introduce only; the reconciliation rules come in Lecture 5).
- Layout: constraints go down, sizes go up, parent sets position. Container, Padding, SizedBox, Row, Column, Expanded, Flexible, Stack, Align, the common overflow error and its fix. One slide per idea, with a small code shape each.
- Scrolling: ListView, ListView.builder, GridView, SingleChildScrollView, why builder is lazy.
- Material scaffolding: Scaffold, AppBar, FloatingActionButton, BottomNavigationBar, SnackBar, dialogs. Cupertino exists: one slide.
- A worked example that builds the Lab 3 todo screen step by step.

### Lecture 4: Async Dart and agent-assisted coding

Port the concurrency section of SRC/build-lecture3.js, but only the parts an app developer needs: Futures, async and await, error handling with try and catch, Streams, FutureBuilder and StreamBuilder, "async is not parallel", and `compute()` as the one-call escape for heavy work. Leave out event loop internals, Isolate.spawn and ports, and the goroutine comparison: MEC Lecture 2 owns them. Say so in one line.

Port the agent-assisted coding section (the 2026 tool landscape, what agents are good at and where they fail, prompting with context, reviewing generated code like any pull request) and add how students are expected to use these tools in the labs: allowed, must be understood, must be reviewed, cited in the pull request description.

### Lecture 5: Debugging and state management, part 1

Port SRC/build-lecture4.js in full: the debugging toolbox, print and debugPrint and assert, launching and attaching DevTools, what each tab is for, the widget inspector, frames and jank and the performance overlay, breakpoints and stepping; then what counts as state, immutable blueprints, the three trees, what setState does, reuse decided by runtimeType then key, Stateless versus Stateful precisely, inside a State object, lifting state up, InheritedWidget, value equality and Equatable, pick the smallest tool. The last slide points at Lecture 6 for BLoC.

### Lecture 6: State management, part 2: BLoC and Riverpod

New deck. Use EX/c4 (bloc, cubit, equatable, parent-child examples) for code. This lecture is the one the lab app depends on most.

- Why setState stops scaling: state shared across screens, side effects, testing.
- Cubit: state class, `emit`, reading it with BlocBuilder. Bloc: events, states, `on<Event>`, when to prefer Bloc over Cubit.
- The widgets: BlocProvider, BlocBuilder, BlocListener, BlocConsumer, `context.read` versus `context.watch`, `buildWhen`.
- State design: sealed or enum-based states, Equatable and why identical states do not rebuild, immutability, copyWith.
- Repositories: the bloc talks to a repository, the repository talks to the network or the database. Folder structure by feature.
- Testing a bloc with bloc_test: one full example.
- Riverpod as the alternative: Provider, NotifierProvider, `ref.watch`, no BuildContext. One comparison slide and a rule for choosing.
- Common mistakes: business logic in widgets, mutating state in place, emitting an equal state, one giant bloc.

### Lecture 7: Networking: HTTP, JSON, and code generation

Port the "HTTP from Flutter" and "Code generation" sections of SRC/build-lecture5.js. Leave out server versus client execution, serverless versus VPS, and Go backends: MEC Lecture 10 owns them. Mention in one line that the backend side is next semester.

- HTTP for app developers: methods, safe is not the same as idempotent, status codes that matter, headers, timeouts.
- dio: a request and its failure paths, interceptors, cancel tokens. The `http` package as the small alternative.
- Retry with exponential backoff and jitter, thundering herds, hedged requests in one slide.
- JSON in Dart: manual fromJson and toJson, then json_serializable with build_runner, the generated half, freezed in one slide.
- A repository class that wraps the API and feeds the bloc from Lecture 6. API keys never live in the app (points at Lecture 12).

### Lecture 8: Firebase, packages, feature flags, REST and GraphQL

Port the Firebase section of SRC/build-lecture5.js and parts 1 to 3 of SRC/build-lecture6.js.

- Wiring Firebase into a Flutter app (flutterfire configure), Firestore read and write, the security rule that guards it, Cloud Functions and where Firebase stops.
- Packages: choosing one you can live with, adding it, version constraints and the lockfile.
- Feature flags: deploy is not release, Firebase Remote Config, Remote Config in Dart.
- APIs: REST and what the verbs promise, over-fetching and under-fetching, GraphQL schema, query and mutation, GraphQL in Flutter, REST versus GraphQL side by side.

### Lecture 9: Observability and local storage

Port part 4 of SRC/build-lecture6.js (observability) and add a new local storage half.

- Observability: why it is harder on a phone, logging an analytics event, catching crashes with Crashlytics, crash-free users, p95 latency, which alerts are worth firing, one incident end to end.
- Local storage: what to store where. shared_preferences for small settings, flutter_secure_storage for tokens, sqflite and Drift for structured data (a schema, a query, a watch), files with path_provider, an in-memory cache with a time to live. When each fits, and what must never be stored in plain text.
- App lifecycle in one slide (WidgetsBindingObserver, saving on pause). Offline-first sync and conflicts are MEC Lectures 8 and 9: one line.

### Lecture 10: Authentication, OAuth, and App Check

Port SRC/build-lecture7.js in full: authentication is not authorization, three factors, why you do not write this yourself, Firebase Auth providers and packages, creating an account, signing in and the one error message you show, account enumeration, authStateChanges as the source of truth, reset and verification and sign-out, linking and re-authentication and second factors, OAuth handoff client-side, Google sign-in end to end, ID token versus refresh token, verify on the backend, never store the password, security rules that bind, App Check activation and enforcement.

### Lecture 11: Routing, permissions, and WebSockets

Port SRC/build-lecture8.js in full. Keep the "four ways to push" slide short and say MQTT is MEC Lecture 4.

- Realtime: why HTTP cannot push, the 101 handshake, web_socket_channel lifecycle, wss and who may connect, dead sockets and heartbeats, reconnecting with backoff, background behavior.
- Permissions: two steps, AndroidManifest.xml, Info.plist, Android 13 media permissions, every answer you have to handle, permission_handler, how to get a permission granted.
- Routing: Navigator 1.0 and why the docs steer you off it, go_router, three ways to carry data, ShellRoute, redirect guards. One slide that ties the three parts together.

### Lecture 12: AI in the app

Port SRC/build-lecture9.js in full. Keep the LiteRT and quantization slides short; MEC revisits on-device constraints.

- Three different things called AI in the app, on-device versus cloud variable by variable, the hybrid pattern.
- ML Kit: text from an image end to end, barcodes from a camera stream, on-device generative AI as a capability.
- Custom models: LiteRT and tflite_flutter, off the UI isolate.
- Cloud LLMs: the key-in-the-binary trap, two correct shapes, firebase_ai, streaming answers, tokens and cost, the failures you will see, plausible wrong answers.

### Lecture 13: LLMs, RAG, and tool calling in the app

New deck, written from the instructor's conference material: `rag/Vector-Search.pptx` (vector search and RAG), `onia/ML Kit and Vertex AI.pptx` (the mobile integration story), the notebooks in `demos/` (01 RAG, 02 MCP, 03 MCP plus RAG, 04 MCP plus RAG plus web search) and the notes in `demos/documents/`. Lecture 12 taught ML Kit, LiteRT, and the safe way to call a hosted model through firebase_ai or a backend proxy; this lecture explains what the model does and builds the two patterns every assistant feature needs.

- How a large language model works, for engineers: tokens and the tokenizer, embeddings, attention in one slide (each token looks at the others and weighs them), next-token prediction, the context window as the only memory, sampling and temperature, why the model produces plausible wrong answers, what training and fine-tuning are and why an app never does them. Hosted models (Gemini, Claude, GPT) versus open models run locally (LM Studio, Ollama, the Qwen family) versus on-device (Gemini Nano, callback to Lecture 12). Cost: tokens in and out, latency to first token.
- Prompting that survives production: system prompt, few-shot examples, structured output with a JSON schema, streaming, prompt injection as the security model (user text is data, not instructions).
- Retrieval-augmented generation: the problem (knowledge cutoff, private data, hallucination), embeddings as vectors, cosine similarity, chunking, a vector store (Vertex AI Vector Search, pgvector, and a small on-device option), the retrieve, augment, generate loop, citations, evaluation (is the answer grounded in the retrieved text), the usual failures (bad chunking, wrong k, stale index). One end-to-end example: the user's notes from Lab 5 become searchable.
- Tool calling: the function declaration (name, description, JSON schema of parameters), the loop (the model returns a call, the app runs it, the result goes back, the model answers), parallel calls, when to confirm with the user before a side effect, least privilege. The Model Context Protocol (MCP) as the standard way to expose tools and resources to a model; what an agent is (a loop with tools and a stop condition). Dart code with firebase_ai function calling for two app tools: add a todo, read the device location (permission from Lecture 11).
- Putting it in the app: architecture (the key stays on the backend or behind Firebase AI Logic with App Check, Lecture 12), where RAG runs (backend for shared documents, on-device for private notes), streaming into a BlocBuilder, latency and offline behavior, cost caps per user, logging without leaking personal data, evaluating with a fixed prompt set before each release, and a checklist. A worked example that ties it together: an assistant tab in the lab todo app that answers questions over the user's todos and can add one through a tool.

Note on the semester. ADMD has 14 lecture slots and 15 decks. Two ways to fit: teach Lectures 12 and 13 as one double session on AI, or fold Lecture 8 into its neighbors (packages into Lecture 2, feature flags into Lecture 9, Firebase wiring into Lecture 10, REST versus GraphQL into Lecture 7). The instructor decides; the decks stay as they are until then.

### Lecture 14: UI polish and testing

New deck. Two halves.

- Theming: ThemeData, Material 3, ColorScheme.fromSeed, dark mode, typography scale, one theme file. Responsive layout: MediaQuery, LayoutBuilder, breakpoints, SafeArea, orientation.
- Forms: Form, TextFormField, validators, FocusNode, keyboard types, submit flow, error display.
- Motion: implicit animations (AnimatedContainer, AnimatedSwitcher, AnimatedOpacity), Hero, when to stop animating.
- Accessibility: Semantics, contrast, tap targets, text scaling, screen readers (TalkBack, VoiceOver). Localization: flutter_localizations, intl, ARB files, plurals, right-to-left in one slide.
- Testing: the pyramid, unit tests, widget tests (testWidgets, find, pump, pumpAndSettle), bloc_test callback to Lecture 6, integration_test on a device, golden tests in one slide, mocking with mocktail, running tests in CI (points at Lecture 15).

### Lecture 15: Release, distribution, and push notifications

New deck. Ends with the course recap and the lab test rules.

- Build modes and flavors, app icons and splash screens, versioning (version name and build number).
- Signing: Android keystore and Play App Signing, iOS certificates and provisioning profiles, what to never commit.
- Stores: Play Console and App Store Connect flows, internal testing and TestFlight, review guidelines that reject apps, privacy labels and permission declarations.
- CI/CD: GitHub Actions running tests and builds, fastlane or Codemagic for delivery, over-the-air code push in one slide (Shorebird).
- Push notifications: FCM setup, tokens, foreground and background handling, iOS APNs, data versus notification messages, what not to put in a notification.
- Before you ship checklist. Course recap: the 14 lectures in one table. What the lab test looks like and how the grade is composed.

## Lab plan

Each lab is two hours, in even weeks. The student's course repository holds one Flutter app that grows across labs. Branch `lab-N` per lab, pushed before the next lab.

| Week | Deck | Title | Source material |
|---|---|---|---|
| 2 | lab01 | Orientation, set-up, and your first pull request | LABSRC/build-lab1.js |
| 4 | lab02 | Dart and null safety | LABSRC/build-lab2.js |
| 6 | lab03 | Widgets, UI, and DevTools | LABSRC/build-lab3.js, LABSRC/build-lab4.js |
| 8 | lab04 | Serialization and networking | LABSRC/build-lab5.js |
| 10 | lab05 | BLoC | EX/c4, new |
| 12 | lab06 | Authentication, routing, and a live screen | new |
| 14 | lab07 | Lab test | new |

### Lab 1: Orientation, set-up, and your first pull request

Port LABSRC/build-lab1.js, but replace the semester-project rules with the cumulative lab app rules: one repository per student, named `admd-labs`, one branch per lab, one pull request per lab merged to main after the lab is graded. Keep the grading slide (table in Course facts). Keep the environment set-up and both troubleshooting slides (flutter doctor problems; no devices, emulators that will not boot, macOS). Tasks: install and run `flutter doctor`, create the repository, create the starter app, run it on an emulator, open a pull request with a screenshot in the description.

### Lab 2: Dart and null safety

Port LABSRC/build-lab2.js: classes, null-safe types, collections, with the minimal UI scaffold to see the objects. Keep its two tasks and the troubleshooting slide. Fix the two merged requirements the old deck had (each requirement on its own step).

### Lab 3: Widgets, UI, and DevTools

Merge LABSRC/build-lab3.js and LABSRC/build-lab4.js. Task I builds the todo screen (Stateless or Stateful, layout widgets, reusable TodoTile). Task II adds the swipeable row with Dismissible. Task III attaches DevTools to the same app, plants the three bugs from the old Lab 4, finds them with the inspector and breakpoints, and explains in the pull request what actually rebuilds. Keep both troubleshooting slides merged into one.

### Lab 4: Serialization and networking

Port LABSRC/build-lab5.js: json_serializable, Equatable, HTTP with dio, retry with backoff and jitter. Add the scaffolding the old deck lacked: the pubspec entries and the build_runner command on the setup slide. The API called is a public JSON API (for example JSONPlaceholder); state the exact endpoint.

### Lab 5: BLoC

New. Rebuild the todo app's state on flutter_bloc. Task I: a TodoCubit with an Equatable state, BlocProvider at the top, BlocBuilder in the screen. Task II: promote it to a TodoBloc with events (load, add, toggle, remove) fed by a repository that calls the Lab 4 API. Task III: one bloc_test that proves add then toggle emits the right states. Include the folder structure and the packages to add. Use EX/c4 for code shapes.

### Lab 6: Authentication, routing, and a live screen

New. Task I: Firebase Auth with email and password plus Google sign-in, authStateChanges drives the app. Task II: go_router with a login route, a home route, and a redirect guard. Task III: one screen that shows live messages from a WebSocket echo server (state the exact public endpoint you are confident exists, or a tiny Go echo server whose full source is on a reference slide). Acceptance: sign out returns to login, a deep link to home while signed out redirects to login, the live screen updates without a refresh.

### Lab 7: Lab test

New. The practical test worth 4 points. The deck states the rules (individual, 90 minutes, own laptop, internet allowed, agents allowed but every line must be explained on request), the format (a one-page spec of a small app with four requirements: a screen built from the layout widgets, state in a Cubit, one network call with a model class, one navigation with go_router), the rubric (one point per requirement, partial credit rules), how the submission is made (branch `lab-7`, pushed at the end), and two practice specs of the same shape. Include a "how to prepare" slide that maps each requirement to the lab that taught it.
