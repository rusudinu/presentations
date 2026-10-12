# Flutter examples for Application Development for Mobile Devices

One Flutter project. The code under `lib/` is grouped by the lecture that uses it.

| Folder | Lecture | What is in it |
|---|---|---|
| `lib/lecture02_dart/` | 2, Dart and null safety | The same class with and without null safety (Dart and Java) |
| `lib/lecture02_dart/null_safety/` | 2, Dart and null safety | The operators, flow promotion, `late` and `required`, and the Dart and Kotlin comparison |
| `lib/lecture02_dart/basics/` | 2, Dart and null safety | Variables, functions, classes, equality, collections, records, pattern matching, the async preview, and the Dart and Kotlin model class |
| `lib/lecture02_dart/flutter_overview/` | 2, Dart and null safety | The widget catalog on one screen, and hot reload versus hot restart |
| `lib/lecture03_widgets/main.dart` | 3, Widgets and layout | The entry point: a list that opens every example below, in slide order |
| `lib/lecture03_widgets/widgets/` | 3, Widgets and layout | Structure, style and behavior as widgets, immutability and `const`, wrapping, rebuild scope, keys |
| `lib/lecture03_widgets/state/` | 3, Widgets and layout | A StatelessWidget and a StatefulWidget side by side |
| `lib/lecture03_widgets/composition/` | 3, Widgets and layout | A list item built badly (one big widget) and well (small composable widgets) |
| `lib/lecture03_widgets/layout/` | 3, Widgets and layout | Constraints, Padding, SizedBox and Container, Row and Column, Expanded and Flexible, Stack, overflow errors and their fixes |
| `lib/lecture03_widgets/scrolling/` | 3, Widgets and layout | ListView eager, builder and separated, GridView, SingleChildScrollView, CustomScrollView |
| `lib/lecture03_widgets/material/` | 3, Widgets and layout | Scaffold with a drawer and a NavigationBar, buttons, SnackBars and dialogs, Cupertino and adaptive widgets |
| `lib/lecture03_widgets/todo/` | 3, Widgets and layout | The worked example: the Lab 3 todo screen, steps 1 to 5 |
| `lib/lecture04_async/` | 4, Async Dart | `compute()` and a small async demo |
| `lib/lecture04_async/futures/` | 4, Async Dart | Console: `then`, `async` and `await`, sequential and concurrent awaits, errors around `await` |
| `lib/lecture04_async/streams/` | 4, Async Dart | Console: an `async*` ticker read with `await for` and with `listen` |
| `lib/lecture04_async/main.dart`, `ui/` | 4, Async Dart | The entry point and its screens: errors in a State, FutureBuilder, a Future created in `build`, StreamBuilder, a Future with a Stream, `compute()` |
| `lib/lecture05_state/` | 5, State management part 1 | Parent and child widgets, an Equatable state, a widget to debug |
| `lib/lecture05_state/main.dart` | 5, State management part 1 | The entry point: a list that opens every screen below. Attach DevTools to it |
| `lib/lecture05_state/debugging/` | 5, State management part 1 | `debugPrint`, `assert` and the debug switches, a jank screen with the performance overlay, a console program for breakpoints |
| `lib/lecture05_state/state/` | 5, State management part 1 | setState scope with build counts, element reuse by type and key, the State lifecycle and `dispose` |
| `lib/lecture05_state/sharing/` | 5, State management part 1 | Lifting state up, prop drilling, the same screen with an InheritedWidget, value equality and rebuilds |
| `lib/lecture05_state/equatable/` | 5, State management part 1 | Console: `==` with and without Equatable, and a field missing from `props` |
| `lib/lecture06_bloc/` | 6, BLoC and Riverpod | The counter as a Cubit and as a Bloc with events |
| `lib/lecture06_bloc/todos/` | 6, BLoC and Riverpod | The todos feature in the folder structure from the slides: `data/` (API, repository), `bloc/` (events, state, handlers), `cubit/`, `auth/` (sealed states), `view/` (BlocBuilder, BlocListener, BlocConsumer, read, watch, select) |
| `lib/lecture06_bloc/riverpod/` | 6, BLoC and Riverpod | The same todo list with Riverpod providers and a Notifier |
| `test/lecture06/` | 6, BLoC and Riverpod | One test per layer: the repository with a fake API, the bloc with `bloc_test`, the view with a mock bloc |
| `lib/lecture07_networking/` | 7, Networking | json_serializable code generation, http and dio clients, retries with backoff and jitter, hedged requests |

The isolate and concurrency demos used by Mobile and Embedded Computing, Lecture 2, are in
`../../mec/examples/`.

## Running

```bash
make help     # every target
make setup    # flutter pub get
make gen      # regenerates the *.g.dart files
make list     # every runnable file, with the command that runs it
make analyze  # static analysis
```

`make run TARGET=lib/lecture06_bloc/cubit/main.dart` runs one example as the app entry point, with
`DEVICE=<id>` to pick a device (`make devices` lists them). `make lectureNN` runs a lecture's single
entry point, and every pure Dart file has a target named after it, for example `make jitter_strategies`.

The same commands without make:

```bash
flutter pub get
dart run build_runner build                                # regenerates the *.g.dart files
flutter run -t lib/lecture06_bloc/cubit/main.dart          # run one example as the app entry point
```

Pure Dart files (for example the retry strategies) run with `dart run <file>`.
