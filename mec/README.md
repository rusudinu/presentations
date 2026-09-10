# Mobile and Embedded Computing

Slides for every lecture and lab. Open the PDF; the file name is the deck number.

## Lectures

| | Deck | About |
|---|---|---|
| Lecture 01 | [Orientation, the device spectrum, and how code runs](MEC-Lecture-01.pdf) | How the course works, and what runs under your app |
| Lecture 02 | [Concurrency](MEC-Lecture-02.pdf) | Event loop, isolates, and goroutines |
| Lecture 03 | [Embedded fundamentals and TinyGo](MEC-Lecture-03.pdf) | Microcontrollers, peripherals, and Go on bare metal |
| Lecture 04 | [Device-to-app networking](MEC-Lecture-04.pdf) | MQTT, CoAP, and TLS on small devices |
| Lecture 05 | [Bluetooth Low Energy](MEC-Lecture-05.pdf) | Advertising, GATT, permissions, and a peripheral written in Go |
| Lecture 06 | [Phone sensors and hardware APIs](MEC-Lecture-06.pdf) | Motion, location, camera and NFC, and what each one costs |
| Lecture 07 | [Background execution and power management](MEC-Lecture-07.pdf) | What the system allows in the background, and what it costs |
| Lecture 08 | [Offline-first, part 1](MEC-Lecture-08.pdf) | Local data and the sync engine |
| Lecture 09 | [Offline-first, part 2: conflicts and CRDTs](MEC-Lecture-09.pdf) | Ordering events without a clock, resolving edits, and data that cannot conflict |
| Lecture 10 | [Backends for mobile](MEC-Lecture-10.pdf) | Serverless, a VPS, and Go |
| Lecture 11 | [gRPC, Protocol Buffers, HTTP/2 and HTTP/3](MEC-Lecture-11.pdf) | Contract-first calls, streaming, and the transport underneath them |
| Lecture 12 | [Platform channels, FFI, and Kotlin Multiplatform](MEC-Lecture-12.pdf) | Crossing into native code, and across platforms at compile time |
| Lecture 13 | [Rendering and Optimization](MEC-Lecture-13.pdf) | The frame budget, the three trees, and finding the bottleneck before you fix it |
| Lecture 14 | [Compilation, energy, and exam preparation](MEC-Lecture-14.pdf) | Where machine code comes from, what it costs in battery, and how the semester is graded |

## Labs

| | Deck | About |
|---|---|---|
| Lab 01 | [Toolchain, board, broker, and project kickoff](MEC-Lab-01.pdf) | TinyGo, a blinking board, a local broker, and your team (Week 2) |
| Lab 02 | [A sensor reading over MQTT](MEC-Lab-02.pdf) | I2C in TinyGo, MQTT in the middle, a live value in Flutter (Week 4) |
| Lab 03 | [Bluetooth Low Energy](MEC-Lab-03.pdf) | A peripheral in Go and a Flutter central (Week 6) |
| Lab 04 | [Phone sensors and a background task](MEC-Lab-04.pdf) | Step detection, location, and a task that outlives the app (Week 8) |
| Lab 05 | [Offline-first sync](MEC-Lab-05.pdf) | An outbox, a drain loop, and one conflict rule (Week 10) |
| Lab 06 | [gRPC: a Go server and a Dart client](MEC-Lab-06.pdf) | One unary call, one stream, a deadline, and a cancel (Week 12) |
| Lab 07 | [Lab test](MEC-Lab-07.pdf) | Rules, format, and two practice specs (Week 14) |
