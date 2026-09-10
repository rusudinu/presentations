# Code examples for Mobile and Embedded Computing

| Folder | Lecture | What is in it |
|---|---|---|
| `lecture02_concurrency/` | 2, Concurrency | `isolate_example.dart` and `isolate_two_way_comm.dart`: `Isolate.spawn`, SendPort and ReceivePort, pure Dart. `blocking_ui.dart` and `non_blocking_ui.dart`: the same heavy computation on the UI isolate and off it, with `main.dart` as the entry point |

The pure Dart files run directly:

```bash
dart run lecture02_concurrency/isolate_example.dart
```

The UI files are Flutter widgets. Copy them into the ADMD example project (`../../admd/examples/`)
and run `flutter run -t lib/<file>.dart`, or into your own app.

The Go servers used in Labs 5 and 6 and the TinyGo programs used in Labs 1 to 3 are printed in
full on the reference slides of those labs.
