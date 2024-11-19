.PHONY: env install lint format check

# python env handler
VENV := venv/bin
UV := $(VENV)/uv pip install -p $(VENV)/python

# Development targets
env:
	@ echo " >> Setting up Python << "
	@ python -m venv venv > /dev/null
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
