.PHONY: env install lint format check

# shell
SHELL := /bin/bash

# constants
RANDOM_FILE := .random_id
RANDOM_ID := $(shell if [ -f $(RANDOM_FILE) ]; then cat $(RANDOM_FILE); else str=$$(tr -dc 'a-z' </dev/urandom | head -c6); echo $$str > $(RANDOM_FILE); echo $$str; fi)
PROJECT := $(shell basename $(CURDIR) | tr '[:upper:]' '[:lower:]')-$(RANDOM_ID)

# runtimes
PY_MAKE := -f ".tools/runtimes/python.Makefile"
NODE_MAKE := -f ".tools/runtimes/node.Makefile"

# Development targets
env:
	@ echo " >> Project: $(PROJECT) << "
	@ echo " >> Setting up Environment... << "
ifeq ($(PYTHON), true)
	@ $(MAKE) $(PY_MAKE) env --no-print-directory
endif
ifeq ($(NODE), true)
	@ $(MAKE) $(NODE_MAKE) env --no-print-directory
endif

install: env
ifeq ($(PYTHON), true)
	@ $(MAKE) $(PY_MAKE) install --no-print-directory
endif
ifeq ($(NODE), true)
	@ $(MAKE) $(NODE_MAKE) install --no-print-directory
endif

lint:
ifeq ($(PYTHON), true)
	@ $(MAKE) $(PY_MAKE) lint --no-print-directory
endif
ifeq ($(NODE), true)
	@ $(MAKE) $(NODE_MAKE) lint --no-print-directory
endif

format:
ifeq ($(PYTHON), true)
	@ $(MAKE) $(PY_MAKE) format --no-print-directory
endif
ifeq ($(NODE), true)
	@ $(MAKE) $(NODE_MAKE) format --no-print-directory
endif

check:
ifeq ($(PYTHON), true)
	@ $(MAKE) $(PY_MAKE) check --no-print-directory
endif
ifeq ($(NODE), true)
	@ $(MAKE) $(NODE_MAKE) check --no-print-directory
endif
