# One command per thing you do with the MEC examples: pub get, analysis, the Flutter UI demo
# and the pure Dart isolate examples. `make help` lists the targets, `make list` every runnable file.

FLUTTER ?= flutter
DART    ?= dart
TARGET  ?= lib/lecture02_concurrency/main.dart
DEVICE  ?=
DEVICE_ARG := $(if $(DEVICE),-d $(DEVICE),)

# a "main(" at the start of a line marks an entry point; importing flutter decides which
# runner it needs, so the two lists below are derived from the sources, never hand-written
MAIN_RE         := ^(void |Future<void> )?main\(
ENTRIES         := $(sort $(shell grep -rlE '$(MAIN_RE)' lib --include='*.dart' 2>/dev/null))
FLUTTER_ENTRIES := $(sort $(shell grep -l 'package:flutter' $(ENTRIES) 2>/dev/null))
DART_ENTRIES    := $(filter-out $(FLUTTER_ENTRIES),$(ENTRIES))
DART_SHORTCUTS  := $(notdir $(basename $(DART_ENTRIES)))
LECTURE_NUMS    := $(sort $(shell ls -d lib/lecture* 2>/dev/null | sed 's|.*/lecture||; s|_.*||'))

.DEFAULT_GOAL := help

help: ## list the targets
	@echo "MEC examples. Targets:"
	@awk 'BEGIN{FS=":.*##"} /^[a-zA-Z0-9_-]+:.*##/{printf "  %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo "  lectureNN  run that lecture's entry point: $(addprefix lecture,$(LECTURE_NUMS))"
	@echo "  <name>     dart run the pure Dart file named <name>.dart: $(DART_SHORTCUTS)"
	@echo "Variables: TARGET=<file> for make run (default $(TARGET)), DEVICE=<id> to pick a device."

setup: ## flutter pub get
	@$(FLUTTER) pub get

analyze: ## static analysis over lib/
	@$(FLUTTER) analyze

run: ## flutter run the blocking / non-blocking UI demo (TARGET=<file>, DEVICE=<id>)
	@$(FLUTTER) run $(DEVICE_ARG) -t $(TARGET)

devices: ## list the devices flutter can run on
	@$(FLUTTER) devices

list: ## print every runnable entry point and how to run it
	@echo "Flutter entry points (need a device, add DEVICE=<id> to pick one):"
	@for f in $(FLUTTER_ENTRIES); do printf "  %-52s make run TARGET=%s\n" "$$f" "$$f"; done
	@echo "Pure Dart files (run in the terminal):"
	@for f in $(DART_ENTRIES); do n=$$(basename $$f .dart); printf "  %-52s make %s\n" "$$f" "$$n"; done

clean: ## remove the Flutter build artefacts
	@$(FLUTTER) clean

# make lecture02 -> run the single entry point of lib/lecture02_*; if the folder has several,
# print them instead of guessing
lecture%:
	@dir=$$(find lib -maxdepth 1 -type d -name 'lecture$**' | head -1); \
	if [ -z "$$dir" ]; then echo "no lib/lecture$** folder. try: make list"; exit 1; fi; \
	fe=""; de=""; \
	for f in $$(grep -rlE '$(MAIN_RE)' "$$dir" --include='*.dart' | sort); do \
	  if grep -q 'package:flutter' "$$f"; then fe="$$fe $$f"; else de="$$de $$f"; fi; \
	done; \
	set -- $$fe; \
	if [ $$# -eq 1 ]; then echo "$(FLUTTER) run $(DEVICE_ARG) -t $$1"; exec $(FLUTTER) run $(DEVICE_ARG) -t $$1; fi; \
	if [ $$# -eq 0 ]; then set -- $$de; \
	  if [ $$# -eq 1 ]; then echo "$(DART) run $$1"; exec $(DART) run $$1; fi; \
	  if [ $$# -eq 0 ]; then echo "$$dir has no entry point. try: make list"; exit 1; fi; \
	fi; \
	echo "$$dir has more than one entry point, pick one:"; \
	for f in $$fe; do echo "  make run TARGET=$$f"; done; \
	for f in $$de; do echo "  make $$(basename $$f .dart)"; done; \
	exit 1

# one target per pure Dart file, named after the file: make isolate_example
$(foreach f,$(DART_ENTRIES),$(eval $(notdir $(basename $(f))): ; @$(DART) run $(f)))

.PHONY: help setup analyze run devices list clean $(DART_SHORTCUTS)
