.PHONY: install lint format check

# shell
SHELL := /bin/bash

# python env handler
VENV_NAME := venv
VENV := $(VENV_NAME)/bin
UV := $(VENV)/uv pip install -p $(VENV)/python

# Development targets
env: $(VENV)/uv

$(VENV)/uv:
	@ echo " >> Setting up Python << "
	@ .devbox/nix/profile/default/bin/python -m $(VENV_NAME) $(VENV_NAME) > /dev/null
	@ $(VENV)/pip install uv > /dev/null

install:
	@ echo " >> Running Python Install... << "
	@ if [ -f requirements.lock ]; then \
	    echo "Installing from requirements.lock..."; \
	    $(UV) -r requirements.lock; \
    else \
      echo "requirements.lock not found, installing from requirements.txt..."; \
      $(UV) -r requirements.txt; \
    fi;
	@ if [ -f dev-requirements.lock ]; then \
	    echo "Installing from dev-requirements.lock..."; \
	    $(UV) -r dev-requirements.lock; \
    else \
      echo "dev-requirements.lock not found, installing from dev-requirements.txt..."; \
      $(UV) -r dev-requirements.txt; \
    fi

lint:
	@ $(VENV)/ruff check src --fix --preview

format:
	@  [ -d tests ] && $(VENV)/ruff format src tests || $(VENV)/ruff format src

check:
	@ echo " >> Running Format Check... << "
	@ $(VENV)/ruff format src --preview --check
	@ echo
	@ echo " >> Running Lint Check... << "
	@ $(VENV)/ruff check src --preview
