.PHONY: install lint format check

# shell
SHELL := /bin/bash

# python env handler
VENV_NAME := venv
VENV := $(VENV_NAME)/bin
UV := $(VENV)/uv pip install -p $(VENV)/python

# Development targets
env: venv/bin/activate

venv/bin/activate:
	@ echo " >> Setting up Python << "
	@ python -m $(VENV_NAME) $(VENV_NAME) > /dev/null
	@ $(VENV)/pip install uv > /dev/null

install:
	@ echo " >> Running Python Install... << "
	@ $(UV) -r requirements.txt
	@ $(UV) -r dev-requirements.txt

lint:
	@ ruff check src --fix --preview

format:
	@ ruff format src --preview

check:
	@ echo " >> Running Format Check... << "
	@ ruff format src --preview --check
	@ echo
	@ echo " >> Running Lint Check... << "
	@ ruff check src --preview
