# Code examples for Mobile and Embedded Computing

| Folder | Lecture | What is in it |
|---|---|---|
| `lib/lecture02_concurrency/` | 2, Concurrency | `isolate_example.dart` and `isolate_two_way_comm.dart`: `Isolate.spawn`, SendPort and ReceivePort, pure Dart. `blocking_ui.dart` and `non_blocking_ui.dart`: the same heavy computation on the UI isolate and off it, with `main.dart` as the entry point |

`make help` lists every target: `make setup`, `make list`, `make analyze`, `make run` for the UI
demo, and one target per pure Dart file, for example `make isolate_example`.

The pure Dart files also run directly:

```bash
dart run lib/lecture02_concurrency/isolate_example.dart
```

The UI files are Flutter widgets. This folder is a Flutter package, so after `flutter pub get` they
run on an emulator with:

```bash
flutter run -t lib/lecture02_concurrency/main.dart   # or: make run
```

The Go servers used in Labs 5 and 6 and the TinyGo programs used in Labs 1 to 3 are printed in
full on the reference slides of those labs.
