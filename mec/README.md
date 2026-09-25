# Mobile and Embedded Computing

Slides for every lecture and lab. Open the PDF; the file name is the deck number.

Code examples that go with the lectures are in [examples/](examples/).

## Lectures

| | Deck | About |
|---|---|---|
| Lecture 01 | [Orientation, the device spectrum, and how code runs](MEC-Lecture-01.pdf) | Course plan, device spectrum, and code execution |
| Lecture 02 | [Concurrency](MEC-Lecture-02.pdf) | Event loop, isolates, and goroutines |
| Lecture 03 | [Embedded fundamentals and TinyGo](MEC-Lecture-03.pdf) | Microcontrollers, peripherals, and Go on bare metal |
| Lecture 04 | [Device-to-app networking](MEC-Lecture-04.pdf) | MQTT, CoAP, and TLS on small devices |
| Lecture 05 | [Bluetooth Low Energy](MEC-Lecture-05.pdf) | Advertising, GATT, permissions, and a peripheral written in Go |
| Lecture 06 | [Phone sensors and hardware APIs](MEC-Lecture-06.pdf) | Motion sensors, location, camera, NFC, and energy cost |
| Lecture 07 | [Background execution and power management](MEC-Lecture-07.pdf) | App lifecycle, background execution, and energy |
| Lecture 08 | [Offline-first, part 1](MEC-Lecture-08.pdf) | Offline-first design, local database, sync engine |
| Lecture 09 | [Offline-first, part 2: conflicts and CRDTs](MEC-Lecture-09.pdf) | Logical clocks, conflict resolution, CRDTs |
| Lecture 10 | [Backends for mobile](MEC-Lecture-10.pdf) | Serverless, VPS hosting, Go backends, API design |
| Lecture 11 | [gRPC, Protocol Buffers, HTTP/2 and HTTP/3](MEC-Lecture-11.pdf) | Protobuf contracts, streaming, wire format, transport |
| Lecture 12 | [Platform channels, FFI, and Kotlin Multiplatform](MEC-Lecture-12.pdf) | Platform channels, dart:ffi, Kotlin Multiplatform |
| Lecture 13 | [Rendering and Optimization](MEC-Lecture-13.pdf) | Frame budget, widget trees, optimization, profiling |
| Lecture 14 | [Compilation, energy, and exam preparation](MEC-Lecture-14.pdf) | Compilation, energy, exam preparation, project defense |

## Labs

| | Deck | About |
|---|---|---|
| Lab 01 | [Toolchain, board, broker, and project kickoff](MEC-Lab-01.pdf) | TinyGo, a blinking LED, a local MQTT broker, team setup (Week 2) |
| Lab 02 | [A sensor reading over MQTT](MEC-Lab-02.pdf) | I2C sensor in TinyGo, MQTT publishing, live value in Flutter (Week 4) |
| Lab 03 | [Bluetooth Low Energy](MEC-Lab-03.pdf) | BLE peripheral in Go, Flutter scan and connect, reconnection (Week 6) |
| Lab 04 | [Phone sensors and a background task](MEC-Lab-04.pdf) | Step detection, location, background tasks (Week 8) |
| Lab 05 | [Offline-first sync](MEC-Lab-05.pdf) | Outbox, drain loop, delta sync, conflict rule (Week 10) |
| Lab 06 | [gRPC: a Go server and a Dart client](MEC-Lab-06.pdf) | gRPC unary call, server stream, deadlines, cancellation (Week 12) |
| Lab 07 | [Lab test](MEC-Lab-07.pdf) | Rules, format, two practice specs (Week 14) |
