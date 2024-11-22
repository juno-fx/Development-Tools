.PHONY: env install lint format check

# shell
SHELL := /bin/bash

# Development targets
env:
	@ echo " >> Devbox Handles Node << "

install:
	@ echo " >> Running Node Install... << "
	@ yarn install --dev

lint:
	@ yarn run prettier -c src

format:
	@ yarn run prettier --write src

check:
	@ yarn run prettier src
