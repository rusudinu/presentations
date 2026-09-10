# Mobile and Embedded Computing (MEC)

Course brief. Every lecture and lab deck under `lectures/` and `labs/` in this folder is written from the
section below that names it, following `template/AUTHORING.md`. `make` here builds them all and publishes
the PDFs to `mec/` at the top of the repository. Paths below are relative to
`/Users/dinu/dev/upb/presentations/`. `SRC` and `LABSRC` refer to the previous course's pptx
generators (`mobile-and-embedded-computing/slides/`, removed from the tree after the port; see git
history). `EX` means `admd/examples/lib/` (the Flutter example project; the isolate and concurrency
demos are in `mec/examples/`), and `FACTS` means `template/FACTS.md` (verified technical facts,
checked 2026: Impeller, React Native, Kotlin Multiplatform dates, TinyGo boards, BLE support, frame
budgets, Firebase Auth behavior, package names). Read FACTS before writing any slide about boards,
runtimes or dates.

## Course facts

| | |
|---|---|
| Program | Internet of Things Engineering, FILS, year III, semester II (spring 2027) |
| Status | Mandatory, 3 ECTS |
| Format | 14 weeks. Lecture 2 h every week. Lab 2 h every second week, even weeks (7 labs). Project 2 h every second week, odd weeks (7 sessions) |
| Evaluation | Exam (E) in the exam session |
| Grading | Final exam 3 p, laboratory and assignments 3 p, lab test 1.5 p, team project 1.5 p, concept presentation 1 p. Pass with at least 5 of 10 |
| Concept presentations | Teams of at most 3 pick a topic from the shared sheet, prepare about 20 minutes of slides plus an optional demo, every member presents, materials go to Moodle |
| Prerequisite | Application Development for Mobile Devices (ADMD, semester I) or equivalent Flutter and Dart knowledge. Students who took Introduction to SAP instead must work through the ADMD Lectures 2, 3, 5 and 6 decks before week 3 |
| Instructor | Dinu-Ștefan Rusu, dinu_stefan.rusu@upb.ro, Microsoft Teams course channel, rusudinu.com. Ships Flutter apps professionally: 45+ apps, 400k installs |
| Stack | Flutter and Dart on the phone, Go on the server, TinyGo on the microcontroller, MQTT between them |
| Repository | github.com/rusudinu/presentations (slides in `mec/`, code examples in `mec/examples/` and `admd/examples/`) |
| Metadata for `\course{}` | `Mobile and Embedded Computing`, `\date{Spring 2027}` |

This course teaches what runs under the app and around it: how code executes, how the phone spends energy, how data survives without a network, how the app talks to servers over RPC and to devices over MQTT and BLE, and how a microcontroller program is written. Its sibling ADMD (semester I) taught how to build the app itself. When a topic belongs to ADMD, name the ADMD lecture in one line and move on.

Neighboring courses in the same program: Computer Networks (semester I, mandatory), Internet Protocols and Internet of Things (optionals), Artificial Intelligence 1 (semester II, in parallel), Digital Signal Processing (semester II), Computer Architecture (semester I). Do not reteach general networking, AI, or CPU architecture. Build on them.

## The project

Teams of at most 3. Worth 1.5 points. Students extend the app they built in the ADMD labs, so the project hours go into the device and sync work, not into UI basics. Approved in Lab 1, defended in the last project session.

Entry conditions (already true for an ADMD app): state in BLoC, real authentication, one WebSocket screen.

Graded requirements, all five needed for approval:

1. A device component: a TinyGo program on a real board (see FACTS for the boards) or in the Wokwi simulator, that reads at least one sensor.
2. Device to phone over MQTT or BLE: the app shows the reading live.
3. Offline-first: the app works with no network and syncs later, with a stated conflict rule.
4. One of gRPC (a Go server with a generated Dart client) or FFI / a platform channel (native code called from Dart).
5. A measured claim: one number the team measured (energy, latency, payload size, frame time) with the method.

Milestones, one per project session (odd weeks): 1 team and idea approved; 3 device streams a reading to a serial console; 5 the app receives it over MQTT or BLE; 7 offline mode with sync; 9 gRPC or FFI integrated; 11 measurement done, polish; 13 demo and defense.

## Lecture plan

Week numbers are lecture weeks. Labs run in even weeks, project sessions in odd weeks.

| Week | Deck | Title | Source material |
|---|---|---|---|
| 1 | lecture01 | Orientation, the device spectrum, and how code runs | SRC/build-lecture1.js, SRC/build-lecture2.js |
| 2 | lecture02 | Concurrency: event loop, isolates, and goroutines | SRC/build-lecture3.js, SRC/build-lecture5.js |
| 3 | lecture03 | Embedded fundamentals and TinyGo | SRC/build-lecture11.js, FACTS, new |
| 4 | lecture04 | Device-to-app networking: MQTT, CoAP, and TLS on small devices | SRC/build-lecture11.js, SRC/build-lecture8.js, new |
| 5 | lecture05 | Bluetooth Low Energy | new |
| 6 | lecture06 | Phone sensors and hardware APIs | new |
| 7 | lecture07 | Background execution and power management | SRC/build-lecture11.js, SRC/build-lecture10.js, new |
| 8 | lecture08 | Offline-first, part 1: local data and the sync engine | SRC/build-lecture10.js |
| 9 | lecture09 | Offline-first, part 2: conflicts and CRDTs | SRC/build-lecture10.js |
| 10 | lecture10 | Backends for mobile: serverless, VPS, and Go | SRC/build-lecture5.js |
| 11 | lecture11 | gRPC, Protocol Buffers, HTTP/2 and HTTP/3 | SRC/build-lecture12.js |
| 12 | lecture12 | Platform channels, FFI, and Kotlin Multiplatform | SRC/build-lecture12.js |
| 13 | lecture13 | Rendering and optimization | SRC/build-lecture11.js, SRC/build-lecture4.js |
| 14 | lecture14 | Compilation, energy, and exam preparation | SRC/build-lecture11.js |

### Lecture 1: Orientation, the device spectrum, and how code runs

Port from SRC/build-lecture1.js: the device landscape (one spectrum from the cloud to a microcontroller, what changes when you leave the desktop, what every app negotiates for, resource allocation in action with the LLM-loading example, where embedded fits). Port from SRC/build-lecture2.js: compiler and interpreter, the compilation spectrum, is compiled code faster, why Dart compiles two ways, garbage collection in one slide. Do not port Git, the four build strategies, or Dart syntax: ADMD Lecture 1 and 2 own them.

- Orientation: the 14 lectures (table above), labs and project sessions, grading, concept presentations, the project requirements and milestones, the prerequisite and what to do if you did not take ADMD.
- Device spectrum, budgets, the ARM note, the phone as the hub for nearby devices.
- How code runs: source to instructions, interpreters, JIT, AOT, Dart's two modes, GC and why it matters on a phone.
- Close with what the project needs by Lab 1 (team sheet, board or simulator choice).

### Lecture 2: Concurrency: event loop, isolates, and goroutines

Port the concurrency section of SRC/build-lecture3.js in full: one frame budget equals one divided by refresh rate, the event loop and microtask queue, Futures and async as a refresher only, Streams, async is not parallel, `compute()`, Isolate.spawn with SendPort and ReceivePort, async versus isolates precisely, Dart isolates versus Go goroutines. Add from SRC/build-lecture5.js the Go section that shows a handler, and extend it: goroutines, channels, `select`, a producer and consumer written in both Dart and Go on facing slides, and what each model buys on a phone versus a server. ADMD Lecture 4 taught async and await; refer to it in one line.

### Lecture 3: Embedded fundamentals and TinyGo

Port the embedded section of SRC/build-lecture11.js (the constraint jump from phone to microcontroller, TinyGo, which board to buy, the machine package, wake send sleep). Extend it into a full lecture. Check board facts against FACTS.

- Anatomy of a microcontroller: core, flash, SRAM, peripherals, clocks, the memory map, what 400 KB of RAM means for your code.
- Bare metal versus an RTOS: the super loop, interrupts, timers, tasks in FreeRTOS, when each fits.
- Peripherals: GPIO, ADC, PWM, I2C, SPI, UART, what each bus is for, one wiring sketch each in words.
- TinyGo: what it is and what it is not, `tinygo build` and `tinygo flash`, targets, the machine package, reading a sensor over I2C, printing to serial, the debugging workflow, the parts of Go you lose (reflection, some goroutine scheduling, heap limits).
- Power: sleep modes, the watchdog, wake sources, the wake send sleep loop.
- Close with the exact set-up for Lab 1 and what the project device must do.

### Lecture 4: Device-to-app networking: MQTT, CoAP, and TLS on small devices

Port the MQTT slides of SRC/build-lecture11.js (publishing a reading, the Flutter app subscribes, mqtt_client) and the "four ways to push" slide of SRC/build-lecture8.js. Stay device-specific: Computer Networks and Internet Protocols cover the general stack.

- Why HTTP polling is wrong for a sensor, the four ways to push, where MQTT fits.
- MQTT in depth: broker, topics and wildcards, QoS 0, 1 and 2 and what each costs, retained messages, last will, keep-alive and sessions, packet size, MQTT 5 additions in one slide.
- MQTT from TinyGo and from Flutter (mqtt_client): connect, subscribe, publish, reconnect. A local Mosquitto broker for the lab, a hosted broker for the project.
- CoAP in one or two slides: when a UDP request-response protocol beats MQTT.
- TLS on a constrained device: certificates versus pre-shared keys, memory cost, device identity and provisioning, rotating credentials.
- Over-the-air firmware updates: partitions, rollback, signing.
- Close with the topic design for the project.

### Lecture 5: Bluetooth Low Energy

New deck. TinyGo BLE support (checked against the upstream support matrix, September 2026): the tinygo.org/x/bluetooth package runs the peripheral role on Nordic nRF chips and on the ESP32-C3 and ESP32-S3 through espradio over HCI; the original Xtensa ESP32 needs an HCI co-processor. On the host side Linux and Windows can advertise; macOS is central-only and cannot act as a peripheral. Say this plainly and give the lab set-ups: an ESP32-C3, ESP32-S3 or nRF52840 board, or a Linux or Windows laptop running the Go peripheral.

- Classic Bluetooth versus BLE, why BLE for sensors, the power profile.
- Advertising and scanning, GAP roles (central, peripheral), connection parameters, MTU.
- GATT: services, characteristics, descriptors, UUIDs, read, write, notify, indicate. Draw the hierarchy for a heart-rate style sensor.
- Pairing and bonding, security levels, what is encrypted.
- Permissions: Android 12 and later (BLUETOOTH_SCAN, BLUETOOTH_CONNECT, location when scanning), iOS (NSBluetoothAlwaysUsageDescription), background limits on both.
- Flutter with flutter_blue_plus: scan, connect, discover services, read, subscribe to notifications, disconnect, reconnect strategy. Code shapes for each.
- The peripheral side in Go: advertise one service with one notifying characteristic.
- Design: keep the characteristic small, batch on the device, do not stream what you can summarize.

### Lecture 6: Phone sensors and hardware APIs

New deck.

- The sensors in a phone: accelerometer, gyroscope, magnetometer, barometer, ambient light, proximity, what each measures and its units, sampling rates, what fusion is (gravity, linear acceleration, rotation vector) in one slide.
- sensors_plus in Flutter: streams, sampling period, handling on the UI isolate, when to move work off it (ADMD Lecture 4 and MEC Lecture 2).
- A worked example: a step counter from accelerometer magnitude with a threshold and a debounce.
- Location: geolocator, accuracy modes and their power cost, permissions (foreground, background, precise versus approximate on Android 12 and later, iOS "while using" versus "always"), when background location is allowed at all.
- Camera: the camera package, preview, capture, image streams, hand-off to ML (ADMD Lecture 12 taught ML Kit).
- NFC: tags, NDEF, nfc_manager, what iOS allows.
- What each sensor costs in energy, batching, and when a platform channel is the right tool (Lecture 12).

### Lecture 7: Background execution and power management

New deck. Port the energy slides of SRC/build-lecture11.js (where the milliamp-hours go, the radio tail) and the background sync slide of SRC/build-lecture10.js.

- Process lifecycle on Android and iOS, app states, what the OS kills and when.
- Android: Doze, App Standby, standby buckets, foreground services and their types, WorkManager, exact alarms, battery optimization exemptions and why not to ask for them.
- iOS: background modes (fetch, processing, location, audio, BLE), BGTaskScheduler, the 30-second rule, silent push.
- From Flutter: the workmanager plugin, flutter_background_service, push-triggered wake with FCM data messages, geofencing, what is not possible (a persistent socket in the background).
- Energy: where the milliamp-hours go, the radio tail, batching network calls, wakelocks, measuring with Battery Historian and the Xcode energy gauge.
- A checklist for a sync task that survives the app going to sleep (the shape of Lab 4).

### Lecture 8: Offline-first, part 1: local data and the sync engine

Port sections 1 to 3 of SRC/build-lecture10.js (why offline-first, the local database, the sync engine) and expand each with code: a Drift table with sync metadata, a query the UI watches, an outbox insert inside the same transaction, the drain loop, delta sync with a cursor, when to wake the radio, background sync. ADMD Lecture 9 introduced local storage; refer to it in one line.

### Lecture 9: Offline-first, part 2: conflicts and CRDTs

Port the conflicts section of SRC/build-lecture10.js and expand it: where conflicts come from, device clocks cannot order events, logical clocks (Lamport, then vector clocks with a worked example), the four strategies ranked (last writer wins, first writer wins, merge by field, ask the user), a resolver you can ship, CRDTs and convergence, a grow-only counter, a PN-counter, an observed-remove set, a last-writer-wins register, tombstones, what CRDTs cost in space. Dart code for the counter and the set.

### Lecture 10: Backends for mobile: serverless, VPS, and Go

Port the server and client, serverless versus VPS, and Go backends sections of SRC/build-lecture5.js, plus the thundering herd and hedged request slides. Expand: API design for a mobile client (pagination, versioning, ETags and conditional requests, compression, rate limits), deploying a Go binary (Docker image, Cloud Run, a systemd unit on a VPS), environment and secrets, health checks, structured logs, what the project backend needs.

### Lecture 11: gRPC, Protocol Buffers, HTTP/2 and HTTP/3

Port boundary one of SRC/build-lecture12.js in full: RPC versus REST, contract first with the .proto file, generating stubs with protoc, a Go server, the generated Dart client, why protobuf is smaller and by how much, schema evolution, four call shapes, HTTP/2 multiplexing, HTTP/3 and QUIC on mobile, deadlines and cancellation and the radio tail, gRPC-Web and Connect. Add a streaming example (server streaming of sensor readings) since the project may use it.

### Lecture 12: Platform channels, FFI, and Kotlin Multiplatform

Port boundaries two to four of SRC/build-lecture12.js in full: two runtimes sharing one process, MethodChannel both sides, what a channel call costs, measuring channel and FFI call cost, dart:ffi calling C, big buffers and moving the pointer, channels for control and FFI for compute, Kotlin Multiplatform sharing logic, expect and actual, source sets, how the iOS app consumes it, Flutter and KMP compared. Add an EventChannel example for a sensor stream and the ffigen workflow.

### Lecture 13: Rendering and optimization

Port the performance, rendering and optimization sections of SRC/build-lecture11.js (two things called performance, the frame budget, Flutter owns every pixel and Impeller draws them, three trees and their costs, reconciliation, keys, what each operation costs, const constructors, lists that build only what is on screen, offscreen buffers, find the bottleneck before you fix anything) and the deeper reconciliation slides of SRC/build-lecture4.js. Add: the DevTools performance view walkthrough, shader warm-up in one slide, images and memory, and a before-and-after profiling example.

### Lecture 14: Compilation, energy, and exam preparation

Port the compilation section of SRC/build-lecture11.js (three ways to turn code into instructions, Dart uses both as build modes, two platforms two answers, where cross-platform runtimes stand in 2026) and the remaining energy material not used in Lecture 7. Then exam preparation: the exam format (multiple choice, 15 questions, 2 points each, one variant per row), what to revise per lecture in one table, the key numbers and rules to remember, five example questions with answers, the project defense schedule and rubric, and the concept presentation logistics.

## Lab plan

Each lab is two hours, in even weeks. Students work in their project team's repository, on a branch `lab-N`, pushed before the next lab.

| Week | Deck | Title |
|---|---|---|
| 2 | lab01 | Toolchain, board, broker, and project kickoff |
| 4 | lab02 | A sensor reading from the board to the phone over MQTT |
| 6 | lab03 | Bluetooth Low Energy: a peripheral and a Flutter central |
| 8 | lab04 | Phone sensors and a background task |
| 10 | lab05 | Offline-first: outbox, sync, and one conflict rule |
| 12 | lab06 | gRPC: a Go server and a Dart client |
| 14 | lab07 | Lab test |

### Lab 1: Toolchain, board, broker, and project kickoff

Install TinyGo and confirm the target for the chosen board (check FACTS for the board list). Students without a board use the Wokwi simulator; state exactly which Wokwi board matches. Flash the blink program, then read the serial console. Install Mosquitto locally and verify publish and subscribe with the command-line clients. Fill the team sheet and get the idea approved (the five requirements). Troubleshooting: flash permission denied, board not detected, wrong target, broker refuses connection.

### Lab 2: A sensor reading from the board to the phone over MQTT

Task I: read a sensor over I2C in TinyGo (a temperature or accelerometer sensor; pick one that FACTS or the TinyGo drivers repository supports) and print it. Task II: publish it as JSON to the broker every two seconds with QoS 1. Task III: the Flutter app subscribes with mqtt_client and shows the value live in a BlocBuilder, with reconnect on broker loss. Acceptance: pulling the board's cable stops updates and reconnecting resumes them.

### Lab 3: Bluetooth Low Energy: a peripheral and a Flutter central

The peripheral is either a board running TinyGo (ESP32-C3, ESP32-S3 or nRF52840, see Lecture 5) or a Linux or Windows laptop running a small Go program with tinygo.org/x/bluetooth (full source on a reference slide; macOS cannot advertise). It advertises one service with one notifying characteristic that carries a counter or a sensor value. Task I: the Flutter app scans and lists devices with flutter_blue_plus, with permissions handled on Android 12 and later and iOS. Task II: connect, discover, subscribe, show the value live. Task III: survive a disconnect and reconnect. Acceptance criteria are precise and checkable.

### Lab 4: Phone sensors and a background task

Task I: a step counter from sensors_plus with a threshold and debounce, shown live. Task II: location with geolocator under the right permission flow, shown with accuracy. Task III: a workmanager task that runs every 15 minutes, writes a timestamp and the last reading to local storage, and is visible in the app after it was closed. Include the AndroidManifest and Info.plist entries. Acceptance: the task ran while the app was closed, proven by the timestamps.

### Lab 5: Offline-first: outbox, sync, and one conflict rule

A Drift database for the app's main entity with sync metadata, writes go to the table and an outbox in one transaction, a drain loop that posts to a tiny Go server (full source on a reference slide, an in-memory list with a version per row), delta sync on start, and last writer wins by server version with a visible "updated elsewhere" marker. Acceptance: airplane mode on, edit, airplane mode off, the server has the edit; two devices editing the same row end with the same value.

### Lab 6: gRPC: a Go server and a Dart client

A .proto with one unary call and one server-streaming call for readings. Generate Go and Dart stubs, run the Go server, call both from Flutter, show the stream live, apply a deadline and a cancel. Include the exact protoc commands and the pubspec entries. Acceptance: the stream updates live, cancelling stops it, a 2-second deadline fails the unary call against a server that sleeps 3 seconds.

### Lab 7: Lab test

The practical test worth 1.5 points. Rules (individual, 90 minutes, own laptop, board or simulator allowed, internet allowed, agents allowed but every line must be explained on request), the format (a one-page spec with three requirements drawn from Labs 2 to 6: publish or subscribe over MQTT, one offline-capable write with an outbox, one gRPC or BLE read), the rubric, submission (branch `lab-7`), two practice specs, and a preparation slide that maps each requirement to the lab that taught it.
