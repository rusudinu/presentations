# The first Flutter demo of the "GitHub and Flutter" talk. Every folder under lib/ has its own
# main.dart, so `make list` prints them and `make run TARGET=<file>` picks one.

FLUTTER ?= flutter
TARGET  ?= lib/main.dart
DEVICE  ?=
DEVICE_ARG := $(if $(DEVICE),-d $(DEVICE),)

ENTRIES := $(sort $(shell find lib -name 'main.dart' 2>/dev/null))

.DEFAULT_GOAL := help

help: ## list the targets
	@echo "GitHub and Flutter, demo. Targets:"
	@awk 'BEGIN{FS=":.*##"} /^[a-zA-Z0-9_-]+:.*##/{printf "  %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo "Variables: TARGET=<file> for make run (default $(TARGET)), DEVICE=<id> to pick a device."

setup: ## flutter pub get
	@$(FLUTTER) pub get

run: ## flutter run the demo (TARGET=<file>, DEVICE=<id>)
	@$(FLUTTER) run $(DEVICE_ARG) -t $(TARGET)

list: ## print every main.dart under lib/ and how to run it
	@for f in $(ENTRIES); do printf "  %-36s make run TARGET=%s\n" "$$f" "$$f"; done

devices: ## list the devices flutter can run on
	@$(FLUTTER) devices

analyze: ## static analysis over lib/
	@$(FLUTTER) analyze

clean: ## remove the Flutter build artefacts
	@$(FLUTTER) clean

.PHONY: help setup run list devices analyze clean
