# Flutter examples for Application Development for Mobile Devices

One Flutter project. The code under `lib/` is grouped by the lecture that uses it.

| Folder | Lecture | What is in it |
|---|---|---|
| `lib/lecture02_dart/` | 2, Dart and null safety | The same class with and without null safety (Dart and Java) |
| `lib/lecture03_widgets/state/` | 3, Widgets and layout | A StatelessWidget and a StatefulWidget side by side |
| `lib/lecture03_widgets/composition/` | 3, Widgets and layout | A list item built badly (one big widget) and well (small composable widgets) |
| `lib/lecture04_async/` | 4, Async Dart | `compute()` and a small async demo |
| `lib/lecture05_state/` | 5, State management part 1 | Parent and child widgets, an Equatable state, a widget to debug |
| `lib/lecture06_bloc/` | 6, BLoC and Riverpod | The counter as a Cubit and as a Bloc with events |
| `lib/lecture07_networking/` | 7, Networking | json_serializable code generation, http and dio clients, retries with backoff and jitter, hedged requests |

The isolate and concurrency demos used by Mobile and Embedded Computing, Lecture 2, are in
`../../mec/examples/`.

## Running

```bash
flutter pub get
dart run build_runner build                                # regenerates the *.g.dart files
flutter run -t lib/lecture06_bloc/cubit/main.dart          # run one example as the app entry point
```

Pure Dart files (for example the retry strategies) run with `dart run <file>`.
