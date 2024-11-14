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
	@ ruff check src --preview

format:
	@ ruff format src --preview
	@ ruff check src --fix --preview

check:
	@ ruff format src --preview
	@ ruff check src --preview
