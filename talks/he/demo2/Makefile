# The second Flutter demo of the "GitHub and Flutter" talk: one app, one entry point in lib/main.dart.

FLUTTER ?= flutter
TARGET  ?= lib/main.dart
DEVICE  ?=
DEVICE_ARG := $(if $(DEVICE),-d $(DEVICE),)

.DEFAULT_GOAL := help

help: ## list the targets
	@echo "GitHub and Flutter, demo2. Targets:"
	@awk 'BEGIN{FS=":.*##"} /^[a-zA-Z0-9_-]+:.*##/{printf "  %-10s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo "Variables: TARGET=<file> for make run (default $(TARGET)), DEVICE=<id> to pick a device."

setup: ## flutter pub get
	@$(FLUTTER) pub get

run: ## flutter run the demo (TARGET=<file>, DEVICE=<id>)
	@$(FLUTTER) run $(DEVICE_ARG) -t $(TARGET)

devices: ## list the devices flutter can run on
	@$(FLUTTER) devices

analyze: ## static analysis over lib/
	@$(FLUTTER) analyze

clean: ## remove the Flutter build artefacts
	@$(FLUTTER) clean

.PHONY: help setup run devices analyze clean
